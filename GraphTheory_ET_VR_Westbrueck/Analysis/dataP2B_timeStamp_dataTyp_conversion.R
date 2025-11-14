####################### dataP2B_timeStamp_dataTyp_conversion.R ##############################

# --------------------script written by Jasmin L. Walter-------------------
# -----------------------jawalter@uni-osnabrueck.de------------------------


'Purpose: Normalizes TimeStampBegin in the PTB control dataset by converting any date-time strings
to Unix timestamps (seconds since epoch, UTC). Produces a consistent CSV used by later scripts.
(# solve problem with different data types in the time stamps of the dataP2B file)

Usage:
  - Adjust: savepath and the input CSV path.
- Run in R/RStudio. No extra packages required (base R only).

Inputs:
  - df_PTB_Ctrl_Preprocessed.csv (may contain mixed types in TimeStampBegin: POSIX-like strings and/or numeric)

Outputs (to savepath):
  - df_PTB_Ctrl_Preprocessed_UnixTS.csv (TimeStampBegin values converted to numeric Unix seconds)

Notes:
  - Conversion uses UTC and format "%Y-%m-%d %H:%M:%OS"; only rows matching the regex pattern are converted.
- Optional: after conversion, coerce the whole column to numeric for consistency, e.g.:
  df$TimeStampBegin <- as.numeric(df$TimeStampBegin)

License: GNU General Public License v3.0 (GPL-3.0) (see LICENSE)'



# savepath 
savepath <- "E:\\WestbrookProject\\Spa_Re\\control_group\\Analysis\\P2B_controls_analysis\\"

## adjust path to folder and file containing the pointing to building task 
# performance, which is uploaded in the OSF repository at https://osf.io/32sqe 
# (different from the repository where the eye and movement tracking dataset is 
# uploaded
# repository folder: 3. Angle Calculation/Resulting Dataframes
# direct link to required file: https://osf.io/32sqe/files/aruvw
                        
df_PTB_Ctrl_Preprocessed_raw <- read.csv(".../performanceData/df_PTB_Ctrl_Preprocessed.csv")



date_rows <- grepl("\\d{4}-\\d{2}-\\d{2} \\d{2}:\\d{2}:\\d{2}", df_PTB_Ctrl_Preprocessed_raw$TimeStampBegin)

# Convert date format to Unix timestamp format
df_PTB_Ctrl_Preprocessed_raw$TimeStampBegin[date_rows] <- as.numeric(as.POSIXct(df_PTB_Ctrl_Preprocessed_raw$TimeStampBegin[date_rows], format="%Y-%m-%d %H:%M:%OS", tz="UTC"))

write.csv(df_PTB_Ctrl_Preprocessed_raw, paste(savepath, "df_PTB_Ctrl_Preprocessed_UnixTS.csv"), row.names = FALSE)


# (added in Nov 2025) process end unix timestamps as well
df_PTB_Ctrl_Preprocessed_raw <- read.csv("E:\\WestbrookProject\\Spa_Re\\control_group\\Analysis\\P2B_controls_analysis\\df_PTB_Ctrl_Preprocessed_UnixTS.csv")
date_rows <- grepl("\\d{4}-\\d{2}-\\d{2} \\d{2}:\\d{2}:\\d{2}", df_PTB_Ctrl_Preprocessed_raw$TimeStampEnd)
df_PTB_Ctrl_Preprocessed_raw$TimeStampEnd[date_rows] <- as.numeric(as.POSIXct(df_PTB_Ctrl_Preprocessed_raw$TimeStampEnd[date_rows], format="%Y-%m-%d %H:%M:%OS", tz="UTC"))

write.csv(df_PTB_Ctrl_Preprocessed_raw, paste("E:\\WestbrookProject\\Spa_Re\\control_group\\Analysis\\P2B_controls_analysis\\df_PTB_Ctrl_Preprocessed_UnixTS_withEndTS.csv"), row.names = FALSE)

