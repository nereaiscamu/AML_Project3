function [M, V, labels]  = resampling5(dataset_list, data)
    M = [];
    V = [];
    labels = [];
    min_length = [];
    min_length(1) = 0;    
    N = length(dataset_list(:,1));
    for i=1:N
        name = erase(dataset_list(i,:), ".mat");
        feats = fieldnames(data.(name));
        M_i = [];
        V_i = [];
        labels_i = [];
        min_length(i+1) = min(structfun(@numel,data.(name)));
        for j=1:length(feats)
            feat = cell2mat(feats(j));
            feat_values = data.(name).(feat)(1:min_length(i+1));
            count = 1;
            data_i = feat_values;
            means = [];
            vars = [];
            k = 1;
            while count < length(data_i)-4
                means(k,1) = mean(data_i(count:count+4));
                vars(k,1) = var(data_i(count:count +4));
                labels_i(k,1)= i;
                count = count + 5;
                k = k+1;
            end 
            M_i = [M_i means];
            V_i = [V_i vars];
            
        end
        M = [M ; M_i];
        V = [V ; V_i];
        len_lab = size(M_i,1);
        labels = [labels; repelem(i,len_lab)'];
    end
end