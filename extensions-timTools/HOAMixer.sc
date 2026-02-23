HOAMixer {
	var server, proxySpace, environment, channelNames, maxLevel, defaultLevel, defaultFadeTime, order;
	/*
	  Decoder is passed in for flexibility depending on performance environment,
	  it also needs to be initialized before passing as it does some kinda asynchronous
	  load of data behind the scenes and fails in weird ways if you don't allow that to
	  finish before using it
	*/
	*new { | server, proxySpace, environment, maxLevel=3.0, defaultLevel=0.7, defaultFadeTime=0.5, order=1|
		^super.newCopyArgs(server, proxySpace, environment, List.new(), maxLevel, defaultLevel, defaultFadeTime, order).init();
    }

	init {
		proxySpace[\hoa_mixer_master_fader] = { 1.0 };
		proxySpace[\hoa_mixer_master_fader].fadeTime = defaultFadeTime;


		/* We  add this to force the mixer  to have (order+1)² channels before we've added any sources */
		proxySpace[\hoa_mixer_null_channel] = { Silent.ar((order+1)**2) };

		this.resetMixBus();

		/* As above, force the output to have (order+1)² channels: */
		proxySpace[\hoa_mixer_output] = { Silent.ar((order+1)**2) };
		proxySpace[\hoa_mixer_output] = { proxySpace[\hoa_mixer_bus] };

	}

	key { |ns, param|
		^(ns++"_"++param).asSymbol
	}

	bus {
		^proxySpace[\hoa_mixer_bus]
	}

	output {
		^proxySpace[\hoa_mixer_output]
	}

	add { |sig, level=nil, angle=0, azim=0, elevation=0, rotate=0, tilt=0, tumble=0|
		var name = sig.key;
		//parameters
		var levelKey = this.key(name, \level);
		var rotateKey = this.key(name, \rotate);
		var tiltKey = this.key(name, \tilt);
		var tumbleKey = this.key(name, \tumble);
		var angleKey = this.key(name, \angle);
		var azimKey = this.key(name, \azim);
		var elevationKey = this.key(name, \elevation);
		//stages
		var insertKey = this.key(name, \insert);
		var levelledKey = this.key(name, \levelled);
		var encodedKey = this.key(name, \encoded);
		var transformedKey = this.key(name, \transformed);

		channelNames.add(name);

		if(level != nil)  {
			proxySpace[levelKey] = { level };
		} {
			proxySpace[levelKey] = { defaultLevel };
		};
    proxySpace[levelKey].fadeTime = defaultFadeTime;

		proxySpace[angleKey] = { angle };
    proxySpace[angleKey].fadeTime = defaultFadeTime;

    proxySpace[azimKey] = { azim };
    proxySpace[azimKey].fadeTime = defaultFadeTime;

    proxySpace[elevationKey] = { elevation };
    proxySpace[elevationKey].fadeTime = defaultFadeTime;

    proxySpace[rotateKey] = { rotate };
    proxySpace[rotateKey].fadeTime = defaultFadeTime;

    proxySpace[tiltKey] = { tilt };
    proxySpace[tiltKey].fadeTime = defaultFadeTime;

    proxySpace[tumbleKey] = { tumble };
    proxySpace[tumbleKey].fadeTime = defaultFadeTime;

		proxySpace[insertKey] = { proxySpace[name] };


		proxySpace[levelledKey] = {
			var chanLevel = Clip.kr(proxySpace[levelKey], 0, maxLevel);
			var masterLevel = Clip.kr(proxySpace[\hoa_mixer_master_fader], 0, maxLevel);
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
			HoaEncodeDirection.ar(proxySpace[levelledKey].ar, radius: AtkHoa.refRadius, order: order)
		};
		proxySpace[transformedKey] = {
      HoaRTT.ar(
        HoaFocus.ar(proxySpace[encodedKey].ar,
          proxySpace[angleKey].kr,
          proxySpace[azimKey].kr,
          proxySpace[elevationKey].kr,
          radius: AtkHoa.refRadius,
          order: order
        ),
        proxySpace[rotateKey],
        proxySpace[tiltKey],
        proxySpace[tumbleKey],
        order: order)
		};

		this.resetMixBus();
	}

	printLevels {
		^channelNames.inject("\n") { |str, chan| str++proxySpace[this.key(chan, \level)].asCode++"\n" }
	}

	resetMixBus {
		var channelCount = channelNames.size;
		proxySpace[\hoa_mixer_bus] = {
			Mix.ar(
				channelNames.collect { |chan, index|
					proxySpace[(chan++"_"++\normalised).asSymbol] = {
						proxySpace[(chan++"_"++\transformed).asSymbol] // * (1.0/channelCount)
					};
					proxySpace[(chan++"_"++\normalised).asSymbol];
				} ++ [proxySpace[\hoa_mixer_null_channel]]
			)
		};
	}
}
