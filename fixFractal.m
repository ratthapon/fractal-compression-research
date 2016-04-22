function fixCode = fixFractal(Image, SofRange, scale)
[M N] = size(SofRange);
fixEncode = [];

for col = 1:N;
   for row = 1:M;
      if ( SofRange(row,col) ~= 0 )
           disp([row col]);			%for debugging program
           dim = SofRange(row,col);
           y1 = row;            
           x1 = col; 
           y2 = row+SofRange(row, col)-1; 
           x2 = col+SofRange(row, col)-1; 
           [Y1 X1 Y2 X2] = fixRegion(y1, x1, SofRange(row,col));
           range = Image(y1:y2,x1:x2);
           if ( isempty(fixEncode) )
                fixEncode = fixMatching(Image, Y1, X1, Y2, X2, range, row, col, scale);
           else
                tmp       = fixMatching(Image, Y1, X1, Y2, X2, range, row, col, scale);
                fixEncode = cat(3,fixEncode,tmp);
           end
      end
   end
end

fixCode = fixEncode;
