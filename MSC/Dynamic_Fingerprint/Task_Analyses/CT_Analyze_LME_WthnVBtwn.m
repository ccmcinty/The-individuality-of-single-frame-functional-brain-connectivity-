% Get counts of number of accurate task identifications and put into linear
% mixed effects model to see if performance confidence interval exceeds
% chance (33% accuracy... 35.333 count)

close all
clear all
clc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Task = 3; %Faces - 1, Words - 2, REST - 3
tasks = {'Faces','Words','REST'};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subs = {'MSC01','MSC02','MSC03','MSC04','MSC05','MSC06','MSC07','MSC08','MSC09','MSC10'};
sess = {'ses-01','ses-02','ses-03','ses-04','ses-05','ses-06','ses-07','ses-08','ses-09','ses-10'};

Correct = zeros(length(subs)*length(sess)*2,1);
SubID = Correct;
index = 0;
%within subject part
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
%between subject part
for sub = 1 : length(subs)
    for ses = 1 : length(sess)
        %add to index
        index = index + 1;

        data = load(['CompTensors/' subs{sub} '_' sess{ses} '_' tasks{Task} '.mat']);
        CT = data.CompTensor;

        %Look only within subject
        subNums = 1 : length(subs);
        subNums(sub) = [];
        CT = CT(:,subNums,:);

        for tr = 1 : size(CT,1)
            CTmat = squeeze(CT(tr,:,:));
            [~,TaskMatch] = find(CTmat==max(CTmat(:)));

            if TaskMatch == Task %if the correct task is identified
                Correct(index) = Correct(index) + 1;
            end
        end
        
        SubID(index,1) = sub;

    end
end

wb_marker = ones(200,1);
wb_marker(101:200) = 0;

T = table(SubID,Correct,wb_marker);
lme = fitlme(T,'Correct~wb_marker+(1|SubID)');
lme
alpha = 0.001;
[CI] = coefCI(lme,'Alpha',alpha);

fprintf(['\n\n\n' num2str((1-alpha)*100) '%% Confidence Interval: [' num2str(CI(2,:)) ']']);

