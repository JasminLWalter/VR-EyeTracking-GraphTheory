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


# savepath <- "E:\\WestbrookProject\\SpaRe_Data\\control_data\\Analysis\\P2B_controls_analysis\\"
savepath <- "F:\\WestbrookProject\\Spa_Re\\control_group\\Analysis\\P2B_controls_analysis\\"
setwd(savepath)

################################################################################

# load the data

# full data frame
dataP2B <- read.csv("F:/WestbrookProject/Spa_Re/control_group/Analysis/P2B_controls_analysis/overviewTable_P2B_Prep_complete.csv")
dataP2B$SubjectID <- as.factor(dataP2B$SubjectID)
dataP2B$StartBuildingName <- as.factor(dataP2B$StartBuildingName)
dataP2B$TargetBuildingName <- as.factor(dataP2B$TargetBuildingName)
#dataP2B$RouteID <- as.factor(dataP2B$RouteID)

###################
model_stcombis <- lm(RecalculatedAngle ~ 
                       NodeDegreeStartBuilding + NodeDegreeTargetBuilding + 
                       StartBuildingDwellingTime + TargetBuildingDwellingTime + 
                       MaxFlowS + ShortestPathDistance + 
                       AlternatingIndex + DistancePart2TargetBuilding,
                     data = dataP2B)

summary(model_stcombis)

plot(model_stcombis, wich = 1, main = "Model Fit")


model_stcombisI <- lm(AngularError ~ 
                        NodeDegreeStartBuilding ,
                      data = dataP2B_stcombis)

summary(model_stcombisI)

library(car)
vif_vals <- vif(model_stcombis)
barplot(vif_vals)
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
                             AlternatingIndex + DistancePart2TargetBuilding,data = dataP2B)

summary(model_ln_stCombi_112)

vif(model_ln_stCombi_112)

model_rd_stCombi <- lmer(RecalculatedAngle ~(1|RouteID), data=dataP2B)
summary(model_rd_stCombi)
r2_nakagawa(model_rd_stCombi)


# data without repetitions and mean for angle, trial duration and distance participant to target building

dataP2B_withoutReps <- read.csv("F:/WestbrookProject/Spa_Re/control_group/Analysis/P2B_controls_analysis/overviewTable_P2B_Prep_complete_withoutReps.csv")
dataP2B_withoutReps$SubjectID <- as.factor(dataP2B_withoutReps$SubjectID)
dataP2B_withoutReps$StartBuildingName <- as.factor(dataP2B_withoutReps$StartBuildingName)
dataP2B_withoutReps$TargetBuildingName <- as.factor(dataP2B_withoutReps$TargetBuildingName)
dataP2B_withoutReps$RouteID <- as.factor(dataP2B_withoutReps$RouteID)


model_ln_stCombi_56 <- lm(RecalculatedAngle ~ 
                              NodeDegreeStartBuilding + NodeDegreeTargetBuilding + 
                              NodeDegreeWeightedStartBuilding + NodeDegreeWeightedTargetBuilding + 
                              StartBuildingDwellingTime + TargetBuildingDwellingTime + 
                              MaxFlowS + MaxFlowWeighted + ShortestPathDistance + 
                              AlternatingIndex + DistancePart2TargetBuilding,
                            data = dataP2B_withoutReps)

summary(model_ln_stCombi_56)
r2_nakagawa(model_ln_stCombi_56)


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


write.csv(dataP2B_withoutReps, paste("F:/WestbrookProject/Spa_Re/control_group/Analysis/P2B_controls_analysis/dataP2B_withoutReps_predictions.csv"), row.names = FALSE)

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