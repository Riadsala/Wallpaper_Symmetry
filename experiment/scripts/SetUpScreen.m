%% set-up screen
bkgrndGreyLevel = 127;
N = 512;
% do we want to remove this line eventually?
Screen('Preference', 'SkipSyncTests', 1);

stimuliScrn = Screen('OpenWindow',0, bkgrndGreyLevel );% , 
[display.width, display.height]=Screen('WindowSize', stimuliScrn);
display.midX = round(display.width/2);
display.midY = round(display.height/2);

% blank screen
blank = bkgrndGreyLevel*ones(N);
textures.blank = Screen('MakeTexture', stimuliScrn, blank);
clear blank

% fixation cross
fixCross = makeFixCross(N, [bkgrndGreyLevel bkgrndGreyLevel bkgrndGreyLevel], N/2, N/2, 32);
textures.fixCross = Screen('MakeTexture', stimuliScrn, fixCross);
clear fixCross

% set font size
Screen('TextSize',stimuliScrn, 20);

KbName('UnifyKeyNames')

% load GetSecs and WaitSecs from memory
GetSecs;
WaitSecs(.01);

noiseMask = 127 + 255 * (rand(150, 150)-0.5);
noiseMask = imresize(noiseMask, 4, 'nearest');
noiseMask(noiseMask<0) = 0;
noiseMask(noiseMask>255) = 255;
% create a cicrular mask
x = repmat(1:600, [600, 1])-300; 
d = x.^2 + x'.^2;
d = d<=300^2;
noiseMask = noiseMask .* d;
noiseMask(noiseMask(:) == 0) = 127;


textures.noiseMask = Screen('MakeTexture', stimuliScrn, noiseMask);

clear noiseMask

% HideCursor;