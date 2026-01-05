%Builds Count Mats using Comp Tensors rather than calculating r values many
%times(as with first versions of PhaseMap2)

% close all
clear all
clc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
perms = 100:199;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subs = {'MSC01','MSC02','MSC03','MSC04','MSC05','MSC06','MSC07','MSC08','MSC09','MSC10'};
sess = {'ses-01','ses-02','ses-03','ses-04','ses-05','ses-06','ses-07','ses-08','ses-09','ses-10'};

Correct = zeros(length(subs)*length(sess) * 102,1);
SubID = Correct;
Atlas = SubID;
index = 0;
%Regular Schaefer 1000
fprintf(['\nSchaefer 1000 Atlas...']);
for sub = 1 : length(subs)
    for ses = 1 : length(sess)
        %add to index
        index = index + 1;

        data = load(['../Dynamic_Fingerprinting/CompTensors_Schaefer1000/' ...
            '' subs{sub} '_' sess{ses} '.mat']);
        CT = data.CompTensor;

        %remove current session from CT (only comparing to the others)
        CT(:,:,ses) = [];

        for tr = 1 : size(CT,1)
            CTmat = squeeze(CT(tr,:,:));
            [SubMatch,~] = find(CTmat==max(CTmat(:)));

            if SubMatch == sub %if the correct task is identified
                Correct(index) = Correct(index) + 1;
            end
        end

        SubID(index,1) = sub;
        Atlas(index,1) = 999;
    end
end

%Regular Schaefer 100
fprintf(['\nSchaefer 100 Atlas...']);
for sub = 1 : length(subs)
    for ses = 1 : length(sess)
        %add to index
        index = index + 1;

        data = load(['../Dynamic_Fingerprinting/CompTensors_Schaefer100/' ...
            '' subs{sub} '_' sess{ses} '_CompTensor.mat']);
        CT = data.CompTensor;

        %remove current session from CT (only comparing to the others)
        CT(:,:,ses) = [];

        for tr = 1 : size(CT,1)
            CTmat = squeeze(CT(tr,:,:));
            [SubMatch,~] = find(CTmat==max(CTmat(:)));

            if SubMatch == sub %if the correct task is identified
                Correct(index) = Correct(index) + 1;
            end
        end

        SubID(index,1) = sub;
        Atlas(index,1) = 100;
    end
end

%Downsampling permutations
fprintf(['\nDownsampling Permutations...']);
for perm = perms
    fprintf(['\n' num2str(perm)]);
    for sub = 1 : length(subs)
        for ses = 1 : length(sess)
            index = index + 1;

            data = load(['CompTensors/perm' num2str(perm) '/' ...
                '' subs{sub} '_' sess{ses} '.mat']);
            CT = data.CompTensor;

            %remove current session from CT (only comparing to the others)
            CT(:,:,ses) = [];

            CountVec = zeros(length(subs),1);
            for tr = 1 : size(CT,1)
                CTmat = squeeze(CT(tr,:,:));
                [SubMatch,~] = find(CTmat==max(CTmat(:)));

                if SubMatch == sub %if the correct task is identified
                    Correct(index) = Correct(index) + 1;
                end

            end

            SubID(index,1) = sub;
            Atlas(index,1) = 1;
        end
    end
end

T = table(SubID,Correct,Atlas);
T.SubID = categorical(T.SubID);
T.Atlas = categorical(T.Atlas);
lme = fitlme(T,'Correct ~ Atlas + (1|SubID)');
lme


[CI] = coefCI(lme,'Alpha',0.001);
