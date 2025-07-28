%% --------------------- analysis_dataPreparation_WB.m------------------------

% --------------------script written by Jasmin L. Walter-------------------
% -----------------------jawalter@uni-osnabrueck.de------------------------

% Description: 
% 

% Input: 
% uses 1004_Expl_S_1_ET_1_.csv file
% Output: 


clear all;

%% adjust the following variables: savepath, current folder and participant list!-----------
% datapaths Westbrook harddrive
% savepath = 'E:\Westbrueck Data\SpaRe_Data\1_Exploration\pre-processing_2023\';
% 
% cd 'E:\Westbrueck Data\SpaRe_Data\1_Exploration\pre-processed_csv\'

% datapaths Living Transformation harddrive
savepath = 'E:\WestbrookProject\SpaRe_Data\control_data\pre-processing_2023\pre-processing_analysis\';

cd 'E:\WestbrookProject\SpaRe_Data\control_data\pre-processing_2023\step1_preparation\'

% Participant list of all participants that participated 5 sessions x 30 min 
% in Westbrook city

PartList = {1004 1005 1008 1010 1011 1013 1017 1018 1019 1021 1022 1023 1054 1055 1056 1057 1058 1068 1069 1072 1073 1074 1075 1077 1079 1080};
% PartList = {1004};


%% --------------------------------------------------------------------------


Number = length(PartList);
noFilePartList = [Number];
missingFiles = table;

replacedData = [];
replacedData_NH = [];

% overviewDistanceCheck = table;

categoriess = ["seeThrough","body", "notReplaced"];
categories_NH = ["seeThrough","body", "noHouse", "notReplaced"];

file = 0;
% loop code over all participants in participant list

for indexPart = 1:Number
    currentPart = cell2mat(PartList(indexPart));
    disp(['participant ', num2str(currentPart)])
    tic
    % loop over recording sessions (should be 5 for each participant)
    for indexSess = 1:5
        % get eye tracking sessions and loop over them (amount of ET files
        % can vary

        dirSess = dir([num2str(currentPart) '_Session_' num2str(indexSess) '*_data_prepared.csv']);
        
        if isempty(dirSess)
            
            disp("missing file detected")
            hMF = table;
            hMF.Participant = currentPart;
            hMF.Session = indexSess;
            missingFiles = [missingFiles; hMF];
        
        else
            %% Main part - runs if files exist!        
            % loop over ET sessions and check data            
            for indexET = 1:length(dirSess)
                % disp(['Process file: ', num2str(currentPart), '_Session_', num2str(indexSess),'_ET_', num2str(indexET)]);
                
                file = file+1;
                % read in the data
                data = readtable(dirSess(indexET).name);

                occ = histcounts(categorical(data.replacedRows), categoriess);

                occNH = histcounts(categorical(data.replacedRows_NH), categories_NH);

                replacedData = [replacedData; [occ, height(data)]];

                replacedData_NH = [replacedData_NH; [occNH, height(data)]];
 


            end

        end

    end
    toc

end


overviewReplacedData = array2table(replacedData, 'VariableNames', [categoriess, "dataLenght"]);
overviewReplacedData_NH = array2table(replacedData_NH, 'VariableNames', [categories_NH, "dataLength"]);

replacedData_p = overviewReplacedData;
replacedData_p{:, 1} = replacedData_p {:, 1} ./ replacedData_p {:, 4};
replacedData_p{:, 2} = replacedData_p {:, 2} ./ replacedData_p {:, 4};
replacedData_p{:, 3} = replacedData_p {:, 3} ./ replacedData_p {:, 4};

replacedData_NH_p = overviewReplacedData_NH;
replacedData_NH_p{:, 1} = replacedData_NH_p {:, 1} ./ replacedData_NH_p {:, 5};
replacedData_NH_p{:, 2} = replacedData_NH_p {:, 2} ./ replacedData_NH_p {:, 5};
replacedData_NH_p{:, 3} = replacedData_NH_p {:, 3} ./ replacedData_NH_p {:, 5};
replacedData_NH_p{:, 4} = replacedData_NH_p {:, 4} ./ replacedData_NH_p {:, 5};


figure(1)

plotty = boxplot(replacedData_p{:,1:3},'Labels', categoriess);
title("replaced data overview")
saveas(gcf,strcat(savepath,'overviewReplacedData.png'));



figure(2)

plotty2 = boxplot(replacedData_NH_p{:, 1:4}, 'Labels', categories_NH);
title("replaced data overview including NH replacement")
saveas(gcf,strcat(savepath,'overviewReplacedData_NH.png'));




writetable(overviewReplacedData, [savepath 'overviewReplacedData.csv']);
writetable(overviewReplacedData_NH, [savepath 'overviewReplacedData_NH.csv']);


disp("done")



