
function [z, rmsv, env] = EMG_prepross(data, fco, fs, ts)
%The cutoff frequency is adjusted upward by 25% because the filter will be 
% applied twice (forward and backward). The adjustment assures that the 
% actual -3dB frequency after two passes will be the desired fco specified
% above. This 25% adjustment factor is correct for a 2nd order Butterworth;
% for a 4th order Butterworth used twice, multiply by 1.116.
    fnyq = fs/2;
    x = data;
    y =abs(x-mean(x));
    [b,a]=butter(4,fco* 1.116/fnyq, "low");
    z=filtfilt(b,a,y);
    rmsv = sqrt(movmean(y.^2, ts));  
    filtered_data_12 =bandpass(data,[10 2000], fs);
    filtered_data_abs = abs(filtered_data_12);
    filtered_data_3 = highpass(filtered_data_abs,30, fs);
    filtered_data_4 = bandstop(filtered_data_3,[30 70], fs);
    [env,l] = envelope(filtered_data_4,50,'rms');

end