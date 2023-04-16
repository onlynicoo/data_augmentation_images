% Input of the function
function [trainImages,trainLabels] = foo6(trainImages,trainLabels)

k = length(trainImages(1,1,1,:));

% For each image
for i = 1:length(trainImages(1,1,1,:))
    
    for j = 1:4
        clear augImg
        augImg(:,:,:,j) = trainImages(:,:,:,i);
        for i=1:3

            % Apply DCT to the image
            DCT= dct2(augImg(:,:,i,j));
            d = DCT;

            % Set some pixels to 0
            DCT(randi([0 1], size(DCT,1),size(DCT,2))==0)=0;

            % The first pixel (1,1) can't be modified
            DCT(1,1)=d(1,1);
            
            % Apply agine DCT
            im(:,:,i) = dct2(DCT)
        end

        image=uint8(im);
        trainImages(:,:,:,k+j) = im;
        trainLabels(k+j) = trainLabels(i);

    end
    k = k+j;
end
    
end