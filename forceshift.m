
clear
[filenames1,paths]=uigetfile('D:\DataAnalysis\Chromavision\Emma\*.mat',...
    'Select the INPUT DATA FILE(s)','MultiSelect','on');

if ischar(filenames1)
    filenames{1}=filenames1;
else
    filenames=filenames1;
end

NumFiles = length(filenames);
fixedpospx_change=[];
forcePSD_change=[];
force_change=[];


for iFile=1:NumFiles
    filepath=strcat(paths,filenames{iFile});
    load(filepath);

clear force_end
clear fixedpos_start
clear forcePSD_start
    
index100pN=find(forceCH1>100,1);
diffforce=forceCH1(index100pN)-forceCH1(1);
diffbead=fixedpos(index100pN)-fixedpos(1);
diffbeadforce=diffbead*data.FD_Data.Props.Distance_Calibration__nm_pix_*data.FD_Data.Force_Channel_1__pN_.Props.Trap_stiffness__pN_m_*10^-9;
scalingfactor(iFile)=diffbeadforce/diffforce;

force_end(1)=forceCH1(start_real_times_index(1));
for i=1:ceil(length(start_real_times_index)/2)
fixedpos_start(i) = fixedpos(start_real_times_index(2*i-1));
forcePSD_start(i) = forceCH1(start_real_times_index(2*i-1));
force_end(i+1)=forceCH1(end_real_times_index(2*i-1));
end

% fixedpos_change{iFile}=diff(fixedpos_start);
% force_change{iFile}=diff(force_end);
% force_change{iFile}(end)=[];
fixedpospx_change=horzcat(fixedpospx_change,diff(fixedpos_start));
forcePSD_change=horzcat(forcePSD_change,diff(forcePSD_start));
force_change=horzcat(force_change,diff(force_end));
force_change(end)=[];


end

fixedpos_change=fixedpospx_change*data.FD_Data.Props.Distance_Calibration__nm_pix_;
forcefrombead_change=fixedpos_change*data.FD_Data.Force_Channel_1__pN_.Props.Trap_stiffness__pN_m_*10^-9;

LowForces=force_change(find(force_change<50));
LowDist=forcefrombead_change(find(force_change<50));
MedForces=force_change(find(force_change>50&force_change<200));
MedDist=forcefrombead_change(find(force_change>50&force_change<200));
HighForces=force_change(find(force_change>200&force_change<500));
HighDist=forcefrombead_change(find(force_change>200&force_change<500));
HugeForces=force_change(find(force_change>500));
HugeDist=forcefrombead_change(find(force_change>500));
CombiDist=forcefrombead_change(find(force_change>200));

figure
scatter(force_change,forcefrombead_change)
xlabel('Force difference with previous stretch (pN)');
ylabel('Change in bead tracking position (pN)');
hold on
scatter(force_change,forcePSD_change)

% figure
% scatter(force_change,fixedpos_change)
% xlabel('Force difference with previous stretch (pN)');
% ylabel('Change in force from bead tracking position (pN)');


AvLow=mean(LowDist(find(LowDist>-80&LowDist<80)));
StdLow=std(LowDist(find(LowDist>-80&LowDist<80)));
SemLow=StdLow/sqrt(length(find(LowDist>-80&LowDist<80)));

AvMed=mean(MedDist(find(MedDist>-80&MedDist<80)));
StdMed=std(MedDist(find(MedDist>-80&MedDist<80)));
SemMed=StdMed/sqrt(length(find(MedDist>-80&MedDist<80)));

AvHigh=mean(HighDist(find(HighDist>-80&HighDist<80)));
StdHigh=std(HighDist(find(HighDist>-80&HighDist<80)));
SemHigh=StdHigh/sqrt(length(find(HighDist>-80&HighDist<80)));

AvHuge=mean(HugeDist(find(HugeDist>-80&HugeDist<80)));
StdHuge=std(HugeDist(find(HugeDist>-80&HugeDist<80)));
SemHuge=StdHuge/sqrt(length(find(HugeDist>-80&HugeDist<80)));

AvCombi=mean(CombiDist(find(CombiDist>-80&CombiDist<80)));
StdCombi=std(CombiDist(find(CombiDist>-80&CombiDist<80)));

x=[0 100 300 700];

figure
bar(x,[AvLow AvMed AvHigh AvHuge])
hold on
er=errorbar(x,[AvLow AvMed AvHigh AvHuge],[SemLow SemMed SemHigh SemHuge]);
er.Color = [0 0 0];                            
er.LineStyle = 'none';  
xlabel('Force difference with previous stretch (pN)');
ylabel('Change in bead tracking position (nm)');
hold off