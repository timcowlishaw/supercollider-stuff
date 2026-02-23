
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

~reverb_mix = 0.6
~reverb_size = 1.0
~reverb_damp = 0.4

~out = { FreeVerb.ar(~mixer_decoded, room: ~reverb_size, damp: ~reverb_damp, mix: ~reverb_mix) }

~out.play

// TAPS WITH DESTORNILLADOR, 3 positiones
m.add(l.listen(\zero, 18.0))

~zero_recording = 0

~zero_rate = -0.33
~zero_spec_mix = 1.0

~zero_level = 2.0

//PING! and behind bridge
m.add(l.listen(\one, 10.0))

~one_recording = 0;

~one_spec_mix.fadeTime = 25;

~one_rate = -0.25;

// AFTER A FEW LOOPS.

~one_level = 3.0;


~one_spec_mix = -1;



// Free, melodic
m.add(l.listen(\two, 13.0), level: 0.0)


~two_recording = 0;
~two_rate = 0.08;
~rhythm_1 = { SinOsc.ar(0.3).range(0.0, 0.7) * Saw.ar(LFNoise1.ar(500).range(2.0, 10.0)) * ~two_spec_playback }
m.add(~rhythm_1, level: 0.0)
~rhythm_1_level.fadeTime = 30.0
~rhythm_1_level = 2.0


~two_level.fadeTime = 10.0
~two_level = 2.0


// Free, noisy
m.add(l.listen(\three, 18.0), level: 3.0)

~three_recording = 0

~three_grain_density = { SinOsc.ar(10.0).range(0.0, 50.0) }
~three_grain_mix = 1.0
~three_grain_duration = { LFNoise2.ar(500).range(0.05, 0.07) }

~three_grain_pos_randomness = { SinOsc.ar(15.0).range(0.5, 1.3) }

~three_level = 0.7

~three_spec_mix = -0.5

~three_rate = { LFNoise2.ar(500).range(0.05, 0.5) }

// TRANSITION TO SECOND MVMT.

~rhythm_1_level = 0.0;

~two_level = 0.0;

~one_spec_mix = 1;

~three_level.fadeTime = 12.5;
~three_level = 0.4


// Hold for a bit.


// MY DISCO / Shellac type riff
m.add(l.listen(\four, 15.0))

~four_recording = 0 ;

// Hold for a bit.

~rhythm_1_level = 0.5

~one_spec_mix = -0.2

~three_level = 0.2


//Harmonics on 7 and 12
m.add(l.listen(\five, 8.5))

~five_recording = 0

~four_level.fadeTime = 20.0
~four_level = 0.0


~five_spec_mix.fadeTime = 15.0;
~five_rate = 0.05;
~five_spec_mix = 0.5;


//DOOM. FUZZ and fade in with pedal. Open then D4 at 12 with bend.
m.add(l.listen(\six, 12.5), level: 0.4)

~six_recording = 0

~six_spec_mix.fadeTime = 20.0


~six_rate = -0.45
~six_spec_mix = 0.0

~one_spec_mix = 1.0

~rhythm_1_level = 0.0;

~three_level = 0.0;

~five_spec_mix = 1.0;

~one_rate = 0.0;

~one_spec_mix = -1.0;



~five_level = 0.0;


~six_level = 0.0

~zero_level = 0.0;

// Let the first theme come back before fading.

~one_level = 0.0;


// NOT THIS TILL LATER!

~wicker_man = { SinOsc.ar(8.0).range(0.0, 1.0) * (SinOsc.ar(Note("E2").freq) + LPF.ar((0.6 + LFNoise2.ar(398).range(-0.4, 0.4)) * Saw.ar([Note("E3").freq, Note("B3").freq, Note("E4").freq, Note("B4").freq]), SinOsc.ar(0.1).range(1000, 2000))) };

m.add(~wicker_man)

~wicker_man_level = 0.0

