%Save out the PCC (full connectivity) and V1 tensors for each scan
close all
clear all
clc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
task = 'REST';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
addpath(['../../../LEiDA']);
tsBaseDir = ['../../Time_Series/Schaefer1000/' task '/'];
outDir = ['StateMaps_' task '/'];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

subs = {'MSC01','MSC02','MSC03','MSC04','MSC05','MSC06','MSC07','MSC08','MSC09','MSC10'};
sess = {'ses-01','ses-02','ses-03','ses-04','ses-05','ses-06','ses-07','ses-08','ses-09','ses-10'};

for sub = 1 : length(subs)
    for ses = 1 : length(sess)
        fprintf(['Sub ' num2str(sub) ' | Session ' num2str(ses) ' | ' task '...']);
        tic

        ts = load(['../../Time_Series/Schaefer1000/' task '/' subs{sub} ...
            '/' sess{ses} '/ts.csv']);
        ts = ts(:,1:116);
        V1 = LEiDA_func_noImg(ts);
        V1 = V1(6:111,:);

        outFN = ['StateMaps_' task '/' subs{sub} '_' sess{ses} '.mat'];
        save(outFN,"V1");
        toc
    end
end