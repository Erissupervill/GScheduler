-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Aug 28, 2024 at 08:11 AM
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
(11, '1', '14', '1', 50, 'test', 'Cancelled', '2024-08-30', '19:00:00', '2024-08-25 14:00:00', '2024-08-27 12:12:29', '14'),
(12, '2', '2', '2', 30, 'too many guests', 'Completed', '2024-01-31', '20:00:00', '2024-08-25 15:00:00', '2024-08-28 13:50:08', '5'),
(13, '3', '3', '2', 200, 'ANG DAMI NYO EH', 'Rejected', '2024-02-29', '18:00:00', '2024-08-25 16:00:00', '2024-08-28 13:50:14', '5'),
(14, '4', '1', '1', 40, 'Queue too long', 'Pending', '2024-08-25', '15:24:00', '2024-08-25 07:31:01', '2024-08-27 15:44:42', '0'),
(15, '5', '14', '1', 40, 'test reason', 'Pending', '2024-08-25', '15:24:00', '2024-08-25 07:31:54', '2024-08-27 19:22:23', '14'),
(16, '6', '14', '1', 22, '', 'Completed', '2024-08-27', '15:33:00', '2024-08-25 07:32:20', '2024-08-27 07:45:23', '5'),
(17, '7', '14', '1', 22, '', 'Pending', '2024-08-27', '15:33:00', '2024-08-25 07:33:10', '2024-08-27 15:44:50', '0'),
(18, '8', '14', '1', 11, '', 'Pending', '2024-08-26', '15:47:00', '2024-08-25 07:47:13', '2024-08-27 15:44:53', '5'),
(19, '9', '14', '1', 11, '', 'Pending', '2024-08-26', '15:47:00', '2024-08-25 07:47:46', '2024-08-27 15:44:55', '5'),
(20, '10', '14', '1', 50, 'smuggler', 'Completed', '2024-04-28', '15:48:00', '2024-08-27 07:51:52', '2024-08-28 13:54:08', '5'),
(21, 'p5aciHpi', '14', '1', 1, NULL, 'Pending', '2024-08-29', '00:03:00', '2024-08-27 16:01:37', '2024-08-27 16:01:37', NULL),
(26, '3jnLSTih', '14', '1', 1, NULL, 'Pending', '2024-02-28', '00:04:00', '2024-08-27 16:04:16', '2024-08-28 13:53:57', NULL),
(27, 'AY1HNKGm', '14', '1', 1, 'szzz', 'Cancelled', '2024-05-31', '00:06:00', '2024-08-27 16:04:23', '2024-08-28 13:54:02', '14');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `customer_reservation`
--
ALTER TABLE `customer_reservation`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `reservation_id` (`reservation_id`),
  ADD KEY `fk_user_id` (`user_id`),
  ADD KEY `fk_branch_id` (`branch_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `customer_reservation`
--
ALTER TABLE `customer_reservation`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `customer_reservation`
--
ALTER TABLE `customer_reservation`
  ADD CONSTRAINT `customer_reservation_fk_branch_id` FOREIGN KEY (`branch_id`) REFERENCES `branch` (`branch_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `customer_reservation_fk_user_id` FOREIGN KEY (`user_id`) REFERENCES `usertable` (`user_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
