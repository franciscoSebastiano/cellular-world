%this function lets you rotate a matlab frame during an animation by chaning the view
%to use the function, first create a figure by typing "wasd_keys;" at the
%top of your program. Then, place this code in your animation loop to
%modify the view mid animation using WASD: view(30+d_count-a_count,30+w_count-s_count);


function wasd_keys
  fig = figure('KeyPressFcn', @KeyPressCb, 'Name', 'Control Window', 'color', [0 0 0], 'NumberTitle', 'off');
  uicontrol('Style', 'text', 'String', 'Press WASD keys', 'Position', [20 20 100 20]);

  assignin('base', 'w_count', 0);
  assignin('base', 'a_count', 0);
  assignin('base', 's_count', 0);
  assignin('base', 'd_count', 0);

  function KeyPressCb(~, event)
    switch event.Key
      case 'w'
        assignin('base', 'w_count', evalin('base', 'w_count') + 1);
      case 'a'
        assignin('base', 'a_count', evalin('base', 'a_count') + 1);
      case 's'
        assignin('base', 's_count', evalin('base', 's_count') + 1);
      case 'd'
        assignin('base', 'd_count', evalin('base', 'd_count') + 1);
    end
  end
end
