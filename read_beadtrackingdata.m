clear

[file,path] = uigetfile('*.tdms');
filepath = strcat(path,file);
data = TDMS_getStruct(filepath);

%%
% trackingmode = data.FD_Data.Props.Tracking_Mode;
forceCH0=data.FD_Data.Force_Channel_0__pN_.data;
forceCH1=data.FD_Data.Force_Channel_1__pN_.data;
time=data.FD_Data.Time__ms_.data;
beadtrackdistance=data.FD_Data.Distance_2__um_.data;
% trap_stiffness_CH0=data.FD_Data.Force_Channel_0__pN_.Props.Trap_stiffness__pN_m_/10^6; % [um/pN]
trap_stiffness_CH1=data.FD_Data.Force_Channel_1__pN_.Props.Trap_stiffness__pN_m_/10^6; % [um/pN]
% distance_calibration=data.FD_Data.Props.Distance_Calibration__nm_pix_;
index50pN=find(forceCH1>50);

if beadtrackdistance(1) == 0
    prompt = {'No bead tracking was detected. Enter distance between beads from BF image. :','Enter pulling speed in um/s:'};
    title = 'Input';
    dims = [1 35];
    definput = {'0','0.05'};
    answer = inputdlg(prompt,title,dims,definput);
    dist50pN = str2num(answer{1});
    pulling_speed=str2num(answer{2});
else
    prompt = {'Enter pulling speed in um/s:'};
    title = 'Input';
    dims = [1 35];
    definput = {'0.05'};
    answer = inputdlg(prompt,title,dims,definput);
    pulling_speed=str2num(answer{1});
    dist50pN=beadtrackdistance(index50pN(1));
end

% Determine starting distance of traps
time50pN = time(index50pN(1));
trap_start_position = dist50pN-time50pN/1000*pulling_speed;

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
start_times=cell2mat(marks.time(startFDindices));
end_times=cell2mat(marks.time(endFDindices));

%% Find index in real time array that corresponds to start and end time of
% FD curves. The exact times from the marks do not correspond to the time
% array. Therefore find cannot be used.Also select forces belonging to stretch curves. 
start_real_times_index=zeros(1,stretches);
end_real_times_index=zeros(1,stretches);
force.x=cell(1,stretches);
force.y=cell(1,stretches);
for iStretch=1:stretches
    [~, start_real_times_index(iStretch)] = min(abs(time - start_times(iStretch)));
    [~, end_real_times_index(iStretch)] = min(abs(time - end_times(iStretch)));
    force.x{iStretch} = forceCH1( [start_real_times_index(iStretch):end_real_times_index(iStretch)] );
    force.y{iStretch} = forceCH0( [start_real_times_index(iStretch):end_real_times_index(iStretch)] );
end

%% Create distance arrays belonging to stretch and retraction curves. 
% For now assume
% that stretching and retractions are being alternated. Later possibly make
% user interface for this.
distance = cell(1,stretches);
for iStretch=1:(stretches)
    total_time(iStretch) = end_times(iStretch)-start_times(iStretch);
    trap_end_position(iStretch) = trap_start_position + total_time(iStretch)/1000*pulling_speed;
end

for iStretch=1:(stretches/2)
    trap_distance{iStretch*2-1} = linspace(trap_start_position, trap_end_position(iStretch*2-1), length(force.x{iStretch*2-1}));
    trap_distance{iStretch*2} = linspace(trap_end_position(iStretch*2), trap_start_position, length(force.x{iStretch*2}));
end

%%
figure
plot(trap_distance{1},force.x{1})
hold on
plot(trap_distance{2},force.x{2})
plot(trap_distance{3},force.x{3})
plot(trap_distance{4},force.x{4})
plot(trap_distance{7},force.x{7})
plot(trap_distance{8},force.x{8})
hold off

%%
% Calculate bead-bead distance assuming same trap stiffness for the two
% traps and linear force-displacement response. Pay attention! This is the
% trap stiffness of CH1! Might want to put this as user input.
bead_bead_distance = cell(1,stretches);
for iStretch=1:(stretches)
    bead_bead_distance{iStretch} = trap_distance{iStretch}-2*force.x{iStretch}/trap_stiffness_CH1;
end


%%
% Calculate relative stretch distance using 50pN as original chromosome
% length

relative_stretch_distance = cell(1,stretches);

for iStretch=1:(stretches)
    relative_stretch_distance{iStretch} = bead_bead_distance{iStretch}/bead_bead_distance{1}(index50pN(1));
end



figure
plot(relative_stretch_distance{1},force.x{1})
hold on
plot(relative_stretch_distance{2},force.x{2})
%plot(relative_stretch_distance{3},force.x{3})
%plot(relative_stretch_distance{4},force.x{4})
plot(relative_stretch_distance{7},force.x{7})
plot(relative_stretch_distance{8},force.x{8})
hold off

%%
subplot(2,1,1);
plot(time,forceCH1)

subplot(2,1,2);
plot(time,beadtrackdistance)

%%
% Option to save analyzed data and script in .mat file

prompt = {'If you want to save the analyzed data, please put filepath here. Otherwise write NO.'};
    title = 'Input';
    dims = [1 100];
    definput = {'C:\Users\User1\Desktop\testfolder'};
    answer = inputdlg(prompt,title,dims,definput);
    
if strcmp(answer{1},'NO')
else save(strcat(answer{1},'\workspace'));
end
