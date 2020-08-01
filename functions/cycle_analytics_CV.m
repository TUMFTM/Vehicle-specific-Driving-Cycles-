function [cycle_analytics_result,CV] = cycle_analytics_CV(dc_cell,vel_up_limit,acc_up,acc_low,veh_data,cv_values)
%Analyse des Fahrzyklus, sowie Klassifizierung des Zyklus anhand des CV
%Wertes

veh_mass=veh_data(1,1);
veh_a_st=veh_data(2,1);
veh_cw=veh_data(3,1);
veh_power=veh_data(4,1);
n_mot_wheel=veh_data(5,1);
c_r=veh_data(6,1);
roh_l=1.2;
gravity=9.81;


[n,m]=size(dc_cell);
dc_acc_max=zeros(n,1);

%Maximal Mögliche Bescheunigung in jedem Punkt berechnen
for i=1:n
    f_t=3600*n_mot_wheel*veh_power/dc_cell(i,2);
    resistance=(0.5*roh_l*veh_cw*veh_a_st*((dc_cell(i,2)/3.6)^2))+(veh_mass*c_r*gravity);
    acc_max=(f_t-resistance)/veh_mass;
    dc_acc_max(i,1)=min(acc_max,acc_up);
end

neutral=0;
acc_number=0;
acc_high_number=0;
acc_low_number=0;
vel_high_number=0;
not_acc_number=0;
for i=1:n
    %% Leerlaufanteil 
    if(dc_cell(i,2)<1)
        neutral=neutral+1;
    end
    %% Anzahl Beschleunigungszuständen
    if(dc_cell(i,4)>0 && dc_cell(i,4)<4)
        acc_number=acc_number+1;
    elseif(dc_cell(i,4)>0)
        not_acc_number=not_acc_number+1;
    end
    %% Anzahl an hohen Beschleunigungen
    if(dc_cell(i,3)>(0.7*dc_acc_max(i,1)))
        acc_high_number=acc_high_number+1;
    end
    %% Anzahl hoher Bremsungen
    if(dc_cell(i,3)<(0.70*acc_low))
        acc_low_number=acc_low_number+1;
    end
    %% Anteil an hohen Geschwindigkeiten
    if(dc_cell(i,2)>(0.80*vel_up_limit))
        vel_high_number=vel_high_number+1;
    end
end
neutral_percentage=neutral/n;
acc_number_perc=acc_number/(acc_number+not_acc_number); %Anteil an Beschleunigungszuständen
cycle_analytics_result.acc_number=acc_number_perc; %Anteil an Beschleunigungszuständen
cycle_analytics_result.acc_high_number=acc_high_number/n; %Anteil an hohen Beschleunigungen (70% von max)
cycle_analytics_result.dec_high_number=acc_low_number/n; %Anteil an hohen Bremsungen (70% von max)
cycle_analytics_result.vel_high_number=vel_high_number/n; %Anteil an hohen Fahrgeschwindigkeiten (80% von max)
%% Mittlere Beschleunigung und Verzögerungen bestimmen
pos=0;
n_pos=0;
dec=0;
n_dec=0;

for i=1:n
    if(dc_cell(i,3)>0)
        pos=pos+dc_cell(i,3);
        n_pos=n_pos+1;
    elseif(dc_cell(i,3)<0)
        dec=dec+dc_cell(i,3);
        n_dec=n_dec+1;
    end
end
mean_accpos=pos/n_pos;
mean_accneg=dec/n_dec;

cycle_analytics_result.accpos_mean=mean_accpos/acc_up; %Verhältnis mittlere zu maximaler Beschleunigung
cycle_analytics_result.accneg_mean=mean_accneg/acc_low; %Verhältnis mittlere zu maximaler Verzögerung
        
%% Zykluswerte
cycle_analytics_result.vmax=max(dc_cell(:,2))/vel_up_limit; %maximale Zyklusgeschwindigkeit in %
cycle_analytics_result.vavg=mean(dc_cell(:,2))/vel_up_limit; %mittlere Zyklusbeschleunigung in % von max
cycle_analytics_result.accmax=max(dc_cell(:,3))/acc_up; %maximale Zyklusbeschleunigung in % von max Wert
cycle_analytics_result.decmax=min(dc_cell(:,3))/acc_low; %maximale Zyklusverzögerung in %von max Wert
cycle_analytics_result.neutral_percentage=neutral_percentage; %Leerlaufanteil


%% CV berechnen
%vavg
vavg_dc=cycle_analytics_result.vavg;
cv_1=1+(9/(cv_values.vavg(1,1)-cv_values.vavg(1,2))*((vavg_dc)-cv_values.vavg(1,2)));
%acc_high_number
cv_2=1+(9/(cv_values.acc_high_number(1,1)-cv_values.acc_high_number(1,2))*((cycle_analytics_result.acc_high_number)-cv_values.acc_high_number(1,2)));
%neutral_percentage
cv_3=1+(9/(cv_values.neutral_percentage(1,1)-cv_values.neutral_percentage(1,2))*((neutral_percentage)-cv_values.neutral_percentage(1,2)));
%dec_high_number
cv_4=1+(9/(cv_values.dec_high_number(1,1)-cv_values.dec_high_number(1,2))*((cycle_analytics_result.dec_high_number)-cv_values.dec_high_number(1,2)));
%acc_number
cv_5=1+(9/(cv_values.acc_number(1,1)-cv_values.acc_number(1,2))*((cycle_analytics_result.acc_number)-cv_values.acc_number(1,2)));

CV_sum=cv_1+cv_2+cv_3+cv_4+cv_5;
CV=(10/(50))*(CV_sum); %CV Wert zwischen 0 und 10 ausgeben

%% Zyklus Plotten
plot(dc_cell(:,2))
title 'Komprimierter Fahrzyklus erster Ordnung';
xlabel 'Zykluszeit in s';
ylabel 'Fahrgeschwindigkeit in km/h'

end
