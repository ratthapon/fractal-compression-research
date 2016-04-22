clear all;

I = imread('cameraman.tif');
I1 = blkproc(I,[2 2], 'mean(mean(x))');
I2 = blkproc(I1,[2 2], 'mean(mean(x))');
%I3= blkproc(I2,[2 2], 'mean(mean(x))');

[M N] = size(I2);
threshold = 3;

DomainBlk = I2;

SofRangeBlk = partition(DomainBlk);
[rangeBlk x y] = qtgetblk(DomainBlk,SofRangeBlk,4);

R = length(rangeBlk);

DRMS_min = 500;
encode = 0;

for i = 1:R;
     tmp_r = rangeBlk(:,:,i);
     range = tmp_r(:)';
     disp(i);
     for v = 1:(M-7);
          for u = 1:(N-7);
               
             Dtemp = DomainBlk(u:u+7,v:v+7);
             D1 = blkproc(Dtemp, [2 2], 'mean(mean(x))');

             Dtmp = D1;
             Dtmp = rot90(Dtmp);
             D2 = Dtmp;
      
             Dtmp = rot90(D2);
             D3 = Dtmp;
    
             Dtmp = rot90(D3);
             D4 = Dtmp;
    
             tmp = fliplr(D1);
             D5 = tmp;
 
             Dtmp = rot90(D5);
             D6 = Dtmp;
    
             Dtmp = rot90(D6);
             D7 = Dtmp;
   
             Dtmp = rot90(D7);
             D8 = Dtmp;
        
             % Set matrix to be a row vector.
             d(:,:,1) = D1(:)';  d(:,:,2) = D2(:)'; 
             d(:,:,3) = D3(:)';  d(:,:,4) = D4(:)'; 
             d(:,:,5) = D5(:)';  d(:,:,6) = D6(:)'; 
             d(:,:,7) = D7(:)';  d(:,:,8) = D8(:)'; 
                 
             for j = 1:8;
                 domain = d(:,:,j); 
                 [DRMS O S] = drms(domain, range);
                 if ( DRMS < threshold );
                      % Store u, v, j, O, S, and DRMS for encoding 
                      if ( i==1 )
                           encode = [x(i), y(i), u, v, j, O, S, DRMS];
                           
                           DRMS_min = 500;
                           encodetmp2 = 0;
                      else
                           encodetmp1 = [x(i), y(i), u, v, j, O, S, DRMS];
                           encode = cat(3, encode, encodetmp1);
                           
                           % clear and initial DRMS_min and encodetmp2.
                           DRMS_min = 500;
                           encodetmp2 = 0;
                      end
                      break;
                 else if ( DRMS <= DRMS_min )
                           DRMS_min = DRMS;
                           encodetmp2 = [x(i), y(i), u, v, j, O, S, DRMS_min];
                      end
                 end
                 
             end
             
             if ( DRMS < threshold );
                  break;
             end

         end
         
         if ( DRMS < threshold );
              break;
         end
         
    end
    if ( DRMS >= threshold );
         if ( encode == 0 )
              encode = encodetmp2;
              
              DRMS_min = 500;
              encodetmp2 = 0;
         else 
              encode = cat(3, encode, encodetmp2);
              
              DRMS_min = 500;
              encodetmp2 = 0;
         end
    end
    
end

save('data3','encode');
