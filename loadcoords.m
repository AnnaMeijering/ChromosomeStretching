function [xcoords ycoords NumFiles background intensities]=loadcoords()
[filename,path]=uigetfile('D:\DataAnalysis\Chromavision\TOPIIdegrons\*.txt',...
    'Select the INPUT DATA FILES','MultiSelect','on');
NumFiles=size(filename,2)-1;

for i = 1:NumFiles
filepath=strcat(path,filename{i+1});
[xcoords{i} ycoords{i}]=ReadstrethingTextFile(filepath);
end
filepath_I=strcat(path,filename{1});
[background intensities]=ReadIntensityTextFile(filepath_I);

end