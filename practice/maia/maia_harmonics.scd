
p = ProxySpace().push(s.boot);
q = ();
f = TimFreezer.new(s, q);

q.fundamental = 164.81; // E3
q.first_harmonic = q.fundamental * 2;
q.second_harmonic = q.fundamental * 3;
q.third_harmonic = q.fundamental * 4;
q.fourth_harmonic = q.fundamental * 5;
q.fifth_harmonic = q.fundamental * 6;
q.sixth_harmonic = q.fundamental * 7;
q.seventh_harmonic = q.fundamental * 8;


//HAROMINICOS JUNTOS

f.freeze(\nota_con_harmonicos, [q.fundamental, q.first_harmonic, q.second_harmonic, q.third_harmonic, q.fourth_harmonic, q.fifth_harmonic], sustain: 0.99, memLength: 0.25);

~nota = \nota_con_harmonicos;
~nota_amp = { 1.0 };
~nota_amp.fadeTime_(5.0);
~nota_vca = { ~nota * ~nota_amp };

~out = { ~nota_vca * 0.4 }
~out.play

s.freqscope;

// HAROMONICOS POR SEPARADO

f.freeze(\fundamental, [q.fundamental] , sustain: 0.99, memLength: 1.0);
f.freeze(\first_harmonic, [q.first_harmonic] , sustain: 0.99, memLength: 1.0);
f.freeze(\second_harmonic, [q.second_harmonic] , sustain: 0.99, memLength: 1.0);
f.freeze(\third_harmonic, [q.third_harmonic] , sustain: 0.99, memLength: 1.0);
f.freeze(\fourth_harmonic, [q.fourth_harmonic] , sustain: 0.99, memLength: 1.0);
f.freeze(\fifth_harmonic, [q.fifth_harmonic] , sustain: 0.99, memLength: 1.0);
f.freeze(\sixth_harmonic, [q.sixth_harmonic] , sustain: 0.95, memLength: 2.0);
f.freeze(\seventh_harmonic, [q.seventh_harmonic] , sustain: 0.95, memLength: 2.0);

~fundamental = \fundamental;
~first_harmonic = \first_harmonic;
~second_harmonic = \second_harmonic;
~third_harmonic = \third_harmonic;
~fourth_harmonic = \fourth_harmonic;
~fifth_harmonic = \fifth_harmonic;
~sixth_harmonic = \sixth_harmonic;
~seventh_harmonic = \seventh_harmonic;

~fundamental_amp = { 0 } // SinOsc.kr(0.25, mul: 0.25) * 0.1 }
~first_amp = { 0 } // SinOsc.kr(0.33, mul: 0.5) * SinOsc.kr(0.03, phase: 0.25 * pi, mul: 0.3) }
~second_amp = { 0 } //SinOsc.kr(0.4) * SinOsc.kr(0.02, mul: 0.4) }
~third_amp = { 0 } // SinOsc.kr(SinOsc.kr(0.05, add: 3, mul: 1)) * SinOsc.kr(0.33, phase: 0.5 * pi) }
~fourth_amp = { 0 } // SinOsc.kr(SinOsc.kr(0.1, add: 2, mul: 2)) * SinOsc.kr(0.2, phase: 1 * pi) }
~fifth_amp = { 0 } // SinOsc.kr(SinOsc.kr(0.2, add: 5.0, mul: 0.5)) * SinOsc.kr(0.1) }
~sixth_amp = { 0 } // SinOsc.kr(SinOsc.kr(0.3, add: 3.0, mul: 0.25)) * SinOsc.kr(0.33, phase: 0.5 * pi) }
~seventh_amp = { 0 } //SinOsc.kr(SinOsc.kr(0.4, add: 5.0, mul: 1.0)) *  SinOsc.kr(0.4, phase: 0.25 * pi) }
~master_amp = { 1.0 }


~out = { (
  (
    ~fundamental * ~fundamental_amp
  ) + (
    ~first_harmonic * ~first_amp
  ) + (
    ~second_harmonic * ~second_amp
  ) + (
    ~third_harmonic * ~third_amp) + (
      ~fourth_harmonic * ~fourth_amp
  ) + (
    ~fifth_harmonic * ~fifth_amp
  ) + (
    ~sixth_harmonic * ~sixth_amp
  ) + (
    ~seventh_harmonic * ~seventh_amp
  ) + (
    XFade2.ar(~second_harmonic, ~third_harmonic, SinOsc.kr(0.25)) * XFade2.ar(~third_harmonic, ~sixth_harmonic, SinOsc.kr(0.321))
  )
) * ~master_amp }
~out.play
