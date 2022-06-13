%% PCA implementation
% Note: before running PCA all features should be normalized
% we can standardize the data by using zscore
clear all; close all;

load Patient_data
load Healthy_data


dataset_list1 = ['AML_01_1.mat'; 'AML_01_2.mat';'AML_01_3.mat'; 
    'AML_02_1.mat'; 'AML_02_2.mat';'AML_02_3.mat'];
dataset_list2 = ["DM002_TDM_08_1kmh.mat"; 
    "DM002_TDM_08_2kmh.mat"; "DM002_TDM_1kmh_NoEES.mat"];
[X1, labels1] = create_data_matrix(dataset_list1, Params_Healthy_cyclesplit);

[X2, labels2] = create_data_matrix(dataset_list2, Params_Patient_cyclesplit);


%%
[M1, V1, labels1_2] = resampling5(dataset_list1,Params_Healthy_cyclesplit);
[M2, V2, labels2_2] = resampling5(dataset_list2, Params_Patient_cyclesplit);

%%
labels1 = repelem(1,length(labels1))';
labels2 = labels2+1;
labels1_2 = repelem(1,length(labels1_2))';
labels2_2 = labels2_2+1;
%%
X = [X1;X2];
labels = [labels1;labels2];
pca_data = zscore(X);
mapcaplot(X,labels)

V = [V1;V2];
labels_2 = [labels1_2;labels2_2];
pca_data_M = zscore(V);
mapcaplot(V,labels_2)

M = [M1;M2];
labels_2 = [labels1_2;labels2_2];
pca_data_V = zscore(M);
mapcaplot(M,labels_2)

X_2 = [M V];
labels_2 = [labels1_2;labels2_2];
pca_data_2 = zscore(X_2);
mapcaplot(X_2, labels_2)



%% Standardize the data previous to PCA


[coefs, score] = pca(pca_data);
[coefs_2, score_2] = pca(pca_data_2);
% this should give a matrix where the columns are the PC and the
% rows the weights of each feature in the PC
% If I understood correctly we only need the 2 first PCs
% Once we run the PCA, different options for visualization: 


%%  1- Mapcaplot
%mapcaplot(data) creates 2-D scatter plots of principal components of data.
% Once you plot the principal components, you can:
% Select principal components for the x and y axes from the 
% drop-down list below each scatter plot.
% Click a data point to display its label.
% Select a subset of data points by dragging a box around them. 
% Points in the selected region and the corresponding points in 
% the other axes are then highlighted. The labels of the selected 
% data points appear in the list box.
% Select a label in the list box to highlight the corresponding data 
% point in the plot. Press and hold Ctrl or Shift to 
% select multiple data points.
% Export the gene labels and indices to the MATLAB® workspace.
varlabels = fieldnames(Params_Healthy_cyclesplit.AML_01_1);
varlabels2 = strcat(fieldnames(Params_Healthy_cyclesplit.AML_01_1), '_var');
varlabels_tot =  [varlabels;varlabels2];


h1 = biplot(coefs(:,1:2),'Scores',score(:,1:2),...
    'Color','b','Marker','o','VarLabels',varlabels);





%% 2- Another option for visualization: biplots
[coefforth,score,~,~,explainedVar] = pca(pca_data);
figure()
% Store handle to biplot
h = biplot([coefforth(:,1) coefforth(:,2)],'Scores',[score(:,1) score(:,2)],'Varlabels',varlabels);
% Identify each handle
hID = get(h, 'tag'); 
% Isolate handles to scatter points
hPt = h(strcmp(hID,'obsmarker')); 
% Identify cluster groups
grp = findgroups(labels);    %r2015b or later - leave comment if you need an alternative
grp(isnan(grp)) = max(grp(~isnan(grp)))+1; 
grpID = 1:max(grp); 
% assign colors and legend display name
clrMap = lines(length(unique(grp)));   % using 'lines' colormap
for i = 1:max(grp)
    set(hPt(grp==i), 'Color', clrMap(i,:), 'DisplayName', sprintf('Cluster %d', grpID(i)))
end
% add legend to identify cluster
[~, unqIdx] = unique(grp);
legend(hPt(unqIdx))
    

%% Now with 5 cycles as a sample with mean and variance

[coefforth_2,score_2,~,~,explainedVar_2] = pca(pca_data_2);
figure()
% Store handle to biplot
h_2 = biplot([coefforth_2(:,1) coefforth_2(:,2)], 'Scores',[score_2(:,1) score_2(:,2)]);%,'Varlabels',varlabels_tot
% Identify each handle
hID = get(h_2, 'tag'); 
% Isolate handles to scatter points
hPt = h_2(strcmp(hID,'obsmarker')); 
% Identify cluster groups
grp = findgroups(labels_2);    %r2015b or later - leave comment if you need an alternative
grp(isnan(grp)) = max(grp(~isnan(grp)))+1; 
grpID = 1:max(grp); 
% assign colors and legend display name
clrMap = lines(length(unique(grp)));   % using 'lines' colormap
for i = 1:max(grp)
    set(hPt(grp==i), 'Color', clrMap(i,:), 'DisplayName', sprintf('Cluster %d', grpID(i)))
end
% add legend to identify cluster
[~, unqIdx] = unique(grp);
legend(hPt(unqIdx))
