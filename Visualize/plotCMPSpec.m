function plotCMPSpec(fig, varargin )
%PLOTCMPSPECTRUM Plot the spectrum, multiple spectrum can plot
%simultaneousely.
% fig - output figure number
% varargin{i} - spectrum data
% varargin{i + 1} - title

figure(fig),
set(fig, 'Position', [100, 100, 500, 300]);
nSubplot = (nargin - 1)/2;
for fIdx = 1:nSubplot
    specData = varargin{(fIdx - 1)*2 + 1};
    specName = varargin{(fIdx - 1)*2 + 2};
    
    freq = 1:size(specData, 1) * 8/256;
    time = 1:size(specData, 2) * 16;
    
    subplot(1, nSubplot, fIdx), imagesc(time, freq, -specData); 
    set(gca, 'YDir', 'normal');
    
    %% set the figure's title and axes name
    title(specName);
    xlabel('Time (ms)');
    ylabel('Frequency (kHz)');
    
    colormap(gray);
end