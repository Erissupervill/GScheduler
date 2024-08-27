-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Aug 27, 2024 at 07:36 PM
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

-- --------------------------------------------------------

--
-- Table structure for table `branch`
--

CREATE TABLE `branch` (
  `id` int(11) UNSIGNED NOT NULL,
  `branch_id` varchar(20) NOT NULL,
  `name` varchar(255) NOT NULL,
  `capacity` int(11) NOT NULL,
  `location` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `customer_reservation`
--

CREATE TABLE `customer_reservation` (
  `id` int(11) UNSIGNED NOT NULL,
  `reservation_id` varchar(20) DEFAULT NULL,
  `user_id` varchar(20) NOT NULL,
  `branch_id` varchar(20) NOT NULL,
  `number_of_guests` int(11) NOT NULL,
  `status_comment` text DEFAULT NULL,
  `status` enum('Pending','Confirmed','Completed','Cancelled','Rejected') NOT NULL,
  `reservation_date` date NOT NULL,
  `reservation_time` time NOT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `updated_by` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `feedback`
--

CREATE TABLE `feedback` (
  `id` int(11) UNSIGNED NOT NULL,
  `feedback_id` varchar(20) NOT NULL,
  `user_id` varchar(20) NOT NULL,
  `rating` int(11) NOT NULL,
  `message` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `updated_by` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `logs`
--

CREATE TABLE `logs` (
  `id` int(11) UNSIGNED NOT NULL,
  `log_id` varchar(20) NOT NULL,
  `action` varchar(50) NOT NULL,
  `user_id` varchar(20) NOT NULL,
  `timestamp` datetime DEFAULT current_timestamp(),
  `description` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `notification`
--

CREATE TABLE `notification` (
  `id` int(11) UNSIGNED NOT NULL,
  `notification_id` varchar(20) NOT NULL,
  `user_id` varchar(20) NOT NULL,
  `reservation_id` varchar(20) NOT NULL,
  `message` text NOT NULL,
  `notification_date` date DEFAULT current_timestamp(),
  `notification_time` time NOT NULL,
  `updated_by` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `otplogs`
--

CREATE TABLE `otplogs` (
  `id` int(11) UNSIGNED NOT NULL,
  `otp_log_id` varchar(20) NOT NULL,
  `user_id` varchar(20) NOT NULL,
  `otp_code` varchar(10) NOT NULL,
  `timestamp` datetime DEFAULT current_timestamp(),
  `status` enum('Generated','Sent','Verified','Failed') DEFAULT 'Generated',
  `description` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `userrole`
--

CREATE TABLE `userrole` (
  `id` int(11) UNSIGNED NOT NULL,
  `role_name` enum('Admin','Staff','User') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `usertable`
--

CREATE TABLE `usertable` (
  `id` int(10) UNSIGNED NOT NULL,
  `user_id` varchar(20) DEFAULT NULL,
  `first_name` varchar(50) DEFAULT NULL,
  `last_name` varchar(50) DEFAULT NULL,
  `username` varchar(50) DEFAULT NULL,
  `password_hash` varchar(255) DEFAULT NULL,
  `email_address` varchar(155) DEFAULT NULL,
  `phone_number` varchar(155) DEFAULT NULL,
  `role_id` int(11) UNSIGNED DEFAULT NULL,
  `last_login` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `branch_id` (`branch_id`),
  ADD UNIQUE KEY `unique_branch_id` (`branch_id`);

--
-- Indexes for table `customer_reservation`
--
ALTER TABLE `customer_reservation`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `reservation_id` (`reservation_id`),
  ADD KEY `fk_user_id` (`user_id`),
  ADD KEY `fk_branch_id` (`branch_id`);

--
-- Indexes for table `feedback`
--
ALTER TABLE `feedback`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `feedback_id` (`feedback_id`),
  ADD KEY `fk_feedback_user_id` (`user_id`),
  ADD KEY `fk_feedback_updated_by` (`updated_by`);

--
-- Indexes for table `logs`
--
ALTER TABLE `logs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `log_id` (`log_id`),
  ADD KEY `fk_logs_user_id` (`user_id`);

--
-- Indexes for table `notification`
--
ALTER TABLE `notification`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `notification_id` (`notification_id`),
  ADD KEY `fk_notification_user_id` (`user_id`),
  ADD KEY `fk_notification_reservation_id` (`reservation_id`),
  ADD KEY `fk_notification_updated_by` (`updated_by`);

--
-- Indexes for table `otplogs`
--
ALTER TABLE `otplogs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `otp_log_id` (`otp_log_id`),
  ADD KEY `fk_otplogs_user_id` (`user_id`);

--
-- Indexes for table `userrole`
--
ALTER TABLE `userrole`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `usertable`
--
ALTER TABLE `usertable`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `user_id` (`user_id`),
  ADD UNIQUE KEY `unique_username` (`username`),
  ADD UNIQUE KEY `unique_email_address` (`email_address`),
  ADD KEY `fk_role_id` (`role_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `branch`
--
ALTER TABLE `branch`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `customer_reservation`
--
ALTER TABLE `customer_reservation`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `feedback`
--
ALTER TABLE `feedback`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `logs`
--
ALTER TABLE `logs`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `notification`
--
ALTER TABLE `notification`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `otplogs`
--
ALTER TABLE `otplogs`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `userrole`
--
ALTER TABLE `userrole`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `usertable`
--
ALTER TABLE `usertable`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `customer_reservation`
--
ALTER TABLE `customer_reservation`
  ADD CONSTRAINT `customer_reservation_fk_branch_id` FOREIGN KEY (`branch_id`) REFERENCES `branch` (`branch_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `customer_reservation_fk_user_id` FOREIGN KEY (`user_id`) REFERENCES `usertable` (`user_id`);

--
-- Constraints for table `feedback`
--
ALTER TABLE `feedback`
  ADD CONSTRAINT `feedback_fk_updated_by` FOREIGN KEY (`updated_by`) REFERENCES `usertable` (`user_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `feedback_fk_user_id` FOREIGN KEY (`user_id`) REFERENCES `usertable` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `logs`
--
ALTER TABLE `logs`
  ADD CONSTRAINT `logs_fk_user_id` FOREIGN KEY (`user_id`) REFERENCES `usertable` (`user_id`);

--
-- Constraints for table `notification`
--
ALTER TABLE `notification`
  ADD CONSTRAINT `notification_fk_reservation_id` FOREIGN KEY (`reservation_id`) REFERENCES `customer_reservation` (`reservation_id`),
  ADD CONSTRAINT `notification_fk_updated_by` FOREIGN KEY (`updated_by`) REFERENCES `usertable` (`user_id`),
  ADD CONSTRAINT `notification_fk_user_id` FOREIGN KEY (`user_id`) REFERENCES `usertable` (`user_id`);

--
-- Constraints for table `otplogs`
--
ALTER TABLE `otplogs`
  ADD CONSTRAINT `otplogs_fk_user_id` FOREIGN KEY (`user_id`) REFERENCES `usertable` (`user_id`);

--
-- Constraints for table `usertable`
--
ALTER TABLE `usertable`
  ADD CONSTRAINT `fk_usertable_userrole_id` FOREIGN KEY (`role_id`) REFERENCES `userrole` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
