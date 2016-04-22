clear all;

load('residual');
[M N] = size(residual);

DomainBlk = residual;

S = partition(DomainBlk);

s = full(S);
figure(2); imshow(s,'truesize');
Image_partition = fixShow(DomainBlk,s);

figure(3); imshow(uint8(abs(Image_partition)),'truesize');

fixFractalCode = fixFractal(DomainBlk,s);
save('fixcode','fixFractalCode');
