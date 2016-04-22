% w11 = audioread('F:\IFEFSR\SpeechData\TestDAT\11k_speaker_1_sp_1-01.wav')';
% w22 = audioread('F:\IFEFSR\SpeechData\TestDAT\22k_speaker_1_sp_1-01.wav')';
fileIdx = 111;
spIdx = num2str(mod(fileIdx,10));
wIdx = num2str(floor(fileIdx/10)+1);

w44 = audioread(['F:\IFEFSR\SpeechData\TestDAT\44k_speaker_1_sp_' wIdx '-0' spIdx '.wav'])';
sampleIdx22 =1:(44100/22050):size(w44,2);
sampleIdx11 =1:(44100/11025):size(w44,2);
w11 = w44(sampleIdx11);
% w11 = resample(w11,44100,11025);
w22 = w44(sampleIdx22);
% w22 = resample(w22,44100,22050);

% close all;
% w22to11 = resample(w22,11025,22050);
% w44to11 = resample(w44,11025,44100);

load(['F:\IFEFSR\Output\sampling11k_trainfs16dstep1\' num2str(fileIdx)]);
f11 = f;
load(['F:\IFEFSR\Output\sampling22k_trainfs32dstep1\' num2str(fileIdx)]);
f22 = f;
load(['F:\IFEFSR\Output\sampling44k_trainfs64dstep1\' num2str(fileIdx)]);
f44 = f;
de11to11 = fractalDecode(f11,11025,16,1,11025,[],[]);
de11to22 = fractalDecode(f11,11025,16,1,22050,[],[]);
de11to44 = fractalDecode(f11,11025,16,1,44100,[],[]);
de22to44 = fractalDecode(f22,22050,32,1,44100,[],[]);
de22to22 = fractalDecode(f22,22050,32,1,22050,[],[]);
de22to11 = fractalDecode(f22,22050,32,1,11025,[],[]);
de44to44 = fractalDecode(f44,44100,64,1,44100,[],[]);
de44to22 = fractalDecode(f44,44100,64,1,22050,[],[]);
de44to11 = fractalDecode(f44,44100,64,1,11025,[],[]);

%% transcode FBE
FBEde11to11 = getFBE(de11to11,11025);
FBEde11to22 = getFBE(de11to22,11025);
FBEde11to44 = getFBE(de11to44,11025);
FBEde22to11 = getFBE(de22to11,22050);
FBEde22to22 = getFBE(de22to22,22050);
FBEde22to44 = getFBE(de22to44,22050);
FBEde44to11 = getFBE(de44to11,44100);
FBEde44to22 = getFBE(de44to22,44100);
FBEde44to44 = getFBE(de44to44,44100);


%% original
FBEw11 = getFBE(w11,11025);
FBEw22 = getFBE(w22,22050);
FBEw44 = getFBE(w44,44100);

% figure(1),
% subplot(2,1,1),hold on,
% stem([ FBEde11to11   FBEde22to22   FBEde44to44 ])
% legend('decode 11k to 11k','decode 22k to 22k','decode 44k to 44k')
% xlabel('Mel channel')
% subplot(2,1,2),hold on
% stem([FBEw11 FBEw22 FBEw44])
% legend('sampling rate 11k','sampling rate 22k','sampling rate 44k')
% xlabel('Mel channel')

% close all
clf,
figure(2),
subplot(2,1,1),hold on,
stem([FBEde11to11*4  FBEde22to22*2   FBEde44to44 ])
legend('decode 11k to 11k','decode 22k to 22k','decode 44k to 44k')
xlabel('Mel channel')
axis([0 inf 0 max([FBEde11to11*4 ;FBEde22to22*2; FBEde44to44; FBEw11*4; FBEw22*2; FBEw44;])])
subplot(2,1,2),hold on
stem([FBEw11*4 FBEw22*2 FBEw44])
legend('sampling rate 11k','sampling rate 22k','sampling rate 44k')
xlabel('Mel channel')
axis([0 inf 0 max([FBEde11to11*4 ;FBEde22to22*2; FBEde44to44; FBEw11*4; FBEw22*2; FBEw44;])])
