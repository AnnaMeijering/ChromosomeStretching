function [background intensities]= ReadIntensityTextFile( FileName )
% Reads the output text file from the beadtracker standalone and saves the
% distance data into a variable

fileID = fopen(FileName,'r');
formatSpec = '%f';
TraceData = textscan(fileID,formatSpec);
background = TraceData{1}(1); 
intensities = TraceData{1}(2:end)'; 
fclose(fileID);

end