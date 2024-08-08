-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jan 31, 2023 at 10:37 AM
-- Server version: 10.4.25-MariaDB
-- PHP Version: 8.1.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `ebillsystem`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `unitstoamount` (IN `units` INT(14), OUT `result` INT(14))   BEGIN
   
    DECLARE a INT(14) DEFAULT 0;
    DECLARE b INT(14) DEFAULT 0;
    DECLARE c INT(14) DEFAULT 0;

    SELECT twohundred FROM unitsRate INTO a ;
    SELECT fivehundred FROM unitsRate INTO b ;
    SELECT thousand FROM unitsRate INTO c  ;

    IF units<200
    then
        SELECT a*units INTO result;
    
    ELSEIF units<500
    then
        SELECT (a*200)+(b*(units-200)) INTO result;
    ELSEIF units > 500
    then
        SELECT (a*200)+(b*(300))+(c*(units-500)) INTO result;
    END IF;

END$$

--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `curdate1` () RETURNS INT(11)  BEGIN
    DECLARE x INT;
    SET x = DAYOFMONTH(CURDATE());
    IF (x=1)
    THEN
        RETURN 1;
    ELSE
        RETURN 0;
    END IF;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `admin`
--

CREATE TABLE `admin` (
  `id` int(14) NOT NULL,
  `name` varchar(40) NOT NULL,
  `email` varchar(40) NOT NULL,
  `pass` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `admin`
--

INSERT INTO `admin` (`id`, `name`, `email`, `pass`) VALUES
(1, 'Administrator One', 'admin@gmail.com', 'Password@123');

-- --------------------------------------------------------

--
-- Table structure for table `bill`
--

CREATE TABLE `bill` (
  `id` int(14) NOT NULL,
  `aid` int(14) NOT NULL,
  `uid` int(14) NOT NULL,
  `units` int(10) NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `status` varchar(10) NOT NULL,
  `bdate` date NOT NULL,
  `ddate` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `bill`
--

INSERT INTO `bill` (`id`, `aid`, `uid`, `units`, `amount`, `status`, `bdate`, `ddate`) VALUES
(27, 1, 21, 550, '2400.00', 'PROCESSED', '2023-01-31', '2023-03-02'),
(28, 1, 23, 234, '570.00', 'PENDING', '2022-12-26', '2023-01-27'),
(29, 1, 28, 390, '1350.00', 'PROCESSED', '2022-11-03', '2022-12-04'),
(30, 1, 24, 234, '570.00', 'PENDING', '2023-01-31', '2023-03-02'),
(31, 1, 25, 200, '400.00', 'PENDING', '2022-11-30', '2022-12-31'),
(32, 1, 33, 660, '3500.00', 'PENDING', '2023-01-31', '2023-03-02'),
(33, 1, 31, 550, '2400.00', 'PROCESSED', '2023-01-31', '2023-03-02'),
(34, 1, 29, 339, '1095.00', 'PROCESSED', '2023-01-31', '2023-03-02'),
(35, 1, 36, 338, '1090.00', 'PENDING', '2023-01-31', '2023-03-02'),
(36, 1, 34, 111, '222.00', 'PROCESSED', '2023-01-31', '2023-03-02');

--
-- Triggers `bill`
--
DELIMITER $$
CREATE TRIGGER `billBackup` AFTER DELETE ON `bill` FOR EACH ROW INSERT INTO billbackup VALUES (null, CONCAT('Bill no- ', old.id, ' has been deleted on ', CURRENT_DATE, '(', old.uid,' ', old.units,' ' ,old.amount, ')') )
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `billbackup`
--

CREATE TABLE `billbackup` (
  `id` int(11) NOT NULL,
  `Record` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `billbackup`
--

INSERT INTO `billbackup` (`id`, `Record`) VALUES
(2, 'Bill no- 18 has been deleted on 2023-01-31(1 61 122.00)');

-- --------------------------------------------------------

--
-- Table structure for table `complaint`
--

CREATE TABLE `complaint` (
  `id` int(14) NOT NULL,
  `uid` int(14) NOT NULL,
  `aid` int(14) NOT NULL,
  `complaint` varchar(140) NOT NULL,
  `status` varchar(40) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `complaint`
--

INSERT INTO `complaint` (`id`, `uid`, `aid`, `complaint`, `status`) VALUES
(20, 34, 1, 'Bill Generated Late', 'NOT PROCESSED'),
(21, 29, 1, 'Bill Generated Late', 'PROCESSED'),
(22, 33, 1, 'Bill Not Correct', 'NOT PROCESSED');

-- --------------------------------------------------------

--
-- Table structure for table `transaction`
--

CREATE TABLE `transaction` (
  `id` int(14) NOT NULL,
  `bid` int(14) NOT NULL,
  `payable` decimal(10,2) NOT NULL,
  `pdate` date DEFAULT NULL,
  `status` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `transaction`
--

INSERT INTO `transaction` (`id`, `bid`, `payable`, `pdate`, `status`) VALUES
(27, 27, '2400.00', '2023-01-31', 'PROCESSED'),
(28, 28, '570.00', NULL, 'PENDING'),
(29, 29, '1350.00', '2023-01-31', 'PROCESSED'),
(30, 30, '570.00', NULL, 'PENDING'),
(31, 31, '400.00', NULL, 'PENDING'),
(32, 32, '3500.00', NULL, 'PENDING'),
(33, 33, '2400.00', '2023-01-31', 'PROCESSED'),
(34, 34, '1095.00', '2023-01-31', 'PROCESSED'),
(35, 35, '1090.00', NULL, 'PENDING'),
(36, 36, '222.00', '2023-01-31', 'PROCESSED');

-- --------------------------------------------------------

--
-- Table structure for table `unitsrate`
--

CREATE TABLE `unitsrate` (
  `sno` int(1) DEFAULT NULL,
  `twohundred` int(14) NOT NULL,
  `fivehundred` int(14) NOT NULL,
  `thousand` int(14) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `unitsrate`
--

INSERT INTO `unitsrate` (`sno`, `twohundred`, `fivehundred`, `thousand`) VALUES
(1, 2, 5, 10);

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `id` int(14) NOT NULL,
  `name` varchar(40) NOT NULL,
  `email` varchar(40) NOT NULL,
  `phone` varchar(255) NOT NULL,
  `pass` varchar(255) NOT NULL,
  `address` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`id`, `name`, `email`, `phone`, `pass`, `address`) VALUES
(21, 'Krishna', 'krish@gmail.com', '5555555555', '$2y$10$itM23gSR5YearpuOD4lcAejiazk/ndQltOULK17QaN4818KAZ4H/a', 'sirsi'),
(22, 'Tanvi p', 'tanvi@gmail.com', '3333333333', '$2y$10$6nEk79RW8LOs5U60q2/uO..L.rJ4wVMA9hGQ3FUPd7ypv3PouIsme', 'ujire'),
(23, 'Vaishnavi r', 'vaishnavir@gmail.com', '9878678767', '$2y$10$F0OxdUj/uu/MXtKHbgjSXecK1ejK8LH/O9OoYDxG6t7ui1bCxaYou', 'sagara'),
(24, 'Shrutha V W', 'shrutha@gmail.com', '9878675676', '$2y$10$ot167RQiG1.T4RYRhA4mme4vI30CFR9mPSEbBflfeoqbx2xJOOcli', 'hubli'),
(25, 'Abhi', 'abhi@gmail.com', '8877889966', '$2y$10$5IxVW5/ZeUGfne8I3QHx0.WOpRnSJqeR/MoMuMlWXmM1OOfd/hdxe', 'hubli'),
(26, 'Vinay', 'vi@gmail.com', '6677889988', '$2y$10$M07ea1K89rgjfpfIrE6ZielayZNwCRDRW8i2JZmBapb3sALKJkhkK', 'sagara'),
(27, 'Ram', 'ram@gmail.com', '6677554466', '$2y$10$UU6xORmIi8FkQoUYGIHnB.SsaHwT2r0pVPaIuCdEk7qYXE1HWpFnW', 'sirsi'),
(28, 'Dimple', 'dimp@gmail.com', '9889899889', '$2y$10$aH.Wv6rFJnzpc39DXRTX1ufqXO05gSEazBijmSGYvy8OAlEbHS.Ce', 'sirsi'),
(29, 'Vidya', 'vidya@gmail.com', '9889988998', '$2y$10$vNwUBr6VOLFJAjLIatklPutXhCeEIhr7M71kW8xwldXNhb/ESDkva', 'ujire'),
(30, 'Anu', 'anu@gmail.com', '9878968576', '$2y$10$8k9pgg/0pGo3gLmsYfQF9.WGbPdIdWgh5j3QUdPhrrG.YETKgkpqG', 'ujire'),
(31, 'Varun', 'varun@gmail.com', '8898867354', '$2y$10$MY767kZw6e4XJO1SDV5nqeQIpTdrwxOBIVsseDm7BPajjzbhAmeYC', 'hubli'),
(32, 'Swati', 's@gmail.com', '91192092387', '$2y$10$iyrW0YiUfqSUsCGZAHU/F..23wrCaWBmXzTRwQTRXolrpI/o97MJG', 'ujire'),
(33, 'Rishi', 'rishi@gmail.com', '9449892855', '$2y$10$r75O0cQQoew40imE9XBTEusgsTocXTu9uAm/q5QIZpUlnWX6b3v9C', 'sirsi'),
(34, 'pramya', 'pra@gmail.com', '9119201223', '$2y$10$EnxuJXoUJa60kOTTJjkt9uRB3KZFPB0EbCFj35iGw37qGmEaT2oXy', 'ujire'),
(35, 'aditya', 'adi@gmail.com', '91192092387', '$2y$10$SbGXdQu4oEMd6/plbflUtOWdc89FBpOyLU7ShUGvDVMtdo5FmS9vK', 'ujire'),
(36, 'Smitha', 'sm@gmail.com', '9113943894', '$2y$10$7JLV0bxUvBZpT3StE0PFb.yC12zfLQpv0e9sxOaKyX7RrxnlzSL3S', 'sirsi'),
(37, 'Srujan', 'sruja@gmail.com', '1234567899', '$2y$10$IPO3SqlHo2x5EbIPN2S/r.ELrIMwUn3MQ6dVkvS6Cj25yUjfi3Qvu', 'ujire');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admin`
--
ALTER TABLE `admin`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `bill`
--
ALTER TABLE `bill`
  ADD PRIMARY KEY (`id`),
  ADD KEY `aid` (`aid`),
  ADD KEY `uid` (`uid`);

--
-- Indexes for table `billbackup`
--
ALTER TABLE `billbackup`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `complaint`
--
ALTER TABLE `complaint`
  ADD PRIMARY KEY (`id`),
  ADD KEY `aid` (`aid`),
  ADD KEY `uid` (`uid`);

--
-- Indexes for table `transaction`
--
ALTER TABLE `transaction`
  ADD PRIMARY KEY (`id`),
  ADD KEY `bid` (`bid`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `admin`
--
ALTER TABLE `admin`
  MODIFY `id` int(14) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `bill`
--
ALTER TABLE `bill`
  MODIFY `id` int(14) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=37;

--
-- AUTO_INCREMENT for table `billbackup`
--
ALTER TABLE `billbackup`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `complaint`
--
ALTER TABLE `complaint`
  MODIFY `id` int(14) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT for table `transaction`
--
ALTER TABLE `transaction`
  MODIFY `id` int(14) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=37;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `id` int(14) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=38;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `bill`
--
ALTER TABLE `bill`
  ADD CONSTRAINT `bill_ibfk_1` FOREIGN KEY (`aid`) REFERENCES `admin` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `bill_ibfk_2` FOREIGN KEY (`uid`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `complaint`
--
ALTER TABLE `complaint`
  ADD CONSTRAINT `complaint_ibfk_1` FOREIGN KEY (`aid`) REFERENCES `admin` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `complaint_ibfk_2` FOREIGN KEY (`uid`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `transaction`
--
ALTER TABLE `transaction`
  ADD CONSTRAINT `transaction_ibfk_1` FOREIGN KEY (`bid`) REFERENCES `bill` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
