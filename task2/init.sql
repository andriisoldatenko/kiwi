CREATE TABLE crew_members (
    id serial NOT NULL PRIMARY KEY,
    first_name varchar(10) NOT NULL,
    last_name varchar(10) NOT NULL,
    date_of_birth date NOT NULL
    -- Create index on date_of_birth
);

-- It's better to create index because we use crew_members.date_of_birth
-- in different group by actions
/*
EXPLAIN ANALYZE select first_name as rnum from crew_members order by date_of_birth limit 1 offset 0;
*/

CREATE INDEX crew_members_date_of_birth_index ON crew_members(date_of_birth);
/*
postgres=# \d crew_members
                                    Table "public.crew_members"
    Column     |         Type          |                         Modifiers
---------------+-----------------------+-----------------------------------------------------------
 id            | integer               | not null default nextval('crew_members_id_seq'::regclass)
 first_name    | character varying(10) | not null
 last_name     | character varying(10) | not null
 date_of_birth | date                  | not null
Indexes:
    "crew_members_pkey" PRIMARY KEY, btree (id)
    "crew_members_date_of_birth_index" btree (date_of_birth)
Referenced by:
    TABLE "crew_member_aircraft" CONSTRAINT "crew_member_aircraft_crew_member_id_fkey" FOREIGN KEY (crew_member_id) REFERENCES crew_members(id) DEFERRABLE INITIALLY DEFERRED
*/

CREATE TABLE aircrafts (
    id serial NOT NULL PRIMARY KEY,
    name varchar(40) NOT NULL,
    discription varchar(300) NOT NULL
);

CREATE TABLE crew_member_aircraft (
    crew_member_id integer references crew_members deferrable initially deferred,
    aircraft_id integer references aircrafts deferrable initially deferred,
    UNIQUE (crew_member_id, aircraft_id),
    updated  TIMESTAMP WITH TIME ZONE NOT NULL
);


INSERT INTO crew_members (first_name, last_name, date_of_birth) VALUES
    ('Andrii', 'Soldatenko', '1989-05-20'),
    ('Scott', 'Griffin', '1980-08-22'),
    ('Steven', 'Martin', '1971-10-05'),
    ('Tanner', 'Hahn', '1973-10-27'),
    ('William', 'Wood', '1986-11-21'),
    ('Adam', 'Ray', '1982-01-03');

INSERT INTO aircrafts (name, discription) VALUES
    ('MiG-21', 'The MiG-21 was the original Lightweight Fighter'),
    ('Waco 10', 'Instantly popular when it was first introduced in 1927, the Waco 10 was an open cockpit, '),
    ('Ercoupe', 'Fred Weicks little side-by-side flier was a revolutionary approach to personal aviation.'),
    ('Consolidated B-24 Liberator', 'Designed by Consolidated Aircraft in the late 1930s'),
    ('Mitsubishi Zero', 'the Mitsubishi Zero epitomized Japans World War II'),
    ('Tesla Zero', 'Tesla aircraft');

INSERT INTO crew_member_aircraft (crew_member_id, aircraft_id, updated) VALUES
    (1, 1, CURRENT_TIMESTAMP),
    (2, 1, CURRENT_TIMESTAMP),
    (3, 1, CURRENT_TIMESTAMP),
    (4, 1, CURRENT_TIMESTAMP),
    (1, 2, CURRENT_TIMESTAMP),
    (2, 2, CURRENT_TIMESTAMP),
    (3, 3, CURRENT_TIMESTAMP),
    (4, 3, CURRENT_TIMESTAMP),
    (4, 4, CURRENT_TIMESTAMP),
    (5, 4, CURRENT_TIMESTAMP),
    (5, 5, CURRENT_TIMESTAMP);


-- Find name of the oldest crew member
select first_name from crew_members order by date_of_birth limit 1 offset 0;
-- Find name of the n-th crew member (second oldest, fifth oldest and so on)
select first_name from crew_members order by date_of_birth limit 1 offset 1;
select first_name from crew_members order by date_of_birth limit 1 offset 2;

--- Another idea more clean
select first_name from (
  select first_name, row_number() OVER (order by date_of_birth) as rnum
  from crew_members
) t where t.rnum = 3;


--- Find name of the most experienced crew member - that one who knows most aircrafts
select t.first_name from (
  select ca.crew_member_id, cm.first_name, count(ca.aircraft_id)
  from crew_member_aircraft as ca
    inner join crew_members as cm on ca.crew_member_id = cm.id
    inner join aircrafts as a on ca.aircraft_id = a.id
    group by ca.crew_member_id, cm.first_name
    order by count(ca.aircraft_id) desc
  limit 1
) t;
-- Find name of the most experienced crew member - that one who knows most aircrafts
-- Second solution more simple :)
select cm.first_name
  from crew_members as cm
    left outer join crew_member_aircraft as ca on ca.crew_member_id = cm.id
    group by cm.id
    order by count(aircraft_id) desc
    limit 1
;


-- Find name of the least experienced crew member - that one who knows least aircrafts (counting from zero)
select cm.first_name, count(aircraft_id)
  from crew_members as cm
    left outer join crew_member_aircraft as ca on ca.crew_member_id = cm.id
    group by cm.id
    order by count(aircraft_id)
    limit 1
;
/*
 first_name | count
------------+-------
 Adam       |     0
 Scott      |     2
 William    |     2
 Andrii     |     2
 Steven     |     2
 Tanner     |     3
(6 rows)
*/
