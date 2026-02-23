
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

m.add(l.load(\tallis, "/home/tim/Music/samples/tallis.wav"));

~tallis_level = 0.0



m.add(l.listen(\sticks, 12.2), level: 0.2)

~sticks_recording = 0

~sticks_spec_mix = 0.5

~sticks_rate = -0.2

~sticks_level = 0.1

~sticks_level = 0.0

~sticks_grain_density = { LFTri.kr(0.1).range(0, 10) }

~sticks_grain_mix.fadeTime = 20.0

~sticks_grain_mix = 0

~sticks_level = 0.0


//FREE rhythmically
m.add(l.listen(\mid_strings, 18.0), level: 0.2)

~mid_strings_recording = 0.0


~mid_strings_spec_mix.fadeTime = 20
~mid_strings_spec_mix = 1

~mid_strings_rate = -0.73


~mid_strings_choppiness = 10.0

~mid_strings_insert = { ~mid_strings * (1 - Dust.ar(~mid_strings_choppiness).range(0, SinOsc.ar(0.32).range(1, 2))) }

~mid_strings_level = 0.1


~mid_strings_level.fadeTime = 21.0

~mid_strings_level = 0.0

// WHEN MAIA low click comes in
m.add(l.listen(\low_strings, 0.7*4*2*4), level: 0.2);

~low_strings_recording = 0.0


~low_strings_level = 0.0

~low_strings_level = 0.7

~low_strings_level.fadeTime = 30.0

~low_strings_level = 0.2


~low_strings_spec_mix.fadeTime = 30.0

~low_strings_rate = -0.22


~low_strings_spec_mix = 0.0

~low_strings_grain_mix = 1.0


m.add(l.listen(\high_strings, 0.7*4*2*4), level: 0.2);

~high_strings_recording = 0.0

~high_strings_spec_mix.fadeTime = 20.0


~high_strings_rate = 0.1


~high_strings_spec_mix = 1.0

~high_strings_level = 0.1

~high_strings_choppiness = 10.0
~high_strings_insert = { ~high_strings * (1 - Dust.ar(~high_strings_choppiness).range(0, SinOsc.ar(0.32).range(5, 10))) }

~high_strings_level.fadeTime = 18.0

~high_strings_level = 0.0
