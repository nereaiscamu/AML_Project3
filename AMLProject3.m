%% Enter your name
close all; clear all; % a bit of cleaning
%======================================================================
% 1)  ASSIGNEMENT 0: SETTINGS
%======================================================================
% Replace by your own information
LAST_NAME1 = 'Bodenmann'; % Last name 1
LAST_NAME2 = 'Heiniger'; % Last name 2
LAST_NAME3 = 'Carbonell'; % Last name 3
GROUP_NAME = 'G'; % your dataset number

% Settings
DATASET1 = ['DM002_TDM_08_1kmh.mat'];
DATASET2 = ['DM002_TDM_08_2kmh.mat'];
DATASET3 = ['DM002_TDM_1kmh_NoEES.mat'];

load(DATASET1); % choose which datastructure to load
Results = [];


%% Plotting different Markers over Time - Right Foot
figure
time = 1:size(data.RKNE, 1);

subplot(331)
plot(time/data.marker_sr, data.RKNE(:, 1) ,'LineWidth',1.2)
set(gca,'FontSize',12)
xlabel('Time [s]')
ylabel('Right knee coordinates')
xlim([0 50.4])
title('a) Knee coordinates over time, X-Coordinates','FontSize',12)

subplot(332)
plot(time/data.marker_sr, data.RKNE(:, 2) ,'LineWidth',1.2)
set(gca,'FontSize',12)
xlabel('Time [s]')
ylabel('Right knee coordinates')
xlim([0 50.4])
title('b) Knee coordinates over time, Y-Coordinates','FontSize',12)

subplot(333)
plot(time/data.marker_sr, data.RKNE(:, 3) ,'LineWidth',1.2)
set(gca,'FontSize',12)
xlabel('Time [s]')
ylabel('Right knee coordinates')
xlim([0 50.4])
title('c) Knee coordinates over time, Z-Coordinates','FontSize',12)

subplot(334)
plot(time/data.marker_sr, data.RANK(:, 1) ,'LineWidth',1.2)
set(gca,'FontSize',12)
xlabel('Time [s]')
ylabel('Right Ankle coordinates')
xlim([0 50.4])
title('d) Ankle coordinates over time, X-Coordinates','FontSize',12)

subplot(335)
plot(time/data.marker_sr, data.RANK(:, 2) ,'LineWidth',1.2)
set(gca,'FontSize',12)
xlabel('Time [s]')
ylabel('Right Ankle coordinates')
xlim([0 50.4])
title('e) Ankle coordinates over time, Y-Coordinates','FontSize',12)

subplot(336)
plot(time/data.marker_sr, data.RANK(:, 3) ,'LineWidth',1.2)
set(gca,'FontSize',12)
xlabel('Time [s]')
ylabel('Right Ankle coordinates')
xlim([0 50.4])
title('f) Ankle coordinates over time, Z-Coordinates','FontSize',12)

subplot(337)
plot(time/data.marker_sr, data.RTOE(:, 1) ,'LineWidth',1.2)
set(gca,'FontSize',12)
xlabel('Time [s]')
ylabel('Right Toe coordinates')
xlim([0 50.4])
title('g) Toe coordinates over time, X-Coordinates','FontSize',12)

subplot(338)
plot(time/data.marker_sr, data.RTOE(:, 2) ,'LineWidth',1.2)
set(gca,'FontSize',12)
xlabel('Time [s]')
ylabel('Right Toe coordinates')
xlim([0 50.4])
title('h) Toe coordinates over time, Y-Coordinates','FontSize',12)

subplot(339)
plot(time/data.marker_sr, data.RTOE(:, 3) ,'LineWidth',1.2)
set(gca,'FontSize',12)
xlabel('Time [s]')
ylabel('Right Toe coordinates')
xlim([0 50.4])
title('i) Toe coordinates over time, Z-Coordinates','FontSize',12)

%% Plotting different Markers over Time - Left Foot

figure
time = 1:size(data.LKNE, 1)

subplot(331)
plot(time/data.marker_sr, data.LKNE(:, 1) ,'LineWidth',1.2)
set(gca,'FontSize',12)
xlabel('Time [s]')
ylabel('Left knee coordinates')
xlim([0 50.4])
title('a) Knee coordinates over time, X-Coordinates','FontSize',12)

subplot(332)
plot(time/data.marker_sr, data.LKNE(:, 2) ,'LineWidth',1.2)
set(gca,'FontSize',12)
xlabel('Time [s]')
ylabel('Left knee coordinates')
xlim([0 50.4])
title('b) Knee coordinates over time, Y-Coordinates','FontSize',12)

subplot(333)
plot(time/data.marker_sr, data.LKNE(:, 3) ,'LineWidth',1.2)
set(gca,'FontSize',12)
xlabel('Time [s]')
ylabel('Left knee coordinates')
xlim([0 50.4])
title('c) Knee coordinates over time, Z-Coordinates','FontSize',12)

subplot(334)
plot(time/data.marker_sr, data.LANK(:, 1) ,'LineWidth',1.2)
set(gca,'FontSize',12)
xlabel('Time [s]')
ylabel('Left Ankle coordinates')
xlim([0 50.4])
title('d) Ankle coordinates over time, X-Coordinates','FontSize',12)

subplot(335)
plot(time/data.marker_sr, data.LANK(:, 2) ,'LineWidth',1.2)
set(gca,'FontSize',12)
xlabel('Time [s]')
ylabel('Left Ankle coordinates')
xlim([0 50.4])
title('e) Ankle coordinates over time, Y-Coordinates','FontSize',12)

subplot(336)
plot(time/data.marker_sr, data.LANK(:, 3) ,'LineWidth',1.2)
set(gca,'FontSize',12)
xlabel('Time [s]')
ylabel('Left Ankle coordinates')
xlim([0 50.4])
title('f) Ankle coordinates over time, Z-Coordinates','FontSize',12)

subplot(337)
plot(time/data.marker_sr, data.LTOE(:, 1) ,'LineWidth',1.2)
set(gca,'FontSize',12)
xlabel('Time [s]')
ylabel('Left Toe coordinates')
xlim([0 50.4])
title('g) Toe coordinates over time, X-Coordinates','FontSize',12)

subplot(338)
plot(time/data.marker_sr, data.LTOE(:, 2) ,'LineWidth',1.2)
set(gca,'FontSize',12)
xlabel('Time [s]')
ylabel('Left Toe coordinates')
xlim([0 50.4])
title('h) Toe coordinates over time, Y-Coordinates','FontSize',12)

subplot(339)
plot(time/data.marker_sr, data.LTOE(:, 3) ,'LineWidth',1.2)
set(gca,'FontSize',12)
xlabel('Time [s]')
ylabel('Left Toe coordinates')
xlim([0 50.4])
title('i) Toe coordinates over time, Z-Coordinates','FontSize',12)

%% Gait cycle event detection based on toe

swingvectorright = zeros(1,length(data.RTOE(:, 3)));
swingvectorleft = zeros(1,length(data.LTOE(:, 3)));

for i=1:length(data.RTOE(:, 3))
    if (data.LTOE(i, 3)>240)
        swingvectorleft(i) = 1;
    else 
        swingvectorleft(i) = 0;
    end
    if (data.RTOE(i, 3)>220)
        swingvectorright(i) = 1;
    else 
        swingvectorright(i) = 0;
    end
end

figure
time = 1:size(data.LKNE, 1);

swingvectorleft
swingvectorright

subplot(211)
plot(data.LTOE(:, 3) ,'LineWidth',1.2)
hold on
plot(300*swingvectorleft ,'LineWidth',1.2)
set(gca,'FontSize',12)

subplot(212)
plot(data.RTOE(:, 3) ,'LineWidth',1.2)
hold on
plot(300*swingvectorright ,'LineWidth',1.2)
set(gca,'FontSize',12)


%% Gait cycle event detection based on ankle

swingvectorankleright = zeros(1,length(data.RANK(:, 3)));
swingvectorankleleft = zeros(1,length(data.LANK(:, 3)));

for  i=1:length(data.RANK(:, 3))
    if (data.RANK(i, 3)>340)
        swingvectorankleright(i) = 1;
    else 
        swingvectorankleright(i) = 0;
    end
end

for  i=1:length(data.LANK(:, 3))
    if (data.LANK(i, 3)>335)
        swingvectorankleleft(i) = 1;
    else 
        swingvectorankleleft(i) = 0;
    end
end



figure

subplot(211)
plot(data.LANK(:, 3) ,'LineWidth',1.2)
hold on
plot(400*swingvectorankleleft ,'LineWidth',1.2)
set(gca,'FontSize',12)

swingvectorankleleft;
swingvectorankleright;

subplot(212)
plot(data.RANK(:, 3) ,'LineWidth',1.2)
hold on
plot(400*swingvectorankleright ,'LineWidth',1.2)
set(gca,'FontSize',12)

%% Detect Steps
stepeventsleft = [];
stepeventsright = [];

for i=1:length(swingvectorankleleft)
    if ((swingvectorankleleft(i)==1) & (swingvectorankleleft(i+1)==0))
        stepeventsleft = [stepeventsleft i+1];
    end
end

for i=1:length(swingvectorankleright)
    if ((swingvectorankleright(i)==1) & (swingvectorankleright(i+1)==0))
        stepeventsright = [stepeventsright i+1];
    end
end


figure
subplot(211)
plot(data.LANK(:, 3))
hold on
scatter(stepeventsleft, data.LANK(stepeventsleft, 3), marker = 'o')
subplot(212)
plot(data.RANK(:, 3))
hold on
scatter(stepeventsright, data.RANK(stepeventsright, 3), marker = 'o')

%% Filtering EMG - Left
LSolfiltered = lowpass(data.LSol, 100, data.EMG_sr)
figure
subplot(231)
plot(data.LSol)
hold on
plot(LSolfiltered)
title('a) LSoL','FontSize',12)

subplot(232)
plot(data.LMG)
title('b) LMG','FontSize',12)

subplot(233)
plot(data.LTA)
title('c) LTA','FontSize',12)

subplot(234)
plot(data.LBF)
title('d) LBF','FontSize',12)

subplot(235)
plot(data.LST)
title('e) LST','FontSize',12)

subplot(236)
plot(data.LVLat)
title('f) LVLat','FontSize',12)

%% Filtering EMG - Right

%% Plotting different Markers over Time - Right Foot
figure
time = 1:size(data.RKNE, 1);

subplot(331)
plot(time/data.marker_sr, data.RKNE(:, 1) ,'LineWidth',1.2)
set(gca,'FontSize',12)
xlabel('Time [s]')
ylabel('Right knee coordinates')
xlim([0 50.4])
title('a) Knee coordinates over time, X-Coordinates','FontSize',12)

subplot(332)
plot(time/data.marker_sr, data.RKNE(:, 2) ,'LineWidth',1.2)
set(gca,'FontSize',12)
xlabel('Time [s]')
ylabel('Right knee coordinates')
xlim([0 50.4])
title('b) Knee coordinates over time, Y-Coordinates','FontSize',12)

subplot(333)
plot(time/data.marker_sr, data.RKNE(:, 3) ,'LineWidth',1.2)
set(gca,'FontSize',12)
xlabel('Time [s]')
ylabel('Right knee coordinates')
xlim([0 50.4])
title('c) Knee coordinates over time, Z-Coordinates','FontSize',12)

subplot(334)
plot(time/data.marker_sr, data.RANK(:, 1) ,'LineWidth',1.2)
set(gca,'FontSize',12)
xlabel('Time [s]')
ylabel('Right Ankle coordinates')
xlim([0 50.4])
title('d) Ankle coordinates over time, X-Coordinates','FontSize',12)

subplot(335)
plot(time/data.marker_sr, data.RANK(:, 2) ,'LineWidth',1.2)
set(gca,'FontSize',12)
xlabel('Time [s]')
ylabel('Right Ankle coordinates')
xlim([0 50.4])
title('e) Ankle coordinates over time, Y-Coordinates','FontSize',12)

subplot(336)
plot(time/data.marker_sr, data.RANK(:, 3) ,'LineWidth',1.2)
set(gca,'FontSize',12)
xlabel('Time [s]')
ylabel('Right Ankle coordinates')
xlim([0 50.4])
title('f) Ankle coordinates over time, Z-Coordinates','FontSize',12)

subplot(337)
plot(time/data.marker_sr, data.RTOE(:, 1) ,'LineWidth',1.2)
set(gca,'FontSize',12)
xlabel('Time [s]')
ylabel('Right Toe coordinates')
xlim([0 50.4])
title('g) Toe coordinates over time, X-Coordinates','FontSize',12)

subplot(338)
plot(time/data.marker_sr, data.RTOE(:, 2) ,'LineWidth',1.2)
set(gca,'FontSize',12)
xlabel('Time [s]')
ylabel('Right Toe coordinates')
xlim([0 50.4])
title('h) Toe coordinates over time, Y-Coordinates','FontSize',12)

subplot(339)
plot(time/data.marker_sr, data.RTOE(:, 3) ,'LineWidth',1.2)
set(gca,'FontSize',12)
xlabel('Time [s]')
ylabel('Right Toe coordinates')
xlim([0 50.4])
title('i) Toe coordinates over time, Z-Coordinates','FontSize',12)

%% Plotting different Markers over Time - Left Foot

figure
time = 1:size(data.LKNE, 1)

subplot(331)
plot(time/data.marker_sr, data.LKNE(:, 1) ,'LineWidth',1.2)
set(gca,'FontSize',12)
xlabel('Time [s]')
ylabel('Left knee coordinates')
xlim([0 50.4])
title('a) Knee coordinates over time, X-Coordinates','FontSize',12)

subplot(332)
plot(time/data.marker_sr, data.LKNE(:, 2) ,'LineWidth',1.2)
set(gca,'FontSize',12)
xlabel('Time [s]')
ylabel('Left knee coordinates')
xlim([0 50.4])
title('b) Knee coordinates over time, Y-Coordinates','FontSize',12)

subplot(333)
plot(time/data.marker_sr, data.LKNE(:, 3) ,'LineWidth',1.2)
set(gca,'FontSize',12)
xlabel('Time [s]')
ylabel('Left knee coordinates')
xlim([0 50.4])
title('c) Knee coordinates over time, Z-Coordinates','FontSize',12)

subplot(334)
plot(time/data.marker_sr, data.LANK(:, 1) ,'LineWidth',1.2)
set(gca,'FontSize',12)
xlabel('Time [s]')
ylabel('Left Ankle coordinates')
xlim([0 50.4])
title('d) Ankle coordinates over time, X-Coordinates','FontSize',12)

subplot(335)
plot(time/data.marker_sr, data.LANK(:, 2) ,'LineWidth',1.2)
set(gca,'FontSize',12)
xlabel('Time [s]')
ylabel('Left Ankle coordinates')
xlim([0 50.4])
title('e) Ankle coordinates over time, Y-Coordinates','FontSize',12)

subplot(336)
plot(time/data.marker_sr, data.LANK(:, 3) ,'LineWidth',1.2)
set(gca,'FontSize',12)
xlabel('Time [s]')
ylabel('Left Ankle coordinates')
xlim([0 50.4])
title('f) Ankle coordinates over time, Z-Coordinates','FontSize',12)

subplot(337)
plot(time/data.marker_sr, data.LTOE(:, 1) ,'LineWidth',1.2)
set(gca,'FontSize',12)
xlabel('Time [s]')
ylabel('Left Toe coordinates')
xlim([0 50.4])
title('g) Toe coordinates over time, X-Coordinates','FontSize',12)

subplot(338)
plot(time/data.marker_sr, data.LTOE(:, 2) ,'LineWidth',1.2)
set(gca,'FontSize',12)
xlabel('Time [s]')
ylabel('Left Toe coordinates')
xlim([0 50.4])
title('h) Toe coordinates over time, Y-Coordinates','FontSize',12)

subplot(339)
plot(time/data.marker_sr, data.LTOE(:, 3) ,'LineWidth',1.2)
set(gca,'FontSize',12)
xlabel('Time [s]')
ylabel('Left Toe coordinates')
xlim([0 50.4])
title('i) Toe coordinates over time, Z-Coordinates','FontSize',12)

%% Gait cycle event detection based on toe

swingvectorright = zeros(1,length(data.RTOE(:, 3)));
swingvectorleft = zeros(1,length(data.LTOE(:, 3)));

for i=1:length(data.RTOE(:, 3))
    if (data.LTOE(i, 3)>240)
        swingvectorleft(i) = 1;
    else 
        swingvectorleft(i) = 0;
    end
    if (data.RTOE(i, 3)>220)
        swingvectorright(i) = 1;
    else 
        swingvectorright(i) = 0;
    end
end

figure
time = 1:size(data.LKNE, 1);

swingvectorleft
swingvectorright

subplot(211)
plot(data.LTOE(:, 3) ,'LineWidth',1.2)
hold on
plot(300*swingvectorleft ,'LineWidth',1.2)
set(gca,'FontSize',12)

subplot(212)
plot(data.RTOE(:, 3) ,'LineWidth',1.2)
hold on
plot(300*swingvectorright ,'LineWidth',1.2)
set(gca,'FontSize',12)


%% Gait cycle event detection based on ankle

swingvectorankleright = zeros(1,length(data.RANK(:, 3)));
swingvectorankleleft = zeros(1,length(data.LANK(:, 3)));

for  i=1:length(data.RANK(:, 3))
    if (data.RANK(i, 3)>340)
        swingvectorankleright(i) = 1;
    else 
        swingvectorankleright(i) = 0;
    end
end

for  i=1:length(data.LANK(:, 3))
    if (data.LANK(i, 3)>335)
        swingvectorankleleft(i) = 1;
    else 
        swingvectorankleleft(i) = 0;
    end
end



figure

subplot(211)
plot(data.LANK(:, 3) ,'LineWidth',1.2)
hold on
plot(400*swingvectorankleleft ,'LineWidth',1.2)
set(gca,'FontSize',12)

swingvectorankleleft;
swingvectorankleright;

subplot(212)
plot(data.RANK(:, 3) ,'LineWidth',1.2)
hold on
plot(400*swingvectorankleright ,'LineWidth',1.2)
set(gca,'FontSize',12)

%% Detect Steps
stepeventsleft = [];
stepeventsright = [];

for i=1:length(swingvectorankleleft)
    if ((swingvectorankleleft(i)==1) & (swingvectorankleleft(i+1)==0))
        stepeventsleft = [stepeventsleft i+1];
    end
end

for i=1:length(swingvectorankleright)
    if ((swingvectorankleright(i)==1) & (swingvectorankleright(i+1)==0))
        stepeventsright = [stepeventsright i+1];
    end
end


figure
subplot(211)
plot(data.LANK(:, 3))
hold on
scatter(stepeventsleft, data.LANK(stepeventsleft, 3), marker = 'o')
subplot(212)
plot(data.RANK(:, 3))
hold on
scatter(stepeventsright, data.RANK(stepeventsright, 3), marker = 'o')

%% Filtering EMG - Left
RSolfiltered = lowpass(data.RSol, 1, data.EMG_sr)
figure
subplot(231)
plot(data.RSol)
hold on
plot(RSolfiltered)
title('a) RSoL','FontSize',12)

RMGfiltered = lowpass(data.RMG, 1, data.EMG_sr)
subplot(232)
plot(data.RMG)
hold on
plot(RMGfiltered)
title('b) RMG','FontSize',12)

RTAfiltered = lowpass(data.RTA, 1, data.EMG_sr)
subplot(233)
plot(data.RTA)
hold on
plot(RTAfiltered)
title('c) RTA','FontSize',12)

RBFfiltered = lowpass(data.RBF, 1, data.EMG_sr)
subplot(234)
plot(data.RBF)
hold on
plot(RBFfiltered)
title('d) RBF','FontSize',12)

RSTfiltered = lowpass(data.RST, 1, data.EMG_sr)
subplot(235)
plot(data.RST)
hold on
plot(RSTfiltered)
title('e) RST','FontSize',12)

RVLATfiltered = lowpass(data.RVLat, 1, data.EMG_sr)
subplot(236)
plot(data.RVLat)
hold on
plot(RSTfiltered)
title('f) RVLat','FontSize',12)



