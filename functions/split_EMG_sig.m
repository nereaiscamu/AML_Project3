function RMS(dataR, dataL,  RTOs, LTOs)
    R_RMS = [];
    L_RMS = [];
    for i = 1:length(RTOs)-1
        rms_i = rms(dataR(RTOs(i):RTOs(i+1)));
        R_RMS = [R_RMS; rms_i];
    end
    for i = 1:length(LTOs)-1
        rms_i = rms(dataL(LTOs(i):LTOs(i+1)));
        L_RMS = [L_RMS; rms_i];
    end

end

