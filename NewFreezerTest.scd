p = ProxySpace().push(s.boot);
q = ();
f = Freezer2.new(s, p);
m = FOAMixer.new(s, p, q);

d = FoaDecoderMatrix.newPanto(2)
~mixer_decoded = { FoaDecode.ar(m.bus.ar, d) };

//~reverb_mix = 0.6
//~reverb_size = 1.0
//~reverb_damp = 0.4

//~out = { FreeVerb.ar(~mixer_decoded, room: ~reverb_size, damp: ~reverb_damp, mix: ~reverb_mix) }

// TODO
// START WITH A SINGLE PURE HIGH HARMONIC AND GRADUALLY "OPEN OUT" the piano sound again. Then perhaps move into "pointellism", back out to piano resonanace (at which point maia rejoins), and finish "closing back" into a single harmonic.

~mixer_decoded.play

f.freeze(\one, duration: 3.0);

f.freeze(\two, duration: 4.5);

(
  m.add(f.thaw(\one_1, \one,
    fundamental:  Note("C#2").freq,
    rate: 0.01,
    lowHarmonic: 1,
    highHarmonic: 10,
  ));
)

(
  m.add(f.thaw(\two_1, \one,
    fundamental:  Note("G#4").freq,
    rate: 0.01,
    lowHarmonic: 1,
    highHarmonic: 10,
  ));
)

(
  m.add(f.thaw(\one_3, \one,
    fundamental:  Note("F#4").freq,
    rate: 0.21,
    lowHarmonic: 1,
    highHarmonic: 10,
  ));
)

(
  m.add(f.thaw(\two_2, \two,
    fundamental:  Note("C#1").freq,
    rate: 0.21,
    lowHarmonic: 1,
    highHarmonic: 5,
  ));
)

~two_2_level = 3.0

(
  m.add(f.thaw(\two_3, \two,
    fundamental:  Note("C#1").freq,
    rate: 0.21,
    lowHarmonic: 1,
    highHarmonic: 1,
  ));
)

~two_3_level = 5.0

~high = { Pulse.ar(4.0).range(5, 65) }

~high <>>.highHarmonic ~two_1


~two_3.set(\lowHarmonic, 1)

~one_3.set(\fundamental, Note("E4").freq)







~high_freq = { SinOsc.ar(2.0).range(3, 3) }
~high_freq <>>.highHarmonic ~one_1

~low_freq = { SinOsc.ar(0.1234).range(1, 1) }


~rhyth = { ~two_2 * Saw.ar(2.0) }

~rhyth2 = { XFade2.ar(~one_1, ~one_3, SinOsc.kr(0.3)) * Saw.ar(TChoose.kr(Impulse.kr(8.0), [8.0, 6.0])) }


~one_1.set(\fundamental, "A5")

~one_3.set(\fundamental, "F#2")

m.add(~rhyth)

~rhyth_level = 0.0

~one_1_level = 0.0

~two_2_level = 0.0

~one_3_level = 0.0

~two_1_level = 0.0

m.add(~rhyth2)

~rhyth2_level = 0.0

~rhth2_insert = { CombL.ar(~rhyth2, 2.0, 0.25, 10.0) }

~high_freq <>>.highHarmonic ~one_1
~high_freq <>>.highHarmonic ~one_3

~low_freq <>>.lowHarmonic ~two_1
~low_freq <>>.lowHarmonic ~two_2
(
  m.add(f.thaw(\power_chord_2, \power_chord,
    fundamental:  Note("Ab4").freq,
    rate: 0.01,
    lowHarmonic: 1,
    highHarmonic: 10,
  ));
)

~power_chord_2.set(\fundamental, "Ab1")

~power_chord_1_level = 0.5

(
  m.add(f.thaw(\power_chord_3, \power_chord,
    fundamental:  Note("Eb3").freq,
    rate: 0.3,
    lowHarmonic: 1,
    highHarmonic: 10,
  ));
)

(
  m.add(f.thaw(\power_chord_2, \power_chord,
    fundamental:  Note("G3").freq,
    rate: 0.03,
    lowHarmonic: 1,
    highHarmonic: 10,
  ));
)

(
  m.add(f.thaw(\power_chord_3, \power_chord,
    fundamental:  Note("A4").freq,
    rate: 0.03,
    lowHarmonic: 1,
    highHarmonic: 10,
  ));
)

FreqScope.new

~power_chord_1.set(\fundamental, Note("D4").freq);

~power_chord_1.set(\slope, 0.5);

~power_chord_2.set(\slope, 0.5);

~tilt = { SinOsc.kr(0.3) }

~tilt <>>.tilt ~power_chord_1

~tilt <>>.tilt ~power_chord_2

~power_chord_1_level = 0.0
~power_chord_2_level = 0.0
~power_chord_3_level = 0.0

(
  m.add(f.thaw(\dirty_3_1, \dirty_3,
    fundamental:  Note("D5").freq,
    rate: 0.2
  ));
)


~dirty_3_1.set(\fundamental, Note("D6").freq)
~dirty_3_1.set(\slope, 10000)
~dirty_3_1.set(\tilt, 0.5)
~tilt <>>.tilt ~dirty_3_1

(
  m.add(f.thaw(\scratchy_1, \scratchy,
    fundamental:  Note("A5").freq,
    rate: 0.33
  ));
)

(
  m.add(f.thaw(\dirty_3_2, \dirty_3,
    fundamental:  Note("D4").freq,
    rate: -0.02,
    width: 1.0
  ));
)

f.freeze(\picking, duration: 10.0)

(
  m.add(f.thaw(\picking_1, \picking,
    fundamental:  Note("D2").freq,
    rate: -0.5,
    width: 1.0
  ));
)

~picking_1.set(\width, 0.01)
~picking_1.set(\fundamental, Note("D2").freq)
~picking_1.set(\highHarmonic, 19)
~picking_1.set(\rate, 0.1)

(
  m.add(f.thaw(\picking_2, \picking,
    fundamental:  Note("G2").freq,
    rate: 0.2,
    width: 0.01
  ));
)

~picking_2.set(\fundamental, Note("A3").freq)
~picking_2.set(\highHarmonic, 19)

~power_chord_1.set(\rate, 0.0)
~power_chord_1.set(\fundamental, Note("D2").freq)
~power_chord_1.set(\highHarmonic, 4)
~power_chord_1.set(\width, 0.02)
~power_chord_1.set(\phase, -0.003)

~power_chord_1_level=0.2

~dirty_3_1_level=0.0
~dirty_3_2_level=0.0
~scratchy_1_level=0.2

~picking_1_level=1.0

~dirty_3_1.set(\fundamental, "D1")

~reluctant_3_1.set(\fundamental, Note("A3").freq)

~reluctant_2_2.set(\fundamental, Note("A4").freq)
~reluctant_2_2.set(\rate, -0.25)
~reluctant_2_2.set(\width, 0.2)

~reluctant1_1.set(\lowHarmonic, 1)

~reluctant1_1.set(\highHarmonic, 2)

~reluctant1_2.set(\lowHarmonic, 3)

~reluctant1_1.fadeTime = 0.1

~reluctant1_1.set(\width, 0.2)

~phase = { SinOsc.ar(0.1).range(-0.0, 0.0) }

~phase <>>.phase ~reluctant1_1

~width = { SinOsc.ar(1.0).range(0.5, 0.5) }

~width <>>.width ~reluctant1_1

(
  f.thaw(\reluctant_1_2, \reluctant,
    fundamental:  Note("E4").freq,
    rate: -0.03
  )
)

(
  f.thaw(\reluctant_2_1, \reluctant_2,
    fundamental:  Note("B5").freq,
    rate: 0.2
  )
)

~reluctant_1_1.play
~reluctant_1_2.play

~reluctant_2_1.set(\fundamental, Note("E2").freq)

~reluctant_2_1.set(\lowHarmonic, 4.0)
~reluctant_2_1.set(\highHarmonic, 15.0)

~phase <>>.phase ~reluctant_2_1

~width <>>.width ~reluctant_2_1

~reluctant_2_1.set(\width, 0.2)

(
  ~reluctant2 = f.thaw(\reluctant,
    fundamental:  Note("E4").freq,
    rate: 0.5
  )
)

(~fundamental = {
 TChoose.kr(
   Dust.kr(1.0),
   [
     Note("E2").freq,
     Note("F#2").freq,
     Note("B2").freq,
   ]
 )
})

~fundamental <>>.fundamental ~reluctant_2_1


~reluctant2.play
~reluctant2.set(\fundamental, Note("E6").freq)
~reluctant2.set(\rate,  -0.01)


(~fundamental = {
 TChoose.kr(
   Dust.kr(1.0),
   [
     Note("E4").freq,
     Note("F#4").freq,
     Note("G4").freq,
   ]
 )
})

~reluctant2.fadeTime = 0.1

p["__freezer2reluctant_4382"].set(\highHarmonic, 2)



~fundamental <>>.fundamental ~reluctant2

~high_harmonic = { SinOsc.kr(0.3).range(1, 10) }

~high_harmonic <>>.high_harmonic ~wicker2


~lfo = { \in.ar * SinOsc.ar(\freq.kr) }


~wicker2 <>> ~lfo

~lfo.set(\freq, 2.0)

~lfo.play

~wicker2.monitor.vol = 0

~wicker2.pause

(
  ~two = f.play(\piano,
    fundamental:  Note("A3").freq,
    lowHarmonic: 1,
    highHarmonic: 10,
    rate: 0.01
  )
)

~two.play

~two_fund = { Note("E4").freq }

~rate = { SinOsc.kr(0.1) }

~rate <>>.rate ~two

~two_fund <>>.fundamental ~two

~two_low_harmonic = { SinOsc.kr(0.3).range(1, 7) }

~two_low_harmonic <>>.low_harmonic ~two

~rhyth = { ~two * Saw.ar(LFNoise2.kr(500).range(0.5,10.0)) }

~rhyth.play

(
  ~three = f.play(\piano,
    fundamental:  Note("A3").freq,
    lowHarmonic: 1,
    highHarmonic: 10,
    rate: -0.5
  )
)

(
    SynthDef(\freezerPlayerNew, { arg out, bufnum, fundamental, lowHarmonic, highHarmonic, slope, tilt, rate, sampleRate, win, hop, fftSize, gate=1.0, fadeTime=0.1;
      var localbuf, chain, outSig, sig, playHead, bins, i, lowerFreqLimit, upperFreqLimit, fromBin, toBin;
      playHead = Phasor.ar(0, BufRateScale.kr(bufnum), 0, BufFrames.kr(bufnum));
      sig = BufRd.ar(1, bufnum, playHead);
      localbuf = LocalBuf.new(fftSize);
      chain = FFT(localbuf, sig, hop, win);
      lowerFreqLimit = lowHarmonic * fundamental;
      upperFreqLimit = highHarmonic * fundamental;
      fromBin = ((fftSize / sampleRate) * lowerFreqLimit).floor.asInteger;
      toBin = ((fftSize / sampleRate) * upperFreqLimit).ceil.asInteger;
      i = lowHarmonic;
      chain = chain.pvcollect(4096, { |mag, phase, bin|
        var coeff, lowerBinFreqLimit, upperBinFreqLimit, harmonicFrequency;
        lowerBinFreqLimit = (bin * (sampleRate/fftSize)) - (sampleRate/fftSize/2);
        upperBinFreqLimit = (bin * (sampleRate/fftSize)) + (sampleRate/fftSize/2);
        harmonicFrequency = i * fundamental;
        if((lowerBinFreqLimit < harmonicFrequency) && (harmonicFrequency <= upperBinFreqLimit), {
          var slopeCoeff, tiltCoeff;
          slopeCoeff = (2 ** (0-i/slope));
          tiltCoeff = 1 - (tilt.sign.max(0) * tilt.abs * (i % 2)) - ((1 - tilt.sign.max(0)) * tilt.abs * (1 - (i % 2)));
          coeff = slopeCoeff * tiltCoeff;
          i = i + 1;
        }, {
          coeff = 0;
        });
        mag * coeff;
      });
      outSig = IFFT.ar(chain, win);
      Out.ar(out, outSig * EnvGen.kr(Env.asr(fadeTime, 1, fadeTime), gate, doneAction: Done.freeSelf));
    }).add;
  )



if((1 < 3) && (3 < 3), { "yes".postln }, { "no".postln});
