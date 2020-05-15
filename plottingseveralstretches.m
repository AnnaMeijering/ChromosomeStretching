clear
[filenames,paths]=uigetfile('D:\DataAnalysis\Chromavision\Emma\forcedrop_analysis\ForcedropfilesCombiTOPII\CombiWithoutTOPIItreated\*.mat',...
    'Select the INPUT DATA FILE');

filepath=strcat(paths,filenames);
load(filepath);

% User selects the stretching curve that should be analysed
    figure
    subplot(2,1,1);
    plot(time,forceCH1)
    ylabel('Force (pN)')
    vline(start_times,'g')
    ax = gca;
    ax.YGrid = 'on';

    subplot(2,1,2);
    plot(time,interbeaddist)
    xlabel('Time (s)')
    ylabel('Distance (um)')
    grid on
    sgt=sgtitle(filenames);
    sgt.FontSize=10;
    [xtimes,yforces]= ginput;
    close
    
    colours=['k' 'k' 'b' 'b' 'r' 'r' 'g' 'g' 'c' 'c' 'm' 'm'];
    
for i=1:length(xtimes)   
    index=find(abs(start_times-xtimes(i)) == min(abs(start_times-xtimes(i))));
    
    d_values{i}=cell2mat(dist.abs(index));
    f_values{i} = cell2mat(force.x(index)); 
    t_values{i} = 1:length(f_values{i});
    
end

% figure
% subplot(2,2,1)
% for k=1:length(xtimes)
%     plot(t_values{k},d_values{k},colours(k))
%     hold on
% end
% xlabel('Time')
% ylabel('Distance (um)')
% hold off
% 
% subplot(2,2,2)
% for k=1:length(xtimes)
%     plot(t_values{k},f_values{k},colours(k))
%     hold on
% end
% xlabel('Time')
% ylabel('Force (pN)')
% hold off
% 
% subplot(2,2,[3 4])
% for k=1:length(xtimes)
%     plot(d_values{k},f_values{k},colours(k))
%     hold on
% end 
% xlabel('Distance (um)')
% ylabel('Force (pN)')
% hold off
%     sgt=sgtitle(filenames);
%     sgt.FontSize=10;

figure
for k=1:length(xtimes)
    plot(d_values{k},f_values{k},colours(k))
    hold on
end 
xlabel('Distance (um)')
ylabel('Force (pN)')
hold off