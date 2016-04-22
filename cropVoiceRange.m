% crop voice range
nCoef = 6;
fsPath = [{'11k_train'},{'11k_test'},{'22k_train'}, ...
    {'22k_test'},{'44k_train'},{'44k_test'}];

for f=1:6
    outPath = ['F:\IFEFSR\CropSpeech\' fsPath{f}];
    mkdir(outPath);
    fileList = importdata(['F:\IFEFSR\' fsPath{f} '.txt']);
    for i=1:10:180 %size(fileList)
        close all;
        [data,Fs] = audioread(fileList{i});
        
        len=length(data');
        [c,l]=wavedec(data',nCoef,'db1');
        [xd,cxd,lxd] = wden(c,l,'minimaxi','s','mln',nCoef,'db1');
        % Compute and reshape DWT to compare with CWT.
        cfd=zeros(nCoef,len);
        for k=1:nCoef
            d=detcoef(cxd,lxd,k);
            d=d(ones(1,2^k),:);
            cfd(k,:)=wkeep(d(:)',len);
        end
        cfd=cfd(:);
        I=find(abs(cfd) <sqrt(eps));
        cfd(I)=zeros(size(I));
        cfd=reshape(cfd,nCoef,len);
        coefSpect = flipud(wcodemat(cfd,255,'row'));
        coefSpect(coefSpect==1) = 0;
        nonZeroSpect = find(std(coefSpect)>5);
        cropData = data(nonZeroSpect(1):nonZeroSpect(end));
        figure,plot(data);
        figure,plot(cropData);
        fileName = regexp(fileList{i}, '\', 'split');
        audiowrite([outPath '\' fileName{end}],cropData,Fs);
        
%         image(cropData);
%         colormap(pink(255));
    end
end