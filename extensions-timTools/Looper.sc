TimLooper {
	var server;
	var length;
	var buffer;
	var synth;
	var punchedIn;

	*new { |server, length=10|
		^super.newCopyArgs(server, length).init
	}

	*define {
		SynthDef(\timLooper, {
			arg bufnum, mix=0.5, punchedIn=0, level=1;
			var inputSig, existingSig, recHead;
			recHead = Phasor.ar(0, BufRateScale.kr(bufnum), 0, BufFrames.kr(bufnum));
			existingSig = BufRd.ar(1, bufnum, recHead);
			inputSig = SoundIn.ar(0);
			BufWr.ar(
				Select.ar(punchedIn, [
					existingSig,
					XFade2.ar(inputSig, existingSig, mix, 1.0)
				])
			, bufnum, recHead);
			Out.ar(0, existingSig * level);
		}).add;
	}

	init {
		buffer = Buffer.alloc(server, length * server.sampleRate, 1);
		synth = Synth.new(\timLooper, [\bufnum, buffer.bufnum]);
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

	level { |level|
		synth.set(\level, level);
	}
}