function [ class_values ] = analytics_pen_class(pen_class)
%Auswertung einer Pendelklasse (s7-s11) und Bildung der relvanten Matrix

%minimale Dauer in dieser Klasse
min_t=min(pen_class(:,1));
%maximale Dauer in dieser Klasse
max_t=max(pen_class(:,1));
%Anzahl verschiedener Werte
number_class=max_t-min_t;

class_values=zeros(number_class+1,5);
[n,m]=size(pen_class);
number_tot=0;
for j=1:number_class+1
    number=0;
    
    for i=1:n
        if(pen_class(i,1)==min_t+j-1)
            number=number+1;
            number_tot=number_tot+1;
        end
    end
    %rel-Häufigkeit der Dauer
    class_values(j,2)=min_t+j-1;
    class_values(j,3)=number/n;
    %Mittelwerte der Beschleunigung und Verzögerung
    class_values(j,4)=mean(pen_class(number_tot+1-number:number_tot,4));
    class_values(j,5)=mean(pen_class(number_tot+1-number:number_tot,5));
end
        

end

