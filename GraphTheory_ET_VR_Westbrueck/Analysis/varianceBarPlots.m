%% testi

x = 1;
y = [100,0,0,0; 67.2,0,0,32.8; 58.5,8.7,0,32.8; 47,0,20.2,32.8];
figure(1)
plotty1 = bar(y,'stacked');%,'FaceColor',[0.24,0.15,0.66; 0.14,0.63,0.90]);

plotty1(1).FaceColor = [0.24,0.15,0.66];
plotty1(2).FaceColor = [0.01,0.72,0.80];
plotty1(3).FaceColor = [0.40,0.80,0.42];
plotty1(4).FaceColor = [0.75,0.75,0.75];
ylim([-10,120])

figure(2)

x = 1;
y = [67.2,0,0,32.8; 58.5,8.7,0,32.8; 47,0,20.2,32.8;];
plotty2 = bar(y,'stacked');%,'FaceColor',[0.24,0.15,0.66; 0.14,0.63,0.90]);

plotty2(1).FaceColor = [0.24,0.15,0.66];
plotty2(2).FaceColor = [0.27,0.38,0.99 ];
plotty2(3).FaceColor = [0.01,0.72,0.80];
plotty2(4).FaceColor = [0.75,0.75,0.75];


ylim([-10,120])


figure(3)
x = 1;
y = [40,60];

plotty3 = bar(x,y,'stacked');%,'FaceColor',[0.24,0.15,0.66; 0.14,0.63,0.90]);

plotty3(1).FaceColor = [0.96,0.73,0.23];
plotty3(2).FaceColor = [0.01,0.72,0.80];

ylim([-10,120])

figure(3)
x = 1;
y = [40,60];

plotty3 = bar(x,y,'stacked');%,'FaceColor',[0.24,0.15,0.66; 0.14,0.63,0.90]);

plotty3(1).FaceColor = [0.01,0.72,0.80];
plotty3(2).FaceColor = [0.01,0.72,0.80];

ylim([-10,120])



figure(4)
x = 1;
y = [34.6,65.4];

plotty4 = bar(x,y,'stacked');%,'FaceColor',[0.24,0.15,0.66; 0.14,0.63,0.90]);

plotty4(1).FaceColor = [0.40,0.80,0.42];
plotty4(2).FaceColor = [0.40,0.80,0.42];

ylim([-10,120])





figure(20)
plotty20 = bar([10;10;10;10;10;10]);

plotty20.FaceColor = 'flat';
plotty20.CData(1,:) = [0.24,0.15,0.66];
plotty20.CData(2,:)  = [0.27,0.38,0.99 ];
plotty20.CData(3,:)  = [0.01,0.72,0.80];
plotty20.CData(4,:)  = [0.40,0.80,0.42];
plotty20.CData(5,:)  = [0.96,0.73,0.23];
plotty20.CData(6,:)  = [0.75,0.75,0.75];











