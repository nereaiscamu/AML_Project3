function [Rmean_step_height, Lmean_step_height, Rstep_height, Lstep_height ] = get_step_height(RTOs, LTOs, RANK, LANK)
    Rstep_height = [];
    Lstep_height = [];
    for i = 1:length(RTOs)-1
        stepheight = max(RANK(RTOs(i):RTOs(i+1),3)) - min(RANK(RTOs(i):RTOs(i+1),3));
        Rstep_height = [Rstep_height stepheight];
    end
    for i = 1:length(LTOs)-1
        stepheight = max(LANK(LTOs(i):LTOs(i+1),3)) - min(LANK(LTOs(i):LTOs(i+1),3));
        Lstep_height = [Lstep_height stepheight];
    end
    Rmean_step_height = mean(Rstep_height)/1000;
    Lmean_step_height = mean(Lstep_height)/1000;
end