function [ pendeln,pendeln_safe ] = search_pendeln(vel_kmh,t_pendel,tol_pen,safety_factor)
%Sucht nach Pendelsequenzen in den Fahrdaten
%Ist der Wert in pendeln_value an der Stelle i = 1, so gehört der Wert zu
%einer Pendelsequenz. Die Dauer einer Pendelsequenz beträgt 10 sec.

%__________________________________________________________________________
%t_pendel=10;
%Pendelzykluslänge in Abhängigkeit von der Geschwindigkeit

n=length(vel_kmh);
pendeln_value=zeros(n,1); 
pendeln_value_safe=zeros(n,1);
%safety_factor=0.5;
for i=1:1:n-(t_pendel-1)
   k=i+(t_pendel-1); %Sequenz der Länge t_pendel
   v_seq=vel_kmh(i:k); %Sequenz von t_pendel
   v_mean=mean(v_seq); %Mittelwert
   delta_v=abs(v_seq-v_mean);%Abweichung vom Mittelwert
   variable=1;
   %Tolernzfeld in Abhängigkeit der Geschwindigkeit
   if(max(v_seq)<tol_pen(1,1))
       tol=tol_pen(2,1);
   elseif(max(v_seq)<tol_pen(1,2))        %30er Zone
       tol=tol_pen(2,2);
   elseif(max(v_seq)<tol_pen(1,3))    %Stadtverkehr
       tol=tol_pen(2,3);
   elseif(max(v_seq)<tol_pen(1,4))   %Landstraße
       tol=tol_pen(2,4);
   else
       tol=tol_pen(2,5);            %Autobahn
   end
   %_______________________________________________________________________
   %Überprüfen der Pendelsequenz mit t_pendel Sekunden
   
   for j=1:t_pendel
       if(delta_v(j)<(tol*v_mean) &&  variable==1)
           variable=1;
       else
           variable=0;
       end
   end
   %Wenn für alle Werte in der Sequenz die Bedingung erfüllt ist, wird die
   %Sequenz als Pendelsequenz identifiziert
   if(variable==1)
       pendeln_value(i:i+(t_pendel-1))=1;

   elseif(pendeln_value(i)==1)
       pendeln_value(i)=1;
     
   else
       pendeln_value(i)=0;
   end
   %_______________________________________________________________________
   %Überprüfen, ob Pendeln mit hoher Wahrscheinlichkeit vorliegt
   for j=1:t_pendel
       if(delta_v(j)<(safety_factor*tol*v_mean) &&  variable==1)
           variable=1;
       else
           variable=0;
       end
   end
   %Wenn für alle Werte in der Sequenz die Bedingung erfüllt ist, wird die
   %Sequenz als Pendelsequenz identifiziert
   if(variable==1)
       pendeln_value_safe(i:i+(t_pendel-1))=1;

   elseif(pendeln_value_safe(i)==1)
       pendeln_value_safe(i)=1;
     
   else
       pendeln_value_safe(i)=0;
   end
   %_______________________________________________________________________
end
%Plotten der Geschwindigkeit und der Pendelsequenzen
pendeln=7.*pendeln_value;
pendeln_safe=7.*pendeln_value_safe;



end

