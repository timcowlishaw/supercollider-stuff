p = ProxySpace().push(s.boot);
q = ();

(
var fftSize = 16384;
var sampleRate = 48000.0;
~freqs =  { [0, 220, 440, 880] } ;
~binLimits = {
  ([0] ++ ~freqs.select { |freq|
    freq != 0.0;
  }.collect { |freq|
    var centre = (fftSize / sampleRate) * freq;
    [centre.floor, centre.ceil]
  }.flatten ++ [fftSize - 1])
}
)

~foo2 = { [0, 0,  0, 0] }

~bar = {
  SinOsc.ar((~foo ?? 440).poll)
}

~bar.play
