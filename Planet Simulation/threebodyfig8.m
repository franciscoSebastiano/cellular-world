clearvars, clf, 

%3 body problem numerical approximation written by Francisco Sebastiano

[D,E,F] = sphere;
r = .1;
X2 = D * r;
Y2 = E * r;
Z2 = F * r;

wasd_keys; % this is my own function. It's available in the github repository.
positionLogCount = 100;
stepCount = 0;
logCount = stepCount;

planet1Positions = zeros(positionLogCount,3);
moon1Positions = zeros(positionLogCount,3);
sunPositions = zeros(positionLogCount,3);

sunMass = 1;
planet1Mass = 1;
moon1Mass = 1;
G = 1;
dt = 0.1;
planet1Position = [11, 10, 10, planet1Mass]; %The 4th index is body mass so that the mass can be cleanly passed as an argument into functions.
sunPosition = [9,10,10, sunMass]; 
moon1Position = [10, 10, 10, moon1Mass];


sunVelocity = [0.347,0.5327,1];
planetVelocity = [0.347,0.5327,1];
moonVelocity = [-2*0.3471,-2*0.5327,1];

h_planet = plot3(planet1Position(1),planet1Position(2),planet1Position(3),'.','MarkerSize',30);% plot planet in 3D
hold on;
moon = plot3(moon1Position(1),moon1Position(2),moon1Position(3),'.','MarkerSize',10);
%sun = plot3(0,0,0,'.','MarkerSize',100);  % plot sun at origin in 3D
s1 = surf(X2+sunPosition(1),Y2+sunPosition(2),Z2+sunPosition(3));
s2 = plot3(moon1Positions(1:logCount, 1), moon1Positions(1:logCount, 2), moon1Positions(1: logCount, 3), 'color', [1 1 1]);
s3 = plot3(planet1Positions(1:logCount, 1), planet1Positions(1:logCount, 2), planet1Positions(1:logCount, 3), 'color', [1 1 1]);
s4 = plot3(sunPositions(1:logCount, 1), sunPositions(1:logCount, 2), sunPositions(1:logCount, 3), 'color', [1 1 1]);


hold off;
xlabel('x');
ylabel('y');
zlabel('z'); % added a z label for the plot
title('Animation of a Planet Rotating Around the Sun in 3D');

while 1
    %code
    stepCount = stepCount+1;

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

    set(h_planet, 'XData', planet1Position(1), 'YData', planet1Position(2), 'ZData', planet1Position(3));
    hold on
    set(moon, 'XData', moon1Position(1), 'YData', moon1Position(2), 'ZData', moon1Position(3));
    delete(s1);delete(s2); delete(s3); delete(s4);
    s1 = surf(X2+sunPosition(1),Y2+sunPosition(2),Z2+sunPosition(3));
    logCount = stepCount;

    if stepCount <= positionLogCount
    planet1Positions(stepCount, :) = planet1Position(1:3);
    moon1Positions(stepCount, :) = moon1Position(1:3);
    sunPositions(stepCount, :) = sunPosition(1:3); 
    else
    planet1Positions = [planet1Positions(2:end, :); planet1Position(1:3)];
    moon1Positions = [moon1Positions(2:end, :); moon1Position(1:3)];
    sunPositions = [sunPositions(2:end, :); sunPosition(1:3)];
    logCount = positionLogCount;
    end
    s2 = plot3(moon1Positions(1:logCount, 1), moon1Positions(1:logCount, 2), moon1Positions(1: logCount, 3), 'color', [1 1 1]);
    s3 = plot3(planet1Positions(1:logCount, 1), planet1Positions(1:logCount, 2), planet1Positions(1:logCount, 3), 'color', [1 1 1]);
    s4 = plot3(sunPositions(1:logCount, 1), sunPositions(1:logCount, 2), sunPositions(1:logCount, 3), 'color', [1 1 1]);

    hold off
    
    view(10+d_count-a_count,5+w_count-s_count);
    pause(0.001);
    xlim([8.8, 11.2]);
    ylim([8.8, 11.2]);
    zlim([8.8,100]);
    set(gca,'Color',[0, 0, 0]);
    grid on
    
end

function [Fx, Fy, Fz] = gForce(body1, body2, G)
    r = sqrt((body1(1)-body2(1))^2 + (body1(2)-body2(2))^2 + (body1(3)-body2(3))^2);
    F = (G*body1(4)*body2(4))/(r^2);
    Fx = -F*((body1(1)-body2(1))/r);
    Fy = -F*((body1(2)-body2(2))/r);
    Fz = -F*((body1(3)-body2(3))/r); 
end



