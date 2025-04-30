q = ();
p = ProxySpace().push(s.boot);
m = FOAMixer.new(s, p, q, maxLevel:5.0, defaultLevel: 0.7, defaultFb: 0.7, defaultFadeTime: 4.0);

~foa_mixer_master_fader = 1.0;

d = FoaDecoderMatrix.newPanto(2)
~mixer_decoded = { FoaDecode.ar(m.bus.ar, d) };

~out = { ~mixer_decoded }

~out.play


//luego puedes hacer:

~a_node = { SinOsc.ar(440) } // no des "play"

m.add(~a_node, level: 0.5) // va reproduciendo automaticamente

~a_node_level = 0.7 //para subir y bajar
