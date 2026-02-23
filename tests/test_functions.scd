p = ProxySpace().push(s.boot);
q = ();
f = ();
l = LoopStation.new(s, p, q, fftSize:16384, hop: 0.25, win: 1, recFadeTime:0.1, defaultFadeTime: 2.0);

m = FOAMixer.new(s, p, q, maxLevel:5.0, defaultLevel: 0.7, defaultFb: 0.7, defaultFadeTime: 4.0);

~foa_mixer_master_fader = 3.0;

d = FoaDecoderMatrix.newPanto(2)
~mixer_decoded = { FoaDecode.ar(m.bus.ar, d) };

~reverb_mix = 0.6
~reverb_size = 1.0
~reverb_damp = 0.4

~out = { FreeVerb.ar(~mixer_decoded, room: ~reverb_size, damp: ~reverb_damp, mix: ~reverb_mix) }

~out.play

(f.addDelay = { |name, time, decay|
  [name, time, decay].poll;
  p[(name ++ "_insert").asSymbol] = { CombL.ar(p[name].ar, delaytime: time, maxdelaytime: time * 3, decaytime: decay) }
})

~test = { SinOsc.ar(SinOsc.kr(0.2).range(440, 880), mul: SinOsc.kr(0.33).range(0, 1)) }

m.add(~test)

f.addDelay(\test, 500, 5000)


(f.addToProxySpace = { |space, name, func|
  space[name] = func
})


f.addToProxySpace(p, \test2, { SinOsc.ar(220) } )

p

m.add(~test2)
