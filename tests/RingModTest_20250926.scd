p = ProxySpace().push(s.boot);
q = ();

m = FOAMixer.new(s, p, q, maxLevel:5.0, defaultLevel: 0.7, defaultFb: 0.7, defaultFadeTime: 4.0);

~foa_mixer_master_fader = 3.0;

d = FoaDecoderMatrix.newPanto(2)
~mixer_decoded = { FoaDecode.ar(m.bus.ar, d) };

~mixer_decoded.play

~carrier_freq = { 500 }
~carrier = { SinOsc.ar(~carrier_freq) }

~modulator_freq = { SinOsc.kr(0.2).range(500, 505) }
~modulator = { SinOsc.ar(~modulator_freq) }

~ring = { ~carrier * ~modulator }


m.add(~ring, level: 0.5)
m.add(~carrier, level: 0.5)

~ring_angle = 0.5 * pi
~carrier_angle = 0.5 * pi

~ring_azim = { SinOsc.kr(0.3) }
~carrier_azim = { SinOsc.kr(0.7) }
