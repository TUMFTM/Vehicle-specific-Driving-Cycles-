function [ drive_data,p_matrix,rel_mat_struct,dc_cell,unmatched_sum,dc,vel_up_limit,acc_up,acc_low,veh_data] = create_cycle(vehicle_class,order_markov_chain)
%Baut den Fahrzyklus mit Hilfe einer Markovkette erster Ordnung auf.


%%
%Pfad aktivieren
addpath(genpath('functions'));

%%
%Fahrzeugcharaktersitk, entnommen aus auto motor sport datenbank

acc_low=-3; %maximal zulässige Verzögerung (Gefahrenbremsung)
if(strcmp(vehicle_class,'small')==1) %VW Up
    vel_up_limit=162; %Maximale Geschwindigkeit
    acc_up=1.92; %maximale Beschleunigung (Berechnet aus 0-100km/h Zeit)
    veh_mass=926; %Fahrzeugmasse
    veh_a_st=2.08; %Stirnfläche
    veh_cw=0.33; %Cw-Wert
    veh_power=44; %Motorleistung
    n_mot_wheel=0.8; %Wirkungsgrad Motorkurbelwelle bis Rad: https://www.schaeffler.com/remotemedien/media/_shared_media/08_media_library/01_publications/schaeffler_2/symposia_1/downloads_11/6_Getriebesysteme_1.pdf
    % Wirkungsgrad stark von Getriebetyp, Gangwahl, etc. abhängig. Daher
    % hier Richtwert
elseif(strcmp(vehicle_class,'small_bev')==1)  %VW eUp
    vel_up_limit=130;
    acc_up=2.2;
    veh_mass=1230;
    veh_a_st=2.08;
    veh_cw=0.33;
    veh_power=60;
    n_mot_wheel=0.95;
elseif(strcmp(vehicle_class,'compact')==1) %VW Golf
    vel_up_limit=212;
    acc_up=3.3;
    veh_mass=1268;
    veh_a_st=2.2;
    veh_cw=0.27;
    veh_power=100;
    n_mot_wheel=0.8;
elseif(strcmp(vehicle_class,'compact_bev')==1) %VW eGolf
    vel_up_limit=140;
    acc_up=2.85;
    veh_mass=1585;
    veh_a_st=2.2;
    veh_cw=0.27;
    veh_power=85;
    n_mot_wheel=0.95;    
elseif(strcmp(vehicle_class,'executive')==1) %Audi A6
    vel_up_limit=250;
    acc_up=4.6;
    veh_mass=1770;
    veh_a_st=2.33;
    veh_cw=0.24;
    veh_power=180;
    n_mot_wheel=0.8;
elseif(strcmp(vehicle_class,'executive_bev')==1) %Tesla Model S
    vel_up_limit=210;
    acc_up=4.8;
    veh_mass=2108;
    veh_a_st=2.34;
    veh_cw=0.23;
    veh_power=193;
    n_mot_wheel=0.95;
elseif(strcmp(vehicle_class,'sport')==1) %Sport nur bedingt sinnvoll, da Fahrdaten nur bis Oberklasse vertreten
    vel_up_limit=260;                   %Porsche 911
    acc_up=6.2;
    veh_mass=1900;
    veh_a_st=2.22;
    veh_cw=0.29;
    veh_power=250;
    n_mot_wheel=0.8;
elseif(strcmp(vehicle_class,'sport_bev')==1) %Tesla Model S P100D
    vel_up_limit=250;
    acc_up=6.3;
    veh_mass=2100;
    veh_a_st=2.34;
    veh_cw=0.24;
    veh_power=310;
    n_mot_wheel=0.95;
end
%Allgemein gültige Fahrzeugdaten

c_r=0.011; %Rollreibungskoeffizient: https://www.thm.de/me/images/user/herzog-91/Kfz-Antriebe/Kfz_Antriebe_2_EnergiebedarfKfz.pdf
veh_data=[veh_mass; veh_a_st; veh_cw; veh_power; n_mot_wheel; c_r]; %Fahrzeugdaten gesammelt
%%
%Fahrdaten laden und relevante Matrizen generieren
[unmatched_sum,pen_global,pen_global_komp,global_state_vector,global_state_matrix,acc_global,dec_global,acc_global_komp,dec_global_komp,rel_mat_struct] = state_drivedata;

%%
%P-Matrix berechnen
if(order_markov_chain==1)
    [state_changes,number_statechange,p_matrix] = generate_p(global_state_vector);
else 
%2te Ordnung
    [state_changes,number_statechange,p_matrix_2_order] = generate_p_2_order(global_state_vector);
end
%% Zyklen berechnen
cycle_time_limit=1800; %Gewünschte Zykluslänge
state_vector_2_order=zeros(cycle_time_limit,1); %Markov-Kette 2.Ordnung
p=1; %Markov-Kette 2.Ordnung
n_cycle=1;
dc_cell=zeros(cycle_time_limit,n_cycle*4);
for i=1:n_cycle
    %%
    %Zyklus starten
    %Initialverteilung
    cycle_typ=1; %Zyklustyp festlegen: Stadt (1) Land (2) Autobahn (3)
                    % Wird weiter unten während dem Zyklus verändert
                    
    s_cycle=[1 0 0 0 0 0 0 0 0 0 0 0]; %Start in Zustand s1
    cycle_time=2; %Start bei Sekunde 2
    state=zeros(6,1);
    drive_data=zeros((1.5*cycle_time_limit),4);
    vel_low=0.1; %minimal Zyklusgeschwindigkeit

    %%
    %Zyklus Schleife
    while cycle_time<cycle_time_limit
        %s_cycle=s_cycle*p_matrix;
        %Aus Verteilung Zustand bestimmen, s_cycle für nächsten Durchlauf
        %setzen
        [ next_s,s_cycle_next] = distribution2state( s_cycle,state);
        %Nächsten Zustand in Zustandsvektor überführen
        state_next=zeros(6,1);
        state_next(1,1)=next_s;
        if(order_markov_chain>1)
            state_vector_2_order(p,1)=next_s; %Markov-Kette 2. Ordnung
            p=p+1; %Markov-Kette 2. Ordnung
        end
        %Relevante Matrix bestimmen
        [rel_mat_next_state] = select_rel_mat(state,state_next,rel_mat_struct,cycle_typ);
        %Randomisiertes Ziehen aus der relevanten Matrix
        [rel_mat_next_state_line] = rand_pullout(state_next,rel_mat_next_state);
        %Zustandsvektor bestimmen
        [state_next] = create_next_state_vector(state,state_next,rel_mat_next_state_line);
        %Mit Zustandsvektor Fahrprofil berechnen
        [ drive_data,cycle_time,state_next] = calculate_drivedata( state_next,drive_data,cycle_time,cycle_typ,vel_up_limit,vel_low,acc_up,acc_low,cycle_time_limit, veh_data);
        %Nächsten Zustand bestimmen und Zyklusende definieren
        if(cycle_time<(cycle_time_limit-50))
            if(order_markov_chain==1)
                s_cycle=s_cycle_next*p_matrix; %1. Ordnung
                step=1;
            else
                %2. Ordnung
                if(p<3)
                    s_cycle=[0 1 0 0 0 0 0 0 0 0 0 0];
                else
                    s_cycle_2_order=zeros(1,144);
                    place=((state_vector_2_order((p-2),1)-1)*12)+(state_vector_2_order(p-1,1));
                    s_cycle_2_order(1,place)=1;
                    s_cycle=s_cycle_2_order*p_matrix_2_order;
                end
                step=1;
            end
        elseif(step==1 && (cycle_time>=(cycle_time_limit-50)))
            s_cycle=[0 0 0 1 0 0 0 0 0 0 0 0];
            step=0;
            vel_low=1;
        elseif(step==0 && state_next(2,1)>=25)
            s_cycle=[0 0 0 0 1 0 0 0 0 0 0 0];
            vel_low=1;
        elseif(step==0 && state_next(2,1) < 25 && state_next(2,1)>3)
            s_cycle=[0 0 0 0 0 1 0 0 0 0 0 0];
        elseif(state_next(2,1)<=3)
            s_cycle=[0 0 0 0 0 0 0 0 0 0 0 1];
        end
        %Neuen Zustandsvektor als alten Speichern
        state=state_next;
         if(cycle_time>600 && cycle_time<=1200) %Nach 600 Sekunden von Stadt zu Land wechseln
             cycle_typ=2;
        elseif(cycle_time>1200) %Nach 1200 Sekunden von Land zu Autobahn wechseln
             cycle_typ=3;
        end

    end
    %%
    %Negative Geschwindigkeitspunkte zu null setzten
    drive_data=drive_data(1:cycle_time_limit,:);
    for k=1:cycle_time_limit
        if(drive_data(k,2)<0)
            drive_data(k,2)=0;
        end
    end
    %Beschleungiung aus Geschwindigkeitsprofil mit abspeichern
    drive_data(:,3)=calc_acc_out_vel(drive_data(:,2));
    %Fahrprofil in globaler Matrix speichern
    dc_cell(:,((i*4)+1)-4:(i*4))=drive_data;
    

    
    %Plot
%     if(i==1)
%         hold on
%     else
%         figure;
%     end
%     plot(drive_data(1:cycle_time_limit,1),drive_data(1:cycle_time_limit,2),'b');
%     xlabel 'Zykluszeit in s';
%     ylabel 'Fahrgeschwindigkeit in kmh';
%     title 'Driving Cycle';
%     hold off
      
end
if(order_markov_chain>1)
    p_matrix=p_matrix_2_order; %2. Ordnung
end
dc.speed=dc_cell(:,2)./3.6;
end

