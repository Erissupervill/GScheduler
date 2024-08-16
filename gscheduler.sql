-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Aug 16, 2024 at 05:53 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `gscheduler`
--

-- --------------------------------------------------------

--
-- Table structure for table `customertable`
--

CREATE TABLE IF NOT EXISTS `customertable` (
  `CustomerID` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `FirstName` varchar(50) NOT NULL,
  `LastName` varchar(50) NOT NULL,
  `ContactInfo` varchar(100) DEFAULT NULL,
  `Email` varchar(100) DEFAULT NULL,
  `BookingPreferences` text DEFAULT NULL,
  `HistoricalBookingData` text DEFAULT NULL,
  PRIMARY KEY (`CustomerID`),
  UNIQUE KEY `Email` (`Email`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `customertable`
--

INSERT INTO `customertable` (`CustomerID`, `FirstName`, `LastName`, `ContactInfo`, `Email`, `BookingPreferences`, `HistoricalBookingData`) VALUES
(1, 'John', 'Doe', '123-456-7890', 'johndoe@example.com', 'Window seat', '10 reservations in last year'),
(2, 'Jane', 'Smith', '987-654-3210', 'janesmith@example.com', 'Vegan options', '5 reservations in last year');

-- --------------------------------------------------------

--
-- Table structure for table `logs`
--

CREATE TABLE IF NOT EXISTS `logs` (
  `LogID` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `Action` varchar(50) NOT NULL,
  `UserID` int(11) UNSIGNED NOT NULL,
  `Timestamp` datetime DEFAULT current_timestamp(),
  `Description` text DEFAULT NULL,
  PRIMARY KEY (`LogID`),
  KEY `logs_ibfk_1` (`UserID`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `logs`
--

INSERT INTO `logs` (`LogID`, `Action`, `UserID`, `Timestamp`, `Description`) VALUES
(10, 'Login', 1, '2024-08-08 09:00:00', 'User John Doe logged in'),
(11, 'Reservation Created', 1, '2024-08-08 09:30:00', 'Reservation created for CustomerID 1'),
(12, 'Login', 2, '2024-08-08 09:45:00', 'User Alice Johnson logged in');

-- --------------------------------------------------------

--
-- Table structure for table `mlalgorithm`
--

CREATE TABLE IF NOT EXISTS `mlalgorithm` (
  `AlgorithmID` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `Type` varchar(50) DEFAULT NULL,
  `Description` text DEFAULT NULL,
  `LastUpdated` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`AlgorithmID`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `mlalgorithm`
--

INSERT INTO `mlalgorithm` (`AlgorithmID`, `Type`, `Description`, `LastUpdated`) VALUES
(1, 'Recommendation', 'Predicts user preferences based on past reservations', '2024-08-01 12:00:00'),
(2, 'Optimization', 'Optimizes table allocation for maximum efficiency', '2024-08-02 12:00:00'),
(3, 'Recommendation', 'Predicts user preferences based on past reservations', '2024-08-01 12:00:00'),
(4, 'Optimization', 'Optimizes table allocation for maximum efficiency', '2024-08-02 12:00:00'),
(5, 'Recommendation', 'Predicts user preferences based on past reservations', '2024-08-01 12:00:00'),
(6, 'Optimization', 'Optimizes table allocation for maximum efficiency', '2024-08-02 12:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `otpverification`
--

CREATE TABLE IF NOT EXISTS `otpverification` (
  `OTPIDReservationId` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `OTPCode` varchar(10) DEFAULT NULL,
  `GenerationTime` datetime DEFAULT current_timestamp(),
  `VerificationStatus` enum('Pending','Verified','Expired') DEFAULT 'Pending',
  PRIMARY KEY (`OTPIDReservationId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `report`
--

CREATE TABLE IF NOT EXISTS `report` (
  `ReportID` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `ReportType` varchar(50) DEFAULT NULL,
  `GeneratedDate` datetime DEFAULT current_timestamp(),
  `Content` text DEFAULT NULL,
  `ReservationID` int(11) UNSIGNED DEFAULT NULL,
  PRIMARY KEY (`ReportID`),
  KEY `ReservationID` (`ReservationID`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `reservation`
--

CREATE TABLE IF NOT EXISTS `reservation` (
  `ReservationID` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `CustomerID` int(11) UNSIGNED DEFAULT NULL,
  `ReservationDateTime` datetime NOT NULL,
  `TableID` int(11) UNSIGNED DEFAULT NULL,
  `Status` enum('Pending','Confirmed','Cancelled') DEFAULT 'Pending',
  `OTPCode` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`ReservationID`),
  KEY `CustomerID` (`CustomerID`),
  KEY `TableID` (`TableID`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `reservation`
--

INSERT INTO `reservation` (`ReservationID`, `CustomerID`, `ReservationDateTime`, `TableID`, `Status`, `OTPCode`) VALUES
(3, 1, '2024-08-07 18:00:00', 1, 'Confirmed', '123456'),
(4, 2, '2024-08-08 19:00:00', 2, 'Pending', '654321');

-- --------------------------------------------------------

--
-- Table structure for table `restauranttable`
--

CREATE TABLE IF NOT EXISTS `restauranttable` (
  `TableId` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `Capacity` int(11) NOT NULL,
  `Location` varchar(100) DEFAULT NULL,
  `AvailabilityStatus` enum('Available','Reserved','Out of Service') DEFAULT 'Available',
  PRIMARY KEY (`TableId`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `restauranttable`
--

INSERT INTO `restauranttable` (`TableId`, `Capacity`, `Location`, `AvailabilityStatus`) VALUES
(1, 4, 'Corner', 'Available'),
(2, 2, 'Center', 'Reserved'),
(3, 4, 'Corner', 'Available'),
(4, 2, 'Center', 'Reserved');

-- --------------------------------------------------------

--
-- Table structure for table `staff`
--

CREATE TABLE IF NOT EXISTS `staff` (
  `StaffID` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `FirstName` varchar(50) DEFAULT NULL,
  `LastName` varchar(50) DEFAULT NULL,
  `Role` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`StaffID`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `staff`
--

INSERT INTO `staff` (`StaffID`, `FirstName`, `LastName`, `Role`) VALUES
(1, 'Alice', 'Johnson', 'Manager'),
(2, 'Bob', 'Williams', 'Waiter'),
(3, 'Alice', 'Johnson', 'Manager'),
(4, 'Bob', 'Williams', 'Waiter');

-- --------------------------------------------------------

--
-- Table structure for table `userrole`
--

CREATE TABLE IF NOT EXISTS `userrole` (
  `RoleID` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `RoleName` enum('Admin','Staff','Customer') NOT NULL,
  PRIMARY KEY (`RoleID`),
  UNIQUE KEY `RoleName` (`RoleName`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `userrole`
--

INSERT INTO `userrole` (`RoleID`, `RoleName`) VALUES
(1, 'Admin'),
(2, 'Staff'),
(3, 'Customer');

-- --------------------------------------------------------

--
-- Table structure for table `usertable`
--

CREATE TABLE IF NOT EXISTS `usertable` (
  `user_id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `email_address` varchar(155) NOT NULL,
  `phone_number` varchar(155) NOT NULL,
  `role_id` int(11) UNSIGNED DEFAULT NULL,
  `last_login` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `customer_id` int(11) UNSIGNED DEFAULT NULL,
  `staff_id` int(11) UNSIGNED DEFAULT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `Username` (`username`),
  KEY `RoleID` (`role_id`),
  KEY `CustomerID` (`customer_id`),
  KEY `StaffID` (`staff_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `usertable`
--

INSERT INTO `usertable` (`user_id`, `username`, `password_hash`, `email_address`, `phone_number`, `role_id`, `last_login`, `created_at`, `updated_at`, `customer_id`, `staff_id`) VALUES
(1, 'johndoe', 'hashedpassword1', 'johndoe@example.com', '123-456-7890', 3, NULL, '2024-08-15 19:25:31', '2024-08-16 03:26:54', 1, NULL),
(2, 'alicej', 'hashedpassword2', 'alicej@example.com', '555-123-4567', 2, NULL, '2024-08-15 19:25:31', '2024-08-16 03:26:57', NULL, 1),
(3, 'admin', '$2b$12$Hd2xLQ/9jPOLHfOg.UuqeOS5mC7QID5xLF3876B2ivyIDCrr69OTq', 'admin@gmail.com', '(12) 35-555-5555', 1, '2024-08-16 10:52:37', '2024-08-16 00:49:15', '2024-08-16 10:52:37', NULL, NULL),
(4, 'staff', '$2b$12$Ry80R5xSkLybsUyQ6xFLHuvc374P3i4J6Co8ZZMfrrADNv6Y7OtX.', 'staff@gmail.com', '(12) 34-567-8900', 2, '2024-08-16 03:29:39', '2024-08-16 00:50:07', '2024-08-16 03:29:40', NULL, NULL),
(5, 'user', '$2b$12$6Tt/sX8OVGcJL/u7quqdm.sNp/w6.nxAQoASW6l0JKck58npZ3iue', 'user@gmail.com', '(12) 34-587-5857', 3, '2024-08-16 01:13:45', '2024-08-16 00:50:19', '2024-08-16 01:13:45', NULL, NULL),
(8, 'testuser1', '$2b$12$trefTU4TL.Wq0REp6DR89eCsnmSZRMp7U1T3Z10pOyJuf4CGTYz3G', 'testuser1@gmail.com', '(12) 31-231-2313', 2, NULL, '2024-08-16 03:28:31', '2024-08-16 03:28:31', NULL, NULL),
(9, 'admin2', '$2b$12$W6WMnmEu7Fab8l6oVwG/QebRVzX3i3mkgEvmrqiL9jPJa6yedNfzC', 'admin2@gmail.com', '(11) 11-111-1111', 1, NULL, '2024-08-16 11:50:36', '2024-08-16 11:50:36', NULL, NULL),
(10, 'staff2', '$2b$12$GdLl/ABHdWgpLilPvOd8sexO2CsoZgBgbJhjBANUda4t1RIU8TtfC', 'staff2@gmail.com', '(12) 31-231-2312', 2, '2024-08-16 11:51:21', '2024-08-16 11:51:07', '2024-08-16 11:51:21', NULL, NULL);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `logs`
--
ALTER TABLE `logs`
  ADD CONSTRAINT `logs_ibfk_1` FOREIGN KEY (`UserID`) REFERENCES `usertable` (`user_id`);

--
-- Constraints for table `otpverification`
--
ALTER TABLE `otpverification`
  ADD CONSTRAINT `otpverification_ibfk_1` FOREIGN KEY (`OTPIDReservationId`) REFERENCES `reservation` (`ReservationID`);

--
-- Constraints for table `report`
--
ALTER TABLE `report`
  ADD CONSTRAINT `report_ibfk_1` FOREIGN KEY (`ReservationID`) REFERENCES `reservation` (`ReservationID`);

--
-- Constraints for table `reservation`
--
ALTER TABLE `reservation`
  ADD CONSTRAINT `reservation_ibfk_1` FOREIGN KEY (`CustomerID`) REFERENCES `customertable` (`CustomerID`),
  ADD CONSTRAINT `reservation_ibfk_2` FOREIGN KEY (`TableID`) REFERENCES `restauranttable` (`TableId`);

--
-- Constraints for table `usertable`
--
ALTER TABLE `usertable`
  ADD CONSTRAINT `usertable_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `userrole` (`RoleID`),
  ADD CONSTRAINT `usertable_ibfk_2` FOREIGN KEY (`customer_id`) REFERENCES `customertable` (`CustomerID`),
  ADD CONSTRAINT `usertable_ibfk_3` FOREIGN KEY (`staff_id`) REFERENCES `staff` (`StaffID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
