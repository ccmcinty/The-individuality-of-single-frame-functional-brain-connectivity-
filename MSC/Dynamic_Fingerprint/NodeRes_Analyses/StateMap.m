%Save out the PCC (full connectivity) and V1 tensors for each scan
close all
clear all
clc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
atlas = 'Schaefer1000';
addpath(['../../../LEiDA']);
tsBaseDir = ['../../Time_Series/' atlas '/REST/'];
outDir = ['StateMaps_' atlas '/'];

subs = {'MSC01','MSC02','MSC03','MSC04','MSC05','MSC06','MSC07','MSC08','MSC09','MSC10'};
sess = {'ses-01','ses-02','ses-03','ses-04','ses-05','ses-06','ses-07','ses-08','ses-09','ses-10'};

inputs = wfu_find_files('perm',['Schaefer1000_100parcel_selections']);
inputs = inputs';

for sub = 1 : length(subs)
    for ses = 1 : length(sess)
        for perm = 1 : height(inputs)
            fprintf(['Sub ' num2str(sub) ' | Session ' num2str(ses) ' | Perm ' num2str(perm) '...']);
            tic
            X = load(inputs{perm});
            nodes = X.KeepVector;

            ts = load([tsBaseDir subs{sub} '/' sess{ses} '/ts.csv']);
            ts = ts(nodes,:);
            V1 = LEiDA_func_noImg(ts);
            V1 = V1(6:808,:);
          
            outDir = ['StateMaps/perm' num2str(perm+99)];
            wfu_mkdir(outDir);

            outFN =  [subs{sub} '_' sess{ses} '.mat'];
            save([outDir '/' outFN],"V1");
            toc
        end
    end
end