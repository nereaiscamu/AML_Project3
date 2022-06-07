function [onset, offset, thrs, d] = detect_bursts(sig, fs)
    onset = [];
    offset = [];
    %They high-pass filtered the raw EMG before applying the TKE operator
    %("6th order, high pass filter at 20 Hz”) 
    % They low-pass filtered the TKE signal y(n) (“6th order, zero-phase 
    % lowpass filter at 50 Hz”) before threshold detection. 
    % TKE = x(n)^2 - (x(n-1)*x(n+1))
    % Threshold = mean(TKE)+ J*std(TKE)
    % They used J=15.
    fnyq = fs/2;
    x = sig;
    y =abs(x-mean(x));
    [b,a]=butter(6,20/fnyq, "high");
    z=filtfilt(b,a,y);
    [b2, a2] = butter(6,45/fnyq, "low");
    z2 = filtfilt(b2,a2,z);    
    c = [];    
    for i=2:length(z2)-1
        c(i-1) = z2(i)^2 -(z2(i+1)*z2(i-1));
    end
    d= sqrt(movmean(c.^2, 500)); % 500 sample window for the RMS as 
    % it makes it easier to detect the burst    
    rem = median(c) + 1.5*iqr(c); 
    rest = c(c<=rem); % I use the mean only of the rest muscle period
    thrs = mean(rest)+2*std(rest);
    N = length(d);
    for i=2:N
        if d(i-1)<thrs && d(i)>=thrs && i<(N-50) && all(d(i:i+50)>=thrs)
                onset = [onset; i];
        end 
        if d(i-1)>thrs && d(i)<=thrs && i>50 && all(d(i-50:i-1)>=thrs)
                offset = [offset; i];        
        end
    end
end
