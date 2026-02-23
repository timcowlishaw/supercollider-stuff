p = ProxySpace().push(s.boot);
q = ();
l = LoopStation.new(s, p, q, fftSize:16384, hop: 0.25, win: 1, recFadeTime:0.1, defaultFadeTime: 2.0);

m = FOAMixer.new(s, p, q, maxLevel:5.0, defaultLevel: 0.7, defaultFb: 0.7, defaultFadeTime: 4.0);

~foa_mixer_master_fader = 3.0;

d = FoaDecoderMatrix.newPanto(2)
~mixer_decoded = { FoaDecode.ar(m.bus.ar, d) };

~reverb_mix = 0.6
~reverb_size = 1.0
~reverb_damp = 0.4

~out = { FreeVerb.ar(~mixer_decoded, room: ~reverb_size, damp: ~reverb_damp, mix: ~reverb_mix) }

~out.play

//   Looper controls:
//     recording, record_mix, rate, pitch, spec_mix, grain_mix, grain_density, grain_pos_randomness,
//     grain_duration, grain_rate, grain_trigs
//   Mixer controls:
//     level, fb, azim, angle, insert
// Some frequencies of interest: 73.82, 220, 696.84, 1046.5, 1318.51


m.add(l.listen(\test, 2.0))

~test_recording = 1;

~test_record_mix = 0.0;

~test_spec_mix = 1.0;

~test_rate = { LFNoise2.ar(10).range(-0.5, 0.5) };

~test_spec_wipe_lower = { LFNoise2.ar(10).range(0.0, 2000.0) }

~test_spec_wipe_upper = { LFNoise2.ar(200).range(800.0, 24000) }


m.add(l.listen(\test2, 0.66))
~test2_recording = 1;

~test2_record_mix = 0;

~test2_spec_mix = 1.0

~test2_rate = -0.1

~test2_insert = { XFade2.ar(LFNoise2.ar(500).range(0.95, 1.0), ~test2, ~test2 * Saw.ar(LFNoise2.ar(200).range(3, 20))) }

~test2_level = 0.3

m.add(l.load(\fx, "/home/tim/Music/samples/fromscratchoct2024/fx_mono.wav"))

m.add(l.load(\bass, "/home/tim/Music/samples/fromscratchoct2024/bass_mono.wav"))

m.add(l.load(\melody, "/home/tim/Music/samples/fromscratchoct2024/melody_mono.wav"))

m.add(l.load(\chords, "/home/tim/Music/samples/fromscratchoct2024/chords_mono.wav"))

m.add(l.load(\roberto_loop, "/home/tim/Downloads/wetransfer_019_1-wav_2025-01-15_1946/019_1.WAV"))

~roberto_loop_spec_mix = 0.5

~roberto_loop_rate = 0.1

~rhythm = { ~roberto_loop * Saw.ar(LFNoise2.kr(3.1).range(0.5, 15)) }


m.add(~rhythm)

m.add(l.load(\roberto_loop2, "/home/tim/Downloads/wetransfer_019_1-wav_2025-01-15_1946/019_1.WAV"))

~glitch = { ~roberto_loop2 * Saw.ar(LFNoise2.kr(10.1).range(4, 50)) }

m.add(~glitch)

~roberto_loop2_spec_mix = 1.0;

~roberto_loop2_rate = 0.1

~roberto_loop2_pitch = 0.5

~roberto_loop2_level = 2.0

~spec_wipe_window = { SinOsc.ar(0.5).range(100, 1000) }

~roberto_loop2_spec_wipe_lower = { SinOsc.ar(0.3).range(0, 24000- ~spec_wipe_window) }
~roberto_loop2_spec_wipe_upper = { ~roberto_loop2_spec_wipe_lower + ~spec_wipe_window }

m.add(l.load(\roberto_loop3, "/home/tim/Downloads/wetransfer_019_1-wav_2025-01-15_1946/019_1.WAV"))

~roberto_loop3_spec_mix = 1.0

~roberto_loop3_rate = -0.33

~roberto_loop3_pitch = 2.0

~roberto_loop_level = 0.0

~roberto_loop3_level = 0.0

~glitch_level = 0.0

~rhythm_level = 0.0

~fx_level = 0.0

~chords_level = 1.0

~melody_level = 1.0

~bass_level = 1.0

~chords_spec_mix = 1.0

~chords_rate = 0.0

~chords_spec_wipe_lower = { LFNoise2.ar(30).range(0, 500) }

~chords_spec_wipe_upper = { LFNoise2.ar(100).range(8000, 24000) }

~melody_spec_mix = 1.0

~melody_rate = 0.0

~melody_spec_wipe_lower = { LFNoise2.ar(0.33).range(0.0, 440.0) }

~melody_spec_wipe_upper = { SinOsc.ar(0.5).range(880, 24000) }

~bass_spec_mix = 1.0

~bass_rate = -0.1

~bass_spec_wipe_lower = { 100 }

~bass_spec_wipe_upper = { 880.0 }


~rhythm = { ~chords * Saw.ar(LFNoise2.kr(3.1).range(0.5, 15)) }

~rhythm2 = { ~bass * Saw.ar(LFNoise2.kr(5.1).range(0.1, 3)) }

~rhythm3 = { ~chords * Saw.ar(LFNoise2.kr(10.0).range(0.1, 1.0)) }

m.add(~rhythm)

m.add(~rhythm2)

m.add(~rhythm3)

~rhythm_level = 0.0

~rhythm2_level = 1.0

~rhythm3_level = 1.0
