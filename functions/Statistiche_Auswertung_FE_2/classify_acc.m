function [ acc_classified ] = classify_acc(acc_global, acc_global_komp)
%Teilt eine Beschleunigungssequenz in drei charakteristische Klassen ein
n=length(acc_global);
number_sequences=length(acc_global_komp);
acc_classified=zeros(n,3);
acc_increase=1.17;
acc_decrease=0.85;

place=1;
i=1;
z=1;
while z <= number_sequences
   %eine Sequenz auslesen
   length_sequence=acc_global_komp(z,2);
   seq=acc_global(i:i+length_sequence-1,2:3);
   acc_seq=[seq zeros(length_sequence,1)];
   %Sequenz analysieren
   t_ana=3; %die naechsten 3 Punkte analysieren
   for k=1:length_sequence-(t_ana-1)
       l=k+(t_ana-1);
       interval=acc_seq(k:l,1:3);
       %zunehmende Beschleunigung prüfen
       if(interval(2,2)/interval(1,2)>acc_increase && interval(3,2)/interval(2,2)>acc_increase && (acc_seq(k,3)==0 || acc_seq(k,3)==1))
           acc_seq(k:l,3)=1;

       %abnehmende Beschleunigung prüfen    
       elseif(interval(2,2)/interval(1,2)<acc_decrease && interval(3,2)/interval(2,2)<acc_decrease && (acc_seq(k,3)==0 || acc_seq(k,3)==3))
           acc_seq(k:l,3)=3;
       %elseif(k==length_sequence-2 && acc_seq(k,3)==3)
           %acc_seq(k:l,3)=3;
       %konstante Beschleunigung prüfen
       elseif(acc_seq(k,3)==0)
           acc_seq(k,3)=2;
           if(l==length_sequence)
               acc_seq(k:l,3)=2;
           end
       end
        
   end
   %klassifizierte Sequenz abspeichern
   acc_classified(place:place+length_sequence-1,1:3)=acc_seq;
   place=place+length_sequence;
   %Naechste Sequenz
   i=i+length_sequence;
   z=z+1;
end
acc_classified=[acc_classified acc_global(:,1)];


end

