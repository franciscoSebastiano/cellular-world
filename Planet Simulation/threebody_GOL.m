close all 
clearvars, clc, clf

%This is a 3-dimensional 3-body approximation which orbits a planet and
%moon around a sun. 
%The planet is simulated using a cellular automata program which mimicks
%growth of plant life and changes in geography with time.
% This is essentially two seperate computational ideas smashed into each
% other -- a three body approximation determines a planet's position and a 
% cellular autmata simulation gives the planet life.

%Written By Francisco Sebastiano

size_of_game = 50;
half_point = 1250;
time = 0;
wasd_keys;

sunlife = randi([0 1],size_of_game,size_of_game);
mylife = randi([0 10],size_of_game,size_of_game);
newlife = mylife;
newsunlife = sunlife;

newColormap = [ 135 206 250; 135 206 250; 135 206 250; 135 206 250; 135 230 250; 135 230 250; 135 230 250; 135 230 250; 135 230 250; 0 0 255; 0 0 255; 0 0 255; 0 0 255;
                150 255 160; 255 200 0; 127 255 0; 255 200 0; 34,139,34; 255 240 0; 34,139,34; 255 255 0; 34,139,50; 255 130 0;]; % black
newColormap = newColormap/255;
colormap(newColormap)

sunMass = 150;
planet1Mass = 1;
moon1Mass = .005;
G = 1;
dt = 0.0005;
planet1Position = [12, 10, 10, planet1Mass]; %The 4th index is body mass so that the mass can be cleanly passed as an argument into functions.
sunPosition = [10,10,10, sunMass]; 
moon1Position = [12.1, 10, 10, moon1Mass];

sunVelocity = [0,0,0];
planetVelocity = [0,7,0];
moonVelocity = [-1.7, 4.6, 2];

s2 = plot3(sunPosition(1),sunPosition(2),sunPosition(3),'.','MarkerSize',10, 'Color', [0.5, 0.5, 0.5]);
hold on;
moon = plot3(moon1Position(1),moon1Position(2),moon1Position(3),'.','MarkerSize',10, 'Color', [0.5, 0.5, 0.5]);
s1 = plot3(planet1Position(1), planet1Position(2),planet1Position(3),'.','MarkerSize',10, 'Color', [0.5, 0.5, 0.5]);
hold off

while 1

time = time+1;

for i = 1:size_of_game
    si = i-1;
    ei = i+1;
    veci = si:ei;
    veci(veci==0)=size_of_game;
    veci(veci==size_of_game+1)=1;
    
    for j = 1:size_of_game
        sj = j-1;
        ej = j+1;
        vecj = sj:ej;
        vecj(vecj==0)=size_of_game;
        vecj(vecj==size_of_game+1)=1;
        binarylife = logical(mylife);
        land = logical(mylife>6);
        land = sum(land,"all");

        sun_neighbors = sum(sum(sunlife(veci,vecj)))-sunlife(i,j);
        
        plantlife = logical(mod(mylife, 1));

        num_neighbors = sum(sum(binarylife(veci,vecj)))-binarylife(i,j);
        val_neighbors = sum(sum(mylife(veci,vecj)))-mylife(i,j);
        plant_neighbors = sum(sum(plantlife(veci,vecj)))-plantlife(i,j);

        if mylife(i,j) <=6 && mylife(i,j)
         if num_neighbors < 2
         newlife(i,j) = newlife(i,j)-.5;
          end

          if num_neighbors > 3
              newlife(i,j) = newlife(i,j)-.5;
          end
          if num_neighbors == 3
              newlife(i,j) = newlife(i,j)+.5;
          elseif num_neighbors > 2 && num_neighbors < 4
              newlife(i,j) = newlife(i,j)+.5;
          end
          if newlife(i,j) > 6
              newlife(i,j)= 6;
          end
        elseif mylife(i,j) == 0
          %Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.
          if num_neighbors == 3
              newlife(i,j) = newlife(i,j)+.5;
          elseif num_neighbors > 2 && num_neighbors < 4
              newlife(i,j) = newlife(i,j)+.5;
          end
          if newlife(i,j) > 6
              newlife(i,j)= 6;
          end
        end

         if mylife(i,j) > 6 && (mod(mylife(i,j), 1) == 0) && mod(time, 5) > 0
              if (mylife(i,j)*3 >= val_neighbors)
                  newlife(i,j) = mylife(i,j)-1;
              elseif (mylife(i,j) < val_neighbors/8) && mylife(i,j)<20
                  newlife(i,j) = mylife(i,j)+1;
              end
         end
         if mylife(i,j) > 6 && (mod(mylife(i,j), 1)) > 0
         
          if val_neighbors < 6*8
              newlife(i,j) = mylife(i,j)-1;

          elseif plant_neighbors < 2 && land < half_point
         newlife(i,j) = 7;
         elseif plant_neighbors < 2 && land > half_point
         newlife(i,j) = 5;

          elseif plant_neighbors > 3 && land < half_point
              newlife(i,j) = 7;
          elseif plant_neighbors > 3 && land > half_point
              newlife(i,j) = 5;

          elseif plant_neighbors == 3 
              newlife(i,j) = mylife(i,j)+1;
          end
      
         elseif plant_neighbors == 3 && val_neighbors > 6*7
              newlife(i,j) = 7.5;
         elseif plant_neighbors == 3 && val_neighbors < 6*7
              newlife(i,j) = 6;
         end

         if sunlife(i,j)
         if sun_neighbors < 2
         newsunlife(i,j) = 0;
          end

          if sun_neighbors > 3
              newsunlife(i,j) = 0;
          end
    else
      
          if sun_neighbors == 3
              newsunlife(i,j) = 1;
          end
    end
    end

end


    

    %Calculate x,y,z forces between all bodies
    [Fx, Fy, Fz] = gForce(planet1Position, sunPosition, G); forcesPlanetSun = [Fx, Fy, Fz] ;
    [Fxm, Fym, Fzm] = gForce(sunPosition, moon1Position, G); forcesSunMoon = [Fxm, Fym, Fzm] ;
    [Fxp, Fyp, Fzp] = gForce(planet1Position, moon1Position, G);forcesPlanetMoon = [Fxp, Fyp, Fzp] ;

    sunVelocity = sunVelocity - forcesPlanetSun*dt/sunMass + forcesSunMoon*dt/sunMass;
    planetVelocity =  planetVelocity + forcesPlanetSun*dt/planet1Mass + forcesPlanetMoon*dt/planet1Mass;
    moonVelocity = moonVelocity - forcesSunMoon*dt/moon1Mass - forcesPlanetMoon*dt/moon1Mass;


    sunPosition(1:3) = sunVelocity*dt + sunPosition(1:3);
    planet1Position(1:3) = planetVelocity*dt + planet1Position(1:3);
    moon1Position(1:3) = moonVelocity*dt + moon1Position(1:3);

    

           
mylife = newlife;
sunlife = newsunlife;
displaysun = sunlife+8;
pause(.1);

[r,c] = size(mylife); 
[R,C] = ndgrid(1:r, 1:c);


theta = (C./c)*2*pi; 
phi = (R./r)*pi; 

scaled_mylife = 1 + .15 * (mylife - min(mylife(:))) / (max(mylife(:)) - min(mylife(:)));
scaled_sunlife = 1 + .05 * (displaysun - min(displaysun(:))) / (max(displaysun(:)) - min(displaysun(:)));

[X,Y,Z] = sph2cart(theta-pi, phi-pi/2, scaled_mylife);  
[D,E,F] = sph2cart(theta-pi, phi-pi/2, scaled_sunlife);  

r = .075;
X2 = X * r;
Y2 = Y * r;
Z2 = Z * r;

rsun = .075;
D2 = D * rsun;
E2 = E * rsun;
F2 = F * rsun;

set(moon, 'XData', moon1Position(1), 'YData', moon1Position(2), 'ZData', moon1Position(3));
hold on
delete(s2)
s2 = surf(D2+sunPosition(1),E2+sunPosition(2),F2+sunPosition(3), displaysun, 'EdgeColor', 'none');
delete(s1)
s1 = surf(X2+planet1Position(1),Y2+planet1Position(2),Z2+planet1Position(3), mylife, 'EdgeColor', 'none');
hold off;


colorbar;


clim([0,11])
xlim([8, 12.5]);
ylim([8,12.5]);
zlim([8,12.5]);
view(10+d_count-a_count,5+w_count-s_count);
set(gca,'Color',[0, 0, 0]);

end

function [Fx, Fy, Fz] = gForce(body1, body2, G)
    r = sqrt((body1(1)-body2(1))^2 + (body1(2)-body2(2))^2 + (body1(3)-body2(3))^2);
    F = (G*body1(4)*body2(4))/(r^2);
    Fx = -F*((body1(1)-body2(1))/r);
    Fy = -F*((body1(2)-body2(2))/r);
    Fz = -F*((body1(3)-body2(3))/r); 
end