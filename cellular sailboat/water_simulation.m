clc, clearvars, clf


size_of_game = 50;
mylife = randi([0 1],size_of_game,size_of_game);
newlife = mylife;

%chat gpt wrote the below section
% Create the object (CHAT GPT SECTION START)
bobbing_object_position = [size_of_game/2, size_of_game/2];  % Change these values to set the position of the object
bobbing_object_amplitude = 5;  % The amount the object bobs up and down
bobbing_object_frequency = 1;  % How quickly the object bobs up and down
bobbing_object_phase = 0;  % The starting point in the bobbing cycle
bobbing_object_time = 0;  % Keeps track of the time for the sine function
% Create the object (CHAT GPT SECTION END)

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

bobbing_object_time = bobbing_object_time + 1;
bobbing_object_height = bobbing_object_amplitude * sin(bobbing_object_frequency * bobbing_object_time + bobbing_object_phase);
bobbing_object_height = bobbing_object_height + bobbing_object_amplitude;


surf(mylife); 
hold on;  
        
hold off;  
colorbar;

view(24,89)
end

