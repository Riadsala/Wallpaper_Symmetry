function experiment



PsychImaging(‘PrepareConfiguration’);
PsychImaging(‘AddTask’, ‘FinalFormatting’, ‘DisplayColorCorrection’, ‘SimpleGamma’);
// >>Open Window code<<
PsychColorCorrection(‘SetEncodingGamma’, win, 1/gamma);



groupsToTest = {...
    'P2', 'PM' ,'PG', 'CM', 'PMM', 'PMG', 'PGG', 'CMM', 'P4', 'P4M', 'P4G', 'P3', 'P3M1', 'P31M', 'P6', 'P6M'};

obsID = input('please enter participant id number: ');
resultsFolder = ['results/person', int2str(obsID)];
mkdir(resultsFolder);

% init random seed!
rng(obsID, 'twister');


%% set parameters for experiment
params.staircaseLength = 30; % number of trials in each staircase
params.nRepetitions = 4; % number of interleaved staircases
params.nLearning = 10; % total number of practise trials

params.initDisplayDur = [0.256, 0.128, 0.064, 0.032, 0.064]; % initial display durations for each staircase
params.practiceDur = 0.500; % how long should the practise duration

params.minDuration = 0.005;
params.maxDuration = 1.000;

params.fixCrossDur = 1.000;
params.isiDuration = 0.700; % inter-stimuli blank
params.noiseMaskDuration = 0.300;
params.stimuliContrast = 0.5;
params.rotate = 1;

params.imagesPerCondition = 50;

addpath('scripts/');

% check which groups have been done already!
files = dir([resultsFolder '/*.txt']);
files = files([files.isdir] == 0);

for ff = 1:length(files)
    grp = regexp(files(ff).name, '[PMGC12346]*(?=.txt)', 'match');
    groupsToTest = groupsToTest(~strcmp(groupsToTest, grp));
end
groupsLeft = length(groupsToTest);
% randomly select one of the remaining groups to test this block
group = groupsToTest{randi(groupsLeft)};

% set up screen and basic textures
SetUpScreen;

% get list of stimuli for current group
stimuli = stimuliToTest(group, params.imagesPerCondition);

% output file
fout = fopen([resultsFolder '/' group '.txt'], 'w');
fprintf(fout, 'person, group, rep, n, t, t1, t2, correct\n');

% set up Quest
pThreshold = 0.82;
beta = 3.5; delta = 0.1; gamma = 0.5;
tGuess = log10(params.initDisplayDur);
tGuessSd = 3;

% set up structure to hold staircase info

for rep = 1:params.nRepetitions
    staircase(rep).q = ...
        QuestCreate(tGuess(rep), tGuessSd, pThreshold, beta, delta, gamma); %#ok<AGROW>
    staircase(rep).q.normalizePdf = 1; %#ok<AGROW>
end
% final staircase is master!
master_staircase.q = ...
    QuestCreate(tGuess(5), tGuessSd, pThreshold, beta, delta, gamma);
master_staircase.q.normalizePdf = 1;

% display start of practise message
DrawFormattedText(stimuliScrn, ['Practice trials \n ' int2str(groupsLeft) ' groups left!'], 'center', 'center');
Screen('flip', stimuliScrn);
WaitSecs(0.5);
KbWait;



%% first do some training trials with feedback!

DrawFormattedText(stimuliScrn, 'Some practise trials', 'center', 'center');
Screen('flip', stimuliScrn);
WaitSecs(0.5);
KbWait;

still_training = 1;
while still_training
    trls_correct = 0;
    
    for trl = 1:params.nLearning
        [correct, tTestA, actualDur]  = RunATrial(log10(params.practiceDur),  ...
            stimuliScrn, stimuli, textures, params);
        
        trls_correct = trls_correct + correct;
        % display feedback!
        if correct
            col = [50, 150, 50];
            Beeper(800)
        else
            col = [205, 15, 75];
            Beeper(350, 0.5, 0.5);
        end
        
        Screen('FillRect', stimuliScrn, col);
        Screen('flip', stimuliScrn);
        WaitSecs(1);
        % clear
        Screen('FillRect', stimuliScrn, 127);
        
        fprintf(fout, '%d, %s, %d, %d, %.3f, %.3f, %.3f, %d\n', ...
            obsID, group, 0, trl, log10(params.practiceDur),...
            actualDur(1), actualDur(2), correct);
    end
    
    % display score for practise block
    if trls_correct/params.nLearning > 0.8
        DrawFormattedText(stimuliScrn, ...
            ['You got ' int2str(trls_correct) ' out of ' int2str(params.nLearning) ' correct. \n Well done!' ], 'center', 'center');
        
        still_training = 0;
    else
        DrawFormattedText(stimuliScrn, ...
            ['You got ' int2str(trls_correct) ' out of ' int2str(params.nLearning) ' correct. \n Can you do better?' ], 'center', 'center');
        
    end
    Screen('flip', stimuliScrn);
    WaitSecs(0.5);
    KbWait;
end


% display start of block message
DrawFormattedText(stimuliScrn, 'Ready to start?', 'center', 'center');
Screen('flip', stimuliScrn);
WaitSecs(0.5);
KbWait;

% create empty array to put results in
tHistory = zeros(params.nRepetitions, params.staircaseLength);
cHistory = zeros(params.nRepetitions, params.staircaseLength);

for trl = 1:params.staircaseLength
    
    repOrder = randperm(params.nRepetitions);
    
    for rep = repOrder
        
        tTest = QuestQuantile(staircase(rep).q);
        
        % new value of tTest is log10(median) of the two intervals.
        [correct, tTest, actualDur] = RunATrial(tTest, ...
            stimuliScrn, stimuli, textures, params);
        %         if rand < 0.5
        % udpate staircase!
        staircase(rep).q = QuestUpdate(staircase(rep).q, tTest, correct);
        master_staircase.q = QuestUpdate(master_staircase.q, tTest, correct);
        %         else
        %             % update staircase - but randomly!
        %             rand_str = randi(params.nRepetitions);
        %             staircase(rand_str).q = QuestUpdate(staircase(rand_str).q, tTest, correct);
        %         end
        % save actual display duration
        tHistory(rep, trl) = tTestA;
        cHistory(rep, trl) = correct;
        fprintf(fout, '%d, %s, %d, %d, %.3f, %.3f, %.3f, %d\n', ...
            obsID, group, rep, trl, tTest,...
            actualDur(1), actualDur(2), correct);
    end
end

sca
fclose(fout);
mkdir([resultsFolder '/thresholds/']);


% feed all data back into a new staircase



durationThresholds = exp([...
    QuestMean(staircase(1).q);
    QuestMean(staircase(2).q);
    QuestMean(staircase(3).q);
    QuestMean(staircase(4).q);
    QuestMean(master_staircase.q)]);

csvwrite([resultsFolder '/thresholds/' group, '.txt'], durationThresholds);




end

function [correct, tTest, actualDur] = RunATrial(tTest, ...
    stimuliScrn, stimuli, textures, params)

displayDur = 10^(tTest);
displayDur = max(displayDur, params.minDuration);
displayDur = min(displayDur, params.maxDuration);

[tex_stim1, tex_stim2, order] = ...
    LoadSymImages(stimuliScrn, stimuli, params);

actualDur = DisplayStimuli(tex_stim1, tex_stim2, ...
    textures, stimuliScrn, displayDur, params);

tTest = log10(median(actualDur));

% get participant's response
Beeper(400, 0.4, 0.10);
choice = getObserverInput('f', 'j');
Beeper(600, 0.4, 0.1);

% decide if correct or not!
if choice == order(1)
    % correct trial
    disp('correct')
    correct = 1;
else
    % incorrect trial
    disp('wrong');
    correct = 0;
end

end


function dur = DisplayStimuli(tex_stim1, tex_stim2, textures, stimuliScrn, displayDur, params)

% display fixation cross
DisplayOnScreen(stimuliScrn, textures.fixCross, params.fixCrossDur);

% display stimulus 1!
Screen('DrawTexture', stimuliScrn, tex_stim1, []);
t1 = Screen('flip', stimuliScrn);
% noise mask
Screen('DrawTexture', stimuliScrn, textures.noiseMask);
t2 = Screen('flip', stimuliScrn, t1+displayDur-0.05);
dur(1) = t2-t1;
WaitSecs(params.noiseMaskDuration);


% inter-stimuli interval
DisplayOnScreen(stimuliScrn, textures.blank, params.isiDuration);

% display stimulus 2!
Screen('DrawTexture', stimuliScrn, tex_stim2, []);
t1 = Screen('flip', stimuliScrn);
% noise mask
Screen('DrawTexture', stimuliScrn, textures.noiseMask);
t2 = Screen('flip', stimuliScrn, t1+displayDur-0.05);
dur(2) = t2 - t1;

% noise mask
DisplayOnScreen(stimuliScrn, textures.noiseMask, params.noiseMaskDuration)

% display blank until response
DisplayOnScreen(stimuliScrn, textures.blank, params.noiseMaskDuration)

Screen('Close', [tex_stim1, tex_stim2]);

end


function DisplayOnScreen(scrn, tex, t)
Screen('DrawTexture', scrn, tex);
Screen('flip', scrn);
WaitSecs(t);
end
