clear
[filenames,paths]=uigetfile('D:\DataAnalysis\Chromavision\Emma\Selection_NoRuptures\subselection\ThirdStretchOver300pN_alsofirststretches\*.mat',...
    'Select the INPUT DATA FILE');

filepath=strcat(paths,filenames);
load(filepath);

% User selects the stretching curve that should be analysed

figure
set(gcf, 'Position',  [100, 100, 1000, 1000])   
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
    
    colours=['k' 'b' 'r' 'r' 'g' 'g' 'c' 'c' 'm' 'm' 'y' 'y' 'k' 'k' 'b' 'b' 'r' 'r' 'g' 'g' 'c' 'c' 'm' 'm' 'y' 'y'];
    
for i=1:length(xtimes)   
    index=find(abs(start_times-xtimes(i)) == min(abs(start_times-xtimes(i))));
    
    d_values{i}=cell2mat(dist.abs(index));
    f_values{i} = cell2mat(force.x(index)); 
    fy_values{i}= cell2mat(force.y(index));
    t_values{i} = 1:length(f_values{i});
    time_val{i}= cell2mat(force.x(index));
    
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
xlim([0 5])
ylim([-50 300])
hold off

% figure
% yyaxis left
%     plot(d_values{1},f_values{1},colours(1))
%     hold on
% yyaxis right
% plot(d_values{1},fy_values{1},colours(1))
% xlabel('Distance (um)')
% ylabel('Force (pN)')
% xlim([0 5])
% %ylim([-50 300])
% hold off


% %[res,k_num_x,k_model,k_plateau_x,k_model_low,l_chrom,l_index,f_num]=HW_stiffness_version2b(d_values{1},f_values{1},100,200,0.02);
% %[res,k_num_y,k_model,k_plateau_y,k_model_low,l_chrom,l_index,f_num]=HW_stiffness_version2b(d_values{1},fy_values{1},100,200,0.02);
% ftot=sqrt(f_values{1}.^2+fy_values{1}.^2);
% %alpha=cot(fy_values{1}./f_values{1});
% beta=acos(f_values{1}./ftot);
% 
% figure
% yyaxis left
% plot(d_values{1},ftot)
% ylabel('Force (pN)')
% ylim([-50 350])
% hold on
% plot(d_values{1},f_values{1})
% yyaxis right
% plot(d_values{1},beta)
% ylabel('Angle (rad)')
% xlabel('Distance (µm)')
% 
% figure
% plot(f_values{1},fy_values{1})
% ylim([-50 200])
% xlim([-50 200])
% hline(0)
% vline(0)



