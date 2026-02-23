// EL PARANY del ctrl-v!!!! (em sap greu)
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
//   Looper controls:
//     recording, record_mix, rate, pitch, spec_mix, grain_mix, grain_density, grain_pos_randomness,
//     grain_duration, grain_rate, grain_trigs
//   Mixer controls:
//     level, fb, azim, angle, insert
// Some frequencies of interest: 73.82, 220, 696.84, 1046.5, 1318.51


m.add(l.load(\fx, "/home/tim/Music/samples/fromscratchoct2024/fx_mono.wav"))

~fx_spec_mix = -1
~fx_rate = 0.25
~fx_level = 2.0
~fx_grain_mix = -1
~fx_grain_rate = { LFNoise2.kr(500) * 10 }
~fx_grain_duration = { SinOsc.kr(0.25).range(0.1, 0.4) }
~fx_grain_pos_randomness = 1.0;
~fx_grain_trigs = { Dust.kr(0.2) }

~fx_insert = { XFade2.ar(~fx, Resonator.ar(~fx, 696.84, damping: LFNoise2.ar(500).range(0.1, 0.2), structure: LFNoise2.ar(250).range(0.2, 0.4), SinOsc.kr(0.2, add: 0.5, mul: 0.5)) }

m.add(l.load(\bass, "/home/tim/Music/samples/fromscratchoct2024/bass_mono.wav"))

m.add(l.load(\chords, "/home/tim/Music/samples/fromscratchoct2024/chords_mono.wav"))

~bass_spec_mix = 0.0

~bass_rate = -0.1

~bass_level = 1.0

~chords_spec_mix = 1.0
~chords_rate = -0.5

~chords_level = 1.0

m.add(l.load(\melody, "/home/tim/Music/samples/fromscratchoct2024/melody_mono.wav"))

~drone = { AnalogFoldOsc.ar(freq: 73.82 * 2, amp: SinOsc.ar(0.1).range(0.0, 0.2)) }

m.add(~drone, level: 0.0)

~drone_level = 0.0

~drone_insert = { ~drone * SinOsc.ar(0.33).range(0.0, 1.0) }

~drone_2 = { AnalogFoldOsc.ar(freq: 696.84, amp: SinOsc.ar(0.05).range(0.0, 0.4)) }
m.add(~drone_2, level: 0.0)

~drone_2_insert = { CombL.ar(~drone_2 * SinOsc.ar(0.2).range(0.0, 1.0), 1.0, 1.0, 0.7) }

~drone_2_level = 0.0

~melody_grain_mix = 0;
~melody_spec_mix =0;
~melody_rate = -0.5;
~melody_grain_rate = { 1 };
~melody_grain_pos_randomness = { 0.6 * LFNoise2.ar(100) }
~melody_grain_duration = { (1 + LFNoise2.ar(500)) * 0.1 }
~melody_grain_trigs = { Dust.kr(10) }

~melody_delayTime = 0.5

~melody_insert  = { CombL.ar(~melody.ar, 3.0, ~melody_delayTime, 10.0) }
~melody_insert.fadeTime = 10.0


~melody_level.fadeTime_(10.0)

~melody_level = 0.5

~chords_level = 0

~bass_level = 0

~chords_insert = { CombL.ar(~chords + (XFade2.ar(~chords, ~melody, LFNoise2.kr(10)) * Saw.ar(3.0))) }

~bass_insert = { ~bass + (XFade2.ar(~bass, ~chords, SinOsc.kr(0.25)) * (0.5 * Saw.ar(1.0))) }


~foa_mixer_master_fader = 0.0
