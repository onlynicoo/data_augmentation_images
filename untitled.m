clear all
warning off

%scegli valore di datas in base a quale dataset vi serve
datas=29;



a = load(strcat('DatasColor_',int2str(datas)),'DATA');
for i = 1:10
    imshow(a.DATA{1, 1}{1, 250})
end
NF=size(DATA{3},1); %number of folds
DIV=DATA{3};%divisione fra training e test set
DIM1=DATA{4};%numero di training pattern
DIM2=DATA{5};%numero di pattern
yE=DATA{2};%label dei patterns
NX=DATA{1};%immagini
