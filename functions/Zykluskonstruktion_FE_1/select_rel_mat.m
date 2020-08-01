function [rel_mat_next_state] = select_rel_mat(state,state_next,rel_mat_struct,cycle_typ)
%Wählt anhand des nächsten Zustandes die relevante Matrix aus
%Geschwindigkeitsbereiche für Beschleunigen und Bremsen

%Cycle_typ=1: Stadt
%Cycle_typ=2: Land
%Cycle_typ=3: Autobahn

acc_dec_low=65;
acc_dec_mid=110;
%Geschwindigkeitsbereich Pendeln
pen_border_low=rel_mat_struct.low_s7(1,1);
pen_border_lowmid=rel_mat_struct.lowmid_s7(1,1);
pen_border_mid=rel_mat_struct.mid_s7(1,1);
pen_border_midhigh=rel_mat_struct.midhigh_s7(1,1);

%relevante Matrix suchen
current_vel=state(2,1);
new_state=state_next(1,1);

if(new_state<4) %Beschleunigen
    if(cycle_typ==1) %Stadt Zyklus
        if(new_state==1)
            rel_mat_next_state=rel_mat_struct.low_s1;
        elseif(new_state==2)
            rel_mat_next_state=rel_mat_struct.low_s2;
        else
            rel_mat_next_state=rel_mat_struct.low_s3;
        end
    elseif(cycle_typ==2) %Land-Zyklus
        if(new_state==1) 
            rel_mat_next_state=rel_mat_struct.mid_s1;
        elseif(new_state==2)
            rel_mat_next_state=rel_mat_struct.mid_s2;
        else
            rel_mat_next_state=rel_mat_struct.mid_s3;
        end
    else %Autobahn Zyklus
        if(new_state==1)
            rel_mat_next_state=rel_mat_struct.high_s1;
        elseif(new_state==2)
            rel_mat_next_state=rel_mat_struct.high_s2;
        else
            rel_mat_next_state=rel_mat_struct.high_s3;
        end
    end
elseif(new_state<7) %Bremsen
    if(current_vel<=acc_dec_low)
        if(new_state==4)
            rel_mat_next_state=rel_mat_struct.low_s4;
        elseif(new_state==5)
            rel_mat_next_state=rel_mat_struct.low_s5;
        else
            rel_mat_next_state=rel_mat_struct.low_s6;
        end
    elseif(current_vel<=acc_dec_mid)
        if(new_state==4)
            rel_mat_next_state=rel_mat_struct.mid_s4;
        elseif(new_state==5)
            rel_mat_next_state=rel_mat_struct.mid_s5;
        else
            rel_mat_next_state=rel_mat_struct.mid_s6;
        end
    else
        if(new_state==4)
            rel_mat_next_state=rel_mat_struct.high_s4;
        elseif(new_state==5)
            rel_mat_next_state=rel_mat_struct.high_s5;
        else
            rel_mat_next_state=rel_mat_struct.high_s6;
        end
    end
elseif(new_state<12)%Pendel-Zustand
    if(current_vel<=pen_border_low)
        if(new_state==7)
            rel_mat_next_state=rel_mat_struct.low_s7;
        elseif(new_state==8)
            rel_mat_next_state=rel_mat_struct.low_s8;
        elseif(new_state==9)
            rel_mat_next_state=rel_mat_struct.low_s9;
        elseif(new_state==10)
            rel_mat_next_state=rel_mat_struct.low_s10;
        else
            rel_mat_next_state=rel_mat_struct.low_s11;
        end
    elseif(current_vel<=pen_border_lowmid)
        if(new_state==7)
            rel_mat_next_state=rel_mat_struct.lowmid_s7;
        elseif(new_state==8)
            rel_mat_next_state=rel_mat_struct.lowmid_s8;
        elseif(new_state==9)
            rel_mat_next_state=rel_mat_struct.lowmid_s9;
        elseif(new_state==10)
            rel_mat_next_state=rel_mat_struct.lowmid_s10;
        else
            rel_mat_next_state=rel_mat_struct.lowmid_s11;
        end
    elseif(current_vel<=pen_border_mid)
        if(new_state==7)
            rel_mat_next_state=rel_mat_struct.mid_s7;
        elseif(new_state==8)
            rel_mat_next_state=rel_mat_struct.mid_s8;
        elseif(new_state==9)
            rel_mat_next_state=rel_mat_struct.mid_s9;
        elseif(new_state==10)
            rel_mat_next_state=rel_mat_struct.mid_s10;
        else
            rel_mat_next_state=rel_mat_struct.mid_s11;
        end
    elseif(current_vel<=pen_border_midhigh)
        if(new_state==7)
            rel_mat_next_state=rel_mat_struct.midhigh_s7;
        elseif(new_state==8)
            rel_mat_next_state=rel_mat_struct.midhigh_s8;
        elseif(new_state==9)
            rel_mat_next_state=rel_mat_struct.midhigh_s9;
        elseif(new_state==10)
            rel_mat_next_state=rel_mat_struct.midhigh_s10;
        else
            rel_mat_next_state=rel_mat_struct.midhigh_s11;
        end
    else
        if(new_state==7)
            rel_mat_next_state=rel_mat_struct.high_s7;
        elseif(new_state==8)
            rel_mat_next_state=rel_mat_struct.high_s8;
        elseif(new_state==9)
            rel_mat_next_state=rel_mat_struct.high_s9;
        elseif(new_state==10)
            rel_mat_next_state=rel_mat_struct.high_s10;
        else
            rel_mat_next_state=rel_mat_struct.high_s11;
        end
    end
else %Leerlauf
    time=[1:1:90];
    cycle_time_ll=randsample(time,1);
    rel_mat_next_state=[0 cycle_time_ll];
end

end

