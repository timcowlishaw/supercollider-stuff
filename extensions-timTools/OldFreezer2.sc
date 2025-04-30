OldFreezer2 {
	var server, proxySpace, environment, fftSize, hop, win, recFadeTime, grainBufLength, defaultFadeTime, channelNames;

	*new { |server, proxySpace, environment, fftSize=8192, hop=0.5, win=1, recFadeTime=0.5, grainBufLength=30, defaultFadeTime=0.5|
		^super.newCopyArgs(server, proxySpace, environment, fftSize, hop, win, recFadeTime, grainBufLength, defaultFadeTime, List.new());
	}

	key { |ns, param|
		^(ns++"_"++param).asSymbol
	}

	listen { |name, duration, startRecording=1|
		var recMix = this.key(name, \record_mix);
		var recording = this.key(name, \recording);
		var buffer = this.key(name, \buffer);
		var fftBuf = this.key(name, \fft_buffer);
		var recorder = this.key(name, \recorder);
		var analyser = this.key(name, \analyser);
		var spec_playback = this.key(name, \spec_playback);
		var clean_playback = this.key(name, \clean_playback);
		var rate = this.key(name, \rate);
		var spec_mix = this.key(name, \spec_mix);
    var fundamental = this.key(name, \fundamental);
    var low_harmonic = this.key(name, \low_harmonic);
    var high_harmonic = this.key(name, \high_harmonic);


		channelNames.add(name);

		proxySpace[recMix]  = { 0.5 };
		proxySpace[recording].ar(1);
		proxySpace[recording] = 0; // Set this again after starting for a soft fade. Caution - you need it to be audio rate
		proxySpace[recording].fadeTime = recFadeTime;
		proxySpace[rate] = { 1.0 }; // this shouldn't fade
		proxySpace[spec_mix] = { 1.0 };
		proxySpace[spec_mix].fadeTime = defaultFadeTime;
    proxySpace[fundamental] = { Note("C3").freq };
    proxySpace[fundamental].fadeTime = defaultFadeTime;
    proxySpace[low_harmonic] = { 1.0 };
    proxySpace[low_harmonic].fadeTime = defaultFadeTime;
    proxySpace[high_harmonic] = { 5.0 };
    proxySpace[high_harmonic].fadeTime = defaultFadeTime;

		environment[buffer] = Buffer.alloc(server, duration * server.sampleRate, 1);
		environment[fftBuf] = Buffer.alloc(
			server,
			duration.calcPVRecSize(fftSize, hop, server.sampleRate),
			1
		);

		proxySpace[recorder] = {
			var inputSig, existingSig, recHead;
			var bufnum = environment[buffer].bufnum;
			recHead = Phasor.ar(0, BufRateScale.kr(bufnum), 0, BufFrames.kr(bufnum));
			existingSig = BufRd.ar(1, bufnum, recHead);
			inputSig = SoundIn.ar(0);
			BufWr.ar(
				XFade2.ar(
					existingSig,
					XFade2.ar(inputSig, existingSig, proxySpace[recMix], 1.0),
					LinLin.ar(proxySpace[recording], 0, 1, -1, 1),
					1.0
				)
			, bufnum, recHead);
			existingSig;
		};

		proxySpace[analyser] = {
			var localbuf, chain, sig, playHead;
			playHead = Phasor.ar(0, BufRateScale.kr(environment[buffer]), 0, BufFrames.kr(environment[buffer]));
			sig = BufRd.ar(1, environment[buffer], playHead);
			localbuf = LocalBuf.new(fftSize);
			chain = FFT(localbuf, sig, hop, win);
			PV_RecordBuf(chain, environment[fftBuf], run: 1, hop: hop, wintype: win, loop: 1);
		};



		/*  this is a hack, but the PVPlaybuf gets angry if you make it read from a buffer before the
		full FFT has been witten. Forking and waiting here allows this to happen, and JITLib means
		we eventually get the right thing returned anyway. We do however need to set it to something of the
		correct type beforehand so it doesn't get coerced into being control rate. */
		proxySpace[name] = { Silent.ar(1) };
		fork {
			1.wait;
			//Now smoothly but quickly fade in
			proxySpace[recording] = startRecording;

			proxySpace[spec_playback] = {
				var sig, chain, localbuf, shiftSig, specWipeLowerBin, specWipeUpperBin;
				localbuf = LocalBuf.new(fftSize);
        specWipeLowerBin = ((fftSize / server.sampleRate) * proxySpace[fundamental] * proxySpace[low_harmonic]).floor;
        specWipeUpperBin = ((fftSize / server.sampleRate) * proxySpace[fundamental] * proxySpace[high_harmonic]).ceil;
				chain = PV_PlayBuf(localbuf, environment[fftBuf], proxySpace[rate], loop: 1);
        chain = PV_BinRange(chain, specWipeLowerBin, specWipeUpperBin);
        chain = PV_RectComb(chain, proxySpace[high_harmonic] - proxySpace[low_harmonic]);
				IFFT.ar(chain, win);
			};

			proxySpace[name] = {
				XFade2.ar(proxySpace[recorder], proxySpace[spec_playback], proxySpace[spec_mix], 1.0);
			};
		};
		^proxySpace[name];
	}
}
