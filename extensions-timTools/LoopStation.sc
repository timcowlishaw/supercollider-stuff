LoopStation {
	var server, proxySpace, environment, fftSize, hop, win, recFadeTime, grainBufLength, defaultFadeTime, channelNames;

	*new { |server, proxySpace, environment, fftSize=8192, hop=0.5, win=1, recFadeTime=0.5, grainBufLength=30, defaultFadeTime=0.5|
		^super.newCopyArgs(server, proxySpace, environment, fftSize, hop, win, recFadeTime, grainBufLength, defaultFadeTime, List.new());
	}

	key { |ns, param|
		^(ns++"_"++param).asSymbol
	}

	printRecording {
		^channelNames.inject("\n") { |str, chan| str++proxySpace[this.key(chan, \recording)].asCode++"\n" }
	}

	stopAllRecording {
		channelNames.collect { |chan|
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
		var grain_trigs = this.key(name, \grain_trigs);
		var grain_pos_randomness = this.key(name, \grain_pos_randomness);
		var grain_duration = this.key(name, \grain_duration);
		var grain_rate = this.key(name, \grain_rate);
		var grain_buffer = this.key(name, \grain_buffer);
		var grain_recorder = this.key(name, \grain_buffer);
    var spec_wipe_lower = this.key(name, \spec_wipe_lower);
    var spec_wipe_upper = this.key(name, \spec_wipe_upper);
    var grain_slope = this.key(name, \grain_slope);
    var grain_angle = this.key(name, \grain_angle);
    var grain_curve = this.key(name, \grain_curve);
    var grain_envelope_buffer = this.key(name, \grain_envelope_buffer);
    var grainUpdateCallback;
    var startPos = this.key(name, \start_pos);
    var endPos = this.key(name, \end_pos);

		channelNames.add(name);

		proxySpace[rate] = { 1.0 }; // this should't fade
		proxySpace[pitch] = { 1.0 };
    proxySpace[pitch].fadeTime = defaultFadeTime;
		proxySpace[spec_mix] = { -1.0 };
    proxySpace[spec_mix].fadeTime = defaultFadeTime;
		proxySpace[grain_mix] = { -1.0 };
    proxySpace[grain_mix].fadeTime = defaultFadeTime;
		proxySpace[grain_density] = { 0 };
    proxySpace[grain_density].fadeTime = defaultFadeTime;
		proxySpace[grain_duration] = { 0.1 };
    proxySpace[grain_duration].fadeTime = defaultFadeTime;
		proxySpace[grain_pos_randomness] = { -1 };
    proxySpace[grain_pos_randomness].fadeTime = defaultFadeTime;
		proxySpace[grain_rate] = { 1.0 };
    proxySpace[grain_rate].fadeTime = defaultFadeTime;
    proxySpace[spec_wipe_lower] = { 0.0 };
    proxySpace[spec_wipe_lower].fadeTime = defaultFadeTime;
    proxySpace[spec_wipe_upper] = { server.sampleRate / 2 };
    proxySpace[spec_wipe_upper].fadeTime = defaultFadeTime;

    proxySpace[grain_slope] = 0.5;
    proxySpace[grain_angle] = 0;
    proxySpace[grain_curve] = 0.0;

    proxySpace[startPos] = { 0.0 };
    proxySpace[endPos] = { 1.0 };

    environment[buffer] = Buffer.read(server, filename);
		environment[grain_buffer] = Buffer.alloc(server, grainBufLength * server.sampleRate, 1);

    environment[grain_envelope_buffer] = Buffer.alloc(server, server.sampleRate, 1);

    grainUpdateCallback =  {
      fork {
        var slope, angle, curve, env, normAngle, stage1, stage2, stage3;
        1.wait;
        slope = proxySpace[grain_slope].bus.getSynchronous;
        angle = proxySpace[grain_angle].bus.getSynchronous;
        curve = proxySpace[grain_curve].bus.getSynchronous;
        normAngle = (1 + angle) / 2;
        stage1 = slope * normAngle;
        stage2 = 1 - slope;
        stage3 = slope * (1 - normAngle);
        env = Env(levels: [0, 1, 1, 0], times: [stage1, stage2, stage3], curve: [curve, 0, 0-curve]);
        environment[grain_envelope_buffer].loadCollection(env.discretize);
      }
    };

    grainUpdateCallback.();
    proxySpace[grain_slope].addDependant(grainUpdateCallback);
    proxySpace[grain_angle].addDependant(grainUpdateCallback);
    proxySpace[grain_curve].addDependant(grainUpdateCallback);

		proxySpace[clean_playback] = {
			var playHead;
			playHead = Phasor.ar(0,
        rate: BufRateScale.kr(environment[buffer]),
        start: proxySpace[startPos] * BufFrames.kr(environment[buffer]),
        end: proxySpace[endPos] * BufFrames.kr(environment[buffer])
      );
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
        playHead = Phasor.ar(0,
          rate: BufRateScale.kr(environment[buffer]),
          start: proxySpace[startPos] * BufFrames.kr(environment[buffer]),
          end: proxySpace[endPos] * BufFrames.kr(environment[buffer])
        );
				sig = BufRd.ar(1, environment[buffer], playHead);

				localbuf = LocalBuf.new(fftSize);
				chain = FFT(localbuf, sig, hop, win);
				PV_RecordBuf(chain, environment[fftBuf], run: 1, hop: hop, wintype: win, loop: 1);
			};

			1.wait;

			proxySpace[spec_playback] = {
				var sig, chain, localbuf, shiftSig, specWipeLowerBin, specWipeUpperBin;
				localbuf = LocalBuf.new(fftSize);

        specWipeLowerBin = ((fftSize / server.sampleRate) * proxySpace[spec_wipe_lower]).floor;
        specWipeUpperBin = ((fftSize / server.sampleRate) * proxySpace[spec_wipe_upper]).ceil;
				chain = PV_PlayBuf(localbuf, environment[fftBuf], proxySpace[rate], loop: 1);
        chain = PV_BinRange(chain, specWipeLowerBin, specWipeUpperBin);
				IFFT.ar(chain, win);
			};

			proxySpace[smooth_signal] = {
				XFade2.ar(proxySpace[clean_playback], proxySpace[spec_playback], proxySpace[spec_mix], 1.0);
			};

			proxySpace[grain_recorder] = {
				var inputSig, recHead, bufnum;
				bufnum = environment[grain_buffer].bufnum;
				recHead = Phasor.ar(0, BufRateScale.kr(bufnum), 0, BufFrames.kr(bufnum));
				inputSig = proxySpace[smooth_signal].ar;
				BufWr.ar(inputSig, bufnum, recHead);
			};

			proxySpace[grain_trigs] = {
				Dust.ar(proxySpace[grain_density])
			};

			proxySpace[grain_playback] = {
				var impulses, bufnum;
				impulses = proxySpace[grain_trigs];
				bufnum = environment[grain_buffer].bufnum;
				GrainBuf.ar(
          numChannels: 1,
          trigger: impulses,
          dur: proxySpace[grain_duration],
          sndbuf: environment[grain_buffer],
          rate: proxySpace[grain_rate],
					pos: XFade2.ar(
						Phasor.ar(0, BufRateScale.kr(bufnum) / BufFrames.kr(bufnum), 0, 1),
						LinLin.ar(WhiteNoise.ar, -1, 1, 0, 1),
						proxySpace[grain_pos_randomness]
					),
          envbufnum: environment[grain_envelope_buffer].bufnum
				);
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
		var grain_trigs = this.key(name, \grain_trigs);
		var grain_pos_randomness = this.key(name, \grain_pos_randomness);
		var grain_duration = this.key(name, \grain_duration);
		var grain_rate = this.key(name, \grain_rate);
		var grain_buffer = this.key(name, \grain_buffer);
		var grain_recorder = this.key(name, \grain_buffer);
    var spec_wipe_lower = this.key(name, \spec_wipe_lower);
    var spec_wipe_upper = this.key(name, \spec_wipe_upper);
    var grain_slope = this.key(name, \grain_slope);
    var grain_angle = this.key(name, \grain_angle);
    var grain_curve = this.key(name, \grain_curve);
    var grain_envelope_buffer = this.key(name, \grain_envelope_buffer);
    var grainUpdateCallback;
    var startPos = this.key(name, \start_pos);
    var endPos = this.key(name, \end_pos);



		channelNames.add(name);

		proxySpace[recMix]  = { 0.5 };
		proxySpace[recording].ar(1);
		proxySpace[recording] = 0; // Set this again after starting for a soft fade. Caution - you need it to be audio rate
		proxySpace[recording].fadeTime = recFadeTime;
		proxySpace[rate] = { 1.0 }; // this shouldn't fade
		proxySpace[pitch] = { 1.0 };
		proxySpace[pitch].fadeTime = defaultFadeTime;
		proxySpace[spec_mix] = { -1.0 };
		proxySpace[spec_mix].fadeTime = defaultFadeTime;
		proxySpace[grain_mix] = { -1.0 };
		proxySpace[grain_mix].fadeTime = defaultFadeTime;
		proxySpace[grain_density] = { 0 };
		proxySpace[grain_density].fadeTime = defaultFadeTime;
		proxySpace[grain_duration] = { 0.1 };
		proxySpace[grain_duration].fadeTime = defaultFadeTime;
		proxySpace[grain_pos_randomness] = { -1 };
		proxySpace[grain_pos_randomness].fadeTime = defaultFadeTime;
		proxySpace[grain_rate] = { 1.0 };
		proxySpace[grain_rate].fadeTime = defaultFadeTime;
    proxySpace[spec_wipe_lower] = { 0.0 };
    proxySpace[spec_wipe_lower].fadeTime = defaultFadeTime;
    proxySpace[spec_wipe_upper] = { server.sampleRate / 2 };
    proxySpace[spec_wipe_upper].fadeTime = defaultFadeTime;

    proxySpace[grain_slope] = 0.5;
    proxySpace[grain_angle] = 0;
    proxySpace[grain_curve] = 0.0;

    proxySpace[startPos] = { 0.0 };
    proxySpace[endPos] = { 1.0 };

    environment[grain_envelope_buffer] = Buffer.alloc(server, server.sampleRate, 1);

    grainUpdateCallback =  {
      fork {
        var slope, angle, curve, env, normAngle, stage1, stage2, stage3;
        1.wait;
        slope = proxySpace[grain_slope].bus.getSynchronous;
        angle = proxySpace[grain_angle].bus.getSynchronous;
        curve = proxySpace[grain_curve].bus.getSynchronous;
        normAngle = (1 + angle) / 2;
        stage1 = slope * normAngle;
        stage2 = 1 - slope;
        stage3 = slope * (1 - normAngle);
        env = Env(levels: [0, 1, 1, 0], times: [stage1, stage2, stage3], curve: [curve, 0, 0-curve]);
        environment[grain_envelope_buffer].loadCollection(env.discretize);
      }
    };

    grainUpdateCallback.();
    proxySpace[grain_slope].addDependant(grainUpdateCallback);
    proxySpace[grain_angle].addDependant(grainUpdateCallback);
    proxySpace[grain_curve].addDependant(grainUpdateCallback);

		environment[buffer] = Buffer.alloc(server, duration * server.sampleRate, 1);
		environment[fftBuf] = Buffer.alloc(
			server,
			duration.calcPVRecSize(fftSize, hop, server.sampleRate),
			1
		);

    environment[grain_buffer] = Buffer.alloc(server, grainBufLength * server.sampleRate, 1);


		proxySpace[recorder] = {
			var inputSig, existingSig, recHead;
			var bufnum = environment[buffer].bufnum;
			recHead = Phasor.ar(0,
        rate: BufRateScale.kr(bufnum),
        start: proxySpace[startPos] * BufFrames.kr(bufnum),
        end: proxySpace[endPos] * BufFrames.kr(bufnum)
      );
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
			playHead = Phasor.ar(0,
        rate: BufRateScale.kr(environment[buffer]),
        start: proxySpace[startPos] * BufFrames.kr(environment[buffer]),
        end: proxySpace[endPos] * BufFrames.kr(environment[buffer])
      );
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
        specWipeLowerBin = ((fftSize / server.sampleRate) * proxySpace[spec_wipe_lower]).floor;
        specWipeUpperBin = ((fftSize / server.sampleRate) * proxySpace[spec_wipe_upper]).ceil;
				chain = PV_PlayBuf(localbuf, environment[fftBuf], proxySpace[rate], loop: 1);
        chain = PV_BinRange(chain, specWipeLowerBin, specWipeUpperBin);
				IFFT.ar(chain, win);
			};

			proxySpace[smooth_signal] = {
				XFade2.ar(proxySpace[recorder], proxySpace[spec_playback], proxySpace[spec_mix], 1.0);
			};

			proxySpace[grain_recorder] = {
				var inputSig, recHead, bufnum;
				bufnum = environment[grain_buffer].bufnum;
				recHead = Phasor.ar(0, BufRateScale.kr(bufnum), 0, BufFrames.kr(bufnum));
				inputSig = proxySpace[smooth_signal].ar;
				BufWr.ar(inputSig, bufnum, recHead);
			};

			proxySpace[grain_trigs] = {
				Dust.ar(proxySpace[grain_density])
			};

			proxySpace[grain_playback] = {
				var impulses, bufnum;
				impulses = proxySpace[grain_trigs];
				bufnum = environment[grain_buffer].bufnum;
				GrainBuf.ar(
          numChannels: 1,
          trigger: impulses,
          dur: proxySpace[grain_duration],
          sndbuf: environment[grain_buffer],
          rate: proxySpace[grain_rate],
					pos: XFade2.ar(
						Phasor.ar(0, BufRateScale.kr(bufnum) / BufFrames.kr(bufnum), 0, 1),
						LinLin.ar(WhiteNoise.ar, -1, 1, 0, 1),
						proxySpace[grain_pos_randomness]
					),
          envbufnum: environment[grain_envelope_buffer].bufnum
				);
			};

			proxySpace[name] = {
				XFade2.ar(proxySpace[smooth_signal], proxySpace[grain_playback], proxySpace[grain_mix], 1.0);
			};
		};
		^proxySpace[name];
	}
}
