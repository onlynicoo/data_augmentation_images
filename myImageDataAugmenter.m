% Input of the function
function [trainImages,trainLabels] = myImageDataAugmenter(trainImages,trainLabels)

k = length(trainImages(1,1,1,:));
% for image warping:
R = makeresampler({'cubic','nearest'},'replicate');

% For every patterns
for i = 1:length(trainImages(1,1,1,:))
    
    for j = 1:9
        clear augImg
        augImg(:,:,:,j) = trainImages(:,:,:,i);
        
        % Flips
        if randi(2) == 1
            augImg(:,:,:,j) = flipdim(augImg(:,:,:,j),2); % horizontal flip
        end
        if randi(2) == 1
            augImg(:,:,:,j) = flipdim(augImg(:,:,:,j),1); % vertical flip
        end
        
        % Rotation
        augImg(:,:,:,j) = imrotate(augImg(:,:,:,j),90*randi([0,4])); % angle in degrees
        
        % Shear
        tanMaxAngle = 0.0607; % tan(20) = 0.0607
        shearOffset = 6.889; % tan(20)*227/2 = 6.889 with img size [227 227]
        shearCase = randi([-6,6]);
        a = tanMaxAngle*shearCase;
        shearOffset = shearOffset*shearCase;
        if randi(2) == 1
            T = maketform('affine',[1 0 0; a 1 0; 0 0 1]); % horizontal shear
            augImg(:,:,:,j) = imtransform(augImg(:,:,:,j),T,R,'XData',[1+shearOffset 227+shearOffset],'YData',[1 227]);
        else
            T = maketform('affine',[1 a 0; 0 1 0; 0 0 1]); % vertical shear
            augImg(:,:,:,j) = imtransform(augImg(:,:,:,j),T,R,'XData',[1 227],'YData',[1+shearOffset 227+shearOffset]);
        end
        
        % Crops
        if randi(2) == 1
            rect = randomWindow2d([227 227],"Scale",[0.4 1],"DimensionRatio",[1 1; 1 1]);
            helpImg = imcrop(augImg(:,:,:,j),rect);
            augImg(:,:,:,j) = imresize(helpImg,[227 227]);
        end
        
        %% 5) Saturation, Contrast, Brightness
        if randi(2) == 1
            augImg(:,:,:,j) = jitterColorHSV(augImg(:,:,:,j),'Contrast',0.3,'Saturation',0.2,'Brightness',0.3);
        end
        
        %% Add the new image to training set
        trainImages(:,:,:,k+j) = augImg(:,:,:,j);
        trainLabels(k+j) = trainLabels(i);
        
    end
    
    k = k + j;
end

end
