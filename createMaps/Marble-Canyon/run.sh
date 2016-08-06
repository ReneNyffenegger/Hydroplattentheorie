#  Input file
#    MarbleCanyon_1s.nc
#  created with:
#    https://github.com/ReneNyffenegger/about-GMT/blob/master/SRTM/create-Marble-Canyon-grid.sh

SRTM_DATA_DIR=~/Digitales-Backup/Development/datasets/GeoSpatial-etc/SRTM/
NC=${SRTM_DATA_DIR}FINALs/MarbleCanyon_1s.nc


LVL_GRAND_LAKE=1710
LVL_HOPI_LAKE=1790

if [ ! -e $NC ]; then
   echo $NC does not exist
   exit -1
fi

J_IMG=-JM8c
# J_PROFILE=-JX16c/10c
J_PROFILE=-JX10c/7c



grdsample $NC -I2s -Gimg.nc

 

grdgradient img.nc -Gimg.grad -A305 
grdhisteq   img.grad -N -Gimg.hist


grdimage img.hist $J_IMG -Cblack,white -K > MarbleCanyon_K.ps
# grdimage img.hist $J_IMG -Cblack,white    > MarbleCanyon.ps


cp MarbleCanyon_K.ps MarbleCanyon_GrandLake.ps
cp MarbleCanyon_K.ps MarbleCanyon_HopiLake.ps

grdcontour img.nc -C$LVL_GRAND_LAKE  $J_IMG  -W.2,blue  -S20 -O  >> MarbleCanyon_GrandLake.ps
grdcontour img.nc -C$LVL_HOPI_LAKE   $J_IMG  -W.2,green -S20 -O  >> MarbleCanyon_HopiLake.ps

# psconvert -W MarbleCanyon.ps           -Tg -FMarbleCanyon.png
psconvert -W MarbleCanyon_GrandLake.ps -Tg -FMarbleCanyon_GrandLake.png
psconvert -W MarbleCanyon_HopiLake.ps  -Tg -FMarbleCanyon_HopiLake.png


STEPS=200

cat <<F > grand-lake.lvl
0      $LVL_GRAND_LAKE
$STEPS $LVL_GRAND_LAKE
F

../createTrack.pl \
    -111 55  0    \
      36 13  0    \
    -111 34  6    \
      36 58  0    \
    $STEPS NS.track

../createTrack.pl \
    -111 53 52    \
      36 47 25    \
    -111 33 37    \
      36 36 08    \
    $STEPS WE.track

cp MarbleCanyon_K.ps MarbleCanyon_Tracks.ps
psxy $J_IMG -R-112.3/-111.5/35.95/37 -W0.5,red NS.track -O -K >> MarbleCanyon_Tracks.ps
psxy $J_IMG -R-112.3/-111.5/35.95/37 -W0.5,red WE.track -O    >> MarbleCanyon_Tracks.ps
psconvert -W MarbleCanyon_Tracks.ps -Tg -FMarbleCanyon_Tracks.png


grdtrack NS.track -Gimg.nc | awk '{print NR " " $3}' > NS.profile
psxy -R0/$STEPS/800/2500 $J_PROFILE NS.profile     -W2         -K    -B/200We  > NS-profile.ps
psxy -R                  $J_PROFILE grand-lake.lvl -W3,blue    -O             >> NS-profile.ps
psconvert -W NS-profile.ps -Tg -FNS-profile.png


grdtrack WE.track -Gimg.nc | awk '{print NR " " $3}' > WE.profile
psxy -R0/$STEPS/800/2500 $J_PROFILE WE.profile     -W2         -K    -B/200We  > WE-profile.ps
psxy -R                  $J_PROFILE grand-lake.lvl -W3,blue    -O             >> WE-profile.ps
psconvert -W WE-profile.ps -Tg -FWE-profile.png

mogrify -resize 600x600  MarbleCanyon_GrandLake.png  MarbleCanyon_HopiLake.png MarbleCanyon_Tracks.pngj
mogrify -resize 500x500  NS-profile.png  WE-profile.png 
