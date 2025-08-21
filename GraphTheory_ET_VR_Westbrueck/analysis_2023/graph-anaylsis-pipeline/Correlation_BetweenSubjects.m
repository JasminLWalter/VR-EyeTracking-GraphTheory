%% -------------------- Correlation_BetweenSubjects -----------------------

% -------------------- written by Lucas Essmann - 2020 --------------------
% ---------------------- lessmann@uni-osnabrueck.de -----------------------

% Requirements:
% Table of all node degree values (n) for all subjects (m) of shape (mxn)

%--------------------------------------------------------------------------
%Procedure: 
% Calculating the correlation coefficients between the degree distributions
% of all subjects. Afterwards calculating the mean value and plotting the
% values in a histogram

clear all; 

plotting_wanted = true; %if you want to plot, set to true
saving_wanted = true; %if you want to save, set to true


%% -------------------------- Initialisation ------------------------------

path = what;
path = path.path;

%savepath
savepath = 'F:\WestbrookProject\Spa_Re\control_group\analysis_velocityBased_2023\graph-theoretical-analysis\nodeDegreeCentrality\';


% cd into centrality overview folder location
cd 'F:\WestbrookProject\Spa_Re\control_group\analysis_velocityBased_2023\graph-theoretical-analysis\nodeDegreeCentrality\'



%-----load the node degree overview-----
% The overview table consists of all node degree values (n) for all 
% subjects (m) with the shape mxn

file = strcat('Overview_NodeDegree');
overview = load(file);
overview = struct2cell(overview);
overview = overview{1,1};

%------calculate the correlation between all subjects--------
% this yields a diagonal matrix of all correlation coefficients
corr_mat_all = corr(table2array(overview(:,2:end)));
%Delete the upper diagonal half of the matrix)
corr_mat_all = tril(corr_mat_all,-1);
%Remove all 0 values (even though the correlation could be ==0)
corr_array = corr_mat_all(corr_mat_all ~= 0); 

% Since the pearson correlation coefficient is not normally distributed
% we apply the fisher z transformation before applying further
% operations

%z Transformation
corr_mat_Z = arrayfun(@fisherZ,corr_array);
%Taking the mean correlation
mean_corrZ = mean(corr_mat_Z);
%Back Transformation
mean_corr = fisherZ_Back(mean_corrZ);

std_corrZ = std(corr_mat_Z);
%Back Transformation
std_corr = fisherZ_Back(std_corrZ);



%% -------------------------- Plotting ------------------------------------
figgy = figure('Name','NodeDegree_Correlations');
histogram(corr_array,10);
xlabel('Correlation Coefficients'); 
ylabel('Frequency');
ax = gca;
ax.XMinorTick = 'on';
% ylim([0 50]);
set(gca,'FontName','Helvetica','FontSize',20)



%% --------------------------- Saving -------------------------------------

if saving_wanted == true
    
    save([savepath 'CorrelationArray.mat'],'corr_array');
    disp('Saved Correlation Array');
    
    
    saveas(gcf,strcat(savepath, ...
        'NodeDegree_Correlation_Histogram','.png'),'png');
    disp('Saved Correlation Histogram');

end


disp(['mean of correlation coefficients =  ', num2str(mean_corr)])
disp(['std of correlation coefficients =  ', num2str(std_corr)])

disp('Done');

% clearvars '-except' ...
%     mean_corr ...
%     corr_array;




%FisherZ Transformation Function
function y = fisherZ(x)
    y = 0.5*(log(1+x)-log(1-x));
end
%FisherZ BackTransformation Function
function y = fisherZ_Back(x)
    y = (exp(2*x)-1)/(exp(2*x)+1);
end