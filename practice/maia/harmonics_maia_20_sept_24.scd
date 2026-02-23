


p = ProxySpace().push(s.boot);

q = ();
f = TimFreezer.new(s, q);

// millor utilitzar nomenclatura PARTIALS??
q.fundamental = 164.81; //E3           //1st partial
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

//HAROMINICOS JUNTOS

f.freeze(\nota_con_harmonicos_pares, [q.sixth_harmonic, q.eighth_harmonic, q.tenth_harmonic, q.twelfth_harmonic,  q.fourteenth_harmonic], sustain: 0.9, memLength: 0.25);
f.freeze(\nota_con_harmonicos_impares, [q.fifth_harmonic, q.seventh_harmonic, q.ninth_harmonic, q.eleventh_harmonic, q.thirteenth_harmonic, q.fifteenth_harmonic], sustain: 0.9, memLength: 0.25);

~nota_pares = \nota_con_harmonicos_pares;
~nota_pares_amp = { 1.0 };
~nota_pares_amp.fadeTime_(5.0);
~nota_pares_vca = { ~nota * ~nota_amp };

~nota_impares = \nota_con_harmonicos_impares;
~nota_impares_amp = { 1.0 };
~nota_impares_amp.fadeTime_(5.0);
~nota_impares_vca = { ~nota * ~nota_amp };

~xfade = { 0 }

~out = { XFade2.ar(~nota_pares, ~nota_impares, ~xfade ) };

~out.play

~out.pause
