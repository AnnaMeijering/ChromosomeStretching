function [BeadBeadDistance FixedBeadPosition MovBeadPosition]= ReadBeadtrackingTextFile( FileName )
% Reads the output text file from the beadtracker standalone and saves the
% distance data into a variable

comma2point_overwrite( FileName )
fileID = fopen(FileName,'r');
formatSpec = '%d %f %f %f %f %f %f %f %f';
BeadTrackData = textscan(fileID,formatSpec,'HeaderLines',1);
BeadBeadDistancePix = BeadTrackData{3}'; 
FixedBeadPosition = BeadTrackData{4}';
MovBeadPosition = BeadTrackData{7}';
fclose(fileID);

prompt = {'Enter pixel size in nm'};
    title = 'Input';
    dims = [1 35];
    definput = {'67.3'};
    answer = inputdlg(prompt,title,dims,definput);
    pixsize=str2double(answer);

    BeadBeadDistance=BeadBeadDistancePix*pixsize/1000;
    
end
