
p = ProxySpace().push(s.boot);
f = Freezer2.new(s, p);



f.load(\material_1, "/home/tim/Documents/REAPER Media/sines-001.wav")
f.load(\material_2, "/home/tim/Documents/REAPER Media/sines-002.wav")
f.load(\material_3, "/home/tim/Documents/REAPER Media/sines-003.wav")


f.thaw(\a_1, \material_1,  fundamental: 280, rate: 1.0, highHarmonic: 3)
~a_1.play(fadeTime: 10)





f.thaw(\a_2, \material_2, fundamental: 150, rate: 1.0, highHarmonic: 3)
~a_2.play(fadeTime: 10)


f.thaw(\a_3, \material_3, fundamental: 107, rate: 1.0, highHarmonic: 3)
~a_3.play(fadeTime: 10)


~a_2.set(\rate, 0.01)
~a_1.set(\rate, 0.08)
~a_3.set(\rate, 0.23)


~topHarmonic = { SinOsc.kr(0.001).range(2, 3) }

~highHarmonic1 = { LFNoise2.kr(500).range(1, ~topHarmonic) }
~highHarmonic2 = { LFNoise2.kr(500).range(1, ~topHarmonic) }
~highHarmonic3 = { LFNoise2.kr(500).range(1, ~topHarmonic) }

~highHarmonic1 <>>.highHarmonic ~a_1
~highHarmonic2 <>>.highHarmonic ~a_2
~highHarmonic3 <>>.highHarmonic ~a_3

~baseTransitionProb = { 0.01 };

~fundamental1 = { TChoose.kr(Dust.kr(~baseTransitionProb), [280, 280*2, 280]) }
~fundamental2 = { TChoose.kr(Dust.kr(~baseTransitionProb * 3), [150, 150*3, 150]) }
~fundamental3 = { TChoose.kr(Dust.kr(~baseTransitionProb * 0.77), [107, 107*5, 107]) }

~fundamental1 <>>.fundamental ~a_1
~fundamental2 <>>.fundamental ~a_2
~fundamental3 <>>.fundamental ~a_3

~a_1_shifted = { PitchShift.ar(~a_1, pitchRatio: 0.25) }

~a_1_shifted.play(fadeTime: 10.0)


~a_1.release(10)
~a_2.release(10)
~a_3.release(10)
~a_1_shifted.release(10)
