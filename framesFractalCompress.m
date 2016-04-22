% frames compress
dStep = 1;
Tw = 25;                % analysis frame duration (ms)
Ts = 20;                % analysis frame shift (ms)
dirParamsFs = [11025 11025 22050 22050 44100 44100];
dirParamsCs = [8 8 16 16 32 32];
setName = [{'F:\IFEFSR\11k_train.txt'} {'F:\IFEFSR\11k_test.txt'} ...
    {'F:\IFEFSR\22k_train.txt'} {'F:\IFEFSR\22k_test.txt'} ...
    {'F:\IFEFSR\44k_train.txt'} {'F:\IFEFSR\44k_test.txt'}];

for setIdx = 1:size(setName,2)
    fileNameList = importdata(set{setIdx});
    stateSize = 5; % default
    observerSize = 128;
    aFs = dirParamsFs(s);%11025 22050 44100 audio Fs or sampling rate
    cFs = dirParamsCs(s); % code frame size
    workingDir = ['F:\IFEFSR\MData\' num2str(floor(aFs/1000)) 'k_fractal_' num2str(cFs) ...
        'fs1_mfcc_' num2str(observerSize) 'Component' num2str(stateSize) 'StatesDiscrete\'];
    mkdir(workingDir);
    FFCDatas = [];
    for fileIdx = 1:size(fileNameList,1)
        [speech,Fs] = audioread(fileNameList{fileIdx});
        sp = speech(:,1)';
        Nw = round( 1E-3*Tw*Fs );    % frame duration (samples)
        Ns = round( 1E-3*Ts*Fs );    % frame shift (samples)
        frames = vec2frames( sp, Nw, Ns, 'cols', @hamming, false );
        frameLen = size(frames,2);
        framesFractalCode = [];
        for i=1:frameLen
            [f fs compressTime] = fractalCompress(frames(:,i),cFs,dStep);
            code = [{f};compressTime];
            framesFractalCode = [framesFractalCode code];
        end
        FFCDatas = [FFCDatas;{framesFractalCode}];
    end
    save([workingDir 'FFCDatas'],'FFCDatas');
end