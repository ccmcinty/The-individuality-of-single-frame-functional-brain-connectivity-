%Builds Count Mats using Comp Tensors rather than calculating r values many
%times(as with first versions of PhaseMap2)

close all
clear all
clc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Atlas = 'Schaefer1000';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subs = {'MSC01','MSC02','MSC03','MSC04','MSC05','MSC06','MSC07','MSC08','MSC09','MSC10'};
sess = {'ses-01','ses-02','ses-03','ses-04','ses-05','ses-06','ses-07','ses-08','ses-09','ses-10'};

Correct_ID = zeros(length(subs),length(sess),length(sess)-1);
for sub = 1 : length(subs)
    for ses = 1 : length(sess)
        data = load([Atlas '_CompTensors/' subs{sub} '_' sess{ses} '.csv']);
        CT = data;

        %remove current session from CT (only comparing to the others)
        osess = sess;
        osess(ses) = [];
        CT(:,ses) = [];

        %loop over other sessions
        for oses = 1 : length(osess)

            CTmat = squeeze(CT(:,oses));
            SubMatch = find(CTmat==max(CTmat(:)));
            
            if SubMatch == sub
                Correct_ID(sub,ses,oses) = 1;
            end
        end
    end
end

ID_Rate = mean(100* Correct_ID(:));
fprintf(['All-TR ID Rate = ' num2str(round(ID_Rate,1)) '%%\n']);


