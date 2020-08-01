function [state_changes,number_statechange,p_matrix] = generate_p_2_order(global_state_vector)
%Ableitung der Zustandsübergangsmatrix
n=length(global_state_vector);
number_statechange=0;
state_changes=zeros(n,2);
%%
%Zustandsübergange erkennen
for i=2:n-1
    if(global_state_vector(i)~=0 && global_state_vector(i+1)~=0 && global_state_vector(i)~=global_state_vector(i+1))
        number_statechange=number_statechange+1;
        state_changes(number_statechange,1)=global_state_vector(i);
        state_changes(number_statechange,2)=global_state_vector(i+1);
    end
end
%%
%Übergangsmatrix
p_matrix=zeros(144,12);
s=1;
for k=1:12
    for j=1:12
        number_change=0;
        for i=2:number_statechange
           if(state_changes(i-1,1)==k && state_changes(i,1)==j && state_changes(i,2)==1 && state_changes(i-1,2)==state_changes(i,1))
               p_matrix(s,1)=p_matrix(s,1)+1;
               number_change=number_change+1;
           elseif(state_changes(i-1,1)==k && state_changes(i,1)==j && state_changes(i,2)==2 && state_changes(i-1,2)==state_changes(i,1))
               p_matrix(s,2)=p_matrix(s,2)+1;
               number_change=number_change+1;
           elseif(state_changes(i-1,1)==k && state_changes(i,1)==j && state_changes(i,2)==3 && state_changes(i-1,2)==state_changes(i,1))
               p_matrix(s,3)=p_matrix(s,3)+1;
               number_change=number_change+1;
           elseif(state_changes(i-1,1)==k && state_changes(i,1)==j && state_changes(i,2)==4 && state_changes(i-1,2)==state_changes(i,1))
               p_matrix(s,4)=p_matrix(s,4)+1;
               number_change=number_change+1;
           elseif(state_changes(i-1,1)==k && state_changes(i,1)==j && state_changes(i,2)==5 && state_changes(i-1,2)==state_changes(i,1))
               p_matrix(s,5)=p_matrix(s,5)+1;
               number_change=number_change+1;
           elseif(state_changes(i-1,1)==k && state_changes(i,1)==j && state_changes(i,2)==6 && state_changes(i-1,2)==state_changes(i,1))
               p_matrix(s,6)=p_matrix(s,6)+1;
               number_change=number_change+1;
           elseif(state_changes(i-1,1)==k && state_changes(i,1)==j && state_changes(i,2)==7 && state_changes(i-1,2)==state_changes(i,1))
               p_matrix(s,7)=p_matrix(s,7)+1;
               number_change=number_change+1;
           elseif(state_changes(i-1,1)==k && state_changes(i,1)==j && state_changes(i,2)==8 && state_changes(i-1,2)==state_changes(i,1))
               p_matrix(s,8)=p_matrix(s,8)+1;
               number_change=number_change+1;
           elseif(state_changes(i-1,1)==k && state_changes(i,1)==j && state_changes(i,2)==9 && state_changes(i-1,2)==state_changes(i,1))
               p_matrix(s,9)=p_matrix(s,9)+1;
               number_change=number_change+1;
           elseif(state_changes(i-1,1)==k && state_changes(i,1)==j && state_changes(i,2)==10 && state_changes(i-1,2)==state_changes(i,1))
               p_matrix(s,10)=p_matrix(s,10)+1;
               number_change=number_change+1;
           elseif(state_changes(i-1,1)==k && state_changes(i,1)==j && state_changes(i,2)==11 && state_changes(i-1,2)==state_changes(i,1))
               p_matrix(s,11)=p_matrix(s,11)+1;
               number_change=number_change+1;
           elseif(state_changes(i-1,1)==k && state_changes(i,1)==j && state_changes(i,2)==12 && state_changes(i-1,2)==state_changes(i,1))
               p_matrix(s,12)=p_matrix(s,12)+1;
               number_change=number_change+1;
           end
        end
    %relative Häufigkeit in Zeile j bilden
    if(number_change==0)
        p_matrix(s,:)=0;
    else
        p_matrix(s,:)=p_matrix(s,:)./number_change;
    end
    s=s+1;
    end
end

end