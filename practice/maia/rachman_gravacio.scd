
p = ProxySpace().push(s.boot);
f = Freezer2.new(s, p);



f.load(\piano_1, "/home/tim/Documents/REAPER Media/rachmaninof-001.wav")
f.load(\piano_2, "/home/tim/Documents/REAPER Media/rachmaninof-002.wav")
f.load(\piano_3, "/home/tim/Documents/REAPER Media/rachmaninof-003.wav")

f.freeze(\piano_rec, duration: 5.0)







f.thaw(\c_1, \piano_rec,  fundamental: Note("C#2").freq, rate: 0.001, highHarmonic: 3, lowHarmonic: 1)


~c_1.set(\rate, 0.1)

~c_1.play(fadeTime: 10)

f.thaw(\c_2, \piano_3,  fundamental: Note("G#2").freq, rate: 0.01, highHarmonic: 2, lowHarmonic: 1)

~c_2.play(fadeTime: 10)

f.thaw(\c_3, \piano_3,  fundamental: Note("C#3").freq, rate: 0.01, highHarmonic: 2, lowHarmonic: 1)

~c_3.play(fadeTime: 10)


f.thaw(\a_3, \piano_1,  fundamental: Note("E5").freq, rate: 0.01, highHarmonic: 2, lowHarmonic: 1)
~a_3.play(fadeTime: 10)














////---------

~a_1.set(\lowHarmonic, 1)


~a_1.set(\highHarmonic, 3)

~a_1.set(\rate, 0.001)


~a_1.set(\fundamental, Note("C#2").freq)



f.thaw(\b_1, \piano_2,  fundamental: Note("E4").freq, rate: 0.05, highHarmonic: 6, lowHarmonic: 1)

~b_1.play(fadeTime: 10)

~b_1.set(\highHarmonic, 3)

~b_1.set(\fundamental, Note("D5").freq)

f.thaw(\c_1, \piano_1,  fundamental: Note("F#4").freq, rate: 0.05, highHarmonic: 3, lowHarmonic: 1)

~c_1.play(fadeTime: 10)

~c_2.release(fadeTime: 20)

f.thaw(\c_2, \piano_1,  fundamental: Note("G#3").freq, rate: 0.05, highHarmonic: 3, lowHarmonic: 1)

~c_2.play(fadeTime: 10)


///-------



f.thaw(\a_1, \piano_1,  fundamental: Note("B2").freq, rate: 0.01, highHarmonic: 3, lowHarmonic: 1)
~a_1.play(fadeTime: 10)

f.thaw(\a_2, \piano_1,  fundamental: Note("G#3").freq, rate: 0.01, highHarmonic: 3, lowHarmonic: 1)
~a_2.play(fadeTime: 10)

f.thaw(\b_1, \piano_1,  fundamental: Note("D3").freq, rate: 0.01, highHarmonic: 3, lowHarmonic: 1)

~b_1.play(fadeTime: 10)



