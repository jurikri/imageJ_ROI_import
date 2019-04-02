clear; clc; close all;

%% select pathway
try load .dir.mat; catch; dir_nm = [cd(), filesep];  end     
[file_nm, dir_nm] = uigetfile(fullfile(dir_nm, '*.xlsx'));
filepath = [dir_nm, file_nm];

%% transfer Coor
cnt = 0;
while 1
    cnt = cnt+1
    try
        Coor{cnt,1} = xlsread(filepath, cnt);
    catch
        break
    end
end
 
ijm = string(zeros((size(Coor, 1)*2)+2,1));

%% make save folder, varience
filepath = [dir_nm file_nm '_save'];
if (exist(filepath, 'dir') == 0)
    % disp(['Made a result directory at :', newline, char(9), filepath]);
    mkdir(filepath);
end


%% basic setup for ijm
tmp = 'roiManager("Show All with labels");';
ijm(1,1) = tmp;
tmp = 'run("ROI Manager...");';
ijm(2,1) = tmp;
tmpadd = 'roiManager("Add");';

%% save csv, for each ROI

filepath2 = strrep(filepath,'\','/');

for ROINum = 1:size(Coor, 1)
    matrix1 = cell2mat(Coor(ROINum,1));
    matrix2 = transpose(matrix1);
    
    filename = [filepath2 '/' num2str(ROINum) '.csv'];
    csvwrite(filename, matrix2)
   
    tmp =  ['run("XY Coordinates... ", "open=[' filename ']");'];
    ijm(ROINum*2-1+2,1) = tmp;
    
    ijm(ROINum*2-0+2,1) = tmpadd;
end

writematrix(ijm,[dir_nm 'imj.csv']);

%%

disp('done')
