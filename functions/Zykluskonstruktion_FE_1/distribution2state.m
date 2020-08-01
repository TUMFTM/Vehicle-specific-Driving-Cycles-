function [ next_s,s_cycle_next] = distribution2state( s_cycle,state )
%Wählt aus Zustandsverteilung den nächsten Zustand aus
%%
%Variante: Zustand mit höchster Wahrscheinlichkeit gewinnt
% state_max=max(s_cycle);
% s_cycle_next=zeros(1,12);
% for i=1:12
%     if(state_max==s_cycle(1,i))
%         next_s=i;
%         s_cycle_next(1,i)=1; %Verteilung für nächsten Zustand
%     end
% end
%%
%Randomisiertes Ziehen aus den 6 wahrscheinlichsten Zuständen;
[s_cycle_sort,index]=sort(s_cycle,'descend');
s_cycle_sort=round(s_cycle_sort.*1000);
number=sum(s_cycle_sort(1,1:6));
pullout_vector=zeros(1,number);
pullout_vector(1,1:s_cycle_sort(1,1))=index(1,1); %Vektor gemäß Verteilung befüllen
n=s_cycle_sort(1,1)+1;
pullout_vector(1,n:n+s_cycle_sort(1,2)-1)=index(1,2);
n=s_cycle_sort(1,1)+s_cycle_sort(1,2)+1;
pullout_vector(1,n:n+s_cycle_sort(1,3)-1)=index(1,3);
n=s_cycle_sort(1,1)+s_cycle_sort(1,2)+s_cycle_sort(1,3)+1;
pullout_vector(1,n:n+s_cycle_sort(1,4)-1)=index(1,4);
n=s_cycle_sort(1,1)+s_cycle_sort(1,2)+s_cycle_sort(1,3)+s_cycle_sort(1,4)+1;
pullout_vector(1,n:n+s_cycle_sort(1,5)-1)=index(1,5);
n=s_cycle_sort(1,1)+s_cycle_sort(1,2)+s_cycle_sort(1,3)+s_cycle_sort(1,4)+s_cycle_sort(1,5)+1;
pullout_vector(1,n:n+s_cycle_sort(1,6)-1)=index(1,6);
%Leerlaufzustand  nur bei niederigen Geschwindigkeiten zulassen
var=1;
while var>0
    next_s=randsample(pullout_vector,1); %randomisiertes Ziehen
    if(next_s==12 && state(2,1) > 5)
        var=1;
    else
        var=0;
    end
end
%%Aktuellen Zustandsvektor neu setzen
s_cycle_next=zeros(1,12); %Nächster Zustand
s_cycle_next(1,next_s)=1;





end

