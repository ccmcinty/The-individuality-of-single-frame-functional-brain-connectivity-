%Build tensor of maximum R values between each TR of referent scan and
%every other scan. Get MaxR = [TRs,subs,visits]
close all
clear all
clc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
permDirs = wfu_find_dirs('perm',['StateMaps']);
permDirs = permDirs';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subs = {'MSC01','MSC02','MSC03','MSC04','MSC05','MSC06','MSC07','MSC08','MSC09','MSC10'};
visits = {'ses-01','ses-02','ses-03','ses-04','ses-05','ses-06','ses-07','ses-08','ses-09','ses-10'};

parpool(10);
for perm = 25 : length(permDirs)
    parfor sub = 1 : length(subs)
        for ses = 1 : length(visits)
            fprintf(['Sub ' num2str(sub) ' | Session ' num2str(ses) '...\n']);

            x = load([permDirs{perm} '/' subs{sub} '_' visits{ses} '_tensor.mat']);
            V1 = x.V1;

            RMat = zeros(height(V1),length(subs),length(visits));

            for tr = 1 : height(V1)
                for osub = 1 : length(subs)
                    for ovis = 1 : length(visits)
                        target = load([permDirs{perm} '/' subs{osub} '_' visits{ovis} '_tensor.mat']);
                        tV1 = target.V1;
                        rvec = zeros(1,height(tV1)); %make vector of r value between referent TR and all TRs for current target scan
                        for oTR = 1 : height(tV1)
                            rvec(oTR) = abs(corr(V1(tr,:)',tV1(oTR,:)'));
                        end
                        RMat(tr,osub,ovis) = max(rvec);
                    end
                end
            end
            outDir = ['CompTensors/' ...
                'perm' num2str(perm+99) '/']
            wfu_mkdir(outDir);
            outMatFN = [outDir '/' subs{sub} '_' visits{ses} '' ...
                '_CompTensor.mat'];
            parFor_save_compTensor(outMatFN,RMat);

        end
    end
end