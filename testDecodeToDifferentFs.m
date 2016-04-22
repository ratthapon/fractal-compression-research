% test variance of Fs in to out wav
wavInFs = 44100;
wavOutFs = 11025;
encodeFs = 8;
encodeDstep = 1;
fractalDecode(f,wavInFs,encodeFs,encodeDstep,wavOutFs,[],'none2f1');

wavInFs = 22050;
wavOutFs = 11025;
encodeFs = 8;
encodeDstep = 1;
fractalDecode(f,wavInFs,encodeFs,encodeDstep,wavOutFs);

wavInFs = 44100;
wavOutFs = 44100;
encodeFs = 64;
encodeDstep = 1;
fractalDecode(f,wavInFs,encodeFs,encodeDstep,wavOutFs);