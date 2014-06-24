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

%  --------------------------------------------------------------------------  %
%%  settings einlesen
rawCell = csv2cell( 'settings.csv' , ';');

head     = rawCell(1     , :); #  zerlegten der Settings in den header
body     = rawCell(2:end , :); #  und dem inhaltlichen body


def = cell2struct (body, head ,2); #  konvertieren zum struct
def = orderfields(def) #  und sortieren um ihn lesbar zu machen zu machen

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
  def(BQA).stimImgTex     = makeTexFromInfo (windowPtr , def(BQA).stimImgInfo    )
  def(BQA).stimratingTex  = makeTexFromInfo (windowPtr , def(BQA).ratingInfo     )
  def(BQA).instructionTex = makeTexFromInfo (windowPtr , def(BQA).instructionInfo)
endfor





