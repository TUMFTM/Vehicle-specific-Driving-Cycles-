function [dc,dc_cell, cycle_analytics_result,CV,p_matrix,rel_mat_struct] = comp_dc(vehicle_class,order_markov_chain)

%% Fahrzyklus berechnen
[ drive_data,p_matrix,rel_mat_struct,dc_cell,unmatched_sum,dc,vel_up_limit,acc_up,acc_low,veh_data] = create_cycle(vehicle_class,order_markov_chain);


%% Farzyklus analysieren
load('cv_values.mat');
[cycle_analytics_result,CV] = cycle_analytics_CV(dc_cell,vel_up_limit,acc_up,acc_low,veh_data,cv_values);

%% Struct ablegen
dc.time=dc_cell(:,1);
dc.speed=dc_cell(:,2);
dc.acceleration=dc_cell(:,4);

%% Plots
%Beschleunigungszustände S1-S3 (Länge der relevanten Matrix beachten)
%bar(1:15,rel_mat_struct.low_s1(:,1)) %Verteilung (S1,S2,S3)
%plot(1:15,rel_mat_struct.low_s1(:,2),'+') %Startbeschleunigung S1
%plot(1:15,rel_mat_struct.low_s2(:,3),'+') %Sequenzdauer S2
%plot(1:15,rel_mat_struct.low_s3(:,4),'+') %Skalierung S3

%Verzögerungszustände S4-S6 (Länge der relevanten Matrix beachten)
%bar(1:15,rel_mat_struct.low_s4(:,1)) %Verteilung
%plot(1:15,rel_mat_struct.low_s4(:,2),'+') %Startverzögerung
%plot(1:15,rel_mat_struct.low_s5(:,2),'+') %Sequenzdauer
%plot(1:15,rel_mat_struct.low_s6(:,4),'+') %Skalierung

%Pendelzustände S7-S11 (Länge der relevanten Matrix beachten)
%bar(1:9,rel_mat_struct.low_s7(:,3)) %Verteilung
%plot(1:9,rel_mat_struct.low_s7(:,2),'+') %Sequenzdauer
%plot(1:9,rel_mat_struct.low_s7(:,4),'+') %Beschleunigungsgrenze positiv
%plot(1:9,rel_mat_struct.low_s7(:,5),'+') %Beschleuigungsgrenze negativ
end

