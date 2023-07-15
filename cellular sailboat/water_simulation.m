clc, clearvars, clf

size_of_game = 50;
mylife = randi([0 1],size_of_game,size_of_game);
newlife = mylife;

figure;

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
        elseif mylife(i,j)<=6
      
          if num_neighbors == 3
              newlife(i,j) = newlife(i,j)+1;
          elseif num_neighbors > 2 && num_neighbors < 4
              newlife(i,j) = newlife(i,j)+0.5;
          end
    end
end
end
    
mylife = newlife;
pause(0.01);

surf(mylife); 
hold on;  
        
hold off;  
colorbar;

view(24,89)
end

