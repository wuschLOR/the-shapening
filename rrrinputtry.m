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
#   [windowPtr,rect] = Screen('OpenWindow', screenID ,[], [0 0 1280  800]);  #  16:10 wu Laptop
#   [windowPtr,rect] = Screen('OpenWindow', screenID ,[], [0 0 1680 1050]);  #  16:10 wu pc
#   [windowPtr,rect] = Screen('OpenWindow', screenID ,[], [0 0 1920 1080]);  #  16:9  testrechner

#  Windowed
#   [windowPtr,rect] = Screen('OpenWindow', screenID ,[], [20 20 620 620]); # 1:1
#   [windowPtr,rect] = Screen('OpenWindow', screenID ,[], [20 20 600 375]); # 16:10
  [windowPtr,rect] = Screen('OpenWindow', screenID ,[], [20 20 600 337]); # 16:9

  nextSeed=22;
%  --------------------------------------------------------------------------  %
%%  settings einlesen
  rawCell = csv2cell( 'settings.csv' , ';');

  head     = rawCell(1     , :); #  zerlegten der Settings in den header
  body     = rawCell(2:end , :); #  und dem inhaltlichen body

%% konvertieren 
  def = cell2struct (body, head ,2); #  konvertieren zum struct
  def = orderfields(def) #  und sortieren um ihn lesbar zu machen zu machen

  BLOCKS = length(def)
  
% Blöcke randomisieren
  rand('state' , nextSeed)
  newSequence = randperm( length(def) );
  for i=1:BLOCKS
      def(:,:) = def(newSequence);
  endfor

# def =
# {
#   5x1 struct array containing the fields:
# 
#     blockName
#     blockNumber
#     instructionFile
#     instructionFolder
#     ratingFile
#     ratingFolder
#     stimImgFolder
#     stimImgType
#     zeitAfterpause
#     zeitBetweenpause
#     zeitFixcross
#     zeitPrepause
#     zeitRating
#     zeitStimuli
# }

%%  Settings verarbeiten
  for BQA=1:length(def) #  BQA == blockquantity
    def(BQA).stimImgInfo      = getFilesInFolderInfo (def(BQA).stimImgFolder     , def(BQA).stimImgType    ); #  stimulus Info holen
    def(BQA).ratingInfo       = getFileInfo          (def(BQA).ratingFolder      , def(BQA).ratingFile     ); #  rating Infos holen
    def(BQA).instructionInfo  = getFileInfo          (def(BQA).instructionFolder , def(BQA).instructionFile); #  instuctions info holen
    def(BQA).stimImgInfo       = makeTexFromInfo (windowPtr , def(BQA).stimImgInfo    );
    def(BQA).ratingInfo        = makeTexFromInfo (windowPtr , def(BQA).ratingInfo     );
    def(BQA).instructionInfo   = makeTexFromInfo (windowPtr , def(BQA).instructionInfo);

    STIMQA= length(def(BQA).stimImgInfo); % wie viele Spalten hat stimImgInfo (so viele wie es stimulus im ordner gibt)
    helpNORMAL  =  zeros (STIMQA , 1)+1;
    helpSCATTER =  zeros (STIMQA , 1)+1;

      schinkenfix = round(STIMQA/4);
      schinken = schinkenfix;
    do
      helpSCATTER(1:schinken)  = helpSCATTER(1:schinken)+1;
      schinken = schinken + schinkenfix;
    until schinken >= schinkenfix*4

    positionCol  = [helpNORMAL ; helpSCATTER];
    textureCol = [ (1:STIMQA)' ; (1:STIMQA)' ];

    hartCol = [textureCol positionCol];
    [tempCol , nextSeed ] = randomizeCol( hartCol , nextSeed , 1 );
    def(BQA).randColTex = tempCol(:,1);
    def(BQA).randColPos = tempCol(:,2);
     
    for TTT=1:length(def(BQA).randColTex)
      def(BQA).RstimImgInfo(TTT) = def(BQA).stimImgInfo( def(BQA).randColTex(TTT,:) );
    endfor

  endfor


  Screen('closeall')






