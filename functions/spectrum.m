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


function [xfft, Pxx] = spectrum(x)
    %Next: compute fft and plot the amplitude spectrum, up to 10Hz. 
    xfft = fft(x-mean(x)); 

    %Next: compute and plot the power spectrum, up to 10Hz.
    Pxx = xfft.*conj(xfft); 

end 