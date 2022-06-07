%% PCA implementation
% Note: before running PCA all features should be normalized
% we can standardize the data by using zscore

pca_data = zscore(results');


PC_comps = pca(results);
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

mapcaplot(data,labels)





%% 2- Another option for visualization: biplots

%    first 4 eigenvectors biplots
       biplot_dimensions(coefs,score,1:2,condition)
       
       biplot_dimensions(coefs,score,2:3,condition)
       
       biplot_dimensions(coefs,score,3:4,condition)

       biplot_dimensions(coefs,score,[3, 1],condition)

       biplot_dimensions(coefs,score,[4, 1],condition)

       biplot_dimensions(coefs,score,[4, 2],condition)
       %    content of the first 4 eigenvectors
       
       bar_eigenvector(coefs,1,field_names)
       bar_eigenvector(coefs,2,field_names)
       bar_eigenvector(coefs,3,field_names)
       bar_eigenvector(coefs,4,field_names)
    
end