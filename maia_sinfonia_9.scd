p = ProxySpace().push(s.boot);
q = ();
f = TimFreezer.new(s, q);

f.freeze(\f_freezer, [174.61, 698.46], sustain: 0.8, memLength: 0.5);
f.freeze(\c_freezer, [65.406, 130.81], sustain: 0.7, memLength: 0.5);
f.freeze(\bflat_freezer, [233.08], sustain: 0.5, memLength: 0.5);
f.freeze(\e_freezer, [329.63], sustain: 0.4, memLength: 0.5);
f.freeze(\aflat_freezer, [415.30], sustain: 0.5, memLength: 0.5);
f.freeze(\bnatural_freezer, [493.88], sustain: 0.3, memLength: 0.5);

~f = \f_freezer;
~f_amp = { 1.0 };
~f_amp.fadeTime_(5.0);
~f_vca = { ~f * ~f_amp };

~c = \c_freezer;
~c_amp = { 1.0 };
~c_amp.fadeTime_(5.0);
~c_vca = { ~c * ~c_amp };

~bflat = \bflat_freezer;
~bflat_amp = { 1.0 };
~bflat_amp.fadeTime_(5.0);
~bflat_vca = { ~bflat * ~bflat_amp };

~e = \e_freezer;
~e_amp = { 1.0 };
~e_amp.fadeTime_(5.0);
~e_vca = { ~e * ~e_amp };

~aflat = \aflat_freezer;
~aflat_amp = { 1.0 };
~aflat_amp.fadeTime_(5.0);
~aflat_vca = { ~aflat * ~aflat_amp };

~bnatural = \bnatural_freezer;
~bnatural_amp = { 1.0 };
~bnatural_amp.fadeTime_(5.0);
~bnatural_vca = { ~bnatural * ~bnatural_amp };

~f_third_amount = { PulseDPW.ar(3.33, add: 1.0, mul: 0.5) }
~f_minor_chord = { ~f_vca + ~c_vca + (~f_third_amount * ~aflat_vca) }

~c_seventh_crossfade = { -1 }
~c_seventh_crossfade.fadeTime_(0.0);
~c_seventh_amount = { SinOsc.ar(0.5, add: 1.0, mul: 0.5) }
~c_7_chord = { ~c_vca + ~e_vca + ( ~c_seventh_amount * XFade2.ar(~bflat_vca, ~bnatural_vca, ~c_seventh_crossfade)) }

~chord_crossfade = { PulseDPW.ar(1) }
~chord_crossfade.fadeTime_(0.2);

~out = { XFade2.ar(~f_minor_chord, ~c_7_chord, ~chord_crossfade) * 0.4 }
~out.play

s.freeAll


