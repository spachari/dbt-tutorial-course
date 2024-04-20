{% snapshot snapshot_name__distribution_centers %}

{{
   config(
       target_database='neon-reporter-418319',
       target_schema='dbt_snapshot',
       unique_key='id',

       strategy='check',
       check_cols=['name', 'latitude', 'longitude']
   )
}}

select 
id,
name,
latitude,
longitude
 from {{ source('thelook_ecommerce', 'distribution_centers') }}

{% endsnapshot %}