clear all; close all; clc;

%%
% Define variables
dir = 'C:\Project\IFEFSR\SpeechData\TestDAT\';
Tw = 25;                % analysis frame duration (ms)
Ts = 10;                % analysis frame shift (ms)
alpha = 1.0;           % preemphasis coefficient
M = 20;                 % number of filterbank channels
C = 12;                 % number of cepstral coefficients
L = 22;                 % cepstral sine lifter parameter
LF = 300;               % lower frequency limit (Hz)
HF = 3700;              % upper frequency limit (Hz)
stateSize = 3; % default
observerPerSpeech = 3;
% load('GMM');
wordCount = 18;
mappingSheet = [];
setASinglePhoneIdx = [1 2 13 15 16 22 25 31 39 41 43 45 47 48 55 61 81 99 106 107 108 109 116 118 121 122 124 132 133 134 135 136 137 139 154 155 157 158 159 175 206 213 214 215 221 222 223 232 240 241 244 249 258 260 285 291 294 303 308 310 318 321 372 384 389 397 411];
setBSinglePhoneIdx = [1 20 30 33 34 43 52 58 60 126 183 185 187 188 190 207 208 209 210 211 212 214 216 222 229 230 245 247 248 249 250 251 254 257 259 261 266 267 271 275 282:293 295:299 300 303 305 307 310 313 314 316 317 318 319 320 372:393 396:399 403 411 416 417 418 419 427 428 429 431 433 435 437 453 455 460 ];

tic
for samp_rate = [11 22 44]
    %%
    MFCCs = [];
    MODEL = {};
    catMFCCs = [];
    for sp = 1:wordCount
        sp
        for spn=1:10
            wav_file = [dir num2str(samp_rate) 'k_speaker_1_sp_' num2str(sp) '-' sprintf('%02d',spn) '.wav'];  % input audio filename
            % Read speech samples, sampling rate and precision from file
            [ speech, fs ] = audioread( wav_file );
            % Feature extraction (feature vectors as columns)
            [ MFCCs, FBEs, frames ] = ...
                mfcc( speech, fs, Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );
            MFCCs = MFCCs(2:end,:);
            
            catMFCCs = [catMFCCs MFCCs];
        end
    end
    observerSize = observerPerSpeech*wordCount +1;
    % cluster and label feature frames
    while 1 % loop until gmfit was converged
        try
            GMM = gmdistribution.fit(catMFCCs',observerSize,'options',statset('maxiter',1000));
            break;
            if GMM.Converged == 1
                break;
            end
        catch ex
            ex
        end
    end
    
    outputs_log = [];
    for sp = 1:wordCount
        sp
        %% suggest transition and emission
        TRGUESS = [];
        EMITGUESS = [];
        for j = 1:stateSize-1
            TRGUESS = [TRGUESS ; [zeros(1,j-1) 1 1 zeros(1,stateSize-j-1)]];
        end
        TRGUESS = TRGUESS/2;  % /2 ,bc just transition to it self and next state
        TRGUESS = [TRGUESS; [zeros(1,stateSize-1) ones(1,1)]];
        %         TRGUESS = ones(stateSize,stateSize)/stateSize;
        
        EMITGUESS = ones(stateSize,observerSize);
        EMITGUESS = EMITGUESS/observerSize;
        ESTTR = TRGUESS;
        ESTEMIT = EMITGUESS;
        
        for spn=1:10
            i = ((sp-1)*10)+spn
            mappingSheet(i) = sp;
            wav_file = [dir num2str(samp_rate) 'k_speaker_1_sp_' num2str(sp) '-' sprintf('%02d',spn) '.wav'];  % input audio filename
            [ speech, fs ] = audioread( wav_file );
            [ MFCCs, FBEs, frames ] = ...
                mfcc( speech, fs, Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );
            MFCCs = MFCCs(2:end,:);
            seq = cluster(GMM,MFCCs');

            %% hmm training
            pseudoEmit = ESTEMIT;
            pseudoTr = ESTTR;
            [ESTTR,ESTEMIT] = hmmtrain(seq',ESTTR,ESTEMIT,'algorithm','viterbi','PSEUDOTRANSITIONS',pseudoTr,'PSEUDOEMISSIONS',pseudoEmit);
            
        end
        MODEL{sp} = [{ESTTR},{ESTEMIT}];
    end
    save(['GMM' num2str(samp_rate)],'GMM');
    save(['MODEL' num2str(samp_rate)],'MODEL');
    save(['mappingSheet' num2str(samp_rate)],'mappingSheet');
end
time = toc




