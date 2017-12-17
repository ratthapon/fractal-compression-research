function batchADPAFCCompose( )
%BATCHADPAFCCOMPOSE Batch operation for adaptive partition composing.

% co-parameters
FS = [ 16 8 ];
RBS = [4 8 16 32 64];
fileList = importdata('F:\IFEFSR\ExpSphinx\an4traintest.txt');

for fsIdx = 1:size(FS, 2)
    fs = FS(fsIdx);
    
    % set in/out dir
    codePathPrefix = ['F:\IFEFSR\AudioFC\FC\AN4' num2str(fs) '_FP_RBS'];
    outputCodeDir = ['F:\IFEFSR\AudioFC\FC\AN4'  ...
        num2str(fs) '_ADPv2_RBS' num2str(RBS(1)) 'T' num2str(RBS(end))];
    audioPathPrefix = 'F:\IFEFSR\SpeechData\an4\wav';
    if fs == 8
        audioPathPrefix = 'F:\IFEFSR\SpeechData\an4_8k\wav';
    end

    for fileIdx = 1:size(fileList, 1)
        % compose code
        sig = rawread(fullfile( audioPathPrefix, [fileList{fileIdx} '.raw'] ));
        parts = ADP(sig, RBS, 1e-6);
        f = ADPAFCCompose( parts, codePathPrefix, [fileList{fileIdx} '.mat'], RBS );
        
        % write adaptive partition code
        outCodePath = fullfile( outputCodeDir, [fileList{fileIdx} '.mat'] );
        outCodeDir = fileparts(outCodePath);
        mkdir(outCodeDir);
        save(outCodePath, 'f');
    end
end
