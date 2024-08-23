
p = ProxySpace().push(s.boot);
q = ();
f = TimFreezer.new(s, q);

q.fundamental = 174.61;
q.first_harmonic = q.fundamental * 2;
q.second_harmonic = q.fundamental * 3;
q.third_harmonic = q.fundamental * 4;
q.fourth_harmonic = q.fundamental * 5;
q.fifth_harmonic = q.fundamental * 6;


//HAROMINICOS JUNTOS

f.freeze(\nota_con_harmonicos, [q.fundamental, q.first_harmonic, q.second_harmonic, q.third_harmonic, q.fourth_harmonic, q.fifth_harmonic], sustain: 1.0, memLength: 0.25);

~nota = \nota_con_harmonicos;
~nota_amp = { 1.0 };
~nota_amp.fadeTime_(5.0);
~nota_vca = { ~nota * ~nota_amp };

~out = { ~nota_vca * 0.4 }
~out.play

s.freqscope;

// HAROMONICOS POR SEPARADO

f.freeze(\fundamental, [q.fundamental] , sustain: 1.0, memLength: 0.25);
f.freeze(\first_harmonic, [q.first_harmonic] , sustain: 1.0, memLength: 0.25);
f.freeze(\second_harmonic, [q.second_harmonic] , sustain: 1.0, memLength: 0.25);
f.freeze(\third_harmonic, [q.third_harmonic] , sustain: 1.0, memLength: 0.25);

~fundamental = \fundamental;
~first_harmonic = \first_harmonic;
~second_harmonic = \second_harmonic;
~third_harmonic = \third_harmonic;




~out = { ((~fundamental * SinOsc.ar(0.25, add: 1, mul: 0.5) * 0.01) + (~first_harmonic * SinOsc.ar(0.33, add: 1, mul: 0.5)) + (~second_harmonic * -5.0)+ (~third_harmonic * 1.0)) * 0.4 }
~out.play
