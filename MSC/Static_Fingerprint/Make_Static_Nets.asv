%Save out the correlation matrix from each participant's MSR TS
close all
clear all
clc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subs = {'MSC01','MSC02','MSC03','MSC04','MSC05','MSC06','MSC07','MSC08','MSC09','MSC10'};
visits = {'ses-01','ses-02','ses-03','ses-04','ses-05','ses-06','ses-07','ses-08','ses-09','ses-10'};

for sub = 1 : length(subs)
    for vis = 1 : length(visits)
        ts = load(['../Time_Series/Schaefer100/REST/' subs{sub} '/' ...
            visits{vis} '/ts.csv']);
        aij = corr(ts');
        aij = mat.aij;

        %%if Schaefer 1000 atlas is being used
        % aij(227,:) = [];
        % aij(:,227) = [];

        save(['Schaefer100_CorrMats/' ...
             subs{sub} '_' visits{vis} '.mat']);
    end
end
