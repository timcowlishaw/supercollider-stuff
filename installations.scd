Quarks.install("SuperDirt");

Quarks.install("https://github.com/calumgunn/StageMaster.git");

Quarks.install("https://github.com/thgrund/tidal-looper.git");

Quarks.install("https://github.com/ambisonictoolkit/atk-sc3.git");

Quarks.install("https://github.com/madskjeldgaard/plugins.quark")


Quarks.install("https://github.com/triss/ChordSymbol.git")

Quarks.install("https://github.com/dkmayer/miSCellaneous_lib.git")

Quarks.install("https://github.com/JamesWenlock/AmbiVerbSC.git")

Plugins.installPlugin("portedplugins")

Atk.downloadKernels;
Atk.downloadMatrices;
Atk.downloadSounds;

// Future Tim if you are reading this because you get
// ERROR: Could not iterate on directory '/home/tim/.local/share/SuperCollider/Extensions/scide_scnvim': No such file or directory
// you need to rm /home/tim/.local/share/SuperCollider/Extensions/scide_scnvim
// (its a symlink that's broken) and then restart vim to regenerate
