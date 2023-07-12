
size_of_game = 50;
half_point = 1250;
mylife = randi([0 10],size_of_game,size_of_game);
wasd_keys; %was_keys is my own function. It can be found in the github repoisitory
newlife = mylife; 
newColormap = [ 135 206 250; 135 206 250; 135 206 250; 135 206 250; 135 230 250; 135 230 250; 135 230 250; 135 230 250; 135 230 250; 0 0 255; 0 0 255; 0 0 255; 0 0 255;
                150 255 160; 255 200 0; 127 255 0; 255 200 0; 34,139,34; 255 240 0; 34,139,34; 255 255 0; 34,139,50; 255 130 0;]; 
newColormap = newColormap/255;
colormap(newColormap)


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
        binarylife = logical(mylife);
        land = logical(mylife>6);
        land = sum(land,"all");
        
       
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
          if num_neighbors == 3
              newlife(i,j) = newlife(i,j)+.5;
          elseif num_neighbors > 2 && num_neighbors < 4
              newlife(i,j) = newlife(i,j)+.5;
          end
          if newlife(i,j) > 6
              newlife(i,j)= 6;
          end
        end
                  
         if mylife(i,j) > 6 && (mod(mylife(i,j), 1) == 0)
              if (mylife(i,j)*3 >= val_neighbors)
                  newlife(i,j) = mylife(i,j)-1;
              elseif (mylife(i,j) < val_neighbors/8) && mylife(i,j)<15
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
    end

    end
    
           

mylife = newlife;
displaylife = mylife/6;
pause(0.01);


[r,c] = size(mylife); 
[R,C] = ndgrid(1:r, 1:c);

theta = (C./c)*2*pi;  
phi = (R./r)*pi; 

scaled_mylife = 1 + 0.06 * (mylife - min(mylife(:))) / (max(mylife(:)) - min(mylife(:)));

[X,Y,Z] = sph2cart(theta-pi, phi-pi/2, scaled_mylife);  

surf(X,Y,Z,mylife, 'EdgeColor', 'none');  
set(gca,'Color',[0 0 0])


colorbar;
clim([0,11])

view(14+d_count-a_count,14+w_count-s_count);



axis equal

end
