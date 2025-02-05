rm(list = ls())

# load the necessary packages
library(Matrix)
library(lme4)
library(ggplot2)
library(scico)
library(pals)
library(glmmTMB)
library(glmmLasso)
library(MuMIn)
library(cAIC4)
library(rsq)
library(performance)
library(lubridate)
library(dplyr)
library(tidyr)


#savepath <- "E:\\WestbrookProject\\SpaRe_Data\\control_data\\Analysis\\P2B_controls_analysis\\"
savepath <- "F:\\WestbrookProject\\Spa_Re\\control_group\\Analysis\\P2B_controls_analysis\\"

setwd(savepath)

################################################################################

# load the data

# full data frame
dataP2B <- read.csv("F:/WestbrookProject/Spa_Re/control_group/Analysis/P2B_controls_analysis/overviewTable_P2B_Prep_complete.csv")
dataP2B$SubjectID <- as.factor(dataP2B$SubjectID)
dataP2B$StartBuildingName <- as.factor(dataP2B$StartBuildingName)
dataP2B$TargetBuildingName <- as.factor(dataP2B$TargetBuildingName)
dataP2B$RouteID <- as.factor(dataP2B$RouteID)



# Define the path where you want to save the plot
savepath <- "F:/WestbrookProject/Spa_Re/control_group/Analysis/P2B_controls_analysis/performanceAnalysis_trialSequence"


################################################################################
# model the performance with the trial sequence, aka the 112 trial order 
# do people get better during the task with time?

model_trialSequence112 <- lm(RecalculatedAngle ~  TrialSequence, data = dataP2B)
summary(model_trialSequence112)

# Create a vector of colors using the Parula colormap
num_subjects <- length(unique(dataP2B$SubjectID))
parula_colors <- parula(num_subjects)

# Create the plot using ggplot2 with Parula colormap
p1 <- ggplot(dataP2B, aes(x = TrialSequence, y = RecalculatedAngle, color = as.factor(SubjectID))) +
  geom_point(size = 1) +  # Use small filled dots
  geom_smooth(method = "lm", se = FALSE, color = "black") +  # Add the regression line
  labs(title = "Linear Regression of Recalculated Angle vs Trial Sequence",
       x = "Trial Sequence",
       y = "Recalculated Angle",
       color = "Subject ID") +  # Add legend title
  scale_color_manual(values = parula_colors) +  # Use Parula colormap
  theme_minimal()

# Display the plot
print(p1)

# Save the plot 
ggsave(filename = file.path(savepath, "performane_trialSequence112.png"), plot = p1)



###############
# model the task duration with time
# do people get faster over the course of the task?


model_trialSequenceDuration <- lm(TrialDuration ~  TrialSequence, data = dataP2B)
summary(model_trialSequenceDuration)

# Create the plot using ggplot2 with Parula colormap
p2 <- ggplot(dataP2B, aes(x = TrialSequence, y = TrialDuration, color = as.factor(SubjectID))) +
  geom_point(size = 1) +  # Use small filled dots
  geom_smooth(method = "lm", se = FALSE, color = "black") +  # Add the regression line
  labs(title = "Linear Regression of Trial Duration vs Trial Sequence",
       x = "Trial Sequence",
       y = "Trial Duration",
       color = "Subject ID") +  # Add legend title
  scale_color_manual(values = parula_colors) +  # Use Parula colormap
  theme_minimal()

# Display the plot
print(p2)

# Save the plot 
ggsave(filename = file.path(savepath, "trialDuration_trialSequence.png"), plot = p2)




###############################################

model_sameStartTrials7 <- lm(RecalculatedAngle ~  TrialSequence_SameStart7, data = dataP2B)
summary(model_sameStartTrials7)

p3 <- ggplot(dataP2B, aes(x = TrialSequence_SameStart7, y = RecalculatedAngle, color = as.factor(SubjectID))) +
  geom_point(size = 1) +  # Use small filled dots
  geom_smooth(method = "lm", se = FALSE, color = "black") +  # Add the regression line
  labs(title = "Linear Regression of angular error vs Trial Sequence at the same location (7 trials)",
       x = "Trial Sequence at same location (7)",
       y = "angular error",
       color = "Subject ID") +  # Add legend title
  scale_color_manual(values = parula_colors) +  # Use Parula colormap
  theme_minimal()

# Display the plot
print(p3)

# Save the plot 
ggsave(filename = file.path(savepath, "performance_trialSequence_SameLocation7.png"), plot = p3)



###########################

model_sameStartTrials14 <- lm(RecalculatedAngle ~  TrialSequence_SameStart14, data = dataP2B)
summary(model_sameStartTrials14)

p4 <- ggplot(dataP2B, aes(x = TrialSequence_SameStart14, y = RecalculatedAngle, color = as.factor(SubjectID))) +
  geom_point(size = 1) +  # Use small filled dots
  geom_smooth(method = "lm", se = FALSE, color = "black") +  # Add the regression line
  labs(title = "Linear Regression of angular error vs Trial Sequence at the same location (7 trials)",
       x = "Trial Sequence at same location (14)",
       y = "angular error",
       color = "Subject ID") +  # Add legend title
  scale_color_manual(values = parula_colors) +  # Use Parula colormap
  theme_minimal()

# Display the plot
print(p4)

# Save the plot 
ggsave(filename = file.path(savepath, "performance_trialSequence_SameLocation14.png"), plot = p4)



###############
# does trial duration predict the error?

model_trialDuration <- lm(RecalculatedAngle ~  TrialDuration, data = dataP2B)
summary(model_trialDuration)

# Create the plot using ggplot2 with Parula colormap
p5 <- ggplot(dataP2B, aes(x = TrialDuration, y = RecalculatedAngle, color = as.factor(SubjectID))) +
  geom_point(size = 1) +  # Use small filled dots
  geom_smooth(method = "lm", se = FALSE, color = "black") +  # Add the regression line
  labs(title = "Linear Regression of Recalculated Angle vs Trial Sequence",
       x = "Trial Duration",
       y = "Recalculated Angle",
       color = "Subject ID") +  # Add legend title
  scale_color_manual(values = parula_colors) +  # Use Parula colormap
  theme_minimal()

# Display the plot
print(p5)

# Save the plot 
ggsave(filename = file.path(savepath, "performane_trialDuration.png"), plot = p5)


#######################
######################

#perform paired t-test

# Reshape the data to wide format
data_wide <- dataP2B %>%
  select(SubjectID, RouteID, TrialOrder, RecalculatedAngle) %>%
  pivot_wider(names_from = TrialOrder, values_from = RecalculatedAngle, names_prefix = "Trial")

# Calculate differences
data_wide <- data_wide %>%
  mutate(Difference = Trial2 - Trial1)

# Reshape data back to long format for plotting
data_long <- data_wide %>%
  pivot_longer(cols = c(Trial1, Trial2), names_to = "TrialOrder", values_to = "Performance")

# Plot 1: Scatter plot with connecting lines
scatter_plot <- ggplot(data_long, aes(x = TrialOrder, y = Performance, group = SubjectID, color = SubjectID)) +
  geom_line() +  # Connect lines for each subject
  geom_point(size = 1) +  # Plot points for each trial
  labs(title = "Performance Across Trial Orders",
       x = "Trial Order",
       y = "Performance",
       color = "Participant") +
  theme_minimal() +
  theme(legend.position = "none")

print(scatter_plot)
# Save the plot 
ggsave(filename = file.path(savepath, "changes_Performance_repetitions_participants.png"), plot = scatter_plot)

# plot 1b
# Create a scatter plot with connecting lines
scatter_plot2 <- ggplot(data_long, aes(x = TrialOrder, y = Performance, group = interaction(SubjectID, RouteID), color = SubjectID)) +
  geom_line() +  # Connect lines for each subject and route
  geom_point(size = 1) +  # Plot points for each trial
  labs(title = "Performance Across Trial Orders",
       x = "Trial Order",
       y = "Performance",
       color = "Participant") +
  theme_minimal() +
  theme(legend.position = "none")

# Print the plot
print(scatter_plot2)
ggsave(filename = file.path(savepath, "changes_Performance_repetitions_all.png"), plot = scatter_plot2)


# Plot 2: Density plot of differences
density_plot <- ggplot(data_wide, aes(x = Difference)) +
  geom_density(fill = "blue", alpha = 0.5) +
  labs(title = "Density Plot of Performance Differences",
       x = "Difference in Performance (Trial2 - Trial1)",
       y = "Density") +
  theme_minimal()

print(density_plot)
ggsave(filename = file.path(savepath, "density_performanceChanges.png"), plot = density_plot)




# Perform paired t-test
t_test_results <- data_wide %>%
  group_by(SubjectID) %>%
  summarize(t_test = list(t.test(Trial1, Trial2, paired = TRUE))) %>%
  pull(t_test)

# Combine results into a data frame
t_test_summary <- do.call(rbind, lapply(t_test_results, function(x) {
  data.frame(statistic = x$statistic, p_value = x$p.value, conf_low = x$conf.int[1], conf_high = x$conf.int[2])
}))

# Print the summary of t-test results
print(t_test_summary)

# Add SubjectID for plotting
t_test_summary <- t_test_summary %>%
  mutate(SubjectID = rownames(t_test_summary))

# Add SubjectID for plotting and a new variable for significance
t_test_summary <- t_test_summary %>%
  mutate(SubjectID = rownames(t_test_summary),
         Significance = ifelse(p_value <= 0.05, "Significant", "Not Significant"))


# Plot 1: Bar plot of t-statistics
bar_plot_statistic <- ggplot(t_test_summary, aes(x = reorder(SubjectID, statistic), y = statistic, fill = statistic > 0)) +
  geom_bar(stat = "identity") +
  coord_flip() +
  labs(title = "Performance Across Trials: Higher Error vs Lower Error in second trial",
       x = "Subject ID",
       y = "t-Statistic",
       fill = "Error Category") +
  scale_fill_manual(values = c("FALSE" = "steelblue","TRUE" = "green"), 
                    labels = c("Higher Error (Worse Performance)","Lower Error (Better Performance)")) +
  theme_minimal()
print(bar_plot_statistic)
ggsave(filename = file.path(savepath, "f-statisticPlot.png"), plot = bar_plot_statistic)


# Plot 2: Bar plot of p-values with significance highlighting
bar_plot_p_value <- ggplot(t_test_summary, aes(x = reorder(SubjectID, p_value), y = p_value, fill = Significance)) +
  geom_bar(stat = "identity") +
  scale_fill_manual(values = c("Significant" = "red", "Not Significant" = "steelblue")) +
  coord_flip() +
  labs(title = "p-Value for Each Participant",
       x = "Subject ID",
       y = "p-Value",
       fill = "Significance") +
  theme_minimal()

print(bar_plot_p_value)
ggsave(filename = file.path(savepath, "p_valuesPlot.png"), plot = bar_plot_p_value)



ggsave(filename = file.path(savepath, "f-statisticPlot.png"), plot = bar_plot_statistic)


# Plot 3: Error bars for Confidence Intervals
error_bar_plot <- ggplot(t_test_summary, aes(x = reorder(SubjectID, statistic), y = statistic, ymin = conf_low, ymax = conf_high)) +
  geom_errorbar(width = 0.2, color = "red") +  # Add error bars
  geom_point(size = 3, color = "blue") +  # Add points
  coord_flip() +
  labs(title = "Confidence Intervals for t-Statistics",
       x = "Subject ID",
       y = "t-Statistic") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))


print(error_bar_plot)

############################################################

dataP2B_trial1 <- dataP2B %>%
  filter(TrialOrder == 1)


################################################################################
# model the performance with the trial sequence, aka the 112 trial order 
# do people get better during the task with time?

model_trialSequence112 <- lm(RecalculatedAngle ~  TrialSequence, data = dataP2B_trial1)
summary(model_trialSequence112)

# Create a vector of colors using the Parula colormap
num_subjects <- length(unique(dataP2B$SubjectID))
parula_colors <- parula(num_subjects)

# Create the plot using ggplot2 with Parula colormap
p1 <- ggplot(dataP2B_trial1, aes(x = TrialSequence, y = RecalculatedAngle, color = as.factor(SubjectID))) +
  geom_point(size = 1) +  # Use small filled dots
  geom_smooth(method = "lm", se = FALSE, color = "black") +  # Add the regression line
  labs(title = "Linear Regression of Recalculated Angle vs Trial Sequence",
       x = "Trial Sequence",
       y = "Recalculated Angle",
       color = "Subject ID") +  # Add legend title
  scale_color_manual(values = parula_colors) +  # Use Parula colormap
  theme_minimal()

# Display the plot
print(p1)

# Save the plot 
ggsave(filename = file.path(savepath, "performane_trialSequence56.png"), plot = p1)



###############
# model the task duration with time
# do people get faster over the course of the task?


model_trialSequenceDuration <- lm(TrialDuration ~  TrialSequence, data = dataP2B_trial1)
summary(model_trialSequenceDuration)

# Create the plot using ggplot2 with Parula colormap
p2 <- ggplot(dataP2B_trial1, aes(x = TrialSequence, y = TrialDuration, color = as.factor(SubjectID))) +
  geom_point(size = 1) +  # Use small filled dots
  geom_smooth(method = "lm", se = FALSE, color = "black") +  # Add the regression line
  labs(title = "Linear Regression of Trial Duration vs Trial Sequence",
       x = "Trial Sequence",
       y = "Trial Duration",
       color = "Subject ID") +  # Add legend title
  scale_color_manual(values = parula_colors) +  # Use Parula colormap
  theme_minimal()

# Display the plot
print(p2)

# Save the plot 
ggsave(filename = file.path(savepath, "trialDuration_trialSequence_trial1.png"), plot = p2)




###############################################

model_sameStartTrials7 <- lm(RecalculatedAngle ~  TrialSequence_SameStart7, data = dataP2B_trial1)
summary(model_sameStartTrials7)

p3 <- ggplot(dataP2B_trial1, aes(x = TrialSequence_SameStart7, y = RecalculatedAngle, color = as.factor(SubjectID))) +
  geom_point(size = 1) +  # Use small filled dots
  geom_smooth(method = "lm", se = FALSE, color = "black") +  # Add the regression line
  labs(title = "Linear Regression of angular error vs Trial Sequence at the same location (7 trials)",
       x = "Trial Sequence at same location (7)",
       y = "angular error",
       color = "Subject ID") +  # Add legend title
  scale_color_manual(values = parula_colors) +  # Use Parula colormap
  theme_minimal()

# Display the plot
print(p3)

# Save the plot 
ggsave(filename = file.path(savepath, "performance_trialSequence_SameLocation7_trial1.png"), plot = p3)

parula_colors <- pals::parula(7)  # Define number of colors as needed

# Create the plot with boxplots, mean line, and notches
p3 <- ggplot(dataP2B_trial1, aes(x = as.factor(TrialSequence_SameStart7), y = RecalculatedAngle)) +
  geom_boxplot(aes(fill = as.factor(TrialSequence_SameStart7)), notch = TRUE, color = "black", fill = "lightblue") +  # Boxplots with light blue fill and notches
  stat_summary(fun = mean, geom = "line", color = "orange", size = 1, aes(group = 1)) +  # Mean line
  stat_summary(fun = mean, geom = "point", color = "orange", size = 3) +  # Mean points
  labs(title = "Boxplots of Angular Error vs Trial Sequence with Mean Line",
       x = "Trial Sequence at Same Location (7 Trials)",
       y = "Angular Error",
       fill = "Trial Sequence") +  # Add legend title
  scale_fill_manual(values = parula_colors) +  # Use Parula colormap for fill
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))  # Rotate x-axis labels for readability

print(p3)
ggsave(filename = file.path(savepath, "performance_trialSequence_SameLocation7_trial1_boxplot.png"), plot = p3)


##################################################################################################
# Calculate the mean for each variable by SubjectID
mean_P2B <- dataP2B_trial1 %>%
  group_by(SubjectID) %>%
  summarize(across(everything(), mean, na.rm = TRUE))


###################################################################
################################################################
# model for mean participant performance

dataGraphMeasures <- read.csv("F:/WestbrookProject/Spa_Re/control_group/Analysis/P2B_controls_analysis/performance_graph_properties_analysis/graphPropertiesPlots/overviewGraphMeasures.csv")
dataFRS <- read.csv("F:/WestbrookProject/Spa_Re/control_group/Analysis/P2B_controls_analysis/overview_FRS_Data.csv")

dataGraphM <- cbind(mean_P2B[, c(1,7)], dataGraphMeasures[, c(2,3,4,5,6,7,8,9)])
dataGraphMFRS <- cbind(dataGraphM, dataFRS[, c(2,5,8)])
dataGraphMFRS$SubjectID <- as.factor(dataGraphMFRS$Participants)



# general graph properties and FRS
modelGraph <- lm(RecalculatedAngle ~ nrViewedHouses + density + diameter + 
                      hierarchyIndex ,data = dataGraphMFRS)
summary(modelGraph)

# general graph properties and FRS
modelDiameter <- lm(RecalculatedAngle ~ diameter, data = dataGraphMFRS)
summary(modelDiameter)



modelGGraph_landmarks <- lm(RecalculatedAngle ~ nrAllLandmarks* nrCommonLandmarks , data = dataGraphMFRS)



summary(modelGGraph_landmarks)




# general graph properties and FRS + edges!!!!
modelGraphFRS <- lm(RecalculatedAngle ~ Mean_egocentric_global + Mean_survey +
                       Mean_cardinal  ,data = dataGraphMFRS)
summary(modelGraphFR)
