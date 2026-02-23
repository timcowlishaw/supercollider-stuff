









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
l = LoopStation.new(s, p, q, fftSize:32768, hop: 0.25, win: 1, recFadeTime:0.1, defaultFadeTime: 2.0);

m = FOAMixer.new(s, p, q, maxLevel:5.0, defaultLevel: 0.7, defaultFb: 0.7, defaultFadeTime: 4.0);

~foa_mixer_master_fader = 8.0;

d = FoaDecoderMatrix.newPanto(2)
~mixer_decoded = { FoaDecode.ar(m.bus.ar, d) };

~reverb_mix = 0.0
~reverb_size = 0.4
~reverb_damp = 0.7

~out = { FreeVerb.ar(~mixer_decoded, room: ~reverb_size, damp: ~reverb_damp, mix: ~reverb_mix) }

~out.play


// WAIT FOR NOTE


m.add(l.listen(\one, 3), level: 0.0)

~one_recording = 0
~one_spec_mix = 1
~one_spec_wipe_lower = { Note("B3").freq }
~one_spec_wipe_upper = { Note("D4").freq  } // C nos interesa
~one_spec_wipe_lower.fadeTime = 12.0
~one_spec_wipe_upper.fadeTime = 12.0
~one_rate = 0.001
~one_rate.fadeTime = 10.0


~one_pitch = 1.0

~one_level = 5.0

~one.play

// WAIT FOR NOTE


m.add(l.listen(\two, 4.123), level: 0.0)

~two_recording = 0
~two_spec_mix = 1.0
~two_spec_wipe_lower = { Note("G3").freq }
~two_spec_wipe_upper = { Note("B3").freq } // A# nos interesa
~two_spec_wipe_lower.fadeTime = 20.0
~two_spec_wipe_upper.fadeTime = 20.0
~two_rate = -0.01

~one <>> { LFNoise2.kr(500).range }


~one_level = 0.0

~rhythm = { ~two * Saw.ar(LFNoise2.kr(500).range(0.1, 30)) * SinOsc.kr(0.33).range(0, 1) }

m.add(~rhythm)

~two_rate = 0.00

~rhythm2 = { ~one * Saw.ar(LFNoise2.kr(500).range(0.2, 20)) * SinOsc.kr(0.1).range(0, 1) }

~rhythm2_level = 0

m.add(~rhythm2)

~rhythm2_level = 0.0

~rhythm_level = 0.0

~two_insert = { CombL.ar(~two.ar, maxdelaytime: 5.0, delaytime: 1.0, decaytime: 6.0) }

~one_insert = { CombL.ar(~one.ar, maxdelaytime: 5.0, delaytime: 1.23, decaytime: 8.2) }

~rhythm_one = { ~one_insert * Pulse.ar(LFNoise2.kr(123).range(10.0, 5.0)).range(0, 1) }

~rhythm_two = { ~two_insert * Saw.ar(LFNoise2.ar(928).range(0.1, 40)).range(0, 1) }


~tremelo = { \in.ar * Pulse.ar(\freq.kr(2.0).range(1.0 - \level.kr(1.0), 1.0)) }

~one <>> ~tremelo

~freq <>>.freq ~tremelo

~freq = { SinOsc.ar(0.1).range(2.0, 5.0) }

~tremelo.stop

m.add(~rhythm_one, level: 0.0)
m.add(~rhythm_two, level: 0.0)

~rhythm_two_level = 0.0
~rhythm_one_level = 0.0

~rhythm_two_level.fadeTime = 10.0
~rhythm_one_level.fadeTime = 10.0
// CUANDO MAIA HAYA TERMINADO

~one_level = 0.0
~two_level = 0.0
~one_rate = 0.1

~two_spec_mix = 1.0
~two_rate = -0.013

~xfader = { SinOsc.ar(0.1) }

~crossfaded = { XFade2.ar(~one_spec_playback, ~two_spec_playback, ~xfader) }

m.add(~crossfaded)

// DO SOME THNGS

~two_level = 4.0

~rhythm_2_level = 3.0
~rhythm_1_level = 3.0


// DO SOME THINGS
~foa_mixer_master_fader = 4.0;
~foa_mixer_master_fader.fadeTime = 0.0;
