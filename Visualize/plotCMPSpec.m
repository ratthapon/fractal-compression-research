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
    
    subplot(1, nSubplot, fIdx), imagesc(-specData); 
    set(gca, 'YDir', 'normal');
    
    %% set the figure's title and axes name
    title(specName);
    xlabel('Time (ms)');
    ylabel('Frequency (kHz)');
    
    %% set the axis tick information
    ax = gca;
    set(ax, 'XTickLabel', [1:6]*320);
    set(ax, 'YTick', [32:32:256]);
    set(ax, 'YTickLabel', [1:8]);
    
    colormap(gray);
end