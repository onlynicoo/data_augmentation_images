function [trainImages,trainLabels] = foo6(trainImages,trainLabels)
k = length(trainImages(1,1,1,:));
for i = 1:length(trainImages(1,1,1,:))
    for j = 1:4
        clear augImg
        augImg(:,:,:,j) = trainImages(:,:,:,i);
        for i=1:3

            % Applica DCT all'immagine
            DCT= dct2(augImg(:,:,i,j));
            d = DCT;
            % Metti a 0 qualche pixel
            DCT(randi([0 1], size(DCT,1),size(DCT,2))==0)=0;
            % Lascia non modificato il primo pixel (1,1)
            DCT(1,1)=d(1,1);
            
            % Riapplica DCT
            im(:,:,i) = dct2(DCT)
            % asodcma
        end
        image=uint8(im);
        trainImages(:,:,:,k+j) = im;%im(:,:,:);
        trainLabels(k+j) = trainLabels(i);
    end
    k = k+j;
end
    
end