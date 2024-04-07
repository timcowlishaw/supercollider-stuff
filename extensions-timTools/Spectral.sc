TimSpectralLooper {
	var server;
	var length;
	var fftsize;
	var hop;
	var win;
	var buffer;
	var fftBuf;
	var recSynth;
	var analyseSynth;
	var playSynth;
	var punchedIn;

	*new { |server, length=10, fftsize=2048, hop=0.25, win=0|
		^super.newCopyArgs(server, length, fftsize, hop, win).init
	}

	*define {
		SynthDef(\timSpectralLooperRec, {
			arg buffer, mix=0.5, punchedIn=0;
			var inputSig, existingSig, recHead;
			recHead = Phasor.ar(0, BufRateScale.kr(buffer), 0, BufFrames.kr(buffer));
			existingSig = BufRd.ar(1, buffer, recHead);
			inputSig = SoundIn.ar(0);
			BufWr.ar(
				Select.ar(punchedIn, [
					existingSig,
					XFade2.ar(inputSig, existingSig, mix, 1.0)
				])
			, buffer, recHead);
		}).add;
		SynthDef(\timSpectralLooperAnalyse, {
			arg buffer, fftBuf, fftsize=2048, hop=0.25, win=0;
			var localbuf, chain, sig, playHead;
			playHead = Phasor.ar(0, BufRateScale.kr(buffer), 0, BufFrames.kr(buffer));
			sig = BufRd.ar(1, buffer, playHead);
			localbuf = LocalBuf.new(fftsize);
			chain = FFT(localbuf, sig, hop, win);
			chain = PV_RecordBuf(chain, fftBuf, run: 1, hop: hop, wintype: win, loop: 1);
		}).add;
		SynthDef(\timSpectralLooperPlay, {
			arg fftBuf, fftsize=2048, win=0, rate=1.0, pitch=1.0;
			var sig, chain, localbuf, shiftSig;
			localbuf = LocalBuf.new(fftsize);
			chain = PV_PlayBuf(localbuf, fftBuf, rate, loop: 1);
			sig = IFFT(chain, win);
			/* shiftSig = PitchShift(sig, pitchRatio: pitch); */
			Out.ar(0, sig);
		}).add;
	}

	init {
		punchedIn = false;
		buffer = Buffer.alloc(server, length * server.sampleRate, 1);

		fftBuf = Buffer.alloc(server, buffer.duration.calcPVRecSize(fftsize, hop, server.sampleRate), 1);
		recSynth = Synth.new(\timSpectralLooperRec, [\buffer, buffer]);
	}

	analyse {
		analyseSynth = Synth.new(\timSpectralLooperAnalyse, [\buffer, buffer,\fftBuf, fftBuf, \fftsize, fftsize, \hop, hop, \win, win]);
	}

	play {

		playSynth = Synth.new(\timSpectralLooperPlay, [\fftBuf, fftBuf, \fftsize, fftsize, \win, win]);
	}

	punch {
		punchedIn = punchedIn.not;
		recSynth.set(\punchedIn, if(punchedIn, 1, 0));
		^punchedIn
	}

	mix { |level|
		recSynth.set(\mix, level);
	}

	pitch { |pitch|
		playSynth.set(\pitch, pitch);
	}

	rate { |level|
		playSynth.set(\rate, level);
	}
}