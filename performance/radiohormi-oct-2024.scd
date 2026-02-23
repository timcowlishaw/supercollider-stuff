
p = ProxySpace().push(s.boot);
q = ();
l = LoopStation.new(s, p, q, fftSize:16384, hop: 0.25, win: 1, recFadeTime:0.1);

m = FOAMixer.new(s, p, q, maxLevel:5.0, defaultLevel: 0.7, defaultFb: 0.7);

d = FoaDecoderMatrix.newPanto(2)
~mixer_decoded = { FoaDecode.ar(m.bus.ar, d) };
~mixer_decoded.play
//   Looper controls:
//     recording, record_mix, rate, pitch, spec_mix, grain_mix, grain_density, grain_pos_randomness,
//     grain_duration, grain_rate, grain_trigs
//   Mixer controls:
//     level, fb, azim, angle, insert




~foa_mixer_master_fader = 1.0;
~foa_mixer_master_feedback = 0.8;


m.add(l.listen(\gtr_1, 10.0), fb: 0.7, level: 0.4);

~gtr_1_recording = 0

~gtr_1_spec_mix = 0
~gtr_1_rate = 0.33

~gtr_1_level = 1

~gtr_1_level.fadeTime_(10)
~gtr_1_level = 0

m.add(l.listen(\gtr_2, 12.5), fb: 0.7, level: 0.4);


~gtr_2_recording = 0


~gtr_2_grain_mix = 0

~gtr_2_level = 1.5

~gtr_2_rate = 0.2

~gtr_2_spec_mix = 1

~gtr_2_level.fadeTime_(10)
~gtr_2_level = 0

~gtr_2_grain_density = { SinOsc.kr(2.0, mul: 10.0, add: 20.0) }
~gtr_2_grain_duration = { 5.0 + SinOsk.kr(0.25, mul: 1.0, add: 2.0) }
~gtr_2_grain_rate = { TChoose.kr(~gtr_2_grain_trigs, [1.5, 1, 0.5]) }
