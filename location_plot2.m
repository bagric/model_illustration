%helysz�nekhez tartoz� �rt�kek v2

%beolvas:
inputfile='C:/Users/juhaszjanos/Desktop/locdata_w1_q0/location_0729_w1_q0.csv'; %�sszes�tett f�jl (input)
data=readtable(inputfile); % beolvas t�bl�zatba
koord=[data.coordinates_1'; data.coordinates_2';data.type']; %hely koordin�t�k, t�pus
people=table2array(data(:,contains(data.Properties.VariableNames, 'allpeople')))'; %m�trixba �rt�keket �ttesz t�bl�zatb�l
infected=table2array(data(:,startsWith(data.Properties.VariableNames, 'infected')))';
weighted_infected=table2array(data(:,contains(data.Properties.VariableNames, 'weighted_infected')))';
new_infected=table2array(data(:,contains(data.Properties.VariableNames, 'new_infected')))';

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
   time_no=size(people,1);
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
pause(0.1);
%waitforbuttonpress; %k�zzel l�ptet�shez
        %frame=getframe(gcf); %videohoz kell
        %writeVideo(v1, frame) %videohoz kell
end
        %close(v1); %videohoz kell