p = ProxySpace().push(s.boot);
p.fadeTime = 10;
q = ();
l = LoopStation.new(s, p, q, fftSize:16384, hop: 0.25, win: 1, recFadeTime:0.1);

m = FOAMixer.new(s, p, q, maxLevel:5.0, defaultLevel: 0.7, defaultFb: 0.7);

~foa_mixer_master_fader = 1.0;

d = FoaDecoderMatrix.newPanto(2)
~mixer_decoded = { FoaDecode.ar(m.bus.ar, d) };

~reverb_mix = 0.6
~reverb_size = 1.0
~reverb_damp = 0.4

~out = { FreeVerb.ar(~mixer_decoded, room: ~reverb_size, damp: ~reverb_damp, mix: ~reverb_mix) }

~out.play
//   Looper controls:
//     recording, record_mix, rate, pitch, spec_mix, grain_mix, grain_density, grain_pos_randomness,
//     grain_duration, grain_rate, grain_trigs
//   Mixer controls:
//     level, fb, azim, angle, insert
// Some frequencies of interest: 73.82, 220, 696.84, 1046.5, 1318.51

m.add(l.listen(\doom, 15.0))

~doom_level = 0.0

~doom_level.fadeTime = 60.0

~doom_recording = 0;

~doom_spec_mix = 0;

~doom_rate = -0.25;


m.add(l.listen(\clicks_and_frets, 21.0))

~clicks_and_frets_level = 0.0

~clicks_and_frets_recording = 0

~clicks_and_frets_grain_mix = 1

~clicks_and_frets_grain_density = { 0.01 * SinOsc.kr(0.1).range(5.0, 100.0) }

~clicks_and_frets_grain_duration = { LFNoise2.kr(400).range(0.05, 0.3) }

~clicks_and_frets_grain_pos_randomness = 10.0

(~clicks_and_frets_res_tuning = {
	TChoose.kr(
    //~clicks_and_frets_grain_trigs,
		CoinGate.kr(1 / ~clicks_and_frets_grain_density.log10, Trig1.kr(~clicks_and_frets_grain_trigs, 0.01)),
    [Note("D2").freq]
	  //[Note("D2").freq, Note("C2").freq, Note("A3").freq, Note("F4").freq]
    )
})


~clicks_and_frets_res_tuning.fadeTime = 0.0

~clicks_and_frets_insert = { CombL.ar(XFade2.ar(~clicks_and_frets, Resonator.ar(~clicks_and_frets, ~clicks_and_frets_res_tuning), LFNoise2.ar(100).range(-1, 1)), 3.0, 0.7, 2.0) }

m.add(l.listen(\high_arps, 12.0))

~high_arps_recording = 0;

~high_arps_level = 0.0

~high_arps_level.fadeTime = 30.0

~high_arps_spec_mix = 1;

~high_arps_rate = 0.1

~high_arps_grain_mix = 0;

~high_arps_grain_density = { LFNoise2.kr(100).range(1, 100) }

~high_arps_grain_duration = { LFNoise2.kr(400).range(0.05, 0.3) }

(~clicks_and_frets_res_tuning = {
	TChoose.kr(
		CoinGate.kr(1 / ~clicks_and_frets_grain_density.log10, Trig1.kr(~clicks_and_frets_grain_trigs, 0.01)),
	  [Note("D2").freq, Note("C2").freq, Note("A3").freq, Note("F4").freq]
    )
})
~clicks_and_frets_res_tuning.fadeTime = 0.2

m.add(l.load(\melody, "/home/tim/Music/samples/fromscratchoct2024/melody_mono.wav"))

~melody_level = 0.0
~melody_level.fadeTime = 30.0
