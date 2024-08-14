// posar aquest arxiu en la carpeta de "extensions" i fer "rebooot" de supercollider

TimFreezer {
  var server;
  var environment;

  *new {|server, environment|
    ^super.newCopyArgs(server, environment);
  }

	key { |ns, param|
		^("freeze_"++ns++"_"++param).asSymbol
	}

  freeze { |name, freqs, sustain=1.0, rate=0.5, gain=10, fftSize=16384, hop=0.5, win=0, memLength=10|
    var prevBufKey = this.key(name, \prev_buffer);
    var coeffsKey = this.key(name, \coeffs);
    var bins = freqs.collect({ |freq| ((fftSize/server.sampleRate) * freq).round.asInteger });
	var mags = Array.zeroFill(fftSize).collect({ |v, i| bins.includes(i).asInteger.asFloat});
	var coeffs = [mags, Array.zeroFill(fftSize)].flop.flatten;

    environment[prevBufKey] = Buffer.alloc(server, memLength.calcPVRecSize(fftSize, hop, server.sampleRate));
    environment[prevBufKey].zero;

    environment[coeffsKey] = coeffs;

    SynthDef(name, {  |out=0, gate=1, fadeTime=0.1|
      var input, phases, inputFFT, inputFFTBuf, synthesizedFFT, synthesizedFFTBuf, chain, prevOut, prevOutFFTBuf;
      input = SoundIn.ar(0);
      inputFFTBuf = LocalBuf(fftSize);
	  inputFFT = FFT(inputFFTBuf, input, hop: hop, wintype: win);
	  synthesizedFFTBuf = LocalBuf(fftSize);
	  synthesizedFFT = PackFFT(synthesizedFFTBuf, fftSize, environment[coeffsKey], 0, fftSize, 1);
      chain = PV_MagMul(inputFFT, synthesizedFFT);
      prevOutFFTBuf = LocalBuf(fftSize);
      prevOut = PV_PlayBuf(prevOutFFTBuf, environment[prevBufKey], rate: rate, loop: 1.0);
      chain = chain.pvcalc2(prevOut, fftSize, { |mags, phases, mags2, phases2|
        [ mags.max(mags2 * sustain), phases2 + phases  ]
      }, frombin: 0, tobin: fftSize, zeroothers: 0);
      chain = PV_RecordBuf(chain, environment[prevBufKey], hop: hop, wintype: win, run: 1.0, loop: 1.0);
	  Out.ar(out,
		(gain *  IFFT.ar(chain, win)) *
		EnvGen.kr(Env.asr(fadeTime, 1, fadeTime), gate, doneAction: Done.freeSelf)
	  )
	}).add;
	^name
  }

}
