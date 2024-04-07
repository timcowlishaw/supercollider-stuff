// "cannot believe that we taught rocks to whisper Secret Numbers so vast that
// their names have never before and will never be spoken again in the long span of
// human time, and we use them to key databases for e-commerce systems"
// — @est@emily.news, 12 August 2023 (https://social.emily.news/@est/110874771638696468)



Server.default = s = Server.local.boot; // start local server





(Looper())



{ Amplitude.kr(SoundIn.ar(0)); }.scope;

b.getToFloatArray


~looper.free


(
{ var trig, rate, x, sr;
    rate = MouseX.kr(0.2, 2, 1);
    trig = Impulse.ar(rate);
    sr = SampleRate.ir;
    x = Phasor.ar(trig, rate / sr);
    SinOsc.ar(
        [
            LinLin.kr(x, 0, 1, 600, 1000), // convert range from 0..1 to 600..1000
            1000 // constant second frequency
        ], 0, 0.2)

}.play;
)