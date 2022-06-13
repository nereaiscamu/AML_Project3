function [X, labels]  = create_data_matrix(dataset_list, data)
    X = [];
    labels = [];
    labels_idx = [];
    min_length = [];
    min_length(1) = 0;
    labels_idx(1) = 0;
    N = length(dataset_list(:,1));
    for i=1:N
        name = erase(dataset_list(i,:), ".mat");
        feats = fieldnames(data.(name));
        X_i = [];
        min_length(i+1) = min(structfun(@numel,data.(name)));
        labels_idx(i+1) = labels_idx(i)+min_length(i+1);


        for j=1:length(feats)
            feat = cell2mat(feats(j));
            feat_values = data.(name).(feat)(1:min_length(i+1));
            X_i = [X_i feat_values];
        end
        X = [X ; X_i];
        labels(labels_idx(i)+1: labels_idx(i+1)) = repelem(i,min_length(i+1));
    end

    labels = labels';
end 
