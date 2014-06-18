function [ finalMsg ] = goDummy ( vpNummer , outputFileStr , buttonBoxON, debugEnabled )

if nargin <4
  if ~exist('vpNummer'      , 'var') ;  vpNummer      = []; endif
  if ~exist('outputFileStr' , 'var') ;  outputFileStr = []; endif
  if ~exist('buttonBoxON'   , 'var') ;  buttonBoxON   = []; endif
  if ~exist('debugEnabled'  , 'var') ;  debugEnabled  = []; endif
endif

 if isempty(vpNummer)      ;  vpNummer      = 001    ; endif
 if isempty(outputFileStr) ;  outputFileStr = 'xkcd' ; endif
 if isempty(buttonBoxON)   ;  buttonBoxON   = false  ; endif
 if isempty(debugEnabled)  ;  debugEnabled  = true   ; endif


 %% [ finalMsg ] = goDummy ( vpNummer , outputFileStr , buttonBoxON, debugEnabled )
 %  ----------------------------------------------------------------------------
%  Input:
%
%    vpNummer      = 001 (default)
%        Number of the participant. IMPRTANT this must be a number, because the
%        random seed is generated with this variable.
%
%    outputFileStr = 'xkcd' (default)
%        String variable that is added to the outputfile name
%        e.g. [experimentName 001 outputFileStr]
%
%    buttonBoxON   = false (default)
%        false == use the keyboard to get the rating input
%        true  == use a buttonbox
%
%    debugEnabled  = false (default)
%        false ==
%        true  ==
%
%  ----------------------------------------------------------------------------
%  Output:
%
%    finalMsg = custom message with no purpose but it will be nice.   I promise!
%
% ----------------------------------------------------------------------------
%  Functionality
%
%
%  ----------------------------------------------------------------------------
%  Requirements
%    Psychtoolbox-3  https://psychtoolbox-3.github.io/overview/
%    awesomeStuff    https://github.com/wuschLOR/awesomeStuff
%
%  ----------------------------------------------------------------------------
%  History
%  2014-06-13 mg  written
%  ----------------------------------------------------------------------------


%  --------------------------------------------------------------------------  %
%%  openGL
%  This script calls Psychtoolbox commands available only in OpenGL-based
%  versions of the Psychtoolbox. The Psychtoolbox command AssertPsychOpenGL will
%  issue an error message if someone tries to execute this script on a computer
%  without an OpenGL Psychtoolbox

AssertOpenGL;

%  --------------------------------------------------------------------------  %
%% debug
%  generell ist der default dass debug aus ist. sobald irgendetwas als die debuginformation angegeben wird wir debug angeworfen
%  Zur Zeit beeinflusst debug das Ausgabelevel der Warnungen und überspringt die VP Dateneingabe

switch debugEnabled
  case true
    debugLvl = 'dangerzone' % debug is turned on

  case false
    debugLvl = 'butter' % debug is false
endswitch

switch debugLvl
  case 'butter'

    %  http://psychtoolbox.org/faqwarningprefs
    newEnableFlag = 1;
    oldEnableFlag = Screen('Preference', 'SuppressAllWarnings', newEnableFlag);
    %  enableFlag can be:
    %  0  normal settingsnewEnableFlag
    %  1  suppresses the printout of warnings

    newLevelVerbosity = 1
    oldLevelVerbosity = Screen('Preference', 'Verbosity', newLevelVerbosity);
    %  newLevelVerbosity can be any of:
    %  ~0) Disable all output - Same as using the 'SuppressAllWarnings' flag.
    %  ~1) Only output critical errors.
    %  ~2) Output warnings as well.
    %  ~3) Output startup information and a bit of additional information. This is the default.
    %  ~4) Be pretty verbose about information and hints to optimize your code and system.
    %  ~5) Levels 5 and higher enable very verbose debugging output, mostly useful for debugging PTB itself, not generally useful for end-users.
    vpNummerStr= num2str(vpNummer);

  case 'dangerzone'
    newEnableFlag = 0;
    oldEnableFlag = Screen('Preference', 'SuppressAllWarnings', newEnableFlag);

    newLevelVerbosity = 3
    oldLevelVerbosity = Screen('Preference', 'Verbosity', newLevelVerbosity);
    versionptb=Screen('Version') %% das als txt irgendwo ausgeben

    vpNummerStr = num2str( strftime( '%Y%m%d%H%M%S' ,localtime (time () ) ) );

endswitch

%% Generating the outputpaths
resultsFolder    = ['.' filesep 'results' filesep]
resultsFolderStr = [resultsFolder vpNummerStr '_' outputFileStr]

fileNameDiary           = [resultsFolderStr '_diary.mat']
fileNameBackupWorkspace = [resultsFolderStr '_backupWS.mat']
fileNameOutput          = [resultsFolderStr '_output.csv']

diary (fileNameDiary)


nextSeed = vpNummer % nextSeed wird für für alle random funktionen benutzt

%  --------------------------------------------------------------------------  %
%%  disable random input tothe console

ListenChar(2)

%  Keys pressed by the subject often show up in the Matlab command window as
%  well, cluttering that window with useless character junk. You can prevent
%  this from happening by disabling keyboard input to Matlab: Add a
%  ListenChar(2); command at the beginning of your script and a
%  ListenChar(0); to the end of your script to enable/disable transmission of
%  keypresses to Matlab. If your script should abort and your keyboard is
%  dead, press CTRL+C to reenable keyboard input -- It is the same as
%  ListenChar(0). See 'help ListenChar' for more info.



%  --------------------------------------------------------------------------  %
%% Tasten festlegen

KbName('UnifyKeyNames'); %keine ahnung warum oder was das macht aber

keyEscape = KbName('escape');

keyConfirm = KbName ('Return');


%  --------------------------------------------------------------------------  %
%%  textstyles

newTextFont = 'Courier New';
newTextSize = 20;
newTextColor= [00 00 00];

%  --------------------------------------------------------------------------  %
%%  screen innizialisieren

screenNumbers=Screen('Screens');
screenID = max(screenNumbers); % benutzt den Bildschirm mit der höchsten ID
%  screenID = 1; %benutzt den Bildschirm 1 bei Bedarf ändern

%  öffnet den Screen
%  windowPtr = spezifikation des Screens die später zum ansteueren verwendet wird
%  rect hat wenn es ohne attribute initiert wird die größe des Bildschirms
%  also: von 0,0 oben links zu 1600, 900 unten rechts

  [windowPtr,rect] = Screen('OpenWindow', screenID ,[], [50 50 650 650]);
%  [windowPtr,rect] = Screen('OpenWindow', screenID ,[], [0 0 1280 800]);
%   [windowPtr,rect] = Screen('OpenWindow', screenID ,[], [1 1 1279 799]);
%  [windowPtr,rect] = Screen('OpenWindow', screenID );

% Screen('BlendFunction', windowPtr, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA); original
% Screen('BlendFunction', windowPtr, GL_ONE_MINUS_SRC_ALPHA, GL_SRC_ALPHA);
%  das hatte was mit dem transparenten hintergund zu tun - keine ahnung was das wirklich macht
[sourceFactorOld, destinationFactorOld]=Screen('BlendFunction', windowPtr, GL_ONE_MINUS_SRC_ALPHA, GL_SRC_ALPHA);
Screen('BlendFunction', windowPtr, sourceFactorOld, destinationFactorOld)

HideCursor(screenID)
flipSlack =Screen('GetFlipInterval', windowPtr)
%  flipSlack =0
flipSlack = flipSlack/2 % das verhindert das das ganze kürzer wird hier noch etwas rumspielen - da es so manchmal zu kurze anzeigezeiten kommen kann 


oldTextFont  = Screen('TextFont'  , windowPtr , newTextFont );
oldTextSize  = Screen('TextSize'  , windowPtr , newTextSize );
oldTextColor = Screen('TextColor' , windowPtr , newTextColor);

%  --------------------------------------------------------------------------  %
%%  einlesen der Ordner:

logoImg   = getImgFolder( 'startup' , 'png' );

blockRatingInfo       = getImgFolder( 'tex rating'       , 'png' );
blockInstructionInfo  = getImgFolder( 'tex instructions' , 'png' );

  stimImgType ='png'
  stimulusInfo = getImgFolder( 'stimulus' , stimImgType );


%  --------------------------------------------------------------------------  %
%% bilder einlesen

  blockRatingTex      = makeTex(windowPtr, blockRatingInfo      , 'tex rating');
  blockInstructionTex = makeTex(windowPtr, blockInstructionInfo , 'tex instructions');

  stimulusTex =  makeTex(windowPtr , stimulusInfo , 'stimulus');
  

%% version a und b generieren
%initialisiert eine Spalte von nullen die normal auf 1 gesetzt wird und in der scatter variante je nach den angegeben alternativpositionen hochaddiert bis alle einen wert von 2-5 haben die dann später durch den positonArray dekodiert werden 
  quantity.tex= length(stimulusTex)
  helparraynormal  = zeros (quantity.tex   , 1)+1;
  helparrayscatter = zeros (quantity.tex   , 1)+1;

    schinkenfix = round(quantity.tex/4);
    schinken = schinkenfix;
  do 
  helparrayscatter(1:schinken)     = helparrayscatter(1:schinken)+1;
    schinken = schinken + schinkenfix;
  until schinken == schinkenfix*4

  helparrayAB  = [helparraynormal ; helparrayscatter];
  helparrayTex = [stimulusTex ; stimulusTex];

  hartCol = [helparrayTex helparrayAB];

  

  
%  --------------------------------------------------------------------------  %
%% Blöcke Definieren
  blockDef(1).description = 'richtungsweisend';
  blockDef(2).description = 'rund';
  blockDef(3).description = 'eckig';
  blockDef(4).description = 'kurfig';
  blockDef(5).description = 'gefallen';

%  präsentationszeit definieren
  blockDef(1).presentationTime = 0.25;
  blockDef(2).presentationTime = 0.25;
  blockDef(3).presentationTime = 0.25;
  blockDef(4).presentationTime = 0.25;
  blockDef(5).presentationTime = 0.25;

  
  quantity.blocks = length(blockDef);


  for i=1:quantity.blocks
    [tempTex , nextSeed ] = randomizeCol( hartCol , nextSeed , 1 );
    blockDef(i).texStiRand = tempTex(:,1);
    blockDef(i).texSimPos  = tempTex(:,2);
  endfor

%  das entsprechende Rating zur Bedingung hinzufügen
  for i=1:quantity.blocks
      blockDef(i).texRating = blockRatingTex(i);
  endfor


% instructions
  for i=1:quantity.blocks
      blockDef(i).texInstructions = blockInstructionTex(i);
  endfor

% Zeiten festmachen in ms
  zeit.fixcross     =   80;
  zeit.prepause     =   80; 
  zeit.stimuli      =  160;
  zeit.afterpause   =  500;
  zeit.rating       = 2450;
  zeit.betweenpause =  500;  

# für alle blöcke fix machen
  for i=1:quantity.blocks
      blockDef(i).timeFixcross     = zeit.fixcross     ;
      blockDef(i).timePrepause     = zeit.prepause     ;
      blockDef(i).timeStimuli      = zeit.stimuli      ;
      blockDef(i).timeAfterpause   = zeit.afterpause   ;
      blockDef(i).timeRating       = zeit.rating       ;
      blockDef(i).timeBetweenpause = zeit.betweenpause ;
  endfor


% Blöcke insgesammt randomisieren
  rand('state' , nextSeed)
  newSequence = randperm( length(blockDef) );
  for i=1:quantity.blocks
      blockDefRand(:,:) = blockDef(newSequence);
  endfor

%  --------------------------------------------------------------------------  %
%% Positionen für 16 :9 Auflösung (300 px felder für )
%
%                3          3          3          3
%        3      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   % = border / free space
%               %% ###1L## %% ###1M## %% ###1R## %%   # = actual face
%               %% ####### %% ####### %% ####### %%
%        3      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%               %% ###2L## %% ###2M## %% ###2R## %%
%               %% ####### %% ####### %% ####### %%   + = fixation cross
%        3      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%               %% ###3L## %% ###3M## %% ###3R## %%
%               %% ####### %% ####### %% ####### %%
%        3      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  die präsentationsfelder müssen alle gleich groß sein 
% x values for all locations

x.edgeLeftStart    = rect(1);
x.edgeLeftEnd      = rect(3) / 100 *  2.34375;

    x.edgeMidLeftStart     = rect(3) / 100 * 17.96875;
    x.edgeMidLeftEnd       = rect(3) / 100 * 42.1875;

    x.edgeMidRightStart    = rect(3) / 100 * 57.8125;
    x.edgeMidRightEnd      = rect(3) / 100 * 82.03125;

x.edgeRightStart   = rect(3) / 100 * 97.65625;
x.edgeRightEnd     = rect(3);

% x IMAGE LEFT
  x.imgLeftStart     = x.edgeLeftEnd      ;
  x.imgLeftEnd       = x.edgeMidLeftStart ;
    x.imgLeftCenter  = x.imgLeftStart + (x.imgLeftEnd - x.imgLeftStart)/2;

% x IMAGE MID
  x.imgMidStart      = x.edgeMidLeftEnd    ;
  x.imgMidEnd        = x.edgeMidRightStart ;
    x.imgMidCenter   = x.imgMidStart + (x.imgMidEnd -x.imgMidStart)/2;

% x IMAGE RIGTHT
  x.imgRightStart    = x.edgeMidRightEnd ;
  x.imgRightEnd      = x.edgeRightStart  ;
    x.imgRightCenter = x.imgRightStart + (x.imgRightEnd - x.imgRightStart)/2;

x.center           = rect(3) / 2;

% y values for all locations

y.edgeTopStart     = rect(2);
y.edgeTopEnd       = rect(4) / 100 *  4.1666666667;

  y.edgeMidTopStart     = rect(4) / 100 * 31.9444444444;
  y.edgeMidTopEnd       = rect(4) / 100 * 36.1111111111;

  y.edgeMidBotStart     = rect(4) / 100 * 63.8888888889;
  y.edgeMidBotEnd       = rect(4) / 100 * 68.0555555556;

y.edgeBotStart     = rect(4) / 100 * 95.8333333333;
y.edgeBotEnd       = rect(4);



  y.imgTopStart    = y.edgeTopEnd;
  y.imgTopEnd      = y.edgeMidTopStart;
    y.imgTopCenter   = y.imgTopStart + (y.imgTopEnd - y.imgTopStart)/2;

  y.imgMidStart    = y.edgeMidTopEnd;
  y.imgMidEnd      = y.edgeMidBotStart; 
    y.imgMidCenter   = y.imgMidStart + (y.imgMidEnd - y.imgMidStart)/2;

  y.imgBotStart    = y.edgeMidBotEnd;
  y.imgBotEnd      = y.edgeBotStart;
    y.imgBotCenter   = y.imgBotStart + (y.imgBotEnd - y.imgBotStart)/2;

y.center           = rect(4) / 2;

%                 x                y            x                y
rect.L1 = [ x.imgLeftStart  y.imgTopStart  x.imgLeftEnd  y.imgTopEnd ];
rect.L2 = [ x.imgLeftStart  y.imgMidStart  x.imgLeftEnd  y.imgMidEnd ];
rect.L3 = [ x.imgLeftStart  y.imgBotStart  x.imgLeftEnd  y.imgBotEnd ];
rect.M1 = [ x.imgMidStart   y.imgTopStart  x.imgMidEnd   y.imgTopEnd ];
rect.M2 = [ x.imgMidStart   y.imgMidStart  x.imgMidEnd   y.imgMidEnd ];
rect.M3 = [ x.imgMidStart   y.imgBotStart  x.imgMidEnd   y.imgBotEnd ];
rect.R1 = [ x.imgRightStart y.imgTopStart  x.imgRightEnd y.imgTopEnd ];
rect.R2 = [ x.imgRightStart y.imgMidStart  x.imgRightEnd y.imgMidEnd ];
rect.R3 = [ x.imgRightStart y.imgBotStart  x.imgRightEnd y.imgBotEnd ];

positonArray(1) = {rect.M2};
positonArray(2) = {rect.L1};
positonArray(3) = {rect.L3};
positonArray(4) = {rect.R1};
positonArray(5) = {rect.R3};

rect.instructions =  [ x.imgLeftStart y.imgTopStart x.imgRightEnd y.imgBotEnd];
rect.rating       =  [ x.imgLeftStart y.imgBotStart x.imgRightEnd y.imgBotEnd];

infotainment(windowPtr , 'testscreen upcomming')
  Screen('FillRect', windowPtr , [255 20 147] , rect.L1  );
  Screen('FillRect', windowPtr , [255 20 147] , rect.L2  );
  Screen('FillRect', windowPtr , [255 20 147] , rect.L3  );
  Screen('FillRect', windowPtr , [255 20 147] , rect.M1  );
  Screen('FillRect', windowPtr , [255 20 147] , rect.M2  );
  Screen('FillRect', windowPtr , [255 20 147] , rect.M3  );
  Screen('FillRect', windowPtr , [255 20 147] , rect.R1  );
  Screen('FillRect', windowPtr , [255 20 147] , rect.R2  );
  Screen('FillRect', windowPtr , [255 20 147] , rect.R3  );

Screen('Flip', windowPtr)
  KbPressWait;
Screen('Flip', windowPtr)

infotainment(windowPtr , 'rating testscreen')
  Screen('FillRect', windowPtr , [255 20 147] , rect.rating  );
  
Screen('Flip', windowPtr)
  KbPressWait;
Screen('Flip', windowPtr)

infotainment(windowPtr , 'instructions testscreen')
  Screen('FillRect', windowPtr , [255 20 147] , rect.instructions  );

Screen('Flip', windowPtr)
  KbPressWait;
Screen('Flip', windowPtr)


%  --------------------------------------------------------------------------  %
%% berechnen der skalierten Bilder + Lokalisation

o = length(blockDefRand)
for j=1:o % für alle definierten Blöcke

  m = length(blockDefRand(j).texStiRand);
  for i = 1:m % für alle vorhandenen Elemente im texStiRand

    %  herrausfinden wie groß die textur ist - anhand des tex pointers
    texRect      = Screen('Rect' , blockDefRand(j).texStiRand(i) );
    % verkleinern erstellen eines recht in das die textur gemalt wird ohne sich zu verzerren
    finRect  = putRectInRect( positonArray( blockDefRand(j).texSimPos(i) ){}  , texRect  );
    % abspeichern
    blockDefRand(j).finRect(i,1) = {finRect};
  endfor

endfor

for j=1:o
  texRating  = Screen('Rect' , blockRatingTex(j) );
  finRectRating = putRectInRect (rect.rating , texRating);
  blockDefRand(j).finRectRating = {finRectRating};
endfor

for j=1:o
  texInstructions  = Screen('Rect' , blockDefRand(j).texInstructions );
  finRectInstructions = putRectInRect (rect.instructions , texInstructions);
  blockDefRand(j).finRectInstructions = {finRectInstructions};
endfor

%  --------------------------------------------------------------------------  %
# MAINPART: THE MIGHTY EXPERIMENT
%  --------------------------------------------------------------------------  %

  o = length(blockDefRand);
  for j=1:o  % für alle definierten Blöcke

    Screen( 'DrawTexture' , windowPtr , blockDefRand(j).texInstructions , [] , blockDefRand(j).finRectInstructions{});
    Screen('Flip', windowPtr);
    KbPressWait;

    m = length(blockDefRand(j).texStiRand);
    [empty, empty , timeBlockBegin ]=Screen('Flip', windowPtr);

    nextFlip = 0;
    infotainment(windowPtr , 'preflip')
    tic
    toc
    [empty,empty,lastFlip ]=Screen('Flip', windowPtr , nextFlip);
    nextFlip = lastFlip + blockDefRand(j).timePrepause - flipSlack;
    infotainment(windowPtr ,  'after flip')
    datestr(lastFlip)
    datestr(now)
    datestr(nextFlip)
    for i = 1:m
        infotainment(windowPtr , 'inblock')
      # PAUSE BETWEEN
        Screen('FrameRect', windowPtr , [255 20 147] , rect.L1  );
        #flip
        [empty, empty , lastFlip ] =Screen('Flip', windowPtr);
        nextFlip = lastFlip + blockDefRand(j).timePrepause - flipSlack;
        infotainment(windowPtr , 'rum pause')'
#       
#       # FIXCROSS
#       Screen('FrameRect', windowPtr , [255 20 147] , rect.L1  );
#       drawFixCross (windowPtr , [18 18 18] , x.center , y.center , 80 , 2 );
#         #flip
#         [empty, empty , lastFlip ] =Screen('Flip', windowPtr , nextFlip);
#         nextFlip = lastFlip + blockDefRand(j).timeFixcross - flipSlack;
# 
#        
#       # PAUSE PRE
#         #flip
#         [empty, empty , lastFlip ] =Screen('Flip', windowPtr , nextFlip);
#         nextFlip = lastFlip + blockDefRand(j).timePrepause - flipSlack;
# 
#       
#       # STIMULUS
#       Screen('FrameRect', windowPtr , [255 20 147] , rect.L1  );
#         #flip
#         [empty, empty , lastFlip ] =Screen('Flip', windowPtr , nextFlip);
#         nextFlip = lastFlip + blockDefRand(j).timeStimuli - flipSlack;
# 
#       # PAUSE AFTER
#         #flip
#         [empty, empty , lastFlip ] =Screen('Flip', windowPtr , nextFlip)
#         nextFlip = lastFlip + blockDefRand(j).timeAfterpause - flipSlack;
# 
#       # RATING
#       Screen('FrameRect', windowPtr , [255 20 147] , rect.L1  );
#         #flip
#         [empty, empty , lastFlip ] =Screen('Flip', windowPtr , nextFlip)
#         nextFlip = lastFlip + blockDefRand(j).timeRating - flipSlack;
    endfor
endfor

       
#       Screen('FrameRect', windowPtr , [255 20 147] , rect.L1  );
# 
#       Screen('DrawTexture', windowPtr, blockDefRand(j).texStiRand(i,1) , [] , blockDefRand(j).finRectLeft(i,1){} );
#       Screen('DrawTexture', windowPtr, blockDefRand(j).texStiRand(i,2) , [] , blockDefRand(j).finRectRight(i,2){} );
# 
# 
#       %  Fixationskreuz
#       drawFixCross (windowPtr , [18 18 18] , x.center , y.center , 80 , 2 );
# 
#       [empty, empty , lastFlip ] =Screen('Flip', windowPtr , nextFlip)
#       nextFlip = lastFlip + blockDefRand(j).presentationTime - flipSlack
# 
#     endfor
# 
#     [empty,empty,timeBlockEnd ]=Screen('Flip', windowPtr , nextFlip)
#     timeBlockTicToc = toc
# 
#     %  Blende wieder zurückstellen
#     Screen('BlendFunction', windowPtr, sourceFactorOld, destinationFactorOld)
# 
#     % Rating anzeigen
#     switch buttonBoxON
#       case false
#         Screen( 'DrawTexture' , windowPtr , blockDefRand(j).texRating , [] , blockDefRand(j).finRectRating{})
#         Screen('Flip', windowPtr)
# 
#         % reaktionszeit abgreifen
#         [pressedButtonTime , pressedButtonValue , pressedButtonStr , pressedButtonCode] = getRating
# 
#         timeReactionSinceBlockBegin = pressedButtonTime - timeBlockBegin
#         timeReactionSinceBlockEnd   = pressedButtonTime - timeBlockEnd
#       case true
#         % i should think about something
#       otherwise
#         % critical error - this should not happen
#     endswitch
# 
#   %    dem outputfile werte zuweisen
#     headings        = { ...
#       'vpNummer' , ...
#       'BunusString' , ...
#       'Index' , ...
#       'Block' , ...
#       'KeyString' , ...
#       'KeyValue'  , ...
#       'ReaktionszeitBlockStart' , ...
#       'ReaktionszeitBlockEnd' , ...
#       'tic toc (sec)'   }
# 
#     outputCell(j,:) = {...
#       vpNummer  ,...
#       outputFileStr , ...
#       num2str(j),...
#       blockDefRand(j).description ,...
#       pressedButtonStr ,...
#       pressedButtonValue , ...
#       timeReactionSinceBlockBegin , ...
#       timeReactionSinceBlockEnd , ...
#       timeBlockTicToc  }
#     % attatch names to the outputCell
#     outputCellFin= [headings ; outputCell]
#     %  speicherndes output files
#     cell2csv ( fileNameOutput , outputCellFin, ';')
#     
#   endfor











headings   = {'lala'};
outputCell = {1337};





%  und hier ist es vorbei

%  --------------------------------------------------------------------------  %
%%  Data saving

infotainment(windowPtr , 'saving your data')

%  den workspace sichern (zur fehlersuche usw)
save (fileNameBackupWorkspace)

% attatch names to the outputCell
outputCellFin= [headings ; outputCell]

%  speicherndes output files
cell2csv ( fileNameOutput , outputCellFin, ';')


diary off

%  --------------------------------------------------------------------------  %
%%  end all processes
infotainment(windowPtr , 'target aquired for termination')

ListenChar(0)
Screen('closeall')

finalMsg = 'geschafft'

endfunction












