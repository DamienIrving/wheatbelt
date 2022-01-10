.PHONY: process-obs process-forecast bias-correction similarity-test independence-test define-regions final-analysis help

include ${CONFIG}

PLOT_PARAMS=plotparams_publication.yml
	
## process-obs : preprocessing of observational data
process-obs : ${OBS_PROCESSED_FILE}
${OBS_PROCESSED_FILE} : ${OBS_DATA} ${OBS_METADATA}
	fileio $< $@ --metadata_file $(word 2,$^) ${OBS_IO_OPTIONS}

## process-forecast : preprocessing of CAFE forecast ensemble
process-forecast : ${FCST_ENSEMBLE_FILE}
${FCST_ENSEMBLE_FILE} : ${FCST_METADATA}
	fileio ${FCST_DATA} $@ --forecast --metadata_file $< ${FCST_IO_OPTIONS} --reset_times --output_chunks lead_time=50 --dask_config ${DASK_CONFIG}

## bias-correction : bias corrected forecast data using observations
bias-correction : ${FCST_BIAS_FILE}
${FCST_BIAS_FILE} : ${FCST_ENSEMBLE_FILE} ${OBS_PROCESSED_FILE}
	bias_correction $< $(word 2,$^) ${VAR} ${BIAS_METHOD} $@ --base_period ${BASE_PERIOD} --rounding_freq A

## similarity-test : similarity test between observations and bias corrected forecast
similarity-test : ${SIMILARITY_FILE}
${SIMILARITY_FILE} : ${FCST_BIAS_FILE} ${OBS_PROCESSED_FILE}
	similarity $< $(word 2,$^) ${VAR} $@ --reference_time_period ${BASE_PERIOD}

## independence-test : independence test for different lead times
independence-test : ${INDEPENDENCE_PLOT}
${INDEPENDENCE_PLOT} : ${FCST_BIAS_FILE}
	independence $< ${VAR} $@ ${INDEPENDENCE_OPTIONS}

## define-regions : define the wheat-sheep regions
define-regions : define_regions.ipynb
define_regions.ipynb : abares.zip ${FCST_CLIMATOLOGY}
	papermill -p abares_shapefile $< -p agcd_file ${OBS_DATA} -p agcd_config ${OBS_METADATA} $@ $@

## final-analysis : do the final analysis
final-analysis : ag_analysis_${SUB_REGION}.ipynb
ag_analysis_${SUB_REGION}.ipynb : ag_analysis.ipynb    
	papermill -p agcd_file ${OBS_PROCESSED_FILE} -p cafe_file ${FCST_ENSEMBLE_FILE} -p cafe_bc_file ${FCST_BIAS_FILE} -p fidelity_file ${SIMILARITY_FILE} -p independence_plot ${INDEPENDENCE_PLOT} -p region ${SUB_REGION} $< $@

## help : show this message
help :
	@echo 'make [target] [-Bnf] CONFIG=config_file.mk'
	@echo ''
	@echo 'valid targets:'
	@grep -h -E '^##' ${MAKEFILE_LIST} | sed -e 's/## //g' | column -t -s ':'
