# BigQuery Machine Learning Exercise

This is an BigQuery Machine Learning (BQML). In this exercise you will have to:

- Train BQML Model
- Evaluate BQML Model
- Predict on new data using the trained BQML model. 

### Explore the Data
First navigate to the console (https://www.console.cloud.google.com) -> BigQuery. This will take you to the BigQuery editor from where you can write your SQL. We will be using a public Google Analytics dataset:

    bigquery-public-data.google_analytics_sample.ga_sessions_*`

If your not sure what to write use the following statement as  starting point:

    SELECT geoNetwork.country, ifnull(totals.transactions,0) as transaction, count(visitId) as visits
    FROM `bigquery-public-data.google_analytics_sample.ga_sessions_*`
    WHERE _TABLE_SUFFIX BETWEEN '20170701' AND '20170801'
    group by geoNetwork.country, transaction
    ORDER BY country desc
    LIMIT 100

### Train BigQuery Model
Now we can train a model using the Google Analytics dataset. Have a look at the BigQuery Machine Learning documentation to figure out how you can use SQL to train the model. Make sure you use the following SELECT statement as the foundation of your statement:

    SELECT
        IF(totals.transactions IS NULL, 0, 1) AS label,
        IFNULL(geoNetwork.country, "") AS country,
        IFNULL(totals.pageviews, 0) AS pageviews,
        IFNULL(device.operatingSystem, "") AS os,
        IF(device.isMobile,1,0) AS is_mobile
    FROM
        `bigquery-public-data.google_analytics_sample.ga_sessions_*`
    WHERE
        _TABLE_SUFFIX BETWEEN '20160801' AND '20170631'
        LIMIT 100000;

When you look at the provides SELECT statement you will notice that this is where we specify our label feature:

    IF(totals.transactions IS NULL, 0, 1) AS label,

### Evaluate BQML Model
After training the model we have to evaluate it's performance. Again go to the documentation and write the SQL statement to evaluate your model. Use the following SELECT statement as your base:

    SELECT
        IF(totals.transactions IS NULL, 0, 1) AS label,
        IFNULL(device.operatingSystem, "") AS os,
        IF(device.isMobile,1,0) AS is_mobile,
        IFNULL(geoNetwork.country, "") AS country,
        IFNULL(totals.pageviews, 0) AS pageviews
    FROM
        `bigquery-public-data.google_analytics_sample.ga_sessions_*`
    WHERE
        _TABLE_SUFFIX BETWEEN '20170701' AND '20170801'));

### Get predictions using BQML 
If the model performance is good we can go and use the trained model to get predictions. Run the following statement in the interface, but first you have to change: kfp-primer-workshop.marketing_data.bq_model`. Specify the SQL statement to use your trained model.  

    SELECT
        country,
    SUM(predicted_label) as total_predicted_purchases
    FROM
        ml.PREDICT(MODEL `kfp-primer-workshop.marketing_data.bq_model`, (
    SELECT
        IFNULL(device.operatingSystem, "") AS os,
        IF(device.isMobile,1,0) AS is_mobile,
        IFNULL(totals.pageviews, 0) AS pageviews,
        IFNULL(geoNetwork.country, "") AS country
    FROM
        `bigquery-public-data.google_analytics_sample.ga_sessions_*`
    WHERE
        _TABLE_SUFFIX BETWEEN '20170701' AND '20170801'))
    GROUP BY country
    ORDER BY total_predicted_purchases DESC
    LIMIT 10;