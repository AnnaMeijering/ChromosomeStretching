function saveandaddFDcurves(destinationfilepath, existingfilepath)
if nargin==2
    load(existingfilepath)
    [~,Norigfiles]=size(FD.distances);
else Norigfiles=0;
end


[filenames1,paths]=uigetfile('D:\DataAnalysis\Chromavision\TOPIIdegrons\*.mat',...
    'Select the INPUT DATA FILE(s)','MultiSelect','on');

if ischar(filenames1)
    filenames{1}=filenames1;
else
    filenames=filenames1;
end

NumFiles = length(filenames);
iFile=Norigfiles+1;
for i=Norigfiles+1:Norigfiles+NumFiles
    filepath=strcat(paths,filenames{i-Norigfiles});
    [forc, dis, inf, NOsel]=userselFDcurve(filepath);
    if NOsel==1
        
    else
    FD.forces{iFile}=forc;
    FD.distances{iFile}=dis;
    info{iFile}=inf;
    reference{iFile,1}=filenames{i-Norigfiles};
    iFile=iFile+1;
    end
    
end

save(destinationfilepath,'FD','info','reference');
end