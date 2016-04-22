clear all;
load('resfrac1');

L = length(encode);

for x=1:L;
     parameters = encode(:,:,x);
     s1(x) = parameters(1,7);
     if (abs(parameters(1,7))>=1)
          s2(x) = parameters(1,7);
     else
          s2(x) = 0;
     end
end

figure(1); stem(s1);
