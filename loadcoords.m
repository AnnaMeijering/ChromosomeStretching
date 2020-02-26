function [xcoords ycoords NumFiles]=loadcoords()
[filename,path]=uigetfile('C:\Users\AMG900\Desktop\*.txt',...
    'Select the INPUT DATA FILES','MultiSelect','on');
NumFiles=size(filename,2);

for i = 1:NumFiles
filepath=strcat(path,filename{i});
[xcoords{i} ycoords{i}]=ReadstrethingTextFile(filepath);
end
end