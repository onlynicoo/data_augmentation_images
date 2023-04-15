function[image] = method3dct(im,samples)
%apply DCT to every dimension of the image
for i=1:3
    DCT = dct2(im(:,:,i));
    for j=1:5
        %take every image from samples and apply DCT to every of them
        sample=samples(:,:,:,j);
        sampleDCT = dct2(sample(:,:,i));
        [x,y] = size(DCT);
        %cycle on every row and every column of original image
        for r=1:x
            for c=1:y
                %take random coefficient, if it is higher than 0.95, set
                %the pixel in position (r,c) to the corresponding pixel in
                %position (r,c) of the sample
                coeff = rand();
                if coeff>=0.95
                    DCT(r,c)=sampleDCT(r,c);
                end
            end
        end
    end
    %inverse DCT
    image(:,:,i) = idct2(DCT);
end
image=uint8(image);                 
                

end

