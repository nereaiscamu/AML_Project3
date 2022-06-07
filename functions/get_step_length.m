function [Rmean_step_length, Lmean_step_length] = get_step_length(RANK, LANK, RICs, LICs, Treadmillspeed, freq)
    steps = min(length(RICs), length(LICs));

    if RICs(1) < LICs(1)
        Lx = transpose(LANK(LICs(1:steps),2) - RANK(RICs(1:steps),2))/1000;
        Lt = double(LICs(1:steps) - RICs(1:steps))/freq;
        Lv = Treadmillspeed(RICs(1:steps));
        Lstep_length = Lx + Lt.*Lv;

        Rx = transpose(RANK(RICs(2:steps),2) - LANK(LICs(1:steps-1),2))/1000;
        Rt = double(RICs(2:steps) - LICs(1:steps-1))/freq;
        Rv = Treadmillspeed(LICs(1:steps-1));
        Rstep_length = Rx + Rt.*Rv;
    else
        Rx = transpose(RANK(RICs(1:steps),2) - LANK(LICs(1:steps),2))/1000;
        Rt = double(RICs(1:steps) - LICs(1:steps))/freq;
        Rv = Treadmillspeed(LICs(1:steps));
        Rstep_length = Rx + Rt.*Rv;

        Lx = transpose(LANK(LICs(2:steps),2) - RANK(RICs(1:steps-1),2))/1000;
        Lt = double(LICs(2:steps) - RICs(1:steps-1))/freq;
        Lv = Treadmillspeed(RICs(1:steps-1));
        Lstep_length = Lx + Lt.*Lv;
    end
    Rmean_step_length = mean(Rstep_length);
    Lmean_step_length = mean(Lstep_length);

end