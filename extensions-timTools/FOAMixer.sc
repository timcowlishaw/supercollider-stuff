FOAMixer {
	var server, proxySpace, environment, channelNames, maxLevel, defaultLevel, defaultFb;
	/*
	  Decoder is passed in for flexibility depending on performance environment,
	  it also needs to be initialized before passing as it does some kinda asynchronous
	  load of data behind the scenes and fails in weird ways if you don't allow that to
	  finish before using it
	*/
	*new { | server, proxySpace, environment, maxLevel=3.0, defaultLevel=0.7, defaultFb=0.7|
		^super.newCopyArgs(server, proxySpace, environment, List.new(), maxLevel, defaultLevel, defaultFb).init();
    }

	init {
		proxySpace[\foa_mixer_master_fader] = { 1.0 };
		proxySpace[\foa_mixer_master_feedback] = { 1.0 };

		environment[\foa_mixer_encoder] = FoaEncoderMatrix.newOmni;

		/* We  add this to force the mixer  to have 4 channels before we've added any sources */
		proxySpace[\foa_mixer_null_channel] = { Silent.ar(4) };
		proxySpace[\foa_mixer_feedback_send] = { Silent.ar(1) };

		this.resetMixBus();

		/* As above, force the output to have 5 channels (4 for FOA ambisonics plus one for feedback): */
		proxySpace[\foa_mixer_output] = { Silent.ar(5) };
		proxySpace[\foa_mixer_output] = { [proxySpace[\foa_mixer_bus], proxySpace[\foa_mixer_feedback_send]] };
		//proxySpace[\foa_mixer_output].add(proxySpace[\foa_mixer_feedback_send], 4);

	}

	key { |ns, param|
		^(ns++"_"++param).asSymbol
	}

	bus {
		^proxySpace[\foa_mixer_bus]
	}

	feedbackSend {
		^proxySpace[\foa_mixer_feedback_send]
	}

	output {
		^proxySpace[\foa_mixer_output]
	}

	add { |sig, level=nil, fb=nil, angle=0, azim=0|
		var name = sig.key;
		//parameters
		var levelKey = this.key(name, \level);
		var fbKey = this.key(name, \fb);
		var azimKey = this.key(name, \azim);
		var angleKey = this.key(name, \angle);
		//stages
		var insertKey = this.key(name, \insert);
		var levelledKey = this.key(name, \levelled);
		var encodedKey = this.key(name, \encoded);
		var transformedKey = this.key(name, \transformed);
		var feedbackSendKey = this.key(name, \feedback_send);

		fbKey.postln;
		feedbackSendKey.postln;

		channelNames.add(name);

		if(level != nil)  {
			proxySpace[levelKey] = { level };
		} {
			proxySpace[levelKey] = { defaultLevel };
		};

		if(fb != nil)  {
			proxySpace[fbKey] = { fb };
		} {
			proxySpace[fbKey] = { defaultFb };
		};

		proxySpace[angleKey] = { angle };
		proxySpace[azimKey] = { azim };

		proxySpace[insertKey] = { proxySpace[name] };

		proxySpace[feedbackSendKey] = {
			var chanFb = Clip.kr(proxySpace[fbKey], 0, maxLevel);
			var masterFb = Clip.kr(proxySpace[\foa_mixer_master_feedback], 0, maxLevel);
			proxySpace[insertKey] * chanFb * masterFb;
		};

		proxySpace[levelledKey] = {
			var chanLevel = Clip.kr(proxySpace[levelKey], 0, maxLevel);
			var masterLevel = Clip.kr(proxySpace[\foa_mixer_master_fader], 0, maxLevel);
			proxySpace[insertKey] * chanLevel * masterLevel;
		};

		/*
		  When using ATK classes within JITLib, it seems to be absolutely crucial to always explicitly refer to
		  the audio-rate (.ar) or control-rate (.kr) variant of whatever nodes you're using as input source. Failing to
		  do this either mucks up the soundfield in hard to pin down ways (often, but not always, accompanied by a 'output
		  reshaped' warning in the console from JITLib, or extremely cryptic (to me) errors. First thing to check if
		  anything goes weird is if you have done this.
		*/
		proxySpace[encodedKey] = {
			FoaEncode.ar(proxySpace[levelledKey].ar, environment.foa_mixer_encoder)
		};
		proxySpace[transformedKey] = {
			FoaTransform.ar(proxySpace[encodedKey].ar, 'push', proxySpace[angleKey].kr, proxySpace[azimKey].kr)
		};

		this.resetMixBus();
	}

	printLevels {
		^channelNames.inject("\n") { |str, chan| str++proxySpace[this.key(chan, \level)].asCode++"\n" }
	}

	resetMixBus {
		var channelCount = channelNames.size;
		proxySpace[\foa_mixer_bus] = {
			Mix.ar(
				channelNames.collect { |chan, index|
					proxySpace[(chan++"_"++\normalised).asSymbol] = {
						proxySpace[(chan++"_"++\transformed).asSymbol] // * (1.0/channelCount)
					};
					proxySpace[(chan++"_"++\normalised).asSymbol];
				} ++ [proxySpace[\foa_mixer_null_channel]]
			)
		};

		proxySpace[\foa_mixer_feedback_send] = {
			Mix.ar(
				channelNames.collect { |chan, index|
					(chan++"_"++\feedback_send).asSymbol.postln;
					proxySpace[(chan++"_"++\fb_normalised).asSymbol] = {
						proxySpace[(chan++"_"++\feedback_send).asSymbol] // * (1.0/channelCount)
					};
					proxySpace[(chan++"_"++\fb_normalised).asSymbol];
				}
			)
		};
	}
}