p = ProxySpace().push(s.boot);
q = ();
f = TimFreezer.new(s, q);

f.freeze(\f_freezer_continuous, [174.61], sustain: 1.0, memLength: 0.25);
f.freeze(\f_freezer_ondulaciones, [174.61], sustain: 0.7, memLength: 0.5);
f.freeze(\aflat_freezer_continuous, [415.30], sustain: 1.0, memLength: 0.25);
f.freeze(\aflat_freezer_ondulaciones, [415.30], sustain: 0.7, memLength: 0.5);

~f_continuous = \f_freezer_continuous;
~f_ondulaciones = \f_freezer_ondulaciones;
~f_smoothness = { 0 }
~f = { XFade2.ar(~f_continuous, ~f_ondulaciones, ~f_smoothness) }
~f_amp = { 1.0 };
~f_amp.fadeTime_(5.0);
~f_vca = { ~f * ~f_amp };

~c = \c_freezer;
~c_amp = { 1.0 };
~c_amp.fadeTime_(5.0);
~c_vca = { ~c * ~c_amp };

~aflat_continuous = \aflat_freezer_continuous;
~aflat_ondulaciones = \aflat_freezer_ondulaciones;
~aflat_smoothness = { 0 }
~aflat = { XFade2.ar(~aflat_continuous, ~aflat_ondulaciones, ~aflat_smoothness) }
~aflat_amp = { 1.0 };
~aflat_amp.fadeTime_(5.0);
~aflat_vca = { ~aflat * ~aflat_amp };


~xfaderate = { 0.5 }
~xfaderate.fadeTime_(5.0)

~xfade = { 0.5 } // SinOsc.kr(~xfaderate) }

~out = { XFade2.ar(~f_vca, ~aflat_vca, ~xfade) * 0.4 }
~out = { (~f_vca + ~aflat_vca) * 0.4 }
~out.play

s.freeAll


