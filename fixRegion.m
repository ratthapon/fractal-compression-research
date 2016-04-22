function [R1, C1, R2, C2] = fixRegion(r1,c1,dim)

Rmax = 256;
Cmax = 256;
rOffset = 8.*dim;
cOffset = 8.*dim;
          
if( (r1-rOffset) < 0 )
	R1 = 1; 
	R2 = 2.*rOffset;
elseif( (r1+rOffset) > Rmax )
	R1 = Rmax-2.*(rOffset)+1;
	R2 = Rmax;
else
	R1 = r1-rOffset+1;
	R2 = r1+rOffset;
end

if( (c1-cOffset) < 0 )
	C1 = 1; 
	C2 = 2.*cOffset;
elseif( (c1+cOffset) > Cmax )
	C1 = Cmax-2.*(cOffset)+1;
	C2 = Cmax;
else
	C1 = c1-cOffset+1;
	C2 = c1+cOffset;
end
