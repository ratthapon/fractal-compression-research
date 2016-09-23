function prepareGlobalSphinx()
%PREPAREGLOBALSPHINX Prepare the global file of ExpSphinx
%   each section will create the corpus for sphinxtrain/test
%   each section must change the exp parameters

dispatchBatchResample()
dispatchBatchMATLABDecode()
dispatchBatchJDecode()
dispatchBatchMATLABMRBSDecode()
dispatchBatchLPFilter()

end

