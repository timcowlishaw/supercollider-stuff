Server.default = s = Server.local.boot; // start local server

(
SynthDef(\timLooperVariable, {
	arg bufnum, mix=0, punchedIn=1, level=1;
	var inputSig, existingSig, recHead, firstPunch, limit;
	firstPunch=punchedIn;
	recHead = Phasor.ar(0, BufRateScale.kr(bufnum), 0, BufFrames.kr(bufnum));
	recHead.poll;
	existingSig = BufRd.ar(1, bufnum, recHead);
	inputSig = SoundIn.ar(0);
	BufWr.ar(
		Select.ar(punchedIn, [
			existingSig,
			XFade2.ar(inputSig, existingSig, mix, 1.0)
		])
		, bufnum, recHead);
	Out.ar(0, existingSig * level);
}).add;
)


~buffer = Buffer.alloc(s, 60 * s.sampleRate, 1);
~synth = Synth.new(\timLooperVariable, [\bufnum, ~buffer.bufnum]);

~synth.set(\mix, 0)

(
SynthDef(\testCounter, {
	arg punch;
	var recHead, lengthChanged, loopLength, punchChanged, lastRecHead, toggled;
	punchChanged = Changed.kr(punch);
	toggled = ToggleFF.kr(punchChanged);
	loopLength = (toggled * lastRecHead) + ((1 - toggled) * 10000);
	lengthChanged = Changed.kr(loopLength);
	recHead = Phasor.ar(lengthChanged, 1, 0, loopLength);
	lastRecHead = (toggled * lastRecHead) + ((1 - toggled) * recHead);
	recHead.poll;
}).add;
)

~synth = Synth.new(\testCounter)


~synth.set(\length, 200)

p = ProxySpace().push(s.boot);

~punch = { 0 }

~punchChanged = { Changed.kr(~punch) }

~toggled = { ToggleFF.kr(~punchChanged) }

~loopLength = {  (~toggled * Max.kr(~recHead)) + ((1 - ~toggled) * 100000) }

~spy = { ~loopLength.poll }

~spy.scope

~lengthChanged =  { Changed.kr(~loopLength) }

~recHead = { Phasor.ar(~lengthChanged, 1, 0, ~loopLength).poll }

~recHead.scope

~test = { Phasor.ar(0, 1, 0, 10000).poll }

~test.scope