classdef LorenzonAugumentation
    %LORENZONAUGUMENTATION Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Property1
    end
    
    methods
        function [new_imageTraining, y] = LorenzonAugumentation(image_training, y)
            
            
            %{
            s = size(image_training);
            new_imageTraining = zeros(s
            new_imageTraining = image_training;
            
            for tmp_img = 1:size(image_training)
                %create new image
                
                new_imageTraining(end+1) = created_image
            end
            %}
        end
        
        function new_img = sheard(img)
            a = 0.45;
            T = maketform('affine2d', [1 0 0; a 1 0; 0 0 1] );
            background = [rand(255,0) rand(255,0) rand(255,0)]';
            R = makeresampler({'cubic','nearest'},'fill');
            new_img = imwrap(img,T,R,'FillValues',background); 
        end
        
        function new_img = flip(img)
            a = rand(4,1);
            if a == 1 %# horizontal flip
                new_img = flip(img ,2);
            elseif a == 2 %# vertical flip
                new_img = flip(img ,1); 
            elseif a == 3
                new_img1 = flip(img ,1);
                new_img = flip(new_img1,2); %# horizontal+vertical flip
            else
                new_img = rot90(fliplr(img),-1); 
            end 
        end
        
        function new_img = rotate(img)
            rng(0,'twister');
            lower_bound = 1;
            upper_bound = 359;
            r = (upper_bound - lower_bound).*rand(1000,1) + lower_bound;
            new_img = imrotate(img,r)';
        end
    end
end