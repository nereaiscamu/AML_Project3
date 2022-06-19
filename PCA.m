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


%% Transforming input data
% Computing mean and variance for each feature and using those
% values over 5 gait cycles as a sample
[M1, V1, labels1_2] = resampling5(dataset_list1,Params_Healthy_cyclesplit);
[M2, V2, labels2_2] = resampling5(dataset_list2, Params_Patient_cyclesplit);

%% Changing the labels to correspond to the different datasets before concatenating
labels2 = labels2+6;
labels2_2 = labels2_2+6;
%% Creating input matrices for PCA
X = [X1;X2];
labels = [labels1;labels2];
pca_data = zscore(X);

V = [V1;V2];
labels_2 = [labels1_2;labels2_2];
pca_data_M = zscore(V);

M = [M1;M2];
labels_2 = [labels1_2;labels2_2];
pca_data_V = zscore(M);

X_2 = [M V];
labels_2 = [labels1_2;labels2_2];
pca_data_2 = zscore(X_2);



%% Standardize the data previous to PCA

[coefs, score, latent, ~, explained] = pca(pca_data);
[coefs_2, score_2, latent_2, ~, explained_2] = pca(pca_data_2);
% this should give a matrix where the columns are the PC and the
% rows the weights of each feature in the PC

%% Creating feature labels for data visualization
varlabels = fieldnames(Params_Healthy_cyclesplit.AML_01_1);
varlabels2 = strcat(fieldnames(Params_Healthy_cyclesplit.AML_01_1), '_var');
varlabels_tot =  [varlabels;varlabels2];

new_varlabels = {};
for i=1:length(varlabels)
    new_varlabels{i} = strrep(varlabels{i},'_',' ');
end
new_varlabels = new_varlabels';

new_varlabels_tot = {};
for i=1:length(varlabels_tot)
    new_varlabels_tot{i} = strrep(varlabels_tot{i},'_',' ');
end
new_varlabels_tot = new_varlabels_tot';


%% Using biplots for data projection into 2 first PCs
[coefforth,score,~,~,explainedVar] = pca(pca_data);
figure()
% Store handle to biplot
h = biplot([coefforth(:,1) coefforth(:,2)],'Scores',[score(:,1) score(:,2)],'Varlabels',varlabels);
% Identify each handle
hID = get(h, 'tag'); 
% Isolate handles to scatter points
hPt = h(strcmp(hID,'obsmarker')); 
% Identify cluster groups
grp = findgroups(labels);    
grp(isnan(grp)) = max(grp(~isnan(grp)))+1; 
grpID = 1:max(grp); 
% assign colors and legend display name
clrMap = [255 0 0; 255 166 0; 255 243 0;100 255 0; 94 176 40; 157 201 243 ;0 85 255; 221 129 255; 250 20 250]/255;
for i = 1:max(grp)
    set(hPt(grp==i), 'Color', clrMap(i,:), 'DisplayName', sprintf('Dataset %d', grpID(i)))
end
% add legend to identify cluster
[~, unqIdx] = unique(grp);
legend(hPt(unqIdx))
  
%% Distance calculation
c1 = score(:,1);
c2 = score(:,2);
groupmeans = [];
names = [];
cgray = gray;

figure
hold on

for i = 1:9
    idx = find(grp == i);
    meanc1 = mean(c1(idx(1):idx(end)));
    meanc2 = mean(c2(idx(1):idx(end)));
    groupmeans = [groupmeans; meanc1 meanc2];
    names = [names "data "+i "mean "+i]
    plot(c1(idx(1):idx(end)), c2(idx(1):idx(end)), '.', "color",  cgray(i*25,:))
    plot(meanc1,meanc2, 'x', "color", clrMap(i, :), 'markersize', 8, 'LineWidth', 4)
end
legend(names)
title("Group means")
xlabel("component 1")
ylabel("component 2")

distances = zeros(9);
for i = 1:9
    for j = 1:9
        distances(i,j) = round(norm(groupmeans(i,:) - groupmeans(j,:)), 2);
    end
end


%% Now with 5 cycles as a sample with mean and variance

[coefforth_2,score_2,latent_2,~,explainedVar_2] = pca(pca_data_2);
figure()
% Store handle to biplot
h_2 = biplot([coefforth_2(:,1) coefforth_2(:,2)], 'Scores',[score_2(:,1) score_2(:,2)],'Varlabels',varlabels_tot);%,'Varlabels',varlabels_tot
% Identify each handle
hID = get(h_2, 'tag'); 
% Isolate handles to scatter points
hPt = h_2(strcmp(hID,'obsmarker')); 
% Identify cluster groups
grp = findgroups(labels_2);    
grp(isnan(grp)) = max(grp(~isnan(grp)))+1; 
grpID = 1:max(grp); 
% assign colors and legend display name
clrMap = [255 0 0; 255 166 0; 255 243 0;100 255 0; 94 176 40; 157 201 243 ;0 85 255; 221 129 255; 250 20 250]/255;
for i = 1:max(grp)
    set(hPt(grp==i), 'Color', clrMap(i,:), 'DisplayName', sprintf('Cluster %d', grpID(i)))
end
% add legend to identify cluster
[~, unqIdx] = unique(grp);
legend(hPt(unqIdx))

%% Feature loading
unscaled_loading = coefs.*sqrt(latent)';  % Computing feature loading
figure
barh(unscaled_loading(:,1))
yticks(1:29)
yticklabels(new_varlabels)
xlim([-0.9, 1])


%% Feature loading 2 (for the 5 cycles per sample)
unscaled_loading_2 = coefs_2.*sqrt(latent_2)';

figure
barh(unscaled_loading_2(:,1))
yticks(1:58)
yticklabels(new_varlabels_tot)
xlim([-0.7, 1])

%% Plots of the 2 most important features
figure
boxplot(X(:,4),labels) % corresponding to step height
title('Boxplot of the left step heigth for the different datasets')
xlabel('Dataset number')
ylabel('Step height (mm)')
%%
figure
boxplot(X(:,21),labels) % corresponding to RMS
title('Boxplot of the EMG RMS for TA and Sol muscles')
xlabel('Dataset number')
ylabel('RMS')


%%
figure
boxplot(X(:,15),labels, 'symbol', '') % corresponding to interlimb coordination
title('Boxplot of the left interlimb coordination')
xlabel('Dataset number')
ylabel('Interlimb coordination (s)')
ylim([0.7,2.7])

