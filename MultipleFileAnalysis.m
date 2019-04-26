%% Analysis of multiple stretching curves

clear
[filenames,paths]=uigetfile('D:\DataAnalysis\Chromavision\Emma\*.mat',...
    'Select the INPUT DATA FILE(s)','MultiSelect','on');

NumFiles = length(filenames);
ChromLength = zeros(1,NumFiles);
for iFile=1:NumFiles
    filepath=strcat(paths,filenames{iFile});
    load(filepath);
    
    % Here the data per file that has to be analysed should be listed
    ChromLength(iFile) = cell2mat(dist.x50pN(1));
end

figure
hist(ChromLength)