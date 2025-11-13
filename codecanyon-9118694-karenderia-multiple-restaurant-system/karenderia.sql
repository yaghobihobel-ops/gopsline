-- phpMyAdmin SQL Dump
-- version 4.8.5
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jan 30, 2022 at 03:32 AM
-- Server version: 10.1.38-MariaDB
-- PHP Version: 7.2.16

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `kmrs2`
--

-- --------------------------------------------------------

--
-- Table structure for table `st_admin_meta`
--

CREATE TABLE `st_admin_meta` (
  `meta_id` int(14) NOT NULL,
  `meta_name` varchar(100) NOT NULL DEFAULT '',
  `meta_value` text,
  `meta_value1` text,
  `meta_value2` varchar(255) NOT NULL DEFAULT '',
  `date_modified` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `st_admin_meta`
--

INSERT INTO `st_admin_meta` (`meta_id`, `meta_name`, `meta_value`, `meta_value1`, `date_modified`) VALUES
(1, 'rejection_list', 'Out of item(s)', '', '2022-01-26 22:46:48'),
(2, 'rejection_list', 'Kitchen closed', '', '2022-01-26 22:46:46'),
(3, 'rejection_list', 'There is no possibility of fullfilling the order.', '', '2022-01-26 22:46:44'),
(4, 'rejection_list', 'Today we are no longer delivering.', '', '2022-01-26 22:46:43'),
(5, 'rejection_list', 'Too long waiting time.', '', '2022-01-26 22:46:41'),
(6, 'rejection_list', 'No ingredient.', '', '2022-01-26 22:46:39'),
(7, 'rejection_list', 'Customer called to cancel', '', '2022-01-26 22:46:38'),
(8, 'rejection_list', 'Restaurant too busy', '', '2022-01-26 22:46:36'),
(9, 'rejection_list', 'other', '', '2022-01-26 22:46:32'),
(37, 'action_type', 'Notification to customer', 'notification_to_customer', '2022-01-26 22:47:25'),
(38, 'action_type', 'Notification to merchant', 'notification_to_merchant', '2022-01-26 22:47:24'),
(39, 'action_type', 'Notification to admin', 'notification_to_admin', '2022-01-26 22:47:22'),
(40, 'action_type', 'Notification to driver', 'notification_to_driver', '2022-01-26 22:47:20'),
(84, 'pause_reason', 'Store is too busy', '', '2022-01-26 22:47:10'),
(85, 'pause_reason', 'Problem in restaurant', '', '2022-01-26 22:47:08'),
(86, 'pause_reason', 'Store closed', '', '2022-01-26 22:47:07'),
(87, 'pause_reason', 'Out of item(s)', '', '2022-01-26 22:47:05'),
(133, 'payout_new_payout_template_id', '16', '', '2022-01-27 07:56:15'),
(134, 'payout_paid_template_id', '17', '', '2022-01-27 07:56:15'),
(135, 'payout_cancel_template_id', '18', '', '2022-01-27 07:56:15'),
(136, 'status_new_order', 'new', '', '2022-01-27 07:48:04'),
(137, 'status_cancel_order', 'cancelled', '', '2022-01-27 07:48:04'),
(138, 'status_delivered', 'delivered', '', '2022-01-27 07:48:04'),
(139, 'status_completed', 'complete', '', '2022-01-27 07:48:04'),
(140, 'status_rejection', 'rejected', '', '2022-01-27 07:48:05'),
(141, 'status_delivery_fail', 'delivery failed', '', '2022-01-27 07:48:05'),
(142, 'status_failed', 'cancelled', '', '2022-01-27 07:48:05'),
(143, 'tracking_status_receive', '', '', '2022-01-27 07:54:06'),
(144, 'tracking_status_process', 'accepted', '', '2022-01-27 07:54:06'),
(145, 'tracking_status_ready', 'ready for pickup', '', '2022-01-27 07:54:06'),
(146, 'tracking_status_in_transit', 'delivery on its way', '', '2022-01-27 07:54:06'),
(147, 'tracking_status_delivered', 'delivered', '', '2022-01-27 07:54:06'),
(148, 'tracking_status_delivery_failed', 'delivery failed', '', '2022-01-27 07:54:06'),
(149, 'tracking_status_completed', 'complete', '', '2022-01-27 07:54:06'),
(150, 'tracking_status_failed', 'cancelled', '', '2022-01-27 07:54:07'),
(151, 'invoice_create_template_id', '2', '', '2022-01-27 07:54:40'),
(152, 'refund_template_id', '3', '', '2022-01-27 07:54:40'),
(153, 'partial_refund_template_id', '11', '', '2022-01-27 07:54:40'),
(154, 'delayed_template_id', '8', '', '2022-01-27 07:54:40'),
(155, 'payout_request_auto_process', '1', '', '2022-01-27 07:55:53'),
(156, 'payout_request_enabled', '1', '', '2022-01-27 07:55:53'),
(157, 'payout_minimum_amount', '100', '', '2022-01-27 07:55:53'),
(158, 'payout_process_days', '5', '', '2022-01-27 07:55:53'),
(159, 'payout_number_can_request', '2', '', '2022-01-27 07:55:53'),
(160, 'theme_menu_active', '370', '', '2022-01-27 08:12:44'),
(161, 'tips', '3', NULL, now()),
(162, 'tips', '4', NULL, now()),
(163, 'tips', '5', NULL, now()),
(251, 'reason_cancel_booking', 'Reserved on another day or time', '', now()),
(252, 'reason_cancel_booking', 'Reserved at another restaurant', '', now()),
(253, 'reason_cancel_booking', 'No longer dining out', '', now()),
(254, 'reason_cancel_booking', 'Other', '', now());


INSERT INTO `st_admin_meta` (`meta_id`, `meta_name`, `meta_value`, `meta_value1`, `date_modified`) VALUES
(292, 'seo_page_tracking_orderpage', '41', '', '2023-06-15 23:36:12'),
(291, 'seo_page_manage_table_booking', '40', '', '2023-06-15 23:36:12'),
(290, 'seo_page_table_booking', '39', '', '2023-06-15 23:36:11'),
(289, 'seo_page_guest_checkout', '38', '', '2023-06-15 23:36:11'),
(288, 'seo_page_checkout', '37', '', '2023-06-15 23:36:11'),
(287, 'seo_page_restaurant_signup', '36', '', '2023-06-15 23:36:11'),
(286, 'seo_page_user_saved_store', '35', '', '2023-06-15 23:36:11'),
(285, 'seo_page_user_saved_payments', '34', '', '2023-06-15 23:36:11'),
(284, 'seo_page_user_address', '32', '', '2023-06-15 23:36:11'),
(283, 'seo_page_user_order', '32', '', '2023-06-15 23:36:11'),
(282, 'seo_page_change_password', '31', '', '2023-06-15 23:36:11'),
(281, 'seo_page_manage_account', '30', '', '2023-06-15 23:36:11'),
(280, 'seo_page_signup', '29', '', '2023-06-15 23:36:11'),
(279, 'seo_page_login', '28', '', '2023-06-15 23:36:11'),
(278, 'seo_page_menu', '27', '', '2023-06-15 23:36:11'),
(277, 'seo_page_cuisine', '26', '', '2023-06-15 23:36:11'),
(276, 'seo_page_contactus', '25', '', '2023-06-15 23:36:11'),
(275, 'seo_page_search', '24', '', '2023-06-15 23:36:11'),
(274, 'seo_page_homepage', '23', '', '2023-06-15 23:36:11');

INSERT INTO `st_admin_meta` (`meta_id`, `meta_name`, `meta_value`, `meta_value1`, `date_modified`) VALUES
(250, 'order_help', 'Dropoff is inaccessible', NULL, NULL),
(249, 'order_help', 'Dropoff address is changed', NULL, NULL),
(248, 'order_help', 'Customer can’t be reached', NULL, NULL),
(247, 'order_help', 'Food spill', NULL, NULL),
(246, 'order_help', 'Order was cancelled', NULL, NULL),
(245, 'order_help', 'Unable to find address', NULL, NULL);


INSERT INTO `st_admin_meta` (`meta_id`, `meta_name`, `meta_value`, `meta_value1`, `date_modified`) VALUES
(244, 'order_decline_reason', 'I have too many orders', NULL, NULL),
(243, 'order_decline_reason', 'Oversize item', NULL, NULL),
(242, 'order_decline_reason', 'I don\'t want to do delivery', NULL, NULL),
(240, 'order_decline_reason', 'Order pickup up by someone else', NULL, NULL),
(239, 'order_decline_reason', 'Restaurant is close', NULL, NULL),
(238, 'order_decline_reason', 'Order was cancelled', NULL, NULL),
(237, 'order_decline_reason', 'Excessive wait time', NULL, NULL),
(236, 'order_decline_reason', 'Distance is too far', NULL, NULL);


INSERT INTO `st_admin_meta` (`meta_id`, `meta_name`, `meta_value`, `meta_value1`, `date_modified`) VALUES
(528, 'call_staff_menu', 'Table Clean', '', '2024-05-17 08:30:59'),
(527, 'call_staff_menu', 'Phone Charger', '', '2024-05-17 08:31:10'),
(526, 'call_staff_menu', 'Kids Cutlery', '', '2024-05-17 08:31:21'),
(525, 'call_staff_menu', 'Toothpick', '', '2024-05-17 08:32:56'),
(524, 'call_staff_menu', 'Extra Bowl', '', '2024-05-17 08:33:22'),
(523, 'call_staff_menu', 'Extra Plate', '', '2024-05-17 08:33:32'),
(522, 'call_staff_menu', 'Ice', '', '2024-05-17 08:33:43'),
(521, 'call_staff_menu', 'Chopstick', '', '2024-05-17 08:33:52'),
(520, 'call_staff_menu', 'Water refill', '', '2024-05-17 08:33:59'),
(519, 'call_staff_menu', 'Wet tissue', '', '2024-05-17 08:33:14'),
(518, 'call_staff_menu', ' Paper napkin', '', '2024-04-03 18:04:12');


-- --------------------------------------------------------

--
-- Table structure for table `st_admin_meta_translation`
--

CREATE TABLE `st_admin_meta_translation` (
  `id` int(14) NOT NULL,
  `meta_id` int(14) NOT NULL DEFAULT '0',
  `language` varchar(100) NOT NULL DEFAULT '',
  `meta_value` text,
  `meta_value1` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `st_admin_meta_translation`
--

INSERT INTO `st_admin_meta_translation` (`id`, `meta_id`, `language`, `meta_value`) VALUES
(1, 9, 'ja', ''),
(2, 9, 'ar', ''),
(3, 9, 'en', 'other'),
(4, 8, 'ja', ''),
(5, 8, 'ar', ''),
(6, 8, 'en', 'Restaurant too busy'),
(7, 7, 'ja', ''),
(8, 7, 'ar', ''),
(9, 7, 'en', 'Customer called to cancel'),
(10, 6, 'ja', ''),
(11, 6, 'ar', ''),
(12, 6, 'en', 'No ingredient.'),
(13, 5, 'ja', ''),
(14, 5, 'ar', ''),
(15, 5, 'en', 'Too long waiting time.'),
(16, 4, 'ja', ''),
(17, 4, 'ar', ''),
(18, 4, 'en', 'Today we are no longer delivering.'),
(19, 3, 'ja', ''),
(20, 3, 'ar', ''),
(21, 3, 'en', 'There is no possibility of fullfilling the order.'),
(22, 2, 'ja', ''),
(23, 2, 'ar', ''),
(24, 2, 'en', 'Kitchen closed'),
(25, 1, 'ja', ''),
(26, 1, 'ar', ''),
(27, 1, 'en', 'Out of item(s)'),
(28, 132, 'ja', ''),
(29, 132, 'ar', ''),
(30, 132, 'en', 'test reason'),
(31, 87, 'ja', ''),
(32, 87, 'ar', ''),
(33, 87, 'en', 'Out of item(s)'),
(34, 86, 'ja', ''),
(35, 86, 'ar', ''),
(36, 86, 'en', 'Store closed'),
(37, 85, 'ja', ''),
(38, 85, 'ar', ''),
(39, 85, 'en', 'Problem in restaurant'),
(40, 84, 'ja', ''),
(41, 84, 'ar', ''),
(42, 84, 'en', 'Store is too busy'),
(43, 40, 'ja', ''),
(44, 40, 'ar', ''),
(45, 40, 'en', 'Notification to driver'),
(46, 39, 'ja', ''),
(47, 39, 'ar', ''),
(48, 39, 'en', 'Notification to admin'),
(49, 38, 'ja', ''),
(50, 38, 'ar', ''),
(51, 38, 'en', 'Notification to merchant'),
(52, 37, 'ja', ''),
(53, 37, 'ar', ''),
(54, 37, 'en', 'Notification to customer');


INSERT INTO `st_admin_meta_translation` (`id`, `meta_id`, `language`, `meta_value`, `meta_value1`) VALUES
(259, 251, 'en', 'Reserved on another day or time', NULL),
(260, 252, 'en', 'Reserved at another restaurant', NULL),
(261, 253, 'en', 'No longer dining out', NULL),
(262, 254, 'en', 'Other', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `st_admin_user`
--

CREATE TABLE `st_admin_user` (
  `admin_id` int(14) NOT NULL,
  `admin_id_token` varchar(255) NOT NULL DEFAULT '',
  `username` varchar(255) NOT NULL DEFAULT '',
  `password` varchar(100) NOT NULL DEFAULT '',
  `first_name` varchar(255) NOT NULL DEFAULT '',
  `last_name` varchar(255) NOT NULL DEFAULT '',
  `email_address` varchar(255) NOT NULL DEFAULT '',
  `contact_number` varchar(50) NOT NULL DEFAULT '',
  `profile_photo` varchar(255) NOT NULL DEFAULT '',
  `path` varchar(255) NOT NULL DEFAULT '',
  `role` varchar(100) NOT NULL DEFAULT '',
  `main_account` int(1) NOT NULL DEFAULT '1',
  `session_token` varchar(255) NOT NULL DEFAULT '',
  `status` varchar(100) NOT NULL DEFAULT 'active',
  `last_login` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `date_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `date_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ip_address` varchar(50) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `st_admin_user`
--

-- --------------------------------------------------------

--
-- Table structure for table `st_availability`
--

CREATE TABLE `st_availability` (
  `id` bigint(20) NOT NULL,
  `merchant_id` bigint(20) NOT NULL DEFAULT '0',
  `meta_name` varchar(100) NOT NULL DEFAULT '',
  `meta_value` varchar(100) NOT NULL DEFAULT '',
  `day_of_week` tinyint(1) NOT NULL DEFAULT '0',
  `status` tinyint(1) NOT NULL DEFAULT '0',
  `start_time` time DEFAULT NULL,
  `end_time` time DEFAULT NULL,
  `date_created` timestamp NULL DEFAULT NULL,
  `date_modified` timestamp NULL DEFAULT NULL,
  `ip_address` varchar(50) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `st_cache`
--

CREATE TABLE `st_cache` (
  `id` int(14) NOT NULL,
  `date_modified` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `st_cache`
--

INSERT INTO `st_cache` (`id`, `date_modified`) VALUES
(1, '2022-01-27 23:49:14');

-- --------------------------------------------------------

--
-- Table structure for table `st_cart`
--

CREATE TABLE `st_cart` (
  `id` int(11) NOT NULL,
  `cart_row` varchar(100) NOT NULL DEFAULT '',
  `cart_uuid` varchar(100) NOT NULL DEFAULT '',
  `merchant_id` int(14) NOT NULL DEFAULT '0',
  `cat_id` int(14) NOT NULL DEFAULT '0',
  `item_token` varchar(255) NOT NULL DEFAULT '',
  `item_size_id` int(14) NOT NULL DEFAULT '0',
  `qty` int(14) NOT NULL DEFAULT '0',
  `special_instructions` varchar(255) NOT NULL DEFAULT '',
  `if_sold_out` varchar(50) NOT NULL DEFAULT '',
  `hold_order` int(1) NOT NULL DEFAULT '0',
  `hold_order_admin` tinyint(1) NOT NULL DEFAULT '0',
  `held_time` datetime DEFAULT NULL,
  `order_reference` varchar(255) NOT NULL DEFAULT '',
  `hold_order_reference` varchar(100) DEFAULT '',
  `transaction_type` varchar(100) NOT NULL DEFAULT '',
  `table_uuid` varchar(100) NOT NULL DEFAULT '',
  `subtotal` decimal(10,4) NOT NULL DEFAULT '0.0000',
  `item_total` decimal(10,2) NOT NULL DEFAULT '0.00',
  `total` decimal(10,4) NOT NULL DEFAULT '0.0000',
  `currency_code` varchar(5) NOT NULL DEFAULT '',
  `send_order` int(1) NOT NULL DEFAULT '0',
  `is_view` int(1) NOT NULL DEFAULT '0',
  `payment_status` int(1) NOT NULL DEFAULT '0',
  `change_trans` int(1) NOT NULL DEFAULT '0',
  `date_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `date_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ip_address` varchar(50) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `st_cart_addons`
--

CREATE TABLE `st_cart_addons` (
  `id` int(11) NOT NULL,
  `cart_row` varchar(100) NOT NULL DEFAULT '',
  `cart_uuid` varchar(100) NOT NULL DEFAULT '',
  `subcat_id` int(14) NOT NULL DEFAULT '0',
  `sub_item_id` int(14) NOT NULL DEFAULT '0',
  `qty` int(14) NOT NULL DEFAULT '0',
  `multi_option` varchar(100) NOT NULL DEFAULT '0',
  `created_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `st_cart_attributes`
--

CREATE TABLE `st_cart_attributes` (
  `id` int(11) NOT NULL,
  `cart_row` varchar(100) NOT NULL DEFAULT '',
  `cart_uuid` varchar(100) NOT NULL DEFAULT '',
  `meta_name` varchar(255) NOT NULL DEFAULT '',
  `meta_id` text,
  `last_update` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `st_category`
--

CREATE TABLE `st_category` (
  `cat_id` int(14) NOT NULL,
  `merchant_id` int(14) NOT NULL DEFAULT '0',
  `category_name` varchar(255) NOT NULL DEFAULT '',
  `category_description` text,
  `available` tinyint(1) NOT NULL DEFAULT '1',
  `photo` varchar(255) NOT NULL DEFAULT '',
  `path` varchar(255) NOT NULL DEFAULT '',
  `icon` varchar(255) DEFAULT '',
  `icon_path` varchar(255) NOT NULL DEFAULT '',
  `status` varchar(100) NOT NULL DEFAULT '',
  `sequence` int(14) NOT NULL DEFAULT '0',
  `available_at_specific` tinyint(1) NOT NULL DEFAULT '0',
  `date_created` varchar(50) NOT NULL DEFAULT '',
  `date_modified` varchar(50) DEFAULT '',
  `ip_address` varchar(50) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `st_category_relationship_dish`
--

CREATE TABLE `st_category_relationship_dish` (
  `id` int(11) NOT NULL,
  `merchant_id` int(14) NOT NULL DEFAULT '0',
  `cat_id` int(11) NOT NULL DEFAULT '0',
  `dish_id` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `st_category_translation`
--

CREATE TABLE `st_category_translation` (
  `id` int(11) NOT NULL,
  `merchant_id` int(14) NOT NULL DEFAULT '0',
  `cat_id` int(14) NOT NULL DEFAULT '0',
  `language` varchar(10) NOT NULL DEFAULT '',
  `category_name` varchar(255) NOT NULL DEFAULT '',
  `category_description` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `st_client`
--

CREATE TABLE `st_client` (
  `client_id` int(14) NOT NULL,
  `client_uuid` varchar(100) NOT NULL DEFAULT '',
  `social_strategy` varchar(100) NOT NULL DEFAULT 'web',
  `merchant_id` int(10) NOT NULL DEFAULT '0',
  `first_name` varchar(255) NOT NULL DEFAULT '',
  `last_name` varchar(255) NOT NULL DEFAULT '',
  `email_address` varchar(200) NOT NULL DEFAULT '',
  `password` varchar(100) NOT NULL DEFAULT '',
  `phone_prefix` varchar(5) NOT NULL DEFAULT '',
  `contact_phone` varchar(20) NOT NULL DEFAULT '',
  `avatar` varchar(255) NOT NULL DEFAULT '',
  `path` varchar(255) NOT NULL DEFAULT '',
  `status` varchar(100) NOT NULL DEFAULT 'active',
  `social_id` varchar(255) NOT NULL DEFAULT '',
  `social_token` text,
  `token` varchar(255) NOT NULL DEFAULT '',
  `mobile_verification_code` int(14) NOT NULL DEFAULT '0',
  `account_verified` int(1) NOT NULL DEFAULT '0',
  `verify_code_requested` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `reset_password_request` int(1) NOT NULL DEFAULT '0',
  `last_login` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `date_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `date_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ip_address` varchar(50) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `st_client_address`
--

CREATE TABLE `st_client_address` (
  `address_id` int(11) NOT NULL,
  `client_id` int(14) NOT NULL DEFAULT '0',
  `address_type` varchar(50) NOT NULL DEFAULT 'map-based',
  `address_uuid` varchar(100) NOT NULL DEFAULT '',
  `place_id` varchar(255) NOT NULL DEFAULT '',
  `address1` varchar(255) NOT NULL DEFAULT '',
  `address2` varchar(255) NOT NULL DEFAULT '',
  `city` varchar(200) NOT NULL DEFAULT '',
  `state` varchar(200) NOT NULL DEFAULT '',
  `postal_code` varchar(255) NOT NULL DEFAULT '',
  `country` varchar(255) NOT NULL DEFAULT '',
  `country_code` varchar(5) NOT NULL DEFAULT '',
  `formatted_address` text,
  `formattedAddress` text,
  `latitude` varchar(255) NOT NULL DEFAULT '',
  `longitude` varchar(255) NOT NULL DEFAULT '',
  `location_name` varchar(255) NOT NULL DEFAULT '',
  `delivery_options` varchar(255) NOT NULL DEFAULT '',
  `delivery_instructions` varchar(255) NOT NULL DEFAULT '',
  `address_label` varchar(255) NOT NULL DEFAULT '',
  `company` varchar(255) NOT NULL DEFAULT '',
  `address_format_use` int(1) NOT NULL DEFAULT '1',
  `custom_field1` varchar(255) NOT NULL DEFAULT '',
  `custom_field2` text,
  `date_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `date_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ip_address` varchar(20) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `st_client_cc`
--

CREATE TABLE `st_client_cc` (
  `cc_id` int(14) NOT NULL,
  `card_uuid` varchar(100) NOT NULL DEFAULT '',
  `client_id` int(14) NOT NULL DEFAULT '0',
  `card_name` varchar(255) NOT NULL DEFAULT '',
  `credit_card_number` varchar(20) NOT NULL DEFAULT '',
  `encrypted_card` binary(255) DEFAULT NULL,
  `expiration_month` varchar(5) NOT NULL DEFAULT '',
  `expiration_yr` varchar(5) NOT NULL DEFAULT '',
  `cvv` varchar(20) NOT NULL DEFAULT '',
  `billing_address` varchar(255) NOT NULL DEFAULT '',
  `date_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `date_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ip_address` varchar(50) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `st_client_meta`
--

CREATE TABLE `st_client_meta` (
  `id` bigint(20) NOT NULL,
  `client_id` bigint(20) NOT NULL DEFAULT '0',
  `meta1` varchar(255) NOT NULL DEFAULT '',
  `meta2` varchar(255) NOT NULL DEFAULT '',
  `meta3` varchar(255) DEFAULT '',
  `meta4` varchar(255) NOT NULL DEFAULT '',
  `date_created` timestamp NULL DEFAULT NULL,
  `ip_address` varchar(50) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `st_client_payment_method`
--

CREATE TABLE `st_client_payment_method` (
  `payment_method_id` int(11) NOT NULL,
  `payment_uuid` varchar(100) NOT NULL DEFAULT '',
  `client_id` int(14) NOT NULL DEFAULT '0',
  `merchant_id` bigint(20) DEFAULT '0',
  `payment_code` varchar(100) NOT NULL DEFAULT '',
  `as_default` int(1) NOT NULL DEFAULT '0',
  `reference_id` int(14) NOT NULL DEFAULT '0',
  `attr1` varchar(255) NOT NULL DEFAULT '',
  `attr2` varchar(255) NOT NULL DEFAULT '',
  `attr3` varchar(255) NOT NULL DEFAULT '',
  `date_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `date_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ip_address` varchar(50) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `st_cooking_ref`
--

CREATE TABLE `st_cooking_ref` (
  `cook_id` int(14) NOT NULL,
  `merchant_id` int(14) NOT NULL DEFAULT '0',
  `cooking_name` varchar(255) NOT NULL DEFAULT '',
  `sequence` int(14) NOT NULL DEFAULT '0',
  `status` varchar(50) NOT NULL DEFAULT 'published',
  `date_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `date_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ip_address` varchar(50) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `st_cooking_ref_translation`
--

CREATE TABLE `st_cooking_ref_translation` (
  `id` int(11) NOT NULL,
  `merchant_id` int(14) NOT NULL DEFAULT '0',  
  `cook_id` int(14) NOT NULL DEFAULT '0',
  `language` varchar(10) NOT NULL DEFAULT '',
  `cooking_name` varchar(255) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `st_cuisine`
--

CREATE TABLE `st_cuisine` (
  `cuisine_id` int(14) NOT NULL,
  `cuisine_name` varchar(255) NOT NULL DEFAULT '',
  `featured_image` varchar(255) NOT NULL DEFAULT '',
  `path` varchar(255) NOT NULL DEFAULT '',
  `icon` varchar(255) NOT NULL DEFAULT '',
  `icon_path` varchar(255) NOT NULL DEFAULT '',
  `slug` varchar(255) NOT NULL DEFAULT '',
  `color_hex` varchar(10) NOT NULL DEFAULT '',
  `font_color_hex` varchar(10) NOT NULL DEFAULT '',
  `sequence` int(14) NOT NULL DEFAULT '0',
  `status` varchar(100) NOT NULL DEFAULT 'publish',
  `date_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `date_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ip_address` varchar(50) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `st_cuisine`
--

INSERT INTO `st_cuisine` (`cuisine_id`, `cuisine_name`, `featured_image`, `path`, `slug`, `color_hex`, `font_color_hex`, `sequence`, `status`, `date_created`, `date_modified`, `ip_address`) VALUES
(1, 'American', '', '', 'american', '#bad5f2', '#444444', 0, 'publish', '2022-01-26 22:15:29', '2022-01-26 22:15:29', ''),
(2, 'Deli', '', '', 'deli', '#d87f22', 'white', 0, 'publish', '2022-01-27 07:56:53', '2022-01-27 08:02:10', '127.0.0.1'),
(3, 'Indian', '', '', 'india', '#e69138', '#999999', 0, 'publish', '2022-01-27 07:57:02', '2022-01-27 08:02:03', '127.0.0.1'),
(4, 'Mediterranean', '', '', 'mediterranean', '#ffd966', '#999999', 0, 'publish', '2022-01-27 07:57:08', '2022-01-27 08:01:58', '127.0.0.1'),
(5, 'Sandwiches', '', '', 'sandwiches', '#bf9000', 'white', 0, 'publish', '2022-01-27 07:57:14', '2022-01-27 08:01:51', '127.0.0.1'),
(6, 'Barbeque', '', '', 'barbeque', '#b27c45', 'white', 0, 'publish', '2022-01-27 07:57:19', '2022-01-27 08:01:46', '127.0.0.1'),
(7, 'Diner', '', '', 'diner', '#3d85c6', '#5b5b5b', 0, 'publish', '2022-01-27 07:57:29', '2022-01-27 08:01:37', '127.0.0.1'),
(8, 'Italian', '', '', 'italian', '#a2c4c9', '#5b5b5b', 0, 'publish', '2022-01-27 07:57:35', '2022-01-27 08:01:28', '127.0.0.1'),
(9, 'Mexican', '', '', 'mexican', '#ea9999', 'white', 0, 'publish', '2022-01-27 07:57:39', '2022-01-27 08:01:21', '127.0.0.1'),
(10, 'Sushi', '', '', 'sushi', '#2986cc', 'white', 0, 'publish', '2022-01-27 07:57:45', '2022-01-27 08:01:14', '127.0.0.1'),
(11, 'Burgers', '', '', 'burgers', '#990000', 'white', 0, 'publish', '2022-01-27 07:57:51', '2022-01-27 08:01:09', '127.0.0.1'),
(12, 'Greek', '', '', 'greek', '#b45f06', 'white', 0, 'publish', '2022-01-27 07:57:59', '2022-01-27 08:01:03', '127.0.0.1'),
(13, 'Japanese', '', '', 'japanese', '#38761d', 'white', 0, 'publish', '2022-01-27 07:58:05', '2022-01-27 08:00:58', '127.0.0.1'),
(14, 'Middle Eastern', '', '', 'middle-eastern', '#45818e', 'white', 0, 'publish', '2022-01-27 07:58:12', '2022-01-27 08:00:51', '127.0.0.1'),
(15, 'Thai', '', '', 'thai', '#a2c4c9', 'black', 0, 'publish', '2022-01-27 07:58:17', '2022-01-27 08:00:45', '127.0.0.1'),
(16, 'Chinese', '', '', 'chinese', '#f6b26b', 'white', 0, 'publish', '2022-01-27 07:58:26', '2022-01-27 08:00:38', '127.0.0.1'),
(17, 'Healthy', '', '', 'healthy', '#8fce00', '#eeeeee', 0, 'publish', '2022-01-27 07:58:32', '2022-01-27 08:00:30', '127.0.0.1'),
(18, 'Korean', '', '', 'korean', '#f9cb9c', '#5b5b5b', 0, 'publish', '2022-01-27 07:58:39', '2022-01-27 08:00:21', '127.0.0.1'),
(19, 'Pizza', '', '', 'pizza', '#fedc78', '#999999', 0, 'publish', '2022-01-27 07:58:45', '2022-01-27 08:00:10', '127.0.0.1'),
(20, 'Vegetarian', '', '', 'vegetarian', '#efe5ee', 'black', 0, 'publish', '2022-01-27 07:58:50', '2022-01-27 07:59:27', '127.0.0.1'),
(21, 'Steak', '', '', 'steak', '#bad5f2', 'black', 0, 'publish', '2022-01-27 07:58:56', '2022-01-27 07:59:14', '127.0.0.1');

-- --------------------------------------------------------

--
-- Table structure for table `st_cuisine_merchant`
--

CREATE TABLE `st_cuisine_merchant` (
  `id` int(14) NOT NULL,
  `merchant_id` varchar(14) NOT NULL DEFAULT '0',
  `cuisine_id` varchar(14) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `st_cuisine_translation`
--

CREATE TABLE `st_cuisine_translation` (
  `id` int(11) NOT NULL,
  `cuisine_id` int(14) NOT NULL DEFAULT '0',
  `language` varchar(100) NOT NULL DEFAULT '',
  `cuisine_name` varchar(255) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `st_cuisine_translation`
--

INSERT INTO `st_cuisine_translation` (`id`, `cuisine_id`, `language`, `cuisine_name`) VALUES
(61, 21, 'ja', ''),
(62, 21, 'ar', ''),
(63, 21, 'en', 'Steak'),
(64, 20, 'ja', ''),
(65, 20, 'ar', ''),
(66, 20, 'en', 'Vegetarian'),
(67, 19, 'ja', ''),
(68, 19, 'ar', ''),
(69, 19, 'en', 'Pizza'),
(73, 18, 'ja', ''),
(74, 18, 'ar', ''),
(75, 18, 'en', 'Korean'),
(76, 17, 'ja', ''),
(77, 17, 'ar', ''),
(78, 17, 'en', 'Healthy'),
(79, 16, 'ja', ''),
(80, 16, 'ar', ''),
(81, 16, 'en', 'Chinese'),
(82, 15, 'ja', ''),
(83, 15, 'ar', ''),
(84, 15, 'en', 'Thai'),
(85, 14, 'ja', ''),
(86, 14, 'ar', ''),
(87, 14, 'en', 'Middle Eastern'),
(88, 13, 'ja', ''),
(89, 13, 'ar', ''),
(90, 13, 'en', 'Japanese'),
(91, 12, 'ja', ''),
(92, 12, 'ar', ''),
(93, 12, 'en', 'Greek'),
(94, 11, 'ja', ''),
(95, 11, 'ar', ''),
(96, 11, 'en', 'Burgers'),
(97, 10, 'ja', ''),
(98, 10, 'ar', ''),
(99, 10, 'en', 'Sushi'),
(100, 9, 'ja', ''),
(101, 9, 'ar', ''),
(102, 9, 'en', 'Mexican'),
(103, 8, 'ja', ''),
(104, 8, 'ar', ''),
(105, 8, 'en', 'Italian'),
(106, 7, 'ja', ''),
(107, 7, 'ar', ''),
(108, 7, 'en', 'Diner'),
(109, 6, 'ja', ''),
(110, 6, 'ar', ''),
(111, 6, 'en', 'Barbeque'),
(112, 5, 'ja', ''),
(113, 5, 'ar', ''),
(114, 5, 'en', 'Sandwiches'),
(115, 4, 'ja', ''),
(116, 4, 'ar', ''),
(117, 4, 'en', 'Mediterranean'),
(118, 3, 'ja', ''),
(119, 3, 'ar', ''),
(120, 3, 'en', 'Indian'),
(121, 2, 'ja', ''),
(122, 2, 'ar', ''),
(123, 2, 'en', 'Deli');

-- --------------------------------------------------------

--
-- Table structure for table `st_currency`
--

CREATE TABLE `st_currency` (
  `id` int(14) NOT NULL,
  `currency_code` varchar(3) NOT NULL DEFAULT '',
  `currency_symbol` varchar(100) NOT NULL DEFAULT '',
  `description` varchar(255) NOT NULL DEFAULT '',
  `as_default` int(1) NOT NULL DEFAULT '0',
  `is_hidden` int(1) NOT NULL DEFAULT '0',
  `currency_position` varchar(100) NOT NULL DEFAULT 'left',
  `exchange_rate` float(14,4) NOT NULL DEFAULT '0.0000',
  `exchange_rate_fee` float(14,4) NOT NULL DEFAULT '0.0000',
  `number_decimal` int(14) NOT NULL DEFAULT '2',
  `decimal_separator` varchar(5) NOT NULL DEFAULT '.',
  `thousand_separator` varchar(5) NOT NULL DEFAULT '',
  `status` varchar(100) NOT NULL DEFAULT 'publish',
  `date_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `date_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ip_address` varchar(50) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `st_currency`
--

INSERT INTO `st_currency` (`id`, `currency_code`, `currency_symbol`, `description`, `as_default`, `is_hidden`, `currency_position`, `exchange_rate`, `exchange_rate_fee`, `number_decimal`, `decimal_separator`, `thousand_separator`, `date_created`, `date_modified`, `ip_address`) VALUES
(1, 'USD', '$', 'United States Dollar', 1, 0, 'right', 1.0000, 0.0000, 2, '', '', '2021-01-20 08:00:54', '2022-01-26 22:41:48', '127.0.0.1'),
(2, 'JPY', '¥', 'Japan Yen', 0, 0, 'left', 104.5940, 0.0000, 2, '.', ',', '2021-01-20 08:02:20', '2021-05-18 23:33:26', '127.0.0.1'),
(13, 'PHP', '₱', 'Philippine Peso', 0, 0, 'left', 48.0425, 0.0000, 2, '.', ',', '2021-01-20 22:51:46', '2021-05-18 23:33:26', '127.0.0.1'),
(16, 'VND', '₫', 'Vietnamese Dong', 0, 0, 'left_space', 23028.3281, 0.0000, 2, '.', ',', '2021-01-21 07:38:41', '2021-05-18 23:33:26', '127.0.0.1'),
(21, 'SAR', '﷼', 'Saudi Riyal', 0, 0, 'left', 3.7511, 0.0000, 3, '.', ',', '2021-01-22 10:34:06', '2021-05-18 23:33:26', '127.0.0.1'),
(22, 'KRW', '₩', 'South Korean Won', 0, 0, 'left', 1106.2035, 0.0000, 2, '.', ',', '2021-01-22 18:08:45', '2021-05-18 23:33:26', '127.0.0.1'),
(23, 'AED', 'د.إ', 'UAE Dirham', 0, 0, 'left', 3.6732, 0.0000, 2, '.', ',', '2021-01-27 15:04:01', '2021-05-18 23:33:26', '127.0.0.1'),
(39, 'SGD', '$', 'Singapore Dollar', 0, 0, 'left', 1.3264, 0.0000, 2, '.', ',', '2021-02-05 10:51:33', '2021-05-18 23:33:26', '127.0.0.1'),
(40, 'EUR', '€', 'Euro', 0, 0, 'left', 0.8252, 0.0000, 2, '.', ',', '2021-02-05 23:20:31', '2021-05-18 23:33:26', '127.0.0.1'),
(41, 'BRL', 'R$', 'Brazilian Real', 0, 0, 'left', 5.3866, 0.0000, 2, '.', ',', '2021-02-05 23:21:54', '2021-05-18 23:33:26', '127.0.0.1'),
(42, 'INR', '₹', 'Indian Rupee', 0, 0, 'left', 72.8289, 0.0000, 2, '.', ',', '2021-02-09 09:52:18', '2021-05-18 23:33:26', '127.0.0.1'),
(43, 'ZWL', '', 'Zimbabwean Dollar', 0, 0, 'left', 322.0000, 0.0000, 2, '.', '', '2021-05-18 23:33:19', '2022-01-26 15:44:44', '127.0.0.1');

-- --------------------------------------------------------

--
-- Table structure for table `st_device`
--

CREATE TABLE `st_device` (
  `device_id` bigint(20) NOT NULL,
  `user_type` varchar(50) NOT NULL DEFAULT '',
  `user_id` bigint(20) NOT NULL DEFAULT '0',
  `platform` varchar(50) NOT NULL DEFAULT '',
  `device_token` text,
  `device_uiid` varchar(255) NOT NULL DEFAULT '',
  `browser_agent` varchar(255) NOT NULL DEFAULT '',
  `enabled` tinyint(1) NOT NULL DEFAULT '1',
  `date_created` timestamp NULL DEFAULT NULL,
  `date_modified` timestamp NULL DEFAULT NULL,
  `ip_address` varchar(50) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `st_device_meta`
--

CREATE TABLE `st_device_meta` (
  `id` bigint(20) NOT NULL,
  `device_id` bigint(20) NOT NULL DEFAULT '0',
  `meta_name` varchar(100) NOT NULL DEFAULT '',
  `meta_value` text,
  `meta_value1` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `st_dishes`
--

CREATE TABLE `st_dishes` (
  `dish_id` int(14) NOT NULL,
  `dish_name` varchar(255) NOT NULL DEFAULT '',
  `photo` varchar(255) NOT NULL DEFAULT '',
  `path` varchar(255) DEFAULT '',
  `status` varchar(100) NOT NULL DEFAULT '',
  `date_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `date_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ip_address` varchar(50) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `st_dishes_translation`
--

CREATE TABLE `st_dishes_translation` (
  `id` int(11) NOT NULL,
  `dish_id` int(14) NOT NULL DEFAULT '0',
  `language` varchar(100) NOT NULL DEFAULT '',
  `dish_name` varchar(255) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `st_email_logs`
--

CREATE TABLE `st_email_logs` (
  `id` int(14) NOT NULL,
  `email_address` varchar(255) NOT NULL DEFAULT '',
  `sender` varchar(255) NOT NULL DEFAULT '',
  `subject` varchar(255) NOT NULL DEFAULT '',
  `content` longtext,
  `status` varchar(255) NOT NULL DEFAULT 'pending',
  `email_provider` varchar(100) NOT NULL DEFAULT '',
  `date_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ip_address` varchar(50) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `st_email_provider`
--

CREATE TABLE `st_email_provider` (
  `id` int(11) NOT NULL,
  `provider_id` varchar(100) NOT NULL DEFAULT '',
  `provider_name` varchar(255) NOT NULL DEFAULT '',
  `as_default` int(1) NOT NULL DEFAULT '0',
  `sender_name` varchar(255) NOT NULL DEFAULT '',
  `sender` varchar(255) NOT NULL DEFAULT '',
  `api_key` varchar(255) NOT NULL DEFAULT '',
  `secret_key` varchar(255) NOT NULL DEFAULT '',
  `smtp_host` varchar(255) NOT NULL DEFAULT '',
  `smtp_port` varchar(255) NOT NULL DEFAULT '',
  `smtp_username` varchar(255) NOT NULL DEFAULT '',
  `smtp_password` varchar(255) NOT NULL DEFAULT '',
  `smtp_secure` varchar(255) NOT NULL DEFAULT '',
  `date_created` datetime DEFAULT NULL,
  `date_modified` datetime DEFAULT NULL,
  `ip_address` varchar(50) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `st_email_provider`
--

INSERT INTO `st_email_provider` (`id`, `provider_id`, `provider_name`, `as_default`, `sender_name`, `sender`, `api_key`, `secret_key`, `smtp_host`, `smtp_port`, `smtp_username`, `smtp_password`, `smtp_secure`, `date_created`, `date_modified`, `ip_address`) VALUES
(1, 'phpmail', 'PHP Mail', 0, '', '', '', '', '', '', '', '', '', NULL, '2021-11-28 14:20:01', '127.0.0.1'),
(2, 'smtp', 'SMTP', 0, '', '', '', '', '', '', '', '', '', NULL, '2021-10-08 09:26:57', '::1'),
(4, 'sendgrid', 'SendGrid', 0, '', '', '', '', '', '', '', '', '', NULL, '2021-11-27 01:54:53', '127.0.0.1'),
(5, 'mailjet', 'MailJet', 0, '', '', '', '', '', '', '', '', '', NULL, '2021-10-08 09:27:48', '::1'),
(6, 'elastic', 'Elastic Email', 0, '', '', '', '', '', '', '', '', '', NULL, '2021-10-08 09:28:06', '::1');

-- --------------------------------------------------------

--
-- Table structure for table `st_favorites`
--

CREATE TABLE `st_favorites` (
  `id` int(14) NOT NULL,
  `fav_type` varchar(100) NOT NULL DEFAULT 'restaurant',
  `client_id` int(14) NOT NULL DEFAULT '0',
  `item_id` int(14) NOT NULL DEFAULT '0',
  `merchant_id` int(14) NOT NULL DEFAULT '0',
  `cat_id` int(14) NOT NULL DEFAULT '0',  
  `date_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `date_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ip_address` varchar(50) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `st_featured_location`
--

CREATE TABLE `st_featured_location` (
  `id` int(11) NOT NULL,
  `featured_name` varchar(50) NOT NULL DEFAULT '',
  `location_name` varchar(255) NOT NULL DEFAULT '',
  `latitude` varchar(20) NOT NULL DEFAULT '',
  `longitude` varchar(20) NOT NULL DEFAULT '',
  `status` varchar(255) NOT NULL DEFAULT 'publish',
  `date_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `date_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ip_address` varchar(50) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `st_gpdr_request`
--

CREATE TABLE `st_gpdr_request` (
  `id` int(11) NOT NULL,
  `request_type` varchar(255) NOT NULL DEFAULT '',
  `client_id` int(14) NOT NULL DEFAULT '0',
  `first_name` varchar(255) NOT NULL DEFAULT '',
  `last_name` varchar(255) NOT NULL DEFAULT '',
  `email_address` varchar(255) NOT NULL DEFAULT '',
  `message` text,
  `status` varchar(100) NOT NULL DEFAULT 'pending',
  `date_created` datetime DEFAULT NULL,
  `date_modified` datetime DEFAULT NULL,
  `ip_address` varchar(50) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `st_ingredients`
--

CREATE TABLE `st_ingredients` (
  `ingredients_id` int(14) NOT NULL,
  `merchant_id` int(14) NOT NULL DEFAULT '0',
  `ingredients_name` varchar(255) NOT NULL DEFAULT '',
  `sequence` int(14) NOT NULL DEFAULT '0',
  `status` varchar(50) NOT NULL DEFAULT 'published',
  `date_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `date_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ip_address` varchar(50) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `st_ingredients_translation`
--

CREATE TABLE `st_ingredients_translation` (
  `id` int(11) NOT NULL,
  `merchant_id` int(14) NOT NULL DEFAULT '0',
  `ingredients_id` int(14) NOT NULL DEFAULT '0',
  `language` varchar(10) NOT NULL DEFAULT '',
  `ingredients_name` varchar(255) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `st_inventory_supplier`
--

CREATE TABLE `st_inventory_supplier` (
  `supplier_id` int(11) NOT NULL,
  `merchant_id` int(14) NOT NULL DEFAULT '0',
  `supplier_name` varchar(255) NOT NULL DEFAULT '',
  `contact_name` varchar(255) NOT NULL DEFAULT '',
  `email` varchar(255) NOT NULL DEFAULT '',
  `phone_number` varchar(50) NOT NULL DEFAULT '',
  `address_1` varchar(255) NOT NULL DEFAULT '',
  `address_2` varchar(255) NOT NULL DEFAULT '',
  `city` varchar(100) NOT NULL DEFAULT '',
  `postal_code` varchar(100) NOT NULL DEFAULT '',
  `country_code` varchar(5) NOT NULL DEFAULT '',
  `region` varchar(100) NOT NULL DEFAULT '',
  `notes` text,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ip_address` varchar(50) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `st_item`
--

CREATE TABLE `st_item` (
  `item_id` int(14) NOT NULL,
  `merchant_id` int(14) NOT NULL DEFAULT '0',
  `item_name` varchar(255) NOT NULL DEFAULT '',
  `slug` varchar(255) NOT NULL DEFAULT '',
  `item_description` text,
  `item_short_description` varchar(255) NOT NULL DEFAULT '',
  `status` varchar(50) NOT NULL DEFAULT '',
  `photo` varchar(255) NOT NULL DEFAULT '',
  `path` varchar(255) NOT NULL DEFAULT '',
  `sequence` int(14) NOT NULL DEFAULT '0',
  `is_featured` varchar(1) NOT NULL DEFAULT '',
  `featured_priority` int(10) DEFAULT NULL,
  `non_taxable` int(1) NOT NULL DEFAULT '1',
  `available` int(1) NOT NULL DEFAULT '1',
  `points_earned` int(14) NOT NULL DEFAULT '0',
  `points_enabled` int(1) NOT NULL DEFAULT '1',
  `packaging_fee` float(14,4) NOT NULL DEFAULT '0.0000',
  `packaging_incremental` int(1) NOT NULL DEFAULT '0',
  `item_token` varchar(50) NOT NULL DEFAULT '',
  `sku` varchar(255) NOT NULL DEFAULT '',
  `track_stock` int(1) NOT NULL DEFAULT '1',
  `supplier_id` int(14) NOT NULL DEFAULT '0',
  `meta_title` varchar(255) NOT NULL DEFAULT '',
  `meta_description` text,
  `meta_keywords` text,
  `meta_image` varchar(255) NOT NULL DEFAULT '',
  `meta_image_path` varchar(255) NOT NULL DEFAULT '',
  `cooking_ref_required` smallint(1) NOT NULL DEFAULT '0',
  `ingredients_preselected` tinyint(1) NOT NULL DEFAULT '0',
  `available_at_specific` tinyint(1) NOT NULL DEFAULT '0',
  `not_for_sale` tinyint(1) NOT NULL DEFAULT '0',
  `color_hex` varchar(10) NOT NULL DEFAULT '',
  `visible` int(1) NOT NULL DEFAULT '1',
  `preparation_time` int(10) NOT NULL DEFAULT '0',
  `extra_preparation_time` int(10) NOT NULL DEFAULT '0',
  `unavailable_until` datetime DEFAULT NULL,
  `is_promo_free_item` tinyint(1) NOT NULL DEFAULT '0',
  `date_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `date_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ip_address` varchar(50) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `st_item_meta`
--

CREATE TABLE `st_item_meta` (
  `id` int(11) NOT NULL,
  `merchant_id` int(14) NOT NULL DEFAULT '0',
  `item_id` int(14) NOT NULL DEFAULT '0',
  `meta_name` varchar(255) NOT NULL DEFAULT '',
  `meta_id` varchar(255) NOT NULL DEFAULT '',
  `meta_value` varchar(255) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `st_item_promo`
--

CREATE TABLE `st_item_promo` (
  `promo_id` int(11) NOT NULL,
  `merchant_id` int(11) NOT NULL DEFAULT '0',
  `item_id` int(11) NOT NULL DEFAULT '0',
  `promo_type` varchar(50) NOT NULL DEFAULT '',
  `buy_qty` int(14) DEFAULT '0',
  `get_qty` int(14) DEFAULT '0',
  `item_id_promo` int(14) NOT NULL DEFAULT '0',
  `discount_start` date DEFAULT NULL,
  `discount_end` date DEFAULT NULL,
  `date_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `date_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ip_address` varchar(50) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `st_item_relationship_category`
--

CREATE TABLE `st_item_relationship_category` (
  `id` int(11) NOT NULL,
  `merchant_id` int(14) NOT NULL DEFAULT '0',
  `item_id` int(14) NOT NULL DEFAULT '0',
  `cat_id` int(14) NOT NULL DEFAULT '0',
  `sequence` int(14) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `st_item_relationship_size`
--

CREATE TABLE `st_item_relationship_size` (
  `item_size_id` int(11) NOT NULL,
  `merchant_id` int(14) NOT NULL DEFAULT '0',
  `item_token` varchar(255) NOT NULL DEFAULT '',
  `item_id` int(14) NOT NULL DEFAULT '0',
  `size_id` int(14) NOT NULL DEFAULT '0',
  `price` float(14,4) NOT NULL DEFAULT '0.0000',
  `cost_price` float(14,4) NOT NULL DEFAULT '0.0000',
  `discount` float(14,4) NOT NULL DEFAULT '0.0000',
  `discount_type` varchar(50) NOT NULL DEFAULT 'fixed',
  `discount_start` date DEFAULT NULL,
  `discount_end` date DEFAULT NULL,
  `sequence` smallint(1) NOT NULL DEFAULT '0',
  `sku` varchar(255) NOT NULL DEFAULT '',
  `barcode` varchar(50) NOT NULL DEFAULT '',
  `available` int(1) NOT NULL DEFAULT '1',
  `low_stock` float(14,2) NOT NULL DEFAULT '0.00',
  `created_at` varchar(50) NOT NULL DEFAULT '',
  `updated_at` varchar(50) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- --------------------------------------------------------

--
-- Table structure for table `st_item_relationship_subcategory`
--

CREATE TABLE `st_item_relationship_subcategory` (
  `id` int(11) NOT NULL,
  `merchant_id` int(14) NOT NULL DEFAULT '0',
  `item_id` int(14) NOT NULL DEFAULT '0',
  `item_size_id` int(14) NOT NULL DEFAULT '0',
  `subcat_id` int(14) NOT NULL DEFAULT '0',
  `multi_option` varchar(255) NOT NULL DEFAULT '',
  `multi_option_min` int(14) NOT NULL DEFAULT '0',  
  `multi_option_value` varchar(255) NOT NULL DEFAULT '',
  `require_addon` smallint(1) NOT NULL DEFAULT '0',
  `pre_selected` smallint(1) NOT NULL DEFAULT '0',
  `sequence` int(12) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `st_item_relationship_subcategory_item`
--

CREATE TABLE `st_item_relationship_subcategory_item` (
  `id` int(11) NOT NULL,
  `merchant_id` int(14) NOT NULL DEFAULT '0',
  `item_id` int(14) NOT NULL DEFAULT '0',
  `subcat_id` int(14) NOT NULL DEFAULT '0',
  `sub_item_id` int(14) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `st_item_translation`
--

CREATE TABLE `st_item_translation` (
  `id` int(11) NOT NULL,
  `merchant_id` int(14) NOT NULL DEFAULT '0',
  `item_id` int(14) NOT NULL DEFAULT '0',
  `language` varchar(10) NOT NULL DEFAULT '',
  `item_name` varchar(255) NOT NULL DEFAULT '',
  `item_description` text,
  `item_short_description` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `st_language`
--

CREATE TABLE `st_language` (
  `id` int(11) NOT NULL,
  `code` varchar(100) NOT NULL DEFAULT '',
  `title` varchar(255) NOT NULL DEFAULT '',
  `description` varchar(255) NOT NULL DEFAULT '',
  `flag` varchar(100) NOT NULL DEFAULT '',
  `rtl` int(1) NOT NULL DEFAULT '0',
  `sequence` int(11) NOT NULL DEFAULT '0',
  `status` varchar(255) NOT NULL DEFAULT 'publish',
  `date_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `date_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ip_address` varchar(50) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `st_language`
--

INSERT INTO `st_language` (`id`, `code`, `title`, `description`, `flag`, `rtl`, `sequence`, `status`, `date_created`, `date_modified`, `ip_address`) VALUES
(1, 'ar', 'Arabic', 'al-\'arabiyyah, العربية', 'AE', 1, 3, 'publish', '2021-05-08 14:46:23', '2022-01-27 08:05:31', '127.0.0.1'),
(2, 'en', 'English', 'american english', 'US', 0, 1, 'publish', '2021-05-08 14:46:23', '2022-01-27 08:05:25', '127.0.0.1'),
(4, 'ja', 'Japanese', 'nihongo', 'JP', 0, 2, 'publish', '2021-05-08 14:46:23', '2022-01-27 08:05:19', '127.0.0.1');

-- --------------------------------------------------------

--
-- Table structure for table `st_location_area`
--

CREATE TABLE `st_location_area` (
  `area_id` int(14) NOT NULL,
  `name` varchar(255) NOT NULL DEFAULT '',
  `city_id` int(14) NOT NULL DEFAULT '0',
  `sequence` int(14) NOT NULL DEFAULT '0',
  `date_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `date_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ip_address` varchar(50) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `st_location_cities`
--

CREATE TABLE `st_location_cities` (
  `city_id` int(11) NOT NULL,
  `name` varchar(30) NOT NULL DEFAULT '',
  `postal_code` varchar(255) NOT NULL DEFAULT '',
  `state_id` int(11) NOT NULL,
  `sequence` int(14) NOT NULL DEFAULT '0',
  `date_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `date_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ip_address` varchar(50) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `st_location_countries`
--

CREATE TABLE `st_location_countries` (
  `country_id` int(11) NOT NULL,
  `shortcode` varchar(3) NOT NULL DEFAULT '',
  `country_name` varchar(150) NOT NULL DEFAULT '',
  `phonecode` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `st_location_countries`
--

INSERT INTO `st_location_countries` (`country_id`, `shortcode`, `country_name`, `phonecode`) VALUES
(1, 'AF', 'Afghanistan', 93),
(2, 'AL', 'Albania', 355),
(3, 'DZ', 'Algeria', 213),
(4, 'AS', 'American Samoa', 1684),
(5, 'AD', 'Andorra', 376),
(6, 'AO', 'Angola', 244),
(7, 'AI', 'Anguilla', 1264),
(8, 'AQ', 'Antarctica', 0),
(9, 'AG', 'Antigua And Barbuda', 1268),
(10, 'AR', 'Argentina', 54),
(11, 'AM', 'Armenia', 374),
(12, 'AW', 'Aruba', 297),
(13, 'AU', 'Australia', 61),
(14, 'AT', 'Austria', 43),
(15, 'AZ', 'Azerbaijan', 994),
(16, 'BS', 'Bahamas The', 1242),
(17, 'BH', 'Bahrain', 973),
(18, 'BD', 'Bangladesh', 880),
(19, 'BB', 'Barbados', 1246),
(20, 'BY', 'Belarus', 375),
(21, 'BE', 'Belgium', 32),
(22, 'BZ', 'Belize', 501),
(23, 'BJ', 'Benin', 229),
(24, 'BM', 'Bermuda', 1441),
(25, 'BT', 'Bhutan', 975),
(26, 'BO', 'Bolivia', 591),
(27, 'BA', 'Bosnia and Herzegovina', 387),
(28, 'BW', 'Botswana', 267),
(29, 'BV', 'Bouvet Island', 0),
(30, 'BR', 'Brazil', 55),
(31, 'IO', 'British Indian Ocean Territory', 246),
(32, 'BN', 'Brunei', 673),
(33, 'BG', 'Bulgaria', 359),
(34, 'BF', 'Burkina Faso', 226),
(35, 'BI', 'Burundi', 257),
(36, 'KH', 'Cambodia', 855),
(37, 'CM', 'Cameroon', 237),
(38, 'CA', 'Canada', 1),
(39, 'CV', 'Cape Verde', 238),
(40, 'KY', 'Cayman Islands', 1345),
(41, 'CF', 'Central African Republic', 236),
(42, 'TD', 'Chad', 235),
(43, 'CL', 'Chile', 56),
(44, 'CN', 'China', 86),
(45, 'CX', 'Christmas Island', 61),
(46, 'CC', 'Cocos (Keeling) Islands', 672),
(47, 'CO', 'Colombia', 57),
(48, 'KM', 'Comoros', 269),
(49, 'CG', 'Congo', 242),
(50, 'CD', 'Congo The Democratic Republic Of The', 242),
(51, 'CK', 'Cook Islands', 682),
(52, 'CR', 'Costa Rica', 506),
(53, 'CI', 'Cote D\'Ivoire (Ivory Coast)', 225),
(54, 'HR', 'Croatia (Hrvatska)', 385),
(55, 'CU', 'Cuba', 53),
(56, 'CY', 'Cyprus', 357),
(57, 'CZ', 'Czech Republic', 420),
(58, 'DK', 'Denmark', 45),
(59, 'DJ', 'Djibouti', 253),
(60, 'DM', 'Dominica', 1767),
(61, 'DO', 'Dominican Republic', 1809),
(62, 'TP', 'East Timor', 670),
(63, 'EC', 'Ecuador', 593),
(64, 'EG', 'Egypt', 20),
(65, 'SV', 'El Salvador', 503),
(66, 'GQ', 'Equatorial Guinea', 240),
(67, 'ER', 'Eritrea', 291),
(68, 'EE', 'Estonia', 372),
(69, 'ET', 'Ethiopia', 251),
(70, 'XA', 'External Territories of Australia', 61),
(71, 'FK', 'Falkland Islands', 500),
(72, 'FO', 'Faroe Islands', 298),
(73, 'FJ', 'Fiji Islands', 679),
(74, 'FI', 'Finland', 358),
(75, 'FR', 'France', 33),
(76, 'GF', 'French Guiana', 594),
(77, 'PF', 'French Polynesia', 689),
(78, 'TF', 'French Southern Territories', 0),
(79, 'GA', 'Gabon', 241),
(80, 'GM', 'Gambia The', 220),
(81, 'GE', 'Georgia', 995),
(82, 'DE', 'Germany', 49),
(83, 'GH', 'Ghana', 233),
(84, 'GI', 'Gibraltar', 350),
(85, 'GR', 'Greece', 30),
(86, 'GL', 'Greenland', 299),
(87, 'GD', 'Grenada', 1473),
(88, 'GP', 'Guadeloupe', 590),
(89, 'GU', 'Guam', 1671),
(90, 'GT', 'Guatemala', 502),
(91, 'XU', 'Guernsey and Alderney', 44),
(92, 'GN', 'Guinea', 224),
(93, 'GW', 'Guinea-Bissau', 245),
(94, 'GY', 'Guyana', 592),
(95, 'HT', 'Haiti', 509),
(96, 'HM', 'Heard and McDonald Islands', 0),
(97, 'HN', 'Honduras', 504),
(98, 'HK', 'Hong Kong S.A.R.', 852),
(99, 'HU', 'Hungary', 36),
(100, 'IS', 'Iceland', 354),
(101, 'IN', 'India', 91),
(102, 'ID', 'Indonesia', 62),
(103, 'IR', 'Iran', 98),
(104, 'IQ', 'Iraq', 964),
(105, 'IE', 'Ireland', 353),
(106, 'IL', 'Israel', 972),
(107, 'IT', 'Italy', 39),
(108, 'JM', 'Jamaica', 1876),
(109, 'JP', 'Japan', 81),
(110, 'XJ', 'Jersey', 44),
(111, 'JO', 'Jordan', 962),
(112, 'KZ', 'Kazakhstan', 7),
(113, 'KE', 'Kenya', 254),
(114, 'KI', 'Kiribati', 686),
(115, 'KP', 'Korea North', 850),
(116, 'KR', 'Korea South', 82),
(117, 'KW', 'Kuwait', 965),
(118, 'KG', 'Kyrgyzstan', 996),
(119, 'LA', 'Laos', 856),
(120, 'LV', 'Latvia', 371),
(121, 'LB', 'Lebanon', 961),
(122, 'LS', 'Lesotho', 266),
(123, 'LR', 'Liberia', 231),
(124, 'LY', 'Libya', 218),
(125, 'LI', 'Liechtenstein', 423),
(126, 'LT', 'Lithuania', 370),
(127, 'LU', 'Luxembourg', 352),
(128, 'MO', 'Macau S.A.R.', 853),
(129, 'MK', 'Macedonia', 389),
(130, 'MG', 'Madagascar', 261),
(131, 'MW', 'Malawi', 265),
(132, 'MY', 'Malaysia', 60),
(133, 'MV', 'Maldives', 960),
(134, 'ML', 'Mali', 223),
(135, 'MT', 'Malta', 356),
(136, 'XM', 'Man (Isle of)', 44),
(137, 'MH', 'Marshall Islands', 692),
(138, 'MQ', 'Martinique', 596),
(139, 'MR', 'Mauritania', 222),
(140, 'MU', 'Mauritius', 230),
(141, 'YT', 'Mayotte', 269),
(142, 'MX', 'Mexico', 52),
(143, 'FM', 'Micronesia', 691),
(144, 'MD', 'Moldova', 373),
(145, 'MC', 'Monaco', 377),
(146, 'MN', 'Mongolia', 976),
(147, 'MS', 'Montserrat', 1664),
(148, 'MA', 'Morocco', 212),
(149, 'MZ', 'Mozambique', 258),
(150, 'MM', 'Myanmar', 95),
(151, 'NA', 'Namibia', 264),
(152, 'NR', 'Nauru', 674),
(153, 'NP', 'Nepal', 977),
(154, 'AN', 'Netherlands Antilles', 599),
(155, 'NL', 'Netherlands The', 31),
(156, 'NC', 'New Caledonia', 687),
(157, 'NZ', 'New Zealand', 64),
(158, 'NI', 'Nicaragua', 505),
(159, 'NE', 'Niger', 227),
(160, 'NG', 'Nigeria', 234),
(161, 'NU', 'Niue', 683),
(162, 'NF', 'Norfolk Island', 672),
(163, 'MP', 'Northern Mariana Islands', 1670),
(164, 'NO', 'Norway', 47),
(165, 'OM', 'Oman', 968),
(166, 'PK', 'Pakistan', 92),
(167, 'PW', 'Palau', 680),
(168, 'PS', 'Palestinian Territory Occupied', 970),
(169, 'PA', 'Panama', 507),
(170, 'PG', 'Papua new Guinea', 675),
(171, 'PY', 'Paraguay', 595),
(172, 'PE', 'Peru', 51),
(173, 'PH', 'Philippines', 63),
(174, 'PN', 'Pitcairn Island', 0),
(175, 'PL', 'Poland', 48),
(176, 'PT', 'Portugal', 351),
(177, 'PR', 'Puerto Rico', 1787),
(178, 'QA', 'Qatar', 974),
(179, 'RE', 'Reunion', 262),
(180, 'RO', 'Romania', 40),
(181, 'RU', 'Russia', 70),
(182, 'RW', 'Rwanda', 250),
(183, 'SH', 'Saint Helena', 290),
(184, 'KN', 'Saint Kitts And Nevis', 1869),
(185, 'LC', 'Saint Lucia', 1758),
(186, 'PM', 'Saint Pierre and Miquelon', 508),
(187, 'VC', 'Saint Vincent And The Grenadines', 1784),
(188, 'WS', 'Samoa', 684),
(189, 'SM', 'San Marino', 378),
(190, 'ST', 'Sao Tome and Principe', 239),
(191, 'SA', 'Saudi Arabia', 966),
(192, 'SN', 'Senegal', 221),
(193, 'RS', 'Serbia', 381),
(194, 'SC', 'Seychelles', 248),
(195, 'SL', 'Sierra Leone', 232),
(196, 'SG', 'Singapore', 65),
(197, 'SK', 'Slovakia', 421),
(198, 'SI', 'Slovenia', 386),
(199, 'XG', 'Smaller Territories of the UK', 44),
(200, 'SB', 'Solomon Islands', 677),
(201, 'SO', 'Somalia', 252),
(202, 'ZA', 'South Africa', 27),
(203, 'GS', 'South Georgia', 0),
(204, 'SS', 'South Sudan', 211),
(205, 'ES', 'Spain', 34),
(206, 'LK', 'Sri Lanka', 94),
(207, 'SD', 'Sudan', 249),
(208, 'SR', 'Suriname', 597),
(209, 'SJ', 'Svalbard And Jan Mayen Islands', 47),
(210, 'SZ', 'Swaziland', 268),
(211, 'SE', 'Sweden', 46),
(212, 'CH', 'Switzerland', 41),
(213, 'SY', 'Syria', 963),
(214, 'TW', 'Taiwan', 886),
(215, 'TJ', 'Tajikistan', 992),
(216, 'TZ', 'Tanzania', 255),
(217, 'TH', 'Thailand', 66),
(218, 'TG', 'Togo', 228),
(219, 'TK', 'Tokelau', 690),
(220, 'TO', 'Tonga', 676),
(221, 'TT', 'Trinidad And Tobago', 1868),
(222, 'TN', 'Tunisia', 216),
(223, 'TR', 'Turkey', 90),
(224, 'TM', 'Turkmenistan', 7370),
(225, 'TC', 'Turks And Caicos Islands', 1649),
(226, 'TV', 'Tuvalu', 688),
(227, 'UG', 'Uganda', 256),
(228, 'UA', 'Ukraine', 380),
(229, 'AE', 'United Arab Emirates', 971),
(230, 'GB', 'United Kingdom', 44),
(231, 'US', 'United States', 1),
(232, 'UM', 'United States Minor Outlying Islands', 1),
(233, 'UY', 'Uruguay', 598),
(234, 'UZ', 'Uzbekistan', 998),
(235, 'VU', 'Vanuatu', 678),
(236, 'VA', 'Vatican City State (Holy See)', 39),
(237, 'VE', 'Venezuela', 58),
(238, 'VN', 'Vietnam', 84),
(239, 'VG', 'Virgin Islands (British)', 1284),
(240, 'VI', 'Virgin Islands (US)', 1340),
(241, 'WF', 'Wallis And Futuna Islands', 681),
(242, 'EH', 'Western Sahara', 212),
(243, 'YE', 'Yemen', 967),
(244, 'YU', 'Yugoslavia', 38),
(245, 'ZM', 'Zambia', 260),
(246, 'ZW', 'Zimbabwe', 263);

-- --------------------------------------------------------

--
-- Table structure for table `st_location_rate`
--

CREATE TABLE `st_location_rate` (
  `rate_id` int(14) NOT NULL,
  `merchant_id` int(14) NOT NULL DEFAULT '0',
  `country_id` int(14) NOT NULL DEFAULT '0',
  `state_id` int(14) NOT NULL DEFAULT '0',
  `city_id` int(14) DEFAULT '0',
  `area_id` int(14) NOT NULL DEFAULT '0',
  `fee` float(14,4) NOT NULL DEFAULT '0.00000',
  `minimum_order` float(14,4) NOT NULL DEFAULT '0.00000',
  `maximum_amount` float(14,2) NOT NULL DEFAULT '0.00',
  `free_above_subtotal` float(14,4) NOT NULL DEFAULT '0.00000',
  `sequence` int(14) NOT NULL DEFAULT '0',
  `date_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `date_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ip_address` varchar(50) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `st_location_states`
--

CREATE TABLE `st_location_states` (
  `state_id` int(11) NOT NULL,
  `name` varchar(30) NOT NULL DEFAULT '',
  `country_id` int(11) NOT NULL DEFAULT '1',
  `sequence` int(14) NOT NULL DEFAULT '0',
  `date_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `date_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ip_address` varchar(50) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `st_map_places`
--

CREATE TABLE `st_map_places` (
  `id` int(11) NOT NULL,
  `reference_type` varchar(50) NOT NULL DEFAULT '',
  `reference_id` varchar(255) NOT NULL DEFAULT '',
  `latitude` varchar(20) NOT NULL DEFAULT '',
  `longitude` varchar(20) NOT NULL DEFAULT '',
  `address1` varchar(255) NOT NULL DEFAULT '',
  `address2` varchar(255) NOT NULL DEFAULT '',
  `country` varchar(255) NOT NULL DEFAULT '',
  `country_code` varchar(5) NOT NULL DEFAULT '',
  `postal_code` varchar(100) NOT NULL DEFAULT '',
  `formatted_address` varchar(255) NOT NULL DEFAULT '',
  `parsed_address` text,
  `date_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `date_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ip_address` varchar(50) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `st_media_files`
--

CREATE TABLE `st_media_files` (
  `id` int(11) NOT NULL,
  `upload_uuid` varchar(100) NOT NULL DEFAULT '',
  `merchant_id` int(14) NOT NULL DEFAULT '0',
  `title` varchar(255) NOT NULL DEFAULT '',
  `filename` varchar(255) NOT NULL DEFAULT '',
  `path` varchar(255) NOT NULL DEFAULT '',
  `size` varchar(50) NOT NULL DEFAULT '',
  `media_type` varchar(100) NOT NULL DEFAULT '',
  `meta_name` varchar(100) NOT NULL DEFAULT '',
  `date_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ip_address` varchar(50) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `st_menu`
--

CREATE TABLE `st_menu` (
  `menu_id` int(11) NOT NULL,
  `menu_type` varchar(100) NOT NULL DEFAULT 'admin',
  `menu_name` varchar(255) NOT NULL DEFAULT '',
  `parent_id` int(11) NOT NULL DEFAULT '0',
  `meta_value1` int(10) NOT NULL DEFAULT '0',
  `link` varchar(255) NOT NULL DEFAULT '',
  `action_name` varchar(255) NOT NULL DEFAULT '',
  `sequence` decimal(10,2) NOT NULL DEFAULT '0.00',
  `status` int(1) NOT NULL DEFAULT '1',
  `visible` int(1) NOT NULL DEFAULT '1',
  `role_create` varchar(255) NOT NULL DEFAULT '',
  `role_update` varchar(255) NOT NULL DEFAULT '',
  `role_delete` varchar(255) NOT NULL DEFAULT '',
  `role_view` varchar(255) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `st_menu`
--

INSERT INTO `st_menu` (`menu_id`, `menu_type`, `menu_name`, `parent_id`, `meta_value1`, `link`, `action_name`, `sequence`, `status`, `visible`, `role_create`, `role_update`, `role_delete`, `role_view`) VALUES
(1, 'admin', 'Dashboard', 0, 0, 'admin/dashboard', 'admin.dashboard', 1.00, 1, 1, '', '', '', ''),
(2, 'admin', 'Merchant', 0, 0, '', 'merchant', 3.00, 1, 1, '', '', '', ''),
(5, 'admin', 'Users', 0, 0, '', 'admin.user', 18.00, 1, 1, '', '', '', ''),
(6, 'admin', 'Orders', 0, 0, '', 'admin.orders', 5.00, 1, 1, '', '', '', ''),
(16, 'admin', 'Membership', 0, 0, '', 'membership', 4.00, 1, 1, '', '', '', ''),
(20, 'admin', 'Attributes', 0, 0, '', 'attributes', 10.00, 1, 1, '', '', '', ''),
(26, 'admin', 'Site configuration', 0, 0, 'admin/site_information', 'admin.site_information', 2.00, 1, 1, '', '', '', ''),
(28, 'admin', 'Promo', 0, 0, '', 'promo', 11.00, 1, 1, '', '', '', ''),
(30, 'admin', 'Notifications', 0, 0, '', 'notifications', 12.00, 1, 1, '', '', '', ''),
(37, 'admin', 'Buyers', 0, 0, '', 'buyer', 13.00, 1, 1, '', '', '', ''),
(46, 'admin', 'SMS', 0, 0, '', 'sms', 15.00, 1, 1, '', '', '', ''),
(52, 'admin', 'Merchant Registration', 51, 0, 'reports/merchant_registration', 'reports.merchant_registration', 1.00, 1, 1, '', '', '', ''),
(53, 'admin', 'Membership Payment', 51, 0, 'reports/merchant_payment', 'reports.merchant_payment', 2.00, 1, 1, '', '', '', ''),
(54, 'admin', 'Merchant Sales', 51, 0, 'reports/merchant_sales', 'reports.merchant_sales', 3.00, 1, 1, '', '', '', ''),
(60, 'merchant', 'Dashboard', 0, 0, 'merchant/dashboard', 'merchant.dashboard', 1.00, 1, 1, '', '', '', ''),
(61, 'merchant', 'Merchant', 0, 0, '', 'merchant', 2.00, 1, 1, '', '', '', ''),
(64, 'merchant', 'Orders', 0, 0, '', 'merchant.orders', 3.00, 1, 1, '', '', '', ''),
(69, 'merchant', 'Settings', 67, 0, 'booking/settings', 'booking.settings', 2.00, 1, 1, '', '', '', ''),
(70, 'merchant', 'Attributes', 0, 0, '', 'attributes', 5.00, 1, 1, '', '', '', ''),
(75, 'merchant', 'Food', 0, 0, '', 'food', 6.00, 1, 1, '', '', '', ''),
(80, 'merchant', 'Order type', 0, 0, '', 'services.settings', 7.00, 1, 1, '', '', '', ''),
(82, 'merchant', 'Promo', 0, 0, '', 'promo', 9.00, 1, 1, '', '', '', ''),
(85, 'merchant', 'Images', 0, 0, '', 'merchant.images', 9.00, 1, 1, '', '', '', ''),
(87, 'merchant', 'Account', 0, 0, '', 'merchant.account', 10.00, 1, 1, '', '', '', ''),
(91, 'merchant', 'SMS', 0, 0, '', 'sms', 11.00, 1, 1, '', '', '', ''),
(94, 'merchant', 'Buyers', 0, 0, '', 'buyer', 12.00, 1, 1, '', '', '', ''),
(97, 'merchant', 'Users', 0, 0, '', 'merchan.user', 13.00, 1, 1, '', '', '', ''),
(100, 'merchant', 'Reports', 0, 0, '', 'reports', 14.00, 1, 1, '', '', '', ''),
(127, 'merchant', 'Inventory Management', 0, 0, '', 'inventory.management', 15.00, 1, 1, '', '', '', ''),
(132, 'merchant', 'Time Slot', 67, 0, 'booking/time_slot', 'booking.time_slot', 6.00, 1, 0, '', '', '', ''),
(133, 'merchant', 'Create Time Slot', 67, 0, 'booking/timeslot_create', 'booking.timeslot_create', 7.00, 1, 0, '', '', '', ''),
(134, 'merchant', 'Update Time Slot', 67, 0, 'booking/timeslot_update', 'booking.timeslot_update', 8.00, 1, 0, '', '', '', ''),
(135, 'merchant', 'Delete Time Slot', 67, 0, 'booking/delete_timeslot', 'booking.delete_timeslot', 8.00, 1, 0, '', '', '', ''),
(141, 'admin', 'Payment gateway', 0, 0, '', 'payment.gateway', 6.00, 1, 1, '', '', '', ''),
(143, 'merchant', 'Payment gateway', 0, 0, '', 'payment.gateway', 8.00, 1, 1, '', '', '', ''),
(152, 'admin', 'Account', 0, 0, '', 'admin.account', 7.00, 1, 1, '', '', '', ''),
(154, 'admin', 'Earnings', 0, 0, '', 'admin.earnings', 8.00, 1, 1, '', '', '', ''),
(156, 'admin', 'Withdrawals', 0, 0, '', 'admin.withdrawals', 9.00, 1, 1, '', '', '', ''),
(160, 'admin', 'Third Party App', 0, 0, '', 'admin.thirdparty', 14.00, 1, 1, '', '', '', ''),
(169, 'admin', 'Order earnings', 51, 0, 'reports/order_earnings', 'reports.order_earnings', 4.00, 1, 1, '', '', '', ''),
(171, 'merchant', 'POS', 0, 0, '', 'pos', 3.00, 1, 1, '', '', '', ''),
(174, 'admin', 'Refund Report', 51, 0, 'reports/refund', 'reports.refund', 5.00, 1, 1, '', '', '', ''),
(368, 'admin', 'Website', 0, 0, '', 'sales.channel', 19.00, 1, 1, '', '', '', ''),
(370, 'website', 'Company', 0, 0, '', '', 0.00, 1, 1, '', '', '', ''),
(373, 'website', 'Service', 0, 0, '', '', 0.00, 1, 1, '', '', '', ''),
(374, 'website', 'Find a store', 373, 0, 'https://demo.bastisapp.com/find-store', '', 0.00, 1, 1, '', '', '', ''),
(375, 'website', 'Services', 373, 0, 'https://demo.bastisapp.com/services', '', 1.00, 1, 1, '', '', '', ''),
(376, 'website', 'Contact Us', 373, 0, 'https://demo.bastisapp.com/contact-us', '', 2.00, 1, 1, '', '', '', ''),
(377, 'website', 'Categories', 0, 0, '', '', 0.00, 1, 1, '', '', '', ''),
(378, 'website', 'Grocery', 377, 0, 'https://demo.bastisapp.com', '', 0.00, 1, 1, '', '', '', ''),
(379, 'website', 'Parcel Delivery', 377, 0, 'https://demo.bastisapp.com', '', 0.00, 1, 1, '', '', '', ''),
(380, 'website', 'Fast Food', 377, 0, 'https://demo.bastisapp.com', '', 0.00, 1, 1, '', '', '', ''),
(385, 'admin', 'Addon manager', 0, 0, 'addon/manager', 'addon.manager', 21.00, 1, 1, '', '', '', ''),
(399, 'admin', 'Marketing', 0, 0, '', 'marketing', 12.00, 1, 1, '', '', '', ''),
(402, 'admin', 'Delivery Management', 0, 0, '', 'delivery.driver', 16.00, 1, 1, '', '', '', ''),
(415, 'admin', 'Mobile Merchant', 0, 0, '', 'mobile.merchant', 16.00, 1, 1, '', '', '', ''),
(417, 'merchant', 'Printers', 0, 0, '', 'printers', 14.00, 1, 1, '', '', '', ''),
(419, 'admin', 'Printers', 0, 0, '', 'printers', 18.00, 1, 1, '', '', '', ''),
(421, 'admin', 'Invoice', 0, 0, '', 'invoice', 9.00, 1, 1, '', '', '', ''),
(423, 'merchant', 'Invoice', 0, 0, '', 'invoice', 11.00, 1, 1, '', '', '', ''),
(428, 'merchant', 'Table Booking', 0, 0, '', 'table.booking', 3.00, 1, 1, '', '', '', ''),
(433, 'admin', 'Utilities', 0, 0, '', 'Utilities', 21.00, 1, 1, '', '', '', ''),
(436, 'admin', 'Table reservation', 0, 0, '', 'table.reservation', 9.00, 1, 1, '', '', '', ''),
(446, 'website_merchant', 'Menu1', 0, 3, '', '', 0.00, 1, 1, '', '', '', ''),
(447, 'website_merchant', 'Terms and conditions', 446, 3, '{{site_url}}/terms', '', 0.00, 1, 1, '', '', '', ''),
(448, 'website_merchant', 'Contact us', 446, 3, '{{site_url}}/contact-us', '', 1.00, 1, 1, '', '', '', ''),
(450, 'website_merchant', 'Menu 2', 0, 3, '', '', 0.00, 1, 1, '', '', '', ''),
(451, 'website_merchant', 'Terms and conditions', 450, 3, '{{site_url}}/terms', '', 3.00, 1, 1, '', '', '', ''),
(455, 'admin', 'Driver Earnings', 51, 0, 'reports/driver_earnings', 'reports.driver_earnings', 6.00, 1, 1, '', '', '', ''),
(456, 'admin', 'Driver wallet', 51, 0, 'reports/driver_wallet', 'reports.driver_wallet', 7.00, 1, 1, '', '', '', ''),
(460, 'admin', 'Loyalty Points', 0, 0, '', 'admin.loyalty', 16.00, 1, 1, '', '', '', ''),
(5681, 'admin', 'Reports', 0, 0, '', 'reports', 17.00, 1, 1, '', '', '', ''),
(17642, 'admin', 'Multi Currency', 0, 0, '', 'multi.currency', 16.10, 1, 1, '', '', '', ''),
(21495, 'merchant', 'Delivery Management', 0, 0, '', 'merchant.driver', 4.00, 1, 1, '', '', '', ''),
(34926, 'admin', 'Settings', 32855, 0, 'digitalwallet/settings', 'digitalwallet.settings', 1.00, 1, 1, '', '', '', ''),
(34927, 'admin', 'Bonus Funds', 32855, 0, 'digitalwallet/bonus_funds', 'digitalwallet.bonus_funds', 2.00, 1, 1, '', '', '', ''),
(34928, 'admin', 'Transactions', 32855, 0, 'digitalwallet/transactions', 'digitalwallet.transactions', 3.00, 1, 1, '', '', '', ''),
(35816, 'admin', 'Digital Wallet', 0, 0, '', 'admin.wallet', 16.10, 1, 1, '', '', '', ''),
(36414, 'admin', 'Communication', 0, 0, '', 'communication', 16.30, 1, 1, '', '', '', ''),
(38314, 'merchant', 'Communication', 0, 0, '', 'merchant.communication', 4.10, 1, 1, '', '', '', ''),
(41963, 'merchant', 'Settings', 91, 0, 'smsmerchant/sms_settings', 'smsmerchant.sms_settings', 1.00, 1, 1, '', '', '', ''),
(41964, 'merchant', 'BroadCast', 91, 0, 'smsmerchant/broadcast', 'smsmerchant.broadcast', 2.00, 1, 1, 'smsmerchant.smsbroadcast_create', 'smsmerchant.broadcast_details', 'smsmerchant.smsbroadcast_delete', ''),
(45554, 'merchant', 'Loyalty Points', 44942, 0, 'loyalty_points/settings', 'loyalty_points.settings', 1.00, 1, 1, '', '', '', ''),
(45860, 'merchant', 'Campaigns', 0, 0, '', 'merchant.campaigns', 4.00, 1, 1, '', '', '', ''),
(62705, 'admin', 'Tableside Ordering', 0, 0, '', 'tableside.ordering', 16.00, 1, 1, '', '', '', ''),
(64272, 'admin', 'Kitchen App', 0, 0, '', 'Kitchen.app', 16.10, 1, 1, '', '', '', ''),
(69516, 'admin', 'Media Library', 0, 0, 'media/library', 'media.library', 20.00, 1, 1, '', '', '', ''),
(73167, 'website', 'Terms and conditions', 370, 0, '{{site_url}}/terms-and-conditions', '', 2.00, 1, 1, '', '', '', ''),
(73169, 'website', 'About Us', 370, 0, '{{site_url}}/about-us', '', 3.00, 1, 1, '', '', '', ''),
(89268, 'website', 'Test with video', 370, 0, '{{site_url}}/test-with-video', '', 0.00, 1, 1, '', '', '', ''),
(89269, 'website', 'Privacy policy', 370, 0, '{{site_url}}/privacy-policy', '', 1.00, 1, 1, '', '', '', ''),
(89605, 'website_merchant', 'Terms and conditions', 450, 3, '{{site_url}}/terms', '', 0.00, 1, 1, '', '', '', ''),
(89606, 'website_merchant', 'Contact us', 450, 3, '{{site_url}}/contact-us', '', 1.00, 1, 1, '', '', '', ''),
(89607, 'website_merchant', 'Privacy Policy', 450, 3, '{{site_url}}/privacy-policy2', '', 2.00, 1, 1, '', '', '', ''),
(101093, 'admin', 'Map API Keys', 26, 0, 'admin/map_keys', 'admin.map_keys', 1.00, 1, 0, '', '', '', ''),
(101094, 'admin', 'Google Recaptcha', 26, 0, 'admin/recaptcha', 'admin.recaptcha', 2.00, 1, 0, '', '', '', ''),
(101095, 'admin', 'Search Mode', 26, 0, 'admin/search_settings', 'admin.search_settings', 3.00, 1, 0, '', '', '', ''),
(101096, 'admin', 'Delivery Fee Management', 26, 0, 'admin/delivery_management', 'admin.delivery_management', 3.10, 1, 0, '', '', 'admin.delete_location_rate', ''),
(101097, 'admin', 'Time Estimates Management', 26, 0, 'admin/estimate_management', 'admin.estimate_management', 3.20, 1, 0, '', '', 'admin.delete_estimate_time', ''),
(101098, 'admin', 'Fee Management', 26, 0, 'admin/fee_management', 'admin.fee_management', 3.30, 1, 0, '', '', '', ''),
(101099, 'admin', 'Login &amp; Signup', 26, 0, 'admin/login_sigup', 'admin.login_sigup', 4.00, 1, 0, '', '', '', ''),
(101100, 'admin', 'Custom Fields', 26, 0, 'admin/custom_fields', 'admin.custom_fields', 4.10, 1, 0, '', '', '', ''),
(101101, 'admin', 'Phone Settings', 26, 0, 'admin/phone_settings', 'admin.phone_settings', 5.00, 1, 0, '', '', '', ''),
(101102, 'admin', 'Social Settings', 26, 0, 'admin/social_settings', 'admin.social_settings', 6.00, 1, 0, '', '', '', ''),
(101103, 'admin', 'Printer Settings', 26, 0, 'admin/printing', 'admin.printing', 7.00, 1, 0, '', '', '', ''),
(101104, 'admin', 'Reviews', 26, 0, 'admin/reviews', 'admin.reviews', 8.00, 1, 0, '', '', '', ''),
(101105, 'admin', 'Timezone', 26, 0, 'admin/timezone', 'admin.timezone', 9.00, 1, 0, '', '', '', ''),
(101106, 'admin', 'Ordering', 26, 0, 'admin/ordering', 'admin.ordering', 10.00, 1, 0, '', '', '', ''),
(101107, 'admin', 'Automated Status Updates', 26, 0, 'admin/automatedstatus', 'admin.automatedstatus', 10.10, 1, 0, '', '', '', ''),
(101108, 'admin', 'Merchant Registration', 26, 0, 'admin/merchant_registration', 'admin.merchant_registration', 11.00, 1, 0, '', '', '', ''),
(101109, 'admin', 'Notifications', 26, 0, 'admin/notifications', 'admin.notifications', 12.00, 1, 0, '', '', '', ''),
(101110, 'admin', 'Contact Settings', 26, 0, 'admin/contact_settings', 'admin.contact_settings', 13.00, 1, 0, '', '', '', ''),
(101111, 'admin', 'Anaylytics', 26, 0, 'admin/analytics_settings', 'admin.analytics_settings', 14.00, 1, 0, '', '', '', ''),
(101112, 'admin', 'API Access', 26, 0, 'admin/api_access', 'admin.api_access', 15.00, 1, 0, '', '', '', ''),
(101113, 'admin', 'Mobile Page', 26, 0, 'admin/mobilepage', 'admin.mobilepage', 16.00, 1, 0, '', '', '', ''),
(101114, 'admin', 'Mobile Settings', 26, 0, 'admin/mobile_settings', 'admin.mobile_settings', 17.00, 1, 0, '', '', '', ''),
(101115, 'admin', 'Push Notifications', 26, 0, 'admin/push_notifications', 'admin.push_notifications', 18.00, 1, 0, '', '', '', ''),
(101116, 'admin', 'GDPR cookie consent', 26, 0, 'admin/cookie_consent', 'admin.cookie_consent', 19.00, 1, 0, '', '', '', ''),
(101117, 'admin', 'Cron Jobs', 26, 0, 'admin/cronjobs', 'admin.cronjobs', 19.10, 1, 0, '', '', '', ''),
(101118, 'admin', 'Others', 26, 0, 'admin/site_others', 'admin.site_others', 20.00, 1, 0, '', '', '', ''),
(101119, 'admin', 'Test Runactions', 26, 0, 'admin/test_runactions', 'admin.test_runactions', 21.00, 1, 0, '', '', '', ''),
(101120, 'admin', 'List', 2, 0, 'vendor/list', 'vendor.list', 1.00, 1, 1, 'vendor.create', 'vendor.edit', 'vendor.delete', ''),
(101121, 'admin', 'New signup', 2, 0, 'vendor/pending_list', 'vendor.pending_list', 1.10, 1, 1, 'vendor.approved', 'vendor.denied', 'vendor.delete', ''),
(101122, 'admin', 'Sponsored', 2, 0, 'vendor/sponsored', 'vendor.sponsored', 2.00, 1, 1, 'vendor.create_sponsored', 'vendor.edit_sponsored', 'vendor.delete_sponsored', ''),
(101123, 'admin', 'Merchant Upload Bulk', 2, 0, 'vendor/bulkupload', 'vendor.bulkupload', 2.10, 1, 0, '', '', '', ''),
(101124, 'admin', 'Merchant Autologin', 2, 0, 'vendor/autologin', 'vendor.autologin', 3.00, 1, 0, '', '', '', ''),
(101125, 'admin', 'Merchant Login information', 2, 0, 'vendor/login', 'vendor.login', 4.00, 1, 0, '', '', '', ''),
(101126, 'admin', 'Merchant Address', 2, 0, 'vendor/address', 'vendor.address', 5.00, 1, 0, '', '', '', ''),
(101127, 'admin', 'Merchant Zone', 2, 0, 'vendor/zone', 'vendor.zone', 6.00, 1, 0, '', '', '', ''),
(101128, 'admin', 'Merchant type', 2, 0, 'vendor/membership', 'vendor.membership', 7.00, 1, 0, '', '', '', ''),
(101129, 'admin', 'Merchant Featured', 2, 0, 'vendor/featured', 'vendor.featured', 8.00, 1, 0, '', '', '', ''),
(101130, 'admin', 'Merchant Payment History', 2, 0, 'vendor/payment_history', 'vendor.payment_history', 9.00, 1, 0, '', '', '', ''),
(101131, 'admin', 'Subscriptions', 2, 0, 'vendor/subscriptions', 'vendor.subscriptions', 9.10, 1, 0, '', '', '', ''),
(101132, 'admin', 'Merchant Payment Settings', 2, 0, 'vendor/payment_settings', 'vendor.payment_settings', 10.00, 1, 0, '', '', '', ''),
(101133, 'admin', 'Access Settings', 2, 0, 'vendor/access_settings', 'vendor.access_settings', 10.10, 1, 0, '', '', '', ''),
(101134, 'admin', 'Settings', 2, 0, 'vendor/others', 'vendor.others', 11.00, 1, 0, '', '', '', ''),
(101135, 'admin', 'API Access', 2, 0, 'vendor/api_access', 'vendor.api_access', 12.00, 1, 0, '', '', '', ''),
(101136, 'admin', 'Mobile Settings', 2, 0, 'vendor/mobile_settings', 'vendor.mobile_settings', 12.10, 1, 0, '', '', '', ''),
(101137, 'admin', 'Search Mode', 2, 0, 'vendor/search_mode', 'vendor.search_mode', 13.00, 1, 0, '', '', '', ''),
(101138, 'admin', 'Login &amp; Signup', 2, 0, 'vendor/login_sigup', 'vendor.login_sigup', 14.00, 1, 0, '', '', '', ''),
(101139, 'admin', 'Phone Settings', 2, 0, 'vendor/phone_settings', 'vendor.phone_settings', 15.00, 1, 0, '', '', '', ''),
(101140, 'admin', 'Social Settings', 2, 0, 'vendor/social_settings', 'vendor.social_settings', 16.00, 1, 0, '', '', '', ''),
(101141, 'admin', 'Google Recaptcha', 2, 0, 'vendor/recaptcha_settings', 'vendor.recaptcha_settings', 17.00, 1, 0, '', '', '', ''),
(101142, 'admin', 'Map API Keys', 2, 0, 'vendor/map_keys', 'vendor.map_keys', 18.00, 1, 0, '', '', '', ''),
(101143, 'admin', 'Plan List', 16, 0, 'plans/list', 'plans.list', 1.00, 1, 1, 'plans.create', 'plans.update', 'plans.plan_delete', ''),
(101144, 'admin', 'Subscriber List', 16, 0, 'plans/subscriber_list', 'plans.subscriber_list', 1.10, 1, 1, '', '', '', ''),
(101145, 'admin', 'Subscriptions Bank Deposit', 16, 0, 'plans/bank_deposit', 'plans.bank_deposit', 1.20, 1, 1, '', 'plans.bank_deposit_view', 'plans.bank_deposit_delete', ''),
(101146, 'admin', 'Plan Features', 16, 0, 'plans/features', 'plans.features', 2.00, 1, 0, 'plans.feature_create', 'plans.feature_update', 'plans.feature_delete', ''),
(101147, 'admin', 'Plans Payment ID', 16, 0, 'plans/payment_list', 'plans.payment_list', 18.00, 1, 0, '', '', '', ''),
(101148, 'admin', 'All Orders', 6, 0, 'order/list', 'order.list', 1.00, 1, 1, '', '', '', 'order.view'),
(101149, 'admin', 'Order Settings', 6, 0, 'order/settings', 'order.settings', 2.00, 1, 1, '', '', '', ''),
(101150, 'admin', 'View PDF', 6, 0, 'preprint/pdf', 'preprint.pdf', 3.00, 1, 0, '', '', '', ''),
(101151, 'admin', 'Order Tabs', 6, 0, 'order/settings_tabs', 'order.settings_tabs', 3.00, 1, 0, '', '', '', ''),
(101152, 'admin', 'Order Buttons', 6, 0, 'order/settings_buttons', 'order.settings_buttons', 4.00, 1, 0, '', '', '', ''),
(101153, 'admin', 'Order Tracking', 6, 0, 'order/settings_tracking', 'order.settings_tracking', 5.00, 1, 0, '', '', '', ''),
(101154, 'admin', 'Order Template', 6, 0, 'order/settings_template', 'order.settings_template', 6.00, 1, 0, '', '', '', ''),
(101155, 'admin', 'All Payment', 141, 0, 'payment_gateway/list', 'payment_gateway.list', 1.00, 1, 1, 'payment_gateway.create', 'payment_gateway.update', 'payment_gateway.delete', ''),
(101156, 'admin', 'Bank Deposit', 141, 0, 'payment_gateway/bank_deposit', 'payment_gateway.bank_deposit', 2.00, 1, 1, '', '', 'payment_gateway.bank_deposit_delete', 'payment_gateway.bank_deposit_view'),
(101157, 'admin', 'Pay on delivery', 141, 0, 'payment_gateway/paydelivery_list', 'payment_gateway.paydelivery_list', 3.00, 1, 1, 'payment_gateway.paydelivery_create', 'payment_gateway.paydelivery_update', 'payment_gateway.paydelivery_delete', ''),
(101158, 'admin', 'Transactions', 152, 0, 'account/transactions', 'account.transactions', 1.00, 1, 1, 'api.commissionadjustment', '', '', ''),
(101159, 'admin', 'Merchant Earnings', 154, 0, 'earnings/merchant', 'earnings.merchant', 1.00, 1, 1, 'api.merchantEarningAdjustment', '', '', ''),
(101160, 'admin', 'Merchant withdrawals', 156, 0, 'withdrawals/merchant', 'withdrawals.merchant', 1.00, 1, 1, '', '', '', ''),
(101161, 'admin', 'Settings', 156, 0, 'withdrawals/settings', 'withdrawals.settings', 2.00, 1, 1, '', '', '', ''),
(101162, 'admin', 'Template', 156, 0, 'withdrawals/settings_template', 'withdrawals.settings_template', 3.00, 1, 0, '', '', '', ''),
(101163, 'admin', 'Invoice List', 421, 0, 'invoice/list', 'invoice.list', 1.00, 1, 1, 'invoice.create', 'invoice.update', 'invoice.delete', 'invoice.view'),
(101164, 'admin', 'Invoice View PDF', 421, 0, 'invoice/pdf', 'invoice.pdf', 2.00, 1, 0, '', '', '', ''),
(101165, 'admin', 'Invoice Cancel', 421, 0, 'invoice/cancel', 'invoice.cancel', 2.10, 1, 0, '', '', '', ''),
(101166, 'admin', 'Bank Deposit', 421, 0, 'invoice/deposit', 'invoice.deposit', 3.00, 1, 1, '', '', 'invoice.bank_deposit_delete', 'invoice.bank_deposit_view'),
(101167, 'admin', 'Invoice Settings', 421, 0, 'invoice/settings', 'invoice.settings', 4.00, 1, 1, '', '', '', ''),
(101168, 'admin', 'Setting', 436, 0, 'reservation/settings', 'reservation.settings', 1.00, 1, 1, '', '', '', ''),
(101169, 'admin', 'Reservation list', 436, 0, 'reservation/list', 'reservation.list', 2.00, 1, 1, 'reservation.create_reservation', 'reservation.update_reservation', 'reservation.reservation_delete', 'reservation.reservation_overview'),
(101170, 'admin', 'Update Booking Status', 436, 0, 'reservation/update_status', 'reservation.update_status', 3.00, 1, 0, '', '', '', ''),
(101171, 'admin', 'Promo List', 28, 0, 'promo/coupon', 'promo.coupon', 1.00, 1, 1, 'promo.coupon_create', 'promo.coupon_update', 'promo.coupon_delete', ''),
(101172, 'admin', 'Email Provider', 30, 0, 'notifications/provider', 'notifications.provider', 1.00, 1, 1, 'notifications.provider_create', 'notifications.provider_update', 'notifications.email_provider_delete', ''),
(101173, 'admin', 'Template List', 30, 0, 'notifications/template', 'notifications.template', 2.00, 1, 1, 'notifications.template_create', 'notifications.template_update', 'notifications.template_delete', ''),
(101174, 'admin', 'Email Logs', 30, 0, 'notifications/email_logs', 'notifications.email_logs', 2.00, 1, 1, '', '', 'notifications.delete_email', ''),
(101175, 'admin', 'Email Clear', 30, 0, 'notifications/clear_email', 'notifications.clear_email', 2.00, 1, 0, '', '', '', ''),
(101176, 'admin', 'Banner List', 399, 0, 'marketing/banner_list', 'marketing.banner_list', 1.00, 1, 1, 'marketing.banner_create', 'marketing.banner_update', 'marketing.banner_delete', ''),
(101177, 'admin', 'Featured Items', 399, 0, 'marketing/featured_items', 'marketing.featured_items', 1.10, 1, 1, '', '', '', ''),
(101178, 'admin', 'Suggested Items', 399, 0, 'marketing/suggested_items', 'marketing.suggested_items', 1.20, 1, 1, '', '', '', ''),
(101179, 'admin', 'Push notification', 399, 0, 'marketing/notification', 'marketing.notification', 2.00, 1, 1, 'marketing.push_new', '', 'marketing.notification_delete', ''),
(101180, 'admin', 'Customer list', 37, 0, 'buyer/customers', 'buyer.customers', 1.00, 1, 1, 'buyer.customer_create', 'buyer.customer_update', 'buyer.customer_delete', ''),
(101181, 'admin', 'Customer Address', 37, 0, 'buyer/address', 'buyer.address', 1.00, 1, 0, 'buyer.address_create', 'buyer.address_update', 'buyer.address_delete', ''),
(101182, 'admin', 'Order History', 37, 0, 'buyer/order_history', 'buyer.order_history', 2.00, 1, 0, '', '', '', ''),
(101183, 'admin', 'Review List', 37, 0, 'buyer/review_list', 'buyer.review_list', 3.00, 1, 1, '', 'buyer.review_update', 'buyer.review_delete', ''),
(101184, 'admin', 'Email Subscribers', 37, 0, 'buyer/email_subscriber', 'buyer.email_subscriber', 4.00, 1, 1, '', '', 'buyer.esubscriber_delete', ''),
(101185, 'admin', 'Real time application', 160, 0, 'thirdparty/realtime', 'thirdparty.realtime', 1.00, 1, 1, '', '', '', ''),
(101186, 'admin', 'Web push notification', 160, 0, 'thirdparty/webpush', 'thirdparty.webpush', 2.00, 1, 1, '', '', '', ''),
(101187, 'admin', 'Firebase Configuration', 160, 0, 'thirdparty/firebase', 'thirdparty.firebase', 3.00, 1, 1, '', '', '', ''),
(101188, 'admin', 'Whatsapp Configuration', 160, 0, 'thirdparty/whatsapp_settings', 'thirdparty.whatsapp_settings', 3.00, 1, 1, '', '', '', ''),
(101189, 'admin', 'SMS Provider List', 46, 0, 'sms/settings', 'sms.settings', 1.00, 1, 1, 'sms.provider_create', 'sms.provider_update', 'sms.provider_delete', ''),
(101190, 'admin', 'SMS Logs', 46, 0, 'sms/logs', 'sms.logs', 2.00, 1, 1, '', '', 'sms.delete', ''),
(101191, 'admin', 'SMS Clear', 46, 0, 'sms/clear_smslogs', 'sms.clear_smslogs', 3.00, 1, 0, '', '', '', ''),
(101192, 'admin', 'Settings', 402, 0, 'driver/settings', 'driver.settings', 1.00, 1, 1, '', '', '', ''),
(101193, 'admin', 'API Access', 402, 0, 'driver/api_access', 'driver.api_access', 1.10, 1, 0, '', '', '', ''),
(101194, 'admin', 'Delete API Keys', 402, 0, 'driver/delete_apikeys', 'driver.delete_apikeys', 1.20, 1, 0, '', '', '', ''),
(101195, 'admin', 'Push notifications', 402, 0, 'driver/push_notifications', 'driver.push_notifications', 2.00, 1, 0, '', '', '', ''),
(101196, 'admin', 'Firebase Settings', 402, 0, 'driver/firebase_settings', 'driver.firebase_settings', 3.00, 1, 0, '', '', '', ''),
(101197, 'admin', 'Signup Settings', 402, 0, 'driver/signup_settings', 'driver.signup_settings', 4.00, 1, 0, '', '', '', ''),
(101198, 'admin', 'Cashout settings', 402, 0, 'driver/withdrawal_settings', 'driver.withdrawal_settings', 5.00, 1, 0, '', '', '', ''),
(101199, 'admin', 'Order Status', 402, 0, 'driver/order_status', 'driver.order_status', 6.00, 1, 0, '', '', '', ''),
(101200, 'admin', 'Order Tabs', 402, 0, 'driver/settings_tabs', 'driver.settings_tabs', 7.00, 1, 0, '', '', '', ''),
(101201, 'admin', 'Pages', 402, 0, 'driver/settings_page', 'driver.settings_page', 8.00, 1, 0, '', '', '', ''),
(101202, 'admin', 'Cron jobs', 402, 0, 'driver/cronjobs', 'driver.cronjobs', 9.00, 1, 0, '', '', '', ''),
(101203, 'admin', 'Cashout list', 402, 0, 'driver/cashout_list', 'driver.cashout_list', 10.00, 1, 1, '', '', '', ''),
(101204, 'admin', 'Collect cash', 402, 0, 'driver/collect_cash', 'driver.collect_cash', 11.00, 1, 1, 'driver.collect_cash_add', 'driver.collect_transactions', 'driver.collect_cash_void', ''),
(101205, 'admin', 'Driver list', 402, 0, 'driver/list', 'driver.list', 12.00, 1, 1, 'driver.add', 'driver.update', 'driver.delete', 'driver.overview'),
(101206, 'admin', 'License', 402, 0, 'driver/license', 'driver.license', 12.10, 1, 0, '', '', '', ''),
(101207, 'admin', 'Vehicle', 402, 0, 'driver/vehicle', 'driver.vehicle', 12.20, 1, 0, '', '', '', ''),
(101208, 'admin', 'Bank Information', 402, 0, 'driver/bank_info', 'driver.bank_info', 12.30, 1, 0, '', '', '', ''),
(101209, 'admin', 'Wallet', 402, 0, 'driver/wallet', 'driver.wallet', 12.40, 1, 0, '', '', '', ''),
(101210, 'admin', 'Cashout Transactions', 402, 0, 'driver/cashout_transactions', 'driver.cashout_transactions', 12.40, 1, 0, '', '', '', ''),
(101211, 'admin', 'Delivery transactions', 402, 0, 'driver/delivery_transactions', 'driver.delivery_transactions', 12.50, 1, 0, '', '', '', ''),
(101212, 'admin', 'Order tips', 402, 0, 'driver/order_tips', 'driver.order_tips', 12.60, 1, 0, '', '', '', ''),
(101213, 'admin', 'Time logs', 402, 0, 'driver/time_logs', 'driver.time_logs', 12.70, 1, 0, '', '', '', ''),
(101214, 'admin', 'Reviews', 402, 0, 'driver/review_ratings', 'driver.review_ratings', 12.80, 1, 0, '', '', '', ''),
(101215, 'admin', 'Car registration', 402, 0, 'driver/carlist', 'driver.carlist', 13.00, 1, 1, 'driver.addcar', 'driver.update_car', 'driver.car_delete', ''),
(101216, 'admin', 'Groups', 402, 0, 'driver/group', 'driver.group', 14.00, 1, 1, 'driver.addgroup', 'driver.group_update', '.group_delete', ''),
(101217, 'admin', 'Employee Schedule', 402, 0, 'driver/schedule', 'driver.schedule', 15.00, 1, 1, 'schedule.add', 'schedule.update', 'schedule.delete', 'driver.schedule_bulk'),
(101218, 'admin', 'Shifts Schedule', 402, 0, 'driver/shift_list', 'driver.shift_list', 16.00, 1, 1, 'driver.addshift', 'driver.shift_update', 'driver.shift_delete', 'driver.shift_bulkupload'),
(101219, 'admin', 'Reviews', 402, 0, 'driver/review_list', 'driver.review_list', 17.00, 1, 1, '', 'driver.review_update', 'driver.review_delete', ''),
(101220, 'admin', 'Map View', 402, 0, 'driver/mapview', 'driver.mapview', 18.00, 1, 1, '', '', '', ''),
(101221, 'admin', 'Settings', 415, 0, 'mobilemerchant/api_access', 'mobilemerchant.api_access', 1.00, 1, 1, '', '', '', ''),
(101222, 'admin', 'Delete API Keys', 415, 0, 'mobilemerchant/delete_apikeys', 'mobilemerchant.delete_apikeys', 2.00, 1, 0, '', '', '', ''),
(101223, 'admin', 'Settings', 415, 0, 'mobilemerchant/settings', 'mobilemerchant.settings', 3.00, 1, 0, '', '', '', ''),
(101224, 'admin', 'Push Notifications', 415, 0, 'mobilemerchant/push_notifications', 'mobilemerchant.push_notifications', 4.00, 1, 0, '', '', '', ''),
(101225, 'admin', 'Pages', 415, 0, 'mobilemerchant/settings_page', 'mobilemerchant.settings_page', 5.00, 1, 0, '', '', '', ''),
(101226, 'admin', 'Settings', 62705, 0, 'tableside/api_access', 'tableside.api_access', 1.00, 1, 1, '', '', '', ''),
(101227, 'admin', 'Settings', 64272, 0, 'kitchen/settings', 'kitchen.settings', 1.00, 1, 1, '', '', '', ''),
(101228, 'admin', 'API Access', 64272, 0, 'kitchen/api_access', 'kitchen.api_access', 2.00, 1, 0, '', '', '', ''),
(101229, 'admin', 'Settings', 460, 0, 'points/settings', 'points.settings', 1.00, 1, 1, '', '', '', ''),
(101230, 'admin', 'Redeem thresholds', 460, 0, 'points/thresholds', 'points.thresholds', 2.00, 1, 1, '', '', '', ''),
(101231, 'admin', 'Monthly thresholds', 460, 0, 'points/monthly_thresholds', 'points.monthly_thresholds', 2.10, 1, 1, '', '', '', ''),
(101232, 'admin', 'User Reward Points', 460, 0, 'points/rewards', 'points.rewards', 3.00, 1, 1, '', '', '', ''),
(101233, 'admin', 'Transactions', 460, 0, 'points/alltransactions', 'points.alltransactions', 4.00, 1, 1, '', '', '', ''),
(101234, 'admin', 'Settings', 35816, 0, 'digitalwallet/settings', 'digitalwallet.settings', 1.00, 1, 1, '', '', '', ''),
(101235, 'admin', 'Bonus Funds', 35816, 0, 'digitalwallet/bonus_funds', 'digitalwallet.bonus_funds', 2.00, 1, 1, '', '', '', ''),
(101236, 'admin', 'Transactions', 35816, 0, 'digitalwallet/transactions', 'digitalwallet.transactions', 3.00, 1, 1, '', '', '', ''),
(101237, 'admin', 'Settings', 17642, 0, 'multicurrency/settings', 'multicurrency.settings', 1.00, 1, 1, '', '', '', ''),
(101238, 'admin', 'Exchange Rates', 17642, 0, 'multicurrency/exchangerate', 'multicurrency.exchangerate', 1.00, 1, 1, '', '', '', ''),
(101239, 'admin', 'Chats', 36414, 0, 'communication/chats', 'communication.chats', 1.00, 1, 1, '', '', '', ''),
(101240, 'admin', 'Settings', 36414, 0, 'communication/settings', 'communication.settings', 2.00, 1, 1, '', '', '', ''),
(101241, 'admin', 'Merchant Registration', 5681, 0, 'reports/merchant_registration', 'reports.merchant_registration', 1.00, 1, 1, '', '', '', ''),
(101242, 'admin', 'Membership Payment', 5681, 0, 'reports/merchant_payment', 'reports.merchant_payment', 2.00, 1, 1, '', '', '', ''),
(101243, 'admin', 'Merchant Sales', 5681, 0, 'reports/merchant_sales', 'reports.merchant_sales', 3.00, 1, 1, '', '', '', ''),
(101244, 'admin', 'Order earnings', 5681, 0, 'reports/order_earnings', 'reports.order_earnings', 4.00, 1, 1, '', '', '', ''),
(101245, 'admin', 'Refund Report', 5681, 0, 'reports/refund', 'reports.refund', 5.00, 1, 1, '', '', '', ''),
(101246, 'admin', 'Driver Earnings', 5681, 0, 'reports/driver_earnings', 'reports.driver_earnings', 6.00, 1, 1, '', '', '', ''),
(101247, 'admin', 'Driver wallet', 5681, 0, 'reports/driver_wallet', 'reports.driver_wallet', 7.00, 1, 1, '', '', '', ''),
(101248, 'admin', 'All User', 5, 0, 'user/list', 'user.list', 1.00, 1, 1, 'user.create', 'user.update', 'user.delete', ''),
(101249, 'admin', 'Change Password', 5, 0, 'user/change_password', 'user.change_password', 2.00, 1, 0, '', '', '', ''),
(101250, 'admin', 'All Roles', 5, 0, 'user/roles_list', 'user.roles_list', 3.00, 1, 1, 'user.role_create', 'user.role_update', 'user.role_delete', ''),
(101251, 'admin', 'Printer List', 419, 0, 'printer/all', 'printer.all', 1.00, 1, 1, 'printer.create', 'printer.update', 'printer.delete', ''),
(101252, 'admin', 'Print Logs', 419, 0, 'printer/logs', 'printer.logs', 2.00, 1, 1, '', '', 'printer.print_delete', 'printer.print_view'),
(101253, 'admin', 'Clear Print Logs', 419, 0, 'printer/clear_printlogs', 'printer.clear_printlogs', 3.00, 1, 0, '', '', '', ''),
(101254, 'admin', 'Theme', 368, 0, 'theme/changer', 'theme.changer', 1.00, 1, 1, '', '', '', ''),
(101255, 'admin', 'SEO Setup', 368, 0, 'website/seosetup', 'website.seosetup', 1.10, 1, 1, '', '', '', ''),
(101256, 'admin', 'XML Sitemap', 368, 0, 'website/sitemap', 'website.sitemap', 1.20, 1, 1, '', '', '', ''),
(101257, 'admin', 'Theme Settings', 368, 0, 'theme/settings', 'theme.settings', 2.00, 1, 0, '', '', '', ''),
(101258, 'admin', 'Menu', 368, 0, 'theme/menu', 'theme.menu', 3.00, 1, 0, '', '', '', ''),
(101259, 'admin', 'Theme Layout', 368, 0, 'theme/layout', 'theme.layout', 4.00, 1, 0, '', '', '', ''),
(101260, 'admin', 'Upload File', 69516, 0, 'uploadfiles/file', 'uploadfiles.file', 1.00, 1, 1, '', 'uploadfiles.getMediaSeleted', 'uploadfiles.deleteFiles', 'uploadfiles.getMedia'),
(101261, 'admin', 'Addon Install', 385, 0, 'addon/install', 'addon.install', 1.00, 1, 0, '', '', '', ''),
(101262, 'admin', 'Fixed database', 433, 0, 'utilities/fixed_database', 'utilities.fixed_database', 1.00, 1, 1, '', '', '', ''),
(101263, 'admin', 'Clean database', 433, 0, 'utilities/clean_database', 'utilities.clean_database', 2.00, 1, 1, '', '', '', ''),
(101264, 'admin', 'Cron Jobs', 433, 0, 'utilities/cronjobs', 'utilities.cronjobs', 3.00, 1, 1, '', '', '', ''),
(101265, 'admin', 'Migration Tools', 433, 0, 'utilities/migration_tools', 'utilities.migration_tools', 4.00, 1, 1, '', '', '', ''),
(101266, 'admin', 'Clear Cache', 433, 0, 'utilities/clear_cache', 'utilities.clear_cache', 5.00, 1, 1, '', '', '', ''),
(101267, 'admin', 'Cuisine', 20, 0, 'attributes/cuisine_list', 'attributes.cuisine_list', 1.00, 1, 1, 'attributes.cuisine_create', 'attributes.cuisine_update', 'attributes.cuisine_delete', 'attributes.cuisine_sort'),
(101268, 'admin', 'Dishes', 20, 0, 'attributes/dish_list', 'attributes.dish_list', 2.00, 1, 1, 'attributes.dish_create', 'attributes.dish_update', 'attributes.dishes_delete', ''),
(101269, 'admin', 'Allergens', 20, 0, 'attributes/allergens_list', 'attributes.allergens_list', 2.10, 1, 1, 'attributes.allergens_create', 'attributes.allergens_update', 'attributes.allergens_delete', ''),
(101270, 'admin', 'Tags', 20, 0, 'attributes/tag_list', 'attributes.tag_list', 3.00, 1, 1, 'attributes.tags_create', 'attributes.tags_update', 'attributes.tags_delete', ''),
(101271, 'admin', 'Order Status', 20, 0, 'attributes/order_status', 'attributes.order_status', 3.10, 1, 1, 'attributes.status_create', 'attributes.status_update', 'attributes.status_delete', ''),
(101272, 'admin', 'Order Status Actions', 20, 0, 'attributes/status_actions', 'attributes.status_actions', 3.20, 1, 0, 'attributes.create_action', 'attributes.update_action', 'attributes.status_action_delete', ''),
(101273, 'admin', 'Currency', 20, 0, 'attributes/currency', 'attributes.currency', 4.00, 1, 1, 'attributes.currency_create', 'attributes.currency_update', 'attributes.currency_delete', ''),
(101274, 'admin', 'Manage Location', 20, 0, 'location/country_list', 'location.country_list', 5.00, 1, 1, 'location.country_create', 'location.country_update', 'location.delete_country', ''),
(101275, 'admin', 'State List', 20, 0, 'location/state_list', 'location.state_list', 6.00, 1, 0, 'location.state_create', 'location.state_update', 'location.state_delete', ''),
(101276, 'admin', 'City List', 20, 0, 'location/city_list', 'location.city_list', 7.00, 1, 0, 'location.city_create', 'location.city_update', 'location.city_delete', ''),
(101277, 'admin', 'Area List', 20, 0, 'location/area_list', 'location.area_list', 8.00, 1, 0, 'location.area_create', 'location.area_update', 'location.area_delete', ''),
(101278, 'admin', 'Zones', 20, 0, 'attributes/zone_list', 'attributes.zone_list', 9.00, 1, 1, 'attributes.zone_create', 'attributes.zone_update', 'attributes.zone_delete', ''),
(101279, 'admin', 'Featured Locations', 20, 0, 'attributes/featured_loc', 'attributes.featured_loc', 10.00, 1, 1, 'attributes.featured_loc_create', 'attributes.featured_loc_update', 'attributes.featured_loc_delete', ''),
(101280, 'admin', 'Pages', 20, 0, 'attributes/pages_list', 'attributes.pages_list', 10.00, 1, 1, 'attributes.pages_create', 'attributes.page_update', 'attributes.pages_delete', ''),
(101281, 'admin', 'Languages', 20, 0, 'attributes/language_list', 'attributes.language_list', 11.00, 1, 1, 'attributes.language_create', 'attributes.language_update', 'attributes.language_delete', ''),
(101282, 'admin', 'Language Settings', 20, 0, 'attributes/language_settings', 'attributes.language_settings', 12.00, 1, 0, '', '', '', ''),
(101283, 'admin', 'Language Import', 20, 0, 'attributes/language_import', 'attributes.language_import', 13.00, 1, 0, '', '', '', ''),
(101284, 'admin', 'Language Translations', 20, 0, 'attributes/language_translation', 'attributes.language_translation', 14.00, 1, 0, '', '', '', ''),
(101285, 'admin', 'Language Export', 20, 0, 'attributes/language_export', 'attributes.language_export', 15.00, 1, 0, '', '', '', ''),
(101286, 'admin', 'Status Management', 20, 0, 'attributes/status_mgt', 'attributes.status_mgt', 16.00, 1, 1, 'attributes.status_mgt_create', 'attributes.status_mgt_update', 'attributes.status_mgt_delete', ''),
(101287, 'admin', 'Order Type', 20, 0, 'attributes/services_list', 'attributes.services_list', 17.00, 1, 1, 'attributes.services_create', 'attributes.services_update', 'attributes.services_delete', ''),
(101288, 'admin', 'Merchant Type', 20, 0, 'attributes/merchant_type_list', 'attributes.merchant_type_list', 18.00, 1, 1, 'attributes.merchant_type_create', 'attributes.merchant_type_update', 'attributes.merchant_type_delete', ''),
(101289, 'admin', 'Rejection List', 20, 0, 'attributes/rejection_list', 'attributes.rejection_list', 19.00, 1, 1, 'attributes.rejection_create', 'attributes.rejection_update', 'attributes.rejection_reason_delete', ''),
(101290, 'admin', 'Pause Order list', 20, 0, 'attributes/pause_reason_list', 'attributes.pause_reason_list', 19.00, 1, 1, 'attributes.pause_create', 'attributes.pause_reason_update', 'attributes.pause_reason_delete', ''),
(101291, 'admin', 'Status Actions', 20, 0, 'attributes/actions_list', 'attributes.actions_list', 20.00, 1, 1, 'attributes.action_create', 'attributes.action_update', 'attributes.action_delete', ''),
(101292, 'admin', 'Tip List', 20, 0, 'attributes/tip_list', 'attributes.tip_list', 21.00, 1, 1, 'attributes.tips_create', 'attributes.tips_update', 'attributes.tips_delete', ''),
(101293, 'admin', 'Booking Cancellation', 20, 0, 'attributes/booking_cancel_list', 'attributes.booking_cancel_list', 22.00, 1, 1, 'attributes.booking_cancellation_create', 'attributes.booking_cancellation_update', 'attributes.booking_cancellation_delete', ''),
(101294, 'admin', 'Cookie Preferences', 20, 0, 'attributes/cookie_preferences', 'attributes.cookie_preferences', 23.00, 1, 1, 'attributes.cookie_preferences_create', 'attributes.cookie_preferences_update', 'attributes.cookie_preferences_delete', ''),
(101295, 'admin', 'Vehicle maker', 20, 0, 'attributes/vehicle', 'attributes.vehicle', 24.00, 1, 1, 'attributes.vehicle_maker_create', 'attributes.vehicle_maker_update', 'attributes.vehicle_maker_delete', ''),
(101296, 'admin', 'Delivery Order Help', 20, 0, 'attributes/delivery_order_help', 'attributes.delivery_order_help', 25.00, 1, 1, 'attributes.delivery_order_help_create', 'attributes.delivery_order_help_update', 'attributes.delivery_order_help_delete', ''),
(101297, 'admin', 'Delivery Decline Reason', 20, 0, 'attributes/delivery_decline_reason', 'attributes.delivery_decline_reason', 26.00, 1, 1, 'attributes.delivery_decline_reason_create', 'attributes.delivery_decline_reason_update', 'attributes.delivery_decline_reason_delete', ''),
(101298, 'admin', 'Call Staff Menu', 20, 0, 'attributes/call_staff_menu', 'attributes.call_staff_menu', 27.00, 1, 1, 'attributes.call_staff_menu_create', 'attributes.call_staff_menu_update', 'attributes.call_staff_menu_delete', ''),
(101299, 'merchant', 'Order Summary', 60, 0, 'merchant/dashboard/order_summary', 'merchant.dashboard.order_summary', 1.00, 1, 0, '', '', '', ''),
(101300, 'merchant', 'Week Sales', 60, 0, 'merchant/dashboard/week_sales', 'merchant.dashboard.week_sales', 2.00, 1, 0, '', '', '', ''),
(101301, 'merchant', 'Daily statistic', 60, 0, 'merchant/dashboard/today_summary', 'merchant.dashboard.today_summary', 2.00, 1, 0, '', '', '', ''),
(101302, 'merchant', 'Last 5 Orders', 60, 0, 'merchant/dashboard/last_5_orders', 'merchant.dashboard.last_5_orders', 3.00, 1, 0, '', '', '', ''),
(101303, 'merchant', 'Popular items', 60, 0, 'merchant/dashboard/popular_items', 'merchant.dashboard.popular_items', 3.00, 1, 0, '', '', '', ''),
(101304, 'merchant', 'Sales overview', 60, 0, 'merchant/dashboard/sales_overview', 'merchant.dashboard.sales_overview', 4.00, 1, 0, '', '', '', ''),
(101305, 'merchant', 'Top Customers', 60, 0, 'merchant/dashboard/top_customer', 'merchant.dashboard.top_customer', 5.00, 1, 0, '', '', '', ''),
(101306, 'merchant', 'Overview of Review', 60, 0, 'merchant/dashboard/review_overview', 'merchant.dashboard.review_overview', 6.00, 1, 0, '', '', '', ''),
(101307, 'merchant', 'Merchant Information', 61, 0, 'merchant/edit', 'merchant.edit', 1.00, 1, 1, '', '', '', ''),
(101308, 'merchant', 'Login information', 61, 0, 'merchant/login', 'merchant.login', 2.00, 1, 0, '', '', '', ''),
(101309, 'merchant', 'Address', 61, 0, 'merchant/address', 'merchant.address', 3.00, 1, 0, '', '', '', ''),
(101310, 'merchant', 'Payment history', 61, 0, 'merchant/payment_history', 'merchant.payment_history', 3.10, 1, 0, '', '', '', ''),
(101311, 'merchant', 'Settings', 61, 0, 'merchant/settings', 'merchant.settings', 4.00, 1, 1, '', '', '', ''),
(101312, 'merchant', 'Time Zone', 61, 0, 'merchant/timezone', 'merchant.timezone', 4.10, 1, 0, '', '', '', ''),
(101313, 'merchant', 'Store Hours', 61, 0, 'merchant/store_hours', 'merchant.store_hours', 5.00, 1, 0, 'merchant.store_hours_create', 'merchant.store_hours_update', 'merchant.store_hours_delete', ''),
(101314, 'merchant', 'Taxes', 61, 0, 'merchant/taxes', 'merchant.taxes', 6.00, 1, 0, '', '', '', ''),
(101315, 'merchant', 'SEO', 61, 0, 'merchant/seo', 'merchant.seo', 6.10, 1, 0, '', '', '', ''),
(101316, 'merchant', 'Kitchen Workload', 61, 0, 'merchant/kitchen_settings', 'merchant.kitchen_settings', 6.11, 1, 0, '', '', '', ''),
(101317, 'merchant', 'Location Management', 61, 0, 'merchant/location_management', 'merchant.location_management', 6.20, 1, 0, '', '', '', ''),
(101318, 'merchant', 'Delivery Management', 61, 0, 'merchant/delivery_management', 'merchant.delivery_management', 6.30, 1, 0, '', '', '', ''),
(101319, 'merchant', 'Time Estimates Management', 61, 0, 'merchant/estimate_management', 'merchant.estimate_management', 6.40, 1, 0, '', '', '', ''),
(101320, 'merchant', 'Zone', 61, 0, 'merchant/zone_settings', 'merchant.zone_settings', 6.20, 1, 0, '', '', '', ''),
(101321, 'merchant', 'Search Mode', 61, 0, 'merchant/search_settings', 'merchant.search_settings', 7.00, 1, 0, '', '', '', ''),
(101322, 'merchant', 'Login &amp; Signup', 61, 0, 'merchant/login_sigup', 'merchant.login_sigup', 8.00, 1, 0, '', '', '', ''),
(101323, 'merchant', 'Phone Settings', 61, 0, 'merchant/phone_settings', 'merchant.phone_settings', 9.00, 1, 0, '', '', '', ''),
(101324, 'merchant', 'Social Settings', 61, 0, 'merchant/social_settings', 'merchant.social_settings', 10.00, 1, 0, '', '', '', ''),
(101325, 'merchant', 'Google Recaptcha', 61, 0, 'merchant/recaptcha_settings', 'merchant.recaptcha_settings', 11.00, 1, 0, '', '', '', ''),
(101326, 'merchant', 'Map API Keys', 61, 0, 'merchant/map_keys', 'merchant.map_keys', 12.00, 1, 0, '', '', '', ''),
(101327, 'merchant', 'Notification Settings', 61, 0, 'merchant/notification_settings', 'merchant.notification_settings', 13.00, 1, 0, '', '', '', ''),
(101328, 'merchant', 'Orders Settings', 61, 0, 'merchant/orders_settings', 'merchant.orders_settings', 14.00, 1, 0, '', '', '', ''),
(101329, 'merchant', 'Menu Options', 61, 0, 'merchant/menu_options', 'merchant.menu_options', 15.00, 1, 0, '', '', '', ''),
(101330, 'merchant', 'Mobile Page', 61, 0, 'merchant/mobilepage', 'merchant.mobilepage', 16.00, 1, 0, '', '', '', ''),
(101331, 'merchant', 'Order limit', 61, 0, 'merchant/time_management', 'merchant.time_management', 17.00, 1, 1, 'merchant.time_management_create', 'merchant.time_management_update', 'merchant.time_mgt_delete', ''),
(101332, 'merchant', 'Banner', 61, 0, 'merchant/banner', 'merchant.banner', 18.00, 1, 1, 'merchant.banner_create', 'merchant.banner_update', 'merchant.banner_delete', ''),
(101333, 'merchant', 'Pages', 61, 0, 'merchant/pages_list', 'merchant.pages_list', 19.00, 1, 1, 'merchant.pages_create', 'merchant.page_update', 'merchant.pages_delete', ''),
(101334, 'merchant', 'Menu', 61, 0, 'merchant/pages_menu', 'merchant.pages_menu', 20.00, 1, 1, '', '', '', ''),
(101335, 'merchant', 'View Order', 64, 0, 'orders/view', 'orders.view', 0.00, 1, 0, '', '', '', ''),
(101336, 'merchant', 'New Orders', 64, 0, 'orders/new', 'orders.new', 1.00, 1, 1, '', '', '', ''),
(101337, 'merchant', 'Orders Processing', 64, 0, 'orders/processing', 'orders.processing', 2.00, 1, 1, '', '', '', ''),
(101338, 'merchant', 'Orders Ready', 64, 0, 'orders/ready', 'orders.ready', 3.00, 1, 1, '', '', '', ''),
(101339, 'merchant', 'Completed', 64, 0, 'orders/completed', 'orders.completed', 4.00, 1, 1, '', '', '', ''),
(101340, 'merchant', 'Scheduled', 64, 0, 'orders/scheduled', 'orders.scheduled', 5.00, 1, 1, '', '', '', ''),
(101341, 'merchant', 'All Orders', 64, 0, 'orders/history', 'orders.history', 6.00, 1, 1, '', '', '', ''),
(101342, 'merchant', 'Create Order', 171, 0, 'pos/create_order', 'pos.create_order', 1.00, 1, 1, 'pos.createorder', '', '', ''),
(101343, 'merchant', 'Order History', 171, 0, 'pos/order_history', 'pos.order_history', 2.00, 1, 1, 'pos.orderhistory', '', '', ''),
(101344, 'merchant', 'Cashout list', 21495, 0, 'merchantdriver/cashout_list', 'merchantdriver.cashout_list', 1.00, 1, 1, '', '', '', ''),
(101345, 'merchant', 'Collect cash', 21495, 0, 'merchantdriver/collect_cash', 'merchantdriver.collect_cash', 2.00, 1, 1, 'merchantdriver.collect_cash_add', '', 'merchantdriver.collect_cash_delete', 'merchantdriver.collect_transactions'),
(101346, 'merchant', 'Driver list', 21495, 0, 'merchantdriver/list', 'merchantdriver.list', 3.00, 1, 1, 'merchantdriver.add', 'merchantdriver.update', 'merchantdriver.delete', 'merchantdriver.overview'),
(101347, 'merchant', 'Driver License', 21495, 0, 'merchantdriver/license', 'merchantdriver.license', 3.10, 1, 0, '', '', '', ''),
(101348, 'merchant', 'Driver Vehicle', 21495, 0, 'merchantdriver/vehicle', 'merchantdriver.vehicle', 3.20, 1, 0, '', '', '', ''),
(101349, 'merchant', 'Driver Bank Information', 21495, 0, 'merchantdriver/bank_info', 'merchantdriver.bank_info', 3.30, 1, 0, '', '', '', ''),
(101350, 'merchant', 'Driver Wallet', 21495, 0, 'merchantdriver/wallet', 'merchantdriver.wallet', 3.40, 1, 0, '', '', '', ''),
(101351, 'merchant', 'Driver Cashout', 21495, 0, 'merchantdriver/cashout_transactions', 'merchantdriver.cashout_transactions', 3.50, 1, 0, '', '', '', ''),
(101352, 'merchant', 'Driver Delivery Transactions', 21495, 0, 'merchantdriver/delivery_transactions', 'merchantdriver.delivery_transactions', 3.60, 1, 0, '', '', '', ''),
(101353, 'merchant', 'Driver Order Tips', 21495, 0, 'merchantdriver/order_tips', 'merchantdriver.order_tips', 3.70, 1, 0, '', '', '', ''),
(101354, 'merchant', 'Driver Time Logs', 21495, 0, 'merchantdriver/time_logs', 'merchantdriver.time_logs', 3.80, 1, 0, '', '', '', ''),
(101355, 'merchant', 'Driver Review', 21495, 0, 'merchantdriver/review_ratings', 'merchantdriver.review_ratings', 3.90, 1, 0, '', '', '', ''),
(101356, 'merchant', 'Car registration', 21495, 0, 'merchantdriver/carlist', 'merchantdriver.carlist', 4.00, 1, 1, 'merchantdriver.addcar', 'merchantdriver.update_car', 'merchantdriver.delete_car', ''),
(101357, 'merchant', 'Groups', 21495, 0, 'merchantdriver/group_list', 'merchantdriver.group_list', 5.00, 1, 1, 'merchantdriver.addgroup', 'merchantdriver.group_update', 'merchantdriver.group_delete', ''),
(101358, 'merchant', 'Zones', 21495, 0, 'merchantdriver/zone_list', 'merchantdriver.zone_list', 6.00, 1, 1, 'merchantdriver.zone_create', 'merchantdriver.zone_update', 'merchantdriver.zone_delete', ''),
(101359, 'merchant', 'Employee Schedule', 21495, 0, 'merchantdriver/schedule_list', 'merchantdriver.schedule_list', 7.00, 1, 1, 'merchantdriver.schedule_add', 'merchantdriver.schedule_update', 'merchantdriver.schedule_delete', 'merchantdriver.schedule_bulk'),
(101360, 'merchant', 'Shifts Schedule', 21495, 0, 'merchantdriver/shift_list', 'merchantdriver.shift_list', 8.00, 1, 1, 'merchantdriver.shift_add', 'merchantdriver.shift_update', 'merchantdriver.shift_delete', 'merchantdriver.shift_bulkupload'),
(101361, 'merchant', 'Reviews', 21495, 0, 'merchantdriver/review_list', 'merchantdriver.review_list', 9.00, 1, 1, 'merchantdriver.review_create', 'merchantdriver.review_update', 'merchantdriver.review_delete', ''),
(101362, 'merchant', 'Loyalty Points', 45860, 0, 'merchant/loyalty_points', 'merchant.loyalty_points', 1.00, 1, 1, '', '', '', ''),
(101363, 'merchant', 'Suggested Items', 45860, 0, 'merchant/suggested_items', 'merchant.suggested_items', 2.00, 1, 1, '', '', '', ''),
(101364, 'merchant', 'Chats', 38314, 0, 'communications/chats', 'communications.chats', 1.00, 1, 1, 'communications.framechat', '', '', ''),
(101365, 'merchant', 'List', 428, 0, 'booking/list', 'booking.list', 1.00, 1, 1, 'booking.create_reservation', 'booking.update_reservation', 'booking.reservation_delete', 'booking.reservation_overview'),
(101366, 'merchant', 'Booking Update Status', 428, 0, 'booking/update_status', 'booking.update_status', 2.00, 1, 0, '', '', '', ''),
(101367, 'merchant', 'Settings', 428, 0, 'booking/settings', 'booking.settings', 3.00, 1, 1, '', '', '', ''),
(101368, 'merchant', 'Shifts', 428, 0, 'booking/shifts', 'booking.shifts', 4.00, 1, 1, 'booking.create_shift', 'booking.update_shift', 'booking.shift_delete', ''),
(101369, 'merchant', 'Room', 428, 0, 'booking/room', 'booking.room', 5.00, 1, 1, 'booking.create_room', 'booking.update_room', 'booking.room_delete', ''),
(101370, 'merchant', 'Tables', 428, 0, 'booking/tables', 'booking.tables', 6.00, 1, 1, 'booking.create_table', 'booking.update_tables', 'booking.tables_delete', ''),
(101371, 'merchant', 'Generate Table', 428, 0, 'booking/generate_table', 'booking.generate_table', 6.10, 1, 0, '', '', '', ''),
(101372, 'merchant', 'Tableside QrCode Configuration', 428, 0, 'booking/tableside_config', 'booking.tableside_config', 6.20, 1, 0, '', '', '', ''),
(101373, 'merchant', 'View Table QrCode', 428, 0, 'booking/table_view', 'booking.table_view', 6.30, 1, 0, '', '', '', ''),
(101374, 'merchant', 'Size', 70, 0, 'attrmerchant/size_list', 'attrmerchant.size_list', 1.00, 1, 1, 'attrmerchant.size_create', 'attrmerchant.size_update', 'attrmerchant.size_delete', ''),
(101375, 'merchant', 'Ingredients', 70, 0, 'attrmerchant/ingredients_list', 'attrmerchant.ingredients_list', 2.00, 1, 1, 'attrmerchant.ingredients_create', 'attrmerchant.ingredients_update', 'attrmerchant.ingredients_delete', ''),
(101376, 'merchant', 'Cooking Reference', 70, 0, 'attrmerchant/cookingref_list', 'attrmerchant.cookingref_list', 3.00, 1, 1, 'attrmerchant.cookingref_create', 'attrmerchant.cookingref_update', 'attrmerchant.cookingref_delete', ''),
(101377, 'merchant', 'Category', 75, 0, 'food/category', 'food.category', 1.00, 1, 1, 'food.category_create', 'food.category_update', 'food.category_delete', 'food.category_sort'),
(101378, 'merchant', 'Category Availability', 75, 0, 'food/category_availability', 'food.category_availability', 2.00, 1, 0, '', '', '', ''),
(101379, 'merchant', 'Addon Category', 75, 0, 'food/addoncategory', 'food.addoncategory', 3.00, 1, 1, 'food.addoncategory_create', 'food.addoncategory_update', 'food.addoncategory_delete', 'food.addoncategory_sort');
INSERT INTO `st_menu` (`menu_id`, `menu_type`, `menu_name`, `parent_id`, `meta_value1`, `link`, `action_name`, `sequence`, `status`, `visible`, `role_create`, `role_update`, `role_delete`, `role_view`) VALUES
(101380, 'merchant', 'Addon Items', 75, 0, 'food/addonitem', 'food.addonitem', 5.00, 1, 1, 'food.addonitem_create', 'food.addonitem_update', 'food.addonitem_delete', 'food.addonitem_sort'),
(101381, 'merchant', 'Items', 75, 0, 'food/items', 'food.items', 7.00, 1, 1, 'food.item_create', 'food.item_update', 'food.item_delete', 'food.item_sort'),
(101382, 'merchant', 'Items Availability', 75, 0, 'food/items_availability', 'food.items_availability', 7.10, 1, 1, '', '', '', ''),
(101383, 'merchant', 'Bulk Import', 75, 0, 'food/bulkimport', 'food.bulkimport', 7.01, 1, 0, '', '', '', ''),
(101384, 'merchant', 'Item Duplicate', 75, 0, 'food/item_duplicate', 'food.item_duplicate', 7.02, 1, 0, '', '', '', ''),
(101385, 'merchant', 'Items price', 75, 0, 'food/item_price', 'food.item_price', 7.10, 1, 0, 'food.itemprice_create', 'food.itemprice_update', 'food.itemprice_delete', ''),
(101386, 'merchant', 'Items addon', 75, 0, 'food/item_addon', 'food.item_addon', 7.20, 1, 0, 'food.itemaddon_create', 'food.itemaddon_update', 'food.itemaddon_delete', 'food.itemaddon_sort'),
(101387, 'merchant', 'Items attributes', 75, 0, 'food/item_attributes', 'food.item_attributes', 7.30, 1, 0, '', '', '', ''),
(101388, 'merchant', 'Tax', 75, 0, 'food/item_tax', 'food.item_tax', 7.30, 1, 0, '', '', '', ''),
(101389, 'merchant', 'Items availability', 75, 0, 'food/item_availability', 'food.item_availability', 7.40, 1, 0, '', '', '', ''),
(101390, 'merchant', 'Items inventory', 75, 0, 'food/item_inventory', 'food.item_inventory', 7.50, 1, 0, '', '', '', ''),
(101391, 'merchant', 'Items promo', 75, 0, 'food/item_promos', 'food.item_promos', 7.60, 1, 0, 'food.itempromo_create', 'food.itempromo_update', 'food.itempromo_delete', ''),
(101392, 'merchant', 'Items gallery', 75, 0, 'food/item_gallery', 'food.item_gallery', 7.70, 1, 0, '', '', '', ''),
(101393, 'merchant', 'Items seo', 75, 0, 'food/item_seo', 'food.item_seo', 7.80, 1, 0, '', '', '', ''),
(101394, 'merchant', 'Delivery Settings', 80, 0, 'services/delivery_settings', 'services.delivery_settings', 1.00, 1, 1, '', '', '', ''),
(101395, 'merchant', 'Fixed Charge', 80, 0, 'services/fixed_charge', 'services.fixed_charge', 3.00, 1, 0, '', '', '', ''),
(101396, 'merchant', 'Charges Table', 80, 0, 'services/charges_table', 'services.charges_table', 4.00, 1, 0, 'services.chargestable_create', 'services.chargestable_update', 'services.chargestable_delete', ''),
(101397, 'merchant', 'Pickup', 80, 0, 'services/settings_pickup', 'services.settings_pickup', 5.00, 1, 1, '', '', '', ''),
(101398, 'merchant', 'Pickup Instructions', 80, 0, 'services/pickup_instructions', 'services.pickup_instructions', 6.00, 1, 0, '', '', '', ''),
(101399, 'merchant', 'Dinein', 80, 0, 'services/settings_dinein', 'services.settings_dinein', 7.00, 1, 1, '', '', '', ''),
(101400, 'merchant', 'Dinein Instructions', 80, 0, 'services/dinein_instructions', 'services.dinein_instructions', 8.00, 1, 0, '', '', '', ''),
(101401, 'merchant', 'All Payments', 143, 0, 'merchant/payment_list', 'merchant.payment_list', 1.00, 1, 1, 'merchant.payment_create', 'merchant.payment_update', 'merchant.payment_delete', ''),
(101402, 'merchant', 'Bank Deposit', 143, 0, 'merchant/bank_deposit', 'merchant.bank_deposit', 2.00, 1, 1, '', 'invoice.bank_deposit_view', 'invoice.bank_deposit_delete', ''),
(101403, 'merchant', 'Pay on delivery', 143, 0, 'merchant/payondelivery', 'merchant.payondelivery', 3.00, 1, 1, '', '', '', ''),
(101404, 'merchant', 'Coupon', 82, 0, 'merchant/coupon', 'merchant.coupon', 1.00, 1, 1, 'merchant.coupon_create', 'merchant.coupon_update', 'merchant.coupon_delete', ''),
(101405, 'merchant', 'Offers', 82, 0, 'merchant/offers', 'merchant.offers', 2.00, 1, 1, 'merchant.offer_create', 'merchant.offer_update', 'merchant.offer_delete', ''),
(101406, 'merchant', 'Gallery', 85, 0, 'images/gallery', 'images.gallery', 1.00, 1, 1, '', '', '', ''),
(101407, 'merchant', 'Media Library', 85, 0, 'images/media_library', 'images.media_library', 2.00, 1, 1, '', '', '', ''),
(101408, 'merchant', 'Get Media Files', 85, 0, 'upload/getMedia', 'upload.getMedia', 3.00, 1, 0, '', '', '', ''),
(101409, 'merchant', 'Get Media Files Selected', 85, 0, 'upload/getMediaSeleted', 'upload.getMediaSeleted', 4.00, 1, 0, '', '', '', ''),
(101410, 'merchant', 'Upload Media Files', 85, 0, 'upload/file', 'upload.file', 5.00, 1, 0, '', '', '', ''),
(101411, 'merchant', 'Delete media files', 85, 0, 'upload/deleteFiles', 'upload.deleteFiles', 6.00, 1, 0, '', '', '', ''),
(101412, 'merchant', 'Statement', 87, 0, 'commission/statement', 'commission.statement', 1.00, 1, 1, '', '', '', ''),
(101413, 'merchant', 'Withdrawals', 87, 0, 'commission/withdrawals', 'commission.withdrawals', 1.00, 1, 1, '', '', '', ''),
(101414, 'merchant', 'List', 423, 0, 'invoicemerchant/list', 'invoicemerchant.list', 1.00, 1, 1, '', '', '', ''),
(101415, 'merchant', 'Invoice View', 423, 0, 'invoicemerchant/view', 'invoicemerchant.view', 2.00, 1, 0, '', '', '', ''),
(101416, 'merchant', 'Upload Deposit', 423, 0, 'invoicemerchant/uploaddeposit', 'invoicemerchant.uploaddeposit', 3.00, 1, 0, '', '', '', ''),
(101417, 'merchant', 'View PDF', 423, 0, 'invoicemerchant/pdf', 'invoicemerchant.pdf', 4.00, 1, 0, '', '', '', ''),
(101418, 'merchant', 'Customer list', 94, 0, 'customer/list', 'customer.list', 1.00, 1, 1, '', '', '', 'customer.view'),
(101419, 'merchant', 'Address', 94, 0, 'customer/addresses', 'customer.addresses', 2.00, 1, 0, 'customer.address_create', 'customer.address_update', 'customer.address_delete', ''),
(101420, 'merchant', 'Order History', 94, 0, 'customer/order_history', 'customer.order_history', 3.00, 1, 0, '', '', '', ''),
(101421, 'merchant', 'Print PDF', 94, 0, 'print/pdf', 'print.pdf', 4.00, 1, 0, '', '', '', ''),
(101422, 'merchant', 'Review List', 94, 0, 'customer/reviews', 'customer.reviews', 5.00, 1, 1, 'customer.review_reply', 'customer.review_reply_update', 'customer.customerreview_delete', ''),
(101423, 'merchant', 'Email Subscribers', 94, 0, 'customer/email_subscriber', 'customer.email_subscriber', 6.00, 1, 1, '', '', 'customer.esubscriber_delete', ''),
(101424, 'merchant', 'All User', 97, 0, 'usermerchant/user_list', 'usermerchant.user_list', 1.00, 1, 1, 'usermerchant.user_create', 'usermerchant.user_update', 'usermerchant.user_delete', ''),
(101425, 'merchant', 'All Roles', 97, 0, 'usermerchant/role_list', 'usermerchant.role_list', 2.00, 1, 1, 'usermerchant.role_create', 'usermerchant.role_update', 'usermerchant.role_delete', ''),
(101426, 'merchant', 'Sales Report', 100, 0, 'merchantreport/sales', 'merchantreport.sales', 1.00, 1, 1, '', '', '', ''),
(101427, 'merchant', 'Daily Sales Report', 100, 0, 'merchantreport/dailysalesreport', 'merchantreport.dailysalesreport', 1.10, 1, 1, '', '', '', ''),
(101428, 'merchant', 'Sales Summary', 100, 0, 'merchantreport/summary', 'merchantreport.summary', 2.00, 1, 1, '', '', '', ''),
(101429, 'merchant', 'Sales Chart', 100, 0, 'merchantreport/summary', 'merchantreport.summary_chart', 2.10, 1, 0, '', '', '', ''),
(101430, 'merchant', 'Refund Report', 100, 0, 'merchantreport/refund', 'merchantreport.refund', 3.00, 1, 1, '', '', '', ''),
(101431, 'merchant', 'All printers', 417, 0, 'printers/all', 'printers.all', 1.00, 1, 1, 'printers.create', 'printers.update', 'printers.delete', ''),
(101432, 'merchant', 'Printer logs', 417, 0, 'printers/logs', 'printers.logs', 2.00, 1, 1, 'printers.print_view', 'printers.print_delete', 'printers.clear_printlogs', ''),
(101433, 'merchant', 'Suppliers', 127, 0, 'supplier/list', 'supplier.list', 1.00, 1, 1, 'supplier.create', 'supplier.update', 'supplier.delete', '');

-- --------------------------------------------------------

--
-- Table structure for table `st_merchant`
--

CREATE TABLE `st_merchant` (
  `merchant_id` int(14) NOT NULL,
  `merchant_uuid` varchar(100) NOT NULL DEFAULT '',
  `restaurant_slug` varchar(255) NOT NULL DEFAULT '',
  `restaurant_name` varchar(255) NOT NULL DEFAULT '',
  `restaurant_phone` varchar(100) NOT NULL DEFAULT '',
  `contact_name` varchar(255) NOT NULL DEFAULT '',
  `contact_phone` varchar(100) NOT NULL DEFAULT '',
  `contact_email` varchar(255) NOT NULL DEFAULT '',
  `address` text,
  `free_delivery` int(1) NOT NULL DEFAULT '2',
  `username` varchar(100) NOT NULL DEFAULT '',
  `password` varchar(100) NOT NULL DEFAULT '',
  `activation_key` varchar(50) NOT NULL DEFAULT '',
  `activation_token` varchar(255) NOT NULL DEFAULT '',
  `status` varchar(100) NOT NULL DEFAULT 'pending',
  `date_activated` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `is_featured` int(1) NOT NULL DEFAULT '1',
  `is_ready` int(1) NOT NULL DEFAULT '1',
  `is_sponsored` int(2) NOT NULL DEFAULT '1',
  `sponsored_expiration` date DEFAULT NULL,
  `lost_password_code` varchar(50) NOT NULL DEFAULT '',
  `is_commission` int(1) NOT NULL DEFAULT '1',
  `percent_commision` decimal(10,2) NOT NULL DEFAULT '0.00',
  `commision_based` varchar(50) NOT NULL DEFAULT '',
  `latitude` varchar(50) NOT NULL DEFAULT '',
  `lontitude` varchar(50) NOT NULL DEFAULT '',
  `logo` varchar(255) NOT NULL DEFAULT '',
  `path` varchar(255) NOT NULL DEFAULT '',
  `merchant_type` int(1) NOT NULL DEFAULT '1',
  `membership_expired` date DEFAULT NULL,
  `commision_type` varchar(50) NOT NULL DEFAULT '',
  `package_id` int(14) NOT NULL DEFAULT '0',
  `package_payment_code` varchar(100) NOT NULL DEFAULT '',
  `allowed_offline_payment` int(1) NOT NULL DEFAULT '0',
  `invoice_terms` int(14) NOT NULL DEFAULT '0',
  `distance_unit` varchar(20) NOT NULL DEFAULT 'mi',
  `delivery_distance_covered` float(14,2) NOT NULL DEFAULT '0.00',
  `header_image` varchar(255) NOT NULL DEFAULT '',
  `path2` varchar(255) NOT NULL DEFAULT '',
  `description` text,
  `short_description` text,
  `close_store` int(1) NOT NULL DEFAULT '0',
  `disabled_ordering` tinyint(1) NOT NULL DEFAULT '0',
  `pause_ordering` tinyint(1) NOT NULL DEFAULT '0',
  `orders_added` int(14) NOT NULL DEFAULT '0',
  `order_limit` int(14) NOT NULL DEFAULT '0',
  `items_added` int(14) NOT NULL DEFAULT '0',
  `item_limit` int(14) NOT NULL DEFAULT '0',
  `last_login` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `self_delivery` int(1) DEFAULT '0',
  `charge_type` varchar(50) NOT NULL DEFAULT 'fixed',
  `free_delivery_on_first_order` int(1) NOT NULL DEFAULT '0',
  `date_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `date_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ip_address` varchar(50) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `st_merchant_meta`
--

CREATE TABLE `st_merchant_meta` (
  `meta_id` int(11) NOT NULL,
  `merchant_id` int(11) NOT NULL DEFAULT '0',
  `meta_name` varchar(255) NOT NULL DEFAULT '',
  `meta_value` text,
  `meta_value1` text,
  `meta_value2` text,
  `meta_value3` text,
  `date_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `st_merchant_payment_method`
--

CREATE TABLE `st_merchant_payment_method` (
  `payment_method_id` int(11) NOT NULL,
  `payment_uuid` varchar(100) NOT NULL DEFAULT '',
  `merchant_id` bigint(20) DEFAULT '0',
  `payment_code` varchar(100) NOT NULL DEFAULT '',
  `as_default` int(1) NOT NULL DEFAULT '0',
  `attr1` varchar(255) NOT NULL DEFAULT '',
  `attr2` varchar(255) NOT NULL DEFAULT '',
  `attr3` varchar(255) NOT NULL DEFAULT '',
  `attr4` varchar(255) NOT NULL DEFAULT '',
  `attr5` varchar(255) NOT NULL DEFAULT '',
  `payment_refence` text,
  `date_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `date_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ip_address` varchar(50) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `st_merchant_type`
--

CREATE TABLE `st_merchant_type` (
  `id` int(11) NOT NULL,
  `type_id` int(11) NOT NULL DEFAULT '0',
  `type_name` varchar(255) NOT NULL DEFAULT '',
  `description` text,
  `commision_type` varchar(50) NOT NULL DEFAULT 'percentage',
  `commission` float(14,2) NOT NULL DEFAULT '0.00',
  `commission_data` text,
  `based_on` varchar(50) NOT NULL DEFAULT 'subtotal',
  `color_hex` varchar(10) NOT NULL DEFAULT '',
  `font_color_hex` varchar(10) NOT NULL DEFAULT '',
  `status` varchar(255) NOT NULL DEFAULT 'publish',
  `date_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `date_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ip_address` varchar(50) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `st_merchant_type`
--

INSERT INTO `st_merchant_type` (`id`, `type_id`, `type_name`, `description`, `commision_type`, `commission`, `based_on`, `color_hex`, `font_color_hex`, `status`, `date_created`, `date_modified`, `ip_address`) VALUES
(1, 1, 'Membership', 'Membership', 'percentage', 0.00, 'subtotal', '#ffd6c4', '', 'publish', '2021-10-06 07:48:02', '2022-01-27 07:45:01', '127.0.0.1'),
(2, 2, 'Commission', 'Commission', 'percentage', 5.00, 'subtotal', '#e8989b', '', 'publish', '2021-10-06 07:48:02', '2022-01-27 07:44:56', '127.0.0.1');

-- --------------------------------------------------------

--
-- Table structure for table `st_merchant_type_translation`
--

CREATE TABLE `st_merchant_type_translation` (
  `id` int(11) NOT NULL,
  `type_id` int(11) NOT NULL DEFAULT '0',
  `language` varchar(100) NOT NULL DEFAULT '',
  `type_name` varchar(255) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `st_merchant_type_translation`
--

INSERT INTO `st_merchant_type_translation` (`id`, `type_id`, `language`, `type_name`) VALUES
(1, 2, 'ja', ''),
(2, 2, 'ar', ''),
(3, 2, 'en', 'Commission'),
(4, 1, 'ja', ''),
(5, 1, 'ar', ''),
(6, 1, 'en', 'Membership');

-- --------------------------------------------------------

--
-- Table structure for table `st_merchant_user`
--

CREATE TABLE `st_merchant_user` (
  `merchant_user_id` int(14) NOT NULL,
  `user_uuid` varchar(50) NOT NULL DEFAULT '',
  `merchant_id` int(14) NOT NULL DEFAULT '0',
  `first_name` varchar(255) NOT NULL DEFAULT '',
  `last_name` varchar(255) NOT NULL DEFAULT '',
  `username` varchar(50) NOT NULL DEFAULT '',
  `password` varchar(32) NOT NULL DEFAULT '',
  `role` int(14) NOT NULL DEFAULT '0',
  `status` varchar(100) NOT NULL DEFAULT 'active',
  `contact_email` varchar(255) NOT NULL DEFAULT '',
  `session_token` varchar(255) NOT NULL DEFAULT '',
  `contact_number` varchar(20) NOT NULL DEFAULT '',
  `main_account` int(1) NOT NULL DEFAULT '0',
  `profile_photo` varchar(255) NOT NULL DEFAULT '',
  `path` varchar(255) NOT NULL DEFAULT '',
  `verification_code` int(10) NOT NULL DEFAULT '0',
  `last_login` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `date_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `date_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ip_address` varchar(50) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `st_multicurrency_list`
--

CREATE TABLE `st_multicurrency_list` (
  `id` int(11) NOT NULL,
  `currency_name` varchar(50) NOT NULL DEFAULT '',
  `symbol` varchar(5) NOT NULL DEFAULT '',
  `code` varchar(50) NOT NULL DEFAULT '',
  `country_code` varchar(5) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `st_multicurrency_list`
--

INSERT INTO `st_multicurrency_list` (`id`, `currency_name`, `symbol`, `code`, `country_code`) VALUES
(1, 'Albanian Lek', 'Lek', 'ALL', 'AL'),
(2, 'East Caribbean Dollar', '$', 'XCD', 'LC'),
(3, 'Euro', '€', 'EUR', 'EU'),
(4, 'Barbadian Dollar', '$', 'BBD', 'BB'),
(5, 'Bhutanese Ngultrum', '', 'BTN', 'BT'),
(6, 'Brunei Dollar', '$', 'BND', 'BN'),
(7, 'Central African CFA Franc', '', 'XAF', 'CM'),
(8, 'Cuban Peso', '$', 'CUP', 'CU'),
(9, 'United States Dollar', '$', 'USD', 'US'),
(10, 'Falkland Islands Pound', '£', 'FKP', 'FK'),
(11, 'Gibraltar Pound', '£', 'GIP', 'GI'),
(12, 'Hungarian Forint', 'Ft', 'HUF', 'HU'),
(13, 'Iranian Rial', '﷼', 'IRR', 'IR'),
(14, 'Jamaican Dollar', 'J$', 'JMD', 'JM'),
(15, 'Australian Dollar', '$', 'AUD', 'AU'),
(16, 'Lao Kip', '₭', 'LAK', 'LA'),
(17, 'Libyan Dinar', '', 'LYD', 'LY'),
(18, 'Macedonian Denar', 'ден', 'MKD', 'MK'),
(19, 'West African CFA Franc', '', 'XOF', 'BJ'),
(20, 'New Zealand Dollar', '$', 'NZD', 'NZ'),
(21, 'Omani Rial', '﷼', 'OMR', 'OM'),
(22, 'Papua New Guinean Kina', '', 'PGK', 'PG'),
(23, 'Rwandan Franc', '', 'RWF', 'RW'),
(24, 'Samoan Tala', '', 'WST', 'WS'),
(25, 'Serbian Dinar', 'Дин.', 'RSD', 'RS'),
(26, 'Swedish Krona', 'kr', 'SEK', 'SE'),
(27, 'Tanzanian Shilling', 'TSh', 'TZS', 'TZ'),
(28, 'Armenian Dram', '', 'AMD', 'AM'),
(29, 'Bahamian Dollar', '$', 'BSD', 'BS'),
(30, 'Bosnia And Herzegovina Konvertibilna Marka', 'KM', 'BAM', 'BA'),
(31, 'Cape Verdean Escudo', '', 'CVE', 'CV'),
(32, 'Chinese Yuan', '¥', 'CNY', 'CN'),
(33, 'Costa Rican Colon', '₡', 'CRC', 'CR'),
(34, 'Czech Koruna', 'Kč', 'CZK', 'CZ'),
(35, 'Eritrean Nakfa', '', 'ERN', 'ER'),
(36, 'Georgian Lari', '', 'GEL', 'GE'),
(37, 'Haitian Gourde', '', 'HTG', 'HT'),
(38, 'Indian Rupee', '₹', 'INR', 'IN'),
(39, 'Jordanian Dinar', '', 'JOD', 'JO'),
(40, 'South Korean Won', '₩', 'KRW', 'KR'),
(41, 'Lebanese Lira', '£', 'LBP', 'LB'),
(42, 'Malawian Kwacha', '', 'MWK', 'MW'),
(43, 'Mauritanian Ouguiya', '', 'MRO', 'MR'),
(44, 'Mozambican Metical', '', 'MZN', 'MZ'),
(45, 'Netherlands Antillean Gulden', 'ƒ', 'ANG', 'AN'),
(46, 'Peruvian Nuevo Sol', 'S/.', 'PEN', 'PE'),
(47, 'Qatari Riyal', '﷼', 'QAR', 'QA'),
(48, 'Sao Tome And Principe Dobra', '', 'STD', 'ST'),
(49, 'Sierra Leonean Leone', '', 'SLL', 'SL'),
(50, 'Somali Shilling', 'S', 'SOS', 'SO'),
(51, 'Sudanese Pound', '', 'SDG', 'SD'),
(52, 'Syrian Pound', '£', 'SYP', 'SY'),
(53, 'Angolan Kwanza', '', 'AOA', 'AO'),
(54, 'Aruban Florin', 'ƒ', 'AWG', 'AW'),
(55, 'Bahraini Dinar', '', 'BHD', 'BH'),
(56, 'Belize Dollar', 'BZ$', 'BZD', 'BZ'),
(57, 'Botswana Pula', 'P', 'BWP', 'BW'),
(58, 'Burundi Franc', '', 'BIF', 'BI'),
(59, 'Cayman Islands Dollar', '$', 'KYD', 'KY'),
(60, 'Colombian Peso', '$', 'COP', 'CO'),
(61, 'Danish Krone', 'kr', 'DKK', 'DK'),
(62, 'Guatemalan Quetzal', 'Q', 'GTQ', ''),
(63, 'Honduran Lempira', 'L', 'HNL', 'HN'),
(64, 'Indonesian Rupiah', 'Rp', 'IDR', 'ID'),
(65, 'Israeli New Sheqel', '₪', 'ILS', 'IL'),
(66, 'Kazakhstani Tenge', 'лв', 'KZT', 'KZ'),
(67, 'Kuwaiti Dinar', '', 'KWD', 'KW'),
(68, 'Lesotho Loti', '', 'LSL', 'LS'),
(69, 'Malaysian Ringgit', 'RM', 'MYR', 'MY'),
(70, 'Mauritian Rupee', '₨', 'MUR', 'MU'),
(71, 'Mongolian Tugrik', '₮', 'MNT', 'MN'),
(72, 'Myanma Kyat', '', 'MMK', 'MM'),
(73, 'Nigerian Naira', '₦', 'NGN', 'NG'),
(74, 'Panamanian Balboa', 'B/.', 'PAB', 'PA'),
(75, 'Philippine Peso', '₱', 'PHP', 'PH'),
(76, 'Romanian Leu', 'lei', 'RON', 'RO'),
(77, 'Saudi Riyal', '﷼', 'SAR', 'SA'),
(78, 'Singapore Dollar', '$', 'SGD', 'SG'),
(79, 'South African Rand', 'R', 'ZAR', 'ZA'),
(80, 'Surinamese Dollar', '$', 'SRD', 'SR'),
(81, 'New Taiwan Dollar', 'NT$', 'TWD', 'TW'),
(82, 'Paanga', '', 'TOP', 'TO'),
(83, 'Venezuelan Bolivar', '', 'VEF', 'VE'),
(84, 'Algerian Dinar', '', 'DZD', 'DZ'),
(85, 'Argentine Peso', '$', 'ARS', 'AR'),
(86, 'Azerbaijani Manat', 'ман', 'AZN', 'AZ'),
(87, 'Belarusian Ruble', 'p.', 'BYR', 'BY'),
(88, 'Bolivian Boliviano', '$ b', 'BOB', 'BO'),
(89, 'Bulgarian Lev', 'лв', 'BGN', 'BG'),
(90, 'Canadian Dollar', '$', 'CAD', 'CA'),
(91, 'Chilean Peso', '$', 'CLP', 'CL'),
(92, 'Congolese Franc', '', 'CDF', 'CD'),
(93, 'Dominican Peso', 'RD$', 'DOP', 'DO'),
(94, 'Fijian Dollar', '$', 'FJD', 'FJ'),
(95, 'Gambian Dalasi', '', 'GMD', 'GM'),
(96, 'Guyanese Dollar', '$', 'GYD', 'GY'),
(97, 'Icelandic Króna', 'kr', 'ISK', 'IS'),
(98, 'Iraqi Dinar', '', 'IQD', 'IQ'),
(99, 'Japanese Yen', '¥', 'JPY', 'JP'),
(100, 'North Korean Won', '₩', 'KPW', 'KP'),
(101, 'Latvian Lats', 'Ls', 'LVL', ''),
(102, 'Swiss Franc', 'Fr.', 'CHF', 'CH'),
(103, 'Malagasy Ariary', '', 'MGA', ''),
(104, 'Moldovan Leu', '', 'MDL', 'MD'),
(105, 'Moroccan Dirham', '', 'MAD', 'MA'),
(106, 'Nepalese Rupee', '₨', 'NPR', 'NP'),
(107, 'Nicaraguan Cordoba', 'C$', 'NIO', 'NI'),
(108, 'Pakistani Rupee', '₨', 'PKR', 'PK'),
(109, 'Paraguayan Guarani', 'Gs', 'PYG', 'PY'),
(110, 'Saint Helena Pound', '£', 'SHP', 'SH'),
(111, 'Seychellois Rupee', '₨', 'SCR', 'SC'),
(112, 'Solomon Islands Dollar', '$', 'SBD', 'SB'),
(113, 'Sri Lankan Rupee', '₨', 'LKR', 'LK'),
(114, 'Thai Baht', '฿', 'THB', 'TH'),
(115, 'Turkish New Lira', '', 'TRY', 'TR'),
(116, 'UAE Dirham', '', 'AED', 'AE'),
(117, 'Vanuatu Vatu', '', 'VUV', 'VU'),
(118, 'Yemeni Rial', '﷼', 'YER', 'YE'),
(119, 'Afghan Afghani', '؋', 'AFN', 'AF'),
(120, 'Bangladeshi Taka', '', 'BDT', 'BD'),
(121, 'Brazilian Real', 'R$', 'BRL', 'BR'),
(122, 'Cambodian Riel', '៛', 'KHR', 'KH'),
(123, 'Comorian Franc', '', 'KMF', 'KM'),
(124, 'Croatian Kuna', 'kn', 'HRK', 'HR'),
(125, 'Djiboutian Franc', '', 'DJF', 'DJ'),
(126, 'Egyptian Pound', '£', 'EGP', 'EG'),
(127, 'Ethiopian Birr', '', 'ETB', 'ET'),
(128, 'CFP Franc', '', 'XPF', 'WF'),
(129, 'Ghanaian Cedi', '', 'GHS', 'GH'),
(130, 'Guinean Franc', '', 'GNF', 'GN'),
(131, 'Hong Kong Dollar', '$', 'HKD', 'HK'),
(132, 'Special Drawing Rights', '', 'XDR', ''),
(133, 'Kenyan Shilling', 'KSh', 'KES', 'KE'),
(134, 'Kyrgyzstani Som', 'лв', 'KGS', 'KG'),
(135, 'Liberian Dollar', '$', 'LRD', 'LR'),
(136, 'Macanese Pataca', '', 'MOP', ''),
(137, 'Maldivian Rufiyaa', '', 'MVR', 'MV'),
(138, 'Mexican Peso', '$', 'MXN', 'MX'),
(139, 'Namibian Dollar', '$', 'NAD', 'NA'),
(140, 'Norwegian Krone', 'kr', 'NOK', 'NO'),
(141, 'Polish Zloty', 'zł', 'PLN', 'PL'),
(142, 'Russian Ruble', 'руб', 'RUB', 'RU'),
(143, 'Swazi Lilangeni', '', 'SZL', 'SZ'),
(144, 'Tajikistani Somoni', '', 'TJS', 'TJ'),
(145, 'Trinidad and Tobago Dollar', 'TT$', 'TTD', 'TT'),
(146, 'Ugandan Shilling', 'USh', 'UGX', 'UG'),
(147, 'Uruguayan Peso', '$ U', 'UYU', 'UY'),
(148, 'Vietnamese Dong', '₫', 'VND', 'VN'),
(149, 'Tunisian Dinar', '', 'TND', 'TN'),
(150, 'Ukrainian Hryvnia', '₴', 'UAH', 'UA'),
(151, 'Uzbekistani Som', 'лв', 'UZS', 'UZ'),
(152, 'Turkmenistan Manat', '', 'TMT', 'TM'),
(153, 'British Pound', '£', 'GBP', 'GB'),
(154, 'Zambian Kwacha', '', 'ZMW', 'ZM'),
(155, 'Bitcoin', 'BTC', 'BTC', 'XBT'),
(156, 'New Belarusian Ruble', 'p.', 'BYN', 'BY'),
(157, 'Bermudan Dollar', '', 'BMD', 'BM'),
(158, 'Guernsey Pound', '', 'GGP', 'GG'),
(159, 'Chilean Unit Of Account', '', 'CLF', 'CL'),
(160, 'Cuban Convertible Peso', '', 'CUC', 'CU'),
(161, 'Manx pound', '', 'IMP', 'IM'),
(162, 'Jersey Pound', '', 'JEP', 'JE'),
(163, 'Salvadoran Colón', '', 'SVC', 'SV'),
(164, 'Old Zambian Kwacha', '', 'ZMK', 'ZM'),
(165, 'Silver (troy ounce)', '', 'XAG', 'XA'),
(166, 'Zimbabwean Dollar', '', 'ZWL', 'ZW');

-- --------------------------------------------------------

--
-- Table structure for table `st_notifications`
--

CREATE TABLE `st_notifications` (
  `notification_uuid` varchar(100) NOT NULL,
  `notication_channel` varchar(50) NOT NULL DEFAULT 'admin',
  `notification_event` varchar(100) NOT NULL DEFAULT '',
  `notification_type` varchar(100) NOT NULL DEFAULT '',
  `message` text,
  `message_parameters` text,
  `meta_data` text,
  `image_type` varchar(50) NOT NULL DEFAULT 'icon',
  `image` varchar(100) NOT NULL DEFAULT '',
  `image_path` varchar(100) NOT NULL DEFAULT '',
  `status` varchar(50) NOT NULL DEFAULT 'pending',
  `response` text,
  `visible` smallint(1) NOT NULL DEFAULT '1',
  `viewed` tinyint(1) NOT NULL DEFAULT '0',
  `date_created` timestamp NULL DEFAULT NULL,
  `ip_address` varchar(50) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `st_offers`
--

CREATE TABLE `st_offers` (
  `offers_id` int(14) NOT NULL,
  `offer_name` varchar(100) NOT NULL DEFAULT '',
  `offer_type` varchar(50) NOT NULL DEFAULT 'percentage',
  `merchant_id` int(14) NOT NULL DEFAULT '0',
  `offer_percentage` float(14,4) NOT NULL DEFAULT '0.0000',
  `min_order` decimal(10,2) NOT NULL DEFAULT '0.00',
  `offer_price` float(14,4) NOT NULL DEFAULT '0.0000',
  `max_discount_cap` decimal(10,2) NOT NULL DEFAULT '0.00',
  `valid_from` date DEFAULT NULL,
  `valid_to` date DEFAULT NULL,
  `applicable_to` varchar(100) NOT NULL DEFAULT 'all',
  `status` varchar(255) NOT NULL DEFAULT 'pending',
  `visible` smallint(1) NOT NULL DEFAULT '1',
  `date_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `date_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ip_address` varchar(50) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `st_opening_hours`
--

CREATE TABLE `st_opening_hours` (
  `id` int(14) NOT NULL,
  `merchant_id` int(14) NOT NULL DEFAULT '0',
  `time_config_type` varchar(50) NOT NULL DEFAULT 'regular_hours',
  `transaction_type` varchar(50) DEFAULT NULL,
  `day` varchar(20) DEFAULT '',
  `day_of_week` int(1) NOT NULL DEFAULT '0',
  `status` varchar(100) NOT NULL DEFAULT 'open',
  `start_time` varchar(14) NOT NULL DEFAULT '',
  `end_time` varchar(14) NOT NULL DEFAULT '',
  `start_time_pm` varchar(14) NOT NULL DEFAULT '',
  `end_time_pm` varchar(14) NOT NULL DEFAULT '',
  `custom_text` varchar(255) NOT NULL DEFAULT '',
  `last_update` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `st_opening_hours`
--

INSERT INTO `st_opening_hours` (`id`, `merchant_id`, `day`, `day_of_week`, `status`, `start_time`, `end_time`, `start_time_pm`, `end_time_pm`, `custom_text`, `last_update`) VALUES
(1, 0, 'monday', 1, 'open', '1:00', '23:55', '', '', '', '2022-01-29 15:55:16'),
(2, 0, 'tuesday', 2, 'open', '1:00', '23:55', '', '', '', '2022-01-29 15:55:32'),
(3, 0, 'wednesday', 3, 'open', '1:00', '23:55', '', '', '', '2022-01-29 15:55:47'),
(4, 0, 'thursday', 4, 'open', '1:00', '23:55', '', '', '', '2022-01-29 15:56:04'),
(5, 0, 'friday', 5, 'open', '1:00', '23:55', '', '', '', '2022-01-29 15:56:16'),
(6, 0, 'saturday', 6, 'open', '1:00', '23:55', '', '', '', '2022-01-29 15:56:34'),
(7, 0, 'sunday', 7, 'open', '1:00', '23:55', '', '', '', '2022-01-29 15:56:48');

-- --------------------------------------------------------

--
-- Table structure for table `st_option`
--

CREATE TABLE `st_option` (
  `id` int(14) UNSIGNED NOT NULL,
  `merchant_id` int(14) NOT NULL DEFAULT '0',
  `option_name` varchar(255) NOT NULL DEFAULT '',
  `option_value` text,
  `last_update` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `st_option`
--

INSERT INTO `st_option` (`id`, `merchant_id`, `option_name`, `option_value`, `last_update`) VALUES
(57, 0, 'website_timezone_new', 'Asia/Manila', '2022-01-27 07:44:21'),
(58, 0, 'website_date_format_new', 'EEE, MMMM d, y', '2022-01-27 07:44:21'),
(59, 0, 'website_time_format_new', 'h:mm a', '2022-01-27 07:44:21'),
(60, 0, 'website_time_picker_interval', '15', '2022-01-27 07:44:21'),
(61, 0, 'disabled_website_ordering', NULL, '2022-01-27 07:44:32'),
(62, 0, 'website_hide_foodprice', NULL, '2022-01-27 07:44:32'),
(63, 0, 'website_disbaled_auto_cart', NULL, '2022-01-27 07:44:32'),
(64, 0, 'website_disabled_cart_validation', NULL, '2022-01-27 07:44:32'),
(65, 0, 'enabled_merchant_check_closing_time', NULL, '2022-01-27 07:44:32'),
(66, 0, 'disabled_order_confirm_page', NULL, '2022-01-27 07:44:32'),
(67, 0, 'restrict_order_by_status', '', '2022-01-27 07:44:32'),
(68, 0, 'enabled_map_selection_delivery', NULL, '2022-01-27 07:44:32'),
(69, 0, 'admin_service_fee', NULL, '2022-01-27 07:44:32'),
(70, 0, 'admin_service_fee_applytax', NULL, '2022-01-27 07:44:32'),
(71, 0, 'cancel_order_enabled', '1', '2022-01-27 07:44:32'),
(72, 0, 'cancel_order_days_applied', NULL, '2022-01-27 07:44:32'),
(73, 0, 'cancel_order_hours', NULL, '2022-01-27 07:44:32'),
(74, 0, 'cancel_order_status_accepted', '', '2022-01-27 07:44:32'),
(75, 0, 'website_review_approved_status', NULL, '2022-01-27 07:44:32'),
(76, 0, 'enabled_website_ordering', '1', '2022-01-27 07:44:32'),
(90, 0, 'merchant_enabled_registration', '1', '2022-01-27 07:45:47'),
(91, 0, 'merchant_default_country', NULL, '2022-01-27 07:45:47'),
(92, 0, 'merchant_specific_country', '[\"PH\"]', '2022-01-27 07:45:47'),
(93, 0, 'pre_configure_size', 'small,medium,large', '2022-01-27 07:45:47'),
(94, 0, 'merchant_enabled_registration_capcha', '0', '2022-01-27 07:45:47'),
(95, 0, 'registration_program', '[\"2\",\"1\"]', '2022-01-27 07:45:47'),
(96, 0, 'registration_confirm_account_tpl', '25', '2022-01-27 07:45:47'),
(97, 0, 'registration_welcome_tpl', NULL, '2022-01-27 07:45:47'),
(98, 0, 'registration_terms_condition', 'By clicking \"Submit,\" you agree to <a href=\"\" class=\"text-green\">Karenderia General Terms and Conditions</a>\r\n     and acknowledge you have read the <a href=\"\" class=\"text-green\">Privacy Policy</a>.', '2022-01-27 07:45:47'),
(99, 0, 'merchant_registration_new_tpl', '26', '2022-01-27 07:45:47'),
(100, 0, 'merchant_registration_welcome_tpl', '24', '2022-01-27 07:45:47'),
(101, 0, 'merchant_plan_expired_tpl', '27', '2022-01-27 07:45:47'),
(102, 0, 'merchant_plan_near_expired_tpl', '28', '2022-01-27 07:45:47'),
(103, 0, 'website_title', 'Karenderia', '2022-01-27 16:09:32'),
(104, 0, 'home_search_unit_type', 'mi', '2022-01-27 16:09:57'),
(105, 0, 'map_provider', 'google.maps', '2022-01-28 07:38:48'),
(106, 0, 'google_geo_api_key', 'XXXX', '2022-01-28 07:38:48'),
(107, 0, 'google_maps_api_key', 'XXXX', '2022-01-28 07:38:48'),
(108, 0, 'mapbox_access_token', 'XXXX', '2022-01-28 07:38:48'),
(109, 0, 'signup_enabled_verification', '0', '2022-01-28 07:49:14'),
(110, 0, 'signup_verification_type', NULL, '2022-01-28 07:49:14'),
(111, 0, 'blocked_email_add', '', '2022-01-28 07:49:14'),
(112, 0, 'blocked_mobile', '', '2022-01-28 07:49:14'),
(113, 0, 'signup_type', 'mobile_phone', '2022-01-28 07:49:14'),
(114, 0, 'signup_enabled_terms', '0', '2022-01-28 07:49:14'),
(115, 0, 'signup_terms', 'By clicking \"Submit,\" you agree to <a href=\"\" class=\"text-green\">Karenderia General Terms and Conditions</a>\r\n	     and acknowledge you have read the <a href=\"\" class=\"text-green\">Privacy Policy</a>.', '2022-01-28 07:49:14'),
(116, 0, 'signup_enabled_capcha', '0', '2022-01-28 07:49:14'),
(117, 0, 'signup_welcome_tpl', '12', '2022-01-28 07:49:14'),
(118, 0, 'signup_verification_tpl', '13', '2022-01-28 07:49:14'),
(119, 0, 'signup_resetpass_tpl', '14', '2022-01-28 07:49:14'),
(120, 0, 'signup_resend_counter', '', '2022-01-28 07:49:14'),
(121, 0, 'signupnew_tpl', '19', '2022-01-28 07:49:14'),
(122, 0, 'image_resizing', '1', '2022-01-28 07:49:14'),
(124, 0, 'backend_version', '2.0.6', now()),
(123, 0, 'backend_forgot_password_tpl', 50, now()),
(125, 0, 'enabled_home_steps', '1', now()),
(126, 0, 'enabled_home_promotional', '1', now()),
(127, 0, 'enabled_signup_section', '1', now()),
(128, 0, 'enabled_mobileapp_section', '1', now()),
(129, 0, 'enabled_social_links', '1', now()),
(130, 0, 'booking_tpl_reservation_canceled', '38', now()),
(131, 0, 'booking_tpl_reservation_denied', '38', now()),
(132, 0, 'booking_tpl_reservation_finished', '38', now()),
(133, 0, 'booking_tpl_reservation_no_show', '38', now()),
(134, 0, 'booking_tpl_reservation_confirmed', '37', now()),
(135, 0, 'booking_tpl_reservation_requested', '36', now()),
(136, 0, 'cookie_theme_mode', 'light', now()),
(137, 0, 'cookie_position', 'bottom_right', now()),
(138, 0, 'cookie_expiration', '365', now()),
(139, 0, 'cookie_title', 'Cookie Consent', now()),
(140, 0, 'cookie_link_accept_button', 'Accept', now()),
(141, 0, 'cookie_link_reject_button', 'Decline', now()),
(142, 0, 'cookie_message', 'This website uses cookies or similar technologies, to enhance your browsing experience and provide personalized recommendations. By continuing to use our website, you agree to our {{privacy_policy_link}}', now()),
(143, 0, 'runactions_enabled', '1', now()),
(144, 0, 'menu_layout', 'left_image', now());


INSERT INTO `st_option` (`id`, `merchant_id`, `option_name`, `option_value`, `last_update`) VALUES
(34972, 0, 'driver_alert_time', '5', '2024-12-16 18:01:49'),
(34974, 0, 'driver_allowed_number_task', '2', '2024-12-16 18:01:49'),
(34976, 0, 'driver_map_enabled_cluster', '1', '2024-12-16 18:01:49'),
(34982, 0, 'driver_time_allowed_accept_order', '1', '2024-12-16 18:01:49'),
(34983, 0, 'driver_enabled_time_allowed_acceptance', '1', '2024-12-16 18:01:49'),
(34984, 0, 'driver_missed_order_tpl', '42', '2024-12-16 18:01:49'),
(34986, 0, 'driver_order_otp_tpl', '43', '2024-12-16 18:01:49'),
(34994, 0, 'driver_on_demand_availability', '1', '2024-12-16 18:01:49'),
(34996, 0, 'driver_auto_assign_retry', '1', '2024-12-16 18:01:49'),
(34997, 0, 'driver_assign_max_retry', '1', '2024-12-16 18:01:49'),
(35532, 0, 'driver_sendcode_via', 'email', '2024-12-30 23:12:19'),
(35534, 0, 'driver_sendcode_tpl', '32', '2024-12-30 23:12:19'),
(35535, 0, 'driver_signup_terms_condition', 'By clicking \"Submit,\" you agree to <a href=\"\" class=\"text-green\">Karenderia General Terms and Conditions</a>\r\n	     and acknowledge you have read the <a href=\"\" class=\"text-green\">Privacy Policy</a>.', '2024-12-30 23:12:19'),
(35536, 0, 'driver_employment_type', 'contractor', '2024-12-30 23:12:19'),
(35537, 0, 'driver_salary_type', 'delivery_fee', '2024-12-30 23:12:19'),
(35543, 0, 'driver_enabled_registration', '1', '2024-12-30 23:12:19');

-- --------------------------------------------------------

--
-- Table structure for table `st_ordernew`
--

CREATE TABLE `st_ordernew` (
  `order_id` int(11) NOT NULL,
  `order_uuid` varchar(100) NOT NULL DEFAULT '',
  `order_reference` varchar(100) NOT NULL DEFAULT '',
  `merchant_id` int(14) NOT NULL DEFAULT '0',
  `client_id` int(14) NOT NULL DEFAULT '0',
  `status` varchar(100) NOT NULL DEFAULT 'draft',
  `payment_status` varchar(100) NOT NULL DEFAULT 'unpaid',
  `delivery_status` varchar(100) NOT NULL DEFAULT 'unassigned',
  `flow_status` varchar(30) NOT NULL DEFAULT 'draft',
  `service_code` varchar(100) NOT NULL,
  `payment_code` varchar(100) NOT NULL,
  `total_discount` decimal(10,4) NOT NULL DEFAULT '0.0000',
  `points` decimal(10,4) NOT NULL DEFAULT '0.0000',
  `sub_total` decimal(10,4) NOT NULL DEFAULT '0.0000',
  `sub_total_less_discount` decimal(10,4) NOT NULL DEFAULT '0.0000',
  `service_fee` decimal(10,4) NOT NULL DEFAULT '0.0000',
  `small_order_fee` decimal(10,4) NOT NULL DEFAULT '0.0000',
  `delivery_fee` decimal(10,4) NOT NULL DEFAULT '0.0000',
  `packaging_fee` decimal(10,4) NOT NULL DEFAULT '0.0000',
  `card_fee` decimal(10,4) NOT NULL DEFAULT '0.0000',
  `tax_type` varchar(50) NOT NULL DEFAULT '',
  `tax` decimal(10,4) NOT NULL DEFAULT '0.0000',
  `tax_total` decimal(10,4) NOT NULL DEFAULT '0.0000',
  `courier_tip` decimal(10,4) NOT NULL DEFAULT '0.0000',
  `total` decimal(10,4) NOT NULL DEFAULT '0.0000',
  `amount_due` decimal(10,4) NOT NULL DEFAULT '0.0000',
  `wallet_amount` decimal(10,4) NOT NULL DEFAULT '0.0000',
  `promo_code` varchar(100) NOT NULL DEFAULT '',
  `promo_total` decimal(10,4) NOT NULL DEFAULT '0.0000',
  `promo_cap` decimal(10,2) NOT NULL DEFAULT '0.00',
  `promo_owner` varchar(50) NOT NULL DEFAULT 'admin',
  `offer_discount` varchar(100) NOT NULL DEFAULT '',
  `offer_total` decimal(10,4) NOT NULL DEFAULT '0.0000',
  `offer_cap` decimal(10,2) NOT NULL DEFAULT '0.00',
  `whento_deliver` varchar(100) NOT NULL DEFAULT '',
  `delivery_date` date DEFAULT NULL,
  `delivery_time` varchar(50) NOT NULL DEFAULT '',
  `delivery_date_time` datetime DEFAULT NULL,
  `delivery_time_end` varchar(50) NOT NULL DEFAULT '',
  `order_accepted_at` timestamp NULL DEFAULT NULL,
  `preparation_time_estimation` int(10) DEFAULT NULL,
  `pickup_time` timestamp NULL DEFAULT NULL,
  `delivery_time_estimation` int(10) DEFAULT NULL,
  `commission_type` varchar(100) NOT NULL DEFAULT '',
  `commission_value` decimal(10,4) NOT NULL DEFAULT '0.0000',
  `commission_based` varchar(100) NOT NULL DEFAULT '',
  `commission` decimal(10,4) NOT NULL DEFAULT '0.0000',
  `merchant_earning` decimal(10,4) NOT NULL DEFAULT '0.0000',
  `total_original` decimal(10,4) NOT NULL DEFAULT '0.0000',
  `commission_original` decimal(10,4) NOT NULL DEFAULT '0.0000',
  `merchant_earning_original` decimal(10,4) NOT NULL DEFAULT '0.0000',
  `adjustment_commission` decimal(10,4) NOT NULL DEFAULT '0.0000',
  `adjustment_total` decimal(10,4) NOT NULL DEFAULT '0.0000',
  `use_currency_code` varchar(5) NOT NULL DEFAULT '',
  `base_currency_code` varchar(5) NOT NULL DEFAULT '',
  `exchange_rate` decimal(10,4) NOT NULL DEFAULT '1.0000',
  `admin_base_currency` varchar(10) NOT NULL DEFAULT '',
  `exchange_rate_use_currency_to_admin` decimal(10,4) NOT NULL DEFAULT '1.0000',
  `exchange_rate_merchant_to_admin` decimal(10,4) NOT NULL DEFAULT '1.0000',
  `exchange_rate_admin_to_merchant` decimal(10,4) NOT NULL DEFAULT '1.0000',
  `formatted_address` varchar(255) NOT NULL DEFAULT '',
  `driver_id` bigint(20) NOT NULL DEFAULT '0',
  `vehicle_id` int(14) NOT NULL DEFAULT '0',
  `assigned_at` timestamp NULL DEFAULT NULL,
  `assigned_expired_at` datetime DEFAULT NULL,
  `date_cancelled` timestamp NULL DEFAULT NULL,
  `is_view` int(1) NOT NULL DEFAULT '0',
  `is_critical` int(1) NOT NULL DEFAULT '0',
  `earning_approve` int(1) NOT NULL DEFAULT '0',
  `delivered_at` datetime DEFAULT NULL,
  `request_from` varchar(50) NOT NULL DEFAULT 'web',
  `late_notification_sent` tinyint(1) NOT NULL DEFAULT '0',
  `preparation_late_sent` tinyint(1) NOT NULL DEFAULT '0',
  `delivering_late_sent` tinyint(1) NOT NULL DEFAULT '0',
  `retry_attempts` int(1) NOT NULL DEFAULT '0',
  `last_retry` timestamp NULL DEFAULT NULL,
  `auto_assign_status` varchar(50) NOT NULL DEFAULT 'pending',
  `date_created` datetime DEFAULT NULL,
  `created_at` date DEFAULT NULL,
  `date_modified` datetime DEFAULT NULL,
  `ip_address` varchar(50) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `st_ordernew_additional_charge`
--

CREATE TABLE `st_ordernew_additional_charge` (
  `id` int(14) NOT NULL,
  `order_id` int(14) NOT NULL DEFAULT '0',
  `item_row` varchar(100) NOT NULL DEFAULT '',
  `charge_name` varchar(200) NOT NULL DEFAULT '',
  `additional_charge` float(14,4) NOT NULL DEFAULT '0.0000'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `st_ordernew_addons`
--

CREATE TABLE `st_ordernew_addons` (
  `id` int(11) NOT NULL,
  `order_id` int(14) NOT NULL DEFAULT '0',
  `item_row` varchar(100) NOT NULL DEFAULT '',
  `subcat_id` int(14) NOT NULL DEFAULT '0',
  `sub_item_id` int(14) NOT NULL DEFAULT '0',
  `qty` int(14) NOT NULL DEFAULT '0',
  `price` float(14,4) NOT NULL DEFAULT '0.0000',
  `addons_total` float(14,4) NOT NULL DEFAULT '0.0000',
  `multi_option` varchar(100) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `st_ordernew_attributes`
--

CREATE TABLE `st_ordernew_attributes` (
  `id` int(11) NOT NULL,
  `order_id` int(14) NOT NULL DEFAULT '0',
  `item_row` varchar(100) NOT NULL DEFAULT '',
  `meta_name` varchar(255) NOT NULL DEFAULT '',
  `meta_value` varchar(255) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `st_ordernew_history`
--

CREATE TABLE `st_ordernew_history` (
  `id` bigint(20) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `order_id` int(14) NOT NULL DEFAULT '0',
  `status` varchar(255) NOT NULL DEFAULT '',
  `remarks` text,
  `ramarks_trans` text,
  `change_by` varchar(100) NOT NULL DEFAULT '',
  `latitude` varchar(100) NOT NULL DEFAULT '',
  `longitude` varchar(100) NOT NULL DEFAULT '',
  `ip_address` varchar(50) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `st_ordernew_item`
--

CREATE TABLE `st_ordernew_item` (
  `id` int(11) NOT NULL,
  `order_id` int(14) NOT NULL DEFAULT '0',
  `item_row` varchar(100) NOT NULL DEFAULT '',
  `cat_id` int(14) NOT NULL DEFAULT '0',
  `item_id` int(14) NOT NULL DEFAULT '0',
  `item_token` varchar(255) NOT NULL DEFAULT '',
  `item_size_id` int(14) NOT NULL DEFAULT '0',
  `qty` int(14) NOT NULL DEFAULT '0',
  `special_instructions` varchar(255) NOT NULL DEFAULT '',
  `if_sold_out` varchar(50) NOT NULL DEFAULT '',
  `price` float(14,5) NOT NULL DEFAULT '0.00000',
  `discount` float(14,5) NOT NULL DEFAULT '0.00000',
  `discount_type` varchar(100) NOT NULL DEFAULT '',
  `item_changes` varchar(100) NOT NULL DEFAULT '1',
  `item_changes_meta1` varchar(100) NOT NULL DEFAULT '',
  `tax_use` text,
  `is_free` tinyint(1) NOT NULL DEFAULT '0',
  `kot_status` varchar(100) NOT NULL DEFAULT 'pending',
  `voided_by` varchar(100) NOT NULL DEFAULT '',
  `voided_at` datetime DEFAULT NULL,
  `void_reason` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `st_ordernew_meta`
--

CREATE TABLE `st_ordernew_meta` (
  `meta_id` int(11) NOT NULL,
  `order_id` int(14) NOT NULL DEFAULT '0',
  `meta_name` varchar(255) NOT NULL DEFAULT '',
  `meta_value` longtext
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `st_ordernew_summary_transaction`
--

CREATE TABLE `st_ordernew_summary_transaction` (
  `transaction_id` bigint(20) NOT NULL,
  `transaction_uuid` varchar(50) NOT NULL DEFAULT '',
  `order_id` bigint(20) DEFAULT '0',
  `transaction_date` timestamp NULL DEFAULT NULL,
  `transaction_type` varchar(50) NOT NULL DEFAULT 'debit',
  `transaction_description` varchar(255) NOT NULL DEFAULT '',
  `transaction_description_parameters` varchar(255) NOT NULL DEFAULT '',
  `transaction_amount` float(14,4) NOT NULL DEFAULT '0.0000',
  `status` varchar(100) NOT NULL DEFAULT 'pending',
  `ip_address` varchar(50) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `st_ordernew_transaction`
--

CREATE TABLE `st_ordernew_transaction` (
  `transaction_id` int(11) NOT NULL,
  `transaction_uuid` varchar(50) NOT NULL DEFAULT '',
  `payment_uuid` varchar(50) DEFAULT '',
  `order_id` int(14) NOT NULL DEFAULT '0',
  `merchant_id` int(14) NOT NULL DEFAULT '0',
  `client_id` int(14) NOT NULL DEFAULT '0',
  `payment_code` varchar(100) NOT NULL DEFAULT '',
  `transaction_name` varchar(20) NOT NULL DEFAULT 'payment',
  `transaction_type` varchar(100) NOT NULL DEFAULT 'credit',
  `transaction_description` varchar(255) NOT NULL DEFAULT 'Payment',
  `trans_amount` float(14,4) NOT NULL DEFAULT '0.0000',
  `currency_code` varchar(5) NOT NULL DEFAULT '',
  `to_currency_code` varchar(10) NOT NULL DEFAULT '',
  `exchange_rate` decimal(10,4) NOT NULL DEFAULT '1.0000',
  `admin_base_currency` varchar(10) NOT NULL DEFAULT '',
  `exchange_rate_merchant_to_admin` decimal(10,4) NOT NULL DEFAULT '1.0000',
  `exchange_rate_admin_to_merchant` decimal(10,4) NOT NULL DEFAULT '1.0000',
  `payment_reference` varchar(255) NOT NULL DEFAULT '',
  `status` varchar(255) NOT NULL DEFAULT 'unpaid',
  `reason` text,
  `date_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `date_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ip_address` varchar(50) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `st_ordernew_trans_meta`
--

CREATE TABLE `st_ordernew_trans_meta` (
  `meta_id` int(11) NOT NULL,
  `transaction_id` int(14) NOT NULL DEFAULT '0',
  `order_id` int(14) NOT NULL DEFAULT '0',
  `meta_name` varchar(255) NOT NULL DEFAULT '',
  `meta_value` longtext,
  `meta_binary` binary(255) NOT NULL DEFAULT '\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `st_order_settings_buttons`
--

CREATE TABLE `st_order_settings_buttons` (
  `id` int(14) NOT NULL,
  `uuid` varchar(100) DEFAULT NULL,
  `group_name` varchar(100) NOT NULL DEFAULT '',
  `button_name` varchar(100) NOT NULL DEFAULT '',
  `class_name` varchar(100) DEFAULT 'btn-green',
  `stats_id` int(14) NOT NULL DEFAULT '0',
  `do_actions` varchar(100) NOT NULL DEFAULT '',
  `order_type` varchar(100) NOT NULL DEFAULT '',
  `date_created` datetime DEFAULT NULL,
  `date_modified` datetime DEFAULT NULL,
  `ip_address` varchar(50) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `st_order_settings_buttons`
--

INSERT INTO `st_order_settings_buttons` (`id`, `uuid`, `group_name`, `button_name`, `class_name`, `stats_id`, `do_actions`, `order_type`, `date_created`, `date_modified`, `ip_address`) VALUES
(1, 'b6dbed53-7f02-11ec-9bf7-9c5c8e164c2c', 'new_order', 'Accepted', 'btn-green', 24, '', '', '2022-01-27 07:50:17', '2022-01-29 15:51:14', '127.0.0.1'),
(2, 'bbdc9fee-7f02-11ec-9bf7-9c5c8e164c2c', 'new_order', 'Reject', 'btn-black', 16, 'reject_form', '', '2022-01-27 07:50:26', '2022-01-27 16:03:07', '127.0.0.1'),
(3, 'c6861876-7f02-11ec-9bf7-9c5c8e164c2c', 'order_processing', 'Ready for pickup', 'btn-green', 18, '', '', '2022-01-27 07:50:43', '2022-01-27 16:03:14', '127.0.0.1'),
(4, 'cea57e92-7f02-11ec-9bf7-9c5c8e164c2c', 'order_ready', 'Delivery on its way', 'btn-green', 21, '', 'delivery', '2022-01-27 07:50:57', '2022-01-27 16:03:19', '127.0.0.1'),
(5, 'd3c615ba-7f02-11ec-9bf7-9c5c8e164c2c', 'order_ready', 'Delivered', 'btn-yellow', 19, '', 'delivery', '2022-01-27 07:51:06', '2022-01-27 16:03:30', '127.0.0.1'),
(6, 'd83d3544-7f02-11ec-9bf7-9c5c8e164c2c', 'order_ready', 'Delivery Failed', 'btn-black', 23, '', 'delivery', '2022-01-27 07:51:13', '2022-01-27 16:03:35', '127.0.0.1'),
(7, 'dd882377-7f02-11ec-9bf7-9c5c8e164c2c', 'order_ready', 'Complete', 'btn-green', 26, '', 'pickup', '2022-01-27 07:51:22', '2022-01-27 16:03:49', '127.0.0.1'),
(8, 'ead61c30-7f02-11ec-9bf7-9c5c8e164c2c', 'order_ready', 'Order failed', 'btn-black', 16, '', 'pickup', '2022-01-27 07:51:44', '2022-01-27 16:03:58', '127.0.0.1'),
(9, '17b16356-7f03-11ec-9bf7-9c5c8e164c2c', 'order_ready', 'Complete', 'btn-green', 26, '', 'dinein', '2022-01-27 07:53:00', '2022-01-27 16:04:03', '127.0.0.1'),
(10, '2156afbe-7f03-11ec-9bf7-9c5c8e164c2c', 'order_ready', 'Order failed', 'btn-black', 16, '', 'dinein', '2022-01-27 07:53:16', '2022-01-27 16:04:13', '127.0.0.1');

-- --------------------------------------------------------

--
-- Table structure for table `st_order_settings_tabs`
--

CREATE TABLE `st_order_settings_tabs` (
  `id` int(14) NOT NULL,
  `group_name` varchar(100) NOT NULL DEFAULT 'new_order',
  `stats_id` int(14) NOT NULL DEFAULT '0',
  `date_modified` datetime DEFAULT NULL,
  `ip_address` varchar(50) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `st_order_settings_tabs`
--

INSERT INTO `st_order_settings_tabs` (`id`, `group_name`, `stats_id`, `date_modified`, `ip_address`) VALUES
(49, 'order_processing', 24, '2022-07-22 21:46:09', '127.0.0.1'),
(50, 'completed_today', 26, '2022-07-22 21:46:42', '127.0.0.1'),
(51, 'completed_today', 19, '2022-07-22 21:46:42', '127.0.0.1'),
(52, 'order_ready', 21, '2022-07-22 21:46:50', '127.0.0.1'),
(53, 'order_ready', 18, '2022-07-22 21:46:50', '127.0.0.1'),
(72, 'assigned', 32, '2022-08-04 21:35:36', '127.0.0.1'),
(73, 'assigned', 30, '2022-08-04 21:35:36', '127.0.0.1'),
(74, 'assigned', 31, '2022-08-04 21:35:36', '127.0.0.1'),
(75, 'assigned', 34, '2022-08-04 21:35:36', '127.0.0.1'),
(76, 'assigned', 35, '2022-08-04 21:35:36', '127.0.0.1'),
(77, 'assigned', 33, '2022-08-04 21:35:36', '127.0.0.1'),
(78, 'assigned', 28, '2022-08-04 21:35:36', '127.0.0.1'),
(79, 'assigned', 29, '2022-08-04 21:35:36', '127.0.0.1'),
(80, 'completed', 39, '2022-08-05 18:32:20', '127.0.0.1'),
(81, 'completed', 37, '2022-08-05 18:32:20', '127.0.0.1'),
(83, 'unassigned', 38, '2023-02-21 19:12:57', '127.0.0.1'),
(84, 'unassigned', 36, '2023-02-21 19:12:57', '127.0.0.1'),
(87, 'new_order', 13, '2024-06-28 08:44:39', '127.0.0.1');

-- --------------------------------------------------------

--
-- Table structure for table `st_order_status`
--

CREATE TABLE `st_order_status` (
  `stats_id` int(14) NOT NULL,
  `group_name` varchar(100) NOT NULL DEFAULT 'order_status',
  `merchant_id` int(14) NOT NULL DEFAULT '0',
  `description` varchar(200) NOT NULL DEFAULT '',
  `font_color_hex` varchar(10) NOT NULL DEFAULT '',
  `background_color_hex` varchar(10) NOT NULL DEFAULT '',
  `date_created` date DEFAULT NULL,
  `date_modified` date DEFAULT NULL,
  `ip_address` varchar(50) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `st_order_status`
--

INSERT INTO `st_order_status` (`stats_id`, `group_name`, `merchant_id`, `description`, `font_color_hex`, `background_color_hex`, `date_created`, `date_modified`, `ip_address`) VALUES
(13, 'order_status', 0, 'new', 'black', '#d4ecdc', '2021-10-11', '2023-05-17', '127.0.0.1'),
(16, 'order_status', 0, 'rejected', 'white', '#ea9895', '2021-10-31', '2022-01-26', '127.0.0.1'),
(18, 'order_status', 0, 'ready for pickup', 'black', '#efe5ee', '2021-11-01', '2023-10-25', '127.0.0.1'),
(19, 'order_status', 0, 'delivered', 'white', '#3ecf8e', '2021-11-01', '2023-10-13', '127.0.0.1'),
(20, 'order_status', 0, 'cancelled', 'white', '#f44336', '2021-11-01', '2022-01-26', '127.0.0.1'),
(21, 'order_status', 0, 'delivery on its way', 'black', '#fbd7af', '2021-11-01', '2022-01-26', '127.0.0.1'),
(22, 'order_status', 0, 'delayed', '#5b5b5b', '#cfe2f3', '2021-11-01', '2022-01-26', '127.0.0.1'),
(23, 'order_status', 0, 'delivery failed', 'white', '#d34f45', '2021-11-01', '2022-01-26', '127.0.0.1'),
(24, 'order_status', 0, 'accepted', 'white', '#f8af01', '2021-11-01', '2023-10-25', '127.0.0.1'),
(25, 'order_status', 0, 'delayed', 'white', '#b6d7a8', '2021-11-03', '2022-01-26', '127.0.0.1'),
(26, 'order_status', 0, 'complete', '#f3f6f4', '#8fce00', '2021-12-16', '2023-10-25', '127.0.0.1'),
(28, 'delivery_status', 0, 'assigned', 'white', '#ffa726', '2022-07-13', '2022-07-22', '127.0.0.1'),
(29, 'delivery_status', 0, 'acknowledged', 'white', '#f8af01', '2022-07-13', '2022-09-02', '127.0.0.1'),
(30, 'delivery_status', 0, 'on the way to restaurant', 'white', '#8fce00', '2022-07-13', '2022-09-02', '127.0.0.1'),
(31, 'delivery_status', 0, 'arrived at restaurant', 'white', '#ea9999', '2022-07-13', '2023-05-16', '127.0.0.1'),
(32, 'delivery_status', 0, 'waiting for order', '#5b5b5b', '#8fce00', '2022-07-13', '2022-09-02', '127.0.0.1'),
(33, 'delivery_status', 0, 'order pickup', 'white', '#8e7cc3', '2022-07-13', '2022-09-02', '127.0.0.1'),
(34, 'delivery_status', 0, 'delivery started', 'white', '#c90076', '2022-07-13', '2022-09-02', '127.0.0.1'),
(35, 'delivery_status', 0, 'arrived at customer', 'white', '#3d85c6', '2022-07-13', '2022-09-02', '127.0.0.1'),
(36, 'delivery_status', 0, 'unassigned', 'white', '#78909c', '2022-07-13', '2022-07-22', '127.0.0.1'),
(37, 'delivery_status', 0, 'delivered', 'white', '#3ecf8e', '2022-07-15', '2022-07-22', '127.0.0.1'),
(38, 'delivery_status', 0, 'declined', 'white', '#f11707', '2022-07-15', '2023-02-22', '127.0.0.1'),
(39, 'delivery_status', 0, 'failed', '#999999', '#dc1e10', '2022-07-15', '2023-02-22', '127.0.0.1'),
(40, 'delivery_status', 0, 'cancelled', 'white', '#f44336', '2023-02-28', NULL, '127.0.0.1');

-- --------------------------------------------------------

--
-- Table structure for table `st_order_status_actions`
--

CREATE TABLE `st_order_status_actions` (
  `action_id` bigint(20) NOT NULL,
  `stats_id` bigint(20) NOT NULL DEFAULT '0',
  `action_type` varchar(50) NOT NULL DEFAULT '',
  `action_value` varchar(100) NOT NULL DEFAULT '',
  `date_created` timestamp NULL DEFAULT NULL,
  `date_modified` timestamp NULL DEFAULT NULL,
  `ip_address` varchar(50) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `st_order_status_actions`
--

INSERT INTO `st_order_status_actions` (`action_id`, `stats_id`, `action_type`, `action_value`, `date_created`, `date_modified`, `ip_address`) VALUES
(1, 13, 'notification_to_customer', '4', '2022-01-27 00:07:12', NULL, '127.0.0.1'),
(2, 13, 'notification_to_merchant', '5', '2022-01-27 00:07:22', NULL, '127.0.0.1'),
(3, 13, 'notification_to_admin', '5', '2022-01-27 00:07:31', NULL, '127.0.0.1'),
(4, 16, 'notification_to_customer', '6', '2022-01-27 00:08:48', NULL, '127.0.0.1'),
(5, 19, 'notification_to_customer', '22', '2022-01-27 00:09:14', NULL, '127.0.0.1'),
(6, 20, 'notification_to_customer', '7', '2022-01-27 00:09:37', NULL, '127.0.0.1'),
(7, 20, 'notification_to_merchant', '20', '2022-01-27 00:09:47', NULL, '127.0.0.1'),
(8, 20, 'notification_to_admin', '20', '2022-01-27 00:09:55', NULL, '127.0.0.1'),
(9, 21, 'notification_to_customer', '21', '2022-01-27 00:10:22', NULL, '127.0.0.1'),
(10, 23, 'notification_to_customer', '23', '2022-01-27 00:10:51', NULL, '127.0.0.1'),
(11, 24, 'notification_to_customer', '9', '2022-01-27 00:11:09', NULL, '127.0.0.1'),
(13, 29, 'notification_to_admin', '30', '2022-08-04 11:48:41', NULL, '127.0.0.1'),
(14, 30, 'notification_to_admin', '31', '2022-08-04 13:15:12', NULL, '127.0.0.1'),
(15, 37, 'notification_to_admin', '33', '2022-08-27 14:35:44', NULL, '127.0.0.1'),
(16, 38, 'notification_to_admin', '33', '2022-08-31 13:12:28', NULL, '127.0.0.1'),
(17, 39, 'notification_to_admin', '33', '2022-08-31 13:12:41', NULL, '127.0.0.1'),
(18, 31, 'notification_to_admin', '40', '2023-02-04 11:53:43', NULL, '127.0.0.1'),
(19, 33, 'notification_to_admin', '41', '2023-02-04 11:55:03', NULL, '127.0.0.1'),
(20, 28, 'notification_to_driver', '44', '2023-02-15 12:08:54', NULL, '127.0.0.1'),
(21, 18, 'notification_to_driver', '45', '2023-02-15 14:05:30', '2023-02-15 14:06:49', '127.0.0.1'),
(23, 26, 'notification_to_customer', '9', '2024-04-18 07:44:25', NULL, '127.0.0.1'),
(24, 28, 'notification_to_admin', '46', '2024-08-10 00:41:48', NULL, '127.0.0.1');

-- --------------------------------------------------------

--
-- Table structure for table `st_order_status_translation`
--

CREATE TABLE `st_order_status_translation` (
  `id` int(11) NOT NULL,
  `stats_id` int(1) NOT NULL DEFAULT '0',
  `language` varchar(100) NOT NULL DEFAULT '',
  `description` varchar(255) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `st_order_status_translation`
--

INSERT INTO `st_order_status_translation` (`id`, `stats_id`, `language`, `description`) VALUES
(7, 25, 'ja', ''),
(8, 25, 'ar', ''),
(9, 25, 'en', 'delayed'),
(13, 23, 'ja', ''),
(14, 23, 'ar', ''),
(15, 23, 'en', 'delivery failed'),
(16, 22, 'ja', ''),
(17, 22, 'ar', ''),
(18, 22, 'en', 'delayed'),
(19, 21, 'ja', ''),
(20, 21, 'ar', ''),
(21, 21, 'en', 'delivery on its way'),
(22, 20, 'ja', ''),
(23, 20, 'ar', ''),
(24, 20, 'en', 'cancelled'),
(31, 16, 'ja', ''),
(32, 16, 'ar', ''),
(33, 16, 'en', 'rejected'),
(129, 28, 'ar', ''),
(130, 28, 'pt_br', ''),
(131, 28, 'ja', ''),
(132, 28, 'fr', ''),
(133, 28, 'en', 'assigned'),
(139, 37, 'ar', ''),
(140, 37, 'pt_br', ''),
(141, 37, 'ja', ''),
(142, 37, 'fr', ''),
(143, 37, 'en', 'delivered'),
(149, 36, 'ar', ''),
(150, 36, 'pt_br', ''),
(151, 36, 'ja', ''),
(152, 36, 'fr', ''),
(153, 36, 'en', 'unassigned'),
(179, 29, 'ar', ''),
(180, 29, 'pt_br', ''),
(181, 29, 'ja', ''),
(182, 29, 'fr', ''),
(183, 29, 'en', 'acknowledged'),
(184, 32, 'ar', ''),
(185, 32, 'pt_br', ''),
(186, 32, 'ja', ''),
(187, 32, 'fr', ''),
(188, 32, 'en', 'waiting for order'),
(194, 30, 'ar', ''),
(195, 30, 'pt_br', ''),
(196, 30, 'ja', ''),
(197, 30, 'fr', ''),
(198, 30, 'en', 'on the way to restaurant'),
(199, 33, 'ar', ''),
(200, 33, 'pt_br', ''),
(201, 33, 'ja', ''),
(202, 33, 'fr', ''),
(203, 33, 'en', 'order pickup'),
(204, 34, 'ar', ''),
(205, 34, 'pt_br', ''),
(206, 34, 'ja', ''),
(207, 34, 'fr', ''),
(208, 34, 'en', 'delivery started'),
(209, 35, 'ar', ''),
(210, 35, 'pt_br', ''),
(211, 35, 'ja', ''),
(212, 35, 'fr', ''),
(213, 35, 'en', 'arrived at customer'),
(219, 38, 'ar', ''),
(220, 38, 'pt_br', ''),
(221, 38, 'ja', ''),
(222, 38, 'fr', ''),
(223, 38, 'en', 'declined'),
(229, 39, 'ar', ''),
(230, 39, 'pt_br', ''),
(231, 39, 'ja', ''),
(232, 39, 'fr', ''),
(233, 39, 'en', 'failed'),
(234, 40, 'ar', ''),
(235, 40, 'pt_br', ''),
(236, 40, 'ja', ''),
(237, 40, 'fr', ''),
(238, 40, 'en', 'cancelled'),
(244, 31, 'ar', 'وصل إلى المطعم'),
(245, 31, 'pt_br', 'chegou ao restaurante'),
(246, 31, 'ja', 'レストランに到着しました'),
(247, 31, 'fr', 'arrivé au resto'),
(248, 31, 'en', 'arrived at restaurant'),
(249, 13, 'ar', 'جديد'),
(250, 13, 'pt_br', 'nova'),
(251, 13, 'ja', '新着'),
(252, 13, 'fr', ''),
(253, 13, 'en', 'new'),
(254, 19, 'de', ''),
(255, 19, 'ar', ''),
(256, 19, 'pt_br', ''),
(257, 19, 'ja', '配達されました'),
(258, 19, 'en', 'delivered'),
(259, 24, 'de', ''),
(260, 24, 'ar', ''),
(261, 24, 'pt_br', ''),
(262, 24, 'ja', '受け入れられました'),
(263, 24, 'en', 'accepted'),
(264, 18, 'de', ''),
(265, 18, 'ar', ''),
(266, 18, 'pt_br', ''),
(267, 18, 'ja', 'ピックアップの準備ができて'),
(268, 18, 'en', 'ready for pickup'),
(269, 26, 'de', ''),
(270, 26, 'ar', ''),
(271, 26, 'pt_br', ''),
(272, 26, 'ja', '完了'),
(273, 26, 'en', 'complete');


-- --------------------------------------------------------

--
-- Table structure for table `st_order_time_management`
--

CREATE TABLE `st_order_time_management` (
  `id` int(11) NOT NULL,
  `group_id` int(14) NOT NULL DEFAULT '0',
  `merchant_id` int(14) NOT NULL DEFAULT '0',
  `transaction_type` varchar(100) NOT NULL DEFAULT '',
  `days` varchar(200) NOT NULL DEFAULT '',
  `start_time` varchar(5) NOT NULL DEFAULT '',
  `end_time` varchar(5) NOT NULL DEFAULT '',
  `number_order_allowed` int(14) NOT NULL DEFAULT '0',
  `order_status` text,
  `status` varchar(255) NOT NULL DEFAULT 'publish'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `st_package_details`
--

CREATE TABLE `st_package_details` (
  `id` int(14) NOT NULL,
  `package_id` int(14) NOT NULL DEFAULT '0',
  `description` text,
  `date_modified` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `st_pages`
--

CREATE TABLE `st_pages` (
  `page_id` int(11) NOT NULL,
  `owner` varchar(50) NOT NULL DEFAULT 'admin',
  `merchant_id` int(10) NOT NULL DEFAULT '0',
  `page_type` varchar(255) NOT NULL DEFAULT 'page',
  `slug` varchar(255) NOT NULL DEFAULT '',
  `title` varchar(255) NOT NULL DEFAULT '',
  `long_content` mediumtext,
  `short_content` varchar(255) NOT NULL DEFAULT '',
  `meta_title` varchar(255) NOT NULL DEFAULT '',
  `meta_description` text,
  `meta_keywords` text,
  `meta_image` varchar(255) NOT NULL DEFAULT '',
  `path` varchar(255) NOT NULL DEFAULT '',
  `status` varchar(255) NOT NULL DEFAULT 'publish',
  `date_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `date_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ip_address` varchar(50) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `st_pages`
--

INSERT INTO `st_pages` (`page_id`, `page_type`, `slug`, `title`, `long_content`, `short_content`, `meta_title`, `meta_description`, `meta_keywords`, `meta_image`, `path`, `status`, `date_created`, `date_modified`, `ip_address`) VALUES
(1, 'page', 'terms-and-conditions', 'Terms and conditions', '<div>\r\n<p>\r\nLorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam id \r\nsapien massa. Sed porta interdum nulla sed accumsan. Proin lacinia vel \r\nnulla eget porttitor. In varius vehicula facilisis. Maecenas non \r\nvehicula massa. Maecenas vel eros nec ante rutrum fringilla vel sit amet\r\n ipsum. Sed ut tellus nisl. Aenean vehicula, diam nec sollicitudin \r\nporttitor, purus augue mattis risus, porta elementum augue nibh eget \r\nsapien. Fusce a efficitur ipsum. In urna mi, ullamcorper ut ultrices sit\r\n amet, faucibus et risus. Maecenas vestibulum molestie ex.\r\n</p>\r\n<p>\r\nMaecenas ut lectus eget ante faucibus tristique. In sodales turpis orci,\r\n quis commodo lectus feugiat quis. Aliquam varius metus diam, id luctus \r\neros sagittis vel. Nulla facilisi. Suspendisse mollis eros lacus, at \r\nmaximus enim imperdiet quis. Nulla eget diam ac diam condimentum \r\nelementum. Ut at ipsum vitae ipsum ullamcorper vestibulum. Aliquam \r\neuismod enim vitae blandit tristique.\r\n</p>\r\n<p>\r\nVestibulum malesuada, diam sit amet tristique finibus, sem lacus \r\nelementum diam, et semper ipsum odio eu quam. Sed hendrerit tincidunt \r\neuismod. Aliquam finibus quis elit at sollicitudin. In at magna euismod,\r\n tincidunt lectus sed, posuere dui. Curabitur congue ante non ligula \r\nsagittis, non blandit metus consectetur. Nunc nisi purus, ultrices in \r\nodio quis, mattis condimentum quam. Nullam vestibulum ex et erat \r\nvolutpat hendrerit. Vestibulum luctus quam vestibulum mollis euismod. \r\nEtiam efficitur mauris vel mi pretium iaculis. Donec sed erat tincidunt,\r\n elementum sem in, consectetur ipsum. Nulla pellentesque porta sapien, \r\neu venenatis justo vulputate vitae. Nunc et finibus ex, non finibus \r\nmassa. Nulla non turpis rutrum, molestie dui id, pharetra massa.\r\n</p>\r\n<p>\r\nDuis a arcu quis quam sodales dapibus. Curabitur consectetur sit amet \r\ndiam sed consectetur. Sed facilisis ultricies odio, nec sagittis enim \r\nlacinia non. Maecenas non congue est, sed condimentum mi. Cras a \r\nporttitor libero. Praesent massa risus, sollicitudin eget accumsan \r\nelementum, ornare nec felis. Vestibulum porttitor imperdiet rhoncus. \r\nMauris consequat fermentum metus feugiat facilisis. Sed eleifend mollis \r\nmattis. Nunc imperdiet lectus non quam ullamcorper, at ultrices ante \r\ncongue. Etiam aliquam arcu felis. Class aptent taciti sociosqu ad litora\r\n torquent per conubia nostra, per inceptos himenaeos. Nulla consequat, \r\nturpis sit amet pharetra elementum, quam lacus placerat sapien, at \r\nsagittis nunc erat in sem. Nulla sed aliquet neque, a tempor leo. \r\nAliquam erat volutpat. Sed tempor libero neque, condimentum feugiat \r\ndolor lobortis in.\r\n</p>\r\n<p>\r\nFusce convallis quis augue vitae scelerisque. Sed auctor lectus a odio \r\neleifend, eget auctor enim vestibulum. Integer neque urna, eleifend in \r\nporta a, vehicula et risus. Vestibulum vehicula placerat ante sed \r\nlaoreet. Integer varius felis a magna tempor, a efficitur ex fringilla. \r\nDonec in diam a diam placerat luctus et nec nisi. Sed efficitur lacus \r\nfelis, vitae rutrum nibh eleifend in.\r\n</p></div>', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam id sapien massa. Sed porta interdum nulla sed accumsan. Proin lacinia vel nulla eget porttitor. In varius vehicula facilisis.', '', '', '', '', '', 'publish', '2022-01-27 08:03:58', '2022-01-27 08:03:58', '127.0.0.1'),
(2, 'page', 'privacy-policy', 'Privacy policy', '<div>\r\n<p>\r\nLorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam id \r\nsapien massa. Sed porta interdum nulla sed accumsan. Proin lacinia vel \r\nnulla eget porttitor. In varius vehicula facilisis. Maecenas non \r\nvehicula massa. Maecenas vel eros nec ante rutrum fringilla vel sit amet\r\n ipsum. Sed ut tellus nisl. Aenean vehicula, diam nec sollicitudin \r\nporttitor, purus augue mattis risus, porta elementum augue nibh eget \r\nsapien. Fusce a efficitur ipsum. In urna mi, ullamcorper ut ultrices sit\r\n amet, faucibus et risus. Maecenas vestibulum molestie ex.\r\n</p>\r\n<p>\r\nMaecenas ut lectus eget ante faucibus tristique. In sodales turpis orci,\r\n quis commodo lectus feugiat quis. Aliquam varius metus diam, id luctus \r\neros sagittis vel. Nulla facilisi. Suspendisse mollis eros lacus, at \r\nmaximus enim imperdiet quis. Nulla eget diam ac diam condimentum \r\nelementum. Ut at ipsum vitae ipsum ullamcorper vestibulum. Aliquam \r\neuismod enim vitae blandit tristique.\r\n</p>\r\n<p>\r\nVestibulum malesuada, diam sit amet tristique finibus, sem lacus \r\nelementum diam, et semper ipsum odio eu quam. Sed hendrerit tincidunt \r\neuismod. Aliquam finibus quis elit at sollicitudin. In at magna euismod,\r\n tincidunt lectus sed, posuere dui. Curabitur congue ante non ligula \r\nsagittis, non blandit metus consectetur. Nunc nisi purus, ultrices in \r\nodio quis, mattis condimentum quam. Nullam vestibulum ex et erat \r\nvolutpat hendrerit. Vestibulum luctus quam vestibulum mollis euismod. \r\nEtiam efficitur mauris vel mi pretium iaculis. Donec sed erat tincidunt,\r\n elementum sem in, consectetur ipsum. Nulla pellentesque porta sapien, \r\neu venenatis justo vulputate vitae. Nunc et finibus ex, non finibus \r\nmassa. Nulla non turpis rutrum, molestie dui id, pharetra massa.\r\n</p>\r\n<p>\r\nDuis a arcu quis quam sodales dapibus. Curabitur consectetur sit amet \r\ndiam sed consectetur. Sed facilisis ultricies odio, nec sagittis enim \r\nlacinia non. Maecenas non congue est, sed condimentum mi. Cras a \r\nporttitor libero. Praesent massa risus, sollicitudin eget accumsan \r\nelementum, ornare nec felis. Vestibulum porttitor imperdiet rhoncus. \r\nMauris consequat fermentum metus feugiat facilisis. Sed eleifend mollis \r\nmattis. Nunc imperdiet lectus non quam ullamcorper, at ultrices ante \r\ncongue. Etiam aliquam arcu felis. Class aptent taciti sociosqu ad litora\r\n torquent per conubia nostra, per inceptos himenaeos. Nulla consequat, \r\nturpis sit amet pharetra elementum, quam lacus placerat sapien, at \r\nsagittis nunc erat in sem. Nulla sed aliquet neque, a tempor leo. \r\nAliquam erat volutpat. Sed tempor libero neque, condimentum feugiat \r\ndolor lobortis in.\r\n</p>\r\n<p>\r\nFusce convallis quis augue vitae scelerisque. Sed auctor lectus a odio \r\neleifend, eget auctor enim vestibulum. Integer neque urna, eleifend in \r\nporta a, vehicula et risus. Vestibulum vehicula placerat ante sed \r\nlaoreet. Integer varius felis a magna tempor, a efficitur ex fringilla. \r\nDonec in diam a diam placerat luctus et nec nisi. Sed efficitur lacus \r\nfelis, vitae rutrum nibh eleifend in.\r\n</p></div>', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam id sapien massa. Sed porta interdum nulla sed accumsan. Proin lacinia vel nulla eget porttitor. In varius vehicula facilisis. ', '', '', '', '', '', 'publish', '2022-01-27 08:05:00', '2022-01-27 08:05:00', '127.0.0.1');

INSERT INTO `st_pages` (`page_id`, `owner`, `merchant_id`, `page_type`, `slug`, `title`, `long_content`, `short_content`, `meta_title`, `meta_description`, `meta_keywords`, `meta_image`, `path`, `status`, `date_created`, `date_modified`, `ip_address`) VALUES
(41, 'seo', 0, 'page', 'stay-in-the-know-track-your-favorite-restaurants-latest-updates-and-specials', 'Tracking order', NULL, '', 'Stay in the Know: Track Your Favorite Restaurant\'s Latest Updates and Specials!', 'Welcome to our Restaurant Tracking Page! Stay informed and never miss a beat with the latest updates from your favorite dining establishments. Track new menu additions, seasonal specials, promotions, and events happening at the restaurants you love. Our comprehensive tracking system ensures you\'re always in the loop, allowing you to plan your culinary adventures with ease. Discover the freshest flavors, follow the trends, and satisfy your cravings by staying connected to the pulse of the restaurant scene. Start tracking today and never miss out on the exciting happenings at your go-to restaurants!', '', '', '', 'publish', '2023-06-15 23:34:56', '2023-06-15 23:34:56', '127.0.0.1'),
(40, 'seo', 0, 'page', 'take-control-of-your-reservations-manage-restaurant-table-bookings', 'Manage table booking', NULL, '', 'Take Control of Your Reservations: Manage Restaurant Table Bookings', 'Empower yourself with the ability to effortlessly manage your restaurant table bookings. With our intuitive management system, you can easily view, modify, and cancel your reservations. Keep track of your upcoming dining plans, make adjustments as needed, and ensure a smooth and seamless experience. Take control of your restaurant bookings and enjoy the convenience of managing your table reservations with ease. Enhance your dining journey with our efficient table booking management feature.', '', '', '', 'publish', '2023-06-15 19:07:59', '2023-06-15 19:07:59', '127.0.0.1'),
(39, 'seo', 0, 'page', 'reserve-your-table-effortless-restaurant-table-booking', 'Table booking', NULL, '', 'Reserve Your Table: Effortless Restaurant Table Booking', 'Secure your dining experience with ease through our hassle-free restaurant table booking. Reserve your preferred table in advance, ensuring a seamless and enjoyable dining occasion. Whether it\'s for a romantic dinner, a family gathering, or a business meeting, our convenient booking process allows you to select the date, time, and party size effortlessly. Experience personalized hospitality and guarantee your spot at our restaurant by making a reservation today. Unlock exceptional dining moments with our effortless table booking service.', '', '', '', 'publish', '2023-06-15 19:07:18', '2023-06-15 19:07:18', '127.0.0.1'),
(38, 'seo', 0, 'page', 'simplified-dining-experience-guest-checkout-at-our-restaurant', 'Guest checkout', NULL, '', 'Simplified Dining Experience: Guest Checkout at Our Restaurant', 'Indulge in a hassle-free dining experience with our guest checkout option at the restaurant. No account creation required! Seamlessly proceed through the checkout process, review your order details, and securely complete your payment as a guest. Whether you\'re a first-time visitor or prefer to skip the account setup, our streamlined guest checkout page ensures a smooth and efficient transaction. Enjoy the convenience and ease of a simplified dining experience, tailored for guests like you.', '', '', '', 'publish', '2023-06-15 19:06:03', '2023-06-15 19:06:03', '127.0.0.1'),
(37, 'seo', 0, 'page', 'effortless-dining-experience-streamlined-checkout-at-our-restaurant', 'Checkout', NULL, '', 'Effortless Dining Experience: Streamlined Checkout at Our Restaurant', 'Enjoy a seamless and hassle-free checkout experience at our restaurant. Our user-friendly checkout page ensures a smooth transaction process, allowing you to review your order, make any necessary modifications, and securely complete your payment. With convenient options for delivery or pickup, you can finalize your dining experience with ease. Experience efficiency and satisfaction as you navigate our optimized restaurant checkout page, making your journey from selection to satisfaction a breeze.', '', '', '', 'publish', '2023-06-15 19:05:04', '2023-06-15 19:05:04', '127.0.0.1'),
(36, 'seo', 0, 'page', 'join-the-culinary-experience-sign-up-for-a-memorable-restaurant-account', 'Restaurant signup', NULL, '', 'Join the Culinary Experience: Sign Up for a Memorable Restaurant Account', 'Embark on a delightful culinary journey by signing up for a restaurant account. Unlock exclusive benefits, personalized recommendations, and seamless online ordering. Experience the convenience of managing reservations, accessing loyalty programs, and receiving updates on special promotions. Join today and indulge in a memorable dining experience tailored to your preferences. Start your gastronomic adventure with our easy restaurant signup process.', '', '', '', 'publish', '2023-06-15 19:04:07', '2023-06-15 19:04:07', '127.0.0.1'),
(35, 'seo', 0, 'page', 'personalized-favorites-store-and-access-your-accounts-preferred-selections', 'User saved store', NULL, '', 'Personalized Favorites: Store and Access Your Account\'s Preferred Selections', 'Make your online experience truly tailored to your preferences by utilizing our account\'s \'Store Favorites\' feature. Save your favorite items, products, or content to easily access them whenever you visit our website. Whether it\'s for shopping, browsing, or entertainment, enjoy the convenience of having your preferred selections readily available at your fingertips. Enhance your user experience and discover the power of personalized favorites with our account\'s intuitive feature.', '', '', '', 'publish', '2023-06-15 19:02:51', '2023-06-15 19:02:51', '127.0.0.1'),
(34, 'seo', 0, 'page', 'secure-and-convenient-manage-saved-payment-methods-in-your-account', 'User saved payments', NULL, '', 'Secure and Convenient: Manage Saved Payment Methods in Your Account', 'Experience hassle-free transactions with our account\'s saved payment feature. Safely store your preferred payment methods for quick and secure checkouts. Enjoy the convenience of managing and updating your saved payment options, providing you with a seamless and efficient payment experience. Simplify your online transactions and enjoy peace of mind with our reliable and secure account saved payment feature.', '', '', '', 'publish', '2023-06-15 19:01:57', '2023-06-15 19:01:57', '127.0.0.1'),
(33, 'seo', 0, 'page', 'effortless-address-management-save-and-update-your-accounts-address', 'User address', NULL, '', 'Effortless Address Management: Save and Update Your Account\'s Address', 'Simplify your address management with our account feature that allows you to save and update your addresses effortlessly. Whether it\'s for shipping, billing, or personal preferences, easily store multiple addresses and conveniently select them during checkout. Experience convenience and efficiency as you streamline your account\'s address information to enhance your online experience.', '', '', '', 'publish', '2023-06-15 19:01:00', '2023-06-15 19:01:00', '127.0.0.1'),
(32, 'seo', 0, 'page', 'manage-your-orders-convenient-access-to-your-restaurant-accounts-order-list', 'User Orders', NULL, '', 'Manage Your Orders: Convenient Access to Your Restaurant Account\'s Order List', 'Easily track and manage your restaurant orders with our user-friendly account interface. Stay organized and informed with instant access to your order list, allowing you to review, modify, and monitor the status of your past and current orders. Streamline your dining experience and enjoy seamless control over your restaurant account\'s order history.', '', '', '', 'publish', '2023-06-15 18:58:09', '2023-06-15 18:59:08', '127.0.0.1'),
(31, 'seo', 0, 'page', 'secure-your-account-change-password-for-enhanced-online-security', 'Change password', NULL, '', 'Secure Your Account: Change Password for Enhanced Online Security', 'Boost your account security with a password change on our website. Safeguard your personal information and enjoy peace of mind knowing your account is protected. Follow our simple steps to update your password and fortify your online presence today.', '', '', '', 'publish', '2023-06-15 18:56:26', '2023-06-15 18:56:26', '127.0.0.1'),
(30, 'seo', 0, 'page', 'effortlessly-manage-your-account-profile-with-our-user-friendly-platform-sign-up-today', 'Manage account', NULL, '', 'Effortlessly Manage Your Account Profile with Our User-Friendly Platform - Sign Up Today!', 'Effortlessly manage your account profile with our user-friendly platform. Update your personal information, track your orders, and enjoy a seamless dining experience at our multiple restaurant karenderia.', '', '', '', 'publish', '2023-06-15 18:50:57', '2023-06-15 18:54:15', '127.0.0.1'),
(29, 'seo', 0, 'page', 'join-our-restaurant-network-and-expand-your-reach-signup-today', 'Signup page', NULL, '', 'Join Our Restaurant Network and Expand Your Reach - Signup Today!', 'Looking to expand your restaurant\'s online presence? Sign up with our multiple restaurant Karenderia platform and showcase your delicious cuisine to a wider audience. Our user-friendly interface and powerful marketing tools make it easy to manage your onl', '', '', '', 'publish', '2023-06-15 18:48:23', '2023-06-15 18:48:23', '127.0.0.1'),
(28, 'seo', 0, 'page', 'login-to-your-restaurant-account-manage-your-menu-and-orders-with-ease', 'Login', NULL, '', 'Login to Your Restaurant Account - Manage Your Menu and Orders with Ease', 'Welcome to our restaurant login page! Access your account and manage your restaurant\'s menu, orders, and promotions with ease. Join our platform today and offer your customers the best dining experience. Sign in now and take your business to new heights!', '', '', '', 'publish', '2023-06-15 18:47:13', '2023-06-15 18:47:13', '127.0.0.1'),
(27, 'seo', 0, 'page', 'explore-our-mouth-watering-menu-delicious-burgers-fries-and-more', 'Menu', NULL, '', 'Explore Our Mouth-Watering Menu - Delicious Burgers, Fries, and More!', 'Looking for a diverse range of mouth-watering dishes? Look no further than our restaurant menu! From savory appetizers to delectable entrees and desserts, we have something for everyone. Our menu is carefully crafted using only the freshest ingredients, e', '', '', '', 'publish', '2023-06-15 18:46:27', '2023-06-15 23:27:39', '127.0.0.1'),
(26, 'seo', 0, 'page', 'explore-our-mouth-watering-cuisine-list-a-culinary-journey-you-dont-want-to-miss', 'Cuisine', NULL, '', 'Explore Our Mouth-Watering Cuisine List - A Culinary Journey You Don\'t Want to Miss!', 'At our multiple restaurant karenderia, we offer a diverse cuisine list that caters to all taste buds. From savory Filipino dishes to international favorites, our menu is sure to satisfy your cravings. Indulge in our delicious meals and experience the best', '', '', '', 'publish', '2023-06-15 18:40:07', '2023-06-15 18:44:26', '127.0.0.1'),
(25, 'seo', 0, 'page', 'get-in-touch-with-us-contact-our-team-for-exceptional-customer-service-and-support', 'Contact us', NULL, '', 'Get in Touch with Us - Contact Our Team for Exceptional Customer Service and Support', 'Looking to get in touch with us? Our contact page is the perfect place to start. Whether you have a question, comment, or feedback, we\'re always happy to hear from our customers. Simply fill out the form on our contact page, and we\'ll get back to you as s', '', '', '', 'publish', '2023-06-15 18:38:48', '2023-06-15 18:43:59', '127.0.0.1'),
(24, 'seo', 0, 'page', 'find-your-perfect-meal-with-our-restaurant-food-ordering-search-explore-the-best-restaurant-results-now', 'Search results', NULL, '', 'Find Your Perfect Meal with Our Restaurant Food Ordering Search - Explore the Best Restaurant Results Now!', 'Looking for the best dining experience? Look no further than our multiple restaurant Karenderia! Our website offers a seamless food ordering process and a comprehensive search feature that allows you to find the perfect restaurant for your taste buds. Wit', 'Restaurants,Dining,Cuisine,Menu,Food,Reservation,Offers', '', '', 'publish', '2023-06-15 18:37:42', '2023-06-15 18:43:28', '127.0.0.1'),
(23, 'seo', 0, 'page', 'order-delicious-food-from-the-comfort-of-your-home-explore-our-restaurant-food-ordering-website-now', 'Homepage', NULL, '', 'Order Delicious Food from the Comfort of Your Home - Explore Our Restaurant Food Ordering Website Now!', 'Order food online from multiple restaurants with ease at our restaurant food ordering website. Enjoy the convenience of browsing menus, placing orders, and getting your favorite meals delivered to your doorstep. Satisfy your cravings today!', 'Delicious cuisine,Dining experience,International cuisine,Fine dining,Family-friendly,Special occasions', '', '', 'publish', '2023-06-15 18:35:44', '2023-06-15 18:41:51', '127.0.0.1');


-- --------------------------------------------------------

--
-- Table structure for table `st_pages_translation`
--

CREATE TABLE `st_pages_translation` (
  `id` int(11) NOT NULL,
  `page_id` int(14) NOT NULL DEFAULT '0',
  `language` varchar(100) NOT NULL DEFAULT '',
  `title` varchar(255) NOT NULL DEFAULT '',
  `long_content` mediumtext,
  `meta_title` varchar(255) NOT NULL DEFAULT '',
  `meta_description` text,
  `meta_keywords` varchar(255) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `st_pages_translation`
--

INSERT INTO `st_pages_translation` (`id`, `page_id`, `language`, `title`, `long_content`, `meta_title`, `meta_description`, `meta_keywords`) VALUES
(1, 1, 'ja', '', '', '', '', ''),
(2, 1, 'ar', '', '', '', '', ''),
(3, 1, 'en', 'Terms and conditions', '<div>\r\n<p>\r\nLorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam id \r\nsapien massa. Sed porta interdum nulla sed accumsan. Proin lacinia vel \r\nnulla eget porttitor. In varius vehicula facilisis. Maecenas non \r\nvehicula massa. Maecenas vel eros nec ante rutrum fringilla vel sit amet\r\n ipsum. Sed ut tellus nisl. Aenean vehicula, diam nec sollicitudin \r\nporttitor, purus augue mattis risus, porta elementum augue nibh eget \r\nsapien. Fusce a efficitur ipsum. In urna mi, ullamcorper ut ultrices sit\r\n amet, faucibus et risus. Maecenas vestibulum molestie ex.\r\n</p>\r\n<p>\r\nMaecenas ut lectus eget ante faucibus tristique. In sodales turpis orci,\r\n quis commodo lectus feugiat quis. Aliquam varius metus diam, id luctus \r\neros sagittis vel. Nulla facilisi. Suspendisse mollis eros lacus, at \r\nmaximus enim imperdiet quis. Nulla eget diam ac diam condimentum \r\nelementum. Ut at ipsum vitae ipsum ullamcorper vestibulum. Aliquam \r\neuismod enim vitae blandit tristique.\r\n</p>\r\n<p>\r\nVestibulum malesuada, diam sit amet tristique finibus, sem lacus \r\nelementum diam, et semper ipsum odio eu quam. Sed hendrerit tincidunt \r\neuismod. Aliquam finibus quis elit at sollicitudin. In at magna euismod,\r\n tincidunt lectus sed, posuere dui. Curabitur congue ante non ligula \r\nsagittis, non blandit metus consectetur. Nunc nisi purus, ultrices in \r\nodio quis, mattis condimentum quam. Nullam vestibulum ex et erat \r\nvolutpat hendrerit. Vestibulum luctus quam vestibulum mollis euismod. \r\nEtiam efficitur mauris vel mi pretium iaculis. Donec sed erat tincidunt,\r\n elementum sem in, consectetur ipsum. Nulla pellentesque porta sapien, \r\neu venenatis justo vulputate vitae. Nunc et finibus ex, non finibus \r\nmassa. Nulla non turpis rutrum, molestie dui id, pharetra massa.\r\n</p>\r\n<p>\r\nDuis a arcu quis quam sodales dapibus. Curabitur consectetur sit amet \r\ndiam sed consectetur. Sed facilisis ultricies odio, nec sagittis enim \r\nlacinia non. Maecenas non congue est, sed condimentum mi. Cras a \r\nporttitor libero. Praesent massa risus, sollicitudin eget accumsan \r\nelementum, ornare nec felis. Vestibulum porttitor imperdiet rhoncus. \r\nMauris consequat fermentum metus feugiat facilisis. Sed eleifend mollis \r\nmattis. Nunc imperdiet lectus non quam ullamcorper, at ultrices ante \r\ncongue. Etiam aliquam arcu felis. Class aptent taciti sociosqu ad litora\r\n torquent per conubia nostra, per inceptos himenaeos. Nulla consequat, \r\nturpis sit amet pharetra elementum, quam lacus placerat sapien, at \r\nsagittis nunc erat in sem. Nulla sed aliquet neque, a tempor leo. \r\nAliquam erat volutpat. Sed tempor libero neque, condimentum feugiat \r\ndolor lobortis in.\r\n</p>\r\n<p>\r\nFusce convallis quis augue vitae scelerisque. Sed auctor lectus a odio \r\neleifend, eget auctor enim vestibulum. Integer neque urna, eleifend in \r\nporta a, vehicula et risus. Vestibulum vehicula placerat ante sed \r\nlaoreet. Integer varius felis a magna tempor, a efficitur ex fringilla. \r\nDonec in diam a diam placerat luctus et nec nisi. Sed efficitur lacus \r\nfelis, vitae rutrum nibh eleifend in.\r\n</p></div>', '', '', ''),
(4, 2, 'ja', '', '', '', '', ''),
(5, 2, 'ar', '', '', '', '', ''),
(6, 2, 'en', 'Privacy policy', '<div>\r\n<p>\r\nLorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam id \r\nsapien massa. Sed porta interdum nulla sed accumsan. Proin lacinia vel \r\nnulla eget porttitor. In varius vehicula facilisis. Maecenas non \r\nvehicula massa. Maecenas vel eros nec ante rutrum fringilla vel sit amet\r\n ipsum. Sed ut tellus nisl. Aenean vehicula, diam nec sollicitudin \r\nporttitor, purus augue mattis risus, porta elementum augue nibh eget \r\nsapien. Fusce a efficitur ipsum. In urna mi, ullamcorper ut ultrices sit\r\n amet, faucibus et risus. Maecenas vestibulum molestie ex.\r\n</p>\r\n<p>\r\nMaecenas ut lectus eget ante faucibus tristique. In sodales turpis orci,\r\n quis commodo lectus feugiat quis. Aliquam varius metus diam, id luctus \r\neros sagittis vel. Nulla facilisi. Suspendisse mollis eros lacus, at \r\nmaximus enim imperdiet quis. Nulla eget diam ac diam condimentum \r\nelementum. Ut at ipsum vitae ipsum ullamcorper vestibulum. Aliquam \r\neuismod enim vitae blandit tristique.\r\n</p>\r\n<p>\r\nVestibulum malesuada, diam sit amet tristique finibus, sem lacus \r\nelementum diam, et semper ipsum odio eu quam. Sed hendrerit tincidunt \r\neuismod. Aliquam finibus quis elit at sollicitudin. In at magna euismod,\r\n tincidunt lectus sed, posuere dui. Curabitur congue ante non ligula \r\nsagittis, non blandit metus consectetur. Nunc nisi purus, ultrices in \r\nodio quis, mattis condimentum quam. Nullam vestibulum ex et erat \r\nvolutpat hendrerit. Vestibulum luctus quam vestibulum mollis euismod. \r\nEtiam efficitur mauris vel mi pretium iaculis. Donec sed erat tincidunt,\r\n elementum sem in, consectetur ipsum. Nulla pellentesque porta sapien, \r\neu venenatis justo vulputate vitae. Nunc et finibus ex, non finibus \r\nmassa. Nulla non turpis rutrum, molestie dui id, pharetra massa.\r\n</p>\r\n<p>\r\nDuis a arcu quis quam sodales dapibus. Curabitur consectetur sit amet \r\ndiam sed consectetur. Sed facilisis ultricies odio, nec sagittis enim \r\nlacinia non. Maecenas non congue est, sed condimentum mi. Cras a \r\nporttitor libero. Praesent massa risus, sollicitudin eget accumsan \r\nelementum, ornare nec felis. Vestibulum porttitor imperdiet rhoncus. \r\nMauris consequat fermentum metus feugiat facilisis. Sed eleifend mollis \r\nmattis. Nunc imperdiet lectus non quam ullamcorper, at ultrices ante \r\ncongue. Etiam aliquam arcu felis. Class aptent taciti sociosqu ad litora\r\n torquent per conubia nostra, per inceptos himenaeos. Nulla consequat, \r\nturpis sit amet pharetra elementum, quam lacus placerat sapien, at \r\nsagittis nunc erat in sem. Nulla sed aliquet neque, a tempor leo. \r\nAliquam erat volutpat. Sed tempor libero neque, condimentum feugiat \r\ndolor lobortis in.\r\n</p>\r\n<p>\r\nFusce convallis quis augue vitae scelerisque. Sed auctor lectus a odio \r\neleifend, eget auctor enim vestibulum. Integer neque urna, eleifend in \r\nporta a, vehicula et risus. Vestibulum vehicula placerat ante sed \r\nlaoreet. Integer varius felis a magna tempor, a efficitur ex fringilla. \r\nDonec in diam a diam placerat luctus et nec nisi. Sed efficitur lacus \r\nfelis, vitae rutrum nibh eleifend in.\r\n</p></div>', '', '', '');

-- --------------------------------------------------------

--
-- Table structure for table `st_payment_gateway`
--

CREATE TABLE `st_payment_gateway` (
  `payment_id` int(11) NOT NULL,
  `payment_name` varchar(255) NOT NULL DEFAULT '',
  `payment_code` varchar(255) NOT NULL DEFAULT '',
  `is_online` tinyint(1) NOT NULL DEFAULT '0',
  `is_payout` tinyint(1) NOT NULL DEFAULT '0',
  `is_plan` tinyint(1) NOT NULL DEFAULT '0',
  `logo_type` varchar(50) NOT NULL DEFAULT 'icon',
  `logo_class` varchar(100) NOT NULL DEFAULT '',
  `logo_image` varchar(255) NOT NULL DEFAULT '',
  `path` varchar(255) NOT NULL DEFAULT '',
  `status` varchar(100) NOT NULL DEFAULT 'active',
  `sequence` int(11) NOT NULL DEFAULT '0',
  `is_live` tinyint(1) NOT NULL DEFAULT '1',
  `attr_json` text,
  `attr_json1` text,
  `attr1` varchar(255) NOT NULL DEFAULT '',
  `attr2` varchar(255) NOT NULL DEFAULT '',
  `attr3` varchar(255) NOT NULL DEFAULT '',
  `attr4` text,
  `attr5` varchar(255) NOT NULL DEFAULT '',
  `attr6` varchar(255) NOT NULL DEFAULT '',
  `attr7` varchar(255) NOT NULL DEFAULT '',
  `attr8` varchar(255) NOT NULL DEFAULT '',
  `attr9` text,
  `split` smallint(1) NOT NULL DEFAULT '0',
  `capture` smallint(1) NOT NULL DEFAULT '0',
  `date_created` timestamp NULL DEFAULT NULL,
  `date_modified` timestamp NULL DEFAULT NULL,
  `ip_address` varchar(50) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `st_payment_gateway`
--

INSERT INTO `st_payment_gateway` (`payment_id`, `payment_name`, `payment_code`, `is_online`, `is_payout`, `is_plan`, `logo_type`, `logo_class`, `logo_image`, `path`, `status`, `sequence`, `is_live`, `attr_json`, `attr_json1`, `attr1`, `attr2`, `attr3`, `attr4`, `attr5`, `attr6`, `attr7`, `attr8`, `attr9`, `split`, `capture`, `date_created`, `date_modified`, `ip_address`) VALUES
(1, 'Cash On delivery', 'cod', 0, 0, 0, 'icon', 'zmdi zmdi-money-box', '', '', 'active', 1, 1, NULL, NULL, '', '', '', '', '', '', '', '', NULL, 0, 0, NULL, NULL, ''),
(2, 'Credit/Debit Card', 'ocr', 0, 0, 0, 'icon', 'zmdi zmdi-card', '', '', 'active', 2, 1, NULL, NULL, '', '', '', '', '', '', '', '', NULL, 0, 0, NULL, '2021-10-11 21:01:47', '127.0.0.1'),
(5, 'Paypal', 'paypal', 1, 1, 1, 'image', 'zmdi zmdi-paypal', '9e9d3f64-40ed-11ef-8e54-9c5c8e164c2c.png', 'upload/all', 'active', 12, 0, '{\"attr1\":{\"label\":\"Client ID\"},\"attr2\":{\"label\":\"Secret ID\"},\"attr5\":{\"label\":\"Card fee %\"},\"attr6\":{\"label\":\"Card fixed fee\"}}', '{\"email_address\":\"Email Address\"}', 'AT4L2f5cPeFy2cOkKW11AIZbuE3nPQxEdDIetVEAinq47vIF2fAs6FAC5Zs-9GetL0rNNplpqq1gTDQa', 'ECjkntbfOoq6OpSCBvtBPr3QOyTmT3dMepglPAe9AdOOfac764TYzjx7EsfTF8JyN7GcntXfkx3Kp1i0', '', '{\"Webhooks Plan\":\"{site_url}/paypal/apiv2/webhooksplans\",\"Events\":\"BILLING.SUBSCRIPTION.ACTIVATED, BILLING.SUBSCRIPTION.CREATED, BILLING.SUBSCRIPTION.CANCELLED, BILLING.SUBSCRIPTION.PAYMENT.FAILED\"}', '', '', '', '', NULL, 0, 0, NULL, '2024-07-18 14:27:38', '127.0.0.1'),
(6, 'Stripe', 'stripe', 1, 0, 1, 'image', '', '32b53410-80b2-11ec-859e-99479722e411.png', 'upload/all', 'active', 13, 0, '{\"attr1\":{\"label\":\"Secret key\"},\"attr2\":{\"label\":\"Publishable Key\"},\"attr3\":{\"label\":\"Webhooks Signing secret\"}}', '{\"account_number\":\"Account number\",\"account_holder_name\":\"Account name\",\"account_holder_type\":\"Account type\",\"currency\":\"Currency\",\"routing_number\":\"Routing number\",\"country\":\"Country\"}', 'sk_test_f95wSoGGaVzxbOgxcUXV0dvx', 'pk_test_svqQz6KfEyJ8S0UO3ac0wAn0', 'whsec_e6QK2fODcE4lfLOz3bk9iqwWWiIKKyEi', '{\"Webhooks Plan\":\"{site_url}/stripe/apiv2/webhooksplans\",\"Events\":\"checkout.session.completed, invoice.paid, invoice.payment_failed, customer.subscription.deleted, subscription_schedule.canceled\"}', '', '', '', '', NULL, 0, 0, NULL, '2024-07-15 01:27:14', '127.0.0.1'),
(7, 'Razorpay', 'razorpay', 1, 1, 1, 'image', '', '40153c1c-80b2-11ec-859e-99479722e411.png', 'upload/all', 'active', 14, 0, '{\"attr1\":{\"label\":\"Key ID\"},\"attr2\":{\"label\":\"Key Secret\"}}', NULL, 'rzp_test_fUeXTtpM4rngDl', 't37LVcdi49KVjj1AE2WCtjkD', '', '{\"Webhooks Plan\":\"{site_url}/razorpay/apiv2/webhooksplans\",\"Events\":\"subscription.charged, subscription.updated, subscription.cancelled, subscription.pending, subscription.halted\"}', '', '', '', '', NULL, 0, 0, '2021-10-14 20:42:19', '2024-09-02 03:22:56', '127.0.0.1'),
(8, 'Mercadopago', 'mercadopago', 1, 0, 0, 'image', 'x', '2f76795f-80b2-11ec-859e-99479722e411.png', 'upload/all', 'active', 7, 0, '{\"attr1\":{\"label\":\"Public Key\"},\"attr2\":{\"label\":\"Access Token\"}}', NULL, 'TEST-287c4601-0425-4eff-84ec-e42f05006d29', 'TEST-3846096499578652-050720-4c7dbc49ba67bf1f86b0594cd222bfaa-131280449', '', '', '', '', '', '', NULL, 0, 0, '2021-10-19 10:16:21', '2022-01-29 16:19:06', '49.147.246.254'),
(9, 'Bank Transfer', 'bank', 0, 1, 0, 'icon', 'zmdi zmdi-store', '', '', 'active', 8, 0, '{\n  \"attr9\": {\n    \"label\": \"Bank Instructions\",\n    \"field_type\": \"textarea\"\n  },\n  \"attr1\": {\n    \"label\": \"Subject\",\n    \"field_type\": \"text\"\n  }\n}', '{\"full_name\":\"Full Name\",\"billing_address1\":\"Billing Address Line 1\",\"billing_address2\":\"Billing Address Line 2\",\"city\":\"City\",\"state\":\"State\",\"post_code\":\"Postcode\",\"country\":\"Country\",\"account_name\":\"Bank Account Holder\'s Name\",\"account_number\":\"Bank Account Number\\/IBAN\",\"swift_code\":\"SWIFT Code\",\"bank_name\":\"Bank Name in Full\",\"bank_branch\":\"Bank Branch City\"}', 'Bank instructions deposit', 'Bank instructions deposit', '', '', '', '', '', '', '<p>Hi {{first_name}},<br><br>Deposit Instructions<br><br>Please deposit {{amount}} to :<br><br>Bank : Your bank name<br>Account Number : Your bank account number<br>Account Name : Your bank account name<br><br>When deposit is completed<br>fill in your bank deposit information {{upload_deposit_url}}<br><br><br>Kind Regards<br></p>', 0, 0, '2021-11-17 03:32:31', '2022-09-16 10:24:30', '127.0.0.1');


INSERT INTO `st_payment_gateway` (`payment_id`, `payment_name`, `payment_code`, `is_online`, `is_payout`, `is_plan`, `logo_type`, `logo_class`, `logo_image`, `path`, `status`, `sequence`, `is_live`, `attr_json`, `attr_json1`, `attr1`, `attr2`, `attr3`, `attr4`, `attr5`, `attr6`, `attr7`, `attr8`, `attr9`, `split`, `capture`, `date_created`, `date_modified`, `ip_address`) VALUES
(10,'Pay on delivery', 'paydelivery', 0, 0, 0, 'icon', 'zmdi zmdi-card', '', '', 'active', 0, 1, NULL, NULL, '', '', '', '', '', '', '', '', NULL, 0, 0, '2023-08-05 01:39:31', '2023-08-05 01:40:23', '127.0.0.1');


UPDATE `st_payment_gateway` SET attr_json='{\n	\"attr1\": {\n		\"label\": \"Change required, if required value = 1\"\n	},\n	\"attr2\": {\n		\"label\": \"Maximum limit\"\n	}\n}'
WHERE payment_code = 'cod';

-- --------------------------------------------------------

--
-- Table structure for table `st_payment_gateway_merchant`
--

CREATE TABLE `st_payment_gateway_merchant` (
  `id` bigint(20) NOT NULL,
  `payment_uuid` varchar(100) NOT NULL DEFAULT '',
  `merchant_id` bigint(14) NOT NULL DEFAULT '0',
  `payment_id` bigint(20) DEFAULT '0',
  `payment_code` varchar(255) NOT NULL DEFAULT '',
  `status` varchar(100) NOT NULL DEFAULT 'active',
  `sequence` int(14) NOT NULL DEFAULT '0',
  `is_live` int(1) NOT NULL DEFAULT '1',
  `attr_json` text,
  `attr1` varchar(255) NOT NULL DEFAULT '',
  `attr2` varchar(255) NOT NULL DEFAULT '',
  `attr3` varchar(255) NOT NULL DEFAULT '',
  `attr4` varchar(255) NOT NULL DEFAULT '',
  `attr5` varchar(255) NOT NULL DEFAULT '',
  `attr6` varchar(255) NOT NULL DEFAULT '',
  `attr7` varchar(255) NOT NULL DEFAULT '',
  `attr8` varchar(255) NOT NULL DEFAULT '',
  `attr9` text,
  `split` smallint(1) NOT NULL DEFAULT '0',
  `capture` smallint(1) NOT NULL DEFAULT '0',
  `date_created` timestamp NULL DEFAULT NULL,
  `date_modified` timestamp NULL DEFAULT NULL,
  `ip_address` varchar(50) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `st_payment_method_meta`
--

CREATE TABLE `st_payment_method_meta` (
  `id` bigint(14) NOT NULL,
  `payment_method_id` bigint(20) DEFAULT NULL,
  `meta_name` varchar(255) NOT NULL DEFAULT '',
  `meta_value` longtext,
  `date_created` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `st_plans`
--

CREATE TABLE `st_plans` (
  `package_id` int(14) NOT NULL,
  `package_uuid` varchar(50) NOT NULL DEFAULT '',
  `plan_type` varchar(50) NOT NULL DEFAULT 'membership',
  `title` varchar(255) NOT NULL DEFAULT '',
  `description` text,
  `price` float(14,4) NOT NULL DEFAULT '0.0000',
  `promo_price` float(14,4) NOT NULL DEFAULT '0.0000',
  `package_period` varchar(50) NOT NULL DEFAULT 'monthly',
  `ordering_enabled` tinyint(1) NOT NULL DEFAULT '1',
  `item_limit` int(14) NOT NULL DEFAULT '0',
  `order_limit` int(14) NOT NULL DEFAULT '0',
  `trial_period` int(14) NOT NULL DEFAULT '0',
  `sequence` int(14) NOT NULL DEFAULT '0',
  `status` varchar(100) NOT NULL DEFAULT '',
  `pos` tinyint(1) NOT NULL DEFAULT '0',
  `self_delivery` tinyint(1) NOT NULL DEFAULT '0',
  `chat` tinyint(1) NOT NULL DEFAULT '0',
  `loyalty_program` tinyint(1) NOT NULL DEFAULT '0',
  `table_reservation` tinyint(1) NOT NULL DEFAULT '0',
  `inventory_management` tinyint(1) NOT NULL DEFAULT '0',
  `marketing_tools` tinyint(1) NOT NULL DEFAULT '0',
  `mobile_app` tinyint(1) NOT NULL DEFAULT '0',
  `payment_processing` tinyint(1) NOT NULL DEFAULT '0',
  `customer_feedback` tinyint(1) NOT NULL DEFAULT '0',
  `coupon_creation` tinyint(1) NOT NULL DEFAULT '0',
  `date_created` timestamp NULL DEFAULT NULL,
  `date_modified` timestamp NULL DEFAULT NULL,
  `ip_address` varchar(50) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `st_plans_invoice`
--

CREATE TABLE `st_plans_invoice` (
  `invoice_number` bigint(20) NOT NULL,
  `invoice_uuid` varchar(50) NOT NULL DEFAULT '',
  `invoice_type` varchar(50) NOT NULL DEFAULT 'membership',
  `payment_code` varchar(10) NOT NULL DEFAULT '',
  `amount` decimal(10,4) NOT NULL DEFAULT '0.00',
  `status` varchar(100) NOT NULL DEFAULT '',
  `merchant_id` bigint(20) DEFAULT '0',
  `package_id` bigint(20) DEFAULT '0',
  `invoice_ref_number` varchar(50) NOT NULL DEFAULT '',
  `payment_ref1` varchar(100) NOT NULL DEFAULT '',
  `created` timestamp NULL DEFAULT NULL,
  `due_date` timestamp NULL DEFAULT NULL,
  `date_created` timestamp NULL DEFAULT NULL,
  `date_modified` timestamp NULL DEFAULT NULL,
  `ip_address` varchar(50) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `st_plans_translation`
--

CREATE TABLE `st_plans_translation` (
  `id` int(11) NOT NULL,
  `package_id` int(11) NOT NULL DEFAULT '0',
  `language` varchar(100) NOT NULL DEFAULT '',
  `title` varchar(255) NOT NULL DEFAULT '',
  `description` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `st_push`
--

CREATE TABLE `st_push` (
  `push_uuid` varchar(100) NOT NULL DEFAULT '',
  `merchant_id` int(14) NOT NULL DEFAULT '0',
  `push_type` varchar(50) NOT NULL DEFAULT '',
  `provider` varchar(50) NOT NULL DEFAULT '',
  `channel_device_id` text,
  `platform` varchar(50) NOT NULL DEFAULT '',
  `title` varchar(255) NOT NULL DEFAULT '',
  `body` text,
  `image` varchar(255) NOT NULL DEFAULT '',
  `path` varchar(255) NOT NULL DEFAULT '',
  `status` varchar(50) NOT NULL DEFAULT 'pending',
  `response` text,
  `date_created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `ip_address` varchar(50) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `st_review`
--

CREATE TABLE `st_review` (
  `id` int(14) NOT NULL,
  `merchant_id` int(14) NOT NULL DEFAULT '0',
  `client_id` int(14) NOT NULL DEFAULT '0',
  `driver_id` int(14) NOT NULL DEFAULT '0',
  `review` text,
  `rating` float(14,1) NOT NULL DEFAULT '0.0',
  `status` varchar(100) NOT NULL DEFAULT 'publish',
  `date_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ip_address` varchar(50) NOT NULL DEFAULT '',
  `order_id` varchar(14) NOT NULL DEFAULT '',
  `parent_id` int(14) NOT NULL DEFAULT '0',
  `reply_from` varchar(255) NOT NULL DEFAULT '',
  `date_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `as_anonymous` varchar(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `st_review_meta`
--

CREATE TABLE `st_review_meta` (
  `id` int(11) NOT NULL,
  `review_id` int(14) NOT NULL DEFAULT '0',
  `meta_name` varchar(100) NOT NULL DEFAULT '',
  `meta_value` varchar(255) NOT NULL DEFAULT '',
  `date_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `st_role`
--

CREATE TABLE `st_role` (
  `role_id` int(11) NOT NULL,
  `role_type` varchar(50) NOT NULL DEFAULT 'admin',
  `merchant_id` int(11) NOT NULL DEFAULT '0',
  `role_name` varchar(255) NOT NULL DEFAULT '',
  `date_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `date_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ip_address` varchar(50) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `st_role_access`
--

CREATE TABLE `st_role_access` (
  `role_access_id` int(11) NOT NULL,
  `role_id` int(11) NOT NULL DEFAULT '0',
  `action_name` varchar(255) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `st_services`
--

CREATE TABLE `st_services` (
  `service_id` int(11) NOT NULL,
  `service_code` varchar(255) NOT NULL DEFAULT '',
  `service_name` varchar(255) NOT NULL DEFAULT '',
  `description` text,
  `color_hex` varchar(10) NOT NULL DEFAULT '',
  `font_color_hex` varchar(10) NOT NULL DEFAULT '',
  `sequence` int(14) NOT NULL DEFAULT '0',  
  `status` varchar(255) NOT NULL DEFAULT 'publish',
  `date_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `date_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ip_address` varchar(50) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `st_services`
--

INSERT INTO `st_services` (`service_id`, `service_code`, `service_name`, `description`, `color_hex`, `font_color_hex`, `sequence`, `status`, `date_created`, `date_modified`, `ip_address`) VALUES
(1, 'delivery', 'Delivery', 'Use the {site_name} to get orders to customer', '#9fc5e8', 'white', 0, 'publish', '2021-08-03 10:12:43', '2024-05-29 00:01:03', '127.0.0.1'),
(2, 'pickup', 'Pickup', 'Let customer {transaction_type} their orders to get more sales at a low fee', '#e8989b', 'white', 1, 'publish', '2021-08-03 10:12:43', '2024-04-02 09:54:47', '127.0.0.1'),
(3, 'dinein', 'Dinein', 'Let customer {transaction_type} at your restaurant at low fee', '#ffd966', '#bcbcbc', 2, 'publish', '2021-08-03 10:12:43', '2024-04-02 09:54:47', '127.0.0.1'),
(4, 'takeout', 'Takeout', '', '#eeeeee', '#c90076', 3, 'publish', '2024-04-02 09:54:24', '2024-04-10 09:31:01', '127.0.0.1');


-- --------------------------------------------------------

--
-- Table structure for table `st_services_fee`
--

CREATE TABLE `st_services_fee` (
  `id` int(11) NOT NULL,
  `service_id` int(11) NOT NULL DEFAULT '0',
  `merchant_id` int(11) NOT NULL DEFAULT '0',
  `charge_type` varchar(50) NOT NULL DEFAULT 'fixed',
  `service_fee` float(14,4) NOT NULL DEFAULT '0.0000',
  `small_order_fee` decimal(10,4) NOT NULL DEFAULT '0.00',
  `small_less_order_based` decimal(10,4) NOT NULL DEFAULT '0.00',
  `date_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `st_services_fee`
--

INSERT INTO `st_services_fee` (`id`, `service_id`, `merchant_id`, `service_fee`, `date_modified`) VALUES
(1, 4, 0, 0.0000, '2022-01-27 16:10:25'),
(2, 3, 0, 0.0000, '2022-01-27 16:10:30'),
(3, 2, 0, 0.0000, '2022-01-27 16:10:35'),
(4, 1, 0, 0.0000, '2022-01-27 16:10:39');

-- --------------------------------------------------------

--
-- Table structure for table `st_services_translation`
--

CREATE TABLE `st_services_translation` (
  `id` int(11) NOT NULL,
  `service_id` int(11) NOT NULL DEFAULT '0',
  `language` varchar(100) NOT NULL DEFAULT '',
  `service_name` varchar(255) NOT NULL DEFAULT '',
  `date_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `st_services_translation`
--

INSERT INTO `st_services_translation` (`id`, `service_id`, `language`, `service_name`, `date_modified`) VALUES
(16, 4, 'ja', '', '2022-01-27 16:10:25'),
(17, 4, 'ar', '', '2022-01-27 16:10:25'),
(18, 4, 'en', 'Takeout', '2022-01-27 16:10:25'),
(19, 3, 'ja', '', '2022-01-27 16:10:30'),
(20, 3, 'ar', '', '2022-01-27 16:10:30'),
(21, 3, 'en', 'Dinein', '2022-01-27 16:10:30'),
(22, 2, 'ja', '', '2022-01-27 16:10:35'),
(23, 2, 'ar', '', '2022-01-27 16:10:35'),
(24, 2, 'en', 'Pickup', '2022-01-27 16:10:35'),
(25, 1, 'ja', '', '2022-01-27 16:10:39'),
(26, 1, 'ar', '', '2022-01-27 16:10:39'),
(27, 1, 'en', 'Delivery', '2022-01-27 16:10:39');

-- --------------------------------------------------------

--
-- Table structure for table `st_shipping_rate`
--

CREATE TABLE `st_shipping_rate` (
  `id` int(14) NOT NULL,
  `merchant_id` int(14) NOT NULL DEFAULT '0',
  `service_code` varchar(255) NOT NULL DEFAULT 'delivery',
  `charge_type` varchar(100) NOT NULL DEFAULT 'dynamic',
  `shipping_type` varchar(100) NOT NULL DEFAULT 'standard',
  `distance_from` float(14,2) NOT NULL DEFAULT '0.00',
  `distance_to` float(14,2) NOT NULL DEFAULT '0.00',
  `shipping_units` varchar(5) NOT NULL DEFAULT '',
  `distance_price` float(14,4) NOT NULL DEFAULT '0.0000',
  `minimum_order` float(14,4) NOT NULL DEFAULT '0.0000',
  `maximum_order` float(14,4) NOT NULL DEFAULT '0.0000',
  `estimation` varchar(20) NOT NULL DEFAULT '',
  `fixed_free_delivery_threshold` float(10,2) NOT NULL DEFAULT '0.00',
  `cap_delivery_charge` float(10,2) NOT NULL DEFAULT '0.00',
  `time_per_additional` float(10,2) NOT NULL DEFAULT '0.00',
  `delivery_radius` float(10,2) NOT NULL DEFAULT '0.00',
  `last_update` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `st_size`
--

CREATE TABLE `st_size` (
  `size_id` int(14) NOT NULL,
  `merchant_id` int(14) NOT NULL DEFAULT '0',
  `size_name` varchar(255) NOT NULL DEFAULT '',
  `sequence` int(14) NOT NULL DEFAULT '0',
  `status` varchar(50) NOT NULL DEFAULT 'published',
  `date_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `date_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ip_address` varchar(50) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `st_size_translation`
--

CREATE TABLE `st_size_translation` (
  `id` int(11) NOT NULL,
  `merchant_id` int(14) NOT NULL DEFAULT '0',  
  `size_id` int(14) NOT NULL DEFAULT '0',
  `language` varchar(10) NOT NULL DEFAULT '',
  `size_name` varchar(255) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `st_sms_broadcast`
--

CREATE TABLE `st_sms_broadcast` (
  `broadcast_id` int(14) NOT NULL,
  `merchant_id` int(14) NOT NULL DEFAULT '0',
  `send_to` int(14) NOT NULL DEFAULT '0',
  `list_mobile_number` text NOT NULL,
  `sms_alert_message` varchar(255) NOT NULL,
  `status` varchar(255) NOT NULL DEFAULT 'pending',
  `date_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `date_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ip_address` varchar(50) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `st_sms_broadcast_details`
--

CREATE TABLE `st_sms_broadcast_details` (
  `id` int(14) NOT NULL,
  `merchant_id` int(14) NOT NULL DEFAULT '0',
  `broadcast_id` int(14) NOT NULL DEFAULT '0',
  `client_id` int(14) NOT NULL DEFAULT '0',
  `client_name` varchar(255) NOT NULL DEFAULT '',
  `contact_phone` varchar(50) NOT NULL DEFAULT '',
  `sms_message` text,
  `status` varchar(255) NOT NULL DEFAULT 'pending',
  `gateway_response` text,
  `date_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `date_executed` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ip_address` varchar(50) NOT NULL DEFAULT '',
  `gateway` varchar(100) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `st_sms_provider`
--

CREATE TABLE `st_sms_provider` (
  `id` int(11) NOT NULL,
  `provider_id` varchar(100) NOT NULL DEFAULT '',
  `provider_name` varchar(255) NOT NULL DEFAULT '',
  `as_default` int(1) NOT NULL DEFAULT '0',
  `key1` varchar(255) NOT NULL DEFAULT '',
  `key2` varchar(255) NOT NULL DEFAULT '',
  `key3` varchar(255) NOT NULL DEFAULT '',
  `key4` varchar(255) NOT NULL DEFAULT '',
  `key5` varchar(255) NOT NULL DEFAULT '',
  `key6` varchar(255) NOT NULL DEFAULT '',
  `key7` varchar(255) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `st_sms_provider`
--

INSERT INTO `st_sms_provider` (`id`, `provider_id`, `provider_name`, `as_default`, `key1`, `key2`, `key3`, `key4`, `key5`, `key6`, `key7`) VALUES
(1, 'twilio', 'Twilio', 0, '', '', '', '', '', '', ''),
(2, 'nexmo', 'Nexmo', 0, '', '', '', '', '', '', ''),
(3, 'clickatell', 'Clickatell', 0, '', '', '', '', '', '', ''),
(5, 'smsglobal', 'SMS Global', 0, '', '', '', '', '', '', '');

INSERT INTO `st_sms_provider` (`id`, `provider_id`, `provider_name`, `as_default`, `key1`, `key2`, `key3`, `key4`, `key5`, `key6`, `key7`) VALUES
(7, 'msg91', 'Msg91', 0, '', '', '', '', '', '', '');

-- --------------------------------------------------------

--
-- Table structure for table `st_status_management`
--

CREATE TABLE `st_status_management` (
  `status_id` int(11) NOT NULL,
  `group_name` varchar(100) NOT NULL DEFAULT '',
  `status` varchar(255) NOT NULL DEFAULT '',
  `title` varchar(255) NOT NULL DEFAULT '',
  `color_hex` varchar(10) NOT NULL DEFAULT '',
  `font_color_hex` varchar(10) NOT NULL DEFAULT '',
  `date_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `date_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ip_address` varchar(50) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `st_status_management`
--

INSERT INTO `st_status_management` (`status_id`, `group_name`, `status`, `title`, `color_hex`, `font_color_hex`, `date_created`, `date_modified`, `ip_address`) VALUES
(1, 'customer', 'pending', 'Pending for approval', '#ffd6c4', '', '2021-05-19 08:35:32', '2022-01-26 22:44:35', '127.0.0.1'),
(2, 'customer', 'active', 'active', '#ffd966', '', '2021-05-19 08:35:32', '2022-01-26 22:45:04', '127.0.0.1'),
(3, 'customer', 'suspended', 'suspended', '#ea9895', 'white', '2021-05-19 08:35:32', '2022-01-26 22:45:01', '127.0.0.1'),
(4, 'customer', 'blocked', 'blocked', '#e8989b', 'white', '2021-05-19 08:35:32', '2022-01-26 22:44:59', '127.0.0.1'),
(5, 'customer', 'expired', 'Expired', '#ea9895', 'white', '2021-05-19 08:35:32', '2022-01-26 22:44:57', '127.0.0.1'),
(6, 'post', 'publish', 'Publish', '#ffd966', '', '2021-05-19 08:35:32', '2022-01-26 22:44:53', '127.0.0.1'),
(7, 'post', 'pending', 'Pending for review', '#ffd6c4', '', '2021-05-19 08:35:32', '2022-01-26 22:44:50', '127.0.0.1'),
(8, 'post', 'draft', 'Draft', '#e8989b', 'white', '2021-05-19 08:35:32', '2022-01-26 22:44:47', '127.0.0.1'),
(9, 'booking', 'pending', 'pending', '#ffd6c4', '', '2021-05-19 08:35:32', '2022-01-26 22:44:44', '127.0.0.1'),
(10, 'booking', 'approved', 'approved', '#d4ecdc', '', '2021-05-19 08:35:32', '2022-01-26 22:44:40', '127.0.0.1'),
(11, 'booking', 'denied', 'denied', '#e8989b', '', '2021-05-19 08:35:32', '2022-01-26 22:44:37', '127.0.0.1'),
(12, 'booking', 'request_cancel_booking', 'request cancel booking', '#d4ecdc', '', '2021-05-19 08:35:32', '2022-01-26 22:44:09', '127.0.0.1'),
(13, 'booking', 'cancel_booking_approved', 'cancel booking approved', '#efe5ee', '', '2021-05-19 08:35:32', '2022-01-26 22:44:07', '127.0.0.1'),
(15, 'transaction', 'process', 'Process', '#ffd966', '', '2021-05-19 02:46:46', '2022-01-26 22:44:05', '127.0.0.1'),
(16, 'payment', 'paid', 'Paid', '#ffd966', '', '2021-05-19 05:12:47', '2022-01-26 22:44:03', '127.0.0.1'),
(19, 'payment', 'unpaid', 'Unpaid', '#2986cc', 'white', '2021-10-12 04:55:38', '2022-01-26 22:44:01', '127.0.0.1'),
(20, 'payment', 'failed', 'Failed', '#f44336', 'white', '2021-10-12 04:55:53', '2022-01-26 22:43:58', '127.0.0.1'),
(21, 'gateway', 'active', 'Active', '#8fce00', 'white', '2021-10-12 04:57:21', '2022-01-26 22:43:56', '127.0.0.1'),
(22, 'gateway', 'inactive', 'Inactive', '#f44336', 'white', '2021-10-12 04:58:12', '2022-01-26 22:43:54', '127.0.0.1'),
(23, 'payment', 'pending', 'Pending', '#8fce00', 'white', '2021-11-20 02:23:22', '2022-01-26 22:43:52', '127.0.0.1'),
(24, 'payment', 'cancelled', 'Cancelled', '#eb786f', 'white', '2021-12-03 14:44:59', '2022-01-26 22:43:33', '127.0.0.1'),
(27, 'customer', 'deleted', 'deleted', '#880808', 'white', '2023-04-01 11:12:04', '2023-04-01 11:12:04', '127.0.0.1');

-- --------------------------------------------------------

--
-- Table structure for table `st_status_management_translation`
--

CREATE TABLE `st_status_management_translation` (
  `id` int(11) NOT NULL,
  `status_id` int(1) NOT NULL DEFAULT '0',
  `language` varchar(100) NOT NULL DEFAULT '',
  `title` varchar(255) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `st_status_management_translation`
--

INSERT INTO `st_status_management_translation` (`id`, `status_id`, `language`, `title`) VALUES
(1, 24, 'ja', ''),
(2, 24, 'ar', ''),
(3, 24, 'en', 'Cancelled'),
(4, 23, 'ja', ''),
(5, 23, 'ar', ''),
(6, 23, 'en', 'Pending'),
(7, 22, 'ja', ''),
(8, 22, 'ar', ''),
(9, 22, 'en', 'Inactive'),
(10, 21, 'ja', ''),
(11, 21, 'ar', ''),
(12, 21, 'en', 'Active'),
(13, 20, 'ja', ''),
(14, 20, 'ar', ''),
(15, 20, 'en', 'Failed'),
(16, 19, 'ja', ''),
(17, 19, 'ar', ''),
(18, 19, 'en', 'Unpaid'),
(19, 16, 'ja', ''),
(20, 16, 'ar', ''),
(21, 16, 'en', 'Paid'),
(22, 15, 'ja', ''),
(23, 15, 'ar', ''),
(24, 15, 'en', 'Process'),
(25, 13, 'ja', ''),
(26, 13, 'ar', ''),
(27, 13, 'en', 'cancel booking approved'),
(28, 12, 'ja', ''),
(29, 12, 'ar', ''),
(30, 12, 'en', 'request cancel booking'),
(31, 1, 'ja', ''),
(32, 1, 'ar', ''),
(33, 1, 'en', 'Pending for approval'),
(34, 11, 'ja', ''),
(35, 11, 'ar', ''),
(36, 11, 'en', 'denied'),
(37, 10, 'ja', ''),
(38, 10, 'ar', ''),
(39, 10, 'en', 'approved'),
(40, 9, 'ja', ''),
(41, 9, 'ar', ''),
(42, 9, 'en', 'pending'),
(43, 8, 'ja', ''),
(44, 8, 'ar', ''),
(45, 8, 'en', 'Draft'),
(46, 7, 'ja', ''),
(47, 7, 'ar', ''),
(48, 7, 'en', 'Pending for review'),
(49, 6, 'ja', ''),
(50, 6, 'ar', ''),
(51, 6, 'en', 'Publish'),
(52, 5, 'ja', ''),
(53, 5, 'ar', ''),
(54, 5, 'en', 'Expired'),
(55, 4, 'ja', ''),
(56, 4, 'ar', ''),
(57, 4, 'en', 'blocked'),
(58, 3, 'ja', ''),
(59, 3, 'ar', ''),
(60, 3, 'en', 'suspended'),
(61, 2, 'ja', ''),
(62, 2, 'ar', ''),
(63, 2, 'en', 'active');

-- --------------------------------------------------------

--
-- Table structure for table `st_subcategory`
--

CREATE TABLE `st_subcategory` (
  `subcat_id` int(14) NOT NULL,
  `merchant_id` int(14) NOT NULL DEFAULT '0',
  `subcategory_name` varchar(255) NOT NULL DEFAULT '',
  `subcategory_description` text,
  `featured_image` varchar(255) NOT NULL DEFAULT '',
  `available` tinyint(1) NOT NULL DEFAULT '1',
  `path` varchar(255) NOT NULL DEFAULT '',
  `discount` varchar(20) NOT NULL DEFAULT '',
  `sequence` int(14) NOT NULL DEFAULT '0',
  `status` varchar(100) NOT NULL DEFAULT 'publish',
  `date_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `date_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ip_address` varchar(50) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `st_subcategory_item`
--

CREATE TABLE `st_subcategory_item` (
  `sub_item_id` int(14) NOT NULL,
  `merchant_id` int(14) NOT NULL DEFAULT '0',
  `sub_item_name` varchar(255) NOT NULL DEFAULT '',
  `item_description` text,
  `category` varchar(255) NOT NULL DEFAULT '',
  `price` varchar(15) NOT NULL DEFAULT '',
  `available` tinyint(1) NOT NULL DEFAULT '1',
  `photo` varchar(255) NOT NULL DEFAULT '',
  `path` varchar(255) DEFAULT '',
  `sequence` int(14) NOT NULL DEFAULT '0',
  `status` varchar(50) NOT NULL DEFAULT '',
  `date_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `date_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ip_address` varchar(50) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `st_subcategory_item_relationships`
--

CREATE TABLE `st_subcategory_item_relationships` (
  `id` int(11) NOT NULL,
  `merchant_id` int(14) NOT NULL DEFAULT '0',
  `subcat_id` int(14) NOT NULL DEFAULT '0',
  `sub_item_id` int(14) NOT NULL DEFAULT '0',
  `sequence` int(12) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `st_subcategory_item_translation`
--

CREATE TABLE `st_subcategory_item_translation` (
  `id` int(11) NOT NULL,
  `merchant_id` int(14) NOT NULL DEFAULT '0',  
  `sub_item_id` int(14) NOT NULL DEFAULT '0',
  `language` varchar(10) NOT NULL DEFAULT '',
  `sub_item_name` varchar(255) NOT NULL DEFAULT '',
  `item_description` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `st_subcategory_translation`
--

CREATE TABLE `st_subcategory_translation` (
  `id` int(11) NOT NULL,
  `merchant_id` int(14) NOT NULL DEFAULT '0',
  `subcat_id` int(14) NOT NULL DEFAULT '0',
  `language` varchar(10) NOT NULL DEFAULT '',
  `subcategory_name` varchar(255) NOT NULL DEFAULT '',
  `subcategory_description` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `st_tags`
--

CREATE TABLE `st_tags` (
  `tag_id` bigint(20) NOT NULL,
  `tag_name` varchar(255) NOT NULL DEFAULT '',
  `slug` varchar(255) NOT NULL DEFAULT '',
  `description` text,
  `date_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ip_address` varchar(50) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `st_tags_relationship`
--

CREATE TABLE `st_tags_relationship` (
  `id` int(11) NOT NULL,
  `banner_id` int(14) NOT NULL DEFAULT '0',
  `tag_id` int(14) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `st_tags_translation`
--

CREATE TABLE `st_tags_translation` (
  `id` int(11) NOT NULL,
  `tag_id` int(11) NOT NULL DEFAULT '0',
  `language` varchar(100) NOT NULL DEFAULT '',
  `tag_name` varchar(255) NOT NULL DEFAULT '',
  `description` varchar(255) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `st_tax`
--

CREATE TABLE `st_tax` (
  `tax_id` bigint(20) NOT NULL,
  `tax_uuid` varchar(100) DEFAULT '',
  `merchant_id` bigint(20) DEFAULT '0',
  `tax_type` varchar(50) DEFAULT 'standard',
  `tax_name` varchar(100) NOT NULL DEFAULT '',
  `tax_in_price` tinyint(1) NOT NULL DEFAULT '0',
  `tax_rate` decimal(10,2) NOT NULL DEFAULT '0.00',
  `tax_rate_type` varchar(50) NOT NULL DEFAULT 'percent',
  `default_tax` tinyint(1) NOT NULL DEFAULT '0',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `date_created` timestamp NULL DEFAULT NULL,
  `date_modified` timestamp NULL DEFAULT NULL,
  `ip_address` varchar(50) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `st_templates`
--

CREATE TABLE `st_templates` (
  `template_id` int(11) NOT NULL,
  `template_key` varchar(255) NOT NULL DEFAULT '',
  `template_name` varchar(255) NOT NULL DEFAULT '',
  `enabled_email` int(1) NOT NULL DEFAULT '0',
  `enabled_sms` int(1) NOT NULL DEFAULT '0',
  `enabled_push` int(1) NOT NULL DEFAULT '0',
  `tags` text,
  `sms_template_id` varchar(255) NOT NULL DEFAULT '',
  `date_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `date_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ip_address` varchar(50) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `st_templates`
--

INSERT INTO `st_templates` (`template_id`, `template_key`, `template_name`, `enabled_email`, `enabled_sms`, `enabled_push`, `tags`, `sms_template_id`, `date_created`, `date_modified`, `ip_address`) VALUES
(2, '', 'Order Invoice', 1, 0, 1, NULL, '', '2021-11-26 14:52:10', '2021-11-26 21:52:10', '127.0.0.1'),
(3, '', 'Customer Full Refund', 1, 0, 1, NULL, '', '2021-11-27 04:43:58', '2021-11-27 11:43:58', '49.147.246.254'),
(4, '', 'Receipt', 1, 0, 1, NULL, '60df2ddaf5f97b279045d663', '2021-11-27 15:47:38', '2021-11-27 22:47:38', '127.0.0.1'),
(5, '', 'New Order', 1, 0, 1, NULL, '', '2021-11-27 15:54:09', '2021-11-27 22:54:09', '127.0.0.1'),
(6, '', 'Order rejected', 1, 0, 1, NULL, '', '2021-11-27 16:02:27', '2021-11-27 23:02:27', '127.0.0.1'),
(7, '', 'Order Cancel', 1, 0, 1, NULL, '', '2021-11-29 02:10:41', '2021-11-29 09:10:41', '127.0.0.1'),
(8, '', 'Delay Order', 1, 0, 1, NULL, '', '2021-11-29 03:11:41', '2021-11-29 10:11:41', '127.0.0.1'),
(9, '', 'Order Accepted', 1, 0, 1, NULL, '', '2021-11-29 08:01:07', '2021-11-29 15:01:07', '127.0.0.1'),
(10, '', 'Driver on its way', 1, 0, 1, NULL, '', '2021-11-29 08:11:06', '2021-11-29 15:11:06', '127.0.0.1'),
(11, '', 'Customer Partial Full Refund', 1, 0, 1, NULL, '', '2021-11-29 10:44:22', '2021-11-29 17:44:22', '127.0.0.1'),
(12, '', 'Customer Welcome', 1, 0, 0, NULL, '', '2021-11-29 15:19:51', '2021-11-29 22:19:51', '127.0.0.1'),
(13, '', 'Customer Verification', 1, 1, 0, NULL, '', '2021-11-29 15:20:09', '2021-11-29 22:20:09', '127.0.0.1'),
(14, '', 'Customer Reset Password', 1, 0, 0, NULL, '', '2021-11-29 15:20:19', '2021-11-29 22:20:19', '127.0.0.1'),
(15, '', 'Review', 1, 0, 0, NULL, '', '2021-12-01 07:53:27', '2021-12-01 14:53:27', '127.0.0.1'),
(16, '', 'Payout new request', 1, 0, 1, NULL, '', '2021-12-04 03:35:08', '2021-12-04 10:35:08', '127.0.0.1'),
(17, '', 'Payout paid', 1, 0, 0, NULL, '', '2021-12-04 03:35:18', '2021-12-04 10:35:18', '127.0.0.1'),
(18, '', 'Payout Cancel', 1, 0, 1, NULL, '', '2021-12-04 03:35:24', '2021-12-04 10:35:24', '127.0.0.1'),
(19, '', 'New customer signup', 0, 0, 1, NULL, '', '2021-12-10 02:00:54', '2021-12-10 09:00:54', '127.0.0.1'),
(20, '', 'New cancell order', 0, 0, 1, NULL, '', '2021-12-10 04:44:40', '2021-12-10 11:44:40', '127.0.0.1'),
(21, '', 'Order on its way', 0, 0, 1, NULL, '', '2021-12-14 09:43:19', '2021-12-14 16:43:19', '127.0.0.1'),
(22, '', 'Order delivered', 0, 0, 1, NULL, '', '2021-12-14 09:43:44', '2021-12-14 16:43:44', '127.0.0.1'),
(23, '', 'Order delivery failed', 0, 0, 1, NULL, '', '2021-12-14 09:44:34', '2021-12-14 16:44:34', '127.0.0.1'),
(24, '', 'Merchant Welcome Email', 1, 0, 0, NULL, '', '2021-12-23 02:10:07', '2021-12-23 09:10:07', '127.0.0.1'),
(25, '', 'Merchant Confirm account', 1, 0, 1, NULL, '', '2021-12-23 02:13:15', '2021-12-23 09:13:15', '127.0.0.1'),
(26, '', 'Merchant new signup', 1, 0, 1, NULL, '', '2021-12-23 11:50:50', '2021-12-23 18:50:50', '127.0.0.1'),
(27, '', 'Merchant plan expired', 1, 0, 1, NULL, '', '2021-12-29 16:09:44', '2021-12-29 23:09:44', '127.0.0.1'),
(28, '', 'Merchant plan near expiration', 1, 0, 1, NULL, '', '2021-12-29 16:17:51', '2021-12-29 23:17:51', '127.0.0.1'),
(29, '', 'Forgot password', 1, 0, 0, NULL, '', '2022-02-20 18:07:48', '2022-02-20 18:07:48', '127.0.0.1'),
(34, '', 'Invoice created', 1, 0, 1, NULL, '', '2022-12-10 19:57:24', '2022-12-10 19:57:24', '127.0.0.1'),
(35, '', 'Invoice new upload deposit', 1, 0, 1, NULL, '', '2022-12-10 20:02:20', '2022-12-10 20:02:20', '127.0.0.1'),
(36, '', 'Booking requested', 1, 0, 0, NULL, '', '2022-12-13 07:51:17', '2022-12-13 07:51:17', '127.0.0.1'),
(37, '', 'Booking confirmed', 1, 0, 0, NULL, '', '2022-12-13 07:55:48', '2022-12-13 07:55:48', '127.0.0.1'),
(38, '', 'Booking Update status', 1, 0, 0, NULL, '', '2022-12-24 19:21:55', '2022-12-24 19:21:55', '127.0.0.1'),
(39, '', 'Contact Us', 1, 0, 1, NULL, '', '2022-12-28 18:56:04', '2022-12-28 18:56:04', '127.0.0.1'),
(40, '', 'Delivery arrived at restaurant', 0, 0, 1, NULL, '', '2023-02-04 19:53:22', '2023-02-04 19:53:22', '127.0.0.1'),
(41, '', 'Delivery order pickup', 0, 0, 1, NULL, '', '2023-02-04 19:54:53', '2023-02-04 19:54:53', '127.0.0.1'),
(42, '', 'Delivery missed assigned task', 0, 0, 1, NULL, '', '2023-02-10 18:59:39', '2023-02-10 18:59:39', '127.0.0.1'),
(43, '', 'Delivery order OTP to customer', 1, 0, 1, NULL, '', '2023-02-15 10:15:44', '2023-02-15 10:15:44', '127.0.0.1'),
(44, '', 'Delivery order assigned to driver', 0, 0, 1, NULL, '', '2023-02-15 20:06:33', '2023-02-15 20:06:33', '127.0.0.1'),
(45, '', 'Delivery order ready for pickup', 0, 0, 1, NULL, '', '2023-02-15 22:05:04', '2023-02-15 22:05:04', '127.0.0.1'),
(46, '', 'Delivery auto assign order', 0, 0, 1, NULL, '', '2023-02-16 19:35:57', '2023-02-16 19:35:57', '127.0.0.1'),
(47, '', 'Delivery started to customer', 0, 0, 1, NULL, '', '2023-02-22 09:59:37', '2023-02-22 09:59:37', '127.0.0.1'),
(48, '', 'Delivery arrived at customer location', 0, 0, 1, NULL, '', '2023-02-22 10:00:53', '2023-02-22 10:00:53', '127.0.0.1'),
(49, '', 'Test runactions', 1, 1, 1, NULL, '5eefb314d6fc0513522d4747', '2023-05-17 20:10:42', '2023-05-17 20:10:42', '127.0.0.1'),
(50, '', 'Complete registration', 1, 0, 0, NULL, '', '2023-12-30 23:20:36', '2023-12-30 23:20:36', '127.0.0.1'),
(51, '', 'New Bank Deposit Uploaded for Subscription Payment', 1, 0, 1, NULL, '', '2024-08-05 18:01:23', '2024-08-05 18:01:23', '127.0.0.1'),
(52, '', 'Bank Subscription Approved', 1, 0, 0, NULL, '', '2024-08-07 17:51:52', '2024-08-07 17:51:52', '127.0.0.1'),
(53, '', 'Merchant Registration is Approved', 1, 0, 0, NULL, '', '2024-08-08 10:05:24', '2024-08-08 10:05:24', '127.0.0.1'),
(54, '', 'Subscription Payment Received and Processed', 1, 0, 0, NULL, '', '2024-08-08 19:13:52', '2024-08-08 19:13:52', '127.0.0.1'),
(55, '', 'Subscription Payment Failed', 1, 0, 0, NULL, '', '2024-08-08 22:01:42', '2024-08-08 22:01:42', '127.0.0.1'),
(56, '', 'Subscription Canceled', 1, 0, 0, NULL, '', '2024-08-09 16:59:48', '2024-08-09 16:59:48', '127.0.0.1');

-- --------------------------------------------------------

--
-- Table structure for table `st_templates_translation`
--

CREATE TABLE `st_templates_translation` (
  `id` int(11) NOT NULL,
  `template_id` int(14) NOT NULL DEFAULT '0',
  `template_type` varchar(100) NOT NULL DEFAULT '',
  `language` varchar(255) NOT NULL DEFAULT '',
  `title` varchar(255) NOT NULL DEFAULT '',
  `content` longtext
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `st_templates_translation`
--

INSERT INTO `st_templates_translation` (`id`, `template_id`, `template_type`, `language`, `title`, `content`) VALUES
(1279, 4, 'email', 'en', 'Order Summary', '{% include \'header.html\' %}\r\n\r\n\r\n\r\n<table style=\"width:100%;\">\r\n <tbody><tr>\r\n  <td style=\"background:#fef9ef;padding:20px 30px;\">\r\n    <img style=\"max-width:15%;max-height:50px;\" src=\"{{logo}}\">\r\n  </td>\r\n </tr>\r\n <tr>\r\n   <td style=\"padding:30px;background:#ffffff;\" valign=\"middle\" align=\"center\">\r\n    <h2 style=\"margin:0;\">Thanks for your order</h2>\r\n    <p style=\"padding:10px;\">You\'ll receive an email when your food are ready to deliver. If you have any questions, Call us {{merchant.contact_phone}}.</p>\r\n    <br>    \r\n    <a href=\"{{order.order_info.tracking_link}}\" target=\"_blank\" style=\"display:block;margin:auto;max-width:200px;padding:10px;background:#3ecf8e;color:#fff;\r\n     text-decoration:none;font-size:18px;font-weight:bold;\">\r\n     Track Order\r\n     </a>\r\n    \r\n   </td>\r\n </tr>\r\n \r\n <tr>\r\n  <td style=\"background:#fef9ef;\">\r\n      {% include \'summary.html\' %}\r\n  </td>\r\n </tr>\r\n \r\n <tr>\r\n   <td style=\"background:#ffffff;\">\r\n     {% include \'items.html\' %}\r\n   </td>\r\n </tr>\r\n  \r\n <tr>\r\n  <td style=\"background:#fef9ef;padding:20px 30px;\">\r\n    \r\n    <table style=\"width:100%; table-layout: fixed;\">\r\n	  <tbody><tr>\r\n	    <th colspan=\"3\" style=\"text-align: left;\"><h5>Contact Us</h5></th>\r\n	    <th colspan=\"7\" style=\"text-align: left;\"><h5>For  promos, news, and updates, follow us on:</h5></th>\r\n	  </tr>\r\n	  <tr>\r\n	    <td colspan=\"3\" style=\"text-align: left; padding:0 3px;\" valign=\"top\">\r\n	     <p>{{site.address}}</p>\r\n         <p>{{site.contact}}</p>\r\n         <p>{{site.email}}</p>\r\n	    </td><td colspan=\"7\" style=\"padding:0 3px;\" valign=\"top\">\r\n	    \r\n	    {% include \'social_link.html\' %}\r\n	     \r\n	     <table>\r\n	      <tbody><tr>\r\n	      <td style=\"padding:0;\"><a href=\"#\" style=\"color:#000;font-size:16px;\">Terms and Conditions</a></td>\r\n	      <td>●</td>\r\n	      <td style=\"padding:0;\"><a href=\"#\" style=\"color:#000;font-size:16px;\">Privacy Policy</a></td>\r\n	      </tr>\r\n	     </tbody></table>\r\n	    \r\n	    </td>\r\n	  </tr>\r\n	</tbody></table>\r\n  \r\n  </td>\r\n </tr>\r\n \r\n</tbody></table>\r\n\r\n{% include \'footer.html\' %}'),
(1280, 4, 'email', 'ja', '', ''),
(1281, 4, 'email', 'ar', '', ''),
(1282, 4, 'sms', 'en', '', 'Your Order Being Processed #{{order_info.order_id}}'),
(1283, 4, 'sms', 'ja', '', ''),
(1284, 4, 'sms', 'ar', '', ''),
(1285, 4, 'push', 'en', '', 'Order Being Processed #{{order_info.order_id}}'),
(1286, 4, 'push', 'ja', '', ''),
(1287, 4, 'push', 'ar', '', ''),
(1423, 11, 'email', 'en', 'Partial refund for your #{{order_info.order_id}}', '{% include \'header.html\' %}\r\n\r\n\r\n\r\n<table style=\"width:100%;\">\r\n <tbody><tr>\r\n  <td style=\"background:#fef9ef;padding:20px 30px;\">\r\n    <img style=\"max-width:15%;max-height:50px;\" src=\"{{logo}}\">\r\n  </td>\r\n </tr>\r\n <tr>\r\n   <td style=\"padding:30px;background:#ffffff;\" valign=\"middle\" align=\"left\">\r\n   \r\n\r\n    <p style=\"padding-bottom:15px\">Hi {{order_info.customer_name}},</p>\r\n	<p style=\"line-height:20px;\">\r\n	Good News! We’ve processed your partial refund of {{additional_data.refund_amount}} for your item(s) from order #{{order_info.order_id}}.\r\n	</p>\r\n	\r\n	<p style=\"line-height:20px;\">Reversal may take 1 to 2 billing cycles or 5 to 15 banking days for local credit cards, and up to 45 banking days for international credit and debit cards, depending on your bank\'s processing time.</p>\r\n    \r\n   </td>\r\n </tr>\r\n \r\n <tr>\r\n  <td style=\"background:#fef9ef;\">\r\n      {% include \'summary.html\' %}\r\n  </td>\r\n </tr>\r\n \r\n <tr>\r\n   <td style=\"background:#ffffff;\">\r\n     {% include \'items.html\' %}\r\n   </td>\r\n </tr>\r\n  \r\n <tr>\r\n  <td style=\"background:#fef9ef;padding:20px 30px;\">\r\n    \r\n    <table style=\"width:100%; table-layout: fixed;\">\r\n	  <tbody><tr>\r\n	    <th colspan=\"3\" style=\"text-align: left;\"><h5>Contact Us</h5></th>\r\n	    <th colspan=\"7\" style=\"text-align: left;\"><h5>For  promos, news, and updates, follow us on:</h5></th>\r\n	  </tr>\r\n	  <tr>\r\n	    <td colspan=\"3\" style=\"text-align: left; padding:0 3px;\" valign=\"top\">\r\n	     <p>{{site.address}}</p>\r\n         <p>{{site.contact}}</p>\r\n         <p>{{site.email}}</p>\r\n	    </td><td colspan=\"7\" style=\"padding:0 3px;\" valign=\"top\">\r\n	    \r\n	    {% include \'social_link.html\' %}\r\n	     \r\n	     <table>\r\n	      <tbody><tr>\r\n	      <td style=\"padding:0;\"><a href=\"#\" style=\"color:#000;font-size:16px;\">Terms and Conditions</a></td>\r\n	      <td>●</td>\r\n	      <td style=\"padding:0;\"><a href=\"#\" style=\"color:#000;font-size:16px;\">Privacy Policy</a></td>\r\n	      </tr>\r\n	     </tbody></table>\r\n	    \r\n	    </td>\r\n	  </tr>\r\n	</tbody></table>\r\n  \r\n  </td>\r\n </tr>\r\n \r\n</tbody></table>\r\n\r\n{% include \'footer.html\' %}'),
(1424, 11, 'email', 'ja', '', ''),
(1425, 11, 'email', 'ar', '', ''),
(1426, 11, 'sms', 'en', '', ''),
(1427, 11, 'sms', 'ja', '', ''),
(1428, 11, 'sms', 'ar', '', ''),
(1429, 11, 'push', 'en', '', ''),
(1430, 11, 'push', 'ja', '', ''),
(1431, 11, 'push', 'ar', '', ''),
(1495, 13, 'email', 'en', 'OTP!', '{% include \'header.html\' %}\r\n<table style=\"width:100%;\">\r\n <tbody><tr>\r\n  <td style=\"background:#fef9ef;padding:20px 30px;\">\r\n    <img style=\"max-width:20%;max-height:50px;\" src=\"{{logo}}\">\r\n  </td>\r\n </tr>\r\n <tr>\r\n   <td style=\"padding:30px;background:#ffffff;\" valign=\"middle\" align=\"left\">\r\n    \r\n    <p>Hi <br></p>\r\n	\r\n	<p>Your OTP is {{code}}.</p>		\r\n	\r\n   </td>\r\n </tr>\r\n \r\n \r\n \r\n  \r\n <tr>\r\n  <td style=\"background:#fef9ef;padding:20px 30px;\">\r\n    \r\n   <table style=\"width:100%; table-layout: fixed;\">\r\n	  <tbody><tr>\r\n	    <th colspan=\"3\" style=\"text-align: left;\"><h5>Contact Us</h5></th>\r\n	    <th colspan=\"7\" style=\"text-align: left;\"><h5>For  promos, news, and updates, follow us on:</h5></th>\r\n	  </tr>\r\n	  <tr>\r\n	    <td colspan=\"3\" style=\"text-align: left; padding:0 3px;\" valign=\"top\">\r\n	     <p>{{site.address}}</p>\r\n         <p>{{site.contact}}</p>\r\n         <p>{{site.email}}</p>\r\n	    </td><td colspan=\"7\" style=\"padding:0 3px;\" valign=\"top\">\r\n	    \r\n	      {% include \'social_link.html\' %}\r\n	     \r\n	     <table>\r\n	      <tbody><tr>\r\n	      <td style=\"padding:0;\"><a href=\"#\" style=\"color:#000;font-size:16px;\">Terms and Conditions</a></td>\r\n	      <td>●</td>\r\n	      <td style=\"padding:0;\"><a href=\"#\" style=\"color:#000;font-size:16px;\">Privacy Policy</a></td>\r\n	      </tr>\r\n	     </tbody></table>\r\n	    \r\n	    </td>\r\n	  </tr>\r\n	</tbody></table>\r\n  \r\n  </td>\r\n </tr>\r\n \r\n</tbody></table>\r\n{% include \'footer.html\' %}\r\n'),
(1496, 13, 'email', 'ja', '', ''),
(1497, 13, 'email', 'ar', '', ''),
(1498, 13, 'sms', 'en', '', 'Your OTP is {{code}}.'),
(1499, 13, 'sms', 'ja', '', ''),
(1500, 13, 'sms', 'ar', '', ''),
(1501, 13, 'push', 'en', '', ''),
(1502, 13, 'push', 'ja', '', ''),
(1503, 13, 'push', 'ar', '', ''),
(1522, 12, 'email', 'en', '{{site.title}} - Registration', '{% include \'header.html\' %}\r\n<table style=\"width:100%;\">\r\n <tbody><tr>\r\n  <td style=\"background:#fef9ef;padding:20px 30px;\">\r\n    <img style=\"max-width:20%;max-height:50px;\" src=\"{{logo}}\">\r\n  </td>\r\n </tr>\r\n <tr>\r\n   <td style=\"padding:30px;background:#ffffff;\" valign=\"middle\" align=\"left\">\r\n    \r\n    <p style=\"margin-bottom:10px;\">Hi {{first_name}} {{last_name}},</p>\r\n	\r\n	<p>You\'ve successfully signed up for a {{site.title}} account! You can use this next time you order through {{site.title}},</p>		\r\n	<p>and you’ll get the latest promos, news, and updates.</p>\r\n	\r\n	<div style=\"padding-top:20px;\">\r\n	<p>Thank You!</p>\r\n	<p>{{site.title}} Team</p>\r\n	</div>\r\n	\r\n   </td>\r\n </tr>\r\n \r\n \r\n \r\n  \r\n <tr>\r\n  <td style=\"background:#fef9ef;padding:20px 30px;\">\r\n    \r\n   <table style=\"width:100%; table-layout: fixed;\">\r\n	  <tbody><tr>\r\n	    <th colspan=\"3\" style=\"text-align: left;\"><h5>Contact Us</h5></th>\r\n	    <th colspan=\"7\" style=\"text-align: left;\"><h5>For  promos, news, and updates, follow us on:</h5></th>\r\n	  </tr>\r\n	  <tr>\r\n	    <td colspan=\"3\" style=\"text-align: left; padding:0 3px;\" valign=\"top\">\r\n	     <p>{{site.address}}</p>\r\n         <p>{{site.contact}}</p>\r\n         <p>{{site.email}}</p>\r\n	    </td><td colspan=\"7\" style=\"padding:0 3px;\" valign=\"top\">\r\n	    \r\n	      {% include \'social_link.html\' %}\r\n	     \r\n	     <table>\r\n	      <tbody><tr>\r\n	      <td style=\"padding:0;\"><a href=\"#\" style=\"color:#000;font-size:16px;\">Terms and Conditions</a></td>\r\n	      <td>●</td>\r\n	      <td style=\"padding:0;\"><a href=\"#\" style=\"color:#000;font-size:16px;\">Privacy Policy</a></td>\r\n	      </tr>\r\n	     </tbody></table>\r\n	    \r\n	    </td>\r\n	  </tr>\r\n	</tbody></table>\r\n  \r\n  </td>\r\n </tr>\r\n \r\n</tbody></table>\r\n{% include \'footer.html\' %}\r\n'),
(1523, 12, 'email', 'ja', '', ''),
(1524, 12, 'email', 'ar', '', ''),
(1525, 12, 'sms', 'en', '', ''),
(1526, 12, 'sms', 'ja', '', ''),
(1527, 12, 'sms', 'ar', '', ''),
(1528, 12, 'push', 'en', '', ''),
(1529, 12, 'push', 'ja', '', ''),
(1530, 12, 'push', 'ar', '', ''),
(1531, 15, 'email', 'en', 'Review your order {{order_info.order_id}}', ''),
(1532, 15, 'email', 'ja', '', ''),
(1533, 15, 'email', 'ar', '', ''),
(1534, 15, 'sms', 'en', '', ''),
(1535, 15, 'sms', 'ja', '', ''),
(1536, 15, 'sms', 'ar', '', ''),
(1537, 15, 'push', 'en', '', ''),
(1538, 15, 'push', 'ja', '', ''),
(1539, 15, 'push', 'ar', '', ''),
(1585, 14, 'email', 'en', 'Password change instructions', '{% include \'header.html\' %}\r\n<table style=\"width:100%;\">\r\n <tbody><tr>\r\n  <td style=\"background:#fef9ef;padding:20px 30px;\">\r\n    <img style=\"max-width:20%;max-height:50px;\" src=\"{{logo}}\">\r\n  </td>\r\n </tr>\r\n <tr>\r\n   <td style=\"padding:30px;background:#ffffff;\" valign=\"middle\" align=\"left\">\r\n    \r\n   <table width=\"50%\" align=\"center\">\r\n   <tbody><tr>\r\n    <td>\r\n	\r\n	<p style=\"margin-bottom:10px;\">Hi {{first_name}} {{last_name}},</p>\r\n	\r\n	 <p style=\"margin-bottom:10px;\">It looks like you have forgotten your password. We can help you to create a new password.</p>\r\n	\r\n	<div style=\"margin:auto;text-align:center;padding-top:10px; padding-bottom:10px;\">\r\n	 <a href=\"{{reset_password_link}}\" target=\"_blank\" style=\"display:block;margin:auto;max-width:200px;padding:10px;background:#3ecf8e;color:#fff;\r\n     text-decoration:none;font-size:18px;font-weight:bold;\">\r\n     Reset Password\r\n     </a>\r\n	</div>\r\n	 \r\n	<p style=\"text-align:center;\">or click this link:</p>\r\n	<p style=\"text-align:center;\"><a href=\"{{reset_password_link}}\">{{reset_password_link}}</a></p>\r\n	\r\n	</td>\r\n   </tr>\r\n   </tbody></table>\r\n	\r\n   </td>\r\n </tr>\r\n \r\n \r\n \r\n  \r\n <tr>\r\n  <td style=\"background:#fef9ef;padding:20px 30px;\">\r\n    \r\n   <table style=\"width:100%; table-layout: fixed;\">\r\n	  <tbody><tr>\r\n	    <th colspan=\"3\" style=\"text-align: left;\"><h5>Contact Us</h5></th>\r\n	    <th colspan=\"7\" style=\"text-align: left;\"><h5>For  promos, news, and updates, follow us on:</h5></th>\r\n	  </tr>\r\n	  <tr>\r\n	    <td colspan=\"3\" style=\"text-align: left; padding:0 3px;\" valign=\"top\">\r\n	     <p>{{site.address}}</p>\r\n         <p>{{site.contact}}</p>\r\n         <p>{{site.email}}</p>\r\n	    </td><td colspan=\"7\" style=\"padding:0 3px;\" valign=\"top\">\r\n	    \r\n	      {% include \'social_link.html\' %}\r\n	     \r\n	     <table>\r\n	      <tbody><tr>\r\n	      <td style=\"padding:0;\"><a href=\"#\" style=\"color:#000;font-size:16px;\">Terms and Conditions</a></td>\r\n	      <td>●</td>\r\n	      <td style=\"padding:0;\"><a href=\"#\" style=\"color:#000;font-size:16px;\">Privacy Policy</a></td>\r\n	      </tr>\r\n	     </tbody></table>\r\n	    \r\n	    </td>\r\n	  </tr>\r\n	</tbody></table>\r\n  \r\n  </td>\r\n </tr>\r\n \r\n</tbody></table>\r\n{% include \'footer.html\' %}\r\n'),
(1586, 14, 'email', 'ja', '', ''),
(1587, 14, 'email', 'ar', '', ''),
(1588, 14, 'sms', 'en', '', ''),
(1589, 14, 'sms', 'ja', '', ''),
(1590, 14, 'sms', 'ar', '', ''),
(1591, 14, 'push', 'en', '', ''),
(1592, 14, 'push', 'ja', '', ''),
(1593, 14, 'push', 'ar', '', ''),
(1639, 17, 'email', 'en', 'Payout paid', '{% include \'header.html\' %}\r\n<table style=\"width:100%;\">\r\n <tbody><tr>\r\n  <td style=\"background:#fef9ef;padding:20px 30px;\">\r\n    <img style=\"max-width:20%;max-height:50px;\" src=\"{{logo}}\">\r\n  </td>\r\n </tr>\r\n <tr>\r\n   <td style=\"padding:30px;background:#ffffff;\" valign=\"middle\" align=\"left\">\r\n    \r\n    <p style=\"margin-bottom:15px;\">Hi {{restaurant_name}}<br></p>\r\n	\r\n	<p>Your Payout with transaction #{{transaction_id}} has been paid.</p>	\r\n	\r\n	<h5>Payout Details</h5>\r\n	<table width=\"60%\">\r\n	 <tbody><tr>\r\n	  <td width=\"25%\">Amount</td>\r\n	  <td>{{transaction_amount}}</td>\r\n	 </tr>\r\n	 <tr>\r\n	  <td>Payment Method</td>\r\n	  <td>{{payment_methood}</td>\r\n	 </tr>	\r\n	  <tr>\r\n	  <td>Transaction</td>\r\n	  <td>{{transaction_description}}</td>\r\n	 </tr>	\r\n	  <tr>\r\n	  <td>Date requested</td>\r\n	  <td>{{transaction_date}}</td>\r\n	 </tr>	 \r\n	</tbody></table>\r\n	\r\n   </td>\r\n </tr>\r\n \r\n \r\n \r\n  \r\n <tr>\r\n  <td style=\"background:#fef9ef;padding:20px 30px;\">\r\n    \r\n   <table style=\"width:100%; table-layout: fixed;\">\r\n	  <tbody><tr>\r\n	    <th colspan=\"3\" style=\"text-align: left;\"><h5>Contact Us</h5></th>\r\n	    <th colspan=\"7\" style=\"text-align: left;\"><h5>For  promos, news, and updates, follow us on:</h5></th>\r\n	  </tr>\r\n	  <tr>\r\n	    <td colspan=\"3\" style=\"text-align: left; padding:0 3px;\" valign=\"top\">\r\n	     <p>{{site.address}}</p>\r\n         <p>{{site.contact}}</p>\r\n         <p>{{site.email}}</p>\r\n	    </td><td colspan=\"7\" style=\"padding:0 3px;\" valign=\"top\">\r\n	    \r\n	      {% include \'social_link.html\' %}\r\n	     \r\n	     <table>\r\n	      <tbody><tr>\r\n	      <td style=\"padding:0;\"><a href=\"#\" style=\"color:#000;font-size:16px;\">Terms and Conditions</a></td>\r\n	      <td>●</td>\r\n	      <td style=\"padding:0;\"><a href=\"#\" style=\"color:#000;font-size:16px;\">Privacy Policy</a></td>\r\n	      </tr>\r\n	     </tbody></table>\r\n	    \r\n	    </td>\r\n	  </tr>\r\n	</tbody></table>\r\n  \r\n  </td>\r\n </tr>\r\n \r\n</tbody></table>\r\n{% include \'footer.html\' %}\r\n'),
(1640, 17, 'email', 'ja', '', ''),
(1641, 17, 'email', 'ar', '', ''),
(1642, 17, 'sms', 'en', '', ''),
(1643, 17, 'sms', 'ja', '', ''),
(1644, 17, 'sms', 'ar', '', ''),
(1645, 17, 'push', 'en', '', ''),
(1646, 17, 'push', 'ja', '', ''),
(1647, 17, 'push', 'ar', '', ''),
(1738, 5, 'email', 'en', 'New order #{{order_info.order_id}} from {{order_info.customer_name}}', '{% include \'header.html\' %}\r\n<table style=\"width:100%;\">\r\n <tbody><tr>\r\n  <td style=\"background:#fef9ef;padding:20px 30px;\">\r\n    <img style=\"max-width:20%;max-height:50px;\" src=\"{{logo}}\">\r\n  </td>\r\n </tr> \r\n <tr>\r\n  <td style=\"background:#ffffff;\">\r\n  \r\n    {% include \'summary.html\' %}\r\n   \r\n  </td>\r\n </tr>\r\n \r\n <tr>\r\n   <td>\r\n     {% include \'items.html\' %}\r\n   </td>\r\n </tr>\r\n  \r\n <tr>\r\n  <td style=\"background:#fef9ef;padding:20px 30px;\">\r\n    \r\n   <table style=\"width:100%; table-layout: fixed;\">\r\n	  <tbody><tr>\r\n	    <th colspan=\"3\" style=\"text-align: left;\"><h5>Contact Us</h5></th>\r\n	    <th colspan=\"7\" style=\"text-align: left;\"><h5>For  promos, news, and updates, follow us on:</h5></th>\r\n	  </tr>\r\n	  <tr>\r\n	    <td colspan=\"3\" style=\"text-align: left; padding:0 3px;\" valign=\"top\">\r\n	     <p>{{site.address}}</p>\r\n         <p>{{site.contact}}</p>\r\n         <p>{{site.email}}</p>\r\n	    </td><td colspan=\"7\" style=\"padding:0 3px;\" valign=\"top\">\r\n	    \r\n	      {% include \'social_link.html\' %}\r\n	     \r\n	     <table>\r\n	      <tbody><tr>\r\n	      <td style=\"padding:0;\"><a href=\"#\" style=\"color:#000;font-size:16px;\">Terms and Conditions</a></td>\r\n	      <td>●</td>\r\n	      <td style=\"padding:0;\"><a href=\"#\" style=\"color:#000;font-size:16px;\">Privacy Policy</a></td>\r\n	      </tr>\r\n	     </tbody></table>\r\n	    \r\n	    </td>\r\n	  </tr>\r\n	</tbody></table>\r\n  \r\n  </td>\r\n </tr>\r\n \r\n</tbody></table>\r\n{% include \'footer.html\' %}\r\n'),
(1739, 5, 'email', 'ja', '', ''),
(1740, 5, 'email', 'ar', '', ''),
(1741, 5, 'sms', 'en', '', 'New order #{{order_info.order_id}} from {{order_info.customer_name}}'),
(1742, 5, 'sms', 'ja', '', ''),
(1743, 5, 'sms', 'ar', '', ''),
(1744, 5, 'push', 'en', 'You have new order from {{customer_name}}', 'Order#{{order_id}} from {{customer_name}}'),
(1745, 5, 'push', 'ja', '', ''),
(1746, 5, 'push', 'ar', '', ''),
(1837, 19, 'email', 'en', 'You have new customer signup', '{% include \'header.html\' %}\r\n<table style=\"width:100%;\">\r\n <tbody><tr>\r\n  <td style=\"background:#fef9ef;padding:20px 30px;\">\r\n    <img style=\"max-width:20%;max-height:50px;\" src=\"{{logo}}\">\r\n  </td>\r\n </tr>\r\n <tr>\r\n   <td style=\"padding:30px;background:#ffffff;\" valign=\"middle\" align=\"left\">\r\n    \r\n    <p style=\"margin-bottom:15px;\">Hi <br></p>\r\n	\r\n	<p>You have new customer signup.</p>	\r\n	\r\n	<h5>Customer Details</h5>\r\n	<table width=\"60%\">\r\n	 <tbody><tr>\r\n	  <td width=\"25%\">First name</td>\r\n	  <td>{{first_name}}</td>\r\n	 </tr>\r\n	 <tr>\r\n	  <td>Last name</td>\r\n	  <td>{{last_name}}</td>\r\n	 </tr>	\r\n	  <tr>\r\n	  <td>Email address</td>\r\n	  <td>{{email_address}}</td>\r\n	 </tr>	\r\n	  <tr>\r\n	  <td>Phone number</td>\r\n	  <td>{{contact_phone}}</td>\r\n	 </tr>	 \r\n	</tbody></table>\r\n	\r\n   </td>\r\n </tr>\r\n \r\n \r\n \r\n  \r\n <tr>\r\n  <td style=\"background:#fef9ef;padding:20px 30px;\">\r\n    \r\n   <table style=\"width:100%; table-layout: fixed;\">\r\n	  <tbody><tr>\r\n	    <th colspan=\"3\" style=\"text-align: left;\"><h5>Contact Us</h5></th>\r\n	    <th colspan=\"7\" style=\"text-align: left;\"><h5>For  promos, news, and updates, follow us on:</h5></th>\r\n	  </tr>\r\n	  <tr>\r\n	    <td colspan=\"3\" style=\"text-align: left; padding:0 3px;\" valign=\"top\">\r\n	     <p>{{site.address}}</p>\r\n         <p>{{site.contact}}</p>\r\n         <p>{{site.email}}</p>\r\n	    </td><td colspan=\"7\" style=\"padding:0 3px;\" valign=\"top\">\r\n	    \r\n	      {% include \'social_link.html\' %}\r\n	     \r\n	     <table>\r\n	      <tbody><tr>\r\n	      <td style=\"padding:0;\"><a href=\"#\" style=\"color:#000;font-size:16px;\">Terms and Conditions</a></td>\r\n	      <td>●</td>\r\n	      <td style=\"padding:0;\"><a href=\"#\" style=\"color:#000;font-size:16px;\">Privacy Policy</a></td>\r\n	      </tr>\r\n	     </tbody></table>\r\n	    \r\n	    </td>\r\n	  </tr>\r\n	</tbody></table>\r\n  \r\n  </td>\r\n </tr>\r\n \r\n</tbody></table>\r\n{% include \'footer.html\' %}\r\n'),
(1838, 19, 'email', 'ja', '', ''),
(1839, 19, 'email', 'ar', '', ''),
(1840, 19, 'sms', 'en', '', 'You have new customer signup'),
(1841, 19, 'sms', 'ja', '', ''),
(1842, 19, 'sms', 'ar', '', ''),
(1843, 19, 'push', 'en', 'You have new customer signup', '{{first_name}} {{last_name}} has signup'),
(1844, 19, 'push', 'ja', '', ''),
(1845, 19, 'push', 'ar', '', ''),
(1864, 20, 'email', 'en', '', ''),
(1865, 20, 'email', 'ja', '', ''),
(1866, 20, 'email', 'ar', '', ''),
(1867, 20, 'sms', 'en', '', ''),
(1868, 20, 'sms', 'ja', '', ''),
(1869, 20, 'sms', 'ar', '', ''),
(1870, 20, 'push', 'en', 'Order #{{order_id}} from {{customer_name}} is cancelled', 'Order #{{order_id}} from {{customer_name}} is cancelled'),
(1871, 20, 'push', 'ja', '', ''),
(1872, 20, 'push', 'ar', '', ''),
(1909, 16, 'email', 'en', 'Payout new request', '{% include \'header.html\' %}\r\n<table style=\"width:100%;\">\r\n <tbody><tr>\r\n  <td style=\"background:#fef9ef;padding:20px 30px;\">\r\n    <img style=\"max-width:20%;max-height:50px;\" src=\"{{logo}}\">\r\n  </td>\r\n </tr>\r\n <tr>\r\n   <td style=\"padding:30px;background:#ffffff;\" valign=\"middle\" align=\"left\">\r\n    \r\n    <p style=\"margin-bottom:15px;\">Hi <br></p>\r\n	\r\n	<p style=\"margin-bottom:10px;\">New payout request by merchant details below.</p>	\r\n	\r\n	<h5>Payout Details</h5>\r\n	<table width=\"60%\">\r\n	 <tbody><tr>\r\n	  <td width=\"25%\">Amount</td>\r\n	  <td>{{transaction_amount}}</td>\r\n	 </tr>\r\n	 <tr>\r\n	  <td>Payment Method</td>\r\n	  <td>{{payment_method}}</td>\r\n	 </tr>	\r\n	  <tr>\r\n	  <td>Transaction</td>\r\n	  <td>{{transaction_description}}</td>\r\n	 </tr>	\r\n	  <tr>\r\n	  <td>Date requested</td>\r\n	  <td>{{transaction_date}}</td>\r\n	 </tr>	 \r\n	</tbody></table>\r\n	\r\n   </td>\r\n </tr>\r\n \r\n \r\n \r\n  \r\n <tr>\r\n  <td style=\"background:#fef9ef;padding:20px 30px;\">\r\n    \r\n   <table style=\"width:100%; table-layout: fixed;\">\r\n	  <tbody><tr>\r\n	    <th colspan=\"3\" style=\"text-align: left;\"><h5>Contact Us</h5></th>\r\n	    <th colspan=\"7\" style=\"text-align: left;\"><h5>For  promos, news, and updates, follow us on:</h5></th>\r\n	  </tr>\r\n	  <tr>\r\n	    <td colspan=\"3\" style=\"text-align: left; padding:0 3px;\" valign=\"top\">\r\n	     <p>{{site.address}}</p>\r\n         <p>{{site.contact}}</p>\r\n         <p>{{site.email}}</p>\r\n	    </td><td colspan=\"7\" style=\"padding:0 3px;\" valign=\"top\">\r\n	    \r\n	      {% include \'social_link.html\' %}\r\n	     \r\n	     <table>\r\n	      <tbody><tr>\r\n	      <td style=\"padding:0;\"><a href=\"#\" style=\"color:#000;font-size:16px;\">Terms and Conditions</a></td>\r\n	      <td>●</td>\r\n	      <td style=\"padding:0;\"><a href=\"#\" style=\"color:#000;font-size:16px;\">Privacy Policy</a></td>\r\n	      </tr>\r\n	     </tbody></table>\r\n	    \r\n	    </td>\r\n	  </tr>\r\n	</tbody></table>\r\n  \r\n  </td>\r\n </tr>\r\n \r\n</tbody></table>\r\n{% include \'footer.html\' %}\r\n'),
(1910, 16, 'email', 'ja', '', ''),
(1911, 16, 'email', 'ar', '', ''),
(1912, 16, 'sms', 'en', '', ''),
(1913, 16, 'sms', 'ja', '', ''),
(1914, 16, 'sms', 'ar', '', ''),
(1915, 16, 'push', 'en', 'New payout new request', 'New payout new request from {{restaurant_name}}'),
(1916, 16, 'push', 'ja', '', ''),
(1917, 16, 'push', 'ar', '', ''),
(1927, 18, 'email', 'en', 'Payout cancelled', '{% include \'header.html\' %}\r\n<table style=\"width:100%;\">\r\n <tbody><tr>\r\n  <td style=\"background:#fef9ef;padding:20px 30px;\">\r\n    <img style=\"max-width:20%;max-height:50px;\" src=\"{{logo}}\">\r\n  </td>\r\n </tr>\r\n <tr>\r\n   <td style=\"padding:30px;background:#ffffff;\" valign=\"middle\" align=\"left\">\r\n    \r\n    <p style=\"margin-bottom:15px;\">Hi {{restaurant_name}}<br></p>\r\n	\r\n	<p>Your Payout with transaction #{{transaction_id}} has been cancelled.</p>	\r\n	\r\n	<h5>Payout Details</h5>\r\n	<table width=\"60%\">\r\n	 <tbody><tr>\r\n	  <td width=\"25%\">Amount</td>\r\n	  <td>{{transaction_amount}}</td>\r\n	 </tr>\r\n	 <tr>\r\n	  <td>Payment Method</td>\r\n	  <td>{{payment_methood}}</td>\r\n	 </tr>	\r\n	  <tr>\r\n	  <td>Transaction</td>\r\n	  <td>{{transaction_description}}</td>\r\n	 </tr>	\r\n	  <tr>\r\n	  <td>Date requested</td>\r\n	  <td>{{transaction_date}}</td>\r\n	 </tr>	 \r\n	</tbody></table>\r\n	\r\n   </td>\r\n </tr>\r\n \r\n \r\n \r\n  \r\n <tr>\r\n  <td style=\"background:#fef9ef;padding:20px 30px;\">\r\n    \r\n   <table style=\"width:100%; table-layout: fixed;\">\r\n	  <tbody><tr>\r\n	    <th colspan=\"3\" style=\"text-align: left;\"><h5>Contact Us</h5></th>\r\n	    <th colspan=\"7\" style=\"text-align: left;\"><h5>For  promos, news, and updates, follow us on:</h5></th>\r\n	  </tr>\r\n	  <tr>\r\n	    <td colspan=\"3\" style=\"text-align: left; padding:0 3px;\" valign=\"top\">\r\n	     <p>{{site.address}}</p>\r\n         <p>{{site.contact}}</p>\r\n         <p>{{site.email}}</p>\r\n	    </td><td colspan=\"7\" style=\"padding:0 3px;\" valign=\"top\">\r\n	    \r\n	      {% include \'social_link.html\' %}\r\n	     \r\n	     <table>\r\n	      <tbody><tr>\r\n	      <td style=\"padding:0;\"><a href=\"#\" style=\"color:#000;font-size:16px;\">Terms and Conditions</a></td>\r\n	      <td>●</td>\r\n	      <td style=\"padding:0;\"><a href=\"#\" style=\"color:#000;font-size:16px;\">Privacy Policy</a></td>\r\n	      </tr>\r\n	     </tbody></table>\r\n	    \r\n	    </td>\r\n	  </tr>\r\n	</tbody></table>\r\n  \r\n  </td>\r\n </tr>\r\n \r\n</tbody></table>\r\n{% include \'footer.html\' %}\r\n'),
(1928, 18, 'email', 'ja', '', ''),
(1929, 18, 'email', 'ar', '', ''),
(1930, 18, 'sms', 'en', '', ''),
(1931, 18, 'sms', 'ja', '', ''),
(1932, 18, 'sms', 'ar', '', ''),
(1933, 18, 'push', 'en', 'Your payout request is cancelled', '{{restaurant_name}} Your payout request with the amount of {{transaction_amount}} is cancel'),
(1934, 18, 'push', 'ja', '', ''),
(1935, 18, 'push', 'ar', '', ''),
(1981, 8, 'email', 'en', 'Sorry for the delay in delivery!', '{% include \'header.html\' %}\r\n<table style=\"width:100%;\">\r\n <tbody><tr>\r\n  <td style=\"background:#fef9ef;padding:20px 30px;\">\r\n    <img style=\"max-width:20%;max-height:50px;\" src=\"{{logo}}\">\r\n  </td>\r\n </tr>\r\n <tr>\r\n   <td style=\"padding:30px;background:#ffffff;\" valign=\"middle\" align=\"left\">\r\n    \r\n    <p>Hi {{order_info.customer_name}},</p>\r\n	\r\n	<p>We are sorry the item(s) from your order {{order_info.order_id}} is taking longer than expected. \r\n	We are working closely with the restaurant team to deliver this order as soon as possible.​</p>\r\n	\r\n	<p><b>{{order_info.delayed_order}}</b></p>\r\n	\r\n	<p>\r\n	Please make sure to turn on your App notification to get the latest updates on your order. \r\n	</p>\r\n    \r\n   </td>\r\n </tr>\r\n \r\n <tr>\r\n  <td style=\"background:#fef9ef;\">\r\n  \r\n     {% include \'summary.html\' %}\r\n   \r\n  </td>\r\n </tr>\r\n \r\n <tr>\r\n   <td style=\"background:#ffffff;\">\r\n     {% include \'items.html\' %}\r\n   </td>\r\n </tr>\r\n  \r\n <tr>\r\n  <td style=\"background:#fef9ef;padding:20px 30px;\">\r\n    \r\n   <table style=\"width:100%; table-layout: fixed;\">\r\n	  <tbody><tr>\r\n	    <th colspan=\"3\" style=\"text-align: left;\"><h5>Contact Us</h5></th>\r\n	    <th colspan=\"7\" style=\"text-align: left;\"><h5>For  promos, news, and updates, follow us on:</h5></th>\r\n	  </tr>\r\n	  <tr>\r\n	    <td colspan=\"3\" style=\"text-align: left; padding:0 3px;\" valign=\"top\">\r\n	     <p>{{site.address}}</p>\r\n         <p>{{site.contact}}</p>\r\n         <p>{{site.email}}</p>\r\n	    </td><td colspan=\"7\" style=\"padding:0 3px;\" valign=\"top\">\r\n	    \r\n	      {% include \'social_link.html\' %}\r\n	     \r\n	     <table>\r\n	      <tbody><tr>\r\n	      <td style=\"padding:0;\"><a href=\"#\" style=\"color:#000;font-size:16px;\">Terms and Conditions</a></td>\r\n	      <td>●</td>\r\n	      <td style=\"padding:0;\"><a href=\"#\" style=\"color:#000;font-size:16px;\">Privacy Policy</a></td>\r\n	      </tr>\r\n	     </tbody></table>\r\n	    \r\n	    </td>\r\n	  </tr>\r\n	</tbody></table>\r\n  \r\n  </td>\r\n </tr>\r\n \r\n</tbody></table>\r\n{% include \'footer.html\' %}\r\n'),
(1982, 8, 'email', 'ja', '', ''),
(1983, 8, 'email', 'ar', '', ''),
(1984, 8, 'sms', 'en', '', ''),
(1985, 8, 'sms', 'ja', '', ''),
(1986, 8, 'sms', 'ar', '', ''),
(1987, 8, 'push', 'en', 'Order #{{order_id}} will be late, {{delayed_order_mins}}min(s)', 'Your order@{{order_id}} will be late, in {{delayed_order_mins}}min(s)'),
(1988, 8, 'push', 'ja', '', ''),
(1989, 8, 'push', 'ar', '', ''),
(2008, 7, 'email', 'en', 'Your order #{{order_info.order_id}} is cancelled', '{% include \'header.html\' %}\r\n<table style=\"width:100%;\">\r\n <tbody><tr>\r\n  <td style=\"background:#fef9ef;padding:20px 30px;\">\r\n    <img style=\"max-width:20%;max-height:50px;\" src=\"{{logo}}\">\r\n  </td>\r\n </tr>\r\n <tr>\r\n   <td style=\"padding:30px;background:#ffffff;\" valign=\"middle\" align=\"center\">\r\n    <h2 style=\"margin:0;\">Your order #{{order_id}} has been cancelled</h2>\r\n    <p style=\"padding:10px;\">unfortunately merchant cannot fulfill your order, merchant says <b>{{order_info.rejetion_reason}}</b></p>\r\n    \r\n   </td>\r\n </tr>\r\n \r\n <tr>\r\n  <td style=\"background:#fef9ef;\">\r\n  \r\n     {% include \'summary.html\' %}\r\n   \r\n  </td>\r\n </tr>\r\n \r\n <tr>\r\n   <td style=\"background:#ffffff;\">\r\n     {% include \'items.html\' %}\r\n   </td>\r\n </tr>\r\n  \r\n <tr>\r\n  <td style=\"background:#fef9ef;padding:20px 30px;\">\r\n    \r\n   <table style=\"width:100%; table-layout: fixed;\">\r\n	  <tbody><tr>\r\n	    <th colspan=\"3\" style=\"text-align: left;\"><h5>Contact Us</h5></th>\r\n	    <th colspan=\"7\" style=\"text-align: left;\"><h5>For  promos, news, and updates, follow us on:</h5></th>\r\n	  </tr>\r\n	  <tr>\r\n	    <td colspan=\"3\" style=\"text-align: left; padding:0 3px;\" valign=\"top\">\r\n	     <p>{{site.address}}</p>\r\n         <p>{{site.contact}}</p>\r\n         <p>{{site.email}}</p>\r\n	    </td><td colspan=\"7\" style=\"padding:0 3px;\" valign=\"top\">\r\n	    \r\n	      {% include \'social_link.html\' %}\r\n	     \r\n	     <table>\r\n	      <tbody><tr>\r\n	      <td style=\"padding:0;\"><a href=\"#\" style=\"color:#000;font-size:16px;\">Terms and Conditions</a></td>\r\n	      <td>●</td>\r\n	      <td style=\"padding:0;\"><a href=\"#\" style=\"color:#000;font-size:16px;\">Privacy Policy</a></td>\r\n	      </tr>\r\n	     </tbody></table>\r\n	    \r\n	    </td>\r\n	  </tr>\r\n	</tbody></table>\r\n  \r\n  </td>\r\n </tr>\r\n \r\n</tbody></table>\r\n{% include \'footer.html\' %}\r\n'),
(2009, 7, 'email', 'ja', '', ''),
(2010, 7, 'email', 'ar', '', ''),
(2011, 7, 'sms', 'en', '', ''),
(2012, 7, 'sms', 'ja', '', ''),
(2013, 7, 'sms', 'ar', '', ''),
(2014, 7, 'push', 'en', 'Your order #{{order_id}} is cancelled', 'Your order #{{order_id}} is cancelled'),
(2015, 7, 'push', 'ja', '', ''),
(2016, 7, 'push', 'ar', '', ''),
(2017, 9, 'email', 'en', 'Your order #{{order_info.order_id}} is accepted by {{merchant.restaurant_name}}', '{% include \'header.html\' %}\r\n\r\n\r\n\r\n<table style=\"width:100%;\">\r\n <tbody><tr>\r\n  <td style=\"background:#fef9ef;padding:20px 30px;\">\r\n    <img style=\"max-width:15%;max-height:50px;\" src=\"{{logo}}\">\r\n  </td>\r\n </tr>\r\n <tr>\r\n   <td style=\"padding:30px;background:#ffffff;\" valign=\"middle\" align=\"center\">\r\n    <h2 style=\"margin:0;\">Order Accepted<br></h2>\r\n    <p>Your order is confirmed and is now being prepared by the store. We\'ll let you know once our rider is on his way to you.</p><p>Conveniently track your order by clicking track order.<br></p>\r\n    <a href=\"{{order.order_info.tracking_link}}\" target=\"_blank\" style=\"display:block;margin:auto;max-width:200px;padding:10px;background:#3ecf8e;color:#fff;\r\n     text-decoration:none;font-size:18px;font-weight:bold;\">\r\n     Track Order\r\n     </a>\r\n    \r\n   </td>\r\n </tr>\r\n \r\n <tr>\r\n  <td style=\"background:#fef9ef;\">\r\n      {% include \'summary.html\' %}\r\n  </td>\r\n </tr>\r\n \r\n <tr>\r\n   <td style=\"background:#ffffff;\">\r\n     {% include \'items.html\' %}\r\n   </td>\r\n </tr>\r\n  \r\n <tr>\r\n  <td style=\"background:#fef9ef;padding:20px 30px;\">\r\n    \r\n    <table style=\"width:100%; table-layout: fixed;\">\r\n	  <tbody><tr>\r\n	    <th colspan=\"3\" style=\"text-align: left;\"><h5>Contact Us</h5></th>\r\n	    <th colspan=\"7\" style=\"text-align: left;\"><h5>For  promos, news, and updates, follow us on:</h5></th>\r\n	  </tr>\r\n	  <tr>\r\n	    <td colspan=\"3\" style=\"text-align: left; padding:0 3px;\" valign=\"top\">\r\n	     <p>{{site.address}}</p>\r\n         <p>{{site.contact}}</p>\r\n         <p>{{site.email}}</p>\r\n	    </td><td colspan=\"7\" style=\"padding:0 3px;\" valign=\"top\">\r\n	    \r\n	    {% include \'social_link.html\' %}\r\n	     \r\n	     <table>\r\n	      <tbody><tr>\r\n	      <td style=\"padding:0;\"><a href=\"#\" style=\"color:#000;font-size:16px;\">Terms and Conditions</a></td>\r\n	      <td>●</td>\r\n	      <td style=\"padding:0;\"><a href=\"#\" style=\"color:#000;font-size:16px;\">Privacy Policy</a></td>\r\n	      </tr>\r\n	     </tbody></table>\r\n	    \r\n	    </td>\r\n	  </tr>\r\n	</tbody></table>\r\n  \r\n  </td>\r\n </tr>\r\n \r\n</tbody></table>\r\n\r\n{% include \'footer.html\' %}'),
(2018, 9, 'email', 'ja', '', ''),
(2019, 9, 'email', 'ar', '', ''),
(2020, 9, 'sms', 'en', '', ''),
(2021, 9, 'sms', 'ja', '', ''),
(2022, 9, 'sms', 'ar', '', ''),
(2023, 9, 'push', 'en', 'Your order #{{order_id}} is accepted by {{restaurant_name}}', 'Your order #{{order_id}} is accepted by {{restaurant_name}}'),
(2024, 9, 'push', 'ja', '', ''),
(2025, 9, 'push', 'ar', '', ''),
(2035, 6, 'email', 'en', 'Your order #{{order_id}} has been rejected', '{% include \'header.html\' %}\r\n<table style=\"width:100%;\">\r\n <tbody><tr>\r\n  <td style=\"background:#fef9ef;padding:20px 30px;\">\r\n    <img style=\"max-width:20%;max-height:50px;\" src=\"{{logo}}\">\r\n  </td>\r\n </tr>\r\n <tr>\r\n   <td style=\"padding:30px;background:#ffffff;\" valign=\"middle\" align=\"center\">\r\n    <h2 style=\"margin:0;\">Your order #{{order_id}} has been rejected</h2>\r\n    <p style=\"padding:10px;\">unfortunately merchant cannot fulfill your order, merchant says <b>{{order_info.rejetion_reason}}</b></p>\r\n    \r\n   </td>\r\n </tr>\r\n \r\n <tr>\r\n  <td style=\"background:#fef9ef;\">\r\n  \r\n     {% include \'summary.html\' %}\r\n   \r\n  </td>\r\n </tr>\r\n \r\n <tr>\r\n   <td style=\"background:#ffffff;\">\r\n     {% include \'items.html\' %}\r\n   </td>\r\n </tr>\r\n  \r\n <tr>\r\n  <td style=\"background:#fef9ef;padding:20px 30px;\">\r\n    \r\n   <table style=\"width:100%; table-layout: fixed;\">\r\n	  <tbody><tr>\r\n	    <th colspan=\"3\" style=\"text-align: left;\"><h5>Contact Us</h5></th>\r\n	    <th colspan=\"7\" style=\"text-align: left;\"><h5>For  promos, news, and updates, follow us on:</h5></th>\r\n	  </tr>\r\n	  <tr>\r\n	    <td colspan=\"3\" style=\"text-align: left; padding:0 3px;\" valign=\"top\">\r\n	     <p>{{site.address}}</p>\r\n         <p>{{site.contact}}</p>\r\n         <p>{{site.email}}</p>\r\n	    </td><td colspan=\"7\" style=\"padding:0 3px;\" valign=\"top\">\r\n	    \r\n	      {% include \'social_link.html\' %}\r\n	     \r\n	     <table>\r\n	      <tbody><tr>\r\n	      <td style=\"padding:0;\"><a href=\"#\" style=\"color:#000;font-size:16px;\">Terms and Conditions</a></td>\r\n	      <td>●</td>\r\n	      <td style=\"padding:0;\"><a href=\"#\" style=\"color:#000;font-size:16px;\">Privacy Policy</a></td>\r\n	      </tr>\r\n	     </tbody></table>\r\n	    \r\n	    </td>\r\n	  </tr>\r\n	</tbody></table>\r\n  \r\n  </td>\r\n </tr>\r\n \r\n</tbody></table>\r\n{% include \'footer.html\' %}\r\n'),
(2036, 6, 'email', 'ja', '', ''),
(2037, 6, 'email', 'ar', '', ''),
(2038, 6, 'sms', 'en', '', ''),
(2039, 6, 'sms', 'ja', '', ''),
(2040, 6, 'sms', 'ar', '', ''),
(2041, 6, 'push', 'en', 'Your order #{{order_id}} has been rejected', 'Your order #{{order_id}} has been rejected'),
(2042, 6, 'push', 'ja', '', ''),
(2043, 6, 'push', 'ar', '', ''),
(2053, 22, 'email', 'en', '', ''),
(2054, 22, 'email', 'ja', '', ''),
(2055, 22, 'email', 'ar', '', ''),
(2056, 22, 'sms', 'en', '', ''),
(2057, 22, 'sms', 'ja', '', ''),
(2058, 22, 'sms', 'ar', '', ''),
(2059, 22, 'push', 'en', 'Your order #{{order_id}} successfully delivered', 'Your order #{{order_id}} successfully delivered'),
(2060, 22, 'push', 'ja', '', ''),
(2061, 22, 'push', 'ar', '', ''),
(2071, 10, 'email', 'en', 'Order is on the way!', '{% include \'header.html\' %}\r\n\r\n\r\n\r\n<table style=\"width:100%;\">\r\n <tbody><tr>\r\n  <td style=\"background:#fef9ef;padding:20px 30px;\">\r\n    <img style=\"max-width:15%;max-height:50px;\" src=\"{{logo}}\">\r\n  </td>\r\n </tr>\r\n <tr>\r\n   <td style=\"padding:30px;background:#ffffff;\" valign=\"middle\" align=\"center\">\r\n    <h2 style=\"margin:0;\">Order is on the way!<br></h2>\r\n    <p style=\"padding:10px;\">For everyone safety is our priority so remember to wash your hands before and after receiving your order<br></p>\r\n    <br>    \r\n    <a href=\"{{order.order_info.tracking_link}}\" target=\"_blank\" style=\"display:block;margin:auto;max-width:200px;padding:10px;background:#3ecf8e;color:#fff;\r\n     text-decoration:none;font-size:18px;font-weight:bold;\">\r\n     Track Order\r\n     </a>\r\n    \r\n   </td>\r\n </tr>\r\n \r\n <tr>\r\n  <td style=\"background:#fef9ef;\">\r\n      {% include \'summary.html\' %}\r\n  </td>\r\n </tr>\r\n \r\n <tr>\r\n   <td style=\"background:#ffffff;\">\r\n     {% include \'items.html\' %}\r\n   </td>\r\n </tr>\r\n  \r\n <tr>\r\n  <td style=\"background:#fef9ef;padding:20px 30px;\">\r\n    \r\n    <table style=\"width:100%; table-layout: fixed;\">\r\n	  <tbody><tr>\r\n	    <th colspan=\"3\" style=\"text-align: left;\"><h5>Contact Us</h5></th>\r\n	    <th colspan=\"7\" style=\"text-align: left;\"><h5>For  promos, news, and updates, follow us on:</h5></th>\r\n	  </tr>\r\n	  <tr>\r\n	    <td colspan=\"3\" style=\"text-align: left; padding:0 3px;\" valign=\"top\">\r\n	     <p>{{site.address}}</p>\r\n         <p>{{site.contact}}</p>\r\n         <p>{{site.email}}</p>\r\n	    </td><td colspan=\"7\" style=\"padding:0 3px;\" valign=\"top\">\r\n	    \r\n	    {% include \'social_link.html\' %}\r\n	     \r\n	     <table>\r\n	      <tbody><tr>\r\n	      <td style=\"padding:0;\"><a href=\"#\" style=\"color:#000;font-size:16px;\">Terms and Conditions</a></td>\r\n	      <td>●</td>\r\n	      <td style=\"padding:0;\"><a href=\"#\" style=\"color:#000;font-size:16px;\">Privacy Policy</a></td>\r\n	      </tr>\r\n	     </tbody></table>\r\n	    \r\n	    </td>\r\n	  </tr>\r\n	</tbody></table>\r\n  \r\n  </td>\r\n </tr>\r\n \r\n</tbody></table>\r\n\r\n{% include \'footer.html\' %}'),
(2072, 10, 'email', 'ja', '', ''),
(2073, 10, 'email', 'ar', '', ''),
(2074, 10, 'sms', 'en', '', ''),
(2075, 10, 'sms', 'ja', '', ''),
(2076, 10, 'sms', 'ar', '', ''),
(2077, 10, 'push', 'en', 'Your order #{{order_id}} is on its way!', 'Your order #{{order_id}} is on its way!'),
(2078, 10, 'push', 'ja', '', ''),
(2079, 10, 'push', 'ar', '', ''),
(2080, 21, 'email', 'en', 'Order is on the way!', '{% include \'header.html\' %}\r\n\r\n\r\n\r\n<table style=\"width:100%;\">\r\n <tbody><tr>\r\n  <td style=\"background:#fef9ef;padding:20px 30px;\">\r\n    <img style=\"max-width:15%;max-height:50px;\" src=\"{{logo}}\">\r\n  </td>\r\n </tr>\r\n <tr>\r\n   <td style=\"padding:30px;background:#ffffff;\" valign=\"middle\" align=\"center\">\r\n    <h2 style=\"margin:0;\">Order is on the way!<br></h2>\r\n    <p style=\"padding:10px;\">For everyone safety is our priority so remember to wash your hands before and after receiving your order<br></p>\r\n    <br>    \r\n    <a href=\"{{order.order_info.tracking_link}}\" target=\"_blank\" style=\"display:block;margin:auto;max-width:200px;padding:10px;background:#3ecf8e;color:#fff;\r\n     text-decoration:none;font-size:18px;font-weight:bold;\">\r\n     Track Order\r\n     </a>\r\n    \r\n   </td>\r\n </tr>\r\n \r\n <tr>\r\n  <td style=\"background:#fef9ef;\">\r\n      {% include \'summary.html\' %}\r\n  </td>\r\n </tr>\r\n \r\n <tr>\r\n   <td style=\"background:#ffffff;\">\r\n     {% include \'items.html\' %}\r\n   </td>\r\n </tr>\r\n  \r\n <tr>\r\n  <td style=\"background:#fef9ef;padding:20px 30px;\">\r\n    \r\n    <table style=\"width:100%; table-layout: fixed;\">\r\n	  <tbody><tr>\r\n	    <th colspan=\"3\" style=\"text-align: left;\"><h5>Contact Us</h5></th>\r\n	    <th colspan=\"7\" style=\"text-align: left;\"><h5>For  promos, news, and updates, follow us on:</h5></th>\r\n	  </tr>\r\n	  <tr>\r\n	    <td colspan=\"3\" style=\"text-align: left; padding:0 3px;\" valign=\"top\">\r\n	     <p>{{site.address}}</p>\r\n         <p>{{site.contact}}</p>\r\n         <p>{{site.email}}</p>\r\n	    </td><td colspan=\"7\" style=\"padding:0 3px;\" valign=\"top\">\r\n	    \r\n	    {% include \'social_link.html\' %}\r\n	     \r\n	     <table>\r\n	      <tbody><tr>\r\n	      <td style=\"padding:0;\"><a href=\"#\" style=\"color:#000;font-size:16px;\">Terms and Conditions</a></td>\r\n	      <td>●</td>\r\n	      <td style=\"padding:0;\"><a href=\"#\" style=\"color:#000;font-size:16px;\">Privacy Policy</a></td>\r\n	      </tr>\r\n	     </tbody></table>\r\n	    \r\n	    </td>\r\n	  </tr>\r\n	</tbody></table>\r\n  \r\n  </td>\r\n </tr>\r\n \r\n</tbody></table>\r\n\r\n{% include \'footer.html\' %}'),
(2081, 21, 'email', 'ja', '', ''),
(2082, 21, 'email', 'ar', '', ''),
(2083, 21, 'sms', 'en', '', ''),
(2084, 21, 'sms', 'ja', '', ''),
(2085, 21, 'sms', 'ar', '', ''),
(2086, 21, 'push', 'en', 'Your order #{{order_id}} is on its way!', 'Your order #{{order_id}} is on its way!'),
(2087, 21, 'push', 'ja', '', ''),
(2088, 21, 'push', 'ar', '', ''),
(2089, 23, 'email', 'en', '', ''),
(2090, 23, 'email', 'ja', '', ''),
(2091, 23, 'email', 'ar', '', ''),
(2092, 23, 'sms', 'en', '', ''),
(2093, 23, 'sms', 'ja', '', ''),
(2094, 23, 'sms', 'ar', '', ''),
(2095, 23, 'push', 'en', 'unfortunately your order#{{order_id}} has failed to deliver', 'unfortunately your order#{{order_id}} has failed to deliver'),
(2096, 23, 'push', 'ja', '', ''),
(2097, 23, 'push', 'ar', '', ''),
(2170, 2, 'email', 'en', 'Invoice for your order #{{order_info.order_id}}', '{% include \'header.html\' %}\r\n\r\n<table style=\"width:100%;\">\r\n <tbody><tr>\r\n  <td style=\"background:#fef9ef;padding:20px 30px;\">\r\n    <img style=\"max-width:20%;max-height:50px;\" src=\"{{logo}}\">\r\n  </td>\r\n </tr>\r\n <tr>\r\n   <td style=\"padding:30px;padding-bottom:10px;background:#ffffff;\" valign=\"middle\" align=\"center\">\r\n    <h2 style=\"margin:0;\">Invoice #{{additional_data.invoice_number}}</h2>    \r\n   </td>   \r\n </tr>\r\n <tr>\r\n   <td style=\"padding-bottom:10px;background:#ffffff;\" valign=\"middle\">\r\n     <table width=\"80%\" align=\"center\">\r\n      <tbody><tr> \r\n       <td>\r\n        <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis ullamcorper sapien ullamcorper nibh aliquam, non rutrum orci vulputate. Donec congue ac tortor eu dignissim. Cras a libero lobortis tellus elementum consequat eget vitae turpis. Mauris non lorem odio. Integer in lacus bibendum, accumsan risus nec, pretium felis. Aliquam auctor nec eros a mattis. Praesent eu ligula vitae ex rhoncus aliquam. Pellentesque ut mattis lectus. Maecenas ultrices a lorem et interdum. Mauris lacinia nec libero id tincidunt. Nunc accumsan quis enim vitae pellentesque.</p>        \r\n       </td>\r\n      </tr>\r\n     </tbody></table>\r\n   </td>   \r\n </tr>\r\n \r\n <tr>\r\n  <td style=\"background:#fef9ef;\">\r\n  \r\n     {% include \'summary.html\' %}\r\n  </td>\r\n </tr>\r\n \r\n <tr>\r\n  <td style=\"padding:30px;\" align=\"center\">\r\n     <a href=\"{{additional_data.payment_link}}\" target=\"_blank\" style=\"display:block;margin:auto;max-width:200px;padding:10px;background:#3ecf8e;color:#fff;\r\n     text-decoration:none;font-size:18px;font-weight:bold;\">\r\n     Pay Now\r\n     </a>\r\n  </td>\r\n </tr>\r\n \r\n  <tr>\r\n  <td style=\"background:#fef9ef;padding:20px 30px;\">\r\n    \r\n     <table style=\"width:100%; table-layout: fixed;\">\r\n	  <tbody><tr>\r\n	    <th colspan=\"3\" style=\"text-align: left;\"><h5>Contact Us</h5></th>\r\n	    <th colspan=\"7\" style=\"text-align: left;\"><h5>For  promos, news, and updates, follow us on:</h5></th>\r\n	  </tr>\r\n	  <tr>\r\n	    <td colspan=\"3\" style=\"text-align: left; padding:0 3px;\" valign=\"top\">\r\n	     <p>{{site.address}}</p>\r\n         <p>{{site.contact}}</p>\r\n         <p>{{site.email}}</p>\r\n	    </td><td colspan=\"7\" style=\"padding:0 3px;\" valign=\"top\">\r\n	    \r\n	    {% include \'social_link.html\' %}\r\n	     \r\n	     <table>\r\n	      <tbody><tr>\r\n	      <td style=\"padding:0;\"><a href=\"#\" style=\"color:#000;font-size:16px;\">Terms and Conditions</a></td>\r\n	      <td>●</td>\r\n	      <td style=\"padding:0;\"><a href=\"#\" style=\"color:#000;font-size:16px;\">Privacy Policy</a></td>\r\n	      </tr>\r\n	     </tbody></table>\r\n	    \r\n	    </td>\r\n	  </tr>\r\n	</tbody></table>\r\n  \r\n  </td>\r\n </tr>\r\n \r\n</tbody></table>\r\n\r\n\r\n{% include \'footer.html\' %}\r\n'),
(2171, 2, 'email', 'ja', '', ''),
(2172, 2, 'email', 'ar', '', ''),
(2173, 2, 'sms', 'en', '', 'Your order #{{order_info.order_id}}, has a balance of {{additional_data.balance}}.\r\npay here {{additional_data.payment_link}}'),
(2174, 2, 'sms', 'ja', '', ''),
(2175, 2, 'sms', 'ar', '', ''),
(2176, 2, 'push', 'en', 'Your order #{{order_id}}, has a balance of {{balance}}. pay here {{payment_link}}', 'Your order #{{order_id}}, has a balance of {{balance}}.\r\npay here {{payment_link}}'),
(2177, 2, 'push', 'ja', '', ''),
(2178, 2, 'push', 'ar', '', ''),
(2179, 24, 'email', 'en', 'Your registration is complete!', '{% include \'header.html\' %}\r\n<table style=\"width:100%;\">\r\n <tbody><tr>\r\n  <td style=\"background:#fef9ef;padding:20px 30px;\">\r\n    <img style=\"max-width:20%;max-height:50px;\" src=\"{{logo}}\">\r\n  </td>\r\n </tr>\r\n <tr>\r\n   <td style=\"padding:30px;background:#ffffff;\" valign=\"middle\" align=\"left\">\r\n    \r\n   <table width=\"50%\" align=\"center\">\r\n   <tbody><tr>\r\n    <td>\r\n	\r\n	<p style=\"margin-bottom:10px;\">Hi {{restaurant_name}},</p>\r\n	\r\n	 <p style=\"margin-bottom:10px;\">Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus quis nunc ut metus vulputate imperdiet at eget ipsum. Duis pharetra eros nec purus auctor, ut dapibus nunc convallis. Phasellus pellentesque lorem eros, et molestie velit pulvinar eget. Praesent orci orci, pulvinar ac nisi sit amet, cursus imperdiet mauris. Sed pharetra, nibh non maximus blandit, ex felis sagittis turpis, et porttitor dui nibh a eros. Donec imperdiet non ex molestie consequat. Duis posuere tortor eget nibh imperdiet sollicitudin. Curabitur porta placerat ex, vitae consequat turpis semper in. Integer non nulla justo. Phasellus posuere faucibus erat, ac ornare odio suscipit sed. Cras et erat dui. </p>		\r\n	\r\n	</td>\r\n   </tr>\r\n   </tbody></table>\r\n	\r\n   </td>\r\n </tr>\r\n \r\n \r\n \r\n  \r\n <tr>\r\n  <td style=\"background:#fef9ef;padding:20px 30px;\">\r\n    \r\n   <table style=\"width:100%; table-layout: fixed;\">\r\n	  <tbody><tr>\r\n	    <th colspan=\"3\" style=\"text-align: left;\"><h5>Contact Us</h5></th>\r\n	    <th colspan=\"7\" style=\"text-align: left;\"><h5>For  promos, news, and updates, follow us on:</h5></th>\r\n	  </tr>\r\n	  <tr>\r\n	    <td colspan=\"3\" style=\"text-align: left; padding:0 3px;\" valign=\"top\">\r\n	     <p>{{site.address}}</p>\r\n         <p>{{site.contact}}</p>\r\n         <p>{{site.email}}</p>\r\n	    </td><td colspan=\"7\" style=\"padding:0 3px;\" valign=\"top\">\r\n	    \r\n	      {% include \'social_link.html\' %}\r\n	     \r\n	     <table>\r\n	      <tbody><tr>\r\n	      <td style=\"padding:0;\"><a href=\"#\" style=\"color:#000;font-size:16px;\">Terms and Conditions</a></td>\r\n	      <td>●</td>\r\n	      <td style=\"padding:0;\"><a href=\"#\" style=\"color:#000;font-size:16px;\">Privacy Policy</a></td>\r\n	      </tr>\r\n	     </tbody></table>\r\n	    \r\n	    </td>\r\n	  </tr>\r\n	</tbody></table>\r\n  \r\n  </td>\r\n </tr>\r\n \r\n</tbody></table>\r\n{% include \'footer.html\' %}\r\n'),
(2180, 24, 'email', 'ja', '', ''),
(2181, 24, 'email', 'ar', '', ''),
(2182, 24, 'sms', 'en', '', ''),
(2183, 24, 'sms', 'ja', '', ''),
(2184, 24, 'sms', 'ar', '', ''),
(2185, 24, 'push', 'en', '', ''),
(2186, 24, 'push', 'ja', '', ''),
(2187, 24, 'push', 'ar', '', '');
INSERT INTO `st_templates_translation` (`id`, `template_id`, `template_type`, `language`, `title`, `content`) VALUES
(2305, 25, 'email', 'en', 'Welcome to {{site.site_name}}. Confirm your account!', '{% include \'header.html\' %}\r\n<table style=\"width:100%;\">\r\n <tbody><tr>\r\n  <td style=\"background:#fef9ef;padding:20px 30px;\">\r\n    <img style=\"max-width:20%;max-height:50px;\" src=\"{{logo}}\">\r\n  </td>\r\n </tr>\r\n <tr>\r\n   <td style=\"padding:30px;background:#ffffff;\" valign=\"middle\" align=\"left\">\r\n    \r\n   <table width=\"50%\" align=\"center\">\r\n   <tbody><tr>\r\n    <td>\r\n	\r\n	<p style=\"margin-bottom:10px;\">Hi {{restaurant_name}},</p>\r\n	\r\n	 <p style=\"margin-bottom:10px;\">Welcome</p>\r\n	 <p>Before you get full access to all features of your restaurant in {{site.site_name}}, please confirm your email address</p>\r\n	\r\n	<div style=\"margin:auto;text-align:center;padding-top:10px; padding-bottom:10px;\">\r\n	 <a href=\"{{confirm_link}}\" target=\"_blank\" style=\"display:block;margin:auto;max-width:200px;padding:10px;background:#3ecf8e;color:#fff;\r\n     text-decoration:none;font-size:18px;font-weight:bold;\">\r\n     Confirm email\r\n     </a>\r\n	</div>\r\n	 \r\n	<p style=\"text-align:center;\">or click this link:</p>\r\n	<p style=\"text-align:center;\"><a href=\"{{confirm_link}}\">{{confirm_link}}</a></p>\r\n	\r\n	</td>\r\n   </tr>\r\n   </tbody></table>\r\n	\r\n   </td>\r\n </tr>\r\n \r\n \r\n \r\n  \r\n <tr>\r\n  <td style=\"background:#fef9ef;padding:20px 30px;\">\r\n    \r\n   <table style=\"width:100%; table-layout: fixed;\">\r\n	  <tbody><tr>\r\n	    <th colspan=\"3\" style=\"text-align: left;\"><h5>Contact Us</h5></th>\r\n	    <th colspan=\"7\" style=\"text-align: left;\"><h5>For  promos, news, and updates, follow us on:</h5></th>\r\n	  </tr>\r\n	  <tr>\r\n	    <td colspan=\"3\" style=\"text-align: left; padding:0 3px;\" valign=\"top\">\r\n	     <p>{{site.address}}</p>\r\n         <p>{{site.contact}}</p>\r\n         <p>{{site.email}}</p>\r\n	    </td><td colspan=\"7\" style=\"padding:0 3px;\" valign=\"top\">\r\n	    \r\n	      {% include \'social_link.html\' %}\r\n	     \r\n	     <table>\r\n	      <tbody><tr>\r\n	      <td style=\"padding:0;\"><a href=\"#\" style=\"color:#000;font-size:16px;\">Terms and Conditions</a></td>\r\n	      <td>●</td>\r\n	      <td style=\"padding:0;\"><a href=\"#\" style=\"color:#000;font-size:16px;\">Privacy Policy</a></td>\r\n	      </tr>\r\n	     </tbody></table>\r\n	    \r\n	    </td>\r\n	  </tr>\r\n	</tbody></table>\r\n  \r\n  </td>\r\n </tr>\r\n \r\n</tbody></table>\r\n{% include \'footer.html\' %}\r\n'),
(2306, 25, 'email', 'ja', '', ''),
(2307, 25, 'email', 'ar', '', ''),
(2308, 25, 'sms', 'en', '', ''),
(2309, 25, 'sms', 'ja', '', ''),
(2310, 25, 'sms', 'ar', '', ''),
(2311, 25, 'push', 'en', 'Welcome to {{site_name}}. Confirm your account!', 'Welcome to {{site_name}}. Confirm your account!'),
(2312, 25, 'push', 'ja', '', ''),
(2313, 25, 'push', 'ar', '', ''),
(2332, 26, 'email', 'en', 'You have new merchant signup', '{% include \'header.html\' %}\r\n<table style=\"width:100%;\">\r\n <tbody><tr>\r\n  <td style=\"background:#fef9ef;padding:20px 30px;\">\r\n    <img style=\"max-width:20%;max-height:50px;\" src=\"{{logo}}\">\r\n  </td>\r\n </tr>\r\n <tr>\r\n   <td style=\"padding:30px;background:#ffffff;\" valign=\"middle\" align=\"left\">\r\n    \r\n    <p style=\"margin-bottom:15px;\">Hi <br></p>\r\n	\r\n	<p style=\"margin-bottom: 15px;\">You have new merchant signup.</p>	\r\n	\r\n	<h5>Customer Details</h5>\r\n	<table width=\"60%\">\r\n	 <tbody><tr>\r\n	  <td width=\"25%\">Restaurant name<br></td>\r\n	  <td>{{restaurant_name}}</td>\r\n	 </tr>\r\n	 <tr>\r\n	  <td>Address<br></td>\r\n	  <td>{{address}}</td>\r\n	 </tr>	\r\n	  <tr>\r\n	  <td>Membership Program<br></td>\r\n	  <td>{{plan_title}}</td>\r\n	 </tr>	\r\n	  <tr>\r\n	  <td>Phone number</td>\r\n	  <td>{{contact_phone}}</td>\r\n	 </tr><tr><td>Email address<br></td><td>{{contact_email}}<br></td></tr>	 \r\n	</tbody></table>\r\n	\r\n   </td>\r\n </tr>\r\n \r\n \r\n \r\n  \r\n <tr>\r\n  <td style=\"background:#fef9ef;padding:20px 30px;\">\r\n    \r\n   <table style=\"width:100%; table-layout: fixed;\">\r\n	  <tbody><tr>\r\n	    <th colspan=\"3\" style=\"text-align: left;\"><h5>Contact Us</h5></th>\r\n	    <th colspan=\"7\" style=\"text-align: left;\"><h5>For  promos, news, and updates, follow us on:</h5></th>\r\n	  </tr>\r\n	  <tr>\r\n	    <td colspan=\"3\" style=\"text-align: left; padding:0 3px;\" valign=\"top\">\r\n	     <p>{{site.address}}</p>\r\n         <p>{{site.contact}}</p>\r\n         <p>{{site.email}}</p>\r\n	    </td><td colspan=\"7\" style=\"padding:0 3px;\" valign=\"top\">\r\n	    \r\n	      {% include \'social_link.html\' %}\r\n	     \r\n	     <table>\r\n	      <tbody><tr>\r\n	      <td style=\"padding:0;\"><a href=\"#\" style=\"color:#000;font-size:16px;\">Terms and Conditions</a></td>\r\n	      <td>●</td>\r\n	      <td style=\"padding:0;\"><a href=\"#\" style=\"color:#000;font-size:16px;\">Privacy Policy</a></td>\r\n	      </tr>\r\n	     </tbody></table>\r\n	    \r\n	    </td>\r\n	  </tr>\r\n	</tbody></table>\r\n  \r\n  </td>\r\n </tr>\r\n \r\n</tbody></table>\r\n{% include \'footer.html\' %}\r\n'),
(2333, 26, 'email', 'ja', '', ''),
(2334, 26, 'email', 'ar', '', ''),
(2335, 26, 'sms', 'en', '', ''),
(2336, 26, 'sms', 'ja', '', ''),
(2337, 26, 'sms', 'ar', '', ''),
(2338, 26, 'push', 'en', 'You have new merchant signup', 'You have new merchant signup'),
(2339, 26, 'push', 'ja', '', ''),
(2340, 26, 'push', 'ar', '', ''),
(2350, 28, 'email', 'en', 'Your membership will expired on {{expiration_date}}', '{% include \'header.html\' %}\r\n<table style=\"width:100%;\">\r\n <tbody><tr>\r\n  <td style=\"background:#fef9ef;padding:20px 30px;\">\r\n    <img style=\"max-width:20%;max-height:50px;\" src=\"{{logo}}\">\r\n  </td>\r\n </tr>\r\n <tr>\r\n   <td style=\"padding:30px;background:#ffffff;\" valign=\"middle\" align=\"left\">\r\n    \r\n    <p style=\"margin-bottom:15px;\">Hi {{restaurant_name}}<br></p>\r\n	\r\n	<p>Your&nbsp; membership will expired on {{expiration_date}}.</p>	\r\n	\r\n	\r\n	\r\n	\r\n   </td>\r\n </tr>\r\n \r\n \r\n \r\n  \r\n <tr>\r\n  <td style=\"background:#fef9ef;padding:20px 30px;\">\r\n    \r\n   <table style=\"width:100%; table-layout: fixed;\">\r\n	  <tbody><tr>\r\n	    <th colspan=\"3\" style=\"text-align: left;\"><h5>Contact Us</h5></th>\r\n	    <th colspan=\"7\" style=\"text-align: left;\"><h5>For  promos, news, and updates, follow us on:</h5></th>\r\n	  </tr>\r\n	  <tr>\r\n	    <td colspan=\"3\" style=\"text-align: left; padding:0 3px;\" valign=\"top\">\r\n	     <p>{{site.address}}</p>\r\n         <p>{{site.contact}}</p>\r\n         <p>{{site.email}}</p>\r\n	    </td><td colspan=\"7\" style=\"padding:0 3px;\" valign=\"top\">\r\n	    \r\n	      {% include \'social_link.html\' %}\r\n	     \r\n	     <table>\r\n	      <tbody><tr>\r\n	      <td style=\"padding:0;\"><a href=\"#\" style=\"color:#000;font-size:16px;\">Terms and Conditions</a></td>\r\n	      <td>●</td>\r\n	      <td style=\"padding:0;\"><a href=\"#\" style=\"color:#000;font-size:16px;\">Privacy Policy</a></td>\r\n	      </tr>\r\n	     </tbody></table>\r\n	    \r\n	    </td>\r\n	  </tr>\r\n	</tbody></table>\r\n  \r\n  </td>\r\n </tr>\r\n \r\n</tbody></table>\r\n{% include \'footer.html\' %}\r\n'),
(2351, 28, 'email', 'ja', '', ''),
(2352, 28, 'email', 'ar', '', ''),
(2353, 28, 'sms', 'en', '', ''),
(2354, 28, 'sms', 'ja', '', ''),
(2355, 28, 'sms', 'ar', '', ''),
(2356, 28, 'push', 'en', 'Your membership will expired on {{expiration_date}}', 'Your membership will expired on {{expiration_date}}'),
(2357, 28, 'push', 'ja', '', ''),
(2358, 28, 'push', 'ar', '', ''),
(2359, 27, 'email', 'en', 'Your membership has expired', '{% include \'header.html\' %}\r\n<table style=\"width:100%;\">\r\n <tbody><tr>\r\n  <td style=\"background:#fef9ef;padding:20px 30px;\">\r\n    <img style=\"max-width:20%;max-height:50px;\" src=\"{{logo}}\">\r\n  </td>\r\n </tr>\r\n <tr>\r\n   <td style=\"padding:30px;background:#ffffff;\" valign=\"middle\" align=\"left\">\r\n    \r\n    <p style=\"margin-bottom:15px;\">Hi {{restaurant_name}}<br></p>\r\n	\r\n	<p>Your&nbsp; membership has expired.</p>	\r\n	\r\n	\r\n	\r\n	\r\n   </td>\r\n </tr>\r\n \r\n \r\n \r\n  \r\n <tr>\r\n  <td style=\"background:#fef9ef;padding:20px 30px;\">\r\n    \r\n   <table style=\"width:100%; table-layout: fixed;\">\r\n	  <tbody><tr>\r\n	    <th colspan=\"3\" style=\"text-align: left;\"><h5>Contact Us</h5></th>\r\n	    <th colspan=\"7\" style=\"text-align: left;\"><h5>For  promos, news, and updates, follow us on:</h5></th>\r\n	  </tr>\r\n	  <tr>\r\n	    <td colspan=\"3\" style=\"text-align: left; padding:0 3px;\" valign=\"top\">\r\n	     <p>{{site.address}}</p>\r\n         <p>{{site.contact}}</p>\r\n         <p>{{site.email}}</p>\r\n	    </td><td colspan=\"7\" style=\"padding:0 3px;\" valign=\"top\">\r\n	    \r\n	      {% include \'social_link.html\' %}\r\n	     \r\n	     <table>\r\n	      <tbody><tr>\r\n	      <td style=\"padding:0;\"><a href=\"#\" style=\"color:#000;font-size:16px;\">Terms and Conditions</a></td>\r\n	      <td>●</td>\r\n	      <td style=\"padding:0;\"><a href=\"#\" style=\"color:#000;font-size:16px;\">Privacy Policy</a></td>\r\n	      </tr>\r\n	     </tbody></table>\r\n	    \r\n	    </td>\r\n	  </tr>\r\n	</tbody></table>\r\n  \r\n  </td>\r\n </tr>\r\n \r\n</tbody></table>\r\n{% include \'footer.html\' %}\r\n'),
(2360, 27, 'email', 'ja', '', ''),
(2361, 27, 'email', 'ar', '', ''),
(2362, 27, 'sms', 'en', '', ''),
(2363, 27, 'sms', 'ja', '', ''),
(2364, 27, 'sms', 'ar', '', ''),
(2365, 27, 'push', 'en', 'Your membership has expired', 'Your membership has expired'),
(2366, 27, 'push', 'ja', '', ''),
(2367, 27, 'push', 'ar', '', ''),
(2377, 3, 'email', 'en', 'Refund for your #{{order_info.order_id}}', '{% include \'header.html\' %}\r\n\r\n\r\n\r\n<table style=\"width:100%;\">\r\n <tbody><tr>\r\n  <td style=\"background:#fef9ef;padding:20px 30px;\">\r\n    <img style=\"max-width:15%;max-height:50px;\" src=\"{{logo}}\">\r\n  </td>\r\n </tr>\r\n <tr>\r\n   <td style=\"padding:30px;background:#ffffff;\" valign=\"middle\" align=\"left\">\r\n   \r\n\r\n    <p style=\"padding-bottom:15px\">Hi {{order_info.customer_name}},</p>\r\n	<p style=\"line-height:20px;\">\r\n	Good News! We’ve processed your full refund of {{additional_data.refund_amount}} for your item(s) from order #{{order_info.order_id}}.\r\n	</p>\r\n	\r\n	<p style=\"line-height:20px;\">Reversal may take 1 to 2 billing cycles or 5 to 15 banking days for local credit cards, and up to 45 banking days for international credit and debit cards, depending on your bank\'s processing time.</p>\r\n    \r\n   </td>\r\n </tr>\r\n \r\n <tr>\r\n  <td style=\"background:#fef9ef;\">\r\n      {% include \'summary.html\' %}\r\n  </td>\r\n </tr>\r\n \r\n <tr>\r\n   <td style=\"background:#ffffff;\">\r\n     {% include \'items.html\' %}\r\n   </td>\r\n </tr>\r\n  \r\n <tr>\r\n  <td style=\"background:#fef9ef;padding:20px 30px;\">\r\n    \r\n    <table style=\"width:100%; table-layout: fixed;\">\r\n	  <tbody><tr>\r\n	    <th colspan=\"3\" style=\"text-align: left;\"><h5>Contact Us</h5></th>\r\n	    <th colspan=\"7\" style=\"text-align: left;\"><h5>For  promos, news, and updates, follow us on:</h5></th>\r\n	  </tr>\r\n	  <tr>\r\n	    <td colspan=\"3\" style=\"text-align: left; padding:0 3px;\" valign=\"top\">\r\n	     <p>{{site.address}}</p>\r\n         <p>{{site.contact}}</p>\r\n         <p>{{site.email}}</p>\r\n	    </td><td colspan=\"7\" style=\"padding:0 3px;\" valign=\"top\">\r\n	    \r\n	    {% include \'social_link.html\' %}\r\n	     \r\n	     <table>\r\n	      <tbody><tr>\r\n	      <td style=\"padding:0;\"><a href=\"#\" style=\"color:#000;font-size:16px;\">Terms and Conditions</a></td>\r\n	      <td>●</td>\r\n	      <td style=\"padding:0;\"><a href=\"#\" style=\"color:#000;font-size:16px;\">Privacy Policy</a></td>\r\n	      </tr>\r\n	     </tbody></table>\r\n	    \r\n	    </td>\r\n	  </tr>\r\n	</tbody></table>\r\n  \r\n  </td>\r\n </tr>\r\n \r\n</tbody></table>\r\n\r\n{% include \'footer.html\' %}'),
(2378, 3, 'email', 'ja', '', ''),
(2379, 3, 'email', 'ar', '', ''),
(2380, 3, 'sms', 'en', '', ''),
(2381, 3, 'sms', 'ja', '', ''),
(2382, 3, 'sms', 'ar', '', ''),
(2383, 3, 'push', 'en', 'Your refund has been process for order #{{order_info.order_id}} ', 'Your refund has been process for order #{{order_info.order_id}} '),
(2384, 3, 'push', 'ja', '', ''),
(2385, 3, 'push', 'ar', '', ''),
(2386, 29, 'email', 'en', 'Forgot password', '{% include \'header.html\' %}\r\n<table style=\"width:100%;\">\r\n <tbody><tr>\r\n  <td style=\"background:#fef9ef;padding:20px 30px;\">\r\n    <img style=\"max-width:20%;max-height:50px;\" src=\"{{logo}}\">\r\n  </td>\r\n </tr>\r\n <tr>\r\n   <td style=\"padding:30px;background:#ffffff;\" valign=\"middle\" align=\"left\">\r\n    \r\n   <table width=\"50%\" align=\"center\">\r\n   <tbody><tr>\r\n    <td>\r\n	\r\n	<p style=\"margin-bottom:10px;\">Hi {{first_name}} {{last_name}},</p>\r\n	\r\n	 <p style=\"margin-bottom:10px;\">It looks like you have forgotten your password. We can help you to create a new password.</p>\r\n	\r\n	<div style=\"margin:auto;text-align:center;padding-top:10px; padding-bottom:10px;\">\r\n	 <a href=\"{{reset_password_link}}\" target=\"_blank\" style=\"display:block;margin:auto;max-width:200px;padding:10px;background:#3ecf8e;color:#fff;\r\n     text-decoration:none;font-size:18px;font-weight:bold;\">\r\n     Reset Password\r\n     </a>\r\n	</div>\r\n	 \r\n	<p style=\"text-align:center;\">or click this link:</p>\r\n	<p style=\"text-align:center;\"><a href=\"{{reset_password_link}}\">{{reset_password_link}}</a></p>\r\n	\r\n	</td>\r\n   </tr>\r\n   </tbody></table>\r\n	\r\n   </td>\r\n </tr>\r\n \r\n \r\n \r\n  \r\n <tr>\r\n  <td style=\"background:#fef9ef;padding:20px 30px;\">\r\n    \r\n   <table style=\"width:100%; table-layout: fixed;\">\r\n	  <tbody><tr>\r\n	    <th colspan=\"3\" style=\"text-align: left;\"><h5>Contact Us</h5></th>\r\n	    <th colspan=\"7\" style=\"text-align: left;\"><h5>For  promos, news, and updates, follow us on:</h5></th>\r\n	  </tr>\r\n	  <tr>\r\n	    <td colspan=\"3\" style=\"text-align: left; padding:0 3px;\" valign=\"top\">\r\n	     <p>{{site.address}}</p>\r\n         <p>{{site.contact}}</p>\r\n         <p>{{site.email}}</p>\r\n	    </td><td colspan=\"7\" style=\"padding:0 3px;\" valign=\"top\">\r\n	    \r\n	      {% include \'social_link.html\' %}\r\n	     \r\n	     <table>\r\n	      <tbody><tr>\r\n	      <td style=\"padding:0;\"><a href=\"#\" style=\"color:#000;font-size:16px;\">Terms and Conditions</a></td>\r\n	      <td>●</td>\r\n	      <td style=\"padding:0;\"><a href=\"#\" style=\"color:#000;font-size:16px;\">Privacy Policy</a></td>\r\n	      </tr>\r\n	     </tbody></table>\r\n	    \r\n	    </td>\r\n	  </tr>\r\n	</tbody></table>\r\n  \r\n  </td>\r\n </tr>\r\n \r\n</tbody></table>\r\n{% include \'footer.html\' %}\r\n'),
(2387, 29, 'email', 'ar', '', ''),
(2388, 29, 'email', 'ja', '', ''),
(2389, 29, 'sms', 'en', '', ''),
(2390, 29, 'sms', 'ar', '', ''),
(2391, 29, 'sms', 'ja', '', ''),
(2392, 29, 'push', 'en', '', ''),
(2393, 29, 'push', 'ar', '', ''),
(2394, 29, 'push', 'ja', '', ''),
(2749, 34, 'email', 'en', 'You have new Invoice #{{invoice_number}}', '{% include \'header.html\' %}\r\n<table style=\"width:100%;\">\r\n <tbody><tr>\r\n  <td style=\"background:#fef9ef;padding:20px 30px;\">\r\n    <img style=\"max-width:20%;max-height:50px;\" src=\"{{logo}}\">\r\n  </td>\r\n </tr> \r\n <tr>\r\n  <td style=\"background:#ffffff;\">\r\n  \r\n   <p>Your invoice is now ready, you can view your invoice by going to backoffice</p>\r\n   \r\n   \r\n  </td>\r\n </tr>\r\n  \r\n <tr>\r\n  <td style=\"background:#fef9ef;padding:20px 30px;\">\r\n    \r\n   <table style=\"width:100%; table-layout: fixed;\">\r\n	  <tbody><tr>\r\n	    <th colspan=\"3\" style=\"text-align: left;\"><h5>Contact Us</h5></th>\r\n	    <th colspan=\"7\" style=\"text-align: left;\"><h5>For  promos, news, and updates, follow us on:</h5></th>\r\n	  </tr>\r\n	  <tr>\r\n	    <td colspan=\"3\" style=\"text-align: left; padding:0 3px;\" valign=\"top\">\r\n	     <p>{{site.address}}</p>\r\n         <p>{{site.contact}}</p>\r\n         <p>{{site.email}}</p>\r\n	    </td><td colspan=\"7\" style=\"padding:0 3px;\" valign=\"top\">\r\n	    \r\n	      {% include \'social_link.html\' %}\r\n	     \r\n	     <table>\r\n	      <tbody><tr>\r\n	      <td style=\"padding:0;\"><a href=\"#\" style=\"color:#000;font-size:16px;\">Terms and Conditions</a></td>\r\n	      <td>●</td>\r\n	      <td style=\"padding:0;\"><a href=\"#\" style=\"color:#000;font-size:16px;\">Privacy Policy</a></td>\r\n	      </tr>\r\n	     </tbody></table>\r\n	    \r\n	    </td>\r\n	  </tr>\r\n	</tbody></table>\r\n  \r\n  </td>\r\n </tr>\r\n \r\n</tbody></table>\r\n{% include \'footer.html\' %}\r\n'),
(2759, 34, 'push', 'en', 'You have new Invoice #{{invoice_number}}', 'You have new Invoice #{{invoice_number}}'),
(2809, 35, 'email', 'en', 'New bank deposit with invoice #{{invoice_number}}', '<p>New bank deposit with invoice #{{invoice_number}}<br></p>'),
(2819, 35, 'push', 'en', 'New bank deposit with invoice #{{invoice_number}}', 'New bank deposit with invoice #{{invoice_number}}'),
(3079, 36, 'email', 'en', 'Online Reservation Confirmation Notification', '{% include \'header.html\' %}\r\n<table style=\"width:100%;\">\r\n <tbody><tr>\r\n  <td style=\"background:#fef9ef;padding:20px 30px;\">\r\n    <img style=\"max-width:20%;max-height:50px;\" src=\"{{logo}}\">\r\n  </td>\r\n </tr>\r\n <tr>\r\n   <td style=\"padding:30px;background:#ffffff;\" valign=\"middle\" align=\"left\">\r\n    \r\n   <table width=\"50%\" align=\"center\">\r\n   <tbody><tr>\r\n    <td>\r\n	\r\n	<p style=\"margin-bottom:10px;\">You have received an online reservation.</p>\r\n	\r\n	 <h5 style=\"margin-bottom:10px;\">RESERVATION DETAILS</h5>\r\n	 \r\n	 <table>\r\n	 <tbody><tr><td>Restaurant Name</td><td>: {{restaurant_name}}</td></tr>\r\n	 <tr><td>Guest Name</td><td>: {{guest_fullname}}</td></tr>\r\n	 <tr><td>Guest Phone</td><td>: {{contact_phone}}</td></tr>\r\n	 <tr><td>Guest Email</td><td>: {{email_address}}</td></tr>\r\n	 <tr><td>Reservation ID</td><td>: {{reservation_id}}</td></tr>\r\n	 <tr><td>Date of booking</td><td>: {{date_created}}</td></tr>\r\n	 <tr><td>Time of arrival</td><td>: {{reservation_datetime}}</td></tr>\r\n	 <tr><td>Party of</td><td>: {{guest_number}}</td></tr>\r\n	 <tr><td>Special Request</td><td>: {{special_request}}</td></tr>\r\n	 </tbody></table>\r\n	 \r\n	\r\n	<br><br>\r\n	<div style=\"margin:auto;text-align:center;padding-top:10px; padding-bottom:10px;\">\r\n	 <a href=\"{{manage_reservation_link}}\" target=\"_blank\" style=\"display:block;margin:auto;max-width:200px;padding:10px;background:#3ecf8e;color:#fff;\r\n     text-decoration:none;font-size:18px;font-weight:bold;\">\r\n     Manage reservation\r\n     </a>\r\n	</div>\r\n	 \r\n	<p style=\"text-align:center;\">or click this link:</p>\r\n	<p style=\"text-align:center;\"><a href=\"{{manage_reservation_link}}\">{{manage_reservation_link}}</a></p>\r\n	\r\n	</td>\r\n   </tr>\r\n   </tbody></table>\r\n	\r\n   </td>\r\n </tr>\r\n \r\n \r\n \r\n  \r\n <tr>\r\n  <td style=\"background:#fef9ef;padding:20px 30px;\">\r\n    \r\n   <table style=\"width:100%; table-layout: fixed;\">\r\n	  <tbody><tr>\r\n	    <th colspan=\"3\" style=\"text-align: left;\"><h5>Contact Us</h5></th>\r\n	    <th colspan=\"7\" style=\"text-align: left;\"><h5>For  promos, news, and updates, follow us on:</h5></th>\r\n	  </tr>\r\n	  <tr>\r\n	    <td colspan=\"3\" style=\"text-align: left; padding:0 3px;\" valign=\"top\">\r\n	     <p>{{site.address}}</p>\r\n         <p>{{site.contact}}</p>\r\n         <p>{{site.email}}</p>\r\n	    </td><td colspan=\"7\" style=\"padding:0 3px;\" valign=\"top\">\r\n	    \r\n	      {% include \'social_link.html\' %}\r\n	     \r\n	     <table>\r\n	      <tbody><tr>\r\n	      <td style=\"padding:0;\"><a href=\"#\" style=\"color:#000;font-size:16px;\">Terms and Conditions</a></td>\r\n	      <td>●</td>\r\n	      <td style=\"padding:0;\"><a href=\"#\" style=\"color:#000;font-size:16px;\">Privacy Policy</a></td>\r\n	      </tr>\r\n	     </tbody></table>\r\n	    \r\n	    </td>\r\n	  </tr>\r\n	</tbody></table>\r\n  \r\n  </td>\r\n </tr>\r\n \r\n</tbody></table>\r\n{% include \'footer.html\' %}\r\n'),
(3089, 36, 'push', 'en', 'Online Reservation Confirmation Notification, Reservation ID#{{reservation_id}}', 'Online Reservation Confirmation Notification, Reservation ID#{{reservation_id}}'),
(3064, 37, 'email', 'en', 'Reservation Confirmed at {{restaurant_name}}', '{% include \'header.html\' %}\r\n<table style=\"width:100%;\">\r\n <tbody><tr>\r\n  <td style=\"background:#fef9ef;padding:20px 30px;\">\r\n    <img style=\"max-width:20%;max-height:50px;\" src=\"{{logo}}\">\r\n  </td>\r\n </tr>\r\n <tr>\r\n   <td style=\"padding:30px;background:#ffffff;\" valign=\"middle\" align=\"left\">\r\n    \r\n   <table width=\"50%\" align=\"center\">\r\n   <tbody><tr>\r\n    <td>\r\n	\r\n	 <p style=\"margin-bottom:10px;\">Your reservation at {{restaurant_name}} is confirmed!</p>\r\n	\r\n	 <h5 style=\"margin-bottom:10px;\">RESERVATION DETAILS</h5>\r\n	 \r\n	 <table>	 \r\n	 <tbody><tr><td>Name of guest:</td><td>: {{guest_fullname}}</td></tr>\r\n	 <tr><td>Number of guests</td><td>: {{guest_number}}</td></tr>\r\n	 <tr><td>Time of arrival</td><td>: {{reservation_datetime}}</td></tr>	 \r\n	 </tbody></table>\r\n	 \r\n	 <p style=\"margin-bottom:10px;\">Your Reservation ID is <b>{{reservation_id}}</b></p>\r\n	\r\n	<div style=\"margin:auto;text-align:center;padding-top:10px; padding-bottom:10px;\">\r\n	 <a href=\"{{manage_reservation_link}}\" target=\"_blank\" style=\"display:block;margin:auto;max-width:200px;padding:10px;background:#3ecf8e;color:#fff;\r\n     text-decoration:none;font-size:18px;font-weight:bold;\">\r\n     Manage reservation\r\n     </a>\r\n	</div>\r\n	 \r\n	<p style=\"text-align:center;\">or click this link:</p>\r\n	<p style=\"text-align:center;\"><a href=\"{{manage_reservation_link}}\">{{manage_reservation_link}}</a></p>\r\n	\r\n	<br><br>\r\n	<h5 style=\"margin-bottom:10px;\">Special Requests</h5>\r\n	<p style=\"margin-bottom:10px;\">{{special_request}}</p>\r\n	<br><br>\r\n	\r\n	<h5 style=\"margin-bottom:10px;\">RESTAURANT DETAILS</h5>\r\n	<p style=\"margin-bottom:10px;\">{{restaurant_name}}</p>\r\n	<p style=\"margin-bottom:10px;\">{{restaurant_contact_phone}} / {{restaurant_contact_email}}</p>\r\n	<br><br>\r\n	\r\n	<h5 style=\"margin-bottom:10px;\">Notes from the restaurant</h5>\r\n	<p style=\"margin-bottom:10px;\">{{notes_from_restaurant}}</p>\r\n	\r\n	</td>\r\n   </tr>\r\n   </tbody></table>\r\n	\r\n   </td>\r\n </tr>\r\n \r\n \r\n \r\n  \r\n <tr>\r\n  <td style=\"background:#fef9ef;padding:20px 30px;\">\r\n    \r\n   <table style=\"width:100%; table-layout: fixed;\">\r\n	  <tbody><tr>\r\n	    <th colspan=\"3\" style=\"text-align: left;\"><h5>Contact Us</h5></th>\r\n	    <th colspan=\"7\" style=\"text-align: left;\"><h5>For  promos, news, and updates, follow us on:</h5></th>\r\n	  </tr>\r\n	  <tr>\r\n	    <td colspan=\"3\" style=\"text-align: left; padding:0 3px;\" valign=\"top\">\r\n	     <p>{{site.address}}</p>\r\n         <p>{{site.contact}}</p>\r\n         <p>{{site.email}}</p>\r\n	    </td><td colspan=\"7\" style=\"padding:0 3px;\" valign=\"top\">\r\n	    \r\n	      {% include \'social_link.html\' %}\r\n	     \r\n	     <table>\r\n	      <tbody><tr>\r\n	      <td style=\"padding:0;\"><a href=\"#\" style=\"color:#000;font-size:16px;\">Terms and Conditions</a></td>\r\n	      <td>●</td>\r\n	      <td style=\"padding:0;\"><a href=\"#\" style=\"color:#000;font-size:16px;\">Privacy Policy</a></td>\r\n	      </tr>\r\n	     </tbody></table>\r\n	    \r\n	    </td>\r\n	  </tr>\r\n	</tbody></table>\r\n  \r\n  </td>\r\n </tr>\r\n \r\n</tbody></table>\r\n{% include \'footer.html\' %}\r\n'),
(3074, 37, 'push', 'en', 'Reservation Confirmed at {{restaurant_name}}, Reservation ID#{{reservation_id}}', 'Reservation Confirmed at {{restaurant_name}}, Reservation ID#{{reservation_id}}'),
(3019, 38, 'email', 'en', 'Reservation {{status}} at {{restaurant_name}}', '{% include \'header.html\' %}\r\n<table style=\"width:100%;\">\r\n <tbody><tr>\r\n  <td style=\"background:#fef9ef;padding:20px 30px;\">\r\n    <img style=\"max-width:20%;max-height:50px;\" src=\"{{logo}}\">\r\n  </td>\r\n </tr>\r\n <tr>\r\n   <td style=\"padding:30px;background:#ffffff;\" valign=\"middle\" align=\"left\">\r\n    \r\n   <table width=\"50%\" align=\"center\">\r\n   <tbody><tr>\r\n    <td>\r\n	\r\n	 <p style=\"margin-bottom:10px;\">Your reservation at {{restaurant_name}} is {{status}}!</p>\r\n	\r\n	 <h5 style=\"margin-bottom:10px;\">RESERVATION DETAILS</h5>\r\n	 \r\n	 <table>	 \r\n	 <tbody><tr><td>Name of guest:</td><td>: {{guest_fullname}}</td></tr>\r\n	 <tr><td>Number of guests</td><td>: {{guest_number}}</td></tr>\r\n	 <tr><td>Time of arrival</td><td>: {{reservation_datetime}}</td></tr>	 \r\n	 </tbody></table>\r\n	 \r\n	 <p style=\"margin-bottom:10px;\">Your Reservation ID is <b>{{reservation_id}}</b></p>\r\n	\r\n	 <h5 style=\"margin-bottom:10px;\">Special Requests</h5>\r\n	 <p style=\"margin-bottom:10px;\">{{special_request}}</p>\r\n	\r\n	\r\n	</td>\r\n   </tr>\r\n   </tbody></table>\r\n	\r\n   </td>\r\n </tr>\r\n \r\n \r\n \r\n  \r\n <tr>\r\n  <td style=\"background:#fef9ef;padding:20px 30px;\">\r\n    \r\n   <table style=\"width:100%; table-layout: fixed;\">\r\n	  <tbody><tr>\r\n	    <th colspan=\"3\" style=\"text-align: left;\"><h5>Contact Us</h5></th>\r\n	    <th colspan=\"7\" style=\"text-align: left;\"><h5>For  promos, news, and updates, follow us on:</h5></th>\r\n	  </tr>\r\n	  <tr>\r\n	    <td colspan=\"3\" style=\"text-align: left; padding:0 3px;\" valign=\"top\">\r\n	     <p>{{site.address}}</p>\r\n         <p>{{site.contact}}</p>\r\n         <p>{{site.email}}</p>\r\n	    </td><td colspan=\"7\" style=\"padding:0 3px;\" valign=\"top\">\r\n	    \r\n	      {% include \'social_link.html\' %}\r\n	     \r\n	     <table>\r\n	      <tbody><tr>\r\n	      <td style=\"padding:0;\"><a href=\"#\" style=\"color:#000;font-size:16px;\">Terms and Conditions</a></td>\r\n	      <td>●</td>\r\n	      <td style=\"padding:0;\"><a href=\"#\" style=\"color:#000;font-size:16px;\">Privacy Policy</a></td>\r\n	      </tr>\r\n	     </tbody></table>\r\n	    \r\n	    </td>\r\n	  </tr>\r\n	</tbody></table>\r\n  \r\n  </td>\r\n </tr>\r\n \r\n</tbody></table>\r\n{% include \'footer.html\' %}\r\n'),
(3029, 38, 'push', 'en', 'Reservation {{status}} at {{restaurant_name}}', 'Reservation {{status}} at {{restaurant_name}}'),
(3109, 39, 'email', 'en', 'New contact form from {{email_address}}', '{% include \'header.html\' %}\n<table style=\"width:100%;\">\n <tbody><tr>\n  <td style=\"background:#fef9ef;padding:20px 30px;\">\n    <img style=\"max-width:20%;max-height:50px;\" src=\"{{logo}}\">\n  </td>\n </tr>\n <tr>\n   <td style=\"padding:30px;background:#ffffff;\" valign=\"middle\" align=\"left\">\n    \n   <table width=\"50%\" align=\"center\">\n   <tbody><tr>\n    <td>\n		 \n	\n	 <h5 style=\"margin-bottom:10px;\">CONTACT DETAILS</h5>\n	 \n	 <table>	 \n	 <tbody><tr><td>Email address:</td><td>: {{email_address}}</td></tr>	 \n	 <tr><td>Full name</td><td>: {{fullname}}</td></tr>	 \n	 <tr><td>Contact number</td><td>: {{contact_number}}</td></tr>	 \n	 <tr><td>Country</td><td>: {{country_name}}</td></tr>	 \n	 <tr><td>Message</td><td>: {{message}}</td></tr>	 \n	 </tbody></table>\n	 \n	 \n	\n	</td>\n   </tr>\n   </tbody></table>\n	\n   </td>\n </tr>\n \n \n \n  \n <tr>\n  <td style=\"background:#fef9ef;padding:20px 30px;\">\n    \n   <table style=\"width:100%; table-layout: fixed;\">\n	  <tbody><tr>\n	    <th colspan=\"3\" style=\"text-align: left;\"><h5>Contact Us</h5></th>\n	    <th colspan=\"7\" style=\"text-align: left;\"><h5>For  promos, news, and updates, follow us on:</h5></th>\n	  </tr>\n	  <tr>\n	    <td colspan=\"3\" style=\"text-align: left; padding:0 3px;\" valign=\"top\">\n	     <p>{{site.address}}</p>\n         <p>{{site.contact}}</p>\n         <p>{{site.email}}</p>\n	    </td><td colspan=\"7\" style=\"padding:0 3px;\" valign=\"top\">\n	    \n	      {% include \'social_link.html\' %}\n	     \n	     <table>\n	      <tbody><tr>\n	      <td style=\"padding:0;\"><a href=\"#\" style=\"color:#000;font-size:16px;\">Terms and Conditions</a></td>\n	      <td>●</td>\n	      <td style=\"padding:0;\"><a href=\"#\" style=\"color:#000;font-size:16px;\">Privacy Policy</a></td>\n	      </tr>\n	     </tbody></table>\n	    \n	    </td>\n	  </tr>\n	</tbody></table>\n  \n  </td>\n </tr>\n \n</tbody></table>\n{% include \'footer.html\' %}\n'),
(3119, 39, 'push', 'en', 'New contact form from {{email_address}}', 'New contact form from {{email_address}}'),
(3449, 40, 'push', 'en', '{{driver_firstname}} has arrived restaurant {{restaurant_name}}', '{{driver_firstname}} has arrived restaurant {{restaurant_name}}'),
(3464, 41, 'push', 'en', '{{driver_firstname}} pickup the order#{{order_id}}', '{{driver_firstname}} pickup the order#{{order_id}}'),
(3374, 42, 'push', 'en', '{{driver_name}} has missed the assign order#{{order_id}}', '{{driver_name}} has missed the assign order#{{order_id}}'),
(3349, 43, 'email', 'en', 'Your order#{{order_id}} OTP is {{code}}', 'Your order#{{order_id}} OTP is {{code}}'),
(3359, 43, 'push', 'en', 'Your order#{{order_id}} OTP is {{code}}', 'Your order#{{order_id}} OTP is {{code}}'),
(3334, 44, 'email', 'en', 'You have new assigned order#{{order_info.order_id}} from {{merchant.restaurant_name}}', 'You have new assigned order#{{order_info.order_id}} from {{merchant.restaurant_name}}'),
(3344, 44, 'push', 'en', 'You have new assigned order#{{order_id}} from {{restaurant_name}}', 'You have new assigned order#{{order_id}} from {{restaurant_name}}'),
(3329, 45, 'push', 'en', 'Order#{{order_id}} is ready for pickup at {{restaurant_name}}', 'Order#{{order_id}} is ready for pickup at {{restaurant_name}}'),
(3479, 46, 'push', 'en', 'Order#{{order_id}} is assigned to {{driver_name}}', 'Order#{{order_id}} is assigned to {{driver_name}}'),
(3494, 47, 'push', 'en', 'Your delivery rider is it is way to you location', 'Your delivery rider is it is way to you location'),
(3509, 48, 'push', 'en', 'Your delivery rider has arrived to your location', 'Your delivery rider has arrived to your location'),
(4024, 49, 'email', 'en', 'Test runactions', '<p>this is a test runactions<br></p>'),
(4034, 49, 'push', 'en', 'Test runactions', 'Test runactions'),
(3754, 50, 'email', 'en', 'Complete your signup for {{site.site_name}}', '<p>Dear {{first_name}},</p><p>Thank you for signing up for {{site.site_name}}!</p><p>To ensure the security of your account and complete the signup process, \nplease verify your email address by clicking the link below:</p>\n\n<p><a href=\"{{verification_link}}\" target=\"_blank\">\nClick here\n</a></p>\n\n<p>If the above link doesn\'t work, copy and paste the following URL into your browser\'s address bar:</p><p>{{verification_link}}</p><p>Thank you for choosing {{site.site_name}}. If you have any questions or need assistance, feel free to contact our support team at {{site.email}} / {{site.contact}} .</p><p>Best regards,</p><p>{{site_name}} Team</p><p></p><p></p><p></p><p></p><p></p><p></p><p></p>'),
(4489, 51, 'email', 'en', 'New Bank Deposit Uploaded for Subscription Payment', 'Dear Admin,<br><br>We have received a new bank deposit upload for a subscription payment.<br><br>Details:<br>- **Merchant Name:** {{restaurant_name}}<br>- **Merchant Email:** {{restaurant_email}}<br>- **Subscription Plan:** {{plan_name}}<br>- **Amount:** {{amount}}<br>- **Reference Number:** {{reference_number}}<br>- **Upload Date:** {{uploaded_date}}<br><br>Please verify the payment and update the subscription status accordingly.<br><br>Best regards,<br>{{site_title}}<br><br>'),
(4499, 51, 'push', 'en', 'New bank deposit uploaded for subscription payment by {{restaurant_name}} with the amount of {{amount}}.', 'New bank deposit uploaded for subscription payment by {{restaurant_name}} with the amount of {{amount}}.'),
(4579, 52, 'email', 'en', 'Your Subscription is Approved and Account is Now Active', '<p>Dear {{restaurant_name}},<br><br>We are pleased to inform you that your bank deposit has been verified, and your subscription is now approved. Your account is active and you can now proceed to the merchant panel to start using our services.<br><br>Subscription Details:<br>- **Subscription Plan:** {{plan_name}}<br>- **Start Date:** {{start_date}}<br>- **End Date:** {{end_date}}<br><br>You can log in to your merchant panel here: {{merchant_panel_url}}<br><br>If you have any questions or need assistance, please do not hesitate to contact our support team.<br><br>Best regards,<br>{{site_title}}<br><br></p>'),
(4589, 52, 'push', 'en', 'Subscription Approved', 'Your subscription is approved and your account is active. You can now proceed to the merchant panel.'),
(4564, 53, 'email', 'en', 'Your Merchant Registration is Approved', '<p>Dear {{restaurant_name}},<br><br>We are delighted to inform you that your merchant registration has been approved. You can now access your merchant panel and start managing your restaurant\'s orders, menu, and other settings.<br><br><br>You can log in to your merchant panel using the following link:<br>{{merchant_panel_url}}<br><br>If you have any questions or need assistance, please feel free to contact our support team.<br><br>Thank you for choosing our services. We look forward to a successful partnership!<br><br>Best regards,<br>{{site_title}}<br><br></p>'),
(4574, 53, 'push', 'en', 'Your registration is approved! You can now access the merchant panel to start managing your restaurant.', 'Your registration is approved! You can now access the merchant panel to start managing your restaurant.\n'),
(4654, 54, 'email', 'en', 'Subscription Payment Received and Processed', '<p>Dear {{restaurant_name}},<br><br>We have successfully received and processed your subscription payment. Thank you for your prompt payment!<br><br>**Subscription Details:**<br>- **Subscription Plan:** {{plan_name}}<br>- **Amount Paid:** {{amount}}<br>- **Payment Date:** {{payment_date}}<br>- **Subscription Period:** {{start_date}} to {{end_date}}<br><br>Your account is now active, and you can continue to use all the features associated with your subscription plan.<br><br>You can log in to your merchant panel here: {{merchant_panel_url}}<br><br>If you have any questions or need further assistance, please do not hesitate to contact our support team.<br><br>Thank you for choosing our services!<br><br>Best regards,<br>{{site_title}}<br><br></p>'),
(4664, 54, 'push', 'en', 'Payment Processed', 'Your subscription payment has been successfully processed. Your account is now active. Thank you for choosing {{site_title}}!'),
(4699, 55, 'email', 'en', 'Important: Subscription Payment Failed', '<p>Dear {{merchant_name}},<br><br>We regret to inform you that your recent attempt to process the payment for your subscription has failed.<br><br>**Subscription Details:**<br>- **Subscription Plan:** {{plan_name}}<br>- **Amount Due:** {{amount}}<br>- **Payment Date:** {{attempted_payment_date}}<br><br>Unfortunately, we were unable to process.<br><br>To ensure uninterrupted access to your subscription, please update your payment information and try again. You can update your payment details by logging in to your merchant panel using the following link:<br><br>{{merchant_panel_url}}<br><br>If the issue persists or if you need any assistance, please do not hesitate to contact our support team. We are here to help you resolve the issue as quickly as possible.<br><br>Thank you for your attention to this matter.<br><br>Best regards, &nbsp;<br>{{site_title}}<br><br></p>'),
(4709, 55, 'push', 'en', 'Subscription Payment Failed', 'Payment failed for your subscription plan. Please update your payment details in your merchant panel to avoid service disruption. Need help? Contact our support team.'),
(4729, 56, 'email', 'en', 'Your Subscription Has Been Canceled', 'Dear {{restaurant_name}},<br><br>We’re writing to inform you that your subscription to the {{plan_name}} plan has been canceled effective {{cancellation_date}}.<br><br>**What This Means:**<br>- You will no longer have access to the features included in the {{plan_name}} plan.<br>- Your account will be placed in an inactive status, and certain services may be limited or unavailable.<br><br>**Next Steps:**<br>If this cancellation was not intended or if you wish to reactivate your subscription, please contact our support team or log in to your merchant panel to choose a new subscription plan.<br><br>We value your partnership with us and hope to continue supporting your business in the future. If there’s anything we can do to assist you or if you have any questions, please don’t hesitate to reach out to us.<br><br>Thank you for being a valued customer.<br><br>Best regards, &nbsp;<br>{{site_title}}<br>{{contact_number}}');

-- --------------------------------------------------------

--
-- Table structure for table `st_voucher_new`
--

CREATE TABLE `st_voucher_new` (
  `voucher_id` int(14) NOT NULL,
  `voucher_owner` varchar(255) NOT NULL DEFAULT 'merchant',
  `merchant_id` int(14) NOT NULL DEFAULT '0',
  `joining_merchant` text,
  `voucher_name` varchar(255) NOT NULL DEFAULT '',
  `voucher_type` varchar(255) NOT NULL DEFAULT '',
  `amount` float(14,4) NOT NULL DEFAULT '0.0000',
  `expiration` date DEFAULT NULL,
  `used_once` int(1) NOT NULL DEFAULT '1',
  `min_order` decimal(14,2) NOT NULL DEFAULT '0.00',
  `max_order` decimal(10,2) DEFAULT '0.00',
  `max_discount_cap` decimal(10,2) NOT NULL DEFAULT '0.00',
  `monday` int(1) NOT NULL DEFAULT '0',
  `tuesday` int(1) NOT NULL DEFAULT '0',
  `wednesday` int(1) NOT NULL DEFAULT '0',
  `thursday` int(1) NOT NULL DEFAULT '0',
  `friday` int(1) NOT NULL DEFAULT '0',
  `saturday` int(1) NOT NULL DEFAULT '0',
  `sunday` int(1) NOT NULL DEFAULT '0',
  `max_number_use` int(14) NOT NULL DEFAULT '0',
  `selected_customer` text,
  `applicable_to` text,
  `status` varchar(100) NOT NULL DEFAULT '',
  `visible` smallint(1) NOT NULL DEFAULT '1',
  `date_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `date_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ip_address` varchar(100) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `st_wallet_cards`
--

CREATE TABLE `st_wallet_cards` (
  `card_id` bigint(20) NOT NULL,
  `card_uuid` varchar(50) NOT NULL DEFAULT '',
  `account_type` varchar(50) NOT NULL DEFAULT '',
  `account_id` bigint(20) NOT NULL DEFAULT '0',
  `date_created` timestamp NULL DEFAULT NULL,
  `date_modified` timestamp NULL DEFAULT NULL,
  `ip_address` varchar(50) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `st_wallet_cards`
--

INSERT INTO `st_wallet_cards` (`card_id`, `card_uuid`, `account_type`, `account_id`, `date_created`, `date_modified`, `ip_address`) VALUES
(1, '8722736e-7eb4-11ec-aa6d-9c5c8e164c2c', 'admin', 0, '2022-01-26 14:30:36', NULL, '127.0.0.1');

-- --------------------------------------------------------

--
-- Table structure for table `st_wallet_transactions`
--

CREATE TABLE `st_wallet_transactions` (
  `transaction_id` bigint(20) NOT NULL,
  `transaction_uuid` varchar(100) NOT NULL DEFAULT '',
  `card_id` bigint(20) NOT NULL DEFAULT '0',
  `transaction_date` timestamp NULL DEFAULT NULL,
  `transaction_description` varchar(255) NOT NULL DEFAULT '',
  `transaction_description_parameters` varchar(255) NOT NULL DEFAULT '',
  `transaction_type` varchar(50) NOT NULL DEFAULT '',
  `transaction_amount` decimal(10,4) NOT NULL DEFAULT '0.00',
  `running_balance` decimal(10,4) NOT NULL DEFAULT '0.00',
  `status` varchar(100) NOT NULL DEFAULT 'paid',
  `orig_transaction_amount` decimal(10,4) NOT NULL DEFAULT '0.0000',
  `merchant_base_currency` varchar(10) NOT NULL DEFAULT '',
  `admin_base_currency` varchar(10) NOT NULL DEFAULT '',
  `exchange_rate_merchant_to_admin` decimal(10,4) NOT NULL DEFAULT '1.0000',
  `exchange_rate_admin_to_merchant` decimal(10,4) NOT NULL DEFAULT '1.0000',
  `reference_id` varchar(255) NOT NULL DEFAULT '',
  `reference_id1` varchar(255) NOT NULL DEFAULT '',  
  `reference_id2` varchar(100) NOT NULL DEFAULT '',  
  `ip_address` varchar(50) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `st_wallet_transactions_meta`
--

CREATE TABLE `st_wallet_transactions_meta` (
  `id` bigint(20) NOT NULL,
  `transaction_id` bigint(20) NOT NULL DEFAULT '0',
  `meta_name` varchar(100) NOT NULL DEFAULT '',
  `meta_value` text,
  `meta_value2` varchar(255) DEFAULT NULL,
  `meta_value3` varchar(255) DEFAULT NULL,
  `date_created` timestamp NULL DEFAULT NULL,
  `ip_address` varchar(50) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `st_zones`
--

CREATE TABLE `st_zones` (
  `zone_id` bigint(20) NOT NULL,
  `zone_uuid` varchar(50) NOT NULL DEFAULT '',
  `merchant_id` bigint(20) DEFAULT '0',
  `zone_name` varchar(255) NOT NULL DEFAULT '',
  `description` varchar(255) NOT NULL DEFAULT '',
  `date_created` timestamp NULL DEFAULT NULL,
  `date_modified` timestamp NULL DEFAULT NULL,
  `ip_address` varchar(50) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


--
-- Table structure for table `st_message`
--

CREATE TABLE `st_message` (
  `id` int(11) NOT NULL,
  `language` varchar(16) NOT NULL,
  `translation` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `st_sourcemessage`
--

CREATE TABLE `st_sourcemessage` (
  `id` int(11) NOT NULL,
  `category` varchar(32) DEFAULT NULL,
  `message` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


--
-- Table structure for table `st_subscriber`
--

CREATE TABLE `st_subscriber` (
  `id` int(11) NOT NULL,
  `email_address` varchar(100) NOT NULL DEFAULT '',
  `merchant_id` int(14) NOT NULL DEFAULT '0',
  `subcsribe_type` varchar(50) NOT NULL DEFAULT 'website',
  `date_created` timestamp NULL DEFAULT NULL,
  `ip_address` varchar(50) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `st_banner`
--

CREATE TABLE `st_banner` (
  `banner_id` int(14) NOT NULL,
  `banner_uuid` varchar(100) NOT NULL DEFAULT '',
  `owner` varchar(50) NOT NULL DEFAULT 'admin',
  `title` varchar(255) NOT NULL DEFAULT '',
  `banner_type` varchar(100) NOT NULL DEFAULT '',
  `meta_value1` int(10) NOT NULL DEFAULT '0',
  `meta_value2` int(10) NOT NULL DEFAULT '0',
  `meta_value3` varchar(255) NOT NULL DEFAULT '',
  `meta_value4` int(10) NOT NULL DEFAULT '0',
  `meta_slug` varchar(200) DEFAULT '',
  `path` varchar(255) NOT NULL DEFAULT '',
  `photo` varchar(255) NOT NULL DEFAULT '',
  `latitude` float DEFAULT NULL,
  `longitude` float DEFAULT NULL,
  `radius` float NOT NULL DEFAULT '0',
  `radius_unit` varchar(5) NOT NULL DEFAULT 'mi',
  `country_id` int(10) NOT NULL DEFAULT '0',
  `state_id` int(10) NOT NULL DEFAULT '0',
  `city_id` int(10) NOT NULL DEFAULT '0',
  `area_id` int(10) NOT NULL DEFAULT '0',
  `sequence` int(10) NOT NULL DEFAULT '0',
  `status` int(10) NOT NULL DEFAULT '1',
  `date_created` timestamp NULL DEFAULT NULL,
  `date_modified` timestamp NULL DEFAULT NULL,
  `ip_address` varchar(50) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


--
-- Table structure for table `st_addons`
--

CREATE TABLE `st_addons` (
  `id` int(11) NOT NULL,
  `addon_name` varchar(255) NOT NULL DEFAULT '',
  `uuid` varchar(255) NOT NULL DEFAULT '',
  `version` varchar(5) NOT NULL DEFAULT '',
  `activated` int(1) NOT NULL DEFAULT '0',
  `image` varchar(100) NOT NULL DEFAULT '',
  `path` varchar(255) NOT NULL DEFAULT '',
  `purchase_code` varchar(50) NOT NULL DEFAULT '',
  `date_created` timestamp NULL DEFAULT NULL,
  `date_modified` timestamp NULL DEFAULT NULL,
  `ip_address` varchar(50) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `st_driver_activity` (
  `id` bigint(20) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `date_created` date DEFAULT NULL,
  `driver_id` bigint(20) DEFAULT '0',
  `order_id` bigint(20) NOT NULL DEFAULT '0',
  `reference_id` bigint(20) NOT NULL DEFAULT '0',
  `status` varchar(255) NOT NULL DEFAULT '',
  `remarks` tinytext,
  `remarks_args` tinytext,
  `latitude` varchar(100) NOT NULL DEFAULT '',
  `longitude` varchar(100) NOT NULL DEFAULT '',
  `ip_address` varchar(50) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `st_bank_deposit` (
  `deposit_id` bigint(20) NOT NULL,
  `deposit_uuid` varchar(100) NOT NULL DEFAULT '',
  `status` varchar(100) DEFAULT 'pending',
  `deposit_type` varchar(50) NOT NULL DEFAULT 'order',
  `merchant_id` bigint(20) NOT NULL DEFAULT '0',
  `transaction_ref_id` varchar(100) DEFAULT '',
  `account_name` varchar(255) NOT NULL DEFAULT '',
  `amount` decimal(10,4) NOT NULL DEFAULT '0.0000',
  `use_amount` decimal(10,4) NOT NULL DEFAULT '0.0000',
  `use_currency_code` varchar(10) NOT NULL DEFAULT '',
  `base_currency_code` varchar(10) NOT NULL DEFAULT '',
  `admin_base_currency` varchar(10) NOT NULL DEFAULT '',
  `exchange_rate` decimal(10,4) NOT NULL DEFAULT '1.0000',
  `exchange_rate_merchant_to_admin` decimal(10,4) NOT NULL DEFAULT '1.0000',
  `exchange_rate_admin_to_merchant` decimal(10,4) NOT NULL DEFAULT '1.0000',
  `reference_number` varchar(100) NOT NULL DEFAULT '',
  `proof_image` varchar(100) NOT NULL DEFAULT '',
  `path` varchar(255) NOT NULL DEFAULT '',
  `date_created` datetime DEFAULT NULL,
  `date_modified` datetime DEFAULT NULL,
  `ip_address` varchar(50) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `st_driver_meta` (
  `meta_id` bigint(20) NOT NULL,
  `merchant_id` bigint(20) NOT NULL DEFAULT '0',
  `reference_id` bigint(20) NOT NULL DEFAULT '0',
  `meta_name` varchar(100) NOT NULL DEFAULT '',
  `meta_value1` varchar(255) NOT NULL DEFAULT '',
  `meta_value2` varchar(255) NOT NULL DEFAULT '',
  `meta_value3` varchar(255) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `st_printer_meta` (
  `id` int(11) NOT NULL,
  `printer_id` int(14) NOT NULL DEFAULT '0',
  `meta_name` varchar(100) NOT NULL DEFAULT '',
  `meta_value1` varchar(255) NOT NULL DEFAULT '',
  `meta_value2` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `st_printer` (
  `printer_id` int(11) NOT NULL,
  `platform` varchar(20) NOT NULL DEFAULT '',
  `merchant_id` int(14) NOT NULL DEFAULT '0',
  `device_uuid` varchar(255) NOT NULL DEFAULT '',
  `printer_uuid` varchar(100) NOT NULL,
  `printer_name` varchar(100) NOT NULL DEFAULT '',
  `printer_bt_name` varchar(255) NOT NULL DEFAULT '',
  `printer_model` varchar(100) NOT NULL DEFAULT 'bluetooth',
  `device_id` varchar(100) NOT NULL DEFAULT '',
  `service_id` varchar(100) NOT NULL DEFAULT '',
  `characteristics` varchar(100) NOT NULL DEFAULT '',
  `paper_width` int(10) NOT NULL DEFAULT '58',
  `auto_print` int(1) NOT NULL DEFAULT '0',
  `print_type` varchar(20) NOT NULL DEFAULT 'raw',
  `character_code` varchar(20) NOT NULL DEFAULT '',
  `auto_close` int(1) NOT NULL DEFAULT '1',
  `status` int(1) NOT NULL DEFAULT '1',
  `date_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `date_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ip_address` varchar(50) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `st_invoice` (
  `invoice_number` int(14) NOT NULL,
  `invoice_uuid` varchar(100) NOT NULL DEFAULT '',
  `merchant_id` int(14) NOT NULL DEFAULT '0',
  `restaurant_name` varchar(255) NOT NULL DEFAULT '',
  `business_address` varchar(255) DEFAULT '',
  `contact_email` varchar(200) NOT NULL DEFAULT '',
  `contact_phone` varchar(50) NOT NULL DEFAULT '',
  `invoice_terms` int(14) NOT NULL DEFAULT '0',
  `invoice_total` decimal(10,4) NOT NULL DEFAULT '0.00',
  `amount_paid` decimal(10,4) NOT NULL DEFAULT '0.00',
  `merchant_base_currency` varchar(10) NOT NULL DEFAULT '',
  `admin_base_currency` varchar(10) NOT NULL DEFAULT '',
  `exchange_rate_merchant_to_admin` decimal(10,4) NOT NULL DEFAULT '0.0000',
  `exchange_rate_admin_to_merchant` decimal(10,4) NOT NULL DEFAULT '0.0000',  
  `invoice_created` datetime DEFAULT NULL,
  `due_date` datetime DEFAULT NULL,
  `date_from` datetime DEFAULT NULL,
  `date_to` datetime DEFAULT NULL,
  `payment_status` varchar(255) NOT NULL DEFAULT 'unpaid',
  `viewed` smallint(1) NOT NULL DEFAULT '0',
  `date_created` datetime DEFAULT NULL,
  `date_modified` datetime DEFAULT NULL,
  `ip_address` varchar(50) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `st_invoice_meta` (
  `id` bigint(20) NOT NULL,
  `invoice_number` int(14) NOT NULL DEFAULT '0',
  `meta_name` varchar(255) NOT NULL DEFAULT '',
  `meta_value1` varchar(255) NOT NULL DEFAULT '',
  `meta_value2` varchar(255) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `st_printer_logs` (
  `id` bigint(20) NOT NULL,
  `order_id` bigint(20) NOT NULL DEFAULT '0',
  `merchant_id` bigint(20) NOT NULL DEFAULT '0',
  `printer_type` varchar(100) NOT NULL DEFAULT 'feie',
  `printer_number` varchar(100) NOT NULL DEFAULT '',
  `print_content` text,
  `job_id` varchar(100) NOT NULL DEFAULT '',
  `status` varchar(255) NOT NULL DEFAULT 'pending',
  `date_created` datetime DEFAULT NULL,
  `ip_address` varchar(50) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `st_table_reservation` (
  `reservation_id` bigint(20) NOT NULL,
  `reservation_uuid` varchar(100) NOT NULL DEFAULT '',
  `client_id` int(14) DEFAULT '0',
  `merchant_id` int(14) NOT NULL DEFAULT '0',
  `room_id` int(14) NOT NULL DEFAULT '0',
  `table_id` int(14) NOT NULL DEFAULT '0',
  `reservation_date` date DEFAULT NULL,
  `reservation_time` time DEFAULT NULL,
  `guest_number` int(14) NOT NULL DEFAULT '0',
  `special_request` varchar(255) NOT NULL DEFAULT '',
  `cancellation_reason` text,
  `status` varchar(100) NOT NULL DEFAULT 'pending',
  `date_created` datetime DEFAULT NULL,
  `date_modified` datetime DEFAULT NULL,
  `ip_address` varchar(50) DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `st_table_reservation_history` (
  `id` bigint(20) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `reservation_id` bigint(20) NOT NULL DEFAULT '0',
  `status` varchar(255) NOT NULL DEFAULT '',
  `remarks` text,
  `ramarks_trans` text,
  `change_by` varchar(100) NOT NULL DEFAULT '',
  `ip_address` varchar(50) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `st_table_room` (
  `room_id` int(14) NOT NULL,
  `room_uuid` varchar(100) NOT NULL DEFAULT '',
  `room_name` varchar(255) NOT NULL DEFAULT '',
  `merchant_id` int(14) NOT NULL DEFAULT '0',
  `sequence` int(14) NOT NULL DEFAULT '0',
  `status` varchar(100) NOT NULL DEFAULT 'pending',
  `date_created` datetime DEFAULT NULL,
  `date_modified` datetime DEFAULT NULL,
  `ip_address` varchar(50) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `st_table_shift` (
  `shift_id` int(14) NOT NULL,
  `shift_uuid` varchar(100) NOT NULL DEFAULT '',
  `merchant_id` int(14) NOT NULL DEFAULT '0',
  `shift_name` varchar(255) NOT NULL DEFAULT '',
  `days_of_week` text,
  `first_seating` time DEFAULT NULL,
  `last_seating` time DEFAULT NULL,
  `shift_interval` int(14) NOT NULL DEFAULT '0',
  `status` varchar(100) NOT NULL DEFAULT '',
  `date_created` datetime DEFAULT NULL,
  `date_modified` datetime DEFAULT NULL,
  `ip_address` varchar(50) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `st_table_shift_days` (
  `id` int(11) NOT NULL,
  `merchant_id` int(14) NOT NULL DEFAULT '0',
  `shift_id` int(14) NOT NULL DEFAULT '0',
  `day_of_week` int(10) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `st_table_tables` (
  `table_id` int(14) NOT NULL,
  `table_uuid` varchar(100) NOT NULL DEFAULT '',
  `merchant_id` int(14) NOT NULL DEFAULT '0',
  `room_id` int(14) NOT NULL DEFAULT '0',
  `table_name` varchar(255) NOT NULL DEFAULT '',
  `min_covers` int(14) NOT NULL DEFAULT '0',
  `max_covers` int(14) NOT NULL DEFAULT '0',
  `available` smallint(1) NOT NULL DEFAULT '1',
  `device_id` varchar(50) NOT NULL DEFAULT '',
  `device_info` varchar(100) NOT NULL DEFAULT '',
  `sequence` int(14) NOT NULL DEFAULT '0',
  `status` varchar(100) NOT NULL DEFAULT 'available',
  `current_order_id` int(10) DEFAULT NULL,
  `date_created` datetime DEFAULT NULL,
  `date_modified` datetime DEFAULT NULL,
  `ip_address` varchar(50) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `st_contact` (
  `id` bigint(20) NOT NULL,
  `email_address` varchar(255) NOT NULL DEFAULT '',
  `receiver_email_address` varchar(255) NOT NULL DEFAULT '',
  `fullname` varchar(255) NOT NULL DEFAULT '',
  `contact_number` varchar(100) NOT NULL DEFAULT '',
  `country_name` varchar(100) NOT NULL DEFAULT '',
  `message` text,
  `date_created` datetime DEFAULT NULL,
  `ip_address` varchar(50) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `st_merchant_commission_order` (
  `id` int(11) NOT NULL,
  `merchant_id` bigint(20) NOT NULL DEFAULT '0',
  `transaction_type` varchar(255) NOT NULL DEFAULT '',
  `commission_type` varchar(255) NOT NULL DEFAULT '',
  `commission` decimal(10,2) NOT NULL DEFAULT '0.00',
  `date_created` datetime DEFAULT NULL,
  `date_modified` datetime DEFAULT NULL,
  `ip_address` varchar(50) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `st_driver` (
  `driver_id` bigint(20) NOT NULL,
  `merchant_id` bigint(20) NOT NULL DEFAULT '0',
  `driver_uuid` varchar(100) NOT NULL DEFAULT '',
  `token` varchar(255) NOT NULL DEFAULT '',
  `employment_type` varchar(100) NOT NULL DEFAULT 'employee',
  `last_seen` timestamp NULL DEFAULT NULL,
  `first_name` varchar(255) NOT NULL DEFAULT '',
  `last_name` varchar(255) NOT NULL DEFAULT '',
  `email` varchar(255) NOT NULL DEFAULT '',
  `phone_prefix` varchar(5) DEFAULT '',
  `phone` varchar(20) NOT NULL DEFAULT '',
  `password` varchar(100) NOT NULL DEFAULT '',
  `photo` varchar(200) NOT NULL DEFAULT '',
  `team_id` int(14) NOT NULL DEFAULT '0',
  `address` tinytext,
  `salary_type` varchar(100) NOT NULL DEFAULT 'salary',
  `salary` decimal(10,2) NOT NULL DEFAULT '0.00',
  `fixed_amount` decimal(10,2) DEFAULT '0.00',
  `commission` decimal(10,2) NOT NULL DEFAULT '0.00',
  `commission_type` varchar(50) NOT NULL DEFAULT 'percentage',
  `incentives_amount` double(10,2) NOT NULL DEFAULT '0.00',
  `allowed_offline_amount` double(10,2) NOT NULL DEFAULT '0.00',
  `license_number` varchar(100) NOT NULL DEFAULT '',
  `license_expiration` date DEFAULT NULL,
  `license_front_photo` varchar(100) NOT NULL DEFAULT '',
  `license_back_photo` varchar(100) DEFAULT '',
  `color_hex` varchar(10) NOT NULL DEFAULT '#3ecf8e',
  `path` varchar(255) NOT NULL DEFAULT '',
  `path_license` varchar(255) NOT NULL DEFAULT '',
  `status` varchar(100) DEFAULT 'active',
  `latitude` varchar(50) NOT NULL DEFAULT '',
  `lontitude` varchar(50) NOT NULL DEFAULT '',
  `delivery_distance_covered` decimal(10,2) NOT NULL DEFAULT '10000.00',
  `verification_code` int(10) NOT NULL DEFAULT '0',
  `account_verified` smallint(1) NOT NULL DEFAULT '0',
  `verify_code_requested` datetime DEFAULT NULL,
  `reset_password_request` smallint(1) NOT NULL DEFAULT '0',
  `notification` int(1) NOT NULL DEFAULT '1',
  `default_currency` varchar(5) NOT NULL DEFAULT '',  
  `is_online` smallint(1) NOT NULL DEFAULT '0',
  `date_created` datetime DEFAULT NULL,
  `date_modified` datetime DEFAULT NULL,
  `ip_address` varchar(50) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `st_driver_break` (
  `id` bigint(20) NOT NULL,
  `schedule_id` bigint(20) NOT NULL DEFAULT '0',
  `driver_id` bigint(20) NOT NULL DEFAULT '0',
  `break_duration` varchar(50) NOT NULL DEFAULT '',
  `break_started` datetime DEFAULT NULL,
  `break_ended` datetime DEFAULT NULL,
  `date_created` datetime DEFAULT NULL,
  `ip_address` varchar(50) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `st_driver_collect_cash` (
  `collect_id` bigint(20) NOT NULL,
  `collection_uuid` varchar(100) NOT NULL DEFAULT '',
  `reference_id` varchar(255) NOT NULL DEFAULT '',
  `merchant_id` bigint(20) NOT NULL DEFAULT '0',
  `driver_id` bigint(20) NOT NULL DEFAULT '0',
  `amount_collected` decimal(10,4) DEFAULT '0.00',
  `merchant_base_currency` varchar(5) NOT NULL DEFAULT '',
  `admin_base_currency` varchar(5) NOT NULL DEFAULT '',
  `exchange_rate_merchant_to_admin` decimal(10,4) NOT NULL DEFAULT '1.0000',
  `exchange_rate_admin_to_merchant` decimal(10,4) NOT NULL DEFAULT '1.0000',
  `transaction_date` datetime DEFAULT NULL,
  `date_created` datetime DEFAULT NULL,
  `ip_address` varchar(50) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `st_driver_group` (
  `group_id` bigint(20) NOT NULL,
  `merchant_id` bigint(20) NOT NULL DEFAULT '0',
  `group_uuid` varchar(100) NOT NULL DEFAULT '',
  `group_name` varchar(100) NOT NULL DEFAULT '',
  `color_hex` varchar(10) NOT NULL DEFAULT '',
  `date_created` timestamp NULL DEFAULT NULL,
  `date_modified` timestamp NULL DEFAULT NULL,
  `ip_address` varchar(50) DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `st_driver_group_relations` (
  `date_created` timestamp NULL DEFAULT NULL,
  `group_id` bigint(20) NOT NULL DEFAULT '0',
  `driver_id` bigint(20) NOT NULL DEFAULT '0',
  `vehicle_id` bigint(20) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `st_driver_payment_method` (
  `payment_method_id` int(11) NOT NULL,
  `payment_uuid` varchar(100) NOT NULL DEFAULT '',
  `driver_id` int(14) NOT NULL DEFAULT '0',
  `merchant_id` bigint(20) DEFAULT '0',
  `payment_code` varchar(100) NOT NULL DEFAULT '',
  `as_default` int(1) NOT NULL DEFAULT '0',
  `reference_id` int(14) NOT NULL DEFAULT '0',
  `attr1` varchar(255) NOT NULL DEFAULT '',
  `attr2` varchar(255) NOT NULL DEFAULT '',
  `attr3` varchar(255) NOT NULL DEFAULT '',
  `date_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `date_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ip_address` varchar(50) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `st_driver_schedule` (
  `schedule_id` bigint(20) NOT NULL,
  `schedule_uuid` varchar(100) NOT NULL DEFAULT '',
  `merchant_id` bigint(20) NOT NULL DEFAULT '0',
  `driver_id` int(14) NOT NULL DEFAULT '0',
  `vehicle_id` int(14) NOT NULL DEFAULT '0',
  `zone_id` bigint(20) NOT NULL DEFAULT '0',
  `shift_id` bigint(20) NOT NULL DEFAULT '0',
  `time_start` datetime DEFAULT NULL,
  `time_end` datetime DEFAULT NULL,
  `shift_time_started` datetime DEFAULT NULL,
  `shift_time_ended` datetime DEFAULT NULL,
  `break_duration` varchar(50) NOT NULL DEFAULT '0',
  `instructions` text,
  `active` smallint(1) NOT NULL DEFAULT '1',
  `on_demand` int(1) NOT NULL DEFAULT '0',
  `date_created` timestamp NULL DEFAULT NULL,
  `date_modified` timestamp NULL DEFAULT NULL,
  `ip_address` varchar(50) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `st_driver_shift_schedule` (
  `shift_id` bigint(20) NOT NULL,
  `shift_uuid` varchar(100) NOT NULL DEFAULT '',
  `zone_id` bigint(20) NOT NULL DEFAULT '0',
  `merchant_id` bigint(20) NOT NULL DEFAULT '0',  
  `time_start` datetime DEFAULT NULL,
  `time_end` datetime DEFAULT NULL,
  `max_allow_slot` int(14) NOT NULL DEFAULT '0',
  `status` varchar(100) NOT NULL DEFAULT 'active',
  `date_created` datetime DEFAULT NULL,
  `date_modified` datetime DEFAULT NULL,
  `ip_address` varchar(50) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `st_driver_vehicle` (
  `vehicle_id` bigint(20) NOT NULL,
  `vehicle_uuid` varchar(100) NOT NULL DEFAULT '',
  `vehicle_type_id` int(14) DEFAULT '0',
  `merchant_id` bigint(20) NOT NULL DEFAULT '0',  
  `driver_id` bigint(20) NOT NULL DEFAULT '0',
  `plate_number` varchar(100) NOT NULL DEFAULT '',
  `maker` varchar(100) NOT NULL DEFAULT '',
  `model` varchar(100) NOT NULL DEFAULT '',
  `color` varchar(50) NOT NULL DEFAULT '',
  `photo` varchar(100) NOT NULL DEFAULT '',
  `path` varchar(200) NOT NULL DEFAULT '',
  `active` smallint(1) NOT NULL DEFAULT '1',
  `date_created` datetime DEFAULT NULL,
  `date_modified` datetime DEFAULT NULL,
  `ip_address` varchar(50) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `st_currency_exchangerate` (
  `id` bigint(20) NOT NULL,
  `provider` varchar(100) NOT NULL DEFAULT '',
  `base_currency` varchar(10) NOT NULL DEFAULT '',
  `currency_code` varchar(10) NOT NULL DEFAULT '',
  `exchange_rate` decimal(10,4) DEFAULT '0.0000',
  `date_created` datetime DEFAULT NULL,
  `date_modified` datetime DEFAULT NULL,
  `ip_address` varchar(50) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `st_paydelivery` (
  `id` int(14) NOT NULL,
  `payment_name` varchar(255) NOT NULL DEFAULT '',
  `photo` varchar(255) NOT NULL DEFAULT '',
  `path` varchar(255) DEFAULT '',
  `sequence` int(14) NOT NULL DEFAULT '0',
  `status` varchar(100) NOT NULL DEFAULT '',
  `date_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `date_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ip_address` varchar(100) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `st_cron` (
  `cron_id` bigint(20) NOT NULL,
  `url` text,
  `status` smallint(6) NOT NULL DEFAULT '0',
  `date_created` datetime DEFAULT NULL,
  `date_modified` datetime DEFAULT NULL,
  `ip_address` varchar(50) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `st_discount` (
  `discount_id` int(11) NOT NULL,
  `discount_uuid` varchar(100) NOT NULL DEFAULT '',
  `merchant_id` int(11) NOT NULL DEFAULT '0',
  `transaction_type` varchar(100) NOT NULL DEFAULT '',
  `title` varchar(255) NOT NULL DEFAULT '',
  `description` text,
  `discount_type` varchar(100) NOT NULL DEFAULT '',
  `amount` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `minimum_amount` decimal(12,4) DEFAULT '0.0000',
  `maximum_amount` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `start_date` date DEFAULT NULL,
  `expiration_date` date DEFAULT NULL,
  `status` int(1) NOT NULL DEFAULT '1',
  `sequence` int(14) NOT NULL DEFAULT '0',
  `date_created` timestamp NULL DEFAULT NULL,
  `date_modified` timestamp NULL DEFAULT NULL,
  `ip_address` varchar(50) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `st_kitchen_order` (
  `kitchen_order_id` int(11) NOT NULL,
  `is_completed` tinyint(1) NOT NULL DEFAULT '0',
  `merchant_id` int(14) NOT NULL DEFAULT '0',
  `order_reference` varchar(50) NOT NULL DEFAULT '',
  `order_ref_id` varchar(100) NOT NULL DEFAULT '',
  `table_uuid` varchar(100) NOT NULL DEFAULT '',
  `room_uuid` varchar(100) NOT NULL DEFAULT '',
  `customer_name` varchar(200) NOT NULL DEFAULT '',
  `transaction_type` varchar(50) NOT NULL DEFAULT '',
  `item_token` varchar(255) NOT NULL DEFAULT '',
  `qty` int(14) NOT NULL DEFAULT '0',
  `item_status` varchar(50) NOT NULL DEFAULT 'queue',
  `special_instructions` text,
  `attributes` text,
  `addons` text,
  `whento_deliver` varchar(50) NOT NULL DEFAULT '',
  `delivery_date` date DEFAULT NULL,
  `delivery_time` varchar(50) NOT NULL DEFAULT '',
  `timezone` varchar(50) NOT NULL DEFAULT '',
  `sequence` int(14) NOT NULL DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `date_completed` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `st_customer_request` (
  `request_id` int(11) NOT NULL,
  `merchant_id` int(14) NOT NULL DEFAULT '0',
  `cart_uuid` varchar(100) NOT NULL DEFAULT '',
  `table_uuid` varchar(100) NOT NULL DEFAULT '',
  `transaction_type` varchar(100) NOT NULL DEFAULT '',
  `timezone` varchar(100) NOT NULL DEFAULT '',
  `request_item` varchar(200) NOT NULL DEFAULT '',
  `qty` int(14) NOT NULL DEFAULT '0',
  `request_time` datetime DEFAULT NULL,
  `completed_time` datetime DEFAULT NULL,
  `request_status` varchar(20) NOT NULL DEFAULT 'pending',
  `is_view` int(1) DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `st_table_status` (
  `table_uuid` varchar(100) NOT NULL DEFAULT '',
  `merchant_id` int(14) NOT NULL DEFAULT '0',
  `status` varchar(20) NOT NULL DEFAULT 'available'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



CREATE TABLE `st_table_device` (
  `table_uuid` varchar(100) NOT NULL DEFAULT '',
  `device_id` varchar(50) NOT NULL DEFAULT '',
  `device_info` varchar(50) NOT NULL DEFAULT '',
  `created_at` datetime DEFAULT NULL,
  `ip_address` varchar(50) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `st_plan_subscriptions` (
  `id` int(10) NOT NULL,
  `payment_id` varchar(50) NOT NULL DEFAULT '',
  `payment_code` varchar(50) NOT NULL DEFAULT '',
  `subscriber_id` int(10) NOT NULL DEFAULT '0',
  `package_id` int(10) NOT NULL DEFAULT '0',
  `plan_name` varchar(255) NOT NULL DEFAULT '',
  `billing_cycle` varchar(50) NOT NULL DEFAULT '',
  `amount` decimal(10,4) NOT NULL DEFAULT '0.0000',
  `currency_code` varchar(5) NOT NULL DEFAULT '',
  `subscriber_type` varchar(50) NOT NULL DEFAULT 'merchant',
  `subscription_id` varchar(255) NOT NULL DEFAULT '',
  `created_at` date DEFAULT NULL,
  `next_due` date DEFAULT NULL,
  `expiration` date DEFAULT NULL,
  `current_start` date DEFAULT NULL,
  `current_end` date DEFAULT NULL,
  `jobs` varchar(100) NOT NULL DEFAULT '',
  `sucess_url` varchar(255) NOT NULL DEFAULT '',
  `failed_url` varchar(255) NOT NULL DEFAULT '',
  `status` varchar(50) NOT NULL DEFAULT 'pending',
  `date_created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `st_plans_create_payment` (
  `id` int(14) NOT NULL,
  `payment_id` varchar(100) NOT NULL DEFAULT '',
  `package_id` int(14) NOT NULL DEFAULT '0',
  `subscriber_id` int(14) NOT NULL DEFAULT '0',
  `subscription_type` varchar(50) NOT NULL DEFAULT '',
  `subscriber_type` varchar(50) NOT NULL DEFAULT 'merchant',
  `jobs` varchar(100) NOT NULL DEFAULT '',
  `success_url` varchar(255) DEFAULT '',
  `failed_url` varchar(255) NOT NULL DEFAULT '',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `st_plans_webhooks` (
  `event_id` int(10) NOT NULL,
  `id` varchar(255) NOT NULL,
  `event_type` varchar(255) NOT NULL DEFAULT '',
  `processed_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `st_plans_customer` (
  `id` int(14) NOT NULL,
  `payment_code` varchar(50) NOT NULL DEFAULT '',
  `subscriber_id` int(14) NOT NULL DEFAULT '0',
  `subscriber_type` varchar(50) NOT NULL DEFAULT '',
  `customer_id` varchar(100) NOT NULL DEFAULT '',
  `livemode` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `st_merchant_location` (
  `id` int(11) NOT NULL,
  `merchant_id` int(14) DEFAULT '0',
  `country_id` int(14) NOT NULL DEFAULT '0',
  `state_id` int(14) NOT NULL DEFAULT '0',
  `city_id` int(14) NOT NULL DEFAULT '0',
  `area_id` int(14) DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `st_location_time_estimate` (
  `id` int(11) NOT NULL,
  `merchant_id` int(14) NOT NULL DEFAULT '0',
  `service_type` varchar(100) NOT NULL DEFAULT '',
  `country_id` int(14) NOT NULL DEFAULT '0',
  `state_id` int(14) NOT NULL DEFAULT '0',
  `city_id` int(14) NOT NULL DEFAULT '0',
  `area_id` int(14) NOT NULL DEFAULT '0',
  `estimated_time_min` int(10) NOT NULL DEFAULT '0',
  `estimated_time_max` int(10) NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `st_job_queue` (
  `id` int(11) NOT NULL,
  `job_name` varchar(255) NOT NULL,
  `job_data` text NOT NULL,
  `status` varchar(50) NOT NULL DEFAULT 'pending',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `st_kitchen_workload_settings` (
  `id` int(11) NOT NULL,
  `merchant_id` int(10) DEFAULT '0',
  `low_workload_max_orders` int(10) NOT NULL DEFAULT '0',
  `low_workload_extra_time` int(10) NOT NULL DEFAULT '0',
  `medium_workload_min_orders` int(10) NOT NULL DEFAULT '0',
  `medium_workload_max_orders` int(10) NOT NULL DEFAULT '0',
  `medium_workload_extra_time` int(10) NOT NULL DEFAULT '0',
  `high_workload_min_orders` int(10) NOT NULL DEFAULT '0',
  `high_workload_extra_time` int(10) NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `st_driver_reviews` (
  `review_id` int(11) NOT NULL,
  `order_id` int(10) DEFAULT NULL,
  `customer_id` int(10) DEFAULT NULL,
  `driver_id` int(10) DEFAULT NULL,
  `rating` tinyint(5) DEFAULT '0',
  `review_text` text,
  `as_anonymous` tinyint(1) NOT NULL DEFAULT '0',
  `status` varchar(100) NOT NULL DEFAULT 'publish',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `st_customer_points_ranks` (
  `account_id` int(11) DEFAULT NULL,
  `first_name` varchar(255) NOT NULL DEFAULT '',
  `last_name` varchar(255) NOT NULL DEFAULT '',
  `total_earning` decimal(10,2) DEFAULT NULL,
  `rank` int(10) DEFAULT NULL,
  `previous_points` decimal(10,2) DEFAULT NULL,
  `total_players` int(10) DEFAULT NULL,
  `percentage_better_than` int(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `st_custom_fields` (
  `field_id` int(11) NOT NULL,
  `field_name` varchar(100) NOT NULL,
  `field_label` varchar(100) NOT NULL,
  `field_type` enum('text','number','date','checkbox','select','textarea') NOT NULL,
  `options` text,
  `is_required` tinyint(1) DEFAULT '0',
  `entity` varchar(100) NOT NULL DEFAULT 'client',
  `sequence` int(11) NOT NULL DEFAULT '0',
  `visible` smallint(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `st_user_custom_field_values` (
  `value_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `field_id` int(11) NOT NULL,
  `value` text,
  `entity` varchar(50) NOT NULL DEFAULT 'client'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `st_promos` (
  `promo_id` int(11) NOT NULL,
  `id` int(11) DEFAULT NULL,
  `merchant_id` int(11) DEFAULT NULL,
  `valid_from` date DEFAULT NULL,
  `valid_to` date DEFAULT NULL,
  `offer_type` varchar(100) NOT NULL DEFAULT '',
  `discount_name` varchar(255) NOT NULL DEFAULT '',
  `offer_amount` decimal(10,2) DEFAULT NULL,
  `discount_type` varchar(100) NOT NULL DEFAULT '',
  `min_order` decimal(10,2) DEFAULT NULL,
  `max_order` decimal(10,2) NOT NULL DEFAULT '0.00',
  `max_discount_cap` decimal(10,2) NOT NULL DEFAULT '0.00',
  `applicable_to` varchar(255) DEFAULT NULL,
  `status` varchar(100) NOT NULL DEFAULT '',
  `visible` smallint(1) NOT NULL DEFAULT '1',
  `monday` smallint(1) NOT NULL DEFAULT '1',
  `tuesday` smallint(1) NOT NULL DEFAULT '1',
  `wednesday` smallint(1) NOT NULL DEFAULT '1',
  `thursday` smallint(1) NOT NULL DEFAULT '1',
  `friday` smallint(1) NOT NULL DEFAULT '1',
  `saturday` smallint(1) NOT NULL DEFAULT '1',
  `sunday` smallint(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `st_payment_reference` (
  `id` int(11) NOT NULL,
  `payment_type` varchar(50) NOT NULL DEFAULT 'order',
  `reference_id` varchar(100) DEFAULT NULL,
  `payment_reference_id` varchar(100) DEFAULT NULL,
  `meta_value` text,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `st_holidays` (
  `id` int(11) NOT NULL,
  `merchant_id` int(11) NOT NULL,
  `holiday_date` date NOT NULL,
  `holiday_name` varchar(255) NOT NULL,
  `is_closed` tinyint(1) DEFAULT '1',
  `open_time` time DEFAULT NULL,
  `close_time` time DEFAULT NULL,
  `reason` text,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `st_driver_attempts` (
  `attempt_id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `driver_id` int(11) NOT NULL,
  `attempt_status` varchar(100) DEFAULT 'pending',
  `attempt_time` datetime DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `st_suggested_items` (
  `id` int(11) NOT NULL,
  `merchant_id` int(11) DEFAULT NULL,
  `item_id` int(10) DEFAULT NULL,
  `status` varchar(50) DEFAULT 'pending',
  `reason` text,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `st_item_free_promo` (
  `promo_id` int(11) NOT NULL,
  `merchant_id` int(11) DEFAULT '0',
  `free_item_id` int(10) DEFAULT NULL,
  `item_token` varchar(50) NOT NULL DEFAULT '',
  `item_size_id` int(10) NOT NULL DEFAULT '0',
  `cat_id` int(10) NOT NULL DEFAULT '0',
  `minimum_cart_total` decimal(10,2) NOT NULL DEFAULT '0.00',
  `max_free_quantity` int(1) DEFAULT '1',
  `auto_add` tinyint(1) DEFAULT '0',
  `status` varchar(50) NOT NULL DEFAULT 'publish',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `st_kot_tickets` (
  `kot_id` int(11) NOT NULL,
  `kot_number` int(10) NOT NULL DEFAULT '0',
  `order_id` int(10) NOT NULL DEFAULT '0',
  `merchant_id` int(10) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `st_kot_items` (
  `id` int(11) NOT NULL,
  `kot_id` int(10) NOT NULL DEFAULT '0',
  `order_item_id` int(10) NOT NULL DEFAULT '0',
  `qty` int(10) NOT NULL DEFAULT '0',
  `note` text,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- END OF CREATING TABLE
--

--
-- Dumping data for table `st_sourcemessage`
--

INSERT INTO `st_sourcemessage` (`id`, `category`, `message`) VALUES
(1, 'backend', 'Total Sales'),
(2, 'backend', 'Total Merchant'),
(3, 'backend', 'Total Commission'),
(4, 'backend', 'Total Subscriptions'),
(5, 'backend', 'Commission this week'),
(6, 'backend', 'Commission this month'),
(7, 'backend', 'Subscriptions this month'),
(8, 'backend', 'Order received'),
(9, 'backend', 'Today delivered'),
(10, 'backend', 'New customer'),
(11, 'backend', 'Total refund'),
(12, 'backend', 'Last Orders'),
(13, 'backend', 'Quick management of the last {{limit}} orders'),
(14, 'backend', 'Block Customer'),
(15, 'backend', 'You are about to block this customer from ordering to your restaurant, click confirm to continue?'),
(16, 'backend', 'Cancel'),
(17, 'backend', 'Confirm'),
(18, 'backend', 'Sold'),
(19, 'backend', 'sales'),
(20, 'backend', 'Sales overview'),
(21, 'backend', 'Top Customers'),
(22, 'backend', 'Overview of Review'),
(23, 'backend', 'Star'),
(24, 'backend', 'Checkout All Reviews'),
(25, 'backend', 'Recent payout'),
(26, 'backend', 'Withdrawals Details'),
(27, 'backend', 'Close'),
(28, 'backend', 'Process this payout'),
(29, 'backend', 'Cancel this payout'),
(30, 'backend', 'Set status to paid'),
(31, 'backend', 'All'),
(32, 'backend', 'Processing'),
(33, 'backend', 'Ready'),
(34, 'backend', 'Completed'),
(35, 'backend', 'Popular items'),
(36, 'backend', 'latest popular items'),
(37, 'backend', 'Last 30 days sales'),
(38, 'backend', 'sales for last 30 days'),
(39, 'backend', 'Popular merchants'),
(40, 'backend', 'best selling restaurant'),
(41, 'backend', 'Popular by review'),
(42, 'backend', 'most reviewed'),
(45, 'backend', 'The difference between the DateTimes is NaN.'),
(46, 'backend', 'Moments ago'),
(47, 'backend', 'Seconds from now'),
(48, 'backend', 'Yesterday'),
(49, 'backend', 'Tomorrow'),
(50, 'backend', 'year'),
(51, 'backend', 'minutes'),
(52, 'backend', 'ago'),
(53, 'backend', 'hours'),
(54, 'backend', 'days'),
(55, 'backend', 'minute'),
(56, 'backend', 'hour'),
(57, 'backend', 'day'),
(58, 'backend', 'Member since {{date_created}}'),
(59, 'backend', '{{total_sold}} orders'),
(60, 'backend', '{{total_sold}} sold'),
(61, 'backend', 'This month you got {{count}} New Reviews'),
(62, 'backend', 'You don\'t have current orders.'),
(63, 'backend', 'Order #{{order_id}}'),
(64, 'backend', '{{sold}} sold'),
(65, 'backend', 'ratings'),
(66, 'backend', 'Title'),
(67, 'backend', 'Select File'),
(68, 'backend', 'Upload New'),
(69, 'backend', 'Website logo'),
(70, 'backend', 'Add Files'),
(71, 'backend', 'Previous'),
(72, 'backend', 'Next'),
(73, 'backend', 'Search'),
(74, 'backend', 'Business Address'),
(75, 'backend', 'Address'),
(76, 'backend', 'Contact Phone Number'),
(77, 'backend', 'Contact email'),
(78, 'backend', 'Save'),
(79, 'backend', 'Site information'),
(80, 'backend', 'Map API Keys'),
(81, 'backend', 'Google Recaptcha'),
(82, 'backend', 'Search Mode'),
(83, 'backend', 'Login & Signup'),
(84, 'backend', 'Phone Settings'),
(85, 'backend', 'Social Login'),
(86, 'backend', 'Printing Settings'),
(87, 'backend', 'Reviews'),
(88, 'backend', 'Timezone'),
(89, 'backend', 'Ordering'),
(90, 'backend', 'Merchant Registration'),
(91, 'backend', 'Notifications'),
(92, 'backend', 'Contact Settings'),
(93, 'backend', 'Analytics'),
(94, 'backend', 'Choose Map Provider'),
(95, 'backend', 'Google Maps'),
(96, 'backend', 'Mapbox'),
(97, 'backend', 'Google Maps (default)'),
(98, 'backend', 'Geocoding API Key'),
(99, 'backend', 'Google Maps JavaScript API'),
(100, 'backend', 'Mapbox Access Token'),
(101, 'backend', 'Site configuration'),
(102, 'backend', 'reCAPTCHA v2'),
(103, 'backend', 'Captcha Site Key'),
(104, 'backend', 'Captcha Secret'),
(105, 'backend', 'Captcha Lang'),
(106, 'backend', 'default is = en'),
(107, 'backend', 'Administration login'),
(108, 'backend', 'Enabled'),
(109, 'backend', 'Merchant login'),
(111, 'backend', 'Address using map provider'),
(112, 'backend', 'Zone'),
(113, 'backend', 'Location using define address'),
(114, 'backend', 'Settings for Address'),
(115, 'backend', 'Enabled choose address from map'),
(116, 'backend', 'Set Specific Country'),
(117, 'backend', 'leave empty to show all country'),
(118, 'backend', 'Settings for define locations'),
(119, 'backend', 'City / Area'),
(120, 'backend', 'State / City'),
(121, 'backend', 'PostalCode/ZipCode'),
(122, 'backend', 'All Country'),
(123, 'backend', 'No results.'),
(124, 'backend', 'Key'),
(125, 'backend', 'Value'),
(126, 'backend', 'Search key'),
(127, 'backend', 'Add Key'),
(128, 'backend', 'First'),
(129, 'backend', 'Last'),
(130, 'backend', 'Signup Type'),
(131, 'backend', 'Standard signup'),
(132, 'backend', 'Mobile phone signup'),
(133, 'backend', 'Signup Verifications'),
(134, 'backend', 'This settings only works in standard signup'),
(135, 'backend', 'Resend code interval'),
(136, 'backend', 'Google reCapcha'),
(137, 'backend', 'Terms and condition'),
(138, 'backend', 'Welcome Template'),
(139, 'backend', 'New Signup Template'),
(140, 'backend', 'this template will send to admin user'),
(141, 'backend', 'Verification Template'),
(142, 'backend', 'Reset Password Template'),
(143, 'backend', 'Block user from registering'),
(144, 'backend', 'Multiple email separated by comma'),
(145, 'backend', 'Multiple mobile separated by comma'),
(146, 'backend', 'Phone country list'),
(147, 'backend', 'define the country selection for mobile phone, empty means will show all.'),
(148, 'backend', 'Default country'),
(149, 'backend', 'default mobile country'),
(150, 'backend', 'Facebook'),
(151, 'backend', 'Enabled Facebook Login'),
(152, 'backend', 'App ID'),
(153, 'backend', 'App Secret'),
(154, 'backend', 'Enabled Google Login'),
(155, 'backend', 'Client ID'),
(156, 'backend', 'Client Secret'),
(157, 'backend', 'Google'),
(158, 'backend', 'Receipt Thank you text'),
(159, 'backend', 'Receipt Footer text'),
(160, 'backend', 'Receipt Logo'),
(161, 'backend', 'Item translations'),
(162, 'backend', 'Merchant can edit/delete review'),
(163, 'backend', 'Resize image width'),
(164, 'backend', 'upload review image will resize to set width, if below set width no resizing will happen.'),
(165, 'backend', 'Template review'),
(166, 'backend', 'Send email reminder to customer to review there order.'),
(167, 'backend', 'Time Zone'),
(168, 'backend', 'Date Format'),
(169, 'backend', 'Time Format'),
(170, 'backend', 'Time interval'),
(171, 'backend', 'Enabled Ordering'),
(172, 'backend', 'Cannot do order again if previous order status is'),
(173, 'backend', 'Order Cancellation'),
(174, 'backend', 'Enabled cancellation of order'),
(175, 'backend', 'Enabled Registration'),
(176, 'backend', 'Enabled CAPTCHA'),
(177, 'backend', 'Membership Program'),
(178, 'backend', 'Terms and conditions'),
(179, 'backend', 'Pre-configure food item size'),
(180, 'backend', 'Templates'),
(181, 'backend', 'this will be added as default food item size to merchant during registration. value must be separated by comma eg. small,medium,large'),
(182, 'backend', 'Confirm Account'),
(183, 'backend', 'Welcome email'),
(184, 'backend', 'Plan Near Expiration'),
(185, 'backend', 'Plan Expired'),
(186, 'backend', 'New Signup'),
(187, 'backend', 'this template will send to admin'),
(188, 'backend', 'Enabled Notification'),
(189, 'backend', 'Email and Mobile number who will receive notifications like new order and cancel order.'),
(190, 'backend', 'Multiple email/mobile must be separated by comma.'),
(191, 'backend', 'Email address'),
(192, 'backend', 'Mobile number'),
(193, 'backend', 'Receiver Email Address'),
(194, 'backend', 'Content'),
(195, 'backend', 'Contact Fields'),
(196, 'backend', 'Facebook Pixel Setting'),
(197, 'backend', 'Facebook Pixel ID'),
(198, 'backend', 'Google Analytics Setting'),
(199, 'backend', 'Tracking ID'),
(200, 'backend', 'All Merchant'),
(201, 'backend', 'Name'),
(202, 'backend', 'Charge Type'),
(203, 'backend', 'Actions'),
(204, 'backend', 'Add new'),
(205, 'backend', 'Update'),
(206, 'backend', 'Delete'),
(207, 'backend', 'Edit Merchant'),
(208, 'backend', 'Restaurant name'),
(209, 'backend', 'Restaurant Slug'),
(210, 'backend', 'Contact Name'),
(211, 'backend', 'Contact Phone'),
(212, 'backend', 'Header'),
(213, 'backend', 'About'),
(214, 'backend', 'Short About'),
(215, 'backend', 'Cuisine'),
(216, 'backend', 'Services'),
(217, 'backend', 'Tags'),
(218, 'backend', 'Featured'),
(219, 'backend', 'Delivery Distance Covered'),
(220, 'backend', 'Published Merchant'),
(221, 'backend', 'Miles'),
(222, 'backend', 'Kilometers'),
(223, 'backend', 'Status'),
(224, 'backend', 'Logo'),
(225, 'backend', 'Merchant information'),
(226, 'backend', 'Login information'),
(227, 'backend', 'Merchant Type'),
(229, 'backend', 'Payment history'),
(230, 'backend', 'Payment settings'),
(231, 'backend', 'Others'),
(232, 'backend', 'First Name'),
(233, 'backend', 'Last Name'),
(235, 'backend', 'Contact number'),
(236, 'backend', 'Username'),
(237, 'backend', 'New Password'),
(238, 'backend', 'Confirm Password'),
(239, 'backend', 'Address details'),
(241, 'backend', 'Geolocation'),
(242, 'backend', 'Latitude'),
(243, 'backend', 'Lontitude'),
(244, 'backend', 'Radius distance covered'),
(245, 'backend', 'Get your address geolocation via service like [link] or [link2], entering invalid coordinates will make your store not available for ordering'),
(246, 'backend', 'No results'),
(247, 'backend', 'Searching...'),
(248, 'backend', 'Type'),
(249, 'backend', 'commission on orders'),
(250, 'backend', 'Percent Commision'),
(251, 'backend', 'Plan'),
(252, 'backend', 'Created'),
(253, 'backend', 'Payment'),
(254, 'backend', 'Invoice #'),
(255, 'backend', 'No data available in table'),
(256, 'backend', 'Showing [start] to [end] of [total] entries'),
(257, 'backend', 'Showing 0 to 0 of 0 entries'),
(258, 'backend', '(filtered from [max] total entries)'),
(259, 'backend', 'Show [menu] entries'),
(260, 'backend', 'Loading...'),
(261, 'backend', 'Search:'),
(262, 'backend', 'No matching records found'),
(266, 'backend', ': activate to sort column ascending'),
(267, 'backend', ': activate to sort column descending'),
(268, 'backend', 'Enabled Payment gateway'),
(269, 'backend', 'Check All'),
(270, 'backend', 'Close this store'),
(272, 'backend', 'Add Merchant'),
(273, 'backend', 'Edit Merchant - information'),
(274, 'backend', 'Edit Merchant - login'),
(275, 'backend', 'Edit Merchant - Merchant type'),
(276, 'backend', 'Edit Merchant - Featured'),
(277, 'backend', 'Edit Merchant - Address'),
(278, 'backend', 'Edit Merchant - Zone'),
(280, 'backend', 'Merchant - Payment Settings'),
(281, 'backend', 'Merchant - Others'),
(282, 'backend', 'Merchant - Access'),
(283, 'backend', 'All Sponsored'),
(284, 'backend', 'Expiration Date'),
(285, 'backend', 'Plan list'),
(286, 'backend', 'Description'),
(287, 'backend', 'Price'),
(288, 'backend', 'Promo'),
(289, 'backend', 'All Plans'),
(290, 'backend', 'Add'),
(291, 'backend', 'Promo Price'),
(292, 'backend', 'Plan period'),
(293, 'backend', 'Item limit'),
(294, 'backend', '0 is unlimited numbers of items'),
(295, 'backend', 'Order limit'),
(296, 'backend', 'Trial Period'),
(297, 'backend', '0 is unlimited numbers of orders per period'),
(298, 'backend', 'trial period number of days'),
(299, 'backend', 'Unlimited'),
(300, 'backend', 'Limited'),
(301, 'backend', 'Daily'),
(302, 'backend', 'Monthly'),
(303, 'backend', 'Anually'),
(304, 'backend', 'Weekly'),
(305, 'backend', 'Details'),
(306, 'backend', 'Features'),
(307, 'backend', 'Plans Payment ID'),
(308, 'backend', 'Paypal'),
(309, 'backend', 'Plan ID'),
(310, 'backend', 'Stripe'),
(311, 'backend', 'Price IDs'),
(312, 'backend', 'Razorpay'),
(313, 'backend', 'No payment yet available'),
(314, 'backend', 'Order Information'),
(315, 'backend', 'Order ID'),
(316, 'backend', 'Merchant'),
(317, 'backend', 'Customer'),
(318, 'backend', 'Orders'),
(320, 'backend', 'Total Orders'),
(321, 'backend', 'All Orders'),
(322, 'backend', 'Filters'),
(323, 'backend', '{{total_items}} items'),
(324, 'backend', 'Order Type.'),
(325, 'backend', 'Total. {{total}}'),
(326, 'backend', 'Place on {{date}}'),
(327, 'backend', 'Start date -- End date'),
(328, 'backend', 'to'),
(329, 'backend', 'Order type'),
(330, 'backend', 'Su'),
(331, 'backend', 'Mo'),
(332, 'backend', 'Tu'),
(333, 'backend', 'We'),
(334, 'backend', 'Th'),
(335, 'backend', 'Fr'),
(336, 'backend', 'Sa'),
(337, 'backend', 'January'),
(338, 'backend', 'February'),
(339, 'backend', 'March'),
(340, 'backend', 'April'),
(341, 'backend', 'May'),
(342, 'backend', 'June'),
(343, 'backend', 'July'),
(344, 'backend', 'August'),
(345, 'backend', 'September'),
(346, 'backend', 'October'),
(347, 'backend', 'November'),
(348, 'backend', 'December'),
(349, 'backend', 'Today'),
(351, 'backend', 'Last 7 Days'),
(352, 'backend', 'Last 30 Days'),
(353, 'backend', 'This Month'),
(354, 'backend', 'Last Month'),
(355, 'backend', 'Custom Range'),
(357, 'backend', 'By Merchant'),
(358, 'backend', 'By customer'),
(359, 'backend', 'By Status'),
(360, 'backend', 'By Order Type'),
(361, 'backend', 'Clear Filters'),
(362, 'backend', 'Apply Filters'),
(363, 'backend', 'Status for new order'),
(364, 'backend', 'Status for delivered order'),
(365, 'backend', 'Status for completed pickup/dinein order'),
(366, 'backend', 'Status for cancel order'),
(367, 'backend', 'Status for order rejection'),
(368, 'backend', 'Status for delivery failed'),
(369, 'backend', 'Status for failed pickup/dinein order'),
(370, 'backend', 'Order Status'),
(371, 'backend', 'Order Tabs'),
(372, 'backend', 'Order Buttons'),
(373, 'backend', 'Order Tracking'),
(374, 'backend', 'Template'),
(375, 'backend', 'Settings'),
(376, 'backend', 'New Orders'),
(377, 'backend', 'select the status that will show on this tab.'),
(378, 'backend', 'Orders Processing'),
(380, 'backend', 'Orders Ready'),
(381, 'backend', 'Completed Today'),
(382, 'backend', 'define the buttons for this tab'),
(383, 'backend', 'Button Name'),
(385, 'backend', 'Order Processing'),
(386, 'backend', 'Button CSS class name eg. btn-green, btn-black'),
(387, 'backend', 'Status for order processing'),
(388, 'backend', 'Status for food ready'),
(389, 'backend', 'Status for in transit'),
(390, 'backend', 'Status for delivered'),
(391, 'backend', 'Template Invoice'),
(392, 'backend', 'Template Refund'),
(393, 'backend', 'Template Partial Refund'),
(394, 'backend', 'Delay Order'),
(395, 'backend', 'All Payment gateway'),
(396, 'backend', 'Add Gateway'),
(397, 'backend', 'Payment gateway list'),
(398, 'backend', 'Online Payment'),
(399, 'backend', 'Available for payout'),
(400, 'backend', 'Available for plan'),
(401, 'backend', 'Payment code'),
(402, 'backend', 'This fields must not have spaces'),
(403, 'backend', 'Payment name'),
(404, 'backend', 'Logo type'),
(405, 'backend', 'Logo class icon'),
(406, 'backend', 'Get icon here'),
(407, 'backend', 'Featured Image'),
(408, 'backend', 'Drop files anywhere to upload'),
(409, 'backend', 'or'),
(410, 'backend', 'Select Files'),
(411, 'backend', 'Icon'),
(412, 'backend', 'Image'),
(413, 'backend', 'Click here'),
(414, 'backend', 'Transaction History'),
(415, 'backend', 'Earnings'),
(416, 'backend', 'Your commission transaction for all orders'),
(418, 'backend', 'Create a Transaction'),
(419, 'backend', 'Adjustment'),
(420, 'backend', 'Date'),
(421, 'backend', 'Transaction'),
(422, 'backend', 'Debit/Credit'),
(423, 'backend', 'Running Balance'),
(424, 'backend', 'Credit'),
(425, 'backend', 'Debit'),
(426, 'backend', 'Payout'),
(427, 'backend', 'Cash In'),
(428, 'backend', 'All transactions'),
(429, 'backend', 'Statement'),
(430, 'backend', 'Total Balance'),
(431, 'backend', 'Merchant Earnings'),
(432, 'backend', 'Balance'),
(435, 'backend', 'Deactivate Merchant'),
(436, 'backend', 'You are about to deactivate this merchant, click confirm to continue?'),
(437, 'backend', 'Create adjustment'),
(438, 'backend', 'Transaction Description'),
(439, 'backend', 'Amount'),
(441, 'backend', 'Submit'),
(442, 'backend', 'Membership History'),
(445, 'backend', 'Refund'),
(446, 'backend', 'Total'),
(447, 'backend', 'Contact'),
(448, 'backend', 'Email'),
(449, 'backend', 'Member since'),
(450, 'backend', 'Activate Merchant'),
(451, 'backend', 'Merchant Info'),
(452, 'backend', 'Withdrawals'),
(453, 'backend', 'Unpaid'),
(454, 'backend', 'Paid'),
(455, 'backend', 'Total Unpaid'),
(456, 'backend', 'Total Paid'),
(457, 'backend', 'Payment status'),
(458, 'backend', 'Account number'),
(459, 'backend', 'Account name'),
(460, 'backend', 'Account type'),
(461, 'backend', 'Account currency'),
(462, 'backend', 'Routing number'),
(463, 'backend', 'Country'),
(464, 'backend', 'Account Holders Name'),
(465, 'backend', 'Bank Account Number/IBAN'),
(466, 'backend', 'SWIFT Code'),
(467, 'backend', 'Bank Name in Full'),
(468, 'backend', 'Bank Branch City'),
(469, 'backend', 'Date requested'),
(470, 'backend', 'Payment Method'),
(472, 'backend', 'offline payment'),
(473, 'backend', 'Emabled request payout'),
(474, 'backend', 'Payout request auto process'),
(475, 'backend', 'Payout number of days to process'),
(476, 'backend', 'number of days that payout will automatically process (this works only if payout auto process is enabled). count starts from the day of request of merchant'),
(477, 'backend', 'Payout minimum amount'),
(478, 'backend', 'Number of payouts'),
(479, 'backend', 'Number of payouts can request per month.'),
(480, 'backend', 'Template new payout request - for admin'),
(481, 'backend', 'Template Payout paid'),
(482, 'backend', 'Template Payout Cancel'),
(483, 'backend', 'Cuisine list'),
(484, 'backend', 'All Cuisine'),
(485, 'backend', 'Add Cuisine'),
(486, 'backend', 'Cuisine Name'),
(487, 'backend', 'Background Color Hex'),
(488, 'backend', 'Font Color Hex'),
(489, 'backend', '{{lang}} translation'),
(490, 'backend', 'Enter {{lang}} name here'),
(491, 'backend', 'Update Cuisine'),
(492, 'backend', 'Dishes list'),
(493, 'backend', 'Add Dishes'),
(494, 'backend', 'Dish Name'),
(495, 'backend', 'All Dishes'),
(496, 'backend', 'Update Dishes'),
(497, 'backend', 'Tags list'),
(498, 'backend', 'Tag Name'),
(499, 'backend', 'All Tags'),
(500, 'backend', 'Add Tags'),
(501, 'backend', 'Update Tags'),
(502, 'backend', 'Status list'),
(503, 'backend', 'Color Hex'),
(505, 'backend', 'Update Status'),
(506, 'backend', 'Status actions'),
(507, 'backend', 'ID'),
(508, 'backend', 'Action Type'),
(509, 'backend', 'Add actions'),
(510, 'backend', 'Update actions'),
(511, 'backend', 'Delete Confirmation'),
(512, 'backend', 'Are you sure you want to permanently delete the selected item?'),
(513, 'backend', 'Currency list'),
(514, 'backend', 'Default'),
(515, 'backend', 'All Currency'),
(516, 'backend', 'Add Currency'),
(517, 'backend', 'Set as Default'),
(518, 'backend', 'Currency'),
(519, 'backend', 'Position'),
(520, 'backend', 'Rate'),
(521, 'backend', '+ Exchange fee'),
(522, 'backend', 'Decimals'),
(523, 'backend', 'Decimal Separator'),
(524, 'backend', 'Thousand Separator'),
(525, 'backend', 'Please select'),
(526, 'backend', 'Left $11'),
(527, 'backend', 'Right 11$'),
(528, 'backend', 'Left with space $ 11'),
(529, 'backend', 'Right with space 11 $'),
(530, 'backend', 'Update Currency'),
(531, 'backend', 'Country List'),
(532, 'backend', 'Add Country'),
(533, 'backend', 'Phone Code'),
(534, 'backend', 'Code'),
(535, 'backend', 'Update Country'),
(536, 'backend', 'State List'),
(537, 'backend', 'City List'),
(538, 'backend', 'District/Area List'),
(539, 'backend', 'Sequence'),
(540, 'backend', 'Add State'),
(542, 'backend', 'State Name'),
(543, 'backend', 'All State'),
(544, 'backend', 'City'),
(545, 'backend', 'State'),
(546, 'backend', 'City Name'),
(547, 'backend', 'Postal Code/Zip code'),
(548, 'backend', 'Select State'),
(549, 'backend', 'Add City'),
(550, 'backend', 'All City'),
(551, 'backend', 'Area List'),
(552, 'backend', 'Area Name'),
(553, 'backend', 'Select City'),
(554, 'backend', 'Add Area'),
(555, 'backend', 'All Area'),
(556, 'backend', 'Zones list'),
(557, 'backend', 'Create Zones'),
(558, 'backend', 'Featured locations'),
(559, 'backend', 'All featured locations'),
(562, 'backend', 'Location name'),
(563, 'backend', 'Longitude'),
(564, 'backend', 'Featured name'),
(565, 'backend', 'Update featured locations'),
(566, 'backend', 'New Restaurant'),
(567, 'backend', 'Popular'),
(568, 'backend', 'Best Seller'),
(569, 'backend', 'Recommended'),
(570, 'backend', 'Pages list'),
(571, 'backend', 'All Pages'),
(572, 'backend', 'Add Page'),
(573, 'backend', 'Short Description'),
(574, 'backend', 'SEO'),
(575, 'backend', 'Meta Title'),
(576, 'backend', 'Meta description'),
(577, 'backend', 'Keywords'),
(578, 'backend', 'Update Page'),
(579, 'backend', 'Languages list'),
(580, 'backend', 'All Language'),
(581, 'backend', 'Add Language'),
(582, 'backend', 'Locale'),
(583, 'backend', 'Select Flag'),
(584, 'backend', 'RTL'),
(585, 'backend', 'Translation'),
(586, 'backend', 'Translation Key'),
(587, 'backend', 'Status Management list'),
(588, 'backend', 'Group'),
(589, 'backend', 'Group Name'),
(590, 'backend', 'Status Key'),
(591, 'backend', 'All Status'),
(592, 'backend', 'Add Status'),
(593, 'backend', 'Date Created. {{date_created}}'),
(594, 'backend', 'Services list'),
(595, 'backend', 'Service fee'),
(596, 'backend', 'All Services'),
(597, 'backend', 'Add Services'),
(598, 'backend', 'Update Services'),
(599, 'backend', 'All Type'),
(600, 'backend', 'Update Merchant Type'),
(601, 'backend', 'Commission Type'),
(602, 'backend', 'Commission based on Subtotal / Total'),
(603, 'backend', 'Commission'),
(604, 'backend', 'Add Merchant Type'),
(605, 'backend', 'Rejection Reason List'),
(606, 'backend', 'Reason'),
(607, 'backend', 'Add Rejection'),
(608, 'backend', 'Update Rejection'),
(609, 'backend', 'Pause Reason List'),
(610, 'backend', 'Add Pause reason'),
(611, 'backend', 'Update Pause reason'),
(612, 'backend', 'Status action List'),
(614, 'backend', 'Key must not have spaces'),
(616, 'backend', 'Update action status'),
(617, 'backend', 'Add action status'),
(618, 'backend', 'Coupon list'),
(619, 'backend', '#Used'),
(620, 'backend', 'All Coupon'),
(621, 'backend', 'Add Coupon'),
(622, 'backend', 'Coupon Type'),
(623, 'backend', 'Days Available'),
(625, 'backend', 'Min Order'),
(626, 'backend', 'Applicable to merchant'),
(627, 'backend', 'Expiration'),
(628, 'backend', 'Coupon Options'),
(629, 'backend', 'Coupon name'),
(630, 'backend', 'fixed amount'),
(631, 'backend', 'percentage'),
(632, 'backend', 'Unlimited for all user'),
(633, 'backend', 'Use only once'),
(634, 'backend', 'Once per user'),
(635, 'backend', 'Once for new user first order'),
(636, 'backend', 'Custom limit per user'),
(637, 'backend', 'Only to selected customer'),
(638, 'backend', 'Define max number of use'),
(639, 'backend', 'Select Customer'),
(640, 'backend', 'Email Provider'),
(641, 'backend', 'All Provider'),
(642, 'backend', 'Add Provider'),
(643, 'backend', 'Provider ID'),
(644, 'backend', 'Provider name'),
(645, 'backend', 'Sender email'),
(646, 'backend', 'Sender name'),
(648, 'backend', 'Update Provider'),
(649, 'backend', 'API KEY'),
(650, 'backend', 'Create your account [url]'),
(651, 'backend', 'SECRET KEY'),
(652, 'backend', 'SMTP host'),
(653, 'backend', 'SMTP port'),
(654, 'backend', 'Password'),
(655, 'backend', 'Secure Connection'),
(656, 'backend', 'TLS'),
(657, 'backend', 'SSL'),
(658, 'backend', 'normal'),
(659, 'backend', 'flash'),
(660, 'backend', 'unicode'),
(661, 'backend', 'ndnd'),
(662, 'backend', 'dnd'),
(663, 'backend', 'premium'),
(664, 'backend', 'lowcost'),
(665, 'backend', 'SMS'),
(666, 'backend', 'Push'),
(667, 'backend', 'All Templates'),
(668, 'backend', 'Add Template'),
(669, 'backend', 'Template name'),
(670, 'backend', 'Enabled Email'),
(671, 'backend', 'Enabled SMS'),
(672, 'backend', 'Enabled Push'),
(673, 'backend', 'Email Templates'),
(674, 'backend', 'SMS Templates'),
(675, 'backend', 'Push Templates'),
(676, 'backend', '{{lang}} Template'),
(677, 'backend', 'Enter {{lang}} Type here'),
(678, 'backend', 'Enter {{lang}} Subject here'),
(679, 'backend', 'Enter {{lang}} Title here'),
(680, 'backend', 'Enter {{lang}} Content here'),
(681, 'backend', 'Update Template'),
(682, 'backend', 'Email Logs'),
(684, 'backend', 'View SMS'),
(685, 'backend', 'Push logs'),
(686, 'backend', 'Platform'),
(687, 'backend', 'Message'),
(688, 'backend', 'Channel/Device'),
(689, 'backend', 'View Push'),
(690, 'backend', 'Customer list'),
(691, 'backend', 'All Customer'),
(692, 'backend', 'Add Customer'),
(694, 'backend', 'Update Customer'),
(695, 'backend', 'Basic Details'),
(696, 'backend', 'Order history'),
(697, 'backend', 'Address list'),
(700, 'backend', 'Places ID'),
(701, 'backend', 'Aparment, suite or floor'),
(702, 'backend', 'Add delivery instructions'),
(703, 'backend', 'Address label'),
(704, 'backend', 'Home'),
(705, 'backend', 'Work'),
(706, 'backend', 'School'),
(707, 'backend', 'Friend house'),
(708, 'backend', 'Other'),
(709, 'backend', 'Leave it at my door'),
(710, 'backend', 'Hand it to me'),
(711, 'backend', 'Meet outside'),
(712, 'backend', 'Order list'),
(713, 'backend', 'Phone'),
(714, 'backend', 'All Review'),
(715, 'backend', 'Update Review'),
(716, 'backend', 'Customer reviews'),
(718, 'backend', 'Customer. [customer_name]'),
(719, 'backend', 'Rating. [rating]'),
(720, 'backend', 'Date. [date_created]'),
(721, 'backend', 'Real time applications'),
(722, 'backend', 'Select Realtime Provider'),
(723, 'backend', 'Pusher App Id'),
(724, 'backend', 'Pusher Key'),
(725, 'backend', 'Pusher Secret'),
(726, 'backend', 'Pusher Cluster'),
(727, 'backend', 'Private API Key'),
(728, 'backend', 'Cluster ID'),
(730, 'backend', 'API secret'),
(731, 'backend', 'WebSocket API endpoint'),
(732, 'backend', 'signup and get your credentials in'),
(733, 'backend', 'Web push notifications'),
(734, 'backend', 'Select Web Push Provider'),
(735, 'backend', 'Instance ID'),
(736, 'backend', 'Primary key'),
(737, 'backend', 'SMS Provider List'),
(739, 'backend', 'Sender ID'),
(740, 'backend', 'API username'),
(741, 'backend', 'API password'),
(743, 'backend', 'Account SID'),
(744, 'backend', 'AUTH Token'),
(745, 'backend', 'Secret'),
(746, 'backend', 'Provider'),
(747, 'backend', 'SMS Logs'),
(748, 'backend', 'Total Registered'),
(749, 'backend', 'Commission Total'),
(750, 'backend', 'Membership Total'),
(751, 'backend', 'Total Active'),
(752, 'backend', 'Total Inactive'),
(753, 'backend', 'Membership Payment'),
(754, 'backend', 'Payment type'),
(755, 'backend', 'Merchant Sales Report'),
(756, 'backend', 'Order earnings report'),
(757, 'backend', 'Count'),
(758, 'backend', 'Admin earned'),
(759, 'backend', 'Merchant earned'),
(760, 'backend', 'Total sell'),
(762, 'backend', 'Subtotal'),
(764, 'backend', 'Admin commission'),
(765, 'backend', 'Refund Report'),
(766, 'backend', 'All Payment status'),
(767, 'backend', 'Payment reference# {{payment_reference}}'),
(768, 'backend', 'Refund on {{date}}'),
(769, 'backend', 'Full refund'),
(770, 'backend', 'Partial refund'),
(771, 'backend', 'All User'),
(772, 'backend', 'Role'),
(773, 'backend', 'Confirm New Password'),
(774, 'backend', 'Edit User'),
(775, 'backend', 'All Roles'),
(776, 'backend', 'Access'),
(777, 'backend', 'Add Role'),
(778, 'backend', 'Themes'),
(779, 'backend', 'Active theme'),
(780, 'backend', 'Customize'),
(781, 'backend', 'Organize your menu'),
(782, 'backend', 'Menu'),
(783, 'backend', 'Setting'),
(784, 'backend', 'Media Library'),
(785, 'backend', 'Media List'),
(786, 'backend', 'Delete File'),
(787, 'backend', 'Notification'),
(788, 'backend', 'Clear all'),
(789, 'backend', 'View all'),
(790, 'backend', 'Profile'),
(791, 'backend', 'Logout'),
(792, 'backend', 'Change Password'),
(793, 'backend', 'Web Notifications'),
(794, 'backend', 'Old Password'),
(795, 'backend', 'Notifications Settings'),
(797, 'backend', 'Select notification type'),
(798, 'backend', 'Order updates'),
(799, 'backend', 'Customer new signup'),
(800, 'backend', 'Merchant new signup'),
(801, 'backend', 'Payout request'),
(802, 'backend', 'All notifications'),
(803, 'backend', 'Order #'),
(804, 'backend', 'Restaurant'),
(806, 'backend', 'Delivery information'),
(807, 'backend', 'Get direction'),
(809, 'backend', 'Delivery Date/Time'),
(810, 'backend', 'Include utensils'),
(815, 'backend', 'Summary'),
(816, 'backend', 'Print'),
(817, 'backend', 'Contact customer'),
(819, 'backend', 'Cancel order'),
(820, 'backend', 'Timeline'),
(821, 'backend', 'Download PDF (A4)'),
(822, 'backend', 'Yes'),
(823, 'backend', 'Okay'),
(824, 'backend', 'Customer Info'),
(825, 'backend', 'Action'),
(826, 'backend', 'Customer ID'),
(827, 'backend', 'Addresses'),
(828, 'backend', 'Unblock Custome'),
(830, 'backend', 'Customer information not found'),
(831, 'backend', 'Are you sure you want to continue'),
(832, 'backend', 'Refund this item'),
(833, 'backend', 'This automatically remove this item from your active orders.'),
(834, 'backend', 'Go back'),
(836, 'backend', 'Remove this item'),
(837, 'backend', 'This will remove this item from your active orders.'),
(840, 'backend', 'Item is Out of Stock'),
(841, 'backend', 'Order decrease'),
(842, 'backend', 'Order Increase'),
(843, 'backend', 'By accepting this order, we will refund the amount of {{amount}} to customer.'),
(844, 'backend', 'Total amount for this order has increase, Send invoice to customer or less from your account with total amount of {{amount}}.'),
(847, 'backend', 'Send invoice'),
(848, 'backend', 'Less on my account'),
(849, 'backend', 'This order has unpaid invoice, until its paid you cannot change the order status.'),
(851, 'backend', 'How much additional time you need?'),
(852, 'backend', 'We\'ll notify the customer about the delay.'),
(854, 'backend', 'Enter why you cannot make this order.'),
(855, 'backend', 'Reject order'),
(856, 'backend', 'Are you sure you want to continue?'),
(857, 'backend', 'Delivery fee'),
(858, 'backend', 'Sub total ([count] items)'),
(859, 'backend', 'Courier tip'),
(860, 'backend', 'Dashboard'),
(862, 'backend', 'List'),
(863, 'backend', 'Sponsored'),
(864, 'backend', 'Users'),
(866, 'backend', 'All order'),
(867, 'backend', 'Order settings'),
(869, 'backend', 'Add User'),
(870, 'backend', 'Delete User'),
(871, 'backend', 'Membership'),
(872, 'backend', 'Plans'),
(873, 'backend', 'Add Plan'),
(874, 'backend', 'Delete Plan'),
(875, 'backend', 'Attributes'),
(880, 'backend', 'Pages'),
(881, 'backend', 'Languages'),
(882, 'backend', 'Buyers'),
(883, 'backend', 'Customers'),
(885, 'backend', 'Create Role'),
(886, 'backend', 'Update Role'),
(887, 'backend', 'Delete Role'),
(889, 'backend', 'Manage Location'),
(891, 'backend', 'Providers'),
(892, 'backend', 'Logs'),
(893, 'backend', 'Reports'),
(896, 'backend', 'Merchant Sales'),
(897, 'backend', 'Status Management'),
(899, 'backend', 'Information'),
(903, 'backend', 'Size'),
(904, 'backend', 'Ingredients'),
(905, 'backend', 'Cooking Reference'),
(906, 'backend', 'Food'),
(907, 'backend', 'Category'),
(908, 'backend', 'Addon Category'),
(909, 'backend', 'Addon Items'),
(910, 'backend', 'Items'),
(911, 'backend', 'Delivery'),
(913, 'backend', 'Coupon'),
(914, 'backend', 'Offers'),
(915, 'backend', 'Images'),
(916, 'backend', 'Account'),
(920, 'backend', 'BroadCast'),
(925, 'backend', 'Sales Report'),
(926, 'backend', 'Sales Summary'),
(927, 'backend', 'Pickup'),
(928, 'backend', 'Dinein'),
(929, 'backend', 'Gallery'),
(933, 'backend', 'Store Hours'),
(934, 'backend', 'Tracking Time'),
(935, 'backend', 'Add Store Hours'),
(936, 'backend', 'Update Store Hours'),
(937, 'backend', 'Delete Store Hours'),
(938, 'backend', 'View Order'),
(939, 'backend', 'Delete Order'),
(940, 'backend', 'Create Time Management'),
(941, 'backend', 'Update Time Management'),
(942, 'backend', 'Delete Time Management'),
(943, 'backend', 'Inventory Management'),
(944, 'backend', 'Suppliers'),
(945, 'backend', 'Time Slot'),
(946, 'backend', 'Create Time Slot'),
(947, 'backend', 'Update Time Slot'),
(948, 'backend', 'Delete Time Slot'),
(949, 'backend', 'Create Size'),
(950, 'backend', 'Update Size'),
(951, 'backend', 'Delete Size'),
(952, 'backend', 'Ingredients create'),
(953, 'backend', 'Payment gateway'),
(954, 'backend', 'All Payment'),
(956, 'backend', 'All payments'),
(957, 'backend', 'Archive'),
(959, 'backend', 'Rejection Reason'),
(962, 'backend', 'Transactions'),
(965, 'backend', 'Merchant withdrawals'),
(967, 'backend', 'Third Party App'),
(968, 'backend', 'Real time application'),
(969, 'backend', 'Web push notification'),
(971, 'backend', 'Scheduled'),
(973, 'backend', 'Zones'),
(974, 'backend', 'Pause order reason'),
(976, 'backend', 'Order earnings'),
(978, 'backend', 'POS'),
(979, 'backend', 'POS create order'),
(983, 'backend', 'Login &amp; Signup'),
(989, 'backend', 'Upload CSV'),
(990, 'backend', 'Add sponsored'),
(991, 'backend', 'Update sponsored'),
(993, 'backend', 'Print PDF'),
(996, 'backend', 'Update Gateway'),
(997, 'backend', 'Withdrawals Template'),
(998, 'backend', 'Cuisine create'),
(999, 'backend', 'Cuisine update'),
(1000, 'backend', 'Dishes create'),
(1001, 'backend', 'Dishes update'),
(1002, 'backend', 'Dishes delete'),
(1003, 'backend', 'Cuisine delete'),
(1004, 'backend', 'Tags create'),
(1005, 'backend', 'Tags update'),
(1006, 'backend', 'Tags delete'),
(1007, 'backend', 'Status create'),
(1008, 'backend', 'Status update'),
(1009, 'backend', 'Status delete'),
(1011, 'backend', 'Status actions create'),
(1012, 'backend', 'Status actions update'),
(1013, 'backend', 'Currency create'),
(1014, 'backend', 'Currency update'),
(1015, 'backend', 'Currency delete'),
(1016, 'backend', 'Country create'),
(1017, 'backend', 'Country update'),
(1020, 'backend', 'State create'),
(1021, 'backend', 'State update'),
(1022, 'backend', 'State delete'),
(1024, 'backend', 'City create'),
(1025, 'backend', 'City delete'),
(1027, 'backend', 'Area create'),
(1028, 'backend', 'Area update'),
(1029, 'backend', 'Area delete'),
(1030, 'backend', 'Zone create'),
(1031, 'backend', 'Zone update'),
(1032, 'backend', 'Zone delete'),
(1033, 'backend', 'Featured create'),
(1034, 'backend', 'Featured update'),
(1035, 'backend', 'Featured delete'),
(1036, 'backend', 'Pages create'),
(1037, 'backend', 'Pages update'),
(1038, 'backend', 'Pages delete'),
(1039, 'backend', 'Language create'),
(1040, 'backend', 'Language update'),
(1041, 'backend', 'Language delete'),
(1042, 'backend', 'Status Management create'),
(1043, 'backend', 'Status Management update'),
(1044, 'backend', 'Status Management delete'),
(1045, 'backend', 'Order type create'),
(1046, 'backend', 'Order type update'),
(1047, 'backend', 'Order type delete'),
(1048, 'backend', 'Merchant type create'),
(1049, 'backend', 'Merchant type update'),
(1050, 'backend', 'Merchant type delete'),
(1051, 'backend', 'Rejection reason create'),
(1052, 'backend', 'Rejection reason update'),
(1054, 'backend', 'Rejection reason delete'),
(1055, 'backend', 'Pause reason create'),
(1056, 'backend', 'Pause reason update'),
(1057, 'backend', 'Pause reason delete'),
(1058, 'backend', 'Status action create'),
(1059, 'backend', 'Status reason update'),
(1060, 'backend', 'Status reason delete'),
(1061, 'backend', 'Coupon create'),
(1062, 'backend', 'Coupon update'),
(1063, 'backend', 'Coupon delete'),
(1064, 'backend', 'Email Provider create'),
(1065, 'backend', 'Email Provider update'),
(1066, 'backend', 'Email Provider delete'),
(1067, 'backend', 'Templates create'),
(1068, 'backend', 'Templates update'),
(1069, 'backend', 'Templates delete'),
(1070, 'backend', 'Email Logs delete'),
(1071, 'backend', 'Push logs delete'),
(1072, 'backend', 'Customer create'),
(1073, 'backend', 'Customer update'),
(1074, 'backend', 'Customer delete'),
(1075, 'backend', 'Customer address'),
(1076, 'backend', 'Customer order history'),
(1077, 'backend', 'Address create'),
(1078, 'backend', 'Address delete'),
(1079, 'backend', 'Address update'),
(1080, 'backend', 'Review update'),
(1081, 'backend', 'Review delete'),
(1082, 'backend', 'SMS provider create'),
(1083, 'backend', 'SMS provider update'),
(1084, 'backend', 'SMS provider delete'),
(1085, 'backend', 'SMS delete logs'),
(1086, 'backend', 'Update User'),
(1088, 'backend', 'Taxes'),
(1089, 'backend', 'Social Settings'),
(1090, 'backend', 'Notification Settings'),
(1091, 'backend', 'Order limit create'),
(1092, 'backend', 'Order view PDF'),
(1093, 'backend', 'Ingredients update'),
(1094, 'backend', 'Cooking create'),
(1095, 'backend', 'Ingredients delete'),
(1096, 'backend', 'Cooking update'),
(1097, 'backend', 'Cooking delete'),
(1098, 'backend', 'Category create'),
(1099, 'backend', 'Category update'),
(1100, 'backend', 'Category delete'),
(1101, 'backend', 'Category availability'),
(1102, 'backend', 'Addon Category create'),
(1103, 'backend', 'Addon Category update'),
(1104, 'backend', 'Addon Category delete'),
(1105, 'backend', 'Addon Item create'),
(1106, 'backend', 'Addon Item update'),
(1107, 'backend', 'Addon Item delete'),
(1108, 'backend', 'Item create'),
(1109, 'backend', 'Item update'),
(1110, 'backend', 'Item delete'),
(1111, 'backend', 'Item price'),
(1112, 'backend', 'Item price delete'),
(1113, 'backend', 'Item price update'),
(1114, 'backend', 'Item addon'),
(1115, 'backend', 'Item addon create'),
(1116, 'backend', 'Item addon update'),
(1117, 'backend', 'Item addon delete'),
(1118, 'backend', 'Item attributes'),
(1119, 'backend', 'Item availability'),
(1120, 'backend', 'Item inventory'),
(1121, 'backend', 'Item promo'),
(1122, 'backend', 'Item promo create'),
(1123, 'backend', 'Item promo update'),
(1124, 'backend', 'Item promo delete'),
(1125, 'backend', 'Item gallery'),
(1126, 'backend', 'Item SEO'),
(1127, 'backend', 'Dynamic Rates'),
(1128, 'backend', 'Fixed Charge'),
(1129, 'backend', 'Pickup instructions'),
(1130, 'backend', 'Dinein instructions'),
(1132, 'backend', 'Offer create'),
(1133, 'backend', 'Offer update'),
(1134, 'backend', 'Offer delete'),
(1135, 'backend', 'Review reply'),
(1136, 'backend', 'User create'),
(1137, 'backend', 'User update'),
(1138, 'backend', 'User delete'),
(1139, 'backend', 'Role create'),
(1140, 'backend', 'Role update'),
(1141, 'backend', 'Role delete'),
(1142, 'backend', 'Supplier create'),
(1143, 'backend', 'Supplier update'),
(1144, 'backend', 'Supplier delete'),
(1145, 'backend', 'Website'),
(1146, 'backend', 'Theme'),
(1147, 'backend', 'Company'),
(1148, 'backend', 'Service'),
(1149, 'backend', 'Find a store'),
(1151, 'backend', 'Contact Us'),
(1152, 'backend', 'Categories'),
(1153, 'backend', 'Grocery'),
(1154, 'backend', 'Parcel Delivery'),
(1155, 'backend', 'Fast Food'),
(1157, 'backend', 'Privacy policy'),
(1158, 'backend', 'Dishes'),
(1159, 'backend', 'No notifications yet'),
(1160, 'backend', 'When you get notifications, they\'ll show up here'),
(1161, 'backend', 'active'),
(1162, 'backend', 'Total Cancel'),
(1163, 'backend', 'Sales this week'),
(1164, 'backend', 'Earning this week'),
(1165, 'backend', 'Your balance'),
(1166, 'backend', 'Today sales'),
(1167, 'backend', 'Today refund'),
(1168, 'backend', 'days ago'),
(1169, 'backend', 'Accepting Orders'),
(1170, 'backend', 'Update Information'),
(1171, 'backend', 'Basic Settings'),
(1172, 'backend', 'Orders Settings'),
(1173, 'backend', 'This will appear in your receipt'),
(1174, 'backend', 'Two Flavor Options'),
(1175, 'backend', 'Close Store'),
(1176, 'backend', 'Enabled Voucher'),
(1177, 'backend', 'Enabled Tips'),
(1178, 'backend', 'Default Tip'),
(1179, 'backend', 'Please select...'),
(1180, 'backend', 'Website address'),
(1181, 'backend', 'Tax number'),
(1182, 'backend', 'All Store Hours'),
(1184, 'backend', 'Open'),
(1185, 'backend', 'From'),
(1187, 'backend', 'Custom Message'),
(1188, 'backend', 'Tax enabled'),
(1189, 'backend', 'Tax on service fee'),
(1190, 'backend', 'Tax on delivery fee'),
(1191, 'backend', 'Tax on packaging fee'),
(1192, 'backend', 'Tax Type'),
(1193, 'backend', 'Standard'),
(1194, 'backend', 'Multiple tax'),
(1195, 'backend', 'Tax not in prices (prices does not include tax)'),
(1197, 'backend', 'Add new tax'),
(1198, 'backend', 'Tax name'),
(1199, 'backend', 'Rate %'),
(1200, 'backend', 'Default tax'),
(1201, 'backend', 'Facebook Page'),
(1202, 'backend', 'Twitter Page'),
(1203, 'backend', 'Google Page'),
(1204, 'backend', 'Merchant Mobile Alert'),
(1205, 'backend', 'Define how many minutes that order set to critical order and needs attentions.'),
(1206, 'backend', 'Critical minutes'),
(1207, 'backend', 'Define how many minutes that order will auto rejected.'),
(1208, 'backend', 'Reject order minutes'),
(1210, 'backend', 'Days/Time'),
(1211, 'backend', 'All Time'),
(1212, 'backend', 'Add Time Management'),
(1213, 'backend', 'Transaction Type'),
(1215, 'backend', 'Start Time'),
(1216, 'backend', 'End Time'),
(1217, 'backend', 'Number Order Allowed'),
(1219, 'backend', 'Status that will count the existing order, if empty will use all status.'),
(1220, 'backend', 'Orders as of today {{date}}'),
(1221, 'backend', 'How to manage orders'),
(1222, 'backend', 'Filter by order number or customer name'),
(1226, 'backend', 'Sort'),
(1227, 'backend', 'Order ID - Ascending'),
(1228, 'backend', 'Order ID - Descending'),
(1229, 'backend', 'Delivery Time - Ascending'),
(1230, 'backend', 'Delivery Time - Descending'),
(1231, 'backend', 'no results\''),
(1232, 'backend', 'Order Details will show here'),
(1233, 'backend', 'Not accepting orders'),
(1234, 'backend', 'Store pause for'),
(1235, 'backend', 'Store Pause'),
(1236, 'backend', 'Would you like to resume accepting orders?'),
(1237, 'backend', 'Pause New Orders'),
(1238, 'backend', 'How long you would like to pause new orders?'),
(1241, 'backend', 'Reason for pausing'),
(1242, 'backend', '{{mins}} min(s)'),
(1243, 'backend', '{{total}} results'),
(1244, 'backend', 'Discount'),
(1245, 'backend', 'Reset'),
(1246, 'backend', 'Proceed to pay'),
(1247, 'backend', 'Clear all items'),
(1248, 'backend', 'Have a promo code?'),
(1249, 'backend', 'Add promo code'),
(1250, 'backend', 'Apply'),
(1251, 'backend', 'Create Payment'),
(1252, 'backend', 'Total Due'),
(1253, 'backend', 'are you sure?'),
(1254, 'backend', 'Walk-in Customer'),
(1255, 'backend', 'Optional'),
(1256, 'backend', 'Special Instructions'),
(1257, 'backend', 'Add a note (extra cheese, no onions, etc.)'),
(1258, 'backend', 'If sold out'),
(1259, 'backend', 'Add to order'),
(1260, 'backend', 'Choose up to'),
(1261, 'backend', 'Select flavor'),
(1262, 'backend', 'Select 1'),
(1263, 'backend', 'POS Orders'),
(1264, 'backend', 'Size List'),
(1265, 'backend', 'Ingredients List'),
(1266, 'backend', 'All Size'),
(1267, 'backend', 'Add Size'),
(1268, 'backend', 'Size Name'),
(1269, 'backend', 'All Ingredients'),
(1270, 'backend', 'Add Ingredients'),
(1271, 'backend', 'Ingredients Name'),
(1272, 'backend', 'Update Ingredients'),
(1273, 'backend', 'Cooking Reference List'),
(1274, 'backend', 'All Cooking Reference'),
(1275, 'backend', 'Add Cooking Reference'),
(1276, 'backend', 'Update Cooking Reference'),
(1277, 'backend', 'Category List'),
(1278, 'backend', 'All Category'),
(1279, 'backend', 'Add Category'),
(1280, 'backend', 'Dish'),
(1281, 'backend', 'Update Category'),
(1282, 'backend', 'Availability'),
(1283, 'backend', 'Available at specified times'),
(1284, 'backend', 'Addon Category List'),
(1285, 'backend', 'All Addon Category'),
(1286, 'backend', 'Add Addon Category'),
(1287, 'backend', 'Update Addon Category'),
(1288, 'backend', 'monday'),
(1289, 'backend', 'tuesday'),
(1290, 'backend', 'wednesday'),
(1291, 'backend', 'thursday'),
(1292, 'backend', 'friday'),
(1293, 'backend', 'saturday'),
(1294, 'backend', 'sunday'),
(1295, 'backend', 'Addon Item List'),
(1296, 'backend', 'All Addon Item'),
(1297, 'backend', 'Add Addon Item'),
(1298, 'backend', 'AddOn Item'),
(1300, 'backend', 'Update Addon Item'),
(1301, 'backend', 'Item List'),
(1302, 'backend', 'All Item'),
(1303, 'backend', 'Add Item'),
(1304, 'backend', 'Long Description'),
(1306, 'backend', 'Select Unit'),
(1307, 'backend', 'Item Name'),
(1308, 'backend', 'Available'),
(1309, 'backend', 'Update Item'),
(1310, 'backend', 'Addon'),
(1311, 'backend', 'Inventory'),
(1312, 'backend', 'Sales Promotion'),
(1314, 'backend', 'Add Price'),
(1315, 'backend', 'Cost Price'),
(1316, 'backend', 'Discount Start'),
(1317, 'backend', 'Discount End'),
(1318, 'backend', 'Discount Type'),
(1319, 'backend', 'SKU'),
(1320, 'backend', 'Fixed'),
(1322, 'backend', 'Select Type'),
(1323, 'backend', 'Select Value'),
(1324, 'backend', 'Required'),
(1325, 'backend', 'No'),
(1326, 'backend', 'multiple'),
(1327, 'backend', 'All Addon'),
(1330, 'backend', 'Pre-selected'),
(1331, 'backend', 'Select Item Price'),
(1332, 'backend', 'Can Select Only One'),
(1333, 'backend', 'Can Select Multiple'),
(1334, 'backend', 'Two Flavors'),
(1335, 'backend', 'Custom'),
(1336, 'backend', 'Enabled Points'),
(1337, 'backend', 'Enabled Packaging Incrementals'),
(1338, 'backend', 'Cooking Reference Mandatory'),
(1339, 'backend', 'Points earned'),
(1340, 'backend', 'Packaging fee'),
(1341, 'backend', 'Delivery options'),
(1342, 'backend', 'Select vehicle type for this item can be used for delivery'),
(1343, 'backend', 'Not for sale'),
(1344, 'backend', 'Track Stock'),
(1345, 'backend', 'Supplier'),
(1346, 'backend', 'Select Supplier'),
(1347, 'backend', 'Add Item Promo'),
(1348, 'backend', 'Buy (qty)'),
(1349, 'backend', 'Get (qty'),
(1350, 'backend', 'Select Item'),
(1351, 'backend', 'Buy (qty) to get the (qty) item free'),
(1352, 'backend', 'Buy (qty) and get 1 at (percen)% off'),
(1353, 'backend', 'Promo Type'),
(1355, 'backend', 'Gallery Image'),
(1356, 'backend', 'Enabled Opt in for no contact delivery'),
(1357, 'backend', 'Free Delivery On First Order'),
(1358, 'backend', 'Delivery Charge Type'),
(1359, 'backend', 'Standard delivery fee'),
(1360, 'backend', 'Delivery Settings'),
(1361, 'backend', 'Delivery estimation'),
(1362, 'backend', 'in minutes example 10-20mins'),
(1363, 'backend', 'Minimum Order'),
(1364, 'backend', 'Maximum Order'),
(1365, 'backend', 'Pickup estimation'),
(1366, 'backend', 'Instructions'),
(1367, 'backend', 'Customer Pickup Instructions'),
(1368, 'backend', 'Describe how a customer will pickup their order when they arrive to your store. Instructions will be displayed on a customer\'s order status page.'),
(1369, 'backend', 'Dinein estimation'),
(1370, 'backend', 'Customer Dinein Instructions'),
(1371, 'backend', 'Describe how customer will dinein in your restaurant. Instructions will be displayed on a customer\'s order status page'),
(1372, 'backend', 'Page not found'),
(1373, 'backend', 'This page is not available in your account.'),
(1374, 'backend', 'Update Coupon'),
(1375, 'backend', 'Offers list'),
(1376, 'backend', 'Valid'),
(1377, 'backend', 'All Offers'),
(1378, 'backend', 'Add Offers'),
(1379, 'backend', 'Offer Percentage'),
(1380, 'backend', 'Orders Over'),
(1381, 'backend', 'Valid From'),
(1382, 'backend', 'Valid To'),
(1383, 'backend', 'Applicable to'),
(1384, 'backend', 'Gallery list'),
(1385, 'backend', 'Your sales, cash in and referral earnings'),
(1386, 'backend', 'Available Balance'),
(1388, 'backend', 'Request Payout'),
(1389, 'backend', 'Add to your balance'),
(1390, 'backend', 'Minimum amount'),
(1391, 'backend', 'how much do you want to add to your account?'),
(1392, 'backend', 'Enter top up amount'),
(1394, 'backend', 'Continue'),
(1395, 'backend', 'Minimum amount {{amonut}}'),
(1396, 'backend', 'Adjustment commission order #{{order_id}}'),
(1397, 'backend', 'Refund commission order #{{order_id}}'),
(1398, 'backend', 'Commission on order #{{order_id}}'),
(1399, 'backend', 'Sales on order #{{order_id}}'),
(1400, 'backend', 'Payment to order #{{order_id}}'),
(1401, 'backend', 'Payout to {{account}}'),
(1402, 'backend', 'Payout History'),
(1404, 'backend', 'Payout account'),
(1406, 'backend', 'Set Account'),
(1407, 'backend', 'Date Processed'),
(1408, 'backend', 'Set your default payout account'),
(1410, 'backend', 'Individual'),
(1411, 'backend', 'Account information'),
(1412, 'backend', 'Bank Account Holders Name'),
(1413, 'backend', 'Reply'),
(1414, 'backend', 'Customer review'),
(1415, 'backend', 'Your Reply'),
(1416, 'backend', 'Comments ([number_comments])'),
(1417, 'backend', 'Date Created. [date_created]'),
(1418, 'backend', 'User List'),
(1419, 'backend', 'Sales Summary Report'),
(1420, 'backend', 'Average price'),
(1421, 'backend', 'Total qty sold'),
(1423, 'backend', 'Sales chart'),
(1424, 'backend', 'All Items'),
(1425, 'backend', 'Supplier List'),
(1426, 'backend', 'Contacts'),
(1427, 'backend', 'Add Supplier'),
(1428, 'backend', 'Phone Number'),
(1429, 'backend', 'Address 1'),
(1430, 'backend', 'Address 2'),
(1431, 'backend', 'Postal/zip code'),
(1432, 'backend', 'Region'),
(1433, 'backend', 'Notes'),
(1434, 'backend', 'Supplier Name'),
(1435, 'backend', 'Archive Order List'),
(1436, 'backend', 'Order has the same status'),
(1437, 'backend', 'Status Updated'),
(1438, 'backend', 'Amount to refund cannot be less than 0'),
(1439, 'backend', 'You don\'t have enough balance in your account. please load your account to process this order.'),
(1440, 'backend', 'Amount to less cannot be less than 0'),
(1441, 'backend', 'Less on account'),
(1445, 'backend', 'Status not found'),
(1447, 'backend', 'Order is cancelled'),
(1448, 'backend', 'Order is delayed by [mins]min(s)'),
(1449, 'backend', 'Customer is notified about the delayed.'),
(1450, 'backend', 'Item row not found'),
(1451, 'backend', 'Succesful'),
(1452, 'backend', 'Additional charge must be greater than zero'),
(1453, 'backend', 'Item added to order'),
(1454, 'backend', 'Customer name is requied'),
(1455, 'backend', 'Customer contact number is requied'),
(1456, 'backend', 'Delivery address is requied'),
(1457, 'backend', 'Delivery coordinates is requied'),
(1459, 'backend', 'Order Information updated'),
(1460, 'backend', 'Client information not found'),
(1461, 'backend', 'Invalid email address'),
(1462, 'backend', 'Account number is required'),
(1463, 'backend', 'Account name is required'),
(1464, 'backend', 'Bank name is required'),
(1465, 'backend', 'Swift code is required'),
(1466, 'backend', 'Country is required'),
(1467, 'backend', 'Payout account saved'),
(1468, 'backend', 'Payout request successfully logged'),
(1470, 'backend', 'Setting saved'),
(1471, 'backend', 'Tax not found'),
(1473, 'backend', 'No item solds yet'),
(1474, 'backend', 'You don\'t have customer yet'),
(1475, 'backend', 'You don\'t have sales yet'),
(1477, 'backend', 'Voucher code not found'),
(1478, 'backend', 'Customer succesfully created'),
(1479, 'backend', 'Order created by {{merchant_user}}'),
(1482, 'backend', 'Record not found'),
(1483, 'backend', 'Merchant not found'),
(1484, 'backend', 'Payout status set to paid'),
(1485, 'backend', 'Transaction not found'),
(1486, 'backend', 'Payout cancelled'),
(1487, 'backend', 'Payout will process in a minute or two'),
(1488, 'backend', 'device updated'),
(1489, 'backend', 'user device not found'),
(1494, 'backend', 'No recent payout request'),
(1495, 'backend', 'Sort menu saved'),
(1496, 'backend', 'Invalid ID'),
(1497, 'backend', 'View'),
(1500, 'backend', 'History'),
(1501, 'backend', 'Manage Plan'),
(1502, 'backend', 'Avatar'),
(1503, 'backend', 'Order#{{order_id}} from {{customer_name}}'),
(1504, 'backend', 'Your order #{{order_id}} is accepted by {{restaurant_name}}'),
(1505, 'backend', 'Go with merchant recommendation'),
(1506, 'backend', 'Contact me'),
(1507, 'backend', 'Cancel the entire order'),
(1508, 'backend', 'Order Details'),
(1509, 'backend', 'Merchant - information'),
(1510, 'backend', 'Merchant - login'),
(1514, 'backend', 'Merchant - Payment history'),
(1517, 'backend', 'View Order #[order_id]'),
(1519, 'backend', 'Cancel Orders'),
(1524, 'backend', 'Update Offers'),
(1530, 'backend', 'Printing Options'),
(1534, 'backend', 'Security'),
(1535, 'backend', 'Menu Options'),
(1538, 'backend', 'Booking'),
(1541, 'backend', 'Update Language'),
(1545, 'backend', 'Add featured locations'),
(1546, 'backend', 'Succesfully updated'),
(1547, 'backend', 'This field is required'),
(1549, 'backend', 'Initial Password must be repeated exactly.'),
(1550, 'backend', 'Email address already exist.'),
(1551, 'backend', '{value}\" has already been taken.'),
(1552, 'backend', '{value}\" has already been added.'),
(1553, 'backend', '{attribute} is not a valid URL.'),
(1554, 'backend', 'This field must be a number.'),
(1555, 'backend', '{attribute} is too small (minimum is {min}).'),
(1556, 'backend', '{attribute} is too big (maximum is {max}).'),
(1557, 'backend', 'this field must be time example hh:mm.'),
(1560, 'backend', 'Succesfully created'),
(1561, 'backend', 'Settings saved');
INSERT INTO `st_sourcemessage` (`id`, `category`, `message`) VALUES
(1562, 'backend', 'Failed cannot update'),
(1563, 'backend', 'Failed cannot save'),
(1564, 'backend', 'The file was larger than 10MB. Please upload a smaller file.'),
(1565, 'backend', 'The file \"{file}\" cannot be uploaded. Only files with these extensions are allowed: {extensions}.'),
(1566, 'backend', 'This field cannot be blank.'),
(1567, 'backend', 'New Password must be repeated exactly'),
(1568, 'backend', 'this field is too short (minimum is {min} characters).'),
(1569, 'backend', 'this field is too long (maximum is {max} characters).'),
(1570, 'backend', 'Record not found.'),
(1572, 'backend', 'Please correct the forms'),
(1573, 'backend', 'You are not authorized to perform this action'),
(1574, 'backend', 'This field is not a valid URL'),
(1575, 'backend', 'Front Translation'),
(1576, 'front', 'Let\'s find best food for you'),
(1577, 'front', 'Enter delivery address'),
(1578, 'front', 'Cuisine type'),
(1579, 'front', 'No Minimum Order'),
(1580, 'front', 'Order in for yourself or for the group, with no restrictions on order value'),
(1581, 'front', 'Live Order Tracking'),
(1582, 'front', 'Know where your order is at all times, from the restaurant to your doorstep'),
(1583, 'front', 'Lightning-Fast Delivery'),
(1584, 'front', 'Experience karenderia superfast delivery for food delivered fresh & on time'),
(1585, 'front', 'Best promotions in your area'),
(1586, 'front', 'Rising stars restaurants'),
(1587, 'front', 'Fastest delivery for you!'),
(1588, 'front', 'Party night?'),
(1589, 'front', 'Popular nearby'),
(1590, 'front', 'Up to'),
(1591, 'front', 'Try something'),
(1592, 'front', 'Best quick'),
(1593, 'front', 'Maybe'),
(1594, 'front', 'New'),
(1595, 'front', 'Lunch'),
(1596, 'front', 'Snacks?'),
(1597, 'front', 'Check'),
(1598, 'front', 'New restaurant'),
(1599, 'front', 'Are you a restaurant owner?'),
(1600, 'front', 'Join us and reach new customers'),
(1601, 'front', 'Just a few steps to join our family'),
(1602, 'front', 'Join'),
(1603, 'front', 'Best restaurants'),
(1604, 'front', 'In your pocket'),
(1606, 'front', 'Download'),
(1607, 'front', 'K mobile app'),
(1608, 'front', 'Order from your favorite restaurants & track on the go, with the all-new K app.'),
(1609, 'front', 'Website'),
(1610, 'front', 'Cart'),
(1611, 'front', 'Sign in'),
(1612, 'front', 'You don\'t have any orders here!'),
(1613, 'front', 'let\'s change that!'),
(1614, 'front', 'Login'),
(1615, 'front', 'Remember me'),
(1616, 'front', 'Forgot password?'),
(1617, 'front', 'Mobile number or email'),
(1618, 'front', 'Password'),
(1619, 'front', 'Don\'t have an account?'),
(1620, 'front', 'Sign Up'),
(1621, 'front', 'User cancelled login or did not fully authorize.'),
(1622, 'front', 'Login with Facebook'),
(1624, 'front', 'Login with Google'),
(1625, 'front', 'Let\'s get started'),
(1626, 'front', 'Enter your phone number'),
(1627, 'front', 'Next'),
(1628, 'front', 'Have an account?'),
(1629, 'front', 'Enter the code sent to'),
(1630, 'front', 'Resend Code'),
(1631, 'front', 'Resend Code in'),
(1633, 'front', 'Fill your information'),
(1634, 'front', 'First name'),
(1635, 'front', 'Last name'),
(1636, 'front', 'Email address'),
(1638, 'front', 'Confirm Password'),
(1639, 'front', 'Submit'),
(1640, 'front', 'Clear all'),
(1641, 'front', 'Filter'),
(1642, 'front', 'Over'),
(1643, 'front', 'Free delivery'),
(1644, 'front', 'end of result'),
(1645, 'front', 'Fastest delivery in'),
(1646, 'front', 'Receive food in less than 20 minutes'),
(1647, 'front', 'Sorry! We\'re not there yet'),
(1648, 'front', 'We\'re working hard to expand our area. However, we\'re not in this location yet. So sorry about this, we\'d still love to have you as a customer.'),
(1649, 'front', 'Try something new in'),
(1650, 'front', 'Most popular'),
(1651, 'front', 'Rating'),
(1652, 'front', 'Promo'),
(1653, 'front', 'Free delivery first order'),
(1654, 'front', 'Price range'),
(1655, 'front', 'Cuisines'),
(1656, 'front', 'Max Delivery Fee'),
(1657, 'front', 'Delivery Fee'),
(1658, 'front', 'Ratings'),
(1659, 'front', 'Search'),
(1660, 'front', 'Now'),
(1661, 'front', 'No default map provider, check your settings.'),
(1662, 'front', 'No results'),
(1663, 'front', 'Invalid file'),
(1664, 'front', 'Record not found'),
(1665, 'front', 'invalid error'),
(1666, 'front', 'You already added review for this order'),
(1667, 'front', 'Login successful'),
(1668, 'front', 'Please wait until we redirect you'),
(1669, 'front', 'Registration successful'),
(1670, 'front', 'Discount {{discount}}%'),
(1671, 'front', 'Pin location is too far from the address'),
(1672, 'front', 'User not login or session has expired'),
(1673, 'front', 'We sent a code to {{email_address}}.'),
(1674, 'front', 'Your verification code is {{code}}'),
(1676, 'front', 'Your session has expired please relogin'),
(1677, 'front', 'Invalid 6 digit code'),
(1678, 'front', 'Succesfull change contact number'),
(1679, 'front', 'Voucher code not found'),
(1680, 'front', 'Payment provider not found'),
(1681, 'front', 'This store is close right now, but you can schedulean order later.'),
(1682, 'front', 'Your Order has been place'),
(1683, 'front', 'Your order from'),
(1684, 'front', 'Summary'),
(1685, 'front', 'Track'),
(1686, 'front', 'Buy again'),
(1687, 'front', 'Customer cancel this order'),
(1688, 'front', 'Your order is now cancel. your refund is on its way.'),
(1689, 'front', 'Your order is now cancel. your partial refund is on its way.'),
(1690, 'front', 'This order has already been cancelled'),
(1691, 'front', 'Customer cancell this order'),
(1692, 'front', 'Your order is now cancel.'),
(1693, 'front', 'not login'),
(1694, 'front', 'You must login to save this store'),
(1695, 'front', 'Merchant has not set time opening yet'),
(1696, 'front', 'Phone number already exist'),
(1697, 'front', 'Accout not verified'),
(1698, 'front', 'Your account is {{status}}'),
(1699, 'front', 'Check {{email_address}} for an email to reset your password.'),
(1700, 'front', 'Your account is either inactive or not verified.'),
(1701, 'front', 'No email address found in our records. please verify your email.'),
(1703, 'front', 'Your password is now updated.'),
(1704, 'front', 'You have already existing request.'),
(1706, 'front', 'Invalid file extension'),
(1707, 'front', 'Invalid file size, allowed size are {{size}}'),
(1708, 'front', 'Failed cannot upload file.'),
(1709, 'front', 'Profile photo saved'),
(1710, 'front', 'Invalid data'),
(1711, 'front', 'File not found'),
(1712, 'front', 'ID is empty'),
(1714, 'front', 'Payment not found'),
(1715, 'front', '{{count}} store'),
(1716, 'front', '{{count}} stores'),
(1717, 'front', 'low cost restaurant'),
(1718, 'front', '{{review_count}} reviews'),
(1719, 'front', 'Save store'),
(1720, 'front', 'Saved'),
(1721, 'front', 'Enter your address'),
(1722, 'front', 'Gallery'),
(1723, 'front', 'Reviews'),
(1724, 'front', 'Based on'),
(1726, 'front', 'Load more'),
(1727, 'front', 'Few words about {{restaurant_name}}'),
(1728, 'front', 'Address'),
(1729, 'front', 'Get direction'),
(1730, 'front', 'Opening hours'),
(1731, 'front', 'Add to cart'),
(1732, 'front', 'Menu'),
(1735, 'front', 'Clear'),
(1736, 'front', 'Place Order'),
(1737, 'front', 'Checkout'),
(1738, 'front', 'Delivery details'),
(1739, 'front', 'Change address'),
(1740, 'front', 'Pick a time'),
(1741, 'front', 'Schedule for later'),
(1742, 'front', 'Done'),
(1743, 'front', 'Save'),
(1744, 'front', 'Optional'),
(1745, 'front', 'Special Instructions'),
(1746, 'front', 'Add a note (extra cheese, no onions, etc.)'),
(1747, 'front', 'If sold out'),
(1748, 'front', 'Go with merchant recommendation'),
(1749, 'front', 'Refund this item'),
(1750, 'front', 'Contact me'),
(1751, 'front', 'Cancel the entire order'),
(1752, 'front', 'Select 1'),
(1753, 'front', 'Choose up to'),
(1754, 'front', 'Select flavor'),
(1755, 'front', 'Required'),
(1756, 'front', 'monday'),
(1757, 'front', 'tuesday'),
(1758, 'front', 'wednesday'),
(1759, 'front', 'thursday'),
(1760, 'front', 'friday'),
(1761, 'front', 'saturday'),
(1762, 'front', 'sunday'),
(1763, 'front', 'You\'re out of range'),
(1764, 'front', 'This restaurant cannot deliver to'),
(1768, 'front', 'We\'ll confirm that you can have this restaurant delivered.'),
(1769, 'front', 'add Address'),
(1770, 'front', 'Delivery Address'),
(1772, 'front', 'Store is close'),
(1774, 'front', 'Schedule Order'),
(1775, 'front', 'min'),
(1776, 'front', 'Cooking Reference'),
(1777, 'front', 'Ingredients'),
(1778, 'front', 'Order type and time'),
(1779, 'front', 'Include utensils and condoments'),
(1780, 'front', 'Tip the courier'),
(1781, 'front', 'Optional tip for the courier'),
(1782, 'front', 'People also ordered'),
(1783, 'front', 'Choose a delivery address'),
(1784, 'front', 'Add new address'),
(1785, 'front', 'Payment Methods'),
(1786, 'front', 'Saved Payment Methods'),
(1787, 'front', 'Sub total'),
(1788, 'front', 'Service fee'),
(1789, 'front', 'Courier tip'),
(1790, 'front', 'Total'),
(1791, 'front', 'Add New Payment Method'),
(1792, 'front', 'Promotion available'),
(1793, 'front', '{{tax_name}} {{tax}}%'),
(1794, 'front', '{{tax_name}} ({{tax}}% included)'),
(1795, 'front', 'Packaging fee'),
(1797, 'front', 'minimum order is {{minimum_order}}'),
(1798, 'front', 'maximum order is {{maximum_order}}'),
(1800, 'front', 'This restaurant cannot deliver to your location.'),
(1801, 'front', 'Back to Menu'),
(1802, 'front', 'Confirming your order'),
(1803, 'front', 'Write A Review'),
(1804, 'front', 'What did you like?'),
(1805, 'front', 'What did you not like?'),
(1806, 'front', 'Add Photos'),
(1807, 'front', 'Write your review'),
(1808, 'front', 'post review as anonymous'),
(1809, 'front', 'Your review helps us to make better choices'),
(1810, 'front', 'Drop files here to upload'),
(1811, 'front', 'Add Review'),
(1812, 'front', 'Maximum files exceeded'),
(1813, 'front', 'Your browser does not support drag\'n\'drop file uploads.'),
(1814, 'front', 'Please use the fallback form below to upload your files like in the olden days.'),
(1815, 'front', 'File is too big ({{filesize}}MiB). Max filesize: {{maxFilesize}}MiB.w'),
(1816, 'front', 'You can\'t upload files of this type.'),
(1817, 'front', 'Server responded with {{statusCode}} code.'),
(1818, 'front', 'Cancel upload'),
(1819, 'front', 'Are you sure you want to cancel this upload?'),
(1820, 'front', 'Remove file'),
(1821, 'front', 'You can not upload any more files.'),
(1822, 'front', 'HOWS WAS YOUR ORDER?'),
(1823, 'front', 'let us know how your delivery wen and how you liked your order!'),
(1824, 'front', 'Rate Your Order'),
(1825, 'front', 'UPON ARRIVAL'),
(1826, 'front', 'Order #'),
(1827, 'front', 'Subtotal'),
(1828, 'front', 'Preparing your order'),
(1829, 'front', '{{restaurant_name}} is preparing your  order.'),
(1830, 'front', 'Your order is ready'),
(1831, 'front', 'Your order is ready to pickup by driver.'),
(1832, 'front', 'Pickup your order'),
(1833, 'front', 'Your order is ready. Time to go to {{restaurant_name}} to pickup your order.'),
(1835, 'front', 'Your order is ready. Time to go to {{restaurant_name}} to eat your order.'),
(1836, 'front', 'Heading to you'),
(1837, 'front', 'Your delivery guy is heading to you with your order.'),
(1838, 'front', 'Order Complete'),
(1839, 'front', 'Your order is completed. Enjoy!'),
(1840, 'front', 'Order cancelled'),
(1841, 'front', 'Unfortunately, the restaurant is not able to complete this order due to the following reason: {{rejetion_reason}}'),
(1842, 'front', 'Order rejected'),
(1845, 'front', 'Your order failed to complete'),
(1846, 'front', 'Unfortunately, the restaurant is not able to complete your order.'),
(1847, 'front', 'We sent your order to {{restaurant_name}} for final confirmation.'),
(1848, 'front', 'Notification'),
(1849, 'front', 'View all'),
(1850, 'front', 'All notifications'),
(1851, 'front', 'end of results'),
(1852, 'front', 'Manage my account'),
(1853, 'front', 'Orders'),
(1854, 'front', 'Addresses'),
(1855, 'front', 'Payments'),
(1856, 'front', 'Saved Stores'),
(1857, 'front', 'Order#{{order_id}} from {{customer_name}}'),
(1858, 'front', 'Your order #{{order_id}} is accepted by {{restaurant_name}}'),
(1859, 'front', 'days ago'),
(1860, 'front', 'day'),
(1861, 'front', 'days'),
(1862, 'front', 'ago'),
(1863, 'front', 'Profile'),
(1864, 'front', 'Basic Details'),
(1865, 'front', 'Change Password'),
(1866, 'front', 'Notifications'),
(1867, 'front', 'Manage Account'),
(1868, 'front', 'For your security, we want to make sure it\'s really you.'),
(1869, 'front', 'Enter 6-digit code'),
(1872, 'front', 'Code'),
(1873, 'front', 'Confirm account deletion'),
(1874, 'front', '(\"Are you sure you want to delete your account and customer data from {{site_title}}?{{new_line}} This action is permanent and cannot be undone.'),
(1875, 'front', 'Delete Account'),
(1876, 'front', 'Don\'t Delete'),
(1877, 'front', 'Okay'),
(1878, 'front', '2-Step Verification'),
(1879, 'front', 'Profile updated'),
(1880, 'front', 'Old password'),
(1881, 'front', 'New password'),
(1882, 'front', 'Notifications Settings'),
(1883, 'front', 'Enabled'),
(1884, 'front', 'Communication preferences'),
(1885, 'front', 'Could not get device interests'),
(1886, 'front', 'notifications enabled'),
(1887, 'front', 'notifications disabled'),
(1888, 'front', 'Could not stop Beams SDK'),
(1889, 'front', 'Could not start Beams SDK'),
(1890, 'front', 'Notification type save'),
(1891, 'front', 'Could not set device interests'),
(1893, 'front', 'Select only the marketing messages you would like to receive from {{settings.site_name}}. You will still receive transactional emails including but not limited to information about your account and certain other updates such as those related to safety and privacy.'),
(1895, 'front', 'Account Data'),
(1896, 'front', 'You can request an archive of your personal information. We\'ll notify you when it\'s ready to download.'),
(1897, 'front', 'Request archive'),
(1898, 'front', 'We received your data request'),
(1899, 'front', 'we\'ll send your data as soon as we can. this process may take a few days. You will receive an email once your data is ready.'),
(1901, 'front', 'You can request to have your account deleted and personal information removed. If you have both a DoorDash and Caviar account, then the information associated with both will be affected to the extent we can identify that the accounts are owned by the same user.'),
(1902, 'front', 'Your account is being deleted'),
(1903, 'front', 'You will be automatically logged out. Your account will be deleted in the next few minutes.'),
(1904, 'front', 'Note: We may retain some information when permitted by law.'),
(1905, 'front', 'Search order'),
(1910, 'front', 'Sorry we cannot find what your looking for'),
(1911, 'front', 'Order now'),
(1912, 'front', 'We like each other'),
(1913, 'front', 'Let\'s not change this!'),
(1914, 'front', 'Orders Qty'),
(1915, 'front', 'Total amount'),
(1916, 'front', 'Place on'),
(1917, 'front', 'View'),
(1920, 'front', 'Download PDF'),
(1921, 'front', 'Cancel order'),
(1924, 'front', 'Refund Issued'),
(1925, 'front', 'Date issued'),
(1926, 'front', 'Issued to'),
(1927, 'front', 'Amount'),
(1928, 'front', 'Description'),
(1929, 'front', 'Replacement'),
(1931, 'front', 'Don\'t cancel'),
(1932, 'front', 'How would you like to proceed?'),
(1933, 'front', 'Are you sure?'),
(1934, 'front', 'Order #{{order_id}}'),
(1935, 'front', '{{total}} item'),
(1936, 'front', '{{total}} items'),
(1937, 'front', 'Sub total ({{count}} items)'),
(1938, 'front', 'Place on {{date}}'),
(1939, 'front', 'Payment by {{payment_name}}'),
(1940, 'front', 'Go to checkout'),
(1941, 'front', 'Your cart from'),
(1942, 'front', 'Your order has not been accepted so there is no charge to cancel. Your payment will be refunded to your account.'),
(1943, 'front', 'Your total refund will be {{amount}}'),
(1944, 'front', 'Your driver is already on their way to pick up your order, so we can only refund the subtotal and tax'),
(1946, 'front', 'The store has started preparing this order so we can only refund the delivery charges and driver tip'),
(1947, 'front', 'Store has confirmed order and a driver has been assigned, so we cannot cancel this order'),
(1948, 'front', 'Refund is not available for this order'),
(1949, 'front', 'Your order has not been accepted so there is no charge to cancel, click cancel order to proceed'),
(1950, 'front', 'The driver has already on the way to pickup your order so we cannot cannot cancel this order'),
(1951, 'front', 'The restaurant has started preparing this order so we cannot cancel this order'),
(1953, 'front', 'this order has no items available'),
(1954, 'front', 'order not found'),
(1955, 'front', 'Discount {{discount}}'),
(1957, 'front', 'Item refund for {{item_name}}'),
(1958, 'front', 'Item out of stock for {{item_name}}'),
(1959, 'front', 'Cannot cancel this order, this order has existing refund.'),
(1960, 'front', 'transaction not found'),
(1961, 'front', 'No invoice payment found'),
(1962, 'front', 'no payment has found'),
(1963, 'front', 'Wow, man of many places :)'),
(1964, 'front', 'No address, lets change that!'),
(1967, 'front', 'Adjust pin'),
(1968, 'front', 'Delivery options'),
(1969, 'front', 'Add delivery instructions'),
(1970, 'front', 'eg. ring the bell after dropoff, leave next to the porch, call upon arrival, etc'),
(1971, 'front', 'Address label'),
(1973, 'front', 'Cancel'),
(1974, 'front', 'Aparment, suite or floor'),
(1976, 'front', 'Confirm'),
(1977, 'front', 'Yes'),
(1978, 'front', 'Are you sure you want to continue?'),
(1979, 'front', 'Complete Address'),
(1980, 'front', 'Edit'),
(1981, 'front', 'Delete'),
(1982, 'front', 'Address details'),
(1984, 'front', 'Home'),
(1985, 'front', 'Work'),
(1986, 'front', 'School'),
(1987, 'front', 'Friend house'),
(1988, 'front', 'Other'),
(1989, 'front', 'Payment'),
(1990, 'front', 'You can add your payment info here'),
(1991, 'front', 'Add new payment'),
(1992, 'front', 'Close Payment'),
(1993, 'front', 'Set Default'),
(1995, 'front', 'Your collection of restaurant and foods'),
(1996, 'front', 'You don\'t have any save stores here!'),
(1997, 'front', 'My orders'),
(1998, 'front', 'Payments Options'),
(1999, 'front', 'Logout'),
(2003, 'front', 'You\'ll be contacted soon!'),
(2004, 'front', '{{website_title}} needs to be contact you for more information. You can expect a phone call or email in 1-3 business days'),
(2005, 'front', 'THANKS FOR LOADING'),
(2006, 'front', 'Payment successful.'),
(2007, 'front', 'check your account statements account.'),
(2008, 'front', 'Go to statement'),
(2009, 'front', 'Cash In'),
(2010, 'front', 'Cash In Amount'),
(2011, 'front', 'Continue'),
(2012, 'front', 'Confirm cash in'),
(2013, 'front', 'Cash in amount {{amount}}, click yes to continue.'),
(2016, 'front', 'Back to dashboard'),
(2017, 'front', 'Subscription Plans'),
(2018, 'front', 'Privacy Notice'),
(2019, 'front', 'Become Restaurant partner'),
(2020, 'front', 'Get a sales boost of up to 30% from takeaways'),
(2022, 'front', 'Why partner with Us?'),
(2023, 'front', 'Increase sales'),
(2024, 'front', 'Keep the kitchen busy'),
(2025, 'front', 'Join a well-oiled marketing machine and watch the orders come in through your door and online.'),
(2026, 'front', 'Meet them and keep them'),
(2027, 'front', 'Attract new local customers and keep them coming back for more.'),
(2028, 'front', 'Use our services'),
(2029, 'front', 'For businesses big and small'),
(2030, 'front', 'Whatever your size we have tools, business support and savings to help grow your business.'),
(2031, 'front', 'Overtake competitors'),
(2032, 'front', 'Become a Multi Restaurant partner today.'),
(2033, 'front', 'Store name'),
(2034, 'front', 'Store address'),
(2035, 'front', 'Choose your membership program'),
(2036, 'front', 'Register user'),
(2037, 'front', 'Signup'),
(2039, 'front', 'Username'),
(2040, 'front', 'Select Payment'),
(2041, 'front', 'Select'),
(2042, 'front', 'weekly'),
(2043, 'front', 'monthly'),
(2044, 'front', 'anually'),
(2045, 'front', 'Enter your card details'),
(2046, 'front', 'Subscribe'),
(2048, 'front', 'Cardholder name'),
(2049, 'front', 'THANKS FOR JOINING'),
(2050, 'front', 'Your registration is complete!'),
(2051, 'front', 'You can login to merchant portal by clicking {{start_link}}here{{end_link}}'),
(2052, 'front', 'Something went wrong.'),
(2053, 'front', 'uh-oh! Looks like the page you are trying to access, doesn\'t exist. Please start afresh.'),
(2054, 'front', 'Processing payment..'),
(2055, 'front', 'don\'t close this window'),
(2056, 'front', '{{estimation}} mins'),
(2057, 'front', '{{distance}} {{unit}} delivery distance'),
(2058, 'front', 'Leave it at my door'),
(2059, 'front', 'Hand it to me'),
(2060, 'front', 'Meet outside'),
(2061, 'front', 'Add tip'),
(2062, 'front', 'Default'),
(2063, 'front', 'Add Cash On delivery'),
(2064, 'front', 'Cash on Delivery or COD is a payment method that allows pay for the items you have ordered only when it gets delivered.'),
(2065, 'front', 'Add Cash'),
(2066, 'front', 'Add New Card'),
(2067, 'front', 'Card Number'),
(2068, 'front', 'Exp. Date'),
(2069, 'front', 'Security Code'),
(2070, 'front', 'Card Name'),
(2071, 'front', 'Billing Address'),
(2072, 'front', 'Add Card'),
(2073, 'front', 'Add Paypal'),
(2074, 'front', 'Pay using your paypal account'),
(2075, 'front', 'Add Stripe'),
(2076, 'front', 'Add your stripe account'),
(2077, 'front', 'You will re-direct to Stripe account to login to your account.'),
(2079, 'front', 'I authorise {{website_name}} to send instructions to the financial institution that issued my card to take payments from my card account in accordance with the terms of my agreement with {{website_name}}'),
(2080, 'front', 'An error has occured'),
(2081, 'front', 'Add Razorpay'),
(2082, 'front', 'Pay using your Razorpay account'),
(2083, 'front', 'Pay using Razorpay'),
(2084, 'front', 'You will re-direct to Razorpay account to login to your account.'),
(2085, 'front', 'Pay with Razorpay'),
(2086, 'front', 'Creating account'),
(2087, 'front', 'Getting payment information....'),
(2088, 'front', 'Add mercadopago'),
(2089, 'front', 'Pay using your mercadopago account'),
(2090, 'front', 'Exp. Date MM/YYYY'),
(2091, 'front', 'Identification Number'),
(2092, 'front', 'Identification'),
(2093, 'front', 'Enter CVV for card'),
(2095, 'front', 'Verification'),
(2096, 'front', 'Order Type'),
(2097, 'front', 'Desired delivery time'),
(2098, 'front', 'Edit phone number'),
(2099, 'front', 'Promotions'),
(2100, 'front', 'Have a promo code?'),
(2101, 'front', 'Add promo code'),
(2102, 'front', 'Apply'),
(2103, 'front', 'Add promo'),
(2104, 'front', 'Not available'),
(2105, 'front', 'You\'re saving {{discount}}'),
(2106, 'front', 'Use until {{date}}'),
(2107, 'front', '({{coupon_name}}) {{amount}}% off'),
(2108, 'front', '({{coupon_name}}) {{amount}} off'),
(2109, 'front', 'Min. spend {{amount}}'),
(2110, 'front', '{{amount}}% off over {{order_over}} on {{transaction}}'),
(2111, 'front', 'valid {{from}} to {{to}}'),
(2112, 'front', 'row not found'),
(2113, 'front', 'cart uuid not found'),
(2114, 'front', 'order has no item'),
(2115, 'front', 'Address not found'),
(2116, 'front', 'no default email provider'),
(2117, 'front', 'Place ID is empty'),
(2118, 'front', 'Map provider not set'),
(2119, 'front', 'merchant not found'),
(2120, 'front', 'Place id not found'),
(2121, 'front', 'Invalid filter'),
(2122, 'front', 'Invalid coordinates'),
(2123, 'front', 'Invalid distance unit'),
(2124, 'front', 'Selected delivery time is already past'),
(2125, 'front', 'Currently unavailable'),
(2126, 'front', 'no memberhisp program'),
(2127, 'front', 'no available payment method'),
(2128, 'front', 'no results payment credentials'),
(2129, 'front', 'no available saved payment'),
(2130, 'front', 'cannot delete records please try again.'),
(2131, 'front', 'No payment method meta found'),
(2133, 'front', 'Please validated captcha'),
(2134, 'front', 'Invalid recaptcha secret key'),
(2135, 'front', 'Invalid google recaptcha error'),
(2136, 'front', 'Invalid response from google recaptcha'),
(2138, 'front', 'invalid response'),
(2139, 'front', 'no sms provider set in admin panel'),
(2140, 'front', 'Undefined facebook response'),
(2141, 'front', 'Invalid ID token'),
(2142, 'front', 'Invalid api keys'),
(2143, 'front', 'undefined map provider'),
(2144, 'front', 'invalid place id parameters'),
(2145, 'front', 'over query limit'),
(2146, 'front', 'input parameter is missing'),
(2147, 'front', 'unknow error'),
(2148, 'front', 'undefined error'),
(2149, 'front', 'miles'),
(2150, 'front', 'km'),
(2151, 'front', 'ft'),
(2152, 'front', 'invalid latitude parameters'),
(2153, 'front', 'invalid longitude parameters'),
(2154, 'front', 'Search tag'),
(2155, 'front', 'Reach more customers'),
(2156, 'backend', 'Replace Item'),
(2157, 'backend', 'Refund payment'),
(2158, 'backend', 'Refund the full amount'),
(2159, 'backend', 'Show language selection'),
(2160, 'backend', 'Languages settings'),
(2161, 'backend', 'Default language'),
(2162, 'backend', 'Backend Translation'),
(2164, 'backend', 'Export Backend translation'),
(2165, 'backend', 'Export Front translation'),
(2166, 'backend', 'Backend'),
(2167, 'backend', 'Front end'),
(2168, 'backend', 'Import language file'),
(2169, 'backend', 'Succesfully imported'),
(2170, 'backend', 'Invalid csv data'),
(2171, 'backend', 'Important notice, all the previous save words will be replace by the csv you uploaded.'),
(2172, 'backend', 'Import'),
(2173, 'front', 'Filters'),
(2174, 'front', 'Restaurant'),
(2175, 'front', 'Food'),
(2176, 'front', 'View order'),
(2177, 'front', 'Tap for hours,address, and more'),
(2178, 'front', 'Add your restaurant'),
(2179, 'front', 'Sign up to deliver'),
(2180, 'front', 'Best restaurants In your pocket'),
(2181, 'front', 'Get the app'),
(2182, 'backend', 'An error has occured.'),
(2183, 'backend', 'Your password has been reset.'),
(2184, 'backend', 'Forgot Backend Password Template'),
(2185, 'backend', 'Allow return to home'),
(2186, 'backend', 'Version {{version}}');


--
-- Indexes for dumped tables
--

--
-- Indexes for table `st_admin_meta`
--
ALTER TABLE `st_admin_meta`
  ADD PRIMARY KEY (`meta_id`),
  ADD KEY `meta_name` (`meta_name`);

--
-- Indexes for table `st_admin_meta_translation`
--
ALTER TABLE `st_admin_meta_translation`
  ADD PRIMARY KEY (`id`),
  ADD KEY `meta_id` (`meta_id`),
  ADD KEY `language` (`language`);

--
-- Indexes for table `st_admin_user`
--
ALTER TABLE `st_admin_user`
  ADD PRIMARY KEY (`admin_id`),
  ADD KEY `username` (`username`),
  ADD KEY `password` (`password`),
  ADD KEY `admin_id_token` (`admin_id_token`),
  ADD KEY `email_address` (`email_address`),
  ADD KEY `contact_number` (`contact_number`);

--
-- Indexes for table `st_availability`
--
ALTER TABLE `st_availability`
  ADD PRIMARY KEY (`id`),
  ADD KEY `merchant_id` (`merchant_id`),
  ADD KEY `meta_name` (`meta_name`),
  ADD KEY `status` (`status`);

--
-- Indexes for table `st_cache`
--
ALTER TABLE `st_cache`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `st_cart`
--
ALTER TABLE `st_cart`
  ADD PRIMARY KEY (`id`),
  ADD KEY `cart_uuid` (`cart_uuid`),
  ADD KEY `item_token` (`item_token`),
  ADD KEY `item_size_id` (`item_size_id`),
  ADD KEY `cart_row` (`cart_row`);

--
-- Indexes for table `st_cart_addons`
--
ALTER TABLE `st_cart_addons`
  ADD PRIMARY KEY (`id`),
  ADD KEY `cart_row` (`cart_row`),
  ADD KEY `cart_uuid` (`cart_uuid`),
  ADD KEY `subcat_id` (`subcat_id`),
  ADD KEY `sub_item_id` (`sub_item_id`);

--
-- Indexes for table `st_cart_attributes`
--
ALTER TABLE `st_cart_attributes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `cart_row` (`cart_row`),
  ADD KEY `cart_uuid` (`cart_uuid`),
  ADD KEY `meta_name` (`meta_name`);

--
-- Indexes for table `st_category`
--
ALTER TABLE `st_category`
  ADD PRIMARY KEY (`cat_id`),
  ADD KEY `merchant_id` (`merchant_id`),
  ADD KEY `category_name` (`category_name`),
  ADD KEY `status` (`status`),
  ADD KEY `sequence` (`sequence`);

--
-- Indexes for table `st_category_relationship_dish`
--
ALTER TABLE `st_category_relationship_dish`
  ADD PRIMARY KEY (`id`),
  ADD KEY `cat_id` (`cat_id`),
  ADD KEY `dish_id` (`dish_id`);

--
-- Indexes for table `st_category_translation`
--
ALTER TABLE `st_category_translation`
  ADD PRIMARY KEY (`id`),
  ADD KEY `cat_id` (`cat_id`),
  ADD KEY `language` (`language`);

--
-- Indexes for table `st_client`
--
ALTER TABLE `st_client`
  ADD PRIMARY KEY (`client_id`),
  ADD KEY `social_strategy` (`social_strategy`),
  ADD KEY `email_address` (`email_address`),
  ADD KEY `password` (`password`),
  ADD KEY `contact_phone` (`contact_phone`),
  ADD KEY `status` (`status`),
  ADD KEY `token` (`token`),
  ADD KEY `mobile_verification_code` (`mobile_verification_code`),
  ADD KEY `social_id` (`social_id`),
  ADD KEY `merchant_id` (`merchant_id`);

--
-- Indexes for table `st_client_address`
--
ALTER TABLE `st_client_address`
  ADD PRIMARY KEY (`address_id`),
  ADD KEY `place_id` (`place_id`),
  ADD KEY `address_uuid` (`address_uuid`),
  ADD KEY `client_id` (`client_id`);

--
-- Indexes for table `st_client_cc`
--
ALTER TABLE `st_client_cc`
  ADD PRIMARY KEY (`cc_id`),
  ADD KEY `client_id` (`client_id`);

--
-- Indexes for table `st_client_meta`
--
ALTER TABLE `st_client_meta`
  ADD PRIMARY KEY (`id`),
  ADD KEY `client_id` (`client_id`),
  ADD KEY `meta1` (`meta1`),
  ADD KEY `meta2` (`meta2`),
  ADD KEY `meta3` (`meta3`),
  ADD KEY `meta4` (`meta4`);

--
-- Indexes for table `st_client_payment_method`
--
ALTER TABLE `st_client_payment_method`
  ADD PRIMARY KEY (`payment_method_id`),
  ADD KEY `client_id` (`client_id`),
  ADD KEY `reference_id` (`reference_id`),
  ADD KEY `payment_uuid` (`payment_uuid`),
  ADD KEY `payment_code` (`payment_code`),
  ADD KEY `merchant_id` (`merchant_id`);

--
-- Indexes for table `st_cooking_ref`
--
ALTER TABLE `st_cooking_ref`
  ADD PRIMARY KEY (`cook_id`),
  ADD KEY `merchant_id` (`merchant_id`),
  ADD KEY `cooking_name` (`cooking_name`),
  ADD KEY `sequence` (`sequence`),
  ADD KEY `status` (`status`);

--
-- Indexes for table `st_cooking_ref_translation`
--
ALTER TABLE `st_cooking_ref_translation`
  ADD PRIMARY KEY (`id`),
  ADD KEY `cook_id` (`cook_id`),
  ADD KEY `language` (`language`);

--
-- Indexes for table `st_cuisine`
--
ALTER TABLE `st_cuisine`
  ADD PRIMARY KEY (`cuisine_id`),
  ADD KEY `cuisine_name` (`cuisine_name`),
  ADD KEY `sequence` (`sequence`);

--
-- Indexes for table `st_cuisine_merchant`
--
ALTER TABLE `st_cuisine_merchant`
  ADD PRIMARY KEY (`id`),
  ADD KEY `merchant_id` (`merchant_id`),
  ADD KEY `cuisine_id` (`cuisine_id`);

--
-- Indexes for table `st_cuisine_translation`
--
ALTER TABLE `st_cuisine_translation`
  ADD PRIMARY KEY (`id`),
  ADD KEY `cuisine_id` (`cuisine_id`),
  ADD KEY `language` (`language`),
  ADD KEY `cuisine_name` (`cuisine_name`);

--
-- Indexes for table `st_currency`
--
ALTER TABLE `st_currency`
  ADD PRIMARY KEY (`id`),
  ADD KEY `currency_symbol` (`currency_symbol`),
  ADD KEY `currency_code` (`currency_code`);

--
-- Indexes for table `st_device`
--
ALTER TABLE `st_device`
  ADD PRIMARY KEY (`device_id`),
  ADD KEY `user_type` (`user_type`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `platform` (`platform`),
  ADD KEY `device_uiid` (`device_uiid`),
  ADD KEY `enabled` (`enabled`);

--
-- Indexes for table `st_device_meta`
--
ALTER TABLE `st_device_meta`
  ADD PRIMARY KEY (`id`),
  ADD KEY `device_id` (`device_id`),
  ADD KEY `meta_name` (`meta_name`);

--
-- Indexes for table `st_dishes`
--
ALTER TABLE `st_dishes`
  ADD PRIMARY KEY (`dish_id`),
  ADD KEY `dish_name` (`dish_name`),
  ADD KEY `status` (`status`);

--
-- Indexes for table `st_dishes_translation`
--
ALTER TABLE `st_dishes_translation`
  ADD PRIMARY KEY (`id`),
  ADD KEY `dish_id` (`dish_id`),
  ADD KEY `language` (`language`),
  ADD KEY `dish_name` (`dish_name`);

--
-- Indexes for table `st_email_logs`
--
ALTER TABLE `st_email_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `email_address` (`email_address`),
  ADD KEY `status` (`status`);

--
-- Indexes for table `st_email_provider`
--
ALTER TABLE `st_email_provider`
  ADD PRIMARY KEY (`id`),
  ADD KEY `provider_id` (`provider_id`),
  ADD KEY `provider_name` (`provider_name`);

--
-- Indexes for table `st_favorites`
--
ALTER TABLE `st_favorites`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fav_type` (`fav_type`),
  ADD KEY `client_id` (`client_id`),
  ADD KEY `merchant_id` (`merchant_id`),
  ADD KEY `item_id` (`item_id`);

--
-- Indexes for table `st_featured_location`
--
ALTER TABLE `st_featured_location`
  ADD PRIMARY KEY (`id`),
  ADD KEY `featured_name` (`featured_name`),
  ADD KEY `status` (`status`);

--
-- Indexes for table `st_gpdr_request`
--
ALTER TABLE `st_gpdr_request`
  ADD PRIMARY KEY (`id`),
  ADD KEY `request_type` (`request_type`),
  ADD KEY `client_id` (`client_id`),
  ADD KEY `status` (`status`);

--
-- Indexes for table `st_ingredients`
--
ALTER TABLE `st_ingredients`
  ADD PRIMARY KEY (`ingredients_id`),
  ADD KEY `merchant_id` (`merchant_id`),
  ADD KEY `status` (`status`),
  ADD KEY `ingredients_name` (`ingredients_name`);

--
-- Indexes for table `st_ingredients_translation`
--
ALTER TABLE `st_ingredients_translation`
  ADD PRIMARY KEY (`id`),
  ADD KEY `ingredients_id` (`ingredients_id`),
  ADD KEY `language` (`language`);

--
-- Indexes for table `st_inventory_supplier`
--
ALTER TABLE `st_inventory_supplier`
  ADD PRIMARY KEY (`supplier_id`),
  ADD KEY `merchant_id` (`merchant_id`);

--
-- Indexes for table `st_item`
--
ALTER TABLE `st_item`
  ADD PRIMARY KEY (`item_id`),
  ADD KEY `merchant_id` (`merchant_id`),  
  ADD KEY `status` (`status`),
  ADD KEY `is_featured` (`is_featured`),
  ADD KEY `points_earned` (`points_earned`),
  ADD KEY `is_promo_free_item` (`is_promo_free_item`),
  ADD KEY `slug` (`slug`);

ALTER TABLE `st_item` ADD FULLTEXT KEY `item_name` (`item_name`);

--
-- Indexes for table `st_item_meta`
--
ALTER TABLE `st_item_meta`
  ADD PRIMARY KEY (`id`),
  ADD KEY `item_id` (`item_id`),
  ADD KEY `meta_name` (`meta_name`),
  ADD KEY `meta_id` (`meta_id`),
  ADD KEY `merchant_id` (`merchant_id`);

--
-- Indexes for table `st_item_promo`
--
ALTER TABLE `st_item_promo`
  ADD PRIMARY KEY (`promo_id`),
  ADD KEY `item_id` (`item_id`),
  ADD KEY `item_id_promo` (`item_id_promo`),
  ADD KEY `merchant_id` (`merchant_id`);

--
-- Indexes for table `st_item_relationship_category`
--
ALTER TABLE `st_item_relationship_category`
  ADD PRIMARY KEY (`id`),
  ADD KEY `merchant_id` (`merchant_id`),
  ADD KEY `item_id` (`item_id`),
  ADD KEY `cat_id` (`cat_id`);

--
-- Indexes for table `st_item_relationship_size`
--
ALTER TABLE `st_item_relationship_size`
  ADD PRIMARY KEY (`item_size_id`),
  ADD KEY `merchant_id` (`merchant_id`),
  ADD KEY `item_token` (`item_token`),
  ADD KEY `item_id` (`item_id`),
  ADD KEY `size_id` (`size_id`);

--
-- Indexes for table `st_item_relationship_subcategory`
--
ALTER TABLE `st_item_relationship_subcategory`
  ADD PRIMARY KEY (`id`),
  ADD KEY `merchant_id` (`merchant_id`),
  ADD KEY `item_id` (`item_id`),
  ADD KEY `subcat_id` (`subcat_id`);

--
-- Indexes for table `st_item_relationship_subcategory_item`
--
ALTER TABLE `st_item_relationship_subcategory_item`
  ADD PRIMARY KEY (`id`),
  ADD KEY `merchant_id` (`merchant_id`),
  ADD KEY `item_id` (`item_id`),
  ADD KEY `subcat_id` (`subcat_id`),
  ADD KEY `sub_item_id` (`sub_item_id`);

--
-- Indexes for table `st_item_translation`
--
ALTER TABLE `st_item_translation`
  ADD PRIMARY KEY (`id`),
  ADD KEY `item_id` (`item_id`),
  ADD KEY `language` (`language`),
  ADD KEY `item_name` (`item_name`);

--
-- Indexes for table `st_language`
--
ALTER TABLE `st_language`
  ADD PRIMARY KEY (`id`),
  ADD KEY `code` (`code`),
  ADD KEY `status` (`status`);

--
-- Indexes for table `st_location_area`
--
ALTER TABLE `st_location_area`
  ADD PRIMARY KEY (`area_id`),
  ADD KEY `city_id` (`city_id`),
  ADD KEY `sequence` (`sequence`),
  ADD KEY `name` (`name`);

--
-- Indexes for table `st_location_cities`
--
ALTER TABLE `st_location_cities`
  ADD PRIMARY KEY (`city_id`),
  ADD KEY `postal_code` (`postal_code`),
  ADD KEY `state_id` (`state_id`),
  ADD KEY `sequence` (`sequence`),
  ADD KEY `name` (`name`);

--
-- Indexes for table `st_location_countries`
--
ALTER TABLE `st_location_countries`
  ADD PRIMARY KEY (`country_id`),
  ADD KEY `shortcode` (`shortcode`);

--
-- Indexes for table `st_location_rate`
--
ALTER TABLE `st_location_rate`
  ADD PRIMARY KEY (`rate_id`),
  ADD KEY `merchant_id` (`merchant_id`),
  ADD KEY `country_id` (`country_id`),
  ADD KEY `state_id` (`state_id`),
  ADD KEY `area_id` (`area_id`),
  ADD KEY `city_id` (`city_id`),
  ADD KEY `fee` (`fee`);

--
-- Indexes for table `st_location_states`
--
ALTER TABLE `st_location_states`
  ADD PRIMARY KEY (`state_id`),
  ADD KEY `country_id` (`country_id`),
  ADD KEY `sequence` (`sequence`),
  ADD KEY `name` (`name`);

--
-- Indexes for table `st_map_places`
--
ALTER TABLE `st_map_places`
  ADD PRIMARY KEY (`id`),
  ADD KEY `reference_type` (`reference_type`),
  ADD KEY `reference_id` (`reference_id`);

--
-- Indexes for table `st_media_files`
--
ALTER TABLE `st_media_files`
  ADD PRIMARY KEY (`id`),
  ADD KEY `merchant_id` (`merchant_id`),
  ADD KEY `meta_name` (`meta_name`);

--
-- Indexes for table `st_menu`
--
ALTER TABLE `st_menu`
  ADD PRIMARY KEY (`menu_id`),
  ADD KEY `menu_type` (`menu_type`),
  ADD KEY `parent_id` (`parent_id`),
  ADD KEY `status` (`status`),
  ADD KEY `visible` (`visible`);

--
-- Indexes for table `st_merchant`
--
ALTER TABLE `st_merchant`
  ADD PRIMARY KEY (`merchant_id`),
  ADD KEY `restaurant_slug` (`restaurant_slug`),
  ADD KEY `restaurant_name` (`restaurant_name`),
  ADD KEY `username` (`username`),
  ADD KEY `password` (`password`),
  ADD KEY `status` (`status`),
  ADD KEY `is_featured` (`is_featured`),
  ADD KEY `is_ready` (`is_ready`),
  ADD KEY `is_sponsored` (`is_sponsored`),
  ADD KEY `is_commission` (`is_commission`),
  ADD KEY `percent_commision` (`percent_commision`),
  ADD KEY `merchant_id` (`merchant_id`),
  ADD KEY `latitude` (`latitude`),
  ADD KEY `lontitude` (`lontitude`),
  ADD KEY `merchant_type` (`merchant_type`),
  ADD KEY `close_store` (`close_store`);

--
-- Indexes for table `st_merchant_meta`
--
ALTER TABLE `st_merchant_meta`
  ADD PRIMARY KEY (`meta_id`),
  ADD KEY `merchant_id` (`merchant_id`),
  ADD KEY `meta_name` (`meta_name`);

--
-- Indexes for table `st_merchant_payment_method`
--
ALTER TABLE `st_merchant_payment_method`
  ADD PRIMARY KEY (`payment_method_id`),
  ADD KEY `merchant_id` (`merchant_id`);

--
-- Indexes for table `st_merchant_type`
--
ALTER TABLE `st_merchant_type`
  ADD PRIMARY KEY (`id`),
  ADD KEY `type_id` (`type_id`),
  ADD KEY `commision_type` (`commision_type`),
  ADD KEY `status` (`status`);

--
-- Indexes for table `st_merchant_type_translation`
--
ALTER TABLE `st_merchant_type_translation`
  ADD PRIMARY KEY (`id`),
  ADD KEY `type_id` (`type_id`),
  ADD KEY `language` (`language`);

--
-- Indexes for table `st_merchant_user`
--
ALTER TABLE `st_merchant_user`
  ADD PRIMARY KEY (`merchant_user_id`),
  ADD KEY `merchant_id` (`merchant_id`),
  ADD KEY `username` (`username`),
  ADD KEY `password` (`password`),
  ADD KEY `status` (`status`),
  ADD KEY `session_token` (`session_token`),
  ADD KEY `user_uuid` (`user_uuid`);

--
-- Indexes for table `st_notifications`
--
ALTER TABLE `st_notifications`
  ADD PRIMARY KEY (`notification_uuid`),
  ADD KEY `notication_channel` (`notication_channel`),
  ADD KEY `notification_type` (`notification_type`);

--
-- Indexes for table `st_offers`
--
ALTER TABLE `st_offers`
  ADD PRIMARY KEY (`offers_id`),
  ADD KEY `merchant_id` (`merchant_id`),
  ADD KEY `status` (`status`),
  ADD KEY `visible` (`visible`);

--
-- Indexes for table `st_opening_hours`
--
ALTER TABLE `st_opening_hours`
  ADD PRIMARY KEY (`id`),
  ADD KEY `merchant_id` (`merchant_id`),
  ADD KEY `day` (`day`),
  ADD KEY `status` (`status`),
  ADD KEY `start_time` (`start_time`),
  ADD KEY `end_time` (`end_time`),
  ADD KEY `start_time_pm` (`start_time_pm`),
  ADD KEY `end_time_pm` (`end_time_pm`),
  ADD KEY `custom_text` (`custom_text`),
  ADD KEY `day_of_week` (`day_of_week`),
  ADD KEY `time_config_type` (`time_config_type`);

--
-- Indexes for table `st_option`
--
ALTER TABLE `st_option`
  ADD PRIMARY KEY (`id`),
  ADD KEY `merchant_id` (`merchant_id`),
  ADD KEY `option_name` (`option_name`);

--
-- Indexes for table `st_ordernew`
--
ALTER TABLE `st_ordernew`
  ADD PRIMARY KEY (`order_id`),
  ADD KEY `order_uuid` (`order_uuid`),
  ADD KEY `merchant_id` (`merchant_id`),
  ADD KEY `client_id` (`client_id`),
  ADD KEY `service_code` (`service_code`),
  ADD KEY `payment_code` (`payment_code`),
  ADD KEY `status` (`status`),
  ADD KEY `payment_status` (`payment_status`),
  ADD KEY `is_critical` (`is_critical`),
  ADD KEY `driver_id` (`driver_id`),
  ADD KEY `delivery_status` (`delivery_status`),
  ADD KEY `date_created` (`date_created`),
  ADD KEY `created_at` (`created_at`),
  ADD KEY `flow_status` (`flow_status`),
  ADD KEY `order_reference` (`order_reference`);

--
-- Indexes for table `st_ordernew_additional_charge`
--
ALTER TABLE `st_ordernew_additional_charge`
  ADD PRIMARY KEY (`id`),
  ADD KEY `order_id` (`order_id`),
  ADD KEY `item_row` (`item_row`);

--
-- Indexes for table `st_ordernew_addons`
--
ALTER TABLE `st_ordernew_addons`
  ADD PRIMARY KEY (`id`),
  ADD KEY `order_id` (`order_id`),
  ADD KEY `item_row` (`item_row`),
  ADD KEY `subcat_id` (`subcat_id`),
  ADD KEY `sub_item_id` (`sub_item_id`);

--
-- Indexes for table `st_ordernew_attributes`
--
ALTER TABLE `st_ordernew_attributes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `order_id` (`order_id`),
  ADD KEY `item_row` (`item_row`),
  ADD KEY `meta_name` (`meta_name`);

--
-- Indexes for table `st_ordernew_history`
--
ALTER TABLE `st_ordernew_history`
  ADD PRIMARY KEY (`id`),
  ADD KEY `order_id` (`order_id`);

--
-- Indexes for table `st_ordernew_item`
--

ALTER TABLE `st_ordernew_item`
  ADD PRIMARY KEY (`id`),
  ADD KEY `order_id` (`order_id`),
  ADD KEY `item_row` (`item_row`),
  ADD KEY `cat_id` (`cat_id`),
  ADD KEY `item_token` (`item_token`),
  ADD KEY `item_size_id` (`item_size_id`),
  ADD KEY `item_id` (`item_id`),
  ADD KEY `kot_status` (`kot_status`);  

--
-- Indexes for table `st_ordernew_meta`
--
ALTER TABLE `st_ordernew_meta`
  ADD PRIMARY KEY (`meta_id`),
  ADD KEY `order_id` (`order_id`),
  ADD KEY `meta_name` (`meta_name`);

--
-- Indexes for table `st_ordernew_summary_transaction`
--
ALTER TABLE `st_ordernew_summary_transaction`
  ADD PRIMARY KEY (`transaction_id`),
  ADD KEY `transaction_uuid` (`transaction_uuid`),
  ADD KEY `order_id` (`order_id`),
  ADD KEY `status` (`status`);

--
-- Indexes for table `st_ordernew_transaction`
--
ALTER TABLE `st_ordernew_transaction`
  ADD PRIMARY KEY (`transaction_id`),
  ADD KEY `order_id` (`order_id`),
  ADD KEY `merchant_id` (`merchant_id`),
  ADD KEY `client_id` (`client_id`),
  ADD KEY `payment_code` (`payment_code`),
  ADD KEY `status` (`status`),
  ADD KEY `transaction_type` (`transaction_type`);

--
-- Indexes for table `st_ordernew_trans_meta`
--
ALTER TABLE `st_ordernew_trans_meta`
  ADD PRIMARY KEY (`meta_id`),
  ADD KEY `order_id` (`order_id`),
  ADD KEY `meta_name` (`meta_name`);

--
-- Indexes for table `st_order_settings_buttons`
--
ALTER TABLE `st_order_settings_buttons`
  ADD PRIMARY KEY (`id`),
  ADD KEY `uuid` (`uuid`),
  ADD KEY `group_name` (`group_name`),
  ADD KEY `stats_id` (`stats_id`),
  ADD KEY `do_actions` (`do_actions`),
  ADD KEY `order_type` (`order_type`);

--
-- Indexes for table `st_order_settings_tabs`
--
ALTER TABLE `st_order_settings_tabs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `group_name` (`group_name`),
  ADD KEY `stats_id` (`stats_id`);

--
-- Indexes for table `st_order_status`
--
ALTER TABLE `st_order_status`
  ADD PRIMARY KEY (`stats_id`),
  ADD KEY `merchant_id` (`merchant_id`);

--
-- Indexes for table `st_order_status_actions`
--
ALTER TABLE `st_order_status_actions`
  ADD PRIMARY KEY (`action_id`),
  ADD KEY `stats_id` (`stats_id`);

--
-- Indexes for table `st_order_status_translation`
--
ALTER TABLE `st_order_status_translation`
  ADD PRIMARY KEY (`id`),
  ADD KEY `stats_id` (`stats_id`),
  ADD KEY `language` (`language`);

--
-- Indexes for table `st_order_time_management`
--
ALTER TABLE `st_order_time_management`
  ADD PRIMARY KEY (`id`),
  ADD KEY `group_id` (`group_id`),
  ADD KEY `merchant_id` (`merchant_id`),
  ADD KEY `transaction_type` (`transaction_type`),
  ADD KEY `days` (`days`),
  ADD KEY `start_time` (`start_time`),
  ADD KEY `end_time` (`end_time`);

--
-- Indexes for table `st_package_details`
--
ALTER TABLE `st_package_details`
  ADD PRIMARY KEY (`id`),
  ADD KEY `package_id` (`package_id`);

--
-- Indexes for table `st_pages`
--
ALTER TABLE `st_pages`
  ADD PRIMARY KEY (`page_id`),
  ADD KEY `slug` (`slug`),
  ADD KEY `title` (`title`),
  ADD KEY `page_type` (`page_type`),
  ADD KEY `status` (`status`),
  ADD KEY `merchant_id` (`merchant_id`),
  ADD KEY `owner` (`owner`);

--
-- Indexes for table `st_pages_translation`
--
ALTER TABLE `st_pages_translation`
  ADD PRIMARY KEY (`id`),
  ADD KEY `page_id` (`page_id`),
  ADD KEY `language` (`language`);

--
-- Indexes for table `st_payment_gateway`
--
ALTER TABLE `st_payment_gateway`
  ADD PRIMARY KEY (`payment_id`),
  ADD KEY `payment_code` (`payment_code`),
  ADD KEY `is_online` (`is_online`),
  ADD KEY `is_payout` (`is_payout`),
  ADD KEY `is_plan` (`is_plan`),
  ADD KEY `status` (`status`);

--
-- Indexes for table `st_payment_gateway_merchant`
--
ALTER TABLE `st_payment_gateway_merchant`
  ADD PRIMARY KEY (`id`),
  ADD KEY `payment_uuid` (`payment_uuid`),
  ADD KEY `merchant_id` (`merchant_id`),
  ADD KEY `payment_id` (`payment_id`),
  ADD KEY `payment_code` (`payment_code`),
  ADD KEY `status` (`status`);

--
-- Indexes for table `st_payment_method_meta`
--
ALTER TABLE `st_payment_method_meta`
  ADD PRIMARY KEY (`id`),
  ADD KEY `payment_method_id` (`payment_method_id`),
  ADD KEY `meta_name` (`meta_name`);

--
-- Indexes for table `st_plans`
--
ALTER TABLE `st_plans`
  ADD PRIMARY KEY (`package_id`),
  ADD KEY `status` (`status`),
  ADD KEY `package_uuid` (`package_uuid`),
  ADD KEY `plan_type` (`plan_type`);

--
-- Indexes for table `st_plans_invoice`
--
ALTER TABLE `st_plans_invoice`
  ADD PRIMARY KEY (`invoice_number`),
  ADD KEY `invoice_uuid` (`invoice_uuid`),
  ADD KEY `invoice_type` (`invoice_type`),
  ADD KEY `payment_code` (`payment_code`),
  ADD KEY `merchant_id` (`merchant_id`),
  ADD KEY `package_id` (`package_id`),
  ADD KEY `status` (`status`);

--
-- Indexes for table `st_plans_translation`
--
ALTER TABLE `st_plans_translation`
  ADD PRIMARY KEY (`id`),
  ADD KEY `package_id` (`package_id`),
  ADD KEY `language` (`language`);

--
-- Indexes for table `st_push`
--
ALTER TABLE `st_push`
  ADD PRIMARY KEY (`push_uuid`),
  ADD KEY `push_type` (`push_type`),
  ADD KEY `provider` (`provider`),
  ADD KEY `status` (`status`);

--
-- Indexes for table `st_review`
--
ALTER TABLE `st_review`
  ADD PRIMARY KEY (`id`),
  ADD KEY `client_id` (`client_id`),
  ADD KEY `merchant_id` (`merchant_id`),
  ADD KEY `rating` (`rating`),
  ADD KEY `status` (`status`),
  ADD KEY `parent_id` (`parent_id`);

--
-- Indexes for table `st_review_meta`
--
ALTER TABLE `st_review_meta`
  ADD PRIMARY KEY (`id`),
  ADD KEY `review_id` (`review_id`),
  ADD KEY `meta_name` (`meta_name`);

--
-- Indexes for table `st_role`
--
ALTER TABLE `st_role`
  ADD PRIMARY KEY (`role_id`),
  ADD KEY `role_type` (`role_type`),
  ADD KEY `merchant_id` (`merchant_id`);

--
-- Indexes for table `st_role_access`
--
ALTER TABLE `st_role_access`
  ADD PRIMARY KEY (`role_access_id`),
  ADD KEY `role_id` (`role_id`);

--
-- Indexes for table `st_services`
--
ALTER TABLE `st_services`
  ADD PRIMARY KEY (`service_id`),
  ADD KEY `service_code` (`service_code`),
  ADD KEY `status` (`status`);

--
-- Indexes for table `st_services_fee`
--
ALTER TABLE `st_services_fee`
  ADD PRIMARY KEY (`id`),
  ADD KEY `service_id` (`service_id`),
  ADD KEY `merchant_id` (`merchant_id`);

--
-- Indexes for table `st_services_translation`
--
ALTER TABLE `st_services_translation`
  ADD PRIMARY KEY (`id`),
  ADD KEY `service_id` (`service_id`),
  ADD KEY `language` (`language`);

--
-- Indexes for table `st_shipping_rate`
--
ALTER TABLE `st_shipping_rate`
  ADD PRIMARY KEY (`id`),
  ADD KEY `merchant_id` (`merchant_id`),
  ADD KEY `service_code` (`service_code`),
  ADD KEY `charge_type` (`charge_type`),
  ADD KEY `shipping_type` (`shipping_type`);

--
-- Indexes for table `st_size`
--
ALTER TABLE `st_size`
  ADD PRIMARY KEY (`size_id`),
  ADD KEY `merchant_id` (`merchant_id`),
  ADD KEY `size_name` (`size_name`),
  ADD KEY `status` (`status`);

--
-- Indexes for table `st_size_translation`
--
ALTER TABLE `st_size_translation`
  ADD PRIMARY KEY (`id`),
  ADD KEY `size_id` (`size_id`),
  ADD KEY `language` (`language`);

--
-- Indexes for table `st_sms_broadcast`
--
ALTER TABLE `st_sms_broadcast`
  ADD PRIMARY KEY (`broadcast_id`),
  ADD KEY `merchant_id` (`merchant_id`),
  ADD KEY `send_to` (`send_to`),
  ADD KEY `status` (`status`);

--
-- Indexes for table `st_sms_broadcast_details`
--
ALTER TABLE `st_sms_broadcast_details`
  ADD PRIMARY KEY (`id`),
  ADD KEY `merchant_id` (`merchant_id`),
  ADD KEY `broadcast_id` (`broadcast_id`),
  ADD KEY `client_id` (`client_id`),
  ADD KEY `status` (`status`),
  ADD KEY `gateway` (`gateway`);

--
-- Indexes for table `st_sms_provider`
--
ALTER TABLE `st_sms_provider`
  ADD PRIMARY KEY (`id`),
  ADD KEY `provider_id` (`provider_id`),
  ADD KEY `as_default` (`as_default`);

--
-- Indexes for table `st_status_management`
--
ALTER TABLE `st_status_management`
  ADD PRIMARY KEY (`status_id`),
  ADD KEY `group_name` (`group_name`),
  ADD KEY `status` (`status`);

--
-- Indexes for table `st_status_management_translation`
--
ALTER TABLE `st_status_management_translation`
  ADD PRIMARY KEY (`id`),
  ADD KEY `status_id` (`status_id`),
  ADD KEY `language` (`language`),
  ADD KEY `title` (`title`);

--
-- Indexes for table `st_subcategory`
--
ALTER TABLE `st_subcategory`
  ADD PRIMARY KEY (`subcat_id`),
  ADD KEY `merchant_id` (`merchant_id`),
  ADD KEY `subcategory_name` (`subcategory_name`),
  ADD KEY `status` (`status`);

--
-- Indexes for table `st_subcategory_item`
--
ALTER TABLE `st_subcategory_item`
  ADD PRIMARY KEY (`sub_item_id`),
  ADD KEY `merchant_id` (`merchant_id`),
  ADD KEY `sub_item_name` (`sub_item_name`),
  ADD KEY `status` (`status`);

--
-- Indexes for table `st_subcategory_item_relationships`
--
ALTER TABLE `st_subcategory_item_relationships`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sub_item_id` (`sub_item_id`),
  ADD KEY `subcat_id` (`subcat_id`);

--
-- Indexes for table `st_subcategory_item_translation`
--
ALTER TABLE `st_subcategory_item_translation`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sub_item_id` (`sub_item_id`),
  ADD KEY `language` (`language`);

--
-- Indexes for table `st_subcategory_translation`
--
ALTER TABLE `st_subcategory_translation`
  ADD PRIMARY KEY (`id`),
  ADD KEY `subcat_id` (`subcat_id`),
  ADD KEY `language` (`language`);

--
-- Indexes for table `st_tags`
--
ALTER TABLE `st_tags`
  ADD PRIMARY KEY (`tag_id`),
  ADD KEY `tag_name` (`tag_name`),
  ADD KEY `slug` (`slug`);

--
-- Indexes for table `st_tags_relationship`
--
ALTER TABLE `st_tags_relationship`
  ADD PRIMARY KEY (`id`),
  ADD KEY `banner_id` (`banner_id`),
  ADD KEY `tag_id` (`tag_id`);

--
-- Indexes for table `st_tags_translation`
--
ALTER TABLE `st_tags_translation`
  ADD PRIMARY KEY (`id`),
  ADD KEY `tag_id` (`tag_id`),
  ADD KEY `language` (`language`);

--
-- Indexes for table `st_tax`
--
ALTER TABLE `st_tax`
  ADD PRIMARY KEY (`tax_id`),
  ADD KEY `merchant_id` (`merchant_id`),
  ADD KEY `active` (`active`);

--
-- Indexes for table `st_templates`
--
ALTER TABLE `st_templates`
  ADD PRIMARY KEY (`template_id`),
  ADD KEY `template_key` (`template_key`),
  ADD KEY `enabled_email` (`enabled_email`),
  ADD KEY `enabled_sms` (`enabled_sms`),
  ADD KEY `enabled_push` (`enabled_push`);

--
-- Indexes for table `st_templates_translation`
--
ALTER TABLE `st_templates_translation`
  ADD PRIMARY KEY (`id`),
  ADD KEY `template_id` (`template_id`),
  ADD KEY `language` (`language`),
  ADD KEY `template_type` (`template_type`);

--
-- Indexes for table `st_voucher_new`
--
ALTER TABLE `st_voucher_new`
  ADD PRIMARY KEY (`voucher_id`),
  ADD KEY `voucher_name` (`voucher_name`),
  ADD KEY `status` (`status`),
  ADD KEY `voucher_owner` (`voucher_owner`),
  ADD KEY `merchant_id` (`merchant_id`),
  ADD KEY `voucher_type` (`voucher_type`);

--
-- Indexes for table `st_wallet_cards`
--
ALTER TABLE `st_wallet_cards`
  ADD PRIMARY KEY (`card_id`),
  ADD KEY `card_uuid` (`card_uuid`),
  ADD KEY `account_type` (`account_type`),
  ADD KEY `account_id` (`account_id`);

--
-- Indexes for table `st_wallet_transactions`
--
ALTER TABLE `st_wallet_transactions`
  ADD PRIMARY KEY (`transaction_id`),
  ADD KEY `card_id` (`card_id`),
  ADD KEY `transaction_uuid` (`transaction_uuid`),
  ADD KEY `transaction_type` (`transaction_type`),
  ADD KEY `status` (`status`);

--
-- Indexes for table `st_wallet_transactions_meta`
--
ALTER TABLE `st_wallet_transactions_meta`
  ADD PRIMARY KEY (`id`),
  ADD KEY `transaction_id` (`transaction_id`),
  ADD KEY `meta_name` (`meta_name`);

--
-- Indexes for table `st_zones`
--
ALTER TABLE `st_zones`
  ADD PRIMARY KEY (`zone_id`),
  ADD KEY `zone_name` (`zone_name`),
  ADD KEY `zone_uuid` (`zone_uuid`),
  ADD KEY `merchant_id` (`merchant_id`);

--
-- Indexes for table `st_subscriber`
--
ALTER TABLE `st_subscriber`
  ADD PRIMARY KEY (`id`),
  ADD KEY `email_address` (`email_address`),
  ADD KEY `merchant_id` (`merchant_id`),
  ADD KEY `subcsribe_type` (`subcsribe_type`);


ALTER TABLE `st_banner`
  ADD PRIMARY KEY (`banner_id`),
  ADD KEY `latitude` (`latitude`),
  ADD KEY `longitude` (`longitude`),
  ADD KEY `radius` (`radius`),
  ADD KEY `radius_unit` (`radius_unit`),
  ADD KEY `country_id` (`country_id`),
  ADD KEY `state_id` (`state_id`),
  ADD KEY `city_id` (`city_id`),
  ADD KEY `area_id` (`area_id`);

--
-- Indexes for table `st_addons`
--
ALTER TABLE `st_addons`
  ADD PRIMARY KEY (`id`);


ALTER TABLE `st_driver_activity`
  ADD PRIMARY KEY (`id`),
  ADD KEY `driver_id` (`driver_id`),
  ADD KEY `order_id` (`order_id`);

ALTER TABLE `st_bank_deposit`
  ADD PRIMARY KEY (`deposit_id`),
  ADD KEY `status` (`status`);


ALTER TABLE `st_driver_meta`
  ADD PRIMARY KEY (`meta_id`),
  ADD KEY `merchant_id` (`merchant_id`),
  ADD KEY `reference_id` (`reference_id`),
  ADD KEY `meta_name` (`meta_name`);

ALTER TABLE `st_printer_meta`
  ADD PRIMARY KEY (`id`),
  ADD KEY `printer_id` (`printer_id`);

ALTER TABLE `st_printer`
  ADD PRIMARY KEY (`printer_id`),
  ADD KEY `merchant_id` (`merchant_id`);

ALTER TABLE `st_invoice`
  ADD PRIMARY KEY (`invoice_number`),
  ADD KEY `invoice_token` (`invoice_uuid`),
  ADD KEY `merchant_id` (`merchant_id`),
  ADD KEY `date_from` (`date_from`),
  ADD KEY `date_to` (`date_to`),
  ADD KEY `invoice_total` (`invoice_total`),
  ADD KEY `invoice_terms` (`invoice_terms`);

ALTER TABLE `st_invoice_meta`
  ADD PRIMARY KEY (`id`),
  ADD KEY `invoice_number` (`invoice_number`);


ALTER TABLE `st_printer_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `order_id` (`order_id`),
  ADD KEY `merchant_id` (`merchant_id`),
  ADD KEY `printer_type` (`printer_type`),
  ADD KEY `status` (`status`);  

ALTER TABLE `st_table_reservation`
  ADD PRIMARY KEY (`reservation_id`),
  ADD KEY `merchant_id` (`merchant_id`),
  ADD KEY `reservation_date` (`reservation_date`),
  ADD KEY `table_id` (`table_id`),
  ADD KEY `guest_number` (`guest_number`),
  ADD KEY `status` (`status`);

ALTER TABLE `st_table_reservation_history`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `st_table_room`
  ADD PRIMARY KEY (`room_id`),
  ADD KEY `room_uuid` (`room_uuid`),
  ADD KEY `merchant_id` (`merchant_id`),
  ADD KEY `status` (`status`);

ALTER TABLE `st_table_shift`
  ADD PRIMARY KEY (`shift_id`),
  ADD UNIQUE KEY `shift_uuid` (`shift_uuid`),
  ADD KEY `merchant_id` (`merchant_id`),
  ADD KEY `status` (`status`);

ALTER TABLE `st_table_shift_days`
  ADD PRIMARY KEY (`id`),
  ADD KEY `merchant_id` (`merchant_id`),
  ADD KEY `shift_id` (`shift_id`),
  ADD KEY `day_of_week` (`day_of_week`);

ALTER TABLE `st_table_tables`
  ADD PRIMARY KEY (`table_id`),
  ADD KEY `merchant_id` (`merchant_id`),
  ADD KEY `room_id` (`room_id`),
  ADD KEY `min_covers` (`min_covers`),
  ADD KEY `max_covers` (`max_covers`),
  ADD KEY `available` (`available`),
  ADD KEY `status` (`status`);

ALTER TABLE `st_contact`
  ADD PRIMARY KEY (`id`);


ALTER TABLE `st_merchant_commission_order`
  ADD PRIMARY KEY (`id`),
  ADD KEY `merchant_id` (`merchant_id`),
  ADD KEY `transaction_type` (`transaction_type`);

ALTER TABLE `st_driver`
  ADD PRIMARY KEY (`driver_id`),
  ADD KEY `driver_uuid` (`driver_uuid`),
  ADD KEY `token` (`token`),
  ADD KEY `status` (`status`),
  ADD KEY `team_id` (`team_id`),
  ADD KEY `salary_type` (`salary_type`),
  ADD KEY `latitude` (`latitude`),
  ADD KEY `delivery_distance_covered` (`delivery_distance_covered`);


ALTER TABLE `st_driver_break`
  ADD PRIMARY KEY (`id`),
  ADD KEY `schedule_id` (`schedule_id`),
  ADD KEY `driver_id` (`driver_id`);  


ALTER TABLE `st_driver_collect_cash`
  ADD PRIMARY KEY (`collect_id`);


ALTER TABLE `st_driver_group`
  ADD PRIMARY KEY (`group_id`),
  ADD KEY `group_uuid` (`group_uuid`);


ALTER TABLE `st_driver_group_relations`
  ADD KEY `group_id` (`group_id`),
  ADD KEY `driver_id` (`driver_id`),
  ADD KEY `vehicle_id` (`vehicle_id`);

ALTER TABLE `st_driver_payment_method`
  ADD PRIMARY KEY (`payment_method_id`),
  ADD KEY `driver_id` (`driver_id`),
  ADD KEY `reference_id` (`reference_id`),
  ADD KEY `payment_uuid` (`payment_uuid`),
  ADD KEY `payment_code` (`payment_code`),
  ADD KEY `merchant_id` (`merchant_id`);

ALTER TABLE `st_driver_schedule`
  ADD PRIMARY KEY (`schedule_id`),
  ADD KEY `schedule_uuid` (`schedule_uuid`),
  ADD KEY `driver_id` (`driver_id`),
  ADD KEY `vehicle_id` (`vehicle_id`);

ALTER TABLE `st_driver_shift_schedule`
  ADD PRIMARY KEY (`shift_id`),
  ADD KEY `shift_uuid` (`shift_uuid`),
  ADD KEY `zone_id` (`zone_id`);


ALTER TABLE `st_driver_vehicle`
  ADD PRIMARY KEY (`vehicle_id`),
  ADD KEY `vehicle_uuid` (`vehicle_uuid`),
  ADD KEY `active` (`active`),
  ADD KEY `vehicle_type_id` (`vehicle_type_id`),
  ADD KEY `driver_id` (`driver_id`);


ALTER TABLE `st_currency_exchangerate`
  ADD PRIMARY KEY (`id`),
  ADD KEY `provider` (`provider`),
  ADD KEY `currency_code` (`currency_code`),
  ADD KEY `exchange_rate` (`exchange_rate`),
  ADD KEY `base_currency` (`base_currency`);


ALTER TABLE `st_paydelivery`
  ADD PRIMARY KEY (`id`),
  ADD KEY `payment_name` (`payment_name`),
  ADD KEY `status` (`status`);


ALTER TABLE `st_cron`
  ADD PRIMARY KEY (`cron_id`);


ALTER TABLE `st_discount`
  ADD PRIMARY KEY (`discount_id`);


ALTER TABLE `st_kitchen_order`
  ADD PRIMARY KEY (`kitchen_order_id`),
  ADD KEY `merchant_id` (`merchant_id`),
  ADD KEY `table_uuid` (`table_uuid`),
  ADD KEY `item_token` (`item_token`),
  ADD KEY `item_status` (`item_status`);


ALTER TABLE `st_customer_request`
  ADD PRIMARY KEY (`request_id`),
  ADD KEY `merchant_id` (`merchant_id`),
  ADD KEY `table_uuid` (`table_uuid`),
  ADD KEY `request_status` (`request_status`);


ALTER TABLE `st_table_status`
  ADD KEY `table_uuid` (`table_uuid`),
  ADD KEY `status` (`status`);


ALTER TABLE `st_table_device`
  ADD KEY `table_uuid` (`table_uuid`),
  ADD KEY `device_id` (`device_id`);


ALTER TABLE `st_plan_subscriptions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `subscriber_id` (`subscriber_id`),
  ADD KEY `subscriber_type` (`subscriber_type`),
  ADD KEY `package_id` (`package_id`),
  ADD KEY `subscription_id` (`subscription_id`),
  ADD KEY `status` (`status`);

ALTER TABLE `st_plans_create_payment`
  ADD PRIMARY KEY (`id`),
  ADD KEY `payment_id` (`payment_id`),
  ADD KEY `package_id` (`package_id`),
  ADD KEY `subscriber_id` (`subscriber_id`),
  ADD KEY `subscription_type` (`subscription_type`),
  ADD KEY `subscriber_type` (`subscriber_type`);

ALTER TABLE `st_plans_webhooks`
  ADD PRIMARY KEY (`event_id`);

ALTER TABLE `st_plans_customer`
  ADD PRIMARY KEY (`id`),
  ADD KEY `subscriber_id` (`subscriber_id`),
  ADD KEY `subscriber_type` (`subscriber_type`),
  ADD KEY `customer_id` (`customer_id`),
  ADD KEY `livemode` (`livemode`),
  ADD KEY `payment_code` (`payment_code`);

ALTER TABLE `st_merchant_location`
  ADD PRIMARY KEY (`id`),
  ADD KEY `merchant_id` (`merchant_id`),
  ADD KEY `country_id` (`country_id`),
  ADD KEY `state_id` (`state_id`),
  ADD KEY `city_id` (`city_id`),
  ADD KEY `area_id` (`area_id`);

ALTER TABLE `st_location_time_estimate`
  ADD PRIMARY KEY (`id`),
  ADD KEY `merchant_id` (`merchant_id`),
  ADD KEY `service_type` (`service_type`),
  ADD KEY `country_id` (`country_id`),
  ADD KEY `city_id` (`city_id`),
  ADD KEY `state_id` (`state_id`),
  ADD KEY `area_id` (`area_id`);

ALTER TABLE `st_job_queue`
  ADD PRIMARY KEY (`id`),
  ADD KEY `job_name` (`job_name`),
  ADD KEY `status` (`status`),
  ADD KEY `created_at` (`created_at`);
  

ALTER TABLE `st_kitchen_workload_settings`
  ADD PRIMARY KEY (`id`),
  ADD KEY `merchant_id` (`merchant_id`);

ALTER TABLE `st_driver_reviews`
  ADD PRIMARY KEY (`review_id`),
  ADD KEY `order_id` (`order_id`),
  ADD KEY `customer_id` (`customer_id`),
  ADD KEY `driver_id` (`driver_id`),
  ADD KEY `rating` (`rating`);


ALTER TABLE `st_custom_fields`
  ADD PRIMARY KEY (`field_id`);


ALTER TABLE `st_user_custom_field_values`
  ADD PRIMARY KEY (`value_id`);


ALTER TABLE `st_promos`
  ADD PRIMARY KEY (`promo_id`),
  ADD KEY `id` (`id`),
  ADD KEY `merchant_id` (`merchant_id`),
  ADD KEY `valid_from` (`valid_from`),
  ADD KEY `valid_to` (`valid_to`),
  ADD KEY `offer_type` (`offer_type`),
  ADD KEY `status` (`status`),
  ADD KEY `visible` (`visible`);  


ALTER TABLE `st_payment_reference`
  ADD PRIMARY KEY (`id`),
  ADD KEY `payment_type` (`payment_type`),
  ADD KEY `reference_id` (`reference_id`),
  ADD KEY `payment_reference_id` (`payment_reference_id`);  


ALTER TABLE `st_holidays`
  ADD PRIMARY KEY (`id`),
  ADD KEY `merchant_id` (`merchant_id`);


ALTER TABLE `st_driver_attempts`
  ADD PRIMARY KEY (`attempt_id`),
  ADD KEY `order_id` (`order_id`),
  ADD KEY `driver_id` (`driver_id`);

ALTER TABLE `st_suggested_items`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `st_item_free_promo`
  ADD PRIMARY KEY (`promo_id`),
  ADD KEY `merchant_id` (`merchant_id`),
  ADD KEY `free_item_id` (`free_item_id`),
  ADD KEY `status` (`status`);

ALTER TABLE `st_kot_tickets`
  ADD PRIMARY KEY (`kot_id`);


ALTER TABLE `st_kot_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_kot_items_item_id` (`order_item_id`),
  ADD KEY `fk_kot_items_kot_delete` (`kot_id`);

--
-- END OF ADD KEY
--  

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `st_admin_meta`
--
ALTER TABLE `st_admin_meta`
  MODIFY `meta_id` int(14) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=164;

--
-- AUTO_INCREMENT for table `st_admin_meta_translation`
--
ALTER TABLE `st_admin_meta_translation`
  MODIFY `id` int(14) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=55;

--
-- AUTO_INCREMENT for table `st_admin_user`
--
ALTER TABLE `st_admin_user`
  MODIFY `admin_id` int(14) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `st_availability`
--
ALTER TABLE `st_availability`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `st_cache`
--
ALTER TABLE `st_cache`
  MODIFY `id` int(14) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `st_cart`
--
ALTER TABLE `st_cart`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `st_cart_addons`
--
ALTER TABLE `st_cart_addons`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `st_cart_attributes`
--
ALTER TABLE `st_cart_attributes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `st_category`
--
ALTER TABLE `st_category`
  MODIFY `cat_id` int(14) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `st_category_relationship_dish`
--
ALTER TABLE `st_category_relationship_dish`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `st_category_translation`
--
ALTER TABLE `st_category_translation`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `st_client`
--
ALTER TABLE `st_client`
  MODIFY `client_id` int(14) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `st_client_address`
--
ALTER TABLE `st_client_address`
  MODIFY `address_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `st_client_cc`
--
ALTER TABLE `st_client_cc`
  MODIFY `cc_id` int(14) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `st_client_meta`
--
ALTER TABLE `st_client_meta`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `st_client_payment_method`
--
ALTER TABLE `st_client_payment_method`
  MODIFY `payment_method_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `st_cooking_ref`
--
ALTER TABLE `st_cooking_ref`
  MODIFY `cook_id` int(14) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `st_cooking_ref_translation`
--
ALTER TABLE `st_cooking_ref_translation`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `st_cuisine`
--
ALTER TABLE `st_cuisine`
  MODIFY `cuisine_id` int(14) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT for table `st_cuisine_merchant`
--
ALTER TABLE `st_cuisine_merchant`
  MODIFY `id` int(14) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `st_cuisine_translation`
--
ALTER TABLE `st_cuisine_translation`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=124;

--
-- AUTO_INCREMENT for table `st_currency`
--
ALTER TABLE `st_currency`
  MODIFY `id` int(14) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=44;

--
-- AUTO_INCREMENT for table `st_device`
--
ALTER TABLE `st_device`
  MODIFY `device_id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `st_device_meta`
--
ALTER TABLE `st_device_meta`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `st_dishes`
--
ALTER TABLE `st_dishes`
  MODIFY `dish_id` int(14) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `st_dishes_translation`
--
ALTER TABLE `st_dishes_translation`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `st_email_logs`
--
ALTER TABLE `st_email_logs`
  MODIFY `id` int(14) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `st_email_provider`
--
ALTER TABLE `st_email_provider`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `st_favorites`
--
ALTER TABLE `st_favorites`
  MODIFY `id` int(14) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `st_featured_location`
--
ALTER TABLE `st_featured_location`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `st_gpdr_request`
--
ALTER TABLE `st_gpdr_request`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `st_ingredients`
--
ALTER TABLE `st_ingredients`
  MODIFY `ingredients_id` int(14) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `st_ingredients_translation`
--
ALTER TABLE `st_ingredients_translation`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `st_inventory_supplier`
--
ALTER TABLE `st_inventory_supplier`
  MODIFY `supplier_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `st_item`
--
ALTER TABLE `st_item`
  MODIFY `item_id` int(14) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `st_item_meta`
--
ALTER TABLE `st_item_meta`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `st_item_promo`
--
ALTER TABLE `st_item_promo`
  MODIFY `promo_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `st_item_relationship_category`
--
ALTER TABLE `st_item_relationship_category`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `st_item_relationship_size`
--
ALTER TABLE `st_item_relationship_size`
  MODIFY `item_size_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `st_item_relationship_subcategory`
--
ALTER TABLE `st_item_relationship_subcategory`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `st_item_relationship_subcategory_item`
--
ALTER TABLE `st_item_relationship_subcategory_item`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `st_item_translation`
--
ALTER TABLE `st_item_translation`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `st_language`
--
ALTER TABLE `st_language`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `st_location_area`
--
ALTER TABLE `st_location_area`
  MODIFY `area_id` int(14) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `st_location_cities`
--
ALTER TABLE `st_location_cities`
  MODIFY `city_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `st_location_countries`
--
ALTER TABLE `st_location_countries`
  MODIFY `country_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=247;

--
-- AUTO_INCREMENT for table `st_location_rate`
--
ALTER TABLE `st_location_rate`
  MODIFY `rate_id` int(14) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `st_location_states`
--
ALTER TABLE `st_location_states`
  MODIFY `state_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `st_map_places`
--
ALTER TABLE `st_map_places`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `st_media_files`
--
ALTER TABLE `st_media_files`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `st_menu`
--
ALTER TABLE `st_menu`
  MODIFY `menu_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=373;

--
-- AUTO_INCREMENT for table `st_merchant`
--
ALTER TABLE `st_merchant`
  MODIFY `merchant_id` int(14) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `st_merchant_meta`
--
ALTER TABLE `st_merchant_meta`
  MODIFY `meta_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `st_merchant_payment_method`
--
ALTER TABLE `st_merchant_payment_method`
  MODIFY `payment_method_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `st_merchant_type`
--
ALTER TABLE `st_merchant_type`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `st_merchant_type_translation`
--
ALTER TABLE `st_merchant_type_translation`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `st_merchant_user`
--
ALTER TABLE `st_merchant_user`
  MODIFY `merchant_user_id` int(14) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `st_offers`
--
ALTER TABLE `st_offers`
  MODIFY `offers_id` int(14) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `st_opening_hours`
--
ALTER TABLE `st_opening_hours`
  MODIFY `id` int(14) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `st_option`
--
ALTER TABLE `st_option`
  MODIFY `id` int(14) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=122;

--
-- AUTO_INCREMENT for table `st_ordernew`
--
ALTER TABLE `st_ordernew`
  MODIFY `order_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `st_ordernew_additional_charge`
--
ALTER TABLE `st_ordernew_additional_charge`
  MODIFY `id` int(14) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `st_ordernew_addons`
--
ALTER TABLE `st_ordernew_addons`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `st_ordernew_attributes`
--
ALTER TABLE `st_ordernew_attributes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `st_ordernew_history`
--
ALTER TABLE `st_ordernew_history`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `st_ordernew_item`
--
ALTER TABLE `st_ordernew_item`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `st_ordernew_meta`
--
ALTER TABLE `st_ordernew_meta`
  MODIFY `meta_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `st_ordernew_summary_transaction`
--
ALTER TABLE `st_ordernew_summary_transaction`
  MODIFY `transaction_id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `st_ordernew_transaction`
--
ALTER TABLE `st_ordernew_transaction`
  MODIFY `transaction_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `st_ordernew_trans_meta`
--
ALTER TABLE `st_ordernew_trans_meta`
  MODIFY `meta_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `st_order_settings_buttons`
--
ALTER TABLE `st_order_settings_buttons`
  MODIFY `id` int(14) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `st_order_settings_tabs`
--
ALTER TABLE `st_order_settings_tabs`
  MODIFY `id` int(14) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `st_order_status`
--
ALTER TABLE `st_order_status`
  MODIFY `stats_id` int(14) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- AUTO_INCREMENT for table `st_order_status_actions`
--
ALTER TABLE `st_order_status_actions`
  MODIFY `action_id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `st_order_status_translation`
--
ALTER TABLE `st_order_status_translation`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=34;

--
-- AUTO_INCREMENT for table `st_order_time_management`
--
ALTER TABLE `st_order_time_management`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `st_package_details`
--
ALTER TABLE `st_package_details`
  MODIFY `id` int(14) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `st_pages`
--
ALTER TABLE `st_pages`
  MODIFY `page_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `st_pages_translation`
--
ALTER TABLE `st_pages_translation`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `st_payment_gateway`
--
ALTER TABLE `st_payment_gateway`
  MODIFY `payment_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `st_payment_gateway_merchant`
--
ALTER TABLE `st_payment_gateway_merchant`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `st_payment_method_meta`
--
ALTER TABLE `st_payment_method_meta`
  MODIFY `id` bigint(14) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `st_plans`
--
ALTER TABLE `st_plans`
  MODIFY `package_id` int(14) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `st_plans_invoice`
--
ALTER TABLE `st_plans_invoice`
  MODIFY `invoice_number` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `st_plans_translation`
--
ALTER TABLE `st_plans_translation`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `st_review`
--
ALTER TABLE `st_review`
  MODIFY `id` int(14) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `st_review_meta`
--
ALTER TABLE `st_review_meta`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `st_role`
--
ALTER TABLE `st_role`
  MODIFY `role_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `st_role_access`
--
ALTER TABLE `st_role_access`
  MODIFY `role_access_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `st_services`
--
ALTER TABLE `st_services`
  MODIFY `service_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `st_services_fee`
--
ALTER TABLE `st_services_fee`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `st_services_translation`
--
ALTER TABLE `st_services_translation`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;

--
-- AUTO_INCREMENT for table `st_shipping_rate`
--
ALTER TABLE `st_shipping_rate`
  MODIFY `id` int(14) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `st_size`
--
ALTER TABLE `st_size`
  MODIFY `size_id` int(14) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `st_size_translation`
--
ALTER TABLE `st_size_translation`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `st_sms_broadcast`
--
ALTER TABLE `st_sms_broadcast`
  MODIFY `broadcast_id` int(14) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `st_sms_broadcast_details`
--
ALTER TABLE `st_sms_broadcast_details`
  MODIFY `id` int(14) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `st_sms_provider`
--
ALTER TABLE `st_sms_provider`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `st_status_management`
--
ALTER TABLE `st_status_management`
  MODIFY `status_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT for table `st_status_management_translation`
--
ALTER TABLE `st_status_management_translation`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=64;

--
-- AUTO_INCREMENT for table `st_subcategory`
--
ALTER TABLE `st_subcategory`
  MODIFY `subcat_id` int(14) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `st_subcategory_item`
--
ALTER TABLE `st_subcategory_item`
  MODIFY `sub_item_id` int(14) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `st_subcategory_item_relationships`
--
ALTER TABLE `st_subcategory_item_relationships`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `st_subcategory_item_translation`
--
ALTER TABLE `st_subcategory_item_translation`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `st_subcategory_translation`
--
ALTER TABLE `st_subcategory_translation`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `st_tags`
--
ALTER TABLE `st_tags`
  MODIFY `tag_id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `st_tags_relationship`
--
ALTER TABLE `st_tags_relationship`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `st_tags_translation`
--
ALTER TABLE `st_tags_translation`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `st_tax`
--
ALTER TABLE `st_tax`
  MODIFY `tax_id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `st_templates`
--
ALTER TABLE `st_templates`
  MODIFY `template_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

--
-- AUTO_INCREMENT for table `st_templates_translation`
--
ALTER TABLE `st_templates_translation`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2386;

--
-- AUTO_INCREMENT for table `st_voucher_new`
--
ALTER TABLE `st_voucher_new`
  MODIFY `voucher_id` int(14) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `st_wallet_cards`
--
ALTER TABLE `st_wallet_cards`
  MODIFY `card_id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `st_wallet_transactions`
--
ALTER TABLE `st_wallet_transactions`
  MODIFY `transaction_id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `st_wallet_transactions_meta`
--
ALTER TABLE `st_wallet_transactions_meta`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `st_zones`
--
ALTER TABLE `st_zones`
  MODIFY `zone_id` bigint(20) NOT NULL AUTO_INCREMENT;


--
ALTER TABLE `st_message`
  ADD PRIMARY KEY (`id`,`language`);

--
-- Indexes for table `st_sourcemessage`
--
ALTER TABLE `st_sourcemessage`
  ADD PRIMARY KEY (`id`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `st_message`
--
ALTER TABLE `st_message`
  ADD CONSTRAINT `FK_Message_SourceMessage` FOREIGN KEY (`id`) REFERENCES `st_sourcemessage` (`id`) ON DELETE CASCADE;

ALTER TABLE `st_subscriber`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;  


ALTER TABLE `st_banner`
  MODIFY `banner_id` int(14) NOT NULL AUTO_INCREMENT; 

--
-- AUTO_INCREMENT for table `st_addons`
--
ALTER TABLE `st_addons`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;   

ALTER TABLE `st_driver_activity`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;  

ALTER TABLE `st_bank_deposit`
  MODIFY `deposit_id` bigint(20) NOT NULL AUTO_INCREMENT;  


ALTER TABLE `st_driver_meta`
  MODIFY `meta_id` bigint(20) NOT NULL AUTO_INCREMENT;  

ALTER TABLE `st_printer_meta`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `st_printer`
  MODIFY `printer_id` int(11) NOT NULL AUTO_INCREMENT;  

ALTER TABLE `st_invoice`
  MODIFY `invoice_number` int(14) NOT NULL AUTO_INCREMENT;  

ALTER TABLE `st_invoice_meta`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

ALTER TABLE `st_printer_logs`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;  

ALTER TABLE `st_table_reservation`
  MODIFY `reservation_id` bigint(20) NOT NULL AUTO_INCREMENT;  

ALTER TABLE `st_table_reservation` AUTO_INCREMENT = 10000;  

ALTER TABLE `st_table_reservation_history`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

ALTER TABLE `st_table_room`
  MODIFY `room_id` int(14) NOT NULL AUTO_INCREMENT;  

ALTER TABLE `st_table_shift`
  MODIFY `shift_id` int(14) NOT NULL AUTO_INCREMENT;  

ALTER TABLE `st_table_shift_days`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;  

ALTER TABLE `st_table_tables`
  MODIFY `table_id` int(14) NOT NULL AUTO_INCREMENT;  

ALTER TABLE `st_contact`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

ALTER TABLE `st_merchant_commission_order`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;  

ALTER TABLE `st_driver`
  MODIFY `driver_id` bigint(20) NOT NULL AUTO_INCREMENT;  
  
ALTER TABLE `st_driver_break`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

ALTER TABLE `st_driver_collect_cash`
  MODIFY `collect_id` bigint(20) NOT NULL AUTO_INCREMENT;


ALTER TABLE `st_driver_group`
  MODIFY `group_id` bigint(20) NOT NULL AUTO_INCREMENT;

ALTER TABLE `st_driver_payment_method`
  MODIFY `payment_method_id` int(11) NOT NULL AUTO_INCREMENT;  

ALTER TABLE `st_driver_schedule`
  MODIFY `schedule_id` bigint(20) NOT NULL AUTO_INCREMENT;

ALTER TABLE `st_driver_shift_schedule`
  MODIFY `shift_id` bigint(20) NOT NULL AUTO_INCREMENT;  

ALTER TABLE `st_driver_vehicle`
  MODIFY `vehicle_id` bigint(20) NOT NULL AUTO_INCREMENT;  

ALTER TABLE `st_currency_exchangerate`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;  

ALTER TABLE `st_paydelivery`
  MODIFY `id` int(14) NOT NULL AUTO_INCREMENT;  

ALTER TABLE `st_cron`
  MODIFY `cron_id` bigint(20) NOT NULL AUTO_INCREMENT;  

ALTER TABLE `st_discount`
  MODIFY `discount_id` int(11) NOT NULL AUTO_INCREMENT;  

ALTER TABLE `st_kitchen_order`
  MODIFY `kitchen_order_id` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `st_customer_request`
  MODIFY `request_id` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `st_plan_subscriptions`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT;

ALTER TABLE `st_plans_create_payment`
  MODIFY `id` int(14) NOT NULL AUTO_INCREMENT;

ALTER TABLE `st_plans_webhooks`
  MODIFY `event_id` int(10) NOT NULL AUTO_INCREMENT;  

ALTER TABLE `st_plans_customer`
  MODIFY `id` int(14) NOT NULL AUTO_INCREMENT;  

ALTER TABLE `st_merchant_location`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;  

ALTER TABLE `st_location_time_estimate`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;


ALTER TABLE `st_job_queue`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;


ALTER TABLE `st_kitchen_workload_settings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;  

ALTER TABLE `st_driver_reviews`
  MODIFY `review_id` int(11) NOT NULL AUTO_INCREMENT;  


ALTER TABLE `st_custom_fields`
  MODIFY `field_id` int(11) NOT NULL AUTO_INCREMENT;  


ALTER TABLE `st_user_custom_field_values`
  MODIFY `value_id` int(11) NOT NULL AUTO_INCREMENT;


ALTER TABLE `st_promos`
  MODIFY `promo_id` int(11) NOT NULL AUTO_INCREMENT;  

ALTER TABLE `st_payment_reference`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;  

ALTER TABLE `st_holidays`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;


ALTER TABLE `st_driver_attempts`
  MODIFY `attempt_id` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `st_suggested_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;  

ALTER TABLE `st_item_free_promo`
  MODIFY `promo_id` int(11) NOT NULL AUTO_INCREMENT;  

ALTER TABLE `st_kot_tickets`
  MODIFY `kot_id` int(11) NOT NULL AUTO_INCREMENT;


ALTER TABLE `st_kot_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;  

-- END OF auto increment

ALTER TABLE st_merchant_meta ADD FULLTEXT(meta_value);
ALTER TABLE st_merchant_meta ADD FULLTEXT(meta_value1);
ALTER TABLE st_merchant_meta ADD FULLTEXT(meta_value2);
ALTER TABLE st_merchant_meta ADD FULLTEXT(meta_value3);

ALTER TABLE st_option ADD FULLTEXT(option_value);

ALTER TABLE `st_item` ADD INDEX(`available`);
ALTER TABLE `st_item` ADD INDEX(`available_at_specific`);
ALTER TABLE `st_item` ADD INDEX(`visible`);
ALTER TABLE `st_item` ADD INDEX(`not_for_sale`);
ALTER TABLE `st_item` ADD INDEX(`item_token`);
ALTER TABLE `st_item` ADD INDEX(`sequence`);
ALTER TABLE `st_item` ADD INDEX(`points_enabled`);  

ALTER TABLE `st_ordernew` ADD INDEX(`created_at`);  

ALTER TABLE `st_cache` ADD INDEX(`date_modified`);


ALTER TABLE `st_kot_items`
  ADD CONSTRAINT `fk_kot_items_kot_delete` FOREIGN KEY (`kot_id`) REFERENCES `st_kot_tickets` (`kot_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_kot_items_kot_id` FOREIGN KEY (`kot_id`) REFERENCES `st_kot_tickets` (`kot_id`);

COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
