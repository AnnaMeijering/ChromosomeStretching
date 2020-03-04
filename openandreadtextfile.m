function data=openandreadtextfile()
[file,path] = uigetfile('*.tdms');
filepath = strcat(path,file);
data=textread(filepath);

end
