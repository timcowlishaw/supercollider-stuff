p = ProxySpace().push(s.boot);


//colors

(

~colors_level = 0.0;
~colors_level.fadeTime = 10.0;

~colors_453_level = ~colors_level;
~colors_451_5_level = ~colors_level;
~colors_532_level = ~colors_level;
~colors_533_7_level = ~colors_level;

~colors_453 = { SinOsc.ar(453, mul: ~colors_453_level) };
~colors_451_5 = { SinOsc.ar(451.5, mul: ~colors_451_level) };
~colors_532 = { SinOsc.ar(532, mul: ~colors_532_level) };
~colors_533_7 = { SinOsc.ar(533.7, mul: ~colors_451_level) };

~colors_453.play;
~colors_451_5.play;
~colors_532.play;
~colors_533_7.play;
)


~colors_level = 0.2


//pendulum

(

~pendulum_level = 0.0;
~pendulum_level.fadeTime = 10.0;

~pendulum_220_level = ~pendulum_level;
~pendulum_221_5_level = ~pendulum_level;
~pendulum_300_5_level = ~pendulum_level;
~pendulum_302_2_level = ~pendulum_level;

~pendulum_220 = { SinOsc.ar(220, mul: ~pendulum_220_level) };
~pendulum_221_5 = { SinOsc.ar(221.5, mul: ~pendulum_221_5_level) };
~pendulum_300_5 = { SinOsc.ar(300.5, mul: ~pendulum_300_5_level) };
~pendulum_302_2 = { SinOsc.ar(302.2, mul: ~pendulum_302_2_level) };

~pendulum_220.play;
~pendulum_221_5.play;
~pendulum_300_5.play;
~pendulum_302_2.play;

)


~colors_level = 0.0

~pendulum_level = 0.0



//pendulum 1

(

~pendulum_1_level = 0.0;
~pendulum_1_level.fadeTime = 10.0;

~pendulum_1_137_8_level = ~pendulum_1_level;
~pendulum_1_139_5_level = ~pendulum_1_level;
~pendulum_1_218_5_level = ~pendulum_1_level;
~pendulum_1_220_level = ~pendulum_1_level;

~pendulum_1_137_8 = { SinOsc.ar(137.8, mul: ~pendulum_1_137_8_level) };
~pendulum_1_139_5 = { SinOsc.ar(139.5, mul: ~pendulum_1_139_5_level) };
~pendulum_1_218_5 = { SinOsc.ar(218.5, mul: ~pendulum_1_218_5_level) };
~pendulum_1_220 = { SinOsc.ar(220, mul: ~pendulum_1_220_level) };

~pendulum_1_137_8.play;
~pendulum_1_139_5.play;
~pendulum_1_218_5.play;
~pendulum_1_220.play;

)

~pendulum_level = 0.0

~pendulum_1_level = 0.15


// pendulum 2
(
~pendulum_2_level = 0.0;
~pendulum_2_level.fadeTime = 10.0;

~pendulum_2_218_5_level = ~pendulum_2_level;
~pendulum_2_220_level = ~pendulum_2_level;
~pendulum_2_297_3_level = ~pendulum_2_level;
~pendulum_2_299_level = ~pendulum_2_level;

~pendulum_2_218_5 = { SinOsc.ar(218.5, mul: ~pendulum_2_218_5_level) };
~pendulum_2_220 = { SinOsc.ar(220, mul: ~pendulum_2_220_level) };
~pendulum_2_297_3 = { SinOsc.ar(297.3, mul: ~pendulum_2_297_3_level) };
~pendulum_2_299 = { SinOsc.ar(299, mul: ~pendulum_2_299_level) };

~pendulum_2_218_5.play;
~pendulum_2_220.play;
~pendulum_2_297_3.play;
~pendulum_2_299.play;
)

~pendulum_1_level = 0.0

~pendulum_2_level = 0.1



// ring modulator 1
(
~ring_modulator_1_level = 0.2;
~ring_modulator_1_level.fadeTime = 10.0;

~ring_modulator_1_beating_freq = 2;

~ring_modulator_1_carrier_freq = 333;

~ring_modulator_1_modulator_freq = 200;
~ring_modulator_1_modulator_freq.fadeTime = 30;

~ring_modulator_1 = { (SinOsc.ar(~ring_modulator_1_carrier_freq) *  SinOsc.ar(~ring_modulator_1_modulator_freq)) * ~ring_modulator_1_level };
~ring_modulator_1_beating = { SinOsc.ar((~ring_modulator_1_carrier_freq +  ~ring_modulator_1_modulator_frequency) + ~ring_modulator_1_beating_freq) * ~ring_modulator_1_level };
~ring_modulator_1_beating_2 = { SinOsc.ar((~ring_modulator_1_carrier_freq -  ~ring_modulator_1_modulator_frequency) + ~ring_modulator_1_beating_freq) * ~ring_modulator_1_level };

~ring_modulator_1.play();
~ring_modulator_1_beating.play();
~ring_modulator_1_beating_2.play();
)


~ring_modulator_1_level = 0.1

~ring_modulator_1_modulator_freq = 333
