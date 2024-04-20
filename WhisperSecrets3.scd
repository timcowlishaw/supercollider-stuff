// TODO: set the correct output in startup.scd
p = ProxySpace().push(s.boot);
q = ();
l = LoopStation.new(s, p, q, fftSize:16384, hop: 0.25, win: 1, recFadeTime:0.1);
// TODO Set levels here in soundcheck:
// Warns about a flattened array, but da igual, funciona.
m = FOAMixer.new(s, p, q, maxLevel:5.0, defaultLevel: 0.7, defaultFb: 0.7);

// At Phonos:
m.output.play // Ch 1-4 Ambisonic A-format to FOH, Ch 5 Feedback to Mercè

/* //Binaural monitoring for rehearsal:
d = FoaDecoderKernel.newCIPIC(12)
~mixer_decoded = { FoaDecode.ar(m.bus.ar, d) };
~mixer_decoded.play
*/

~foa_mixer_master_fader = 1.0;
~foa_mixer_master_feedback = 0.8;

// When you haven't got a real mixer to hand: (you'll also need this at VIU to send Mercè to the ambisonic mix)
/*
~input = { SoundIn.ar }
m.add(~input, level: 0.6, fb: 0.0)
~input_level = 0.6
~input_fb = 1.0

*/

// PANIC!!! (at the ambisonic livecode and controlled-feedback disco)
(
l.stopAllRecording;
~foa_mixer_master_fader = 0;
~foa_mixer_master_feedback = 0;
)

// WTF?
(
  m.printLevels;
  l.printRecording;
)

// All clear
(
~foa_mixer_master_fader = 1.0;
~foa_mixer_master_feedback = 0.8;
)

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


////////////////////////////////////////////////////////////////////////////////////////////////
// TOT EL NOSTRE EQUIP ES UN SOL INSTRUMENT.                                                 //
// És un instrument fet de la terra: de fang, de porcellana, de silici, i de coure.         //
// Fa so a través de la ressonància: les conques vibren, igual que les portes lògiques.    //
// Sembla que el instrument té vida: ens toca a nosaltres mentre ho toquem,               //
// i de vegades de maneres inesperades. Preguem la vostra comprensió :-)                 //
//                                                                                      //
// "cannot believe that we taught rocks to whisper Secret Numbers so vast that         //
//  their names have never before and will never be spoken again in the long          //
//  span of human time, and we use them to key databases for e-commerce systems"     //
//  – https://social.emily.news/@est/110874771638696468                             //
/////////////////////////////////////////////////////////////////////////////////////


// 1st Movement - GOLPES

m.add(l.listen(\golpes_1, 30.0), fb: 0.7, level: 0.4);

~golpes_1_level = 1.0

m.printLevels

~golpes_1_recording = 0

~golpes_1_spec_mix =  { SinOsc.kr(0.25) }
~golpes_1_rate = 0.1
~golpes_1_grain_mix =  { SinOsc.kr(0.33) }

~golpes_1_grain_density = { SinOsc.kr(0.33, mul: 10.0, add: 10.0) }
~golpes_1_grain_duration = { SinOsk.kr(0.25, mul: 1.0, add: 1.0) }
~golpes_1_grain_rate = 1.5


(~golpes_1_grain_rate = {
	TChoose.kr(
		CoinGate.kr(1 / ~golpes_1_grain_density.log10, Trig1.kr(~golpes_1_grain_trigs, 0.01)),
		[0.5] ++ Scale.dorian.ratios.at([0, 1, 4, 5]) ++ [2.0, 4.0]
    )
})

m.add(l.listen(\golpes_2, 21.5), fb:0.0);

~golpes_2_level = 1.0

~golpes_2_recording = 0

~golpes_2_spec_mix = 0
~golpes_2_rate = -1
~golpes_2_grain_mix = 1

~golpes_2_grain_density = { SinOsc.kr(2.0, mul: 10.0, add: 20.0) }
~golpes_2_grain_duration = { SinOsk.kr(0.25, mul: 0.5, add: 1.0) }
~golpes_2_grain_rate = { TChoose.kr(~golpes_2_gain_trigs, [1.5, 1, 0.5]) }


(~golpes_1_grain_rate = {
	TChoose.kr(
		CoinGate.kr(1 / ~golpes_1_grain_density.log10, Trig1.kr(~golpes_1_grain_trigs, 0.01)),
		[0.5] ++ Scale.dorian.ratios.at([0, 1, 4, 5]) ++ [2.0, 4.0]
    )
})

m.printLevels

(
  ~golpes_1_angle.fadeTime_(60);
  ~golpes_1_angle = 0.5pi;
)

(
  ~golpes_1_pan_speed = 0;
  ~golpes_1_pan_speed.fadeTime_(10);
  ~golpes_1_azim = { LFSaw.kr(~golpes_1_pan_speed,  mul:pi) };
)

  ~golpes_1_pan_speed = 0.5;

(
  ~golpes_2_angle.fadeTime_(60);
  ~golpes_2_angle = 0.5pi;
)

(
  ~golpes_2_pan_speed = 0;
  ~golpes_2_pan_speed.fadeTime_(10);
  ~golpes_2_azim = { LFSaw.kr(~golpes_2_pan_speed,  mul:pi) };
)

~golpes_2_pan_speed = 0.1;

(
  ~golpes_1_fb.fadeTime_(30)
  ~golpes_1_fb = 1.0 // TODO set in soundcheck
)

(
  ~golpes_2_fb.fadeTime_(20)
  ~golpes_2_fb = 1.0 // TODO set in soundcheck
)

m.add(l.listen(\golpes_3, 35), fb:0.0, level:0.0);

m.printLevels

l.printRecording
~golpes_3_recording =1

~golpes_3_record_mix = 0.6
~golpes_3_level.fadeTime_(40)
~golpes_3_fb.fadeTime_(90)
~golpes_3_fb = 0.6 // TODO set in soundcheck
~golpes_3_level = 1.0 // TODO ditto

~gplpes_1_rate = -0.2
~golpes_1_spec_mix.fadeTime_(60)
~golpes_1_spec_mix = 1

~golpes_2_rate = -0.5
~golpes_2_spec_mix.fadeTime_(45)
~golpes_2_spec_mix = 1

~golpes_3_grain_density = { 12.0 };
~golpes_3_grain_density.fadeTime_(10.0)
~golpes_3_grain_duration = { SinOsc.kr(SinOsc.kr(0.1, mul: 0.25)) };
~golpes_3_grain_duration.fadeTime_(10.0);

(
  ~golpes_3_angle.fadeTime_(10);
  ~golpes_3_angle = 0.35pi;
)



(~golpes_3_grain_rate = {
	TChoose.kr(
		 ~golpes_3_grain_density, Trig1.kr(~golpes_3_grain_trigs, 0.01)),
		[0.5, 2.0, 4.0]
    )
})

~golpes_3_spec_mix = 0
~golpes_3_rate = 0.1

~golpes_3_pan_speed = 0;
~golpes_3_pan_speed.fadeTime_(10);
~golpes_3_azim = { LFSaw.kr(~golpes_2_pan_speed,  mul:pi) };


(~golpes_3_grain_rate = {
	TChoose.kr(
		CoinGate.kr(1 / ~golpes_3_grain_density.log10, Trig1.kr(~golpes_3_grain_trigs, 0.01)),
		[0.5] ++ Scale.aeolian.ratios.at([0, 4]) ++ [2.0]
    )
})


(~golpes_3_insert = {
	CombL.ar(~golpes_3, 1.0, 0.75, 2.0)
})



~golpes_3_grain_mix.fadeTime_(20)
~golpes_3_grain_mix = 1.0

~golpes_3_grain_density = { 100.0 };
~golpes_3_grain_duration = { 2.0 }


// Transition.

~golpes_1_level.fadeTime_(30)
~golpes_2_level.fadeTime_(30)
~golpes_3_grain_density.fadeTime_(30)
~golpes_1_level = 0
~golpes_2_level = 0
~golpes_3_grain_density = 0

~golpes_1_fb.fadeTime_(10)
~golpes_2_fb.fadeTime_(10)
~golpes_3_fb.fadeTime_(10)
~golpes_1_fb = 0
~golpes_2_fb = 0
~golpes_3_fb = 0

~golpes_3_level.fadeTime_(10)
~golpes_3_level = 0

~golpes_1_recording = 0
~golpes_2_recording = 0
~golpes_3_recording = 0


// 2nd Movement

// Cascabelles. Movements across and around. Myxolydian mode. grain randomness peaking and slowing (short grains, massive density - sync with random). Klank resonator (but fade it in slowly).

m.add(l.listen(\golpesbajo, 20))

~golpesbajo_level.fadeTime_(45)
~golpesbajo_level = 0

~golpesbajo_recording = 0

~golpesbajo_rate = { SinOsc.kr(0.2) }

~golpesbajo_spec_mix = { SinOsc.kr(2) }

m.add(l.listen(\cascabelles, 27))

~cascabelles_recording = 0

~cascabelles_level.fadeTime_(120)
~cascabelles_level = 0
~cascabelles_level = 1.4

~cas

~cascabelles_grain_mix = 0.5

~cascabelles_osc = { SinOsc.kr(0.4) }

(~cascabelles_grain_density = { ~cascabelles_osc * 100.0 })

(~cascabelles_grain_duration = { ~cascabelles_osc / 100 })

~cascabelles_pos_randomness = 0.4

~cascabelles_grain_rate = 0.25

~cascabelles_insert = { Klang.ar([[200, 450, 12003], [0.0, 0.0, 0.0]]) }


// Transiton.

// 3rd Movement.
// Random pan movements synced with grain trigger (use fadeTo and LinLin)
// Back to a minor-ish mode initially, but slowly add chromaticism and dischord

m.add(l.listen(\arco1, 45))

~arco1_recording = 0


~arco_1_level = 2.0


~arco_2_level = 1.5

l.printRecording

m.add(l.listen(\arco2, 54.6))

~arco_2_recording = 0

~arco_2_spec_mix = 1
~arco_2_rate = -0.1

~arco_2_level = { 1.5 + SinOsc.kr(SinOsc.kr(0.1, mul: 0.5), mul: 0.2))

~arco_1_grain_mix = 1.0
~arco_1_grain_duration = 12.0

~arco_1_grain_density.fadeTime_(120)
~arco_1_grain_density = 0

~arco_1_level.fadeTime(20)
~arco_1_level = 0

m.printLevels

~arco_2_level.fadeTime_(00)
~arco_2_level = 0.0

~foa_mixer_master_fader = 0.0


(~arco_1_grain_rate = {
	TChoose.kr(
		CoinGate.kr(1 / ~arco_1_grain_density.log10, Trig1.kr(~arco_1_grain_trigs, 0.01)),
		Scale.dorian.ratios.at([ 2, 6]) ++ [4.0]
    )
})


// FIN.