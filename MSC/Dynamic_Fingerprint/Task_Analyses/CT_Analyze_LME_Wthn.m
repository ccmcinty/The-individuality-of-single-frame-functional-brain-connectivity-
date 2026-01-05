% Get counts of number of accurate task identifications and put into linear
% mixed effects model to see if performance confidence interval exceeds
% chance (33% accuracy)

close all
clear all
clc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Task = 3; %Faces - 1, Words - 2, REST - 3
tasks = {'Faces','Words','REST'};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subs = {'MSC01','MSC02','MSC03','MSC04','MSC05','MSC06','MSC07','MSC08','MSC09','MSC10'};
sess = {'ses-01','ses-02','ses-03','ses-04','ses-05','ses-06','ses-07','ses-08','ses-09','ses-10'};

Correct = zeros(length(subs)*length(sess),1);
SubID = Correct;
index = 0;
for sub = 1 : length(subs)
    for ses = 1 : length(sess)
        %add to index
        index = index + 1;

        data = load(['CompTensors/' subs{sub} '_' sess{ses} '_' tasks{Task} '.mat']);
        CT = data.CompTensor;

        %Look only within subject
        CT = squeeze(CT(:,sub,:));

        for tr = 1 : size(CT,1)
            CTvec = squeeze(CT(tr,:));
            [~,TaskMatch] = find(CT==max(CTvec(:)));

            if TaskMatch == Task %if the correct task is identified
                Correct(index) = Correct(index) + 1;
            end
        end
        
        SubID(index,1) = sub;

    end
end

T = table(SubID,Correct);
lme = fitlme(T,'Correct~1+(1|SubID)');
lme
[CI] = coefCI(lme,'Alpha',0.001);

fprintf(['\n\n\n99.9%% Confidence Interval: [' num2str(CI) ']']);


Correct = Correct / 106*100;
Mean = mean(Correct);
SD = std(Correct);
fprintf(['\n\n\nMean = ' num2str(round(Mean,1)) ' | SD = ' num2str(round(SD,1))]);