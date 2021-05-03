# ---------------------------------------------
#
# height & weight
# Body Surface Area (BSA) (Dubois and Dubois) = 
# 0.007184 x (patient height in cm)0.725 x (patient weight in kg)0.425
#

# height
h5readAttributes(h5.fn,"f.50/f.50")
height =  h5read(h5.fn,"f.50/f.50")
rownames(height) = sample.id[,1]
height = height[df$sample.id,]
height.2 = height[,3]

height.2[which(height.2 == -9999)]  <- height[which(height.2 == -9999),][,1]
any(height.2 == -9999)

height = height.2
all(df$sample.id == names(height))
df$height = height

# weight
weight =  h5read(h5.fn,"f.21002/f.21002")
rownames(weight) = sample.id[,1]
weight = weight[df$sample.id,]
weight.2 = weight[,3]

weight.2[which(weight.2 == -9999)]  <- weight[which(weight.2 == -9999),][,1]
any(weight.2 == -9999)

weight = weight.2
all(df$sample.id == names(weight))
df$weight = weight

df$bsa =  0.007184*(df$height^0.725) * (df$weight^0.425)
df$bsa.2 =  sqrt(df$height*df$weight/3600)
df$bmi = df$weight/(df$height/100)^2

hist(df$bsa)
