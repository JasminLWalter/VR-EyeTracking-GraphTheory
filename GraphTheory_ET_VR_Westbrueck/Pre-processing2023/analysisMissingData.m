%% --------------------- step4_resampling.m------------------------

% --------------------script written by Jasmin L. Walter-------------------
% -----------------------jawalter@uni-osnabrueck.de------------------------

% Description: 
% 

% Input: 
% uses 1004_Expl_S_1_ET_1_flattened.csv file
% Output: 


clear all;

%% adjust the following variables: savepath, current folder and participant list!-----------
% datapaths Westbrook harddrive
% savepath = 'E:\Westbrueck Data\SpaRe_Data\1_Exploration\pre-processing_2023\';
% 
% cd 'E:\Westbrueck Data\SpaRe_Data\1_Exploration\pre-processed_csv\'

% datapaths Living Transformation harddrive
savepath = 'E:\WestbrookProject\SpaRe_Data\control_data\pre-processing_2023\missingDataAnalysis\';

cd 'E:\WestbrookProject\SpaRe_Data\control_data\pre-processing_2023\velocity_based\step3_gazeProcessing\'

% Participant list of all participants that participated 5 sessions x 30 min 
% in Westbrook city

PartList = {1004 1005 1008 1010 1011 1013 1017 1018 1019 1021 1022 1023 1054 1055 1056 1057 1058 1068 1069 1072 1073 1074 1075 1077 1079 1080};
% PartList = {1004};


%% --------------------------------------------------------------------------


Number = length(PartList);
noFilePartList = [Number];
missingFiles = table;




% data = readtable('1004_Session_1_ET_1_data_smoothed.csv');


% loop code over all participants in participant list

for indexPart = 1:Number

    disp(['Paritipcant ', num2str(indexPart)])
    currentPart = cell2mat(PartList(indexPart));

    tic
    % loop over recording sessions (should be 5 for each participant)
    for indexSess = 1:5

        % get eye tracking sessions and loop over them (amount of ET files
        % can vary
        dirSess = dir([num2str(currentPart) '_Session_' num2str(indexSess) '*_data_processed_gazes.csv']);

        if isempty(dirSess)

            hMF = table;
            hMF.Participant = currentPart;
            hMF.Session = indexSess;
            missingFiles = [missingFiles; hMF];

        else
            %% Main part - runs if files exist!        
            % loop over ET sessions and check data            
            for indexET = 1:length(dirSess)
                disp(['Process file: ', num2str(currentPart), '_Session_', num2str(indexSess),'_ET_', num2str(indexET)]);
                % read in the data
                data = readtable(dirSess(indexET).name);

                timestamps = data.timeStampDataPointStart_converted;


                clean = strcmp(data.cleanData, 'True');
                badData = ~clean;
                
                percMD =sum(badData)/height(badData);
                
                badDataIndices = find(badData');
                diffBadData = diff([0 badDataIndices 0]);
                
                segmentStartIndices = badDataIndices([true, diffBadData(2:end-1) > 1]);
                segmentEndIndices = badDataIndices([diffBadData(2:end-1) > 1, true]);
                
                
                % Step 3: Calculate the exact time differences
                segmentLengths = timestamps(segmentEndIndices) - timestamps(segmentStartIndices) + (timestamps(2)-timestamps(1)); % To account for interval gaps
                
                
                % Plot the histogram of segment lengths
                figure (1);
                histogram(segmentLengths);
                xlabel('Length of consecutive bad data segments');
                ylabel('Frequency');
                title('Consecutive bad data segments, missing data precentage = ', strcat(num2str(percMD*100), '%'));

                ax = gca;
                exportgraphics(ax,strcat(savepath, num2str(currentPart), '_Session_', num2str(indexSess),'_ET_', num2str(indexET), 'missingData_histogram.png'),'Resolution',600)
                hold off 




            end
        end
    end
end

