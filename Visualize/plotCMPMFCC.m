function plotCMPMFCC( fig, varargin )
%PLOTCMPMFCC Plot the features, multiple features can plot
%simultaneousely.
% fig - output figure number
% varargin{i} - spectrum data
% varargin{i + 1} - title

figure(fig),
set(fig, 'Position', [100, 100, 500, 300]);
nSubplot = (nargin - 1)/2;
for fIdx = 1:nSubplot
    featData = varargin{(fIdx - 1)*2 + 1};
    featName = varargin{(fIdx - 1)*2 + 2};
    
    subplot(1, nSubplot, fIdx), imagesc(-featData); 
    set(gca, 'YDir', 'normal');
    
    %% set the figure's title and axes name
    title(featName);
    xlabel('Time (ms)');
    ylabel('Coefficient index');
    
    %% set the axis tick information
    ax = gca;
    set(ax, 'XTickLabel', [1:6]*320);
    set(ax, 'YTick', [1:5:30]);
    set(ax, 'YTickLabel', [1:5:30]);
    
    colormap(gray);
end

