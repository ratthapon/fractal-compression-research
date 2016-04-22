clear all;
load('resfrac2');

L = length(encode);

for x=1:L;
     parameters = encode(:,:,x);
     rms(x) = parameters(1,8);
end

stem(rms);
