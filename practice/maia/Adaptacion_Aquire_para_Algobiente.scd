p = ProxySpace().push(s.boot);

q = ();

m = FOAMixer.new(s, p, q, maxLevel:5.0, defaultLevel: 0.7, defaultFb: 0.7, defaultFadeTime: 4.0);

~foa_mixer_master_fader = 0.5;

~out = {m.bus.ar}

~out.play

//colors


(

~colors_453 = { SinOsc.ar(453, mul: ~colors_453_level) };
~colors_451_5 = { SinOsc.ar(451.5, mul: ~colors_451_level) };
~colors_532 = { SinOsc.ar(532, mul: ~colors_532_level) };
~colors_533_7 = { SinOsc.ar(533.7, mul: ~colors_451_level) };

)


(
m.add(~colors_453, level: 0.0);
m.add(~colors_451_5, level: 0.0);
m.add(~colors_532, level: 0.0);
m.add(~colors_533_7, level: 0.0);

~colors_level = 0.0;
~colors_level.fadeTime = 10.0;

~colors_453_level = ~colors_level;
~colors_451_5_level = ~colors_level;
~colors_532_level = ~colors_level;
~colors_533_7_level = ~colors_level;

)


//NIVEL MAESTRO COLORS
~colors_level = 0.4



(
~colors_453_angle = 0.5 * pi;
~colors_451_5_angle = 0.5 * pi;
~colors_532_angle = 0.5 * pi;
~colors_533_7_angle = 0.5 * pi;

//OSCILADORES MOVIMIENTO COLORS
~colors_453_azim = { SinOsc.kr(0.2).range(-pi, pi) };
~colors_451_5_azim = { SinOsc.kr(0.33).range(-pi, pi) };
~colors_532_azim = { SinOsc.kr(0.2, phase: pi).range(-pi, pi) };
~colors_532_7_azim = { SinOsc.kr(0.1, phase: pi).range(-pi, pi) };
)




//pendulum

(
~pendulum_220 = { SinOsc.ar(220, mul: ~pendulum_220_level) };
~pendulum_221_5 = { SinOsc.ar(221.5, mul: ~pendulum_221_5_level) };
~pendulum_300_5 = { SinOsc.ar(300.5, mul: ~pendulum_300_5_level) };
~pendulum_302_2 = { SinOsc.ar(302.2, mul: ~pendulum_302_2_level) };
)

(
~pendulum_level = 0.0;
~pendulum_level.fadeTime = 10.0;
m.add(~pendulum_220, level: 0.0);
m.add(~pendulum_221_5, level: 0.0);
m.add(~pendulum_300_5, level: 0.0);
m.add(~pendulum_302_2, level: 0.0);
~pendulum_220_level = ~pendulum_level;
~pendulum_221_5_level = ~pendulum_level;
~pendulum_300_5_level = ~pendulum_level;
~pendulum_302_2_level = ~pendulum_level;
)





~colors_level = 0.3

~pendulum_level = 0.8


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

//~pendulum_1_137_8.play;
//~pendulum_1_139_5.play;
//~pendulum_1_218_5.play;
//~pendulum_1_220.play;

)
m.add(~pendulum_1_137_8);
m.add(~pendulum_1_139_5);
m.add(~pendulum_1_218_5);
m.add(~pendulum_1_220);

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

//~pendulum_2_218_5.play;
//~pendulum_2_220.play;
//~pendulum_2_297_3.play;
//~pendulum_2_299.play;
)

m.add(~pendulum_2_218_5);
m.add(~pendulum_2_220);
m.add(~pendulum_2_297_3);
m.add(~pendulum_2_299);

~pendulum_1_level = 0.7

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

//~ring_modulator_1.play();
//~ring_modulator_1_beating.play();
//~ring_modulator_1_beating_2.play();
)


m.add(~ring_modulator_1);

~ring_modulator_1_level = 0.00

~ring_modulator_1_modulator_freq = 333

p.clear(30)
