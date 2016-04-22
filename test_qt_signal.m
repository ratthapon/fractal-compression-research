% qt signal
% wav = audioread('F:\IFEFSR\SpeechData\TestDAT\11k_speaker_1_sp_1-11.wav');
% S = qtdecomp(wav, 0.5, [4 256]);

I = imread('liftingbody.png');
S = qtdecomp(I,.6);
blocks = repmat(uint8(0),size(S));

for dim = [512 256 128 64 32 16 8 4 2 1];    
  numblocks = length(find(S==dim));    
  if (numblocks > 0)        
    values = repmat(uint8(1),[dim dim numblocks]);
    values(2:dim,2:dim,:) = 0;
    blocks = qtsetblk(blocks,S,dim,values);
  end
end

blocks(end,1:end) = 1;
blocks(1:end,end) = 1;

imshow(I), figure, imshow(blocks,[])