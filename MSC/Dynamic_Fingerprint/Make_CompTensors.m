%Build tensor of maximum R values between each volume of target scan and
%database scans. 
close all
clear all
clc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%edit these parameters
atlas = 'Schaefer100'; %the number here should be 100, 200, 500, or 1000
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
outDir = ['CompTensors_' atlas '/'];

subs = {'MSC01','MSC02','MSC03','MSC04','MSC05','MSC06','MSC07','MSC08','MSC09','MSC10'};
visits = {'ses-01','ses-02','ses-03','ses-04','ses-05','ses-06','ses-07','ses-08','ses-09','ses-10'};

for sub = 1 : length(subs) %this can be made into a parfor loop to speed up this step
    for ses = 1 : length(visits)
        fprintf(['Sub ' num2str(sub) ' | Session ' num2str(ses) '...\n']);
        tic

        x = load(['StateMaps_' atlas '/' subs{sub} '_' visits{ses} '.mat']);
        V1 = x.V1;

        RMat = zeros(height(V1),length(subs),length(visits));

        for tr = 1 : height(V1)
            for osub = 1 : length(subs)
                for ovis = 1 : length(visits)
                    database = load(['StateMaps_' atlas '/' ...
                        '' subs{osub} '_' visits{ovis} '.mat']);
                    tV1 = database.V1;
                    rvec = zeros(1,height(tV1)); 
                    for oTR = 1 : height(tV1)
                        rvec(oTR) = abs(corr(V1(tr,:)',tV1(oTR,:)'));
                    end
                    RMat(tr,osub,ovis) = max(rvec);
                end
            end
        end

        outMatFN = [outDir '/' subs{sub} '_' visits{ses} '.mat'];
        parFor_save_compTensor(outMatFN,RMat);
        
        toc
    end
end