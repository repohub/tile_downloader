# tile_downloader - Google maps tile downloader shell script
===============
This script downloads tiles from google maps and glues them together into one png file.


# Requirements
===============
- curl
- python installation
- imagemagick -> montage


# Usage
===============
- >>sh tile_downloader.sh 52.540266,13.372547 52.518545,13.448078 18 s
- >>sh tile_downloader.sh left_upper_corner right_lower_corner zoom_level map_or_satellite
- Coordinates from google maps -> right click in designated area -> What's here?

## Zoom level für Map
- 20 - 5m
- 19 - 5m
- 18 - 20m/100ft
- 17 - 20m/50ft
- 16 - 50m
- 15 - 100m
- 14 - 200m
- 13 - 500m
- 12 - 1km
- 11 - 2km
- 10 - 5km
- 9 - 10km
- 8 - 20km/10Meilen
- 7 - 20km/20Meilen
- 6 - 50km
- 5 - 100km
- 4 - 200km
- 3 - 500km
- 2 - 1000km
- 1 - 2000km
