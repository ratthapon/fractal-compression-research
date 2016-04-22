% an4 audio resampler
an4_FileIds = 'F:\IFEFSR\SpeechData\an4\an4fileids.txt';
an4fids = fopen(an4_FileIds, 'w');
an4_8k_FileIds = 'F:\IFEFSR\SpeechData\an4_8k\an4fileids.txt';
an4_8kfids = fopen(an4_8k_FileIds, 'w');
trainId = importdata('F:\IFEFSR\SpeechData\an4\etc\an4_train.fileids');
testId = importdata('F:\IFEFSR\SpeechData\an4\etc\an4_test.fileids');
fileId = [trainId; testId];

for fIdx = 1:size(fileId,1)
    fIdx
    inFName = ['F:/IFEFSR/SpeechData/an4/wav/' fileId{fIdx} '.raw'];
    fid = fopen(inFName, 'r');
    wave = fread(fid, 'int16');
    
    wave_subsample = downsample(wave,2);
    
    outFName = ['F:/IFEFSR/SpeechData/an4_8k/wav/' fileId{fIdx} '.raw'];
    fout = fopen(outFName, 'w');
    fwrite(fout,wave_subsample,'int16'); 
    
    %     sound(wave,16000);
    outFName = ['F:/IFEFSR/SpeechData/an4/wav/' fileId{fIdx} '.wav'];
    audiowrite(outFName,wave/(2^15),16000);
    fprintf(an4fids,'%s\r\n',outFName);
    
    outFName = ['F:/IFEFSR/SpeechData/an4_8k/wav/' fileId{fIdx} '.wav'];
    audiowrite(outFName,wave_subsample/(2^15),8000);
    fprintf(an4_8kfids,'%s\r\n',outFName);
    
    fclose(fid);
    fclose(fout);
end
fclose(an4fids);
fclose(an4_8kfids);