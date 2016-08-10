function partitionSize = adaptivePartition1D(dat,thresh)
% dat = wav;
% blockSize = [4 8 16 32 64 128 256 512];
% blockSize = blockSize(end:-1:1)
dat = dat(:)';
partitionSize = zeros(size(dat)); % partitioned boundary size
partitionSize(1) = size(dat,2);
minBlockSize = 8;
canPartition = true;
datLen = size(dat,2);
% loop until can't partition 
while canPartition
    canPartition = 0;
    
    % for entire data 
    for idx = 1:datLen
        
        % found boundary information
        if partitionSize(idx) > 0
            % retrive neccessary information
            chunkSize = partitionSize(idx);
            from = idx;
            to = from + chunkSize - 1;
            % check if need to partition
            if needToSegment(dat,from,to,thresh) && chunkSize >= minBlockSize*2
                canPartition = true;
                
                % reset old information in boundary
                for i = from:to
                    partitionSize(i) = 0;
                end
                % set new information
                midPosition = from + floor((to - from)/2) + 1;
                partitionSize(idx) = midPosition - from;
                partitionSize(midPosition) = to - midPosition + 1;
            end
        end
    end
end
% var(wav) 