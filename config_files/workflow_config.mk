# Configuration for ABARES wheat-sheep region analysis

VAR=pr
UNITS=${VAR}='mm day-1'

SHAPEFILE=/home/599/dbi599/wheatbelt/shapefiles/wheat_sheep.zip
REGION=wheat-sheep
SUB_REGION=all
SHP_HEADER=region
SPATIAL_AGG=mean

TIME_FREQ=A-DEC
TIME_AGG=sum

BIAS_METHOD=additive
BASE_PERIOD=2004-01-01 2019-12-31

GENERAL_IO_OPTIONS=--variables ${VAR} --spatial_coords -44 -11 113 154 
TIME_IO_OPTIONS=--time_freq ${TIME_FREQ} --time_agg ${TIME_AGG} --complete_time_agg_periods 
SPATIAL_IO_OPTIONS=--shapefile ${SHAPEFILE} --shp_header ${SHP_HEADER} --combine_shapes --spatial_agg ${SPATIAL_AGG}
FCST_IO_OPTIONS=${GENERAL_IO_OPTIONS} ${TIME_IO_OPTIONS} ${SPATIAL_IO_OPTIONS} --units ${UNITS} --units_timing middle --input_freq D
OBS_IO_OPTIONS=${GENERAL_IO_OPTIONS} ${TIME_IO_OPTIONS} ${SPATIAL_IO_OPTIONS} --input_freq M

FCST_DATA_1990S := $(sort $(wildcard /g/data/xv83/dcfp/CAFE-f6/c5-d60-pX-f6-199[5,6,7,8,9]*/atmos_isobaric_daily.zarr.zip))
FCST_DATA_2000S := $(sort $(wildcard /g/data/xv83/dcfp/CAFE-f6/c5-d60-pX-f6-2*/atmos_isobaric_daily.zarr.zip))
FCST_DATA := ${FCST_DATA_1990S} ${FCST_DATA_2000S}
FCST_METADATA=/home/599/dbi599/unseen/config/dataset_cafe_daily.yml
FCST_CLIMATOLOGY=/g/data/xv83/dbi599/ag/data/${VAR}_cafe-c5-d60-pX-f6_2004-2019_annual-climatology.zarr.zip
FCST_ENSEMBLE_FILE=/g/data/xv83/dbi599/ag/data/${VAR}_cafe-c5-d60-pX-f6_19950501-20201101_${TIME_FREQ}_${REGION}-${SPATIAL_AGG}.zarr.zip

OBS_DATA=/g/data/ia39/agcd/post-processed/data/agcd_v2_precip_total_cafe-grid_monthly_1900-2020.zarr.zip
OBS_METADATA=/home/599/dbi599/unseen/config/dataset_agcd_monthly.yml
OBS_PROCESSED_FILE=/g/data/xv83/dbi599/ag/data/${VAR}_agcd_1900-2019_${TIME_FREQ}_${REGION}-${SPATIAL_AGG}.zarr.zip

FCST_BIAS_FILE=/g/data/xv83/dbi599/ag/data/${VAR}_cafe-c5-d60-pX-f6_19950501-20191101_${TIME_FREQ}_${REGION}-${SPATIAL_AGG}_bias-corrected-agcd-${BIAS_METHOD}.zarr.zip
SIMILARITY_FILE=/g/data/xv83/dbi599/ag/data/ks-test_${VAR}_cafe-c5-d60-pX-f6_19950501-20191101_${TIME_FREQ}_${REGION}-${SPATIAL_AGG}_bias-corrected-agcd-${BIAS_METHOD}.zarr.zip

INDEPENDENCE_PLOT=/g/data/xv83/dbi599/ag/figures/independence-test_${VAR}_cafe-c5-d60-pX-f6_19950501-20191101_${TIME_FREQ}_${REGION}-${SUB_REGION}-${SPATIAL_AGG}_bias-corrected-agcd-${BIAS_METHOD}.png
INDEPENDENCE_OPTIONS=--spatial_selection region=${SUB_REGION}

DASK_CONFIG=dask_local.yml



