-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Aug 24, 2024 at 06:05 PM
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
(3, 'testagaina', 'testagainae', 'admin', '$2b$12$gttSgsgSfNjpD7l3PlKaqeBfb31shz4AtQS8dfNGvTdmVGXPbPPke', 'admin@gmail.com', '(12) 35-555-5555', 1, '2024-08-24 23:42:35', '2024-08-16 00:49:15', '2024-08-24 23:42:35'),
(15, 'test1', 'test1', 'test', '$2b$12$Aaj2g6wotDaqzDMe.JO3FOfhhAhUnzP75BchZTcUMyJYz94PQxbfG', 'testuser@gmail.com', '(12) 31-231-2312', 3, '2024-08-24 23:33:21', '2024-08-24 13:29:52', '2024-08-24 23:33:21'),
(17, '', '', 'john_doe', '$2b$12$fRT7yg6C6jBOlaKZlNhK/u7MiTkNlSXdjaz7by6S/JoSZ45gxKHja', 'john.doe@example.com', '123-456-7890', 1, NULL, '2024-08-24 13:40:20', '2024-08-24 13:40:33'),
(18, '', '', 'jane_smith', '$2b$12$fRT7yg6C6jBOlaKZlNhK/u7MiTkNlSXdjaz7by6S/JoSZ45gxKHja', 'jane.smith@example.com', '234-567-8901', 2, NULL, '2024-08-24 13:40:20', '2024-08-24 13:40:36'),
(20, '', '', 'staff', '$2b$12$d8PV23XbL7qt3mxRlyEDz.Y66N1Mez3pxheMb1/mNJ3dzSWXtGu8.', 'staff@gmail.com', '(12) 31-231-2312', 2, '2024-08-24 23:50:53', '2024-08-24 22:50:37', '2024-08-24 23:50:53');

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
  MODIFY `user_id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

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
-- Constraints for table `usertable`
--
ALTER TABLE `usertable`
  ADD CONSTRAINT `usertable_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `userrole` (`RoleID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
