
p = ProxySpace().push(s.boot);
q = ();
l = OldFreezer2.new(s, p, q, fftSize:32768, hop: 0.25, win: 1, recFadeTime:0.1, defaultFadeTime: 2.0);

m = FOAMixer.new(s, p, q, maxLevel:5.0, defaultLevel: 0.7, defaultFb: 0.7, defaultFadeTime: 4.0);

~foa_mixer_master_fader = 8.0;

d = FoaDecoderMatrix.newPanto(2)
~mixer_decoded = { FoaDecode.ar(m.bus.ar, d) };

~reverb_mix = 0.6
~reverb_size = 0.4
~reverb_damp = 0.7

~out = { FreeVerb.ar(~mixer_decoded, room: ~reverb_size, damp: ~reverb_damp, mix: ~reverb_mix) }

~out.play


// WAIT FOR NOTE


m.add(l.listen(\one, 3), level: 0.0)

~one_recording = 0
~one_rate = 0.1


~one_fundamental = { Note("F#3").freq }
~one_fundamental.fadeTime = 0.0
~one_low_harmonic = { 4 }
~one_low_harmonic.fadeTime = 0.0
~one_high_harmonic = { 7 }
~one_high_harmonic.fadeTime = 0.0

~one_level = 0.0


m.add(l.listen(\two, 4.2), level: 0.0)

~two_rate = 0.02

~two_recording = 0

~two_level = 0.0

~two_fundamental  = { Note("G#2").freq }

~two_fundamental.fadeTime = 0.0

~two_low_harmonic = { 3 }
~two_low_harmonic.fadeTime = 0.0
~two_high_harmonic = { 7 }
~two_high_harmonic.fadeTime = 0.0


~xfade = { LFTri.ar(LFNoise2.kr(500).range(2.0, 10.0)).range(-0.5, 0.5) }


~crossfaded = { XFade2.ar(~one, ~two, ~xfade) }

m.add(~crossfaded)

~crossfaded_level = 1.0

m.add(l.listen(\three, 4.2), level: 0.0)

~three_record_mix = 0

~three_rate = -0.1

~three_recording = 0.0

~three_fundamental = { Note("C#2").freq }
~three_fundamental.fadeTime = 0.0
~three_low_harmonic = { 1 }
~three_low_harmonic.fadeTime = 0.0
~three_high_harmonic = { 3 }
~three_high_harmonic.fadeTime = 0.0

~lfo = { LFTri.ar(LFNoise2.kr(1025).range(3.0, 15.0)).range(0.7, 1.0) }

~three_insert = { ~three * ~lfo }

~three_level = 1.0

~beat_detune = { 2 } //SinOsc.ar(0.01).range(0.0, 1.0) }

~bass_note = { Note("C#3").freq }

~bass = { AnalogFoldOSC.ar([~bass_note - ~beat_detune, ~bass_note + ~beat_detune]) }

m.add(~bass, level: 0.1)

~bass_level = 0.00

