# cursor_poc

A dbt Core project for BigQuery demonstrating modern data transformation practices.

## Project Overview

This project showcases:
- BigQuery-optimized models with partitioning and clustering
- Data quality testing and documentation
- Model dependencies and transformations
- BigQuery-specific SQL functions

## Prerequisites

- dbt Core 1.11.11+ installed
- Google Cloud Platform account with BigQuery access
- Service account key file for authentication

## Setup

1. **Configure your BigQuery connection** in `~/.dbt/profiles.yml`:
   - Update `project` with your GCP project ID
   - Update `dataset` with your preferred dataset name
   - Verify the `keyfile` path points to your service account key

2. **Test your connection**:
   ```bash
   dbt debug
   ```

3. **Run the project**:
   ```bash
   dbt run
   ```

4. **Run tests**:
   ```bash
   dbt test
   ```

## Project Structure

```
cursor_poc/
├── models/
│   └── example/
│       ├── my_first_dbt_model.sql    # Sample user table with BigQuery optimizations
│       ├── my_second_dbt_model.sql   # Aggregated statistics
│       └── schema.yml                # Tests and documentation
├── dbt_project.yml                   # Project configuration
└── README.md
```

## Models

### my_first_dbt_model
- **Materialization**: Table with partitioning by `created_at` and clustering by `id`
- **Purpose**: Sample user data with derived fields
- **Features**: BigQuery-specific functions and optimizations

### my_second_dbt_model
- **Materialization**: View
- **Purpose**: Aggregated user statistics by year
- **Dependencies**: References `my_first_dbt_model`

## BigQuery Features Used

- **Partitioning**: Daily partitioning on timestamp field
- **Clustering**: Clustering on ID field for better query performance
- **BigQuery Functions**: `current_timestamp()`, `extract()`, `split()`, `array_agg()`, `string_agg()`

## Resources

- [dbt Documentation](https://docs.getdbt.com/docs/introduction)
- [BigQuery dbt Adapter](https://docs.getdbt.com/reference/warehouse-profiles/bigquery-profile)
- [dbt Community](https://community.getdbt.com/)
