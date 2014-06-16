function [ finalMsg ] = goDummy ( vpNummer , outputFileStr , buttonBoxON, debugEnabled )

% initialisieren der fehlenden Variablen
if nargin <4
  if ~exist('vpNummer'      , 'var') ;  vpNummer      = []; endif
  if ~exist('outputFileStr' , 'var') ;  outputFileStr = []; endif
  if ~exist('buttonBoxON'   , 'var') ;  buttonBoxON   = []; endif
  if ~exist('debugEnabled'  , 'var') ;  debugEnabled  = []; endif
endif

% default werte initialisieren
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

  %paarungen definieren !!!!!!!!!!!!!muss rausgeworfen werden und die Funktion umgeschrieben oder verbessert werden !!!!!!!!!!!!!!!
  blockDef(1).texColum = [stimulusTex stimulusTex];
  blockDef(2).texColum = [stimulusTex stimulusTex];
  blockDef(3).texColum = [stimulusTex stimulusTex];
  blockDef(4).texColum = [stimulusTex stimulusTex];
  blockDef(5).texColum = [stimulusTex stimulusTex];
  
  howManyBlocks = length(blockDef);

%  Stimuli randomisieren !!!!!!!!!!!!!!!!!! hier muss noch rein dass A und B richtig zugeordnet werden
  for i=1:howManyBlocks
    [blockDef(i).texColumRand , nextSeed ] = randomizeColMatrix( blockDef(i).texColum , nextSeed , 2 , false , false );
  endfor

%  das entsprechende Rating zur Bedingung hinzufügen
  for i=1:howManyBlocks
      blockDef(i).texRating = blockRatingTex(i);
  endfor


% instructions
  for i=1:howManyBlocks
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
  for i=1:howManyBlocks
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
  for i=1:howManyBlocks
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

% putting together die rects [ x y x y]
rectImgLeft        = [x.imgLeftStart  y.imgTopStart    x.imgLeftEnd     y.imgBotEnd    ];
rectImgRight       = [x.imgRightStart y.imgTopStart    x.imgRightEnd    y.imgBotEnd    ];
rectImgInstruction = [x.edgeLeftEnd   y.edgeTopEnd     x.edgeRightStart y.edgeBotStart ];
rectImgRating      = [x.edgeLeftEnd   y.imgRatingStart x.edgeRightStart y.imgRatingEnd ];

















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












