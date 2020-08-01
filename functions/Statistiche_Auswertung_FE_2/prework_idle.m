function [ idle ] = prework_idle(idle,state_general)
%Passt den Vektor, in welchem die Leerlaufsequenzen gespeichert sind an
%Es werden die Leerlaufsequenzen nach der eindeutigen Zustandszuweisung
%weiter untersucht
n=length(state_general);
for i=1:n
   if(state_general(i,1)~=12)
       idle(i,:)=0;
   end
end

end