clear all;

%I = imread('cactus1.bmp');
I = imread('lena.bmp');
DomainBlk = I;

% Encoding fractal image compression with block size 4.
blkSize = 4;
S = fixPartition(DomainBlk, blkSize);
sps = full(S);        % sps is a sparse matrix.

	%figure(2); imshow(sps,'truesize');
	%Image_partition = fixShow(DomainBlk,sps);
	%figure(3); imshow(uint8(Image_partition),'truesize');
     
pathName4 = 'C:\MATLAB\work\FixSize2D\cactus\fix4\fix4_';
     
for scale = 0.1:0.1:1
    profile on;
    fixFractalCode = fixFractal(DomainBlk, sps, scale);
    fName = strcat(pathName4,int2str(scale*10));
    profreport(fName);
    save(fName,'fixFractalCode');
end
 
%------------------------------------------------------

% Encoding fractal image compression with block size 8.
blkSize = 8;
S = fixPartition(DomainBlk, blkSize);
sps = full(S);        % sps is a sparse matrix.

pathName8 = 'C:\MATLAB\work\FixSize2D\cactus\fix8\fix8_';
     
for scale = 0.1:0.1:1
    profile on;
    %fixFractalCode = fixFractal(DomainBlk, sps, scale);
    fixFractalCode = scale;
    fName = strcat(pathName8,int2str(scale*10));
    profreport(fName);
    save(fName,'fixFractalCode');
end
 
%------------------------------------------------------

% Encoding fractal image compression with block size 16.
blkSize = 16;
S = fixPartition(DomainBlk, blkSize);
sps = full(S);        % sps is a sparse matrix.

	%figure(2); imshow(sps,'truesize');
	%Image_partition = fixShow(DomainBlk,sps);
	%figure(3); imshow(uint8(Image_partition),'truesize');
     
pathName16 = 'C:\MATLAB\work\FixSize2D\cactus\fix16\fix16_';
     
for scale = 0.1:0.1:1
    profile on;
    %fixFractalCode = fixFractal(DomainBlk, sps, scale);
    fixFractalCode = scale;
    fName = strcat(pathName16,int2str(scale*10));
    profreport(fName);
    save(fName,'fixFractalCode');
end
 
%------------------------------------------------------
