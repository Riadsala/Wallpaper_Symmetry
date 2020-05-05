if blk > 1
    
    DrawFormattedText(stimuliScrn, ...
        'End of block. Please take a break', ...
        display.midX-300, display.midY-200);
    Screen('flip', stimuliScrn);
    WaitSecs(1);
    KbWait;
    EyelinkDoTrackerSetup(iLink.el);
    
end

X = meshgrid(1:32)-round(32/2);
Y = X';

theta = trialList(blk, 1).targTheta;

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
    ['Welcome to block ', int2str(blk), ' \n' ...
    'You will be looking for the target shown:\n' ...
    'Press f for target absent, j for target present. \n' ...
    'Press any key when you are ready to start'], ...
    display.midX-300, display.midY-200);
Screen('flip', stimuliScrn);
WaitSecs(1);
KbWait;

