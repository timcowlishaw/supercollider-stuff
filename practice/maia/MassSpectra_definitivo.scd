Server.default.options.inDevice = "Windows DirectSound : Analogue 1 + 2 (Focusrite USB Audio)";

Server.default.options.outDevice = "Windows DirectSound : Speakers (Focusrite USB Audio)   (device #14 with 0 ins 6 outs)";


p = ProxySpace().push(s.boot);
f = Freezer2.new(s, p);



f.freeze(\sticks, duration: 5.0); // sticks

f.thaw(\sticks_1, \sticks, fundamental: 150, rate: 0.1, highHarmonic: 10)
~sticks0 = { ~sticks_1 * 0.6 }
~sticks0.play(fadeTime: 20)
~sticks0.stop(fadeTime: 20)


f.freeze(\ebow_2803, duration: 2.0); // guitar-sine 280Hz

f.thaw(\ebow_280_3, \ebow_2803, fundamental: 280, rate: 0.01, highHarmonic: 2, lowHarmonic: 1)

~ebow_280 = { (~ebow_280_3 * LFNoise2.kr(SinOsc.kr(3).range(1,11))) * 5 }
~ebow_280.play(fadeTime: 20)
~ebow_280.stop(fadeTime: 20)

~ebow_280_frito3 = { ~ebow_280_3 * Saw.ar(LFNoise2.ar(3234).range(350, 400), mul: LFBrownNoise1.ar(1.0, mul: 0.1)) }
~ebow_280_frito3.play(fadeTime:20)
~ebow_280_frito3.stop(fadeTime: 20)



f.freeze(\ebow_150, duration: 1.0); // guitar-sine 150Hz

f.thaw(\ebow_150_1, \ebow_150, fundamental: 150, rate: 0.01, highHarmonic: 2)
	~ebow_150_1.set(\rate, 0.0001)
	~ebow_150 = { (~ebow_150_1 + SinOsc.ar(301 + LFNoise2.kr(1).range(0, 5), mul: 0.1)) * 0.06} // LFNoise2.kr(1)
~ebow_150.play(fadeTime: 20)
~ebow_150.stop(fadeTime: 20)



f.freeze(\ebow_3450, duration: 0.250); // guitar-sine 345Hz

f.thaw(\ebow_345_10, \ebow_3450, fundamental: 345, rate: 0.01, highHarmonic: 2)

~ebow_345_10.set(\highHarmonic, 3)

~ebow_3450 = { ~ebow_345_10 * 2 }
~ebow_3450.play(fadeTime: 20)
~ebow_3450.stop(fadeTime: 20)



f.freeze(\bow, duration: 5); // arco

f.thaw(\bow_1, \bow, fundamental: 150, rate: 0.01, highHarmonic: 8)
~bow = { ~bow_1 * 0.7}
~bow.play(fadeTime: 20)
~bow.stop(fadeTime: 20)



 // for the final part, to play with guitar + tools
~in = { SinOsc.ar(1450, mul:0.9) * CombL.ar(SoundIn.ar(0, mul: 0.2), delaytime: 0.15, decaytime: 1.5) } // "In" signal + effects
~in.play(fadeTime: 20)
~in.stop(fadeTime: 20)







