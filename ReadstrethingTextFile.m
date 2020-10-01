function [TraceCoordsX TraceCoordsY]= ReadstrethingTextFile( FileName )
% Reads the output text file from the beadtracker standalone and saves the
% distance data into a variable

fileID = fopen(FileName,'r');
formatSpec = '%f %f';
TraceData = textscan(fileID,formatSpec);
TraceCoordsX = TraceData{1}'; 
TraceCoordsY = TraceData{2}'; 
fclose(fileID);

end