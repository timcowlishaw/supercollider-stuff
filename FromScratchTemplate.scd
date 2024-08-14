p = ProxySpace().push(s.boot);
q = ();

q.root = 69.296;
q.scale = Scale.dorian.ratios;


~octave = { 3 };
~detune = { 0.0 };
~detune_rate_left = { 0 };
~detune_rate_right = { 0 };
~detune_phase_diff = { 0};

~root = { [ q.root * 2.pow(~octave) + SinOsc.ar(~detune_rate_left, mul: ~detune), q.root  * 2.pow(~octave) + SinOsc.ar(~detune_rate_right, phase: ~detune_phase_diff, mul: ~detune) ] };

~fund1 = { (~root * 2.pow(1) * q.scale[0]) };
~fund1.fadeTime_(1.0);
~freq1 = { ~fund1 };
~amp1 = { 0.05 };
~osc1 = { SinOsc.ar(~freq1) * ~amp1 };


~mix = { ~osc1  };
~mix.fadeTime_(10);
~level = { 1.0 };
~level.fadeTime_(2.0);
~master = { ~mix * ~level };
~master.play;



