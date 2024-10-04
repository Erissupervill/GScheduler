-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Aug 29, 2024 at 03:36 PM
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
  `id` int(11) UNSIGNED NOT NULL,
  `branch_id` varchar(20) NOT NULL,
  `name` varchar(255) NOT NULL,
  `capacity` int(11) NOT NULL,
  `location` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `branch`
--

INSERT INTO `branch` (`id`, `branch_id`, `name`, `capacity`, `location`) VALUES
(1, '1', 'Pasig', 97, 'Sto. Tomas'),
(2, '2', 'Taguig', 100, 'Sta. Ana');

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

--
-- Dumping data for table `customer_reservation`
--

INSERT INTO `customer_reservation` (`id`, `reservation_id`, `user_id`, `branch_id`, `number_of_guests`, `status_comment`, `status`, `reservation_date`, `reservation_time`, `created_at`, `updated_at`, `updated_by`) VALUES
(11, '1', '14', '1', 50, 'test', 'Cancelled', '2024-08-25', '19:00:00', '2024-08-25 14:00:00', '2024-08-28 14:31:07', '14'),
(12, '2', '2', '2', 30, 'too many guests', 'Completed', '2024-08-25', '20:00:00', '2024-08-25 15:00:00', '2024-08-28 14:31:09', '5'),
(13, '3', '3', '2', 200, 'ANG DAMI NYO EH', 'Rejected', '2024-08-31', '18:00:00', '2024-08-25 16:00:00', '2024-08-28 15:13:52', '5'),
(14, '4', '1', '1', 40, 'Queue too long', 'Pending', '2024-08-25', '15:24:00', '2024-08-25 07:31:01', '2024-08-27 15:44:42', '0'),
(15, '5', '14', '1', 40, 'test reason', 'Pending', '2024-08-25', '15:24:00', '2024-08-25 07:31:54', '2024-08-27 19:22:23', '14'),
(16, '6', '14', '1', 22, '', 'Completed', '2024-08-25', '15:33:00', '2024-08-25 07:32:20', '2024-08-28 14:31:16', '5'),
(17, '7', '14', '1', 22, '', 'Pending', '2024-08-29', '15:33:00', '2024-08-25 07:33:10', '2024-08-28 15:12:00', '0'),
(18, '8', '14', '1', 11, '', 'Pending', '2024-08-23', '15:47:00', '2024-08-25 07:47:13', '2024-08-28 15:11:57', '5'),
(19, '9', '14', '1', 11, '', 'Pending', '2024-08-24', '15:47:00', '2024-08-25 07:47:46', '2024-08-28 15:11:55', '5'),
(20, '10', '14', '1', 50, 'smuggler', 'Completed', '2024-08-26', '15:48:00', '2024-08-27 07:51:52', '2024-08-28 15:11:52', '5'),
(21, 'p5aciHpi', '14', '1', 1, NULL, 'Pending', '2024-08-27', '00:03:00', '2024-08-27 16:01:37', '2024-08-28 15:11:50', NULL),
(26, '3jnLSTih', '14', '1', 1, NULL, 'Pending', '2024-08-29', '00:04:00', '2024-08-27 16:04:16', '2024-08-28 15:11:47', NULL),
(27, 'AY1HNKGm', '14', '1', 1, 'szzz', 'Cancelled', '2024-08-28', '00:06:00', '2024-08-27 16:04:23', '2024-08-28 15:11:44', '14'),
(44, '33', '14', '1', 130, 'Test data 21', 'Completed', '2024-09-23', '22:00:00', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL),
(45, '34', '14', '2', 135, 'Test data 22', 'Cancelled', '2024-09-24', '23:00:00', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL),
(46, '35', '14', '1', 140, 'Test data 23', 'Pending', '2024-09-25', '18:00:00', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL),
(47, '36', '14', '2', 145, 'Test data 24', 'Completed', '2024-09-26', '19:00:00', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL),
(48, '37', '14', '1', 150, 'Test data 25', 'Cancelled', '2024-09-27', '20:00:00', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL),
(49, '38', '14', '2', 155, 'Test data 26', 'Pending', '2024-09-28', '21:00:00', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL),
(50, '39', '14', '1', 160, 'Test data 27', 'Completed', '2024-09-29', '22:00:00', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL),
(51, '40', '14', '2', 165, 'Test data 28', 'Cancelled', '2024-09-30', '23:00:00', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL),
(52, '41', '14', '1', 170, 'Test data 29', 'Pending', '2024-10-01', '18:00:00', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL),
(53, '42', '14', '2', 175, 'Test data 30', 'Completed', '2024-10-02', '19:00:00', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL),
(54, '43', '14', '1', 180, 'Test data 31', 'Cancelled', '2024-10-03', '20:00:00', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL),
(55, '44', '14', '2', 185, 'Test data 32', 'Pending', '2024-10-04', '21:00:00', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL),
(56, '45', '14', '1', 190, 'Test data 33', 'Completed', '2024-10-05', '22:00:00', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL),
(57, '46', '14', '2', 195, 'Test data 34', 'Cancelled', '2024-10-06', '23:00:00', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL),
(58, '47', '14', '1', 200, 'Test data 35', 'Pending', '2024-10-07', '18:00:00', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL),
(59, '48', '14', '2', 205, 'Test data 36', 'Completed', '2024-10-08', '19:00:00', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL),
(60, '49', '14', '1', 210, 'Test data 37', 'Cancelled', '2024-10-09', '20:00:00', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL),
(61, '50', '14', '2', 215, 'Test data 38', 'Pending', '2024-10-10', '21:00:00', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL),
(62, '51', '14', '1', 220, 'Test data 39', 'Completed', '2024-10-11', '22:00:00', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL),
(63, '52', '14', '2', 225, 'Test data 40', 'Cancelled', '2024-10-12', '23:00:00', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL),
(64, '53', '14', '1', 230, 'Test data 41', 'Pending', '2024-10-13', '18:00:00', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL),
(65, '54', '14', '2', 235, 'Test data 42', 'Completed', '2024-10-14', '19:00:00', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL),
(66, '55', '14', '1', 240, 'Test data 43', 'Cancelled', '2024-10-15', '20:00:00', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL),
(67, '56', '14', '2', 245, 'Test data 44', 'Pending', '2024-10-16', '21:00:00', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL),
(68, '57', '14', '1', 250, 'Test data 45', 'Completed', '2024-10-17', '22:00:00', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL),
(69, '58', '14', '2', 255, 'Test data 46', 'Cancelled', '2024-10-18', '23:00:00', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL),
(70, '59', '14', '1', 260, 'Test data 47', 'Pending', '2024-10-19', '18:00:00', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL),
(71, '60', '14', '2', 265, 'Test data 48', 'Completed', '2024-10-20', '19:00:00', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL),
(72, '61', '14', '1', 270, 'Test data 49', 'Cancelled', '2024-10-21', '20:00:00', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL),
(73, '62', '14', '2', 275, 'Test data 50', 'Pending', '2024-10-22', '21:00:00', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL),
(74, '63', '14', '1', 280, 'Test data 51', 'Completed', '2024-10-23', '22:00:00', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL),
(75, '64', '14', '2', 285, 'Test data 52', 'Cancelled', '2024-10-24', '23:00:00', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL),
(76, '65', '14', '1', 290, 'Test data 53', 'Pending', '2024-10-25', '18:00:00', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL),
(77, '66', '14', '2', 295, 'Test data 54', 'Completed', '2024-10-26', '19:00:00', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL),
(78, '67', '14', '1', 300, 'Test data 55', 'Cancelled', '2024-10-27', '20:00:00', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL),
(79, '68', '14', '2', 305, 'Test data 56', 'Pending', '2024-10-28', '21:00:00', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL),
(80, '69', '14', '1', 310, 'Test data 57', 'Completed', '2024-10-29', '22:00:00', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL),
(81, '70', '14', '2', 315, 'Test data 58', 'Cancelled', '2024-10-30', '23:00:00', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL),
(82, '71', '14', '1', 320, 'Test data 59', 'Pending', '2024-10-31', '18:00:00', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL),
(83, '72', '14', '2', 325, 'Test data 60', 'Completed', '2024-11-01', '19:00:00', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL),
(84, '73', '14', '1', 330, 'Test data 61', 'Cancelled', '2024-11-02', '20:00:00', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL),
(85, '74', '14', '2', 335, 'Test data 62', 'Pending', '2024-11-03', '21:00:00', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL),
(86, '75', '14', '1', 340, 'Test data 63', 'Completed', '2024-11-04', '22:00:00', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL),
(87, '76', '14', '2', 345, 'Test data 64', 'Cancelled', '2024-11-05', '23:00:00', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL),
(88, '77', '14', '1', 350, 'Test data 65', 'Pending', '2024-11-06', '18:00:00', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL),
(89, '78', '14', '2', 355, 'Test data 66', 'Completed', '2024-11-07', '19:00:00', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL),
(90, '79', '14', '1', 360, 'Test data 67', 'Cancelled', '2024-11-08', '20:00:00', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL),
(91, '80', '14', '2', 365, 'Test data 68', 'Pending', '2024-11-09', '21:00:00', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL),
(92, '81', '14', '1', 370, 'Test data 69', 'Completed', '2024-11-10', '22:00:00', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL),
(93, '82', '14', '2', 375, 'Test data 70', 'Cancelled', '2024-11-11', '23:00:00', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL),
(94, '83', '14', '1', 380, 'Test data 71', 'Pending', '2024-11-12', '18:00:00', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL),
(95, '84', '14', '2', 385, 'Test data 72', 'Completed', '2024-11-13', '19:00:00', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL);

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

--
-- Dumping data for table `feedback`
--

INSERT INTO `feedback` (`id`, `feedback_id`, `user_id`, `rating`, `message`, `created_at`, `updated_at`, `updated_by`) VALUES
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

CREATE TABLE `logs` (
  `id` int(11) UNSIGNED NOT NULL,
  `log_id` varchar(20) NOT NULL,
  `action` varchar(50) NOT NULL,
  `user_id` varchar(20) NOT NULL,
  `timestamp` datetime DEFAULT current_timestamp(),
  `description` text DEFAULT NULL,
  `browser` varchar(200) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `logs`
--

INSERT INTO `logs` (`id`, `log_id`, `action`, `user_id`, `timestamp`, `description`, `browser`) VALUES
(1, 'g79R0F5R', 'View User Logs', '3', '2024-08-29 04:49:37', 'User Admin User accessed /Admin/Logs/User', 'Chrome 128.0.0'),
(2, 'RkiufU2g', 'View User Logs', '3', '2024-08-29 04:52:38', 'User Admin User accessed /Admin/Logs/User', 'Chrome 128.0.0'),
(3, 'iIet4GFP', 'View Admin Dashboard', '3', '2024-08-29 04:52:38', 'User Admin User accessed /Admin/Dashboard', 'Chrome 128.0.0'),
(4, 'avEq4ANS', 'View Reservation Predictions', '3', '2024-08-29 04:52:38', 'User Admin User accessed /Admin/api/reservation_predictions', 'Chrome 128.0.0'),
(5, '9vkIQ3Km', 'View User Logs', '3', '2024-08-29 04:52:39', 'User Admin User accessed /Admin/Logs/User', 'Chrome 128.0.0'),
(6, '9hSBTI5I', 'View Admin Dashboard', '3', '2024-08-29 04:52:39', 'User Admin User accessed /Admin/Dashboard', 'Chrome 128.0.0'),
(7, 'Negm1Xwv', 'View Reservation Predictions', '3', '2024-08-29 04:52:40', 'User Admin User accessed /Admin/api/reservation_predictions', 'Chrome 128.0.0'),
(8, 'mUQ9t1ny', 'View Admin Dashboard', '3', '2024-08-29 04:53:04', 'User Admin User accessed /Admin/Dashboard', 'Chrome 128.0.0'),
(9, 'yFJwQY6o', 'View Reservation Predictions', '3', '2024-08-29 04:53:04', 'User Admin User accessed /Admin/api/reservation_predictions', 'Chrome 128.0.0'),
(10, 'Rf3Kybnn', 'View User Logs', '3', '2024-08-29 04:53:05', 'User Admin User accessed /Admin/Logs/User', 'Chrome 128.0.0'),
(11, 'wYAjNTpS', 'View Admin Dashboard', '3', '2024-08-29 04:53:05', 'User Admin User accessed /Admin/Dashboard', 'Chrome 128.0.0'),
(12, 'IOfKWqxl', 'View Reservation Predictions', '3', '2024-08-29 04:53:06', 'User Admin User accessed /Admin/api/reservation_predictions', 'Chrome 128.0.0'),
(13, 'vUvFWCmG', 'View Admin Dashboard', '3', '2024-08-29 04:53:34', 'User Admin User accessed /Admin/Dashboard', 'Chrome 128.0.0'),
(14, 'uoIGMyXz', 'View Reservation Predictions', '3', '2024-08-29 04:53:34', 'User Admin User accessed /Admin/api/reservation_predictions', 'Chrome 128.0.0'),
(15, '5EIxk8fO', 'View User Logs', '3', '2024-08-29 04:53:34', 'User Admin User accessed /Admin/Logs/User', 'Chrome 128.0.0'),
(16, 'i1LmkHCQ', 'View User Logs', '3', '2024-08-29 04:53:49', 'User Admin User accessed /Admin/Logs/User', 'Chrome 128.0.0'),
(17, 'KXSddRtn', 'View Admin Dashboard', '3', '2024-08-29 04:53:49', 'User Admin User accessed /Admin/Dashboard', 'Chrome 128.0.0'),
(18, 'hYk9mZGe', 'View Reservation Predictions', '3', '2024-08-29 04:53:50', 'User Admin User accessed /Admin/api/reservation_predictions', 'Chrome 128.0.0'),
(19, '0Hx62N99', 'View Admin Dashboard', '3', '2024-08-29 04:54:10', 'User Admin User accessed /Admin/Dashboard', 'Chrome 128.0.0'),
(20, '1dUDbbBu', 'View Reservation Predictions', '3', '2024-08-29 04:54:10', 'User Admin User accessed /Admin/api/reservation_predictions', 'Chrome 128.0.0'),
(21, 'hSs42Czn', 'View User Logs', '3', '2024-08-29 04:54:11', 'User Admin User accessed /Admin/Logs/User', 'Chrome 128.0.0'),
(22, 'ui3JvZvr', 'View Admin Dashboard', '3', '2024-08-29 04:54:11', 'User Admin User accessed /Admin/Dashboard', 'Chrome 128.0.0'),
(23, 'KJ0zhNcM', 'View Reservation Predictions', '3', '2024-08-29 04:54:11', 'User Admin User accessed /Admin/api/reservation_predictions', 'Chrome 128.0.0'),
(24, 'MLsll26I', 'View User Logs', '3', '2024-08-29 04:55:12', 'User Admin User accessed /Admin/Logs/User', 'Chrome 128.0.0'),
(25, 'u7vKpGyo', 'View User Logs', '3', '2024-08-29 04:55:18', 'User Admin User accessed /Admin/Logs/User', 'Chrome 128.0.0'),
(26, 'CDewB147', 'View User Logs', '3', '2024-08-29 04:55:40', 'User Admin User accessed /Admin/Logs/User', 'Chrome 128.0.0'),
(27, 'Vfpr0SFy', 'View User Logs', '3', '2024-08-29 04:55:50', 'User Admin User accessed /Admin/Logs/User', 'Chrome 128.0.0'),
(28, 'Rsw14OKK', 'View User Logs', '3', '2024-08-29 04:56:50', 'User Admin User accessed /Admin/Logs/User', 'Chrome 128.0.0'),
(29, 'ZED6v138', 'View User Logs', '3', '2024-08-29 04:56:59', 'User Admin User accessed /Admin/Logs/User', 'Chrome 128.0.0'),
(30, 'hll5dlsG', 'View Admin Dashboard', '3', '2024-08-29 04:56:59', 'User Admin User accessed /Admin/Dashboard', 'Chrome 128.0.0'),
(31, 'AvIUCjoS', 'View Reservation Predictions', '3', '2024-08-29 04:56:59', 'User Admin User accessed /Admin/api/reservation_predictions', 'Chrome 128.0.0'),
(32, 'hkdvkj1N', 'View Admin Dashboard', '3', '2024-08-29 04:57:21', 'User Admin User accessed /Admin/Dashboard', 'Chrome 128.0.0'),
(33, '6UaFXpcp', 'View Reservation Predictions', '3', '2024-08-29 04:57:21', 'User Admin User accessed /Admin/api/reservation_predictions', 'Chrome 128.0.0'),
(34, 'EOpgSQnN', 'View User Logs', '3', '2024-08-29 04:57:21', 'User Admin User accessed /Admin/Logs/User', 'Chrome 128.0.0'),
(35, 'B6lRd6Tr', 'View User Logs', '3', '2024-08-29 04:57:41', 'User Admin User accessed /Admin/Logs/User', 'Chrome 128.0.0'),
(36, 'G6GCl4KB', 'Unknown Action', '3', '2024-08-29 04:57:49', 'User Admin User accessed /Admin/Create/User', 'Chrome 128.0.0'),
(37, 'FgjG1yoJ', 'Unknown Action', '3', '2024-08-29 05:00:42', 'User Admin User accessed /Admin/Create/User', 'Chrome 128.0.0'),
(38, 'eW5xRO0r', 'Unknown Action', '3', '2024-08-29 05:00:43', 'User Admin User accessed /Admin/Feedbacks', 'Chrome 128.0.0'),
(39, '7mSwkp3v', 'Unknown Action', '3', '2024-08-29 05:00:44', 'User Admin User accessed /Admin/Create/User', 'Chrome 128.0.0'),
(40, 'BTnQ1n0A', 'View User List', '3', '2024-08-29 05:00:45', 'User Admin User accessed /Admin/Users', 'Chrome 128.0.0'),
(41, 'fxurnbLZ', 'View Admin Dashboard', '3', '2024-08-29 05:00:45', 'User Admin User accessed /Admin/Dashboard', 'Chrome 128.0.0'),
(42, 'AucmuuFT', 'View Reservation Predictions', '3', '2024-08-29 05:00:45', 'User Admin User accessed /Admin/api/reservation_predictions', 'Chrome 128.0.0'),
(43, '1RNDNSzI', 'View User Logs', '3', '2024-08-29 05:00:46', 'User Admin User accessed /Admin/Logs/User', 'Chrome 128.0.0'),
(44, 'x4cvQQAf', 'View User Logs', '3', '2024-08-29 05:01:07', 'User Admin User accessed /Admin/Logs/User', 'Chrome 128.0.0'),
(45, 'd1g1wN6v', 'View User Logs', '3', '2024-08-29 05:02:11', 'User Admin User accessed /Admin/Logs/User', 'Chrome 128.0.0'),
(46, 'xSQ8JTKF', 'View User Logs', '3', '2024-08-29 05:02:38', 'User Admin User accessed /Admin/Logs/User', 'Chrome 128.0.0'),
(47, 'Y8LPuaBt', 'View User Logs', '3', '2024-08-29 05:03:24', 'User Admin User accessed /Admin/Logs/User', 'Chrome 128.0.0'),
(48, 'LmuTDvhX', 'View User Logs', '3', '2024-08-29 05:03:33', 'User Admin User accessed /Admin/Logs/User', 'Chrome 128.0.0'),
(49, 'caoq0FBM', 'View Feedbacks', '3', '2024-08-29 05:03:33', 'User Admin User accessed /Admin/Feedbacks', 'Chrome 128.0.0'),
(50, 'd86vbtE2', 'Create New User', '3', '2024-08-29 05:03:34', 'User Admin User accessed /Admin/Create/User', 'Chrome 128.0.0'),
(51, '6NWH1ZdZ', 'View Feedbacks', '3', '2024-08-29 05:03:34', 'User Admin User accessed /Admin/Feedbacks', 'Chrome 128.0.0'),
(52, 'SDMGPFzv', 'View User Logs', '3', '2024-08-29 05:03:39', 'User Admin User accessed /Admin/Logs/User', 'Chrome 128.0.0'),
(53, 'NQavs6wB', 'Create New User', '3', '2024-08-29 05:03:57', 'User Admin User accessed /Admin/Create/User', 'Chrome 128.0.0'),
(54, 'wZwxRcNT', 'View Admin Dashboard', '3', '2024-08-29 13:10:57', 'User Admin User accessed /Admin/Dashboard with action: View Admin Dashboard', 'Chrome 128.0.0'),
(55, 'ruK9GxgJ', 'Unknown Action', '3', '2024-08-29 13:10:57', 'User Admin User accessed /api/peak_time_predictions with action: Unknown Action', 'Chrome 128.0.0'),
(56, '3jVOP8ee', 'Unknown Action', '3', '2024-08-29 13:10:57', 'User Admin User accessed /api/daily_booking_summary with action: Unknown Action', 'Chrome 128.0.0'),
(57, '6Q98uxkm', 'Unknown Action', '3', '2024-08-29 13:10:57', 'User Admin User accessed /api/weekly_booking_summary with action: Unknown Action', 'Chrome 128.0.0'),
(58, 'OwMYmynO', 'Unknown Action', '3', '2024-08-29 13:10:57', 'User Admin User accessed /api/monthly_booking_summary with action: Unknown Action', 'Chrome 128.0.0'),
(59, 'IcVHxb68', 'Unknown Action', '3', '2024-08-29 13:10:57', 'User Admin User accessed /api/reservation_predictions with action: Unknown Action', 'Chrome 128.0.0'),
(60, 'HkrHxvKC', 'View Admin Dashboard', '3', '2024-08-29 13:11:06', 'User Admin User accessed /Admin/Dashboard with action: View Admin Dashboard', 'Chrome 128.0.0'),
(61, 'q9K5nUwe', 'Unknown Action', '3', '2024-08-29 13:11:07', 'User Admin User accessed /api/peak_time_predictions with action: Unknown Action', 'Chrome 128.0.0'),
(62, 'ADVTTGvb', 'Unknown Action', '3', '2024-08-29 13:11:07', 'User Admin User accessed /api/daily_booking_summary with action: Unknown Action', 'Chrome 128.0.0'),
(63, 'Cijivoma', 'Unknown Action', '3', '2024-08-29 13:11:07', 'User Admin User accessed /api/weekly_booking_summary with action: Unknown Action', 'Chrome 128.0.0'),
(64, '9QxdpTg5', 'Unknown Action', '3', '2024-08-29 13:11:07', 'User Admin User accessed /api/monthly_booking_summary with action: Unknown Action', 'Chrome 128.0.0'),
(65, 'Mvj2mLVQ', 'Unknown Action', '3', '2024-08-29 13:11:07', 'User Admin User accessed /api/reservation_predictions with action: Unknown Action', 'Chrome 128.0.0'),
(66, 'NpFlmMmP', 'Unknown Action', '3', '2024-08-29 13:11:18', 'User Admin User accessed /api/reservation_predictions with action: Unknown Action', 'Chrome 128.0.0'),
(67, 'LtBbdiMm', 'Unknown Action', '3', '2024-08-29 13:11:47', 'User Admin User accessed /api/reservation_predictions with action: Unknown Action', 'Chrome 128.0.0'),
(68, 'KKWwHntp', 'Unknown Action', '3', '2024-08-29 13:12:00', 'User Admin User accessed /api/reservation_predictions with action: Unknown Action', 'Chrome 128.0.0'),
(69, 'g4CE2HTT', 'View Admin Dashboard', '3', '2024-08-29 13:12:02', 'User Admin User accessed /Admin/Dashboard with action: View Admin Dashboard', 'Chrome 128.0.0'),
(70, 'hV3snx0w', 'Unknown Action', '3', '2024-08-29 13:12:02', 'User Admin User accessed /api/peak_time_predictions with action: Unknown Action', 'Chrome 128.0.0'),
(71, 'C10nj1wA', 'Unknown Action', '3', '2024-08-29 13:12:02', 'User Admin User accessed /api/daily_booking_summary with action: Unknown Action', 'Chrome 128.0.0'),
(72, 'O3o21R2R', 'Unknown Action', '3', '2024-08-29 13:12:02', 'User Admin User accessed /api/weekly_booking_summary with action: Unknown Action', 'Chrome 128.0.0'),
(73, 'qzLLR9ri', 'Unknown Action', '3', '2024-08-29 13:12:02', 'User Admin User accessed /api/monthly_booking_summary with action: Unknown Action', 'Chrome 128.0.0'),
(74, 'qTjogllh', 'Unknown Action', '3', '2024-08-29 13:12:02', 'User Admin User accessed /api/reservation_predictions with action: Unknown Action', 'Chrome 128.0.0'),
(75, 'rkEzYhG8', 'View Admin Dashboard', '3', '2024-08-29 13:12:33', 'User Admin User accessed /Admin/Dashboard with action: View Admin Dashboard', 'Chrome 128.0.0'),
(76, 'aetsqX4I', 'Unknown Action', '3', '2024-08-29 13:12:33', 'User Admin User accessed /api/peak_time_predictions with action: Unknown Action', 'Chrome 128.0.0'),
(77, 'HoaVOmgJ', 'Unknown Action', '3', '2024-08-29 13:12:33', 'User Admin User accessed /api/daily_booking_summary with action: Unknown Action', 'Chrome 128.0.0'),
(78, 'WqAsgTsa', 'Unknown Action', '3', '2024-08-29 13:12:33', 'User Admin User accessed /api/weekly_booking_summary with action: Unknown Action', 'Chrome 128.0.0'),
(79, 'HvvaP6SL', 'Unknown Action', '3', '2024-08-29 13:12:33', 'User Admin User accessed /api/monthly_booking_summary with action: Unknown Action', 'Chrome 128.0.0'),
(80, 'AIk4pMXj', 'Unknown Action', '3', '2024-08-29 13:12:33', 'User Admin User accessed /api/reservation_predictions with action: Unknown Action', 'Chrome 128.0.0'),
(81, 'fQF7teDn', 'View Admin Dashboard', '3', '2024-08-29 13:13:34', 'User Admin User accessed /Admin/Dashboard with action: View Admin Dashboard', 'Chrome 128.0.0'),
(82, 'SQboPag2', 'Unknown Action', '3', '2024-08-29 13:13:35', 'User Admin User accessed /api/peak_time_predictions with action: Unknown Action', 'Chrome 128.0.0'),
(83, 'EeEnHaf1', 'Unknown Action', '3', '2024-08-29 13:13:35', 'User Admin User accessed /api/daily_booking_summary with action: Unknown Action', 'Chrome 128.0.0'),
(84, 'RdMaFVOt', 'Unknown Action', '3', '2024-08-29 13:13:35', 'User Admin User accessed /api/weekly_booking_summary with action: Unknown Action', 'Chrome 128.0.0'),
(85, 'PLRn1L0q', 'Unknown Action', '3', '2024-08-29 13:13:35', 'User Admin User accessed /api/monthly_booking_summary with action: Unknown Action', 'Chrome 128.0.0'),
(86, 'BDNWecqM', 'Unknown Action', '3', '2024-08-29 13:13:35', 'User Admin User accessed /api/reservation_predictions with action: Unknown Action', 'Chrome 128.0.0'),
(87, 'OXJxSOdQ', 'View Admin Dashboard', '3', '2024-08-29 13:13:53', 'User Admin User accessed /Admin/Dashboard with action: View Admin Dashboard', 'Chrome 128.0.0'),
(88, 'qlvnfebC', 'Unknown Action', '3', '2024-08-29 13:13:54', 'User Admin User accessed /api/peak_time_predictions with action: Unknown Action', 'Chrome 128.0.0'),
(89, 'mzmFuu0h', 'Unknown Action', '3', '2024-08-29 13:13:54', 'User Admin User accessed /api/daily_booking_summary with action: Unknown Action', 'Chrome 128.0.0'),
(90, '3jBkaXGH', 'Unknown Action', '3', '2024-08-29 13:13:54', 'User Admin User accessed /api/weekly_booking_summary with action: Unknown Action', 'Chrome 128.0.0'),
(91, 'FtmkkTnS', 'Unknown Action', '3', '2024-08-29 13:13:54', 'User Admin User accessed /api/monthly_booking_summary with action: Unknown Action', 'Chrome 128.0.0'),
(92, 'e3SD7dxz', 'Unknown Action', '3', '2024-08-29 13:13:54', 'User Admin User accessed /api/reservation_predictions with action: Unknown Action', 'Chrome 128.0.0'),
(93, '4ec87XiF', 'View Admin Dashboard', '3', '2024-08-29 13:14:36', 'User Admin User accessed /Admin/Dashboard with action: View Admin Dashboard', 'Chrome 128.0.0'),
(94, 'jyHlavaW', 'Unknown Action', '3', '2024-08-29 13:14:36', 'User Admin User accessed /api/peak_time_predictions with action: Unknown Action', 'Chrome 128.0.0'),
(95, 'xCirepEq', 'Unknown Action', '3', '2024-08-29 13:14:36', 'User Admin User accessed /api/daily_booking_summary with action: Unknown Action', 'Chrome 128.0.0'),
(96, 'G0tgKQMd', 'Unknown Action', '3', '2024-08-29 13:14:36', 'User Admin User accessed /api/weekly_booking_summary with action: Unknown Action', 'Chrome 128.0.0'),
(97, 'WV0MTjMB', 'Unknown Action', '3', '2024-08-29 13:14:36', 'User Admin User accessed /api/monthly_booking_summary with action: Unknown Action', 'Chrome 128.0.0'),
(98, 'ae8Xtx35', 'Unknown Action', '3', '2024-08-29 13:14:36', 'User Admin User accessed /api/reservation_predictions with action: Unknown Action', 'Chrome 128.0.0'),
(99, '6BWR7Ii1', 'View Admin Dashboard', '3', '2024-08-29 13:16:17', 'User Admin User accessed /Admin/Dashboard with action: View Admin Dashboard', 'Chrome 128.0.0'),
(100, 'tWpIRKdn', 'Unknown Action', '3', '2024-08-29 13:16:17', 'User Admin User accessed /api/daily_booking_summary with action: Unknown Action', 'Chrome 128.0.0'),
(101, '7If97js7', 'Unknown Action', '3', '2024-08-29 13:16:17', 'User Admin User accessed /api/weekly_booking_summary with action: Unknown Action', 'Chrome 128.0.0'),
(102, 'YiZBbFFE', 'Unknown Action', '3', '2024-08-29 13:16:17', 'User Admin User accessed /api/monthly_booking_summary with action: Unknown Action', 'Chrome 128.0.0'),
(103, 'P16wDshv', 'Unknown Action', '3', '2024-08-29 13:16:17', 'User Admin User accessed /api/reservation_predictions with action: Unknown Action', 'Chrome 128.0.0'),
(104, 'dhxOMCEs', 'View Admin Dashboard', '3', '2024-08-29 13:16:33', 'User Admin User accessed /Admin/Dashboard with action: View Admin Dashboard', 'Chrome 128.0.0'),
(105, 'RUZmGHEs', 'Unknown Action', '3', '2024-08-29 13:16:34', 'User Admin User accessed /api/peak_time_predictions with action: Unknown Action', 'Chrome 128.0.0'),
(106, 'nwXFB9LU', 'Unknown Action', '3', '2024-08-29 13:16:34', 'User Admin User accessed /api/daily_booking_summary with action: Unknown Action', 'Chrome 128.0.0'),
(107, '7wD7oqGy', 'Unknown Action', '3', '2024-08-29 13:16:34', 'User Admin User accessed /api/weekly_booking_summary with action: Unknown Action', 'Chrome 128.0.0'),
(108, 'T54NgGqb', 'Unknown Action', '3', '2024-08-29 13:16:34', 'User Admin User accessed /api/monthly_booking_summary with action: Unknown Action', 'Chrome 128.0.0'),
(109, '9NcxYUUT', 'Unknown Action', '3', '2024-08-29 13:16:34', 'User Admin User accessed /api/reservation_predictions with action: Unknown Action', 'Chrome 128.0.0'),
(110, 'aCmRip7L', 'View Admin Dashboard', '3', '2024-08-29 13:17:18', 'User Admin User accessed /Admin/Dashboard with action: View Admin Dashboard', 'Chrome 128.0.0'),
(111, 'njurrq2K', 'Unknown Action', '3', '2024-08-29 13:17:18', 'User Admin User accessed /api/daily_booking_summary with action: Unknown Action', 'Chrome 128.0.0'),
(112, 's5L0bIad', 'Unknown Action', '3', '2024-08-29 13:17:18', 'User Admin User accessed /api/peak_time_predictions with action: Unknown Action', 'Chrome 128.0.0'),
(113, 'Dxd0AulH', 'Unknown Action', '3', '2024-08-29 13:17:18', 'User Admin User accessed /api/weekly_booking_summary with action: Unknown Action', 'Chrome 128.0.0'),
(114, 'CMdAPGIg', 'Unknown Action', '3', '2024-08-29 13:17:18', 'User Admin User accessed /api/reservation_predictions with action: Unknown Action', 'Chrome 128.0.0'),
(115, 'yHCJG6ji', 'Unknown Action', '3', '2024-08-29 13:17:18', 'User Admin User accessed /api/monthly_booking_summary with action: Unknown Action', 'Chrome 128.0.0'),
(116, 'nJkijPrS', 'View Admin Dashboard', '3', '2024-08-29 13:17:29', 'User Admin User accessed /Admin/Dashboard with action: View Admin Dashboard', 'Chrome 128.0.0'),
(117, '7DLYjGbP', 'Unknown Action', '3', '2024-08-29 13:17:30', 'User Admin User accessed /api/daily_booking_summary with action: Unknown Action', 'Chrome 128.0.0'),
(118, 'mZtCMdPy', 'Unknown Action', '3', '2024-08-29 13:17:30', 'User Admin User accessed /api/weekly_booking_summary with action: Unknown Action', 'Chrome 128.0.0'),
(119, 'vLGffvLx', 'Unknown Action', '3', '2024-08-29 13:17:30', 'User Admin User accessed /api/monthly_booking_summary with action: Unknown Action', 'Chrome 128.0.0'),
(120, 'mncfnsch', 'Unknown Action', '3', '2024-08-29 13:17:30', 'User Admin User accessed /api/reservation_predictions with action: Unknown Action', 'Chrome 128.0.0'),
(121, '3ONcydXr', 'View Admin Dashboard', '3', '2024-08-29 13:18:42', 'User Admin User accessed /Admin/Dashboard with action: View Admin Dashboard', 'Chrome 128.0.0'),
(122, '8YLyTruL', 'Unknown Action', '3', '2024-08-29 13:18:42', 'User Admin User accessed /api/daily_booking_summary with action: Unknown Action', 'Chrome 128.0.0'),
(123, 'nPOL6n9S', 'Unknown Action', '3', '2024-08-29 13:18:42', 'User Admin User accessed /api/weekly_booking_summary with action: Unknown Action', 'Chrome 128.0.0'),
(124, 'ssdiI9UV', 'Unknown Action', '3', '2024-08-29 13:18:42', 'User Admin User accessed /api/monthly_booking_summary with action: Unknown Action', 'Chrome 128.0.0'),
(125, 'ShicttSN', 'Unknown Action', '3', '2024-08-29 13:18:42', 'User Admin User accessed /api/reservation_predictions with action: Unknown Action', 'Chrome 128.0.0'),
(126, '7htu3ES0', 'View User List', '3', '2024-08-29 13:18:43', 'User Admin User accessed /Admin/Users with action: View User List', 'Chrome 128.0.0'),
(127, '5fP9RJIY', 'View Admin Dashboard', '3', '2024-08-29 13:18:45', 'User Admin User accessed /Admin/Dashboard with action: View Admin Dashboard', 'Chrome 128.0.0'),
(128, 'ZvwawrUs', 'Unknown Action', '3', '2024-08-29 13:18:45', 'User Admin User accessed /api/daily_booking_summary with action: Unknown Action', 'Chrome 128.0.0'),
(129, 'Onv2eCNy', 'Unknown Action', '3', '2024-08-29 13:18:45', 'User Admin User accessed /api/weekly_booking_summary with action: Unknown Action', 'Chrome 128.0.0'),
(130, 'D0MfXJXh', 'Unknown Action', '3', '2024-08-29 13:18:45', 'User Admin User accessed /api/monthly_booking_summary with action: Unknown Action', 'Chrome 128.0.0'),
(131, 'u4YDlDsQ', 'Unknown Action', '3', '2024-08-29 13:18:45', 'User Admin User accessed /api/reservation_predictions with action: Unknown Action', 'Chrome 128.0.0'),
(132, 'fya54Dqk', 'Unknown Action', '3', '2024-08-29 13:18:56', 'User Admin User accessed /api/peak_time_predictions with action: Unknown Action', 'Chrome 128.0.0'),
(133, '4NsCaR9P', 'View Admin Dashboard', '3', '2024-08-29 13:19:04', 'User Admin User accessed /Admin/Dashboard with action: View Admin Dashboard', 'Chrome 128.0.0'),
(134, '9zd9VCJy', 'Unknown Action', '3', '2024-08-29 13:19:04', 'User Admin User accessed /api/peak_time_predictions with action: Unknown Action', 'Chrome 128.0.0'),
(135, 'FXe0xYAf', 'Unknown Action', '3', '2024-08-29 13:19:04', 'User Admin User accessed /api/daily_booking_summary with action: Unknown Action', 'Chrome 128.0.0'),
(136, 'f2ummV7c', 'Unknown Action', '3', '2024-08-29 13:19:04', 'User Admin User accessed /api/weekly_booking_summary with action: Unknown Action', 'Chrome 128.0.0'),
(137, 'rSNFRNfU', 'Unknown Action', '3', '2024-08-29 13:19:04', 'User Admin User accessed /api/monthly_booking_summary with action: Unknown Action', 'Chrome 128.0.0'),
(138, 'MTf9lXfl', 'Unknown Action', '3', '2024-08-29 13:19:04', 'User Admin User accessed /api/reservation_predictions with action: Unknown Action', 'Chrome 128.0.0'),
(139, 'nDLFXeZ9', 'View Admin Dashboard', '3', '2024-08-29 13:20:59', 'User Admin User accessed /Admin/Dashboard with action: View Admin Dashboard', 'Chrome 128.0.0'),
(140, 'filIjCuY', 'Unknown Action', '3', '2024-08-29 13:20:59', 'User Admin User accessed /api/peak_time_predictions with action: Unknown Action', 'Chrome 128.0.0'),
(141, 'ZfSTlqiq', 'Unknown Action', '3', '2024-08-29 13:20:59', 'User Admin User accessed /api/daily_booking_summary with action: Unknown Action', 'Chrome 128.0.0'),
(142, '44Dh97eN', 'Unknown Action', '3', '2024-08-29 13:20:59', 'User Admin User accessed /api/weekly_booking_summary with action: Unknown Action', 'Chrome 128.0.0'),
(143, 'DjR41Tdv', 'Unknown Action', '3', '2024-08-29 13:20:59', 'User Admin User accessed /api/reservation_predictions with action: Unknown Action', 'Chrome 128.0.0'),
(144, 'oB2CjxPy', 'Unknown Action', '3', '2024-08-29 13:20:59', 'User Admin User accessed /api/monthly_booking_summary with action: Unknown Action', 'Chrome 128.0.0'),
(145, 'vjo3vQ5W', 'View Admin Dashboard', '3', '2024-08-29 13:21:08', 'User Admin User accessed /Admin/Dashboard with action: View Admin Dashboard', 'Chrome 128.0.0'),
(146, 'GQqt692y', 'View Admin Dashboard', '3', '2024-08-29 13:21:23', 'User Admin User accessed /Admin/Dashboard with action: View Admin Dashboard', 'Chrome 128.0.0'),
(147, 'BrN1MThM', 'Unknown Action', '3', '2024-08-29 13:21:23', 'User Admin User accessed /api/daily_booking_summary with action: Unknown Action', 'Chrome 128.0.0'),
(148, 'WyxnCbzW', 'Unknown Action', '3', '2024-08-29 13:21:23', 'User Admin User accessed /api/weekly_booking_summary with action: Unknown Action', 'Chrome 128.0.0'),
(149, '1wAR3eZ8', 'Unknown Action', '3', '2024-08-29 13:21:23', 'User Admin User accessed /api/monthly_booking_summary with action: Unknown Action', 'Chrome 128.0.0'),
(150, 'kdzUVf3v', 'Unknown Action', '3', '2024-08-29 13:21:23', 'User Admin User accessed /api/reservation_predictions with action: Unknown Action', 'Chrome 128.0.0'),
(151, 'zRwCRJHz', 'View Admin Dashboard', '3', '2024-08-29 13:21:27', 'User Admin User accessed /Admin/Dashboard with action: View Admin Dashboard', 'Chrome 128.0.0'),
(152, 'OJlCtVWA', 'Unknown Action', '3', '2024-08-29 13:21:27', 'User Admin User accessed /api/peak_time_predictions with action: Unknown Action', 'Chrome 128.0.0'),
(153, 'alpTeF9w', 'Unknown Action', '3', '2024-08-29 13:21:27', 'User Admin User accessed /api/daily_booking_summary with action: Unknown Action', 'Chrome 128.0.0'),
(154, 'el8uEdON', 'Unknown Action', '3', '2024-08-29 13:21:27', 'User Admin User accessed /api/weekly_booking_summary with action: Unknown Action', 'Chrome 128.0.0'),
(155, '5Ip4So0u', 'Unknown Action', '3', '2024-08-29 13:21:27', 'User Admin User accessed /api/monthly_booking_summary with action: Unknown Action', 'Chrome 128.0.0'),
(156, 'RbpZWdbZ', 'Unknown Action', '3', '2024-08-29 13:21:27', 'User Admin User accessed /api/reservation_predictions with action: Unknown Action', 'Chrome 128.0.0'),
(157, 'ieFUaJCn', 'View Admin Dashboard', '3', '2024-08-29 13:22:21', 'User Admin User accessed /Admin/Dashboard with action: View Admin Dashboard', 'Chrome 128.0.0'),
(158, 'wjPNcKxS', 'Unknown Action', '3', '2024-08-29 13:22:21', 'User Admin User accessed /api/peak_time_predictions with action: Unknown Action', 'Chrome 128.0.0'),
(159, 'BIITQz9U', 'Unknown Action', '3', '2024-08-29 13:22:21', 'User Admin User accessed /api/daily_booking_summary with action: Unknown Action', 'Chrome 128.0.0'),
(160, 'nUShjgxD', 'Unknown Action', '3', '2024-08-29 13:22:21', 'User Admin User accessed /api/weekly_booking_summary with action: Unknown Action', 'Chrome 128.0.0'),
(161, 'daXpS6eD', 'Unknown Action', '3', '2024-08-29 13:22:21', 'User Admin User accessed /api/monthly_booking_summary with action: Unknown Action', 'Chrome 128.0.0'),
(162, 'IgfXyeMz', 'Unknown Action', '3', '2024-08-29 13:22:21', 'User Admin User accessed /api/reservation_predictions with action: Unknown Action', 'Chrome 128.0.0'),
(163, '6o9Zk2Nt', 'View Admin Dashboard', '3', '2024-08-29 13:23:21', 'User Admin User accessed /Admin/Dashboard with action: View Admin Dashboard', 'Chrome 128.0.0'),
(164, 'QyoijAlK', 'View Admin Dashboard', '3', '2024-08-29 13:23:36', 'User Admin User accessed /Admin/Dashboard with action: View Admin Dashboard', 'Chrome 128.0.0'),
(165, 'tWLIjuyF', 'Unknown Action', '3', '2024-08-29 13:23:36', 'User Admin User accessed /api/peak_time_predictions with action: Unknown Action', 'Chrome 128.0.0'),
(166, 'WfOLFj9D', 'Unknown Action', '3', '2024-08-29 13:23:36', 'User Admin User accessed /api/daily_booking_summary with action: Unknown Action', 'Chrome 128.0.0'),
(167, 'xrvP6WTe', 'Unknown Action', '3', '2024-08-29 13:23:36', 'User Admin User accessed /api/weekly_booking_summary with action: Unknown Action', 'Chrome 128.0.0'),
(168, 'slY8sVXU', 'Unknown Action', '3', '2024-08-29 13:23:36', 'User Admin User accessed /api/reservation_predictions with action: Unknown Action', 'Chrome 128.0.0'),
(169, 'vVbL9bVa', 'Unknown Action', '3', '2024-08-29 13:23:36', 'User Admin User accessed /api/monthly_booking_summary with action: Unknown Action', 'Chrome 128.0.0'),
(170, 'CgKl4FrA', 'View Admin Dashboard', '3', '2024-08-29 13:23:55', 'User Admin User accessed /Admin/Dashboard with action: View Admin Dashboard', 'Chrome 128.0.0'),
(171, '2DyQdheI', 'Unknown Action', '3', '2024-08-29 13:23:56', 'User Admin User accessed /api/peak_time_predictions with action: Unknown Action', 'Chrome 128.0.0'),
(172, '9k8pBCJi', 'Unknown Action', '3', '2024-08-29 13:23:56', 'User Admin User accessed /api/daily_booking_summary with action: Unknown Action', 'Chrome 128.0.0'),
(173, 'TbbOMUXq', 'Unknown Action', '3', '2024-08-29 13:23:56', 'User Admin User accessed /api/weekly_booking_summary with action: Unknown Action', 'Chrome 128.0.0'),
(174, 'qeBJQoF1', 'Unknown Action', '3', '2024-08-29 13:23:56', 'User Admin User accessed /api/monthly_booking_summary with action: Unknown Action', 'Chrome 128.0.0'),
(175, 't0qzWW04', 'Unknown Action', '3', '2024-08-29 13:23:56', 'User Admin User accessed /api/reservation_predictions with action: Unknown Action', 'Chrome 128.0.0'),
(176, 'NWNghNby', 'View Admin Dashboard', '3', '2024-08-29 13:24:30', 'User Admin User accessed /Admin/Dashboard with action: View Admin Dashboard', 'Chrome 128.0.0'),
(177, 'SlMkrdvb', 'Unknown Action', '3', '2024-08-29 13:24:31', 'User Admin User accessed /api/peak_time_predictions with action: Unknown Action', 'Chrome 128.0.0'),
(178, 'DD54cMO9', 'Unknown Action', '3', '2024-08-29 13:24:31', 'User Admin User accessed /api/daily_booking_summary with action: Unknown Action', 'Chrome 128.0.0'),
(179, '4xQzSqrw', 'Unknown Action', '3', '2024-08-29 13:24:31', 'User Admin User accessed /api/monthly_booking_summary with action: Unknown Action', 'Chrome 128.0.0'),
(180, 'bXH2KNiT', 'Unknown Action', '3', '2024-08-29 13:24:31', 'User Admin User accessed /api/weekly_booking_summary with action: Unknown Action', 'Chrome 128.0.0'),
(181, 'D1iYppFA', 'Unknown Action', '3', '2024-08-29 13:24:31', 'User Admin User accessed /api/reservation_predictions with action: Unknown Action', 'Chrome 128.0.0'),
(182, '8b0rXJIk', 'View Admin Dashboard', '3', '2024-08-29 13:24:55', 'User Admin User accessed /Admin/Dashboard with action: View Admin Dashboard', 'Chrome 128.0.0'),
(183, 'RTHvdgfU', 'Unknown Action', '3', '2024-08-29 13:24:55', 'User Admin User accessed /api/daily_booking_summary with action: Unknown Action', 'Chrome 128.0.0'),
(184, 'eczuX972', 'Unknown Action', '3', '2024-08-29 13:24:55', 'User Admin User accessed /api/weekly_booking_summary with action: Unknown Action', 'Chrome 128.0.0'),
(185, '7ZFIU3Kt', 'Unknown Action', '3', '2024-08-29 13:24:55', 'User Admin User accessed /api/monthly_booking_summary with action: Unknown Action', 'Chrome 128.0.0'),
(186, 'WA031Qgc', 'Unknown Action', '3', '2024-08-29 13:24:55', 'User Admin User accessed /api/reservation_predictions with action: Unknown Action', 'Chrome 128.0.0'),
(187, 'gc48fXCW', 'View Admin Dashboard', '3', '2024-08-29 13:25:15', 'User Admin User accessed /Admin/Dashboard with action: View Admin Dashboard', 'Chrome 128.0.0'),
(188, 'o8jaUvga', 'Unknown Action', '3', '2024-08-29 13:25:15', 'User Admin User accessed /api/peak_time_predictions with action: Unknown Action', 'Chrome 128.0.0'),
(189, 'gztS8VM0', 'Unknown Action', '3', '2024-08-29 13:25:15', 'User Admin User accessed /api/daily_booking_summary with action: Unknown Action', 'Chrome 128.0.0'),
(190, 'BBPjxdvq', 'Unknown Action', '3', '2024-08-29 13:25:15', 'User Admin User accessed /api/weekly_booking_summary with action: Unknown Action', 'Chrome 128.0.0'),
(191, 'ahpBsocp', 'Unknown Action', '3', '2024-08-29 13:25:15', 'User Admin User accessed /api/monthly_booking_summary with action: Unknown Action', 'Chrome 128.0.0'),
(192, 'tqUOaOyd', 'Unknown Action', '3', '2024-08-29 13:25:15', 'User Admin User accessed /api/reservation_predictions with action: Unknown Action', 'Chrome 128.0.0'),
(193, 'V0QUAvRy', 'View Admin Dashboard', '3', '2024-08-29 13:26:12', 'User Admin User accessed /Admin/Dashboard with action: View Admin Dashboard', 'Chrome 128.0.0'),
(194, 'HNJAO55o', 'Unknown Action', '3', '2024-08-29 13:26:12', 'User Admin User accessed /api/peak_time_predictions with action: Unknown Action', 'Chrome 128.0.0'),
(195, 'RGubUxR1', 'Unknown Action', '3', '2024-08-29 13:26:12', 'User Admin User accessed /api/daily_booking_summary with action: Unknown Action', 'Chrome 128.0.0'),
(196, 'oyn6rvRw', 'Unknown Action', '3', '2024-08-29 13:26:12', 'User Admin User accessed /api/weekly_booking_summary with action: Unknown Action', 'Chrome 128.0.0'),
(197, 'dkq7FzAG', 'Unknown Action', '3', '2024-08-29 13:26:12', 'User Admin User accessed /api/monthly_booking_summary with action: Unknown Action', 'Chrome 128.0.0'),
(198, 'DMrL278i', 'Unknown Action', '3', '2024-08-29 13:26:12', 'User Admin User accessed /api/reservation_predictions with action: Unknown Action', 'Chrome 128.0.0'),
(199, 'ALepN3ZO', 'View Admin Dashboard', '3', '2024-08-29 13:26:48', 'User Admin User accessed /Admin/Dashboard with action: View Admin Dashboard', 'Chrome 128.0.0'),
(200, 'eQz6Axqd', 'Unknown Action', '3', '2024-08-29 13:26:49', 'User Admin User accessed /api/peak_time_predictions with action: Unknown Action', 'Chrome 128.0.0'),
(201, 'gMezylVH', 'Unknown Action', '3', '2024-08-29 13:26:49', 'User Admin User accessed /api/daily_booking_summary with action: Unknown Action', 'Chrome 128.0.0'),
(202, 'Dz7udIwj', 'Unknown Action', '3', '2024-08-29 13:26:49', 'User Admin User accessed /api/weekly_booking_summary with action: Unknown Action', 'Chrome 128.0.0'),
(203, 'fW7SJGpB', 'Unknown Action', '3', '2024-08-29 13:26:49', 'User Admin User accessed /api/monthly_booking_summary with action: Unknown Action', 'Chrome 128.0.0'),
(204, 'LKM5TDGx', 'Unknown Action', '3', '2024-08-29 13:26:49', 'User Admin User accessed /api/reservation_predictions with action: Unknown Action', 'Chrome 128.0.0'),
(205, 'eczpMckW', 'View Admin Dashboard', '3', '2024-08-29 13:27:29', 'User Admin User accessed /Admin/Dashboard with action: View Admin Dashboard', 'Chrome 128.0.0'),
(206, 'PwAizOur', 'Unknown Action', '3', '2024-08-29 13:27:29', 'User Admin User accessed /api/peak_time_predictions with action: Unknown Action', 'Chrome 128.0.0'),
(207, '3FAK3cOL', 'Unknown Action', '3', '2024-08-29 13:27:29', 'User Admin User accessed /api/daily_booking_summary with action: Unknown Action', 'Chrome 128.0.0'),
(208, 'WOjo0EQW', 'Unknown Action', '3', '2024-08-29 13:27:29', 'User Admin User accessed /api/weekly_booking_summary with action: Unknown Action', 'Chrome 128.0.0'),
(209, 'NS2Sre5R', 'Unknown Action', '3', '2024-08-29 13:27:29', 'User Admin User accessed /api/monthly_booking_summary with action: Unknown Action', 'Chrome 128.0.0'),
(210, 'twKaAbhb', 'Unknown Action', '3', '2024-08-29 13:27:29', 'User Admin User accessed /api/reservation_predictions with action: Unknown Action', 'Chrome 128.0.0'),
(211, 'UedmSHGf', 'View Admin Dashboard', '3', '2024-08-29 13:27:56', 'User Admin User accessed /Admin/Dashboard with action: View Admin Dashboard', 'Chrome 128.0.0'),
(212, '2mdD1IpT', 'Unknown Action', '3', '2024-08-29 13:27:56', 'User Admin User accessed /api/peak_time_predictions with action: Unknown Action', 'Chrome 128.0.0'),
(213, 'kOpdvIRa', 'Unknown Action', '3', '2024-08-29 13:27:56', 'User Admin User accessed /api/daily_booking_summary with action: Unknown Action', 'Chrome 128.0.0'),
(214, 'WhkbrRjh', 'Unknown Action', '3', '2024-08-29 13:27:56', 'User Admin User accessed /api/weekly_booking_summary with action: Unknown Action', 'Chrome 128.0.0'),
(215, 'oqKL6daz', 'Unknown Action', '3', '2024-08-29 13:27:56', 'User Admin User accessed /api/monthly_booking_summary with action: Unknown Action', 'Chrome 128.0.0'),
(216, 'HmzDL0iJ', 'Unknown Action', '3', '2024-08-29 13:27:56', 'User Admin User accessed /api/reservation_predictions with action: Unknown Action', 'Chrome 128.0.0'),
(217, 'AkqagRbK', 'View Admin Dashboard', '3', '2024-08-29 13:28:13', 'User Admin User accessed /Admin/Dashboard with action: View Admin Dashboard', 'Chrome 128.0.0'),
(218, '685lr5Fy', 'Unknown Action', '3', '2024-08-29 13:28:13', 'User Admin User accessed /api/peak_time_predictions with action: Unknown Action', 'Chrome 128.0.0'),
(219, 'qSdP2npD', 'Unknown Action', '3', '2024-08-29 13:28:13', 'User Admin User accessed /api/daily_booking_summary with action: Unknown Action', 'Chrome 128.0.0'),
(220, 'SPhN0vpW', 'Unknown Action', '3', '2024-08-29 13:28:13', 'User Admin User accessed /api/weekly_booking_summary with action: Unknown Action', 'Chrome 128.0.0'),
(221, 'ybfoTRYk', 'Unknown Action', '3', '2024-08-29 13:28:13', 'User Admin User accessed /api/monthly_booking_summary with action: Unknown Action', 'Chrome 128.0.0'),
(222, 'HtrtWqiZ', 'Unknown Action', '3', '2024-08-29 13:28:13', 'User Admin User accessed /api/reservation_predictions with action: Unknown Action', 'Chrome 128.0.0'),
(223, 'ptCGj2Pt', 'View Admin Dashboard', '3', '2024-08-29 13:28:36', 'User Admin User accessed /Admin/Dashboard with action: View Admin Dashboard', 'Chrome 128.0.0'),
(224, 'oTEtNJwa', 'Unknown Action', '3', '2024-08-29 13:28:36', 'User Admin User accessed /api/peak_time_predictions with action: Unknown Action', 'Chrome 128.0.0'),
(225, 'ARyFdgKu', 'Unknown Action', '3', '2024-08-29 13:28:36', 'User Admin User accessed /api/daily_booking_summary with action: Unknown Action', 'Chrome 128.0.0'),
(226, '3t819yO1', 'Unknown Action', '3', '2024-08-29 13:28:36', 'User Admin User accessed /api/weekly_booking_summary with action: Unknown Action', 'Chrome 128.0.0'),
(227, 'mKGKp8fQ', 'Unknown Action', '3', '2024-08-29 13:28:36', 'User Admin User accessed /api/monthly_booking_summary with action: Unknown Action', 'Chrome 128.0.0'),
(228, 'I979GxMs', 'Unknown Action', '3', '2024-08-29 13:28:36', 'User Admin User accessed /api/reservation_predictions with action: Unknown Action', 'Chrome 128.0.0'),
(229, '8pu8HJxj', 'Create New User', '3', '2024-08-29 13:29:36', 'User Admin User accessed /Admin/Create/User with action: Create New User', 'Chrome 128.0.0'),
(230, 'VmXOAxe0', 'Create New User', '3', '2024-08-29 13:30:26', 'User Admin User accessed /Admin/Create/User with action: Create New User', 'Chrome 128.0.0'),
(231, 'gjmKh1jJ', 'Create New User', '3', '2024-08-29 13:30:42', 'User Admin User accessed /Admin/Create/User with action: Create New User', 'Chrome 128.0.0'),
(232, 'ghJAJsUu', 'Create New User', '3', '2024-08-29 13:30:43', 'User Admin User accessed /Admin/Create/User with action: Create New User', 'Chrome 128.0.0'),
(233, '0zZfpuEg', 'Create New User', '3', '2024-08-29 13:30:43', 'User Admin User accessed /Admin/Create/User with action: Create New User', 'Chrome 128.0.0'),
(234, 'a9AaXBi2', 'Create New User', '3', '2024-08-29 13:30:44', 'User Admin User accessed /Admin/Create/User with action: Create New User', 'Chrome 128.0.0'),
(235, 'VDAlihKi', 'Create New User', '3', '2024-08-29 13:31:06', 'User Admin User accessed /Admin/Create/User with action: Create New User', 'Chrome 128.0.0'),
(236, 'lrRuHdtb', 'Create New User', '3', '2024-08-29 13:31:26', 'User Admin User accessed /Admin/Create/User with action: Create New User', 'Chrome 128.0.0'),
(237, 'Fuwi6hzV', 'Create New User', '3', '2024-08-29 13:32:22', 'User Admin User accessed /Admin/Create/User with action: Create New User', 'Chrome 128.0.0'),
(238, 'vyDl65oq', 'Create New User', '3', '2024-08-29 13:32:51', 'User Admin User accessed /Admin/Create/User with action: Create New User', 'Chrome 128.0.0'),
(239, '9ocGhhdN', 'Create New User', '3', '2024-08-29 13:32:53', 'User Admin User accessed /Admin/Create/User with action: Create New User', 'Chrome 128.0.0'),
(240, 'pvd6E7rJ', 'Create New User', '3', '2024-08-29 13:33:49', 'User Admin User accessed /Admin/Create/User with action: Create New User', 'Chrome 128.0.0'),
(241, '4O2GkMue', 'Create New User', '3', '2024-08-29 13:33:50', 'User Admin User accessed /Admin/Create/User with action: Create New User', 'Chrome 128.0.0'),
(242, 'ZIOjVZHe', 'Create New User', '3', '2024-08-29 13:33:50', 'User Admin User accessed /Admin/Create/User with action: Create New User', 'Chrome 128.0.0'),
(243, 'qn4tLdhL', 'Create New User', '3', '2024-08-29 13:33:50', 'User Admin User accessed /Admin/Create/User with action: Create New User', 'Chrome 128.0.0'),
(244, 'kjXc1ohY', 'Create New User', '3', '2024-08-29 13:34:00', 'User Admin User accessed /Admin/Create/User with action: Create New User', 'Chrome 128.0.0'),
(245, 'tKvQYwNB', 'Create New User', '3', '2024-08-29 13:35:13', 'User Admin User accessed /Admin/Create/User with action: Create New User', 'Chrome 128.0.0'),
(246, '1QTbFFiT', 'Create New User', '3', '2024-08-29 13:35:13', 'User Admin User accessed /Admin/Create/User with action: Create New User', 'Chrome 128.0.0'),
(247, '4TNhCnAB', 'Create New User', '3', '2024-08-29 13:35:16', 'User Admin User accessed /Admin/Create/User with action: Create New User', 'Chrome 128.0.0'),
(248, 'oixlQmq5', 'View User List', '3', '2024-08-29 13:35:16', 'User Admin User accessed /Admin/Users with action: View User List', 'Chrome 128.0.0'),
(249, 'iQWIpfA8', 'Update Action', '3', '2024-08-29 13:35:27', 'User Admin User accessed /Admin/handle_user_action/11 with action: Update Action', 'Chrome 128.0.0'),
(250, 'TorssVM2', 'View User List', '3', '2024-08-29 13:35:27', 'User Admin User accessed /Admin/Users with action: View User List', 'Chrome 128.0.0'),
(251, 'VeBsWMrb', 'View User List', '3', '2024-08-29 13:35:32', 'User Admin User accessed /Admin/Users with action: View User List', 'Chrome 128.0.0'),
(252, '6X4HR3xg', 'View Admin Dashboard', '3', '2024-08-29 13:35:32', 'User Admin User accessed /Admin/Dashboard with action: View Admin Dashboard', 'Chrome 128.0.0'),
(253, 'UDmEaTAQ', 'Unknown Action', '3', '2024-08-29 13:35:33', 'User Admin User accessed /api/peak_time_predictions with action: Unknown Action', 'Chrome 128.0.0'),
(254, 'KhL5wOLa', 'Unknown Action', '3', '2024-08-29 13:35:33', 'User Admin User accessed /api/daily_booking_summary with action: Unknown Action', 'Chrome 128.0.0'),
(255, 'IKDzB9Zm', 'Unknown Action', '3', '2024-08-29 13:35:33', 'User Admin User accessed /api/weekly_booking_summary with action: Unknown Action', 'Chrome 128.0.0'),
(256, 'Yqy4bNXd', 'Unknown Action', '3', '2024-08-29 13:35:33', 'User Admin User accessed /api/monthly_booking_summary with action: Unknown Action', 'Chrome 128.0.0'),
(257, 'Wip7hgot', 'Unknown Action', '3', '2024-08-29 13:35:33', 'User Admin User accessed /api/reservation_predictions with action: Unknown Action', 'Chrome 128.0.0');

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

--
-- Dumping data for table `notification`
--

INSERT INTO `notification` (`id`, `notification_id`, `user_id`, `reservation_id`, `message`, `notification_date`, `notification_time`, `updated_by`) VALUES
(1, '7', '3', '103', 'Your reservation at Branch C has been updated.', '2024-08-27', '00:00:00', '1'),
(2, '8', '1', '104', 'Reminder: Your reservation at Branch D is tomorrow.', '2024-08-27', '00:00:00', NULL),
(6, 't5Ed3mPs', '14', 'AY1HNKGm', 'Your reservation with ID AY1HNKGm has been cancelled. Reason: waw', '2024-08-27', '16:22:24', NULL);

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

--
-- Dumping data for table `otplogs`
--

INSERT INTO `otplogs` (`id`, `otp_log_id`, `user_id`, `otp_code`, `timestamp`, `status`, `description`) VALUES
(1, '1', '2', '123456', '2024-08-24 12:00:00', 'Generated', 'OTP generated for verification'),
(2, '2', '1', '654321', '2024-08-24 13:00:00', 'Verified', 'OTP verified successfully');

-- --------------------------------------------------------

--
-- Table structure for table `userrole`
--

CREATE TABLE `userrole` (
  `id` int(11) UNSIGNED NOT NULL,
  `role_name` enum('Admin','Staff','User') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `userrole`
--

INSERT INTO `userrole` (`id`, `role_name`) VALUES
(1, 'Admin'),
(2, 'Staff'),
(3, 'User');

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
-- Dumping data for table `usertable`
--

INSERT INTO `usertable` (`id`, `user_id`, `first_name`, `last_name`, `username`, `password_hash`, `email_address`, `phone_number`, `role_id`, `last_login`, `created_at`, `updated_at`) VALUES
(1, '1', 'Johns', 'Dogs', 'john_doe', '$2b$12$fRT7yg6C6jBOlaKZlNhK/u7MiTkNlSXdjaz7by6S/JoSZ45gxKHja', 'john.doe@example.com', '(12) 34-567-890_', 3, NULL, '2024-08-24 13:40:20', '2024-08-27 16:29:58'),
(2, '2', 'Jane', 'Smithbebe', 'jane_smith', '$2b$12$fRT7yg6C6jBOlaKZlNhK/u7MiTkNlSXdjaz7by6S/JoSZ45gxKHja', 'jane.smith@example.com', '(23) 45-678-901_', 3, NULL, '2024-08-24 13:40:20', '2024-08-27 16:30:04'),
(3, '3', 'Admin', 'User', 'admin', '$2b$12$gttSgsgSfNjpD7l3PlKaqeBfb31shz4AtQS8dfNGvTdmVGXPbPPke', 'admin@gmail.com', '(12) 35-555-5555', 1, '2024-08-27 17:34:47', '2024-08-16 00:49:15', '2024-08-27 17:34:47'),
(4, '4', 'Test', 'User', 'testuser', '$2b$12$Aaj2g6wotDaqzDMe.JO3FOfhhAhUnzP75BchZTcUMyJYz94PQxbfG', 'testuser@gmail.com', '(12) 31-231-2312', 3, '2024-08-24 23:33:21', '2024-08-24 13:29:52', '2024-08-24 23:33:21'),
(5, '5', 'jaden smith', 'Member', 'staff', '$2b$12$RYUv5zarJenzfI5vXHBS5OBSAs9ufkcW40ljyMCERZE8HIIx4YWri', 'staff@gmail.com', '(12) 31-231-2312', 2, '2024-08-27 17:22:34', '2024-08-24 22:50:37', '2024-08-27 17:22:34'),
(7, '7', NULL, NULL, 'test', '$2b$12$JjvMQmVxp/PYaWM.XcbJSeAkcVhOAqCYW/dpk7SbOcbraqItCulMe', 'test@gmail.com', '(12) 31-231-2312', 3, '2024-08-25 06:19:49', '2024-08-25 06:19:43', '2024-08-25 06:19:49'),
(8, '14', 'dong', 'abay', 'newtest', '$2b$12$ldRCBjdH8WSU9dWUhctN8uJLEW1DH2nFLULyGqa2j/BT9frcWlz46', 'newtest@gmail.com', '(12) 31-231-2312', 3, '2024-08-27 17:34:33', '2024-08-25 07:45:59', '2024-08-27 17:34:33'),
(9, 'I910ZY33', NULL, NULL, 'teststaff', '$2b$12$qmAFV.zreaVYz.zv9CR1r.AkxYNwzq62MYc0sngywz73ouFGsKmrq', 'teststaff@gmail.com', '(12) 31-231-2312', 1, NULL, '2024-08-27 16:33:56', '2024-08-27 16:33:56'),
(10, 'IHrOCw3N', NULL, NULL, 'admint', '$2b$12$spqouEdk6XCbFBj6FNfNS.Etbau/Z7SG9CH3.xbxHzQ7ijKAr87Z.', 'admint@gmail.com', '(12) 31-231-2312', 1, NULL, '2024-08-27 16:42:22', '2024-08-27 16:42:22'),
(11, '9KiserAh', 'snake', 'snakelord', NULL, '$2b$12$89sZpqlE7xfIFDWqWhV5yOusMEyN369o6RloVc9yuQCJQo4JpBYF2', 'snake@gmail.com', '(12) 31-231-2312', 1, NULL, '2024-08-29 13:35:13', '2024-08-29 13:35:27');

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
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `customer_reservation`
--
ALTER TABLE `customer_reservation`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=96;

--
-- AUTO_INCREMENT for table `feedback`
--
ALTER TABLE `feedback`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT for table `logs`
--
ALTER TABLE `logs`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=258;

--
-- AUTO_INCREMENT for table `notification`
--
ALTER TABLE `notification`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `otplogs`
--
ALTER TABLE `otplogs`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `userrole`
--
ALTER TABLE `userrole`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `usertable`
--
ALTER TABLE `usertable`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

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
