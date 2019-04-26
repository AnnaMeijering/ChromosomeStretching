%% Analysis of multiple stretching curves

clear
[filenames,paths]=uigetfile('D:\DataAnalysis\Chromavision\Emma\*.mat',...
    'Select the INPUT DATA FILE(s)','MultiSelect','on');

NumFiles = length(filenames);
ChromLength = zeros(1,NumFiles);
for iFile=1:NumFiles
    filepath=strcat(paths,filenames{iFile});
    load(filepath);
    
    % User selects the stretching curve that should be analysed
    figure
    subplot(2,1,1);
    plot(time,forceCH1)
    vline(start_times,'g')

    subplot(2,1,2);
    plot(time,interbeaddist)
    [xtimes,yforces]= ginput(1);
    close
    index=find(abs(start_times-xtimes) == min(abs(start_times-xtimes)));
    
    % Here the data per file that has to be analysed should be listed
    ChromLength(iFile) = cell2mat(dist.x50pN(index));
    FD.distances{iFile}=cell2mat(dist.abs(index))-ChromLength(iFile);
    FD.forces{iFile} = cell2mat(force.x(index));
end

figure
for k=1:NumFiles
    plot(FD.distances{k},FD.forces{k})
    hold on
end
hold off

% figure
% hist(ChromLength)