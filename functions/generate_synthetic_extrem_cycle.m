function [dc_extrem,n] =generate_synthetic_extrem_cycle(acc_max,dec_max,v_max,time,time_reach)
%Erzeugung eines synthetischen extremen Fahrzyklus
dc_extrem=zeros(time+5,1);

%Für Rollenprüfstand Startgeschwindigkeit auf 7 stellen
dc_extrem(1:5,1)=7;

%Vektoren für Erreichen von acc_max
vector_reach=zeros(time_reach,1);
for i=1:time_reach
    vector_reach(i)=(1/time_reach)*i;
    vector_reach_neg(i)=(1/time_reach)*(time_reach+1-i);
end
%Geschwidigkeitszunahme pro reach Anteil
v_reach=sum(vector_reach)*3.6;

%%
%Block 1 mit 0.7 v_max

acc_reach=vector_reach*acc_max;
acc_reach_neg=vector_reach_neg*acc_max;
dc_reach=zeros(time_reach,1);
%Beschleunigungsphase
v_init=dc_extrem(5);
for j=1:time_reach
    dc_reach(j)=v_init+(acc_reach(j)*3.6);
    v_init=dc_reach(j);
end
dc_extrem(6:6+time_reach-1,1)=dc_reach;
i=0;
while(dc_extrem(6+time_reach-1+i,1) < ((0.5*v_max)-v_reach))
    dc_extrem(6+time_reach+i,1)=dc_extrem(6+time_reach-1+i)+(acc_max*3.6);
    i=i+1;
end
%Aktuelle Postion
n=1;
for m=1:time+5
    if(dc_extrem(m,1)>0)
        n=n+1;
    end
end
for j=1:time_reach
    dc_extrem(n+j-1,1)=dc_extrem(n+j-2)+(acc_reach_neg(j)*3.6);
end
%Aktuelle Position
n=1;
for m=1:time+5
    if(dc_extrem(m,1)>0)
        n=n+1;
    end
end
%Haltephase
time_hold_block_1=40;
dc_extrem(n:n+time_hold_block_1)=dc_extrem(n-1,1);
%Bremsphase
n=1;
for m=1:time+5
    if(dc_extrem(m,1)>0)
        n=n+1;
    end
end
dec_reach=vector_reach*dec_max;
for k=1:time_reach
    dc_extrem(n+k-1,1)=dc_extrem(n+k-2)+(dec_reach(k)*3.6);
end
n=1;
for m=1:time+5
    if(dc_extrem(m,1)>0)
        n=n+1;
    end
end
i=0;
while(dc_extrem(n+i-1,1) > 20 )
    dc_extrem(n+i,1)=dc_extrem(n+i-1)+(dec_max*3.6);
    i=i+1;
end
n=1;
for m=1:time+5
    if(dc_extrem(m,1)>0)
        n=n+1;
    end
end
time_hold_low=10;
dc_extrem(n:n+time_hold_low)=15;
%%
%Block_2 mit v_max
n=n+time_hold_low+1;

acc_reach=vector_reach*acc_max;
acc_reach_neg=vector_reach_neg*acc_max;
dc_reach=zeros(time_reach,1);
%Beschleunigungsphase
v_init=dc_extrem(n-1);
for j=1:time_reach
    dc_reach(j)=v_init+(acc_reach(j)*3.6);
    v_init=dc_reach(j);
end
dc_extrem(n:n+time_reach-1,1)=dc_reach;
i=0;
while(dc_extrem(n+time_reach-1+i,1) < ((0.9*v_max)-v_reach))
    dc_extrem(n+time_reach+i,1)=dc_extrem(n+time_reach-1+i)+(acc_max*3.6);
    i=i+1;
end
%Aktuelle Postion
n=1;
for m=1:time+5
    if(dc_extrem(m,1)>0)
        n=n+1;
    end
end
for j=1:time_reach
    dc_extrem(n+j-1,1)=dc_extrem(n+j-2)+(acc_reach_neg(j)*3.6);
end
%Aktuelle Position
n=1;
for m=1:time+5
    if(dc_extrem(m,1)>0)
        n=n+1;
    end
end
%Haltephase
time_hold_block_2=100;
dc_extrem(n:n+time_hold_block_2)=dc_extrem(n-1,1);
%Bremsphase
n=1;
for m=1:time+5
    if(dc_extrem(m,1)>0)
        n=n+1;
    end
end
dec_reach=vector_reach*dec_max;
for k=1:time_reach
    dc_extrem(n+k-1,1)=dc_extrem(n+k-2)+(dec_reach(k)*3.6);
end
n=1;
for m=1:time+5
    if(dc_extrem(m,1)>0)
        n=n+1;
    end
end
i=0;
while(dc_extrem(n+i-1,1) > 25 )
    dc_extrem(n+i,1)=dc_extrem(n+i-1)+(dec_max*3.6);
    i=i+1;
end
n=1;
for m=1:time+5
    if(dc_extrem(m,1)>0)
        n=n+1;
    end
end
time_hold_low=10;
dc_extrem(n:n+time_hold_low)=15;

%%
%Block 3 v_max
n=n+time_hold_low+1;

acc_reach=vector_reach*acc_max;
acc_reach_neg=vector_reach_neg*acc_max;
dc_reach=zeros(time_reach,1);
%Beschleunigungsphase
v_init=dc_extrem(n-1);
for j=1:time_reach
    dc_reach(j)=v_init+(acc_reach(j)*3.6);
    v_init=dc_reach(j);
end
dc_extrem(n:n+time_reach-1,1)=dc_reach;
i=0;
while(dc_extrem(n+time_reach-1+i,1) < ((0.9*v_max)-v_reach))
    dc_extrem(n+time_reach+i,1)=dc_extrem(n+time_reach-1+i)+(acc_max*3.6);
    i=i+1;
end
%Aktuelle Postion
n=1;
for m=1:time+5
    if(dc_extrem(m,1)>0)
        n=n+1;
    end
end
for j=1:time_reach
    dc_extrem(n+j-1,1)=dc_extrem(n+j-2)+(acc_reach_neg(j)*3.6);
end
%Aktuelle Position
n=1;
for m=1:time+5
    if(dc_extrem(m,1)>0)
        n=n+1;
    end
end
%Haltephase
time_hold_block_3=80;
dc_extrem(n:n+time_hold_block_3)=dc_extrem(n-1,1);
%Bremsphase
n=1;
for m=1:time+5
    if(dc_extrem(m,1)>0)
        n=n+1;
    end
end
dec_reach=vector_reach*dec_max;
for k=1:time_reach
    dc_extrem(n+k-1,1)=dc_extrem(n+k-2)+(dec_reach(k)*3.6);
end
n=1;
for m=1:time+5
    if(dc_extrem(m,1)>0)
        n=n+1;
    end
end
i=0;
while(dc_extrem(n+i-1,1) > 80 )
    dc_extrem(n+i,1)=dc_extrem(n+i-1)+(dec_max*3.6);
    i=i+1;
end
n=1;
for m=1:time+5
    if(dc_extrem(m,1)>0)
        n=n+1;
    end
end
time_hold_low=10;
dc_extrem(n:n+time_hold_low)=65;
%%
%Block 4 v_max
n=n+time_hold_low+1;

acc_reach=vector_reach*acc_max;
acc_reach_neg=vector_reach_neg*acc_max;
dc_reach=zeros(time_reach,1);
%Beschleunigungsphase
v_init=dc_extrem(n-1);
for j=1:time_reach
    dc_reach(j)=v_init+(acc_reach(j)*3.6);
    v_init=dc_reach(j);
end
dc_extrem(n:n+time_reach-1,1)=dc_reach;
i=0;
while(dc_extrem(n+time_reach-1+i,1) < ((0.93*v_max)-v_reach))
    dc_extrem(n+time_reach+i,1)=dc_extrem(n+time_reach-1+i)+(acc_max*3.6);
    i=i+1;
end
%Aktuelle Postion
n=1;
for m=1:time+5
    if(dc_extrem(m,1)>0)
        n=n+1;
    end
end
for j=1:time_reach
    dc_extrem(n+j-1,1)=dc_extrem(n+j-2)+(acc_reach_neg(j)*3.6);
end
%Aktuelle Position
n=1;
for m=1:time+5
    if(dc_extrem(m,1)>0)
        n=n+1;
    end
end
%Haltephase
time_hold_block_4=20;
dc_extrem(n:n+time_hold_block_4)=dc_extrem(n-1,1);
%Bremsphase
n=1;
for m=1:time+5
    if(dc_extrem(m,1)>0)
        n=n+1;
    end
end
dec_reach=vector_reach*dec_max;
for k=1:time_reach
    dc_extrem(n+k-1,1)=dc_extrem(n+k-2)+(dec_reach(k)*3.6);
end
n=1;
for m=1:time+5
    if(dc_extrem(m,1)>0)
        n=n+1;
    end
end
i=0;
while(dc_extrem(n+i-1,1) > 20 )
    dc_extrem(n+i,1)=dc_extrem(n+i-1)+(dec_max*3.6);
    i=i+1;
end
n=1;
for m=1:time+5
    if(dc_extrem(m,1)>0)
        n=n+1;
    end
end
time_hold_low=100;
dc_extrem(n:n+time_hold_low)=7;

end




