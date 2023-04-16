clear all
warning off

% Chose the dataset to use
datas=29;

% load the dataset
load(strcat('DatasColor_',int2str(datas)),'DATA');
NF=size(DATA{3},1); % Number of folds
DIV=DATA{3};% Train test division
DIM1=DATA{4};% Training pattern number
DIM2=DATA{5};% Pattern number
yE=DATA{2};% Patterns label
NX=DATA{1};% Images

% Load pre-trained model
net = alexnet;  % Load AlexNet
siz=[227 227];

% Heavier model that can be used
% net = vgg16;
% siz=[224 224];

% Neural networks parameters
miniBatchSize = 30;
learningRate = 1e-4;
metodoOptim='sgdm';
options = trainingOptions(metodoOptim,...
    'MiniBatchSize',miniBatchSize,...
    'MaxEpochs',30,...
    'InitialLearnRate',learningRate,...
    'Verbose',false,...
    'Plots','training-progress');
numIterationsPerEpoch = floor(DIM1/miniBatchSize);


for fold=1:NF
    close all force
    
    trainPattern=(DIV(fold,1:DIM1));
    testPattern=(DIV(fold,DIM1+1:DIM2));
    y=yE(DIV(fold,1:DIM1));% Training label
    yy=yE(DIV(fold,DIM1+1:DIM2));% Test label
    numClasses = max(y);% Number of classes
    
    % Create training set
    clear nome trainingImages
    for pattern=1:DIM1
        IM=NX{DIV(fold,pattern)};% Singol data image
        
        IM=imresize(IM,[siz(1) siz(2)]);% Resizing the images for CNN compatibility
        if size(IM,3)==1
            IM(:,:,2)=IM;
            IM(:,:,3)=IM(:,:,1);
        end
        trainingImages(:,:,:,pattern)=IM;
    end
    imageSize=size(IM);
    
    
    % set function_to_use to chose the augumenter to use
    % (trainingImages,y) will have the augumented patterns and lables
    
    function_to_use = "foo6"

    switch function_to_use
        case "foo6"
            [trainingImages,y]= foo6(trainingImages,y)
        case "foo4"
            [trainingImages,y]= foo4(trainingImages,y)
        case "method3dct"
            [trainingImages,y]= method3dct(trainingImages,y)
        case "method2dct"
            [trainingImages,y]= method2dct(trainingImages,y)
        case "method1dct"
            [trainingImages,y]= method1dct(trainingImages,y)
        case "myImageDataAugmenter"
            [trainingImages,y]= myImageDataAugmenter(trainingImages,y)
    end


    % Creation of more patterns using standard techniques
    imageAugmenter = imageDataAugmenter( ...
        'RandXReflection',true, ...
        'RandXScale',[1 2], ...
        'RandYReflection',true, ...
        'RandYScale',[1 2],...
        'RandRotation',[-10 10],...
        'RandXTranslation',[0 5],...
        'RasndYTranslation', [0 5]);
    trainingImages = augmentedImageSource(imageSize,trainingImages,categorical(y'),'DataAugmentation',imageAugmenter);
    
    % Tuning of the model
    % The last three layers of the pretrained network net are configured for 1000 classes.
    % These three layers must be fine-tuned for the new classification problem. Extract all layers, except the last three, from the pretrained network.
    layersTransfer = net.Layers(1:end-3);
    layers = [
        layersTransfer
        fullyConnectedLayer(numClasses,'WeightLearnRateFactor',20,'BiasLearnRateFactor',20)
        softmaxLayer
        classificationLayer];
    netTransfer = trainNetwork(trainingImages,layers,options);
    
    % Create test set
    clear nome test testImages
    for pattern=ceil(DIM1)+1:ceil(DIM2)
        IM=NX{DIV(fold,pattern)};%singola data immagine
        
        IM=imresize(IM,[siz(1) siz(2)]);
        if size(IM,3)==1
            IM(:,:,2)=IM;
            IM(:,:,3)=IM(:,:,1);
        end
        testImages(:,:,:,pattern-ceil(DIM1))=uint8(IM);
    end
    
    % Classify test patterns
    [outclass, score{fold}] =  classify(netTransfer,testImages);
    
    % Compute accuracy
    [a,b]=max(score{fold}');
    ACC(fold)=sum(b==yy)./length(yy);
    
end