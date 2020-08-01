function [typ_1,typ_2,typ_3] = find_morestates_dec(mat_komp,mat_ex)
%Auslesen der Unterzustände aus den Beschleunigungssequenzen für ein
%Geschwindigkeitsbereich
[length_komp,x]=size(mat_komp);
[length_ex,y]=size(mat_ex);
typ_1=zeros(length_ex,5);
typ_2=zeros(length_ex,5);
typ_3=zeros(length_ex,5);
typ_1_step=1;
typ_2_step=1;
typ_3_step=1;
j=1;
for i=1:length_komp
    t_seq=mat_komp(i,2);
    current_mat=mat_ex(j:j+t_seq-1,:);
    %In dieser Matrix nach den Unterzuständen suchen
    %l_c_m=length(current_mat);
    l_c_m=t_seq;
    step=1;
    length_seq=1;
    while step<l_c_m
        
        if(current_mat(step,3)==current_mat(step+1,3) && current_mat(step,3)~=0)
            length_seq=length_seq+1;
            step=step+1;
            variabel=0;
        elseif(current_mat(step,3)==0) %Unmatched Zustände rausnehmen
            step=step+1;
            variabel=0;

        else
            variabel=1;
        end
        if(l_c_m-step==0)
            variabel=1;
        end
        if(variabel==1) %Squenz zu Ende
            %Welcher Typ Sequenz
            if(current_mat(step,3)==4)
                typ_1(typ_1_step:typ_1_step+length_seq-1,1:4)=current_mat(step-(length_seq-1):step,1:4);
                typ_1(typ_1_step,5)=length_seq;
                typ_1_step=typ_1_step+length_seq;
            elseif(current_mat(step,3)==5)
                typ_2(typ_2_step:typ_2_step+length_seq-1,1:4)=current_mat(step-(length_seq-1):step,1:4);
                typ_2(typ_2_step,5)=length_seq;
                typ_2_step=typ_2_step+length_seq;
            else
                typ_3(typ_3_step:typ_3_step+length_seq-1,1:4)=current_mat(step-(length_seq-1):step,1:4);
                typ_3(typ_3_step,5)=length_seq;
                typ_3_step=typ_3_step+length_seq;
            end
            length_seq=1;
            step=step+1;
        end
    end
            
    
    
    %Zähler erhöhen
    j=j+t_seq;
end

end