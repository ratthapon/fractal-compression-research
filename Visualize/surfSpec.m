function surfSpec( fig, varargin )
%SURFSPEC Surfplot the spectrum, multiple spectrum can plot
%simultaneousely.
% fig - output figure number
% varargin{i} - spectrum data
% varargin{i + 1} - title

figure(fig),
nSubplot = (nargin - 1)/2;
for fIdx = 1:nSubplot
    specData = varargin{(fIdx - 1)*2 + 1};
    specName = varargin{(fIdx - 1)*2 + 2};
    
    subplot(1, nSubplot, fIdx), surf(specData); 
    set(gca, 'YDir', 'normal');
    
    %% set the figure's title and axes name
    title(specName);
    xlabel('Time (ms)');
    ylabel('Frequency (kHz)');
    zlabel('Magnitude (x1000)');
    
    %% set the axis tick information
    ax = gca;
    set(ax, 'XTickLabel', [1:6]*320);
    set(ax, 'YTick', [32:32:256]);
    set(ax, 'YTickLabel', [1:8]);
    set(ax, 'ZTick', [0:1000:16000]);
    set(ax, 'ZTickLabel', [0:16]);
    
    axis([0 inf 0 256 0 16000]);
    view([60, -60, 45]);
end

