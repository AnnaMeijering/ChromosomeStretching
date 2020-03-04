function loadaddsave(stretchpath)
    load(stretchpath);
    prompt = {'TOPII degraded? 1/0'};
    title = 'Input';
    dims = [1 35];
    definput = {'0'};
    answer = inputdlg(prompt,title,dims,definput);
    TOPIIdegraded = int16(str2double(answer{1}));
    save(stretchpath)
end