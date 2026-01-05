%Build tensor of maximum R values between each TR of referent scan and
%every other scan. Get MaxR = [TRs,subs,visits]
close all
clear all
clc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subs = {'MSC01','MSC02','MSC03','MSC04','MSC05','MSC06','MSC07','MSC08','MSC09','MSC10'};
visits = {'ses-01','ses-02','ses-03','ses-04','ses-05','ses-06','ses-07','ses-08','ses-09','ses-10'};
tasks = {'Faces','Words','REST'};

% parpool(10);
parfor sub = 1 : length(subs)
    for ses = 1 : length(visits)
        for task = 1 : length(tasks)
            fprintf(['Sub ' num2str(sub) ' | Session ' num2str(ses) ' | ' tasks{task} '...\n']);

            x = load(['StateMaps_' tasks{task} '/' subs{sub} '_' visits{ses} '.mat']);
            V1 = x.V1;

            RMat = zeros(height(V1),length(subs),length(visits),length(tasks));

            for tr = 1 : height(V1)
                for osub = 1 : length(subs)
                    for ovis = 1 : length(visits)
                        for otask = 1 : length(tasks)
                            target = load(['StateMaps_' tasks{otask} '/' ...
                                '' subs{osub} '_' visits{ovis} '.mat']);
                            tV1 = target.V1;
                            rvec = zeros(1,height(tV1)); %make vector of r value between referent TR and all TRs for current target scan
                            for oTR = 1 : height(tV1)
                                rvec(oTR) = abs(corr(V1(tr,:)',tV1(oTR,:)'));
                            end
                            RMat(tr,osub,ovis,otask) = max(rvec);
                        end
                    end
                end
            end
            RMat(:,:,ses,:) = []; %remove the current session from comparison tensor
            RMat = squeeze(max(RMat,[],3)); %Make RMat [tTR x dSub x dTask] (ignores session ID)
            outMatFN = ['CompTensors/' ...
                '' subs{sub} '_' visits{ses} '_' tasks{task} '.mat'];
            parFor_save_compTensor(outMatFN,RMat);
        end
    end
end