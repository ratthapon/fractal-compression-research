
sig = createComplexSignal(8000);
outputPath = 'F:\GitRepo\fractal-compression\AudioCompressor\src\test\resources\';

rawwrite([ direct 'synth-8.raw' ], sig);
rawwrite([ direct 'synth-8-20.raw' ], sig(1:20));
rawwrite([ direct 'synth-8-40.raw' ], sig(21:60));
rawwrite([ direct 'synth-8-50.raw' ], sig(61:110));
rawwrite([ direct 'synth-8-70.raw' ], sig(111:180));

sig16 = createComplexSignal(16000);

rawwrite([ direct 'synth-16.raw' ], sig16);
rawwrite([ direct 'synth-16-20.raw' ], sig16(1:20));
rawwrite([ direct 'synth-16-40.raw' ], sig16(21:60));
rawwrite([ direct 'synth-16-50.raw' ], sig16(61:110));
rawwrite([ direct 'synth-16-70.raw' ], sig16(111:180));







