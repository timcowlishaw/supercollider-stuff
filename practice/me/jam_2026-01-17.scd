
p = ProxySpace().push(s.boot);
q = ();
l = LoopStation.new(s, p, q, fftSize:16384, hop: 0.25, win: 1, recFadeTime:0.1, defaultFadeTime: 5.0);

m = FOAMixer.new(s, p, q, maxLevel:5.0, defaultLevel: 0.7, defaultFb: 0.7, defaultFadeTime: 10.0);

~foa_mixer_master_fader = 1.0;

d = FoaDecoderMatrix.newPanto(2)
~mixer_decoded = { FoaDecode.ar(m.bus.ar, d) };

~reverb_mix = 0.6
~reverb_size = 1.0
~reverb_damp = 0.4

~out = { FreeVerb.ar(~mixer_decoded, room: ~reverb_size, damp: ~reverb_damp, mix: ~reverb_mix) }

~out.play

m.add(l.load(\fx, "/home/tim/Music/samples/fromscratchoct2024/fx_mono.wav"))

~fx_spec_mix = -1
~fx_rate = 0.25
~fx_level = 2.0
~fx_grain_mix = -1
~fx_grain_rate = { LFNoise2.kr(500) * 10 }
~fx_grain_duration = { SinOsc.kr(0.25).range(0.1, 0.4) }
~fx_grain_pos_randomness = 1.0;
~fx_grain_trigs = { Dust.kr(0.2) }

~fx_res_freq = { TWChoose.kr(~fx_grain_trigs, [Note("G#2").freq, Note("B2").freq],[0.5, 0.5]) }

~fx_insert = { XFade2.ar(~fx, Resonator.ar(~fx, ~fx_res_freq, damping: LFNoise2.ar(500).range(0.7, 1.0), structure: LFNoise2.ar(250).range(0.2, 0.4)), SinOsc.kr(0.2).range(-1, -1)) }

m.add(l.load(\bass, "/home/tim/Music/samples/fromscratchoct2024/bass_mono.wav"))

~bass_spec_mix = 1.0

~bass_rate = -0.5

~bass_level = 3.0

~bass_change_trigs = { Dust.kr(0.3) }
~bass_res_freq = { TWChoose.kr(~bass_change_trigs, [Note("G#3", "D#3", "F#3").freq],[0.5, 0.0, 0.5]) }

~bass_insert = { XFade2.ar(~bass, Resonator.ar(~bass, ~bass_res_freq, damping: LFNoise2.ar(500).range(0.01, 0.02), structure: LFNoise2.ar(250).range(0.5, 0.6)), SinOsc.kr(0.2).range(-1, -1)) }


~drone_change_trigs = { Dust.kr(4.7) }

~drone_freq = { TWChoose.kr(~drone_change_trigs, [Note("G4").freq, Note("B4").freq, Note("F#4").freq], [0.5, 0.25, 0.25]) }

~drone = { CombL.ar(LPF.ar(AnalogFoldOsc.ar(freq: ~drone_freq, amp: SinOsc.ar(0.1).range(0.0, 0.2)), 1337) * EnvGen.ar(Env.perc(0.01, 0.4), ~drone_change_trigs), delaytime: 0.1, maxdelaytime: 2.0, decaytime: 4.0) }

m.add(~drone, level: 0.0)

~drone_level = { LFTri.kr(0.1).range(0.0, 0.0) }

~drone_insert = { CombL.ar(~drone * SinOsc.ar(0.33).range(0.0, 1.0), 1.0, 1.0, 0.99) }

m.add(l.load(\chords, "/home/tim/Music/samples/fromscratchoct2024/chords_mono.wav"))

~chords_spec_mix = 1.0
~chords_rate = -0.5

~chords_level = 1.0


~chords_level.fadeTime = 20
~chords_level = 0.0

~bass_level = 0.0
