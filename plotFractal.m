% plot zm fractal datas
clc
clear all;
close all;
workingDir = 'F:\IFEFSR\Output\';
Fs = [11 22 44]; % input sampling rate
enFs = [8 16 32];
for iFs = 1:3
    FC(iFs) = load([workingDir 'sampling' num2str(Fs(iFs)) ...
        'k_trainfs' num2str(enFs(iFs)) 'dstep1\1']);
    f = FC(iFs).f;
end

% scatter(f(:,1),f(:,2),50,'.')