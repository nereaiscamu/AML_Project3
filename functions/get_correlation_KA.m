function [Rmean_corr_KA, Lmean_corr_KA] = get_correlation_KA(RTOs, LTOs, RKNE, LKNE, RANK, LANK)
    Rcorr_KA = [];
    Lcorr_KA = [];
    for i = 1:length(RTOs)-1
        corr = corrcoef(RKNE(RTOs(i):RTOs(i+1),:), RANK(RTOs(i):RTOs(i+1),:));
        Rcorr_KA = [Rcorr_KA; corr(1,2)];
    end
    for i = 1:length(LTOs)-1
        corr = corrcoef(LKNE(LTOs(i):LTOs(i+1),:), LANK(LTOs(i):LTOs(i+1),:));
        Lcorr_KA = [Lcorr_KA; corr(1,2)];
    end
    Rmean_corr_KA = mean(Rcorr_KA);
    Lmean_corr_KA = mean(Lcorr_KA);
end