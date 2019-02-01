


library(lgrdata)
data(automobiles)
automobiles2 <- dplyr::filter(automobiles, !is.na(horsepower))

.seed <- 1

fit_full <- lm(fuel_efficiency ~ cylinders*engine_volume*horsepower*weight, data=automobiles2)
broom::glance(fit_full)
mean((automobiles2$fuel_efficiency - predict(fit_full))^2)


# - must remove missing values manually, otherwise crash (no options)
# - makes a bonus horrendous plot
# - unlike real R functions, only returns the data, not the actual results!
# - ok so this is horse shit
library(DAAG)
set.seed(.seed)
cv_fit_full <- DAAG::cv.lm(automobiles2,
                     fuel_efficiency ~ cylinders*engine_volume*horsepower*weight,
                     m = 10, printit=FALSE,
                     plotit=FALSE) # this does not even work


#- we have to define a function that takes a matrix of predictors.
# that's cool except how do we include interations easily? We don't!
# and since lm() MUST take a formula, we are forced to use lsfit, which has no predict method
#-no summary method, no print method, no methods!
library(bootstrap)
fit_function <- function(x,y)lsfit(x,y)
predict_function <- function(fit,x)cbind(1,x)%*%fit$coef

predictors <- data.matrix(automobiles2[,c("cylinders","engine_volume","horsepower","weight")])
response <- as.vector(automobiles2$fuel_efficiency)

set.seed(.seed)
cv_fit <- crossval(x = predictors,
                   y = response,
                   theta.fit = fit_function,
                   theta.predict = predict_function, 
                   ngroup = 10)

# --> test MSE
mean((automobiles2$fuel_efficiency - cv_fit$cv.fit)^2)


# - must refit model with `y` component. no big deal
# - seems quite slow compared to caret::train
fit_full2 <- lm(fuel_efficiency ~ cylinders*engine_volume*horsepower*weight, 
                data=automobiles2,
                y = TRUE, x = TRUE)
library(lmvar)
set.seed(.seed)
cv_fit_lv <- cv.lm(fit_full2, k = 10)

# --> test MSE
cv_fit_lv$MSE$mean


# - if your model is not included in caret, can't really use this approach
# for example, loess() is not included
library(caret)
set.seed(.seed)
cv_fit_cr <- train(
  fuel_efficiency ~ cylinders*engine_volume*horsepower*weight, 
  data = automobiles2,
  method = "lm",
  trControl = trainControl(
    method = "cv", 
    number = 10,
    verboseIter = FALSE
  )
)

# --> test MSE
(cv_fit_cr$results$RMSE)^2


# bonus
plot(varImp(cv_fit_cr))



# feature selection
# how do we add interactions???????
auto_predictors <- data.matrix(automobiles2[,5:ncol(automobiles2)])
fuel_efficiency <- as.vector(automobiles2$fuel_efficiency)

rf1 <- rfe(auto_predictors,
           fuel_efficiency,
           sizes=2:6,
           rfeControl = rfeControl(functions = lmFuncs,
                                   method = "cv", number = 10,
                                   rerank = TRUE))
plot(rf1, type='o', cex=1.2)           

rf1$optVariables




