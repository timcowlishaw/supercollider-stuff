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
~c_amp = { 0.7 };
~c_amp.fadeTime_(5.0);
~c_vca = { ~c * ~c_amp };

~bflat = \bflat_freezer;
~bflat_amp = { 0.0 };
~bflat_amp.fadeTime_(5.0);
~bflat_vca = { ~bflat * ~bflat_amp };

~e = \e_freezer;
~e_amp = { 0.0 };
~e_amp.fadeTime_(5.0);
~e_vca = { ~e * ~e_amp };

~aflat = \aflat_freezer;
~aflat_amp = { 0.7 };
~aflat_amp.fadeTime_(5.0);
~aflat_vca = { ~aflat * ~aflat_amp };

~bnatural = \bnatural_freezer;
~bnatural_amp = { 0.0 };
~bnatural_amp.fadeTime_(5.0);
~bnatural_vca = { ~bnatural * ~bnatural_amp };

~out = { (~f_vca + ~c_vca + ~bflat_vca + ~e_vca + ~aflat_vca + ~bnatural_vca) * 0.5 }
~out.play

s.freeAll
