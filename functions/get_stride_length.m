function [Rmean_stride_length, Lmean_stride_length, Rvar_stride_length, Lvar_stride_length] = get_stride_length(RANK, LANK, RICs, LICs, Treadmillspeed, freq)
    
    Lx = transpose(diff(LANK(LICs,2)))/1000;
    Lt = double(diff(LICs))/freq;
    Lv = Treadmillspeed(LICs(1:end-1));
    Lstride_length = Lx + Lt.*Lv;

    Rx = transpose(diff(RANK(RICs,2)))/1000;
    Rt = double(diff(RICs))/freq;
    Rv = Treadmillspeed(RICs(1:end-1));
    Rstride_length = Rx + Rt.*Rv;

    Rmean_stride_length = mean(Rstride_length);
    Lmean_stride_length = mean(Lstride_length);
    Rvar_stride_length = var(Rstride_length);
    Lvar_stride_length = var(Lstride_length);
end