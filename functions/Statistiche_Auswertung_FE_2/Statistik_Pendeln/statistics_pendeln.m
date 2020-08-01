function [state_values_pendeln,...
    rel_mat_class_1_low,rel_mat_class_2_low,rel_mat_class_3_low,rel_mat_class_4_low,rel_mat_class_5_low,...
    rel_mat_class_1_lowmid,rel_mat_class_2_lowmid,rel_mat_class_3_lowmid,rel_mat_class_4_lowmid,rel_mat_class_5_lowmid,...
    rel_mat_class_1_mid,rel_mat_class_2_mid,rel_mat_class_3_mid,rel_mat_class_4_mid,rel_mat_class_5_mid,...
    rel_mat_class_1_midhigh,rel_mat_class_2_midhigh,rel_mat_class_3_midhigh,rel_mat_class_4_midhigh,rel_mat_class_5_midhigh,...
    rel_mat_class_1_high,rel_mat_class_2_high,rel_mat_class_3_high,rel_mat_class_4_high,rel_mat_class_5_high...
    ] = statistics_pendeln(pen_global_komp)
%Unterzutände für Pendelvorgänge bestimmen
%Klassengrenzen und relevante Matrizen bilden

%Clustergrenzen Pendeln
vel_pen_cluster=[55 80 100 130]; %Geschwindigkeitsgrenzen der Unterteilung

%%
%Pendeln in Geschwindigkeitsklassen
[ pen_low, pen_lowmid, pen_middle, pen_midhigh, pen_high,vel_avg_low,vel_avg_lowmid,vel_avg_middle,vel_avg_midhigh ] = cluster_pendeln(pen_global_komp,vel_pen_cluster);

%Aufteilung plotten
%plot(pen_low(:,4),pen_low(:,2),'b+'); %Sequenzdauer über mittlerer Geschwindigkeit
%hold on
%plot(pen_lowmid(:,4),pen_low(:,2),'k+'); %Sequenzdauer über mittlerer Geschwindigkeit
%plot(pen_middle(:,4),pen_low(:,2),'r+'); %Sequenzdauer über mittlerer Geschwindigkeit
%plot(pen_midhigh(:,4),pen_low(:,2),'g+'); %Sequenzdauer über mittlerer Geschwindigkeit
%plot(pen_high(:,4),pen_low(:,2),'m+'); %Sequenzdauer über mittlerer Geschwindigkeit
%hold off
%%
%Zustandseinteilung innerhalb einer Geschwindigkeitsklasse
%Low
[output_pen_low,class_1_low,class_2_low,class_3_low,class_4_low,class_5_low] = classify_pendeln_frequency(pen_low);
%Low_mid
[output_pen_lowmid,class_1_lowmid,class_2_lowmid,class_3_lowmid,class_4_lowmid,class_5_lowmid ] = classify_pendeln_frequency(pen_lowmid);
%Mid
[output_pen_mid,class_1_mid,class_2_mid,class_3_mid,class_4_mid,class_5_mid ] = classify_pendeln_frequency(pen_middle);
%Mid-High
[output_pen_midhigh,class_1_midhigh,class_2_midhigh,class_3_midhigh,class_4_midhigh,class_5_midhigh ] = classify_pendeln_frequency(pen_midhigh);
%High
[output_pen_high,class_1_high,class_2_high,class_3_high,class_4_high,class_5_high ] = classify_pendeln_frequency(pen_high);

%%
%Ausgabe mit Klassengrenzen
state_values_pendeln=zeros(25,5);
state_values_pendeln(1:5,2)=vel_avg_low;
state_values_pendeln(6:10,1)=vel_avg_low+0.001;
state_values_pendeln(6:10,2)=vel_avg_lowmid;
state_values_pendeln(11:15,1)=vel_avg_lowmid+0.001;
state_values_pendeln(11:15,2)=vel_avg_middle;
state_values_pendeln(16:20,1)=vel_avg_middle+0.001;
state_values_pendeln(16:20,2)=vel_avg_midhigh;
state_values_pendeln(21:25,1)=vel_avg_midhigh+0.001;
state_values_pendeln(21:25,2)=inf;

state_values_pendeln(1:5,3:4)=output_pen_low(:,3:4);
state_values_pendeln(6:10,3:4)=output_pen_lowmid(:,3:4);
state_values_pendeln(11:15,3:4)=output_pen_mid(:,3:4);
state_values_pendeln(16:20,3:4)=output_pen_midhigh(:,3:4);
state_values_pendeln(21:25,3:4)=output_pen_high(:,3:4);
state_values_pendeln(1:5,5)=7:11; %Zustände
state_values_pendeln(6:10,5)=7:11;
state_values_pendeln(11:15,5)=7:11;
state_values_pendeln(16:20,5)=7:11;
state_values_pendeln(21:25,5)=7:11;

%%
%Relevante Matrizen bilden
%Low Bereich
[rel_mat_class_1_low ] = analytics_pen_class(class_1_low);
rel_mat_class_1_low(:,1)=vel_avg_low;
[rel_mat_class_2_low ] = analytics_pen_class(class_2_low);
rel_mat_class_2_low(:,1)=vel_avg_low;
[rel_mat_class_3_low ] = analytics_pen_class(class_3_low);
rel_mat_class_3_low(:,1)=vel_avg_low;
[rel_mat_class_4_low ] = analytics_pen_class(class_4_low);
rel_mat_class_4_low(:,1)=vel_avg_low;
[rel_mat_class_5_low ] = analytics_pen_class(class_5_low);
rel_mat_class_5_low(:,1)=vel_avg_low;
%Lowmid
[rel_mat_class_1_lowmid ] = analytics_pen_class(class_1_lowmid);
rel_mat_class_1_lowmid(:,1)=vel_avg_lowmid;
[rel_mat_class_2_lowmid ] = analytics_pen_class(class_2_lowmid);
rel_mat_class_2_lowmid(:,1)=vel_avg_lowmid;
[rel_mat_class_3_lowmid ] = analytics_pen_class(class_3_lowmid);
rel_mat_class_3_lowmid(:,1)=vel_avg_lowmid;
[rel_mat_class_4_lowmid ] = analytics_pen_class(class_4_lowmid);
rel_mat_class_4_lowmid(:,1)=vel_avg_lowmid;
[rel_mat_class_5_lowmid ] = analytics_pen_class(class_5_lowmid);
rel_mat_class_5_lowmid(:,1)=vel_avg_lowmid;
%Mid
[rel_mat_class_1_mid ] = analytics_pen_class(class_1_mid);
rel_mat_class_1_mid(:,1)=vel_avg_middle;
[rel_mat_class_2_mid ] = analytics_pen_class(class_2_mid);
rel_mat_class_2_mid(:,1)=vel_avg_middle;
[rel_mat_class_3_mid ] = analytics_pen_class(class_3_mid);
rel_mat_class_3_mid(:,1)=vel_avg_middle;
[rel_mat_class_4_mid ] = analytics_pen_class(class_4_mid);
rel_mat_class_4_mid(:,1)=vel_avg_middle;
[rel_mat_class_5_mid ] = analytics_pen_class(class_5_mid);
rel_mat_class_5_mid(:,1)=vel_avg_middle;
%MidHigh
[rel_mat_class_1_midhigh ] = analytics_pen_class(class_1_midhigh);
rel_mat_class_1_midhigh(:,1)=vel_avg_midhigh;
[rel_mat_class_2_midhigh ] = analytics_pen_class(class_2_midhigh);
rel_mat_class_2_midhigh(:,1)=vel_avg_midhigh;
[rel_mat_class_3_midhigh ] = analytics_pen_class(class_3_midhigh);
rel_mat_class_3_midhigh(:,1)=vel_avg_midhigh;
[rel_mat_class_4_midhigh ] = analytics_pen_class(class_4_midhigh);
rel_mat_class_4_midhigh(:,1)=vel_avg_midhigh;
[rel_mat_class_5_midhigh ] = analytics_pen_class(class_5_midhigh);
rel_mat_class_5_midhigh(:,1)=vel_avg_midhigh;
%High
[rel_mat_class_1_high ] = analytics_pen_class(class_1_high);
rel_mat_class_1_high(:,1)=inf;
[rel_mat_class_2_high] = analytics_pen_class(class_2_high);
rel_mat_class_2_high(:,1)=inf;
[rel_mat_class_3_high ] = analytics_pen_class(class_3_high);
rel_mat_class_3_high(:,1)=inf;
[rel_mat_class_4_high ] = analytics_pen_class(class_4_high);
rel_mat_class_4_high(:,1)=inf;
[rel_mat_class_5_high ] = analytics_pen_class(class_5_high);
rel_mat_class_5_high(:,1)=inf;

end

