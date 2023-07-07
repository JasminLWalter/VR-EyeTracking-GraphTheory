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


savepath <- "F:\\Westbrueck Data\\SpaRe_Data\\1_Exploration\\Analysis\\P2B_controls_analysis"

setwd(savepath)


dataP2B <- read.csv("F:/Westbrueck Data/SpaRe_Data/1_Exploration/Analysis/P2B_controls_analysis/overviewTable_P2B_Prep_complete.csv")
dataP2B$SubjectID <- as.factor(dataP2B$SubjectID)

dataP2B$lnRecalcAngle <- log(dataP2B$RecalculatedAngle)

testModel <- lmer(RecalculatedAngle ~ DistancePart2TargetBuilding + 
                        NodeDegreeStartBuilding + NodeDegreeTargetBuilding + 
                        NodeDegreeWeightedStartBuilding + NodeDegreeWeightedTargetBuilding + 
                        MaxFlowS + MaxFlowWeighted + 
                        ShortestPathDistance + AlternatingIndex + 
                        StartBuildingDwellingTime + TargetBuildingDwellingTime + 
                        Mean_egocentric_global + Mean_survey + Mean_cardinal +
                        (1|StartBuildingName) + (1|TargetBuildingName),
                      data = dataP2B)
summary(testModel)
BIC(testModel)
AIC(testModel)
rsq(testModel)


initial_model <- lmer(RecalculatedAngle ~ DistancePart2TargetBuilding + 
                    NodeDegreeStartBuilding + NodeDegreeTargetBuilding + 
                    NodeDegreeWeightedStartBuilding + NodeDegreeWeightedTargetBuilding + 
                    MaxFlowS + MaxFlowWeighted + 
                    ShortestPathDistance + AlternatingIndex + 
                    StartBuildingDwellingTime + TargetBuildingDwellingTime + 
                    Mean_egocentric_global + Mean_survey + Mean_cardinal +
                    (1|SubjectID) + (1|StartBuildingName) + (1|TargetBuildingName),
                  data = dataP2B)


test_model <- lm(RecalculatedAngle ~  SubjectID,
                      data = dataP2B)
summary(initial_model)

BIC(initial_model)

var_explained <- c(summary(initial_model)$varcor$SubjectID,
                   summary(initial_model)$varcor$StartBuildingName,
                   summary(initial_model)$varcor$TargetBuildingName,
                   summary(initial_model)$coefficients[,2])^2

min_var_explained <- which.min(var_explained)
####################

initial_modelLN <- lmer(lnRecalcAngle ~ DistancePart2TargetBuilding + 
                        NodeDegreeStartBuilding + NodeDegreeTargetBuilding + 
                        NodeDegreeWeightedStartBuilding + NodeDegreeWeightedTargetBuilding + 
                        MaxFlowS + MaxFlowWeighted + 
                        ShortestPathDistance + AlternatingIndex + 
                        StartBuildingDwellingTime + TargetBuildingDwellingTime + 
                        Mean_egocentric_global + Mean_survey + Mean_cardinal +
                        (1|SubjectID) + (1|StartBuildingName) + (1|TargetBuildingName),
                      data = dataP2B)

summary(initial_modelLN)

hist(resid(initial_modelLN))

# check for normality of residuals
ggplot(data.frame(residuals = residuals(initial_modelLN), fitted = fitted(initial_modelLN)), aes(x = fitted, y = residuals)) +
  geom_point() +
  geom_smooth() +
  ggtitle("Residuals vs Fitted") +
  xlab("Fitted Values") +
  ylab("Residuals")

# check for outliers
qqnorm(resid(initial_modelLN))
qqline(resid(initial_modelLN))

# create scale-location plot of residuals
plot(fitted(initial_modelLN), sqrt(abs(resid(initial_modelLN))))

# create Cook's distance plot
plot(cooks.distance(initial_modelLN))


# check for homoscedasticity
ggplot(data.frame(residuals = residuals(my_model2), fitted = fitted(my_model2)), aes(x = fitted, y = residuals)) +
  geom_point() +
  ggtitle("Residuals vs Fitted") +
  xlab("Fitted Values") +
  ylab("Residuals") +
  scale_y_continuous(limits = c(-3, 3)) +
  geom_hline(yintercept = 0, color = "red") +
  geom_smooth(se = FALSE)

# check for linearity
ggplot(data.frame(y = mydata$y, fitted = fitted(my_model)), aes(x = fitted, y = y)) +
  geom_point() +
  geom_smooth() +
  ggtitle("Actual vs Fitted") +
  xlab("Fitted Values") +
  ylab("Actual Values")

# check for independence
acf(residuals(my_model))




########################
#try a new stepwise selection process.
initialModelA<- initial_model
evaluate <- drop1(initialModelA,test="Chisq")

# 30073.05, remove MaxFlowS
modelA2 <-lmer(RecalculatedAngle ~ DistancePart2TargetBuilding + 
                 NodeDegreeStartBuilding + NodeDegreeTargetBuilding + 
                 NodeDegreeWeightedStartBuilding + NodeDegreeWeightedTargetBuilding + 
                 MaxFlowWeighted + 
                 ShortestPathDistance + AlternatingIndex + 
                 StartBuildingDwellingTime + TargetBuildingDwellingTime + 
                 Mean_egocentric_global + Mean_survey + Mean_cardinal +
                 (1|SubjectID) + (1|StartBuildingName) + (1|TargetBuildingName),
               data = dataP2B)
evaluate2 <- drop1(modelA2,test="Chisq")

# 30071.09, remove egocentric mean, 
# 30069.15, remove mean cardinal
# 30067.21, node degree weighted start building
#	30065.29 ,start building dwelling time
# 30063.78, target building dwelling time
# 30062.77, Distance Part 2 Target Building
# 30062.12, mean survey
# 30062.03, shortest path distance
modelA3 <-lmer(RecalculatedAngle ~ 
                 NodeDegreeStartBuilding + NodeDegreeTargetBuilding + 
                 NodeDegreeWeightedTargetBuilding + 
                 MaxFlowWeighted + 
                 AlternatingIndex + 
                 (1|SubjectID) + (1|StartBuildingName) + (1|TargetBuildingName),
               data = dataP2B)
evaluate3 <- drop1(modelA3, test="Chisq")



########
fm1 <- initial_model
## likelihood ratio tests
drop1(fm1,test="Chisq")
## use Kenward-Roger corrected F test, or parametric bootstrap,
## to test the significance of each dropped predictor
if (require(pbkrtest) && packageVersion("pbkrtest")>="0.3.8") {
  KRSumFun <- function(object, objectDrop, ...) {
    krnames <- c("ndf","ddf","Fstat","p.value","F.scaling")
    r <- if (missing(objectDrop)) {
      setNames(rep(NA,length(krnames)),krnames)
    } else {
      krtest <- KRmodcomp(object,objectDrop)
      unlist(krtest$stats[krnames])
    }
    attr(r,"method") <- c("Kenward-Roger via pbkrtest package")
    r
  }
  drop1(fm1, test="user", sumFun=KRSumFun)
  
  if(lme4:::testLevel() >= 3) { ## takes about 16 sec
    nsim <- 100
    PBSumFun <- function(object, objectDrop, ...) {
      pbnames <- c("stat","p.value")
      r <- if (missing(objectDrop)) {
        setNames(rep(NA,length(pbnames)),pbnames)
      } else {
        pbtest <- PBmodcomp(object,objectDrop,nsim=nsim)
        unlist(pbtest$test[2,pbnames])
      }
      attr(r,"method") <- c("Parametric bootstrap via pbkrtest package")
      r
    }
    system.time(drop1(fm1, test="user", sumFun=PBSumFun))
  }
}
## workaround for creating a formula in a separate environment
createFormula <- function(resp, fixed, rand) {  
  f <- reformulate(c(fixed,rand),response=resp)
  ## use the parent (createModel) environment, not the
  ## environment of this function (which does not contain 'data')
  environment(f) <- parent.frame()
  f
}
createModel <- function(data) {
  mf.final <- createFormula("RecalculatedAngle","DistancePart2TargetBuilding",                    NodeDegreeStartBuilding + NodeDegreeTargetBuilding + 
                    "NodeDegreeWeightedStartBuilding","NodeDegreeWeightedTargetBuilding", 
                    "MaxFlowS","MaxFlowWeighted", 
                    "ShortestPathDistance","AlternatingIndex", 
                    "StartBuildingDwellingTime","TargetBuildingDwellingTime", 
                    "Mean_egocentric_global","Mean_survey","Mean_cardinal",
                    "(1|SubjectID)","(1|StartBuildingName)","(1|TargetBuildingName)")
  lmer(mf.final, data=data)
}

drop1(createModel(data=dataP2B))

#################
stepAutoModelBack <- stepcAIC(initial_model,direction = "backward", trace = TRUE, data = dataP2B,numberOfSavedModels = 1)








stepAutoModelFor <- stepcAIC(initial_model,direction = "forward", trace = TRUE, data = dataP2B,numberOfSavedModels = 1)
groupCandidates=c("cask","batch","sample"),
direction="forward", data=Pastes,trace=TRUE)

######
model2 <- lmer(RecalculatedAngle ~ DistancePart2TargetBuilding + 
                        NodeDegreeStartBuilding + NodeDegreeTargetBuilding + 
                        NodeDegreeWeightedStartBuilding + NodeDegreeWeightedTargetBuilding + 
                        MaxFlowS + MaxFlowWeighted + 
                        ShortestPathDistance + AlternatingIndex + 
                        StartBuildingDwellingTime +  
                        Mean_egocentric_global + Mean_survey + Mean_cardinal +
                        (1|SubjectID) + (1|StartBuildingName) + (1|TargetBuildingName),
                      data = dataP2B)
summary(model2)

BIC(model2)

var_explained <- c(summary(model2)$varcor$SubjectID,
                   summary(model2)$varcor$StartBuildingName,
                   summary(model2)$varcor$TargetBuildingName,
                   summary(model2)$coefficients[,2])^2

min_var_explained <- which.min(var_explained)

print(min_var_explained)

########
model3 <- lmer(RecalculatedAngle ~ DistancePart2TargetBuilding + 
                 NodeDegreeStartBuilding + NodeDegreeTargetBuilding + 
                 NodeDegreeWeightedStartBuilding + NodeDegreeWeightedTargetBuilding + 
                 MaxFlowS + MaxFlowWeighted + 
                 ShortestPathDistance + AlternatingIndex + 
                 Mean_egocentric_global + Mean_survey + Mean_cardinal +
                 (1|SubjectID) + (1|StartBuildingName) + (1|TargetBuildingName),
               data = dataP2B)
summary(model3)

BIC(model3)

var_explained <- c(summary(model3)$varcor$SubjectID,
                   summary(model3)$varcor$StartBuildingName,
                   summary(model3)$varcor$TargetBuildingName,
                   summary(model3)$coefficients[,2])^2

min_var_explained <- which.min(var_explained)

print(min_var_explained)
##########################
model4 <- lmer(RecalculatedAngle ~ 
                 NodeDegreeStartBuilding + NodeDegreeTargetBuilding + 
                 NodeDegreeWeightedStartBuilding + NodeDegreeWeightedTargetBuilding + 
                 MaxFlowS + MaxFlowWeighted + 
                 ShortestPathDistance + AlternatingIndex + 
                 Mean_egocentric_global + Mean_survey + Mean_cardinal +
                 (1|SubjectID) + (1|StartBuildingName) + (1|TargetBuildingName),
               data = dataP2B)
summary(model4)

BIC(model4)

var_explained <- c(summary(model4)$varcor$SubjectID,
                   summary(model4)$varcor$StartBuildingName,
                   summary(model4)$varcor$TargetBuildingName,
                   summary(model4)$coefficients[,2])^2

min_var_explained <- which.min(var_explained)

print(min_var_explained)
##################################

model5 <- lmer(RecalculatedAngle ~ 
                 NodeDegreeStartBuilding + NodeDegreeTargetBuilding + 
                 NodeDegreeWeightedStartBuilding  + 
                 MaxFlowS + MaxFlowWeighted + 
                 ShortestPathDistance + AlternatingIndex + 
                 Mean_egocentric_global + Mean_survey + Mean_cardinal +
                 (1|SubjectID) + (1|StartBuildingName) + (1|TargetBuildingName),
               data = dataP2B)
summary(model5)

BIC(model5)

var_explained <- c(summary(model5)$varcor$SubjectID,
                   summary(model5)$varcor$StartBuildingName,
                   summary(model5)$varcor$TargetBuildingName,
                   summary(model5)$coefficients[,2])^2

min_var_explained <- which.min(var_explained)

print(min_var_explained)
######################
model6 <- lmer(RecalculatedAngle ~ 
                 NodeDegreeStartBuilding + NodeDegreeTargetBuilding + 
                 MaxFlowS + MaxFlowWeighted + 
                 ShortestPathDistance + AlternatingIndex + 
                 Mean_egocentric_global + Mean_survey + Mean_cardinal +
                 (1|SubjectID) + (1|StartBuildingName) + (1|TargetBuildingName),
               data = dataP2B)
summary(model6)

BIC(model6)

var_explained <- c(summary(model6)$varcor$SubjectID,
                   summary(model6)$varcor$StartBuildingName,
                   summary(model6)$varcor$TargetBuildingName,
                   summary(model6)$coefficients[,2])^2

min_var_explained <- which.min(var_explained)

print(min_var_explained)
#############
model7 <- lmer(RecalculatedAngle ~ 
                 NodeDegreeStartBuilding + NodeDegreeTargetBuilding + 
                 MaxFlowS + 
                 ShortestPathDistance + AlternatingIndex + 
                 Mean_egocentric_global + Mean_survey + Mean_cardinal +
                 (1|SubjectID) + (1|StartBuildingName) + (1|TargetBuildingName),
               data = dataP2B)
summary(model7)

BIC(model7)

var_explained <- c(summary(model7)$varcor$SubjectID,
                   summary(model7)$varcor$StartBuildingName,
                   summary(model7)$varcor$TargetBuildingName,
                   summary(model7)$coefficients[,2])^2

min_var_explained <- which.min(var_explained)

print(min_var_explained)
###################
model8 <- lmer(RecalculatedAngle ~ 
                 NodeDegreeStartBuilding +
                 MaxFlowS + 
                 ShortestPathDistance + AlternatingIndex + 
                 Mean_egocentric_global + Mean_survey + Mean_cardinal +
                 (1|SubjectID) + (1|StartBuildingName) + (1|TargetBuildingName),
               data = dataP2B)
summary(model8)

BIC(model8)

var_explained <- c(summary(model8)$varcor$SubjectID,
                   summary(model8)$varcor$StartBuildingName,
                   summary(model8)$varcor$TargetBuildingName,
                   summary(model8)$coefficients[,2])^2

min_var_explained <- which.min(var_explained)

print(min_var_explained)
####
model9 <- lmer(RecalculatedAngle ~ 
                 MaxFlowS + 
                 ShortestPathDistance + AlternatingIndex + 
                 Mean_egocentric_global + Mean_survey + Mean_cardinal +
                 (1|SubjectID) + (1|StartBuildingName) + (1|TargetBuildingName),
               data = dataP2B)
summary(model9)

BIC(model9)

var_explained <- c(summary(model9)$varcor$SubjectID,
                   summary(model9)$varcor$StartBuildingName,
                   summary(model9)$varcor$TargetBuildingName,
                   summary(model9)$coefficients[,2])^2

min_var_explained <- which.min(var_explained)

print(min_var_explained)

######

model10 <- lmer(RecalculatedAngle ~ 
                 MaxFlowS + 
                 ShortestPathDistance +
                 Mean_egocentric_global + Mean_survey + Mean_cardinal +
                 (1|SubjectID) + (1|StartBuildingName) + (1|TargetBuildingName),
               data = dataP2B)
summary(model10)

BIC(model10)

var_explained <- c(summary(model10)$varcor$SubjectID,
                   summary(model10)$varcor$StartBuildingName,
                   summary(model10)$varcor$TargetBuildingName,
                   summary(model10)$coefficients[,2])^2

min_var_explained <- which.min(var_explained)

print(min_var_explained)

#######
model11 <- lmer(RecalculatedAngle ~ 
                  ShortestPathDistance +
                  Mean_egocentric_global + Mean_survey + Mean_cardinal +
                  (1|SubjectID) + (1|StartBuildingName) + (1|TargetBuildingName),
                data = dataP2B)
summary(model11)

BIC(model11)

var_explained <- c(summary(model11)$varcor$SubjectID,
                   summary(model11)$varcor$StartBuildingName,
                   summary(model11)$varcor$TargetBuildingName,
                   summary(model11)$coefficients[,2])^2

min_var_explained <- which.min(var_explained)

print(min_var_explained)

#############

model12 <- lmer(RecalculatedAngle ~ 
                  Mean_egocentric_global + Mean_survey + Mean_cardinal +
                  (1|SubjectID) + (1|StartBuildingName) + (1|TargetBuildingName),
                data = dataP2B)
summary(model12)

BIC(model12)

var_explained <- c(summary(model12)$varcor$SubjectID,
                   summary(model12)$varcor$StartBuildingName,
                   summary(model12)$varcor$TargetBuildingName,
                   summary(model12)$coefficients[,2])^2

min_var_explained <- which.min(var_explained)

print(min_var_explained)
############

model13 <- lmer(RecalculatedAngle ~ 
                  Mean_egocentric_global + Mean_survey + 
                  (1|SubjectID) + (1|StartBuildingName) + (1|TargetBuildingName),
                data = dataP2B)
summary(model13)

BIC(model13)

var_explained <- c(summary(model13)$varcor$SubjectID,
                   summary(model13)$varcor$StartBuildingName,
                   summary(model13)$varcor$TargetBuildingName,
                   summary(model13)$coefficients[,2])^2

min_var_explained <- which.min(var_explained)

print(min_var_explained)

#######
model14 <- lmer(RecalculatedAngle ~ 
                  Mean_egocentric_global +  
                  (1|SubjectID) + (1|StartBuildingName) + (1|TargetBuildingName),
                data = dataP2B)
summary(model14)

BIC(model14)

var_explained <- c(summary(model14)$varcor$SubjectID,
                   summary(model14)$varcor$StartBuildingName,
                   summary(model14)$varcor$TargetBuildingName,
                   summary(model14)$coefficients[,2])^2

min_var_explained <- which.min(var_explained)

print(min_var_explained)

##################
model15 <- lmer(RecalculatedAngle ~ 
                  (1|SubjectID) + (1|StartBuildingName) + (1|TargetBuildingName),
                data = dataP2B)
summary(model15)

BIC(model15)

var_explained <- c(summary(model15)$varcor$SubjectID,
                   summary(model15)$varcor$StartBuildingName,
                   summary(model15)$varcor$TargetBuildingName,
                   summary(model15)$coefficients[,2])^2

min_var_explained <- which.min(var_explained)

print(min_var_explained)
############

model16 <- lmer(RecalculatedAngle ~ 
                  (1|SubjectID) + (1|StartBuildingName),
                data = dataP2B)
summary(model15)

BIC(model16)

#####################################################
testModel2 <- lmer(RecalculatedAngle ~ 
                 NodeDegreeTargetBuilding + 
                 ShortestPathDistance + AlternatingIndex + 
                 Mean_egocentric_global +Mean_survey+ Mean_cardinal
               + (1|StartBuildingName) + (1|TargetBuildingName),
               data = dataP2B)
summary(testModel2)
BIC(testModel2)
AIC(testModel2)
rsq(testModel2)

################
## a new try

model0 <- lmer(RecalculatedAngle ~ 
                 NodeDegreeTargetBuilding + 
                 ShortestPathDistance + AlternatingIndex + 
                 Mean_egocentric_global +Mean_survey+ Mean_cardinal
                 + (1|SubjectID) + (1|StartBuildingName) + (1|TargetBuildingName),
               data = dataP2B)
summary(model0)

AIC(model0)

var_explained <- c(summary(model0)$varcor$SubjectID,
                   summary(model0)$coefficients[,2])^2

min_var_explained <- which.min(var_explained)

print(var_explained)

#########################
########################

test = rsq(my_model0)
coefficients <- coef(my_model0)

hist(dataP2B$RecalculatedAngle)

# Q-Q plot
qqnorm(dataP2B$RecalculatedAngle)
qqline(dataP2B$RecalculatedAngle)

## do the same with the ln recalc angle

hist(dataP2B$lnRecalcAngle)

qqnorm(dataP2B$lnRecalcAngle)
qqline(dataP2B$lnRecalcAngle)



# Perform a Shapiro-Wilk test for normality of the response variable
shapiro.test(dataP2B$RecalculatedAngle)
# Results W = 0.88694, p-value < 2.2e-16

# Histogram
hist(dataP2B$RecalculatedAngle, breaks = 10, col = "grey", border = "white")

plot(density(dataP2B$RecalculatedAngle))

# Kolmogorov-Smirnov test
ks.test(dataP2B$RecalculatedAngle, "punif")
#D = 0.98111, p-value < 2.2e-16, alternative hypothesis: two-sided

# Chi-squared test
observed_freq <- table(cut(dataP2B$RecalculatedAngle, breaks = seq(0, 1, 0.1)))
expected_freq <- rep(length(dataP2B$RecalculatedAngle)/10, 10)
chisq.test(observed_freq, p = expected_freq)


# Fit the GLMM with a uniform response distribution
model <- glmmTMB(RecalculatedAngle ~ DistancePart2TargetBuilding + 
                   NodeDegreeStartBuilding + NodeDegreeTargetBuilding + 
                   NodeDegreeWeightedStartBuilding + NodeDegreeWeightedTargetBuilding + 
                   MaxFlowS + MaxFlowWeighted + 
                   ShortestPathDistance + AlternatingIndex + 
                   StartBuildingDwellingTime + TargetBuildingDwellingTime + 
                   Mean_egocentric_global + Mean_survey + Mean_cardinal + 
                   (1|SubjectID) + (1|StartBuildingName) + (1|TargetBuildingName),
                 data = dataP2B, family = "uniform")



# create the formula for the model with 14 fixed effects
my_formula <- RecalculatedAngle ~ DistancePart2TargetBuilding + 
  NodeDegreeStartBuilding + NodeDegreeTargetBuilding + 
  NodeDegreeWeightedStartBuilding + NodeDegreeWeightedTargetBuilding + 
  MaxFlowS + MaxFlowWeighted + 
  ShortestPathDistance + AlternatingIndex + 
  StartBuildingDwellingTime + TargetBuildingDwellingTime + 
  Mean_egocentric_global + Mean_survey + Mean_cardinal




# create the linear mixed model with random intercepts for each level of a grouping variable "group"
my_model2 <- lmer(RecalculatedAngle ~ DistancePart2TargetBuilding + 
                   NodeDegreeStartBuilding + NodeDegreeTargetBuilding + 
                   NodeDegreeWeightedStartBuilding + NodeDegreeWeightedTargetBuilding + 
                   MaxFlowS + MaxFlowWeighted + 
                   ShortestPathDistance + AlternatingIndex + 
                   StartBuildingDwellingTime + TargetBuildingDwellingTime + 
                   Mean_egocentric_global + Mean_survey + Mean_cardinal +
                   (1|SubjectID) + (1|StartBuildingName) + (1|TargetBuildingName),
                   data = dataP2B)
summary(my_model2)

hist(resid(my_model2))

# check for normality of residuals
ggplot(data.frame(residuals = residuals(my_model), fitted = fitted(my_model)), aes(x = fitted, y = residuals)) +
  geom_point() +
  geom_smooth() +
  ggtitle("Residuals vs Fitted") +
  xlab("Fitted Values") +
  ylab("Residuals")

# check for homoscedasticity
ggplot(data.frame(residuals = residuals(my_model2), fitted = fitted(my_model2)), aes(x = fitted, y = residuals)) +
  geom_point() +
  ggtitle("Residuals vs Fitted") +
  xlab("Fitted Values") +
  ylab("Residuals") +
  scale_y_continuous(limits = c(-3, 3)) +
  geom_hline(yintercept = 0, color = "red") +
  geom_smooth(se = FALSE)

# check for linearity
ggplot(data.frame(y = mydata$y, fitted = fitted(my_model)), aes(x = fitted, y = y)) +
  geom_point() +
  geom_smooth() +
  ggtitle("Actual vs Fitted") +
  xlab("Fitted Values") +
  ylab("Actual Values")

# check for independence
acf(residuals(my_model))

# check for outliers
qqnorm(resid(my_model))
qqline(resid(my_model))

##########################################################################

dataP2B$SubjectID <- as.factor(dataP2B$SubjectID)
dataP2B$StartBuildingName <- as.factor(dataP2B$StartBuildingName)
dataP2B$TargetBuildingName <- as.factor(dataP2B$TargetBuildingName)

# Create the formula with fixed and random effects
formula <- formula(paste("RecalculatedAngle ~ DistancePart2TargetBuilding + 
                          NodeDegreeStartBuilding + NodeDegreeTargetBuilding + 
                          NodeDegreeWeightedStartBuilding + NodeDegreeWeightedTargetBuilding + 
                          MaxFlowS + MaxFlowWeighted + 
                          ShortestPathDistance + AlternatingIndex + 
                          StartBuildingDwellingTime + TargetBuildingDwellingTime + 
                          Mean_egocentric_global + Mean_survey + Mean_cardinal"))

# Create the design matrix
X <- model.matrix(formula, dataP2B)

# Set up the glmmLasso control parameters
control <- list(family = "gaussian", alpha = 1, maxit = 1000)


# Fit the model
model <- glmmLasso(formula, data = dataP2B, X = X, control = control)





# Define variables
y <- dataP2B$RecalculatedAngle
X <- dataP2B[, 6:19]
Z <- dataP2B[, c(1, 3, 4)]

# Set up model formula
formula <- formula(paste("y ~", paste0("X", 1:14, collapse = " + ")))

# Set up random effects structure
random_effects <- list(SubjectID = ~ 1, StartBuildingName = ~ 1, TargetBuildingName = ~ 1)

# Set up model with lasso regularization
modelLasso <- glmmLasso(RecalculatedAngle ~ DistancePart2TargetBuilding + 
                          NodeDegreeStartBuilding + NodeDegreeTargetBuilding + 
                          NodeDegreeWeightedStartBuilding + NodeDegreeWeightedTargetBuilding + 
                          MaxFlowS + MaxFlowWeighted + 
                          ShortestPathDistance + AlternatingIndex + 
                          StartBuildingDwellingTime + TargetBuildingDwellingTime + 
                          Mean_egocentric_global + Mean_survey + Mean_cardinal + 
                          (1|SubjectID) + (1|StartBuildingName) + (1|TargetBuildingName),
                          data = dataP2B, control = list(maxit = 1000),lambda = 0.1)

# View model coefficients
print(model$coefficients)

my_model <- glmmTMB(RecalculatedAngle ~ DistancePart2TargetBuilding + 
                      NodeDegreeStartBuilding + NodeDegreeTargetBuilding + 
                      NodeDegreeWeightedStartBuilding + NodeDegreeWeightedTargetBuilding + 
                      MaxFlowS + MaxFlowWeighted + 
                      ShortestPathDistance + AlternatingIndex + 
                      StartBuildingDwellingTime + TargetBuildingDwellingTime + 
                      Mean_egocentric_global + Mean_survey + Mean_cardinal, data = dataP2B, 
                    family = gaussian, weights = weights, 
                    control = glmmTMBControl(optimizer = "bobyqa", optArgs = list(parallel = TRUE), check.conv = list(objective = 1e-8, reltol = 1e-8, atol = 1e-8)), 
                    method = "lasso")




##########################################################################


# Define fixed effects matrix X and response variable y
X <- model.matrix(~ DistancePart2TargetBuilding + 
                    NodeDegreeStartBuilding + NodeDegreeTargetBuilding + 
                    NodeDegreeWeightedStartBuilding + NodeDegreeWeightedTargetBuilding + 
                    MaxFlowS + MaxFlowWeighted + 
                    ShortestPathDistance + AlternatingIndex + 
                    StartBuildingDwellingTime + TargetBuildingDwellingTime + 
                    Mean_egocentric_global + Mean_survey + Mean_cardinal, data = dataP2B)

y <- dataP2B$RecalculatedAngle

# Define grouping variables and random effects matrix Z
Group1 <- as.factor(dataP2B$SubjectID)
Group2 <- as.factor(dataP2B$StartBuildingName)
Group3 <- as.factor(dataP2B$TargetBuildingName)

Z <- model.matrix(~ 0 + Group1 + Group2 + Group3)

formulaFixed <- RecalculatedAngle ~ DistancePart2TargetBuilding + 
  NodeDegreeStartBuilding + NodeDegreeTargetBuilding + 
  NodeDegreeWeightedStartBuilding + NodeDegreeWeightedTargetBuilding + 
  MaxFlowS + MaxFlowWeighted + 
  ShortestPathDistance + AlternatingIndex + 
  StartBuildingDwellingTime + TargetBuildingDwellingTime + 
  Mean_egocentric_global + Mean_survey + Mean_cardinal

formulaFixed <- RecalculatedAngle ~  
  NodeDegreeStartBuilding + NodeDegreeTargetBuilding 


formulaRandom <- (~ 1 | as.factor(SubjectID)) + (~ 1 | as.factor(StartBuildingName)) + (~ 1 | as.factor(TargetBuildingName))
random_formula <- SubjectID ~ 1 + StartBuildingName ~1 + TargetBuildingName ~1


# Fit linear mixed model with lasso regularization
fit <- glmmLasso(formulaFixed, rnd=NULL,
                   data= dataP2B, lambda = 0.1)

# Print model summary
summary(fit)


