clear all;
load('data3');

L = length(encode);
Iteration = 1; 
image0 = zeros(32);
image1 = zeros(32);

while ( Iteration <= 10 )
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
     figure(2); imshow(uint8(image0)); pause; 
end

imshow(uint8(image0));