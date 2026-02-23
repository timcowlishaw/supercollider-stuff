p = ProxySpace().push(s.boot);

q = ();
f = TimFreezer.new(s, q);


q.fundamental = 164.81; //E3           //1st partial
q.first_harmonic = q.fundamental * 2;  //2nd partial
q.second_harmonic = q.fundamental * 3; //3rd partial
q.third_harmonic = q.fundamental * 4;  //4th partial
q.fourth_harmonic = q.fundamental * 5; //5th partial
q.fifth_harmonic = q.fundamental * 6;  //6th partial, 699.246Hz-->Fa5
q.sixth_harmonic = q.fundamental * 7;    //7th partial, 815.787Hz-->Sol#5~~~~
q.seventh_harmonic = q.fundamental * 8;    //8th partial, 932.328Hz-->La#5
q.eighth_harmonic = q.fundamental * 9;    //9th partial, 1.048.869Hz-->Do6 ++++
q.ninth_harmonic = q.fundamental * 10;    //10th partial, 1.165.410Hz-->(1174,66Hz)Re6 ++++
q.tenth_harmonic = q.fundamental * 11;    //11th partial, 1.281.951Hz-->(1318,51hz)Mi6 ~~~~
q.eleventh_harmonic = q.fundamental * 12;    //12th partial, 1.398.492Hz-->(1396,91Hz)Fa6 +++
q.twelfth_harmonic = q.fundamental * 13;    //13th partial, 1.515.033Hz-->(1479,98Hz)Fa#6
q.thirteenth_harmonic = q.fundamental * 14;  //14th partial, 1.631.574Hz-->(1661,22Hz)Sol#6
q.fourteenth_harmonic = q.fundamental * 15; //15th partial, 1.748.115Hz-->(1760,00Hz)La6 ++++
q.fifteenth_harmonic = q.fundamental * 16;    //16th partial, 1.864.656Hz-->(1864,66)La# ++++


f.freeze(\fundamental, [q.fundamental], sustain: 1.0, memLength: 0.25);
f.freeze(\fundamental_detune, [q.fundamental + 1], sustain: 1.0, memLength: 0.25);

f.freeze(\sixth_harmonic, [q.sixth_harmonic], sustain: 0.999, memLength: 0.05);
f.freeze(\sixth_harmonic_detune, [q.sixth_harmonic + 2], sustain: 0.999, memLength: 0.05);

f.freeze(\eighth_harmonic, [q.eighth_harmonic], sustain: 0.999, memLength: 0.05);
f.freeze(\eighth_harmonic_detune, [q.eighth_harmonic + 3], sustain: 0.999, memLength: 0.05);

~fundamental = \fundamental
~fundamental_detune = \fundamental_detune

~sixth_harmonic = \sixth_harmonic
~sixth_harmonic_detune = \sixth_harmonic_detune

~eighth_harmonic = \eighth_harmonic
~eighth_harmonic_detune = \eighth_harmonic_detune



~out = { ((0.1 * ~fundamental)) + ( ((0.5 * ~fundamental)) * (0.4 * Saw.ar(SinOsc.kr(0.1, phase: LFNoise0.ar(500), add: 5, mul: 5)))) }


~out = { ~eighth_harmonic + ~eighth_harmonic_detune + SinOsc.ar(q.eighth_harmonic + 1) + ~sixth_harmonic + ~sixth_harmonic_detune }

~out.pause

~out = {
  (3.0 * ~sixth_harmonic) + (0.1 * SinOsc.ar(q.sixth_harmonic + 1)) +
  (3.0 * ~eighth_harmonic) + (0.1 * SinOsc.ar(q.eighth_harmonic + 5))
}

