function [result_matrix] = search_cv_values(number_cycles,vehicle_class)
%Sucht Werte für Bewertungsparameter für Zyklus
acc_number=zeros(number_cycles,1);
acc_high_number=zeros(number_cycles,1);
dec_high_number=zeros(number_cycles,1);
accpos_mean=zeros(number_cycles,1);
accneg_mean=zeros(number_cycles,1);
vmax=zeros(number_cycles,1);
vavg=zeros(number_cycles,1);
accmax=zeros(number_cycles,1);
decmax=zeros(number_cycles,1);
neutral_percentage=zeros(number_cycles,1);
vel_high_number=zeros(number_cycles,1);

for i=1:number_cycles
    [dc_cell, cycle_analytics_result] = comp_dc(vehicle_class);
    acc_number(i,1)=cycle_analytics_result.acc_number;
    acc_high_number(i,1)=cycle_analytics_result.acc_high_number;
    dec_high_number(i,1)=cycle_analytics_result.dec_high_number;
    accpos_mean(i,1)=cycle_analytics_result.accpos_mean;
    accneg_mean(i,1)=cycle_analytics_result.accneg_mean;
    vmax(i,1)=cycle_analytics_result.vmax;
    vavg(i,1)=cycle_analytics_result.vavg;
    accmax(i,1)=cycle_analytics_result.accmax;
    decmax(i,1)=cycle_analytics_result.decmax;
    neutral_percentage(i,1)=cycle_analytics_result.neutral_percentage;
    vel_high_number(i,1)=cycle_analytics_result.vel_high_number;
    i
end
result_matrix.acc_number=acc_number;
result_matrix.acc_high_number=acc_high_number;
result_matrix.dec_high_number=dec_high_number;
result_matrix.accpos_mean=accpos_mean;
result_matrix.accneg_mean=accneg_mean;
result_matrix.vmax=vmax;
result_matrix.vavg=vavg;
result_matrix.accmax=accmax;
result_matrix.decmax=decmax;
result_matrix.neutral_percentage=neutral_percentage;
result_matrix.vel_high_number=vel_high_number;
