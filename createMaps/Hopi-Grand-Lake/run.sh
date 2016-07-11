grdcut /var/tmp/about-GMT/SRTM/Grand-Canyon-and-Hopi-Lake.nc -R-114/-107.5/34.4/40 -GHopi-Grand-Lake.nc -V

# grdsample Hopi-Grand-Lake_.nc -I800+/689+ -GHopi-Grand-Lake.nc
# cp Hopi-Grand-Lake_.nc Hopi-Grand-Lake.nc

# LVL_GRAND_LAKE=1810
LVL_GRAND_LAKE=1710
LVL_HOPI_LAKE=1790


cat << CONT > contour.d
1500 A
# 1600 C
# 1700 C
$LVL_GRAND_LAKE A
$LVL_HOPI_LAKE A
# 1800 C
# 1900 C
2000 A
# 2100 C
# 2200 C
# 2300 C
# 2400 C
2500 A
2600 C
2700 C
CONT

function create_map() {

  LVL_LAKE=$1
  NAME_LAKE=$2


COLOR_LAKE=230-0.6-0.78
COLOR_GREEN_1500=120-0.55-0.70
COLOR_GREEN_1500_2000=120-0.60-0.80
COLOR_GREEN_2000_2500=120-0.65-0.90
COLOR_BROWN_2500_3000=35-0.65-0.65

COLOR_GRAY=0-0-0.5

if [[ $LVL_LAKE > 0 ]]; then

  COLOR_INTRO="
-1         $COLOR_LAKE	           $LVL_LAKE	 $COLOR_LAKE
$LVL_LAKE	 $COLOR_GREEN_1500_2000  2000        $COLOR_GREEN_1500_2000
"

else

  COLOR_INTRO="
0          $COLOR_GREEN_1500       1500        $COLOR_GREEN_1500
1500       $COLOR_GREEN_1500_2000  2000        $COLOR_GREEN_1500_2000
"

fi

cat << LAKE > lake_level.cpt
$COLOR_INTRO
2000       $COLOR_GREEN_2000_2500  2500        $COLOR_GREEN_2000_2500
2500       $COLOR_BROWN_2500_3000  3000        $COLOR_BROWN_2500_3000

B   0-0-0
F   0-0-1
N   0-0-0.5
LAKE
  
  grdgradient Hopi-Grand-Lake.nc -GHopi-Grand-Lake.grad -A305 
  
  grdmath Hopi-Grand-Lake.grad Hopi-Grand-Lake.nc $LVL_LAKE GT MUL = Hopi-Grand-Lake-without-lake.grad
# cp Hopi-Grand-Lake.grad Hopi-Grand-Lake-without-lake.grad
  
  grdhisteq Hopi-Grand-Lake-without-lake.grad -N -GHopi-Grand-Lake-without-lake.hist
  
# grdinfo Hopi-Grand-Lake-without-lake.hist
  
  grdmath Hopi-Grand-Lake-without-lake.hist 5.5 DIV = Hopi-Grand-Lake-without-lake.norm
  
  grdimage     Hopi-Grand-Lake.nc -Clake_level.cpt -IHopi-Grand-Lake-without-lake.norm       -Jx3c  > $NAME_LAKE.ps
# grdcontour   Hopi-Grand-Lake.nc -Ccontour.d      -A+r3c                                 -O -J    >> $NAME_LAKE.ps

# pslegend     -Dx4.5/0/6i/0.3i  << LEG                                                   -O       >> $NAME_LAKE.ps
# B lake_level.cpt 0c 0c
# LEG

  
# gv Hopi-Grand-Lake.ps
  
  psconvert $NAME_LAKE.ps -W -Tg -F$NAME_LAKE.png

  mogrify -resize 800x689! $NAME_LAKE.png

}

create_map $LVL_GRAND_LAKE Grand-Lake
create_map $LVL_HOPI_LAKE  Hopi-Lake
create_map  0              Grand-Canyon
