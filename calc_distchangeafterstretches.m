function [forcedrop,distchange,distchangerel,maxforce,stretchrank,pull_speed]=calc_distchangeafterstretches()
[filenames1,paths]=uigetfile('D:\DataAnalysis\Chromavision\Emma\*.mat',...
    'Select the INPUT DATA FILE(s)','MultiSelect','on');

if ischar(filenames1)
    filenames{1}=filenames1;
else
    filenames=filenames1;
end

NumFiles = length(filenames);
pull_speed=[];

for iFile=1:NumFiles
    filepath=strcat(paths,filenames{iFile});
    load(filepath);
    clear j
    NFD=length(start_times);
    if mod(NFD,2)==1
        NFD=NFD-1;
    end
    if NFD==0
    else
    k=1;
    num=1;
    stretchrank{iFile}(1)=1;
     for j=(1:2:NFD)
        forcedrop{iFile}(k)=mean(force.x{j+1}(end-10:end))-mean(force.x{j}(1:10));
        distchange{iFile}(k)=mean(dist.abs{j+1}(end-10:end))-mean(dist.abs{j}(1:10));
        distchangerel{iFile}(k)=distchange{iFile}(k)/mean(dist.abs{j}(1:10));
        maxforce{iFile}(k)=max(force.x{j});
        pull_speed=horzcat(pull_speed,pulling_speed);
        k=k+1;
     end
   
     for j=2:k-1
        if maxforce{iFile}(j-1)*1.2>maxforce{iFile}(j)
            num=num+1;
            stretchrank{iFile}(j)=num;
        else num=1;
            stretchrank{iFile}(j)=num;
        end 
     end
   end
end