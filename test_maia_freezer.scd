p = ProxySpace().push(s.boot);
f = Freezer2.new(s, p);


f.freeze(\ebow_280, duration: 5.0); // guitar-sine 280Hz

f.thaw(\ebow_280_1, \ebow_280, fundamental: 280, rate: 0.01, highHarmonic: 2)

~ebow_280 = { ~ebow_280_1 }

~ebow_280_frito3 = { ~ebow_280_1 * Saw.ar(LFNoise2.ar(3234).range(350, 400), mul: LFBrownNoise1.ar(1.0, mul: 0.2)) }

~ebow_280.play(fadeTime: 10)

~ebow_280.pause()

~ebow_280_frito3.play(fadeTime:10)

f.freeze(\ebow_150, duration: 5.0); // guitar-sine 150Hz

f.thaw(\ebow_150_1, \ebow_150, fundamental: 150, rate: 0.01, highHarmonic: 2)

~ebow_150 = { ~ebow_150_1 }

~ebow_150.play(fadeTime: 10)
