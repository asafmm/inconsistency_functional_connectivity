
library(glmnet)
library(dplyr)
library(lme4)
library(jtools)
library(sjPlot)

## OLS for aggregated MMI
Ys = read.csv('C:/Users/Asaf/Documents/python/phd/inconsistency_functional_connectivity/task_connectivity/aggregated_y_for_R.csv')
X = read.csv('C:/Users/Asaf/Documents/python/phd/inconsistency_functional_connectivity/task_connectivity/task_fc_motor_value.csv')
X[,c(FALSE, FALSE, rep(TRUE, 15))] = scale(X[,c(FALSE, FALSE, rep(TRUE, 15))])
df = merge(X, Ys, by.x = c('Subject'), by.y=c('Subject'))
lm_model = lm('logMMI ~ VSTR__SMA+M1__SMA+M1__Kolling+VMPFC__Kolling', data=df)
lm_model_all = lm('logMMI ~ VSTR__PCC+VSTR__SMA+M1__PCC+VMPFC__VSTR+SMA__PCC+Kolling__PCC+Kolling__SMA+Kolling__VSTR+M1__SMA+M1__VSTR+M1__Kolling+VMPFC__PCC+VMPFC__SMA+VMPFC__Kolling+VMPFC__M1', df)
tab_model(lm_model, lm_model_all)


## Mixed effects for average MMI per block
Ys = read.csv('C:/Users/Asaf/Documents/python/phd/inconsistency_functional_connectivity/task_connectivity/trial_data/group_by_block.csv')
Y = Ys[,c('Subject', 'block', 'RT', 'logMMI')]
X = read.csv('C:/Users/Asaf/Documents/python/phd/inconsistency_functional_connectivity/task_connectivity/task_fc_motor_value_per_block.csv')
X[,c(FALSE, FALSE, rep(TRUE, 15))] = scale(X[,c(FALSE, FALSE, rep(TRUE, 15))])
df = merge(X, Y, by.x = c('Subject', 'block_vec'), by.y=c('Subject','block'))
model_big = lmer('logMMI ~ VSTR__PCC + VSTR__SMA + M1__PCC + VMPFC__VSTR + (1|Subject)', df)

model_all = lmer('logMMI ~ VSTR__PCC+VSTR__SMA+M1__PCC+VMPFC__VSTR+SMA__PCC+Kolling__PCC+Kolling__SMA+Kolling__VSTR+M1__SMA+M1__VSTR+M1__Kolling+VMPFC__PCC+VMPFC__SMA+VMPFC__Kolling+VMPFC__M1+ (1|Subject)', df)
model_small = lmer('logMMI ~ (1|Subject)', df)
tab_model(model_all, model_big, model_small)
