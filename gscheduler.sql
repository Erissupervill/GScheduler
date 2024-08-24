-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Aug 24, 2024 at 09:41 AM
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
-- Table structure for table `logs`
--

CREATE TABLE `logs` (
  `LogID` int(11) UNSIGNED NOT NULL,
  `Action` varchar(50) NOT NULL,
  `UserID` int(11) UNSIGNED NOT NULL,
  `Timestamp` datetime DEFAULT current_timestamp(),
  `Description` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `mlalgorithm`
--

CREATE TABLE `mlalgorithm` (
  `AlgorithmID` int(11) UNSIGNED NOT NULL,
  `Type` varchar(50) DEFAULT NULL,
  `Description` text DEFAULT NULL,
  `LastUpdated` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `otplogs`
--

CREATE TABLE `otplogs` (
  `OTPLogID` int(11) UNSIGNED NOT NULL,
  `UserID` int(11) UNSIGNED NOT NULL,
  `OTPCode` varchar(10) NOT NULL,
  `Timestamp` datetime DEFAULT current_timestamp(),
  `Status` enum('Generated','Sent','Verified','Failed') DEFAULT 'Generated',
  `Description` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `reservation`
--

CREATE TABLE `reservation` (
  `reservation_id` int(11) UNSIGNED NOT NULL,
  `customer_id` int(11) UNSIGNED DEFAULT NULL,
  `reservation_date_time` datetime NOT NULL,
  `table_id` int(11) UNSIGNED DEFAULT NULL,
  `status` enum('Pending','Confirmed','Cancelled','Rejected') DEFAULT 'Pending',
  `updated_by` int(11) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `reservation`
--

INSERT INTO `reservation` (`reservation_id`, `customer_id`, `reservation_date_time`, `table_id`, `status`, `updated_by`) VALUES
(1, 17, '2024-08-25 19:00:00', 1, 'Confirmed', NULL),
(2, 18, '2024-08-26 20:00:00', 2, 'Confirmed', 16),
(3, 18, '2024-08-27 18:30:00', 3, 'Pending', 16),
(4, 17, '2024-08-28 21:00:00', 4, 'Confirmed', NULL),
(5, 18, '2024-08-29 19:30:00', 5, 'Pending', NULL),
(6, 17, '2024-08-30 20:00:00', 6, 'Confirmed', NULL),
(7, 17, '2024-08-31 18:00:00', 7, 'Pending', NULL),
(8, 19, '2024-09-01 19:00:00', 8, 'Rejected', NULL),
(9, 19, '2024-09-02 20:00:00', 9, 'Confirmed', NULL),
(10, 17, '2024-09-03 21:00:00', 10, 'Confirmed', NULL),
(11, 15, '2024-08-24 14:56:00', 1, 'Pending', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `restauranttable`
--

CREATE TABLE `restauranttable` (
  `table_id` int(11) UNSIGNED NOT NULL,
  `Capacity` int(11) NOT NULL,
  `Location` varchar(100) DEFAULT NULL,
  `availability_status` enum('Available','Reserved','Out of Service') DEFAULT 'Available'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `restauranttable`
--

INSERT INTO `restauranttable` (`table_id`, `Capacity`, `Location`, `availability_status`) VALUES
(1, 4, 'taguig', 'Available'),
(2, 2, 'taguig', 'Available'),
(3, 6, 'pasig', 'Reserved'),
(4, 4, 'taguig', 'Available'),
(5, 2, 'taguig', 'Available'),
(6, 6, 'pasig', 'Reserved'),
(7, 4, 'pasig', 'Available'),
(8, 2, 'pasig', 'Reserved'),
(9, 6, 'taguig', 'Available'),
(10, 4, 'pasig', 'Reserved');

-- --------------------------------------------------------

--
-- Table structure for table `userrole`
--

CREATE TABLE `userrole` (
  `RoleID` int(11) UNSIGNED NOT NULL,
  `RoleName` enum('Admin','Staff','Customer') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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

CREATE TABLE `usertable` (
  `user_id` int(11) UNSIGNED NOT NULL,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `email_address` varchar(155) NOT NULL,
  `phone_number` varchar(155) NOT NULL,
  `role_id` int(11) UNSIGNED DEFAULT NULL,
  `last_login` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `usertable`
--

INSERT INTO `usertable` (`user_id`, `first_name`, `last_name`, `username`, `password_hash`, `email_address`, `phone_number`, `role_id`, `last_login`, `created_at`, `updated_at`) VALUES
(3, '', '', 'admin', '$2b$12$Hd2xLQ/9jPOLHfOg.UuqeOS5mC7QID5xLF3876B2ivyIDCrr69OTq', 'admin@gmail.com', '(12) 35-555-5555', 1, '2024-08-24 13:31:11', '2024-08-16 00:49:15', '2024-08-24 13:31:11'),
(14, '', '', 'admin2', '$2b$12$WJlQ2d//YgyfQwFn6PSOGOxy.KmptSNGvZ0DlecWw44TdQ4hyE7iG', 'admin2@gmail.com', '(12) 31-231-2312', 1, NULL, '2024-08-24 13:11:44', '2024-08-24 13:11:44'),
(15, '', '', 'test', '$2b$12$fRT7yg6C6jBOlaKZlNhK/u7MiTkNlSXdjaz7by6S/JoSZ45gxKHja', 'testuser@gmail.com', '(12) 31-231-2312', 3, '2024-08-24 14:14:43', '2024-08-24 13:29:52', '2024-08-24 14:14:43'),
(16, '', '', 'staff', '$2b$12$a9w1k4to6gcqhWMLCW4amug/4T1qTy1H.UxZF8DZ65xQ2lQSu07Em', 'staff@gmail.com', '(12) 31-231-2312', 2, '2024-08-24 15:20:24', '2024-08-24 13:35:49', '2024-08-24 15:20:24'),
(17, '', '', 'john_doe', '$2b$12$fRT7yg6C6jBOlaKZlNhK/u7MiTkNlSXdjaz7by6S/JoSZ45gxKHja', 'john.doe@example.com', '123-456-7890', 1, NULL, '2024-08-24 13:40:20', '2024-08-24 13:40:33'),
(18, '', '', 'jane_smith', '$2b$12$fRT7yg6C6jBOlaKZlNhK/u7MiTkNlSXdjaz7by6S/JoSZ45gxKHja', 'jane.smith@example.com', '234-567-8901', 2, NULL, '2024-08-24 13:40:20', '2024-08-24 13:40:36'),
(19, '', '', 'alice_johnson', '$2b$12$fRT7yg6C6jBOlaKZlNhK/u7MiTkNlSXdjaz7by6S/JoSZ45gxKHja', 'alice.johnson@example.com', '345-678-9012', 2, NULL, '2024-08-24 13:40:20', '2024-08-24 13:40:38');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `logs`
--
ALTER TABLE `logs`
  ADD PRIMARY KEY (`LogID`),
  ADD KEY `logs_ibfk_1` (`UserID`);

--
-- Indexes for table `mlalgorithm`
--
ALTER TABLE `mlalgorithm`
  ADD PRIMARY KEY (`AlgorithmID`);

--
-- Indexes for table `otplogs`
--
ALTER TABLE `otplogs`
  ADD PRIMARY KEY (`OTPLogID`),
  ADD KEY `UserID` (`UserID`);

--
-- Indexes for table `reservation`
--
ALTER TABLE `reservation`
  ADD PRIMARY KEY (`reservation_id`),
  ADD KEY `customer_id` (`customer_id`),
  ADD KEY `table_id` (`table_id`),
  ADD KEY `rejected_by` (`updated_by`);

--
-- Indexes for table `restauranttable`
--
ALTER TABLE `restauranttable`
  ADD PRIMARY KEY (`table_id`);

--
-- Indexes for table `userrole`
--
ALTER TABLE `userrole`
  ADD PRIMARY KEY (`RoleID`),
  ADD UNIQUE KEY `RoleName` (`RoleName`);

--
-- Indexes for table `usertable`
--
ALTER TABLE `usertable`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `Username` (`username`),
  ADD KEY `RoleID` (`role_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `logs`
--
ALTER TABLE `logs`
  MODIFY `LogID` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `mlalgorithm`
--
ALTER TABLE `mlalgorithm`
  MODIFY `AlgorithmID` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `otplogs`
--
ALTER TABLE `otplogs`
  MODIFY `OTPLogID` int(11) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `reservation`
--
ALTER TABLE `reservation`
  MODIFY `reservation_id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `restauranttable`
--
ALTER TABLE `restauranttable`
  MODIFY `table_id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `userrole`
--
ALTER TABLE `userrole`
  MODIFY `RoleID` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `usertable`
--
ALTER TABLE `usertable`
  MODIFY `user_id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `logs`
--
ALTER TABLE `logs`
  ADD CONSTRAINT `logs_ibfk_1` FOREIGN KEY (`UserID`) REFERENCES `usertable` (`user_id`);

--
-- Constraints for table `otplogs`
--
ALTER TABLE `otplogs`
  ADD CONSTRAINT `otplogs_ibfk_1` FOREIGN KEY (`UserID`) REFERENCES `usertable` (`user_id`);

--
-- Constraints for table `reservation`
--
ALTER TABLE `reservation`
  ADD CONSTRAINT `reservation_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `usertable` (`user_id`),
  ADD CONSTRAINT `reservation_ibfk_2` FOREIGN KEY (`table_id`) REFERENCES `restauranttable` (`table_id`),
  ADD CONSTRAINT `reservation_ibfk_3` FOREIGN KEY (`updated_by`) REFERENCES `usertable` (`user_id`);

--
-- Constraints for table `usertable`
--
ALTER TABLE `usertable`
  ADD CONSTRAINT `usertable_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `userrole` (`RoleID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
