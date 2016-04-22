function logic = needToSegment(dat,from,to,thresh)
newDat = dat(from:to);
logic = var(newDat) > thresh;
% logic = true;