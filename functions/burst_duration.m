function [R_burst_dur, L_burst_dur] = burst_duration(data_R, data_L,RTOs, LTOs, SR_EMG)

    R_burst_dur = [];
    L_burst_dur = [];
    for i = 1:length(RTOs)-1
        [onset, offset, thrs, d] = detect_bursts(data_R(RTOs(i):RTOs(i+1)), 1000);
        dur_i = mean(compute_duration(onset, offset, SR_EMG));
        R_burst_dur = [R_burst_dur; dur_i];
    end
    for i = 1:length(LTOs)-1
        [onset, offset, thrs, d] = detect_bursts(data_L(LTOs(i):LTOs(i+1)), 1000);
        dur_i = mean(compute_duration(onset, offset, SR_EMG));
        L_burst_dur = [L_burst_dur; dur_i];
    end
end 