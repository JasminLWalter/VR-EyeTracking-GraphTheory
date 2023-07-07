
# solve problem with different data types in the time stamps of the dataP2B file


## dataP2B - format
df_PTB_Ctrl_Preprocessed_raw <- read.csv("D:/WestbrookData/df_PTB_Ctrl_Preprocessed.csv")

date_rows <- grepl("\\d{4}-\\d{2}-\\d{2} \\d{2}:\\d{2}:\\d{2}", df_PTB_Ctrl_Preprocessed_raw$TimeStampBegin)

# Convert date format to Unix timestamp format
df_PTB_Ctrl_Preprocessed_raw$TimeStampBegin[date_rows] <- as.numeric(as.POSIXct(df_PTB_Ctrl_Preprocessed_raw$TimeStampBegin[date_rows], format="%Y-%m-%d %H:%M:%OS", tz="UTC"))

write.csv(df_PTB_Ctrl_Preprocessed_raw, paste(savepath, "df_PTB_Ctrl_Preprocessed_UnixTS.csv"), row.names = FALSE)


# Convert Unix timestamp format to date format# 
# df_PTB_Ctrl_Preprocessed_raw$TimeStampBegin <- format(as.POSIXct(as.numeric(df_PTB_Ctrl_Preprocessed_raw$TimeStampBegin), origin="1970-01-01", tz="UTC"), "%Y-%m-%d %H:%M:%OS")
# df_PTB_Ctrl_Preprocessed_raw$TimeStampBegin <- strftime(as.POSIXct(as.numeric(df_PTB_Ctrl_Preprocessed_raw$TimeStampBegin), origin="1970-01-01", tz="UTC"), format = "%Y-%m-%d %H:%M:%OS3", tz = "UTC")

# write.csv(df_PTB_Ctrl_Preprocessed_raw, paste(savepath, "df_PTB_Ctrl_Preprocessed_DateTS.csv"), row.names = FALSE)

