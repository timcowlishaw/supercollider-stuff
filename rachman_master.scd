q = ();
p = ProxySpace().push(s.boot);
f = Freezer2.new(s, p);


m = FOAMixer.new(s, p, q, maxLevel:5.0, defaultLevel: 0.7, defaultFb: 0.7, defaultFadeTime: 4.0);

~foa_mixer_master_fader = 10.0;

d = FoaDecoderMatrix.newPanto(2)
~mixer_decoded = { FoaDecode.ar(m.bus.ar, d) };

~reverb_mix = 0.0
~reverb_size = 0.4
~reverb_damp = 0.7

~out = { FreeVerb.ar(~mixer_decoded, room: ~reverb_size, damp: ~reverb_damp, mix: ~reverb_mix) }

~out.play

//f.load(\piano_1, "/home/tim/Documents/REAPER Media/rachmaninof-001.wav")
//f.load(\piano_2, "/home/tim/Documents/REAPER Media/rachmaninof-002.wav")
//f.load(\piano_3, "/home/tim/Documents/REAPER Media/rachmaninof-003.wav")

f.freeze(\piano_1, 3.0)
f.freeze(\piano_2, 5.0)
f.freeze(\piano_3, 7.2)



//high harmonic of final sustained note, bring in under maia
m.add(f.thaw(\c_1, \piano_3,  fundamental: Note("C#2").freq, rate: 0.0088, highHarmonic: 9, lowHarmonic: 5), level: 1.0)

//gradually open downwards, by steps
~c_1.set(\lowHarmonic, 4)

~c_1.set(\lowHarmonic,  3)

~c_1.set(\lowHarmonic, 2)

// and let the fundametnal slowly fade in.
m.add(f.thaw(\c_2, \piano_3,  fundamental: Note("C#2").freq, rate: 0.007, highHarmonic: 3, lowHarmonic: 1), level: 0.0)
~c_2_level.fadeTime=20.0
~c_2_level = 1.0



m.add(f.thaw(\a_1, \piano_1,  fundamental: Note("F#3").freq, rate: 0.008, highHarmonic: 10, lowHarmonic: 8), level: 0.0)


~a_1_level.fadeTime = 30.0
~a_1_level = 1.0

// start modulating harmonics
~a_1_low_harm = { Pulse.ar(LFNoise2.ar(500).range(5.0, 10.0)).range(2, 7) }
~a_1_low_harm <>>.lowHarmonic ~a_1

~a_1.set(\fundamental,  Note("G#3").freq)



m.add(f.thaw(\a_2, \piano_1,  fundamental: Note("F#3").freq, rate: 0.07, highHarmonic: 5, lowHarmonic: 1), level: 0.0)

~a_2_level.fadeTime = 30.0
~a_2_level = 1.0


// REPLACE WITH XFADED VERSION
~a_2_level = 0.0
~a_1_level = 0.0
~a_x_fade_fader = { SinOsc.ar(LFNoise2.ar(500).range(2.0, 3.2)) }
~a_x_fade = { XFade2.ar(~a_1, ~a_2, ~a_x_fade_fader)}
~a_x_fade_insert = { CombL.ar(~a_x_fade.ar, maxdelaytime: 5.0, delaytime: SinOsc.ar(0.1).range(0.2, 0.205), decaytime: 20.0) }
m.add(~a_x_fade)

// First rhythmical material, higher
~c_1_rhyth = { ~c_1 * Saw.ar(LFNoise2.kr(293).range(3.0, 7.0)) } // as below: something with Choice to make the rhythmic shifts more rhythmical
m.add(~c_1_rhyth, level: 0.0)
~c_1_rhyth_level.fadeTime = 60.0
~c_1_rhyth_level = 1.0
~c_1_rhyth_insert = { CombL.ar(~c_1_rhyth.ar, maxdelaytime: 2.0, delaytime: 0.07, decaytime: 1.2, mul: 1.0) }
~c_1_rhyth_level = { SinOsc.ar(0.15).range(0.2, 1.0) }

// Second rhythmial material, lower
~c_2_rhyth = { ~c_2 * Saw.ar(LFNoise2.kr(500).range(0.1, 3.0)) } // do something with Choice here, make it double /half speed as well as subtle random shiftingº
m.add(~c_2_rhyth, level: 0.0)
~c_2_rhyth_level.fadeTime = 60.0
~c_2_rhyth_level = 1.0
~c_2_rhyth_insert = { CombL.ar(~c_2_rhyth.ar, maxdelaytime: 2.0, delaytime: 0.15, decaytime: 1.2, mul: 1.0) }
~c_2.set(\fundamental, Note("C#3").freq) // sounds fuller? How to get here "naturally"?
~c_2_rhyth_level = { SinOsc.ar(0.22).range(0.33, 1.5) }


// Some dischords
f.thaw(\b_1, \piano_2,  fundamental: Note("D4").freq, rate: 0.01, highHarmonic: 5, lowHarmonic: 1)
f.thaw(\b_2, \piano_2, fundamental: Note("D#4").freq, rate: 0.01, lowHarmonic: 5, highHarmonic: 11)
f.thaw(\b_3, \piano_2, fundamental: Note("F#3").freq, rate: 0.01, lowHarmonic: 3, highHarmonic: 17)
f.thaw(\b_4, \piano_2, fundamental: Note("E3").freq, rate: 0.01, lowHarmonic: 1, highHarmonic: 9)

~b_harm_mod_1_rate = { 0.2 }
~b_harm_mod_2_rate = { 0.33 }

~b_low_range_low = { 1 }
~b_low_range_high = { ~b_low_range_low + 5 }

~b_high_range_low = { ~b_low_range_high  + 4 }
~b_high_range_high = { ~b_high_range_low + 8 }

~b_transition_speed = { 1 * 4.0 }

~b_delay_detune_speed = { SinOsc.ar(0.1).range(0.21, 0.32) }
~b_delay_detune = { 1 / 1000 }


~b_low_1 = { SinOsc.ar(~b_harm_mod_1_rate).range(~b_low_range_low, ~b_low_range_high) }
~b_low_2 = { SinOsc.ar(~b_harm_mod_2_rate).range(~b_low_range_low, ~b_low_range_high) }

~b_high_1 = { SinOsc.ar(~b_harm_mod_1_rate).range(~b_high_range_low, ~b_high_range_high) }
~b_high_2 = { SinOsc.ar(~b_harm_mod_2_rate).range(~b_high_range_low, ~b_high_raage_high) }

~b_low_1 <>>.lowHarmonic ~b_1
~b_low_2 <>>.lowHarmonic ~b_2
~b_low_1 <>>.lowHarmonic ~b_3
~b_low_2 <>>.lowHarmonic ~b_4

~b_high_1 <>>.highHarmonic ~b_1
~b_high_2 <>>.highHarmonic ~b_2
~b_high_1 <>>.highHarmonic ~b_3
~b_high_2 <>>.highHarmonic ~b_4



~b_which = { LFBrownNoise1.ar(~b_transition_speed, 0.1, 2, mul: 3, add: 0) }
~b = { LinSelectX.ar(~b_which.ar, [~b_1.ar, ~b_2.ar, ~b_3.ar, ~b_4.ar]) }
~b_insert = { CombL.ar(~b.ar, maxdelaytime: 5.0, delaytime: 0.66 + (~b_delay_detune * SinOsc.ar(~b_delay_detune_speed)), decaytime: 10.0) }

m.add(~b)


// Fade everything except the dischords
~a_x_fade_level.fadeTime = 30.0
~a_x_fade_level = 0.0

~c_1_level = 0.0
~c_2_level = 0.0

~c_1_rhyth_level = 0.0
~c_2_rhyth_level = 0.0


// Bring in the low drone to end

~c_2_level = 4.0


// bring out dischords
~b_level.fadeTime = 20.0
~b_level = 0.0


// bring out low drone
~c_2_level = 0.0

//emergency
~foa_mixer_master_fader.fadeTime = 0.0
~foa_mixer_master_fader = 10.0¡

m.printLevels()
