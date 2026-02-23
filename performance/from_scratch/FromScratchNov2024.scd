
p = ProxySpace().push(s.boot);
q = ();
p.fadeTime = 5.0;
~reverb_mix = 0.6
~reverb_size = 1.0
~reverb_damp = 0.4












~bus = { Saw.ar(SinOsc.ar(0.5).range(0.0, 5.0), mul: 0.2) * (SinOsc.ar(Note("C2").freq, add: SinOsc.ar(Note("G5").freq, mul:50))) + (Saw.ar(SinOsc.ar(0.33).range(0.0, 4.0), mul: 0.2) *  SinOsc.ar(Note("Af4").freq) * SinOsc.ar(0.1)) + (SinOsc.ar(SinOsc.ar(0.1).range(0.0, 2.0)) * SinOsc.ar(Note("Ef3").freq, mul: 0.5))}

~out = { FreeVerb.ar(~bus, room: ~reverb_size, damp: ~reverb_damp, mix: ~reverb_mix) }

~out.pause
