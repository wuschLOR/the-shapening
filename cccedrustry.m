%  --------------------------------------------------------------------------  %
%%  init screen

screenNumbers=Screen('Screens');
screenID = max(screenNumbers); % benutzt den Bildschirm mit der höchsten ID
%  screenID = 1; %benutzt den Bildschirm 1 bei Bedarf ändern

%  öffnet den Screen
%  windowPtr = spezifikation des Screens die später zum ansteueren verwendet wird
%  rect hat wenn es ohne attribute initiert wird die größe des Bildschirms
%  also: von 0,0 oben links zu 1600, 900 unten rechts

# Auflösungen:
#  Vanilla
#   [windowPtr,rect] = Screen('OpenWindow', screenID );

#  Normal sreens
#   [windowPtr,rect] = Screen('OpenWindow', screenID ,[], [0 0 1279  800]);  #  16:10 wu Laptop
#   [windowPtr,rect] = Screen('OpenWindow', screenID ,[], [0 0 1679 1050]);  #  16:10 wu pc
#   [windowPtr,rect] = Screen('OpenWindow', screenID ,[], [0 0 1919 1080]);  #  16:9  testrechner

#  Windowed
#   [windowPtr,rect] = Screen('OpenWindow', screenID ,[], [20 20 620 620]); # 1:1
#   [windowPtr,rect] = Screen('OpenWindow', screenID ,[], [20 20 600 375]); # 16:10
  [windowPtr,rect] = Screen('OpenWindow', screenID ,[], [20 20 600 337]); # 16:9
fprintf('initCedrusUSBLinux \n')

[handle , BBworking ] = initCedrusUSBLinux


fprintf('ready press pls\n')


for i=1:10
  Screen('FrameRect', windowPtr , [255 20 147] );
    [empty, empty , lastFlip ] =Screen('Flip', windowPtr);
  do
    evt = CedrusResponseBox('GetButtons', handle);
  until ~isempty(evt)
  aaa(i)=evt;
  infotainment(windowPtr , 'lalala')

  buttons = 1;
  while any(buttons(1,:))
    buttons = CedrusResponseBox('FlushEvents', handle);
  end

endfor

try
  CedrusResponseBox('CloseAll');
  fprintf('closeall')
end
Screen('closeall')
