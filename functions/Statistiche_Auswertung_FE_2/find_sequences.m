function [ seq_length,k,sequences,sequences_komp ] = find_sequences(vector_vel, vel_kmh,acc_ms2,filter)
%Liest aus die einzelne Sequenzen für Pendeln, Beschleunigen, Bremsen aus
%den geclusterten Fahrdaten aus
n=length(vector_vel);
%Erster Durchlauf um die Länge der einzelne Sequenzen zu erkennen
seq_length=zeros(n,1); %Vector in dem die Längen der Sequenzen abgespeichert werden
k=1;
value_seq_length=0;
for i=1:n
    if(vector_vel(i)~=0)
        seq_length(k)=seq_length(k)+1;
    elseif(i>1 && vector_vel(i-1)~=0 && vector_vel(i)==0)
        k=k+1;
    end        
end
%Anzahl der gefunden Sequenzen hängt davon ab, ob letzter Wert im Vektor
%null oder ungleich null ist
if(vector_vel(n)==0)
    k=k-1;
end
%Auslesen und Abspeichern der gefundenen Sequenzen
matrix_size=sum(seq_length);
sequences=zeros(matrix_size, 7);
%Erste Spalte befüllen_____________________________________________________
j=1;
add=0;
while j<=k
    sequences(j+add:j+seq_length(j)-1+add,1)=j;
    add=add+seq_length(j)-1;
    j=j+1;
end
%Andere Spalten befüllen___________________________________________________

%Für Beschleunigung
if(filter==1)
    
    place=1;
    addx=0;
    %hold on
    for l=2:n
        if(vector_vel(l-1)~=0 && vector_vel(l)==0)
            %Zeite Spalte: Geschwindigkeit
            sequences(place+addx:place+addx+seq_length(place)-1,2)=vel_kmh(l-(seq_length(place)):l-1);
            %Dritte Spalte: Beschleunigung
            sequences(place+addx:place+addx+seq_length(place)-1,3)=acc_ms2(l-(seq_length(place)):l-1);
            %Vierte Spalte: Länge der Sequenz
            sequences(place+addx,4)=seq_length(place);
            %Fuenfte Spalte: Mittelwert der Beschleunigung
            sequences(place+addx,5)=mean(acc_ms2(l-(seq_length(place)):l-1));
            %Sechste Spalte: Maximalwert der Beschleunigung
            sequences(place+addx,6)=max(acc_ms2(l-(seq_length(place)):l-1));
            %Werte müssen aus dem entsprechenden Vektor an der Stelle
            %(l-(seq_length(place)):l-1)ausgelesen werden

            %Beschleunigung Plotten
            %plot(sequences(place+addx:place+addx+seq_length(place)-1,3));

            addx=addx+seq_length(place)-1;
            place=place+1;
        elseif(l==n && vector_vel(l)~=0)
            %Zeite Spalte: Geschwindigkeit
            sequences(place+addx:place+addx+seq_length(place)-1,2)=vel_kmh(l-(seq_length(place))+1:l);
            %Dritte Spalte: Beschleunigung
            sequences(place+addx:place+addx+seq_length(place)-1,3)=acc_ms2(l-(seq_length(place))+1:l);
            %Vierte Spalte: Länge der Sequenz
            sequences(place+addx,4)=seq_length(place);
            %Fuenfte Spalte: Mittelwert der Beschleunigung
            sequences(place+addx,5)=mean(acc_ms2(l-(seq_length(place)):l));
            %Sechste Spalte: Maximalwert der Beschleunigung
            sequences(place+addx,6)=max(acc_ms2(l-(seq_length(place)):l));
            %Werte müssen aus dem entsprechenden Vektor an der Stelle
            %(l-(seq_length(place)):l)ausgelesen werden

            %Beschleunigung plotten
            %plot(sequences(place+addx:place+addx+seq_length(place)-1,3));

        end

    end

elseif(filter==2)
    %Für Bremsen
    place=1;
    addx=0;
    %hold on
    for l=2:n
        if(vector_vel(l-1)~=0 && vector_vel(l)==0)
            %Zeite Spalte: Geschwindigkeit
            sequences(place+addx:place+addx+seq_length(place)-1,2)=vel_kmh(l-(seq_length(place)):l-1);
            %Dritte Spalte: Beschleunigung
            sequences(place+addx:place+addx+seq_length(place)-1,3)=acc_ms2(l-(seq_length(place)):l-1);
            %Vierte Spalte: Länge der Sequenz
            sequences(place+addx,4)=seq_length(place);
            %Fuenfte Spalte: Mittelwert der Bremsung
            sequences(place+addx,5)=mean(acc_ms2(l-(seq_length(place)):l-1));
            %Sechste Spalte: Maximalwert der Bremsung
            sequences(place+addx,6)=min(acc_ms2(l-(seq_length(place)):l-1));
            %Werte müssen aus dem entsprechenden Vektor an der Stelle
            %(l-(seq_length(place)):l-1)ausgelesen werden

            %Beschleunigung Plotten
            %plot(sequences(place+addx:place+addx+seq_length(place)-1,3));

            addx=addx+seq_length(place)-1;
            place=place+1;
        elseif(l==n && vector_vel(l)~=0)
            %Zeite Spalte: Geschwindigkeit
            sequences(place+addx:place+addx+seq_length(place)-1,2)=vel_kmh(l-(seq_length(place))+1:l);
            %Dritte Spalte: Beschleunigung
            sequences(place+addx:place+addx+seq_length(place)-1,3)=acc_ms2(l-(seq_length(place))+1:l);
            %Vierte Spalte: Länge der Sequenz
            sequences(place+addx,4)=seq_length(place);
            %Fuenfte Spalte: Mittelwert der Bremsung
            sequences(place+addx,5)=mean(acc_ms2(l-(seq_length(place)):l));
            %Sechste Spalte: Maximalwert der Bremsung
            sequences(place+addx,6)=min(acc_ms2(l-(seq_length(place)):l));
            %Werte müssen aus dem entsprechenden Vektor an der Stelle
            %(l-(seq_length(place)):l)ausgelesen werden

            %Beschleunigung plotten
            %plot(sequences(place+addx:place+addx+seq_length(place)-1,3));

        end

    end
    
    
else
    %Für Pendeln
    place=1;
    addx=0;
    %hold on
    for l=2:n
        if(vector_vel(l-1)~=0 && vector_vel(l)==0)
            %Zeite Spalte: Geschwindigkeit
            sequences(place+addx:place+addx+seq_length(place)-1,2)=vel_kmh(l-(seq_length(place)):l-1);
            %Dritte Spalte: Beschleunigung
            sequences(place+addx:place+addx+seq_length(place)-1,3)=acc_ms2(l-(seq_length(place)):l-1);
            %Vierte Spalte: Länge der Sequenz
            sequences(place+addx,4)=seq_length(place);
            %Fuenfte Spalte: Mittelwert der Geschwindigkeit
            sequences(place+addx,5)=mean(vel_kmh(l-(seq_length(place)):l-1));
            %Sechste Spalte: Maximalwert der Beschleunigung
            sequences(place+addx,6)=max(acc_ms2(l-(seq_length(place)):l-1));
            %Siebte Spalte: Minimalwert der Beschleunigung
            sequences(place+addx,7)=min(acc_ms2(l-(seq_length(place)):l-1));
            %Werte müssen aus dem entsprechenden Vektor an der Stelle
            %(l-(seq_length(place)):l-1)ausgelesen werden

            %Pendeln Plotten
            %plot(sequences(place+addx:place+addx+seq_length(place)-1,3));

            addx=addx+seq_length(place)-1;
            place=place+1;
        elseif(l==n && vector_vel(l)~=0)
            %Zeite Spalte: Geschwindigkeit
            sequences(place+addx:place+addx+seq_length(place)-1,2)=vel_kmh(l-(seq_length(place))+1:l);
            %Dritte Spalte: Beschleunigung
            sequences(place+addx:place+addx+seq_length(place)-1,3)=acc_ms2(l-(seq_length(place))+1:l);
            %Vierte Spalte: Länge der Sequenz
            sequences(place+addx,4)=seq_length(place);
            %Fuenfte Spalte: Mittelwert der Geschwindigkeit
            sequences(place+addx,5)=mean(vel_kmh(l-(seq_length(place)):l));
            %Sechste Spalte: Maximalwert der Beschleunigung
            sequences(place+addx,6)=max(acc_ms2(l-(seq_length(place)):l));
            %Siebte Spalte: Minmale Beschleunigung
            sequences(place+addx,7)=min(acc_ms2(l-(seq_length(place)):l));
            %Werte müssen aus dem entsprechenden Vektor an der Stelle
            %(l-(seq_length(place)):l)ausgelesen werden

            %Pendeln plotten
            %plot(sequences(place+addx:place+addx+seq_length(place)-1,3));

        end

    end
    
end
%__________________________________________________________________________
%Komprimierte Matrix der Sequenzen erstellen:
sequences_komp=zeros(k,6);
place_mat=1;
x=1;
%Zweite Spalte: Dauer der Sequenzen
sequences_komp(:,2)=seq_length(1:k);

%Für Beschleunigung
if(filter==1)
    while place_mat <= k
        %Dritte Spalte: Startgeschwindigkeit der Sequenz
        sequences_komp(place_mat,3)=sequences(x,2);
        %Vierte Spalte: Endgeschwindigkeit der Sequenz
        sequences_komp(place_mat,4)=sequences(x+(sequences_komp(place_mat,2)-1),2);
        %Fuenfte Spalte: Maximale Beschleunigung
        sequences_komp(place_mat,5)=sequences(x,6);
        %Sechste Spalte: Durchschnittliche Beschleunigung
        sequences_komp(place_mat,6)=sequences(x,5);

        x=x+seq_length(place_mat);
        place_mat=place_mat+1;
    end
elseif(filter==2)
    %Für Bremsen
    while place_mat <= k
        %Dritte Spalte: Startgeschwindigkeit der Sequenz
        sequences_komp(place_mat,3)=sequences(x,2);
        %Vierte Spalte: Maximale Bremsung der Sequenz
        sequences_komp(place_mat,4)=sequences(x,6);
        %Fuenfte Spalte: Durchschnittliche Beschleunigung
        sequences_komp(place_mat,5)=sequences(x,5);

        x=x+seq_length(place_mat);
        place_mat=place_mat+1;
    end
else
    %Für Pendeln
    while place_mat <= k
        %Dritte Spalte: Startgeschwindigkeit der Sequenz
        sequences_komp(place_mat,3)=sequences(x,2);
        %Vierte Spalte: Durchschnittliche Geschwindigkeit
        sequences_komp(place_mat,4)=sequences(x,5);
        %Fuenfte Spalte: Maximale Beschleunigung
        sequences_komp(place_mat,5)=sequences(x,6);
        %Sechste Spalte:  Minimale Beschleunigung
        sequences_komp(place_mat,6)=sequences(x,7);

        x=x+seq_length(place_mat);
        place_mat=place_mat+1;
    end
end

