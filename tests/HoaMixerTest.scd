

// Things (for Tim) to remember:
//   Ranges:
//     Angle: -0.5pi to 0.5pi
//     azim, elevation, RTT: 0 to 2pi (or -pi, pi, or whatever)
//   Looper controls:
//     recording, record_mix, rate, pitch, spec_mix, grain_mix, grain_density, grain_pos_randomness,
//     grain_duration, grain_rate, grain_trigs
//   Mixer controls:
//     level, angle, azim, elevation, rotate, tilt, tumble, insert
// Insert goes on the OUTSIDE, like ~foo_insert = { ~foo }
// (https://github.com/timcowlishaw/supercollider-stuff si estàs llegint això i tens curiositat)

p = ProxySpace().push(s.boot);
q = ();
l = LoopStation.new(s, p, q, fftSize:16384, hop: 0.25, win: 1, recFadeTime:0.1, defaultFadeTime: 2.0);

m = HOAMixer.new(s, p, q, maxLevel:5.0, defaultLevel: 0.7, defaultFadeTime: 4.0, order: 3);


~out = { m.bus.ar }


~out.play

~bounce = {SinOsc.ar(330) * LFSaw.kr(6).range(1, 0) }

~bounce2 = {SinOsc.ar(440) * LFSaw.kr(4.4).range(1, 0) }

~bounce2_insert = { CombL.ar(~bounce2.ar, maxdelaytime: 2.0, delaytime: 1.0, decaytime: 5.0) }

~bounce_insert = { CombL.ar(~bounce.ar, maxdelaytime: 2.0, delaytime: 0.66, decaytime: 5.0) }

m.add(~bounce, level: 0.2)

m.add(~bounce2, level: 0.2)

~bounce_angle =  0.5*pi


~bounce_elevation = { LFTri.ar(0.1).range(-pi, pi) }



~bounce_rotate = { LFSaw.ar(0.33).range(0, 2* pi) }

~bounce_level = { 0.2 }
~bounce2_level = { 0.2 }


~bounce2_angle =  { 0.5*pi }

~bounce2_rotate = { LFSaw.ar(0.33).range(0, 2 * pi) }

~bounce2_elevation = { LFTri.ar(0.1).range(-0.2*pi,  0.2*pi) }

~bounce2_tumble = 0 // { LFSaw.ar(0.1).range(0, 2 * pi) }

~bounce2_tilt = { LFSaw.ar(0.1).range(0, 2 * pi) }

~bounce_tilt = { 0 }

~bounce_tumble = { 0 }

AtkHoa.refRadius
