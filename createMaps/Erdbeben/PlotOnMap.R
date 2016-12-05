#
#    http://www.exegetic.biz/blog/category/science/earthquake/
#


# catalog <- read.csv(file.path("data", "earthquake-catalog.csv"), stringsAsFactors = FALSE)
catalog <- read.csv("2015_Magnitude-groesser-gleich-5.csv", stringsAsFactors = FALSE)

catalog <- catalog[c(12, 16, 17, 1, 2:5)]

require(ggplot2)
require(maps   )
require(grid   )

world.map <- map_data('world')

x11()

ggplot() +
geom_polygon(
   data = world.map,
   aes(x     = long,
       y     = lat,
       group = group),
   fill = "#EEEECC") +
geom_point(
    data  = catalog,
    alpha = 0.25,
    aes(x      = longitude,
        y      = latitude,
        size   = mag,
        colour = depth))  +
labs(x = NULL, y = NULL) +
scale_colour_gradient(
      "Depth [m]",
      high = "red") +
scale_size("Magnitude") +
coord_fixed(
  ylim = c(- 82.5,  87.5),
  xlim = c(-185  , 185  )) +
theme_classic() +
theme(
  axis.line        = element_blank(),
  axis.text        = element_blank(),
  axis.ticks       = element_blank(),
  plot.margin      = unit(c(3, 0, 0, 0),"mm"),
  legend.text      = element_text(size = 6),
  legend.title     = element_text(size = 8, face = "plain"),
  panel.background = element_rect(fill='#D6E7EF'))

Sys.sleep(1000)
