function [d_values,f_values,t_values,top2degron]=selectthreestretches(filepath)

load(filepath);
top2degron=TOPIIdegraded;
% User selects the stretching curve that should be analysed

figure
set(gcf, 'Position',  [100, 100, 1000, 1000])   
    subplot(2,1,2);
    for i=1:length(force.x)
    plot(dist.abs{i},force.x{i})
    hold on
    xlabel('Distance (um)')
    ylabel('Force (pN)')
    grid on
    end

    hold off
    
    subplot(2,1,1);
    for i=1:length(force.x)
    plot(time(start_real_times_index(i):end_real_times_index(i)),force.x{i})
    hold on
    ylabel('Force (pN)')
    ax = gca;
    ax.YGrid = 'on';
    end
    vline(start_times,'g')
    [xtimes,yforces]= ginput(3);
    hold off
    close
    
    colours=['k' 'k' 'b' 'b' 'r' 'r' 'g' 'g' 'c' 'c' 'm' 'm' 'y' 'y' 'k' 'k' 'b' 'b' 'r' 'r' 'g' 'g' 'c' 'c' 'm' 'm' 'y' 'y'];
    
    
figure
for i=1:3  
    index=find(abs(start_times-xtimes(i)) == min(abs(start_times-xtimes(i))));
    
    d_values{i}=cell2mat(dist.abs(index));
    f_values{i} = cell2mat(force.x(index)); 
    t_values{i} = 1:length(f_values{i});

    plot(d_values{i},f_values{i})
    hold on
    xlabel('Distance (um)')
    ylabel('Force (pN)')
    grid on
    
end
hold off
