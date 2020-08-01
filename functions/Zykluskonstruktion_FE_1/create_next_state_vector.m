function [state_next] = create_next_state_vector(state,state_next,rel_mat_next_state_line)
%Vervollständigt den Zustandsvektor des nächsten Intervalls
%Zustandsvektor [state; v; a;a_range; t_seq; scale-faktor]
if(state_next(1,1)==1 || state_next(1,1)==4)
    state_next(2,1)=state(2,1);
    state_next(3,1)=rel_mat_next_state_line(1,2);
    state_next(4,1)=0;
    state_next(5,1)=ceil(rel_mat_next_state_line(1,3));
    state_next(6,1)=rel_mat_next_state_line(1,4);
elseif(state_next(1,1)==2 || state_next(1,1)==5)
    state_next(2,1)=state(2,1);
    if(state_next(1,1)==2 && state(3,1)<=0)
        state_next(3,1)=rel_mat_next_state_line(1,2);
    elseif(state_next(1,1)==5 && state(3,1)>=0)
        state_next(3,1)=rel_mat_next_state_line(1,2);
    else
        state_next(3,1)=state(3,1);
    end
    state_next(4,1)=0;
    state_next(5,1)=ceil(rel_mat_next_state_line(1,3));
    state_next(6,1)=1;
elseif(state_next(1,1)==3 || state_next(1,1)==6)
    state_next(2,1)=state(2,1);
    state_next(3,1)=state(3,1);
    state_next(4,1)=0;
    state_next(5,1)=ceil(rel_mat_next_state_line(1,3));
    state_next(6,1)=rel_mat_next_state_line(1,4);
elseif(state_next(1,1)<12)
    state_next(2,1)=state(2,1);
    state_next(3,1)=rel_mat_next_state_line(1,4); %pos Beschleunigung
    state_next(4,1)=rel_mat_next_state_line(1,5); %neg Beschleunigung
    state_next(5,1)=ceil(rel_mat_next_state_line(1,2)); %Sequenzlänge
    state_next(6,1)=1;
elseif(state_next(1,1)==12)
    state_next(2,1)=0;
    state_next(3,1)=0;
    state_next(4,1)=0;
    state_next(5,1)=ceil(rel_mat_next_state_line(1,2));
    state_next(6,1)=0;
end
    
    

end

