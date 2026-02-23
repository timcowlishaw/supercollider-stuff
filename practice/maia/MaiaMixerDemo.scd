


















p = ProxySpace().push(s.boot);
q = ();

m = FOAMixer.new(s, p, q, maxLevel:5.0, defaultLevel: 0.7, defaultFb: 0.7, defaultFadeTime: 4.0);

d = FoaDecoderMatrix.newPanto(2)
~out = { FoaDecode.ar(m.bus.ar, d) };
~out.play


~sin = { (SinOsc.ar(200) + SinOsc.ar(203)) * Saw.ar(50, 0.6)  }

m.add(~sin, level: 0.0)

~sin_level.fadeTime = 10

~sin_level = 0.0

~sin2 = { (SinOsc.ar(537) + SinOsc.ar(540)) * Saw.ar(10, 0.6)  }

m.add(~sin2)

~sin2_level = 0.0

~sin2_insert = { CombL.ar(~sin2.ar, 5.0, 0.1, 2.0) }


