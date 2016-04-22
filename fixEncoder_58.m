% clear all;

I = imread('lena.bmp');
% I = doub;
% I = double(I);
% I = I/256;
%I128 = I(1:2:256, 1:2:256);
DomainBlk = I;

% Encoding fractal image compression with block size 4.
blkSize = 4;
S = fixPartition(DomainBlk, blkSize);
sps = full(S);        % sps is a sparse matrix.

	figure(2); imshow(sps,'InitialMagnification',100);
	Image_partition = fixShow(DomainBlk,sps);
	figure(3); imshow(uint8(Image_partition),'InitialMagnification',100);
     
pathName4 = 'C:\Project\IFEFSR\code\BaseMFCC\fix4_';
     
for scale = 0.9:0.1:0.9
    profile on;
    fixFractalCode = fixFractal(DomainBlk, sps, scale);
    fName = strcat(pathName4,int2str(scale*10),'DoubleScale01');
    profreport(fName);
    save(fName,'fixFractalCode');
end
 
%------------------------------------------------------

% Encoding fractal image compression with block size 8.
% blkSize = 8;
% S = fixPartition(DomainBlk, blkSize);
% sps = full(S);        % sps is a sparse matrix.
% 
% pathName8 = 'C:\MATLAB\work\FixSize2D\cactus\fix8\fix8_';
%      
% for scale = 0.1:0.1:1
%     profile on;
%     %fixFractalCode = fixFractal(DomainBlk, sps, scale);
%     fixFractalCode = scale;
%     fName = strcat(pathName8,int2str(scale*10));
%     profreport(fName);
%     save(fName,'fixFractalCode');
% end
%  
% %------------------------------------------------------
% 
% % Encoding fractal image compression with block size 16.
% blkSize = 16;
% S = fixPartition(DomainBlk, blkSize);
% sps = full(S);        % sps is a sparse matrix.
% 
% 	%figure(2); imshow(sps,'truesize');
% 	%Image_partition = fixShow(DomainBlk,sps);
% 	%figure(3); imshow(uint8(Image_partition),'truesize');
%      
% pathName16 = 'C:\MATLAB\work\FixSize2D\cactus\fix16\fix16_';
%      
% for scale = 0.1:0.1:1
%     profile on;
%     %fixFractalCode = fixFractal(DomainBlk, sps, scale);
%     fixFractalCode = scale;
%     fName = strcat(pathName16,int2str(scale*10));
%     profreport(fName);
%     save(fName,'fixFractalCode');
% end
 
%------------------------------------------------------
