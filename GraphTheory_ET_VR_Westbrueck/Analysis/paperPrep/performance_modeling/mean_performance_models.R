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
savepath <- "F:\\WestbrookProject\\Spa_Re\\control_group\\Analysis\\P2B_controls_analysis\\"
setwd(savepath)

################################################################################

# load the data

# other data frames

dataFRS <- read.csv("F:/WestbrookProject/Spa_Re/control_group/Analysis/P2B_controls_analysis/overview_FRS_Data.csv")

dataGraphMeasures <- read.csv("F:/WestbrookProject/Spa_Re/control_group/Analysis/P2B_controls_analysis/performance_graph_properties_analysis/overviewGraphMeasures.csv")

dataGraphMFRS <- cbind(dataGraphMeasures, dataFRS[, c(2,5,8)])
dataGraphMFRS$Participants <- as.factor(dataGraphMFRS$Participants)

# full data frame
dataP2B <- read.csv("F:/WestbrookProject/Spa_Re/control_group/Analysis/P2B_controls_analysis/overviewTable_P2B_Prep_complete.csv")
dataP2B$SubjectID <- as.factor(dataP2B$SubjectID)

################ modeling #####################

# only subject id

# participant ID in lm

model_lm_participantID <- lm(RecalculatedAngle ~ as.factor(SubjectID), data = dataP2B)

summary(model_lm_participantID)


model_rd_participantID <- lmer(RecalculatedAngle ~ (1|SubjectID), data = dataP2B)


summary(model_rd_participantID)

r2_nakagawa(model_rd_participantID)



#######################################
# frs data

modelFRS <- lm(meanPerformance ~ Mean_egocentric_global + Mean_survey +
                 Mean_cardinal  ,data = dataGraphMFRS)
summary(modelFRS)

# individual regressions

modelFRS2 <- lm(meanPerformance ~ Mean_egocentric_global ,data = dataGraphMFRS)
summary(modelFRS2)


modelFRS3 <- lm(meanPerformance ~ Mean_survey ,data = dataGraphMFRS)
summary(modelFRS3)


modelFRS4 <- lm(meanPerformance ~ Mean_cardinal,data = dataGraphMFRS)
summary(modelFRS4)


#########################################
# general graph properties

modelGraphM_full <- lm(meanPerformance ~ nrViewedHouses + nrEdges + density + diameter +
                       hierarchyIndex,data = dataGraphMFRS)
summary(modelGraphM_full)

# -----------------
# residual plots

hist(resid(modelGraphM_full))

# check for normality of residuals
ggplot(data.frame(residuals = residuals(modelGraphM_full), fitted = fitted(modelGraphM_full)), aes(x = fitted, y = residuals)) +
  geom_point() +
  geom_smooth() +
  ggtitle("Residuals vs Fitted") +
  xlab("Fitted Values") +
  ylab("Residuals")

# check for outliers
qqnorm(resid(modelGraphM_full))
qqline(resid(modelGraphM_full))

# create scale-location plot of residuals
plot(fitted(modelGraphM_full), sqrt(abs(resid(modelGraphM_full))))

# create Cook's distance plot
plot(cooks.distance(modelGraphM_full))


# check for homoscedasticity
ggplot(data.frame(residuals = residuals(modelGraphM_full), fitted = fitted(modelGraphM_full)), aes(x = fitted, y = residuals)) +
  geom_point() +
  ggtitle("Residuals vs Fitted") +
  xlab("Fitted Values") +
  ylab("Residuals") +
  scale_y_continuous(limits = c(-3, 3)) +
  geom_hline(yintercept = 0, color = "red") +
  geom_smooth(se = FALSE)

# check for linearity
ggplot(data.frame(y = dataGraphMFRS$meanPerformance, fitted = fitted(modelGraphM_full)), aes(x = fitted, y = y)) +
  geom_point() +
  geom_smooth() +
  ggtitle("Actual vs Fitted") +
  xlab("Fitted Values") +
  ylab("Actual Values")

# check for independence
acf(residuals(modelGraphM_full))



###------------------------------------

# simple models

modelNo <- lm(meanPerformance ~ nrViewedHouses, data = dataGraphMFRS)
summary(modelNo)


modelE <- lm(meanPerformance ~ nrEdges, data = dataGraphMFRS)
summary(modelE)

modelDe <- lm(meanPerformance ~ density,data = dataGraphMFRS)
summary(modelDe)

modelDi <- lm(meanPerformance ~ diameter, data = dataGraphMFRS)
summary(modelDi)




modelH <- lm(meanPerformance ~ hierarchyIndex, data = dataGraphMFRS)
summary(modelH)


#####---------------------------------------------
# uniquely explaiend variances.... remove fixed effects 1 by 1
fullR2 <- summary(modelGraphM_full)[["r.squared"]]

# remove viewed buildings/nodes
modelGGraph2 <- lm(meanPerformance ~ nrEdges + density + 
                     diameter + hierarchyIndex ,data = dataGraphMFRS)
summary(modelGGraph2)

fullR2 - summary(modelGGraph2)[["r.squared"]]

# remove edges
modelGGraph3 <- lm(meanPerformance ~ nrViewedHouses + density + 
                     diameter + hierarchyIndex ,data = dataGraphMFRS)
summary(modelGGraph3)

fullR2 - summary(modelGGraph3)[["r.squared"]]

# remove density

modelGGraph4 <- lm(meanPerformance ~ nrViewedHouses + nrEdges + 
                     diameter + hierarchyIndex ,data = dataGraphMFRS)
summary(modelGGraph4)

fullR2 - summary(modelGGraph4)[["r.squared"]]


# remove diameter
modelGGraph5 <- lm(meanPerformance ~ nrViewedHouses + nrEdges + density + 
                     hierarchyIndex ,data = dataGraphMFRS)
summary(modelGGraph5)

fullR2 - summary(modelGGraph5)[["r.squared"]]


# remove hierarchy index
modelGGraph6 <- lm(meanPerformance ~ nrViewedHouses + nrEdges + density + diameter,data = dataGraphMFRS)
summary(modelGGraph6)

fullR2 - summary(modelGGraph6)[["r.squared"]]



################################################
# landmark models


modelGGraph_landmarks <- lm(meanPerformance ~ nrIndividualLandmarks+nrCommonLandmarks , data = dataGraphMFRS)

summary(modelGGraph_landmarks)

modelGGraph_landmarks2 <- lm(meanPerformance ~ nrAllLandmarks+nrCommonLandmarks, data = dataGraphMFRS)

summary(modelGGraph_landmarks2)

modelGGraph_landmarks3 <- lm(meanPerformance ~ nrAllLandmarks+nrIndividualLandmarks , data = dataGraphMFRS)

summary(modelGGraph_landmarks3)

####
# Create the plot using ggplot2 with Parula colormap


########## individual regressions

fullR2_L <- summary(modelGGraph_landmarks2)[["r.squared"]]

modelGGraph_landmarksI <- lm(meanPerformance ~ nrIndividualLandmarks, data = dataGraphMFRS)

summary(modelGGraph_landmarksI)

fullR2_L - summary(modelGGraph_landmarksI)[["r.squared"]]

modelGGraph_landmarksC <- lm(meanPerformance ~ nrCommonLandmarks, data = dataGraphMFRS)

summary(modelGGraph_landmarksC)

fullR2_L - summary(modelGGraph_landmarksC)[["r.squared"]]

modelGGraph_landmarksA <- lm(meanPerformance ~ nrAllLandmarks, data = dataGraphMFRS)

summary(modelGGraph_landmarksA)

fullR2_L - summary(modelGGraph_landmarksA)[["r.squared"]]


















