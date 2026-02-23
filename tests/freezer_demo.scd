p = ProxySpace().push(s.boot);
q = ();
f = TimFreezer.new(s, q);

// Todes aquestes lineas tardan un minut cadascú per a evaluar, tot i que ho farem de cop al inici
f.freeze(\mi_freezer, [82.41, 164.81, 329.63, 659.25]);
f.freeze(\la_freezer, [440, 880, 1760], sustain: 0.9);
f.freeze(\re_freezer, [587.33, 1174.66, 2349.32], sustain: 0.7);

~mi = \mi_freezer;
~mi_lfo_rate =  { SinOsc.kr(0.1, mul: 2.5) };
~mi_lfo = { SinOsc.kr(~mi_lfo_rate) };
~mi_vca = { ~mi_lfo * ~mi };

~la = \la_freezer;
~la_lfo_rate =  { SinOsc.kr(0.19, mul: 3.667); };
~la_lfo = { SinOsc.kr(~la_lfo_rate) };
~la_vca = { ~la_lfo * ~la };

~re = \re_freezer;
~re_lfo_rate =  { SinOsc.kr(0.25, mul: 6) };
~re_lfo = { SinOsc.kr(~re_lfo_rate) };
~re_vca = { ~re_lfo * ~re };

~cross = { ~la_vca * ~re_vca };
~cross_level = { 0.0 };

~out = { ~la_vca + ~re_vca + ~mi_vca + (~cross * ~cross_level) }

~out.fadeTime_(10)
~out.vol_(1)
~out.play

s.freeAll

q.keys
