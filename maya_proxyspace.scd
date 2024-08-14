p = ProxySpace().push(s.boot);
q = ();

(
q.memLength = 10;
q.fftSize = 16384;
"length".postln;
q.prevOut1 = Buffer.alloc(s, q.memLength.calcPVRecSize(q.fftSize, 0.5, s.sampleRate), 1);
q.prevOut1.zero;
"prevout".postln;
q.freqs1= #[587.33, 1046.5, 659.255, 880, 1567.982];
q.bins1 = q.freqs1.collect({ |freq| ((q.fftSize/s.sampleRate) * freq).round.asInteger });
"bins".postln;
q.mags1 = Array.zeroFill(q.fftSize).collect({ |v, i| q.bins1.includes(i).asInteger.asFloat});
"mags".postln;
q.phases1 = Array.zeroFill(q.fftSize);
"phases".postln;

SynthDef("freezer1", { |out, gate=1, fadeTime=0.1|
  var input, synthesized, inputFFT, inputFFTBuf, synthesizedFFT, synthesizedFFTBuf, chain, prevOut, prevOutFFTBuf, recChain;
  input = SoundIn.ar(0);
  inputFFTBuf = LocalBuf(q.fftSize);
  inputFFT = FFT(inputFFTBuf, input, 0.5);
  synthesizedFFTBuf = LocalBuf(q.fftSize);
  synthesizedFFT = PackFFT(synthesizedFFTBuf, q.fftSize, [q.mags1, q.phases1].flop.flatten, 0, q.fftSize, 1);
  chain = PV_MagMul(inputFFT, synthesizedFFT);
  prevOutFFTBuf = LocalBuf(q.fftSize);
  prevOut = PV_PlayBuf(prevOutFFTBuf, q.prevOut1, rate: 0.25, loop: 1.0);
  chain = chain.pvcalc2(prevOut, q.fftSize, { |mags, phases, mags2, phases2|
		[ mags.max(mags2 * 0.8), phases2 + phases  ]
  }, frombin: 0, tobin: q.fftSize, zeroothers: 0);
  chain = PV_RecordBuf(chain, q.prevOut1, hop:0.5, run: 1.0, loop: 1.0);
  Out.ar(out,
    (10 *  IFFT(chain, q.fftSize).dup) *
    EnvGen.kr(Env.asr(fadeTime, 1, fadeTime), gate, doneAction: Done.freeSelf)
  )
}).add

)


Scale.dorian()

q.prevOut1.zero

~foo = { Synth("freezer1")  }

~foo.play;



~freezer1.play;

~freezer1.fadeTime(10)

~freezer1[0] = \freezer1;

~freezer1[10] = { |in| in * SinOsc.kr(SinOsc.kr(1.0, mul: 3.0), mul: 5.0, add: 0.0) }

{ ~freezer1 * SinOsc.kr(SinOsc.kr(0.25), mul: 2.0) }.play;

~freezer.play

~out.play

~out = ~freezer

s.freeAll

(
SynthDef(\test, { |out, gate=1, fadeTime=0.1|
  Out.ar(out,
    SinOsc.ar(440) *
    EnvGen.kr(Env.asr(fadeTime, 1, fadeTime), gate, doneAction: Done.freeSelf)
  )
}).add
)


~test2 = \test

~test2.play

~test2.fadeTime_(10)

~test.stop

// if you supply a gate it fades in and out. evaluate this several times
(
~out = SynthDef("w", { arg out=0, gate=1.0, fadeTime = 0.1;
    Out.ar(out,
        SinOsc.ar([Rand(430, 800), Rand(430, 800)], 0, 0.2)
            * EnvGen.kr(Env.asr(fadeTime, 1, fadeTime), gate, doneAction: Done.freeSelf)
    )
    });
)

~out.play

(
SynthDef("staub", { arg out, gate=1, fadeTime = 0.1;
    Out.ar(out,
        Ringz.ar(Dust.ar(15), Rand(1, 3) * 3000*[1,1], 0.001)
        * EnvGen.kr(Env.asr(fadeTime, 1, fadeTime), gate, doneAction: Done.freeSelf)
    )
}).add;
)

~out = nil;

~out.fadeTime = 10

~out.play

s.freeAll
