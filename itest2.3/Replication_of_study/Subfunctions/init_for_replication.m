mother_path = fileparts(fileparts(fileparts(mfilename('fullpath'))));

% set path
addpath(fullfile(mother_path,'itest'))
addpath(fullfile(mother_path,'subfunctions'))
addpath(fullfile(mother_path,'implementation'))
addpath(fullfile(mother_path,'Replication_of_study','Subfunctions'))

% Initialize the random number generator's seed randomly. 
% Note: comment out this if you want to find the results of simulation with
% fixed seed e.g. rng(1,'default');
rng('shuffle'); 

% Make Results directory, if not exist.
resdir = fullfile(mother_path,'Replication_of_study','Results');
if ~exist(resdir,'dir'); mkdir(resdir); end



