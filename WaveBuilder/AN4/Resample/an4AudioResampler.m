% an4 audio resampler
warning('off');
inDir16 = 'F:/IFEFSR/SpeechData/an4/wav/';
outDir8 = 'F:/IFEFSR/SpeechData/an4_fir1_30_75/wav/';

trainId = importdata('F:\IFEFSR\SpeechData\an4\etc\an4_train.fileids');
testId = importdata('F:\IFEFSR\SpeechData\an4\etc\an4_test.fileids');
fileId = [trainId; testId];

for fIdx = 1:size(fileId,1)
    fIdx
    nameStruct = regexp(fileId{fIdx},'/','split');
    subDir = [ nameStruct{1} '/' nameStruct{2} '/'];
    fileName = nameStruct{3};
    
    inFName = [inDir16 subDir fileName '.raw'];
    fIn = fopen(inFName, 'r');
    wave = fread(fIn, 'int16');
    
    b1 = fir1(8,0.75);
    waveSub = filtfilt(b1,1,wave);       % Zero-phase digital filtering
%     waveSub = decimate(waveSub,2,'FIR');
    
    mkdir([outDir8 subDir]);
    outFName = [outDir8 subDir fileName '.raw'];
    fOut = fopen(outFName, 'w');
    fwrite(fOut,waveSub,'int16');
    
    % outFName = ['F:/IFEFSR/SpeechData/an4/wav/' fileId{fIdx} '.wav'];
    % audiowrite(outFName,wave/(2^15),16000);
    % fprintf(an4fids,'%s\r\n',outFName);
    %
    % outFName = ['F:/IFEFSR/SpeechData/an4_8k/wav/' fileId{fIdx} '.wav'];
    % audiowrite(outFName,waveSub/(2^15),8000);
    % fprintf(an4_8kfids,'%s\r\n',outFName);
    
    fclose(fIn);
    fclose(fOut);
end
warning('on');
