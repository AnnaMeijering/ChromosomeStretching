function [maxforce,stretchrank,numbreak]=rupture_analysis()
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
        maxforce{iFile}(k)=max(force.x{j});
        
    FD.forcedif{k}=diff(force.x{j});
    FD.distdif{k} =diff(dist.abs{j});

    ibreak{k}=find(FD.forcedif{k}<-2);
    iibreak{k}=diff(ibreak{k});
    double_ibreaks{k}=find(iibreak{k}==1)+1;
    ibreak{k}(double_ibreaks{k})=[];
    numbreak{iFile}(k)=length(ibreak{k});
    if numbreak{iFile}(k)>25
        numbreak{iFile}(k)=0;
        numbreak_outliers{iFile}(k)=numbreak{iFile}(k);
        ibreak{k}=[];
    end
        
        
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