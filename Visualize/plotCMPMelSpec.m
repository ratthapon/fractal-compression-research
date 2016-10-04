function plotCMPMelSpec( fig, varargin )
%PLOTCMPMELSPEC Plot the mel spectrum, multiple mel spectrum can plot
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
    ylabel('Mel frequency index');
    
    %% set the axis tick information
    ax = gca;
    set(ax, 'XTickLabel', [1:6]*320);
    set(ax, 'YTick', [1:2:30]);
    set(ax, 'YTickLabel', [1:2:30]);
    
    colormap(gray);
end
