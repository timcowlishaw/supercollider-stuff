
p = ProxySpace().push(s.boot);
q = ();
l = LoopStation.new(s, p, q, fftSize:16384, hop: 0.25, win: 1, recFadeTime:0.1, defaultFadeTime: 0.0);

m = FOAMixer.new(s, p, q, maxLevel:5.0, defaultLevel: 0.7, defaultFb: 0.7, defaultFadeTime: 10.0);

p.fadeTime = 5.0;

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
//     grain_duration, grain_rate, grain_trigs, spec_wipe
//   Mixer controls:
//     level, fb, azim, angle, insert
// Some frequencies of interest: 73.82, 220, 696.84, 1046.5, 1318.51


m.add(l.load(\chords, "/home/tim/Music/samples/fromscratchoct2024/chords_mono.wav"))

~chords_spec_mix = 1
~chords_rate = 0


~chords_spec_wipe = { -0.95 }
~chords_spec_wipe_2 = { 0.02 }

~chords.inspect

s.freqscope

m.add(l.listen(\prova, 20))

~prova_spec_mix = 1.0
~prova_rate = 2.0
~prova_level = 0.0
~prova_spec_wipe = { SinOsc.kr(0.1).range(0.15, 0.33) };

m.add(l.listen(\acord, 5))

~prova_recording = 0;

~acord_recording = 0;

~acord_recording.inspect

~acord_spec_mix = 1;

~acord_rate = 0.0;

~acord_rate.fadeTime = 0;

~acord_level = 0;

s.freqscope


~acord_level = 0.5

~acord_spec_wipe = { SinOsc.kr(0.1).range(0, -1) }
~acord_spec_wipe.fadeTime = 0

m.add(l.listen(\maia, 20))

~maia_recording = 0

~maia_spec_mix = 1 // { SinOsc.kr(0.2).range(0, 1); }

~maia_rate.fadeTime = 0;


~maia.inspect




~maia_rate = 0

~maia_spec_wipe = { 0.01 }


