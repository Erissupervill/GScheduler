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

--
-- Dumping data for table `alembic_version`
--

INSERT INTO `alembic_version` (`version_num`) VALUES
('2a8414e7362e');

--
-- Dumping data for table `branch`
--

INSERT INTO `branch` (`id`, `branch_id`, `name`, `capacity`, `location`) VALUES
(1, '1', 'Pasig', 97, 'Sto. Tomas'),
(2, '2', 'Taguig', 100, 'Sta. Ana');

--
-- Dumping data for table `customer_reservation`
--

INSERT INTO `customer_reservation` (`id`, `reservation_id`, `user_id`, `branch_id`, `number_of_guests`, `status_comment`, `status`, `reservation_date`, `reservation_time`, `created_at`, `updated_at`, `updated_by`) VALUES
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

--
-- Dumping data for table `logs`
--

INSERT INTO `logs` (`id`, `log_id`, `action`, `user_id`, `timestamp`, `description`) VALUES
(1, '1', 'User Login', '1', '2024-08-24 13:40:20', 'User John Doe logged in'),
(2, '2', 'Reservation Created', '4', '2024-08-24 13:00:00', 'Reservation created for 20 guests');

--
-- Dumping data for table `notification`
--

INSERT INTO `notification` (`id`, `notification_id`, `user_id`, `reservation_id`, `message`, `notification_date`, `notification_time`, `updated_by`) VALUES
(1, '7', '3', '103', 'Your reservation at Branch C has been updated.', '2024-08-27', '00:00:00', '1'),
(2, '8', '1', '104', 'Reminder: Your reservation at Branch D is tomorrow.', '2024-08-27', '00:00:00', NULL),
(6, 't5Ed3mPs', '14', 'AY1HNKGm', 'Your reservation with ID AY1HNKGm has been cancelled. Reason: waw', '2024-08-27', '16:22:24', NULL);

--
-- Dumping data for table `otplogs`
--

INSERT INTO `otplogs` (`id`, `otp_log_id`, `user_id`, `otp_code`, `timestamp`, `status`, `description`) VALUES
(1, '1', '2', '123456', '2024-08-24 12:00:00', 'Generated', 'OTP generated for verification'),
(2, '2', '1', '654321', '2024-08-24 13:00:00', 'Verified', 'OTP verified successfully');

--
-- Dumping data for table `userrole`
--

INSERT INTO `userrole` (`id`, `role_name`) VALUES
(1, 'Admin'),
(2, 'Staff'),
(3, 'User');

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
(10, 'IHrOCw3N', NULL, NULL, 'admint', '$2b$12$spqouEdk6XCbFBj6FNfNS.Etbau/Z7SG9CH3.xbxHzQ7ijKAr87Z.', 'admint@gmail.com', '(12) 31-231-2312', 1, NULL, '2024-08-27 16:42:22', '2024-08-27 16:42:22');
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
