filepath = 'C:\Users\User1\Desktop\testfiles\piezotracking_20190111-120139 Jumps ~ 300pN #001-003.tdms';
data = TDMS_getStruct(filepath);

%%
forceCH0=data.FD_Data.Force_Channel_0__pN_.data;
forceCH1=data.FD_Data.Force_Channel_1__pN_.data;
time=data.FD_Data.Time__ms_.data;
beadtrackdistance=data.FD_Data.Distance_1__um_.data;
trap_stiffness_CH0=data.FD_Data.Force_Channel_0__pN_.Props.Trap_stiffness__pN_m_/10^6; % [um/pN]
trap_stiffness_CH1=data.FD_Data.Force_Channel_1__pN_.Props.Trap_stiffness__pN_m_/10^6; % [um/pN]
distance_calibration=data.FD_Data.Props.Distance_Calibration__nm_pix_;

%%
trap_distance = beadtrackdistance;
force.x = forceCH1;
bead_bead_distance = trap_distance-2*force.x/trap_stiffness_CH1;


subplot(2,1,1)
plot(beadtrackdistance)
hold on
plot(bead_bead_distance)
hold off

subplot(2,1,2)
plot(bead_bead_distance,force.x)

%% TODO
% * check if beadtrackdistance is real distance in um (with or without bead
% diameter subtraction?)