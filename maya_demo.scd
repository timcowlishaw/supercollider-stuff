
~microfono = { SoundIn.ar };
~microfono.scope // o lo que sea

q.frecuencia_que_nos_interesa = 440.0

~filtered = { BPF.ar(~microfono, q.frecuencia_que_nos_interesa, rq:1000.0) }; // con un "q" bien estrecho







~trigger = {   }.scope;//nos falta algo para sostener despues

~osc = { SinOsc.ar(q.frecuencia_que_nos_interesa) }

~out = { ~env * ~osc }

~out.play;


//// FFT COSAS DESDE Loopstation


// GRABAR MICROFONO A UN BUFFER
var fftSize = 8192;
var win = 1 // no recuerdo que window es esto
var dutation = 10.0; //  o lo que sea
var buffer = Buffer.alloc(server, duration * server.sampleRate, 1);
var recHead = Phasor.ar(0, BufRateScale.kr(bufnum), 0, BufFrames.kr(bufnum));
var inputSig = SoundIn.ar(0);
BufWr.ar(inputSig, buffer.bufnum, recHead);

// Hacer el FFT

var localbuf, chain, sig, playHead;
playHead = Phasor.ar(0, BufRateScale.kr(buffer), 0, BufFrames.kr(buffer));
sig = BufRd.ar(1, buffer, playHead);
localbuf = LocalBuf.new(fftSize);
chain = FFT(localbuf, sig, hop, win);
chain = PV_()
IFFT.ar(chain, win).play;


~test = { Latch.kr(1.0, Tartini.kr(SoundIn.ar)[0].round == 440.0) }
~test.scope;

~test.pause


//// NEW APPROACH: synthesize the sines we're interested in, multiply magnitudes with input signal and freeze if mag is higher than last seen.

//// IT WORKS!!

~prevOut = Buffer.alloc(s, 16384);

(
SynthDef("freezer", { |prevOut, freqs=#[440, 880],  threshold=0.7, out=0|
  var input, synthesized, inputFFT, inputFFTBuf, synthesizedFFT, synthesizedFFTBuf, chain;
  input = SoundIn.ar(0);
  synthesized = freqs.collect({ arg freq; SinOsc.ar(freq) }).inject(Silent.ar, { arg sum, osc; sum + osc });

  inputFFTBuf = LocalBuf(16384);
  inputFFT = FFT(inputFFTBuf, input);
  synthesizedFFTBuf = LocalBuf(16384);
  synthesizedFFT = FFT(synthesizedFFTBuf, synthesized);
  chain = PV_MagAbove(inputFFT, threshold);
  chain = PV_MagMul(inputFFT, synthesizedFFT);
  //chain = PV_Max(chain, prevOut);
  //chain = PV_RecordBuf(chain, prevOut, run: 1);
  chain = PV_Copy(chain, prevOut);
  Out.ar(out, 0.1 * IFFT(prevOut, 16384).dup)
}).play(s, args: [\prevOut, ~prevOut, \freqs, [554.37, 1318.51, 987.77]]) // Set frequencies here, and tune threshold if need be.
)

~prevOut.plot

s.freeAll

//// REFCACTORING


(
~memLength = 1;
~prevOut = Buffer.alloc(s, ~memLength.calcPVRecSize(16384, 0.5, s.sampleRate), 1);

~freqs= #[587.33, 1046.5, 440, 880, 1760];
~bins = ~freqs.collect({ |freq| ((16384/48000.0) * freq).round.asInteger });
~mags = Array.zeroFill(16384).collect({ |v, i| ~bins.includes(i).asInteger.asFloat});
~phases = Array.zeroFill(16384);

SynthDef("freezer", { |prevOut, out=0|
  var input, synthesized, inputFFT, inputFFTBuf, synthesizedFFT, synthesizedFFTBuf, chain;
  input = SoundIn.ar(0);
  inputFFTBuf = LocalBuf(16384);
  inputFFT = FFT(inputFFTBuf, input, 0.5);
  synthesizedFFTBuf = LocalBuf(16384);
  synthesizedFFT = PackFFT(synthesizedFFTBuf, 16384, [~mags, ~phases].flop.flatten, 0, 16384, 1);
  chain = PV_MagMul(inputFFT, synthesizedFFT);
  chain = PV_Max(chain, prevOut);
  chain = PV_RecordBuf(chain, prevOut, hop:0.5, run: 1.0, loop: 1.0);
  Out.ar(out, 100 * IFFT(chain, 16384).dup)
}).play(s, args: [\prevOut, ~prevOut ])
)


s.freeAll



/// EVEN BETTER WITH DECAY AND SHIT


(
~memLength = 10;
~prevOut = Buffer.alloc(s, ~memLength.calcPVRecSize(16384, 0.5, s.sampleRate), 1);
~prevOut.zero;
~freqs= #[587.33, 1046.5, 440, 880, 1760];
~bins = ~freqs.collect({ |freq| ((16384/48000.0) * freq).round.asInteger });
~mags = Array.zeroFill(16384).collect({ |v, i| ~bins.includes(i).asInteger.asFloat});
~phases = Array.zeroFill(16384);

SynthDef("freezer", { |prevOutBuffer, out=0|
  var input, synthesized, inputFFT, inputFFTBuf, synthesizedFFT, synthesizedFFTBuf, chain, prevOut, prevOutFFTBuf, recChain;
  input = SoundIn.ar(0);
  inputFFTBuf = LocalBuf(16384);
  inputFFT = FFT(inputFFTBuf, input, 0.5);
  synthesizedFFTBuf = LocalBuf(16384);
  synthesizedFFT = PackFFT(synthesizedFFTBuf, 16384, [~mags, ~phases].flop.flatten, 0, 16384, 1);
  chain = PV_MagMul(inputFFT, synthesizedFFT);
  prevOutFFTBuf = LocalBuf(16384);
  prevOut = PV_PlayBuf(prevOutFFTBuf, prevOutBuffer, rate: 0.25, loop: 1.0);
  //chain = PV_XFade(chain, prevOut, fade: 0.5);
  chain = chain.pvcalc2(prevOut, 16384, { |mags, phases, mags2, phases2|
		[ mags.max(mags2) * 0.9, phases2 + phases  ]
  }, frombin: 0, tobin: 16384, zeroothers: 0);
  //recChain = chain.pvcalc(1, { |mag, phase| [mag * 0.5, phase] });
  chain = PV_RecordBuf(chain, prevOutBuffer, hop:0.5, run: 1.0, loop: 1.0);
  Out.ar(out, SinOsc.kr(0.25, mul: 8.0, add: 2.0) *  IFFT(chain, 16384).dup)
}).play(s, args: [\prevOutBuffer, ~prevOut ])
)

s.freeAll

