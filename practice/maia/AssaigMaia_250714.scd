//First, the setup:
(
q = ();
p = ProxySpace().push(s.boot);
f = Freezer2.new(s, p);


m = FOAMixer.new(s, p, q, maxLevel:5.0, defaultLevel: 0.7, defaultFb: 0.7, defaultFadeTime: 4.0);

~foa_mixer_master_fader = 5.0;

d = FoaDecoderMatrix.newPanto(2);
~mixer_decoded = { FoaDecode.ar(m.bus.ar, d) };

~reverb_mix = 0.3;
~reverb_size = 0.4;
~reverb_damp = 0.7;

~comp_thresh = 0.25;
~comp_ratio = 1/4.0;
~comp_makeup=3.0;

~out = {
  FreeVerb.ar(
    Compander.ar(
      ~mixer_decoded,
      ~mixer_decoded,
      thresh:  ~comp_thresh,
      slopeBelow: 1.0,
      slopeAbove: ~comp_ratio,
      mul: ~comp_makeup
    ),
    room: ~reverb_size,
    damp: ~reverb_damp,
    mix: ~reverb_mix
  )
};

~out.play;
)

// VERY IMPORTANT things before starting,
// 0.1) BLOCK YOUR SCREENSAVER!
// 0.2) Make sure everything's wired up in pipewire (AFTER starting SC)
// 0.3) SHOW THE  LEVEL METER!!!
// 0.4) MAKE SURE THATFOCUS IS RETURNED TO THIS WINDOW!!!

// 1) check levels and tempo with Maia.


// 2) Adjust this to fit the acoustics and relative level of the piano.
~foa_mixer_master_fader = 5.0;
~foa_mixer_master_fader.fadeTime = 3.0;

f.freeze(\barra, 0.2)

(
m.add(
  f.thaw(\barra_1, \barra,
    fundamental: 3384,
    lowHarmonic: 1,
    highHarmonic: 2,
    rate: 0.1
  )
);
)


~xfade = { LFNoise2.kr(100.0) }
~barra_1_insert = { XFade2.ar(PitchShift.ar(~barra_1.ar, pitchRatio: 0.75), ~barra_1.ar, ~xfade) }



(
m.add(
  f.thaw(\barra_2, \barra,
    fundamental: 3384,
    lowHarmonic: 0,
    highHarmonic: 1,
    rate: 0.1
  ),
  level: 0.0
);
)

~barra_2_insert = { LFNoise2.ar(10).range(-0.1, 0.1) + PitchShift.ar(~barra_2.ar, pitchRatio: 0.25) }
~barra_2_level.fadeTime = 10.0
~barra_2_level = 1.0

(
m.add(
  f.thaw(\barra_3, \barra,
    fundamental: 3384,
    lowHarmonic: 0,
    highHarmonic: 1,
    rate: 0.1
  ),
  level: 0.0
);
)

~barra_3_insert = { PitchShift.ar(~barra_3.ar, pitchRatio: 0.24) }
~barra_3_level.fadeTime = 10.0
~barra_3_level = 1.0

(
m.add(
  f.thaw(\barra_4, \barra,
    fundamental: 3384,
    lowHarmonic: 0,
    highHarmonic: 1,
    rate: 0.1
  ),
  level: 0.0
);
)

~lfo_speed = { SinOsc.ar(0.1).range(0.33, 1.0) }
~barra_4_insert = { SinOsc.ar(~lfo_speed).range(0, 1) * PitchShift.ar(~barra_4.ar, pitchRatio: 0.12) }
~barra_4_level.fadeTime = 10.0
~barra_4_level = 1.0

f.freeze(\piano, 0.2)





(
m.add(
  f.thaw(\piano_1, \piano,
    fundamental: Note("G#2").freq,
    lowHarmonic: 1,
    highHarmonic: 7,
    rate: 0.1
  )
);
)

~piano_1_insert = { LFNoise2.ar(10).range(0.6, 1.4) *  (PitchShift.ar(~piano_1, pitchRatio: 2.0) + ~piano_1) }

(
m.add(
  f.thaw(\piano_2, \piano,
    fundamental: Note("D3").freq,
    lowHarmonic: 1,
    highHarmonic: 5,
    rate: 0.1
  )
);
)

(
m.add(
  f.thaw(\piano_3, \piano,
    fundamental: Note("C3").freq,
    lowHarmonic: 1,
    highHarmonic: 5,
    rate: 0.1
  )
);
)


~piano_2.set(\fundamental, Note("C3").freq)
~piano_3.set(\fundamental, Note("D3").freq)
~piano_1.set(\fundamental, Note("A#2").freq)


~lfo_speed_1 = { 0.33 }
~lfo_speed_2 = { 5.0 }
~lfo_speed_3 = { 2.0 }
~lfo_amt = { 1.0 }
~piano_1_insert = { SinOsc.ar(~lfo_speed_1).range(1.0 - ~lfo_amt, 1.0 + ~lfo_amt) * ~piano_1}
~piano_2_insert = { SinOsc.ar(~lfo_speed_2).range(1.0 - ~lfo_amt, 1.0 + ~lfo_amt) * ~piano_2}
~piano_3_insert = { SinOsc.ar(~lfo_speed_3).range(1.0 - ~lfo_amt, 1.0 + ~lfo_amt) * ~piano_3}

~barra_2_level = 0.0
~barra_3_level = 0.0
~barra_4_level = 0.0
~barra_1_level = 0.0
~piano_1_level = 0.0
~piano_2_level = 0.0
~piano_3_level = 0.0


f.freeze(\gtr, 5.0)

(
m.add(
  f.thaw(\gtr_1, \gtr,
    fundamental: Note("C3").freq,
    lowHarmonic: 1,
    highHarmonic: 5,
    rate: 0.33
  )
);
)

(
m.add(
  f.thaw(\gtr_2, \gtr,
    fundamental: Note("B3").freq,
    lowHarmonic: 1,
    highHarmonic: 5,
    rate: 0.5
  )
);
)

(
m.add(
  f.thaw(\gtr_3, \gtr,
    fundamental: Note("G4").freq,
    lowHarmonic: 1,
    highHarmonic: 5,
    rate: 1.0
  )
);
)

f.freeze(\gtr_lo, 5.0)

(
m.add(
  f.thaw(\gtr_lo_1, \gtr_lo,
    fundamental: Note("A2").freq,
    lowHarmonic: 1,
    highHarmonic: 5,
    rate: 0.15
  )
);
)

~gtr_lo_1_level = 1.2

~gtr_lo_1_insert = { PitchShift.ar(~gtr_lo_1.ar, 0.5) + ~gtr_lo_1 }

~gtr_3_level.fadeTime = 20.0

~gtr_3_lavel = 0.0

~gtr_2_level.fadeTime = 20.0

~gtr_2_lavel = 0.0

~gtr_1_level.fadeTime = 20.0

~gtr_1_lavel = 0.0

~gtr_lo_1_level.fadeTime = 20.0

~gtr_lo_1_level = 0.0

