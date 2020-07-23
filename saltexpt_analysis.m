clear

% Select three curves: 1 Before swelling, 2 While swollen, 3 After
% swelling.
[filename,path]=uigetfile('D:\DataAnalysis\Chromavision\TOPIIdegrons\Salt experiments\*.mat',...
    'Select the INPUT DATA FILE');
filepath=strcat(path,filename);
[dist,force,time,top2degron]=selectthreestretches(filepath);

% Obtain stiffness values from fit in between two forces (lowerbound and
% upperbound). Determine stiffness of chromosome at upperbound force.
% Determine length from stiffness when stiffness exceeds threshold value. 
force_lowerbound=100;     % pN
force_upperbound=200;     % pN
stiffness_threshold=0.02; % pN/nm
for i=1:3
[datafit{i},stiffness{i},k_ubound{i},ks_mean{i}]=HW_stiffness_version2(dist{i},force{i},force_lowerbound,force_upperbound);
length{i}=length_from_stiffness(dist{i}(2:end),force{i}(2:end),stiffness{i},stiffness_threshold);
end

figure
for i=1:3
plot(dist{i},force{i})
hold on
vline(length{i})
end
hold off

%%
% Option to save analyzed data and script in .mat file

prompt = {'If you want to save the analyzed data, please put filepath here. Otherwise write NO.'};
    title = 'Input';
    dims = [1 100];
    definput = {'D:\DataAnalysis\Chromavision\TOPIIdegrons\Salt experiments'};
    answer = inputdlg(prompt,title,dims,definput);
    

if strcmp(answer{1},'NO')
else save(strcat(answer{1},'\saltexpt3stretches_',filename));
end
