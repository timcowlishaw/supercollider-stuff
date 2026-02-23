~o = { SinOsc.ar(LFPar.kr(105, 0, 400, 400),0, 0.01) }
~o.play(fadeTime: 10);
~o.release(10);


~p =  { SinOsc.ar([280], 0, LFNoise2.kr(1))!2}
~p.play(fadeTime: 10);
~p.release(10);


~a = { SinOsc.ar([105, 107], 0, 30.3) }
~a.play(fadeTime: 10);
~a.release(10);

~b = { SinOsc.ar([220, 221.6], 0, 0.5)}
~b.play(fadeTime: 10);
~b.release(10);

~c = { SinOsc.ar([345, 348], 0, 0.2) }
~c.play(fadeTime: 10);
~c.release(10);

~d = { SinOsc.ar(2222, 0, 0.2) !2}
~d.play(fadeTime: 10);
~d.release(10);

~e = { SinOsc.ar(2224, 0, 0.2)!2 }
~e.play(fadeTime: 10);
~e.release(10);

~f = { SinOsc.ar([670,672.5], 0, 0.2) }
~f .play(fadeTime: 10);
~f.release(10);

~g = { SinOsc.ar([523, 261.5], 0, 0.2) }
~g.play(fadeTime: 10);
~g.release(10);

280,
150, 107
220, 221.6 // FALTA AIXÒ
345, 348,
2222,
2224
670, 672.5
523, 261.5
