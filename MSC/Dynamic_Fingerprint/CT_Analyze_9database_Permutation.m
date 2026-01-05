%Do x random permutations of fingerprinting where database scans get a
%random label without replacement
close all
clear all
clc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
numPerms = 1000;
Atlas = 'Schaefer100';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subs = {'MSC01','MSC02','MSC03','MSC04','MSC05','MSC06','MSC07','MSC08','MSC09','MSC10'};
sess = {'ses-01','ses-02','ses-03','ses-04','ses-05','ses-06','ses-07','ses-08','ses-09','ses-10'};

perm_singleTR_accuracy = zeros(numPerms,1);
perm_fullScan_accuracy = zeros(numPerms,1);
for perm = 1 : numPerms
    fprintf(['\nPermutation ' num2str(perm)]);
    %get permutation sequence
    labelSwap = randsample(length(subs),length(subs),0);

    TR_Accuracy = zeros(length(subs),length(sess));
    Correct_ID = zeros(size(TR_Accuracy));
    tiedSubCount = 0;
    correctSubTiedCount = 0;
    for sub = 1 : length(subs)
        for ses = 1 : length(sess)
            data = load(['CompTensors_' Atlas '/' subs{sub} '_' sess{ses} '.mat']);
            CT = data.CompTensor;

            %remove current session from CT (only comparing to the others)
            CT(:,:,ses) = [];

            %mix subject labels of CT to match current permutation
            CT = CT(:,labelSwap,:);

            CountVec = zeros(length(subs),1);
            for tr = 1 : size(CT,1)
                CTmat = squeeze(CT(tr,:,:));
                [SubMatch,~] = find(CTmat==max(CTmat(:)));

                CountVec(SubMatch) = CountVec(SubMatch) + 1;

            end

            TR_accuracy = round([CountVec(sub) / 803 * 100],1);
            TR_Accuracy(sub,ses) = TR_accuracy;

            IDed_sub = find(CountVec == max(CountVec));
            if length(IDed_sub) == 1
                if IDed_sub == sub
                    Correct_ID(sub,ses) = 1;
                else
                    % fprintf('ID failed\n\n');
                end
            else
                tiedSubCount = tiedSubCount+1;
                if ~isempty(find(IDed_sub,sub))
                    correctSubTiedCount = correctSubTiedCount + 1;
                end
            end

        end
    end

    Mean_TR_Accuracy = mean(TR_Accuracy(:));
    fprintf(['\nMean TR Accuracy = ' num2str(round(Mean_TR_Accuracy,1)) '%%\n']);

    ID_Rate = mean(100 * Correct_ID(:));
    fprintf(['All-TR ID Rate = ' num2str(round(ID_Rate,1)) '%%\n']);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    perm_singleTR_accuracy(perm) = Mean_TR_Accuracy;
    perm_fullScan_accuracy(perm) = ID_Rate;

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subs = {'MSC01','MSC02','MSC03','MSC04','MSC05','MSC06','MSC07','MSC08','MSC09','MSC10'};
sess = {'ses-01','ses-02','ses-03','ses-04','ses-05','ses-06','ses-07','ses-08','ses-09','ses-10'};

TR_Accuracy = zeros(length(subs),length(sess));
Correct_ID = zeros(size(TR_Accuracy));
tiedSubCount = 0;
correctSubTiedCount = 0;
for sub = 1 : length(subs)
    for ses = 1 : length(sess)
        data = load(['CompTensors_' Atlas '/' subs{sub} '_' sess{ses} '.mat']);
        CT = data.CompTensor;

        %remove current session from CT (only comparing to the others)
        CT(:,:,ses) = [];

        CountVec = zeros(length(subs),1);
        for tr = 1 : size(CT,1)
            CTmat = squeeze(CT(tr,:,:));
            [SubMatch,~] = find(CTmat==max(CTmat(:)));

            CountVec(SubMatch) = CountVec(SubMatch) + 1;

        end

        TR_accuracy = round([CountVec(sub) / 803 * 100],1);
        TR_Accuracy(sub,ses) = TR_accuracy;
        fprintf([subs{sub} ' ' sess{ses} ' TR accuracy = ' num2str(TR_accuracy) '%%\n']);

        IDed_sub = find(CountVec == max(CountVec));
        if length(IDed_sub) == 1
            if IDed_sub == sub

                fprintf('Correct ID\n\n');
                Correct_ID(sub,ses) = 1;

            else
                fprintf('ID failed\n\n');

            end

        else 
            tiedSubCount = tiedSubCount+1;
            if ~isempty(find(IDed_sub,sub))
                correctSubTiedCount = correctSubTiedCount + 1;
            end
        end

    end
end
fprintf(['--- Actual Result ---\n']);
Mean_TR_Accuracy = mean(TR_Accuracy(:));
fprintf(['Mean TR Accuracy = ' num2str(round(Mean_TR_Accuracy,1)) '%%\n']);

ID_Rate = mean(100 * Correct_ID(:));
fprintf(['All-TR ID Rate = ' num2str(round(ID_Rate,1)) '%%\n']);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

f = figure; hold on;
f.Position = [100 100 700 700];
h1 = hist(perm_singleTR_accuracy,1:1:100);
plot(h1,'k','LineWidth',3);
line([Mean_TR_Accuracy Mean_TR_Accuracy],[min(h1) max(h1)],'LineWidth',3,'Color','r');
pval1 = length(find(perm_singleTR_accuracy >= Mean_TR_Accuracy))/numPerms;
title([Atlas ' TR | p = ' num2str(pval1)]);
ylabel('# of Permutations');
xlabel('Accuracy (%)');

f = figure; hold on;
f.Position = [1000 100 700 700];
h2 = hist(perm_fullScan_accuracy,1:1:100);
plot(h2,'k','LineWidth',3);
line([ID_Rate ID_Rate],[min(h2) max(h2)],'Color','r','LineWidth',3);
pval2 = length(find(perm_fullScan_accuracy >= ID_Rate))/numPerms;
title([Atlas ' Full | p = ' num2str(pval2)]);
ylabel('# of Permutations');
xlabel('Accuracy (%)');

fprintf(['\n\n\n' Atlas]);

save(['Permutation_Results/' Atlas '_9database.mat'],"pval1","pval2","h1","h2","Mean_TR_Accuracy","ID_Rate","perm_singleTR_accuracy","perm_fullScan_accuracy");






