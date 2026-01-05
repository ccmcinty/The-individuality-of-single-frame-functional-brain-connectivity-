close all
clear all
clc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Atlases = {'Schaefer100','Schaefer200','Schaefer500','Schaefer1000'};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subs = {'MSC01','MSC02','MSC03','MSC04','MSC05','MSC06','MSC07','MSC08','MSC09','MSC10'};
sess = {'ses-01','ses-02','ses-03','ses-04','ses-05','ses-06','ses-07','ses-08','ses-09','ses-10'};

Correct = zeros(60000,1);
% Correct = zeros(length(subs)*length(sess),1);
% SubID = Correct;
index = 0;
for sub = 1 : length(subs)
    for ses = 1 : length(sess)
        for atlas = 1 : length(Atlases)
           
            data = load(['CompTensors_' Atlas '/' subs{sub} '_' sess{ses} '.mat']);

            %9 Database Scans
            fprintf([subs{sub} ' | ' sess{ses} ' | ' Atlases{atlas} ' | 9 database\n']);
            index = index + 1;
            CT = data.CompTensor;
            %remove current session from CT (only comparing to the others)
            CT(:,:,ses) = [];
            for tr = 1 : size(CT,1)
                CTmat = squeeze(CT(tr,:,:));
                [SubMatch,~] = find(CTmat==max(CTmat(:)));
                if SubMatch == sub %if the correct task is identified
                    Correct(index,1) = Correct(index,1) + 1;
                end
            end
            SubID(index,1) = sub;
            Atlas_ID(index,1) = atlas;
            DB_ID(index,1) = 9;

            %5 Database Scans
            fprintf([subs{sub} ' | ' sess{ses} ' | ' Atlases{atlas} ' | 5 database\n']);
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
                SubID(index,1) = sub;
                Atlas_ID(index,1) = atlas;
                DB_ID(index,1) = 5;
                CTcombo = CT(:,:,combos(combo,:));
                for tr = 1 : size(CT,1)
                    CTmat = squeeze(CTcombo(tr,:,:));
                    [SubMatch,~] = find(CTmat==max(CTmat(:)));
                    if SubMatch == sub
                        Correct(index,1) = Correct(index,1) + 1;
                    end
                end
            end

            % %1 Database Scan
            % fprintf([subs{sub} ' | ' sess{ses} ' | ' Atlases{atlas} ' | 1 database\n']);
            % CT = data.CompTensor;
            % %remove current session from CT (only comparing to the others)
            % osess = sess;
            % osess(ses) = [];
            % CT(:,:,ses) = [];
            % CountMat = zeros(length(subs),length(osess));
            % %loop over other sessions
            % for oses = 1 : length(osess)
            %     %add to index
            %     index = index + 1;
            %     SubID(index,1) = sub;
            %     Atlas_ID(index,1) = atlas;
            %     DB_ID(index,1) = 1;
            %     %within current target session, loop over all referent TRs
            %     for tr = 1 : size(CT,1)
            %         CTmat = squeeze(CT(tr,:,oses));
            %         SubMatch = find(CTmat==max(CTmat(:)));
            % 
            %         if SubMatch == sub
            %             Correct(index,1) = Correct(index,1) + 1;
            %         end
            %     end
            % end

            
        end
    end
end
Correct(index+1:end) = [];

T = table(SubID,Correct,Atlas_ID,DB_ID);
T.SubID = categorical(T.SubID);
T.Atlas_ID = categorical(T.Atlas_ID);
T.DB_ID = categorical(T.DB_ID);
lme = fitlme(T,'Correct ~ Atlas_ID + DB_ID + (1|SubID)');
lme


[CI] = coefCI(lme,'Alpha',0.001);
% fprintf(['\n\n\n99.9%% Confidence Interval: [' num2str(CI) ']']);
