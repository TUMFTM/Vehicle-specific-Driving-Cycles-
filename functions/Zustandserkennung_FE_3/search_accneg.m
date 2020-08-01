function [ acc_neg ] = search_accneg( vel_kmh, acc_ms2,t_acc,threshold_dec)
%Sucht in den Fahrdaten (Geschwindigkeit in kmh, Beschleunigung in m/s^2)
%nach Abremssequenzen
n=length(vel_kmh);
%t_acc=3;
sum_acc_neg_threshold=threshold_dec(1,2); %Schwelle für Summenbeschleunigung
acc_threshold=threshold_dec(1,1); %Schwelle für Einzelbeschleunigungen
accneg_value=zeros(n,1);
for i=1:1:n-(t_acc-1)
    k=i+(t_acc-1);
    v_seq=vel_kmh(i:k);
    a_seq=acc_ms2(i:k);
    %acc_threshold=-0.005; %Schwelle für Einzelbeschleunigungen
    sum_acc_seq=sum(a_seq);
    variable=1;
    for j=1:t_acc
        if(a_seq(j)<acc_threshold && sum_acc_seq < sum_acc_neg_threshold && variable==1)
            variable=1;
        else
            variable=0;
        end   
            
    end
    if(variable==1)
        accneg_value(i:k)=1;
    elseif(accneg_value(i)==1)
        accneg_value(i)=1;
    else
        accneg_value(i)=0;
    end
    
end
%Plotten der Abbremssequenzen
acc_neg=4.*accneg_value;
%hold on
%plot(acc_neg,'ro');

end

