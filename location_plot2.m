%helyszínekhez tartozó értékek v2

%beolvas:
%inputfile='C:/Users/juhaszjanos/Desktop/locdata_w1_q0/location_0729_w1_q0.csv'; %összesített fájl (input)

inputfile='F:/location_0901_w1_q3.csv'; %összesített fájl (input)

data=readtable(inputfile); % beolvas táblázatba
koord=[data.coordinates_1'; data.coordinates_2';data.type']; %hely koordináták, típus
people=table2array(data(:,contains(data.Properties.VariableNames, 'allpeople')))'; %mátrixba értékeket áttesz táblázatból
infected=table2array(data(:,startsWith(data.Properties.VariableNames, 'infected')))';
weighted_infected=table2array(data(:,contains(data.Properties.VariableNames, 'weighted_infected')))';
new_infected=table2array(data(:,contains(data.Properties.VariableNames, 'new_infected')))';

okord = koord;
opeople = people;
oinfected = infected;

%%
koord = okord;
people = opeople;
infected = oinfected;

koord=koord(:,1:length(koord(1,:))-3);
people=people(:,1:length(people(1,:))-3);
infected=infected(:,1:length(infected(1,:))-3);
koord(1,:) = koord(1,:)-min(koord(1,:));
koord(2,:) = koord(2,:)-min(koord(2,:));
koord(1,:) = 1.02 * (5+839 - 839*koord(1,:)./max(koord(1,:)));
koord(2,:) = (5 + 1155*koord(2,:)./max(koord(2,:)));

%%
%ábrázol
%videohoz kell: 

videoout='vid.mp4';

% v1=VideoWriter(strcat([filedict, videoout]), 'MPEG-4');

v1=VideoWriter((videoout), 'MPEG-4');        
v1.FrameRate=8;
open(v1);

% adatok min max értékei
   p=[min(min(people)), max(max(people))]
   inf=[min(min(infected)), max(max(infected))]
   w=[min(min(weighted_infected)), max(max(weighted_infected))]
   n=[min(min(new_infected)), max(max(new_infected))]
%pontos idõ kiszámolsa lépésszámból:
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
       0.8, 0.8, 0.8]; %colomap a helyszíneknek

f=figure('units','normalized','outerposition',[0 0 1 1]);
set(f,'visible','off');
axis square
%axis tight

I=imread('map.png','png');

%waitforbuttonpress %animáció gombnyomásra indul (nagyba kitehetõ elötte)
for i=1:1:time_no %minden idõlépésben

    mmap = imagesc(I);
    hold on
    
    %subplot(2,2,1) % 1 ábrán is lehetne a 4 animáció (túl kicsi már szerintem...)
    scatter(koord(2,:), koord(1,:), people(i,:)+1, koord(3,:), 'filled'); % x, y koordináták, pont mérete arányos az ábrázolt értékkel, a szín a helytípus alapján 
    scatter(koord(2,:), koord(1,:), 10*infected(i,:)+1, koord(3,:), 'filled'); % *5, hogy jobban látszódjanak a pontok; +1 a 0-ás létszámú helyek miatt 
    %scatter(koord(2,:), koord(1,:), 5*weighted_infected(i,:)+1, koord(3,:), 'filled');
    %scatter(koord(2,:), koord(1,:), 5*new_infected(i,:)+1, koord(3,:), 'filled');
    % ábra cím + idõ
    title({['day ', num2str(nap(i)), '; ', num2str(ora(i)), ':', num2str(perc(i))];...
            'number of people'});%'number of fresh infections'});%'~infectiousness'});%'number of infected people'});%
    % colorban finom hangolása
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
    tightfig(gcf);
    hold off;
    %pause(0.1);
    
%     waitforbuttonpress; %kézzel léptetéshez
    frame=getframe(gcf); %videohoz kell
    writeVideo(v1, frame) %videohoz kell
end
close(v1); %videohoz kell