p = ProxySpace().push(s.boot);

q = ();
f = TimFreezer.new(s, q);

q.fifth_harmonic = q.fundamental * 6;  //6th partial, 699.246Hz-->Fa5
q.sixth_harmonic = q.fundamental * 7;    //7th partial, 815.787Hz-->Sol#5~~~~
q.seventh_harmonic = q.fundamental * 8;    //8th partial, 932.328Hz-->La#5


f.freeze(\spectro, [q.fifth_harmonic, q.sixth_harmonic, q.seventh_harmonic])

~spectro = \spectro


