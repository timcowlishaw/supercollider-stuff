
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

~reverb_mix = 0.1
~reverb_size = 1.0
~reverb_damp = 0.4

~out = { FreeVerb.ar(~mixer_decoded, room: ~reverb_size, damp: ~reverb_damp, mix: ~reverb_mix) }

~out.play


//2 strings bent, unison - high

//Agrega low note

m.add(l.listen(\zero, 5.0), level: 0.0)

~zero_recording = 0.0
~zero_record_mix = -1

~zero_rate = -0.1
~zero_spec_mix = 1.0

~zero_level.fadeTime = 30.0

~zero_level = 0.4





// Melody up and down kinda around the middle of the freboard down wards, on middle two strings


m.add(l.listen(\two, 8.0), level: 0.0)

~two_rate = 0.03

~two_spec_mix = 1

~two_level = 0.1

~two_recording = 0.0

m.add(l.listen(\fx_low, 7.0), level: 0.0)

~fx_low_rate = 0.23

~fx_low_spec_mix = 1

~fx_low_level = 0.2

~fx_low_recording = 0.0

~fx_low_res_freq = { Note("F2").freq }

~fx_low_insert = { XFade2.ar(~fx_low, Resonator.ar(~fx_low, ~fx_low_res_freq, damping: LFNoise2.ar(500).range(0.2, 0.9), structure: LFNoise2.ar(250).range(0.2, 0.4)), SinOsc.kr(0.2).range(0, 1)) }



// nice chord
m.add(l.listen(\chord, 5.0), level: 0.0)

~chord_recording = 0.0
~chord_record_mix = -1

~chord_rate = -0.1
~chord_spec_mix = 1.0

~chord_level.fadeTime = 30.0

~chord_level = 0.4

~zero_level = 0.0
~fx_low_level = 0.0
~two_level = 0.0


// sympathetic high arhyrhmic picking, layered
m.add(l.listen(\three, 10.0), level: 0.6)

~three_level = 0.2

~three_grain_mix = { SinOsc.ar(0.1).range(-1, 0) }
~three_spec_mix = 0.4
~three_rate = { SinOsc.ar(0.001).range(0.33, 0.75) }
~three_grain_rate = { 1 + (LFNoise2.kr(500) * 0.2) }
~three_grain_duration = { SinOsc.kr(0.25).range(0.01, 0.1) }
~three_grain_pos_randomness = 100.0;
~three_grain_trigs = { Dust.kr(SinOsc.ar(0.3).range(1.0, 5.0)) }

~three_record_mix = -0.5
~three_recording = 0

~three_level = 0.0

~three_res_freq = { Note("A4").freq }

~three_insert = { XFade2.ar(~three, Resonator.ar(~three, ~three_res_freq, damping: LFNoise2.ar(500).range(0.2, 0.9), structure: LFNoise2.ar(250).range(0.2, 0.4)), SinOsc.kr(0.2).range(-1, -0.75)) }


~chord_level = 0.0


~zero_level = 0.3

~fx_low_level = 0.2


~three_level = 0.0

m.add(l.listen(\four, 12.0), level: 1.0)

~four_recording = 0

~four_record_mix = 0

~zero_level = 0.0
~two_level = 0.0

~four_level.fadeTime = 40

~four_level = 0.25
~four_spec_mix = { Saw.ar(500).range(0.5, SinOsc.ar(0.33).range(0.5, 1)) }
~four_rate =   { LFNoise2.ar(500).range(-1, 1) }

~saw_range = { LFNoise2.ar(239).range(20, 20) }

~saw_mix = { SinOsc.ar(0.1).range(0.0, 0.0) }

~four_insert = { CombL.ar(~four.ar * ((1-~saw_mix) + Saw.ar(LFNoise2.ar(500).range(20, ~saw_range), ~saw_mix)), 10.0, 0.77, 5.0) }

~saw_freq = { LFNoise2.ar(40).range(10, 15) }

~saw_ampl = { LFTri.ar(0.1).range(0.2, 0.4) }

~zero_level = 0.0

~chord_level = 0.3

~fx_low_level = 0.0


~four_level = 0.0

m.printLevels()

~chord_insert = { LFTri.ar(SinOsc.ar(0.01).range(3.0, 4.0)) * ~chord }

~chord_rate = { LFNoise2.ar(500).range(-0.5, 0.5) }

~chord_recording = 0.0

~chord_recording = 0.0
~chord_record_mix = 0.5

q = ()

MIDIClient.init;

MIDIIn.connectAll;


(
var midiReceive;
  midiReceive = MIDIFunc.cc ({ |value, ccNum, chan, src|
    [value, ccNum, chan, src].postln;
    ~zero_level = (value / 127.0).range(0.0, 1.0)
}, ccNum: 1, chan: 0);

)

(
var midiReceive;
  midiReceive = MIDIFunc.cc ({ |value, ccNum, chan, src|
    [value, ccNum, chan, src].postln;
    ~fx_low_level = (value / 127.0).range(0.0, 1.0)
}, ccNum: 2, chan: 0);

)

(
var midiReceive;
  midiReceive = MIDIFunc.cc ({ |value, ccNum, chan, src|
    [value, ccNum, chan, src].postln;
    ~two_level = (value / 127.0).range(0.0, 1.0)
}, ccNum: 3, chan: 0);

)

(
var midiReceive;
  midiReceive = MIDIFunc.cc ({ |value, ccNum, chan, src|
    [value, ccNum, chan, src].postln;
    ~three_level = (value / 127.0).range(0, 1.0)
}, ccNum: 4, chan: 0);

)

(
var midiReceive;
  midiReceive = MIDIFunc.cc ({ |value, ccNum, chan, src|
    var fadeTime;
    [value, ccNum, chan, src].postln;
    fadeTime = ~chord_level.fadeTime;
    ~chord_level.fadeTime = 0;
    ~chord_level = (value / 127.0).range(0.0, 1.0);
    ~chord_level.fadeTime = fadeTime;
}, ccNum: 5, chan: 0);

)

(
var midiReceive;
  midiReceive = MIDIFunc.cc ({ |value, ccNum, chan, src|
    [value, ccNum, chan, src].postln;
    ~four_level = (value / 127.0).range(0.0, 1.0)
}, ccNum: 6, chan: 0);

)
q.midiReceive

m.add(l.listen(\five, 4.0), level: 1.0)

~five_spec_mix = { SinOsc.ar(0.2).range(0.5, 1) }

~five_rate = { LFNoise2.ar(500).range(-1, 1) }

~five_insert = { XFade2.ar(LFTri.ar(SinOsc.ar(0.1).range(3.0, 5.0)) * ~five, ~five, SinOsc.ar(0.15).range(-0.5, 5.0)) }

~five_recording = 0.0



