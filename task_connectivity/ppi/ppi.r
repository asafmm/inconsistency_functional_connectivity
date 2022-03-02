
library(glmnet)
library(dplyr)
library(lme4)
library(jtools)
library(sjPlot)

df = read.csv('C:/Users/ltfm/Documents/python/Asaf/inconsistency_functional_connectivity/task_connectivity/ppi/ppi_table_v1.csv')
df$Subject = factor(df$Subject)
df[, c(FALSE, rep(TRUE, 12))] = scale(df[, c(FALSE, rep(TRUE, 12))])
vmpfc = lmer('VMPFC ~  M1 + SMA + ConvMMI + M1*ConvMMI + SMA*ConvMMI + ConvTR + ConvSlope + ConvEndow (1|Subject)', data=df)
vstr = lmer('VSTR ~ M1 + SMA + ConvMMI + M1*ConvMMI + SMA*ConvMMI + ConvTR + ConvSlope + ConvEndow + (1|Subject)', data=df)
vmpfc_v1 = lmer('VMPFC ~  v1 + V1_R + ConvMMI + v1*ConvMMI + V1_R*ConvMMI + ConvRT + (1|Subject)', data=df)
vstr_v1 = lmer('VSTR ~  v1 + V1_R + ConvMMI + v1*ConvMMI + V1_R*ConvMMI + ConvRT + (1|Subject)', data=df)
tab_model(vmpfc, vstr, vmpfc_v1, vstr_v1)

vmpfc_lm = lm('VMPFC ~ v1 + V1_R + M1 + SMA + ConvMMI + v1*ConvMMI + V1_R*ConvMMI + M1*ConvMMI + SMA*ConvMMI', data=df)
pcc = lmer('PCC ~ v1 + V1_R + M1 + SMA + ConvMMI + v1*ConvMMI + V1_R*ConvMMI + M1*ConvMMI + SMA*ConvMMI + (1|Subject)', data=df)
acc = lmer('Kolling ~ v1 + V1_R + M1 + SMA + ConvMMI + v1*ConvMMI + V1_R*ConvMMI + M1*ConvMMI + SMA*ConvMMI + (1|Subject)', data=df)

# small models
vmpfc_m1 = lmer('VMPFC ~ M1 + ConvMMI + M1*ConvMMI + (1|Subject)', data=df)
vmpfc_sma = lmer('VMPFC ~ SMA + ConvMMI + SMA*ConvMMI + (1|Subject)', data=df)
vstr_m1 = lmer('VSTR ~ M1 + ConvMMI + M1*ConvMMI + (1|Subject)', data=df)
vstr_sma = lmer('VSTR ~ SMA + ConvMMI + SMA*ConvMMI + (1|Subject)', data=df)
tab_model(vmpfc_m1, vmpfc_sma, vstr_m1, vstr_sma)

# inverse models
sma = lmer('SMA ~ VMPFC + ConvMMI + VMPFC*ConvMMI + (1|Subject)', data=df)
m1 = lmer('M1 ~ VMPFC + ConvMMI + VMPFC*ConvMMI + (1|Subject)', data=df)

# motor task
df_motor = read.csv('C:/Users/ltfm/Documents/python/Asaf/inconsistency_functional_connectivity/task_connectivity/ppi/motor_ppi_table.csv')
df_motor$Subject = factor(df_motor$Subject)
df_motor[, c(FALSE, rep(TRUE, 7))] = scale(df_motor[, c(FALSE, rep(TRUE, 7))])
vmpfc = lmer('VMPFC ~ M1 + SMA + ConvMMI + M1*ConvMMI + SMA*ConvMMI + (1|Subject)', data=df_motor)
vstr = lmer('VSTR ~ M1 + SMA + ConvMMI + M1*ConvMMI + SMA*ConvMMI + (1|Subject)', data=df_motor)
pcc = lmer('PCC ~ M1 + SMA + ConvMMI + M1*ConvMMI + SMA*ConvMMI + (1|Subject)', data=df_motor)
acc = lmer('Kolling ~ M1 + SMA + ConvMMI + M1*ConvMMI + SMA*ConvMMI + (1|Subject)', data=df_motor)
tab_model(vmpfc, vstr, pcc, acc)