// based on mass_spetra_base_2024-10-18.scd!

p = ProxySpace().push(s.boot);

q = ();
f = TimFreezer.new(s, q);

// millor utilitzar nomenclatura PARTIALS??
q.fundamental = 48.99; //G1          //1st partial
q.first_harmonic = q.fundamental * 2;  //2nd partial
q.second_harmonic = q.fundamental * 3; //3rd partial
q.third_harmonic = q.fundamental * 4;  //4th partial
q.fourth_harmonic = q.fundamental * 5; //5th partial
q.fifth_harmonic = q.fundamental * 6;  //6th partial, 699.246Hz-->Fa5
q.sixth_harmonic = q.fundamental * 7;    //7th partial, 815.787Hz-->Sol#5~~~~
q.seventh_harmonic = q.fundamental * 8;    //8th partial, 932.328Hz-->La#5
q.eighth_harmonic = q.fundamental * 9;    //9th partial, 1.048.869Hz-->Do6 ++++
q.ninth_harmonic = q.fundamental * 10;    //10th partial, 1.165.410Hz-->(1174,66Hz)Re6 ++++
q.tenth_harmonic = q.fundamental * 11;    //11th partial, 1.281.951Hz-->(1318,51hz)Mi6 ~~~~
q.eleventh_harmonic = q.fundamental * 12;    //12th partial, 1.398.492Hz-->(1396,91Hz)Fa6 +++
q.twelfth_harmonic = q.fundamental * 13;    //13th partial, 1.515.033Hz-->(1479,98Hz)Fa#6
q.thirteenth_harmonic = q.fundamental * 14;  //14th partial, 1.631.574Hz-->(1661,22Hz)Sol#6
q.fourteenth_harmonic = q.fundamental * 15; //15th partial, 1.748.115Hz-->(1760,00Hz)La6 ++++
q.fifteenth_harmonic = q.fundamental * 16;    //16th partial, 1.864.656Hz-->(1864,66)La# ++++


// Only four harmonics, choose them wisely. Add an amount of beating to each.

q.tone_1 = q.third_harmonic; // G
q.tone_2 = q.eighth_harmonic; // E
q.tone_3 = q.twelfth_harmonic; // Bflat
q.tone_4 = q.thirteenth_harmonic; // C


f.freeze(\tone_1, [q.tone_1], sustain: 0.9, memLength: 0.5);
f.freeze(\tone_2, [q.tone_2], sustain: 0.999, memLength: 0.25);
f.freeze(\tone_3, [q.tone_3], sustain: 0.99, memLength: 0.25);
f.freeze(\tone_4, [q.tone_4], sustain: 0.999, memLength: 0.25);

~tone_1_pure = \tone_1;
~tone_2_pure = \tone_2;
~tone_3_pure = \tone_3;
~tone_4_pure = \tone_4;

~tone_1_detune_range = { SinOsc.kr(0.5, mul: 1.0) };
~tone_1_detune_amount = { 1.0 };

~tone_2_detune_range = { 1 };
~tone_2_detune_amount = { 1.0 };

~tone_3_detune_range =  { 1 };
~tone_3_detune_amount = { 0.0 };

~tone_4_detune_range = { 1 };
~tone_4_detune_amount =  { 0.0 };

~tone_1_detune_range.fadeTime_(2);
~tone_1_detune_amount.fadeTime_(2);
~tone_2_detune_range.fadeTime_(2);
~tone_2_detune_amount.fadeTime_(2);
~tone_3_detune_range.fadeTime_(2);
~tone_3_detune_amount.fadeTime_(2);
~tone_4_detune_range.fadeTime_(2);
~tone_4_detune_amount.fadeTime_(2);

~env_follower_attack = { 0.1 };
~env_follower_decay = { 0.1 };

// TODO maybe replace this SinOsc with a little bit of LFNoise2?

~tone_1 = { ~tone_1_pure + (~tone_1_detune_amount * EnvDetect.ar(~tone_1_pure, ~env_follower_attack, ~env_follower_decay) * SinOsc.ar(q.tone_1 + ~tone_1_detune_range)) };
~tone_2 = { ~tone_2_pure + (~tone_2_detune_amount * EnvDetect.ar(~tone_2_pure, ~env_follower_attack, ~env_follower_decay) * SinOsc.ar(q.tone_2 + ~tone_2_detune_range)) };
~tone_3 = { ~tone_3_pure + (~tone_3_detune_amount * EnvDetect.ar(~tone_3_pure, ~env_follower_attack, ~env_follower_decay) * SinOsc.ar(q.tone_3 + ~tone_3_detune_range)) };
~tone_4 = { ~tone_4_pure + (~tone_4_detune_amount * EnvDetect.ar(~tone_4_pure, ~env_follower_attack, ~env_follower_decay) * SinOsc.ar(q.tone_4 + ~tone_4_detune_range)) };



// Three different processing chains, allow mix of harmonics as input to each one.

~drone_input = { ~tone_1 };
~dust_input = { XFade2.ar(~tone_2, ~tone_3, SinOsc.kr(0.4)) * ~tone_1 };
~clicks_input = { ~tone_1 };

~drone_input.fadeTime_(5);
~dust_input.fadeTime_(5);
~clicks_input.fadeTime_(5);


// Add the actual processing chains and their params

~drone_tremelo_freq = { 0.125 };
~drone_tremelo_level = { 0.5 };

~dust_density = { SinOsc.kr(0.25, add: 5, mul: 10) };
~dust_release = { SinOsc.kr(0.33, add: 0.005, mul: 0.01) };

~clicks_freq = { 10 };
~clicks_randomness = { 5.0 };
~clicks_random_freq = { 500 };

~drone_tremelo_freq.fadeTime_(2);
~drone_tremelo_level.fadeTime_(2);
~dust_density.fadeTime_(2);
~dust_release.fadeTime_(2);
~clicks_freq.fadeTime_(2);
~clicks_randomness.fadeTime_(2);

// TODO there must be a better way of getting an audio rate constant
~drone = { ~drone_input * XFade2.ar(Silent.ar(1) + 1.0, SinOsc.ar(~drone_tremelo_freq, add: 1, mul: 0.5),  (~drone_tremelo_level * 2) - 1) };
~dust = { ~dust_input * EnvGen.ar(Env.perc(~dust_release), Dust.kr(~dust_density)) };
~clicks = { ~clicks_input * Saw.ar(~clicks_freq + (LFNoise1.kr(~clicks_random_freq) * ~clicks_randomness)) };


//Some patch points for improvised adding of effects:

~drone_output = { ~drone }; //+ (SinOsc.ar(0.15, mul: 0.05, add: 0.01) * WhiteNoise.ar()) };
~dust_output = { ~dust };
~clicks_output = { ~clicks };

~drone_output.fadeTime_(5);
~dust_output.fadeTime_(5);
~clicks_output.fadeTime_(5);

// Mix them independently into the output.

~drone_level = { 4.0 };
~dust_level = { 0 };
~clicks_level = { 0 }; // LFNoise2.kr(~clicks_freq) * 3.0 * SinOsc.kr(0.25, add: 1, mul: 0.5) };

~drone_level.fadeTime_(5);
~clicks_level.fadeTime_(5);
~dust_level.fadeTime_(5);

~master_level = { 1.0 }
~master_level.fadeTime_(20);

~out =  { ~master_level * ((~drone_level * ~drone_output) + (~dust_level * ~dust_output) + (~clicks_level * ~clicks_output)) };
~out.play;
