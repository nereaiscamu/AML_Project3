% function [xfft, Pxx] = spectrum(x, SR)
%     fnyq = SR/2;
%     N=length(x); 
%     freqs=0:(SR/N):10; 
%     %Next: compute fft and plot the amplitude spectrum, up to 10Hz. 
%     xfft = fft(x-mean(x)); 
%     figure; 
%     plot(freqs,abs(xfft(1:2559))); 
%     %Next: compute and plot the power spectrum, up to 10Hz.
%     Pxx = xfft.*conj(xfft); 
%     figure; 
%     plot(freqs,abs(Pxx(1:2559))); 
% end 


function [xfft, Pxx] = spectrum(data_R, data_L, num_values)

    if num_values == 1
        %Next: compute fft and plot the amplitude spectrum, up to 10Hz. 
        R_xfft = fft(data_R-mean(data_R)); 
        L_xfft = fft(data_L-mean(data_L)); 
        %Next: compute and plot the power spectrum, up to 10Hz.
        R_Pxx = R_xfft.*conj(R_xfft); 
        L_Pxx = L_Pxx.*conj(L_Pxx);
    end
    if num_values == 'all_cycles'
        R_xfft = [];
        R_Pxx = [];
        L_xfft = [];
        L_Pxx = [];
        for i = 1:length(RTOs)-1
            sig_i = mean(dataR(RTOs(i):RTOs(i+1)));
        R_xfft = [R_xfft; sig_i];
    end
    for i = 1:length(LTOs)-1
        sig_i = mean(dataL(LTOs(i):LTOs(i+1)));
        L_split_sig = [L_split_sig; sig_i];
    end

    end


    FALTA ACABAR FUNCIÓN