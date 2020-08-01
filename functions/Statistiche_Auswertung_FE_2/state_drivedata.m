function [unmatched_sum,pen_global,pen_global_komp,global_state_vector,global_state_matrix,acc_global,dec_global,acc_global_komp,dec_global_komp,rel_mat] = state_drivedata( )
%Zustandszuweisung und Bildung der relvanten Matrizen
% table='filenames.xls';
% [num,str]=xlsread(table,'A:A');
% number_files=length(str);
addpath(genpath('data'));
files=dir('data');
names={files.name};
number_files=length(names);
unmatched_sum=zeros(number_files,2);
%sum_meter=0;
%sum_seconds=0;
for i=3:number_files
    %fileload=char(str(i));
    fileload=char(names{i});
    struct=load(fileload);
    cell_data=struct2cell(struct);
    tvd_file=cell_data{2};
    tvd_file=table2array(tvd_file(:,3));
    %sum_meter=sum_meter+(sum(tvd_file));
    %sum_seconds=sum_seconds+length(tvd_file);
    
    %in kmh
    tvd_file=tvd_file.*3.6;
    %% Zustandszuweisung
    %Globale Zustandszuweisung: Beschleunigung|Bremsen|Pendeln|Leerlauf
    [ pre_state,state_general,unmatched_state,pendeln_safe,acc,dec,vel_kmh,acc_ms2,idle] = prestate_drivesequence(tvd_file);
    unmatched_sum(i,1)=unmatched_state;
    
    unmatched_sum(i,2)=length(acc_ms2);
    %% Sequenzen aus Fahrdaten extrahieren
    %Sequenzen suchen
    %Beschleunigung
    %Vorverarbeitung Beschleunigen
    [ acc ] = prework_acc(acc,state_general,1);
    [ seq_length_acc,k_acc,sequences_acc,sequences_komp_acc ] = find_sequences(acc, vel_kmh,acc_ms2,1); %1 für Beschleunigung
    %Bremsen
    %Vorverarbeitung Bremsen
    [ dec ] = prework_acc(dec,state_general,2);
    [ seq_length_dec,k_dec,sequences_dec,sequences_komp_dec ] = find_sequences(dec, vel_kmh,acc_ms2,2); %2 für Bremsen
    %Pendeln
    %Vorverarbeitung Pendeln
    [ pendeln ] = prework_pendeln(pendeln_safe,state_general);
    [ seq_length_pen,k_pen,sequences_pen,sequences_komp_pen ] = find_sequences(pendeln, vel_kmh,acc_ms2,3); %3 für Pendeln
    %Leerlauf
    %Vorverarbeitung Leerlauf
    [ idle ] = prework_idle(idle,state_general);
    [ seq_length_idle,k_idle,sequences_idle,sequences_komp_idle ] = find_sequences(idle, vel_kmh,acc_ms2,3);
    %% Unterzustände
    %Unterzustände für Beschleunigung
    [ sequences_acc_classified ] = classify_acc(sequences_acc, sequences_komp_acc);
    %Unterzustände für Bremsen
    [ sequences_dec_classified ] = classify_dec(sequences_dec, sequences_komp_dec);
    %% Unterzustände
    %Unterzustände in globalen Zustandsvektor überführen
    typ=1;
    [pre_state,state_general] = morestates(pre_state, state_general,sequences_acc_classified,typ);
    typ=2;
    [pre_state,state_general] = morestates(pre_state, state_general,sequences_dec_classified,typ);
    %% Globale Matrizen
    %Globale Pendel-Matrix aufbauen für weitere statistische Analyse
    %Globaler Zustandsvektor aufbauen
    
    if(i==3)
        pen_global=sequences_pen;
        pen_global_komp=sequences_komp_pen;
        global_state_vector=state_general;
        global_state_matrix=[state_general vel_kmh];
        acc_global=sequences_acc_classified;
        acc_global_komp=sequences_komp_acc;
        dec_global=sequences_dec_classified;
        dec_global_komp=sequences_komp_dec;
        idle_global_komp=sequences_komp_idle;

    else
         pen_global=[pen_global; sequences_pen];
         pen_global_komp=[pen_global_komp; sequences_komp_pen];
         global_state_vector=[global_state_vector; 0; state_general];
         global_state_matrix=[global_state_matrix; 0 0; state_general vel_kmh];
         acc_global=[acc_global; sequences_acc_classified];
         acc_global_komp=[acc_global_komp; sequences_komp_acc];
         dec_global=[dec_global; sequences_dec_classified];
         dec_global_komp=[dec_global_komp; sequences_komp_dec];
         idle_global_komp=[idle_global_komp; sequences_komp_idle];
    end
  
    
    
end
%% Pendeln
%Relevante Matrizen Pendeln
[state_values_pendeln,...
    rel_mat_class_7_low,rel_mat_class_8_low,rel_mat_class_9_low,rel_mat_class_10_low,rel_mat_class_11_low,...
    rel_mat_class_7_lowmid,rel_mat_class_8_lowmid,rel_mat_class_9_lowmid,rel_mat_class_10_lowmid,rel_mat_class_11_lowmid,...
    rel_mat_class_7_mid,rel_mat_class_8_mid,rel_mat_class_9_mid,rel_mat_class_10_mid,rel_mat_class_11_mid,...
    rel_mat_class_7_midhigh,rel_mat_class_8_midhigh,rel_mat_class_9_midhigh,rel_mat_class_10_midhigh,rel_mat_class_11_midhigh,...
    rel_mat_class_7_high,rel_mat_class_8_high,rel_mat_class_9_high,rel_mat_class_10_high,rel_mat_class_11_high...
    ] = statistics_pendeln(pen_global_komp);
%Unterzustände Pendeln zuweisen
[pen_global_komp_enh,global_state_vector,global_state_matrix] = morestates_pendeln(state_values_pendeln,global_state_matrix,pen_global_komp,global_state_vector);

%% Beschleunigung
%Relevante Matrizen Beschleunigen
[rel_mat_1_low_acc,rel_mat_2_low_acc,rel_mat_3_low_acc,...
    rel_mat_1_mid_acc,rel_mat_2_mid_acc,rel_mat_3_mid_acc,...
    rel_mat_1_high_acc,rel_mat_2_high_acc,rel_mat_3_high_acc] = statistics_acc(acc_global_komp,acc_global);
%% Bremsen
%Relevante Matrizen Bremsen
[rel_mat_4_low_dec,rel_mat_5_low_dec,rel_mat_6_low_dec,...
    rel_mat_4_mid_dec,rel_mat_5_mid_dec,rel_mat_6_mid_dec,...
    rel_mat_4_high_dec,rel_mat_5_high_dec,rel_mat_6_high_dec] = statistics_dec(dec_global_komp,dec_global );

%%

%% Bildung rel mat
%relevante Matrizen in Struct abspeichern
%Beschleunigung
rel_mat.low_s1=rel_mat_1_low_acc;
rel_mat.low_s2=rel_mat_2_low_acc;
rel_mat.low_s3=rel_mat_3_low_acc;
rel_mat.mid_s1=rel_mat_1_mid_acc;
rel_mat.mid_s2=rel_mat_2_mid_acc;
rel_mat.mid_s3=rel_mat_3_mid_acc;
rel_mat.high_s1=rel_mat_1_high_acc;
rel_mat.high_s2=rel_mat_2_high_acc;
rel_mat.high_s3=rel_mat_3_high_acc;
%Bremsen
rel_mat.low_s4=rel_mat_4_low_dec;
rel_mat.low_s5=rel_mat_5_low_dec;
rel_mat.low_s6=rel_mat_6_low_dec;
rel_mat.mid_s4=rel_mat_4_mid_dec;
rel_mat.mid_s5=rel_mat_5_mid_dec;
rel_mat.mid_s6=rel_mat_6_mid_dec;
rel_mat.high_s4=rel_mat_4_high_dec;
rel_mat.high_s5=rel_mat_5_high_dec;
rel_mat.high_s6=rel_mat_6_high_dec;
%Pendeln
rel_mat.low_s7=rel_mat_class_7_low;
rel_mat.low_s8=rel_mat_class_8_low;
rel_mat.low_s9=rel_mat_class_9_low;
rel_mat.low_s10=rel_mat_class_10_low;
rel_mat.low_s11=rel_mat_class_11_low;
rel_mat.lowmid_s7=rel_mat_class_7_lowmid;
rel_mat.lowmid_s8=rel_mat_class_8_lowmid;
rel_mat.lowmid_s9=rel_mat_class_9_lowmid;
rel_mat.lowmid_s10=rel_mat_class_10_lowmid;
rel_mat.lowmid_s11=rel_mat_class_11_lowmid;
rel_mat.mid_s7=rel_mat_class_7_mid;
rel_mat.mid_s8=rel_mat_class_8_mid;
rel_mat.mid_s9=rel_mat_class_9_mid;
rel_mat.mid_s10=rel_mat_class_10_mid;
rel_mat.mid_s11=rel_mat_class_11_mid;
rel_mat.midhigh_s7=rel_mat_class_7_midhigh;
rel_mat.midhigh_s8=rel_mat_class_8_midhigh;
rel_mat.midhigh_s9=rel_mat_class_9_midhigh;
rel_mat.midhigh_s10=rel_mat_class_10_midhigh;
rel_mat.midhigh_s11=rel_mat_class_11_midhigh;
rel_mat.high_s7=rel_mat_class_7_high;
rel_mat.high_s8=rel_mat_class_8_high;
rel_mat.high_s9=rel_mat_class_9_high;
rel_mat.high_s10=rel_mat_class_10_high;
rel_mat.high_s11=rel_mat_class_11_high;
end
