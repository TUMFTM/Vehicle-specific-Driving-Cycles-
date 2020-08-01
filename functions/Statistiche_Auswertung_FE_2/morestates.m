function [pre_state,state_general] = morestates(pre_state, state_general,sequences_classified,typ)
%Überführt die Unterzustände in den globalen Zustandsvektor
if(typ==1) 
    spalte=1;
    value=1;%Typ=1: Beschleunigung
else
    spalte=2; %Typ=2: Bremsen
    value=4;
end
n=length(state_general);
%pre_state=[pre_state zeros(n,1)];
step_classified=1;
for i=1:n
    if(state_general(i,1)==value)
        state_general(i,1)=sequences_classified(step_classified,3);
        step_classified=step_classified+1;
        
    end
end
%State-Vector befüllen
% for i=1:n
%     if(state_general(i)==value)
%         state_general(i,1)=pre_state(i,4+spalte);
%     end
% end
    

end

