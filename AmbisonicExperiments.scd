// ATK Setup
// Quarks.install("https://github.com/ambisonictoolkit/atk-sc3.git");
//Atk.downloadKernels;
// Atk.downloadMatrices;
// Atk.downloadSounds;
// Helpful ambisonic visualiser: FoaXformDisplay.new(16)

/* Debug FoaDecoder and try out transorms */
FoaXformDisplay.new(16)
s.boot

~bus = Bus.audio(s, 4);
~decoder = FoaDecoderKernel.newCIPIC(12)


(
{
	var sig;
	sig = In.ar(~bus, 4);
	sig = FoaDecode.ar(sig, ~decoder);
	Out.ar(0, sig);
}.play
)

~bus.scope
~bus.index


/* Ok, so far so good. */

/* Next let's try with JITLib: */


// Ranges for push:
//   Angle: -0.5pi (distant, west), 0 (centre), 0.5pi (distant, east)
//   Azimuth: pi (south), 0.5pi (west), 0 (north), -0.5pi (east), -pi (south, again)

p = ProxySpace().push(s.boot); // store proxy space in p so it can be accessed easily.
q = ();

q.encoder = FoaEncoderMatrix.newOmni
q.decoder = FoaDecoderKernel.newCIPIC(12)

~freq1 = { 220 }
~fmAmt1 = { 0.3 }
~ratio1 = { 2.02 }
~angle1 = { 0.5 * pi }
~attack1 =  { 0.0 }
~release1 = { 0.2 }
~impulse1 = { 8 }
~azim1 = {  LFSaw.kr(0.25, mul:2*pi, add:-pi) }

~src1 = { PinkNoise.ar * EnvGen.ar(Env.perc(~attack1, ~release1), Impulse.kr(~impulse1)) }

~src1 = { SinOsc.ar(~freq1 * (1 + (SinOsc.ar(~freq1 * ~ratio1) * ~fmAmt1))) * EnvGen.ar(Env.perc(~attack1, ~release1), Impulse.kr(~impulse1)) }

~encoded1 = { FoaEncode.ar(~src1.ar, q.encoder) }
~transformed1 = { FoaTransform.ar(~encoded1.ar, 'push', ~angle1.kr, ~azim1.kr) }
~transformed1.scope

~decoded = { FoaDecode.ar(~transformed1.ar, q.decoder); } /* REALLY IMPORTANT you explicitly call .ar on the source, always. You'll get a reshape warning and things will 'work'-ish but won't spatialise properly. */

~decoded.play
~decoded.stop

~freq1.key

/* Let's try with our new mixer */
p = ProxySpace().push(s.boot); // store proxy space in p so it can be accessed easily.
q = ();
/* for some reason we need to initialize this before passing it into the mixer,
there's some weird async loading that happens which mens if we init it within t
he same execution as the FOAMixer it fails weirdly because of a null framesize: */
d = FoaDecoderKernel.newCIPIC(12);
m = FOAMixer.new(s, p, q, d);
q.scale = Scale.dorian

~freq1 = { 220 }
~fmAmt1 = { 0.3 }
~ratio1 = { 2.02 }
~attack1 =  { 0.0 }
~release1 = { 0.2 }
~impulse1 = { 8 }
~src1 = { SinOsc.ar(~freq1 * (1 + (SinOsc.ar(~freq1 * ~ratio1) * ~fmAmt1))) * EnvGen.ar(Env.perc(~attack1, ~release1), Impulse.kr(~impulse1)) }

m.add(~src1)

~src1_azim = {  LFSaw.kr(0.25, mul:2*pi, add:-pi) }
~src1_angle = { 0.5 * pi }


~freq2 = { 220 * 3 * q.scale.ratios[3] }
~fmAmt2 = { 0.3 }
~ratio2 = { 3.02 }
~attack2 =  { 0.0 }
~release2 = { 0.3 }
~impulse2 = { 6 }
~src2 = { SinOsc.ar(~freq2 * (1 + (SinOsc.ar(~freq2 * ~ratio2) * ~fmAmt2))) * EnvGen.ar(Env.perc(~attack2, ~release2), Impulse.kr(~impulse2)) }

m.add(~src2)

~src2_azim = {  LFSaw.kr(0.15, pi/2, mul:2*pi, add:-pi) }
~src2_angle = { 0.5 * pi }

~src1_level = 0.5
~src2_level = 0.5


m.bus.scope
m.output.scope

m.output.play

// *AND FINALLY WITH THE LOOP STATION?
p = ProxySpace().push(s.boot); // store proxy space in p so it can be accessed easily.
q = ();
/* for some reason we need to initialize this before passing it into the mixer,
there's some weird async loading that happens which mens if we init it within t
he same execution as the FOAMixer it fails weirdly because of a null framesize: */
d = FoaDecoderKernel.newCIPIC(12);
m = FOAMixer.new(s, p, q, d);
l = LoopStation.new(s, p, q);

m.output.play

m.add(l.listen(\test, 10))

~test_recording = 0

~test_record_mix = -1.0

p

~test_level = 3.5

~test_angle = 0.5 * pi

~test_azim = { LFSaw.kr(0.15, mul: 2*pi, add:-pi) }

m.add(l.listen(\test, 10))

m.add(l.listen(\test2, 3))

~test2_angle = 0.3 * pi

~test2_azim = { LFSaw.kr(0.05, mul: 2*pi, add:-pi) }

~test_azim = 0.7 * pi

~test2_level = 2.2

~test2_recording = 0

~test_level = 0.1

~test_insert = { CombL.ar(~test, 0.7, 0.5, 5.0) }

// * Let's get the LoopStation doing some spectral stuff. On its own before plugging into the mixer.

p = ProxySpace().push(s.boot); // store proxy space in p so it can be accessed easily.
q = ();
l = LoopStation.new(s, p, q, fftSize:8192);
d = FoaDecoderKernel.newCIPIC(12)
m = FOAMixer.new(s, p, q, d)
m.output.play

m.add(l.listen(\test, 10))

m.add(l.listen(\test2, 10))

~test_record = 0


~test2_record = 1

~test2_rate = { 0.5 } // SinOsc.kr(0.25, mul:0.5, add:-0.25) }

~test_insert = { CombL.ar(~test, 0.5, 0.3, 3.0) }

~test.stop

~test2_pitch = { 0.5 }

~test_level = 3.0

p


m.output.play

~test_angle = { 0.5 * pi }
~test_azim = { LFSaw.kr(0.05, mul: 2*pi, add:-pi) }


~test2_angle = { 0.5 * pi }
~test2_azim = { LFSaw.kr(0.05, pi, mul: 2*pi, add:-pi) }


~test2_level = 3.0

~test2_insert = { PitchShift.ar(~test2.ar, windowSize: 0.1, pitchRatio: ~test2_pitch, pitchDispersion: 0, timeDispersion: 0.004) }

// Let's try loading a file:

p = ProxySpace().push(s.boot); // store proxy space in p so it can be accessed easily.
q = ();
l = LoopStation.new(s, p, q, fftSize:16384, hop: 0.25, win: 1);
d = FoaDecoderKernel.newCIPIC(12)
m = FOAMixer.new(s, p, q, d)
m.output.play

m.add(l.load(\test_file, "/Users/tim/Dropbox/Music/Samples/loops/sad_piano.WAV"))

~test_file_rate = { SinOsc.kr(0.25, add:-1.0, mul: 4.0) }

~test_file_spec_mix = 1

~test_file_rate = 0.25

~test_file_grain_mix = 0.75

~test_file_grain_density = { 2 + SinOsc.kr(0.25, mul: 5.0) }

~test_file_grain_release = 0.2

~test_file_grain_attack = 0.01

~test_file_level = 0.0

~test_file_insert = { CombL.ar(~test_file, 2.0, 0.9, 10.0) }

m.printLevels()

m.add(l.load(\test_file2, "/Users/tim/Dropbox/Music/Samples/loops/sad_piano.WAV"))

~test_file2_rate = 0.1

~test_file2_spec_mix = 1

~test_file2_level = 3.0

~test_file_pitch.fadeTime_(0.5)

~test_file2_pitch = 2

~test_file2_level = 0.0

~test_file2_insert = { PitchShift.ar(~test_file2.ar, windowSize: 0.1, pitchRatio: ~test_file2_pitch, pitchDispersion: 0, timeDispersion: 0.5) }



~test_file_angle = { 0.5 * pi }
~test_file_azim = { LFSaw.kr(0.05, mul: 2*pi, add:-pi) }


~test_file2_angle = { 0.5 * pi }
~test_file2_azim = { LFSaw.kr(0.05, pi, mul: 2*pi, add:-pi) }

m.add(l.listen(\test, 20.0))

~test_level = 6.0

~test_spec_mix = 0

~test_spec_rate = -0.33

~test_punch = 0

~test_record_mix = 0

~test_spec_mix = 0.25

~test_grain_mix = 0.2

~test_grain_release = 0.2

~test_grain_attack = 0.2

~test_grian_density = 5.0

~test_insert = { CombL.ar(~test, 2.0, 0.5, 10, 1.0) }

~test_rate = 0.25

~test_grain_mix = 0

~test_grain_density = 5.0

~test_recording = 0

~test_rate = 1

~test_record_mix = 0

~test_rec

m.add(l.listen(\test2, 5.0))

~test2_spec_mix = 0.6

~test2_spec_rate = 0.1

~test_file_level.asCode

~test2_grain_mix = 0.1

~test_grain_density = 5.0

q.test_file_buffer.duration

l.load(\test_file, "/Users/tim/Dropbox/Music/Samples/loops/sad_piano.WAV").play


q.b_test = Buffer.read(s, "/Users/tim/Dropbox/Music/Samples/loops/sad_piano.WAV");

q.b_test.play

["a", "b", "c"].inject("\n") {|m,x| m++x++"\n" }