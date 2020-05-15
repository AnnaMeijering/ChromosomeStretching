clear
[filenames1,paths]=uigetfile('D:\DataAnalysis\Chromavision\Emma\*.mat',...
    'Select the INPUT DATA FILE(s)','MultiSelect','on');

if ischar(filenames1)
    filenames{1}=filenames1;
else
    filenames=filenames1;
end

NumFiles = length(filenames);

for iFile=1:NumFiles
    filepath=strcat(paths,filenames{iFile});
    load(filepath);
    clear title
    NFD=length(start_times);
    if mod(NFD,2)==1
        NFD=NFD-1;
    end
    % User selects the stretching curve that should be analysed
    figure
    subplot(2,1,1);
    plot(time,forceCH1)
    ylabel('Force (pN)')
    title(sprintf("The number of stretches is %d",NFD/2))
    vline(start_times,'g')
    ax = gca;
    ax.YGrid = 'on';
    

    subplot(2,1,2);
    plot(time,interbeaddist)
    xlabel('Time (s)')
    ylabel('Distance (um)')
    grid on
    sgt=sgtitle(filenames{iFile});
    sgt.FontSize=10;
    ginput;
    close
end