function [image]=method1dct(im)
for i=1:3
    %apply DCT to every dimension of the image
    DCT= dct2(im(:,:,i));
    d=DCT;
    %set some pixel to 0 
    DCT(randi([0 1], size(DCT,1),size(DCT,2))==0)=0;
    %leave unmodified pixel in position (1,1)
    DCT(1,1)=d(1,1);
    %apply inverse DCT
    %image(:,:,i)= idct2(DCT);
    DCT = dct2(DCT)
end
image=uint8(image);
    
end