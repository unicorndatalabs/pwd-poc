# PSQL Introduction

*(~5 minutes)*

This is a quick run through of pre-flight checks and introduction to Postgres

## Displaying Data

Sometimes columns can get too large for our terminal output - to avoid this we can turn on `Expanded display auto` to let `psql` decide which is the most intelligble format:

```sql
> \x auto

Expanded display is used automatically.
```

## Set the `NULL` character identifier

When working with data, null records are inevitable! By default in the `psql` prompt `NULL` values are actually rendered as blank strings `''` which can be confusing and lead to incorrect analyses!

We will set the `¤` character to show us the null values but this can be changed to anything else you like 

```sql
> \pset null ¤

Null display is "¤".
```

You can check that this works out by running the following:

```sql
> select postal_code from address limit 10;

 postal_code 
-------------
 ¤
 ¤
 ¤
 ¤
 35200
 17886
 83579
 53561
 42399
 18743
```

## Explain Plan Debugging

When we run basic `select * from actor` or similar queries, we are actually submitting them to the `psql` execution engine and the statements will run on actual data.

In practice, when datasets are sufficiently large, it is advisable to use the `explain` tool to generate an `explain plan` for the requested query as opposed to executing it there and then during the development and debugging stage.

In technical terms - instead of running the query and returning you data, the `explain plan` will return a tree of *plan nodes* with information about specific scan algorithms and aggregation operations.

There is also `explain analyze` which not only returns you the `explain plan` with the tree nodes, but it will also return the actual row counts of raw data which will be accessed by the query. This is quite useful in practice when you need to identify bottlenecks in slow running jobs to further optimise performance.

For now, we just need to ingrain some good habits for our SQL practice - make sure you are using the `explain` in front of queries you are not quite sure about so you can validate the syntax. In time we will cover exactly how to read an explain plan indepth as it is super important for larger datasets!

As our test datasets are relatively small - there is not too much that could go wrong should you forget to add explain in front of each query you submit!

👇👇 If you'd like to read more about `explain` and `explain analyze` click here:  
https://www.postgresql.org/docs/9.4/using-explain.html


## Inspecting Database Elements

We can easily inspect the contents of the database by running the handy `\d` command.

```sql
> \d 

                     List of relations
Schema |            Name            |   Type   |  Owner   
--------+----------------------------+----------+----------
 public | actor                      | table    | postgres
 public | actor_actor_id_seq         | sequence | postgres
 public | actor_info                 | view     | postgres
 public | address                    | table    | postgres
 public | address_address_id_seq     | sequence | postgres
 public | category                   | table    | postgres
 public | category_category_id_seq   | sequence | postgres
 public | city                       | table    | postgres
 public | city_city_id_seq           | sequence | postgres
 ...
  public | store_store_id_seq         | sequence | postgres
(41 rows)
```

You can also run `\dt` to only view tables

```sql
> \dt

              List of relations
 Schema |       Name       | Type  |  Owner   
--------+------------------+-------+----------
 public | actor            | table | postgres
 public | address          | table | postgres
 public | category         | table | postgres
 public | city             | table | postgres
 public | country          | table | postgres
 public | customer         | table | postgres
 public | film             | table | postgres
 public | film_actor       | table | postgres
 public | film_category    | table | postgres
 public | inventory        | table | postgres
 public | language         | table | postgres
 public | payment          | table | postgres
 public | payment_p2007_01 | table | postgres
 public | payment_p2007_02 | table | postgres
 public | payment_p2007_03 | table | postgres
 public | payment_p2007_04 | table | postgres
 public | payment_p2007_05 | table | postgres
 public | payment_p2007_06 | table | postgres
 public | rental           | table | postgres
 public | staff            | table | postgres
 public | store            | table | postgres
(21 rows)
```

Or `\dv` for only the views

```sql
> \dv

                   List of relations
 Schema |            Name            | Type |  Owner   
--------+----------------------------+------+----------
 public | actor_info                 | view | postgres
 public | customer_list              | view | postgres
 public | film_list                  | view | postgres
 public | nicer_but_slower_film_list | view | postgres
 public | sales_by_film_category     | view | postgres
 public | sales_by_store             | view | postgres
 public | staff_list                 | view | postgres
(7 rows)
```

Or `\ds` for the sequences

```sql
> \ds

                     List of relations
 Schema |            Name            |   Type   |  Owner   
--------+----------------------------+----------+----------
 public | actor_actor_id_seq         | sequence | postgres
 public | address_address_id_seq     | sequence | postgres
 public | category_category_id_seq   | sequence | postgres
 public | city_city_id_seq           | sequence | postgres
 public | country_country_id_seq     | sequence | postgres
 public | customer_customer_id_seq   | sequence | postgres
 public | film_film_id_seq           | sequence | postgres
 public | inventory_inventory_id_seq | sequence | postgres
 public | language_language_id_seq   | sequence | postgres
 public | payment_payment_id_seq     | sequence | postgres
 public | rental_rental_id_seq       | sequence | postgres
 public | staff_staff_id_seq         | sequence | postgres
 public | store_store_id_seq         | sequence | postgres
(13 rows)
```

You can also run `\d <relation-name>` to see more information about columns, indexes, keys, references and triggers for a specific table or view

```sql
> \d film

                                                Table "public.film"
        Column        |            Type             | Collation | Nullable |                Default                
----------------------+-----------------------------+-----------+----------+---------------------------------------
 film_id              | integer                     |           | not null | nextval('film_film_id_seq'::regclass)
 title                | character varying(255)      |           | not null | 
 description          | text                        |           |          | 
 release_year         | year                        |           |          | 
 language_id          | smallint                    |           | not null | 
 original_language_id | smallint                    |           |          | 
 rental_duration      | smallint                    |           | not null | 3
 rental_rate          | numeric(4,2)                |           | not null | 4.99
 length               | smallint                    |           |          | 
 replacement_cost     | numeric(5,2)                |           | not null | 19.99
 rating               | mpaa_rating                 |           |          | 'G'::mpaa_rating
 last_update          | timestamp without time zone |           | not null | now()
 special_features     | text[]                      |           |          | 
 fulltext             | tsvector                    |           | not null | 
Indexes:
    "film_pkey" PRIMARY KEY, btree (film_id)
    "film_fulltext_idx" gist (fulltext)
    "idx_fk_language_id" btree (language_id)
    "idx_fk_original_language_id" btree (original_language_id)
    "idx_title" btree (title)
```