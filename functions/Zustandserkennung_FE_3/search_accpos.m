function [ acc_pos ] = search_accpos(vel_kmh,acc_ms2,t_acc,threshold_acc)
%Sucht in den Fahrdaten (Geschwindigkeit in kmh, Beschleunigung in m/s^2)
%nach Beschleunigungssequenzen
n=length(vel_kmh);
%t_acc=3;
%Über sum_threshold kann die Stärke der Beschleunigung, die identifiziert 
%werden sollen,eingestellt werden
sum_threshold=threshold_acc(1,2);
acc_threshold=threshold_acc(1,1);
accpos_value=zeros(n,1);
for i=1:1:n-(t_acc-1)
    k=i+(t_acc-1);
    v_seq=vel_kmh(i:k);
    a_seq=acc_ms2(i:k);
    %acc_threshold=0.01;
    variable=1;
    sum_acc_seq=sum(a_seq);
    %Betrachtung der Beschleunigung
    for j=1:t_acc
        if(a_seq(j)>acc_threshold && sum_acc_seq > sum_threshold && variable==1)
            variable=1;
        else
            variable=0;
        end   
            
    end
    if(variable==1)
        accpos_value(i:k)=1;
    elseif(accpos_value(i)==1)
        accpos_value(i)=1;
    else
        accpos_value(i)=0;
    end
    
end
%Plotten der Beschleunigungsequenzen
acc_pos=accpos_value;
%hold on
%plot(acc_pos,'gd');
end

