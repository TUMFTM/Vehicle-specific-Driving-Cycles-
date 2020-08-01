function [ pendeln ] = prework_pendeln(pendeln,state_general)
%Passt den Vektor, in welchem die Pendelsequenzen gespeichert sind an
%Es werden die Pendelsequenzen nach der eindeutigen Zustandszuweisung
%weiter untersucht
n=length(state_general);
for i=1:n
   if(state_general(i,1)~=7)
       pendeln(i,:)=0;
   end
end

end

