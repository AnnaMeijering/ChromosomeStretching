function [force, distance, info, NOsel]=userselFDcurve(filepath)

 load(filepath);
 % User selects the stretching curve that should be analysed
    figure
    subplot(2,1,1);
    plot(time,forceCH1)
    vline(start_times,'g')

    subplot(2,1,2);
    plot(time,interbeaddist)
    [xtimes,~]= ginput(1);
    close
    
    if isempty(xtimes)
        NOsel=1;
        distance=0;
        info=0;
    else
        NOsel=0;
        index=find(abs(start_times-xtimes) == min(abs(start_times-xtimes)));
    
    % Here the data per file that has to be analysed should be listed
    distance=cell2mat(dist.abs(index));
    force = cell2mat(force.x(index));
    info{1}=pulling_speed;
    info{2}=sample_age;
    end

end