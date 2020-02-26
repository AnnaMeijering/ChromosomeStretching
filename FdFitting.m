%% Fd fitting

clear
[filenames,paths]=uigetfile('D:\DataAnalysis\Chromavision\Emma\*.mat',...
    'Select the INPUT DATA FILE');

filepath=strcat(paths,filenames);
load(filepath);

    figure
    subplot(2,1,1);
    plot(time,forceCH1)
    vline(start_times,'g')

    subplot(2,1,2);
    plot(time,interbeaddist)
    [xtimes,yforces]= ginput(1);
    close
    
    index=find(abs(start_times-xtimes) == min(abs(start_times-xtimes)));    
    d_values=cell2mat(dist.abs(index));
    f_values = cell2mat(force.x(index)); 
    t_values = 1:length(f_values);

fd = FdData('name', f_values, d_values, t_values);
fd1 = fd.subset('f', [0 300]);
f = fitfd(fd1,'model','network','noTrim');
%f = fitfd(fd1,'noTrim');
plotfdfit(fd1,f)
%fd1 = fd.subset('f', [00 150]);
