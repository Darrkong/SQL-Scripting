/* Welcome to the SQL mini project. For this project, you will use
Springboard' online SQL platform, which you can log into through the
following link:

https://sql.springboard.com/
Username: student
Password: learn_sql@springboard

The data you need is in the "country_club" database. This database
contains 3 tables:
    i) the "Bookings" table,
    ii) the "Facilities" table, and
    iii) the "Members" table.

Note that, if you need to, you can also download these tables locally.

In the mini project, you'll be asked a series of questions. You can
solve them using the platform, but for the final deliverable,
paste the code for each solution into this script, and upload it
to your GitHub.

Before starting with the questions, feel free to take your time,
exploring the data, and getting acquainted with the 3 tables. */



/* Q1: Some of the facilities charge a fee to members, but some do not.
Please list the names of the facilities that do. */

/* 
Tennis Court 1
Tennis Court 2
Massage Room 1 
Massage Room 2
Squash Court
*/

SELECT * 
FROM  `Facilities` 
WHERE membercost >0;


/* Q2: How many facilities do not charge a fee to members? */

/* 
4 
*/
SELECT COUNT( * ) 
FROM  `Facilities` 
WHERE membercost =0;


/* Q3: How can you produce a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost?
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question. */

SELECT facid, name, membercost, guestcost, initialoutlay, monthlymaintenance
FROM  `Facilities` 
WHERE membercost >0
AND membercost / monthlymaintenance < 0.20


/* Q4: How can you retrieve the details of facilities with ID 1 and 5?
Write the query without using the OR operator. */

SELECT 
*
FROM  `Facilities` 
WHERE facid in (1,5)

/* Q5: How can you produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100? Return the name and monthly maintenance of the facilities
in question. */

SELECT 
name, 
monthlymaintenance,
case
  when monthlymaintenance > 100 then 'expensive'
  else 'cheap'
end as class
FROM  `Facilities` 

/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Do not use the LIMIT clause for your solution. */

/* Darren Smith*/
SELECT 
firstname, 
surname,
joindate
FROM  Members
where joindate = 
(SELECT MAX(joindate) FROM Members)



/* Q7: How can you produce a list of all members who have used a tennis court?
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. */

SELECT 
distinct t3.firstname, t3.surname
from
Bookings t1
inner join
Facilities t2
on 
t1.facid = t2.facid and
t2.name like 'Tennis Court%'
inner join
Members t3
on
t1.memid = t3.memid and
t3.firstname != 'GUEST'

/* Q8: How can you produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30? Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */

select
t2.name,
concat(t3.firstname, ' ', t3.surname) as name,
case
  when firstname = 'GUEST' then t2.guestcost * t1.slots
  else t2.membercost * t1.slots
end as total_cost
from 
Bookings t1
inner join
Facilities t2
on
t1.facid = t2.facid and
t1.starttime between '2012-09-14 00:00:00' and '2012-09-14 23:59:59'
inner join
Members t3
on 
t1.memid = t3.memid
having total_cost > 30
order by 3 desc


/* Q9: This time, produce the same result as in Q8, but using a subquery. */

select
t2.name,
concat(t3.firstname, ' ', t3.surname) as name,
case
  when firstname = 'GUEST' then t2.guestcost * t1.slots
  else t2.membercost * t1.slots
end as total_cost
from 
(
  select
  *
  from
  Bookings
  where starttime between '2012-09-14 00:00:00' and '2012-09-14 23:59:59'
) t1
inner join
Facilities t2
on
t1.facid = t2.facid
inner join
Members t3
on 
t1.memid = t3.memid
having total_cost > 30
order by 3 desc

/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */

/* 
Pool Table 270.0
Snooker Table 240.0
Table Tennis 180.0
*/

select
t2.name,
sum(
case
  when firstname = 'GUEST' then t2.guestcost * t1.slots
  else t2.membercost * t1.slots
end
) as total_revenue
from 
Bookings t1
inner join
Facilities t2
on
t1.facid = t2.facid
inner join
Members t3
on 
t1.memid = t3.memid
group by 1
having total_revenue < 1000
order by 2 desc


