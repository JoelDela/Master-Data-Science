#----------------------------------------------------------------------------------#
#  ___           _          _                  ___     ____   ____  
# |_ _|  _ __   (_)   ___  (_)   ___    _     / _ \   / ___| |  _ \ 
#  | |  | '_ \  | |  / __| | |  / _ \  (_)   | | | | | |     | |_) |
#  | |  | | | | | | | (__  | | | (_) |  _    | |_| | | |___  |  _ < 
# |___| |_| |_| |_|  \___| |_|  \___/  (_)    \___/   \____| |_| \_\
#----------------------------------------------------------------------------------#



rm(list=ls())

#-------------------------- Start: load data -------------------------------------#

data_train<-as.data.frame(fread("./data_in/zip.train"))
data_test<-as.data.frame(fread("./data_in/zip.test"))

#--------------------------- End: load data --------------------------------------#



#------------------------- Start: Set plot parameters ----------------------------#

COLORS <- c("white", "black")


CUSTOM_COLORS <- colorRampPalette(colors = COLORS)
CUSTOM_COLORS_PLOT <- colorRampPalette(brewer.pal(10, "Set3"))


#--------------------------- End: Set plot parameters ----------------------------#




#------------------------- Start: Exploratory Analysis ----------------------------#

head(data_train)
dim(data_train)
colnames(data_train)

sum(is.na(data_train))



head(data_test)
dim(data_test)
colnames(data_test)

sum(is.na(data_test))


#------------------------- End: Exploratory Analysis ----------------------------#



#------------------------- Start: Exploratory Analysis ----------------------------#




#------------------------- Start: Preprocess data ------------------------------#


data_train[, 1] <- as.factor(data_train[, 1])  # As Category
colnames(data_train) <- c("Y", paste("X", 1:256, sep = ""))
class(data_train[, 1])
levels(data_train[, 1])
sapply(data_train[1, ], class)


data_test[, 1] <- as.factor(data_test[, 1])  # As Category
colnames(data_test) <- c("Y", paste("X", 1:256, sep = ""))
class(data_test[, 1])
levels(data_test[, 1])

sapply(data_test[1, ], class)

#------------------------- End: Preprocess data ------------------------------#





#--------------------------- Start: Previous plot data ---------------------------------#

par(mfrow = c(4, 3), pty = "s", mar = c(1, 1, 1, 1), xaxt = "n", yaxt = "n")
images_digits_0_9 <- array(dim = c(10, 16 * 16))
for (digit in 0:9) {
  print(digit)
  images_digits_0_9[digit + 1, ] <- apply(data_train[data_train[, 1] == digit, -1], 2, sum)
  
  images_digits_0_9[digit + 1, ] <- images_digits_0_9[digit + 1, ]/max(images_digits_0_9[digit + 1, ]) * 255
  
  z <- array(images_digits_0_9[digit + 1, ], dim = c(16, 16))
  z <- z[, 16:1]  ##right side up
  image(1:16, 1:16, z, main = digit, col = CUSTOM_COLORS(256))
}



# pdf(file=paste0('trainDigit.pdf'),)
par(mfrow = c(4, 4), pty = "s", mar = c(3, 3, 3, 3), xaxt = "n", yaxt = "n")
for (i in 1:10) {
  z <- array(as.vector(as.matrix(data_train[i, -1])), dim = c(16, 16))
  z <- z[, 16:1]  ##right side up
  image(1:16, 1:16, z, main = data_train[i, 1], col = CUSTOM_COLORS(256))
  print(i)
}




#--------------------------- End: Previous plot data ---------------------------------#









#--------------------------- Start: Graphic exploratory analysis ---------------------------------#

#-- Train

resTable <- table(data_train$Y)
par(mfrow = c(1, 1))
par(mar = c(5, 4, 4, 2) + 0.1)  # increase y-axis margin.
plot <- plot(data_train$Y, col = CUSTOM_COLORS_PLOT(10), main = "Total Number of Digits (Training Set)", 
             ylim = c(0, 1500), ylab = "Examples Number")
text(x = plot, y = resTable + 50, labels = resTable, cex = 0.75)



par(mfrow = c(1, 1))
percentage <- round(resTable/sum(resTable) * 100)
labels <- paste0(row.names(resTable), " (", percentage, "%) ")  # add percents to labels
pie(resTable, labels = labels, col = CUSTOM_COLORS_PLOT(10), main = "Total Number of Digits (Training Set)")


#-- Test


resTable <- table(data_test$Y)
par(mfrow = c(1, 1))
par(mar = c(5, 4, 4, 2) + 0.1)  # increase y-axis margin.
plot <- plot(data_test$Y, col = CUSTOM_COLORS_PLOT(10), main = "Total Number of Digits (Testing Set)", 
             ylim = c(0, 400), ylab = "Examples Number")
text(x = plot, y = resTable + 20, labels = resTable, cex = 0.75)


#--

par(mfrow = c(1, 1))
percentage <- round(resTable/sum(resTable) * 100)
labels <- paste0(row.names(resTable), " (", percentage, "%) ")  # add percents to labels
pie(resTable, labels = labels, col = CUSTOM_COLORS_PLOT(10), main = "Total Number of Digits (Testing Set)")


#--------------------------- End: Graphic exploratory analysis ---------------------------------#






#--------------------------- Start: Train a decision tree ---------------------------------#


pc <- proc.time()
model_tree <- tree(data_train$Y ~ ., data = data_train)
proc.time() - pc

print(model_tree)



plot(model_tree, uniform = TRUE, main = "Classification. Tree of Handwritten Digit Recognition ")
text(model_tree, all = TRUE, cex = 0.75)

draw.tree(model_tree, cex = 0.5, nodeinfo = TRUE, col = gray(0:8/8))

#confusion matrix
predictrion_tree <- predict(model_tree, newdata = data_test, type = "class")
table(Actual= data_test$Y, Predicted = predictrion_tree)

error_rate_tree <- sum(data_test$Y != predictrion_tree)/nrow(data_test)
print(paste0("Accuary (Precision): ", 1 - error_rate_tree))


#--Predict Digit for Example 1 (Tree)

row <- 1
prediction.digit <- as.vector(predict(model_tree, newdata = data_test[row, ], type = "class"))

print(paste0("Current Digit: ", as.character(data_test$Y[row])))
print(paste0("Predicted Digit: ", prediction.digit))


z <- array(as.vector(as.matrix(data_test[row, -1])), dim = c(16, 16))
z <- z[, 16:1]  ##right side up
par(mfrow = c(1, 1), pty = "s", mar = c(1, 1, 1, 1), xaxt = "n", yaxt = "n")
image(1:16, 1:16, z, main = data_test[row, 1], col = CUSTOM_COLORS(256))

#--------------------------- End: Train a decision tree ---------------------------------#




#--------------------------- Start: Train a K nearest neighbors ---------------------------------#

pc <- proc.time()
model.knn <- knn(train = data_train,test=data_test,cl=data_train$Y,k=3)
proc.time() - pc

summary(model.knn)


#confusion matrix 
table(Actual = data_test$Y, 'Predicted' = model.knn)

error.rate.knn <- sum(data_test$Y != model.knn)/nrow(data_test)
print(paste0("Accuary (Precision): ", 1 - error.rate.knn))


#plots

row <- 1

prediction.digit<-model.knn[1]

print(paste0("Current Digit: ", as.character(data_test$Y[row])))

print(paste0("Predicted Digit: ", prediction.digit))

par(mfrow = c(1, 3), pty = "s", mar = c(1, 1, 1, 1), xaxt = "n", yaxt = "n")
z <- array(as.vector(as.matrix(data_test[row, -1])), dim = c(16, 16))
z <- z[, 16:1]  ##right side up
image(1:16, 1:16, z, main = data_test[row, 1], col = CUSTOM_COLORS(256))

#--------------------------- End: Train a K nearest neighbors ---------------------------------#








#------------------------- Start: Train a Support Vector Machine ------------------------------#

pc <- proc.time()
model.svm <- svm(data_train$Y ~ ., method = "class", data = data_train)
proc.time() - pc

summary(model.svm)

prediction.svm <- predict(model.svm, newdata = data_test, type = "class")
table(Actual = data_test$Y, Predicted = prediction.svm)

error.rate.svm <- sum(data_test$Y != prediction.svm)/nrow(data_test)
print(paste0("Accuary (Precision): ", 1 - error.rate.svm))


#plot
# All Prediction for Row 1
row <- 1
prediction.digit <- as.vector(predict(model.svm, newdata = data_test[row, 
                                                                        ], type = "class"))
print(paste0("Current Digit: ", as.character(data_test$Y[row])))
print(paste0("Predicted Digit: ", prediction.digit))




errors <- as.vector(which(data_test$Y != prediction.svm))
print(paste0("Error Numbers: ", length(errors)))


predicted <- as.vector(prediction.svm)
par(mfrow = c(4, 4), pty = "s", mar = c(3, 3, 3, 3), xaxt = "n", yaxt = "n")
for (i in 1:length(errors)) {
  z <- array(as.vector(as.matrix(data_test[errors[i], -1])), dim = c(16, 
                                                                        16))
  z <- z[, 16:1]  ##right side up
  image(1:16, 1:16, z, main = paste0("C.D.:", as.character(data_test$Y[i]), 
                                     " - Pr.D.:", predicted[errors[i]]), col = CUSTOM_COLORS(256))
}


#------------------------- End: Train a Support Vector Machine ------------------------------#







