LoopStation {
	var server, proxySpace, environment, fftSize, hop, win, recFadeTime, channelNames;

	*new { |server, proxySpace, environment, fftSize=8192, hop=0.5, win=1, recFadeTime=0.5|
		^super.newCopyArgs(server, proxySpace, environment, fftSize, hop, win, recFadeTime, List.new());
	}

	key { |ns, param|
		^(ns++"_"++param).asSymbol
	}

	printRecording {
		^channelNames.inject("\n") { |str, chan| str++proxySpace[this.key(chan, \recording)].asCode++"\n" }
	}

	stopAllRecording {
		channelNames.each { |chan|
			proxySpace[this.key(chan, \recording)] = 0;
		}
	}

	load { |name, filename|
		var buffer = this.key(name, \buffer);
		var fftBuf = this.key(name, \fft_buffer);
		var recorder = this.key(name, \recorder);
		var analyser = this.key(name, \analyser);
		var spec_playback = this.key(name, \spec_playback);
		var clean_playback = this.key(name, \clean_playback);
		var smooth_signal = this.key(name, \smooth_signal);
		var grain_playback = this.key(name, \grain_playback);
		var rate = this.key(name, \rate);
		var pitch = this.key(name, \pitch);
		var spec_mix = this.key(name, \spec_mix);
		var grain_mix = this.key(name, \grain_mix);
		var grain_density = this.key(name, \grain_density);
		var grain_attack = this.key(name, \grain_attack);
		var grain_release = this.key(name, \grain_release);
		var grain_curve = this.key(name, \grain_curve);

		channelNames.add(name);

		proxySpace[rate] = { 1.0 };
		proxySpace[pitch] = { 1.0 };
		proxySpace[spec_mix] = { -1.0 };
		proxySpace[grain_mix] = { -1.0 };
		proxySpace[grain_density] = { 0 };
		proxySpace[grain_attack] = { 0.01 };
		proxySpace[grain_release] = { 0.25 };
		proxySpace[grain_curve] = { 0 };

		environment[buffer] = Buffer.read(server, filename);

		proxySpace[clean_playback] = {
			var playHead;
			playHead = Phasor.ar(0, BufRateScale.kr(environment[buffer]), 0, BufFrames.kr(environment[buffer]));
			BufRd.ar(1, environment[buffer], playHead);
		};

		/*  this is a hack, but the PVPlaybuf gets angry if you make it read from a buffer before the
		full FFT has been witten. Forking and waiting here allows this to happen, and JITLib means
		we eventually get the right thing returned anyway. We do however need to set it to something of the
		correct type beforehand so it doesn't get coerced into being control rate. */
		proxySpace[name] = { Silent.ar(1) };
		fork {
			1.wait;

			environment[fftBuf] = Buffer.alloc(
				server,
				environment[buffer].duration.calcPVRecSize(fftSize, hop, server.sampleRate),
				1
			);

			proxySpace[analyser] = {
				var localbuf, chain, sig, playHead;
				playHead = Phasor.ar(0, BufRateScale.kr(environment[buffer]), 0, BufFrames.kr(environment[buffer]));
				sig = BufRd.ar(1, environment[buffer], playHead);

				localbuf = LocalBuf.new(fftSize);
				chain = FFT(localbuf, sig, hop, win);
				PV_RecordBuf(chain, environment[fftBuf], run: 1, hop: hop, wintype: win, loop: 1);
			};

			1.wait;

			proxySpace[spec_playback] = {
				var sig, chain, localbuf, shiftSig;
				localbuf = LocalBuf.new(fftSize);
				chain = PV_PlayBuf(localbuf, environment[fftBuf], proxySpace[rate], loop: 1);
				IFFT.ar(chain, win);
			};

			proxySpace[smooth_signal] = {
				XFade2.ar(proxySpace[clean_playback], proxySpace[spec_playback], proxySpace[spec_mix], 1.0);
			};

			proxySpace[grain_playback] = {
				var impulses, windows, playHead, outSig;
				impulses = Dust.kr(proxySpace[grain_density]);
				windows = EnvGen.ar(Env.perc(proxySpace[grain_attack], proxySpace[grain_release], curve: proxySpace[grain_curve]), impulses);
				playHead = Phasor.ar(
					impulses,
					BufRateScale.kr(environment[buffer]),
					0, BufFrames.kr(environment[buffer]),
					WhiteNoise.kr(BufFrames.kr(environment[buffer]))
				);
				outSig = BufRd.ar(1, environment[buffer], playHead);
				outSig * windows;
			};

			proxySpace[name] = {
				XFade2.ar(proxySpace[smooth_signal], proxySpace[grain_playback], proxySpace[grain_mix], 1.0);
			};
		};
		^proxySpace[name];
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
		var smooth_signal = this.key(name, \smooth_signal);
		var grain_playback = this.key(name, \grain_playback);
		var rate = this.key(name, \rate);
		var pitch = this.key(name, \pitch);
		var spec_mix = this.key(name, \spec_mix);
		var grain_mix = this.key(name, \grain_mix);
		var grain_density = this.key(name, \grain_density);
		var grain_attack = this.key(name, \grain_attack);
		var grain_release = this.key(name, \grain_release);
		var grain_curve = this.key(name, \grain_curve);

		channelNames.add(name);

		proxySpace[recMix]  = { 0.5 };
		proxySpace[recording].ar(1);
		proxySpace[recording] = 0; // Set this again after starting for a soft fade. Caution - you need it to be audio rate
		proxySpace[recording].fadeTime_(recFadeTime);
		proxySpace[rate] = { 1.0 };
		proxySpace[pitch] = { 1.0 };
		proxySpace[spec_mix] = { -1.0 };
		proxySpace[grain_mix] = { -1.0 };
		proxySpace[grain_density] = { 0 };
		proxySpace[grain_attack] = { 0.01 };
		proxySpace[grain_release] = { 0.25 };
		proxySpace[grain_curve] = { 0.5 };

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
				var sig, chain, localbuf, shiftSig;
				localbuf = LocalBuf.new(fftSize);
				chain = PV_PlayBuf(localbuf, environment[fftBuf], proxySpace[rate], loop: 1);
				IFFT.ar(chain, win);
			};

			proxySpace[smooth_signal] = {
				XFade2.ar(proxySpace[recorder], proxySpace[spec_playback], proxySpace[spec_mix], 1.0);
			};

			proxySpace[grain_playback] = {
				var impulses, windows, playHead, outSig;
				impulses = Dust.kr(proxySpace[grain_density]);
				windows = EnvGen.ar(Env.perc(proxySpace[grain_attack], proxySpace[grain_release], curve: proxySpace[grain_curve]), impulses);
				playHead = Phasor.ar(
					impulses,
					BufRateScale.kr(environment[buffer]),
					0, BufFrames.kr(environment[buffer]),
					WhiteNoise.kr(BufFrames.kr(environment[buffer]))
				);
				outSig = BufRd.ar(1, environment[buffer], playHead);
				outSig * windows;
			};

			proxySpace[name] = {
				XFade2.ar(proxySpace[smooth_signal], proxySpace[grain_playback], proxySpace[grain_mix], 1.0);
			};
		};
		^proxySpace[name];
	}
}
