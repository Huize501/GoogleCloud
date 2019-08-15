gcloud ai-platform jobs submit training marketing_v1_97s \
   --staging-bucket=gs://huize501 \
   --region=us-central1 \
   --module-name=trainer.task \
   --package-path=trainer \
   --runtime-version 1.14 \
   --python-version 3.5 \
   -- \
   --pathdata gs://erwinh-mldemo/scikit/marketing-data.csv \
   --pathoutput gs://erwinh-mldemo/scikit/model \
   --storage BQ \
   --bqtable erwinh-mldemo.marketing.marketing_propensity_main