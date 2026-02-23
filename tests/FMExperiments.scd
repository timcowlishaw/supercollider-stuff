p = ProxySpace().push(s.boot); // store proxy space in p so it can be accessed easily.
q = ();


~osc1 = { SinOsc.ar(~freq1mod) }
~osc2 = { SinOsc.ar(~freq2mod) }
~osc3 = { SinOsc.ar(~freq3mod) }
~level1 = { SinOsc.kr(0.5) * 0.1 }
~level2 = { SinOsc.kr(0.6) * 0.4 }
~level3 = { SinOsc.kr(0.7) * 0.6 }
~mixed = { ~level1 * ~osc1 + ~level2 * ~osc2 + ~level3 * ~osc3 }
~mixed.play

~freq1 =  { 220 } // + SinOsc.kr(0.25, add:-2.5, mul: 5) }
~freq2 = 221
~freq3 = 884

~mod12 = { 1 } //SinOsc.kr(0.22) } //SinOsc.kr(0.1, mul: 0.2)) }
~mod13 = { 0.2 } //SinOsc.kr(0.333) }
~mod23 = { 0.6 } //{ SinOsc.kr(0.8) }

~freq1mod = { ~freq1  }
~freq2mod = { ~freq2 * ~mod12 * ~osc1.kr }
~freq3mod = { ~freq3 * ~mod13 * ~osc1.kr * ~mod23 * ~osc2.kr }

~level1 = { MouseX.kr }
~level2 = { MouseY.kr }
~level3 = { SinOsc.kr(0.7) * 0.6 }


~mixed.play

~osc1.scope

~freq1mod = { 440 }

~osc = { SinOsc.ar(~freq) }

~mod = { 0.0 }

~fbNode = FbNode(1)

~freq =  { 440 + 0.1 * fbNode.delay }

{ SinOsc.kr(~freq2, mul: 5.0, add: 220) }

~freq2 = { SinOsc.kr(221, mul: 5.0) }

~freq = { 440 + ~mod * ~osc.kr }


~freq.scope

~osc.play

// there is no immediacy: hear the buffer size cycle

~out = { Impulse.ar(1 ! 2) + (~out.ar(2) * 0.99) };
~out.pause

~out = { SinOsc.ar([220, 440], ~out * LFNoise2.kr(0.5, 4pi), 0.4) }
~out.play


waking up a network of proxies


// hit cmd-. to stop all nodes

// start again

~out.play;

~out = { SinOsc.ar([220, 330], ~out.ar(2).reverse * LFNoise2.kr(0.5, 4pi), 0.4) };

~out = { Impulse.ar(1 ! 2) + (~out.ar(2) * 0.99) };

~out.fadeTime_(10)

~out.vol_(2.0)



~out = { SinOsc.ar(Slope.ar(~out.ar) * MouseX.kr(0.1, 1000, 1)) * MouseY.kr(0.01, 0.25) + SinOsc.ar(220.0 * MouseY.kr(-2, 2), 0, 0.1) };
