function imPartition = fixShow(im,s)
[M N] = size(s);
imPartition = im;

for i = 1:N;
     for j = 1:M;
          if ( s(j,i) ~= 0 )
               y1 = j; 
               x1 = i; 
               y2 = j + s(j,i); 
               x2 = i + s(j,i); 
               imPartition(y1,x1:x2) = 0; %edit for print 256;
               imPartition(y1:y2,x2) = 0; %edit for print 256;
               imPartition(y2,x1:x2) = 0; %edit for print 256;
               imPartition(y1:y2,x1) = 0; %edit for print 256;
          end
     end
end
