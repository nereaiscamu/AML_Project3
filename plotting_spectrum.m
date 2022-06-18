healthy = load("AML_01_1.mat");
no_EES = load("DM002_TDM_1kmh_NoEES.mat");
EES = load("DM002_TDM_08_1kmh.mat");

EMG_healthy = healthy.EMG;
EMG_no_EES = no_EES.data;
EMG_EES = EES.data;

%%
 R_pxx_healthy = pwelch(EMG_healthy.LTA, 100, 50);
 a = find(R_pxx==median(R_pxx(:)));

 R_pxx_noEES = pwelch(EMG_no_EES.LTA, 100, 50);
 b = find(R_pxx2==median(R_pxx2(:)));

 R_pxx_EES = pwelch(EMG_EES.LTA, 100, 50);
 c = find(R_pxx2==median(R_pxx2(:)));


 plot(10*log10(R_pxx_healthy))
 hold on
 plot(10*log10(R_pxx_noEES), 'red')
 hold on
 plot(10*log10(R_pxx_EES), 'k')
 hold on
 plot(a, median(10*log10(R_pxx_healthy)), '*')
 hold on
 plot(b, median(10*log10(R_pxx_noEES)), 'o')
 hold on
 plot(b, median(10*log10(R_pxx_EES)), 'o')
 legend('Power spectrum healthy', ...
     'Power spectrum SCI patient no stimulation', ...
     'Power spectrum SCI patient EES', ...
     'Median power frequency healthy', ...
     'Median power frequency SCI patient noEES', ...
     'Median power frequency SCI patient EES')
 xlabel('Frequency (Hz)')
 ylabel('Power (dB/(rad/sample)')

