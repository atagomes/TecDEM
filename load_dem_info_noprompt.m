function load_dem_info_noprompt(varargin)

dispout = evalin('base','dispout');
tecfig = evalin('base','tecfig');

[areaname,location]=uigetfile('*.tif');

if areaname ~= 0
    add_histroy({'Start loading Digital Elevation Model.'});
    
    fls = strcat(location,areaname);
    [dem,area_info] = rasterread(fls);

    info.dtheta = -0.45;
    info.path = fls(1:end-4);
    info.project_name = areaname;

    rawdem = double(dem.data);

    assignin('base','rawdem',rawdem);

    savefile = strcat(info.path,'_rawDEM.mat');
    save(savefile,'rawdem')
    
    ny = area_info.Height;
    nx = area_info.Width;

    res1 = area_info.GeoTransformation(2);

    x1 = area_info.bbox(1,1);
    y1 = area_info.bbox(1,2);
    x2 = area_info.bbox(2,1);
    y2 = area_info.bbox(2,2);
    
    res = 110000*res1;
    area_info.res = res;

    assignin('base','info',info);
    assignin('base','area_info',area_info);
    assignin('base','r',[ny nx]);
    assignin('base','res',res);

    savefile = strcat(info.path,'_INFO.mat');
    save(savefile,'area_info','info')
    dem_info_write()
    
    textfile = strcat(info.path,'_info.txt');

    fid=fopen(textfile,'r');

    while 1
        tline = fgetl(fid);
        if ~ischar(tline),
            break
        end
        add_histroy({tline});
    end

    fclose(fid)

    add_histroy({'Digital Elevation Model loaded successfully.'});
    add_comm_line();
    
end

end