function [idle_true] = search_idle(vel_kmh,t_idle,vel_idle)
%Sucht nach Leerlaufzuständen
n=length(vel_kmh);
%t_idle=3;
%vel_idle=1;
idle_true=zeros(n,1);
for i=1:n-(t_idle-1)
    k=i+(t_idle-1);
    vel_seq=vel_kmh(i:k);
    variable=1;
    for j=1:t_idle
        if(vel_seq(j)<vel_idle && variable==1)
            variable=1;
        else
            variable=0;
        end
    end
    if(variable==1)
        idle_true(i:k)=12;
    elseif(idle_true(i)==12)
        idle_true(i)=12;
    end
end
end

