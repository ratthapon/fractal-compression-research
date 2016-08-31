%% Next evaluate on sub-corpus speech signal
warning off
%% parameters
RBS = [8 4 2];
Fs_inout = [1 1]; % Fs in/out ratio
coeffVal = [0.99, 1.2];
partitionType = [{'ADP_RBS2T8'}, {'FIXED_PARTITION_RBS'}];
numIndependVar = 3; % coefflimit, rbs, partition tpye
numDependVar = 2; % psnr of 8k, 16k signal
psnrMatrix_2 = zeros((length(RBS) + 2)*length(coeffVal), numIndependVar + numDependVar);
mfccparams;

%% read speech-paths
sigDir = 'F:\IFEFSR\SamplesSpeech\speech';
codeDir = 'F:\IFEFSR\SamplesSpeech\code';
filePathsLoc = 'F:\IFEFSR\SamplesSpeech\ids8.txt';
fid = fopen(filePathsLoc,'r');
allFilePaths = textscan(fid, '%s','Delimiter','\n');
allFilePaths = allFilePaths{1};
fclose(fid);

%% for each sampling rate
for fsIdx = 1:2
    FsShort = 8*fsIdx;
    fs = FsShort * 1000;
    %% for each coefficient limits
    for coeffIdx = 1:2
        for idx = 1:length(allFilePaths)
            %% Read original sig for baseline
            inSigPath = normpath([sigDir '\' num2str(FsShort) ...
                '\' allFilePaths{idx}]);
            sig = rawread(inSigPath);
                        [MFCC, FBE, SPEC] = mfcc( sig, fs,...
                Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L);
            data(idx).originSig = sig;
            data(idx).originMfcc = MFCC;
            
            %% mangage ouput dir
            outFigdir = ['F:\IFEFSR\SamplesSpeech\pictures-speech\' num2str(FsShort) '\'];
            outDatdir = ['F:\IFEFSR\SamplesSpeech\data-speech\' num2str(FsShort) '\'];
            mkdir(fileparts(normpath([outDatdir '\' allFilePaths{idx}])));
            
            % plot original sig
            caption = ['Original signal Fs = ' num2str(FsShort) 'k'];
            plotSigVsFreqRes( sig, caption, FsShort*1000 );
            
            %% read code from dataset
            % no need to use matlab
            F = cell(size(RBS)); % compose multi-rbs fractal code
            for rbsIdx = 1:3 %length(RBS)
                
                % load the code and decompress it
                inCodePath = normpath([ codeDir '\SUBAN4' num2str(FsShort) ...
                    '_FIXED_PARTITION_RBS' num2str(RBS(rbsIdx)) '_COEFF' ...
                    sprintf('%03d', coeffVal(coeffIdx) * 100) ...
                    '\' regexprep(allFilePaths{idx}, '.raw', '.mat')]);
                dat = load(inCodePath);
                F(rbsIdx) = {dat.f};
                recSig = decompressAudioFC(dat.f, Fs_inout(1), Fs_inout(2), 15);
                [MFCC, FBE, SPEC] = mfcc( recSig, fs,...
                    Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L);
                data(idx).reconSig{rbsIdx} = recSig;
                data(idx).reconMfcc{rbsIdx} = MFCC;
                
                % plot the reconstruc signal
                caption = ['Fixed FC R scale at ' num2str(RBS(rbsIdx)) ' Fs = ' num2str(FsShort) 'k' ...
                    ' LC ' num2str(coeffVal(coeffIdx)) ...
                    ' psnr = ' num2str(PSNR(sig, recSig))];
                fig = plotSigVsFreqRes( recSig, caption, FsShort*1000 );
                
                % collect psnr matrix for later evaluate
                psnrMatrix_2((coeffIdx - 1)*(length(RBS) + 2) + rbsIdx, 1) = coeffVal(coeffIdx);
                psnrMatrix_2((coeffIdx - 1)*(length(RBS) + 2) + rbsIdx, 2) = RBS(rbsIdx);
                psnrMatrix_2((coeffIdx - 1)*(length(RBS) + 2) + rbsIdx, 3) = 0; % fixed partition
                psnrMatrix_2((coeffIdx - 1)*(length(RBS) + 2) + rbsIdx, numIndependVar + ((idx-1)*2)+ fsIdx) ...
                    = PSNR(sig, recSig);
            end
            
            %% Multi R coding section
            recSig = MultiScaleAFCDecoder(F, Fs_inout(1), Fs_inout(2), 15);
            [MFCC, FBE, SPEC] = mfcc( recSig, fs,...
                Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L);
            data(idx).reconMRBSSig = recSig;
            data(idx).reconMRBSMfcc = MFCC;
            caption = ['Multi R scales FC' ' Fs = ' num2str(FsShort)  ...
                'k psnr = ' num2str(PSNR(sig, recSig))];
            fig = plotSigVsFreqRes( recSig, caption, FsShort*1000 );
            
            % collect psnr matrix for later evaluate
            expOffset = (coeffIdx - 1)*(length(RBS) + 2) + length(RBS);
            psnrMatrix_2(expOffset + 1, 1) = coeffVal(coeffIdx);
            psnrMatrix_2(expOffset + 1, 2) = 0;
            psnrMatrix_2(expOffset + 1, 3) = 0; % composite fixed partition
            psnrMatrix_2(expOffset + 1, numIndependVar + ((idx-1)*2) + fsIdx) ...
                = PSNR(sig, recSig);
            
            %% adaptive partition coding section
            nCodePath = normpath([ codeDir '\SUBAN4' num2str(FsShort) ...
                '_ADP_RBS2T8_COEFF' ...
                sprintf('%03d', coeffVal(coeffIdx) * 100) ...
                '\' regexprep(allFilePaths{idx}, '.raw', '.mat')]);
            dat = load(inCodePath);
            recSig = decompressAudioFC(dat.f, Fs_inout(1), Fs_inout(2), 15);
            [MFCC, FBE, SPEC] = mfcc( recSig, fs,...
                Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L);
            data(idx).reconADPSig = recSig;
            data(idx).reconADPMfcc = MFCC;
            caption = ['ADP2T8 FC' ' Fs = ' num2str(FsShort)  ...
                'k psnr = ' num2str(PSNR(sig, recSig))];
            fig = plotSigVsFreqRes( recSig, caption, FsShort*1000 );
            
            % collect psnr matrix for later evaluate
            psnrMatrix_2(expOffset + 2, 1) = coeffVal(coeffIdx);
            psnrMatrix_2(expOffset + 2, 2) = 0;
            psnrMatrix_2(expOffset + 2, 3) = 1; % adaptive partition
            psnrMatrix_2(expOffset + 2, numIndependVar + ((idx-1)*2) + fsIdx) ...
                = PSNR(sig, recSig);
            save(normpath([outDatdir '\' regexprep(allFilePaths{idx}, '.raw', '.mat')]), 'data');
            close all;
        end
    end
end
