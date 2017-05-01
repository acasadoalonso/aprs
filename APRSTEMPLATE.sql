-- phpMyAdmin SQL Dump
-- version 4.5.4.1deb2ubuntu2
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Apr 10, 2017 at 07:11 AM
-- Server version: 5.7.17-0ubuntu0.16.04.1
-- PHP Version: 7.0.15-0ubuntu0.16.04.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `APRSLOG`
--

DELIMITER $$
--
-- Functions
--
DROP FUNCTION IF EXISTS `GETBEARING`$$
CREATE DEFINER=`ogn`@`%` FUNCTION `GETBEARING` (`lat1` DOUBLE, `lon1` DOUBLE, `lat2` DOUBLE, `lon2` DOUBLE) RETURNS DOUBLE NO SQL
    DETERMINISTIC
    COMMENT 'Returns the initial bearing, in degrees, to follow the great circle route             from point (lat1,lon1), to point (lat2,lon2)'
BEGIN
	DECLARE bearing FLOAT;
    SET bearing= (360.0 + 
      DEGREES(ATAN2(
       SIN(RADIANS(lon2-lon1))*COS(RADIANS(lat2)),
       COS(RADIANS(lat1))*SIN(RADIANS(lat2))-SIN(RADIANS(lat1))*COS(RADIANS(lat2))*
            COS(RADIANS(lon2-lon1))
      ))
     ) % 360.0;
     RETURN bearing;
END$$

DROP FUNCTION IF EXISTS `GETBEARINGROSE`$$
CREATE DEFINER=`ogn`@`%` FUNCTION `GETBEARINGROSE` (`lat1` DOUBLE, `lon1` DOUBLE, `lat2` DOUBLE, `lon2` DOUBLE) RETURNS VARCHAR(5) CHARSET utf8 NO SQL
    DETERMINISTIC
    COMMENT 'Returns the initial bearing, in degrees, to follow the great circle route             from point (lat1,lon1), to point (lat2,lon2)'
BEGIN
	DECLARE bearing FLOAT;
	DECLARE bearingRose VARCHAR(5);
    SET bearing= (360.0 + 
      DEGREES(ATAN2(
       SIN(RADIANS(lon2-lon1))*COS(RADIANS(lat2)),
       COS(RADIANS(lat1))*SIN(RADIANS(lat2))-SIN(RADIANS(lat1))*COS(RADIANS(lat2))*
            COS(RADIANS(lon2-lon1))
      ))
     ) % 360.0;
     SET bearingRose='N';
     IF bearing>=0 AND bearing<11.5 THEN SET bearingRose='N';
     ELSEIF bearing>=11.5 AND bearing<34 THEN SET bearingRose='NNE';
     ELSEIF bearing>=34 AND bearing<56.5 THEN SET bearingRose='NE';
     ELSEIF bearing>=56.5 AND bearing<79 THEN SET bearingRose='ENE';
     ELSEIF bearing>=79 AND bearing<101.5 THEN SET bearingRose='E';
     ELSEIF bearing>=101.5 AND bearing<124 THEN SET bearingRose='ESE';
     ELSEIF bearing>=124 AND bearing<146.5 THEN SET bearingRose='SE';
     ELSEIF bearing>=146.5 AND bearing<169 THEN SET bearingRose='SSE';
     ELSEIF bearing>=169 AND bearing<191.5 THEN SET bearingRose='S';
     ELSEIF bearing>=191.5 AND bearing<214 THEN SET bearingRose='SSW';
     ELSEIF bearing>=214 AND bearing<236.5 THEN SET bearingRose='SW';
     ELSEIF bearing>=236.5 AND bearing<259 THEN SET bearingRose='WSW';
     ELSEIF bearing>=259 AND bearing<281.5 THEN SET bearingRose='W';
     ELSEIF bearing>=281.5 AND bearing<304 THEN SET bearingRose='WNW';
     ELSEIF bearing>=304 AND bearing<326.5 THEN SET bearingRose='NW';
     ELSEIF bearing>=326.5 AND bearing<349 THEN SET bearingRose='NNW';
     ELSE SET bearingRose='N';
     END IF;
     
     RETURN bearingRose;
END$$

DROP FUNCTION IF EXISTS `GETDISTANCE`$$
CREATE DEFINER=`ogn`@`%` FUNCTION `GETDISTANCE` (`deg_lat1` FLOAT, `deg_lng1` FLOAT, `deg_lat2` FLOAT, `deg_lng2` FLOAT) RETURNS FLOAT BEGIN 
  DECLARE distance FLOAT;
  DECLARE delta_lat FLOAT; 
  DECLARE delta_lng FLOAT; 
  DECLARE lat1 FLOAT; 
  DECLARE lat2 FLOAT;
  DECLARE a FLOAT;

  SET distance = 0;

  
  SET delta_lat = radians(deg_lat2 - deg_lat1); 
  SET delta_lng = radians(deg_lng2 - deg_lng1); 
  SET lat1 = radians(deg_lat1); 
  SET lat2 = radians(deg_lat2); 

  
  SET a = sin(delta_lat/2.0) * sin(delta_lat/2.0) + sin(delta_lng/2.0) * sin(delta_lng/2.0) * cos(lat1) * cos(lat2); 
  SET distance = 3956.6 * 2 * atan2(sqrt(a),  sqrt(1-a)); 

  RETURN distance;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `GLIDERS`
--

DROP TABLE IF EXISTS `GLIDERS`;
CREATE TABLE IF NOT EXISTS `GLIDERS` (
  `idglider` char(9) DEFAULT NULL,
  `registration` char(9) DEFAULT NULL,
  `cn` char(3) DEFAULT NULL,
  `type` text,
  `source` char(1) DEFAULT NULL,
  `flarmtype` char(1) DEFAULT NULL,
  UNIQUE KEY `idglider` (`idglider`),
  UNIQUE KEY `GLIDERIDX` (`idglider`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `GLIDERS_INFO`
--

DROP TABLE IF EXISTS `GLIDERS_INFO`;
CREATE TABLE IF NOT EXISTS `GLIDERS_INFO` (
  `registration` char(6) NOT NULL,
  `maker` varchar(50) NOT NULL,
  `model` varchar(50) NOT NULL,
  `owner` varchar(50) NOT NULL,
  PRIMARY KEY (`registration`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `GLIDERS_PILOT`
--

DROP TABLE IF EXISTS `GLIDERS_PILOT`;
CREATE TABLE IF NOT EXISTS `GLIDERS_PILOT` (
  `CN` varchar(10) NOT NULL,
  `Pilot` varchar(50) NOT NULL,
  PRIMARY KEY (`CN`,`Pilot`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `GLIDERS_POSITIONS`
--

DROP TABLE IF EXISTS `GLIDERS_POSITIONS`;
CREATE TABLE IF NOT EXISTS `GLIDERS_POSITIONS` (
  `flarmId` varchar(50) NOT NULL,
  `lat` float DEFAULT '0',
  `lon` float DEFAULT '0',
  `altitude` float DEFAULT '0',
  `course` float DEFAULT '0',
  `date` char(6) DEFAULT '000000',
  `time` char(6) DEFAULT '000000',
  `rot` float DEFAULT '0',
  `speed` float DEFAULT '0',
  `distance` float DEFAULT '0',
  `climb` float DEFAULT '0',
  `station` varchar(50) DEFAULT 'NONE',
  `sensitivity` float NOT NULL DEFAULT '0',
  `gps` char(6) DEFAULT '',
  `lastFixTx` datetime DEFAULT NULL,
  `ground` int(11) NOT NULL DEFAULT '-1',
  `source` varchar(4) CHARACTER SET utf16 NOT NULL DEFAULT 'OGN',
  KEY `flarmId` (`flarmId`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `OGNDATA`
--

DROP TABLE IF EXISTS `OGNDATA`;
CREATE TABLE IF NOT EXISTS `OGNDATA` (
  `idflarm` char(9) DEFAULT NULL,
  `date` char(6) DEFAULT NULL,
  `time` char(6) DEFAULT NULL,
  `station` char(9) DEFAULT NULL,
  `latitude` float DEFAULT NULL,
  `longitude` float DEFAULT NULL,
  `altitude` int(11) DEFAULT NULL,
  `speed` float DEFAULT NULL,
  `course` int(11) DEFAULT NULL,
  `roclimb` int(11) DEFAULT NULL,
  `rot` float DEFAULT NULL,
  `sensitivity` float DEFAULT NULL,
  `gps` char(6) DEFAULT NULL,
  `uniqueid` char(16) DEFAULT NULL,
  `distance` float DEFAULT NULL,
  `extpos` char(5) DEFAULT NULL,
  `source` varchar(4) NOT NULL DEFAULT 'OGN'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Triggers `OGNDATA`
--
DROP TRIGGER IF EXISTS `INSERTGLIDERPOSITION`;
DELIMITER $$
CREATE TRIGGER `INSERTGLIDERPOSITION` AFTER INSERT ON `OGNDATA` FOR EACH ROW IF ((SELECT count(flarmId) FROM GLIDERS_POSITIONS WHERE flarmId=NEW.idflarm)=0) THEN
	INSERT INTO GLIDERS_POSITIONS  (flarmId, lat, lon, altitude, course, date, time, rot, speed, climb, station, sensitivity, gps, lastFixTx, source) VALUES (NEW.idflarm, NEW.latitude, NEW.longitude, NEW.altitude, NEW.course, NEW.date, NEW.time, NEW.rot, NEW.speed, NEW.roclimb, NEW.station, NEW.sensitivity, NEW.gps, NOW(), NEW.source);
	   
ELSE
   UPDATE GLIDERS_POSITIONS SET lat=NEW.latitude, lon=NEW.longitude, altitude=NEW.altitude, course=NEW.course, date=NEW.date, time=NEW.time, rot=NEW.rot, speed=NEW.speed, distance=NEW.distance, climb=NEW.roclimb, station=NEW.station, gps=NEW.gps, sensitivity=NEW.sensitivity, lastFixTx=NOW(), source=NEW.source where flarmId=NEW.idflarm;

	if(NEW.speed=0) THEN
      UPDATE GLIDERS_POSITIONS set climb=0  where flarmId=NEW.idflarm;
    END IF;
    UPDATE RECEIVERS_STATUS set lastFixRx=NOW(), maxDistance=(select ifnull(max(distance),0) from OGNDATA where station=NEW.station and date=DATE_FORMAT(NOW(), '%y%m%d')) where idrec=NEW.station;
	
END IF
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `OGNDATAARCHIVE`
--

DROP TABLE IF EXISTS `OGNDATAARCHIVE`;
CREATE TABLE IF NOT EXISTS `OGNDATAARCHIVE` (
  `idflarm` char(9) DEFAULT NULL,
  `date` char(6) DEFAULT NULL,
  `time` char(6) DEFAULT NULL,
  `station` char(9) DEFAULT NULL,
  `latitude` float DEFAULT NULL,
  `longitude` float DEFAULT NULL,
  `altitude` int(11) DEFAULT NULL,
  `speed` float DEFAULT NULL,
  `course` int(11) DEFAULT NULL,
  `roclimb` int(11) DEFAULT NULL,
  `rot` float DEFAULT NULL,
  `sensitivity` float DEFAULT NULL,
  `gps` char(6) DEFAULT NULL,
  `uniqueid` char(30) DEFAULT NULL,
  `distance` float DEFAULT NULL,
  `extpos` char(5) DEFAULT NULL,
  `source` varchar(4) NOT NULL DEFAULT 'OGN',
  KEY `datetime` (`idflarm`,`date`,`time`,`station`) USING BTREE,
  KEY `OGNDIDX` (`idflarm`,`date`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `RECEIVERS`
--

DROP TABLE IF EXISTS `RECEIVERS`;
CREATE TABLE IF NOT EXISTS `RECEIVERS` (
  `idrec` char(9) DEFAULT NULL COMMENT 'Id of station',
  `lati` double DEFAULT NULL,
  `longi` double DEFAULT NULL,
  `alti` double DEFAULT NULL,
  `otime` datetime(6) DEFAULT NULL,
  `version` varchar(20) DEFAULT NULL,
  `cpu` float DEFAULT NULL,
  `temp` float DEFAULT NULL,
  `rf` varchar(20) DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL COMMENT 'Station status',
  UNIQUE KEY `RECEIVERSIDX` (`idrec`,`otime`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Triggers `RECEIVERS`
--
DROP TRIGGER IF EXISTS `UPDATERECEIVERSSTATUS`;
DELIMITER $$
CREATE TRIGGER `UPDATERECEIVERSSTATUS` AFTER INSERT ON `RECEIVERS` FOR EACH ROW IF ((SELECT count(idrec) FROM RECEIVERS_STATUS WHERE idrec=NEW.idrec)=0) THEN
	INSERT INTO RECEIVERS_STATUS  (alti, cpu, idrec, lati, longi, otime, rf, status, temp, version, lastFixRx) VALUES (NEW.alti, NEW.cpu, NEW.idrec, NEW.lati, NEW.longi, NEW.otime, NEW.rf, NEW.status, NEW.temp, NEW.version, NOW());
	   
	ELSE
	   UPDATE RECEIVERS_STATUS SET alti=NEW.alti, cpu=NEW.cpu, lati=NEW.lati, longi=NEW.longi, otime=NEW.otime, rf=NEW.rf, status=NEW.status, temp=NEW.temp, version=NEW.version, lastFixRx=NOW() where idrec=NEW.idrec;
 END IF
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `RECEIVERS_STATUS`
--

DROP TABLE IF EXISTS `RECEIVERS_STATUS`;
CREATE TABLE IF NOT EXISTS `RECEIVERS_STATUS` (
  `idrec` char(9) DEFAULT NULL COMMENT 'Id of station',
  `lati` double DEFAULT NULL,
  `longi` double DEFAULT NULL,
  `alti` double DEFAULT NULL,
  `lastFixRx` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `otime` datetime(6) DEFAULT NULL,
  `version` varchar(20) DEFAULT NULL,
  `cpu` float DEFAULT NULL,
  `temp` float DEFAULT NULL,
  `rf` varchar(20) DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL COMMENT 'Station status',
  `maxDistance` float NOT NULL DEFAULT '0',
  UNIQUE KEY `RECEIVERS_STATUSIDX` (`idrec`,`otime`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `TRKDEVICES`
--

DROP TABLE IF EXISTS `TRKDEVICES`;
CREATE TABLE IF NOT EXISTS `TRKDEVICES` (
  `id` varchar(16) NOT NULL,
  `owner` varchar(64) NOT NULL,
  `spotid` varchar(36) NOT NULL,
  `spotpasswd` varchar(16) DEFAULT NULL,
  `compid` varchar(3) NOT NULL,
  `model` varchar(16) NOT NULL,
  `registration` varchar(9) NOT NULL,
  `active` tinyint(1) NOT NULL,
  `devicetype` varchar(6) NOT NULL DEFAULT 'SPOT',
  `flarmid` varchar(9) DEFAULT NULL COMMENT 'Flarmid to link',
  UNIQUE KEY `id` (`id`),
  KEY `spotid` (`spotid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `WAYPOINTS`
--

DROP TABLE IF EXISTS `WAYPOINTS`;
CREATE TABLE IF NOT EXISTS `WAYPOINTS` (
  `idWaypoint` int(11) NOT NULL AUTO_INCREMENT,
  `waypoint` varchar(100) NOT NULL,
  `waypointType` varchar(15) NOT NULL,
  `waypointCountry` varchar(5) NOT NULL,
  `waypointLat` float NOT NULL,
  `waypointLon` float NOT NULL,
  PRIMARY KEY (`idWaypoint`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DELIMITER $$
--
-- Events
--
DROP EVENT IF EXISTS `restore_max_distance`$$
CREATE DEFINER=`ogn`@`%` EVENT `restore_max_distance` ON SCHEDULE EVERY 1 DAY STARTS '2016-12-20 00:30:00' ON COMPLETION NOT PRESERVE ENABLE DO UPDATE RECEIVERS_STATUS SET maxDistance=0 where maxDistance<>0 AND ((select count(*) from OGNDATA where station=idrec and date=CONCAT(RIGHT(YEAR(NOW()),2), MONTH(NOW()), DAY(NOW())))=0)$$

DELIMITER ;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
