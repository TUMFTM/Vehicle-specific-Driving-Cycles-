function [pen_global_komp_enh,global_state_vector,global_state_matrix] = morestates_pendeln(state_values_pendeln,global_state_matrix,pen_global_komp,global_state_vector)
%Weist den allgemeinen Pendelzuständen die entsprechenden Unterzustände zu
%%
%Unterzustände bestimmen
n=length(pen_global_komp);
pen_global_komp_enh=[pen_global_komp zeros(n,1)];
for i=1:n
   step=0;
   j=1;
   while step<1
       if(pen_global_komp(i,2)<= state_values_pendeln(j,4) && pen_global_komp(i,4)<=state_values_pendeln(j,2) )
           step=1;
           pen_global_komp_enh(i,7)=state_values_pendeln(j,5);
       else
           j=j+1;
       end
   end
end
%%
%Zustände in globale Zustandsmatrix  und globalen Zustandsvektor speichern
m=length(global_state_vector);
step_pen_enh=1;
i=1;
while i<=m
    if(global_state_vector(i,1)==7)
        t_seq=pen_global_komp_enh(step_pen_enh,2);
        global_state_vector(i:i+(t_seq-1))=pen_global_komp_enh(step_pen_enh,7);
        global_state_matrix(i:i+(t_seq-1),1)=pen_global_komp_enh(step_pen_enh,7);
        step_pen_enh=step_pen_enh+1;
        i=i+t_seq;
    else
        i=i+1;
    end
end
        

end

