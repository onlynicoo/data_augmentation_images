function [trainImages,trainLabels] = foo4(trainImages,trainLabels)

k = length(trainImages(1,1,1,:)); 

for i = 1:length(trainImages(1,1,1,:))
    
    for j = 1:3
        clear augImg
        augImg(:,:,:,j) = trainImages(:,:,:,i);
        
        % Specchia
        if randi(2) == 1
            augImg(:,:,:,j) = flipdim(augImg(:,:,:,j),2); % horizontal flip
        end
        if randi(2) == 1
            augImg(:,:,:,j) = flipdim(augImg(:,:,:,j),1); % vertical flip
        end
        
        % Ruota
        augImg(:,:,:,j) = imrotate(augImg(:,:,:,j),90*randi([0,4])); % angle in degrees
      
        % Salt & Pepper noise
        augImg(:,:,:,j) = imnoise(augImg(:,:,:,j), 'salt & pepper', 0.005);
        
        % Saturation, Contrast, Brightness
        if randi(2) == 1
            augImg(:,:,:,j) = jitterColorHSV(augImg(:,:,:,j),'Contrast',0.8,'Saturation',0.2,'Brightness',0.3);
        end
        
        % Aggiungo le imm al training set
        trainImages(:,:,:,k+j) = augImg(:,:,:,j);
        trainLabels(k+j) = trainLabels(i); 
    end
    k = k + j;
end

end
