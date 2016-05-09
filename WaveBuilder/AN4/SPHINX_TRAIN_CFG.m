% import cfg file
fid = fopen(globalCFG,'r');
cfg = textscan(fid, '%s','Delimiter','\n');
fclose(fid);

% params setting

% search line of parameters
baseDirLineIdx = -1;
mLineIdx = -1;
hfLineIdx = -1;
cLineIdx = -1;
featureLineIdx = -1;
cmnLineIdx = -1;
acgLineIdx = -1;
normLineIdx = -1;
for i = 1:size(cfg{1}, 1)
   if (~isempty(regexp(cfg{1}{i},'\$CFG_BASE_DIR = ','match')))
       baseDirLineIdx = i;
   end
   if (~isempty(regexp(cfg{1}{i},'\$CFG_NUM_FILT = ','match')))
       mLineIdx = i;
   end
   if (~isempty(regexp(cfg{1}{i},'\$CFG_HI_FILT = ','match')))
       hfLineIdx = i;
   end
   if (~isempty(regexp(cfg{1}{i},'\$CFG_VECTOR_LENGTH = ','match')))
       cLineIdx = i;
   end
   if (~isempty(regexp(cfg{1}{i},'\$CFG_FEATURE = ','match')))
       featureLineIdx = i;
   end
   if (~isempty(regexp(cfg{1}{i},'\$CFG_CMN = ','match')))
       cmnLineIdx = i;
   end
   if (~isempty(regexp(cfg{1}{i},'\$CFG_AGC = ','match')))
       acgLineIdx = i;
   end
   if (~isempty(regexp(cfg{1}{i},'\$CFG_VARNORM = ','match')))
       normLineIdx = i;
   end
   if (~isempty(regexp(cfg{1}{i},'\$CFG_WAVFILES_DIR = ','match')))
       trainWavDirLineIdx = i;
   end
   if (~isempty(regexp(cfg{1}{i},'\$CFG_TEST_WAVFILES_DIR = ','match')))
       testWavDirLineIdx = i;
   end
    
end
% assign new value
baseDir = [outPrefix expCase  ...
    '/' featExtractor '/' dataCase '/' dataSet '/A' alphaStr];

cfg{:}{baseDirLineIdx} = ['$CFG_BASE_DIR = "' baseDir '/an4' '";'];
cfg{:}{mLineIdx} = ['$CFG_NUM_FILT = ' num2str(M) ';'];
cfg{:}{hfLineIdx} = ['$CFG_HI_FILT = ' num2str(HF) ';'];
cfg{:}{cLineIdx} = ['$CFG_VECTOR_LENGTH = ' num2str(C) ';'];
featType = '';
if (C==30), featType = '1s_c' ; elseif (C==13), featType = '1s_c_d_dd'; end;
cfg{:}{featureLineIdx} = ['$CFG_FEATURE = "' featType '";'];
cfg{:}{cmnLineIdx} = '$CFG_CMN = "current";';
cfg{:}{acgLineIdx} = '$CFG_AGC = "max";';
cfg{:}{normLineIdx} = '$CFG_VARNORM = "yes";';

trainDir = ['F:/IFEFSR/SpeechData/an4/wav'];
subDir = ['F:/IFEFSR/SpeechData/an4_8k/wav'];
if strcmp(dataSet, 'FC')
    trainDir = ['F:/IFEFSR/ExpSphinx/FC1616/wav'];
    subDir = ['F:/IFEFSR/ExpSphinx/FC816/wav'];
end
if (a==1), testDir = trainDir ; elseif (a==2), testDir = subDir; end;
cfg{:}{trainWavDirLineIdx} = ['$CFG_WAVFILES_DIR = "' trainDir '";'];
cfg{:}{testWavDirLineIdx} = ['$CFG_TEST_WAVFILES_DIR = "' testDir '";'];

% save
etcDir = [outPrefix expCase '/' featExtractor '/' dataCase '/' dataSet '/A' alphaStr '/an4/etc/'];
fid = fopen([etcDir 'sphinx_train.cfg'], 'w');
fprintf(fid, '%s \r\n',cfg{:}{:});
fclose(fid);


