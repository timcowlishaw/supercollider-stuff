q = ();
p = ProxySpace().push(s.boot);
f = Freezer2.new(s, p);


m = FOAMixer.new(s, p, q, maxLevel:5.0, defaultLevel: 0.7, defaultFb: 0.7, defaultFadeTime: 4.0);

~foa_mixer_master_fader = 5.0;

d = FoaDecoderMatrix.newPanto(2)
~mixer_decoded = { FoaDecode.ar(m.bus.ar, d) };

~reverb_mix = 0.3
~reverb_size = 0.4
~reverb_damp = 0.7

~out = { FreeVerb.ar(~mixer_decoded, room: ~reverb_size, damp: ~reverb_damp, mix: ~reverb_mix) }

~out.play

//f.load(\piano_1, "/home/tim/Documents/REAPER Media/rachmaninof-001.wav")
//f.load(\piano_2, "/home/tim/Documents/REAPER Media/rachmaninof-002.wav")
//f.load(\piano_3, "/home/tim/Documents/REAPER Media/rachmaninof-003.wav")

f.freeze(\piano_1, 1.837) // Tres corcheras, negra = 49BPM
f.freeze(\piano_2, 2.448) // Un compas de 4/4, negra = 98BPM
f.freeze(\piano_3, 4.21) // Un compas de 4/4, negra = 57BPM

// TIM CO

// and let the fundametnal slowly fade in.
m.add(f.thaw(\c_2, \piano_3,  fundamental: Note("C#2").freq, rate: 0.007, highHarmonic: 4, lowHarmonic: 4), level: 0.0)
~c_2_level.fadeTime=20.0
~c_2_level = 4.0

//high harmonic of final sustained note, bring in under maia
m.add(f.thaw(\c_1, \piano_3,  fundamental: Note("C#2").freq, rate: 0.0088, highHarmonic: 8, lowHarmonic: 8), level: 0.1)

//gradually open downwards, by steps
// and subir nivell
~c_1_level.fadeTime = 10.0
~c_1_level = 4.0


//high harmonic of final sustained note, bring in under maia
m.add(f.thaw(\c_3, \piano_3,  fundamental: Note("C#2").freq, rate: 0.093, highHarmonic: 6, lowHarmonic: 6), level: 0.1)

//gradually open downwards, by steps
// and subir nivell
~c_3_level.fadeTime = 10.0
~c_3_level = 3.0

~beat_c_3 = { PitchShift.ar(~c_3, ratio: 1.001) }
m.add(~beat_c_3, level: 0.0)
~beat_c_3_level.fadeTime = 10.0
~beat_c_3_level = 4.0

~beat_c_1 = { PitchShift.ar(~c_1, ratio: 1.002) }
m.add(~beat_c_1, level: 0.0)
~beat_c_1_level.fadeTime = 10.0
~beat_c_1_level = 4.0


~beat_c_2 = { PitchShift.ar(~c_2, ratio: 1.005) }
m.add(~beat_c_2, level: 0.0)
~beat_c_2_level.fadeTime = 10.0
~beat_c_2_level = 4.0

//high harmonic of final sustained note, bring in under maia
m.add(f.thaw(\c_4, \piano_3,  fundamental: Note("C#2").freq, rate: 0.093, highHarmonic: 2, lowHarmonic: 2), level: 0.1)

~c_4_level.fadeTime = 10.0
~c_4_level = 3.0



m.add(f.thaw(\a_1, \piano_1,  fundamental: Note("G#3").freq, rate: 0.008, highHarmonic: 3, lowHarmonic: 3), level: 0.0)


~a_1_level.fadeTime = 30.0
~a_1_level = 4.0



// start modulating harmonics
//~a_1_low_harm = { Pulse.ar(LFNoise2.ar(500).range(5.0, 10.0)).range(5, 8) }
//~a_1_low_harm <>>.lowHarmonic ~a_1

//~a_1.set(\fundamental,  Note("G#3").freq)



m.add(f.thaw(\a_2, \piano_1,  fundamental: Note("F#3").freq, rate: 0.07, highHarmonic: 5, lowHarmonic: 5), level: 0.0)

~a_2_level.fadeTime = 30.0
~a_2_level = 4.0


// REPLACE WITH XFADED VERSION
~a_2_level = 0.0
~a_1_level = 0.0
~a_x_fade_fader = { SinOsc.ar(LFNoise2.ar(500).range(2.0, 3.2)) }
~a_x_fade = { XFade2.ar(~a_1, ~a_2, ~a_x_fade_fader)}
~a_x_fade_insert = { CombL.ar(~a_x_fade.ar, maxdelaytime: 5.0, delaytime: SinOsc.ar(0.1).range(0.2, 0.205), decaytime: 20.0) }
m.add(~a_x_fade)

~a_x_fade_level = 3.0



m.add(f.thaw(\c_5, \piano_3,  fundamental: Note("C#3").freq, rate: 0.093, highHarmonic: 10, lowHarmonic: 10), level: 0.1)
~c_5_level.fadeTime = 20.0
~c_5_level = 5.0

~c_4.set(\lowHarmonic, 2)

m.add(f.thaw(\c_4_open, \piano_3,  fundamental: Note("C#2").freq, rate: 0.093, highHarmonic: 3, lowHarmonic: 1), level: 0.1)
~c_4_open.fadeTime = 10.0
~c_4_open_level = { SinOsc.ar(0.08).range(0.0, 4.0) }

~beat_c_5 = { PitchShift.ar(~c_5, ratio: 1.007) }
m.add(~beat_c_5)
~beat_c_5_level.fadeTime = 20.0
~beat_c_5_level = 5.0


// First rhythmical material, higher
~c_1_rhyth = { ~c_1 * Saw.ar(LFNoise2.kr(293).range(3.0, 7.0)) } // as below: something with Choice to make the rhythmic shifts more rhythmical
m.add(~c_1_rhyth, level: 0.0)
~c_1_rhyth_level.fadeTime = 60.0
~c_1_rhyth_level = 1.0
~c_1_rhyth_insert = { CombL.ar(~c_1_rhyth.ar, maxdelaytime: 2.0, delaytime: 0.07, decaytime: 1.2, mul: 1.0) }
~c_1_rhyth_level = { SinOsc.ar(0.15).range(0.2, 1.0) }

// Second rhythmial material, lower
~c_2_rhyth = { ~c_2 * Saw.ar(LFNoise2.kr(500).range(0.1, 40.0)) } // do something with Choice here, make it double /half speed as well as subtle random shiftingº
m.add(~c_2_rhyth, level: 0.0)
~c_2_rhyth_level.fadeTime = 60.0
~c_2_rhyth_level = 0.6
~c_2_rhyth_insert = { CombL.ar(~c_2_rhyth.ar, maxdelaytime: 2.0, delaytime: 0.15, decaytime: 1.2, mul: 1.0) }
~c_2.set(\fundamental, Note("C#3").freq) // sounds fuller? How to get here "naturally"?
~c_2_rhyth_level = { SinOsc.ar(0.22).range(0.33, 1.5) }


// Some dischords
f.thaw(\b_1, \piano_2,  fundamental: Note("D4").freq, rate: 0.01, highHarmonic: 1, lowHarmonic: 1)
f.thaw(\b_2, \piano_2, fundamental: Note("D#4").freq, rate: 0.01, lowHarmonic: 1, highHarmonic: 1)
f.thaw(\b_3, \piano_2, fundamental: Note("F#3").freq, rate: 0.01, lowHarmonic: 1, highHarmonic: 1)
f.thaw(\b_4, \piano_2, fundamental: Note("E3").freq, rate: 0.01, lowHarmonic: 1, highHarmonic: 1)

// WHAT DO THESE DO TIM? EXperiment
//~b_harm_mod_1_rate = { 0.5 }
//~b_harm_mod_2_rate = { 0.33 }


//~b_low_range_low = { 1 }
//~b_low_range_high = { ~b_low_range_low + 2 }

//~b_high_range_low = { ~b_low_range_high  + 3 }
//~b_high_range_high = { ~b_high_range_low + 1 }

~b_transition_speed = { 1 * 4.0 } // vary between low (eg 4) for smooth sweeps, and eg 4000 for chaos.

~b_delay_detune_speed = { SinOsc.ar(0.1).range(0.21, 0.32) }
~b_delay_detune = { 1 / 10 }


//~b_low_1 = { SinOsc.ar(~b_harm_mod_1_rate).range(~b_low_range_low, ~b_low_range_high) }
//~b_low_2 = { SinOsc.ar(~b_harm_mod_2_rate).range(~b_low_range_low, ~b_low_range_high) }
//
//~b_high_1 = { SinOsc.ar(~b_harm_mod_1_rate).range(~b_high_range_low, ~b_high_range_high) }
//~b_high_2 = { SinOsc.ar(~b_harm_mod_2_rate).range(~b_high_range_low, ~b_high_raage_high) }
//
//~b_low_1 <>>.lowHarmonic ~b_1
//~b_low_2 <>>.lowHarmonic ~b_2
//~b_low_1 <>>.lowHarmonic ~b_3
//~b_low_2 <>>.lowHarmonic ~b_4
//
//~b_high_1 <>>.highHarmonic ~b_1
//~b_high_2 <>>.highHarmonic ~b_2
//~b_high_1 <>>.highHarmonic ~b_3
//~b_high_2 <>>.highHarmonic ~b_4


~b_which = { LFBrownNoise1.ar(~b_transition_speed, 0.1, 2, mul: 3, add: 0) }
~b = { LinSelectX.ar(~b_which.ar, [~b_1.ar, ~b_2.ar, ~b_3.ar, ~b_4.ar]) }
~b_insert = { CombL.ar(~b.ar, maxdelaytime: 5.0, delaytime: 0.66 + (~b_delay_detune * SinOsc.ar(~b_delay_detune_speed)), decaytime: 10.0) }

m.add(~b)

~b_level = 0.0

~c_1_level = 4.0
~beat_c_1_level = 4.0

~c_2_level = 4.0
~beat_c_2_level = 4.0

~c_3_level = 4.0
~beat_c_3_level = 4.0

// Fade everything except the dischords
~a_x_fade_level.fadeTime = 30.0
~a_x_fade_level = 0.0

~c_4_level = 0.0

~c_1_rhyth_level = 0.0
~c_2_rhyth_level = 0.0


// Bring in the low drone to end

~c_4_level = 4.0


// bring out dischords
~b_level.fadeTime = 20.0
~b_level = 0.0


// bring out low drone
~c_4.set(\lowHarmonic, 2) // work out how to do this gradually
~c_4_level = 0.0

~beat_c_4 = { PitchShift.ar(~c_4, ratio: 1.02) }
m.add(~beat_c_4, level: 0.9)
~beat_c_4_level = 0.0
~sub_c_4_ = { PitchShift.ar(~c_4, ratio: 0.5) }
m.add(~sub_c_4, level: 3.0)
~sub_c_4_level = 0.0

//emergency
~foa_mixer_master_fader.fadeTime = 0.0
~foa_mixer_master_fader = 0.0
m.printLevels()
