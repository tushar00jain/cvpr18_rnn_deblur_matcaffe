clear
addpath('../');
caffe.reset_all()
% Solver = modelconfig(model_path);
Solver.Solver_ = caffe.Solver('./model/solver.prototxt');
Solver.Solver_.net.copy_from('./model/LRNN_iter_200000.caffemodel');

Base = '/data/SOTIS';
BaseOutput = sprintf('/workdir/results');
NFrames=50;
Method = 'NLTV-LK'
Dataset = 'EurasianCitiesBase';
Input = sprintf('%s/Stabilized/%s/NFrames%d/%s', Base, Dataset, NFrames, Method);
Output = sprintf('%s%s/Stabilized/%s/NFrames%d/%s', BaseOutput, Base, Dataset, NFrames, Method);

name = Input;
ImageFolder = dir(name);  
for I = ceil(3 + (length(ImageFolder) - 3) * 0.75):length(ImageFolder)
    name = sprintf('%s/%s/%s', Input, ImageFolder(I).name);
    DistanceFolder = dir(name);
    for L = 3:length(DistanceFolder)
        name = sprintf('%s/%s/%s/*.png', Input, ImageFolder(I).name, DistanceFolder(L).name);
        Images = dir(name);
        for S = 1:length(Images)
            name = sprintf('%s/%s/%s/%s', Input, ImageFolder(I).name, DistanceFolder(L).name, Images(S).name);
            blur = imread(name);
            if length(size(blur)) > 2
                blur = rgb2gray(blur);
            end
            blur = cat(3, blur, blur, blur);
            blur = single(blur)/255;
            clean = Solver.Solver_.net.forward({blur});
            clean = clean{1};
            name = sprintf('%s/%s/%s/%s', Output, ImageFolder(I).name, DistanceFolder(L).name);
            if not(exist(name, 'dir'))
                mkdir(name);
            end
            name = sprintf('%s%s', name, Images(S).name);
            imwrite(clean, name);
            disp(sprintf('Done: %s', name));
        end
    end
end
