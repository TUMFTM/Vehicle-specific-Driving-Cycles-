function [ dec_classified ] = classify_dec(dec_global, dec_global_komp)
%Teilt eine Beschleunigungssequenz in drei charakteristische Klassen ein
n=length(dec_global);
number_sequences=length(dec_global_komp);
dec_classified=zeros(n,3);

dec_increase=1.17;
dec_decrease=0.85;

place=1;
i=1;
z=1;
while z <= number_sequences
   %eine Sequenz auslesen
   length_sequence=dec_global_komp(z,2);
   seq=dec_global(i:i+length_sequence-1,2:3);
   dec_seq=[seq zeros(length_sequence,1)];
   %Sequenz analysieren
   t_ana=3; %die naechsten 3 Punkte analysieren
   for k=1:length_sequence-(t_ana-1)
       l=k+(t_ana-1);
       interval=dec_seq(k:l,1:3);
       %zunehmende Bremsung prüfen
       if(interval(2,2)/interval(1,2)>dec_increase && interval(3,2)/interval(2,2)>dec_increase && (dec_seq(k,3)==0 || dec_seq(k,3)==4))
           dec_seq(k:l,3)=4;

       %abnehmende Bremsung prüfen    
       elseif(interval(2,2)/interval(1,2)<dec_decrease && interval(3,2)/interval(2,2)<dec_decrease && (dec_seq(k,3)==0 || dec_seq(k,3)==6))
           dec_seq(k:l,3)=6;
       elseif(k==length_sequence-2 && dec_seq(k,3)==6)
           dec_seq(k:l,3)=6;
       %konstante Bremsung prüfen
       elseif(dec_seq(k,3)==0)
           dec_seq(k,3)=5;
           if(l==length_sequence)
               dec_seq(k:l,3)=5;
           end
       end
        
   end
   %klassifizierte Sequenz abspeichern
   dec_classified(place:place+length_sequence-1,1:3)=dec_seq;
   place=place+length_sequence;
   %Naechste Sequenz
   i=i+length_sequence;
   z=z+1;
end
dec_classified=[dec_classified dec_global(:,1)];


end