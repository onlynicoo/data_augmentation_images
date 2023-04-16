% Input of the function 
function[image] = method2dct(im)
[y,x,z]=size(im);

% Apply standard deviation for every level
sigma2 = std(double(im));
sigma1 = std(sigma2);
sigma = std(sigma1)/2;

for channel=1:z
   
    % Apply DCT
    DCTim = dct2(im(:,:,channel));
    for riga = 1:y
        for colonna = 1:x
            
            %DTC(1,1) unmodified
            if riga==1 && colonna==1
                %nothing
            else
            % Calculate random number between (-0.5,0.5)
            random_z = rand();
            while random_z > 1/2
                random_z = rand();
            end
            prob = rand();
            if prob > 1/2
                random_z = random_z * 1;
            else
                random_z = random_z * -1;
            end
            % Modify DCT image
            DCTim(riga, colonna)= DCTim(riga, colonna) + sigma*random_z;
            end
        end
     end
    % Inverse DCT
    image(:,:,channel) = idct2(DCTim);
end
    image = uint8(image);
end
