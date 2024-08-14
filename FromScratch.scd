p = ProxySpace.push(s)

~x1 = { SinOsc.ar(~freq) }; // oscil·lador
~amp = { 0.1 }; // amp
~freq = { 100 };
~vca = { \in.ar * 0.1 }; // voltage control amplifier
~freq <>> ~x1; // set oscillator frequency with another module
~x1 <>> ~vca; // set oscillator as input of VCA to modulate it

~mixer = { [\left.ar, \right.ar]};
~mixer.play;

// --
~x1 <>> ~vca <>>.left ~mixer;
// is the same as
~x1 <>> ~vca;
~vca <>>.left ~mixer;
// ---
