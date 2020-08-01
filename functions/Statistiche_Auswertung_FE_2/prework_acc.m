function [ acc ] = prework_acc(acc,state_general,typ)
%Passt den Vektor, in welchem die Beschleunigungssequenzen gespeichert sind an
%Es werden die Beschleunigungssequenzen nach der eindeutigen Zustandszuweisung
%weiter untersucht
n=length(state_general);
if(typ==1)
    value=1;
else
    value=4;
end
for i=1:n
   if(state_general(i,1)==value)
       
   else
       acc(i,:)=0;
   end
end

end