function [rms, o, s] = drmsconst(a,b,sLimit)
a = double(a); b = double(b);

if(size(a) ~= size(b))
   error('dimension of arguments is not agree.');
end

sum_a = sum(a);
sum_a2 = sum(a.^2);
sum_b = sum(b);
sum_b2 = sum(b.^2);

sum_ab = sum(a.*b);

dim = size(a);
n = dim(1,2);

s1 = (n.*sum_ab)-(sum_a.*sum_b); s2 = (n.*sum_a2)-(sum_a.^2);

if (s2==0)
   s = 0;
   o = (1./n).*sum_b;
else
     sReal  = s1./s2;
     if( (sReal < sLimit) & (sReal > -sLimit) )
          s = sReal;
     elseif( sReal >= sLimit )
          s = sLimit;
     else
          s = -sLimit;
     end
     o = (1./n).*(sum_b-(s.*sum_a));
end

x = (s.*sum_a2)-(2.*sum_ab)+(2.*o.*sum_a);
y = ((n.*o)-(2.*sum_b));
R = (1./n).*(sum_b2+(s.*x)+o.*y);
rms = sqrt(R);
