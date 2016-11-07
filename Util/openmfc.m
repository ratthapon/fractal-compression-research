function data = openmfc( file )
% check if feature dimension already exists, if not load global value
if ~exist('C', 'var')
    [ ~, ~, ~, ~, C, ~, ~, ~ ] = getMFCCSphinxParams();
end

% Load the data 
data = featread( file , C); 

% Save to the workspace 
if nargout == 0 
    assignin('base','feat',data); 
end

% chekif instaplot is turn on, then show the feature
if exist('instaplot', 'var') && instaplot == true
    fig = figure();
    plotCMPMFCC( fig, data )
end