
// Things (for Tim) to remember:
//   "~" is  actually "\" on your keyboard, and "\" is "`" :-)
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

~reverb_mix = 0.1
~reverb_size = 1.0
~reverb_damp = 0.4

~out = { FreeVerb.ar(~mixer_decoded, room: ~reverb_size, damp: ~reverb_damp, mix: ~reverb_mix) }

~out.play


//Sticks on high string near bridge

m.add(l.listen(\zero, 12.0), level: 1.0)

~zero_recording = 0

~zero_rate = -0.1
~zero_spec_mix = 1.0

~zero_level.fadeTime = 30.0

~zero_level = 0 // { LFTri.ar(0.33).range(0, 1.0) }


m.add(l.listen(\one, 5.0), level: 1.0)

~one_level = 0.0

m.add(l.listen(\two, 7.0), level: 1.0)

~two_level = 0.0

m.add(l.listen(\three, 8.01), level: 1.0)

~three_level = 0.0

m.add(l.listen(\four, 12.00), level: 1.0)

m.add(l.listen(\five, 6.00), level: 1.0)

~five_recording = 0.0

~five_grain_mix = 0

~five_grain_density =  { LFTri.ar(10.0).range(0, 20) }


~five_level.fadeTime = 20.0

~five_level = 0.0

m.add(l.listen(\six, 12.00), level: 1.0)

m.add(l.listen(\seven, 13.50), level: 1.0)

~seven_recording = 0.0

~seven_grain_rate = { 0.5 }

~seven_grain_density = { LFTri.ar(2).range(0, 0) }

~seven_grain_mix.fadeTime = 30

~seven_grain_mix = 1.0

~six_recording = 0.0

~six_rate = -0.333

~six_spec_mix.fadeTime = 30.0

~six_spec_mix = 1.0

~six_level = 1.2


~six_level.fadeTime = 30.0

~six_level = 0.0

~seven_level = 0.6

~four_level = 0.0

~one_recording = 0

~one_rate = -0.000001

~one_spec_mix = { LFTri.ar(0.3).range(0, 1) }


~two_rate = 0.01


~two_spec_mix = { LFTri.ar(0.25).range(0, 1) }


~one_grain_mix = 0

~one_grain_density = 0

~one_insert = { ~one * LFTri.ar(SinOsc.ar(0.2).range(2, 8)).range(0.2, 1.0) }

~one_level = 0.0

m.add(l.listen(\maia, 12.0), level: 1.0)

~maia_recording = 0
~maia_rate = -0.1
~maia_insert = { ~maia * LFTri.ar(SinOsc.ar(0.2).range(2, 8)).range(0.2, 1.0) }

~maia_level = 1.0

