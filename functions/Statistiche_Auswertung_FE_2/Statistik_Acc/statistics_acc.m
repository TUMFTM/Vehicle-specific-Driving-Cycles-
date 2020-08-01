function [rel_mat_1_low_acc,rel_mat_2_low_acc,rel_mat_3_low_acc,...
    rel_mat_1_mid_acc,rel_mat_2_mid_acc,rel_mat_3_mid_acc,...
    rel_mat_1_high_acc,rel_mat_2_high_acc,rel_mat_3_high_acc] = statistics_acc(acc_global_komp,acc_global)
%Statistische Auswertung der Beschleunigungssequenzen und Bildung der relevanten
%Matrizen
%%
%In Stadt,Land,Autobahn einteilen
[ acc_low, acc_mid, acc_high,acc_global_komp,acc_global,acc_low_ex,acc_mid_ex,acc_high_ex] = cluster_acceleration(acc_global_komp,acc_global);

%Unterzustände auslesen und abspeichern
%Low
[typ_1_low,typ_2_low,typ_3_low] = find_morestates_acc(acc_low,acc_low_ex);
%Mid
[typ_1_mid,typ_2_mid,typ_3_mid] = find_morestates_acc(acc_mid,acc_mid_ex);
%High
[typ_1_high,typ_2_high,typ_3_high] = find_morestates_acc(acc_high,acc_high_ex);
%%
%Relevante Matrizen bilden
[rel_mat_1_low_acc] = analytics_acc_class(typ_1_low,1);
[rel_mat_2_low_acc] = analytics_acc_class(typ_2_low,2);
[rel_mat_3_low_acc] = analytics_acc_class_typ36(typ_3_low);

[rel_mat_1_mid_acc] = analytics_acc_class(typ_1_mid,1);
[rel_mat_2_mid_acc] = analytics_acc_class(typ_2_mid,2);
[rel_mat_3_mid_acc] = analytics_acc_class_typ36(typ_3_mid);

[rel_mat_1_high_acc] = analytics_acc_class(typ_1_high,1);
[rel_mat_2_high_acc] = analytics_acc_class(typ_2_high,2);
[rel_mat_3_high_acc] = analytics_acc_class_typ36(typ_3_high);
end

