q = ();
p = ProxySpace().push(s.boot);
f = Freezer2.new(s, p);
l = LoopStation.new(s, p, q, fftSize:16384, hop: 0.25, win: 1, recFadeTime:0.1, defaultFadeTime: 2.0);
m = FOAMixer.new(s, p, q, maxLevel:5.0, defaultLevel: 0.7, defaultFb: 0.7, defaultFadeTime: 4.0);

~foa_mixer_master_fader = 10.0;

d = FoaDecoderMatrix.newPanto(2)
~mixer_decoded = { FoaDecode.ar(m.bus.ar, d) };

~reverb_mix = 0.2
~reverb_size = 0.4
~reverb_damp = 0.7

~out = { FreeVerb.ar(~mixer_decoded, room: ~reverb_size, damp: ~reverb_damp, mix: ~reverb_mix) }

~out.play


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


m.add(l.load(\high_chords, "/home/tim/Documents/REAPER Media/guitar thing 080425/guitar thing 080425-001.wav"), level: 0.0)
m.add(l.load(\low_chords, "/home/tim/Documents/REAPER Media/guitar thing 080425/guitar thing 080425-002.wav"), level: 0.0)
m.add(l.load(\ebow, "/home/tim/Documents/REAPER Media/guitar thing 080425/guitar thing 080425-003.wav"), level: 0.0)
m.add(l.load(\bow, "/home/tim/Documents/REAPER Media/guitar thing 080425/guitar thing 080425-004.wav"), level: 0.0)

f.load(\high_chords, "/home/tim/Documents/REAPER Media/guitar thing 080425/guitar thing 080425-001.wav")
f.load(\low_chords, "/home/tim/Documents/REAPER Media/guitar thing 080425/guitar thing 080425-002.wav")
f.load(\ebow, "/home/tim/Documents/REAPER Media/guitar thing 080425/guitar thing 080425-003.wav")
f.load(\bow, "/home/tim/Documents/REAPER Media/guitar thing 080425/guitar thing 080425-004.wav")

~high_chords_spec_mix = 1
~high_chords_rate = 0.1
~high_chords_level = 0.5

m.add(f.thaw(\hc_ef, \high_chords, fundamental: Note("C#5").freq, rate: 0.03, highHarmonic: 5, lowHarmonic: 1))

m.add(f.thaw(\lc_df, \low_chords, fundamental: Note("C#3").freq, rate: 0.03, highHarmonic: 3, lowHarmonic: 1))


m.add(f.thaw(\e_af, \ebow, fundamental: Note("D#4").freq, rate: 0.2, highHarmonic: 5, lowHarmonic: 1))
~e_af_level = 0.3

~low_chords_rate = 0.04
~low_chords_spec_mix = 1.0
~low_chords_level = 0.3


~pitchDispersion = { SinOsc.ar(0.33).range(0.0, 0.01) }
~timeDispersion = { SinOsc.ar(0.25).range(0.5, 0.7) }
~detune = { SinOsc.ar(200.0).range(0.0, 0.010) }

~ebow_spec_mix = 0.0
~ebow_grain_mix = 0.0
~ebow_grain_pos_randomness = 0.05
~ebow_grain_density = 0
~ebow_grain_duration = 0.75
~ebow_rate = 0.5
( ~ebow_insert = {
    ~ebow +
    PitchShift.ar(~ebow, pitchRatio: 0.5 + (0.5 * ~detune), pitchDispersion: ~pitchDispersion, timeDispersion: ~timeDisperson ) +
    PitchShift.ar(~ebow, pitchRatio: 1.5 - (1.5 * ~detune), pitchDispersion: ~pitchDispersion, timeDispersion: ~timeDispersion ) +
    PitchShift.ar(~ebow, pitchRatio: 2.0 + (2.0 * ~detune), pitchDispersion: ~pitchDispersion, timeDispersion: ~timeDispersion) +
    PitchShift.ar(~ebow, pitchRatio: 2.25 - (2.25 * ~detune), pitchDispersion: ~pitchDispersion, timeDispersion: ~timeDispersion)
})

~ebow_level = 0.5


m.add(l.load(\ebow_2, "/home/tim/Documents/REAPER Media/guitar thing 080425/guitar thing 080425-003.wav"), level: 0.0)
~ebow_2_grain_mix = -1
~ebow_2_spec_mix = 0.0
~ebow_2_grain_pos_randomness = 0.7
~ebow_2_grain_density = 1
~ebow_2_grain_duration = 0.025
~ebow_2_rate = 0.66
( ~ebow_2_insert = {
    ~ebow_2 +
    PitchShift.ar(~ebow_2, pitchRatio: 0.5 - (0.5 * ~detune), pitchDispersion: ~pitchDispersion, timeDispersion: ~timeDispersion) +
    PitchShift.ar(~ebow_2, pitchRatio: 1.5 + (1.5 * ~detune), pitchDispersion: ~pitchDispersion, timeDispersion: ~timeDispersion) +
    PitchShift.ar(~ebow_2, pitchRatio: 2.0 - (2.0 * ~detune), pitchDispersion: ~pitchDispersion, timeDispersion: ~timeDispersion) +
    PitchShift.ar(~ebow_2, pitchRatio: 2.25 + (2.25 * ~detune), pitchDispersion: ~pitchDispersion, timeDispersion: ~timeDispersion)
})

~ebow_2_level = 0.5

m.add(l.load(\ebow_3, "/home/tim/Documents/REAPER Media/guitar thing 080425/guitar thing 080425-003.wav"), level: 0.0)
~ebow_3_grain_mix = -1
~ebow_3_spec_mix = 0.0
~ebow_3_grain_pos_randomness = 0.7
~ebow_3_grain_density = 1
~ebow_3_grain_duration = 0.025
~ebow_3_rate = 0.30
( ~ebow_3_insert = {
    ~ebow_3 +
    PitchShift.ar(~ebow_3, pitchRatio: 0.5 - (0.5 * ~detune), pitchDispersion: ~pitchDispersion, timeDispersion: ~timeDispersion) +
    PitchShift.ar(~ebow_3, pitchRatio: 1.5 + (1.5 * ~detune), pitchDispersion: ~pitchDispersion, timeDispersion: ~timeDispersion) +
    PitchShift.ar(~ebow_3, pitchRatio: 2.0 - (2.0 * ~detune), pitchDispersion: ~pitchDispersion, timeDispersion: ~timeDispersion) +
    PitchShift.ar(~ebow_3, pitchRatio: 2.25 + (2.25 * ~detune), pitchDispersion: ~pitchDispersion, timeDispersion: ~timeDispersion)
})
~ebow_3_level = 0.5

~bow_grain_mix = 0.7
~bow_spec_mix = 0.7
~bow_rate = 0.1
~bow_grain_pos_randomness = 0.7
~bow_grain_rate = 0.1
~bow_grain_density = 0.5
~bow_grain_duration = 1.0
~bow_level = 0.6

~bow_insert = { CombL.ar(~bow.ar, maxdelaytime: 5.0, delaytime: 0.45, decaytime: 5.0) }


~lc_df.set(\fundamental, Note("A#3").freq)
~hc_ef.set(\fundamental, Note("D#4").freq)
~e_af.set(\fundamental, Note("C#2").freq)

~lc_df.set(\highHarmonic, 17)
~hc_ef.set(\highHarmonic, 21)
~e_af.set(\highHarmonic, 25)

~lc_df.set(\lowHarmonic, 1)
~hc_ef.set(\lowHarmonic, 1)
~e_af.set(\lowHarmonic, 1)

~lc_df_level = 1.0
~hc_ef_level = 1.0
~e_af_level = 1.0

~ebow_level = 0.0
~ebow_2_level = 0.0
~ebow_3_level = 0.0

~lc_df_level = 0.0
~hc_ef_level = 0.0
~e_af_level = 0.0

~bow_level = 0.0
~ebow_level = 0.0
~ebow_2_level = 0.0
~ebow_3_level = 0.0
~low_chords_level = 0.0
~high_chords_level = 0.0
