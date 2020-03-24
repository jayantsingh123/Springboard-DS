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

SELECT name 
FROM Facilities 
WHERE membercost > 0



/* Q2: How many facilities do not charge a fee to members? */


SELECT count(1) AS 'Facilities with no fee' 
FROM Facilities 
WHERE membercost = 0



/* Q3: How can you produce a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost?
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question. */

SELECT facid, name, membercost, monthlymaintenance 
FROM Facilities 
WHERE (membercost >0 AND membercost < (0.20*monthlymaintenance))



/* Q4: How can you retrieve the details of facilities with ID 1 and 5?
Write the query without using the OR operator. */

SELECT * 
FROM Facilities
WHERE facid IN (1,5)


/* Q5: How can you produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100? Return the name and monthly maintenance of the facilities
in question. */

SELECT name, monthlymaintenance,
CASE WHEN (monthlymaintenance >=100) THEN 'Expensive'
ELSE 'Cheap' END AS cost_effectiveness
FROM Facilities



/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Do not use the LIMIT clause for your solution. */

SELECT firstname, surname, max(joindate) 
FROM Members




/* Q7: How can you produce a list of all members who have used a tennis court?
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. */


SELECT DISTINCT CONCAT(firstname,' ', surname) AS Member_name, name as Court_name 
FROM Members
JOIN Bookings
ON Bookings.memid = Members.memid
JOIN Facilities
ON Facilities.facid = Bookings.facid
WHERE Facilities.name LIKE '%Tennis Court%' AND Members.memid !=0
ORDER BY Member_name
 


OR

SELECT DISTINCT CONCAT(firstname,' ', surname) AS Member_name, name as Court_name 
FROM Members
JOIN Bookings
ON Bookings.memid = Members.memid
JOIN Facilities
ON Facilities.facid = Bookings.facid
AND Facilities.name LIKE '%Tennis Court%' AND Members.memid !=0
ORDER BY Member_name


/* Q8: How can you produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30? Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */





SELECT name as Court_name, CONCAT(firstname,' ', surname) AS Member_name,
CASE WHEN Members.memid > 0 THEN Facilities.membercost*Bookings.slots
ELSE Facilities.guestcost*Bookings.slots END AS Cost
FROM Members
JOIN Bookings
ON Bookings.memid = Members.memid
JOIN Facilities
ON Facilities.facid = Bookings.facid
WHERE (Bookings.starttime >= '2012-09-14' AND Bookings.starttime < '2012-09-15') AND ((Facilities.membercost*Bookings.slots > 30 AND Members.memid > 0) OR (Facilities.guestcost*Bookings.slots > 30 AND Members.Memid = 0))
ORDER BY Cost DESC


/* Q9: This time, produce the same result as in Q8, but using a subquery. */

SELECT *
FROM (
    SELECT name as Court_name, CONCAT(firstname,' ', surname) AS Member_name,
	CASE WHEN Members.memid > 0 THEN Facilities.membercost*Bookings.slots
	ELSE Facilities.guestcost*Bookings.slots END AS Cost	
	FROM Members
	JOIN Bookings
	ON Bookings.memid = Members.memid
	JOIN Facilities
	ON Facilities.facid = Bookings.facid
	WHERE (Bookings.starttime >= '2012-09-14' AND Bookings.starttime < '2012-09-15') 
	) As Table1
WHERE Table1.Cost > 30
ORDER BY Table1.Cost DESC 




/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */

SELECT Facilities.name,
	SUM(CASE WHEN Bookings.memid > 0 THEN Facilities.membercost*Bookings.slots
        ELSE Facilities.guestcost*Bookings.slots END) AS Revenue
FROM Facilities
JOIN Bookings
ON Facilities.facid = Bookings.facid
GROUP BY 1
HAVING (Revenue < 1000)
ORDER By Revenue