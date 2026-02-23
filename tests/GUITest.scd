
p = ProxySpace().push(s.boot);
q = ();
l = LoopStation.new(s, p, q, fftSize:16384, hop: 0.25, win: 1, recFadeTime:0.1, defaultFadeTime: 5.0);

m = FOAMixer.new(s, p, q, maxLevel:5.0, defaultLevel: 0.7, defaultFb: 0.7, defaultFadeTime: 10.0);

~foa_mixer_master_fader = 1.0;

d = FoaDecoderMatrix.newPanto(2)
~mixer_decoded = { FoaDecode.ar(m.bus.ar, d) };

~reverb_mix = 0.6
~reverb_size = 1.0
~reverb_damp = 0.4

~out = { FreeVerb.ar(~mixer_decoded, room: ~reverb_size, damp: ~reverb_damp, mix: ~reverb_mix) }

~out.play

m.add(l.load(\fx, "/home/tim/Music/samples/fromscratchoct2024/melody_mono.wav"))

~fx_spec_mix = -1
~fx_rate = 0.25
~fx_level = 2.0
~fx_grain_mix = -1
~fx_grain_rate = { LFNoise2.kr(500) * 10 }
~fx_grain_duration = { SinOsc.kr(0.25).range(0.1, 0.4) }
~fx_grain_pos_randomness = 1.0;
~fx_grain_prob = 0.2
~fx_grain_trigs = { Dust.kr(~fx_grain_prob) }

~fx_res_freq = { TWChoose.kr(~fx_grain_trigs, [Note("D4").freq, Note("E4").freq, Note("G4").freq],[0.5, 0.5]) }

~res_amt = -1

~fx_insert = { XFade2.ar(~fx, Resonator.ar(~fx, ~fx_res_freq, damping: LFNoise2.ar(500).range(0.7, 1.0), structure: LFNoise2.ar(250).range(0.2, 0.4)), SinOsc.kr(0.2).range(-1, ~res_amt)) }

q.w = Window.new("GUI Introduction", Rect(200,200,255,100));
q.w.front

q.l = Slider.new(q.w,Rect(95,0,150,30));
q.l.action = { ~fx_spec_mix = q.l.value.range(0, 1).postln }

q.l2 = Slider.new(q.w,Rect(95,35,150,30));

q.l2.action = { ~res_amt = q.l2.value.range(-1, 1).postln }

q.l3 = Slider.new(q.w,Rect(95,70,150,30));

q.l3.action = {  ~fx_rate = q.l3.value.range(-1, 1).postln }

q.l4 = Slider.new(q.w,Rect(95,105,150,30));

q.l4.action = {  ~fx_grain_mix = q.l4.value.range(-1, 1).postln }

q.l5 = Slider.new(q.w,Rect(95,140,150,30));

q.l5.action = {  ~fx_grain_prob = q.l5.value.range(0, 20).postln }


~fx_level = 0.0
