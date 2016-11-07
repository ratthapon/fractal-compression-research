function data = openraw( file )
%OPENRAW Open raw file

% read the raw file
data = rawread(file);

% Save to the workspace 
if nargout == 0 
    assignin('base','wave',data); 
end
