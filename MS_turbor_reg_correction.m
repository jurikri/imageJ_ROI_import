clear; clc; close all;

%% select pathway
try load .dir.mat; catch; dir_nm = [cd(), filesep];  end     
[file_nm, dir_nm] = uigetfile(fullfile(dir_nm, '*.tif'));
filepath = [dir_nm, file_nm];

savepath = [filepath '_fix.tif'];

%% video load

tiff_info = imfinfo(filepath);

% savesetup
t = Tiff(savepath,'w'); 
tagstruct.ImageLength = tiff_info(1).Height;
tagstruct.ImageWidth = tiff_info(1).Width;
tagstruct.Photometric = 1;
% https://www.awaresystems.be/imaging/tiff/tifftags/photometricinterpretation.html
% according to this reference, 'BlacksZero' is 1
tagstruct.BitsPerSample = tiff_info(1).BitsPerSample;
tagstruct.SamplesPerPixel = tiff_info(1).SamplesPerPixel;
tagstruct.PlanarConfiguration = 1;
% according to this reference, 'Chunky' is 1
tagstruct.Software = 'MATLAB' 

setTag(t,tagstruct)
setTag(t, 'numberOfStrips' , 1)
%% detect and save
clear saveFrame
for frame = 1:size(tiff_info,1)
    msFrame = uint8(imread(filepath,frame));
    tmp = sum(msFrame,2);
    msplot(frame) = sum(find(~tmp)>0);
    
    saveFrame(:,:,frame) = uint32(imread(filepath,frame));
    if msplot(frame) > 15
        saveFrame(:,:,frame) = uint32(imread(filepath,frame-1));
    end
    write(t,saveFrame(:,:,frame));
end



close(t);

plot(msplot)
find(msplot > 15)

ms.getTag

ms = Tiff(filepath, 'r+')
write(ms,saveFrame);

























