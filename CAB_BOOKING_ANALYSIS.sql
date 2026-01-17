create database cb;
use cb;

CREATE TABLE Customers (
 CustomerID INT PRIMARY KEY,
 Name VARCHAR(100),
 Email VARCHAR(100),
 RegistrationDate DATE
);

CREATE TABLE Drivers (
 DriverID INT PRIMARY KEY,
 Name VARCHAR(100),
 JoinDate DATE
);

CREATE TABLE Cabs (
 CabID INT PRIMARY KEY,
 DriverID INT,
 VehicleType VARCHAR(20),
 PlateNumber VARCHAR(20),
 FOREIGN KEY (DriverID) REFERENCES Drivers(DriverID)
);

CREATE TABLE Bookings (
 BookingID INT PRIMARY KEY,
 CustomerID INT,
 CabID INT,
 BookingDate DATETIME,
 Status VARCHAR(20),
 PickupLocation VARCHAR(100),
 DropoffLocation VARCHAR(100),
 FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
 FOREIGN KEY (CabID) REFERENCES Cabs(CabID)
);

CREATE TABLE TripDetails (
 TripID INT PRIMARY KEY,
 BookingID INT,
 StartTime DATETIME,
 EndTime DATETIME,
 DistanceKM FLOAT,
 Fare FLOAT,
 FOREIGN KEY (BookingID) REFERENCES Bookings(BookingID)
);

CREATE TABLE Feedback (
 FeedbackID INT PRIMARY KEY,
 BookingID INT,
 Rating FLOAT,
 Comments TEXT,
 FeedbackDate DATE,
 FOREIGN KEY (BookingID) REFERENCES Bookings(BookingID)
);

INSERT INTO Customers (CustomerID, Name, Email, RegistrationDate) VALUES
(1, 'Amit Sharma', 'amit@example.com', '2024-01-10'),
(2, 'Priya Verma', 'priya@example.com', '2024-02-15'),
(3, 'Rahul Mehta', 'rahul@example.com', '2024-03-05'),
(4, 'Sneha Kapoor', 'sneha@example.com', '2024-03-20'),
(5, 'Vikram Singh', 'vikram@example.com', '2024-04-01');

INSERT INTO Drivers (DriverID, Name, JoinDate) VALUES
(101, 'Ramesh Yadav', '2023-12-01'),
(102, 'Sunil Patil', '2024-01-05'),
(103, 'Anil Kumar', '2024-02-10'),
(104, 'Mohit Gupta', '2024-02-25');

INSERT INTO Cabs (CabID, DriverID, VehicleType, PlateNumber) VALUES
(201, 101, 'Sedan', 'MH12AB1234'),
(202, 102, 'SUV', 'MH14CD5678'),
(203, 103, 'Sedan', 'MH15EF9101'),
(204, 104, 'Hatchback', 'MH16GH1122');

INSERT INTO Bookings (BookingID, CustomerID, CabID, BookingDate, Status, PickupLocation, DropoffLocation) VALUES
(301, 1, 201, '2024-04-10 09:00:00', 'Completed', 'Pune Station', 'Hinjewadi'),
(302, 2, 202, '2024-04-11 10:30:00', 'Completed', 'Baner', 'Kothrud'),
(303, 3, 203, '2024-04-12 11:15:00', 'Canceled', 'Koregaon Park', 'Viman Nagar'),
(304, 4, 204, '2024-04-12 12:45:00', 'Completed', 'Shivajinagar', 'Camp'),
(305, 5, 201, '2024-04-13 08:20:00', 'Completed', 'Hadapsar', 'Magarpatta'),
(306, 1, 202, '2024-04-14 14:00:00', 'Completed', 'Baner', 'Pimpri'),
(307, 3, 201, '2024-04-14 15:30:00', 'Completed', 'Viman Nagar', 'Airport'),
(308, 2, 204, '2024-04-15 09:45:00', 'Canceled', 'Aundh', 'Swargate'),
(309, 4, 203, '2024-04-16 19:00:00', 'Completed', 'Kothrud', 'Deccan'),
(310, 5, 202, '2024-04-17 07:50:00', 'Completed', 'Pimpri', 'Chinchwad');

INSERT INTO TripDetails (TripID, BookingID, StartTime, EndTime, DistanceKM, Fare) VALUES
(401, 301, '2024-04-10 09:05:00', '2024-04-10 09:50:00', 15.2, 350),
(402, 302, '2024-04-11 10:35:00', '2024-04-11 11:10:00', 10.5, 250),
(403, 304, '2024-04-12 12:50:00', '2024-04-12 13:30:00', 12.0, 280),
(404, 305, '2024-04-13 08:25:00', '2024-04-13 09:05:00', 14.0, 320),
(405, 306, '2024-04-14 14:05:00', '2024-04-14 14:50:00', 18.5, 400),
(406, 307, '2024-04-14 15:35:00', '2024-04-14 15:55:00', 7.2, 150),
(407, 309, '2024-04-16 19:05:00', '2024-04-16 19:40:00', 9.5, 220),
(408, 310, '2024-04-17 07:55:00', '2024-04-17 08:30:00', 11.3, 270);

INSERT INTO Feedback (FeedbackID, BookingID, Rating, Comments, FeedbackDate) VALUES
(501, 301, 4.5, 'Smooth ride, polite driver.', '2024-04-10'),
(502, 302, 5.0, 'Very comfortable SUV.', '2024-04-11'),
(503, 303, 2.0, 'Driver canceled the ride late.', '2024-04-12'),
(504, 304, 3.5, 'Average experience.', '2024-04-12'),
(505, 305, 4.0, 'Good ride, on time.', '2024-04-13'),
(506, 306, 4.8, 'Excellent service.', '2024-04-14'),
(507, 307, 4.2, 'Quick trip, nice driver.', '2024-04-14'),
(508, 308, 1.5, 'Driver did not show up.', '2024-04-15'),
(509, 309, 3.0, 'Okay ride, bit late.', '2024-04-16'),
(510, 310, 4.7, 'Great trip, clean cab.', '2024-04-17');

# Q1 Identify customers who have completed the most bookings. What insights can you draw about their behavior?
select Customers.CustomerID, Name, count(*)
from Customers, Bookings
where Customers.CustomerID = Bookings.CustomerID and Status = 'completed'
group by Bookings.CustomerID, Name;

# Q2  Find customers who have canceled more than 30% of their total bookings. What could be the reason for frequent cancellations?
select CustomerID, count(*) as 'total_bookings',
sum(Status = 'canceled'),
(sum(Status = 'canceled')/count(*)) as 'cancel_ratio'
from Bookings
group by CustomerID
having cancel_ratio > 0.1;

# Q3 Determine the busiest day of the week for bookings. How can the company optimize cab availability on peak days?
select dayname(BookingDate) as 'day', count(*)
from Bookings
group by day;

# Q4 Identify drivers who have received an average rating below 3.0 in the past three months. What strategies can be implemented to improve their performance?
select Drivers.DriverID, Drivers.Name, avg(Rating)
from Drivers, Bookings, Feedback, Cabs
where Drivers.DriverID = Cabs.DriverID and Cabs.CabID = Bookings.CabID and Bookings.BookingID = Feedback.BookingID 
and FeedbackDate >= date_sub(curdate(), interval 3 month)
group by Drivers.DriverID, Drivers.Name
having avg(rating) < 3.0;

# Q5 . Find the top 2 drivers who have completed the longest trips in terms of distance. What does this say about their working patterns?
select Drivers.DriverID, Drivers.Name, max(DistanceKM)
from Drivers, Bookings, Cabs, TripDetails
where Drivers.DriverID = Cabs.DriverID and Cabs.CabID = Bookings.CabID and Bookings.BookingID = TripDetails.BookingID
group by Drivers.DriverID
order by max(DistanceKM) desc
limit 2;

# Q6  Identify drivers with a high percentage of canceled trips. Could this indicate driver unreliability?
select Drivers.DriverID, count(*) as 'total_booking', sum(Status = 'Canceled') as 'canceled trips', (sum(Status = 'Canceled')/count(*))*100 as 'percentage_of_canceled_trips'
from Drivers, Bookings, Cabs
where Drivers.DriverID = Cabs.DriverID and Cabs.CabID = Bookings.CabID 
group by Drivers.DriverID
having (percentage_of_canceled_trips) > 30;

# Q7 Calculate the total revenue generated by completed bookings in the last 6 months. How has the revenue trend changed over time?
selecT sum(Fare)
from Bookings,TripDetails
where Bookings.BookingID = TripDetails.BookingID and Status = 'Completed' and BookingDate >= date_sub(curdate(), interval 6 month);


# Q8 Identify the top 3 most frequently traveled routes based on PickupLocation and DropoffLocation. Should the company allocate more cabs to these routes?
select PickupLocation, DropoffLocation, count(*)
from Bookings
group by PickupLocation, DropoffLocation
order by count(*) desc
limit 3;

# Q9 Determine if higher-rated drivers tend to complete more trips and earn higher fares. Is there a direct correlation between driver ratings and earnings?
select Drivers.DriverID, avg(Rating), count(*), sum(Fare)
from Drivers, Bookings, Cabs, TripDetails, Feedback
where Drivers.DriverID = Cabs.DriverID and Cabs.CabID = Bookings.CabID and Bookings.BookingID = TripDetails.BookingID
and TripDetails.BookingID = Feedback.BookingID
group by Drivers.DriverID
order by avg(Rating) desc;

# Q10 Analyze the average waiting time (difference between booking time and trip start time) for different pickup locations. How can this be optimized to reduce delays?
select PickupLocation, avg(timestampdiff(minute, BookingDate, StartTime))
from Bookings, TripDetails
where Bookings.BookingID = TripDetails.BookingID
group by PickupLocation
order by avg(timestampdiff(minute, BookingDate, StartTime));

# Q11  Identify the most common reasons for trip cancellations from customer feedback. What actions can be taken to reduce cancellations?
select Comments 
from Bookings, Feedback
where Bookings.BookingID = Feedback.BookingID and Status = 'Canceled'
group by Comments;

# Q12 Find out whether shorter trips (low-distance) contribute significantly to revenue. Should the company encourage more short-distance rides?
select
    case
        when DistanceKM <= 5 then 'Short'
        when DistanceKM <= 15 then 'Medium'
        else 'Long'
    end as trip_type,
    sum(Fare) as revenue
from TripDetails
group by trip_type;

# Q13 Compare the revenue generated from 'Sedan' and 'SUV' cabs. Should the company invest more in a particular vehicle type?
select VehicleType, sum(Fare)
from Cabs, TripDetails, Bookings
where Cabs.CabID = Bookings.CabID and Bookings.BookingID = TripDetails.BookingID
group by VehicleType;

# Q14 . Predict which customers are likely to stop using the service based on their last booking date and frequency of rides. How can customer retention be improved?
select Customers.CustomerID, Name, count(TripID), max(BookingDate) as last_booking_date,  DATEDIFF(CURDATE(), MAX(BookingDate)) as days_since_last_booking
from Customers 
left join Bookings on Customers.CustomerID = Bookings.CustomerID
left join TripDetails on Bookings.BookingID = TripDetails.BookingID
group by Customers.CustomerID, Name;

# Q15 Analyze whether weekend bookings differ significantly from weekday bookings. Should the company introduce dynamic pricing based on demand?
select  
    case
        when DAYOFWEEK(BookingDate) in (1, 7) then 'Weekend'
        else 'Weekday'
    end as DayType,
    count(*) as Total_Bookings,
    sum(Fare) as Total_Revenue
from Bookings, TripDetails
where Bookings.BookingID = TripDetails.BookingID and Status = 'Completed'
group by DayType;
