
// Things (for Tim) to remember:
//   Ranges for push:
//     Angle: -0.5pi (distant, west), 0 (centre), 0.5pi (distant, east)
//     Azimuth: pi (south), 0.5pi (west), 0 (north), -0.5pi (east), -pi (south, again)
//   Looper controls:
//     recording, record_mix, rate, pitch, spec_mix, grain_mix, grain_density, grain_pos_randomness,
//     grain_duration, grain_rate, grain_trigs
//   Mixer controls:
//     level, fb, azim, angle, insert
// (https://github.com/timcowlishaw/supercollider-stuff si estàs llegint això i tens curiositat)

p = ProxySpace().push(s.boot);
q = ();
l = LoopStation.new(s, p, q, fftSize:16384, hop: 0.25, win: 1, recFadeTime:0.1, defaultFadeTime: 2.0);

m = FOAMixer.new(s, p, q, maxLevel:5.0, defaultLevel: 0.7, defaultFb: 0.7, defaultFadeTime: 4.0);

~foa_mixer_master_fader = 3.0;

d = FoaDecoderMatrix.newPanto(2)
~mixer_decoded = { FoaDecode.ar(m.bus.ar, d) };

~reverb_mix = 0.4
~reverb_size = 1.0
~reverb_damp = 0.4

~out = { FreeVerb.ar(~mixer_decoded, room: ~reverb_size, damp: ~reverb_damp, mix: ~reverb_mix) }

~out.play

m.add(l.listen(\zero, 6.0))

~zero_recording = 0

~zero_rate = -0.2
~zero_spec_mix = { 1} // SinOsc.ar(0.18).range(0.0, 1,0)}

~zero_record_mix = 0.5

~zero_level = 0.7 // { SinOsc.kr(SinOsc.kr(0.5).range(2.0, 10.0)).range(0.3, 0.6) }
~zero_level.fadeTime = 25.0

~zero_angle = 0.25*pi
~zero_azim = { SinOsc.kr(0.5) * pi }

~zero_grain_mix = 0 // { SinOsc.kr(0.2).range(-0.5, 0.5) }

~zero_grain_density = { LFNoise2.kr(500).range(0.0, 10.0) }
~zero_grain_pos_rand = { SinOsc.kr(0.11).range(0, 1) }

m.add(l.listen(\one, 12.0), level: 0.0)

~one_recording = 0

~one_rate = 0.25
~one_spec_mix = 1.0

~one_angle = 0.25*pi
~one_azim = { SinOsc.kr(0.22) * pi }

~one_grain_mix = -1
~one_grain_density = 0.6
~one_grain_pos_rand = 1.0

~one_level = 0-0 //{ SinOsc.kr(0.08).range(0.5, 0.7) }
~one_level.fadeTime = 50.0

m.add(l.listen(\two, 7.5), level: 0.0)

~two_recording = 0

~two_rate = -0.33
~two_spec_mix = 1.0
~two_grain_mix = 1.0

~two_grain_density = 0.6
~two_grain_pos_rand = 1.0

~two_level = 0.7

m.add(l.listen(\three, 15.0), level: 0.0)

~three_recording = 0

~three_rate = -0.33
~three_spec_mix = 1.0
~three_grain_mix = -1

~three_grain_density = 0.6
~three_grain_pos_rand = 1.0

~three_level = 0.7


~sin1 = { SinOsc.ar(101.5) }

m.add(~sin1, level: 0.0)

~sin1_level.fadeTime = 10.0

~sin1_level = 0.0


~sin1_angle = 0.25*pi
~sin1_azim = { SinOsc.kr(0.124) * pi }

~sin2 = { SinOsc.ar(703) * SinOsc.ar(703).range(0, 0.1) + SinOsc.ar(604) * SinOsc.ar(504).range(0, 0.2) }

m.add(~sin2, level: 0.0)

~sin2_level.fadeTime = 10.0

~sin2_level = 0 // { SinOsc.ar(0.1).range(0.0, 0.3) }


~sin2_angle = 0.5*pi
~sin2_azim = { SinOsc.kr(2.0, phase: 0.35) * pi }

~saw1 = { Saw.ar(1, 0.02) }

m.add(~saw1, level: 0.0)

~saw1_level.fadeTime = 10.0

~saw1_level = 0.0


~saw1_angle = 0.5*pi
~saw1_azim = { SinOsc.kr(0.2, phase: 0.35) * pi }

~saw2 = { Saw.ar(1.5, 0.02) }

m.add(~saw2, level: 0.0)

~saw2_level.fadeTime = 10.0

~saw2_level = 0.0


~saw2_angle = 0.5*pi
~saw2_azim = { SinOsc.kr(0.33, phase: 0.1) * pi }

