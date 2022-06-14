function [R_Mean, L_Mean, R_var, L_var] = Mean_EMG(dataR, dataL,  RTOs, LTOs)
    R_Mean = [];
    L_Mean = [];
    R_var = [];
    L_var = [];
    for i = 1:length(RTOs)-1
        mean_i = mean(dataR(RTOs(i):RTOs(i+1)));
        var_i = var(dataR(RTOs(i):RTOs(i+1)));
        R_Mean = [R_Mean; mean_i];
        R_var = [R_var; var_i];
    end
    for i = 1:length(LTOs)-1
        mean_i = mean(dataL(LTOs(i):LTOs(i+1)));
        var_i = var(dataL(LTOs(i):LTOs(i+1)));
        L_Mean = [L_Mean; mean_i];
        L_var = [L_var; var_i];
    end

end