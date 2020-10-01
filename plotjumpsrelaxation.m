    load('D:\DataAnalysis\Chromavision\Emma\jumps\firstjumpsselection\jumps.mat')
    
    for i=1:NFiles;
%     tfit_i=find(abs(time-xtimes(1)-10000)==min(abs(time-xtimes(1)-10000)));
%     time_jump{i}=time(tstart_i:tend_i);
%     time_fit{i}=time(tstart_i:tfit_i)/1000;
%     force_jump{i}=forceCH1(tstart_i:tend_i);
%     
%     force_fit{i}=(forceCH1(tstart_i:tfit_i)-forceCH1(tend_i))/(forceCH1(tstart_i)-forceCH1(tend_i));
%     force_fitlog{i}=log(force_fit{iF});
%     P = polyfit(time_fit{i},force_fitlog{i},1);
%     yfit = P(1)*time_fit{i}+P(2);
    force_jump_scaled{i}=(force_jump{i}-force_jump{i}(end))/(force_jump{i}(1)-force_jump{i}(end));
    force_jump_scaled_smoothed{i}=smoothdata(force_jump_scaled{i},'movmean',50);
    end
    
    figure
    for i=2:NFiles
    plot (time_jump{i},force_jump{i})
    hold on
    end
    xlabel('Time (s)')
    ylabel('Relative force change')
    axis([0 120 -0.1 1])
    hold off

    figure
    for i=2:NFiles
    plot ((time_jump{i}-time_jump{i}(1))/1000,force_jump_scaled_smoothed{i})
    hold on
    end
    Exparray=exp(-(1/20).*(time_jump{17}-time_jump{17}(1))/1000);
    plot((time_jump{17}-time_jump{17}(1))/1000,Exparray,'r')
    xlabel('Time (s)')
    ylabel('Relative force change')
    axis([0 120 -0.1 1])
    hold off
    
    
    
    
    figure
    for i=2:NFiles
    semilogy((time_jump{i}-time_jump{i}(1))/1000,force_jump_scaled_smoothed{i})
    hold on
    end
    xlabel('Time (s)')
    ylabel('Relative force change')
    axis([0 60 0.1 1])
    hold off
    
        figure
    for i=2:NFiles
    loglog((time_jump{i}-time_jump{i}(1))/1000,force_jump_scaled_smoothed{i})
    hold on
    end
    xlabel('Time (s)')
    ylabel('Relative force change')
    axis([0 120 0.1 1])
    hold off
    
    figure
    for i=1:NFiles;
    plot(time_fit{i}-time_fit{i}(1),force_fit{i})
    hold on
    end
    hold off
    
    figure
    for i=2:NFiles;
    plot((time_jump{i}-time_jump{i}(1))/1000,force_jump{i}-force_jump{i}(1))
    hold on
    end
    xlabel('Time (s)')
    ylabel('Force (pN)')
    hold off
