p = ProxySpace().push(s.boot);
q = ();
l = LoopStation.new(s, p, q, fftSize:16384, hop: 0.25, win: 1, recFadeTime:0.1, defaultFadeTime: 2.0);

m = FOAMixer.new(s, p, q, maxLevel:5.0, defaultLevel: 0.7, defaultFb: 0.7, defaultFadeTime: 4.0);

~foa_mixer_master_fader = 5.0;

d = FoaDecoderMatrix.newPanto(2)
~mixer_decoded = { FoaDecode.ar(m.bus.ar, d) };

~reverb_mix = 0.6
~reverb_size = 1.0
~reverb_damp = 0.4

~out = { FreeVerb.ar(~mixer_decoded, room: ~reverb_size, damp: ~reverb_damp, mix: ~reverb_mix) }

~out.play

m.add(l.listen(\one, 0.25))





~one_recording = 0;

~one_rec_mix = 1;

~one_level = 0;

~one_spec_mix = 1;

~one_rate = 1

m.add(l.listen(\two, 10.0))

~two_recording = 0;

~two_rec_mix = -1;

~two_spec_mix = 1.0;

~two_rate = 0.1;

~one_spec_wipe_lower = { Note("C4").freq }

~one_spec_wipe_upper = { Note("C6").freq }

~two_spec_wipe_lower = { Note("E3").freq }

~two_spec_wipe_upper = { Note("A4").freq }

~two_insert =  { ~two * SinOsc.ar(LFNoise2.ar(100).range(2.0, 3.0)).range(0.0, 1.0) }

~one_insert = { ~one * SinOsc.ar(LFNoise2.ar(500).range(0.2, 2)) }

~rhythm = { ~one * Saw.ar(LFNoise2.kr(10).range(3, 300)) }

~rhythm_2 = { ~two * Saw.ar(LFNoise2.kr(100).range(2, 5)) }

~rhythm_3 = { ~rhythm * ~rhythm_2 }

m.add(~rhythm)

m.add(~rhythm_2)

m.add(~rhythm_3)

~two_level = 0.0

~one_level = 0.0

~rhythm_level = 0.0

~rhythm_2_level = 0.0 // { SinOsc.ar(0.01).range(0.0, 2.0) }
~rhythm_3_level = 0.0

m.add(l.listen(\three, 8.0))

~three_recording = 0

~three_spec_mix = 1.0

~three_rate = 0.1

~two_spec_wipe_lower = { Note("E4").freq }

~two_spec_wipe_upper = { Note("E4").freq }


~three_level = 0.0

m.add(l.listen(\four, 4.0))

~four_recording = 0


~four_level = 3.0

~four_spec_mix = 1.0

ºq~four_rate = 1.0

~four_spec_wipe_lower = { SinOsc.ar(2).range(0, 23990) }
~four_spec_wipe_upper = { ~four_spec_wipe_lower + 10 }