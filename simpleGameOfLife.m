clc, clearvars, clf
%conways game of life simulation
%parts of this script are borrowed from this github repository: https://github.com/cmontalvo251/MATLAB/blob/master/conway/conway.m

size_of_game = 100;
mylife = randi([0 1],size_of_game,size_of_game);
newlife = mylife;
figure;
newColormap = [ 1 1 1  ;  % white
              
               0 0 0 ]; % black
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
        num_neighbors = sum(sum(mylife(veci,vecj)))-mylife(i,j);
        if mylife(i,j)
            
        if (num_neighbors < 2)
            newlife(i,j) = 0;
        end
          if (num_neighbors > 3)
              newlife(i,j) = 0;
          end
        else
              if (num_neighbors == 3)
              newlife(i,j) = 1;
          end
        end
    end
            
end
mylife = newlife;
pause(.01);
imagesc(mylife); 
colorbar;
end