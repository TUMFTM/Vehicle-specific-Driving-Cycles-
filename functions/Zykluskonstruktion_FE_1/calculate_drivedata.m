function [ drive_data,cycle_time,state_next ] = calculate_drivedata( state_next,drive_data,cycle_time,cycle_typ,vel_up_limit,vel_low,acc_up,acc_low,cycle_time_limit,veh_data)
%Berechnung des Fahrprofils anhand des Zustandsvektors
%Grenzen für die Geschwindigkeit werden vorgegeben. Falls die
%Geschwindigkeit über die Grenzen hinausgeht, wird der Zustand abgebrochen.

%Fahrzeugdaten auslesen
veh_mass=veh_data(1,1);
veh_a_st=veh_data(2,1);
veh_cw=veh_data(3,1);
veh_power=veh_data(4,1);
n_mot_wheel=veh_data(5,1);
c_r=veh_data(6,1);
roh_l=1.2;
gravity=9.81;


if(cycle_typ==1)
     vel_up=60;
elseif(cycle_typ==2)
     vel_up=105;
else
     vel_up=vel_up_limit;
end

if(state_next(1,1)<7) %Beschleunigen und Bremsen
    drive_data(cycle_time,4)=state_next(1,1);
    t_seq=state_next(5,1);
    acc=state_next(3,1); %aktuelle Zyklusbeschleunigung
    vel=state_next(2,1); %aktuelle Zyklusgeschwindigkeit
    %Für Modelierung des Zyklusende
    if(cycle_time>(cycle_time_limit-50) && state_next(1,1)>4 )
        t_seq=1;
        %Beschleunigung so wählen, dass vel kurz vor Zyklusende nahe bei
        %null ist
        if(vel>30)
            acc=-((vel-vel_low)/3.6)/(cycle_time_limit-cycle_time-15);
        else
            acc=-((vel-vel_low)/3.6)/(cycle_time_limit-cycle_time);
        end
    end
    
    while t_seq>0
        var=0;
        %Grenzen einhalten
        if(state_next(1,1)<4) %Beschleunigung
            %Ggf Sklierung anpassen falls hohe Belastung erwünscht
            %while (acc*state_next(6,1))>acc_up
                %state_next(6,1)=state_next(6,1)*0.95; %Skalieung 5% reduzieren solange bis acc_up unterschritten wird
            %end
            if((vel+(acc*3.6))>vel_up || (acc*state_next(6,1))>=acc_up )
                t_seq=0;
            else
                var=1;
            end

        else %Bremsen
            if((vel+(acc*3.6))<=vel_low || (acc*state_next(6,1))<= acc_low )
                t_seq=0;
            else
                var=1;
            end
        end
        if(var==1)
            drive_data(cycle_time,1)=cycle_time;
            vel=vel+(acc*3.6);
            drive_data(cycle_time,2)=vel;
            acc=acc*state_next(6,1); %Skalieren
            %Maximale Beschleunigung überprüfen
            f_t=3600*n_mot_wheel*veh_power/vel;
            resistance=(0.5*roh_l*veh_cw*veh_a_st*((vel/3.6)^2))+(veh_mass*c_r*gravity);
            acc_max=(f_t-resistance)/veh_mass;
            if(acc>acc_max && acc>0)
                acc=acc_max;
            end
            drive_data(cycle_time,3)=acc;
            t_seq=t_seq-1;
            drive_data(cycle_time,4)=state_next(1,1);
            cycle_time=cycle_time+1;
        end
    end
    state_next(2,1)=vel;
    state_next(3,1)=acc;
elseif(state_next(1,1)<12) %Pendeln
    drive_data(cycle_time,4)=state_next(1,1);
    t_seq=state_next(5,1);
    acc_pos=state_next(3,1);
    acc_neg=state_next(4,1);
    acc_choice=linspace(acc_neg,acc_pos,10);
    acc=randsample(acc_choice,1);
    vel=state_next(2,1);
    while t_seq>0
        drive_data(cycle_time,1)=cycle_time;
        if(vel+(acc*3.6)< vel_up && vel+(acc*3.6)> vel_low)
            vel=vel+(acc*3.6);
            drive_data(cycle_time,2)=vel;
            acc=randsample(acc_choice,1);
            drive_data(cycle_time,3)=acc;
            t_seq=t_seq-1;
            drive_data(cycle_time,4)=state_next(1,1);
            cycle_time=cycle_time+1;
        else
            if(acc>0)
                acc=acc_neg; %damit Geschwindigkeit reduziert wird um Grenze einzhalten
            else
                acc=acc_pos; %damit Geschwindigkeit erhöht wird um Grenze einzuhalten
            end
        end
    end
    state_next(2,1)=vel;
    state_next(3,1)=acc;
elseif(state_next(1,1)==12) %Leerlauf
    drive_data(cycle_time,4)=state_next(1,1);
    t_seq=state_next(5,1);
    acc=state_next(3,1);
    vel=state_next(2,1);
    while t_seq>0
        drive_data(cycle_time,1)=cycle_time;
        vel=vel+(acc*3.6);
        drive_data(cycle_time,2)=vel;
        acc=acc*state_next(6,1); %Skalieren
        drive_data(cycle_time,3)=acc;
        t_seq=t_seq-1;
        drive_data(cycle_time,4)=state_next(1,1);
        cycle_time=cycle_time+1;
    end
    state_next(2,1)=vel;
    state_next(3,1)=acc;

end
        
        
    


end

