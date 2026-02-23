

~freqs = [440, 880, 1780];
~bins = ~freqs.collect({ |freq| ((16384/48000.0) * freq).round.asInteger });

~prevOut = Buffer.alloc(s, 16384);
~mults = Buffer.alloc(s, 16354);

~mults.set(*[~bins, 1.0].lace(~bins.size * 2))

(
SynthDef("freezer", { |mults, prevOut, out=0|
  var input, synthesized, inputFFTBuf, chain;
  var bufferSize=16384;

  input = SoundIn.ar(0);
  inputFFTBuf = LocalBuf(bufferSize);
  chain = FFT(inputFFTBuf, input);
  /* chain = chain.pvcollect { |mag, phase, bin, index|
	var newMag = (mag * mults.get(bin)).max(prevOut.get(bin));
	prevOut.set(bin, newMag);
    newMag
  }; */
  chain = PV_MagMul(chain, mults);
  Out.ar(out, IFFT(chain, bufferSize).dup)
}).add
)


~mults.getn(0, 16382) { |n| n.println }

~mults.size

~freezer = Synth("freezer", [\prevOut, ~prevOut, \mults, ~mults])

s.freeAll


    // FFT window size
~fftSize = 2048;
// Calculate the number of bins
~numBins = (~fftSize / 2) + 1;

    // Step 1: Allocate and populate the buffer with coefficients
    ~coeffs = Array.fill(~numBins, { |i| 1.0.rand }); // Random coefficients for example
    ~buffer = Buffer.alloc(s, ~coeffs.size, 1);
    ~buffer.sendCollection(~coeffs);

    // Step 2: Define a SynthDef that uses PV_MagMult
(
SynthDef(\pvMagMultExample, {
        arg in=0, out=0, bufnum;
        var chain, sig;

        // Input signal
        sig = SoundIn.ar(in);

        // FFT
        chain = FFT(LocalBuf(2048), sig);

        // Multiply magnitudes with coefficients from buffer
        chain = PV_MagMul(chain, bufnum);

        // IFFT
        sig = IFFT(chain);

        // Output signal
        Out.ar(out, sig);
    }).add;
)
    // Step 3: Create a synth using the SynthDef
    s.sync; // Wait for server to sync
    Synth(\pvMagMultExample, [\in, 0, \out, 0, \bufnum, ~buffer]);



(
~memLength = 10;
~prevOut = Buffer.alloc(s, ~memLength.calcPVRecSize(16384, 0.5, s.sampleRate), 1);
~prevOut.zero;
~freqs= #[587.33, 1046.5, 440, 880, 1760];

SynthDef("freezer", { |prevOutBuffer, out=0, sustain=1.0, outGain=10.0, playbackRate=0.25|
  var input, synthesized, inputFFT, inputFFTBuf, synthesizedFFT, synthesizedFFTBuf, chain, prevOut, prevOutFFTBuf;
  var bins = ~freqs.collect({ |freq| ((16384/48000.0) * freq).round.asInteger });
  var mags = Array.zeroFill(16384).collect({ |v, i| bins.includes(i).asInteger.asFloat});
  var phases = Array.zeroFill(16384);

  input = SoundIn.ar(0);
  inputFFTBuf = LocalBuf(16384);
  inputFFT = FFT(inputFFTBuf, input, 0.5);
  synthesizedFFTBuf = LocalBuf(16384);
  synthesizedFFT = PackFFT(synthesizedFFTBuf, 16384, [mags, phases].flop.flatten, 0, 16384, 1);
  chain = PV_MagMul(inputFFT, synthesizedFFT);
  prevOutFFTBuf = LocalBuf(16384);
  prevOut = PV_PlayBuf(prevOutFFTBuf, prevOutBuffer, rate: playbackRate, loop: 1.0);
  chain = chain.pvcalc2(prevOut, 16384, { |mags, phases, mags2, phases2|
		[ mags.max(mags2) * sustain, phases2 + phases  ]
  }, frombin: 0, tobin: 16384, zeroothers: 0);
  chain = PV_RecordBuf(chain, prevOutBuffer, hop:0.5, run: 1.0, loop: 1.0);
  Out.ar(out, outGain * IFFT(chain, 16384).dup)
}).play(s, args: [\prevOut, ~prevOut, \sustain, 10.0])
)



s.freeAll

{ SoundIn.ar(0)  }.scope;

~prevOut.plot


~freqs = [440, 880]


~bins.includes(150)

~mags = Array.zeroFill(16384).collect({ |v, i| ~bins.includes(i).asInteger.asFloat })

[ ~mags, 5.0].lace(16384 * 2)