p = ProxySpace().push(s.boot);
q = ();
l = LoopStation.new(s, p, q, fftSize:16384, hop: 0.25, win: 1, recFadeTime:0.1, defaultFadeTime: 2.0);

m = FOAMixer.new(s, p, q, maxLevel:5.0, defaultLevel: 0.7, defaultFb: 0.7, defaultFadeTime: 4.0);

~foa_mixer_master_fader = 3.0;

d = FoaDecoderMatrix.newPanto(2)
~mixer_decoded = { FoaDecode.ar(m.bus.ar, d) };

~reverb_mix = 0.0
~reverb_size = 1.0
~reverb_damp = 0.4

~out = { FreeVerb.ar(~mixer_decoded, room: ~reverb_size, damp: ~reverb_damp, mix: ~reverb_mix) }

~out.play

//   Looper controls:
//     recording, record_mix, rate, pitch, spec_mix, grain_mix, grain_density, grain_pos_randomness,
//     grain_duration, grain_rate, grain_trigs
//   Mixer controls:
//     level, fb, azim, angle, insert

m.add(l.load(\roberto_loop, "/home/tim/Downloads/wetransfer_019_1-wav_2025-01-15_1946/019_1.WAV"))
~roberto_loop_spec_mix = 0
~roberto_loop_grain_mix = 1.0
~roberto_loop_grain_duration = { LFNoise2.kr(12398).range(0.1, 1) }
~roberto_loop_grain_density = { LFNoise2.kr(12398).range(10, 0.1) }
~roberto_loop_grain_pos_randomness = { SinOsc.kr(0.24).range(0, 1) }
~roberto_loop_rate = -0.1
~roberto_loop_spec_wipe_lower = { 0 }

m.add(l.listen(\crackle, 7.5))
~crackle_recording = 0
~crackle_spec_mix = 0
~crackle_grain_mix = 1
~crackle_grain_density =1
~crackle_distort_prob = 0
~crackle_distort_prob.fadeTime = 0.0
~crackle_rate = 0.5
~crackle_drive_gain = { SinOsc.kr(LFNoise.kr(123).range(3, 10)).range(-1, -0.9) }
~crackle_bias = { Saw.kr(LFNoise.kr(4344).range(0.2, 5)).range(0.2, 0) }
~crackle_release = { SinOsc.kr(0.1).range(0.05, 0.15) }
~crackle_distort_mix = { EnvGen.kr(Env.perc(releaseTime: ~crackle_release), Dust.kr(~crackle_distort_prob)) }
~crackle_insert = { ~crackle + (AnalogVintageDistortion.ar(~crackle, drivegain: ~crackle_drive_gain, bias: ~crackle_bias) *  ~crackle_distort_mix) }


m.add(l.listen(\bass, 12.1))
~bass_recording = 0
~bass_level = 3.0
~bass_lfo_rate = { SinOsc.kr(0.1).range(2, 3) }
~bass_lfo_level = { SinOsc.kr(0.092).range(-1, -0.2) }
~bass_insert = { XFade2.ar(~bass, ~bass * SinOsc.ar(~bass_lfo_rate), ~bass_lfo_level) }

m.add(l.listen(\slopads, 23.4))
~slopads_recording = 0
~slopads_spec_mix = 0
~slopads_rate = 0.5
~slopads_insert = { LockhartWavefolder.ar(CombL.ar(AnalogDegrade.ar(~slopads, variance: 0.8, amount: 0.6), delaytime: 0.6, maxdelaytime: 1.0, decaytime: 10.0), numCells: 4.0) }

m.add(l.listen(\breathy, 13))
~breathy_recording = 0
~breathy_spec_mix = -0.5
~breathy_rate = 0.1
~breathy_insert = { FreeVerb.ar(~breathy, room: 0.8, damp: 0.2, mix: 0.7) }

~glitch_rate_lower = 0.1
~glitch_rate_upper = 50
~glitch_res_limit = -0.85
~glitch_res_limit.fadeTime = 2.0
~glitch_env = { Saw.ar(LFNoise2.ar(234).range(~glitch_rate_lower, ~glitch_rate_upper)).range(0, 1) }
~glitch = { ~slopads * ~glitch_env }
~glitch_damping = { SinOsc.ar(0.07).range(0.5, 0.9) }
~glitch_insert = { XFade2.ar(~glitch, Resonator.ar(~glitch, freq: TChoose.kr(~glitch_env, [Note("e2").freq, Note("a2").freq, Note("f#3").freq] ), damping: ~glitch_damping), LFNoise2.kr(350).range(-1, ~glitch_res_limit))}
m.add(~glitch)

~cross_rate = { LFNoise2.ar(149).range(0.1, 0.5) }
~cross_mix = { SinOsc.ar(LFNoise2.ar(9348).range(0.3, 50)) }
~cross = { XFade2.ar(~slopads, ~bass, ~cross_mix) * ~breathy * Pulse.ar(~cross_rate).range(0, 10) }
m.add(~cross, level: 0)

~roberto_loop_level = 1.0
~crackle_level = 0.0
~bass_level = 0.0
~slopads_level = 0.0
~breathy_level = 0.0
~glitch_level  = 0.0
~cross_level = 0.0


