//First, the setup:
(
q = ();
p = ProxySpace().push(s.boot);
f = Freezer2.new(s, p);


m = FOAMixer.new(s, p, q, maxLevel:5.0, defaultLevel: 0.7, defaultFb: 0.7, defaultFadeTime: 4.0);

~foa_mixer_master_fader = 5.0;

d = FoaDecoderMatrix.newPanto(2);
~mixer_decoded = { FoaDecode.ar(m.bus.ar, d) };

~reverb_mix = 0.3;
~reverb_size = 0.4;
~reverb_damp = 0.7;

~comp_thresh = 0.25;
~comp_ratio = 1/4.0;
~comp_makeup=3.0;

~out = {
  FreeVerb.ar(
    Compander.ar(
      ~mixer_decoded,
      ~mixer_decoded,
      thresh:  ~comp_thresh,
      slopeBelow: 1.0,
      slopeAbove: ~comp_ratio,
      mul: ~comp_makeup
    ),
    room: ~reverb_size,
    damp: ~reverb_damp,
    mix: ~reverb_mix
  )
};

~out.play;
)

~foa_mixer_master_fader = 5.0;
~foa_mixer_master_fade.fadeTime = 3.0;


f.freeze(\test, 1.837);


(
m.add(
  f.thaw(\test_1, \test,
    fundamental: Note("A2").freq,
    rate: 0.01,
    highHarmonic: 2,
    lowHarmonic: 2
  ),
  level: 1.0);
)

