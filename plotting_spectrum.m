R_lowfreq_pow = [];
L_lowfreq_pow = [];
R_medfreq = [];
L_medfreq = [];

RANK = Markers.RANK - mean(Markers.RANK);
LANK = Markers.LANK - mean(Markers.LANK);
RHIP = Markers.RHIP - mean(Markers.RHIP);
LHIP = Markers.LHIP - mean(Markers.LHIP);
RKNE = Markers.RKNE - mean(Markers.RKNE);
LKNE = Markers.LKNE - mean(Markers.LKNE);

%Gait cycle events detection (TO and IC)
[RTOs, LTOs, RICs, LICs] = gait_cycle_events(RANK, LANK, RKNE, LKNE, RHIP, LHIP);


for i = 1:length(RTOs)-1
    data_i = EMG.LTA(RTOs(i):RTOs(i+1));
    R_pxx = pwelch(data_i, 100, 50);
    stop = int16(0.1*length(R_pxx));
    pow_i = sum(R_pxx(1:stop));
    R_lowfreq_pow = [R_lowfreq_pow; pow_i];
    a = find(R_pxx==median(R_pxx(:)));
    R_medfreq = [R_medfreq;a]
end



%%


 R_pxx = pwelch(EMG.LTA, 100, 50);
 a = find(R_pxx==median(R_pxx(:)));

 R_pxx2 = pwelch(data.LTA, 100, 50);
 b = find(R_pxx2==median(R_pxx2(:)));

 plot(R_pxx)
 hold on
 plot(a, median(R_pxx), '*')
 hold on
 plot(R_pxx2, 'red')
 hold on
 plot(b, median(R_pxx2), 'o')

