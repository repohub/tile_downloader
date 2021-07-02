#!/bin/bash
# infos from
# http://peterp.brandlehner.at/google-maps
# http://manialabs.wordpress.com/2013/01/26/converting-latitude-and-longitude-to-map-tile-in-mercator-projection/
# http://www.imagemagick.org/Usage/montage/

echo "
# usage
# >>sh tile_downloader.sh 52.537108,13.367386 52.526248,13.392105 18 s
# >>sh tile_downloader.sh linke_obere_Ecke rechte_untere_Ecke zoom_level map_or_satelite
# Koordinaten aus google maps -> "Was ist hier?"

# zoom level für Map 
# 20 - 5m
# 19 - 5m
# 18 - 20m/100ft
# 17 - 20m/50ft
# 16 - 50m
# 15 - 100m
# 14 - 200m
# 13 - 500m
# 12 - 1km
# 11 - 2km
# 10 - 5km
# 9 - 10km
# 8 - 20km/10Meilen
# 7 - 20km/20Meilen
# 6 - 50km
# 5 - 100km
# 4 - 200km
# 3 - 500km
# 2 - 1000km
# 1 - 2000km
"
if [[ -z $3 ]]; then
        exit 0
fi

rm -rf tmp
rm -f out.png
mkdir tmp
cd tmp

leftUp=$1 
rightDown=$2 
z=$3

# extract data leftUp
xlu=$(echo $leftUp | sed 's/\(^.*\),.*/\1/')
ylu=$(echo $leftUp | sed 's/^.*,\(.*\)/\1/')
echo $xlu
echo $ylu

# umrechnen in Mercatorprojektion
ytilelu=$(python -c "import math; latRad = math.radians(float($xlu)); rowIndex = math.log(math.tan(latRad) + (1.0 / math.cos(latRad))); rowNormalized = (1 - (rowIndex / math.pi)) / 2; tilesPerRow = 2 ** $z; row = round(rowNormalized * (tilesPerRow - 1)); print int(row)")

xtilelu=$(python -c "import math; lonRad = math.radians(float($ylu)); columnIndex = lonRad; columnNormalized = (1 + (columnIndex / math.pi)) / 2; tilesPerRow = 2 ** $z; column = round(columnNormalized * (tilesPerRow - 1)); print int(column)")
echo $xtilelu
echo $ytilelu

# extract data rightDown
xrd=$(echo $rightDown | sed 's/\(^.*\),.*/\1/')
yrd=$(echo $rightDown |sed 's/^.*,\(.*\)/\1/')
#echo $xrd
#echo $yrd

# extract zoom level
#echo $z

# umrechnen in Mercatorprojektion
ytilerd=$(python -c "import math; latRad = math.radians(float($xrd)); rowIndex = math.log(math.tan(latRad) + (1.0 / math.cos(latRad))); rowNormalized = (1 - (rowIndex / math.pi)) / 2; tilesPerRow = 2 ** $z; row = round(rowNormalized * (tilesPerRow - 1)); print int(row)")

xtilerd=$(python -c "import math; lonRad = math.radians(float($yrd)); columnIndex = lonRad; columnNormalized = (1 + (columnIndex / math.pi)) / 2; tilesPerRow = 2 ** $z; column = round(columnNormalized * (tilesPerRow - 1)); print int(column)")
echo $xtilerd
echo $ytilerd

divx=$(( $xtilerd-$xtilelu+1 ))
divy=$(( $ytilerd-$ytilelu+1 ))
echo $divx
echo $divy


# Satellite: https://khms1.google.com/kh/v=904&x=[ TILE-X ]&y=[ TILE-Y ]&z=[ ZOOM ]
# Map: http://mt0.google.com/vt/lyrs=m@146&hl=de&x=[ TILE-X ]&y=[ TILE-Y ]&z=[ ZOOM ]
# Terrain: http://mt1.google.com/vt/lyrs=t@126,r@146&hl=de&x=[ TILE-X ]&y=[ TILE-Y ]&z=[ ZOOM ]
# Transparent Map: http://mt0.google.com/vt/lyrs=h@146&hl=de&x=[ TILE-X ]&y=[ TILE-Y ]&z=[ ZOOM ]

echo "------"
for (( x=$xtilelu; x<=$xtilerd; x++ )); do
    for (( y=$ytilelu; y<=$ytilerd; y++ )); do
        if [[ $4 == "s" ]]; then
            curl  "https://khms1.google.com/kh/v=904&x=$x&y=$y&z=$z" -o "$y+$x.png"
            #https://khms1.google.com/kh/v=904?x=565087&y=348646&z=20
        else
            curl  "http://mt0.google.com/vt/lyrs=m@146&hl=de&x=$x&y=$y&z=$z" -o "$y+$x.png"
        fi
        #curl -s "https://khm0.google.at/kh/v=142&x=$x&y=$y&z=$z" -o "$y+$x.png"
        # curl -s "http://mt0.google.com/vt/lyrs=m@146&hl=de&x=$x&y=$y&z=$z" -o "$y+$x.png"
    done
done

echo "montage -tile $divyx$divx -geometry +0+0 *.png ../out.png"
montage -tile $divyx$divx -geometry +0+0 *.png ../out.png

open ../out.png