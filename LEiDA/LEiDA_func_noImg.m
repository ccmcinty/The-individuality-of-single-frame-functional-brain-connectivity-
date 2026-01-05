function [Leading_Eig,Var_Eig,dFC] = LEiDA_func_noImg(ts)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LEADING EIGENVECTOR DYNAMICS ANALYSIS
%
% This function processes the data for LEiDA
%
% - Loads the BOLD data from all subjects in a matrix of Time x Brain areas
% - Computes the BOLD phases via Hilbert transform
% - Calculates the iFC (or instantaneous BOLD coherence matrix)
% - Calculates the instantaneous Leading Eigenvector
% - Calculates the instantaneous % of variance
% - Calculates de time x time FCD matrices
%
% Saves into LEiDA_data.mat
% Leading_Eig - Leading Eigenvector at each timepoint & each subject
% Var_Eig     - % of variance of the leading eigenvector
% FCD_eig     - Cosine similarity of eigenvectors over time
%
% Written by
% Joana Cabral joana.cabral@psych.ox.ac.uk
% Last edited May 2016
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ts = ts';

% Set parameters and preallocate variables
N = width(ts); % Number of nodes
Tmax = height(ts); % Number of TRs

Phases=zeros(N,Tmax);
Leading_Eig=zeros(Tmax,N);
Var_Eig=zeros(1,Tmax);
FCD_eig =zeros(Tmax-2,Tmax-2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Get the Phase of BOLD data
for seed=1:N
    timeseriedata=demean(detrend(ts(:,seed)));
    Phases(seed,:) = angle(hilbert(timeseriedata));
end

% Get the iFC leading eigenvector at each time point
iFC=zeros(N);

% tic
nEdges = N * (N-1) / 2;
dFC = nan(Tmax,N,N);
for t=1:Tmax
    for n=1:N
        for p=1:N
            iFC(n,p)=cos(adif(Phases(n,t),Phases(p,t)));
        end
    end

    % aij = iFC;
    % aij = triu(aij,1);
    % aij(aij == 0) = [];
    % dFC(t,:) = aij;
    dFC(t,:,:) = iFC;

    [eVec,eigVal]=eig(iFC);
    eVal=diag(eigVal);
    [val1, i_vec_1] = max(eVal);
    Leading_Eig(t,:)=eVec(:,i_vec_1);
    % Calculate the variance explained by the leading eigenvector
    Var_Eig(t)=val1/sum(eVal);

    % if t == 50
    %     f = figure;
    %     f.Position = [10 10 900 900];
    %     imagesc(iFC);
    %     colormap jet;
    %     set(gca,'xtick',[]);
    %     set(gca,'ytick',[]);
    % 
    %      f = figure;
    %     f.Position = [10 10 1900 50];
    %     imagesc(Leading_Eig(t,:));
    %     colormap jet;
    %     set(gca,'xtick',[]);
    %     set(gca,'ytick',[]);
    % 
    %     f = figure;
    %     f.Position = [10 10 900 900];
    %     imagesc(Leading_Eig(t,:) .* Leading_Eig(t,:)');
    %     colormap jet;
    %     set(gca,'xtick',[]);
    %     set(gca,'ytick',[]);
    % end
end
% toc
