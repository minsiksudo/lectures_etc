library(tidyverse)

# Loading student list

readxl::read_excel("/Volumes/macdrive/Dropbox/Inha/5_Lectures/2024/BPE3206/attendance book (20242,BPE3206-001).xlsx") %>% 
        .$`학생명`

mbti <- c("INFP", "INFP", "ENFJ", "ENFJ", "ISTJ", "ISTJ", 
          "ESFP", "ESFP", "ENTP", "ENTP", "INTJ", "INTJ",
          "INFJ", "INFJ", "ESTJ", "ESTJ", "ENTJ", "ENTJ", 
          "ISFJ", "ISFJ", "ESFJ", "ESFJ", "ISTP", "ISTP")

# 조의 수 설정 (예: 4개의 조)
num_groups <- 6

# 학생 ID 생성 (학생 1, 학생 2, ..., 학생 24)
data <- readxl::read_excel("/Volumes/macdrive/Dropbox/Inha/5_Lectures/2024/BPE3206/attendance book (20242,BPE3206-001).xlsx") %>% 
        .$`학생명` %>% 
        data.frame(Student = .)

data$MBTI <- mbti


# MBTI similarity
mbti_similarity <- function(mbti1, mbti2) {
        sum(strsplit(mbti1, "")[[1]] == strsplit(mbti2, "")[[1]])
}


# grouping by similarity
set.seed(20240905)

assign_groups <- function(data, num_groups) {
        data$Group <- NA
        group_size <- nrow(data) / num_groups
        
        for (i in 1:num_groups) {
                if (nrow(data[is.na(data$Group), ]) >= group_size) {
                        selected <- sample(which(is.na(data$Group)), 1)
                        data$Group[selected] <- i
                        
                        remaining <- which(is.na(data$Group))
                        similarities <- sapply(remaining, function(x) mbti_similarity(data$MBTI[selected], data$MBTI[x]))
                        
                        closest <- order(similarities, decreasing = TRUE)[1:(group_size-1)]
                        data$Group[remaining[closest]] <- i
                } else {
                        data$Group[is.na(data$Group)] <- i
                }
        }
        
        return(data)
}


# Assign groups
grouped_data <- assign_groups(data, num_groups)


# Print result
for (i in 1:num_groups) {
        cat("조", i, ":\n")
        print(grouped_data[grouped_data$Group == i, c("Student", "MBTI")])
        cat("\n")
}
