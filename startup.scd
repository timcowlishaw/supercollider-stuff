
/*
This is an example startup file.
If you want to modify it, best copy it elsewhere to keep the git repository clean.

You can then load it by calling
"path/to/my/superdirt_startup.scd".load
from the supercollider startup file

The supercollider startup file is to be found in
Platform.userAppSupportDir +/+ "startup.scd",
or via the menu File > Open startup file
*/

(
~interfaces = Dictionary.newFrom([
	\bluetooth, Dictionary.newFrom([
		\outDevice, "Loopback to earbuds",
		\inDevice, "Built-in Microph",
		\inChannel, 0,
		\numOutputBusChannels, 2,
		\numInputBusChannels, 2,
		\channelsPerOrbit, 2,
		\channelMap, 0 ! 12,
	]),
	\builtIn, Dictionary.newFrom([
		\outDevice, "Built-in Output",
		\inDevice, "Built-in Microph",
		\inChannel, 0,
		\numOutputBusChannels, 2,
		\numInputBusChannels, 2,
		\channelsPerOrbit, 2,
		\channelMap, 0 ! 12,
	]),
	\soundcraft, Dictionary.newFrom([
		\outDevice, "Soundcraft Signature 12 MTK",
		\inDevice, "Soundcraft Signature 12 MTK",
		\inChannel, 4,
		\numOutputBusChannels, 12,
		\numInputBusChannels, 14,
		\channelsPerOrbit, 1,
		\channelMap, [0, 1, 2, 3, 4, 5, [6,7], [8,9], [10, 11]]
	]),
	\mappedEverywhereOut, Dictionary.newFrom([
		\outDevice, "SuperDirt to Everywhere",
		\inDevice, "Soundcraft Signature 12 MTK",
		\inChannel, 4,
		\numOutputBusChannels, 18,
		\numInputBusChannels, 14,
		\channelsPerOrbit, 2,
		\channelMap, [0, 2, 4, 6, 8, 10, 12, 14, 16]
	]),
	\focusrite, Dictionary.newFrom([
		\outDevice, "Scarlett 2i4 USB",
		\inDevice, "Scarlett 2i4 USB",
		\inChannel, 0,
		\numOutputBusChannels, 4,
		\numInputBusChannels, 2,
		\channelsPerOrbit, 2,
		\channelMap, 0 ! 12
	]),
	\viu8channel, Dictionary.newFrom([
		\outDevice, "Eight Channel Bus",
		\inDevice, "Aggregate Device",
		\inChannel, 0,
		\numOutputBusChannels, 8,
		\numInputBusChannels, 2,
		\channelsPerOrbit, 2,
		\channelMap, 0 ! 12
	])
]);

~interface = ~interfaces.at(\focusrite);
~loadSuperdirt = false;
~loadStageMaster = false;

s.reboot { // server options are only updated on reboot
	// configure the sound server: here you could add hardware specific options
	// see http://doc.sccode.org/Classes/ServerOptions.html

	//s.options.inDevice = "Scarlett 2i4 USB";
	//s.options.outDevice =  "32 Channel Bus"; //"Built-in Output"; //"Scarlett 2i4 USB";
	s.options.outDevice = ~interface.at(\outDevice);
	s.options.inDevice = ~interface.at(\inDevice);
	// When 32 channel output selected:
	//s.options.numOutputBusChannels = 12;

	s.options.numOutputBusChannels = ~interface.at(\numOutputBusChannels); // set this to your hardware output channel size, if necessary
	s.options.numInputBusChannels = ~interface.at(\numInputBusChannels);
	s.options.numBuffers = 4096 * 256; // increase this if you need to load more samples
	s.options.memSize = 16384 * 32 * 2; // increase this if you get "alloc failed" messages
	s.options.numWireBufs = 64 * 4; // increase this if you get "exceeded number of interconnect buffers" messages
	s.options.maxNodes = 1024 * 32 * 4; // increase this if you are getting drop outs and the message "too many nodes"
	s.options.numAudioBusChannels = 1024 * 4;

	// boot the server and start SuperDirt
	s.waitForBoot {
		if(~loadSuperdirt, {
			~dirt.stop; // stop any old ones, avoid duplicate dirt (if it is nil, this won't do anything)
			~dirt = SuperDirt(~interface.at(\channelsPerOrbit), s); // two output channels, increase if you want to pan across more channels
			// load("/Users/tim/Library/Application Support/SuperCollider/synthdefs/mi-ugens.scd");
			~dirt.loadSoundFiles;   // load samples (path containing a wildcard can be passed in)
			// for example: ~dirt.loadSoundFiles("/Users/myUserName/Dirt/samples/*");
			~dirt.loadSoundFiles("/Users/tim/Music/Dirt/samples/*"); // specify sample folder to load
			s.sync; // optionally: wait for samples to be read

			// When a stereo out is selected:
			~dirt.start(57120, ~interface.at(\channelMap));   // start listening on port 57120, create twelve busses each sending audio to channel 0

			// When soundcraft 12 channel desk selected
			//~dirt.start(57120, [0, 2, 4, 6, 8, 10]);

			// When 32 channel bus selected:
			//~dirt.start(57120, [0, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30]);

			// optional, needed for convenient access from sclang:
			(
				~d1 = ~dirt.orbits[0]; ~d2 = ~dirt.orbits[1]; ~d3 = ~dirt.orbits[2];
				~d4 = ~dirt.orbits[3]; ~d5 = ~dirt.orbits[4]; ~d6 = ~dirt.orbits[5];
				~d7 = ~dirt.orbits[6]; ~d8 = ~dirt.orbits[7]; ~d9 = ~dirt.orbits[8];
				~d10 = ~dirt.orbits[9]; ~d11 = ~dirt.orbits[10]; ~d12 = ~dirt.orbits[11];
			);

			// define global effects for mutable instruments effects
			~dirt.orbits.do { |x|
				var clouds = GlobalDirtEffect(\global_mi_clouds, [\cloudspitch, \cloudspos, \cloudssize, \cloudsdens, \cloudstex, \cloudswet, \cloudsgain, \cloudsspread, \cloudsrvb, \cloudsfb, \cloudsfreeze, \cloudsmode, \cloudslofi]);
				var verb = GlobalDirtEffect(\global_mi_verb, [\verbwet, \verbtime, \verbdamp, \verbhp, \verbfreeze, \verbdiff, \verbgain]);
				x.globalEffects = x.globalEffects
				.addFirst(clouds)
				.addFirst(verb);
				x.initNodeTree;
			};
			// end define global effects for mutable instruments effects
		});

		// directly below here, in your own copy of this file, you could add further code that you want to call on startup
		// this makes sure the server and ~dirt are running
		// you can keep this separate and make it easier to switch between setups
		// by using "path/to/my/file.scd".load and if necessary commenting out different load statements
		// .

		s.latency = 0.6; // increase this if you get "late" messages

		if(~loadSuperdirt, {
			// From https://github.com/thgrund/tidal-looper
			~looper = TidalLooper(~dirt);
			// You can adjust these parameter even in runtime
			~looper.rLevel = 1.0;
			~looper.pLevel = 1.0;
			~looper.linput = ~interface.at(\inChannel); // Set this to your main input port.
			~looper.lname = "loop";
		});


		// From https://github.com/calumgunn/StageMaster
		if(~loadStageMaster, {
			StageMaster.activate(numChannels: ~interface.at(\numOutputBusChannels), compThreshold: 0.7, limiterLevel: 1.0, highEndDb: 3.0);
		})
	};
})
