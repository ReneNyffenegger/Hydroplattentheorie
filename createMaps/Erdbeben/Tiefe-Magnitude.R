quakes <- read.csv("2015_Magnitude-groesser-gleich-5.csv", stringsAsFactors = FALSE)
quakes <- quakes[c('depth', 'mag')]

quakes$mag = jitter(quakes$mag, 8)

x11()

plot(
  quakes$depth, quakes$mag,
  xlab='Tiefe', ylab='Magnitude',
  type='p', cex=1.0, pch=21, bg='blue',
  main='Erdbeben 2015')

z <- locator(1)
