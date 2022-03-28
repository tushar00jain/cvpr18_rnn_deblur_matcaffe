function Solver = dataconfig(Solver)
Solver.patchsize = 256;
Solver.batchsize = 14;
Solver.datapath = '/data/SOTIS';  
Solver.inputfolder = 'Stabilized/EurasianCitiesBase/NFrames50/NLTV-TVL1';
Solver.labelfolder = 'Groundtruth/EurasianCitiesGT';

testlst = {};
trainlst = {};

count = 1;
nameBase = fullfile(Solver.datapath, Solver.inputfolder);
ImageFolder = dir(nameBase);  
for I = 3:floor(length(ImageFolder)*0.75)
    nameImageFolder = fullfile(nameBase, ImageFolder(I).name);
    DistanceFolder = dir(nameImageFolder);
    for L = 3:length(DistanceFolder)
        nameDistanceFolder = fullfile(nameImageFolder, DistanceFolder(L).name);
        Images = dir(fullfile(nameDistanceFolder, '*.png'));
        for S = 1:length(Images)
            trainlst{count}.input = fullfile(nameDistanceFolder, Images(S).name);
            trainlst{count}.label = fullfile(Solver.datapath, Solver.labelfolder, [ImageFolder(I).name '.png']);

            count = count+1;
        end
    end
end

data.trainlst = trainlst;
data.train_num = length(trainlst);
data.testlst = testlst;
data.test_num = length(testlst);


fprintf('saving data structure ...\n');
save(fullfile('./data', 'data.mat'), 'data');

Solver.data = data;
fprintf('Done with data config, obtain %d traning images.\n',Solver.data.train_num);
end
