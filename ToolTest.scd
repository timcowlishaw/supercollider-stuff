
Server.default = s = Server.local.boot; // start local server

TimLooper.define
TimGranular.define
TimSpectralLooper.define

~looper = TimSpectralLooper.new(s, 7, fftsize: 8192)


~looper.analyse

~looper.play

~looper.rate(-0.01)

~looper.punch

~looper.mix(0.01)


~looper2 = TimSpectralLooper.new(s, 10, fftsize: 8192)

~looper2.punch

~looper2.analyse

~looper2.play

~looper2.rate(0.25)

~looper2.mix(0.01)


~looper3 = TimSpectralLooper.new(s, 7, fftsize: 8192)

~looper3.punch

~looper3.mix(0.01)

~looper3.analyse

~looper3.play

~looper3.rate(-0.5)

~looper3.punch


~granular1 = TimGranular.new(s, 10)

~granular1.release(0.3)

~granular1.attack(0.1)

~granular1.density(20.2)

~granular1.mix(0.1)

~granular1.punch

~granular2 = TimGranular.new(s, 2)
~granular2.punch
~granular2.mix(0.1)
~granular2.attack(2.1)
~granular2.release(0.9)
~granular2.density(10.2)

s.plotTree