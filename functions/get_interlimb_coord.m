function [Rmean_interlimb_coord, Lmean_interlimb_coord, R_interlimb_coord, L_interlimb_coord] = get_interlimb_coord(RTOs, LTOs, RICs, LICs, freq)
    RTOs
    RICs
    LTOs
    LICs
    if length(LTOs) > length(RTOs)
        LTOs = LTOs(1:length(RTOs));
    end
    if length(RTOs) > length(LTOs)
        RTOs = RTOs(1:length(LTOs));
    end
    if length(RTOs) > length(RICs)
        RTOs = RTOs(1:length(RICs));
    end
    if length(RICs) > length(RTOs)
        RICs = RICs(1:length(RTOs));
    end
    if length(LTOs) > length(LICs)
        LTOs = LTOs(1:length(LICs));
    end
    if length(LICs) > length(LTOs)
        LICs = LICs(1:length(LTOs));
    end
    if LICs(1)>RICs(1)
        L_interlimb_coord = (LICs-RTOs)/freq;
        LTOs_new = LTOs(1:end-1);
        RICs_new = RICs(2:end);
        R_interlimb_coord = (RICs_new - LTOs_new)/freq;
    else
        R_interlimb_coord = (RICs-LTOs)/freq;
        RTOs_new = RTOs(1:end-1);
        LICs_new = LICs(2:end);
        L_interlimb_coord = (LICs_new - RTOs_new)/freq;
    end
    Rmean_interlimb_coord = mean(R_interlimb_coord);
    Lmean_interlimb_coord = mean(L_interlimb_coord);
end