
library(lgrdata)
library(dplyr)
library(broom)
data(anthropometry)

# almost linear data
set.seed(1)
dat <- anthropometry %>% 
  filter(complete.cases(.),
         gender=='female') %>%
  sample_n(60) 

train_dat <- dat[1:30,]
test_dat <- dat[31:60,]

sp <-  seq(0.2, 0.9, length=5)
cols <- colorRampPalette(c("red2","blue2"))(length(sp))

with(train_dat, plot(age, foot_length))
for(i in seq_along(sp)){
  fit <- loess(foot_length ~ age, data=train_dat, span=sp[i])
  out <- augment(fit) %>% 
    arrange(age)
  with(out, lines(age, .fitted, col=cols[i]))
}



sp <-  seq(0.2, 0.99, length=20)
fits <- lapply(sp, function(x)loess(foot_length ~ age, data=train_dat, span=x, degree=2))

mse_train <- sapply(fits, function(x)mean((predict(x, newdata = train_dat) - train_dat$foot_length)^2))
mse_test <- sapply(fits, function(x)mean((predict(x, newdata = test_dat) - test_dat$foot_length)^2))

plot(sp, mse_train, ylim=c(0,400), type='l', col="blue", lwd=2)
lines(sp, mse_test, pch=19, col="red2", lwd=2)



with(train_dat, plot(age, foot_length))
out <- augment(fits[[which(sp == max(sp))]]) %>% 
  arrange(age)
with(out, lines(age, .fitted, col=cols[i]))

with(test_dat, plot(age, foot_length))
out <- augment(fits[[which(sp == max(sp))]]) %>% 
  arrange(age)
with(out, lines(age, .fitted, col=cols[i]))




# very non-linear data
data(fluxtower)
library(lubridate)

flux <- mutate(fluxtower, DateTime = dmy_hm(TIMESTAMP),
                     Date = as.Date(DateTime),
                     time = hour(DateTime) + minute(DateTime)/60) %>%
  filter(Date == as.Date("2009-2-24"))


sp <-  seq(0.15, 0.99, length=20)
fits <- lapply(sp, function(x){
  loess(Tair ~ time, data=flux, span=x, degree=2)
})

mse_train <- sapply(fits, function(x){
  mean((predict(x) - flux$Tair)^2)
})

plot(sp, mse_train)

library(nlshelper)
plot_loess(fits[[1]])
plot_loess(fits[[20]])



cross_leave_one <- function(sp){
  
  mse <- vector("numeric", length = nrow(flux))
  for(i in seq_len(nrow(flux))){
    
    fit_min_i <- loess(Tair ~ time, data=flux[-i,], span=sp, degree=2)
    pred_i <- predict(fit_min_i, newdata = flux[i,])
    mse[i] <- (pred_i - flux[i, "Tair"])^2
  }
return(sum(mse, na.rm=TRUE))
}

mse_test <- mapply(cross_leave_one, sp = sp)

plot(sp, log10(mse_train), ylim=c(-2,2.5))
points(sp, log10(mse_test), pch=19)


# My method identical to `crossval` from bootstrap package
library(bootstrap)

x <- crossval(flux$time, flux$Tair, 
              theta.fit=function(x,y, span)loess(y~x, span=span),
              theta.predict = function(fit, x)predict(fit, newdata=x),
              span=0.99)
sum((x$cv.fit - flux$Tair)^2, na.rm=T)
mse_test[sp == 0.99]



# need something in between!


