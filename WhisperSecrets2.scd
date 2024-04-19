// "cannot believe that we taught rocks to whisper Secret Numbers so vast that
//  their names have never before and will never be spoken again in the long
//  span of human time, and we use them to key databases for e-commerce systems"
//  – https://assemblag.es/@est@emily.news/110874771621260688


// Ranges for push:
//   Angle: -0.5pi (distant, west), 0 (centre), 0.5pi (distant, east)
//   Azimuth: pi (south), 0.5pi (west), 0 (north), -0.5pi (east), -pi (south, again)


/// TODO TIM FIX ALL THIS WITH NEW CONTROLS AND STARTUP / LEVEL SETTING STUFF PROCEDURE

/// THEN TWO LOOPERS PER SECTION PLUS SOME READY MADE EFFECT TEMPLATES

// Looper controls
/*
		var recMix = this.key(name, \record_mix);
		var recording = this.key(name, \recording);
		var rate = this.key(name, \rate);
		var pitch = this.key(name, \pitch);
		var spec_mix = this.key(name, \spec_mix);
		var grain_mix = this.key(name, \grain_mix);
		var grain_density = this.key(name, \grain_density);
		var grain_attack = this.key(name, \grain_attack);
		var grain_release = this.key(name, \grain_release);
		var grain_curve = this.key(name, \grain_curve);
*/
// Mixer controls
/*
		var levelKey = this.key(name, \level);
		var azimKey = this.key(name, \azim);
		var angleKey = this.key(name, \angle);
		var insertKey = this.key(name, \insert);
*/

p = ProxySpace().push(s.boot);
q = ();
l = LoopStation.new(s, p, q, fftSize:16384, hop: 0.25, win: 1);
d = FoaDecoderKernel.newCIPIC(12)
m = FOAMixer.new(s, p, q, d)
m.output.play

m.add(l.load(\test_file, "/Users/tim/Music/Samples/field recording clips/guitar octaves.wav"))
~test_file_level = 0

m.add(l.listen(\golpes1, 71))

~golpes1_level.fadeTime_(10)
~golpes1_level = 1.0

~golpes1_recording = 0

~golpes1_spec_mix = -1

~golpes1_rate = { LFSaw.kr(0.08) }

~golpes1_grain_mix = -1

~golpes1_grain_density = { SinOsc.kr(0.1, mul: 5.0) }

~golpes1_pitch.fadeTime_(0.07)
~golpes1_pitch = 1
~golpes1_insert = { PitchShift.ar(~golpes1.ar, windowSize: 0.1, pitchRatio: ~golpes1_pitch, pitchDispersion: 0, timeDispersion: 0.004) }

m.add(l.listen(\golpes2, 52))

~golpes2_level.fadeTime_(10)
~golpes2_level = 0.1

~golpes2_recording = 0

~golpes2_delay_level = 0.4
~golpes2_delay_time = { SinOsc.kr(0, 25, mul: 2.0, add: 0.2) }
~golpes2_decay_time = 1.0
~golpes2_insert = { CombL.ar(~golpes2,5.0, ~golpes2_delay_time, ~golpes2_decay_time, ~golpes_2_delay_level) }

m.add(l.listen(\golpes3, 33))

~golpes3_recording = 0

~golpes3_spec_mix = -0.3
~golpes3_rate = 0.1

m.add(l.listen(\golpes4, 40))

~golpes4_recording = 0

~golpes4_grain_density = 20

~golpes4_grain_attack = 0.01
~golpes4_grain_release = 0.1


~golpes4_grain_mix = { SinOsc.kr(0.33, mul: SinOsc.kr(0.1, mul: 2.0) , add: -1) }


// TERMINANDO

~golpes1_level.fadeTime_(2)
~golpes1_level = 0.0 // { SinOsc.kr(SinOsc.kr(0.01, mul: 0.1, add: 0.01), mul: 1.0) }

~golpes2_level.fadeTime_(12)
~golpes2_level = 0

~golpes3_level.fadeTime_(10)
~golpes3_level = 0

~golpes4_level.fadeTime_(30)
~golpes4_level = 0


m.add(l.listen(\agua1, 5))

~agua1_recording = 0

~agua1_level = 0

~agua_1_spec_mix = 0.76
~agua_1_rate = 0.1

m.add(l.listen(\cascabelles, 30))

~cascabelles_recording = 0

~cascabelles_level = 1.0

~cascabelles_spec_mix = 1

~cascabelles_rate = 0.1

~cascabelles_delay_level = 0.3
~cascabelles_delay_time = { SinOsc.kr(0.1, 25, mul: 5.0, add: 0.2) }
~cascabelles_decay_time = 10.0
~cascabelles_insert = { CombL.ar(~cascabelles, 5.0, ~cascabelles_delay_time, ~cascabelles_decay_time, ~cascabelles_2_delay_level) }

~cascabelles_level = 5.7

~cascabelles_spec_mix = { SinOsc.kr(SinOsc.kr(0.05, mul: 0.5, add: 0.1), 25, mul: 2.0, add: -0.1) }

~cascabelles_rate = -0.5

~cascabelles_pitch = 0.5
~cascabelles_pitch.fadeTime_(0.5)
~cascabelles_insert = { PitchShift.ar(~cascabelles.ar, windowSize: 0.1, pitchRatio: ~cascabelles_pitch, pitchDispersion: 0, timeDispersion: 0.004) }


m.add(l.listen(\cascabelles2, 23))

~cascabelles2_recording = 0


~cascabelles2_grain_mix = 0.7

~cascabelles2_grain_density = { SinOsc.ar(0.05, mul:3.0) }

~cascabelles2_grain_attack = 3.0
~cascabelles2_grain_release = 5.0

~cascabelles2_pitch = 2
~cascabelles2_pitch.fadeTime_(0.01)
~cascabelles2_insert = { PitchShift.ar(~cascabelles2.ar, windowSize: 0.1, pitchRatio: ~cascabelles2_pitch, pitchDispersion: 0, timeDispersion: 0.004) }


~cascabelles2_level.fadeTime_(60)
~cascabelles2_level = 0


~cascabelles_level.fadeTime_(90)
~cascabelles_level = 0

m.printLevels

m.add(l.listen(\cascabelles3, 18))

~cascabelles3_recording = 0

~cascabelles_spec_mix = 1

~cascabelles_rate = -0.2

~cascabelles3_level.fadeTime_(30)
~cascabelles3_level = 0.0

m.add(l.listen(\agua, 24))

~agua_recording = 0

~agua_spec_mix = 1

~agua_rate = -1

~agua_level.fadeTime_(45)
~agua_level = 0


m.printLevels

// SEGUNDO MOVIMIENTO, ARCOS

m.add(l.listen(\arco1, 60.0))

~arco1_recording = 0

~arco1_grain_mix = -1 // { SinOsc.kr(0.25, mul:2, add:-1) }
~arco1_grain_density = { 2 + SinOsc.kr(0.33, mul: 3) }

~arco1_level = 0.2

~arco1_grain_attack = 3
~arco1_grain_release = 3
~arco1_grain_curve = { WhiteNose.kr() }

~arco1_level = 0.1

m.add(l.listen(\arco2, 17.5))

~arco2_recording = 0

~arco2_pitch = 0.7
~arco2_pitch.fadeTime_(0.1)
~arco2_pitch = 0.5

~arco2_level = { SinOsc.kr(0.08, mul: 0.8) }

// HACER UNA SEÑAL A MERCÈ ANTES DE BAJARLO
~arco2_insert = { PitchShift.ar(~arco2.ar, windowSize: 0.1, pitchRatio: ~arco2_pitch, pitchDispersion: 0, timeDispersion: 0.004) }

~arco2_grain_mix = { SinOsc.kr(0.1, mul:2, add:-1) }
~arco2_grain_density = { 2 + SinOsc.kr(0.75, mul: 10) }
~arco2_grain_attack = 1
~arco2_grain_release = 0.5

m.add(l.listen(\arco3, 24))

~arco3_recording = 0
~arco3_spec_mix = 1

~arco3_level = { SinOsc.kr(4, mul: SinOsc.kr(0.1, mul: 0.3)) }

~arco3_pitch = 2.0
~arco3_pitch.fadeTime_(0.1)


// HACER UNA SEÑAL A MERCÈ ANTES DE BAJARLO
~arco3_insert = { PitchShift.ar(~arco3.ar, windowSize: 0.1, pitchRatio: ~arco3_pitch, pitchDispersion: 0, timeDispersion: 0.004) }


~arco3_rate = 0.25

m.add(l.listen(\arco4, 27))

~arco4_recording = 0

~arco4_spec_mix = 1

~arco4_rate = 0.1


~arco4_spec_mix = 0.5
~arco_4_rate = 0.25
~arco_4_level = { 0.0 }

m.add(l.listen(\arco5, 23))


// TERMINANDO

~arco1_level.fadeTime_(30)
~arco1_level = 0

~arco2_level.fadeTime_(20)
~arco2_level = 0

~arco3_level.fadeTime_(20)
~arco3_level = 0

~arco4_level.fadeTime_(10)
~arco4_level = 0

// NEXT MOVEMENT

m.add(l.listen(\arco5, 30))

~arco6_level = { SinOsc.kr(mul: 0.7) }


