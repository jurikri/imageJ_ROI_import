clear; clc; close all;

%% select pathway
try load .dir.mat; catch; dir_nm = [cd(), filesep];  end     
[file_nm, dir_nm] = uigetfile(fullfile(dir_nm, '*.tif'));
filepath = [dir_nm, file_nm];

savepath = [filepath '_fix.tif'];

%% detect and save
clear saveFrame
tiff_info = imfinfo(filepath);
for frame = 1:size(tiff_info,1)
    disp([num2str(frame) ' / ' num2str(size(tiff_info,1))])
    msFrame = uint16(imread(filepath, frame));
    tmp = sum(msFrame,2);
    msplot(frame) = sum(find(~tmp)>0);
    
    saveFrame = uint16(imread(filepath,frame));
    if msplot(frame) > 15
        saveFrame = buffter;
    end
    imwrite(saveFrame, savepath, 'WriteMode', 'append', 'Compression', 'none')
    buffter = saveFrame;
end

plot(msplot)
find(msplot > 15)
