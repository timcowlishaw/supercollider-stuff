TimGranular {
	var server;
	var length;
	var buffer;
	var synth;
	var punchedIn;

	*new { |server, length=10|
		^super.newCopyArgs(server, length).init
	}

	*define {
		SynthDef(\timGranular, {
			arg bufnum, mix=0.5, punchedIn=0, density=1.0, attack=0, release=0.1;
			var inputSig, existingSig, outSig, recHead, impulses, windows, playHead;
			recHead = Phasor.ar(0, BufRateScale.kr(bufnum), 0, BufFrames.kr(bufnum));
			existingSig = BufRd.ar(1, bufnum, recHead);
			inputSig = SoundIn.ar(0);
			BufWr.ar(
				Select.ar(punchedIn, [
					existingSig,
					XFade2.ar(inputSig, existingSig, mix, 1.0)
				])
			, bufnum, recHead);
			impulses = Dust.kr(density);
			windows = EnvGen.ar(Env.perc(attack, release, curve: 0), impulses);
			playHead = Phasor.ar(
				impulses,
				BufRateScale.kr(bufnum),
				0, BufFrames.kr(bufnum),
				WhiteNoise.kr(BufFrames.kr(bufnum))
			);
			outSig = BufRd.ar(1, bufnum, playHead);
			Out.ar(0, outSig * windows);
		}).add;
	}

	init {
		buffer = Buffer.alloc(server, length * server.sampleRate, 1);
		synth = Synth.new(\timGranular, [\bufnum, buffer.bufnum]);
		punchedIn = false;
	}

	punch {
		punchedIn = punchedIn.not;
		synth.set(\punchedIn, if(punchedIn, 1, 0));
		^punchedIn
	}

	mix { |level|
		synth.set(\mix, level);
	}

	density { |level|
		synth.set(\density, level);
	}

	attack { |level|
		synth.set(\attack, level);
	}

	release { |level|
		synth.set(\release, level);
	}
}