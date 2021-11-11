function [output_Y_estimate,output_b_estimate,output_model,output_model_esti,output_y_esti_] = statistic_regression_model(sample,Y_pos,X_pos,high_power)
%UNTITLED2 此处显示有关此函数的摘要
%   此处显示详细说明
% eval(['C' num2str(Category_index) '_TrainValue = C' ...
%         num2str(Category_index) '_TrainData(:,1:size(SampleData,2)-1);'])
%     
%% I 确定输入输出样本
% [tagNum,~] = size(tag);
% [result,pos] = ismember(main_tag,tag);
%  
% X_col_select = 1:tagNum;
% X_col_select(pos) = [];
Y = sample(:,Y_pos);
X = sample(:,X_pos);
X_num = numel(X_pos);
for ii = 1:X_num
    eval(['x' num2str(ii) '= X(:,' num2str(ii) ')'])
end
% Y_num = tagNum - X_num;
beta_num = (high_power+1)*X_num;
%% II 模型初始化
x_index = repmat(1:X_num,high_power+1,1);
power_index = repmat(high_power:-1:0,1,X_num);
myfun = 'y~';
for ii = 1:beta_num
    myfun = [myfun 'b' num2str(ii) '*x' num2str(x_index(ii)) '^' num2str(power_index(ii)) '+'];
end
myfun(end) = '';
% myfun = ['y~b1*x' num2str(ii) '^' high_power];
%% III 模型构建
% myfun = 'y~b1*x4^3+b2*x4^2+b3*x4+b4*exp(b5*x1)+b6*x3^3+b7*x3^2+b8*x3+b9';
% X = [x1,x3,x4];
beta0 = ones(1,beta_num);
mdl = fitnlm(X,Y,myfun,beta0);
CoefficientsEstimate = mat2cell(mdl.Coefficients.Estimate,ones(1,beta_num),1);

for ii = 1:beta_num
   eval([mdl.CoefficientNames{ii} '= CoefficientsEstimate{' num2str(ii) '}'])
end

y_esti = '';
for ii = 1:beta_num
    y_esti = [y_esti 'b' num2str(ii) '.*x' num2str(x_index(ii)) '.^' num2str(power_index(ii)) '+'];
end
y_esti(end) = '';

eval(['y_compute =' y_esti ';'])
b_origin_sort = str2num(char(replace(mdl.CoefficientNames,"b","")'));
[~,b_pos] = ismember(1:beta_num,b_origin_sort);
b = cell2mat(CoefficientsEstimate(b_pos));


output_Y_estimate = y_compute;
output_b_estimate = b;
output_model = myfun;
output_model_esti = mdl;
output_y_esti_ = y_esti;
end

