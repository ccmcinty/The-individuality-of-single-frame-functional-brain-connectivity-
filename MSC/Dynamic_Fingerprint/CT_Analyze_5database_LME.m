
close all
clear all
clc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Atlas = 'Schaefer100';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subs = {'MSC01','MSC02','MSC03','MSC04','MSC05','MSC06','MSC07','MSC08','MSC09','MSC10'};
sess = {'ses-01','ses-02','ses-03','ses-04','ses-05','ses-06','ses-07','ses-08','ses-09','ses-10'};

Correct = zeros(length(subs)*length(sess)*nchoosek(9,5),1);
SubID = Correct;
index = 0;
for sub = 1 : length(subs)
    for ses = 1 : length(sess)
        data = load(['CompTensors_' Atlas '/' subs{sub} '_' sess{ses} '.mat']);
        CT = data.CompTensor;
        %remove current session from CT (only comparing to the others)
        sessNums = 1:10;
        remCurrSes = find(strcmp(sess,sess{ses}));
        sessNums(remCurrSes) = [];

        %get possible target session combinations (9 choose 5)
        combos = nchoosek(sessNums,5);

        osess = sess;
        osess(ses) = [];

        %make CompTensorCombos to store the max R value between each TR and
        %the 5 referent scans of different combos
        for combo = 1 : height(combos)
            index = index + 1;
            SubID(index) = sub;
            CTcombo = CT(:,:,combos(combo,:));

            for tr = 1 : size(CT,1)
                CTmat = squeeze(CTcombo(tr,:,:));
                [SubMatch,~] = find(CTmat==max(CTmat(:)));

                if SubMatch == sub
                    Correct(index) = Correct(index) + 1;
                end
            end
        end
    end
end

T = table(SubID,Correct);
lme = fitlme(T,'Correct~1+(1|SubID)');
lme
[CI] = coefCI(lme,'Alpha',0.001);

fprintf(['\n\n\n99.9%% Confidence Interval: [' num2str(CI) ']']);


Correct = Correct / 803*100;
Mean = mean(Correct);
SD = std(Correct);
fprintf(['\n\n\nMean = ' num2str(round(Mean,1)) ' | SD = ' num2str(round(SD,1))]);