p = ProxySpace().push(s.boot);
q = ();
l = LoopStation.new(s, p, q, fftSize:16384, hop: 0.25, win: 1, recFadeTime:0.1, defaultFadeTime: 2.0);

m = StereoMixer.new(s, p, q, maxLevel:5.0, defaultLevel: 0.7, defaultFb: 0.7, defaultFadeTime: 4.0);

~stereo_mixer_master_fader = 1.0;


~reverb_mix = 0.1
~reverb_size = 1.0
~reverb_damp = 0.4

~out = { FreeVerb.ar(m.output.ar, room: ~reverb_size, damp: ~reverb_damp, mix: ~reverb_mix) }

~out.play


m.add(l.load(\tallis, "/home/tim/Music/samples/tallis.wav"));

~tallis_grain_mix = 0

~tallis_spec_mix = 1.0

~tallis_rate = 0.1

~tallis_end_pos = 0.6
~tallis_start_pos = 0.045

~tallis_grain_density = 2.0

~tallis_grain_duration = 60

~tallis_grain_rate = { TWChoose.kr(~tallis_grain_trigs, [0.5, 1.0, 2.0], [0.35, 0.5, 0.15]) }

~tallis_grain_pos_randomness = 0.25

~tallis_grain_slope = 1
~tallis_grain_angle = -0.25
~tallis_grian_curve = 3.0

~tallis_insert = { CombL.ar(AnalogLoss.ar(AnalogChew.ar(~tallis.ar, depth: 0.05)), delaytime: 0.5, decaytime: 5.0) }

~tallis_pan = { 0 }

m.add(l.listen(\sticks, 12.2), level: 0.2)

~sticks_recording = 0.0


~sticks_level = 0.6

~sticks_start_pos = { LFTri.kr(0.33).range(0.5, 0.7) }
~sticks_end_pos = { LFTri.kr(0.5).range(0.8, 0.9) }

~sticks_grain_mix = 0

~sticks_grain_density = 5.0

~sticks_rate = 0.1

~sticks_spec_mix = 1

~sticks_grain_duration = 100

~sticks_grain_rate = 1

~sticks_grian_slope = 1

~sticks_grain_angle = -0.25

~sticks_grain_pos_randomness = 1.0


~sticks_insert = { CombL.ar(~sticks.ar, delaytime: 0.5, maxdelaytime: 2.0, decaytime: 5.0) }


~sticks_level.fadeTime = 30.0

~sticks_level = 0.0

m.add(l.listen(\two, 15), level: 0.4)

~two_level = 0.15

~two_recording = 0.0

~two_spec_mix = 1.0

~two_rate = 0.21

~two_glitchy = 10.0

~two_glitch_level = 0.6

~two_level = 1.0

~two_grain_density = 2.0

~two_grain_duration = 60

~two_grain_rate = { TWChoose.kr(~two_grain_trigs, [0.5, 1.0, 2.0], [0.35, 0.5, 0.15]) }

~two_grain_pos_randomness = 0.25

~two_grain_slope = 1
~two_grain_angle = -0.25
~two_grian_curve = 3.0

~two_grain_mix = 0.0

~two_insert = { CombL.ar(~two.ar, delaytime: 0.5, maxdelaytime: 2.0, decaytime: 5.0) }


~two_level.fadeTime = 30.0
~two_level = 0.0


m.add(l.listen(\one, 10), level: 0.4)

~one_recording = 0.0

~one_record_mix = -0.8

~one_grain_mix = 1.0

~one_rate = 0.25
~one_spec_mix = 1.0

~one_grain_density = 20.0
~one_grain_duration = { LFNoise2.ar(500).range(20, 100) }

~one_grain_angle = 0.75
~one_grain_slope = 1.0
~one_grain_curve = 2.0

~one_grain_pos_randomness = 0.2

~one_level = 0.3
~one_grain_density.fadeTime = 20.0

~one_grain_density = 0.0

~one_pan  = { LFTri.kr(0.3) }

~one_insert = { CombL.ar(~one.ar, delaytime: 1.2, maxdelaytime: 2.0, decaytime: 5.0) }


