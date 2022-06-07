function [Rmean_ratio_fl, Lmean_ratio_fl] = get_ratio_fl(RTOs, LTOs, RANK, LANK)
    Rratio_fl = [];
    Lratio_fl = [];
    for i = 1:length(RTOs)-1
        fw = max(RANK(RTOs(i):RTOs(i+1), 2)) - min(RANK(RTOs(i):RTOs(i+1), 2));
        lat = max(RANK(RTOs(i):RTOs(i+1), 1)) - min(RANK(RTOs(i):RTOs(i+1), 1));
        Rratio_fl = [Rratio_fl; fw/lat];
    end
    for i = 1:length(LTOs)-1
        fw = max(LANK(LTOs(i):LTOs(i+1), 2)) - min(LANK(LTOs(i):LTOs(i+1), 2));
        lat = max(LANK(LTOs(i):LTOs(i+1), 1)) - min(LANK(LTOs(i):LTOs(i+1), 1));
        Lratio_fl = [Lratio_fl; fw/lat];
    end
    Rmean_ratio_fl = mean(Rratio_fl);
    Lmean_ratio_fl = mean(Lratio_fl);
end