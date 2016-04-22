% 
load('F:\IFEFSR\FractalCode\22k_train_matlabResampling_Fs16ds1\22k_speaker_1_sp_1-01.mat');
f22 = f;
load('F:\IFEFSR\FractalCode\44k_train_matlabResampling_Fs32ds1\44k_speaker_1_sp_1-01.mat');
f44 = f;

w11 = audioread('F:\IFEFSR\SpeechData\TestDAT_matlabResampling\11k_speaker_1_sp_1-01.wav');
w22 = audioread('F:\IFEFSR\SpeechData\TestDAT_matlabResampling\22k_speaker_1_sp_1-01.wav');
w44 = audioread('F:\IFEFSR\SpeechData\TestDAT_matlabResampling\44k_speaker_1_sp_1-01.wav');

dew11to22 = fractalDecode(f22,22050,16,1,22050,w11',[]);
dew22to22 = fractalDecode(f22,22050,16,1,22050,w22',[]);
dew44to22 = fractalDecode(f22,22050,16,1,22050,w44',[]);

