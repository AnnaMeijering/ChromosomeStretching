% StretchingAnalysis
clear

[filename1,path] = uigetfile('Z:\users\Emma\F-trap DATA raw\*.tdms',...
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
filefolder=erase(file1{iF},'.tdms');

filepath2=erase(filepath1,'.tdms');
filepath2=strcat(filepath2,'.img');
[file2,path2] = uigetfile(strcat(filepath2,'\*txt'),'Select bead tracking data');
filepath2 = strcat(path2,file2);
[beadbeaddist,bead1,bead2] = ReadBeadtrackingTextFile( filepath2 );


%% Obtain all relevant input from datafiles or ask user for input
% trackingmode = data.FD_Data.Props.Tracking_Mode;
if  isfield(data,'Ft_HiRes_Data')
data.Ft_HiRes_Data=[];
end

if bead1(1)<bead2(1)
    fixedpos=bead1;
    movpos=bead2;
else fixedpos=bead2;
    movpos=bead1;
end

forceCH0=data.FD_Data.Force_Channel_0__pN_.data;
forceCH1=data.FD_Data.Force_Channel_1__pN_.data;
time=data.FD_Data.Time__ms_.data;
beadtrackdistance=data.FD_Data.Distance_1__um_.data;
beaddiam=data.FD_Data.Props.Bead_Diameter__um_ ;
interbeaddist=beadbeaddist-beaddiam;
gitinfo=getGitInfo();

    prompt = {'Enter pulling speed in um/s:','Enter sample age in days:'};
    title = 'Input';
    dims = [1 35];
    definput = {'0.05','1'};
    answer = inputdlg(prompt,title,dims,definput);
    pulling_speed=str2double(answer{1});
    sample_age = str2double(answer{2});

% Make structures that contain all the mark comments and times
marks={};
for i=1:length(data.Marks.Mark__.data)
marks.mark{i} = data.Marks.Props.(sprintf('Mark_%d_comment', i));
marks.time{i} = data.Marks.Time__ms_.data(i);
end

% Find the start and end of FD curves and the total number of stretches
startFDindices=strcmp('F,d curve: Start',marks.mark);
endFDindices=strcmp('F,d curve: End',marks.mark);
stretches = sum(startFDindices);
retractions = sum(endFDindices);
start_times=cell2mat(marks.time(startFDindices));
end_times=cell2mat(marks.time(endFDindices));

if stretches<retractions
   stretches=stretches+1;
   start_times=horzcat([1],start_times);
end

%% Find index in real time array that corresponds to start and end time of
% FD curves. The exact times from the marks do not correspond to the time
% array. Therefore find cannot be used.Also select forces and distances belonging to stretch curves. 
start_real_times_index=zeros(1,stretches);
end_real_times_index=zeros(1,stretches);
force.x=cell(1,stretches);
force.y=cell(1,stretches);
dist.abs=cell(1,stretches);
dist.x50pN=cell(1,stretches);
for iStretch=1:stretches
    [~, start_real_times_index(iStretch)] = min(abs(time - start_times(iStretch)));
    if stretches ==retractions
        [~, end_real_times_index(iStretch)] = min(abs(time - end_times(iStretch)));
    else
        if iStretch < stretches
            [~, end_real_times_index(iStretch)] = min(abs(time - end_times(iStretch)));
        else end_real_times_index(iStretch) = length(time);
        end
    end
    force.x{iStretch} = forceCH1( [start_real_times_index(iStretch):end_real_times_index(iStretch)] );
    force.y{iStretch} = forceCH0( [start_real_times_index(iStretch):end_real_times_index(iStretch)] );
    dist.abs{iStretch} = interbeaddist( [start_real_times_index(iStretch):end_real_times_index(iStretch)] );
    if max(force.x{iStretch})>50 
        index50pN=find(force.x{iStretch}>50);
        dist.x50pN{iStretch} = dist.abs{iStretch}(index50pN(1));
    else dist.x50pN{iStretch}=NaN;
    end
end


%%
force.xav=cell(3,stretches);
dist.av=cell(3,stretches);
Averaging=[2 5 10];
for j=1:3;
for i=1:stretches;
        force.xav{j,i}=averagearray(force.x{i},Averaging(j));
        dist.av{j,i} =averagearray(dist.abs{i},Averaging(j));
end
end

%%
% figure
% for iStretch = 1:stretches;
%     plot(dist.av{3,iStretch},force.xav{3,iStretch})
%     hold on
% end
% hold off



%% Select user ROI
% 
% figure
% subplot(2,1,1);
% plot(time,forceCH1)
% vline(start_times,'g')
% 
% subplot(2,1,2);
% plot(time,interbeaddist)
% [xtimes,yforces]= ginput(100);

%% Determine closest starting points and end points to analyse
% start_end_analyse_index=zeros(2,length(xtimes));
% for sel= 1:length(xtimes)
%     index=find(abs(start_times-xtimes(sel)) == min(abs(start_times-xtimes(sel))));
%     start_end_analyse_index(1,sel) = start_real_times_index(index);
%     start_end_analyse_index(2,sel) = end_real_times_index(index);
% end
% 
% 
% figure
% for figs=1:length(start_end_analyse_index(1,:));
%     plot(interbeaddist(start_end_analyse_index(1,figs):start_end_analyse_index(2,figs)), forceCH1( start_end_analyse_index(1,figs):start_end_analyse_index(2,figs) ) )
%     hold on
% end
% hold off


%%
% Option to save analyzed data and script in .mat file

prompt = {'If you want to save the analyzed data, please put filepath here. Otherwise write NO.'};
    title = 'Input';
    dims = [1 100];
    definput = {'D:\DataAnalysis\Chromavision\Emma'};
    answer = inputdlg(prompt,title,dims,definput);
    
if strcmp(answer{1},'NO')
else save(strcat(answer{1},'\workspace_',filefolder));
end
end
close all