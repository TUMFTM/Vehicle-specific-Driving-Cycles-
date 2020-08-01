function [state_changes,number_statechange,p_matrix] = generate_p(global_state_vector)
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
p_matrix=zeros(12,12);
for j=1:12
    number_change=0;
    for i=1:number_statechange
       if(state_changes(i,1)==j && state_changes(i,2)==1)
           p_matrix(j,1)=p_matrix(j,1)+1;
           number_change=number_change+1;
       elseif(state_changes(i,1)==j && state_changes(i,2)==2)
           p_matrix(j,2)=p_matrix(j,2)+1;
           number_change=number_change+1;
       elseif(state_changes(i,1)==j && state_changes(i,2)==3)
           p_matrix(j,3)=p_matrix(j,3)+1;
           number_change=number_change+1;
       elseif(state_changes(i,1)==j && state_changes(i,2)==4)
           p_matrix(j,4)=p_matrix(j,4)+1;
           number_change=number_change+1;
       elseif(state_changes(i,1)==j && state_changes(i,2)==5)
           p_matrix(j,5)=p_matrix(j,5)+1;
           number_change=number_change+1;
       elseif(state_changes(i,1)==j && state_changes(i,2)==6)
           p_matrix(j,6)=p_matrix(j,6)+1;
           number_change=number_change+1;
       elseif(state_changes(i,1)==j && state_changes(i,2)==7)
           p_matrix(j,7)=p_matrix(j,7)+1;
           number_change=number_change+1;
       elseif(state_changes(i,1)==j && state_changes(i,2)==8)
           p_matrix(j,8)=p_matrix(j,8)+1;
           number_change=number_change+1;
       elseif(state_changes(i,1)==j && state_changes(i,2)==9)
           p_matrix(j,9)=p_matrix(j,9)+1;
           number_change=number_change+1;
       elseif(state_changes(i,1)==j && state_changes(i,2)==10)
           p_matrix(j,10)=p_matrix(j,10)+1;
           number_change=number_change+1;
       elseif(state_changes(i,1)==j && state_changes(i,2)==11)
           p_matrix(j,11)=p_matrix(j,11)+1;
           number_change=number_change+1;
       elseif(state_changes(i,1)==j && state_changes(i,2)==12)
           p_matrix(j,12)=p_matrix(j,12)+1;
           number_change=number_change+1;
       end
    end
    %relative Häufigkeit in Zeile j bilden
    p_matrix(j,:)=p_matrix(j,:)./number_change;
end

end

