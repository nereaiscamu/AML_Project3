function [R_Mean, L_Mean] = Mean_EMG(dataR, dataL,  RTOs, LTOs)
    R_Mean = [];
    L_Mean = [];
    for i = 1:length(RTOs)-1
        mean_i = mean(dataR(RTOs(i):RTOs(i+1)));
        R_mean = [R_Mean; mean_i];
    end
    for i = 1:length(LTOs)-1
        mean_i = mean(dataL(LTOs(i):LTOs(i+1)));
        L_Mean = [L_Mean; mean_i];
    end

end