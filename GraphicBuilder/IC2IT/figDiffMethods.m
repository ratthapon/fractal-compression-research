expDir = 'F:\IFEFSR\ExpSphinx\';
dataSet = 'FCMATLABRBS4FSPITCH3NHAR20MINCD1MINHD10INCLUDEORIGINT9HARFS1616';
dataSet2 = 'FCMATLABRBS4FSPITCH3NHAR20MINCD1MINHD10EXCLUDEORIGINT9HARFS1616';
nPitch = 3;
nHar = 20;
minCD = 1;
minHD = 10;
exclude = false;
harfunc = @(originSig, sig) addHarToSigFromCeps( originSig, sig, ...
    16 * 1000, 16  * 1000, ...
    'npitch', nPitch, 'nhar', nHar, 'mincd', minCD, 'minhd', minHD, ...
    'enableexcludeorigin', exclude);
fileListPath = [expDir 'an4traintest.txt'];
fileList = importdata(fileListPath);

for sampleIdx = 30:30
    reconFilePath = normpath([expDir dataSet '\wav\' fileList{sampleIdx} '.raw']);
    reconFilePath2 = normpath([expDir dataSet2 '\wav\' fileList{sampleIdx} '.raw']);
    originFilePath = normpath([expDir 'BASE16' '\wav\' fileList{sampleIdx} '.raw']);
    subsampleFilePath = normpath([expDir 'BASE8' '\wav\' fileList{sampleIdx} '.raw']);
    
    speech00 = rawread(subsampleFilePath);
    speech0 = rawread(originFilePath);
    [ CC0, FBE0, OUTMAG0, MAG0, H0, DCT0] = mfcc2( speech0, 16000);
    
    speech1 = rawread(reconFilePath2);
    [ CC1, FBE1, OUTMAG1, MAG1, H1, DCT1] = mfcc2( speech1, 16000);
    
    speech2 = rawread(reconFilePath);
    [ CC2, FBE2, OUTMAG2, MAG2, H2, DCT2] = mfcc2( speech2, 16000);
    
    [speech3, fundFreq, synthHar]  = harfunc(speech0, speech2);
    [ CC3, FBE3, OUTMAG3, MAG3, H3, DCT3] = mfcc2( speech3, 16000);
    
    [speech4, fundFreq, synthHar]  = harfunc(speech0, speech1);
    [ CC4, FBE4, OUTMAG4, MAG4, H4, DCT4] = mfcc2( speech4, 16000);
    
    plotCMPSpec(5, ...
        OUTMAG0(:, 25:65), {'Spectrum of','original signal 16 kHz'}, ...
        OUTMAG1(:, 25:65), {'Spectrum of','FCD method 16->16 kHz'}, ...
        OUTMAG4(:, 25:65), {'Spectrum of','hybrid of FCD and HP method 16->16 kHz'} ...
        );
    set(gcf, 'position', [-1600 0 900 300])
    
    g = fspecial('average', [1 512]);
    diff1 = rangefilt( abs(zscore(OUTMAG0)-zscore(OUTMAG1)), ones(41, 3));
    diff2 = rangefilt( abs(zscore(OUTMAG0)-zscore(OUTMAG4)), ones(41, 3));
    plotCMPSpec(6, ...
        diff1(:, 25:65), {'Difference of','16 kHz spectrum from','FCD method and original signal'}, ...
        diff2(:, 25:65), {'Difference of','16 kHz spectrum from','hybrid of FCD and HP method and original signal'} ...
        );
    set(gcf, 'position', [-1600 0 900 300])
    
    figure(6)
    for subfig = 1:2
        subplot(1, 2, subfig),
        hold on,
        plot(repmat([ 100 220 380 520 ], 2, 1), repmat([2:3]', 1, 4), 'k');
        plot(1:700 , ones(1,700) * 2.5, 'k');
        text([15 260 550],[2.5 2.5 2.5], 'silence', ...
            'BackgroundColor', 'white', 'FontSize', 8);
        text([120 410],[2.5 2.5], 'speech', ...
            'BackgroundColor', 'white', 'FontSize', 8);
    end
end




