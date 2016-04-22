% clear all;
load('C:\Project\IFEFSR\code\BaseMFCC\Fix4_9DoubleScale01');


L = length(fixFractalCode);
Iteration = 1; 
image0 = zeros(512);
image1 = zeros(512);

while ( Iteration <= 15 )
     for i=1:L;
          disp([Iteration i L]);
        
          parameters = fixFractalCode(:,:,i);
          v = parameters(1,1) * 2;
          u = parameters(1,2) * 2; 
          y = parameters(1,3) * 2;
          x = parameters(1,4) * 2;
          dim = parameters(1,5) * 2;
          rotation = parameters(1,6);
          o = parameters(1,7);
          s = parameters(1,8);
          if v+(2*dim)-1 > 512
              v = 512 - (2*dim) + 1;
          end
          if u+(2*dim)-1 > 512
              u = 512 - (2*dim) + 1;
          end
          switch (rotation)
          case 1
                %tmp = blkproc(image1(v:v+(2*dim)-1,u:u+(2*dim)-1),[2 2], 'mean(mean(x))');
                tmp = avgBlk2(image1(v:v+(2*dim)-1,u:u+(2*dim)-1));
                image0(y:y+dim-1,x:x+dim-1) = (s.*tmp)+o;
          case 2
                %tmp = blkproc(image1(v:v+(2*dim)-1,u:u+(2*dim)-1),[2 2], 'mean(mean(x))');
                tmp = avgBlk2(image1(v:v+(2*dim)-1,u:u+(2*dim)-1));
                tmp = rot90(tmp);
                image0(y:y+dim-1,x:x+dim-1) = (s.*tmp)+o;
          case 3;
                %tmp = blkproc(image1(v:v+(2*dim)-1,u:u+(2*dim)-1),[2 2], 'mean(mean(x))');
                tmp = avgBlk2(image1(v:v+(2*dim)-1,u:u+(2*dim)-1));
                tmp = rot90(tmp); tmp = rot90(tmp);
                image0(y:y+dim-1,x:x+dim-1) = (s.*tmp)+o;
          case 4
                %tmp = blkproc(image1(v:v+(2*dim)-1,u:u+(2*dim)-1),[2 2], 'mean(mean(x))');
                tmp = avgBlk2(image1(v:v+(2*dim)-1,u:u+(2*dim)-1));
                tmp = rot90(tmp); tmp = rot90(tmp); tmp = rot90(tmp);
                image0(y:y+dim-1,x:x+dim-1) = (s.*tmp)+o;
          case 5;
                %tmp = blkproc(image1(v:v+(2*dim)-1,u:u+(2*dim)-1),[2 2], 'mean(mean(x))');
                tmp = avgBlk2(image1(v:v+(2*dim)-1,u:u+(2*dim)-1));
                tmp = flipud(tmp);
                image0(y:y+dim-1,x:x+dim-1) = (s.*tmp)+o;
          case 6;
                %tmp = blkproc(image1(v:v+(2*dim)-1,u:u+(2*dim)-1),[2 2], 'mean(mean(x))');
                tmp = avgBlk2(image1(v:v+(2*dim)-1,u:u+(2*dim)-1));
                tmp = flipud(tmp); 
                tmp = rot90(tmp);
                image0(y:y+dim-1,x:x+dim-1) = (s.*tmp)+o;
          case 7;
                %tmp = blkproc(image1(v:v+(2*dim)-1,u:u+(2*dim)-1),[2 2], 'mean(mean(x))');
                tmp = avgBlk2(image1(v:v+(2*dim)-1,u:u+(2*dim)-1));
                tmp = flipud(tmp); 
                tmp = rot90(tmp); tmp = rot90(tmp);
                image0(y:y+dim-1,x:x+dim-1) = (s.*tmp)+o;
          case 8
                %tmp = blkproc(image1(v:v+(2*dim)-1,u:u+(2*dim)-1),[2 2], 'mean(mean(x))');
                tmp = avgBlk2(image1(v:v+(2*dim)-1,u:u+(2*dim)-1));
                tmp = flipud(tmp); 
                tmp = rot90(tmp); tmp = rot90(tmp); tmp = rot90(tmp);
                image0(y:y+dim-1,x:x+dim-1) = (s.*tmp)+o;
          otherwise
                error('It is not normal orientation.');
          end
     end
     image1 = image0;
     Iteration = Iteration + 1;
     figure(2); imshow(uint8(image0)); 
     %pause; 
end

figure(2); imshow(uint8(image0),'InitialMagnification',100);

org = imread('lena.bmp');
psnr = PSNR(org, image0);
disp([psnr]);

