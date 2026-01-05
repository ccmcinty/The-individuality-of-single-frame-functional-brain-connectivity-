%Make a tensor for each visit for each subject relating the current network
%to all other visits/subjects... a [SUBJECT x VISIT] matrix of r values
close all
clear all
clc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
atlas = 'Schaefer1000'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subs = {'MSC01','MSC02','MSC03','MSC04','MSC05','MSC06','MSC07','MSC08','MSC09','MSC10'};
visits = {'ses-01','ses-02','ses-03','ses-04','ses-05','ses-06','ses-07','ses-08','ses-09','ses-10'};

f = figure; f.Position = [100 300 700 700];
for sub = 1 : length(subs)
    for vis = 1 : length(visits)
        Rmat = zeros(length(subs),length(visits));
        tarAij = load([atlas '_CorrMats/' subs{sub} '_' visits{vis} '.mat']);
        tarAij = tarAij.aij;

        for osub = 1 : length(subs)
            for ovis = 1 : length(visits)
                baseAij = load([atlas '_CorrMats/' subs{osub} '_' visits{ovis} '.mat']);
                baseAij = baseAij.aij;
                Rmat(osub,ovis) = corr(tarAij(:),baseAij(:));
            end
        end
        imagesc(Rmat); colormap jet; clim([0 1]); colorbar;
        title([subs{sub} ' | ' visits{vis}]);
        pause(0.1)
        writematrix(Rmat,[atlas '_CompTensors/' subs{sub} '_' visits{vis} '.csv']);
    end
end