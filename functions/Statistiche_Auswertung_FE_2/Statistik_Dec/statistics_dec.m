function [rel_mat_4_low_dec,rel_mat_5_low_dec,rel_mat_6_low_dec,...
    rel_mat_4_mid_dec,rel_mat_5_mid_dec,rel_mat_6_mid_dec,...
    rel_mat_4_high_dec,rel_mat_5_high_dec,rel_mat_6_high_dec] = statistics_dec(dec_global_komp,dec_global )
%Statistische Auswertung der Bremssequenzen und Bildung der relevanten
%Matrizen
%%
%In Stadt,Land,Autobahn einteilen
[ dec_low, dec_middle, dec_high,dec_global_komp,dec_global,dec_low_ex,dec_mid_ex,dec_high_ex ] = cluster_decceleration(dec_global_komp,dec_global);
%Unterzustände auslesen und abspeichern
%Low
[typ_4_low,typ_5_low,typ_6_low] = find_morestates_dec(dec_low,dec_low_ex);
%Mid
[typ_4_mid,typ_5_mid,typ_6_mid] = find_morestates_dec(dec_middle,dec_mid_ex);
%High
[typ_4_high,typ_5_high,typ_6_high] = find_morestates_dec(dec_high,dec_high_ex);

%%
%Relevante Matrizen bilden
[rel_mat_4_low_dec] = analytics_acc_class(typ_4_low,1);
[rel_mat_5_low_dec] = analytics_acc_class(typ_5_low,2);
[rel_mat_6_low_dec] = analytics_acc_class_typ36(typ_6_low);

[rel_mat_4_mid_dec] = analytics_acc_class(typ_4_mid,1);
[rel_mat_5_mid_dec] = analytics_acc_class(typ_5_mid,2);
[rel_mat_6_mid_dec] = analytics_acc_class_typ36(typ_6_mid);

[rel_mat_4_high_dec] = analytics_acc_class(typ_4_high,1);
[rel_mat_5_high_dec] = analytics_acc_class(typ_5_high,2);
[rel_mat_6_high_dec] = analytics_acc_class_typ36(typ_6_high);
end