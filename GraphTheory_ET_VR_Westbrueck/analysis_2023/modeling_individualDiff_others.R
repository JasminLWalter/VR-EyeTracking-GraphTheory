rm(list = ls())

# load the necessary packages
library(Matrix)
library(lme4)
library(ggplot2)
library(glmmTMB)
library(glmmLasso)
library(MuMIn)
library(cAIC4)
library(rsq)
library(performance)
library(lubridate)
library(car)


# savepath <- "E:\\WestbrookProject\\SpaRe_Data\\control_data\\Analysis\\P2B_controls_analysis\\"
savepath <- "F:\\WestbrookProject\\Spa_Re\\control_group\\analysis_velocityBased_2023\\P2B_analysis\\data_overviews\\"
setwd(savepath)

################################################################################

# load the data

# full data frame
dataP2B <- read.csv("F:\\WestbrookProject\\Spa_Re\\control_group\\analysis_velocityBased_2023\\P2B_analysis\\data_overviews\\overviewTable_P2B_Prep_complete.csv")
dataP2B$SubjectID <- as.factor(dataP2B$SubjectID)
dataP2B$StartBuildingName <- as.factor(dataP2B$StartBuildingName)
dataP2B$TargetBuildingName <- as.factor(dataP2B$TargetBuildingName)
dataP2B$RouteID <- as.factor(dataP2B$RouteID)

# data without repetitions and mean for angle, trial duration and distance participant to target building

dataP2B_withoutReps <- read.csv("F:\\WestbrookProject\\Spa_Re\\control_group\\analysis_velocityBased_2023\\P2B_analysis\\data_overviews\\overviewTable_P2B_Prep_complete_withoutReps.csv")
dataP2B_withoutReps$SubjectID <- as.factor(dataP2B_withoutReps$SubjectID)
dataP2B_withoutReps$StartBuildingName <- as.factor(dataP2B_withoutReps$StartBuildingName)
dataP2B_withoutReps$TargetBuildingName <- as.factor(dataP2B_withoutReps$TargetBuildingName)
dataP2B_withoutReps$RouteID <- as.factor(dataP2B_withoutReps$RouteID)

# other data frames

dataFRS <- read.csv("F:\\WestbrookProject\\Spa_Re\\control_group\\analysis_velocityBased_2023\\P2B_analysis\\data_overviews\\overview_FRS_Data.csv")

# dataPerformance <- read.csv("F:/WestbrookProject/Spa_Re/control_group/Analysis/P2B_controls_analysis/performance_graph_properties_analysis/overviewPerformance.csv")

dataGraphMeasures <- read.csv("F:\\WestbrookProject\\Spa_Re\\control_group\\analysis_velocityBased_2023\\P2B_analysis\\data_overviews\\overviewGraphGazeMeasures.csv")

dataGraphMFRS <- cbind(dataGraphMeasures, dataFRS[, c(2,5,8)])
dataGraphMFRS$Participants <- as.factor(dataGraphMFRS$Participants)

#dataGraphMeasures2 <- read.csv("F:/WestbrookProject/Spa_Re/control_group/analysis_durationBased_2023/overviewGraphMeasures.csv")
#dataGraphM2 <- cbind(dataPerformance[, c(1,2)], dataGraphMeasures2[, c(2,3,4,5,6,7,8,9,10,11)])

dataGraphMeasures_longF <- read.csv("F:/WestbrookProject/Spa_Re/control_group/Analysis/P2B_controls_analysis/performance_graph_properties_analysis/graphPropertiesPlots/overviewGraphMeasures_longFormat.csv")
#dataGraphMFRS$Participants <- as.factor(dataGraphMFRS$Participants)


#dataPGM_long <- cbind(dataP2B[, c(5,20)], dataGraphMeasures_longF[, c(1,2,3,4,5)])


#dataP2B_GM <- cbind(dataP2B, dataGraphMeasures_longF[, c(2,3,4,5)])


################################################################################

# modeling
#################################################################################
################################################################################

#### st combinations

model_ln_stCombi_112 <- lm(RecalculatedAngle ~ 
                             NodeDegreeStartBuilding + NodeDegreeTargetBuilding + 
                             NodeDegreeWeightedStartBuilding + NodeDegreeWeightedTargetBuilding + 
                             StartBuildingDwellingTime + TargetBuildingDwellingTime + 
                             MaxFlowS + MaxFlowWeighted + ShortestPathDistance + 
                             AlternatingIndex + DistancePart2TargetBuilding,
                           data = dataP2B)

summary(model_ln_stCombi_112)

model_ln_stCombi_112_2 <- lm(RecalculatedAngle ~ 
                             NodeDegreeStartBuilding + NodeDegreeTargetBuilding + 
                             NodeDegreeWeightedStartBuilding + NodeDegreeWeightedTargetBuilding + 
                             ClosenessStartBuilding + ClosenessTargetBuilding+
                             BetweennessStartBuilding + BetweennessTargetBuilding +
                             PagerankStartBuilding + PagerankTargetBuilding+
                             EigenvectorStartBuilding + EigenvectorTargetBuilding+
                             StartBuildingDwellingTime + TargetBuildingDwellingTime + 
                             MaxFlowS + MaxFlowWeighted + ShortestPathDistance + 
                             AlternatingIndex + DistancePart2TargetBuilding,
                           data = dataP2B)

summary(model_ln_stCombi_112_2)



model_ln_stCombi_56 <- lm(RecalculatedAngle ~ 
                            NodeDegreeStartBuilding + NodeDegreeTargetBuilding + 
                            NodeDegreeWeightedStartBuilding + NodeDegreeWeightedTargetBuilding + 
                            StartBuildingDwellingTime + TargetBuildingDwellingTime + 
                            MaxFlowS + MaxFlowWeighted + ShortestPathDistance + 
                            AlternatingIndex + DistancePart2TargetBuilding,
                          data = dataP2B_withoutReps)

summary(model_ln_stCombi_56)

AIC(model_ln_stCombi_112)
AIC(model_ln_stCombi_56)

BIC(model_ln_stCombi_112)
BIC(model_ln_stCombi_56)

model_rd_stCombi_112 <- lmer(RecalculatedAngle ~ 
                               NodeDegreeStartBuilding + NodeDegreeTargetBuilding + 
                               NodeDegreeWeightedStartBuilding + NodeDegreeWeightedTargetBuilding + 
                               StartBuildingDwellingTime + TargetBuildingDwellingTime + 
                               MaxFlowS + MaxFlowWeighted + ShortestPathDistance + 
                               AlternatingIndex + DistancePart2TargetBuilding + (1|SubjectID),
                             data = dataP2B)

summary(model_rd_stCombi_112)
r2_nakagawa(model_rd_stCombi_112)

AIC(model_rd_stCombi_112)
BIC(model_rd_stCombi_112)

model_ln_stCombi_112_diameter = lm(RecalculatedAngle ~ 
                                     NodeDegreeStartBuilding + NodeDegreeTargetBuilding + 
                                     NodeDegreeWeightedStartBuilding + NodeDegreeWeightedTargetBuilding + 
                                     StartBuildingDwellingTime + TargetBuildingDwellingTime + 
                                     MaxFlowS + MaxFlowWeighted + ShortestPathDistance + 
                                     AlternatingIndex + DistancePart2TargetBuilding + diameter,
                                   data = dataP2B_GM)

summary(model_ln_stCombi_112_diameter)

AIC(model_ln_stCombi_112_diameter)
BIC(model_ln_stCombi_112_diameter)

# get the predictions of the model with the fixed effects 26x56 data rows

# Select relevant columns for prediction
selected_cols_full <- dataP2B_withoutReps[, c("NodeDegreeStartBuilding", "NodeDegreeTargetBuilding",
                                              "NodeDegreeWeightedStartBuilding", "NodeDegreeWeightedTargetBuilding",
                                              "StartBuildingDwellingTime", "TargetBuildingDwellingTime",
                                              "MaxFlowS", "MaxFlowWeighted", "ShortestPathDistance",
                                              "AlternatingIndex", "DistancePart2TargetBuilding")]

# Generate predictions using the linear model and selected columns
predictions_full_112 <- predict(model_ln_stCombi_112, newdata = selected_cols_full)


dataP2B_withoutReps$Predictions_full_112 <- predictions_full_112

# Generate predictions using the linear model and selected columns
predictions_full_56 <- predict(model_ln_stCombi_56, newdata = selected_cols_full)


dataP2B_withoutReps$Predictions_full_56 <- predictions_full_56


## now with random effects

model_rd_stCombi <- lmer(RecalculatedAngle ~ 
                           NodeDegreeStartBuilding + NodeDegreeTargetBuilding + 
                           NodeDegreeWeightedStartBuilding + NodeDegreeWeightedTargetBuilding + 
                           StartBuildingDwellingTime + TargetBuildingDwellingTime + 
                           MaxFlowS + MaxFlowWeighted + ShortestPathDistance + 
                           AlternatingIndex + DistancePart2TargetBuilding + diameter+
                           (1|SubjectID) + (1|RouteID),
                         data = dataP2B_GM)

summary(model_rd_stCombi)

r2_nakagawa(model_rd_stCombi)



## with removed non sig fixed effects _Model 2

model_ln_stCombi_M2 <- lm(RecalculatedAngle ~ 
                            NodeDegreeStartBuilding + NodeDegreeTargetBuilding + 
                            NodeDegreeWeightedStartBuilding +  
                            StartBuildingDwellingTime + TargetBuildingDwellingTime + 
                            ShortestPathDistance + 
                            AlternatingIndex + DistancePart2TargetBuilding,
                          data = dataP2B)

summary(model_ln_stCombi_M2)


# get the predictions of the model with the fixed effects 26x56 data rows

# Select relevant columns for prediction
selected_cols_2 <- dataP2B_withoutReps[, c("NodeDegreeStartBuilding", "NodeDegreeTargetBuilding",
                                           "NodeDegreeWeightedStartBuilding", 
                                           "StartBuildingDwellingTime", "TargetBuildingDwellingTime",
                                           "ShortestPathDistance",
                                           "AlternatingIndex", "DistancePart2TargetBuilding")]

# Generate predictions using the linear model and selected columns
predictions_M2 <- predict(model_ln_stCombi_M2, newdata = selected_cols_2)

# Print the predicted values
# print(predictions)

dataP2B_withoutReps$Predictions_M2 <- predictions_M2


###### remove again non-sig effect - Model 3

model_ln_stCombi_M3 <- lm(RecalculatedAngle ~ 
                            NodeDegreeStartBuilding + NodeDegreeTargetBuilding + 
                            NodeDegreeWeightedStartBuilding +  
                            StartBuildingDwellingTime + TargetBuildingDwellingTime + 
                            ShortestPathDistance + 
                            AlternatingIndex,
                          data = dataP2B)

summary(model_ln_stCombi_M3)


# get the predictions of the model with the fixed effects 26x56 data rows

# Select relevant columns for prediction
selected_cols_3 <- dataP2B_withoutReps[, c("NodeDegreeStartBuilding", "NodeDegreeTargetBuilding",
                                           "NodeDegreeWeightedStartBuilding", 
                                           "StartBuildingDwellingTime", "TargetBuildingDwellingTime",
                                           "ShortestPathDistance",
                                           "AlternatingIndex")]

# Generate predictions using the linear model and selected columns
predictions_M3 <- predict(model_ln_stCombi_M3, newdata = selected_cols_3)

# Print the predicted values
# print(predictions)

dataP2B_withoutReps$Predictions_M3 <- predictions_M3


###### remove again non-sig effect - Model 4

model_ln_stCombi_M4 <- lm(RecalculatedAngle ~ 
                            NodeDegreeStartBuilding + NodeDegreeTargetBuilding + 
                            NodeDegreeWeightedStartBuilding +  
                            TargetBuildingDwellingTime + 
                            ShortestPathDistance + 
                            AlternatingIndex,
                          data = dataP2B)

summary(model_ln_stCombi_M4)


# get the predictions of the model with the fixed effects 26x56 data rows

# Select relevant columns for prediction
selected_cols_4 <- dataP2B_withoutReps[, c("NodeDegreeStartBuilding", "NodeDegreeTargetBuilding",
                                           "NodeDegreeWeightedStartBuilding", 
                                           "TargetBuildingDwellingTime",
                                           "ShortestPathDistance",
                                           "AlternatingIndex")]

# Generate predictions using the linear model and selected columns
predictions_M4 <- predict(model_ln_stCombi_M4, newdata = selected_cols_4)

# Print the predicted values
# print(predictions)

dataP2B_withoutReps$Predictions_M4 <- predictions_M4

## save csv file

write.csv(dataP2B_withoutReps, paste(savepath,"dataP2B_withoutReps_predictions.csv"), row.names = FALSE)

## check the model with st-combi means only

dataP2B_stCombi_means <- read.csv("E:/Westbrueck Data/SpaRe_Data/1_Exploration/Analysis/P2B_controls_analysis/dataP2B_stCombi_means.csv")

model_ln_stCombi_Means <- lm(AngularError ~ 
                               NodeDegreeStartBuilding + NodeDegreeTargetBuilding + 
                               NodeDegreeWeightedStartBuilding + NodeDegreeWeightedTargetBuilding + 
                               StartBuildingDwellingTime + TargetBuildingDwellingTime + 
                               MaxFlowS + MaxFlowWeighted + ShortestPathDistance + 
                               AlternatingIndex + DistancePart2TargetBuilding,
                             data = dataP2B_stCombi_means)

summary(model_ln_stCombi_Means)


##### check how much the s-t- combi can explain as a factor

model_ln_factor_stCombi <- lm(RecalculatedAngle ~ as.factor(RouteID),
                              data = dataP2B_GM)
summary(model_ln_factor_stCombi)

model_rd_factor_stCombi <- lmer(RecalculatedAngle ~ (1|RouteID),
                                data = dataP2B_GM)
summary(model_rd_factor_stCombi)

r2_nakagawa(model_rd_factor_stCombi)

################################################################################
##############################################################################

## try out trial order
model_rd_trialOrder <- lmer(RecalculatedAngle ~ (1|TrialOrder), 
                            data = dataP2B)

summary(model_rd_trialOrder)
r2_nakagawa(model_rd_trialOrder) # Conditional R2: 0.006

# linear
model_ln_trialOrder <- lm(RecalculatedAngle ~ as.factor(TrialOrder), 
                          data = dataP2B)

summary(model_ln_trialOrder) # 0.003204




# random effects model

# participant ID and route ID, Start Building, Target building
model_rd_ST <- lmer(RecalculatedAngle ~  (1|RouteID), 
                      data = dataP2B)

summary(model_rd_ST)

r2_nakagawa(model_rd_ST)

model_rd_PRST <- lmer(RecalculatedAngle ~ (1|SubjectID) + (1|RouteID), 
                      data = dataP2B)

summary(model_rd_PRST)

r2_nakagawa(model_rd_PRST) # 0.202


# as factors
model_ln_factor_p_stCombi <- lm(RecalculatedAngle ~ as.factor(SubjectID) + as.factor(RouteID),
                                data = dataP2B_GM)

summary(model_ln_factor_p_stCombi) #Multiple R-squared:  0.2201,	Adjusted R-squared:  0.1981

# as linear model

model_lm_PRST <- lm(RecalculatedAngle ~ as.factor(SubjectID) + as.factor(RouteID) + 
                      as.factor(StartBuildingName) + as.factor(TargetBuildingName), 
                    data = dataP2B)

summary(model_lm_PRST) # 0.2201

###################
############
#testi
model_test<- lmer(RecalculatedAngle ~ (1|SubjectID) + (1|RouteID), data = dataP2B)

summary(model_test)

r2_nakagawa(model_test)


################################################################################
################################################################################

# only subject id

# participant ID

model_rd_participantID <- lmer(RecalculatedAngle ~ (1|SubjectID), data = dataP2B)


summary(model_rd_participantID)

r2_nakagawa(model_rd_participantID)

# participant ID in lm

model_lm_participantID <- lm(RecalculatedAngle ~ as.factor(SubjectID), data = dataP2B)

summary(model_lm_participantID)


# s-t combi

model_lm_stcombi <- lm(RecalculatedAngle ~ as.factor(RouteID), data = dataP2B)

summary(model_lm_stcombi)


# s-t combi & participant

# s-t combi

model_lm_part_stcombi <- lm(RecalculatedAngle ~ as.factor(SubjectID) + as.factor(RouteID), data = dataP2B)

summary(model_lm_part_stcombi)



# linear model with graph measures - only participants differences

## add average shortest path here!

# general graph properties and FRS
modelGraphFRS <- lm(meanPerformance ~ nrViewedHouses + density + diameter + avgShortestPath +
                      hierarchyIndex ,data = dataGraphM2)
summary(modelGraphFRS)

# general graph properties and FRS + edges!!!!
modelGraphFRS2 <- lm(meanPerformance ~ nrViewedHouses + nrEdges + density + diameter +
                       hierarchyIndex + Mean_egocentric_global + Mean_survey +
                       Mean_cardinal  ,data = dataGraphMFRS)
summary(modelGraphFRS2)

# residual plots

hist(resid(modelGraphFRS))

# check for normality of residuals
ggplot(data.frame(residuals = residuals(modelGraphFRS), fitted = fitted(modelGraphFRS)), aes(x = fitted, y = residuals)) +
  geom_point() +
  geom_smooth() +
  ggtitle("Residuals vs Fitted") +
  xlab("Fitted Values") +
  ylab("Residuals")

# check for outliers
qqnorm(resid(modelGraphFRS))
qqline(resid(modelGraphFRS))

# create scale-location plot of residuals
plot(fitted(modelGraphFRS), sqrt(abs(resid(modelGraphFRS))))

# create Cook's distance plot
plot(cooks.distance(modelGraphFRS))


# check for homoscedasticity
ggplot(data.frame(residuals = residuals(modelGraphFRS), fitted = fitted(modelGraphFRS)), aes(x = fitted, y = residuals)) +
  geom_point() +
  ggtitle("Residuals vs Fitted") +
  xlab("Fitted Values") +
  ylab("Residuals") +
  scale_y_continuous(limits = c(-3, 3)) +
  geom_hline(yintercept = 0, color = "red") +
  geom_smooth(se = FALSE)

# check for linearity
ggplot(data.frame(y = dataGraphMFRS$meanPerformance, fitted = fitted(modelGraphFRS)), aes(x = fitted, y = y)) +
  geom_point() +
  geom_smooth() +
  ggtitle("Actual vs Fitted") +
  xlab("Fitted Values") +
  ylab("Actual Values")

# check for independence
acf(residuals(modelGraphFRS))



#################################################

# landmark measures & global graph measure model

# only landmark stuff

modelGGraph_landmarks <- lm(meanPerformance ~ nrIndividualLandmarks*nrCommonLandmarks , data = dataGraphMFRS)

summary(modelGGraph_landmarks)

# add dwelling time

modelGGraph_landmarks2 <- lm(meanPerformance ~ nrAllLandmarks + nrIndividualLandmarks, data = dataGraphMFRS)

summary(modelGGraph_landmarks2)


# testi diameter and nr common landmarks
modelGGraph_landmarks3 <- lm(meanPerformance ~ nrCommonLandmarks, data = dataGraphMFRS)


summary(modelGGraph_landmarks3)

testi <- lm(meanPerformance ~ diameter, data = dataGraphMFRS)
summary(testi)

###
# testi with new preprocessing of graphs

modelTesti <- lm(meanPerformance ~ 
                   density + hierarchyIndex,data = dataGraphMFRS)

summary(modelTesti)

plot(modelTesti, which = 1, main = "Model Fit")

vif_values <- vif(modelTesti)
vif_values

barplot(vif_values, col = "skyblue", main = "Variance Inflation Factor (VIF")

modelTesti2 <- lm(meanPerformance ~ diameter,data = dataGraphMFRS)
summary(modelTesti2)

testi3 <- lm(meanPerformance ~ diameter,data = dataGraphM2)

summary(testi3)

################ 

# all global graph measures + landmark stats

modelVH <- lm(meanPerformance ~ nrViewedHouses,data = dataGraphMFRS)
summary(modelVH)

modelE <- lm(meanPerformance ~ nrEdges,data = dataGraphMFRS)
summary(modelE)

modelDe <- lm(meanPerformance ~ density,data = dataGraphMFRS)
summary(modelDe)

modelDi <- lm(meanPerformance ~ diameter, data = dataGraphMFRS)
summary(modelDi)

modelH <- lm(meanPerformance ~ hierarchyIndex, data = dataGraphMFRS)
summary(modelH)

modelSP <- lm(meanPerformance ~ avgShortestPath, data = dataGraphMFRS)
summary(modelSP)

modelnd <- lm(meanPerformance ~ nodeDegree_mean, data = dataGraphMFRS)
summary(modelnd)

modelcl <- lm(meanPerformance ~ closeness_mean, data = dataGraphMFRS)
summary(modelcl)

modelpG <- lm(meanPerformance ~ perDiffObGazes, data = dataGraphMFRS)
summary(modelpG)


testi<- lm(eyeDirectionCombinedLocal_changes_std ~ hmdDirectionForward_changes_std, data = dataGraphMFRS)
summary(testi)


testi2 <- lm(meanPerformance ~ density + nodeDegree_mean + perDiffObGazes +eyeDirectionCombinedWorld_changes_std, data = dataGraphMFRS)
summary(testi2)

modelstd <- lm(meanPerformance ~ stdPerformance, data = dataGraphMFRS)
summary(modelstd)

########################
# only general graph based measures
modelGGraphAll <- lm(meanPerformance ~ nrViewedHouses + nrEdges + density + 
                       diameter + hierarchyIndex +
                       nrAllLandmarks + nrCommonLandmarks,data = dataGraphMFRS)
summary(modelGGraphAll)

# only general graph based measures
modelGGraph2 <- lm(meanPerformance ~ nrViewedHouses + nrEdges + density + 
                     diameter + hierarchyIndex ,data = dataGraphMFRS)
summary(modelGGraph2)

# uniquely explaiend variances.... remove fixed effects 1 by 1

modelGGraph3 <- lm(meanPerformance ~ nrEdges + density + 
                     diameter + hierarchyIndex ,data = dataGraphMFRS)
summary(modelGGraph3)

modelGGraph4 <- lm(meanPerformance ~ nrViewedHouses + density + 
                     diameter + hierarchyIndex ,data = dataGraphMFRS)
summary(modelGGraph4)

modelGGraph5 <- lm(meanPerformance ~ nrViewedHouses + nrEdges + 
                     diameter + hierarchyIndex ,data = dataGraphMFRS)
summary(modelGGraph5)

modelGGraph6 <- lm(meanPerformance ~ nrViewedHouses + nrEdges + density + 
                     hierarchyIndex ,data = dataGraphMFRS)
summary(modelGGraph6)

modelGGraph7 <- lm(meanPerformance ~ nrViewedHouses + nrEdges + density + diameter,data = dataGraphMFRS)
summary(modelGGraph7)


#########-------------------------------------------
modelGGraph_Nodiameter <- lm(meanPerformance ~ nrViewedHouses + nrEdges + density + 
                               hierarchyIndex ,data = dataGraphMFRS)

summary(modelGGraph_Nodiameter)

# only FRS measures
modelFRS <- lm(meanPerformance ~ Mean_egocentric_global + Mean_survey +
                 Mean_cardinal  ,data = dataGraphMFRS)
summary(modelFRS)

modelFRS2 <- lm(meanPerformance ~ Mean_survey +
                  Mean_cardinal  ,data = dataGraphMFRS)
summary(modelFRS2)

modelFRS3 <- lm(meanPerformance ~ Mean_egocentric_global + 
                  Mean_cardinal  ,data = dataGraphMFRS)
summary(modelFRS3)


modelFRS4 <- lm(meanPerformance ~ Mean_egocentric_global + Mean_survey,data = dataGraphMFRS)
summary(modelFRS4)

#############################################################

# only diameter 
modelDiameter <- lm(meanPerformance ~ diameter ,data = dataGraphMFRS)

summary(modelDiameter)

model_test <- lm(meanPerformance ~ 1,data = dataGraphMFRS)

summary(model_test)
model_test.rsq


# residual plots

hist(resid(modelDiameter))

# check for normality of residuals ????????????????
ggplot(data.frame(residuals = residuals(modelDiameter), fitted = fitted(modelDiameter)), aes(x = fitted, y = residuals)) +
  geom_point() +
  geom_smooth() +
  ggtitle("Residuals vs Fitted") +
  xlab("Fitted Values") +
  ylab("Residuals")

# check for outliers
qqnorm(resid(modelDiameter))
qqline(resid(modelDiameter))

# create scale-location plot of residuals
plot(fitted(modelDiameter), sqrt(abs(resid(modelDiameter))))

# create Cook's distance plot
plot(cooks.distance(modelDiameter))


# check for homoscedasticity
ggplot(data.frame(residuals = residuals(modelDiameter), fitted = fitted(modelDiameter)), aes(x = fitted, y = residuals)) +
  geom_point() +
  ggtitle("Residuals vs Fitted") +
  xlab("Fitted Values") +
  ylab("Residuals") +
  scale_y_continuous(limits = c(-3, 3)) +
  geom_hline(yintercept = 0, color = "red") +
  geom_smooth(se = FALSE)

# check for linearity
ggplot(data.frame(y = dataGraphMFRS$meanPerformance, fitted = fitted(modelDiameter)), aes(x = fitted, y = y)) +
  geom_point() +
  geom_smooth() +
  ggtitle("Actual vs Fitted") +
  xlab("Fitted Values") +
  ylab("Actual Values")

# check for independence
acf(residuals(modelDiameter))





#################################################################################
#################################################################################
# all parameters in one

model_ALL <- lmer(RecalculatedAngle ~ 
                    NodeDegreeStartBuilding + NodeDegreeTargetBuilding + 
                    NodeDegreeWeightedStartBuilding + NodeDegreeWeightedTargetBuilding + 
                    StartBuildingDwellingTime + TargetBuildingDwellingTime +
                    MaxFlowS + MaxFlowWeighted + 
                    ShortestPathDistance + AlternatingIndex + DistancePart2TargetBuilding +  
                    nrViewedHouses + nrEdges + density + diameter +
                    Mean_egocentric_global + Mean_survey + Mean_cardinal +
                    (1|SubjectID) + (1|RouteID) + (1|StartBuildingName) + (1|TargetBuildingName),
                  data = dataP2B_GM)

summary(model_ALL)
r2_nakagawa(model_ALL)


# participant ID and route ID

model_rd_participantRouteID <- lmer(RecalculatedAngle ~ (1|SubjectID) + (1|RouteID), 
                                    data = dataP2B)

summary(model_rd_participantRouteID )

r2_nakagawa(model_rd_participantRouteID)



# test diameter:

model_diameter_long <- lm(RecalculatedAngle ~ diameter, data = dataPGM_long)

summary(model_diameter_long )

r2_nakagawa(model_rd_participantID)

# test diameter and subject ID

model_lmm_diameter_participantID <- lmer(RecalculatedAngle ~ diameter + (1|Participants), data = dataPGM_long)

summary(model_lmm_diameter_participantID)

r2_nakagawa(model_lmm_diameter_participantID)

# subject id rn  and all subject related fixed effects

model_participantID_FRS_GGM <- lmer(RecalculatedAngle ~ 
                                      nrViewedHouses + nrEdges + density + diameter +
                                      (1|SubjectID), data = dataP2B_GM)

summary(model_participantID_FRS_GGM)

test <- r2_nakagawa(model_participantID_FRS_GGM)

print(test)



# trial/route id

model_rd_routeID <- lmer(RecalculatedAngle ~ (1|RouteID), data = dataP2B)

summary(model_rd_routeID)

r2_nakagawa(model_rd_routeID)

# start building id

model_rd_startB <- lmer(RecalculatedAngle ~ (1|StartBuildingName), data = dataP2B)

summary(model_rd_startB)

r2_nakagawa(model_rd_startB)

# target building id

model_rd_targetB <- lmer(RecalculatedAngle ~ (1|TargetBuildingName), data = dataP2B)

summary(model_rd_targetB)

r2_nakagawa(model_rd_targetB)


############################################################################################
#############################################################################################
#############################################################################################
# some playing around with different models


# only node measures for start buildings

modelNodes_startBuildings <- lm(RecalculatedAngle ~
                                  NodeDegreeStartBuilding +
                                  NodeDegreeWeightedStartBuilding +
                                  StartBuildingDwellingTime,data = dataP2B)

summary(modelNodes_startBuildings)

# only start building identity as random effect

model_startBuildings <- lmer(RecalculatedAngle ~ (1|StartBuildingName), data = dataP2B)

summary(model_startBuildings)

r2_nakagawa(model_startBuildings)

# combination of node measures and start building identity

model_test <- lmer(RecalculatedAngle ~
                     NodeDegreeStartBuilding +
                     NodeDegreeWeightedStartBuilding +
                     StartBuildingDwellingTime+
                     (1|StartBuildingName),data = dataP2B)

summary(model_test)
r2_nakagawa(model_test)

######################################

modelGraphMeasures<- lm(RecalculatedAngle ~ 
                          NodeDegreeStartBuilding + NodeDegreeTargetBuilding + 
                          NodeDegreeWeightedStartBuilding + NodeDegreeWeightedTargetBuilding + 
                          StartBuildingDwellingTime + TargetBuildingDwellingTime + 
                          MaxFlowS + MaxFlowWeighted + 
                          ShortestPathDistance + AlternatingIndex + 
                          DistancePart2TargetBuilding, data = dataP2B)

summary(modelGraphMeasures)


modelGraphMeasures2<- lm(RecalculatedAngle ~ 
                           NodeDegreeStartBuilding + NodeDegreeTargetBuilding + 
                           NodeDegreeWeightedStartBuilding + 
                           StartBuildingDwellingTime + TargetBuildingDwellingTime + 
                           ShortestPathDistance + AlternatingIndex + 
                           DistancePart2TargetBuilding, data = dataP2B)

summary(modelGraphMeasures2)


modelGraphMeasures3<- lm(RecalculatedAngle ~ 
                           NodeDegreeStartBuilding + NodeDegreeTargetBuilding + 
                           NodeDegreeWeightedStartBuilding + 
                           TargetBuildingDwellingTime + 
                           ShortestPathDistance + AlternatingIndex, data = dataP2B)

summary(modelGraphMeasures3)
