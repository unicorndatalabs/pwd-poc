# Basic PSQL Questions

These questions can be answered using a single query on a single table within the database.

There are a total of TBC questions grouped by area of focus:

* Initial Exploration
* Group By Aggregates
* String Manipulation
* ...

## Initial Exploration

You first show up and then someone asks you to "inspect" the data...here are a few sample questions that you might try to answer!

### Questions

1. Show the first 10 rows from the `actor` table ordered by actor_id
2. How many rows are there in the `actor` table?
3. How many distinct rows are there in the `actor` table?
4. What is the first name of the actor with `actor_id = 10`?
5. How many unique `name` records exist in the `category` table?
6. Write a query to return the first 10 non empty records of the `postal_code` column with a new alias `postcode` from the `address` table

### Answers

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

Notes:

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

6. Write a query to return the first 10 non empty records of the `postal_code` column with a new alias `postcode` from the `address` table

**Notes:**

* This is where our command `\pset null ¤` really comes in handy!
* Non empty usually relates to the `is not null` method used in a `where` filter but sometimes it can also refer to a blank string in a character data type column also: `where <field-name> = ''`

```sql
> select postal_code as postcode from address where postal_code is not null limit 10;
 
 count 
-------
    16
```

7. What is the earliest `release_year` from the `film` table?

```sql
> select min(release_year) from film;

 min  
------
 2006
```

## Group By Aggregations

### Questions

### Answers

## String Operations

### Questions

### Answers

What is the full name of the actor with `actor_id = 10`?

```sql
> select concat(first_name, ' ', last_name) as full_name from actor where actor_id = 10;
 
 first_name 
------------
 CHRISTIAN GABLE
(1 row)
```


5. What is the most common actor `last_name`?
6. What is the most common 1st letter in `first_name`?
7. What is the most common 2nd letter in `first_name`?
8. What is the most common last letter in `first_name`?
9. How many characters is the longest `last_name`?
10. What is the longest `last_name`?



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

What is most common 3 letter combination from `first_name`?

```sql


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