function [rel_mat,typ_mat_komp] = analytics_acc_class_typ36(typ_mat)
%Statistische Analyse einer Matrix eines Beschleunigungszustandes
[n,w]=size(typ_mat);
state=3;
%Vereinfachte Matrix auslesen
typ_mat_komp=zeros(n,6);
step=1;
for i=1:n
    if(typ_mat(i,5)~=0 && typ_mat(i,3)~=0)
        typ_mat_komp(step,1:5)=typ_mat(i,:);
        step=step+1;
    end
end
typ_mat_komp=typ_mat_komp(1:step-1,:);

if(state==1 || state==3)
   %Durchschnittliche Zunahme oder Abnahme der Beschleunigung bestimmen
   j=1;
   l=1;
   k=sum(typ_mat_komp(:,5));
   while j<=k
       seq_t=typ_mat(j,5);
       if(typ_mat(j+seq_t-1,2)==0)
           seq_t=seq_t-1;
       end
       if(typ_mat(j,3)==0)
           j=j+1;
       else
           m=(typ_mat(j+seq_t-1,2)/typ_mat(j,2));
           if(m>1)
               m=(typ_mat(j+seq_t-2,2)/typ_mat(j,2));
               mean_steigerung=m^(1/(seq_t-2));
           else
               mean_steigerung=m^(1/(seq_t-1));
           end
           typ_mat_komp(l,6)=mean_steigerung;
           j=j+seq_t;
           l=l+1;
       end
   end
       
end

[a,b]=size(typ_mat_komp);
typ_mat_komp_use=zeros(a,6);
delete=0;
p=1;
for i=1:a
   if(typ_mat_komp(i,6)>1)
       delete=delete+1;
   else
       typ_mat_komp_use(p,:)=typ_mat_komp(i,:);
       p=p+1;
   end
end
typ_mat_komp=typ_mat_komp_use(1:p-1,:);
%konstante Dauer
typ_mat_time=mean(typ_mat_komp(:,5));
%konstante Steigerung
%typ_mat_scale=mean(typ_mat_komp(:,6));
%Histogram mit 15 Klassen für Skalierungsfaktor
%Es wird dann der Klassenmittelwert als relevanter Wert verwendet
%Der Skalierungsfaktor wird mit dem Startwert der
%Beschleunigungsgematched
H=histogram(typ_mat_komp(:,6),15);
Edge_Values=H.BinEdges;
abs_freq=H.Values;
rel_freq=transpose(abs_freq./(step-1));
%relevante Matrix Initialisieren
rel_mat=zeros(15,4);
rel_mat(:,3)=typ_mat_time;
%rel_mat(:,4)=typ_mat_scale;
rel_mat(:,1)=rel_freq;
[length_komp,m]=size(typ_mat_komp);
for i=1:15
    %median_class=(Edge_Values(i+1)+Edge_Values(i))/2;
    %rel_mat(i,4)=median_class;
    n_acc=0;
    n_scale=0;
    mean_acc=0;
    mean_scale=0;
    %Startbeschleunigung mit Skalierungsfaktor matchen
    for z=1:length_komp
        if(typ_mat_komp(z,6)> Edge_Values(i) && typ_mat_komp(z,2)<= Edge_Values(i+1))
            mean_scale=mean_scale+typ_mat_komp(z,6);
            n_scale=n_scale+1;
            mean_acc=mean_acc+typ_mat_komp(z,2);
            n_acc=n_acc+1;
            
        end
    end
    rel_mat(i,2)=mean_acc/n_acc;
    rel_mat(i,4)=mean_scale/n_scale; %Skalierungsfaktor
end 

    
end