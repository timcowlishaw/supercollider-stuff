
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
~foa_mixer_master_fader = 5.0;
~foa_mixer_master_fade.fadeTime = 3.0;


// Compás 4
f.freeze(\piano_1, 1.837) // Tres corcheras, negra = 49BPM - 3º motivo principal mano derecha
// Compás 15
f.freeze(\piano_2, 2.448) // Un compas de 4/4, negra = 98BPM, 2º compas motvo cromático

// Compás 58
f.freeze(\piano_3, 4.21) // Un compas de 4/4, negra = 57BPM, 4º acorde del final

~c_level = 1.0;

(
q.c_1_rate = 0.007;
q.c_1_harmonic = 4;
q.c_1_fade_time = 1.0;
q.c_1_freq =  Note("C#2").freq;
m.add(
  f.thaw(\c_1, \piano_3,
    fundamental: q.c_1_freq,
    rate: q.c_1_rate,
    highHarmonic: q.c_1_harmonic,
    lowHarmonic: q.c_1_harmonic
  ),
  level: 0.0);
)

(
~c_1_level.fadeTime=q.c_1_fade_time;
~c_1_level = ~c_level;
)

(
~c_1_azim =  { LFBrownNoise1.ar(40.0, dev: 0.1, dist:2).range(-pi, pi) };
~c_1_angle = -0.5 * pi;
)

(
q.c_2_rate = 0.088;
q.c_2_harmonic = 8;
q.c_2_fade_time = 20.0;
q.c_2_freq =  Note("C#2").freq;
m.add(
  f.thaw(\c_2, \piano_3,
    fundamental: q.c_2_freq,
    rate: q.c_2_rate,
    highHarmonic: q.c_2_harmonic,
    lowHarmonic: q.c_2_harmonic
  ),
  level: 0.0);
)

(
~c_2_level.fadeTime=q.c_2_fade_time;
~c_2_level = ~c_level;
)

(
~c_2_azim =  { LFBrownNoise1.ar(40.0, dev: 0.1, dist:2).range(-pi, pi) };
~c_2_angle = -0.5 * pi;
)

(
q.c_3_rate = 0.093;
q.c_3_harmonic = 6;
q.c_3_fade_time = 25.0;
q.c_3_freq =  Note("C#2").freq;
m.add(
  f.thaw(\c_3, \piano_3,
    fundamental: q.c_3_freq,
    rate: q.c_3_rate,
    highHarmonic: q.c_3_harmonic,
    lowHarmonic: q.c_3_harmonic
  ),
  level: 0.0);
)

(
~c_3_level.fadeTime=q.c_3_fade_time;
~c_3_level = ~c_level;
)

(
~c_3_azim =  { LFBrownNoise1.ar(40.0, dev: 0.1, dist:2).range(-pi, pi) };
~c_3_angle = -0.5 * pi;
)

(
~beat_c_1 = { PitchShift.ar(~c_1, pitchRatio: 1.001) };
m.add(~beat_c_1, level: 0.0);
~beat_c_1_level.fadeTime = 10.0;
~beat_c_1_level = ~c_1_level;
~beat_c_1_angle = ~c_1_angle;
~beat_c_1_azim = ~c_1_azim;
)

(
~beat_c_2 = { PitchShift.ar(~c_2, pitchRatio: 1.0023) };
m.add(~beat_c_2, level: 0.0);
~beat_c_2_level.fadeTime = 10.0;
~beat_c_2_level = ~c_2_level;
~beat_c_2_angle = ~c_2_angle;
~beat_c_2_azim = ~c_2_azim;
)

(
~beat_c_3 = { PitchShift.ar(~c_3, pitchRatio: 1.0044) };
m.add(~beat_c_3, level: 0.0);
~beat_c_3_level.fadeTime = 10.0;
~beat_c_3_level = ~c_3_level;
~beat_c_3_angle = ~c_3_angle;
~beat_c_3_azim = ~c_3_azim;
)

(
m.add(
  f.thaw(\c_0, \piano_3,
    fundamental: Note("C#2").freq,
    rate: 0.02, highHarmonic: 2, lowHarmonic: 2
  ), level: 0.0);
)

(
~c_0_level.fadeTime = 20.0;
~c_0_level = 0.7;
)


(
m.add(
  f.thaw(\c_0_open, \piano_3,
    fundamental: Note("C#2").freq,
    rate: 0.093,
    highHarmonic: 3, lowHarmonic: 1
  ), level: 0.0);
)

(
~c_0_open_insert = { ~c_0_open * SinOsc.ar(0.08).range(0.0, 0.25) };
~c_0_open_level.fadeTime = 20.0;
~c_0_open_level = 0.5;
)

(
~c_1.set(\lowHarmonic, 5);
~c_1.set(\highHarmonic, 5);
)

(
~c_2.set(\lowHarmonic, 9);
~c_2.set(\highHarmonic, 9);
)

(
~c_3.set(\lowHarmonic, 3);
~c_3.set(\highHarmonic, 3);
)

(
~c_2.set(\lowHarmonic, 15);
~c_2.set(\highHarmonic, 15);
)

(
f.thaw(\a_1, \piano_1,  fundamental: Note("E2").freq, rate: 0.008, highHarmonic: 3, lowHarmonic: 3);

f.thaw(\a_2, \piano_1,  fundamental: Note("A3").freq, rate: 0.07, highHarmonic: 5, lowHarmonic: 5);

f.thaw(\a_3, \piano_1,  fundamental: Note("B3").freq, rate: 0.0544, highHarmonic: 4, lowHarmonic: 4);

)

(

~a_low_harmonic = 3;
//TODO tim this next one needs rethinking
~a_band_width = { EnvGen.ar(Env.perc(0.001), Dust.ar(0.25)).range(0, 0) };
~a_transition_speed = 9.0;

~a_high_harmonic = ~a_low_harmonic + ~a_band_width;
~a_low_harmonic <>>.lowHarmonic ~a_1;
~a_low_harmonic <>>.lowHarmonic ~a_2;
~a_low_harmonic <>>.lowHarmonic ~a_3;
~a_high_harmonic <>>.highHarmonic ~a_1;
~a_high_harmonic <>>.highHarmonic ~a_2;
~a_high_harmonic <>>.highHarmonic ~a_3;

~a_x_fade_fader = { LFBrownNoise1.kr(freq: ~a_transition_speed, dev: 0.2).range(0, 2) };
~a_x_fade = { LinSelectX.ar(~a_x_fade_fader, [~a_1, ~a_2, ~a_3]) };
~a = { Compander.ar(~a_x_fade.ar, ~a_x_fade.ar, thresh: 0.25, slopeBelow:1.0, slopeAbove: 0.25, mul: 1.5)  };
)
(
m.add(~a, level: 0.0);
)
(
~a_insert = { CombL.ar(~a.ar, maxdelaytime: 5.0, delaytime: SinOsc.ar(0.1).range(0.2, 0.205), decaytime: 20.0) };
)
(
~a_azim =  { LFBrownNoise1.ar(4.0, dev: 0.1, dist:2).range(-pi, pi) };
~a_angle = -0.5 * pi;
~a_level.fadeTime = 20.0;
~a_level = 0.2;
)

(

f.thaw(\b_1, \piano_2,  fundamental: Note("D4").freq, rate: 0.01, highHarmonic: 1, lowHarmonic: 1);
f.thaw(\b_2, \piano_2, fundamental: Note("D#4").freq, rate: 0.01, lowHarmonic: 1, highHarmonic: 1);
f.thaw(\b_3, \piano_2, fundamental: Note("F#3").freq, rate: 0.01, lowHarmonic: 1, highHarmonic: 1);
f.thaw(\b_4, \piano_2, fundamental: Note("E3").freq, rate: 0.01, lowHarmonic: 1, highHarmonic: 1);
)
(
~b_transition_speed = { 4 * 4.0 }; // vary between low (eg 4) for smooth sweeps, and eg 4000 for chaos.

~b_delay_detune_speed = { SinOsc.ar(0.1).range(0.2,  0.32) };
~b_delay_detune = { 1 / 1000.0 };

~b_low_harmonic = 2;

//TODO tim this doesn't work (nor above in the a section - do something else and millor que entre mes suau que això)
~b_band_width = { EnvGen.ar(Env.perc(0.0001), Dust.ar(0.25)).range(0, 0) };

~b_high_harmonic = ~b_low_harmonic + ~b_band_width;
~b_low_harmonic <>>.lowHarmonic ~b_1;
~b_low_harmonic <>>.lowHarmonic ~b_2;
~b_low_harmonic <>>.lowHarmonic ~b_3;
~b_low_harmonic <>>.lowHarmonic ~b_4;
~b_high_harmonic <>>.highHarmonic ~b_1;
~b_high_harmonic <>>.highHarmonic ~b_2;
~b_high_harmonic <>>.highHarmonic ~b_3;
~b_high_harmonic <>>.highHarmonic ~b_4;

~b_which = { LFBrownNoise1.ar(~b_transition_speed, dev: 0.1, dist: 2).range(1, 4) };
~b_fade = { LinSelectX.ar(~b_which.ar, [~b_1.ar, ~b_2.ar, ~b_3.ar, ~b_4.ar]) };
~b = { Compander.ar(~b_fade.ar, ~b_fade.ar, thresh: 0.1, slopeBelow: 1.0, slopeAbove: 0.25, mul: 5) };
)
(
m.add(~b, level: 0.0);
);

(
~b_insert = { CombL.ar(~b.ar, maxdelaytime: 5.0, delaytime: 0.66 + (~b_delay_detune * SinOsc.ar(~b_delay_detune_speed)), decaytime: 10.0) };
~b_azim =  { LFBrownNoise1.ar(4.0, dev: 0.1, dist:2).range(-pi, pi) };
~b_angle = 0.5 * pi;
~b_level.fadeTime = 25.0;
~b_level = 1.0;
)


~c_1_level = 0.0;
~beat_c_1_level = 0.0;

~c_2_level = 0.0;
~beat_c_2_level = 0.0;

~c_3_level = 0.0;
~beat_c_3_level = 0.0;

// pause here

~c_0_open_level = 0.0;

// Leave a and b a bit with pedal bass note

~c_0_level = 0

// Leave a and b a bit on their own

~b_level = 0.0 // do this one gradually

// finally a

//then nothing

~a_level = 0
~c_0.set(\lowHarmonic, 2);
~c_0.set(\highHarmonic, 2);
