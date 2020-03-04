%Add TOPII info to file
clear all
[filenames1,paths]=uigetfile('D:\DataAnalysis\Chromavision\TOPIIdegrons\*.mat',...
    'Select the INPUT DATA FILE(s)','MultiSelect','on');

if ischar(filenames1)
    filenames{1}=filenames1;
else
    filenames=filenames1;
end

NumFiles = length(filenames);
for i=1:NumFiles
    filepath=strcat(paths,filenames{i});
    loadaddsave(filepath)
end