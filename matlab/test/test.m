clear
addpath('../');
caffe.reset_all()
% Solver = modelconfig(model_path);
Solver.Solver_ = caffe.Solver('./model/solver.prototxt');
Solver.Solver_.net.copy_from('./model/LRNN_iter_200000.caffemodel');

Base = '/data/SOTIS2';
BaseOutput = sprintf('/workdir/results');
NFrames=50;
Dataset = 'EurasianCitiesBase-Part1';
Input = sprintf('%s/Stabilized/%s/NFrames%d', Base, Dataset, NFrames);
Output = sprintf('%s%s/Stabilized/%s/NFrames%d', BaseOutput, Base, Dataset, NFrames);

name = Input;
MethodFolder = dir(name);        
for N = 3:length(MethodFolder)
    name = sprintf('%s/%s/', Input, MethodFolder(N).name); 
    ImageFolder = dir(name);  
    for I = ceil(length(ImageFolder)*0.75):length(ImageFolder)
        name = sprintf('%s/%s/%s', Input, MethodFolder(N).name, ImageFolder(I).name);
        DistanceFolder = dir(name);
        for L = 3:length(DistanceFolder)
            name = sprintf('%s/%s/%s/%s/*.png', Input, MethodFolder(N).name, ImageFolder(I).name, DistanceFolder(L).name);
            Images = dir(name);
            for S = 1:length(Images)
                name = sprintf('%s/%s/%s/%s/%s', Input, MethodFolder(N).name, ImageFolder(I).name, DistanceFolder(L).name,Images(S).name);
                blur = imread(name);
                if length(size(blur)) > 2
                    blur = rgb2gray(blur);
                end
                blur = cat(3, blur, blur, blur);
                blur = single(blur)/255;
                clean = Solver.Solver_.net.forward({blur});
                clean = clean{1};
                name = sprintf('%s/%s/%s/%s/%s', Output, MethodFolder(N).name, ImageFolder(I).name, DistanceFolder(L).name);
                if not(exist(name, 'dir'))
                    mkdir(name);
                end
                name = sprintf('%s%s', name, Images(S).name);
                imwrite(clean, name);
                disp(sprintf('Done: %s', name));
            end
        end
     end
end
