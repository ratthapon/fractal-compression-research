function execJFC( varargin )
%EXECJFC JFC launcher

% build parameters list
injectParameters = cell( 1, nargin);
for idx = 1:nargin
    injectParameters{idx} = varargin{idx};
end

% write tempolary parameters file
execDir = pwd;
fileIds = [execDir '\tempParameters.txt'];
fid = fopen(fileIds,'w');
fprintf(fid, '%s\r\n', injectParameters{:});
fclose(fid);

% call fractal coding process
cd F:/GitRepo/fractal-compression/AudioCompressor/target
audioCompressorVersion = char(getFCVersion());
system(['java -cp ".;lib/*;audio-compressor-' audioCompressorVersion '.jar"' ...
    ' th.ac.kmitl.it.prip.fractal.MainExecuter ' ...
    fileIds], '-echo');
cd(execDir);

end

