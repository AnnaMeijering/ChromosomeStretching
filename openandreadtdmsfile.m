function data=openandreadtextfile()
[file,path] = uigetfile('*.tdms');
filepath = strcat(path,file);
data = TDMS_getStruct(filepath);

end
