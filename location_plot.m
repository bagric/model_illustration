% helyek param�tereit beolvas (1 f�jl 1 id�pont a f�jlban a helyek sorrendben)
% id�pontonk�nti .txt-k let�ltve �s egy mapp�ba pakolva
%%
% input helyek
%
fname2 = 'C:/Users/juhaszjanos/Downloads/locations_0729.json'; %location file
filedict='C:/Users/juhaszjanos/Desktop/locdata_w1_q0/'; %adat f�jlok helye
output='location_0729_w1_q0.csv'; %.xlsx %kimeneti f�jl neve
videoout='location_0729_w1_q0.mp4';
%}
%{
fname2 = 'C:/Users/juhaszjanos/Downloads/locations0_0901.json'; %location file
filedict='C:/Users/juhaszjanos/Desktop/locdata_w1_q3_0901/'; %adat f�jlok helye
output='location_0901_w1_q3.csv'; %.xlsx %kimeneti f�jl neve
videoout='location_0901_w1_q3.mp4'; %output video neve
%}
%%
% location beolvas
var2 = jsondecode(fileread(fname2));
loc_no=size(var2.places,1);
koord=zeros(3, loc_no); % x,y location t�pus
%%
loc_files = dir(strcat([filedict,'*.txt'])); 
time_no=size(loc_files,1); %h�ny f�jl van?
people=zeros(time_no, loc_no); % emberek helyeken adott id�kben
infected=zeros(time_no, loc_no); % fert�z�ttek
weighted_infected=zeros(time_no, loc_no); % s�lyozott fert�z�ttek
new_infected=zeros(time_no, loc_no); % �j fert�z�ttek adott helyen adott id�pontban

% adatok beolvas�sa
for a=1:time_no %minden id�pillanat
filename=strcat([filedict,'locationStats_',num2str(a-1),'.txt']) % aktu�lis f�jl neve
data=dlmread(filename); % beolvas m�trixba sz�mokat
people(a,:)=data(1,1:end-1);
infected(a,:)=data(2,1:end-1);
weighted_infected(a,:)=data(3,1:end-1);
new_infected(a,:)=data(4,1:end-1);
end

%%
%ki�r
for i=1:size(var2.places,1) %minden location
 % json matlabba struct array-k�nt, ennek a v�g�re �j mez�k a id�pontonk�nti adatokkal
 var2.places(i).allpeople=people(:,i);
 var2.places(i).infected=infected(:,i);
 var2.places(i).weighted_infected=weighted_infected(:,i);
 var2.places(i).new_infected=new_infected(:,i);
 koord(:,i)=[var2.places(i).coordinates(1);var2.places(i).coordinates(2);var2.places(i).type]; %x,y,koord, loc t�pus
end
writetable(struct2table(var2.places), strcat([filedict,output,])); % ment sz�vegf�jlba, vektor mez�k elemei k�l�n cell�k itt m�r (lass�)

%%
%�br�zol
%videohoz kell: 
        %{
        %v1=VideoWriter(strcat([filedict, videoout]), 'MPEG-4');
        v1=VideoWriter((videoout), 'MPEG-4');        
        v1.FrameRate=8;
        open(v1);
        %}
% adatok min max �rt�kei
   p=[min(min(people)), max(max(people))]
   inf=[min(min(infected)), max(max(infected))]
   w=[min(min(weighted_infected)), max(max(weighted_infected))]
   n=[min(min(new_infected)), max(max(new_infected))]
%pontos id� kisz�molsa l�p�ssz�mb�l:
   t=0:time_no-1;
   perc=mod(t*10,60);
   ora=mod((t*10-perc)/60,24);
   nap=mod((t*10-(perc+ora*60))/(24*60),7);
mymap=[0.5, 0.5, 0;...
       0, 0, 1;...
       1, 1, 0;...
       1, 0.5, 0;...
       1, 0.5, 0.75;...
       1, 0, 0.75;...
       1, 0, 0;...
       0.5, 0, 0;...
       0.5, 0, 1;...
       0, 0.5, 0;...
       1, 1, 1;...
       0, 0, 0;...
       1, 0.3, 0;...
       0.5, 0.5, 0.5;...
       0.8, 0.8, 0.8]; %colomap a helysz�neknek
figure;
waitforbuttonpress %anim�ci� gombnyom�sra indul (nagyba kitehet� el�tte)
for i=1:1:time_no %minden id�l�p�sben
    %subplot(2,2,1) % 1 �br�n is lehetne a 4 anim�ci� (t�l kicsi m�r szerintem...)
scatter(koord(2,:), koord(1,:), people(i,:)+1, koord(3,:), 'filled'); % x, y koordin�t�k, pont m�rete ar�nyos az �br�zolt �rt�kkel, a sz�n a helyt�pus alapj�n 
%scatter(koord(2,:), koord(1,:), 5*infected(i,:)+1, koord(3,:), 'filled'); % *5, hogy jobban l�tsz�djanak a pontok; +1 a 0-�s l�tsz�m� helyek miatt 
%scatter(koord(2,:), koord(1,:), 5*weighted_infected(i,:)+1, koord(3,:), 'filled');
%scatter(koord(2,:), koord(1,:), 5*new_infected(i,:)+1, koord(3,:), 'filled');
% �bra c�m + id�
title({['day ', num2str(nap(i)), '; ', num2str(ora(i)), ':', num2str(perc(i))];...
        'number of people'});%'number of fresh infections'});%'~infectiousness'});%'number of infected people'});%
% colorban finom hangol�sa
colormap(mymap);
c=colorbar;
c.FontSize=8;
c.Ticks=1.5:1:16.5;
c.TickLabels={'Public space', 'Residence', 'School', 'Standard workplace',...
   'Smaller evening social acitvity',...
   'Bigger evening social acitvity',... 
   'Short visit activity',... 
   'Longer visit activity',... 
   'Weekend social activity',... 
   'Long stay recreation outdoor',...
   'Closed facility', 'Hospital', 'Non-standard workspace',...
   'Health centre', 'Outside'};
caxis([1,16]);
%{
    subplot(2,2,2)
scatter(koord(2,:), koord(1,:), 5*infected(i,:)+1, koord(3,:), 'filled');
title({'number of infected people'});
colormap(mymap);
%colorbar;
%caxis(inf);

    subplot(2,2,3)
scatter(koord(2,:), koord(1,:), 5*weighted_infected(i,:)+1, koord(3,:), 'filled');
title({'~infectiousness'});
%colorbar;
%caxis(w);
    subplot(2,2,4)
scatter(koord(2,:), koord(1,:), 5*new_infected(i,:)+1, koord(3,:), 'filled');
title({'number of fresh infections'});
%colorbar;
%caxis(n);
%}
pause(0.1);
%waitforbuttonpress; %k�zzel l�ptet�shez
        %frame=getframe(gcf); %videohoz kell
        %writeVideo(v1, frame) %videohoz kell
end
        %close(v1); %videohoz kell
