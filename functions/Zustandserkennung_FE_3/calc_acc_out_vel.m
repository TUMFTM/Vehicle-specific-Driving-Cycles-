function [ acc_ms2 ] = calc_acc_out_vel( vel_kmh )
%Berechnung der Beschleunigung in m/s^2 aus der Geschwindigkeit im km/h
% Plot der Beschleunigung
n=length(vel_kmh);
acc_ms2=zeros(n,1);
for i=1:n-1
    acc_ms2(i)=(vel_kmh(i+1)-vel_kmh(i));
    acc_ms2(i)=acc_ms2(i)/3.6;
end



end

