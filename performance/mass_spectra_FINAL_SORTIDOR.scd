//First, the setup:
(
q = ();
p = ProxySpace().push(s.boot);
f = Freezer2.new(s, p);


m = FOAMixer.new(s, p, q, maxLevel:5.0, defaultLevel: 0.7, defaultFb: 0.7, defaultFadeTime: 4.0);

~foa_mixer_master_fader = 5.0;

d = FoaDecoderMatrix.newPanto(2);
~mixer_decoded = { FoaDecode.ar(m.bus.ar, d) };
)


//THIS IS IN THREE PARTS NOW! Now the effects bus params
(
~reverb_mix = 0.3;
~reverb_size = 0.4;
~reverb_damp = 0.7;

~comp_thresh = 0.06;
~comp_ratio = 1/8.0;
~comp_makeup=4;
)


//NOW THE OUTPUT
(
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
~foa_mixer_master_fader = 8.0;
~foa_mixer_master_fader.fadeTime = 3.0;

// Compás 4
f.freeze(\piano_1, 1.837); // Tres corcheras, negra = 49BPM - 3º motivo principal mano derecha
// Compás 15
f.freeze(\piano_2, 2.448); // Un compas de 4/4, negra = 98BPM, 2º compas motvo cromático

// Compás 58
f.freeze(\piano_3, 4.21); // Un compas de 4/4, negra = 57BPM, 4º acorde del final


// FOR PRACTICE ONLY
//f.load(\piano_1, "/home/tim/Documents/REAPER Media/rachmaninof-001.wav");
//f.load(\piano_2, "/home/tim/Documents/REAPER Media/rachmaninof-002.wav");
//f.load(\piano_3, "/home/tim/Documents/REAPER Media/rachmaninof-003.wav");


q.initial_level = 2.4;

//TIME 0.00
(
q.c_1_rate = 0.007;
q.c_1_harmonic = 4;
q.c_1_freq =  Note("C#2").freq;
q.c_1_fade_time = 10.0;
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
~c_1_lfo_depth = 0.0;
~c_1_lfo_depth.fadeTime = 3.0;
~c_1_lfo_speed = 3;
~c_1_lfo_speed.fadeTime = 5.0;
)

~c_1_insert = { CombL.ar(~c_1.ar * SinOsc.ar(~c_1_lfo_speed).range(1.0 - ~c_1_lfo_depth, 1.0), maxdelaytime: 5.0, delaytime: 0.5, decaytime: 5.0)}


~c_1_level = q.initial_level;

~c_1_level.fadeTime=q.c_1_fade_time;

// Move it around a bit
//randomise dist 0-5 and freq a bit.
(
~c_1_azim =  { LFBrownNoise1.ar(40.0, dev: 0.1, dist:2).range(-pi, pi) };
~c_1_angle = -0.5 * pi;
)

(
~beat_c_1 = { PitchShift.ar(~c_1, pitchRatio: 1.005) };
m.add(~beat_c_1, level: 0.0);
~beat_c_1_level.fadeTime = 10.0;
~beat_c_1_level = q.initial_level;
~beat_c_1_angle = ~c_1_angle;
~beat_c_1_azim = ~c_1_azim;
)

(
q.a_1_rate = 0.088;
q.a_1_harmonic = 8;
q.a_1_fade_time = 20.0;
q.a_1_freq =  Note("C#2").freq;
m.add(
  f.thaw(\a_1, \piano_1,
    fundamental: q.a_1_freq,
    rate: q.a_1_rate,
    highHarmonic: q.a_1_harmonic,
    lowHarmonic: q.a_1_harmonic
  ),
  level: 0.0);
)

(
~a_1_lfo_depth = 0.0;
~a_1_lfo_depth.fadeTime = 3.0;
~a_1_lfo_speed = 5;
~a_1_lfo_speed.fadeTime = 5.0;
)

~a_1_insert = { CombL.ar(~a_1.ar * SinOsc.ar(~a_1_lfo_speed).range(1.0 - ~a_1_lfo_depth, 1.0), maxdelaytime: 5.0, delaytime: 0.33, decaytime: 10.0)}
~a_1_level.fadeTime=q.a_1_fade_time;
~a_1_level = q.initial_level;


(
~a_1_azim =  { LFBrownNoise1.ar(40.0, dev: 0.1, dist:2).range(-pi, pi) };
~a_1_angle = -0.5 * pi;
)


(
~beat_a_1 = { PitchShift.ar(~a_1, pitchRatio: 1.0023) };
m.add(~beat_a_1, level: 0.0);
~beat_a_1_level.fadeTime = 10.0;
~beat_a_1_level = q.initial_level;
~beat_a_1_angle = ~a_1_angle;
~beat_a_1_azim = ~a_1_azim;
)

(
q.b_1_rate = 0.093;
q.b_1_harmonic = 6;
q.b_1_fade_time = 25.0;
q.b_1_freq =  Note("C#2").freq;
m.add(
  f.thaw(\b_1, \piano_2,
    fundamental: q.b_1_freq,
    rate: q.b_1_rate,
    highHarmonic: q.b_1_harmonic,
    lowHarmonic: q.b_1_harmonic
  ),
  level: 0.0);
)

(
~b_1_lfo_depth = 0.0;
~b_1_lfo_depth.fadeTime = 3.0;
~b_1_lfo_speed = 2;
~b_1_lfo_speed.fadeTime = 5.0;
)


~b_1_insert = { CombL.ar(~b_1.ar * SinOsc.ar(~b_1_lfo_speed).range(1.0 - ~b_1_lfo_depth, 1.0), maxdelaytime: 5.0, delaytime: 0.243, decaytime: 10.0)}

~b_1_level.fadeTime=q.b_1_fade_time;

~b_1_level = q.initial_level;


(
~b_1_azim =  { LFBrownNoise1.ar(40.0, dev: 0.1, dist:2).range(-pi, pi) };
~b_1_angle = -0.5 * pi;
)


(
~beat_b_1 = { PitchShift.ar(~b_1, pitchRatio: 1.0044) };
m.add(~beat_b_1, level: 0.0);
~beat_b_1_level.fadeTime = 10.0;
~beat_b_1_level = q.initial_level;
~beat_b_1_angle = ~b_1_angle;
~beat_b_1_azim = ~b_1_azim;
)

// WAIT FOR FADE IN

~b_1.set(\highHarmonic, 7); ~b_1.set(\lowHarmonic, 7)

~b_1.set(\highHarmonic, 9); ~b_1.set(\lowHarmonic, 9)

~a_1.set(\highHarmonic, 11); ~a_1.set(\lowHarmonic, 11)

~a_1.set(\highHarmonic, 13); ~a_1.set(\lowHarmonic, 13)


~c_1_lfo_depth =  0.2
~a_1_lfo_depth = 0.5
~b_1_lfo_depth = 0.3

~a_1.set(\highHarmonic, 8); ~a_1.set(\lowHarmonic, 8)

~b_1.set(\highHarmonic, 6); ~b_1.set(\lowHarmonic, 6)


// TIME 3.30


(
m.add(
  f.thaw(\c_0, \piano_3,
    fundamental: Note("C#2").freq,
    rate: 0.02, highHarmonic: 2, lowHarmonic: 2
  ), level: 0.0);
)

(
~c_0_insert = { ~c_0 * LFNoise2.ar(SinOsc.ar(0.3).range(219, 304)).range(0.2, 0.8) };
~c_0_level.fadeTime = 20.0;
~c_0_level = 2.0;

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
~c_0_open_insert = { LPF.ar(~c_0_open * SinOsc.ar(0.08).range(0.0, 0.25), freq: Note("G#3").freq) };
~c_0_open_level.fadeTime = 30.0;
~c_0_open_level = 3.0;
)


//"C#2", "D#2", "E2", 6, 7, 9 , 11, 4
~b_1_transition_prob = { 0.2 }
~b_1_fundamental = { TChoose.kr(Dust.kr(~b_1_transition_prob), ["C#2"].collect {|note| Note(note).freq} ) }
~b_1_fundamental <>>.fundamental ~b_1
~b_1_harmonic = { TChoose.kr(Dust.kr(~b_1_transition_prob), [6]) }
~b_1_harmonic <>>.highHarmonic ~b_1
~b_1_harmonic <>>.lowHarmonic ~b_1

//"G#2", "F#2", "E2", 7, 8
~a_1_transition_prob = { 0.6 }
~a_1_fundamental = { TChoose.kr(Dust.kr(~a_1_transition_prob), ["C#2"].collect {|note| Note(note).freq} ) }
~a_1_fundamental <>>.fundamental ~a_1
~a_1_harmonic = { TChoose.kr(Dust.kr(~a_1_transition_prob), [8]) }
~a_1_harmonic <>>.highHarmonic ~a_1
~a_1_harmonic <>>.lowHarmonic ~a_1

// C#2, F#2, A#2, 4, 6
~c_1_transition_prob = { 0.09 }
~c_1_fundamental = { TChoose.kr(Dust.kr(~c_1_transition_prob), ["C#2"].collect {|note| Note(note).freq} ) }
~c_1_fundamental <>>.fundamental ~c_1
~c_1_harmonic = { TChoose.kr(Dust.kr(~c_1_transition_prob), [4]) }
~c_1_harmonic <>>.highHarmonic ~c_1
~c_1_harmonic <>>.lowHarmonic ~c_1

~c_0_open_level = 1.3


~c_1_lfo_speed = { SinOsc.ar(0.1).range(2, 5) }
~a_1_lfo_speed = { SinOsc.ar(0.33).range(3, 10) }
~b_1_lfo_speed = { SinOsc.ar(0.25).range(1, 8) }

~c_1_lfo_depth = 0.6
~b_1_lfo_depth = 0.6
~a_1_lfo_depth = 0.6

~c_1_lfo_depth = 0.0
~b_1_lfo_depth = 0.0
~a_1_lfo_depth = 0.0

// Later, start fading out the original notes:

~c_1_level = 0.0;
~beat_c_1_level = 0.0;

~a_1_level = 0.0;
~beat_a_1_level = 0.0;

~b_1_level = 0.0;
~beat_b_1_level = 0.0;

// pause here

~c_0_level = 0.0;

~c_0_open_level = 0.0;


