function [Rmean_limb_angular_vel, Lmean_limb_angular_vel] = get_limb_angular_vel(RHIP, LHIP, RKNE, LKNE, freq)
    Rlimb_angular_vel = rad2deg(atan((RHIP(:,3)-RKNE(:,3))./(RHIP(:,1)-RKNE(:,1))));
    Llimb_angular_vel = rad2deg(atan((LHIP(:,3)-LKNE(:,3))./(LHIP(:,1)-LKNE(:,1))));
    for i = 1:length(Rlimb_angular_vel)
        if Rlimb_angular_vel(i)<0
            Rlimb_angular_vel(i) = Rlimb_angular_vel(i)+180;
        end
        if Llimb_angular_vel(i)<0
            Llimb_angular_vel(i) = Llimb_angular_vel(i)+180;
        end
    end
    Rmean_limb_angular_vel = mean(diff(Rlimb_angular_vel)*freq);
    Lmean_limb_angular_vel = mean(diff(Llimb_angular_vel)*freq);
end