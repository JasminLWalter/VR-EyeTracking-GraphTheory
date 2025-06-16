% --------------------script written by Jasmin L. Walter-------------------
% -----------------------jawalter@uni-osnabrueck.de------------------------

% Description: 

% Input:  

% Output:



clear all;

%% adjust the following variables: savepath, current folder and participant list!-----------


savepath= 'E:\WestbrookProject\SpaRe_Data\control_data\pre-processing_2023\velocity_based\analysis_gazeProcessing\';


cd 'E:\WestbrookProject\SpaRe_Data\control_data\pre-processing_2023\velocity_based\step3_gazeProcessing\intermediateProcessing\';

% 26 participants with 5x30min VR trainging less than 30% data loss
PartList = {1004 1005 1008 1010 1011 1013 1017 1018 1019 1021 1022 1023 1054 1055 1056 1057 1058 1068 1069 1072 1073 1074 1075 1077 1079 1080};
% PartList = {1004 1005};

%-------------------------------------------------------------------------------


Number = length(PartList);
noFilePartList = [Number];
missingFiles = table;

overview = table;
indexO = 0;

for indexPart = 1:Number
    
    disp(['Paritipcant ', num2str(indexPart)])
    currentPart = cell2mat(PartList(indexPart));
    
    tic
    % loop over recording sessions (should be 5 for each participant)
    for indexSess = 1:5
        
        % get eye tracking sessions and loop over them (amount of ET files
        % can vary
        dirSess = dir([num2str(currentPart) '_Session_' num2str(indexSess) '*_data_correTS_mad_wobig.csv']);
        

        if isempty(dirSess)
            
            hMF = table;
            hMF.Participant = currentPart;
            hMF.Session = indexSess;
            missingFiles = [missingFiles; hMF];
        
        else
            %% Main part - runs if files exist!        
            % loop over ET sessions and check data            
            for indexET = 1:length(dirSess)
                
                indexO = indexO+1;
                disp(['Process file: ', num2str(currentPart), '_Session_', num2str(indexSess),'_ET_', num2str(indexET)]);
                % read in the data
                data = readtable(dirSess(indexET).name);
                % data = readtable('1004_Session_1_ET_1_data_correTS_mad_wobig.csv');

                fixations = data.events == 2.0;     

                remData = strcmp(data.removedData, 'True');
                interp = strcmp(data.interpolated, 'False');

                data.goodData = ~(remData & interp);

                events = data.events;
               
                 % Find the start and end indices for fixations
                fixation_start_indices = find(events == 2.0);
                fixation_end_indices = find(events == -2.0);
                
                % Find the start and end indices for saccades
                saccade_start_indices = find(events == 1.0);
                saccade_end_indices = find(events == -1.0);
                
                % Initialize logical arrays for fixations and saccades
                is_fixation = false(height(data), 1);
                is_saccade = false(height(data), 1);
                
                % Mark the rows corresponding to fixations
                for i = 1:length(fixation_start_indices)
                    while(fixation_start_indices(i)> fixation_end_indices(i))
                        fixation_end_indices(i) = [];
                    end

                    is_fixation(fixation_start_indices(i):fixation_end_indices(i)) = true;
                end
                
                % Mark the rows corresponding to saccades
                for i = 1:length(saccade_start_indices)
                    while(saccade_start_indices(i)> saccade_end_indices(i))
                        saccade_end_indices(i) = [];
                    end
                    is_saccade(saccade_start_indices(i):saccade_end_indices(i)) = true;
                end
                
                % calculate rows
                fixation_rows = data.goodData(is_fixation);
                saccade_rows = data.goodData(is_saccade);
                missingData_fix = is_fixation & (remData & interp);
                missingData_sacc = is_saccade & (remData & interp);



                % check for isFix column

                %% better understand where during saccades missing data occurs
                % % Identify the indices where goodData is false (missing data)
                % % Identify the indices where goodData is false (missing data)
                % missing_data_indices = find(~data.goodData);
                % 
                % % Initialize logical arrays to check missing data coverage
                % exact_saccade_match = 0;  % To check if missing data matches exactly one saccade
                % partial_saccade_match = 0; % To check if missing data is smaller but within a saccade
                % sacc_fix_mix = 0;
                % 
                % startI = missing_data_indices(1);
                % endI = missing_data_indices(1);
                % 
                % 
                % for i = 1: length(missing_data_indices)
                % 
                %     if (missing_data_indices(i) - endI) <= 1
                % 
                %         endI = missing_data_indices(i);
                % 
                %     else
                % 
                %         missingDRange = startI:endI;
                % 
                %         % Loop through each saccade to check for exact and partial matches
                %         for j = 1:length(saccade_start_indices)
                %             saccade_range = saccade_start_indices(j):saccade_end_indices(j);
                % 
                %             if any(ismember(missingDRange, saccade_range))
                %                 break
                % 
                %                 % Check if the entire missing data segment is within this saccade
                %                 if all(ismember(missingDRange, saccade_range))
                %                     % Check if the missing data segment exactly matches the saccade
                %                     if (length(saccade_range) - ismember(missingDRange, saccade_range)) <= 3
                %                         exact_saccade_match = exact_saccade_match+1;
                %                     else
                %                         partial_saccade_match = partial_saccade_match+1;
                %                     end
                % 
                %                 else
                %                     sacc_fix_mix = sacc_fix_mix +1;
                %                 end
                % 
                %             end
                % 
                %         end
                % 
                % 
                %         startI = missing_data_indices(i);
                %         endI = missing_data_indices(i);
                % 
                % 
                %     end
                % 
                % 
                % end



                %% add everything to overview
                
                overview.participant(indexO) = currentPart;
                overview.session(indexO) = indexSess;
                overview.et(indexO) = indexET;

                overview.num_fix_startIndex(indexO) = length(fixation_start_indices);
                overview.num_fix_endIndex(indexO) = length(fixation_end_indices);
                overview.num_saccade_startIndex(indexO) = length(saccade_start_indices);
                overview.num_saccade_endIndex(indexO) = length(saccade_end_indices);

                overview.rows_fixations(indexO) = height(fixation_rows);
                overview.rows_fixations_p(indexO) = height(fixation_rows)/height(data);
                overview.rows_fixations_goodD(indexO) = sum(fixation_rows)/height(data);

                overview.rows_saccades(indexO) = height(saccade_rows);
                overview.rows_saccades_p(indexO) = height(saccade_rows)/height(data);
                overview.rows_saccades_goodD(indexO) = sum(saccade_rows)/height(data);

                overview.sum_missingData_fix(indexO) = sum(missingData_fix);
                overview.sum_missingData_sacc(indexO) = sum(missingData_sacc);
                overview.sum_missingData_sacc_p(indexO) = sum(missingData_sacc)/height(data);



                % overview.exact_saccade_match(indexO) = exact_saccade_match;
                % overview.partial_saccade_match(indexO) = partial_saccade_match;
                % overview.sacc_fix_mix(indexO) = sacc_fix_mix;


            end
        end
    end
    toc
end

save([savepath 'overview_analysis_events_missingData'], 'overview');
