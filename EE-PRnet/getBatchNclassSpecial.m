function inputs = getBatchNclassSpecial(imdb,batchIdx,trSetIdx,at_epoch_on)

imsize224 = [224 224];
avRGB = [123.68 116.78 103.94];
label_batch = single(imdb.label(1,batchIdx));

if(batchIdx(1) < trSetIdx+1)
img = vl_imreadjpeg(imdb.image(batchIdx),'resize',imsize224,'SubtractAverage',avRGB,'Pack','Saturation',.9,'Contrast',0.7);
else
img = vl_imreadjpeg(imdb.image(batchIdx),'resize',imsize224,'SubtractAverage',avRGB,'Pack');
end
img2Align_batch = img{1}; 
img2Align_batch = gpuArray(img2Align_batch);
label_batch =  gpuArray(label_batch);
% img2ROI_batch = gpuArray(img2ROI_batch);
% img2Align_batch = gpuArray(img2Align_batch);
% label_batch =  gpuArray(label_batch);


inputs = {'label', label_batch, 'ANInput', img2Align_batch, 'Input224', img2Align_batch};


