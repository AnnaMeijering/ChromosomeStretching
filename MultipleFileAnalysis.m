%% Analysis of multiple stretching curves

clear
[filenames1,paths]=uigetfile('D:\DataAnalysis\Chromavision\Emma\Selection_NoRuptures\*.mat',...
    'Select the INPUT DATA FILE(s)','MultiSelect','on');

if ischar(filenames1)
    filenames{1}=filenames1;
else
    filenames=filenames1;
end

NumFiles = length(filenames);

%     prompt = {'Do you want single curve (1) or multiple curve (10) analysis?'};
%     title = 'Input';
%     dims = [1 35];
%     definput = {'1'};
%     answer = inputdlg(prompt,title,dims,definput);
%     NumStretchAnalysis=str2double(answer{1});

%ChromLength = zeros(1,NumFiles);
colours=['r', 'g', 'b'];
stretchspeed = [0.01 0.02 0.05];
for iFile=1:NumFiles
    clear dAvg fAvg Forceder1 Forceder2
    filepath=strcat(paths,filenames{iFile});
    load(filepath);
    
    % User selects the stretching curve that should be analysed
    figure
    subplot(2,1,1);
    plot(time,forceCH1)
    vline(start_times,'g')

    subplot(2,1,2);
    plot(time,interbeaddist)
    [xtimes,yforces]= ginput(1);
    close
    
    if isempty(xtimes)
    else    
    index=find(abs(start_times-xtimes) == min(abs(start_times-xtimes)));
    
    % Here the data per file that has to be analysed should be listed
    %index30pN=find(force.x{index}>30);
    %dist.x30pN(iFile) = dist.abs{index}(index30pN(1));
    ChromLength(iFile) = cell2mat(dist.x50pN(index));
    %FD.distances{iFile}=cell2mat(dist.abs(index))-ChromLength(iFile);
    FD.distances{iFile}=cell2mat(dist.abs(index));
    FD.forces{iFile} = cell2mat(force.x(index));
    
%     % User selects deflection point
%     figure
%     plot(FD.distances{iFile},FD.forces{iFile})
%         prompt = {'Plateau or not? y/n'};
%     title = 'Input';
%     dims = [1 10];
%     definput = {'y'};
%     answer = inputdlg(prompt,title,dims,definput);
%     if strcmp(answer{1},'y')
%         plateau(iFile)=1;
%     else plateau(iFile)=0;
%     end
%     close
    
    %FD.xdeflection{iFile}=xdeflection;
    
    FD.difforces{iFile} = diff(FD.forces{iFile});
        if max(FD.forces{iFile})>150 
        index150pN=find(FD.forces{iFile}>150);
        index100pN=find(FD.forces{iFile}>100);
        dist.x150pN{iFile} = FD.distances{iFile}(index150pN(1));
        dist.x100pN{iFile} = FD.distances{iFile}(index100pN(1));
        slope(iFile) = 50/(dist.x150pN{iFile}-dist.x100pN{iFile});
    else dist.x100pN{iFile}=NaN;
        dist.x150pN{iFile}=NaN;
        slope(iFile) = NaN;
    end
    FD.times{iFile} = 1:length(FD.forces{iFile});
    PlotcolourSpeed(iFile) = colours(find(pulling_speed == stretchspeed));
%     if plateau(iFile)==1
%             Plotcolourplateau(iFile) = colours(1);
%     else Plotcolourplateau(iFile) = colours(2);
%     end

%     if sample_age<21
%             PlotcolourAge(iFile) = colours(1);
%     elseif sample_age<70
%         PlotcolourAge(iFile) = colours(2);
%     else PlotcolourAge(iFile) = colours(3);
%     end

%     fd = FdData(filenames{iFile}, FD.forces{iFile}, FD.distances{iFile}, FD.times{iFile});
%     fd1=fd.subset('f',[-100 50]);
%     FD.fit{iFile} = fitfd(fd1,'noTrim');
%     Lc(iFile)=FD.fit{iFile}.Lc;
%     Lp(iFile)=FD.fit{iFile}.Lp;
%     Smod(iFile)=FD.fit{iFile}.S;
%     Smod(iFile)=FD.fit{iFile}.S;
%     Fzero(iFile)=FD.fit{iFile}.F0;
%     plotfdfit(fd,FD.fit{iFile})
    
    
    
    % In order to determine the point of highest curvature we want to take
    % the second derivative. First we make an averaged array, since there
    % are recurring values in the original array.
    % Make an average vector for both distance and force
     n=30; % evarage every n values 
     dAvg = arrayfun(@(i) mean(FD.distances{iFile}(i:i+n-1)),1:n:length(FD.distances{iFile})-n+1)'; % distance average
     fAvg = arrayfun(@(i) mean(FD.forces{iFile}(i:i+n-1)),1:n:length(FD.forces{iFile})-n+1)'; % force average
    
    % Now do an interpolation and smoothing spline to the data that can
    % than used to calculate the second derivative.
%     xEqualSpaced = linspace(dAvg(1), dAvg(end), length(dAvg))'; % create equal spacing x-axis
%     y = interp1(dAvg, fAvg, xEqualSpaced); % create interpolated y-axis
%    [pp, ~] = csaps( xEqualSpaced, y ,0.9999 ); % create cubic smoothing spline

[pp, ~] = csaps( dAvg,fAvg ,0.9997 ); % create cubic smoothing spline

% To check whether the function fnder comes to the same result as manual
% differentiation the code below can be used. The function fnder seems
% to follow the same trend, but almost without noise.
%     for Ndif=1:length(dAvg)-1
%         dd(Ndif)=dAvg(Ndif+1)-dAvg(Ndif);
%         df(Ndif)=fAvg(Ndif+1)-fAvg(Ndif);
%     end
%     dff=df./dd;
%     plot(dAvg(1:end-1),dff)

    p_der1{iFile} = fnder(pp,1);
    p_der2{iFile} = fnder(pp,2); % calculate second derivative (use function fnplt to plot results)
    [pks,locs{iFile}]=findpeaks(fnval( p_der2{iFile},dAvg));
    Forceder1=fnval( p_der1{iFile},dAvg);
    Forceder2=fnval( p_der2{iFile},dAvg);
    
    %Find slope of curves when force exceeds 200pN
%     iSlope=find(fAvg>200);
%     xslope(iFile)=dAvg(iSlope(1));
%     yslope(iFile)=Forceder1(iSlope(1));
%     stiffness(iFile)=data.FD_Data.Force_Channel_0__pN_.Props.Trap_stiffness__pN_m_  ;
%     corrslopestiffness=corrcoef(yslope,stiffness);
    
    if length(locs{iFile})>1
        
    %User selects deflection point
%     figure
%     plot(FD.distances{iFile},FD.forces{iFile})
%         [xdist,yforce]= ginput(1);
%     close
%         inflpoints=dAvg(locs{iFile});
%         [Min,Ind]=min(abs(inflpoints-xdist));
%         MaxCurv{iFile}=dAvg(locs{iFile}(Ind));
        
    %Or just get point of highest curvature
    MaxCurv{iFile}=dAvg(find(Forceder2==max(Forceder2)));
    ChromoLength(iFile)=MaxCurv{iFile};
    ChromoSlope(iFile)=Forceder1(find(Forceder2==max(Forceder2)));
    ChromoForce(iFile)=fAvg(find(Forceder2==max(Forceder2)));
    Scaleddist{iFile}=(dAvg)./ChromoLength(iFile);
    ForceAv{iFile}=fAvg;
    
%     ChromoLength=[2.677,2.982,2.417,2.305,2.026,1.808,1.849,3.194,3.169,4.155,4.03,3.116,...
%         1.689,3.13,2.256,3.745,3.482,1.709,3.078,1.896,2.37,3.214,1.42,2.085,6.184,3.651,3.775,2.881,2.714,1.184];
%     MaxIndex=find(min(abs(dAvg-ChromoLength(iFile)))==(abs(dAvg-ChromoLength(iFile))));
%      ChromoSlope(iFile)=Forceder1(MaxIndex);
%      ChromoForce(iFile)=fAvg(MaxIndex);
%      Scaleddist{iFile}=(dAvg)./ChromoLength(iFile);
%      ForceAv{iFile}=fAvg;
    
    
    
    else MaxCurv{iFile}=dAvg(locs{iFile});
    end
    
    end
end

for l=1:length(ChromLength)
    %FD.distances0{l}=FD.distances{l}-FD.distances{l}(1);
    FD.distances50{l}=FD.distances{l}-ChromLength(l);
    %FD.distancesdefltrans{l}=FD.distances{l}-FD.xdeflection{l};
    %FD.distancesdefl{l}=FD.distances{l}/FD.xdeflection{l};
    FD.distancesscaled{l}=FD.distances{l}/FD.distances{l}(1);
    FD.distancesscaledchromlength{l}=FD.distances{l}/ChromLength(l);
    P = polyfit(FD.distances{l}(1:100),FD.forces{l}(1:100),1);
    slopes(l)=P(1);
    if slopes(l)>20
        Plotcolourslopes(l)='b';
    else 
        Plotcolourslopes(l)='r';
    end
end

kT=4.114;
Lp=5; %50 for dsDNA
S=1266;
Lc=3000;
d=500:10:3500;
dmicron=d./1000;

        y1=0.0001.*d+1;
        y2=0.0005.*d+1;
        y3=0.001.*d+1;
        y4=0.008.*d+1;
        y5=0.016.*d+1;

F = real(...
        (2.*(Lp.*Lc.*S.*d - Lp.*S.*Lc.^2))./(3.*Lp.*Lc.^2) - ...
           (-16.*Lp.^2.*S.^2.*(d.^2).*Lc.^2 + ...
            32.*Lp.^2.*S.^2.*d.*Lc.^3 - 16.*Lp.^2.*S.^2.*Lc.^4)./ ...
             (24.*Lp.*Lc.^2.*(-8.*Lp.^3.*S.^3.*(d.^3).*Lc.^3 + ...
               24.*Lp.^3.*S.^3.*(d.^2).*Lc.^4 - ...
                     24.*Lp.^3.*S.^3.*d.*Lc.^5 + ...
               27.*kT.*Lp.^2.*S.^2.*Lc.^6 + 8.*Lp.^3.*S.^3.*Lc.^6 + ...
               3.*sqrt(3).* ...
                sqrt(-16.*kT.*Lp.^5.*S.^5.*(d.^3).*Lc.^9 + ...
                  48.*kT.*Lp.^5.*S.^5.*(d.^2).*Lc.^10 - ...
                           48.*kT.*Lp.^5.*S.^5.*d.*Lc.^11 + ...
                  27.*kT.^2.*Lp.^4.*S.^4.*Lc.^12 + ...
                           16.*kT.*Lp.^5.*S.^5.*Lc.^12)).^(1./3)) + ...
              (1./(6.*Lp.*Lc.^2)).* ...
             (-8.*Lp.^3.*S.^3.*(d.^3).*Lc.^3 + ...
             24.*Lp.^3.*S.^3.*(d.^2).*Lc.^4 - ...
             24.*Lp.^3.*S.^3.*d.*Lc.^5 + ...
                  27.*kT.*Lp.^2.*S.^2.*Lc.^6 + ...
             8.*Lp.^3.*S.^3.*Lc.^6 + ...
             3.*sqrt(3).* ...
              sqrt(-16.*kT.*Lp.^5.*S.^5.*(d.^3).*Lc.^9 + ...
                48.*kT.*Lp.^5.*S.^5.*(d.^2).*Lc.^10 - ...
                        48.*kT.*Lp.^5.*S.^5.*d.*Lc.^11 + ...
                27.*kT.^2.*Lp.^4.*S.^4.*Lc.^12 + ...
                        16.*kT.*Lp.^5.*S.^5.*Lc.^12)).^(1./3));

figure
yyaxis left
for k=1:length(ChromLength)
    plot(FD.distances{k},FD.forces{k})
    vline(MaxCurv{k},'r')
    hold on
end
%plot(d,F,'r')
ylabel('Force (pN)')
xlabel('Distance (um)')
ylim([-50 400])
%xlim([2 5])

yyaxis right
plot(dAvg,Forceder2./5,'r--')
ylim([-50 2000])
plot(dAvg,Forceder1)
hold off

figure
for k=1:length(ChromLength)
    plot(FD.distances{k},FD.forces{k},'k:')
    hold on
end
plot(dmicron,FDNA,'r','LineWidth',3)
plot(dmicron,F.*y1,'g','LineWidth',3)
plot(dmicron,F.*y2,'g','LineWidth',3)
plot(dmicron,F.*y3,'g','LineWidth',3)
plot(dmicron,F.*y4,'g','LineWidth',3)
plot(dmicron,F.*y5,'g','LineWidth',3)
% plot(dmicron,F.*4,'b','LineWidth',3)
% plot(dmicron,F.*8,'m','LineWidth',3)
ylabel('Force (pN)')
xlabel('Distance (um)')
ylim([-50 400])
%xlim([2 5])

figure
for k=1:length(ChromLength)
    plot(Scaleddist{k},ForceAv{k})
    %vline(MaxCurv{k},'g')
    hold on
end
plot(dmicron,F,'r','LineWidth',3)
ylabel('Force (pN)')
xlabel('Distance (um)')
%ylim([-50 400])
%xlim([2 5])
hold off

figure
hist(ChromoLength)
ylabel('Chromosome length (um)')
xlabel('Frequency')

figure
hist(ChromoSlope)
ylabel('Stretch stiffness (pN/um)')
xlabel('Frequency')

figure
hist(ChromoForce)
ylabel('Force at highest curvature (pN)')
xlabel('Frequency')

figure
scatter(ChromoLength,ChromoSlope)
ylabel('Stretch stiffness (pN/um)')
xlabel('Distance (um)')

% figure
%     plot(dAvg,Forceder1)
% ylabel('First derivative')
% xlabel('Distance (um)')
% 
% 
% figure
%     plot(dAvg,Forceder2)
% ylabel('Second derivative')
% xlabel('Distance (um)')

% figure
% for k=1:length(ChromLength)
%     plot(FD.distances{k}(1:end-1),FD.difforces{k})
%     hold on
% end
% hold off
