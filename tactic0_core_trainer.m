% alloc data buffer
        catMFCCs = [];
        for fIdx = trainFileIdx
            %% load audio data and resample
            signal = audioread(filesList{fIdx});
%             signal = (signal - mean(signal)) / std(signal);
            %% Feature extraction (feature vectors as columns)
            [ MFCCs ] = ...
                mfcc( signal, rFPS(rIdx),...
                Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );
%             MFCCs = MFCCs(2:end,:);
            catMFCCs = [catMFCCs MFCCs];

        end
        MFCCsSet(bIdx,rIdx) = {catMFCCs};
        time = toc;
        featureExtractionTimes(bIdx,rIdx) = time;
        
        
        tic;
        while 1 % run forever until success
            try
                GMM = gmdistribution.fit(MFCCsSet{bIdx,rIdx}',observerSize,'SharedCov',true,'options',statset('maxiter',500));
                break;
            catch ex
                ex;
            end
        end
        GMMSet(bIdx,rIdx) = {GMM};
        time = toc;
        clusterTimes(bIdx,rIdx) = time;
        
        
        tic;
        % locate files list
        filesList = importdata(['F:\IFEFSR\' num2str(floor(rFPS(rIdx)/1000)) ...
            'k_NECTEC_matlabResampling.txt']);
        %% load gmm
        GMM = GMMSet{bIdx,rIdx};
        %% alloc buffer
        MODEL = repmat({},1,wordCount);
        
        %% random initial model
        for sIdx = 1:wordCount
            % suggest transition and emission
            RandTR = rand(stateSize,stateSize); % it is stochastic model % ones(stateSize,stateSize)/stateSize;
            ESTTR = RandTR./repmat(sum(RandTR,2),1,stateSize);
            RandEMIT = rand(stateSize,observerSize); % it is stochastic model % ones(stateSize,stateSize)/stateSize;
            ESTEMIT = RandEMIT./repmat(sum(RandEMIT,2),1,observerSize);
            MODEL{sIdx} = [{ESTTR},{ESTEMIT}];
        end
        
        %% train model
        for sIdx = 1:wordCount
            for idx = sIdx:wordCount:nTrain
                %% load audio signal
                signal = audioread(filesList{trainFileIdx(idx)});
                signal = (signal - mean(signal)) / std(signal);
                %% Feature extraction (feature vectors as columns)
                [ MFCCs ] = ...
                    mfcc( signal, rFPS(rIdx),...
                    Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );
%                 MFCCs = MFCCs(2:end,:);
                
                %% map features sequence to speech sequence
                seq = cluster(GMM,MFCCs');
                
                %% hmm training
                % load previous model
                ESTTR = MODEL{sIdx}{1};
                ESTEMIT = MODEL{sIdx}{2};
                % prevent zero divide
                pseudoEmit = ESTEMIT;
                pseudoTr = ESTTR;
                
                %% find new transition and emission
                [ESTTR,ESTEMIT] = hmmtrain(seq',ESTTR,ESTEMIT,...
                    'algorithm','viterbi',...
                    'PSEUDOTRANSITIONS',pseudoTr,'PSEUDOEMISSIONS',pseudoEmit);
                MODEL{sIdx} = [{ESTTR},{ESTEMIT}];
            end
        end
        MODELSet(bIdx,rIdx) = {MODEL};
        time = toc;
        trainingTimes(bIdx,rIdx) = time;
        save([dataDir 'trainingTimes'],'trainingTimes');
        save([dataDir 'MODELSet'],'MODELSet');
        save([dataDir 'ModelingWs']);