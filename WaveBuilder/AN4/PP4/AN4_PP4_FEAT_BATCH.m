mfccparams;
warning off;
Cs = [ 30]; % n ceps
Ms = [30]; % m filter
HFs = [  7300]; % highest freq
As = [1 2]; %  alpha
alpha = 0.95;
Fs = 16000;
fileListS = [{importdata('F:\IFEFSR\AudioFC\an4test.txt')}, ...
    {importdata('F:\IFEFSR\AudioFC\an4traintest.txt')}];
inDirS = [{'F:\IFEFSR\SpeechData\an4_8k\wav\'}, ...
    {'F:\IFEFSR\SpeechData\an4\wav\'}];
outDirS = [{'F:/IFEFSR/AudioFC/DAudio_Preemp/AN4_8K_PP5_2_A95'}, ...
    {'F:/IFEFSR/AudioFC/DAudio_Preemp/AN4_16K_PP5_2_A95'}];

t = tic;
for C = Cs
    for M = Ms
        for a = As
            fileList = fileListS{a};
            for HF = HFs
                inDir = inDirS{a};
                outDir = [outDirS{a} '_A' num2str(alpha*10) ...
                    '_C' num2str(C) ...
                    '_M' num2str(M) ...
                    '_HF' num2str(HF)
                    ];
                mkdir(outDir);
                mkdir([outDir '/fig/']);
                AN4_PP4_FEAT;
            end
        end
    end
end
time = toc(t);

