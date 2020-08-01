function [rel_mat_next_state_line] = rand_pullout(state_next,rel_mat_next_state)
%Randomisiertes Ziehen gemäß Häufigkeitsverteilung aus der relevanten
%Matrix

%Falls zunehmendes Beschleunigen oder Bremsen
%Startwert der Beschleunigung erforderlich
if(state_next(1,1)==1 || state_next(1,1)==2 || state_next(1,1)==4 || state_next(1,1)==5)
    number=rel_mat_next_state(:,1)*1000;
    number=round(number);
    n=sum(number);
    pullout_vector=zeros(n,1);
    j=1;
    i=1;
    while i<=n
        pullout_vector(i:i+(number(j)-1),1)=j;
        i=i+number(j);
        j=j+1;
    end 
    %Randomisiertes Ziehen der Zeilennummer aus dem Pullout-Vector
    number_line=randsample(pullout_vector,1);
    %Matrix-Zeile auslesen
    rel_mat_next_state_line=rel_mat_next_state(number_line,:);
elseif(state_next(1,1)==3 || state_next(1,1)==6)
    
    %rel_mat_next_state_line=rel_mat_next_state(1,:);
        number=rel_mat_next_state(:,1)*1000;
    number=round(number);
    n=sum(number);
    pullout_vector=zeros(n,1);
    j=1;
    i=1;
    while i<=n
        pullout_vector(i:i+(number(j)-1),1)=j;
        i=i+number(j);
        j=j+1;
    end 
    %Randomisiertes Ziehen der Zeilennummer aus dem Pullout-Vector
    number_line=randsample(pullout_vector,1);
    %Matrix-Zeile auslesen
    rel_mat_next_state_line=rel_mat_next_state(number_line,:);
    
elseif(state_next(1,1)<12)
    %Pendeln
    number=rel_mat_next_state(:,3)*1000;
    number=round(number);
    n=sum(number);
    pullout_vector=zeros(n,1);
    j=1;
    i=1;
    while i<=n
        pullout_vector(i:i+(number(j)-1),1)=j;
        i=i+number(j);
        j=j+1;
    end
    %Randomisiertes Ziehen der Zeilennummer aus dem Pullout-Vector
    number_line=randsample(pullout_vector,1);
    %Matrix-Zeile auslesen
    rel_mat_next_state_line=rel_mat_next_state(number_line,:);
else
    %Leerlauf
    rel_mat_next_state_line=rel_mat_next_state;
    
end
    

end

