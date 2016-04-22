
close all
% for i=25:40
%     figure(i),plot([MFCCsd44to11(:,i) MFCCsd44to22(:,i) MFCCsd44to44(:,i) ])
%     legend('11k','22k','44k');
% end

for i=25:40
    figure(i),plot([MFCCsw11(:,i) MFCCsw22(:,i) MFCCsw44(:,i) ])
    legend('11k','22k','44k');
end
