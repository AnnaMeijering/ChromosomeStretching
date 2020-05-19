%% Analysis of multiple stretching curves

clear
[filename,path]=uigetfile('D:\DataAnalysis\Chromavision\TOPIIdegrons\*.mat',...
    'Select the INPUT DATA FILE');
filepath=strcat(path,filename);
load(filepath);
[~,NumFiles]=size(FD.distances);

for iFile=1:NumFiles
    clear dAvg fAvg Forceder1 Forceder2
    
%     % User selects deflection point and determines presence of plateau
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

    FD.times{iFile} = 1:length(FD.forces{iFile});
    
    [res{iFile},res2{iFile},fprime{iFile},fofd{iFile}]=HW_stiffness(FD.distances{iFile},FD.forces{iFile});
     pwl(iFile) = res{iFile}.b;
     pwl2(iFile) = res2{iFile}.b;
     fd = FdData('names', FD.forces{iFile}, FD.distances{iFile}, FD.times{iFile});
     fd1=fd.subset('f',[-Inf 300]);
     %FD.fit{iFile} = fitfd(fd1,'model','network','noTrim','lBounds',[0 0 1266 0.0001],'uBounds',[1000 100 1266 10]); %Lp Lc S Fscale
     FD.fit{iFile} = fitfd(fd1,'model','odijk-f0','noTrim','lBounds',[1 1 0],'uBounds',[100 20 10000]); %Lp Lc S
     
     Lc(iFile)=FD.fit{iFile}.Lc;
     Lp(iFile)=FD.fit{iFile}.Lp;
     Smod(iFile)=FD.fit{iFile}.S;
     %Fscale(iFile)=FD.fit{iFile}.Fscale;
     Fscale(iFile)=1;
     Fzero(iFile)=FD.fit{iFile}.F0;
     plotfdfit(fd1,FD.fit{iFile})
     
     FD.distscaled{iFile}=(FD.distances{iFile}-Lc(iFile))/Lc(iFile);
    
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
       
    
    else MaxCurv{iFile}=dAvg(locs{iFile});
    end
    
end

% kT=4.114;
% Lp=5; %50 for dsDNA
% S=1266;
% Lc=3000;
% d=500:10:3500;
% dmicron=d./1000;
% 
%         y1=0.0001.*d+1;
%         y2=0.0005.*d+1;
%         y3=0.001.*d+1;
%         y4=0.008.*d+1;
%         y5=0.016.*d+1;
% 
% F = real(...
%         (2.*(Lp.*Lc.*S.*d - Lp.*S.*Lc.^2))./(3.*Lp.*Lc.^2) - ...
%            (-16.*Lp.^2.*S.^2.*(d.^2).*Lc.^2 + ...
%             32.*Lp.^2.*S.^2.*d.*Lc.^3 - 16.*Lp.^2.*S.^2.*Lc.^4)./ ...
%              (24.*Lp.*Lc.^2.*(-8.*Lp.^3.*S.^3.*(d.^3).*Lc.^3 + ...
%                24.*Lp.^3.*S.^3.*(d.^2).*Lc.^4 - ...
%                      24.*Lp.^3.*S.^3.*d.*Lc.^5 + ...
%                27.*kT.*Lp.^2.*S.^2.*Lc.^6 + 8.*Lp.^3.*S.^3.*Lc.^6 + ...
%                3.*sqrt(3).* ...
%                 sqrt(-16.*kT.*Lp.^5.*S.^5.*(d.^3).*Lc.^9 + ...
%                   48.*kT.*Lp.^5.*S.^5.*(d.^2).*Lc.^10 - ...
%                            48.*kT.*Lp.^5.*S.^5.*d.*Lc.^11 + ...
%                   27.*kT.^2.*Lp.^4.*S.^4.*Lc.^12 + ...
%                            16.*kT.*Lp.^5.*S.^5.*Lc.^12)).^(1./3)) + ...
%               (1./(6.*Lp.*Lc.^2)).* ...
%              (-8.*Lp.^3.*S.^3.*(d.^3).*Lc.^3 + ...
%              24.*Lp.^3.*S.^3.*(d.^2).*Lc.^4 - ...
%              24.*Lp.^3.*S.^3.*d.*Lc.^5 + ...
%                   27.*kT.*Lp.^2.*S.^2.*Lc.^6 + ...
%              8.*Lp.^3.*S.^3.*Lc.^6 + ...
%              3.*sqrt(3).* ...
%               sqrt(-16.*kT.*Lp.^5.*S.^5.*(d.^3).*Lc.^9 + ...
%                 48.*kT.*Lp.^5.*S.^5.*(d.^2).*Lc.^10 - ...
%                         48.*kT.*Lp.^5.*S.^5.*d.*Lc.^11 + ...
%                 27.*kT.^2.*Lp.^4.*S.^4.*Lc.^12 + ...
%                         16.*kT.*Lp.^5.*S.^5.*Lc.^12)).^(1./3));

% figure
% yyaxis left
% for k=1:NumFiles
%     plot(FD.distances{k},FD.forces{k})
%     vline(MaxCurv{k},'r')
%     hold on
% end
% %plot(d,F,'r')
% ylabel('Force (pN)')
% xlabel('Distance (um)')
% ylim([-50 400])
% %xlim([2 5])
% 
% yyaxis right
% plot(dAvg,Forceder2./5,'r--')
% ylim([-50 2000])
% plot(dAvg,Forceder1)
% hold off

% figure
% yyaxis left
% for k=1:NumFiles
%     plot(FD.distances{k},FD.forces{k})
%     vline(MaxCurv{k},'r')
%     hold on
% end
% %plot(d,F,'r')
% ylabel('Force (pN)')
% xlabel('Distance (um)')
% ylim([-50 400])
% %xlim([2 5])

colour='kr';
condition={'Control','Degraded'};

for k=1:NumFiles
    if length(info{k}) == 3
        treated(k)=info{k}{3};
    else 
        treated(k) = 0;
    end
    grouping{k}=condition{treated(k)+1};
    for m=1:length(FD.forces{k})-2
    FD.forcedif{k}(m)=FD.forces{k}(m+2)-FD.forces{k}(m);
    FD.distdif{k}(m)=FD.distances{k}(m+2)-FD.distances{k}(m);
    end
    
    ibreak{k}=find(FD.forcedif{k}<-1.5);
    iibreak{k}=diff(ibreak{k});
    double_ibreaks{k}=find(iibreak{k}==1)+1;
    ibreak{k}(double_ibreaks{k})=[];
    numbreak(k)=length(ibreak{k});
    if numbreak(k)>25
        numbreak(k)=0;
        numbreak_outliers(k)=numbreak(k);
        ibreak{k}=[];
    end
    
    breakforce{k}=FD.forces{k}(ibreak{k});
    breakdif{k}=FD.forcedif{k}(ibreak{k});
    
end
    icontrol=find(treated==0);
    idegraded=find(treated==1);
    breakdif_control=[];
    breakdif_degraded=[];
    breakforce_control=[];
    breakforce_degraded=[];
    
    for i=icontrol;
        breakdif_control=[breakdif_control breakdif{i}];
        breakforce_control=[breakforce_control breakforce{i}];
    end
    for i=idegraded;
        breakdif_degraded=[breakdif_degraded breakdif{i}];
        breakforce_degraded=[breakforce_degraded breakforce{i}];
    end
    
    breakdifs=horzcat(breakdif_control,breakdif_degraded);
    breakforces=horzcat(breakforce_control,breakforce_degraded);
    g_control=repmat({'Control'},1,length(breakdif_control));
    g_degraded=repmat({'Degraded'},1,length(breakdif_degraded));
    g=[g_control, g_degraded];

figure
boxplot(numbreak,grouping)
title('Number of rupture events')

figure
boxplot(breakdifs,g)
title('Size of rupture events')

figure
boxplot(breakforces,g)
title('Force at which rupture events take place')

figure
for k=1:NumFiles
    plot(FD.distances{k},FD.forces{k},colour(treated(k)+1))
    hold on
end
ylabel('Force (pN)')
xlabel('Distance (um)')
ylim([-30 350])
xlim([0 13])



figure
for k=1:NumFiles
    plot(FD.distscaled{k},FD.forces{k},colour(treated(k)+1))
    hold on
end
ylabel('Force (pN)')
xlabel('Strain')
ylim([-30 350])
xlim([-0.8 0.3])

figure
histogram(ChromoLength)
xlabel('Chromosome length (um)')
ylabel('Frequency')

figure
histogram(ChromoSlope)
xlabel('Stretch steepness at highest curvature (pN/um)')
ylabel('Frequency')

figure
histogram(ChromoForce)
xlabel('Force at highest curvature (pN)')
ylabel('Frequency')

figure
scatter(ChromoLength,ChromoSlope)
ylabel('Stretch steepness at highest curvature (pN/um)')
xlabel('Distance (um)')

figure
scatter(Lc,Smod)
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
