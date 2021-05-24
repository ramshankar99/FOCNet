function [imdb] = generatepatches

addpath('utilities');
batchSize     = 8;        % batch size

folder = 'Train_Set';  
label_folder = 'Train_Set_Label';

nchannel      = 1;           % number of channels
patchsize     = 160;

ext           =  {'*.jpg','*.png','*.bmp','*.jpeg'};
filepaths     =  [];
label_filepaths = [];

for i = 1 : length(ext)
    filepaths = cat(1,filepaths, dir(fullfile(folder, ext{i})));
end


for i = 1 : length(ext)
    label_filepaths = cat(1,label_filepaths, dir(fullfile(label_folder, ext{i})));
end

% count the number of extracted patches
for i = 1 : length(filepaths)
    
    %image = imread(fullfile(folder,filepaths(i).name)); % uint8
    %label = imread(fullfile(label_folder,label_filepaths(i).name)); % uint8
    %[~, name, exte] = fileparts(filepaths(i).name);
    
    if mod(i,100)==0
        disp([i,length(filepaths)]);
    end
end

numPatches  = 999;
%diffPatches = numPatches - count;
disp([int2str(numPatches),' = ',int2str(numPatches/batchSize),' X ', int2str(batchSize)]);


count = 0;
imdb.images = zeros(patchsize, patchsize, nchannel, numPatches,'single');
imdb.labels = zeros(patchsize, patchsize, nchannel, numPatches,'single');

for i = 1 : length(filepaths)
    
    image = imread(fullfile(folder,filepaths(i).name)); % uint8
    label = imread(fullfile(label_folder,label_filepaths(i).name));
    %[~, name, exte] = fileparts(filepaths(i).name);
    
    image = rgb2gray(image);
    label = im2gray(label);
    
    count = count+1;
    imdb.images(:, :, :, count) = image(120:120+patchsize-1,55:55+patchsize-1,:);
    imdb.labels(:, :, :, count) = label(120:120+patchsize-1,55:55+patchsize-1,:);
    if mod(i,100)==0
        disp([i,length(filepaths)]);
    end
end

imdb.set    = uint8(ones(1,size(imdb.labels,4)));

