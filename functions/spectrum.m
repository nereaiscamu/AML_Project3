function [R_lowfreq_pow, L_lowfreq_pow,R_medfreq, L_medfreq] = spectrum(data_R, data_L, window, noverlap, RTOs, LTOs)
    R_lowfreq_pow = [];
    L_lowfreq_pow = [];
    R_medfreq = [];
    L_medfreq = [];

    for i = 1:length(RTOs)-1
        data_i = data_R(RTOs(i):RTOs(i+1));
        R_pxx = pwelch(data_i, window, noverlap);
        stop = int16(0.1*length(R_pxx));
        pow_i = sum(R_pxx(1:stop));
        R_lowfreq_pow = [R_lowfreq_pow; pow_i];
        a = find(R_pxx==median(R_pxx(:)));
        R_medfreq = [R_medfreq;a];

    end
    for i = 1:length(LTOs)-1
        data_i = data_L(LTOs(i):LTOs(i+1));
        L_pxx = pwelch(data_i, window, noverlap); 
        stop = int16(0.1*length(L_pxx));
        pow_i = sum(L_pxx(1:stop));
        L_lowfreq_pow = [L_lowfreq_pow; pow_i];
        a = find(R_pxx==median(R_pxx(:)));
        L_medfreq = [L_medfreq; a];

    end
end 


            
  

   


   