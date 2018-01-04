function [evg, x] = evgram(xobs, yobs)

filename_obs = 'obs.txt';
if exist(filename_obs, 'file'), delete(filename_obs); end
fid = fopen(filename_obs, 'wt');
fprintf(fid, '%s\t%s\t%s\n', 'x', 'y', 'obs');
fclose(fid);
dlmwrite(filename_obs, [xobs, yobs], 'delimiter', '\t', '-append');

filename_evgram = 'evgram.txt';
toolspath = [fileparts(mfilename('fullpath')) filesep];
system(sprintf('Rscript %sevgram.R %s %s', toolspath, filename_obs, filename_evgram));
evgram = dlmread(filename_evgram);

delete(filename_obs, filename_evgram);

x   = evgram(:, 1);
evg = evgram(:, 2);
