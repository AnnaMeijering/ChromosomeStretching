function [BeadBeadDistance FixedBeadPosition MovBeadPosition]= ReadBeadtrackingTextFile( FileName )
% Reads the output text file from the beadtracker standalone and saves the
% distance data into a variable

comma2point_overwrite( FileName )
fileID = fopen(FileName,'r');
formatSpec = '%d %f %f %f %f %f %f %f %f';
BeadTrackData = textscan(fileID,formatSpec,'HeaderLines',1);
BeadBeadDistance = BeadTrackData{2}'; 
FixedBeadPosition = BeadTrackData{4}';
MovBeadPosition = BeadTrackData{7}';
fclose(fileID);

end