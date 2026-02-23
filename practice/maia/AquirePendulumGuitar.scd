
// Things (for Tim) to remember:
//   Ranges:
//     Angle: -0.5pi to 0.5pi
//     azim, elevation, RTT: 0 to 2pi (or -pi, pi, or whatever)
//   Looper controls:
//     recording, record_mix (-1 playback, 1 overwrite), rate, pitch, spec_mix, grain_mix, grain_density, grain_pos_randomness,
//     grain_duration, grain_rate, grain_trigs
//   Mixer controls:
//     level, angle, azim, elevation, rotate, tilt, tumble, insert
// Insert goes on the OUTSIDE, like ~foo_insert = { ~foo }
// (https://github.com/timcowlishaw/supercollider-stuff si estàs llegint això i tens curiositat)

p = ProxySpace().push(s.boot);
p.fadeTime = 3.0;
q = ();
l = LoopStation.new(s, p, q, fftSize:16384, hop: 0.25, win: 1, recFadeTime:0.1, defaultFadeTime: 2.0);

m = HOAMixer.new(s, p, q, maxLevel:5.0, defaultLevel: 0.7, defaultFadeTime: 4.0, order: 3);

~hoa_mixer_master_fader = 3.0;

~out = { m.bus.ar }

~out.play

~colors_level = 0.0;
~colors_level.fadeTime = 15

m.add(l.listen(\colors_1, 6.0), level: 0.0);


(
  ~colors_1_spec_mix = 1.0;
  ~colors_1_rate = 0.2;
  ~colors_1_level.fadeTime = ~colors_level.fadeTime;
  ~colors_1_level = ~colors_level;
)

// Som hi??

~colors_1_recording = 0
~colors_level.fadeTime = 25.0
~colors_level = 3.0

~colors_1_angle = 0.5 * pi

~colors_1_rotate = { LFSaw.kr(0.2).range(0, 2*pi) }

~colors_level = { LFTri.kr(3.0) }

m.add(l.listen(\colors_2, 13.1), level: 0.0);
(
  ~colors_2_spec_mix = 1.0;
  ~colors_2_rate = -0.31;
  ~colors_2_level.fadeTime = ~colors_level.fadeTime;
  ~colors_2_level = ~colors_level;
)

~colors_2_recording = 0

~colors_2_angle = 0.5 * pi
~colors_2_elevation = { LFTri.kr(0.1).range(-0.5 *pi, 0.5 *pi) }

~colors_2_rotate = { LFSaw.kr(0.18).range(0, 2*pi) }

~colors_2_level = { SinOsc.kr(2).range(0.2, 0.4) }
~colors_1_level = { SinOsc.kr(3).range(0.2, 0.4) }

~colors_1_level = 10.0
~colors_2_level = 10.0


~pendulum_level = 0.0;
~pendulum_level.fadeTime = 15

m.add(l.listen(\pendulum_1, 21.0), level: 0.0);


(
  ~pendulum_1_spec_mix = -1.0;
  ~pendulum_1_grain_mix = 1.0;
  ~pendulum_1_grain_density = 0.3;
  ~pendulum_1_grain_duration = 0.003;
  ~pendulum_1_insert = { CombL.ar(~pendulum_1.ar, maxdelaytime: 2.0, delaytime: 0.13, decaytime: 0.88) };
  ~pendulum_1_grain_pos_randomness = { LFBrownNoise1.kr(1.0).range(0.0, 1.0) };
  ~pendulum_1_rate = -0.12;
  ~pendulum_1_level.fadeTime = ~pendulum_level.fadeTime;
  ~pendulum_1_level = ~pendulum_level;
)

~pendulum_1_recording = 0
~pendulum_level = 4.0

~pendulum_1_angle = 0.0 * pi
~pendulum_1_elevation = { LFTri.kr(0.33).range(-0.5 *pi, 0.5 *pi) }

~pendulum_1_grain_density = 10.0;

~pendulum_1_rotate = { LFBrownNoise1.ar(0.5).range(0, 2*pi) }


m.add(l.listen(\pendulum_2, 13.1), level: 0.0);
(
  ~pendulum_2_spec_mix = 1.0;
  ~pendulum_2_rate = 0.15;
  ~pendulum_2_level.fadeTime = ~pendulum_level.fadeTime;
  ~pendulum_2_level = ~pendulum_level;
)

~pendulum_2_angle = 0.5 * pi
~pendulum_2_elevation = { LFTri.kr(0.1).range(-0.5 *pi, 0.5 *pi) }
~pendulum_2_tilt = { LFSaw.kr(0.5).range(0, 2*pi) }
~pendulum_2_rotate = { LFSaw.kr(0.33).range(0, 2*pi) }

~pendulum_2_recording = 0
~pendulum_2_level = 20.0

~pendulum_1_level = 10.0

~pendulum_level = 0

~pendulum_a_level = 0.0;
~pendulum_a_level.fadeTime = 15

m.add(l.listen(\pendulum_a_1, 3.0), level: 0.0);


(
  ~pendulum_a_1_spec_mix = 1.0;
  ~pendulum_a_1_rate = -0.12;
  ~pendulum_a_1_level.fadeTime = ~pendulum_a_level.fadeTime;
  ~pendulum_a_1_level = ~pendulum_a_level;
)

~pendulum_a_1_recording = 0
~pendulum_a_1_level = 70.0

~pendulum_a_1_angle = 0.5 * pi
~pendulum_a_1_elevation = { LFTri.kr(0.08).range(-0.5 *pi, 0.5 *pi) }
~pendulum_a_1_tilt = { LFSaw.kr(0.6).range(0, 2*pi) }
~pendulum_a_1_rotate = { LFSaw.kr(0.4).range(0, 2*pi) }


m.add(l.listen(\pendulum_a_2, 13.1), level: 0.0);
(
  ~pendulum_a_2_spec_mix = 1.0;
  ~pendulum_a_2_rate = 0.15;
  ~pendulum_a_2_level.fadeTime = ~pendulum_a_level.fadeTime;
  ~pendulum_a_2_level = ~pendulum_a_level;
)

~pendulum_a_2_recording = 1

~pendulum_a_2_angle = 0.5 * pi
~pendulum_a_2_rotate = { LFSaw.kr(0.44).range(0, 2*pi) }

~pendulum_a_2_level = 0.0

~pendulum_a_level = 0

~pendulum_b_level = 0
m.add(l.listen(\pendulum_b_1, 9.2), level: 0.0);


(
  ~pendulum_b_1_spec_mix = 1.0;
  ~pendulum_b_1_rate = -0.12;
  ~pendulum_b_1_level.fadeTime = ~pendulum_b_level.fadeTime;
  ~pendulum_b_1_level = ~pendulum_b_level;
  ~pendulum_2_lfo_amt = 0.0;
  ~pendulum_2_lfo_speed = 0.12;
  ~pendulum_2_lfo_speed2 = 0.1;
  ~pendulum_b_1_insert = {
  ~pendulum_b_1 * LFTri.kr(
    SinOsc.kr(~pendulum_2_lfo_speed).range(2.0, 5.0)
  ).range(
    SinOsc.kr(~pendulum_2_lfo_speed2).range(1 - ~pendulum_b2_lfo_amt, 1.0) // Open downwards to bring in LFO
  , 1.0)
}
)

~pendulum_b_1_recording = 0
~pendulum_b_level = 10.0

~pendulum_2_lfo_speed = 2;
~pendulum_2_lfo_speed2 = 4;
  ~pendulum_2_lfo_amt = 0.4;

~pendulum_b_1_angle = 0.5 * pi
~pendulum_b_2_rotate = { LFBrownNoise1.kr(26).range(0, 2*pi) }


m.add(l.listen(\pendulum_b_2, 11.7), level: 0.0);
(
  ~pendulum_b_2_spec_mix = 1.0;
  ~pendulum_b_2_rate = 0.15;
  ~pendulum_b_2_level.fadeTime = ~pendulum_b_level.fadeTime;
  ~pendulum_b_2_level = ~pendulum_b_level;
)

~pendulum_b_2_recording = 0

~pendulum_b_1_angle = 0.5 * pi
~pendulum_b_2_rotate = { LFBrownNoise1.kr(50).range(0, 2*pi) }
~pendulum_b_2_elevation = { SinOsc.kr(0.1).range(-0.5*pi, 0.5*pi) }

~pendulum_b_1_level = 1.0
~pendulum_b_1_level.fadeTime = 30

~pendulum_b_1_grain_mix = 0.0
~pendulum_b_1_grain_density = 10.0
~pendulum_b_1_grain_pos_randomness = 123.0

~pendulum_b_1_rate = { LFBrownNoise1.kr(120) }

~pendulum_b_level = 1.0

~bounce = {SinOsc.ar(220) * LFSaw.kr(3).range(0, 1) }

~bounce2 = {SinOsc.ar(210) * LFSaw.kr(4.4).range(0, 1) }

m.add(~bounce, level: 0.2)
m.add(~bounce2, level: 0.2)

~bounce2_angle = 0.5 * pi

~bounce_angle = 0.5 * pi

~bounce_azim = { SinOsc.kr(0.2).range(-pi, pi) }

~bounce2_azim = { SinOsc.kr(0.7).range(-pi, pi) }

~bounce_level = 0.0
~bounce2_level = 0.0

~foa_mixer

~hoa_mixer_master_fader.fadeTime = 60.0;
~hoa_mixer_master_fader = 3.0;



