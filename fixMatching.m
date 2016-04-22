function code = fixMatching(Domain, R1, C1, R2, C2, Range, rowR, colR, scale)
[rs cs] = size(Range);        % rs = row size and cs = col. size

r1 = Range;
r2 = rot90(r1);
r3 = rot90(r2);
r4 = rot90(r3);
r5 = flipud(Range);
r6 = rot90(r5);
r7 = rot90(r6);
r8 = rot90(r7);

R(:,:,1) = r1(:)';
R(:,:,2) = r2(:)';
R(:,:,3) = r3(:)';
R(:,:,4) = r4(:)';
R(:,:,5) = r5(:)';
R(:,:,6) = r6(:)';
R(:,:,7) = r7(:)';
R(:,:,8) = r8(:)';

Threshold = 2;                 %Initialize threshold value.
DRMS_min = 500;

colLimit = C2-2.*cs+1;
rowLimit = R2-2.*rs+1;

for colD = C1:colLimit;        % col limitation
	for rowD = R1:rowLimit;    % row limitation 
        DD = Domain(rowD:rowD+(2.*rs)-1, colD:colD+(2.*cs)-1); 
        %D = blkproc(DD,[2 2],'mean(mean(x))');
        D = avgBlk2(DD);
        D = D(:)';
        for Pattern = 1:8;
            [DRMS O S] = drmsconst(D, R(:,:,Pattern), scale);
            if ( DRMS <= Threshold )
                      code1 = [rowD, colD, rowR, colR, rs, Pattern, O, S, DRMS];
                      break;
            else if ( DRMS <= DRMS_min )
                      DRMS_min = DRMS;
                      code2 = [rowD, colD, rowR, colR, rs, Pattern, O, S, DRMS];
                 end
            end
        end
        if ( DRMS <= Threshold )
             break;
        end
    end
    if ( DRMS <= Threshold ) 
         break;
    end
end

if ( DRMS <= Threshold )
     code = code1;
     return;
else
     code = code2;
end
