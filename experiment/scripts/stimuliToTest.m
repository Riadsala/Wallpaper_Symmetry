function stimuli = stimuliToTest(grp, stimuliPerCondition)

keySet = {'P1', 'P2', 'PM' ,'PG', 'CM', 'PMM', 'PMG', 'PGG', 'CMM', 'P4', 'P4M', 'P4G', 'P3', 'P3M1', 'P31M', 'P6', 'P6M'};
valueSet = 101:1:117;

code = valueSet(strcmp(grp, keySet));
stimuli.group = grp;
for jj = 1:stimuliPerCondition
    stimuli.sym{jj} =  sprintf('%d%03d.PNG', code, jj);
    stimuli.ctl{jj} =  sprintf('%d%03d.PNG', code+17, jj);
end

end

