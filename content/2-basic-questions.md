# Basic PSQL Examples

This SQL reference guide covers various examples across a wide range of scenarios.

You can refer to this guide anytime you get stuck or forget how to perform a certain action.

There are links to related `Postgres` documentation pages for more details!

## SQL Operation Categories

* [Data Exploration](#Data-Exploration)
* [Math Functions]
* [Aggregate Functions](#Aggregate-Functions)
* String Manipulation
* Group By
* Joins
* Window Functions
    - Ranking Methods
    - Applied Aggregates
    - Rowwise Operations
* Regular Expressions
* Indexing & Primary Keys
* User Defined Functions

## Data Exploration

1. Show the first 10 rows from the `actor` table ordered by actor_id

```sql
> select * from actor order by actor_id limit 10;
 
 actor_id | first_name |  last_name   |     last_update     
----------+------------+--------------+---------------------
        1 | PENELOPE   | GUINESS      | 2006-02-15 04:34:33
        2 | NICK       | WAHLBERG     | 2006-02-15 04:34:33
        3 | ED         | CHASE        | 2006-02-15 04:34:33
        4 | JENNIFER   | DAVIS        | 2006-02-15 04:34:33
        5 | JOHNNY     | LOLLOBRIGIDA | 2006-02-15 04:34:33
        6 | BETTE      | NICHOLSON    | 2006-02-15 04:34:33
        7 | GRACE      | MOSTEL       | 2006-02-15 04:34:33
        8 | MATTHEW    | JOHANSSON    | 2006-02-15 04:34:33
        9 | JOE        | SWANK        | 2006-02-15 04:34:33
       10 | CHRISTIAN  | GABLE        | 2006-02-15 04:34:33
```

2. How many rows are there in the `actor` table?

```sql
> select count(*) from actor;
 
 count 
-------
   200
```

3. How many distinct rows are there in the `actor` table?

**Notes:**

* Use of a subquery requires an alias
* There is no way to run `count(distinct *)` within `PSQL`

```sql
> select count(*) from (select distinct * from actor) a;
 
 count 
-------
   200
```

4. What is the first name of the actor with `actor_id = 10`?

```sql
> select first_name from actor where actor_id = 10;
 
 first_name 
------------
 CHRISTIAN
```

5. How many unique `name` records exist in the `category` table?

```sql
> select count(distinct name) from category;
 
 count 
-------
    16
```

6. Return the unique number of non null records of `postal_code` as a new column with a alias `unique_postcodes` from the `address` table

```sql
> select count(distinct postal_code) as unique_postcodes from address where postal_code is not null;
 
 unique_postcodes 
------------------
              596
```

## Basic Math & Date Functions

How many days has it been since the `film` table was last updated (`last_update`)?

**Note:**

* `current_date` returns a flexible date/timestamp/year object for use with other date types in `Postgres`

```sql
> select extract(day from current_date - max(last_update)) as days_since_last_update from film;

 days_since_last_update 
------------------------
                   5302
```

Write a query that returns the number of years since a film has been released and show the top 5 most recent films ordered by `title`

```sql
> select title, extract(year from current_date) - release_year as years_since_release from film order by years_since_release, title limit 5;

      title       | years_since_release 
------------------+---------------------
 ACADEMY DINOSAUR |                  14
 ACE GOLDFINGER   |                  14
 ADAPTATION HOLES |                  14
 AFFAIR PREJUDICE |                  14
 AFRICAN EGG      |                  14

```

Write a query that shows the top 10 records for a `cost_difference` column which is the difference between `replacement_cost` and `rental_rate` from the `film` table rounded to 1 decimal place

```sql
> select round(replacement_cost - rental_rate, 1) as cost_difference from film limit 10;

```

Write a query to return the `title`, `length` and a new `hour_length` column with `length` rounded to the nearest hour and show only the 5 longest movies

```sql
> select title, length, round(length / 60) as hour_length from film order by length desc limit 5;

     title      | length | hour_length 
----------------+--------+-------------
 DARN FORRESTER |    185 |           3
 GANGS PRIDE    |    185 |           3
 CONTROL ANTHEM |    185 |           3
 CHICAGO NORTH  |    185 |           3
 HOME PITY      |    185 |           3
```

## Aggregation Functions

7. What is the earliest `release_year` from the `film` table?

```sql
> select min(release_year) from film;

 min  
------
 2006
```

8. What is the total sum of movie `length` from the `film` table?

```sql
> select sum(length) from film;

  sum   
--------
 115272
```

9. What is the average `rental_duration` from the `film` table?

```sql
> select avg(rental_duration) from film;

        avg         
--------------------
 4.9850000000000000
```


## Group By Aggregations

### Questions

### Answers

## String Operations

### Questions

* What is the most common actor `last_name`?
* What is the most common 1st letter in `first_name`?
* What is the most common 2nd letter in `first_name`?
* What is the most common last letter in `first_name`?
* How many characters is the longest `last_name`?
* What is the longest `last_name`?

### Answers

What is the full name of the actor with `actor_id = 10`?

```sql
> select concat(first_name, ' ', last_name) as full_name from actor where actor_id = 10;
 
 first_name 
------------
 CHRISTIAN GABLE
(1 row)
```

What is the most common actor `last_name`?

```sql
> select last_name, count(*) from actor group by 1 order by 2 desc limit 1;
 
 last_name | count 
-----------+-------
 KILMER    |     5
```

What is the most common starting letter in `first_name`?

```sql
> select left(first_name, 1), count(*) from actor group by 1 order by 2 desc limit 1;
 
 left | count 
------+-------
 J    |    23
 ```

What is the most common 2nd letter in `first_name`?

```sql
> select substring(first_name, 2, 1), count(*) from actor group by 1 order by 2 desc limit 1;
 
 left | count 
------+-------
 A    |    46
 ```

What is the most common last letter in `first_name`?
```sql
> select right(first_name, 1), count(*) from actor group by 1 order by 2 desc limit 1;
 
 left | count 
------+-------
 N    |    36
 ```

How many characters is the longest `last_name`?

```sql
> select max(length(last_name)) from actor;
 
 max 
-----
  12
(1 row)
 ```

 What is the longest `last_name`?

 ```sql
> select last_name, length(last_name) as last_name_length from actor group by 1 order by 2 desc limit 1;
 
  last_name   | last_name_length 
--------------+------------------
 LOLLOBRIGIDA |               12
 ```

7. What is the 2nd most common actor `first_name`?

Sub-query method

```sql
select * from (
    select
        last_name,
        rank() over (order by counts desc) as count_rank
    from (
        select
            last_name,
            count(*) as counts
        from actor
        group by 1
    ) t1 
) t2
where count_rank = 2
;

 last_name | count_rank 
-----------+------------
 TEMPLE    |          2
 NOLTE     |          2
(2 rows)
```

Alternative CTE Method

```sql
with last_name_counts as (
    select
            last_name,
            count(*) as counts
        from actor
        group by 1
)
select * from (
    select
        last_name,
        rank() over (order by counts desc) as count_rank
    from last_name_counts
    ) t
where count_rank = 2
;

 last_name | count_rank 
-----------+------------
 TEMPLE    |          2
 NOLTE     |          2
(2 rows)
```