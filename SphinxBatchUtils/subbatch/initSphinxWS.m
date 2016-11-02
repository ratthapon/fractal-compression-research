function initSphinxWS(expDirPrefix, preemAlphaStr, featExtractor, ...
    featCase, dataSet, recogCase, parameters, notes)
%INITSPHINXWS Init the Sphinx experiment directory
%   Detailed explanation goes here

%% setup exp directory
outDir = fullfile(expDirPrefix, ['A' preemAlphaStr], featExtractor, featCase, dataSet,  ...
    recogCase, 'an4');
mkdir(outDir);

%% coppy configure
globalEtcPath = fullfile(expDirPrefix, 'etc');
etcPath = fullfile(outDir, 'etc');
copyfile(globalEtcPath, etcPath, 'f');

%% load global mfcc parameters
[ Tw, Ts, preemAlpha, M, C, L, LF, HF ] = getMFCCSphinxParams();

%% map config string to numeric value
% config feat case, also n-mel-channel
featType = '1s_c';
if strcmpi(featCase, 'caseA') 
    featType = '1s_c'; 
    C = 30; 
elseif strcmpi(featCase, 'caseB') 
    featType = '1s_c_d_dd'; 
    C = 13;
end

% config input wave directory
trainSuffix = '';
testSuffix = '';
if strcmpi(recogCase, 'origin') 
    trainSuffix = '16';
    testSuffix = '16';
elseif strcmpi(recogCase, 'cross') 
    trainSuffix = '16';
    testSuffix = '8';
end

if strcmpi(dataSet, 'base') 

else
    trainSuffix = [ trainSuffix '16' ];
    testSuffix = [ testSuffix '16' ];
end

% insert notes space
interpNotes(1:2:(length(notes)*2)) = notes(1:length(notes));
interpNotes(2:2:(length(notes)*2)) = {' '};

%% config exp
[ cfg ] = parseSphinxCfg( fullfile(expDirPrefix, 'sphinx_train.cfg') ); % read global config
[ cfg ] = setSphinxCfg( cfg, 'CFG_BASE_DIR', ['"' normpath(outDir) '"']);
[ cfg ] = setSphinxCfg( cfg, 'CFG_NUM_FILT', num2str( M ));
[ cfg ] = setSphinxCfg( cfg, 'CFG_HI_FILT', num2str( HF ) );
[ cfg ] = setSphinxCfg( cfg, 'CFG_VECTOR_LENGTH', num2str( C ) );
[ cfg ] = setSphinxCfg( cfg, 'CFG_FEATURE', ['"' featType '"']);
[ cfg ] = setSphinxCfg( cfg, 'CFG_AGC', '"max"' );
[ cfg ] = setSphinxCfg( cfg, 'CFG_CMN', '"current"' );
[ cfg ] = setSphinxCfg( cfg, 'CFG_VARNORM', '"yes"' );
[ cfg ] = setSphinxCfg( cfg, 'CFG_STATESPERHMM', '3' );
[ cfg ] = setSphinxCfg( cfg, 'CFG_WAVFILES_DIR', ...
    ['"' normpath(fullfile(expDirPrefix, [ dataSet trainSuffix ], 'wav')) '"']);
[ cfg ] = setSphinxCfg( cfg, 'CFG_TEST_WAVFILES_DIR', ...
    ['"' normpath(fullfile(expDirPrefix, [ dataSet testSuffix ], 'wav')) '"']);

[ cfg ] = setSphinxCfg( cfg, 'CFG_NOTE', ['"' cell2mat(interpNotes) '"'] );

%% set injection params
for i = 1: size(parameters, 1)
    [ cfg ] = setSphinxCfg( cfg, parameters{1}, parameters{2} );
end

%% write the config file
writeSphinxCfg(cfg, fullfile(etcPath, 'sphinx_train.cfg'));

end

