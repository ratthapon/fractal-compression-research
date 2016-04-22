clear all;
load('fixcode');
encode = fixFractalCode;

L = length(encode);
Iteration = 1; 
image0 = zeros(256);
image1 = zeros(256);

while ( Iteration <= 15 )
     for i=1:L;
          parameters = encode(:,:,i);
          v = parameters(1,1);
          u = parameters(1,2); 
          y = parameters(1,3);
          x = parameters(1,4);
          rotation = parameters(1,6);
          o = parameters(1,7);
          s = parameters(1,8);
          
          switch (rotation)
          case 1
                tmp = blkproc(image1(v:v+7,u:u+7),[2 2], 'mean(mean(x))');
                image0(y:y+3,x:x+3) = (s.*tmp)+o;
          case 2
                tmp = blkproc(image1(v:v+7,u:u+7),[2 2], 'mean(mean(x))');
                tmp = rot90(tmp);
                image0(y:y+3,x:x+3) = (s.*tmp)+o;
          case 3;
                tmp = blkproc(image1(v:v+7,u:u+7),[2 2], 'mean(mean(x))');
                tmp = rot90(tmp,2); 
                image0(y:y+3,x:x+3) = (s.*tmp)+o;
          case 4
                tmp = blkproc(image1(v:v+7,u:u+7),[2 2], 'mean(mean(x))');
                tmp = rot90(tmp,3); 
                image0(y:y+3,x:x+3) = (s.*tmp)+o;
          case 5;
                tmp = blkproc(image1(v:v+7,u:u+7),[2 2], 'mean(mean(x))');
                tmp = flipud(tmp);
                image0(y:y+3,x:x+3) = (s.*tmp)+o;
          case 6;
                tmp = blkproc(image1(v:v+7,u:u+7),[2 2], 'mean(mean(x))');
                tmp = flipud(tmp); 
                tmp = rot90(tmp);
                image0(y:y+3,x:x+3) = (s.*tmp)+o;
          case 7;
                tmp = blkproc(image1(v:v+7,u:u+7),[2 2], 'mean(mean(x))');
                tmp = flipud(tmp); 
                tmp = rot90(tmp,2); 
                image0(y:y+3,x:x+3) = (s.*tmp)+o;
          case 8
                tmp = blkproc(image1(v:v+7,u:u+7),[2 2], 'mean(mean(x))');
                tmp = flipud(tmp); 
                tmp = rot90(tmp,3); 
                image0(y:y+3,x:x+3) = (s.*tmp)+o;
          otherwise
                error('It is not normal orientation.');
          end
     end
     image1 = image0;
     Iteration = Iteration + 1;
     figure(3); imshow(uint8(abs(image0))); %pause; 
end

imshow(uint8(abs(image0)));

load('imL');
iml = double(imL);
figure(4); imshow(uint8(iml-image0));

