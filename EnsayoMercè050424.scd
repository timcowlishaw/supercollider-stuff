TimLooper.define

~looper = TimLooper.new(s, 10)

~looper.punch

~looper.level(1.0)

TimGranular.define

~granular = TimGranular.new(s, 7)

~granular.punch

~granular.attack(0.1)

~granular.release(4.0)

~granular.density(0.01)

~looper2 = TimLooper.new(s, 13)

~looper2.punch

~looper2.level(0.20)


~looper3 = TimLooper.new(s, 7)

~looper3.punch

~looper3.level(0.0)




~looper4 = TimLooper.new(s, 11)

~looper4.punch

~looper4.level(0.0)

~granular4 = TimGranular.new(s, 5)

~granular4.punch


~granular4.density(10.0)

~granular4.attack(0.0)

~granular4.release(0.2)


~looper5 = TimLooper.new(s, 15)

~looper5.punch


~looper5.level(0.10)

~granular6 = TimGranular.new(s, 4)


~granular6.punch


~granular6.attack(0.6)

 ~granular6.release(1.2)

~granular6.density(0100.0)




({ SinOsc.ar(55.0) * SinOsc.kr(0.125) }).play

~looper6 = TimLooper.new(s, 10)

~looper6.punch



~granular6 = TimGranular.new(s, 4)


~granular6.punch


~granular6.attack(0.6)

 ~granular6.release(1.2)

~granular6.density(0100.0)

[\a,\b,\c].collect {|x, i| [x, i] } 