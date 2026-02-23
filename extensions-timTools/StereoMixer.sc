StereoMixer {
	var server, proxySpace, environment, channelNames, maxLevel, defaultLevel, defaultFb, defaultFadeTime;
	/*
	  Decoder is passed in for flexibility depending on performance environment,
	  it also needs to be initialized before passing as it does some kinda asynchronous
	  load of data behind the scenes and fails in weird ways if you don't allow that to
	  finish before using it
	*/
	*new { | server, proxySpace, environment, maxLevel=3.0, defaultLevel=0.7, defaultFb=0.7, defaultFadeTime=0.5|
		^super.newCopyArgs(server, proxySpace, environment, List.new(), maxLevel, defaultLevel, defaultFb, defaultFadeTime).init();
    }

	init {
		proxySpace[\stereo_mixer_master_fader] = { 1.0 };
		proxySpace[\stereo_mixer_master_fader].fadeTime = defaultFadeTime;

		/* We  add this to force the mixer  to have 4 channels before we've added any sources */
		proxySpace[\stereo_mixer_null_channel] = { Silent.ar(2) };

		this.resetMixBus();

		/* As above, force the output to have 2 channel: */
		proxySpace[\stereo_mixer_output] = { Silent.ar(2) };
		proxySpace[\stereo_mixer_output] = { proxySpace[\stereo_mixer_bus] };

	}

	key { |ns, param|
		^(ns++"_"++param).asSymbol
	}

	bus {
		^proxySpace[\stereo_mixer_bus]
	}

	output {
		^proxySpace[\stereo_mixer_output]
	}

	add { |sig, level=nil, fb=nil, pan=0|
		var name = sig.key;
		//parameters
		var levelKey = this.key(name, \level);
		var fbKey = this.key(name, \fb);
		var panKey = this.key(name, \pan);
		//stages
		var insertKey = this.key(name, \insert);
		var levelledKey = this.key(name, \levelled);
		var pannedKey = this.key(name, \panned);

		channelNames.add(name);

		if(level != nil)  {
			proxySpace[levelKey] = { level };
		} {
			proxySpace[levelKey] = { defaultLevel };
		};
    proxySpace[levelKey].fadeTime = defaultFadeTime;

		if(fb != nil)  {
			proxySpace[fbKey] = { fb };
		} {
			proxySpace[fbKey] = { defaultFb };
		};
    proxySpace[fbKey].fadeTime = defaultFadeTime;

		proxySpace[panKey] = { pan };
    proxySpace[panKey].fadeTime = defaultFadeTime;

		proxySpace[insertKey] = { proxySpace[name] };

		proxySpace[levelledKey] = {
			var chanLevel = Clip.kr(proxySpace[levelKey], 0, maxLevel);
			var masterLevel = Clip.kr(proxySpace[\stereo_mixer_master_fader], 0, maxLevel);
			proxySpace[insertKey] * chanLevel * masterLevel;
		};

		proxySpace[pannedKey] = {
			Pan2.ar(proxySpace[levelledKey].ar,  pos: proxySpace[panKey].kr)
		};

		this.resetMixBus();
	}

	printLevels {
		^channelNames.inject("\n") { |str, chan| str++proxySpace[this.key(chan, \level)].asCode++"\n" }
	}

	resetMixBus {
		var channelCount = channelNames.size;
		proxySpace[\stereo_mixer_bus] = {
			Mix.ar(
				channelNames.collect { |chan, index|
					proxySpace[(chan++"_"++\normalised).asSymbol] = {
						proxySpace[(chan++"_"++\panned).asSymbol] // * (1.0/channelCount)
					};
					proxySpace[(chan++"_"++\normalised).asSymbol];
				} ++ [proxySpace[\stereo_mixer_null_channel]]
			)
		};
	}
}
