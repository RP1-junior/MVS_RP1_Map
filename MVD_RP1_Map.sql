

-- Rename [{MVD_RP1_Map}] to new database name

CREATE DATABASE MVD_RP1_Map CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

USE MVD_RP1_Map;



CREATE TABLE RMCType
(
   bType                               TINYINT UNSIGNED  NOT NULL,
   sType                               VARCHAR (31)      NOT NULL,

   CONSTRAINT PK_RMCType PRIMARY KEY
   (
      bType                            ASC
   )
)
ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO RMCType
       (bType, sType)
VALUES ( 0, ''              ),
       ( 1, 'Universe'      ),
       ( 2, 'Supercluster'  ),
       ( 3, 'Galaxy Cluster'),
       ( 4, 'Galaxy'        ),
       ( 5, 'Black Hole'    ),
       ( 6, 'Nebula'        ),
       ( 7, 'Star Cluster'  ),
       ( 8, 'Constellation' ),
       ( 9, 'Star System'   ),
       (10, 'Star'          ),
       (11, 'Planet System' ),
       (12, 'Planet'        ),
       (13, 'Moon'          ),
       (14, 'Debris'        ),
       (15, 'Satellite'     ),
       (16, 'Transport'     ),
       (17, 'Surface'       );


CREATE TABLE RMCObject
(
   ObjectHead_Parent_wClass            SMALLINT          NOT NULL,
   ObjectHead_Parent_twObjectIx        BIGINT            NOT NULL,
   ObjectHead_Self_wClass              SMALLINT          NOT NULL,
   ObjectHead_Self_twObjectIx          BIGINT            NOT NULL AUTO_INCREMENT,
   ObjectHead_twEventIz                BIGINT            NOT NULL,
   ObjectHead_wFlags                   SMALLINT          NOT NULL,

   Name_wsRMCObjectId                  VARCHAR (48)      NOT NULL,
   Type_bType                          TINYINT UNSIGNED  NOT NULL,
   Type_bSubtype                       TINYINT UNSIGNED  NOT NULL,
   Type_bFiction                       TINYINT UNSIGNED  NOT NULL,
   Owner_twRPersonaIx                  BIGINT            NOT NULL,
   Resource_qwResource                 BIGINT            NOT NULL,
   Resource_sName                      VARCHAR (48)      NOT NULL DEFAULT '',
   Resource_sReference                 VARCHAR (128)     NOT NULL DEFAULT '',
   Transform_Position_dX               DOUBLE            NOT NULL,
   Transform_Position_dY               DOUBLE            NOT NULL,
   Transform_Position_dZ               DOUBLE            NOT NULL,
   Transform_Rotation_dX               DOUBLE            NOT NULL,
   Transform_Rotation_dY               DOUBLE            NOT NULL,
   Transform_Rotation_dZ               DOUBLE            NOT NULL,
   Transform_Rotation_dW               DOUBLE            NOT NULL,
   Transform_Scale_dX                  DOUBLE            NOT NULL,
   Transform_Scale_dY                  DOUBLE            NOT NULL,
   Transform_Scale_dZ                  DOUBLE            NOT NULL,
   Orbit_Spin_tmPeriod                 BIGINT            NOT NULL,
   Orbit_Spin_tmStart                  BIGINT            NOT NULL,
   Orbit_Spin_dA                       DOUBLE            NOT NULL,
   Orbit_Spin_dB                       DOUBLE            NOT NULL,
   Bound_dX                            DOUBLE            NOT NULL,
   Bound_dY                            DOUBLE            NOT NULL,
   Bound_dZ                            DOUBLE            NOT NULL,
   Properties_fMass                    FLOAT             NOT NULL,
   Properties_fGravity                 FLOAT             NOT NULL,
   Properties_fColor                   FLOAT             NOT NULL,
   Properties_fBrightness              FLOAT             NOT NULL,
   Properties_fReflectivity            FLOAT             NOT NULL,

   CONSTRAINT PK_RMCObject PRIMARY KEY
   (
      ObjectHead_Self_twObjectIx       ASC
   ),

   INDEX IX_RMCObject_ObjectHead_Parent_twObjectIx
   (
      ObjectHead_Parent_twObjectIx     ASC
   ),

   INDEX IX_RMCObject_Name_wsRMCObjectId
   (
      Name_wsRMCObjectId               ASC
   )
)
ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- bOp     Meaning
-- 0       NULL
-- 1       RMCObject_Open
-- 2       RMCObject_Close
-- 3       RMCObject_Name
-- 4       RMCObject_Type
-- 5       RMCObject_Owner
-- 6       RMCObject_Resource
-- 7       RMCObject_Transform
-- 8       RMCObject_Orbit
-- 9       RMCObject_Spin
-- 10      RMCObject_Bound
-- 11      RMCObject_Properties

CREATE TABLE RMCObjectLog
(
   dtCreated                           DATETIME          NOT NULL    DEFAULT CURRENT_TIMESTAMP,
   twLogIx                             BIGINT            NOT NULL    AUTO_INCREMENT,

   bOp                                 TINYINT UNSIGNED  NOT NULL,
   dwIPAddress                         BINARY(4)         NOT NULL,
   twRPersonaIx                        BIGINT            NOT NULL,
   twRMCObjectIx                       BIGINT            NOT NULL,

   CONSTRAINT PK_RMCObjectLog PRIMARY KEY
   (
      twLogIx                          ASC
   )
)
ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



CREATE TABLE RMEvent
(
   twEventIx                           BIGINT            NOT NULL AUTO_INCREMENT,

   sType                               VARCHAR(32)       NOT NULL,

   Self_wClass                         TINYINT UNSIGNED  NOT NULL,
   Self_twObjectIx                     BIGINT            NOT NULL,
   Child_wClass                        TINYINT UNSIGNED  NOT NULL,
   Child_twObjectIx                    BIGINT            NOT NULL,
   wFlags                              SMALLINT          NOT NULL,
   twEventIz                           BIGINT            NOT NULL,

   sJSON_Object                        TEXT              NOT NULL,
   sJSON_Child                         TEXT              NOT NULL,
   sJSON_Change                        TEXT              NOT NULL,

   CONSTRAINT PK_RMEvent PRIMARY KEY
   (
      twEventIx                        ASC
   )
)
ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



CREATE TABLE RMPType
(
   bType                               TINYINT UNSIGNED  NOT NULL,
   sType                               VARCHAR (31)      NOT NULL,

   CONSTRAINT PK_RMPType PRIMARY KEY
   (
      bType ASC
   )
)
ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO RMPType
       (bType, sType)
VALUES ( 0, ''         ),
       ( 1, 'Transport'),
       ( 2, 'Other'    );


CREATE TABLE RMPObject
(
   ObjectHead_Parent_wClass            SMALLINT          NOT NULL,
   ObjectHead_Parent_twObjectIx        BIGINT            NOT NULL,
   ObjectHead_Self_wClass              SMALLINT          NOT NULL,
   ObjectHead_Self_twObjectIx          BIGINT            NOT NULL AUTO_INCREMENT,
   ObjectHead_twEventIz                BIGINT            NOT NULL,
   ObjectHead_wFlags                   SMALLINT          NOT NULL,

   Type_bType                          TINYINT UNSIGNED  NOT NULL,
   Type_bSubtype                       TINYINT UNSIGNED  NOT NULL,
   Type_bFiction                       TINYINT UNSIGNED  NOT NULL,
   Type_bMovable                       TINYINT UNSIGNED  NOT NULL,
   Owner_twRPersonaIx                  BIGINT            NOT NULL,
   Resource_qwResource                 BIGINT            NOT NULL,
   Resource_sName                      VARCHAR (48)      NOT NULL DEFAULT '',
   Resource_sReference                 VARCHAR (128)     NOT NULL DEFAULT '',
   Transform_Position_dX               DOUBLE            NOT NULL,
   Transform_Position_dY               DOUBLE            NOT NULL,
   Transform_Position_dZ               DOUBLE            NOT NULL,
   Transform_Rotation_dX               DOUBLE            NOT NULL,
   Transform_Rotation_dY               DOUBLE            NOT NULL,
   Transform_Rotation_dZ               DOUBLE            NOT NULL,
   Transform_Rotation_dW               DOUBLE            NOT NULL,
   Transform_Scale_dX                  DOUBLE            NOT NULL,
   Transform_Scale_dY                  DOUBLE            NOT NULL,
   Transform_Scale_dZ                  DOUBLE            NOT NULL,
   Bound_dX                            DOUBLE            NOT NULL,
   Bound_dY                            DOUBLE            NOT NULL,
   Bound_dZ                            DOUBLE            NOT NULL,

   CONSTRAINT PK_RMPObject PRIMARY KEY
   (
      ObjectHead_Self_twObjectIx       ASC
   ),

   INDEX IX_RMPObject_ObjectHead_Parent_twObjectIx
   (
      ObjectHead_Parent_twObjectIx     ASC
   )
)
ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- bOp     Meaning
-- 0       NULL
-- 1       RMPObject_Open
-- 2       RMPObject_Close
-- 3    -- RMPObject_Name
-- 4       RMPObject_Type
-- 5       RMPObject_Owner
-- 6       RMPObject_Resource
-- 7       RMPObject_Transform
-- 8    -- RMPObject_Orbit
-- 9    -- RMPObject_Spin
-- 10      RMPObject_Bound
-- 11   -- RMPObject_Properties

CREATE TABLE RMPObjectLog
(
   dtCreated                           DATETIME          NOT NULL    DEFAULT CURRENT_TIMESTAMP,
   twLogIx                             BIGINT            NOT NULL    AUTO_INCREMENT,

   bOp                                 TINYINT UNSIGNED  NOT NULL,
   dwIPAddress                         BINARY(4)         NOT NULL,
   twRPersonaIx                        BIGINT            NOT NULL,
   twRMPObjectIx                       BIGINT            NOT NULL,

   CONSTRAINT PK_RMPObjectLog PRIMARY KEY
   (
      twLogIx                          ASC
   )
)
ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



CREATE TABLE RMRoot
(
   ObjectHead_Parent_wClass            SMALLINT          NOT NULL,
   ObjectHead_Parent_twObjectIx        BIGINT            NOT NULL,
   ObjectHead_Self_wClass              SMALLINT          NOT NULL,
   ObjectHead_Self_twObjectIx          BIGINT            NOT NULL AUTO_INCREMENT,
   ObjectHead_twEventIz                BIGINT            NOT NULL,
   ObjectHead_wFlags                   SMALLINT          NOT NULL,

   Name_wsRMRootId                     VARCHAR (48)      NOT NULL,
   Owner_twRPersonaIx                  BIGINT            NOT NULL,

   CONSTRAINT PK_RMRoot PRIMARY KEY
   (
      ObjectHead_Self_twObjectIx       ASC
   )
)
ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- bOp     Meaning
-- 0       NULL
-- 1    -- RMRoot_Open
-- 2    -- RMRoot_Close
-- 3       RMRoot_Name
-- 4    -- RMRoot_Type
-- 5       RMRoot_Owner
-- 6    -- RMRoot_Resource
-- 7    -- RMRoot_Transform
-- 8    -- RMRoot_Orbit
-- 9    -- RMRoot_Spin
-- 10   -- RMRoot_Bound
-- 11   -- RMRoot_Properties
-- 12   -- RMRoot_RMRoot_Open
-- 13   -- RMRoot_RMRoot_Close
-- 14      RMRoot_RMCObject_Open
-- 15      RMRoot_RMCObject_Close
-- 16      RMRoot_RMTObject_Open
-- 17      RMRoot_RMTObject_Close
-- 18      RMRoot_RMPObject_Open
-- 19      RMRoot_RMPObject_Close

CREATE TABLE RMRootLog
(
   dtCreated                           DATETIME          NOT NULL    DEFAULT CURRENT_TIMESTAMP,
   twLogIx                             BIGINT            NOT NULL    AUTO_INCREMENT,

   bOp                                 TINYINT UNSIGNED  NOT NULL,
   dwIPAddress                         BINARY(4)         NOT NULL,
   twRPersonaIx                        BIGINT            NOT NULL,
   twRMRootIx                          BIGINT            NOT NULL,

   CONSTRAINT PK_RMRootLog PRIMARY KEY
   (
      twLogIx                          ASC
   )
)
ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



CREATE TABLE RMTBuilding
(
   twRMTObjectIx                       BIGINT            NOT NULL,  -- sector
   bnOSMWay                            BIGINT            NOT NULL,  -- building

   PRIMARY KEY
   (
      twRMTObjectIx                    ASC,
      bnOSMWay                         ASC
   )
)
ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



CREATE TABLE RMTSubsurface
(
   twRMTObjectIx                       BIGINT            NOT NULL,
                                                                 --                        Nul      Car      Cyl      Geo
   tnGeometry                          TINYINT UNSIGNED  NOT NULL, --                        0        1        2        3
   dA                                  DOUBLE            NOT NULL,      -- original coordinates   -        x        angle    latitude
   dB                                  DOUBLE            NOT NULL,      -- original coordinates   -        y        y        longitude
   dC                                  DOUBLE            NOT NULL,      -- original coordinates   -        z        radius   radius

-- bnMatrix =  twRMTObjectIx is the         transform for this subsurface
-- bnMatrix = -twRMTObjectIx is the inverse transform for this subsurface

   PRIMARY KEY
   (
      twRMTObjectIx                    ASC
   )
)
ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE RMTMatrix
(
   bnMatrix                            BIGINT            NOT NULL,

   d00                                 DOUBLE            NOT NULL DEFAULT 1,
   d01                                 DOUBLE            NOT NULL DEFAULT 0,
   d02                                 DOUBLE            NOT NULL DEFAULT 0,
   d03                                 DOUBLE            NOT NULL DEFAULT 0,

   d10                                 DOUBLE            NOT NULL DEFAULT 0,
   d11                                 DOUBLE            NOT NULL DEFAULT 1,
   d12                                 DOUBLE            NOT NULL DEFAULT 0,
   d13                                 DOUBLE            NOT NULL DEFAULT 0,

   d20                                 DOUBLE            NOT NULL DEFAULT 0,
   d21                                 DOUBLE            NOT NULL DEFAULT 0,
   d22                                 DOUBLE            NOT NULL DEFAULT 1,
   d23                                 DOUBLE            NOT NULL DEFAULT 0,

   d30                                 DOUBLE            NOT NULL DEFAULT 0,
   d31                                 DOUBLE            NOT NULL DEFAULT 0,
   d32                                 DOUBLE            NOT NULL DEFAULT 0,
   d33                                 DOUBLE            NOT NULL DEFAULT 1,

   PRIMARY KEY
   (
      bnMatrix                         ASC
   )
)
ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



CREATE TABLE RMTType
(
   bType                               TINYINT UNSIGNED  NOT NULL,
   sType                               VARCHAR (31)      NOT NULL,

   CONSTRAINT PK_RMTType PRIMARY KEY
   (
      bType ASC
   )
)
ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO RMTType
       (bType, sType)
VALUES ( 0, ''         ),
       ( 1, 'Root'     ),
       ( 2, 'Water'    ),
       ( 3, 'Land'     ),
       ( 4, 'Country'  ),
       ( 5, 'Territory'),
       ( 6, 'State'    ),
       ( 7, 'County'   ),
       ( 8, 'City'     ),
       ( 9, 'Community'),
       (10, 'Sector'   ),
       (11, 'Parcel'   );


CREATE TABLE RMTObject
(
   ObjectHead_Parent_wClass            SMALLINT          NOT NULL,
   ObjectHead_Parent_twObjectIx        BIGINT            NOT NULL,
   ObjectHead_Self_wClass              SMALLINT          NOT NULL,
   ObjectHead_Self_twObjectIx          BIGINT            NOT NULL AUTO_INCREMENT,
   ObjectHead_twEventIz                BIGINT            NOT NULL,
   ObjectHead_wFlags                   SMALLINT          NOT NULL,

   Name_wsRMTObjectId                  VARCHAR (48)      NOT NULL,
   Type_bType                          TINYINT UNSIGNED  NOT NULL,
   Type_bSubtype                       TINYINT UNSIGNED  NOT NULL,
   Type_bFiction                       TINYINT UNSIGNED  NOT NULL,
   Owner_twRPersonaIx                  BIGINT            NOT NULL,
   Resource_qwResource                 BIGINT            NOT NULL,
   Resource_sName                      VARCHAR (48)      NOT NULL DEFAULT '',
   Resource_sReference                 VARCHAR (128)     NOT NULL DEFAULT '',
   Transform_Position_dX               DOUBLE            NOT NULL,
   Transform_Position_dY               DOUBLE            NOT NULL,
   Transform_Position_dZ               DOUBLE            NOT NULL,
   Transform_Rotation_dX               DOUBLE            NOT NULL,
   Transform_Rotation_dY               DOUBLE            NOT NULL,
   Transform_Rotation_dZ               DOUBLE            NOT NULL,
   Transform_Rotation_dW               DOUBLE            NOT NULL,
   Transform_Scale_dX                  DOUBLE            NOT NULL,
   Transform_Scale_dY                  DOUBLE            NOT NULL,
   Transform_Scale_dZ                  DOUBLE            NOT NULL,
   Bound_dX                            DOUBLE            NOT NULL,
   Bound_dY                            DOUBLE            NOT NULL,
   Bound_dZ                            DOUBLE            NOT NULL,
   Properties_bLockToGround            TINYINT UNSIGNED  NOT NULL,
   Properties_bYouth                   TINYINT UNSIGNED  NOT NULL,
   Properties_bAdult                   TINYINT UNSIGNED  NOT NULL,
   Properties_bAvatar                  TINYINT UNSIGNED  NOT NULL,

   CONSTRAINT PK_RMTObject PRIMARY KEY
   (
      ObjectHead_Self_twObjectIx       ASC
   ),

   INDEX IX_RMTObject_ObjectHead_Parent_twObjectIx
   (
      ObjectHead_Parent_twObjectIx     ASC
   ),

   INDEX IX_RMTObject_Name_wsRMTObjectId
   (
      Name_wsRMTObjectId               ASC
   )
)
ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- bOp     Meaning
-- 0       NULL
-- 1       RMTObject_Open
-- 2       RMTObject_Close
-- 3       RMTObject_Name
-- 4       RMTObject_Type
-- 5       RMTObject_Owner
-- 6       RMTObject_Resource
-- 7       RMTObject_Transform
-- 8    -- RMTObject_Orbit
-- 9    -- RMTObject_Spin
-- 10      RMTObject_Bound
-- 11      RMTObject_Properties

CREATE TABLE RMTObjectLog
(
   dtCreated                           DATETIME          NOT NULL    DEFAULT CURRENT_TIMESTAMP,
   twLogIx                             BIGINT            NOT NULL    AUTO_INCREMENT,

   bOp                                 TINYINT UNSIGNED  NOT NULL,
   dwIPAddress                         BINARY(4)         NOT NULL,
   twRPersonaIx                        BIGINT            NOT NULL,
   twRMTObjectIx                       BIGINT            NOT NULL,

   CONSTRAINT PK_RMTObjectLog PRIMARY KEY
   (
      twLogIx                          ASC
   )
)
ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DELIMITER $$
CREATE FUNCTION ArcLength
(
   dRadius          DOUBLE,
   dX0              DOUBLE,
   dY0              DOUBLE,
   dZ0              DOUBLE,
   dX               DOUBLE,
   dY               DOUBLE,
   dZ               DOUBLE
)
RETURNS DOUBLE
DETERMINISTIC
BEGIN
            -- arc length = 2 * radius * arcsin (distance / (2 * radius))
            -- This function assumes dX0, dY0, and dZ0 have already been normalized to dRadius
            -- Origins in the database sit below the surface and must also be normalized to dRadius
       DECLARE dNormal DOUBLE DEFAULT dRadius / SQRT ((dX * dX) + (dY * dY) + (dZ * dZ));
           SET dX = dX * dNormal;
           SET dY = dY * dNormal;
           SET dZ = dZ * dNormal;
           SET dX = dX - dX0;
           SET dY = dY - dY0;
           SET dZ = dZ - dZ0;
        RETURN (2.0 * dRadius) * ASIN (SQRT ((dX * dX) + (dY * dY) + (dZ * dZ)) / (2.0 * dRadius));
END$$
DELIMITER ;



-- TIME reports time in 1/64 sec from UTC Jan 1, 1601
-- UNIX reports time in 1/1000 sec from UTC Jan 1, 1970
-- There are  134774 days between UTC Jan 1, 1601 and UTC Jan 1, 1970
-- There are 5529600 1/64 sec per day

-- 134774 * 5529600 = 745246310400

DELIMITER $$

CREATE FUNCTION DateTime2_Time
(
   tmStamp BIGINT
)
RETURNS DATETIME  -- DATETIME values must be in UTC
DETERMINISTIC
BEGIN

      DECLARE dt2 DATETIME;
      DECLARE s BIGINT;
      DECLARE mcs BIGINT;

          SET tmStamp = tmStamp - 745246310400;

          SET s = tmStamp DIV 64;

          SET mcs = tmStamp MOD 64;
          SET mcs = mcs * 1000000;
          SET mcs = mcs DIV 64;

          SET dt2 = DATE_ADD('1970-01-01', INTERVAL s SECOND);
          SET dt2 = DATE_ADD(dt2, INTERVAL mcs MICROSECOND);

       RETURN dt2;
  END$$

DELIMITER ;



-- DATETIME2  reports time in 1/10000000 sec from UTC Jan 1, 0001
-- JavaScript reports time in 1/1000     sec from UTC Jan 1, 1970 (Unix Epoch Time)
-- There are  719162 days between Jan 1, 0001 and Jan 1, 1970
-- There are 86400000 1/1000 sec per day

DELIMITER $$

CREATE FUNCTION Date_DateTime2
(
   dtStamp DATETIME  -- DATETIME values must be in UTC and generally generated from UTC_TIMESTAMP()
)
RETURNS BIGINT
DETERMINISTIC
BEGIN
      -- Convert MySQL DATETIME to JavaScript timestamp (milliseconds since Jan 1, 1970)
      -- MySQL's UNIX_TIMESTAMP returns seconds since 1970, so multiply by 1000 for milliseconds
      RETURN UNIX_TIMESTAMP(dtStamp) * 1000;
  END$$

DELIMITER ;



DELIMITER $$

CREATE FUNCTION Format_Bound
(
   dX                      DOUBLE,
   dY                      DOUBLE,
   dZ                      DOUBLE
)
RETURNS VARCHAR (256)
DETERMINISTIC
BEGIN
      RETURN CONCAT ('{ "Max": ', Format_Double3(dX, dY, dZ), ' }');
  END$$

DELIMITER ;



DELIMITER $$

CREATE FUNCTION Format_Control
(
   Self_wClass             SMALLINT,
   Self_twObjectIx         BIGINT,
   Child_wClass            SMALLINT,
   Child_twObjectIx        BIGINT,
   wFlags                  SMALLINT,
   twEventIz               BIGINT
)
RETURNS VARCHAR (256)
DETERMINISTIC
BEGIN
      RETURN CONCAT
             (
                '{ "wClass_Object": ', CAST(Self_wClass AS CHAR),
                ', "twObjectIx": ',    CAST(Self_twObjectIx AS CHAR),
                ', "wClass_Child": ',  CAST(Child_wClass AS CHAR),
                ', "twChildIx": ',     CAST(Child_twObjectIx AS CHAR),
                ', "wFlags": ',        CAST(wFlags AS CHAR),
                ', "twEventIz": ',     CAST(twEventIz AS CHAR),
                ' }'
             );
  END$$

DELIMITER ;



DELIMITER $$

CREATE FUNCTION Format_Double
(
   d   DOUBLE
)
RETURNS VARCHAR (32)
DETERMINISTIC
BEGIN

      DECLARE dA      DOUBLE DEFAULT ABS(d);
      DECLARE e       INT DEFAULT 0;
      DECLARE sSign   VARCHAR (1) DEFAULT '';
      DECLARE sExp    VARCHAR (8) DEFAULT '';
      DECLARE sNum    VARCHAR (20) DEFAULT '';

           IF (dA <> d)
         THEN
              SET sSign = '-';
       END IF ;

           IF dA <> 0 AND dA <> 1
         THEN
                    IF dA < 1.0
                  THEN
                          WHILE (dA < POW(10, -e) AND e < 310)
                             DO
                                     SET e = e + 1;
                      END WHILE ;

                            SET dA = dA * POW(10, e);
                            SET sExp = CONCAT ('e-', e);
                ELSEIF dA >= 10.0
                  THEN
                          WHILE (dA >= POW(10, e + 1) AND e < 310)
                             DO
                                     SET e = e + 1;
                      END WHILE ;

                            SET dA = dA * POW(10, -e);
                            SET sExp = CONCAT ('e+', e);
                END IF ;
       END IF ;

           IF (FLOOR(dA) = CEILING(dA))
         THEN
              SET sNum = CAST(dA AS CHAR);
         ELSE
              SET sNum = FORMAT(dA, 16);
       END IF ;

       RETURN CONCAT (sSign, sNum, sExp);
  END$$

DELIMITER ;



DELIMITER $$

CREATE FUNCTION Format_Double3
(
   dX   DOUBLE,
   dY   DOUBLE,
   dZ   DOUBLE
)
RETURNS VARCHAR (256)
DETERMINISTIC
BEGIN
      RETURN CONCAT ('[', Format_Double(dX), ',', Format_Double(dY), ',', Format_Double(dZ), ']');
  END$$

DELIMITER ;



DELIMITER $$

CREATE FUNCTION Format_Double4
(
   dX   DOUBLE,
   dY   DOUBLE,
   dZ   DOUBLE,
   dW   DOUBLE
)
RETURNS VARCHAR (256)
DETERMINISTIC
BEGIN
      RETURN CONCAT ('[', Format_Double(dX), ',', Format_Double(dY), ',', Format_Double(dZ), ',', Format_Double(dW), ']');
  END$$

DELIMITER ;


DELIMITER $$

CREATE FUNCTION Format_Float
(
   d   FLOAT
)
RETURNS VARCHAR (32)
DETERMINISTIC
BEGIN

      DECLARE dA      FLOAT DEFAULT ABS(d);
      DECLARE e       INT DEFAULT 0;
      DECLARE sSign   VARCHAR (1) DEFAULT '';
      DECLARE sExp    VARCHAR (8) DEFAULT '';
      DECLARE sNum    VARCHAR (20) DEFAULT '';

           IF (dA <> d) THEN
              SET sSign = '-';
           END IF ;

           IF dA <> 0 AND dA <> 1 THEN
                   IF dA < 1.0 THEN
                       WHILE (dA < POW(10, -e) AND e < 310) DO
                            SET e = e + 1;
                       END WHILE;

                        SET dA = dA * POW(10, e);
                        SET sExp = CONCAT ('e-', e);
              ELSEIF dA >= 10.0 THEN
                       WHILE (dA >= POW(10, e + 1) AND e < 310) DO
                            SET e = e + 1;
                       END WHILE;

                        SET dA = dA * POW(10, -e);
                        SET sExp = CONCAT ('e+', e);
                  END IF ;
          END IF ;

           IF (FLOOR(dA) = CEILING(dA)) THEN
              SET sNum = CAST(dA AS CHAR);
           ELSE
              SET sNum = FORMAT(dA, 8);
           END IF ;

       RETURN CONCAT (sSign, sNum, sExp);
  END$$

DELIMITER ;



DELIMITER $$

CREATE FUNCTION Format_Name_C
(
   wsRMCObjectId            VARCHAR (48)
)
RETURNS VARCHAR (256)
DETERMINISTIC
BEGIN
      RETURN CONCAT ('{ "wsRMCObjectId": "', wsRMCObjectId, '" }');
  END$$

DELIMITER ;



DELIMITER $$

CREATE FUNCTION Format_Name_R
(
   wsRMRootId            VARCHAR (48)
)
RETURNS VARCHAR (256)
DETERMINISTIC
BEGIN
      RETURN CONCAT ('{ "wsRMRootId": "', wsRMRootId, '" }');
  END$$

DELIMITER ;



DELIMITER $$

CREATE FUNCTION Format_Name_T
(
   wsRMTObjectId            VARCHAR (48)
)
RETURNS VARCHAR (256)
DETERMINISTIC
BEGIN
      RETURN CONCAT ('{ "wsRMTObjectId": "', wsRMTObjectId, '" }');
  END$$

DELIMITER ;



DELIMITER $$

CREATE FUNCTION Format_ObjectHead
(
   Parent_wClass           SMALLINT,
   Parent_twObjectIx       BIGINT,
   Self_wClass             SMALLINT,
   Self_twObjectIx         BIGINT,
   wFlags                  SMALLINT,
   twEventIz               BIGINT
)
RETURNS VARCHAR (256)
DETERMINISTIC
BEGIN
      RETURN CONCAT ('{ "wClass_Parent": ', CAST(Parent_wClass AS CHAR), ', "twParentIx": ', CAST(Parent_twObjectIx AS CHAR), ', "wClass_Object": ', CAST(Self_wClass AS CHAR), ', "twObjectIx": ', CAST(Self_twObjectIx AS CHAR), ', "wFlags": ', CAST(wFlags AS CHAR), ', "twEventIz": ', CAST(twEventIz AS CHAR), ' }');
  END$$

DELIMITER ;



DELIMITER $$

CREATE FUNCTION Format_Orbit_Spin
(
   tmPeriod                 BIGINT,
   tmStart                  BIGINT,
   dA                       DOUBLE,
   dB                       DOUBLE
)
RETURNS VARCHAR (256)
DETERMINISTIC
BEGIN
      RETURN CONCAT ('{ "tmPeriod": ', CAST(tmPeriod AS CHAR), ', "tmStart": ', CAST(tmStart AS CHAR), ', "dA": ', Format_Double(dA), ', "dB": ', Format_Double(dB), ' }');
  END$$

DELIMITER ;



DELIMITER $$

CREATE FUNCTION Format_Owner
(
   twRPersonaIx                BIGINT
)
RETURNS VARCHAR (256)
DETERMINISTIC
BEGIN
      RETURN CONCAT ('{ "twRPersonaIx": ', CAST(twRPersonaIx AS CHAR), ' }');
  END$$

DELIMITER ;



DELIMITER $$

CREATE FUNCTION Format_Properties_C
(
   fMass                    FLOAT,
   fGravity                 FLOAT,
   fColor                   FLOAT,
   fBrightness              FLOAT,
   fReflectivity            FLOAT
)
RETURNS VARCHAR (256)
DETERMINISTIC
BEGIN
      RETURN CONCAT ('{ "fMass": ', Format_Float(fMass), ', "fGravity": ', Format_Float(fGravity), ', "fColor": ', Format_Float(fColor), ', "fBrightness": ', Format_Float(fBrightness), ', "fReflectivity": ', Format_Float(fReflectivity), ' }');
  END$$

DELIMITER ;


DELIMITER $$

CREATE FUNCTION Format_Properties_T
(
   bLockToGround            TINYINT UNSIGNED,
   bYouth                   TINYINT UNSIGNED,
   bAdult                   TINYINT UNSIGNED,
   bAvatar                  TINYINT UNSIGNED
)
RETURNS VARCHAR (256)
DETERMINISTIC
BEGIN
      RETURN CONCAT ('{ "bLockToGround": ', CAST(bLockToGround AS CHAR), ', "bYouth": ', CAST(bYouth AS CHAR), ', "bAdult": ', CAST(bAdult AS CHAR), ', "bAvatar": ', CAST(bAvatar AS CHAR), ' }');
  END$$

DELIMITER ;



DELIMITER $$

CREATE FUNCTION Format_Resource
(
   qwResource               BIGINT,
   sName                    VARCHAR (48),
   sReference               VARCHAR (128)
)
RETURNS VARCHAR (256)
DETERMINISTIC
BEGIN
      DECLARE n        INT;
      DECLARE sName_   VARCHAR (128);

          SET sName_ = sName;

           IF SUBSTRING (sName, 1, 1) = '~' THEN
              SET n = LOCATE (':', sName);
               IF n > 0 AND LENGTH (sName) = n + 10 THEN
                  SET sName_ = CONCAT ('https://', SUBSTRING (sName, 2, n - 2), '-cdn.rp1.com/sector/', SUBSTRING (sName, n + 1, 1), '/', SUBSTRING (sName, n + 2, 3), '/', SUBSTRING (sName, n + 5, 3), '/', SUBSTRING (sName, n + 1, 10), '.json');
               END IF ;
          END IF ;

      RETURN CONCAT ('{ "qwResource": ', CAST(qwResource AS CHAR), ', "sName": "', sName_, '", "sReference": "', sReference, '" }');
  END$$

DELIMITER ;



DELIMITER $$

CREATE FUNCTION Format_Transform
(
   Position_dX               DOUBLE,
   Position_dY               DOUBLE,
   Position_dZ               DOUBLE,
   Rotation_dX               DOUBLE,
   Rotation_dY               DOUBLE,
   Rotation_dZ               DOUBLE,
   Rotation_dW               DOUBLE,
   Scale_dX                  DOUBLE,
   Scale_dY                  DOUBLE,
   Scale_dZ                  DOUBLE
)
RETURNS VARCHAR (512)
DETERMINISTIC
BEGIN
      RETURN CONCAT ('{ "Position": ', Format_Double3(Position_dX, Position_dY, Position_dZ), ', "Rotation": ', Format_Double4(Rotation_dX, Rotation_dY, Rotation_dZ, Rotation_dW), ', "Scale": ', Format_Double3(Scale_dX, Scale_dY, Scale_dZ), ' }');
  END$$

DELIMITER ;



DELIMITER $$

CREATE FUNCTION Format_Type_C
(
   bType                    TINYINT UNSIGNED,
   bSubtype                 TINYINT UNSIGNED,
   bFiction                 TINYINT UNSIGNED
)
RETURNS VARCHAR (256)
DETERMINISTIC
BEGIN
      RETURN CONCAT ('{ "bType": ', CAST(bType AS CHAR), ', "bSubtype": ', CAST(bSubtype AS CHAR), ', "bFiction": ', CAST(bFiction AS CHAR), ' }');
  END$$

DELIMITER ;



DELIMITER $$

CREATE FUNCTION Format_Type_P
(
   bType                    TINYINT UNSIGNED,
   bSubtype                 TINYINT UNSIGNED,
   bFiction                 TINYINT UNSIGNED,
   bMovable                 TINYINT UNSIGNED
)
RETURNS VARCHAR (256)
DETERMINISTIC
BEGIN
      RETURN CONCAT ('{ "bType": ', CAST(bType AS CHAR), ', "bSubtype": ', CAST(bSubtype AS CHAR), ', "bFiction": ', CAST(bFiction AS CHAR), ', "bMovable": ', CAST(bMovable AS CHAR), ' }');
  END$$

DELIMITER ;



DELIMITER $$

CREATE FUNCTION Format_Type_T
(
   bType                    TINYINT UNSIGNED,
   bSubtype                 TINYINT UNSIGNED,
   bFiction                 TINYINT UNSIGNED
)
RETURNS VARCHAR (256)
DETERMINISTIC
BEGIN
      RETURN CONCAT ('{ "bType": ', CAST(bType AS CHAR), ', "bSubtype": ', CAST(bSubtype AS CHAR), ', "bFiction": ', CAST(bFiction AS CHAR), ' }');
  END$$

DELIMITER ;



DELIMITER $$

CREATE FUNCTION IPstob
(
   sIPAddress     VARCHAR (16)
)
RETURNS BINARY(4)
DETERMINISTIC
BEGIN
      DECLARE a       INT;
      DECLARE b       INT;
      DECLARE c       INT;
      DECLARE x       BIGINT;

          SET a = LOCATE ('.', sIPAddress);
          SET b = LOCATE ('.', sIPAddress, a + 1);
          SET c = LOCATE ('.', sIPAddress, b + 1);

          SET x = 0;
          SET x = x * 256 + CAST(SUBSTRING (sIPAddress, 1,          a - 1) AS UNSIGNED);
          SET x = x * 256 + CAST(SUBSTRING (sIPAddress, a + 1,  b - a - 1) AS UNSIGNED);
          SET x = x * 256 + CAST(SUBSTRING (sIPAddress, b + 1,  c - b - 1) AS UNSIGNED);
          SET x = x * 256 + CAST(SUBSTRING (sIPAddress, c + 1, 16 - c - 1) AS UNSIGNED);

       RETURN CAST(x AS BINARY(4));
  END$$

DELIMITER ;

DELIMITER $$

CREATE FUNCTION IPbtos
(
   dwIPAddress    BINARY(4)
)
RETURNS VARCHAR (16)
DETERMINISTIC
BEGIN
      RETURN CONCAT
      (
          CAST(CONV (HEX (SUBSTRING (dwIPAddress, 1, 1)), 16, 10) AS CHAR), '.',
          CAST(CONV (HEX (SUBSTRING (dwIPAddress, 2, 1)), 16, 10) AS CHAR), '.',
          CAST(CONV (HEX (SUBSTRING (dwIPAddress, 3, 1)), 16, 10) AS CHAR), '.',
          CAST(CONV (HEX (SUBSTRING (dwIPAddress, 4, 1)), 16, 10) AS CHAR)
      );
  END$$

DELIMITER ;


-- This function is really Date_Current

DELIMITER $$

CREATE FUNCTION Time_Current
(
)
RETURNS BIGINT
DETERMINISTIC
BEGIN
       RETURN Date_DateTime2(UTC_TIMESTAMP());
  END$$

DELIMITER ;



-- DATETIME2  reports time in 1/10000000 sec from UTC Jan 1, 0001
-- S3         reports time in 1/64       sec from UTC Jan 1, 1601
-- There are  584388 days between UTC Jan 1, 0001 and UTC Jan 1, 1601
-- There are 5529600 1/64 sec per day

-- 584388 * 5529600 = 3231431884800

DELIMITER $$

CREATE FUNCTION Time_DateTime2
(
   dtStamp DATETIME  -- DATETIME values must be in UTC and generally generated from UTC_TIMESTAMP()
)
RETURNS BIGINT
DETERMINISTIC
BEGIN
      -- Convert MySQL DATETIME to S3 timestamp format
      -- MySQL uses seconds since 1970, S3 uses 1/64 sec since 1601
      -- There are 134774 days between Jan 1, 1601 and Jan 1, 1970
      -- 134774 * 86400 * 64 = 745246310400
      RETURN (UNIX_TIMESTAMP(dtStamp) * 64) + 745246310400;
  END$$

DELIMITER ;


DELIMITER $$

CREATE PROCEDURE call_Error
(
   IN    dwError                       INT,
   IN    sError                        VARCHAR (255),
   INOUT nError                        INT
)
BEGIN
           SET nError = IFNULL (nError, 0);

        INSERT Error
             ( dwError, sError )
        SELECT dwError, sError;

           SET nError = nError + 1;
  END$$

DELIMITER ;



DELIMITER $$

CREATE PROCEDURE call_Event_Push
(
)
BEGIN
       DECLARE bError INT DEFAULT 1;
       DECLARE nCount INT DEFAULT 0;

        INSERT INTO RMEvent
             ( sType, Self_wClass, Self_twObjectIx, Child_wClass, Child_twObjectIx, wFlags, twEventIz, sJSON_Object, sJSON_Child, sJSON_Change )
        SELECT sType, Self_wClass, Self_twObjectIx, Child_wClass, Child_twObjectIx, wFlags, twEventIz, sJSON_Object, sJSON_Child, sJSON_Change
          FROM Event
      ORDER BY nOrder ASC;

           SET nCount = ROW_COUNT ();
            IF (nCount > 0)
          THEN
                   SET bError = 0;
        END IF ;
  END$$

DELIMITER ;



DELIMITER $$

CREATE PROCEDURE etl_Events
(
   OUT bError INT
)
BEGIN
          DROP TEMPORARY TABLE IF EXISTS Events;
        CREATE TEMPORARY TABLE Events
               (
                  twEventIx      BIGINT
               );

         START TRANSACTION;

        INSERT INTO Events
             ( twEventIx )
        SELECT twEventIx
          FROM RMEvent
      ORDER BY twEventIx ASC
         LIMIT 100;

        SELECT CONCAT
               (
                 '{ ',
                   '"sType": ',     '"', e.sType, '"',
                 ', "pControl": ',  Format_Control (e.Self_wClass, e.Self_twObjectIx, e.Child_wClass, e.Child_twObjectIx, e.wFlags, e.twEventIz),
                 ', "pObject": ',   e.sJSON_Object,
                 ', "pChild": ',    e.sJSON_Child,
                 ', "pChange": ',   e.sJSON_Change,
                ' }'
               )
               AS `Object`
          FROM RMEvent AS e
          JOIN Events AS t ON t.twEventIx = e.twEventIx
      ORDER BY e.twEventIx;

        DELETE e
          FROM RMEvent AS e
          JOIN Events AS t ON t.twEventIx = e.twEventIx;

        SELECT COUNT(*) AS nCount
          FROM RMEvent;

        COMMIT ;

          DROP TEMPORARY TABLE IF EXISTS Events;
          SET bError = 0;
  END$$

DELIMITER ;



DELIMITER $$

CREATE PROCEDURE call_RMPObject_Select
(
   IN nResultSet                   INT
)
BEGIN
       DECLARE OBJECTHEAD_FLAG_SUBSCRIBE_PARTIAL          INT DEFAULT 0x10;
       DECLARE OBJECTHEAD_FLAG_SUBSCRIBE_FULL             INT DEFAULT 0x20;

       DECLARE SBO_CLASS_RMPOBJECT                        INT DEFAULT 73;

        SELECT CONCAT
               (
                 '{ ',
                    '"ObjectHead": ',    Format_ObjectHead
                                         (
                                            p.ObjectHead_Parent_wClass,
                                            p.ObjectHead_Parent_twObjectIx,
                                            p.ObjectHead_Self_wClass,
                                            p.ObjectHead_Self_twObjectIx,
                                            IF (nResultSet = 0, OBJECTHEAD_FLAG_SUBSCRIBE_FULL, OBJECTHEAD_FLAG_SUBSCRIBE_PARTIAL),
                                            p.ObjectHead_twEventIz
                                         ),

                  ', "twRMPObjectIx": ', p.ObjectHead_Self_twObjectIx,      -- is this necessary

                  ', "Type": ',          Format_Type_P
                                         (
                                            p.Type_bType,
                                            p.Type_bSubtype,
                                            p.Type_bFiction,
                                            p.Type_bMovable
                                         ),
                  ', "Owner": ',         Format_Owner
                                         (
                                            p.Owner_twRPersonaIx
                                         ),
                  ', "Resource": ',      Format_Resource
                                         (
                                            p.Resource_qwResource,
                                            p.Resource_sName,
                                            p.Resource_sReference
                                         ),
                  ', "Transform": ',     Format_Transform
                                         (
                                            p.Transform_Position_dX,
                                            p.Transform_Position_dY,
                                            p.Transform_Position_dZ,
                                            p.Transform_Rotation_dX,
                                            p.Transform_Rotation_dY,
                                            p.Transform_Rotation_dZ,
                                            p.Transform_Rotation_dW,
                                            p.Transform_Scale_dX,
                                            p.Transform_Scale_dY,
                                            p.Transform_Scale_dZ
                                         ),
                  ', "Bound": ',         Format_Bound
                                         (
                                            p.Bound_dX,
                                            p.Bound_dY,
                                            p.Bound_dZ
                                         ),

                  ', "nChildren":  ',    IFNULL(cap.nCount, 0),
                 ' }'
               ) AS `Object`
          FROM Results   AS x
          JOIN RMPObject AS p on p.ObjectHead_Self_twObjectIx = x.ObjectHead_Self_twObjectIx
     LEFT JOIN (SELECT ObjectHead_Parent_twObjectIx, COUNT(*) AS nCount FROM RMPObject WHERE ObjectHead_Parent_wClass = SBO_CLASS_RMPOBJECT GROUP BY ObjectHead_Parent_twObjectIx) AS cap ON cap.ObjectHead_Parent_twObjectIx = p.ObjectHead_Self_twObjectIx
         WHERE x.nResultSet = nResultSet;
  END$$

DELIMITER ;


DELIMITER $$

CREATE PROCEDURE get_RMPObject_Update
(
   IN    sIPAddress                    VARCHAR (16),
   IN    twRPersonaIx                  BIGINT,
   IN    twRMPObjectIx                 BIGINT,
   OUT   nResult                       BIGINT
)
BEGIN
       DECLARE bCommit INT DEFAULT 0;
       DECLARE nError  INT DEFAULT 0;
       DECLARE nCount  INT;

            -- Create the temp Error table
        CREATE TEMPORARY TABLE Error
               (
                  nOrder                        INT             NOT NULL AUTO_INCREMENT,
                  dwError                       INT             NOT NULL,
                  sError                        VARCHAR (255)   NOT NULL,
                  PRIMARY KEY (nOrder)
               );

            -- Create the temp Results table
        CREATE TEMPORARY TABLE Results
               (
                  nResultSet                    INT,
                  ObjectHead_Self_twObjectIx    BIGINT
               );

           SET twRPersonaIx  = IFNULL (twRPersonaIx,  0);
           SET twRMPObjectIx = IFNULL (twRMPObjectIx, 0);

            IF twRPersonaIx < 0
          THEN
               CALL call_Error (1, 'Session is invalid', nError);
        END IF ;

            IF twRMPObjectIx <= 0
          THEN
               CALL call_Error (2, 'PObject is invalid', nError);
        END IF ;

            IF nError = 0
          THEN
                 INSERT INTO Results
                 SELECT 0,
                        p.ObjectHead_Self_twObjectIx
                   FROM RMPObject AS p
                  WHERE p.ObjectHead_Self_twObjectIx = twRMPObjectIx;

                    SET nCount = ROW_COUNT();
                     IF nCount = 1 AND bType IS NOT NULL
                   THEN
                          INSERT INTO Results
                          SELECT 1,
                                 x.ObjectHead_Self_twObjectIx
                            FROM RMPObject AS p
                            JOIN RMPObject AS x ON x.ObjectHead_Parent_wClass     = p.ObjectHead_Self_wClass
                                               AND x.ObjectHead_Parent_twObjectIx = p.ObjectHead_Self_twObjectIx
                           WHERE p.ObjectHead_Self_twObjectIx = twRMPObjectIx
                        ORDER BY x.ObjectHead_Self_twObjectIx ASC;

                            CALL call_RMPObject_Select(0);
                            CALL call_RMPObject_Select(1);

                             SET bCommit = 1;
                   ELSE
                            CALL call_Error (3, 'PObject does not exist', nError);
                 END IF ;
        END IF ;

            IF bCommit = 0
          THEN
               SELECT dwError, sError FROM Error;
        END IF ;

          DROP TEMPORARY TABLE IF EXISTS Error;
          DROP TEMPORARY TABLE IF EXISTS Results;

           SET nResult = bCommit - 1 - nError;

  END$$

DELIMITER ;



DELIMITER $$

CREATE PROCEDURE call_RMTObject_Select
(
   IN nResultSet                   INT
)
BEGIN
       DECLARE OBJECTHEAD_FLAG_SUBSCRIBE_PARTIAL          INT DEFAULT 0x10;
       DECLARE OBJECTHEAD_FLAG_SUBSCRIBE_FULL             INT DEFAULT 0x20;

       DECLARE SBO_CLASS_RMTOBJECT                        INT DEFAULT 72;

        SELECT CONCAT
               (
                 '{ ',
                    '"ObjectHead": ',    Format_ObjectHead
                                         (
                                            t.ObjectHead_Parent_wClass,
                                            t.ObjectHead_Parent_twObjectIx,
                                            t.ObjectHead_Self_wClass,
                                            t.ObjectHead_Self_twObjectIx,
                                            IF (nResultSet = 0, OBJECTHEAD_FLAG_SUBSCRIBE_FULL, OBJECTHEAD_FLAG_SUBSCRIBE_PARTIAL),
                                            t.ObjectHead_twEventIz
                                         ),

                  ', "twRMTObjectIx": ', t.ObjectHead_Self_twObjectIx,      -- is this necessary

                  ', "Name": ',          Format_Name_T
                                         (
                                            t.Name_wsRMTObjectId
                                         ),
                  ', "Type": ',          Format_Type_T
                                         (
                                            t.Type_bType,
                                            t.Type_bSubtype,
                                            t.Type_bFiction
                                         ),
                  ', "Owner": ',         Format_Owner
                                         (
                                            t.Owner_twRPersonaIx
                                         ),
                  ', "Resource": ',      Format_Resource
                                         (
                                            t.Resource_qwResource,
                                            t.Resource_sName,
                                            t.Resource_sReference
                                         ),
                  ', "Transform": ',     Format_Transform
                                         (
                                            t.Transform_Position_dX,
                                            t.Transform_Position_dY,
                                            t.Transform_Position_dZ,
                                            t.Transform_Rotation_dX,
                                            t.Transform_Rotation_dY,
                                            t.Transform_Rotation_dZ,
                                            t.Transform_Rotation_dW,
                                            t.Transform_Scale_dX,
                                            t.Transform_Scale_dY,
                                            t.Transform_Scale_dZ
                                         ),
                  ', "Bound": ',         Format_Bound
                                         (
                                            t.Bound_dX,
                                            t.Bound_dY,
                                            t.Bound_dZ
                                         ),
                  ', "Properties": ',    Format_Properties_T
                                         (
                                            t.Properties_bLockToGround,
                                            t.Properties_bYouth,
                                            t.Properties_bAdult,
                                            t.Properties_bAvatar
                                         ),

                  ', "nChildren":  ',    IFNULL(cat.nCount, 0) + IFNULL(cap.nCount, 0),
                 ' }'
               ) AS `Object`
          FROM Results   AS x
          JOIN RMTObject AS t on t.ObjectHead_Self_twObjectIx = x.ObjectHead_Self_twObjectIx
     LEFT JOIN (SELECT ObjectHead_Parent_twObjectIx, COUNT(*) AS nCount FROM RMTObject WHERE ObjectHead_Parent_wClass = SBO_CLASS_RMTOBJECT GROUP BY ObjectHead_Parent_twObjectIx) AS cat ON cat.ObjectHead_Parent_twObjectIx = t.ObjectHead_Self_twObjectIx
     LEFT JOIN (SELECT ObjectHead_Parent_twObjectIx, COUNT(*) AS nCount FROM RMPObject WHERE ObjectHead_Parent_wClass = SBO_CLASS_RMTOBJECT GROUP BY ObjectHead_Parent_twObjectIx) AS cap ON cap.ObjectHead_Parent_twObjectIx = t.ObjectHead_Self_twObjectIx
         WHERE x.nResultSet = nResultSet;
  END$$

DELIMITER ;



DELIMITER $$

CREATE PROCEDURE get_RMTObject_Update
(
   IN    sIPAddress                    VARCHAR (16),
   IN    twRPersonaIx                  BIGINT,
   IN    twRMTObjectIx                 BIGINT,
   OUT   nResult                       BIGINT
)
BEGIN
       DECLARE MVO_RMTOBJECT_TYPE_PARCEL                  INT DEFAULT 11;

       DECLARE bCommit INT DEFAULT 0;
       DECLARE nError  INT DEFAULT 0;
       DECLARE nCount  INT;

       DECLARE bType TINYINT UNSIGNED;

            -- Create the temp Error table
        CREATE TEMPORARY TABLE Error
               (
                  nOrder                        INT             NOT NULL AUTO_INCREMENT,
                  dwError                       INT             NOT NULL,
                  sError                        VARCHAR (255)   NOT NULL,
                  PRIMARY KEY (nOrder)
               );

            -- Create the temp Results table
        CREATE TEMPORARY TABLE Results
               (
                  nResultSet                    INT,
                  ObjectHead_Self_twObjectIx    BIGINT
               );

           SET twRPersonaIx  = IFNULL (twRPersonaIx,  0);
           SET twRMTObjectIx = IFNULL (twRMTObjectIx, 0);

            IF twRPersonaIx < 0
          THEN
               CALL call_Error (1, 'Session is invalid', nError);
        END IF ;

            IF twRMTObjectIx <= 0
          THEN
               CALL call_Error (2, 'TObject is invalid', nError);
        END IF ;

            IF nError = 0
          THEN
                 SELECT t.Type_bType INTO bType
                   FROM RMTObject AS t
                  WHERE t.ObjectHead_Self_twObjectIx = twRMTObjectIx;

                 INSERT INTO Results
                 SELECT 0,
                        t.ObjectHead_Self_twObjectIx
                   FROM RMTObject AS t
                  WHERE t.ObjectHead_Self_twObjectIx = twRMTObjectIx;

                    SET nCount = ROW_COUNT ();
                     IF nCount = 1 AND bType IS NOT NULL
                   THEN
                              IF bType <> MVO_RMTOBJECT_TYPE_PARCEL
                            THEN
                                   INSERT INTO Results
                                   SELECT 1,
                                          x.ObjectHead_Self_twObjectIx
                                     FROM RMTObject AS t
                                     JOIN RMTObject AS x ON x.ObjectHead_Parent_wClass     = t.ObjectHead_Self_wClass
                                                        AND x.ObjectHead_Parent_twObjectIx = t.ObjectHead_Self_twObjectIx
                                    WHERE t.ObjectHead_Self_twObjectIx = twRMTObjectIx
                                 ORDER BY x.ObjectHead_Self_twObjectIx ASC;
                            ELSE
                                   INSERT INTO Results
                                   SELECT 1,
                                          p.ObjectHead_Self_twObjectIx
                                     FROM RMTObject AS t
                                     JOIN RMPObject AS p ON p.ObjectHead_Parent_wClass     = t.ObjectHead_Self_wClass
                                                        AND p.ObjectHead_Parent_twObjectIx = t.ObjectHead_Self_twObjectIx
                                    WHERE t.ObjectHead_Self_twObjectIx = twRMTObjectIx
                                 ORDER BY p.ObjectHead_Self_twObjectIx ASC;
                          END IF ;

                            CALL call_RMTObject_Select(0);
                              IF bType <> MVO_RMTOBJECT_TYPE_PARCEL
                            THEN
                                     CALL call_RMTObject_Select (1);
                            ELSE
                                     CALL call_RMPObject_Select (1);
                          END IF ;

                             SET bCommit = 1;
                   ELSE
                            CALL call_Error (3, 'TObject does not exist', nError);
                 END IF ;
        END IF ;

            IF bCommit = 0
          THEN
               SELECT dwError, sError FROM Error;
        END IF ;

          DROP TEMPORARY TABLE IF EXISTS Error;
          DROP TEMPORARY TABLE IF EXISTS Results;

           SET nResult = bCommit - 1 - nError;

  END$$

DELIMITER ;



DELIMITER $$
CREATE PROCEDURE call_RMCObject_Select(
   IN nResultSet                   INT
)
BEGIN
       DECLARE OBJECTHEAD_FLAG_SUBSCRIBE_PARTIAL          INT DEFAULT 0x10;
       DECLARE OBJECTHEAD_FLAG_SUBSCRIBE_FULL             INT DEFAULT 0x20;

       DECLARE SBO_CLASS_RMCOBJECT                        INT DEFAULT 71;

        SELECT CONCAT
               (
                 '{ ',
                    '"ObjectHead": ',    Format_ObjectHead
                                         (
                                            c.ObjectHead_Parent_wClass,
                                            c.ObjectHead_Parent_twObjectIx,
                                            c.ObjectHead_Self_wClass,
                                            c.ObjectHead_Self_twObjectIx,
                                            IF (nResultSet = 0, OBJECTHEAD_FLAG_SUBSCRIBE_FULL, OBJECTHEAD_FLAG_SUBSCRIBE_PARTIAL),
                                            c.ObjectHead_twEventIz
                                         ),

                  ', "twRMCObjectIx": ', c.ObjectHead_Self_twObjectIx,      -- is this necessary

                  ', "Name": ',          Format_Name_C
                                         (
                                            c.Name_wsRMCObjectId
                                         ),
                  ', "Type": ',          Format_Type_C
                                         (
                                            c.Type_bType,
                                            c.Type_bSubtype,
                                            c.Type_bFiction
                                         ),
                  ', "Owner": ',         Format_Owner
                                         (
                                            c.Owner_twRPersonaIx
                                         ),
                  ', "Resource": ',      Format_Resource
                                         (
                                            c.Resource_qwResource,
                                            c.Resource_sName,
                                            c.Resource_sReference
                                         ),
                  ', "Transform": ',     Format_Transform
                                         (
                                            c.Transform_Position_dX,
                                            c.Transform_Position_dY,
                                            c.Transform_Position_dZ,
                                            c.Transform_Rotation_dX,
                                            c.Transform_Rotation_dY,
                                            c.Transform_Rotation_dZ,
                                            c.Transform_Rotation_dW,
                                            c.Transform_Scale_dX,
                                            c.Transform_Scale_dY,
                                            c.Transform_Scale_dZ
                                         ),
                  ', "Orbit_Spin": ',    Format_Orbit_Spin
                                         (
                                            c.Orbit_Spin_tmPeriod,
                                            c.Orbit_Spin_tmStart,
                                            c.Orbit_Spin_dA,
                                            c.Orbit_Spin_dB
                                         ),
                  ', "Bound": ',         Format_Bound
                                         (
                                            c.Bound_dX,
                                            c.Bound_dY,
                                            c.Bound_dZ
                                         ),
                  ', "Properties": ',    Format_Properties_C
                                         (
                                            c.Properties_fMass,
                                            c.Properties_fGravity,
                                            c.Properties_fColor,
                                            c.Properties_fBrightness,
                                            c.Properties_fReflectivity
                                         ),

                  ', "nChildren":  ',    IFNULL(cac.nCount, 0) + IFNULL(cat.nCount, 0),
                 ' }'
               ) AS `Object`
          FROM Results   AS x
          JOIN RMCObject AS c on c.ObjectHead_Self_twObjectIx = x.ObjectHead_Self_twObjectIx
     LEFT JOIN (SELECT ObjectHead_Parent_twObjectIx, COUNT(*) AS nCount FROM RMCObject WHERE ObjectHead_Parent_wClass = SBO_CLASS_RMCOBJECT GROUP BY ObjectHead_Parent_twObjectIx) AS cac ON cac.ObjectHead_Parent_twObjectIx = c.ObjectHead_Self_twObjectIx
     LEFT JOIN (SELECT ObjectHead_Parent_twObjectIx, COUNT(*) AS nCount FROM RMTObject WHERE ObjectHead_Parent_wClass = SBO_CLASS_RMCOBJECT GROUP BY ObjectHead_Parent_twObjectIx) AS cat ON cat.ObjectHead_Parent_twObjectIx = c.ObjectHead_Self_twObjectIx
         WHERE x.nResultSet = nResultSet;
  END$$

DELIMITER ;



DELIMITER $$

CREATE PROCEDURE get_RMCObject_Update
(
   IN    sIPAddress                    VARCHAR (16),
   IN    twRPersonaIx                  BIGINT,
   IN    twRMCObjectIx                 BIGINT,
   OUT   nResult                       BIGINT
)
BEGIN
       DECLARE MVO_RMCOBJECT_TYPE_SURFACE                 INT DEFAULT 17;

       DECLARE bCommit INT DEFAULT 0;
       DECLARE nError  INT DEFAULT 0;
       DECLARE nCount  INT;

       DECLARE bType TINYINT UNSIGNED;

            -- Create the temp Error table
        CREATE TEMPORARY TABLE Error
               (
                  nOrder                        INT             NOT NULL AUTO_INCREMENT,
                  dwError                       INT             NOT NULL,
                  sError                        VARCHAR (255)   NOT NULL,
                  PRIMARY KEY (nOrder)
               );

            -- Create the temp Results table
        CREATE TEMPORARY TABLE Results
               (
                  nResultSet                    INT,
                  ObjectHead_Self_twObjectIx    BIGINT
               );

           SET twRPersonaIx  = IFNULL (twRPersonaIx,  0);
           SET twRMCObjectIx = IFNULL (twRMCObjectIx, 0);

            IF twRPersonaIx < 0
          THEN
               CALL call_Error (1, 'Session is invalid', nError);
        END IF ;

            IF twRMCObjectIx <= 0
          THEN
               CALL call_Error (2, 'CObject is invalid', nError);
        END IF ;

            IF nError = 0
          THEN
                 SELECT c.Type_bType INTO bType
                   FROM RMCObject AS c
                  WHERE c.ObjectHead_Self_twObjectIx = twRMCObjectIx;

                 INSERT INTO Results
                 SELECT 0,
                        c.ObjectHead_Self_twObjectIx
                   FROM RMCObject AS c
                  WHERE c.ObjectHead_Self_twObjectIx = twRMCObjectIx;

                    SET nCount = ROW_COUNT ();
                     IF nCount = 1 AND bType IS NOT NULL
                   THEN
                              IF bType <> MVO_RMCOBJECT_TYPE_SURFACE
                            THEN
                                   INSERT INTO Results
                                   SELECT 1,
                                          x.ObjectHead_Self_twObjectIx
                                     FROM RMCObject AS c
                                     JOIN RMCObject AS x ON x.ObjectHead_Parent_wClass     = c.ObjectHead_Self_wClass
                                                        AND x.ObjectHead_Parent_twObjectIx = c.ObjectHead_Self_twObjectIx
                                    WHERE c.ObjectHead_Self_twObjectIx = twRMCObjectIx
                                 ORDER BY x.ObjectHead_Self_twObjectIx ASC;
                            ELSE
                                   INSERT INTO Results
                                   SELECT 1,
                                          t.ObjectHead_Self_twObjectIx
                                     FROM RMCObject AS c
                                     JOIN RMTObject AS t ON t.ObjectHead_Parent_wClass     = c.ObjectHead_Self_wClass
                                                        AND t.ObjectHead_Parent_twObjectIx = c.ObjectHead_Self_twObjectIx
                                    WHERE c.ObjectHead_Self_twObjectIx = twRMCObjectIx
                                 ORDER BY t.ObjectHead_Self_twObjectIx ASC;
                          END IF ;

                            CALL call_RMCObject_Select(0);
                              IF bType <> MVO_RMCOBJECT_TYPE_SURFACE
                            THEN
                                     CALL call_RMCObject_Select (1);
                            ELSE
                                     CALL call_RMTObject_Select (1);
                          END IF ;

                             SET bCommit = 1;
                   ELSE
                            CALL call_Error (3, 'CObject does not exist', nError);
                 END IF ;
        END IF ;

            IF bCommit = 0
          THEN
               SELECT dwError, sError FROM Error;
        END IF ;

          DROP TEMPORARY TABLE IF EXISTS Error;
          DROP TEMPORARY TABLE IF EXISTS Results;

           SET nResult = bCommit - 1 - nError;

  END$$

DELIMITER ;



DELIMITER $$

CREATE PROCEDURE call_RMRoot_Select
(
   IN nResultSet                   INT
)
BEGIN
       DECLARE OBJECTHEAD_FLAG_SUBSCRIBE_PARTIAL          INT DEFAULT 0x10;
       DECLARE OBJECTHEAD_FLAG_SUBSCRIBE_FULL             INT DEFAULT 0x20;

        SELECT CONCAT
               (
                 '{ ',
                    '"ObjectHead": ',    Format_ObjectHead
                                         (
                                            r.ObjectHead_Parent_wClass,
                                            r.ObjectHead_Parent_twObjectIx,
                                            r.ObjectHead_Self_wClass,
                                            r.ObjectHead_Self_twObjectIx,
                                            IF (nResultSet = 0, OBJECTHEAD_FLAG_SUBSCRIBE_FULL, OBJECTHEAD_FLAG_SUBSCRIBE_PARTIAL),
                                            r.ObjectHead_twEventIz
                                         ),

                  ', "twRMRootIx": ',    r.ObjectHead_Self_twObjectIx,      -- is this necessary

                  ', "Name": ',          Format_Name_R
                                         (
                                            r.Name_wsRMRootId
                                         ),
                  ', "Owner": ',         Format_Owner
                                         (
                                            r.Owner_twRPersonaIx
                                         ),
                 ' }'
               ) AS `Object`
          FROM Results  AS x
          JOIN RMRoot   AS r on r.ObjectHead_Self_twObjectIx = x.ObjectHead_Self_twObjectIx
         WHERE x.nResultSet = nResultSet;
  END$$

DELIMITER ;



DELIMITER $$

CREATE PROCEDURE get_RMRoot_Update
(
   IN    sIPAddress                    VARCHAR (16),
   IN    twRPersonaIx                  BIGINT,
   IN    twRMRootIx                    BIGINT,
   OUT   nResult                       BIGINT
)
BEGIN
       DECLARE bCommit INT DEFAULT 0;
       DECLARE nError  INT DEFAULT 0;
       DECLARE nCount  INT;

            -- Create the temp Error table
        CREATE TEMPORARY TABLE Error
               (
                  nOrder                        INT             NOT NULL AUTO_INCREMENT,
                  dwError                       INT             NOT NULL,
                  sError                        VARCHAR (255)   NOT NULL,
                  PRIMARY KEY (nOrder)
               );

            -- Create the temp Results table
        CREATE TEMPORARY TABLE Results
               (
                  nResultSet                    INT,
                  ObjectHead_Self_twObjectIx    BIGINT
               );

           SET twRPersonaIx = IFNULL (twRPersonaIx, 0);
           SET twRMRootIx   = IFNULL (twRMRootIx,   0);

            IF twRPersonaIx < 0
          THEN
               CALL call_Error (1, 'Session is invalid', nError);
        END IF ;

            IF twRMRootIx <= 0
          THEN
               CALL call_Error (2, 'Root is invalid', nError);
        END IF ;

            IF nError = 0
          THEN
                 INSERT INTO Results
                 SELECT 0,
                        r.ObjectHead_Self_twObjectIx
                   FROM RMRoot    AS r
                  WHERE r.ObjectHead_Self_twObjectIx = twRMRootIx;

                    SET nCount = ROW_COUNT ();
                     IF nCount = 1
                   THEN
                          INSERT INTO Results
                          SELECT 1,
                                 c.ObjectHead_Self_twObjectIx
                            FROM RMRoot    AS r
                            JOIN RMCObject AS c ON c.ObjectHead_Parent_wClass     = r.ObjectHead_Self_wClass
                                                   AND c.ObjectHead_Parent_twObjectIx = r.ObjectHead_Self_twObjectIx
                           WHERE r.ObjectHead_Self_twObjectIx = twRMRootIx
                        ORDER BY c.ObjectHead_Self_twObjectIx ASC;

                          INSERT INTO Results
                          SELECT 2,
                                 t.ObjectHead_Self_twObjectIx
                            FROM RMRoot    AS r
                            JOIN RMTObject AS t ON t.ObjectHead_Parent_wClass     = r.ObjectHead_Self_wClass
                                                   AND t.ObjectHead_Parent_twObjectIx = r.ObjectHead_Self_twObjectIx
                           WHERE r.ObjectHead_Self_twObjectIx = twRMRootIx
                        ORDER BY t.ObjectHead_Self_twObjectIx ASC;

                          INSERT INTO Results
                          SELECT 3,
                                 p.ObjectHead_Self_twObjectIx
                            FROM RMRoot    AS r
                            JOIN RMPObject AS p ON p.ObjectHead_Parent_wClass     = r.ObjectHead_Self_wClass
                                                   AND p.ObjectHead_Parent_twObjectIx = r.ObjectHead_Self_twObjectIx
                           WHERE r.ObjectHead_Self_twObjectIx = twRMRootIx
                        ORDER BY p.ObjectHead_Self_twObjectIx ASC;

                            CALL call_RMRoot_Select(0);
                            CALL call_RMCObject_Select(1);
                            CALL call_RMTObject_Select(2);
                            CALL call_RMPObject_Select(3);

                             SET bCommit = 1;
                   ELSE
                            CALL call_Error (3, 'Root does not exist', nError);
                 END IF ;
        END IF ;

            IF bCommit = 0
          THEN
               SELECT dwError, sError FROM Error;
        END IF ;

          DROP TEMPORARY TABLE IF EXISTS Error;
          DROP TEMPORARY TABLE IF EXISTS Results;

           SET nResult = bCommit - 1 - nError;

  END$$

DELIMITER ;
