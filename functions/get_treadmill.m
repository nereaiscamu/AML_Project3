function Treadmillspeed = get_treadmill(name, RANK, freq)
    if name == "AML_02_1" || name == "DM002_TDM_08_2kmh" || name == "AML_01_1"
        Treadmillspeed(1:length(RANK(:,1))) = 2/3.6; %m/s
    end
    if name == "AML_02_2" || name == "AML_02_3" || name == "AML_01_2" || name == "AML_01_3"
        Treadmillspeed(1:60*freq) = 2/3.6;%m/s
        Treadmillspeed(60*freq:120*freq) = 3/3.6;%m/s
        Treadmillspeed(120*freq:180*freq) = 4/3.6;%m/s
        Treadmillspeed(180:length(RANK(:,1))) = 5/3.6;%m/s
    end
    if name == "AML_02_3" || name == "AML_01_3"
        Treadmillspeed(1:length(RANK(:,1))) = 3/3.6;%m/s
    end
    if name == "DM002_TDM_08_1kmh" || name == "DM002_TDM_1kmh_NoEES" 
        Treadmillspeed(1:length(RANK(:,1))) = 1/3.6;%m/s
    end
end