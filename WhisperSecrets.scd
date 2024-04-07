// ATK Setup
// Quarks.install("https://github.com/ambisonictoolkit/atk-sc3.git");
//Atk.downloadKernels;
// Atk.downloadMatrices;
// Atk.downloadSounds;
// Helpful ambisonic visualiser: FoaXformDisplay.new(16)
// Ranges for push:
//   Angle: -0.5pi (distant, west), 0 (centre), 0.5pi (distant, east)
//   Azimuth: pi (south), 0.5pi (west), 0 (north), -0.5pi (east), -pi (south, again)

p = ProxySpace().push(s.boot); // store proxy space in p so it can be accessed easily.
q = ();

q.encoder = FoaEncoderMatrix.newOmni
//q.decoder = FoaDecoderMatrix.newPanto(2)
q.decoder = FoaDecoderKernel.newCIPIC(12)
m = FOAMixer.new(s, p, q);


~decoded = { FoaDecode.ar(m.bus, q.decoder); }

l = LoopStation.new(s, p, q, m)
m.bus.scope
l.listen(\test, 10)

q.scale = Scale.dorian

~freq1 = { 220 }
~fmAmt1 = { 0.3 }
~ratio1 = { 2.02 }
~angle1 = { 0.5 * pi }
~attack1 =  { 0.0 }
~release1 = { 0.2 }
~impulse1 = { 8 }
~azim1 = {  LFSaw.kr(0.25, mul:2*pi, add:-pi) }

~src1 = { SinOsc.ar(220) }

~src1 = { SinOsc.ar(~freq1 * (1 + (SinOsc.ar(~freq1 * ~ratio1) * ~fmAmt1))) * EnvGen.ar(Env.perc(~attack1, ~release1), Impulse.kr(~impulse1)) }

~encoded1 = { FoaEncode.ar(~src1.ar, q.encoder) }
~transformed1 = { FoaTransform.ar(~encoded1.ar, 'push', ~angle1.kr, ~azim1.kr) }
~transformed1.scope
m.add(~transformed1)
~decoded.stop
~decoded.play

~decoded = { FoaDecode.ar(~transformed1, q.decoder); }

m.add(~transformed1);

~freq2 = { ~freq1 * 2 * q.scale.ratios[3] }
~angle2 = { 0.1 * pi }
~azim2 = { Saw.ar(0.25, mul:2*pi, add:-pi - 0.001) }


~src2 = { SinOsc.ar (~freq2) }
~encoded2 = { FoaEncode.ar(~src2.ar, q.encoder) }
~transformed2 = { FoaTransform.ar(~encoded2.ar, 'push', ~angle2.kr, ~azim2.kr) }
m.add(~transformed2);

~test_angle = 0.5 * pi

~test_azimuth = { SinOsc.ar(0.25, mul: 2*pi, add: -pi) } // pan isn't working as it's going straight to the soundcard out.

~test_recording = 0 // This never evalutes to 'false' as it's inside a NodeProxy? possibly

~test_recMix = 0

~left_angle = 0.5*pi

~left_azim = { SinOsc.kr(0.2) }

~left_freq.fadeTime_(10)

~left_freq = 221

~right_freq.fadeTime_(20)

~right_freq = 550

~decoded.play

~left_osc.fadeTime_(2).pause

~right_osc.fadeTime_(2).pause

~centre_osc.fadeTime_(2).pause

~left_azim = { SinOsc.kr(0.5, mul:pi, add:-0.5*pi) }
~left_angle = { 0.5*pi }

l.create(\right, 441)
~right_azim = { SinOsc.kr(0.33, 0.33*pi, mul:pi, add:-0.5*pi) }
~right_angle = { 0.33*pi }

l.create(\centre, 662)
~centre_azim = { SinOsc.kr(1.2, 0.5*pi, mul:pi, add:-0.5*pi) }
~centre_angle = { 0.5*pi }

~right_freq

~bus.scope
~centre_transformed.scope

~sig = { PinkNoise.ar() }

~encoded = { FoaEncode.ar(~sig.ar, q.encoder) }

~angle = { 0.5*pi }

~azim = { SinOsc.kr(0.5, mul:pi, add:-0.5*pi) }

~transformed = {  FoaTransform.ar(~encoded.ar, 'push', ~angle.kr, ~azim.kr) }

~sig2 = { SinOsc.ar(440) }

~encoded2 = { FoaEncode.ar(~sig2.ar, q.encoder) }

~azim2 = { SinOsc.kr(0.25, 1, pi, -0.5 * pi) }

~transformed2 = { FoaTransform.ar(~encoded2.ar, 'push', ~angle.kr, ~azim2.kr) }

~summed.add(~transformed2)

~summed = { Mix(~list) }

~decided = { FoaDecode.ar(~summed.ar, q.decoder); }

~decided.play

~decided.stop

l = LoopStation.new(s, p, q, ~bus)

x = List.newFrom([1,2,3])

x.collect { |x|  x * 2 }.collect { |x, i| i }


x = List.new()

x.size

~osc1 = { SinOsc.ar(440) }
~osc2 = { SinOsc.ar(441) }
~osc3 = { SinOsc.ar(220) }


~chain.add(~osc1)

~chain.add(~osc2)

~chain.add(~osc3)

~chain = { List.newUsing([Silent.ar(4)])}

~output = { Mix.new(~chain) }

~output.stop

~chain = ~chain + { SinOsc.ar(220) }

l.create("test", 400)
l.create("test2", 300)



~attack = 0.02
~release = 0.5
~intensity = { 5.0 }
~intensity.fadeTime_(2.0)
~impulses = { Dust.kr(~intensity) }
~sig = { EnvGen.ar(Env.perc(~attack, ~release, curve: 0),  ~impulses) * SinOsc.ar() }
~sig.scope
~encoded = { FoaEncode.ar(~sig.ar, q.encoder) }
~angle = { pi }
~azim = { pi }
~transformed = { FoaTransform.ar(~encoded.ar, 'push', ~angle.kr, ~azim.kr) }
~decoded = { FoaDecode.ar(~transformed.ar, q.decoder); }
~decoded.play
~decoded.stop

~transformed.scope

~decoded.scope


~sig.stop


/* Debug FoaDecoder and try out transorms */
FoaXformDisplay.new(16)
s.boot

~bus = Bus.audio(s, 4);
~decoder = FoaDecoderKernel.newCIPIC(3)


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


