clear all;
load('D:\Fix4_9');


L = length(fixFractalCode);
Iteration = 1; 
image0 = zeros(256);
image1 = zeros(256);

while ( Iteration <= 10 )
     for i=1:L;
          disp([Iteration i L]);
        
          parameters = fixFractalCode(:,:,i);
          v = parameters(1,1);
          u = parameters(1,2); 
          y = parameters(1,3);
          x = parameters(1,4);
          dim = parameters(1,5);
          rotation = parameters(1,6);
          o = parameters(1,7);
          s = parameters(1,8);
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

figure(2); imshow(uint8(image0),'truesize');
imageL(1:2:256,:) = image0(1:2:256,:);
imageR(2:2:256,:) = image0(2:2:256,:);
figure(3); imshow(uint8(imageL),'truesize');
figure(4); imshow(uint8(imageR),'truesize');

org = imread('cactus1.bmp');
psnr = PSNR(org, image0);
disp([psnr]);

figure(5); 
subplot(2,1,1); plot(org(50,:)); axis([1 300 50 300]);
subplot(2,1,2); plot(org(:,100)); axis([1 300 50 300]);

figure(6); 
subplot(2,1,1); plot(image0(50,:)); axis([1 300 50 300]);
subplot(2,1,2); plot(image0(:,100)); axis([1 300 50 300]);

image0 = uint8(image0);
imageL = uint8(imageL);
imageR = uint8(imageR);

%imwrite(image0, 'C:\Phd_Paper\Seminar\fix_4_a.png', 'BitDepth', 8);
%imwrite(imageL, 'C:\Phd_Paper\Seminar\fix_4_b.png', 'BitDepth', 8);
%imwrite(imageR, 'C:\Phd_Paper\Seminar\fix_4_c.png', 'BitDepth', 8);
