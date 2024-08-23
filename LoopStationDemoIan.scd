p = ProxySpace().push(s.boot);
q = ();
l = LoopStation.new(s, p, q, fftSize:16384, hop: 0.25, win: 1);
d = FoaDecoderMatrix.newStereo
m = FOAMixer.new(s, p, q, d)
m.output.play

l.listen(\gtr1, 20)

~out = { ~gtr1 }

~gtr1_spec_mix = 1.0

~gtr1_rate = 2.0
º
p

~out.play
