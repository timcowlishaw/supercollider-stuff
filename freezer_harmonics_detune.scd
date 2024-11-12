p = ProxySpace().push(s.boot);
q = ();
f = TimFreezer.new(s, q);

q.fundamental = 328; // E3



f.freeze(\fundamental, [q.fundamental] , sustain: 0.99, memLength: 1.0);

~fundamental = \fundamental;


~fundamental_amp = { 0.0 } // SinOsc.kr(0.25, mul: 0.25) * 0.1 }

~detuneOffset = { SinOsc.kr(0.1, mul: 0.0, add: 0.1) }
~detuneOffset.fadeTime_(5.0);
~shifted = { PitchShift.ar(~fundamental, pitchRatio: 1 + ~detuneOffset, pitchDispersion: 0.00) }


~shifted_amp = { SinOsc.ar(3, mul: 0.4) }

~harmRatio = { 0.5 }
~harmonic = { PitchShift.ar(~shifted, pitchRatio: ~harmRatio) }
~harmonic_amp = { SinOsc.ar(0.5) }

~harmRatio2 = { 5.0 }
~harmonic2 = { XFade2.ar(PitchShift.ar(~shifted, pitchRatio: ~harmRatio2), PitchShift.ar(~shifted, pitchRatio: ~harmRatio2 / 2.0), SinOsc.kr(0.1)) }
~harmonic_amp2 = { SinOsc.ar(0.2) }

~master_amp = { 1.0 }



~crossMod = { ~harmonic2 * ~fundamental }
~crossMod_amp = { SinOsc.ar(0.05) * SinOsc.ar(SinOsc.kr(0.1, mul: 10, add: 10), add: 1.0) }

~out = { ((~fundamental * ~fundamental_amp) + (~shifted * ~shifted_amp) + (~harmonic +  ~harmonic_amp) + (~harmonic2 +  ~harmonic_amp2) + (~crossMod * ~crossMod_amp)) * ~master_amp }
~out.play
