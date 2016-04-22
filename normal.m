I = imread('cameraman.tif');
[M N] = size(I);
threshold = 0.01;

DomainBlk = blkproc(I,[2 2], 'mean(mean(x))');
SofDomainBlk = partition(DomainBlk);
domainBlk = qtgetblk(DomainBlk,SofDomainBlk,8);

SofRangeBlk = partition(I);
rangeBlk = qtgetblk(I,SofRangeBlk,8);

R = length(rangeBlk);
D = length(domainBlk);

for u = 1:D;
     D1 = domainBlk(:,:,u);

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
     D1 = D1(:)';  D2 = D2(:)'; 
     D3 = D3(:)';  D4 = D4(:)'; 
     D5 = D5(:)';  D6 = D6(:)'; 
     D7 = D7(:)';  D8 = D8(:)'; 
                 
      for v=1:R;
          tmp = Range(:,:,v);
          r = tmp(:)';
                                    
          logic1 = (drms(D1,r) > threshold);
          logic2 = (drms(D2,r) > threshold);
          logic3 = (drms(D3,r) > threshold);
          logic4 = (drms(D4,r) > threshold);
          logic5 = (drms(D5,r) > threshold);
          logic6 = (drms(D6,r) > threshold);
          logic7 = (drms(D7,r) > threshold);
          logic8 = (drms(D8,r) > threshold);
                
          logic = ( logic1 & logic2 & logic3 & logic4 &...
                    logic5 & logic6 & logic7 & logic8 );                        
       end
end