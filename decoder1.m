clear all;
load('resfrac1');

L = length(encode);
Iteration = 1; 
image0 = zeros(256);
image1 = zeros(256);

while ( Iteration <= 20 )
     for i=1:L;
          parameters = encode(:,:,i);
          x = parameters(1,1);
          y = parameters(1,2); 
          u = parameters(1,3);
          v = parameters(1,4);
          rotation = parameters(1,5);
          o = parameters(1,6);
          s = parameters(1,7);
          switch (rotation)
          case 1
                tmp = blkproc(image1(u:u+15,v:v+15),[2 2], 'mean(mean(x))');
                image0(x:x+7,y:y+7) = (s.*tmp)+o;
          case 2
                tmp = blkproc(image1(u:u+15,v:v+15),[2 2], 'mean(mean(x))');
                tmp = rot90(tmp);
                image0(x:x+7,y:y+7) = (s.*tmp)+o;
          case 3;
                tmp = blkproc(image1(u:u+15,v:v+15),[2 2], 'mean(mean(x))');
                tmp = rot90(tmp); tmp = rot90(tmp);
                image0(x:x+7,y:y+7) = (s.*tmp)+o;
          case 4
                tmp = blkproc(image1(u:u+15,v:v+15),[2 2], 'mean(mean(x))');
                tmp = rot90(tmp); tmp = rot90(tmp); tmp = rot90(tmp);
                image0(x:x+7,y:y+7) = (s.*tmp)+o;
          case 5;
                tmp = blkproc(image1(u:u+15,v:v+15),[2 2], 'mean(mean(x))');
                tmp = fliplr(tmp);
                image0(x:x+7,y:y+7) = (s.*tmp)+o;
          case 6;
                tmp = blkproc(image1(u:u+15,v:v+15),[2 2], 'mean(mean(x))');
                tmp = fliplr(tmp); 
                tmp = rot90(tmp);
                image0(x:x+7,y:y+7) = (s.*tmp)+o;
          case 7;
                tmp = blkproc(image1(u:u+15,v:v+15),[2 2], 'mean(mean(x))');
                tmp = fliplr(tmp); 
                tmp = rot90(tmp); tmp = rot90(tmp);
                image0(x:x+7,y:y+7) = (s.*tmp)+o;
          case 8
                tmp = blkproc(image1(u:u+15,v:v+15),[2 2], 'mean(mean(x))');
                tmp = fliplr(tmp); 
                tmp = rot90(tmp); tmp = rot90(tmp); tmp = rot90(tmp);
                image0(x:x+7,y:y+7) = (s.*tmp)+o;
          otherwise
                error('It is not normal orientation.');
          end
     end
     image1 = image0;
     Iteration = Iteration + 1;
     figure(1); imshow(uint8(abs(image0))); %pause; 
end

imshow(uint8(abs(image0)));

load('stereopair');
figure(2); imshow(uint8(imL)); 
figure(3); imshow(uint8(imR)); 

res = double(imL)-double(imR);
figure(4); imshow(uint8(abs(res)));

Recon_imR = double(imL) - image0;
figure(5); imshow(uint8(Recon_imR)); 

