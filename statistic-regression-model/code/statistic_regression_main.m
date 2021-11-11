close all
%% ��ʼ��-�ļ�Ŀ¼��ȡ
% addpath "..\sample-data\�����н�̳���ڶ���ˮ�������޹�˾"
dataDirPath = "..\sample-data";
files = dir(dataDirPath);
dirName = {files(3:end).name};
factoryName = dirName;
%��ȡ�ļ����������ļ�
% fullPath = fullfile("..\sample-data\�����н�̳���ڶ���ˮ�������޹�˾",)

factoryDataPath = "..\sample-data\"+factoryName;                   % �������ݴ�ŵ��ļ���·��
factoryTotalNum = numel(factoryName);
monitorTagFileName = cell(factoryTotalNum,1);
monitorTagName = cell(factoryTotalNum,1);
monitorTagDataDir = cell(factoryTotalNum,1);
for dir_index = 1:factoryTotalNum
    %��ȡ��ǰ��ҵ�����������ļ���
    monitorTagDataFile = dir(fullfile(factoryDataPath(dir_index),'*.xlsx'));  % ��ʾ�ļ��������з��Ϻ�׺��Ϊ.xlsx�ļ���������Ϣ
    monitorTagFileName{dir_index} = {monitorTagDataFile.name}';
    monitorTagName{dir_index} = replace({monitorTagDataFile.name}','.xlsx','');
%     cell2mat([{monitorTagDataFile.folder}' {monitorTagDataFile.name}'])
    folder = cell2mat([{monitorTagDataFile.folder}']);
    name = cell2mat([{monitorTagDataFile.name}']);
    monitorTagDataDir{dir_index} = strcat(folder,'\',name);
end

% display(FileNames{1})




% disp(dirName)
%% ��������
currDirIndex = 1;
%��ȡ�ļ�������������
% filename = fullfile(Path,FileNames{1});
currDirTotalFile = monitorTagFileName{currDirIndex};
[fileNum,arg] = size(currDirTotalFile);
sample = [];
for file_index = 1:fileNum
   filename = monitorTagDataDir{currDirIndex}(file_index,:);
    opts = detectImportOptions(filename);
    % opts.PreserveVariableNames = true;
    T = readtable(filename,opts);
    sample = [sample T.value]; 
end

%% ������������
% sample = sample(1:100,:);



disp(sample)
Objname = 'GK_LYG_GDSW';
X_tagName = {'E10510','E50461','E10110'};
Y_tagName = {'E20620'};
X_tagName = strcat(Objname,'.',X_tagName);
Y_tagName = strcat(Objname,'.',Y_tagName);

[Xresult,Xpos] = ismember(X_tagName,monitorTagName{1});
[Yresult,Ypos] = ismember(Y_tagName,monitorTagName{1});
X_pos = sort(Xpos);
Y_pos = sort(Ypos);
X_tagNameAdjusted = monitorTagName{1}(X_pos);


% ȥ����ֵ0
Y_badValue_row_pos = find(0==sample(:,Y_pos));
sample(Y_badValue_row_pos,5) = deal(sample(Y_badValue_row_pos+2,5));
data_column = sample(:,5);
outliers_pos = [find(data_column<5.1);find(data_column>13)];
sample(outliers_pos,5) = deal((data_column(outliers_pos-4)+data_column(outliers_pos+4))./2);
% sample_column = [X_pos Y_pos];
% for ii = 1:numel(sample_column)
%     data_column = sample(:,sample_column(ii));
%     badValue_row_pos = find(0==data_column);
%     sample(badValue_row_pos,sample_column(ii)) = deal((sample(badValue_row_pos+2,sample_column(ii))+sample(badValue_row_pos-2,sample_column(ii)))./2);
% %     data_mean = mean(data_column);
% %     data_std = std(data_column);
% %     outliers_pos = [find(data_column<data_mean-2.4*data_std);find(data_column>data_mean+2.4*data_std)];
% %     sample(outliers_pos,sample_column(ii)) = deal((sample(outliers_pos-2,sample_column(ii))+sample(outliers_pos+2,sample_column(ii)))./2);
% end


%% ģ�ʹ
high_power = 3;
[Y_estimate,b_estimate,model,model_esti,y_esti_] = statistic_regression_model(sample,Y_pos,X_pos,high_power);

%% ͼ���������
figure(1)
hold on
plot(1:numel(Y_estimate),sample(:,Y_pos),'-b')
plot(1:numel(Y_estimate),Y_estimate,'-ro')
% plot(1:numel(Y_estimate),Y_estimate-sample(:,Y_pos),'-gx')
legend('ʵ�ʳ�ˮTN','�ع���ϳ�ˮTN','Location','NorthWest');
hold off
figure(2)
hold on
plot(1:numel(Y_estimate),0.3*ones(1,numel(Y_estimate)),'-r')
plot(1:numel(Y_estimate),abs((Y_estimate-sample(:,Y_pos))./sample(:,Y_pos)),'-gx')
legend('�����','Location','NorthWest');
hold off
disp(['model:' model])
disp(strcat("b",num2str((1:numel(b_estimate))'),"=",num2str(b_estimate)))
disp(strcat("x",num2str((1:numel(X_pos))'),"-->",X_tagNameAdjusted))
disp(['y --> ' cell2mat(Y_tagName)])
% disp(strcat('b',(1:numel(b_estimate))','=' b_estimate))