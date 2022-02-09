function [batch, gt] = Gen_training_deblur2( Solver)

batch = single(zeros(Solver.patchsize,Solver.patchsize,3,Solver.batchsize));
gt = single(zeros(Solver.patchsize,Solver.patchsize,3,Solver.batchsize));
rng('shuffle');
idpool = randperm(Solver.data.train_num);
for count = 1:Solver.batchsize
    idx = idpool(count);
    clean = imread(Solver.data.trainlst{idx}.label);
    if length(size(clean)) > 2
        clean = rgb2gray(clean);
    end
    clean = cat(3, clean, clean, clean);
    clean = single(clean)/255;

    blur = imread(Solver.data.trainlst{idx}.input);
    if length(size(blur)) > 2
        blur = rgb2gray(blur);
    end
    blur = cat(3, blur, blur, blur);
    blur = single(blur)/255;

%     blur_gray = rgb2gray(blur);
%     [dx,dy] = gradient(blur_gray);
%     batch(:,:,:,count) = cat(3, blur, dx, dy);
    batch(:,:,:,count) = blur;
    gt(:,:,:,count) = clean;
end
end
