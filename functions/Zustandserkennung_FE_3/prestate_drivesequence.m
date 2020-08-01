function [ pre_state,state_general,unmatched_state,pendeln_safe,acc_pos,acc_neg,vel_kmh,acc_ms2,idle_true] = prestate_drivesequence(tvd_file)
%Zustandszuwerisung in einem Fahrprofil
%s_1-s_3: Beschleunigungszustände
%s_4-s_6: Bremszustände
%s_7-s_11: Pendelzustände
%s_12: Leerlaufzustand

%Parameter Pendeln
t_pendel=10; % minimale Pendeldauer
tol_pen=[15 35 60 110 inf; 0.5 0.15 0.1 0.08 0.04]; %bis 15 km/h 50% Toleranz, bis 35 km/h 15% Toleranz,...
safety_factor_pen=0.5; %reduziert das Toleranzfeld um die Hälfte
%Parameter Beschleunigen
t_acc=3; %minimale Dauer einer Beschleunigungssequenz
threshold_acc=[0.01 0.1]; %Einzelschwellwert und Summenschwellwert
%Parameter Bremsen
t_dec=3; %minimale Dauer einer Verzögerungssequenz
threshold_dec=[-0.005 -0.1]; %Einzelschwellwert und Summenschwellwert
%Parameter Leerlauf
t_idle=3; %minimale Dauer eines Leerlaufzustandes
vel_idle=1; %Grenze für Leerlauf

%Geschwindigkeitsfeld glätten
vel_kmh_unfiltered=tvd_file;
[vel_kmh]=smooth(vel_kmh_unfiltered,'moving');
%Beschleunigung aus Geschwindigkeit berechnen
[acc_ms2]=calc_acc_out_vel(vel_kmh);


[n,m]=size(vel_kmh);

%Pendel-Fahrabschnitte suchen
[pendeln,pendeln_safe]=search_pendeln(vel_kmh,t_pendel,tol_pen,safety_factor_pen);
%Beschleunigungs-Fahrabschnitte suchen
[acc_pos]=search_accpos(vel_kmh,acc_ms2,t_acc,threshold_acc);
%Brems-Fahrabschnitt suchen
[acc_neg]=search_accneg(vel_kmh,acc_ms2,t_dec,threshold_dec);
%Leerlauf Sequenzen suchen
[idle_true]=search_idle(vel_kmh,t_idle,vel_idle);
%Zustandsübersicht:
pre_state=zeros(n,4);
pre_state(:,1)=acc_pos;
pre_state(:,2)=acc_neg;
pre_state(:,3)=pendeln_safe; %Pendeln mit hoher Wahrscheinlichkeit wählen
pre_state(:,4)=idle_true;
state_general=zeros(n,1);
i=2;
while i< n
    seq_end_1=0;
    step_1=1;
    seq_end_2=0;
    step_2=1;
    step_change=0;
    
    if(pre_state(i,4)~=0) %Leerlauf ist dominant
        state_general(i,1)=pre_state(i,4);
    elseif(pre_state(i,1)>0 && pre_state(i,3)==0) %Falls nur Beschleunigen
        state_general(i,1)=pre_state(i,1);
    elseif(pre_state(i,2)>0 && pre_state(i,3)==0) %Falls nur Bremsen
        state_general(i,1)=pre_state(i,2);
    elseif(pre_state(i,3)>0 && pre_state(i,1)==0 && pre_state(i,2)==0) %Falls nur Pendeln
        state_general(i,1)=pre_state(i,3);
    elseif(pre_state(i,1)>0 && pre_state(i,3)>0 && pre_state(i-1,1)>0 && pre_state(i-1,3)==0)
        %Beschleunigungssequenz zu Ende laufen lassen
        %Wie lange ist die Beschleunigungssequenz noch
        while seq_end_1<1
            if(pre_state(i+step_1,1)==0)
                seq_end_1=1;
            else
                step_1=step_1+1;
            end
        end
        %Beschleunigung zu Ende laufen lassen
        state_general(i:i+step_1-1,1)=pre_state(i,1);
        i=i+step_1;
        step_change=1;
    elseif(pre_state(i,2)>0 && pre_state(i,3)>0 && pre_state(i-1,2)>0 && pre_state(i-1,3)==0)
        %Bremssequenz zu Ende laufen lassen
        %Wie lange ist die Bremssequenz noch
        while seq_end_2<1
            if(pre_state(i+step_2,2)==0)
                seq_end_2=1;
            else
                step_2=step_2+1;
            end
        end
        %Bremsen zu Ende laufen lassen
        state_general(i:i+step_2-1,1)=pre_state(i,2);
        i=i+step_2;
        step_change=1;
        
    elseif(pre_state(i,1)>0 && pre_state(i,3)>0 && pre_state(i-1,1)==0 && pre_state(i-1,3)>0) %Beschleunigen und Pendeln
        %Wie lange ist die Beschleunigungssequenz noch
        while seq_end_1<1
            if(pre_state(i+step_1,1)==0)
                seq_end_1=1;
            elseif(i+step_1<n)
                step_1=step_1+1;
            else
                seq_end_1=1;
            end
        end
        
        %Wie lange ist die Pendelsequenz noch
        while seq_end_2<1
            if(pre_state(i+step_2,3)==0)
                seq_end_2=1;
            elseif(i+step_2 < n)
                step_2=step_2+1;
            else
                seq_end_2=1;
            end
        end
        %Die Beschleunigungssequenz dauert noch step_1 Schritte
        %Die Pendelsequenz dauert noch step_2 Schritte
        if(step_1<=step_2) 
            %Falls die Pendelsequenz länger ist als die
            %Beschleunigungssequenz
            state_general(i:i+step_1-1)=pre_state(i,3);
            i=i+step_1;
            step_change=1;
        else
            %Falls die Beschleunigungssequenz länger ist als die
            %Pendelsequenz
            state_general(i:i+step_1-1)=pre_state(i,1);
            i=i+step_1;
            step_change=1;
        end
        
    elseif(pre_state(i,2)>0 && pre_state(i,3)>0 && pre_state(i-1,2)==0 && pre_state(i-1,3)>0)%Pendeln und Bremsen
        %Wie lange dauert die Bremssequenz noch
        while seq_end_1<1
            if(pre_state(i+step_1,2)==0)
                seq_end_1=1;
            elseif(i+step_1< n)
                step_1=step_1+1;
            else
                seq_end_1=1;
            end
        end
        %Wie lange dauert die Pendelsequenz noch
        while seq_end_2<1
            if(pre_state(i+step_2,3)==0)
                seq_end_2=1;
            elseif(i+step_2 < n)
                step_2=step_2+1;
            else
                seq_end_2=1;
            end
        end
        %Die Bremssequenz dauert noch step_1 Schritte
        %Die Pendelsequenz dauert noch step_2 Schritte
        if(step_1<=step_2)
            %Falls die Pendelsequenz länger ist als die Bremssequenz
            state_general(i:i+step_1-1,1)=pre_state(i,3);
            i=i+step_1;
            step_change=1;
        else
            %Falls die Bremssequenz länger ist als die Pendelsequenz
            state_general(i:i+step_1-1,1)=pre_state(i,2);
            i=i+step_1;
            step_change=1;
        end
            
        
    
        
        
    end
    %Zähler erhöhen
    if(step_change==0)
        i=i+1;
    end
end
%Ersten Punkt im Profil noch Zustand zuweisen
% if(state_general(2,1)==1)
%     state_general(1,1)=1;
% elseif(state_general(2,1)==4)
%     state_general(1,1)=4;
% elseif(state_general(2,1)==7)
%     state_general(1,1)=7;
% else
%     state_general(1,1)=12;
% end


%Verlauf mit Zuweisung Plotten
% figure
% plot(vel_kmh,'b','LineWidth',1);
% title 'Driving Profil State';
% xlabel 'Zeit in s';
% ylabel 'Fahrgeschwindigkeit in km/h';
% hold on
unmatched_state=0;
for i=1:n
    if(state_general(i,1)==7)
        %plot(i,vel_kmh(i),'k+','MarkerSize',14,'LineWidth',1.5);
    
    elseif(state_general(i,1)==1)
        %plot(i,vel_kmh(i),'gd','MarkerSize',12,'LineWidth',1);
    
    elseif(state_general(i,1)==4)
        %plot(i,vel_kmh(i),'ro','Markersize',12,'LineWidth',1);
    
    elseif(state_general(i,1)==12)
        %plot(i,vel_kmh(i),'^b','MarkerSize',10,'LineWidth',1);
    
    else
        unmatched_state=unmatched_state+1;
        %plot(i,vel_kmh(i),'ms');
    end

end
%hold off

end