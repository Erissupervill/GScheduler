-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Aug 26, 2024 at 10:16 AM
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
-- Table structure for table `alembic_version`
--

CREATE TABLE `alembic_version` (
  `version_num` varchar(32) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `alembic_version`
--

INSERT INTO `alembic_version` (`version_num`) VALUES
('2a8414e7362e');

-- --------------------------------------------------------

--
-- Table structure for table `branch`
--

CREATE TABLE `branch` (
  `branch_id` int(11) UNSIGNED NOT NULL,
  `capacity` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `location` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `branch`
--

INSERT INTO `branch` (`branch_id`, `capacity`, `name`, `location`) VALUES
(1, 150, 'Pasig', 'Sto. Tomas'),
(2, 100, 'Taguig', 'Sta. Ana');

-- --------------------------------------------------------

--
-- Table structure for table `customer_reservation`
--

CREATE TABLE `customer_reservation` (
  `reservation_id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `branch_id` int(10) UNSIGNED NOT NULL,
  `number_of_guests` int(11) NOT NULL,
  `status_comment` text NOT NULL,
  `status` enum('Pending','Confirmed','Completed','Cancelled','Rejected') NOT NULL,
  `reservation_date` date NOT NULL,
  `reservation_time` time NOT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `updated_by` int(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `customer_reservation`
--

INSERT INTO `customer_reservation` (`reservation_id`, `user_id`, `branch_id`, `number_of_guests`, `status_comment`, `status`, `reservation_date`, `reservation_time`, `created_at`, `updated_at`, `updated_by`) VALUES
(1, 14, 1, 50, 'COMPLETED', 'Completed', '2024-08-30', '19:00:00', '2024-08-25 14:00:00', '2024-08-26 16:02:24', 5),
(2, 2, 2, 30, '', 'Confirmed', '2024-08-31', '20:00:00', '2024-08-25 15:00:00', '2024-08-26 06:40:24', 5),
(3, 3, 2, 200, '', 'Pending', '2024-08-29', '18:00:00', '2024-08-25 16:00:00', '2024-08-26 14:25:57', 0),
(4, 1, 1, 40, 'Queue too long', 'Cancelled', '2024-08-25', '15:24:00', '2024-08-25 07:31:01', '2024-08-25 17:50:10', 0),
(5, 14, 1, 40, 'Guests exceeds capacity', 'Rejected', '2024-08-25', '15:24:00', '2024-08-25 07:31:54', '2024-08-25 17:49:22', 0),
(6, 14, 1, 22, '', 'Rejected', '2024-08-27', '15:33:00', '2024-08-25 07:32:20', '2024-08-25 18:00:15', 0),
(7, 14, 1, 22, '', 'Cancelled', '2024-08-27', '15:33:00', '2024-08-25 07:33:10', '2024-08-25 18:02:24', 0),
(8, 14, 1, 11, '', 'Confirmed', '2024-08-26', '15:47:00', '2024-08-25 07:47:13', '2024-08-26 06:05:14', 5),
(9, 14, 1, 11, '', 'Rejected', '2024-08-26', '15:47:00', '2024-08-25 07:47:46', '2024-08-26 06:22:36', 5);

-- --------------------------------------------------------

--
-- Table structure for table `logs`
--

CREATE TABLE `logs` (
  `log_id` int(11) UNSIGNED NOT NULL,
  `action` varchar(50) NOT NULL,
  `user_id` int(11) UNSIGNED NOT NULL,
  `timestamp` datetime DEFAULT current_timestamp(),
  `description` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `logs`
--

INSERT INTO `logs` (`log_id`, `action`, `user_id`, `timestamp`, `description`) VALUES
(1, 'User Login', 1, '2024-08-24 13:40:20', 'User John Doe logged in'),
(2, 'Reservation Created', 4, '2024-08-24 13:00:00', 'Reservation created for 20 guests');

-- --------------------------------------------------------

--
-- Table structure for table `otplogs`
--

CREATE TABLE `otplogs` (
  `otp_log_id` int(11) UNSIGNED NOT NULL,
  `user_id` int(11) UNSIGNED NOT NULL,
  `otp_code` varchar(10) NOT NULL,
  `timestamp` datetime DEFAULT current_timestamp(),
  `status` enum('Generated','Sent','Verified','Failed') DEFAULT 'Generated',
  `description` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `otplogs`
--

INSERT INTO `otplogs` (`otp_log_id`, `user_id`, `otp_code`, `timestamp`, `status`, `description`) VALUES
(1, 2, '123456', '2024-08-24 12:00:00', 'Generated', 'OTP generated for verification'),
(2, 1, '654321', '2024-08-24 13:00:00', 'Verified', 'OTP verified successfully');

-- --------------------------------------------------------

--
-- Table structure for table `userrole`
--

CREATE TABLE `userrole` (
  `role_id` int(11) UNSIGNED NOT NULL,
  `role_name` enum('Admin','Staff','User') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `userrole`
--

INSERT INTO `userrole` (`role_id`, `role_name`) VALUES
(1, 'Admin'),
(2, 'Staff'),
(3, 'User');

-- --------------------------------------------------------

--
-- Table structure for table `usertable`
--

CREATE TABLE `usertable` (
  `user_id` int(10) UNSIGNED NOT NULL,
  `first_name` varchar(50) DEFAULT NULL,
  `last_name` varchar(50) DEFAULT NULL,
  `username` varchar(50) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `email_address` varchar(155) NOT NULL,
  `phone_number` varchar(155) NOT NULL,
  `role_id` int(11) UNSIGNED NOT NULL,
  `last_login` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `usertable`
--

INSERT INTO `usertable` (`user_id`, `first_name`, `last_name`, `username`, `password_hash`, `email_address`, `phone_number`, `role_id`, `last_login`, `created_at`, `updated_at`) VALUES
(1, 'John', 'Dog', 'john_doe', '$2b$12$fRT7yg6C6jBOlaKZlNhK/u7MiTkNlSXdjaz7by6S/JoSZ45gxKHja', 'john.doe@example.com', '(12) 34-567-890_', 3, NULL, '2024-08-24 13:40:20', '2024-08-25 05:13:33'),
(2, 'Jane', 'Smith', 'jane_smith', '$2b$12$fRT7yg6C6jBOlaKZlNhK/u7MiTkNlSXdjaz7by6S/JoSZ45gxKHja', 'jane.smith@example.com', '234-567-8901', 3, NULL, '2024-08-24 13:40:20', '2024-08-25 11:45:42'),
(3, 'Admin', 'User', 'admin', '$2b$12$gttSgsgSfNjpD7l3PlKaqeBfb31shz4AtQS8dfNGvTdmVGXPbPPke', 'admin@gmail.com', '(12) 35-555-5555', 1, '2024-08-26 06:54:37', '2024-08-16 00:49:15', '2024-08-26 06:54:37'),
(4, 'Test', 'User', 'testuser', '$2b$12$Aaj2g6wotDaqzDMe.JO3FOfhhAhUnzP75BchZTcUMyJYz94PQxbfG', 'testuser@gmail.com', '(12) 31-231-2312', 3, '2024-08-24 23:33:21', '2024-08-24 13:29:52', '2024-08-24 23:33:21'),
(5, 'Staff', 'Member', 'staff', '$2b$12$RYUv5zarJenzfI5vXHBS5OBSAs9ufkcW40ljyMCERZE8HIIx4YWri', 'staff@gmail.com', '(12) 31-231-2312', 2, '2024-08-26 06:54:44', '2024-08-24 22:50:37', '2024-08-26 06:54:44'),
(6, NULL, NULL, 'admin2', '$2b$12$cYhgutZjFWd1aGE0kCtpbeOP/3EnEoEvWeg9R2p6yeYTRbrD7zIvK', 'admin2@gmail.com', '(12) 31-231-2311', 1, '2024-08-25 04:25:56', '2024-08-25 04:19:11', '2024-08-25 12:28:26'),
(7, NULL, NULL, 'test', '$2b$12$JjvMQmVxp/PYaWM.XcbJSeAkcVhOAqCYW/dpk7SbOcbraqItCulMe', 'test@gmail.com', '(12) 31-231-2312', 3, '2024-08-25 06:19:49', '2024-08-25 06:19:43', '2024-08-25 06:19:49'),
(14, 'dong', 'abay', 'newtest', '$2b$12$ldRCBjdH8WSU9dWUhctN8uJLEW1DH2nFLULyGqa2j/BT9frcWlz46', 'newtest@gmail.com', '(12) 31-231-2312', 3, '2024-08-26 06:28:16', '2024-08-25 07:45:59', '2024-08-26 06:28:16');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `alembic_version`
--
ALTER TABLE `alembic_version`
  ADD PRIMARY KEY (`version_num`);

--
-- Indexes for table `branch`
--
ALTER TABLE `branch`
  ADD PRIMARY KEY (`branch_id`);

--
-- Indexes for table `customer_reservation`
--
ALTER TABLE `customer_reservation`
  ADD PRIMARY KEY (`reservation_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `customer_reservation_ibfk_2` (`branch_id`),
  ADD KEY `updated_by` (`updated_by`);

--
-- Indexes for table `logs`
--
ALTER TABLE `logs`
  ADD PRIMARY KEY (`log_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `otplogs`
--
ALTER TABLE `otplogs`
  ADD PRIMARY KEY (`otp_log_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `userrole`
--
ALTER TABLE `userrole`
  ADD PRIMARY KEY (`role_id`),
  ADD UNIQUE KEY `role_name` (`role_name`);

--
-- Indexes for table `usertable`
--
ALTER TABLE `usertable`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email_address` (`email_address`),
  ADD KEY `role_id` (`role_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `branch`
--
ALTER TABLE `branch`
  MODIFY `branch_id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `customer_reservation`
--
ALTER TABLE `customer_reservation`
  MODIFY `reservation_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `logs`
--
ALTER TABLE `logs`
  MODIFY `log_id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `otplogs`
--
ALTER TABLE `otplogs`
  MODIFY `otp_log_id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `userrole`
--
ALTER TABLE `userrole`
  MODIFY `role_id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `usertable`
--
ALTER TABLE `usertable`
  MODIFY `user_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `customer_reservation`
--
ALTER TABLE `customer_reservation`
  ADD CONSTRAINT `customer_reservation_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `usertable` (`user_id`),
  ADD CONSTRAINT `customer_reservation_ibfk_2` FOREIGN KEY (`branch_id`) REFERENCES `branch` (`branch_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `logs`
--
ALTER TABLE `logs`
  ADD CONSTRAINT `logs_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `usertable` (`user_id`);

--
-- Constraints for table `otplogs`
--
ALTER TABLE `otplogs`
  ADD CONSTRAINT `otplogs_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `usertable` (`user_id`);

--
-- Constraints for table `usertable`
--
ALTER TABLE `usertable`
  ADD CONSTRAINT `usertable_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `userrole` (`role_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
