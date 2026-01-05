%This script calculates the leading eigenvector at each frame of each scan.
%This is represented in a TxN matrix and saved out to 'StateMaps_*atlas*
close all
clear all
clc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%edit these parameters
atlas = 'Schaefer100'; %the number here should be 100, 200, 500, or 1000
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
addpath(['../../LEiDA']);
tsBaseDir = ['../Time_Series/' atlas '/REST/'];
outDir = ['StateMaps_' atlas '/'];

subs = {'MSC01','MSC02','MSC03','MSC04','MSC05','MSC06','MSC07','MSC08','MSC09','MSC10'};
sess = {'ses-01','ses-02','ses-03','ses-04','ses-05','ses-06','ses-07','ses-08','ses-09','ses-10'};

for sub = 1 : length(subs)
    for ses = 1 : length(sess)
        fprintf(['Sub ' num2str(sub) ' | Session ' num2str(ses) '...']);
        tic
        
        ts = load([tsBaseDir subs{sub} '/' sess{ses} '/ts.csv']);
        V1 = LEiDA_func_noImg(ts);
        V1 = V1(6:808,:);

        outFN = [outDir subs{sub} '_' sess{ses} '.mat'];
        save(outFN,"V1");
        toc
    end
end
