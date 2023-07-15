clc, clearvars, clf

size_of_game = 30;
mylife = randi([0 1],size_of_game,size_of_game);
newlife = mylife;

wasd_keys;

boat = stlread('sailboat.stl');
shift = [0, 0, 0];
shift(1) = (size_of_game/2)*50;
shift(2) = (size_of_game/2)*50;
shift(3) = 0;

rotation_angle_x = 0;  
rotation_angle_y = 0;  
rotation_angle_z = 0;  

while 1

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
        num_neighbors = sum(sum(mylife(veci,vecj)))-mylife(i,j);

        if mylife(i,j)
         if num_neighbors < 2
         newlife(i,j) = newlife(i,j)-0.5;
          end

          if num_neighbors > 3
              newlife(i,j) = newlife(i,j)-0.5;
          end
          if num_neighbors == 3
              newlife(i,j) = newlife(i,j)+1;
          elseif num_neighbors > 2 && num_neighbors < 4
              newlife(i,j) = newlife(i,j)+0.5;
          end
 
    else
      
          if num_neighbors == 3
              newlife(i,j) = newlife(i,j)+1;
          elseif num_neighbors > 2 && num_neighbors < 4
              newlife(i,j) = newlife(i,j)+0.5;
          end
    end
end
end
    
mylife = newlife;

X = round(shift(1)/50);
Y = round(shift(2)/50);
X(X==0) = size_of_game;
X(X==size_of_game+1) = 1;
Y(Y==0) = size_of_game;
Y(Y==size_of_game+1) = 1;
rearheight = mylife(X-1,Y);
frontheight = mylife(X+1, Y);
leftheight = mylife(X, Y+1);
rightheight = mylife(X, Y-1);
directheight = mylife(X,Y);

shift(1) = shift(1) + (rearheight - frontheight)*2.5;
shift(2) = shift(2) + (rightheight - leftheight)*2.5;
shift(3) = (directheight*5);

if (rightheight - leftheight) > 1
    rotation_angle_x = rotation_angle_x - pi/100;
elseif (rightheight - leftheight) < -1
        rotation_angle_x = rotation_angle_x + pi/100;
elseif rotation_angle_x > 0;
    rotation_angle_x = rotation_angle_x-pi/50;
elseif rotation_angle_x < 0;
    rotation_angle_x = rotation_angle_x+pi/50;
end
if (rearheight - frontheight) > 1
    rotation_angle_z = rotation_angle_z + pi/100;
    rotation_angle_y = rotation_angle_y + pi/100;
elseif (rearheight - frontheight) < -1
        rotation_angle_y = rotation_angle_y - pi/100;
        rotation_angle_z = rotation_angle_z - pi/100;
elseif rotation_angle_y > 0;
    rotation_angle_y = rotation_angle_y-pi/50;
elseif rotation_angle_y < 0;
    rotation_angle_y = rotation_angle_y+pi/50;
end


pause(0.1);

vertices = boat.Points;
faces = boat.ConnectivityList;
vertices = vertices + shift;
scale_factor = 0.02;  
vertices = vertices * scale_factor;

rotation_matrix_x = [1, 0, 0; 0, cos(rotation_angle_x), -sin(rotation_angle_x); 0, sin(rotation_angle_x), cos(rotation_angle_x)];
rotation_matrix_y = [cos(rotation_angle_y), 0, sin(rotation_angle_y); 0, 1, 0; -sin(rotation_angle_y), 0, cos(rotation_angle_y)];
rotation_matrix_z = [cos(rotation_angle_z), -sin(rotation_angle_z), 0; sin(rotation_angle_z), cos(rotation_angle_z), 0; 0, 0, 1];

center = mean(vertices, 1);

vertices = vertices - center;

vertices = (rotation_matrix_x * vertices')';
vertices = (rotation_matrix_y * vertices')';
vertices = (rotation_matrix_z * vertices')';

vertices = vertices + center;

boat_shifted = triangulation(faces, vertices);

displaylife = mylife/6;
surf(displaylife); 
hold on; 

xlim([0, 30])
ylim([0, 30])
zlim([0, 10])
view(10+d_count-a_count,5+w_count-s_count);

trimesh(boat_shifted, 'FaceColor', [1, 0.55, 0], 'EdgeColor', 'black');
colorbar;
clim([0,1]);
set(gca,'Color',[223/255, 247/255, 250/255])
grid off;
hold off;  

end
