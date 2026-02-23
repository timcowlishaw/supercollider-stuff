// EL PARANY dels macros de vim!!!! (em sap greu)
p = ProxySpace().push(s.boot);
q = ();
l = LoopStation.new(s, p, q, fftSize:16384, hop: 0.25, win: 1, recFadeTime:0.1, defaultFadeTime: 5.0);

m = FOAMixer.new(s, p, q, maxLevel:5.0, defaultLevel: 0.7, defaultFb: 0.7, defaultFadeTime: 10.0);

p.fadeTime = 5.0;

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



~fx_level = 0.1

~fx_grain_mix = 1

~fx_grain_density = { LFNoise2.kr(500).range(0, 10) }

~fx_insert = { XFade2.ar(~fx, Resonator.ar(~fx, freq: TChoose.kr(~fx_grain_trigs, [Note("d2").freq, Note("c2").freq, Note("f3").freq] )), LFNoise2.kr(350).range(-1, 0.5))}

m.add(l.load(\bass, "/home/tim/Music/samples/fromscratchoct2024/bass_mono.wav"))



~bass_spec_mix = 0

~bass_rate = -0.1

m.add(l.load(\melody, "/home/tim/Music/samples/fromscratchoct2024/melody_mono.wav"))


~melody_spec_mix = 1

~melody_rate = 0.0


~melody_insert = { XFade2.ar(~melody, ~melody * Saw.ar(0.5), SinOsc.kr(0.33)) }

~melody_grain_rate


m.add(l.load(\chords, "/home/tim/Music/samples/fromscratchoct2024/chords_mono.wav"))

~chords_spec_mix = 1

~chords_rate = 0.0

~chords_level = 1.0


~rhythm = { ~chords * Saw.ar(3) }

m.add(~rhythm)



~foa_mixer_master_fader = 0
