clear

% Select three curves: 1 Before swelling, 2 While swollen, 3 After
% swelling. Save just those three stretching curves as workspace for later
% analysis.
[filename,path]=uigetfile('D:\DataAnalysis\Chromavision\TOPIIdegrons\Salt experiments\*.mat',...
    'Select the INPUT DATA FILE');
filepath=strcat(path,filename);
[dist,force,time,top2degron]=selectthreestretches(filepath);

%%
% Option to save analyzed data and script in .mat file

prompt = {'If you want to save the analyzed data, please put filepath here. Otherwise write NO.'};
    title = 'Input';
    dims = [1 100];
    definput = {'D:\DataAnalysis\Chromavision\TOPIIdegrons\Salt experiments'};
    answer = inputdlg(prompt,title,dims,definput);
    

if strcmp(answer{1},'NO')
else save(strcat(answer{1},'\saltexpt3stretches_',filename),'dist','force','time','top2degron');
end
