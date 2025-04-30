Freezer2 {
	var server, proxySpace, buffers, fftSize, hop, win;

	*new { |server, proxySpace, fftSize=32768, hop=0.25, win=1|
    this.loadSynthDefs();
		^super.newCopyArgs(server, proxySpace, (), fftSize, hop, win);
	}

  *loadSynthDefs {
    SynthDef(\freezerRecorder, {  arg bufnum, duration;
      var inputSig;
      inputSig = SoundIn.ar(0);
      RecordBuf.ar(inputSig, bufnum, loop:0, doneAction: Done.freeSelf);
    }).add;

    SynthDef(\freezerAnalyzer, { arg inBufnum, outBufnum, fftSize, hop, win;
      var localbuf, chain, sig, playHead;
      playHead = Phasor.ar(0, BufRateScale.kr(inBufnum), 0, BufFrames.kr(inBufnum));
      sig = BufRd.ar(1, inBufnum, playHead);
      localbuf = LocalBuf.new(fftSize);
      chain = FFT(localbuf, sig, hop, win);
      PV_RecordBuf(chain, outBufnum, run: 1, hop: hop, wintype: win, loop: 1);
    }).add;

    SynthDef(\freezerPlayer, { arg out, bufnum, fundamental, lowHarmonic, highHarmonic,  sampleRate, rate, width, phase, win, fftSize, shift=0.0, gate=1.0, fadeTime=0.1;
      var sig, chain, localbuf, specWipeLowerBin, specWipeUpperBin, outSig;
      localbuf = LocalBuf.new(fftSize);
      specWipeLowerBin = ((fftSize / sampleRate) * fundamental * lowHarmonic).floor;
      specWipeUpperBin = ((fftSize / sampleRate) * fundamental * highHarmonic).ceil;
      chain = PV_PlayBuf(localbuf, bufnum, rate, loop: 1);
      chain = PV_BinShift(chain, shift: shift);
      chain = PV_BinRange(chain, specWipeLowerBin, specWipeUpperBin);
      chain = PV_RectComb(chain, highHarmonic - lowHarmonic, phase: phase, width: width);
      outSig = IFFT.ar(chain, win);
      Out.ar(out, outSig * EnvGen.kr(Env.asr(fadeTime, 1, fadeTime), gate, doneAction: Done.freeSelf));
    }).add;

/*    SynthDef(\freezerPlayerNew, { arg out, bufnum, fundamental, lowHarmonic, highHarmonic, slope, tilt, rate, sampleRate, win, fftSize, gate=1.0, fadeTime=0.1;
      var localbuf, chain, outSig, bins, i;
      bins = Array.new(100);
      (highHarmonic - lowHarmonic).do { |x|
        var h, bin;
        x.poll(label:"x");
        h = lowHarmonic + x;
        bin = ((fftSize / sampleRate) * (fundamental * h)).round.asInteger;
        bins.add(bin);
      };
      bins.size.poll(label:"bins size");
      localbuf = LocalBuf.new(fftSize);
      chain = PV_PlayBuf(localbuf, bufnum, rate, loop: 1);
      i = 1;
      chain = chain.pvcollect(1024, { |mag, phase, bin|
        var coeff;
        if(bins.includes(bin), {
          var slopeCoeff, tiltCoeff;
          slopeCoeff = (2 ** (0-i/slope));
          tiltCoeff = 1 - (tilt.sign.max(0) * tilt.abs * (i % 2)) - ((1 - tilt.sign.max(0)) * tilt.abs * (1 - (i % 2)));
          coeff = slopeCoeff * tiltCoeff;
          i = i + 1;
          i.poll(label:"i");
        }, {
          coeff = 0;
        });
        mag * coeff;
      });
      outSig = IFFT.ar(chain, win);
      Out.ar(out, outSig * EnvGen.kr(Env.asr(fadeTime, 1, fadeTime), gate, doneAction: Done.freeSelf));
    }).add; */
  }

	key { |ns, param|
		^("__freezer2"++ns++"_"++param).asSymbol
	}

  freeze { |name, duration=0.5|
    var recBufKey = this.key(name, \rec_buf);
    var fftBufKey = this.key(name, \fft_buf);

		buffers[recBufKey] = Buffer.alloc(server, duration * server.sampleRate, 1);
		buffers[fftBufKey] = Buffer.alloc(
			server,
			duration.calcPVRecSize(fftSize, hop, server.sampleRate),
			1
		);

    Synth(\freezerRecorder, ["bufnum", buffers[recBufKey], "duration", duration]);
    Synth(\freezerAnalyzer, ["inBufnum", buffers[recBufKey], "outBufnum", buffers[fftBufKey], "fftSize", fftSize, "hop", hop, "win", win]);
  }

  load { |name, filename|
    var recBufKey = this.key(name, \rec_buf);
    var fftBufKey = this.key(name, \fft_buf);
		buffers[recBufKey] = Buffer.read(server, filename, action: { arg b;
      buffers[fftBufKey] = Buffer.alloc(
        server,
        b.duration.calcPVRecSize(fftSize, hop, server.sampleRate),
        1
      );
      Synth(\freezerAnalyzer, ["inBufnum", b, "outBufnum", buffers[fftBufKey], "fftSize", fftSize, "hop", hop, "win", win]);
    });
  }

  thaw { |playerName, recorderName, fundamental, lowHarmonic=1, highHarmonic=10, rate=0.1,width=1.0, phase=0.0, shift=0.0|
    var fftBufKey = this.key(recorderName, \fft_buf);
    proxySpace[playerName]= \freezerPlayer;
    proxySpace[playerName].set(
      \bufnum, buffers[fftBufKey],
      \fundamental, fundamental,
      \lowHarmonic, lowHarmonic,
      \highHarmonic, highHarmonic,
      \rate, rate,
      \win, win,
      \shift, shift,
      \fftSize, fftSize,
      \sampleRate, server.sampleRate,
      \phase, phase,
      \width, width
    );
    ^proxySpace[playerName];
  }
}
