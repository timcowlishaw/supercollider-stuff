// TODO: set the correct output in startup.scd
p = ProxySpace().push(s.boot);
q = ();
l = LoopStation.new(s, p, q, fftSize:16384, hop: 0.25, win: 1, recFadeTime:0.1);
// TODO Set levels here in soundcheck:
// Warns about a flattened array, but da igual, funciona.
m = FOAMixer.new(s, p, q, maxLevel:5.0, defaultLevel: 0.7, defaultFb: 0.7);

// At Phonos:
m.output.play // Ch 1-4 Ambisonic A-format to FOH, Ch 5 Feedback to Mercè

/* Binaural monitoring for rehearsal:
d = FoaDecoderKernel.newCIPIC(12)
~mixer_decoded = { FoaDecode.ar(m.bus.ar, d) };
~mixer_decoded.play
*/

/* When you haven't got a real mixer to hand:
~input = { SoundIn.ar }
m.add(~input, level: 0.0, fb: 1.0)
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
~foa_mixer_master_fader = 1;
~foa_mixer_master_feedback = 1;
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


// 1st Movement

m.add(l.listen(\golpes_1, 30.0), fb=0.0);

~golpes_1_recording = 0

m.add(l.listen(\golpes_2, 21.5), fb=0.0);

~golpes_2_recording = 0

(
  ~golpes_1_angle.fadeTime_(60);
  ~golpes_1_angle = 0.5pi;
)

(
  ~golpes_1_pan_speed = 0;
  ~golpes_1_pan_speed.fadeTime_(10);
  ~golpes_1_azim = { LFSaw.kr(~golpes_1_pan_speed,  mul:pi) };
)

  ~golpes_1_pan_speed = 0;

(
  ~golpes_2_angle.fadeTime_(60);
  ~golpes_2_angle = 0.5pi;
)

(
  ~golpes_2_pan_speed = 0;
  ~golpes_2_pan_speed.fadeTime_(10);
  ~golpes_2_azim = { LFSaw.kr(~golpes_2_pan_speed,  mul:pi) };
)

~golpes_2_pan_speed = 0;

(
  ~golpes_1_fb.fadeTime_(30)
  ~golpes_1_fb = 1.0 // TODO set in soundcheck
)

(
  ~golpes_2_fb.fadeTime_(20)
  ~golpes_2_fb = 1.0 // TODO set in soundcheck
)

m.add(l.listen(\golpes_3, 47), fb=0.0);

~golpes_3_record_mix = 0.75
~golpes_3_fb.fadeTime_(90)
~golpes_3_fb = 0.6 // TODO set in soundcheck


~golpes1_spec_mix =

// Transition.


// 2nd Movement

// Transiton.

// 3rd Movement.

// FIN.