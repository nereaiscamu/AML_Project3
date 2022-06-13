X = [];
labels = [];
min_length = [];
min_length(1) = 0;
dataset_list = ['AML_01_1.mat'; 'AML_01_2.mat';'AML_01_3.mat'; 
    'AML_02_1.mat'; 'AML_02_2.mat';'AML_02_3.mat'];

data_healthy = Params_Healthy_cyclesplit;
N = length(dataset_list(:,1));
for i=1:N
    name = erase(dataset_list(i,:), ".mat");
    feats = fieldnames(data_healthy.(name));
    X_i = [];
    labels_i = [];
    min_length(i+1) = min(structfun(@numel,data_healthy.(name)));
    for j=1:length(feats)
        feat = cell2mat(feats(j));
        feat_values = data_healthy.(name).(feat)(1:min_length(i+1));
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
        X_i = [X_i means vars];
        
        
    end
    X = [X ; X_i];
    len_lab = size(X_i,1);
    labels = [labels; repelem(i,len_lab)'];
end
        
        

