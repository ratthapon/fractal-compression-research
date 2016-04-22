
filesList = importdata(['F:\IFEFSR\11k_TEST_MR_Thesh1E-4_code.txt']);
for fIdx = 1:size(filesList,1)
    load(filesList{fIdx});
    %     if size(f,2) ~= 7
    %         'Errr'
    %         fIdx
    %     end
    f_in = f;
    f = [f_in(:,1:2) f_in(:,4:7)];
    save(filesList{fIdx},'f');
end