function [tex_stim1, tex_stim2, order] = LoadSymImages(stimuliScrn, stimuli, params)

% 1 should be symmetrical,
% 2 is control
order = randperm(2);

% select a random example to use
ii = randi(params.imagesPerCondition);

fname =  char(strcat('stimuli/', stimuli.sym(ii)));
stimulusSym = ScaleContrastRotate(imread(fname), params);

fname =  char(strcat('stimuli/', stimuli.ctl(ii)));
stimulusCtl = ScaleContrastRotate(imread(fname), params);

if order(1)==1
    tex_stim1 = Screen('MakeTexture', stimuliScrn, stimulusSym);
    tex_stim2 = Screen('MakeTexture', stimuliScrn, stimulusCtl);
else
    tex_stim1 = Screen('MakeTexture', stimuliScrn, stimulusCtl);
    tex_stim2 = Screen('MakeTexture', stimuliScrn, stimulusSym);
end


end

function im = ScaleContrastRotate(im, params)
im  = im2double(im);

% set mean to 0!
im = params.stimuliContrast * (im - mean(im(:)));

if params.rotate
    im = imrotate(im, randi(360), 'bilinear');
end

% set to mean 0.5
im = 255 * (im + 0.5);



end

