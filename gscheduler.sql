-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Aug 27, 2024 at 07:38 PM
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
CREATE DATABASE IF NOT EXISTS `gscheduler` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `gscheduler`;

-- --------------------------------------------------------

--
-- Table structure for table `alembic_version`
--

CREATE TABLE IF NOT EXISTS `alembic_version` (
  `version_num` varchar(32) NOT NULL,
  PRIMARY KEY (`version_num`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `alembic_version`
--

INSERT INTO `alembic_version` VALUES
('2a8414e7362e');

-- --------------------------------------------------------

--
-- Table structure for table `branch`
--

CREATE TABLE IF NOT EXISTS `branch` (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `branch_id` varchar(20) NOT NULL,
  `name` varchar(255) NOT NULL,
  `capacity` int(11) NOT NULL,
  `location` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `branch_id` (`branch_id`),
  UNIQUE KEY `unique_branch_id` (`branch_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `branch`
--

INSERT INTO `branch` VALUES
(1, '1', 'Pasig', 97, 'Sto. Tomas'),
(2, '2', 'Taguig', 100, 'Sta. Ana');

-- --------------------------------------------------------

--
-- Table structure for table `customer_reservation`
--

CREATE TABLE IF NOT EXISTS `customer_reservation` (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
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
  `updated_by` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `reservation_id` (`reservation_id`),
  KEY `fk_user_id` (`user_id`),
  KEY `fk_branch_id` (`branch_id`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `customer_reservation`
--

INSERT INTO `customer_reservation` VALUES
(11, '1', '14', '1', 50, 'test', 'Cancelled', '2024-08-30', '19:00:00', '2024-08-25 14:00:00', '2024-08-27 12:12:29', '14'),
(12, '2', '2', '2', 30, 'too many guests', 'Completed', '2024-08-31', '20:00:00', '2024-08-25 15:00:00', '2024-08-27 10:46:47', '5'),
(13, '3', '3', '2', 200, 'ANG DAMI NYO EH', 'Rejected', '2024-08-29', '18:00:00', '2024-08-25 16:00:00', '2024-08-27 17:33:15', '5'),
(14, '4', '1', '1', 40, 'Queue too long', 'Pending', '2024-08-25', '15:24:00', '2024-08-25 07:31:01', '2024-08-27 15:44:42', '0'),
(15, '5', '14', '1', 40, 'test reason', 'Pending', '2024-08-25', '15:24:00', '2024-08-25 07:31:54', '2024-08-27 19:22:23', '14'),
(16, '6', '14', '1', 22, '', 'Completed', '2024-08-27', '15:33:00', '2024-08-25 07:32:20', '2024-08-27 07:45:23', '5'),
(17, '7', '14', '1', 22, '', 'Pending', '2024-08-27', '15:33:00', '2024-08-25 07:33:10', '2024-08-27 15:44:50', '0'),
(18, '8', '14', '1', 11, '', 'Pending', '2024-08-26', '15:47:00', '2024-08-25 07:47:13', '2024-08-27 15:44:53', '5'),
(19, '9', '14', '1', 11, '', 'Pending', '2024-08-26', '15:47:00', '2024-08-25 07:47:46', '2024-08-27 15:44:55', '5'),
(20, '10', '14', '1', 50, 'smuggler', 'Completed', '2024-08-28', '15:48:00', '2024-08-27 07:51:52', '2024-08-27 17:34:15', '5'),
(21, 'p5aciHpi', '14', '1', 1, NULL, 'Pending', '2024-08-29', '00:03:00', '2024-08-27 16:01:37', '2024-08-27 16:01:37', NULL),
(26, '3jnLSTih', '14', '1', 1, NULL, 'Pending', '2024-08-28', '00:04:00', '2024-08-27 16:04:16', '2024-08-27 16:04:16', NULL),
(27, 'AY1HNKGm', '14', '1', 1, 'szzz', 'Cancelled', '2024-08-31', '00:06:00', '2024-08-27 16:04:23', '2024-08-27 16:22:39', '14');

-- --------------------------------------------------------

--
-- Table structure for table `feedback`
--

CREATE TABLE IF NOT EXISTS `feedback` (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `feedback_id` varchar(20) NOT NULL,
  `user_id` varchar(20) NOT NULL,
  `rating` int(11) NOT NULL,
  `message` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `updated_by` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `feedback_id` (`feedback_id`),
  KEY `fk_feedback_user_id` (`user_id`),
  KEY `fk_feedback_updated_by` (`updated_by`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `feedback`
--

INSERT INTO `feedback` VALUES
(1, '4', '14', 5, 'test', '2024-08-26 04:33:17', '2024-08-26 04:33:17', NULL),
(2, '7', '14', 1, 'test', '2024-08-26 04:33:57', '2024-08-26 04:33:57', NULL),
(3, '8', '14', 1, 'test', '2024-08-26 04:34:48', '2024-08-26 04:34:48', NULL),
(4, '9', '14', 1, 'wew', '2024-08-26 04:34:53', '2024-08-26 04:34:53', NULL),
(7, '12', '14', 1, 'Baliwag', '2024-08-26 04:37:34', '2024-08-26 04:37:34', NULL),
(8, '13', '14', 5, 'bombaclart', '2024-08-26 06:38:53', '2024-08-26 06:38:53', NULL),
(9, '14', '14', 2, 'AGOYMODE', '2024-08-26 06:43:25', '2024-08-26 06:56:34', '3'),
(10, '15', '14', 5, 'bombaclot', '2024-08-26 06:43:57', '2024-08-26 06:43:57', NULL),
(11, '16', '14', 5, 'test', '2024-08-26 06:44:47', '2024-08-26 06:44:47', NULL),
(12, '17', '14', 5, 'bossing', '2024-08-26 06:45:17', '2024-08-26 06:45:17', NULL),
(13, '18', '14', 5, 'wew', '2024-08-26 06:46:18', '2024-08-26 06:56:11', '3'),
(14, '19', '14', 5, 'wewewe', '2024-08-26 06:46:48', '2024-08-26 06:46:48', NULL),
(15, '20', '14', 5, 'barurot', '2024-08-26 06:48:25', '2024-08-26 06:48:25', NULL),
(16, '21', '14', 5, 'testing bossing', '2024-08-26 06:52:12', '2024-08-26 06:52:12', NULL),
(17, '22', '3', 5, 'walang ganon bad yan', '2024-08-26 06:52:35', '2024-08-26 06:52:35', NULL),
(18, '23', '3', 5, 'testing bossing', '2024-08-26 06:53:11', '2024-08-26 06:53:11', NULL),
(19, '24', '14', 5, 'bombaclotsererer', '2024-08-26 06:55:55', '2024-08-26 06:55:55', NULL),
(20, '25', '14', 5, 'nyawkiks bay', '2024-08-26 23:46:58', '2024-08-26 23:46:58', NULL),
(21, 'JARVOIct', '14', 5, 'test', '2024-08-27 08:29:23', '2024-08-27 08:29:23', NULL),
(22, 'AAQ5153c', '14', 5, 'barbatos', '2024-08-27 08:29:30', '2024-08-27 08:29:30', NULL),
(23, '4jDjyFrs', '14', 5, 'bagal ng utak mo eh', '2024-08-27 09:20:09', '2024-08-27 09:20:09', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `logs`
--

CREATE TABLE IF NOT EXISTS `logs` (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `log_id` varchar(20) NOT NULL,
  `action` varchar(50) NOT NULL,
  `user_id` varchar(20) NOT NULL,
  `timestamp` datetime DEFAULT current_timestamp(),
  `description` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `log_id` (`log_id`),
  KEY `fk_logs_user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `logs`
--

INSERT INTO `logs` VALUES
(1, '1', 'User Login', '1', '2024-08-24 13:40:20', 'User John Doe logged in'),
(2, '2', 'Reservation Created', '4', '2024-08-24 13:00:00', 'Reservation created for 20 guests');

-- --------------------------------------------------------

--
-- Table structure for table `notification`
--

CREATE TABLE IF NOT EXISTS `notification` (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `notification_id` varchar(20) NOT NULL,
  `user_id` varchar(20) NOT NULL,
  `reservation_id` varchar(20) NOT NULL,
  `message` text NOT NULL,
  `notification_date` date DEFAULT current_timestamp(),
  `notification_time` time NOT NULL,
  `updated_by` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `notification_id` (`notification_id`),
  KEY `fk_notification_user_id` (`user_id`),
  KEY `fk_notification_reservation_id` (`reservation_id`),
  KEY `fk_notification_updated_by` (`updated_by`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `notification`
--

INSERT INTO `notification` VALUES
(1, '7', '3', '103', 'Your reservation at Branch C has been updated.', '2024-08-27', '00:00:00', '1'),
(2, '8', '1', '104', 'Reminder: Your reservation at Branch D is tomorrow.', '2024-08-27', '00:00:00', NULL),
(6, 't5Ed3mPs', '14', 'AY1HNKGm', 'Your reservation with ID AY1HNKGm has been cancelled. Reason: waw', '2024-08-27', '16:22:24', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `otplogs`
--

CREATE TABLE IF NOT EXISTS `otplogs` (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `otp_log_id` varchar(20) NOT NULL,
  `user_id` varchar(20) NOT NULL,
  `otp_code` varchar(10) NOT NULL,
  `timestamp` datetime DEFAULT current_timestamp(),
  `status` enum('Generated','Sent','Verified','Failed') DEFAULT 'Generated',
  `description` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `otp_log_id` (`otp_log_id`),
  KEY `fk_otplogs_user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `otplogs`
--

INSERT INTO `otplogs` VALUES
(1, '1', '2', '123456', '2024-08-24 12:00:00', 'Generated', 'OTP generated for verification'),
(2, '2', '1', '654321', '2024-08-24 13:00:00', 'Verified', 'OTP verified successfully');

-- --------------------------------------------------------

--
-- Table structure for table `userrole`
--

CREATE TABLE IF NOT EXISTS `userrole` (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `role_name` enum('Admin','Staff','User') NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `userrole`
--

INSERT INTO `userrole` VALUES
(1, 'Admin'),
(2, 'Staff'),
(3, 'User');

-- --------------------------------------------------------

--
-- Table structure for table `usertable`
--

CREATE TABLE IF NOT EXISTS `usertable` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
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
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`),
  UNIQUE KEY `unique_username` (`username`),
  UNIQUE KEY `unique_email_address` (`email_address`),
  KEY `fk_role_id` (`role_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `usertable`
--

INSERT INTO `usertable` VALUES
(1, '1', 'Johns', 'Dogs', 'john_doe', '$2b$12$fRT7yg6C6jBOlaKZlNhK/u7MiTkNlSXdjaz7by6S/JoSZ45gxKHja', 'john.doe@example.com', '(12) 34-567-890_', 3, NULL, '2024-08-24 13:40:20', '2024-08-27 16:29:58'),
(2, '2', 'Jane', 'Smithbebe', 'jane_smith', '$2b$12$fRT7yg6C6jBOlaKZlNhK/u7MiTkNlSXdjaz7by6S/JoSZ45gxKHja', 'jane.smith@example.com', '(23) 45-678-901_', 3, NULL, '2024-08-24 13:40:20', '2024-08-27 16:30:04'),
(3, '3', 'Admin', 'User', 'admin', '$2b$12$gttSgsgSfNjpD7l3PlKaqeBfb31shz4AtQS8dfNGvTdmVGXPbPPke', 'admin@gmail.com', '(12) 35-555-5555', 1, '2024-08-27 17:34:47', '2024-08-16 00:49:15', '2024-08-27 17:34:47'),
(4, '4', 'Test', 'User', 'testuser', '$2b$12$Aaj2g6wotDaqzDMe.JO3FOfhhAhUnzP75BchZTcUMyJYz94PQxbfG', 'testuser@gmail.com', '(12) 31-231-2312', 3, '2024-08-24 23:33:21', '2024-08-24 13:29:52', '2024-08-24 23:33:21'),
(5, '5', 'jaden smith', 'Member', 'staff', '$2b$12$RYUv5zarJenzfI5vXHBS5OBSAs9ufkcW40ljyMCERZE8HIIx4YWri', 'staff@gmail.com', '(12) 31-231-2312', 2, '2024-08-27 17:22:34', '2024-08-24 22:50:37', '2024-08-27 17:22:34'),
(7, '7', NULL, NULL, 'test', '$2b$12$JjvMQmVxp/PYaWM.XcbJSeAkcVhOAqCYW/dpk7SbOcbraqItCulMe', 'test@gmail.com', '(12) 31-231-2312', 3, '2024-08-25 06:19:49', '2024-08-25 06:19:43', '2024-08-25 06:19:49'),
(8, '14', 'dong', 'abay', 'newtest', '$2b$12$ldRCBjdH8WSU9dWUhctN8uJLEW1DH2nFLULyGqa2j/BT9frcWlz46', 'newtest@gmail.com', '(12) 31-231-2312', 3, '2024-08-27 17:34:33', '2024-08-25 07:45:59', '2024-08-27 17:34:33'),
(9, 'I910ZY33', NULL, NULL, 'teststaff', '$2b$12$qmAFV.zreaVYz.zv9CR1r.AkxYNwzq62MYc0sngywz73ouFGsKmrq', 'teststaff@gmail.com', '(12) 31-231-2312', 1, NULL, '2024-08-27 16:33:56', '2024-08-27 16:33:56'),
(10, 'IHrOCw3N', NULL, NULL, 'admint', '$2b$12$spqouEdk6XCbFBj6FNfNS.Etbau/Z7SG9CH3.xbxHzQ7ijKAr87Z.', 'admint@gmail.com', '(12) 31-231-2312', 1, NULL, '2024-08-27 16:42:22', '2024-08-27 16:42:22');

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
