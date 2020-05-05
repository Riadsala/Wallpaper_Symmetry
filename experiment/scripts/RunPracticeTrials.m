
X = meshgrid(1:32)-round(32/2);
Y = X';

theta = targThetas(1);

U = X*cos(theta) + Y*sin(theta);
V = -X*sin(theta) + Y*cos(theta);

lineSeg = zeros(32);
lineSeg(abs(U)<5/2) = 1;
lineSeg(abs(V)>25.6/2) = 0;


lineSeg(lineSeg(:)==0) = 0.75;
lineSeg(lineSeg(:)==1) = 0.2;

lineSeg = 255*lineSeg;

targTex = Screen('MakeTexture', stimuliScrn, lineSeg);
Screen('DrawTexture', stimuliScrn, targTex);
Screen('Close', targTex);
DrawFormattedText(stimuliScrn, ...
    ['Hello. First of all, we will carry out some practise trials \n' ...
    'You will be loooking for the target shown:\n' ...
    'Press f for target absent, j for target present. \n' ...
    'Press any key when you are ready to start'], ...
    display.midX-300, display.midY-200);
Screen('flip', stimuliScrn);
WaitSecs(1);
KbWait;

for trl = 1:2
    trialInfo.target = 'present';
    trialInfo.distracters = 'easy';
    trialInfo.targTheta = targThetas(1);
    % run a trial
    [resp, rt, targLoc, targVar] = RunATrial(obs, 0, trl, ...
        trialInfo, stimuliScrn, iLink, textures);
end

trl = 3;
trialInfo.target = 'absent';
trialInfo.distracters = 'easy';
trialInfo.targTheta = targThetas(1);
% run a trial
[resp, rt, targLoc, targVar] = RunATrial(obs, 0, trl, ...
    trialInfo, stimuliScrn, iLink, textures);
trl = 4;
trialInfo.target = 'absent';
trialInfo.distracters = 'hard';
trialInfo.targTheta = targThetas(1);
% run a trial
[resp, rt, targLoc, targVar] = RunATrial(obs, 0, trl, ...
    trialInfo, stimuliScrn, iLink, textures);

for trl = 5:6
    trialInfo.target = 'present';
    trialInfo.distracters = 'hard';
    trialInfo.targTheta = targThetas(1);
    % run a trial
    [resp, rt, targLoc, targVar] = RunATrial(obs, 0, trl, ...
        trialInfo, stimuliScrn, iLink, textures);
end


trl = 7;
trialInfo.target = 'absent';
trialInfo.distracters = 'hard';
trialInfo.targTheta = targThetas(1);
% run a trial
[resp, rt, targLoc, targVar] = RunATrial(obs, 0, trl, ...
    trialInfo, stimuliScrn, iLink, textures);

trl = 8;
trialInfo.target = 'absent';
trialInfo.distracters = 'easy';
trialInfo.targTheta = targThetas(1);

clear trialInfo
