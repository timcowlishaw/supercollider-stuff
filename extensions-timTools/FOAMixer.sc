FOAMixer {
	var server, proxySpace, environment, channelNames;
	/*
	  Decoder is passed in for flexibility depending on performance environment,
	  it also needs to be initialized before passing as it does some kinda asynchronous
	  load of data behind the scenes and fails in weird ways if you don't allow that to
	  finish before using it
	*/
	*new { | server, proxySpace, environment, decoder|
		^super.newCopyArgs(server, proxySpace, environment, List.new()).init(decoder);
    }

	init { |decoder|
		environment[\foa_mixer_encoder] = FoaEncoderMatrix.newOmni;
		environment[\foa_mixer_decoder] = decoder;
		/* We  add this to force the mixer  to have 4 channels before we've added any sources */
		proxySpace[\foa_mixer_null_channel] = { Silent.ar(4) };
		this.resetMixBus();
		/*
		  When using ATK classes within JITLib, it seems to be absolutely crucial to always explicitly refer to
		  the audio-rate (.ar) or control-rate (.kr) variant of whatever nodes you're using as input source. Failing to
		  do this either mucks up the soundfield in hard to pin down ways (often, but not always, accompanied by a 'output
		  reshaped' warning in the console from JITLib, or extremely cryptic (to me) errors. First thing to check if
		  anything goes weird is if you have done this.
		*/
		proxySpace[\foa_mixer_decoded] = { FoaDecode.ar(proxySpace[\foa_mixer_bus].ar, environment.foa_mixer_decoder) };
	}

	key { |ns, param|
		^(ns++"_"++param).asSymbol
	}

	bus {
		^proxySpace[\foa_mixer_bus]
	}

	output {
		^proxySpace[\foa_mixer_decoded]
	}


	add { |sig, level=0.7, angle=0, azim=0|
		var name = sig.key;
		//parameters
		var levelKey = this.key(name, \level);
		var azimKey = this.key(name, \azim);
		var angleKey = this.key(name, \angle);
		//stages
		var insertKey = this.key(name, \insert);
		var levelledKey = this.key(name, \levelled);
		var encodedKey = this.key(name, \encoded);
		var transformedKey = this.key(name, \transformed);

		channelNames.add(name);

		proxySpace[levelKey] = { level };
		proxySpace[angleKey] = { angle };
		proxySpace[azimKey] = { azim };

		proxySpace[insertKey] = { proxySpace[name] };
		proxySpace[levelledKey] = { proxySpace[insertKey] * proxySpace[levelKey] };
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
			Mix(
				channelNames.collect { |chan, index|
					proxySpace[(chan++"_"++\normalised).asSymbol] = {
						proxySpace[(chan++"_"++\transformed).asSymbol] // * (1.0/channelCount)
					};
					proxySpace[(chan++"_"++\normalised).asSymbol];
				} ++ [proxySpace[\foa_mixer_null_channel]]
			)
		};
	}
}