function batchJFCFixEncode()
%BATCHJFCENCODE Fixed partition fractal encoding using JFC

%% define co-parameters
outdir = 'F://IFEFSR//AudioFC//FC//TEST//';
infile = 'F://IFEFSR//ExpSphinx//an4traintest_small.txt';
wavDir = 'F://IFEFSR//SpeechData//an4';
nProc = '1';
coeffLimit = '1.2';
pthresh = '0';
inext = 'raw';
outext = 'mat';

%% define experiments parameters set
FS = [{'8'}, {'16'}];
RBS = [{'128'}, {'64'}, {'32'}, {'16'}, {'8'}, {'4'}, {'2'}];
P = buildParamsMatrix( FS, RBS );

for expIdx = 1:length(P)
    fs = P{expIdx, 1};
    rbs = P{expIdx, 2};
    
    %% construct parameter values
    testname = ['AN4' fs '_FP_RBS' rbs];
    inDirSuffix = '';
    if strcmp('8', fs)
        inDirSuffix = '_8k';
    end
    inpathprefix = [wavDir inDirSuffix '//wav//'];
    
    %% exec JFC
    execJFC( ...
    ['processname compress'], ...
        ['testname ' testname], ...
        ['infile ' infile ], ...
        ['inpathprefix ' inpathprefix], ...
        ['outdir ' outdir], ...
        ['maxprocess ' nProc], ...
        ['inext ' inext], ...
        ['outext ' outext], ...
        ['pthresh ' pthresh], ...
        ['reportrate 0'], ...
        ['gpu true'], ...
        ['coefflimit ' coeffLimit], ...
        ['skipifexist false'], ...
        ['minr ' rbs], ...
        ['maxr ' rbs]);
    
end

