mfccparams;
load('F:\IFEFSR\Recognition analysis\MEL_SCALE_30_8000.mat');
c = MEL_SCALE(2:31);
filesList = importdata('F:\IFEFSR\16k_NECTEC_MR.txt');
signalSeq = [];
FBESet = [];
sortFBESet = [];
classIdx = zeros(2,804);
highIdx = [];
midIdx = [];
lowIdx = [];
OutPut = [];
for fIdx = 1:size(filesList,1)
    [Sig,Fs] = audioread(filesList{fIdx});
    [MFCC,FBE] = mfcc( Sig, Fs,...
        Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );
    [~,sortFBE] =  sort(FBE);
    sortFBE = sortFBE(end:-1:1,:);
    sortFBESet = [sortFBESet {sortFBE}];
    selSortFBE = sortFBE(1:10,:);
    if all(sum(selSortFBE>=27)>=1)
        highIdx = [highIdx; [fIdx mod(fIdx-1,67)+1]];
        OutPut(fIdx,:) = [mod(fIdx-1,67)+1 ceil(fIdx/67) 1 0 0];
    elseif all(sum(selSortFBE>=23)>=1)
        midIdx = [midIdx; [fIdx mod(fIdx-1,67)+1]];
        OutPut(fIdx,:) = [mod(fIdx-1,67)+1 ceil(fIdx/67) 0 1 0];
    else
        lowIdx = [lowIdx; [fIdx mod(fIdx-1,67)+1]];
        OutPut(fIdx,:)  = [mod(fIdx-1,67)+1 ceil(fIdx/67) 0 0 1];
    end
    % word label, sample idx, is high, is mid
    figure(1),imagesc(FBE);
end
% all band
allIdx = [];
for fIdx = 1:size(filesList,1)
    allIdx = [allIdx; [fIdx mod(fIdx-1,67)+1]];
end
save('F:\IFEFSR\Recognition analysis\allIdx','allIdx');
save('F:\IFEFSR\Recognition analysis\highIdx','highIdx');
save('F:\IFEFSR\Recognition analysis\midIdx','midIdx');
save('F:\IFEFSR\Recognition analysis\lowIdx','lowIdx');
classCount = sum(OutPut(:,3:5))