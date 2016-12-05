quakes <- read.csv("2015_Magnitude-groesser-gleich-5.csv", stringsAsFactors = FALSE)

depths <- quakes[c('depth')]$depth

x11()

hist(depths, main='Erdbebentiefen (2015, Mag >= 5)', xlab='Tiefe (km)', ylab='')
z <- locator(1)

depths <- depths[depths > 100]

hist(depths, main='Erdbebentiefen (2015, Mag >= 5, Tiefe>100 km)', xlab='Tiefe (km)', ylab='')
z <- locator(1)
