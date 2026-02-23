

















//First, the setup:

q = ();
p = ProxySpace().push(s.boot);


~sin335 = { SinOsc.ar([345, 350]) * 0.5 }

~sin335.play(fadeTime: 10)

~sin335.stop





~sin1200 = { SinOsc.ar([337*3 + 0, 335*3 + 0]) * 0.2 }

~sin1200.play(fadeTime: 10)

~sin1200.stop

~sin1201 = { SinOsc.ar([337*3 + 50, 335*3 + 50]) * 0.2 }

~sin1201.play(fadeTime: 10)

~sin1201.stop

(
~xfade = {
  XFade2.ar(~sin1200, ~sin1201, LFTri.kr(0.15)) * LFTri.kr(0.03).range(0, 1)
}
)

~xfade.play(fadeTime: 10)

~xfade.stop

~sin335.stop




~fa = { SinOsc.ar(Note("F3").freq * ())  * 0.5 }

~fa.play

~fa.stop


[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13].collect { |h| (h * 345).mid }

Note
.


~mibemol_beating = { LFTri.kr(0.25).range(0, LFTri.kr(0.01.range(0, 2))) }

~mibemol  = { SinOsc.ar([Note("Eb2").freq + ~mibemol_beating, Note("Eb2").freq - ~mibemol_beating]) * 0.1}



~rebemol_beating = { LFTri.kr(0.1).range(0, 0) }

~rebemol  = { SinOsc.ar([Note("Db2").freq + ~rebemol_beating, Note("Db2").freq - ~rebemol_beating]) * 0.1}


~xfade_cv = { -1 } // LFTri.kr(0.1) } // LFTri.kr(0.1) }

~xfade_cv.fadeTime = 5

~xfade = { XFade2.ar(~mibemol, ~rebemol, ~xfade_cv) * Saw.kr(SinOsc.kr(0.05).range(1, 3), 0.1) }

~xfade.stop(fadeTime: 10)

~la_beating = 0
~la  = { SinOsc.ar([Note("A4").freq + ~la_beating, Note("A4").freq - ~la_beating]) * 0.01 }

~la.stop(fadeTime: 10)

~sibemol_beating = { LFTri.kr(0.07).range(1, 2) }
~sibemol2  = { SinOsc.ar([Note("Bb4").freq + ~sibemol_beating, Note("Bb4").freq - ~sibemol_beating]) * Saw.kr(SinOsc.kr(0.8).range(0, 4), 0.1) }

~sibemol2.stop(fadeTime: 10)


~fa_beating = 3


~fa  = { SinOsc.ar([Note("F4").freq + ~fa_beating, Note("F4").freq - ~fa_beating]) * (Saw.kr(SinOsc.kr(0.1).range(2, 15), 0.05) + 0.05) }

~fa.stop(fadeTime: 10)

~do_beating = 2
~do  = { SinOsc.ar([Note("C5").freq + ~do_beating, Note("C5").freq - ~do_beating]) * 0.01 }

~do.stop(fadeTime: 10)


~fasq = { LPF.ar(Saw.ar([Note("F4").freq, Note("F4").freq + 0.01]), LFTri.kr(0.1).range(200, 300)) }

~fasq.pause(fadeTime: 10)

