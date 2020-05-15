clear

[filename1,path] = uigetfile('D:\DataAnalysis\Chromavision\Emma\jumps\*.tdms',...
    'Select .tdms file','MultiSelect','on');

if ischar(filename1)
    file1{1}=filename1;
else
    file1=filename1;
end

NFiles = length(file1);

for iF=1:NFiles

filepath1 = strcat(path,file1{iF});
data = TDMS_getStruct(filepath1);

forceCH0=data.FD_Data.Force_Channel_0__pN_.data;
forceCH1=data.FD_Data.Force_Channel_1__pN_.data;
time=data.FD_Data.Time__ms_.data;
beadtrackdistance=data.FD_Data.Distance_1__um_.data;
beaddiam=data.FD_Data.Props.Bead_Diameter__um_ ;
interbeaddist=beadtrackdistance-beaddiam;
gitinfo=getGitInfo();

% User selects the stretching curve that should be analysed
    figure
    subplot(2,1,1);
    plot(time,forceCH1)
    ylabel('Force (pN)')
    ax = gca;
    ax.YGrid = 'on';

    subplot(2,1,2);
    plot(time,interbeaddist)
    xlabel('Time (s)')
    ylabel('Distance (um)')
    grid on
    sgt=sgtitle(file1{iF});
    sgt.FontSize=10;
    [xtimes,yforces]= ginput;
    close

    tstart_i=find(abs(time-xtimes(1))==min(abs(time-xtimes(1))));
   
    tend_i=find(abs(time-xtimes(2))==min(abs(time-xtimes(2))));

end