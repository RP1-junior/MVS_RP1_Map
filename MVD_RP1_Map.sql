/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                                 MVD_RP1_Map : Database.sql                                                 ~~
~~                                                 MySQL Database Creation Script                                             ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2023 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

-- Rename [{MVD_RP1_Map}] to your desired database name
-- This script creates a MySQL database with UTF-8 support and appropriate settings

-- Drop database (optional - remove if you want to preserve existing data)
-- DROP DATABASE [{MVD_RP1_Map}];

CREATE DATABASE IF NOT EXISTS MVD_RP1_Map;

USE MVD_RP1_Map;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~
~~ MySQL Database Creation Notes:
~~
~~ 1. File Management: MySQL handles data files automatically. No need to specify file paths.
~~ 2. Character Set: utf8mb4 is recommended for full UTF-8 support including emojis.
~~ 3. Storage Engine: InnoDB is recommended for ACID compliance and foreign key support.
~~ 4. User Management: Create dedicated users instead of using root for applications.
~~ 5. Configuration: Many SQL Server database settings are handled in MySQL's my.cnf file.
~~
~~ Recommended my.cnf settings for this database:
~~ [mysqld]
~~ default-storage-engine=innodb
~~ innodb_file_per_table=1
~~ innodb_buffer_pool_size=1G  # Adjust based on available RAM
~~ max_connections=200
~~ query_cache_size=32M
~~ log-bin=mysql-bin
~~ binlog_format=ROW
~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                                 MVD_RP1_Map : RMCObject.sql                                                ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2023 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

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

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

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

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

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

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                                  MVD_RP1_Map : RMEvent.sql                                                 ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2025 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

CREATE TABLE RMEvent
(
   twEventIx                           BIGINT            NOT NULL AUTO_INCREMENT,

   sType                               VARCHAR (32)       NOT NULL,

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

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                                 MVD_RP1_Map : RMPObject.sql                                                ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2023 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

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

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

CREATE TABLE RMPObject
(
   ObjectHead_Parent_wClass            SMALLINT          NOT NULL,
   ObjectHead_Parent_twObjectIx        BIGINT            NOT NULL,
   ObjectHead_Self_wClass              SMALLINT          NOT NULL,
   ObjectHead_Self_twObjectIx          BIGINT            NOT NULL AUTO_INCREMENT,
   ObjectHead_twEventIz                BIGINT            NOT NULL,
   ObjectHead_wFlags                   SMALLINT          NOT NULL,

   Name_wsRMPObjectId                  VARCHAR (48)      NOT NULL DEFAULT '',
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

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

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

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                                  MVD_RP1_Map : RMRoot.sql                                                  ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2023 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

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

INSERT INTO RMRoot
       ( ObjectHead_Parent_wClass, ObjectHead_Parent_twObjectIx, ObjectHead_Self_wClass, ObjectHead_twEventIz, ObjectHead_wFlags, Name_wsRMRootId, Owner_twRPersonaIx )
VALUES ( 52,                       1,                            70,                     0,                    32,                'Root',          1                  );

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

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

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                                MVD_RP1_Map : RMTBuilding.sql                                               ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2023 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

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

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                                 MVD_RP1_Map : RMTMatrix.sql                                                ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2023 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

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

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                                 MVD_RP1_Map : RMTObject.sql                                                ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2023 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

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

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

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

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

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

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                                 MVD_RP1_Map : ArcLength.sql                                                ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2023 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

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

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                              MVD_RP1_Map : DateTime2_Time.sql                                              ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2023 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

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

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                              MVD_RP1_Map : Date_DateTime2.sql                                              ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2023 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

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

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                               MVD_RP1_Map : Format_Bound.sql                                               ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2023 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

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
      RETURN CONCAT ('{ "Max": ', Format_Double3 (dX, dY, dZ), ' }');
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                              MVD_RP1_Map : Format_Control.sql                                              ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2025 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

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

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                               MVD_RP1_Map : Format_Double.sql                                              ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2023 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE FUNCTION Format_Double
(
   d   DOUBLE
)
RETURNS VARCHAR (32)
DETERMINISTIC
BEGIN

      DECLARE dA      DOUBLE DEFAULT ABS (d);
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
                          WHILE (dA < POW (10, -e) AND e < 310)
                             DO
                                     SET e = e + 1;
                      END WHILE ;

                            SET dA = dA * POW (10, e);
                            SET sExp = CONCAT ('e-', e);
                ELSEIF dA >= 10.0
                  THEN
                          WHILE (dA >= POW (10, e + 1) AND e < 310)
                             DO
                                     SET e = e + 1;
                      END WHILE ;

                            SET dA = dA * POW (10, -e);
                            SET sExp = CONCAT ('e+', e);
                END IF ;
       END IF ;

           IF (FLOOR (dA) = CEILING (dA))
         THEN
              SET sNum = CAST(dA AS CHAR);
         ELSE 
              SET sNum = FORMAT (dA, 16);
       END IF ;

       RETURN CONCAT (sSign, sNum, sExp);
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                              MVD_RP1_Map : Format_Double3.sql                                              ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2023 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

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

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                              MVD_RP1_Map : Format_Double4.sql                                              ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2023 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

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

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                               MVD_RP1_Map : Format_Float.sql                                               ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2023 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE FUNCTION Format_Float
(
   d   FLOAT
)
RETURNS VARCHAR (32)
DETERMINISTIC
BEGIN

      DECLARE dA      FLOAT        DEFAULT ABS (d);
      DECLARE e       INT          DEFAULT 0;
      DECLARE sSign   VARCHAR (1)  DEFAULT '';
      DECLARE sExp    VARCHAR (8)  DEFAULT '';
      DECLARE sNum    VARCHAR (20) DEFAULT '';

           IF (dA <> d)
         THEN
                   SET sSign = '-';
       END IF ;

           IF dA <> 0 AND dA <> 1
         THEN
                    IF dA < 1.0
                  THEN
                          WHILE (dA < POW (10, -e) AND e < 310)
                             DO
                                     SET e = e + 1;
                      END WHILE ;

                            SET dA = dA * POW (10, e);
                            SET sExp = CONCAT ('e-', e);

                ELSEIF dA >= 10.0
                  THEN
                          WHILE (dA >= POW (10, e + 1) AND e < 310)
                             DO
                                     SET e = e + 1;
                      END WHILE ;

                            SET dA = dA * POW (10, -e);
                            SET sExp = CONCAT ('e+', e);
                END IF ;
       END IF ;

           IF (FLOOR (dA) = CEILING (dA))
         THEN
                   SET sNum = CAST(dA AS CHAR);
         ELSE 
                   SET sNum = FORMAT (dA, 8);
       END IF ;

       RETURN CONCAT (sSign, sNum, sExp);
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                               MVD_RP1_Map : Format_Name_C.sql                                              ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2023 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

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

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                               MVD_RP1_Map : Format_Name_P.sql                                              ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2023 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE FUNCTION Format_Name_P
(
   wsRMPObjectId            VARCHAR (48)
)
RETURNS VARCHAR (256)
DETERMINISTIC
BEGIN
      RETURN CONCAT ('{ "wsRMPObjectId": "', wsRMPObjectId, '" }');
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                               MVD_RP1_Map : Format_Name_R.sql                                              ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2023 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

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

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                               MVD_RP1_Map : Format_Name_T.sql                                              ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2023 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

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

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                             MVD_RP1_Map : Format_ObjectHead.sql                                            ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2023 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

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

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                             MVD_RP1_Map : Format_Orbit_Spin.sql                                            ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2023 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

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

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                               MVD_RP1_Map : Format_Owner.sql                                               ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2023 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

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

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                            MVD_RP1_Map : Format_Properties_C.sql                                           ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2023 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

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

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                            MVD_RP1_Map : Format_Properties_T.sql                                           ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2023 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

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

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                              MVD_RP1_Map : Format_Resource.sql                                             ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2023 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

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

            IF SUBSTRING(sName, 1, 1) = '~'
          THEN
                    SET n = LOCATE (':', sName);
                     IF n > 0 AND LENGTH (sName) = n + 10
                   THEN
                             SET sName_ = CONCAT ('https://', SUBSTRING(sName, 2, n - 2), '-cdn.rp1.com/sector/', SUBSTRING(sName, n + 1, 1), '/', SUBSTRING(sName, n + 2, 3), '/', SUBSTRING(sName, n + 5, 3), '/', SUBSTRING(sName, n + 1, 10), '.json');
                 END IF ;
        END IF ;

        RETURN CONCAT
               (
                  '{ ', 
                    '"qwResource": ',   CAST(qwResource AS CHAR), 
                  ', "sName": "',       sName_, 
                 '", "sReference": "',  sReference, 
                 '" }'
               );
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                             MVD_RP1_Map : Format_Transform.sql                                             ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2023 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

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
      RETURN CONCAT ('{ "Position": ', Format_Double3 (Position_dX, Position_dY, Position_dZ), ', "Rotation": ', Format_Double4(Rotation_dX, Rotation_dY, Rotation_dZ, Rotation_dW), ', "Scale": ', Format_Double3 (Scale_dX, Scale_dY, Scale_dZ), ' }');
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                               MVD_RP1_Map : Format_Type_C.sql                                              ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2023 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

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

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                               MVD_RP1_Map : Format_Type_P.sql                                              ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2023 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

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

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                               MVD_RP1_Map : Format_Type_T.sql                                              ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2023 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

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

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                                MVD_RP1_Friends : IPstob.sql                                                ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                              Copyright 2023-2024 Metaversal Corporation. All rights reserved.                              ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE FUNCTION IPstob
(
   sIPAddress     VARCHAR (16)
)
RETURNS BINARY(4)
DETERMINISTIC
BEGIN
       RETURN UNHEX (HEX (INET_ATON (sIPAddress)));
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
          CAST(CONV (HEX (SUBSTRING(dwIPAddress, 1, 1)), 16, 10) AS CHAR), '.',
          CAST(CONV (HEX (SUBSTRING(dwIPAddress, 2, 1)), 16, 10) AS CHAR), '.',
          CAST(CONV (HEX (SUBSTRING(dwIPAddress, 3, 1)), 16, 10) AS CHAR), '.',
          CAST(CONV (HEX (SUBSTRING(dwIPAddress, 4, 1)), 16, 10) AS CHAR)
      );
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                                MVD_RP1_Map : Table_Error.sql                                               ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2025 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

-- Note: MySQL doesn't support table-valued functions like SQL Server
-- This would need to be implemented as a stored procedure that creates a temporary table
-- For now, this is converted to a comment indicating the table structure

-- CREATE TEMPORARY TABLE Error
-- (
--    nOrder                        INT             NOT NULL AUTO_INCREMENT PRIMARY KEY,
--    dwError                       INT             NOT NULL,
--    sError                        VARCHAR (255)   NOT NULL
-- );

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                                MVD_RP1_Map : Table_Event.sql                                               ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2025 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

-- Note: MySQL doesn't support table-valued functions like SQL Server
-- This would need to be implemented as a stored procedure that creates a temporary table
-- For now, this is converted to a comment indicating the table structure

-- CREATE TEMPORARY TABLE Event
-- (
--    nOrder                        INT             NOT NULL AUTO_INCREMENT PRIMARY KEY,
--    sType                         VARCHAR (32)    NOT NULL,
--    Self_wClass                   SMALLINT        NOT NULL,
--    Self_twObjectIx               BIGINT          NOT NULL,
--    Child_wClass                  SMALLINT        NOT NULL,
--    Child_twObjectIx              BIGINT          NOT NULL,
--    wFlags                        SMALLINT        NOT NULL,
--    twEventIz                     BIGINT          NOT NULL,
--    sJSON_Object                  TEXT            NOT NULL,
--    sJSON_Child                   TEXT            NOT NULL,
--    sJSON_Change                  TEXT            NOT NULL
-- );

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                               MVD_RP1_Map : Table_Results.sql                                              ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2025 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

-- Note: MySQL doesn't support table-valued functions like SQL Server
-- This would need to be implemented as a stored procedure that creates a temporary table
-- For now, this is converted to a comment indicating the table structure

-- CREATE TEMPORARY TABLE Results
-- (
--    nResultSet                    INT,
--    ObjectHead_Self_twObjectIx    BIGINT
-- );

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                               MVD_RP1_Map : Time_Current.sql                                               ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2023 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

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

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                              MVD_RP1_Map : Time_DateTime2.sql                                              ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2023 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

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

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                                MVD_RP1_Map : call_Error.sql                                                ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2025 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

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

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                              MVD_RP1_Map : call_Event_Push.sql                                             ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2025 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

/*
   Procedures call this function to push events onto the queue.
*/

DELIMITER $$

CREATE PROCEDURE call_Event_Push
(
   OUT   bError                        INT
)
BEGIN
        INSERT INTO RMEvent
             ( sType, Self_wClass, Self_twObjectIx, Child_wClass, Child_twObjectIx, wFlags, twEventIz, sJSON_Object, sJSON_Child, sJSON_Change )
        SELECT sType, Self_wClass, Self_twObjectIx, Child_wClass, Child_twObjectIx, wFlags, twEventIz, sJSON_Object, sJSON_Child, sJSON_Change
          FROM Event
      ORDER BY nOrder ASC;

           SET bError = IF (ROW_COUNT () > 0, 0, 1);
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                                MVD_RP1_Map : etl_Events.sql                                                ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2025 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

/*
   The NodeJS server calls this function periodically to retrieve events from the queue.
*/

DELIMITER $$

CREATE PROCEDURE etl_Events
(
   OUT   bError                        INT
)
BEGIN
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

          DROP TEMPORARY TABLE Events;

           SET bError = 0;
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                           MVD_RP1_Map : call_RMPObject_Event.sql                                           ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2025 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE call_RMPObject_Event
(
   IN    twRMPObjectIx                 BIGINT,
   OUT   twEventIz                     BIGINT,
   OUT   bError                        INT
)
BEGIN
        SELECT ObjectHead_twEventIz
          INTO twEventIz
          FROM RMPObject
         WHERE ObjectHead_Self_twObjectIx = twRMPObjectIx;

            -- Success will be tested on the update below

        UPDATE RMPObject
           SET ObjectHead_twEventIz = ObjectHead_twEventIz + 1
         WHERE ObjectHead_Self_twObjectIx = twRMPObjectIx;

           SET bError = IF (ROW_COUNT () = 1, 0, 1);
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                        MVD_RP1_Map : call_RMPObject_Event_Bound.sql                                        ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2023 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE call_RMPObject_Event_Bound
(
   IN    twRMPObjectIx                 BIGINT,
   IN    Bound_dX                      DOUBLE,
   IN    Bound_dY                      DOUBLE,
   IN    Bound_dZ                      DOUBLE,
   OUT   bError                        INT
)
BEGIN
       DECLARE SBO_CLASS_NULL                             INT DEFAULT 0;
       DECLARE SBO_CLASS_RMPOBJECT                        INT DEFAULT 73;

       DECLARE twEventIz BIGINT;

          CALL call_RMPObject_Event (twRMPObjectIx, twEventIz, bError);
            IF bError = 0
          THEN
                 UPDATE RMPObject
                    SET Bound_dX = Bound_dX,
                        Bound_dY = Bound_dY,
                        Bound_dZ = Bound_dZ
                  WHERE ObjectHead_Self_twObjectIx = twRMPObjectIx;

                    SET bError = IF (ROW_COUNT () = 1, 0, 1);

                     IF bError = 0
                   THEN
                          INSERT INTO Event
                                 (sType, Self_wClass, Self_twObjectIx, Child_wClass, Child_twObjectIx, wFlags, twEventIz, sJSON_Object, sJSON_Child, sJSON_Change)
                          SELECT 'BOUND',

                                 SBO_CLASS_RMPOBJECT,
                                 twRMPObjectIx,
                                 SBO_CLASS_NULL,
                                 0,
                                 0,
                                 twEventIz,

                                 CONCAT
                                 (
                                   '{ ',
                                     '"pBound": ',        Format_Bound
                                                          (
                                                             Bound_dX,
                                                             Bound_dY,
                                                             Bound_dZ
                                                          ),
                                  ' }'
                                 ),

                                 '{ }',

                                 '{ }';

                               SET bError = IF (ROW_COUNT () = 1, 0, 1);
                 END IF ;
        END IF ;
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                         MVD_RP1_Map : call_RMPObject_Event_Name.sql                                        ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2023 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE call_RMPObject_Event_Name
(
   IN    twRMPObjectIx                 BIGINT,
   IN    Name_wsRMPObjectId            VARCHAR (48),
   OUT   bError                        INT
)
BEGIN
       DECLARE SBO_CLASS_NULL                             INT DEFAULT 0;
       DECLARE SBO_CLASS_RMPOBJECT                        INT DEFAULT 73;

       DECLARE twEventIz BIGINT;

          CALL call_RMPObject_Event (twRMPObjectIx, twEventIz, bError);
            IF bError = 0
          THEN
                 UPDATE RMPObject
                    SET Name_wsRMPObjectId = Name_wsRMPObjectId
                  WHERE ObjectHead_Self_twObjectIx = twRMPObjectIx;

                    SET bError = IF (ROW_COUNT () = 1, 0, 1);

                     IF bError = 0
                   THEN
                          INSERT INTO Event
                                 (sType, Self_wClass, Self_twObjectIx, Child_wClass, Child_twObjectIx, wFlags, twEventIz, sJSON_Object, sJSON_Child, sJSON_Change)
                          SELECT 'NAME',

                                 SBO_CLASS_RMPOBJECT,
                                 twRMPObjectIx,
                                 SBO_CLASS_NULL,
                                 0,
                                 0,
                                 twEventIz,

                                 CONCAT
                                 (
                                   '{ ',
                                     '"pName": ',         Format_Name_P
                                                          (
                                                             Name_wsRMPObjectId
                                                          ),
                                  ' }'
                                 ),

                                 '{ }',

                                 '{ }';

                             SET bError = IF (ROW_COUNT () = 1, 0, 1);
                 END IF ;
        END IF ;
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                        MVD_RP1_Map : call_RMPObject_Event_Owner.sql                                        ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2023 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE call_RMPObject_Event_Owner
(
   IN    twRMPObjectIx                 BIGINT,
   IN    Owner_twRPersonaIx            BIGINT,
   OUT   bError                        INT
)
BEGIN
       DECLARE SBO_CLASS_NULL                             INT DEFAULT 0;
       DECLARE SBO_CLASS_RMPOBJECT                        INT DEFAULT 73;

       DECLARE twEventIz BIGINT;

          CALL call_RMPObject_Event (twRMPObjectIx, twEventIz, bError);
            IF bError = 0
          THEN
                 UPDATE RMPObject
                    SET Owner_twRPersonaIx = Owner_twRPersonaIx
                  WHERE ObjectHead_Self_twObjectIx = twRMPObjectIx;

                    SET bError = IF (ROW_COUNT () = 1, 0, 1);

                     IF bError = 0
                   THEN
                          INSERT INTO Event
                                 (sType, Self_wClass, Self_twObjectIx, Child_wClass, Child_twObjectIx, wFlags, twEventIz, sJSON_Object, sJSON_Child, sJSON_Change)
                          SELECT 'OWNER',

                                 SBO_CLASS_RMPOBJECT,
                                 twRMPObjectIx,
                                 SBO_CLASS_NULL,
                                 0,
                                 0,
                                 twEventIz,

                                 CONCAT
                                 (
                                   '{ ',
                                     '"pOwner": ',        Format_Owner
                                                          (
                                                             Owner_twRPersonaIx
                                                          ),
                                  ' }'
                                 ),

                                 '{ }',

                                 '{ }';

                               SET bError = IF (ROW_COUNT () = 1, 0, 1);
                 END IF ;
        END IF ;
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                       MVD_RP1_Map : call_RMPObject_Event_Resource.sql                                      ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2023 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE call_RMPObject_Event_Resource
(
   IN    twRMPObjectIx                 BIGINT,
   IN    Resource_qwResource           BIGINT,
   IN    Resource_sName                VARCHAR (48),
   IN    Resource_sReference           VARCHAR (128),
   OUT   bError                        INT
)
BEGIN
       DECLARE SBO_CLASS_NULL                             INT DEFAULT 0;
       DECLARE SBO_CLASS_RMPOBJECT                        INT DEFAULT 73;

       DECLARE twEventIz BIGINT;

          CALL call_RMPObject_Event (twRMPObjectIx, twEventIz, bError);
            IF bError = 0
          THEN
                 UPDATE RMPObject
                    SET Resource_qwResource = Resource_qwResource,
                        Resource_sName      = Resource_sName,
                        Resource_sReference = Resource_sReference       
                  WHERE ObjectHead_Self_twObjectIx = twRMPObjectIx;

                    SET bError = IF (ROW_COUNT () = 1, 0, 1);

                     IF bError = 0
                   THEN
                          INSERT INTO Event
                                 (sType, Self_wClass, Self_twObjectIx, Child_wClass, Child_twObjectIx, wFlags, twEventIz, sJSON_Object, sJSON_Child, sJSON_Change)
                          SELECT 'RESOURCE',

                                 SBO_CLASS_RMPOBJECT,
                                 twRMPObjectIx,
                                 SBO_CLASS_NULL,
                                 0,
                                 0,
                                 twEventIz,

                                 CONCAT
                                 (
                                   '{ ',
                                     '"pResource": ',     Format_Resource
                                                          (
                                                             Resource_qwResource,
                                                             Resource_sName,
                                                             Resource_sReference
                                                          ),
                                  ' }'
                                 ),

                                 '{ }',

                                 '{ }';

                               SET bError = IF (ROW_COUNT () = 1, 0, 1);
                 END IF ;
        END IF ;
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                   MVD_RP1_Map : call_RMPObject_Event_RMPObject_Close.sql                                   ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2023 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE call_RMPObject_Event_RMPObject_Close
(
   IN    twRMPObjectIx                 BIGINT,
   IN    twRMPObjectIx_Close           BIGINT,
   OUT   bError                        INT,
   IN    bReparent                     TINYINT UNSIGNED
)
BEGIN

       DECLARE SBO_CLASS_RMPOBJECT                        INT DEFAULT 73;
       DECLARE SBA_SUBSCRIBE_REFRESH_EVENT_EX_FLAG_CLOSE  INT DEFAULT 0x02;

       DECLARE twEventIz BIGINT;

          CALL call_RMPObject_Event (twRMPObjectIx, twEventIz, bError);
            IF bError = 0
          THEN
                     IF bReparent = 0
                   THEN
                          DELETE FROM RMPObject                                        -- we actually want to delete the entire tree - all the way down to the pobject!
                           WHERE ObjectHead_Self_twObjectIx = twRMPObjectIx_Close;
         
                             SET bError = IF (ROW_COUNT () = 1, 0, 1);
                 END IF ;

                     IF bError = 0
                   THEN
                          INSERT INTO Event
                                 (sType, Self_wClass, Self_twObjectIx, Child_wClass, Child_twObjectIx, wFlags, twEventIz, sJSON_Object, sJSON_Child, sJSON_Change)
                          SELECT 'RMPOBJECT_CLOSE',

                                 SBO_CLASS_RMPOBJECT,
                                 twRMPObjectIx,
                                 SBO_CLASS_RMPOBJECT,
                                 twRMPObjectIx_Close,
                                 SBA_SUBSCRIBE_REFRESH_EVENT_EX_FLAG_CLOSE,
                                 twEventIz,

                                 '{ }',

                                 '{ }',

                                 '{ }';

                             SET bError = IF (ROW_COUNT () = 1, 0, 1);
                 END IF ;
        END IF ;
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                    MVD_RP1_Map : call_RMPObject_Event_RMPObject_Open.sql                                   ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2023 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE call_RMPObject_Event_RMPObject_Open
(
   IN    twRMPObjectIx                 BIGINT,
   IN    Name_wsRMPObjectId            VARCHAR (48),
   IN    Type_bType                    TINYINT UNSIGNED,
   IN    Type_bSubtype                 TINYINT UNSIGNED,
   IN    Type_bFiction                 TINYINT UNSIGNED,
   IN    Type_bMovable                 TINYINT UNSIGNED,
   IN    Owner_twRPersonaIx            BIGINT,
   IN    Resource_qwResource           BIGINT,
   IN    Resource_sName                VARCHAR (48),
   IN    Resource_sReference           VARCHAR (128),
   IN    Transform_Position_dX         DOUBLE,
   IN    Transform_Position_dY         DOUBLE,
   IN    Transform_Position_dZ         DOUBLE,
   IN    Transform_Rotation_dX         DOUBLE,
   IN    Transform_Rotation_dY         DOUBLE,
   IN    Transform_Rotation_dZ         DOUBLE,
   IN    Transform_Rotation_dW         DOUBLE,
   IN    Transform_Scale_dX            DOUBLE,
   IN    Transform_Scale_dY            DOUBLE,
   IN    Transform_Scale_dZ            DOUBLE,
   IN    Bound_dX                      DOUBLE,
   IN    Bound_dY                      DOUBLE,
   IN    Bound_dZ                      DOUBLE,
   OUT   twRMPObjectIx_Open            BIGINT,
   OUT   bError                        INT,
   IN    bReparent                     TINYINT UNSIGNED
)
BEGIN

       DECLARE SBO_CLASS_RMPOBJECT                        INT DEFAULT 73;
       DECLARE SBA_SUBSCRIBE_REFRESH_EVENT_EX_FLAG_OPEN   INT DEFAULT 0x01;

       DECLARE twEventIz BIGINT;

          CALL call_RMPObject_Event (twRMPObjectIx, twEventIz, bError);
            IF bError = 0
          THEN
                     IF bReparent = 0
                   THEN
                          INSERT INTO RMPObject
                                 (ObjectHead_Parent_wClass, ObjectHead_Parent_twObjectIx, ObjectHead_Self_wClass, ObjectHead_twEventIz, ObjectHead_wFlags, Name_wsRMPObjectId, Type_bType, Type_bSubtype, Type_bFiction, Type_bMovable, Owner_twRPersonaIx, Resource_qwResource, Resource_sName, Resource_sReference, Transform_Position_dX, Transform_Position_dY, Transform_Position_dZ, Transform_Rotation_dX, Transform_Rotation_dY, Transform_Rotation_dZ, Transform_Rotation_dW, Transform_Scale_dX, Transform_Scale_dY, Transform_Scale_dZ, Bound_dX, Bound_dY, Bound_dZ)
                          VALUES (SBO_CLASS_RMPOBJECT,      twRMPObjectIx,                SBO_CLASS_RMPOBJECT,    0,                    32,                Name_wsRMPObjectId, Type_bType, Type_bSubtype, Type_bFiction, Type_bMovable, Owner_twRPersonaIx, Resource_qwResource, Resource_sName, Resource_sReference, Transform_Position_dX, Transform_Position_dY, Transform_Position_dZ, Transform_Rotation_dX, Transform_Rotation_dY, Transform_Rotation_dZ, Transform_Rotation_dW, Transform_Scale_dX, Transform_Scale_dY, Transform_Scale_dZ, Bound_dX, Bound_dY, Bound_dZ);
         
                             SET bError = IF (ROW_COUNT () = 1, 0, 1);

                             SET twRMPObjectIx_Open = LAST_INSERT_ID ();
                 END IF ;

                     IF bError = 0
                   THEN
                          INSERT INTO Event
                                 (sType, Self_wClass, Self_twObjectIx, Child_wClass, Child_twObjectIx, wFlags, twEventIz, sJSON_Object, sJSON_Child, sJSON_Change)
                          SELECT 'RMPOBJECT_OPEN',

                                 SBO_CLASS_RMPOBJECT,
                                 twRMPObjectIx,
                                 SBO_CLASS_RMPOBJECT,
                                 twRMPObjectIx_Open,
                                 SBA_SUBSCRIBE_REFRESH_EVENT_EX_FLAG_OPEN,
                                 twEventIz,

                                 '{ }',

                                 CONCAT
                                 (
                                   '{ ',
                                     '"pName": ',         Format_Name_P
                                                          (
                                                             Name_wsRMPObjectId
                                                          ),
                                   ', "pType": ',         Format_Type_P
                                                          (
                                                             Type_bType,
                                                             Type_bSubtype,
                                                             Type_bFiction,
                                                             Type_bMovable
                                                          ),
                                   ', "pOwner": ',        Format_Owner
                                                          (
                                                             Owner_twRPersonaIx
                                                          ),
                                   ', "pResource": ',     Format_Resource
                                                          (
                                                             Resource_qwResource,
                                                             Resource_sName,
                                                             Resource_sReference
                                                          ),
                                   ', "pTransform": ',    Format_Transform
                                                          (
                                                             Transform_Position_dX,
                                                             Transform_Position_dY,
                                                             Transform_Position_dZ,
                                                             Transform_Rotation_dX,
                                                             Transform_Rotation_dY,
                                                             Transform_Rotation_dZ,
                                                             Transform_Rotation_dW,
                                                             Transform_Scale_dX,
                                                             Transform_Scale_dY,
                                                             Transform_Scale_dZ
                                                          ),
                                   ', "pBound": ',        Format_Bound
                                                          (
                                                             Bound_dX,
                                                             Bound_dY,
                                                             Bound_dZ
                                                          ),
                                  ' }'
                                 ),

                                 '{ }';

                               SET bError = IF (ROW_COUNT () = 1, 0, 1);
                 END IF ;
        END IF ;
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                      MVD_RP1_Map : call_RMPObject_Event_Transform.sql                                      ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2023 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE call_RMPObject_Event_Transform
(
   IN    twRMPObjectIx                 BIGINT,
   IN    Transform_Position_dX         DOUBLE,
   IN    Transform_Position_dY         DOUBLE,
   IN    Transform_Position_dZ         DOUBLE,
   IN    Transform_Rotation_dX         DOUBLE,
   IN    Transform_Rotation_dY         DOUBLE,
   IN    Transform_Rotation_dZ         DOUBLE,
   IN    Transform_Rotation_dW         DOUBLE,
   IN    Transform_Scale_dX            DOUBLE,
   IN    Transform_Scale_dY            DOUBLE,
   IN    Transform_Scale_dZ            DOUBLE,
   OUT   bError                        INT
)
BEGIN
       DECLARE SBO_CLASS_NULL                             INT DEFAULT 0;
       DECLARE SBO_CLASS_RMPOBJECT                        INT DEFAULT 73;

       DECLARE twEventIz BIGINT;

          CALL call_RMPObject_Event (twRMPObjectIx, twEventIz, bError);
            IF bError = 0
          THEN
                 UPDATE RMPObject
                    SET Transform_Position_dX = Transform_Position_dX,
                        Transform_Position_dY = Transform_Position_dY,
                        Transform_Position_dZ = Transform_Position_dZ,
                        Transform_Rotation_dX = Transform_Rotation_dX,
                        Transform_Rotation_dY = Transform_Rotation_dY,
                        Transform_Rotation_dZ = Transform_Rotation_dZ,
                        Transform_Rotation_dW = Transform_Rotation_dW,
                        Transform_Scale_dX    = Transform_Scale_dX,
                        Transform_Scale_dY    = Transform_Scale_dY,
                        Transform_Scale_dZ    = Transform_Scale_dZ
                  WHERE ObjectHead_Self_twObjectIx = twRMPObjectIx;

                    SET bError = IF (ROW_COUNT () = 1, 0, 1);

                     IF bError = 0
                   THEN
                          INSERT INTO Event
                                 (sType, Self_wClass, Self_twObjectIx, Child_wClass, Child_twObjectIx, wFlags, twEventIz, sJSON_Object, sJSON_Child, sJSON_Change)
                          SELECT 'TRANSFORM',

                                 SBO_CLASS_RMPOBJECT,
                                 twRMPObjectIx,
                                 SBO_CLASS_NULL,
                                 0,
                                 0,
                                 twEventIz,

                                 CONCAT
                                 (
                                   '{ ',
                                     '"pTransform": ',    Format_Transform
                                                          (
                                                             Transform_Position_dX,
                                                             Transform_Position_dY,
                                                             Transform_Position_dZ,
                                                             Transform_Rotation_dX,
                                                             Transform_Rotation_dY,
                                                             Transform_Rotation_dZ,
                                                             Transform_Rotation_dW,
                                                             Transform_Scale_dX,
                                                             Transform_Scale_dY,
                                                             Transform_Scale_dZ
                                                          ),
                                  ' }'
                                 ),

                                 '{ }',

                                 '{ }';

                               SET bError = IF (ROW_COUNT () = 1, 0, 1);
                 END IF ;
        END IF ;
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                         MVD_RP1_Map : call_RMPObject_Event_Type.sql                                        ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2023 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE call_RMPObject_Event_Type
(
   IN    twRMPObjectIx                 BIGINT,
   IN    Type_bType                    TINYINT UNSIGNED,
   IN    Type_bSubtype                 TINYINT UNSIGNED,
   IN    Type_bFiction                 TINYINT UNSIGNED,
   IN    Type_bMovable                 TINYINT UNSIGNED,
   OUT   bError                        INT
)
BEGIN
       DECLARE SBO_CLASS_NULL                             INT DEFAULT 0;
       DECLARE SBO_CLASS_RMPOBJECT                        INT DEFAULT 73;

       DECLARE twEventIz BIGINT;

          CALL call_RMPObject_Event (twRMPObjectIx, twEventIz, bError);
            IF bError = 0
          THEN
                 UPDATE RMPObject
                    SET Type_bType    = Type_bType,
                        Type_bSubtype = Type_bSubtype,
                        Type_bFiction = Type_bFiction,
                        Type_bMovable = Type_bMovable
                  WHERE ObjectHead_Self_twObjectIx = twRMPObjectIx;

                    SET bError = IF (ROW_COUNT () = 1, 0, 1);

                     IF bError = 0
                   THEN
                          INSERT INTO Event
                                 (sType, Self_wClass, Self_twObjectIx, Child_wClass, Child_twObjectIx, wFlags, twEventIz, sJSON_Object, sJSON_Child, sJSON_Change)
                          SELECT 'TYPE',

                                 SBO_CLASS_RMPOBJECT,
                                 twRMPObjectIx,
                                 SBO_CLASS_NULL,
                                 0,
                                 0,
                                 twEventIz,

                                 CONCAT
                                 (
                                   '{ ',
                                     '"pType": ',         Format_Type_P
                                                          (
                                                             Type_bType,
                                                             Type_bSubtype,
                                                             Type_bFiction,
                                                             Type_bMovable
                                                          ),
                                  ' }'
                                 ),

                                 '{ }',

                                 '{ }';

                               SET bError = IF (ROW_COUNT () = 1, 0, 1);
                 END IF ;
        END IF ;
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                            MVD_RP1_Map : call_RMPObject_Log.sql                                            ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2025 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE call_RMPObject_Log
(
   IN    bOp                           TINYINT UNSIGNED,
   IN    sIPAddress                    VARCHAR (16),
   IN    twRPersonaIx                  BIGINT,
   IN    twRMPObjectIx                 BIGINT,
   OUT   bError                        INT
)
BEGIN
       DECLARE dwIPAddress BINARY (4) DEFAULT IPstob (sIPAddress);

        INSERT INTO RMPObjectLog
               (bOp, dwIPAddress, twRPersonaIx, twRMPObjectIx)
        VALUES (bOp, dwIPAddress, twRPersonaIx, twRMPObjectIx);
 
           SET bError = IF (ROW_COUNT () = 1, 0, 1);
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                           MVD_RP1_Map : call_RMPObject_Select.sql                                          ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2023 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

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
                    '"pObjectHead": ',   Format_ObjectHead
                                         (
                                            p.ObjectHead_Parent_wClass,
                                            p.ObjectHead_Parent_twObjectIx,
                                            p.ObjectHead_Self_wClass,
                                            p.ObjectHead_Self_twObjectIx,
                                            IF (nResultSet = 0, OBJECTHEAD_FLAG_SUBSCRIBE_FULL, OBJECTHEAD_FLAG_SUBSCRIBE_PARTIAL),
                                            p.ObjectHead_twEventIz
                                         ),

                  ', "twRMPObjectIx": ', p.ObjectHead_Self_twObjectIx,      -- is this necessary

                  ', "pName": ',         Format_Name_P
                                         (
                                            p.Name_wsRMPObjectId
                                         ),
                  ', "pType": ',         Format_Type_P
                                         (
                                            p.Type_bType,
                                            p.Type_bSubtype,
                                            p.Type_bFiction,
                                            p.Type_bMovable
                                         ),
                  ', "pOwner": ',        Format_Owner
                                         (
                                            p.Owner_twRPersonaIx
                                         ),
                  ', "pResource": ',     Format_Resource
                                         (
                                            p.Resource_qwResource,
                                            p.Resource_sName,
                                            p.Resource_sReference
                                         ),
                  ', "pTransform": ',    Format_Transform
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
                  ', "pBound": ',        Format_Bound
                                         (
                                            p.Bound_dX,
                                            p.Bound_dY,
                                            p.Bound_dZ
                                         ),

                  ', "nChildren":  ',    IFNULL (cap.nCount, 0),
                 ' }'               
               ) AS `Object`
          FROM Results   AS x
          JOIN RMPObject AS p on p.ObjectHead_Self_twObjectIx = x.ObjectHead_Self_twObjectIx
     LEFT JOIN (SELECT ObjectHead_Parent_twObjectIx, COUNT(*) AS nCount FROM RMPObject WHERE ObjectHead_Parent_wClass = SBO_CLASS_RMPOBJECT GROUP BY ObjectHead_Parent_twObjectIx) AS cap ON cap.ObjectHead_Parent_twObjectIx = p.ObjectHead_Self_twObjectIx
         WHERE x.nResultSet = nResultSet;
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                          MVD_RP1_Map : call_RMPObject_Validate.sql                                         ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2023 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE call_RMPObject_Validate
(
   IN    twRPersonaIx                  BIGINT,
   IN    twRMPObjectIx                 BIGINT,
   OUT   ObjectHead_Parent_wClass      SMALLINT,
   OUT   ObjectHead_Parent_twObjectIx  BIGINT,
   INOUT nError                        INT
)
BEGIN
       DECLARE nCount INT;

        SELECT o.ObjectHead_Parent_wClass, o.ObjectHead_Parent_twObjectIx
          INTO   ObjectHead_Parent_wClass,   ObjectHead_Parent_twObjectIx
          FROM RMPObject AS o
         WHERE o.ObjectHead_Self_twObjectIx = twRMPObjectIx;

           SET nCount = ROW_COUNT ();

            IF twRPersonaIx <= 0
          THEN
                   CALL call_Error (1, 'twRPersonaIx is invalid',  nError);
        ELSEIF twRMPObjectIx <= 0
          THEN
                   CALL call_Error (2, 'twRMPObjectIx is invalid', nError);
        ELSEIF nCount <> 1
          THEN
                   CALL call_Error (3, 'twRMPObjectIx is unknown', nError);
        ELSEIF twRPersonaIx <> twRPersonaIx
          THEN                                                                -- TBD
                   CALL call_Error (4, 'Invalid rights',           nError);
        END IF ;
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                       MVD_RP1_Map : call_RMPObject_Validate_Bound.sql                                      ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2023 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE call_RMPObject_Validate_Bound
(
   IN    ObjectHead_Parent_wClass      SMALLINT,
   IN    ObjectHead_Parent_twObjectIx  BIGINT,
   IN    twRMPObjectIx                 BIGINT,
   IN    Bound_dX                      DOUBLE,
   IN    Bound_dY                      DOUBLE,
   IN    Bound_dZ                      DOUBLE,
   INOUT nError                        INT
)
BEGIN
            IF Bound_dX IS NULL OR Bound_dX <> Bound_dX
          THEN
                   CALL call_Error (21, 'Bound_dX is NULL or NaN', nError);
        ELSEIF Bound_dX < 0
          THEN
                   CALL call_Error (21, 'Bound_dX is invalid',     nError);
        END IF ;

            IF Bound_dY IS NULL OR Bound_dY <> Bound_dY
          THEN
                   CALL call_Error (21, 'Bound_dY is NULL or NaN', nError);
        ELSEIF Bound_dY < 0
          THEN
                   CALL call_Error (21, 'Bound_dY is invalid',     nError);
        END IF ;

            IF Bound_dZ IS NULL OR Bound_dZ <> Bound_dZ
          THEN
                   CALL call_Error (21, 'Bound_dZ is NULL or NaN', nError);
        ELSEIF Bound_dZ < 0
          THEN
                   CALL call_Error (21, 'Bound_dZ is invalid',     nError);
        END IF ;

            IF nError = 0
          THEN
                     -- validate bound is inside  parent's   bound
                     -- validate bound is outside children's bound
                    SET nError = nError;
        END IF ;
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                       MVD_RP1_Map : call_RMPObject_Validate_Name.sql                                       ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2023 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE call_RMPObject_Validate_Name
(
   IN    ObjectHead_Parent_wClass      SMALLINT,
   IN    ObjectHead_Parent_twObjectIx  BIGINT,
   IN    twRMPObjectIx                 BIGINT,
   IN    Name_wsRMPObjectId            VARCHAR (48),
   INOUT nError                        INT
)
BEGIN
            IF Name_wsRMPObjectId IS NULL
          THEN
                   CALL call_Error (21, 'Name_wsRMPObjectId is NULL', nError);
        END IF ;
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                       MVD_RP1_Map : call_RMPObject_Validate_Owner.sql                                      ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2023 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE call_RMPObject_Validate_Owner
(
   IN    ObjectHead_Parent_wClass      SMALLINT,
   IN    ObjectHead_Parent_twObjectIx  BIGINT,
   IN    twRMPObjectIx                 BIGINT,
   IN    Owner_twRPersonaIx            BIGINT,
   INOUT nError                        INT
)
BEGIN
            IF Owner_twRPersonaIx IS NULL
          THEN
                   CALL call_Error (21, 'Owner_twRPersonaIx is NULL',    nError);
        ELSEIF Owner_twRPersonaIx NOT BETWEEN 1 AND 0x0000FFFFFFFFFFFC
          THEN
                   CALL call_Error (21, 'Owner_twRPersonaIx is invalid', nError);
        END IF ;
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                     MVD_RP1_Map : call_RMPObject_Validate_Resource.sql                                     ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2023 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE call_RMPObject_Validate_Resource
(
   IN    ObjectHead_Parent_wClass      SMALLINT,
   IN    ObjectHead_Parent_twObjectIx  BIGINT,
   IN    twRMPObjectIx                 BIGINT,
   IN    Resource_qwResource           BIGINT,
   IN    Resource_sName                VARCHAR (48),
   IN    Resource_sReference           VARCHAR (128),
   INOUT nError                        INT
)
BEGIN
            IF Resource_qwResource IS NULL
          THEN
                   CALL call_Error (21, 'Resource_qwResource is NULL', nError);
        END IF ;
            IF Resource_sName IS NULL
          THEN
                   CALL call_Error (21, 'Resource_sName is NULL',      nError);
        END IF ;
            IF Resource_sReference IS NULL
          THEN
                   CALL call_Error (21, 'Resource_sReference is NULL', nError);
        END IF ;

            -- do we want to check sName and sReference for length or invalid characters
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                     MVD_RP1_Map : call_RMPObject_Validate_Transform.sql                                    ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2023 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE call_RMPObject_Validate_Transform
(
   IN    ObjectHead_Parent_wClass      SMALLINT,
   IN    ObjectHead_Parent_twObjectIx  BIGINT,
   IN    twRMPObjectIx                 BIGINT,
   IN    Transform_Position_dX         DOUBLE,
   IN    Transform_Position_dY         DOUBLE,
   IN    Transform_Position_dZ         DOUBLE,
   IN    Transform_Rotation_dX         DOUBLE,
   IN    Transform_Rotation_dY         DOUBLE,
   IN    Transform_Rotation_dZ         DOUBLE,
   IN    Transform_Rotation_dW         DOUBLE,
   IN    Transform_Scale_dX            DOUBLE,
   IN    Transform_Scale_dY            DOUBLE,
   IN    Transform_Scale_dZ            DOUBLE,
   INOUT nError                        INT
)
BEGIN
            IF Transform_Position_dX IS NULL OR Transform_Position_dX <> Transform_Position_dX
          THEN
                   CALL call_Error (21, 'Transform_Position_dX is NULL or NaN', nError);
        END IF ;
            IF Transform_Position_dY IS NULL OR Transform_Position_dY <> Transform_Position_dY
          THEN
                   CALL call_Error (21, 'Transform_Position_dY is NULL or NaN', nError);
        END IF ;
            IF Transform_Position_dZ IS NULL OR Transform_Position_dZ <> Transform_Position_dZ
          THEN
                   CALL call_Error (21, 'Transform_Position_dZ is NULL or NaN', nError);
        END IF ;

            IF Transform_Rotation_dX IS NULL OR Transform_Rotation_dX <> Transform_Rotation_dX
          THEN
                   CALL call_Error (21, 'Transform_Rotation_dX is NULL or NaN', nError);
        END IF ;
            IF Transform_Rotation_dY IS NULL OR Transform_Rotation_dY <> Transform_Rotation_dY
          THEN
                   CALL call_Error (21, 'Transform_Rotation_dY is NULL or NaN', nError);
        END IF ;
            IF Transform_Rotation_dZ IS NULL OR Transform_Rotation_dZ <> Transform_Rotation_dZ
          THEN
                   CALL call_Error (21, 'Transform_Rotation_dZ is NULL or NaN', nError);
        END IF ;
            IF Transform_Rotation_dW IS NULL OR Transform_Rotation_dW <> Transform_Rotation_dW
          THEN
                   CALL call_Error (21, 'Transform_Rotation_dW is NULL or NaN', nError);
        END IF ;

            IF Transform_Scale_dX IS NULL OR Transform_Scale_dX <> Transform_Scale_dX
          THEN
                   CALL call_Error (21, 'Transform_Scale_dX is NULL or NaN',    nError);
        END IF ;
            IF Transform_Scale_dY IS NULL OR Transform_Scale_dY <> Transform_Scale_dY
          THEN
                   CALL call_Error (21, 'Transform_Scale_dY is NULL or NaN',    nError);
        END IF ;
            IF Transform_Scale_dZ IS NULL OR Transform_Scale_dZ <> Transform_Scale_dZ
          THEN
                   CALL call_Error (21, 'Transform_Scale_dZ is NULL or NaN',    nError);
        END IF ;

            IF nError = 0
          THEN
                     -- validate position is inside parent's bound
                    SET nError = nError;
        END IF ;
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                       MVD_RP1_Map : call_RMPObject_Validate_Type.sql                                       ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2023 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE call_RMPObject_Validate_Type
(
   IN    ObjectHead_Parent_wClass      SMALLINT,
   IN    ObjectHead_Parent_twObjectIx  BIGINT,
   IN    twRMPObjectIx                 BIGINT,
   IN    Type_bType                    TINYINT UNSIGNED,
   IN    Type_bSubtype                 TINYINT UNSIGNED,
   IN    Type_bFiction                 TINYINT UNSIGNED,
   IN    Type_bMovable                 TINYINT UNSIGNED,
   INOUT nError                        INT
)
BEGIN
       DECLARE SBO_CLASS_RMTOBJECT                        INT DEFAULT 72;
       DECLARE SBO_CLASS_RMPOBJECT                        INT DEFAULT 73;
       DECLARE MVO_RMTOBJECT_TYPE_PARCEL                  INT DEFAULT 11;

       DECLARE Parent_bType    TINYINT UNSIGNED;
       DECLARE Parent_bSubtype TINYINT UNSIGNED;
       DECLARE Self_bType      TINYINT UNSIGNED;
       DECLARE Self_bSubtype   TINYINT UNSIGNED;

            IF ObjectHead_Parent_wClass = SBO_CLASS_RMPOBJECT
          THEN
                 SELECT o.Type_bType, o.Type_bSubtype
                   INTO Parent_bType, Parent_bSubtype
                   FROM RMPObject AS o
                  WHERE o.ObjectHead_Self_twObjectIx = ObjectHead_Parent_twObjectIx;
        END IF ;

            IF twRMPObjectIx > 0
          THEN
                 SELECT o.Type_bType, o.Type_bSubtype
                   INTO   Self_bType,   Self_bSubtype
                   FROM RMPObject AS o
                  WHERE o.ObjectHead_Self_twObjectIx = twRMPObjectIx;
-- get max children's type and subtype

        END IF ;

-- attachment points can't have cildren

            IF Type_bType IS NULL
          THEN
                   CALL call_Error (21, 'Type_bType is NULL',       nError);
        END IF ;

            IF Type_bSubtype IS NULL
          THEN
                   CALL call_Error (21, 'Type_bSubtype is NULL',    nError);
        END IF ;

            IF Type_bFiction IS NULL
          THEN
                   CALL call_Error (21, 'Type_bFiction is NULL',    nError);
        ELSEIF Type_bFiction NOT BETWEEN 0 AND 1
          THEN
                   CALL call_Error (21, 'Type_bFiction is invalid', nError);
        END IF ;

            IF Type_bMovable IS NULL
          THEN
                   CALL call_Error (21, 'Type_bMovable is NULL',    nError);
        ELSEIF Type_bMovable NOT BETWEEN 0 AND 1
          THEN
                   CALL call_Error (21, 'Type_bMovable is invalid', nError);
        END IF ;

            IF ObjectHead_Parent_wClass = SBO_CLASS_RMTOBJECT  AND  Parent_bType <> MVO_RMTOBJECT_TYPE_PARCEL
          THEN
                   CALL call_Error (21, 'Parent\'s Type_bType must be equal to PARCEL when its parent\'s class is RMTOBJECT', nError);
/*
        ELSEIF ObjectHead_Parent_wClass = SBO_CLASS_RMPOBJECT  AND  Type_bType < Parent_bType
          THEN
                   CALL call_Error (21, 'Type_bType must be greater than or equal to its parent\'s Type_bType', nError);
        ELSEIF ObjectHead_Parent_wClass = SBO_CLASS_RMPOBJECT  AND  Type_bType = Parent_bType  AND  Type_bSubtype <= Parent_bSubtype
          THEN
                   CALL call_Error (21, 'Type_bSubtype must be greater than its parent\'s Type_bType', nError);
*/
        END IF ;
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                           MVD_RP1_Map : get_RMPObject_Update.sql                                           ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2025 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

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

            -- Create the temp Error table
        CREATE TEMPORARY TABLE Error
               (
                  nOrder                        INT             NOT NULL AUTO_INCREMENT PRIMARY KEY,
                  dwError                       INT             NOT NULL,
                  sError                        VARCHAR (255)   NOT NULL
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

                     IF ROW_COUNT () = 1
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

          DROP TEMPORARY TABLE Error;
          DROP TEMPORARY TABLE Results;

           SET nResult = bCommit - 1 - nError;

END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                            MVD_RP1_Map : set_RMPObject_Bound.sql                                           ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                              Copyright 2023-2025 Metaversal Corporation. All rights reserved.                              ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE set_RMPObject_Bound
(
   IN    sIPAddress                    VARCHAR (16),
   IN    twRPersonaIx                  BIGINT,
   IN    twRMPObjectIx                 BIGINT,
   IN    Bound_dX                      DOUBLE,
   IN    Bound_dY                      DOUBLE,
   IN    Bound_dZ                      DOUBLE,
   OUT   nResult                       INT
)
BEGIN
       DECLARE RMPOBJECT_OP_BOUND                         INT DEFAULT 8;

       DECLARE nError  INT DEFAULT 0;
       DECLARE bCommit INT DEFAULT 0;
       DECLARE bError  INT;

       DECLARE ObjectHead_Parent_wClass     SMALLINT;
       DECLARE ObjectHead_Parent_twObjectIx BIGINT;

            -- Create the temp Error table
        CREATE TEMPORARY TABLE Error
               (
                  nOrder                        INT             NOT NULL AUTO_INCREMENT PRIMARY KEY,
                  dwError                       INT             NOT NULL,
                  sError                        VARCHAR (255)   NOT NULL
               );

            -- Create the temp Event table
        CREATE TEMPORARY TABLE Event
               (
                  nOrder                        INT             NOT NULL AUTO_INCREMENT PRIMARY KEY,
                  sType                         VARCHAR (50)    NOT NULL,
                  Self_wClass                   SMALLINT        NOT NULL,
                  Self_twObjectIx               BIGINT          NOT NULL,
                  Child_wClass                  SMALLINT        NOT NULL,
                  Child_twObjectIx              BIGINT          NOT NULL,
                  wFlags                        SMALLINT        NOT NULL,
                  twEventIz                     BIGINT          NOT NULL,
                  sJSON_Object                  TEXT            NOT NULL,
                  sJSON_Child                   TEXT            NOT NULL,
                  sJSON_Change                  TEXT            NOT NULL
               );

           SET twRPersonaIx  = IFNULL (twRPersonaIx,  0);
           SET twRMPObjectIx = IFNULL (twRMPObjectIx, 0);

         START TRANSACTION;

          CALL call_RMPObject_Validate (twRPersonaIx, twRMPObjectIx, ObjectHead_Parent_wClass, ObjectHead_Parent_twObjectIx, nError);
            IF nError = 0
          THEN
                   CALL call_RMPObject_Validate_Bound (ObjectHead_Parent_wClass, ObjectHead_Parent_twObjectIx, twRMPObjectIx, Bound_dX, Bound_dY, Bound_dZ, nError);
        END IF ;

            IF nError = 0
          THEN
                   CALL call_RMPObject_Event_Bound (twRMPObjectIx, Bound_dX, Bound_dY, Bound_dZ, bError);
                     IF bError = 0
                   THEN
                             SET bCommit = 1;
                   ELSE
                            CALL call_Error (-1, 'Failed to update RMPObject', nError);
                 END IF ;
        END IF ;
       
            IF bCommit = 1
          THEN
                    SET bCommit = 0;
                 
                   CALL call_RMPObject_Log (RMPOBJECT_OP_BOUND, sIPAddress, twRPersonaIx, twRMPObjectIx, bError);
                     IF bError = 0
                   THEN
                            CALL call_Event_Push (bError);
                              IF bError = 0
                            THEN
                                      SET bCommit = 1;
                            ELSE
                                     CALL call_Error (-9, 'Failed to push events', nError);
                          END IF ;
                   ELSE
                            CALL call_Error (-8, 'Failed to log action', nError);
                 END IF ;
        END IF ;

            IF bCommit = 0
          THEN
                 SELECT dwError, sError FROM Error;

               ROLLBACK ;
          ELSE
                 COMMIT ;
        END IF ;

          DROP TEMPORARY TABLE Error;
          DROP TEMPORARY TABLE Event;

           SET nResult = bCommit - 1 - nError;
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                            MVD_RP1_Map : set_RMPObject_Name.sql                                            ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                              Copyright 2023-2025 Metaversal Corporation. All rights reserved.                              ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE set_RMPObject_Name
(
   IN    sIPAddress                    VARCHAR (16),
   IN    twRPersonaIx                  BIGINT,
   IN    twRMPObjectIx                 BIGINT,
   IN    Name_wsRMPObjectId            VARCHAR (48),
   OUT   nResult                       INT
)
BEGIN
       DECLARE RMPOBJECT_OP_NAME                          INT DEFAULT 1;

       DECLARE nError  INT DEFAULT 0;
       DECLARE bCommit INT DEFAULT 0;
       DECLARE bError  INT;

       DECLARE ObjectHead_Parent_wClass     SMALLINT;
       DECLARE ObjectHead_Parent_twObjectIx BIGINT;

            -- Create the temp Error table
        CREATE TEMPORARY TABLE Error
               (
                  nOrder                        INT             NOT NULL AUTO_INCREMENT PRIMARY KEY,
                  dwError                       INT             NOT NULL,
                  sError                        VARCHAR (255)   NOT NULL
               );

            -- Create the temp Event table
        CREATE TEMPORARY TABLE Event
               (
                  nOrder                        INT             NOT NULL AUTO_INCREMENT PRIMARY KEY,
                  sType                         VARCHAR (50)    NOT NULL,
                  Self_wClass                   SMALLINT        NOT NULL,
                  Self_twObjectIx               BIGINT          NOT NULL,
                  Child_wClass                  SMALLINT        NOT NULL,
                  Child_twObjectIx              BIGINT          NOT NULL,
                  wFlags                        SMALLINT        NOT NULL,
                  twEventIz                     BIGINT          NOT NULL,
                  sJSON_Object                  TEXT            NOT NULL,
                  sJSON_Child                   TEXT            NOT NULL,
                  sJSON_Change                  TEXT            NOT NULL
               );

           SET twRPersonaIx  = IFNULL (twRPersonaIx,  0);
           SET twRMPObjectIx = IFNULL (twRMPObjectIx, 0);

         START TRANSACTION;

          CALL call_RMPObject_Validate (twRPersonaIx, twRMPObjectIx, ObjectHead_Parent_wClass, ObjectHead_Parent_twObjectIx, nError);
            IF nError = 0
          THEN
                   CALL call_RMPObject_Validate_Name (ObjectHead_Parent_wClass, ObjectHead_Parent_twObjectIx, twRMPObjectIx, Name_wsRMPObjectId, nError);
        END IF ;

            IF nError = 0
          THEN
                   CALL call_RMPObject_Event_Name (twRMPObjectIx, Name_wsRMPObjectId, bError);
                     IF bError = 0
                   THEN
                             SET bCommit = 1;
                   ELSE 
                            CALL call_Error (-1, 'Failed to update RMPObject', nError);
                 END IF ;
        END IF ;
       
            IF bCommit = 1
          THEN
                    SET bCommit = 0;
                 
                   CALL call_RMPObject_Log (RMPOBJECT_OP_NAME, sIPAddress, twRPersonaIx, twRMPObjectIx, bError);
                     IF bError = 0
                   THEN
                            CALL call_Event_Push (bError);
                              IF bError = 0
                            THEN
                                      SET bCommit = 1;
                            ELSE
                                     CALL call_Error (-9, 'Failed to push events', nError);
                          END IF ;
                   ELSE
                            CALL call_Error (-8, 'Failed to log action', nError);
                 END IF ;
        END IF ;

            IF bCommit = 0
          THEN
                 SELECT dwError, sError FROM Error;

               ROLLBACK ;
          ELSE
                 COMMIT ;
        END IF ;

          DROP TEMPORARY TABLE Error;
          DROP TEMPORARY TABLE Event;

           SET nResult = bCommit - 1 - nError;
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                            MVD_RP1_Map : set_RMPObject_Owner.sql                                           ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                              Copyright 2023-2025 Metaversal Corporation. All rights reserved.                              ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE set_RMPObject_Owner
(
   IN    sIPAddress                    VARCHAR (16),
   IN    twRPersonaIx                  BIGINT,
   IN    twRMPObjectIx                 BIGINT,
   IN    Owner_twRPersonaIx            BIGINT,
   OUT   nResult                       INT
)
BEGIN
       DECLARE RMPOBJECT_OP_OWNER                         INT DEFAULT 3;

       DECLARE nError  INT DEFAULT 0;
       DECLARE bCommit INT DEFAULT 0;
       DECLARE bError  INT;

       DECLARE ObjectHead_Parent_wClass     SMALLINT;
       DECLARE ObjectHead_Parent_twObjectIx BIGINT;

            -- Create the temp Error table
        CREATE TEMPORARY TABLE Error
               (
                  nOrder                        INT             NOT NULL AUTO_INCREMENT PRIMARY KEY,
                  dwError                       INT             NOT NULL,
                  sError                        VARCHAR (255)   NOT NULL
               );

            -- Create the temp Event table
        CREATE TEMPORARY TABLE Event
               (
                  nOrder                        INT             NOT NULL AUTO_INCREMENT PRIMARY KEY,
                  sType                         VARCHAR (50)    NOT NULL,
                  Self_wClass                   SMALLINT        NOT NULL,
                  Self_twObjectIx               BIGINT          NOT NULL,
                  Child_wClass                  SMALLINT        NOT NULL,
                  Child_twObjectIx              BIGINT          NOT NULL,
                  wFlags                        SMALLINT        NOT NULL,
                  twEventIz                     BIGINT          NOT NULL,
                  sJSON_Object                  TEXT            NOT NULL,
                  sJSON_Child                   TEXT            NOT NULL,
                  sJSON_Change                  TEXT            NOT NULL
               );

           SET twRPersonaIx  = IFNULL (twRPersonaIx,  0);
           SET twRMPObjectIx = IFNULL (twRMPObjectIx, 0);

         START TRANSACTION;

          CALL call_RMPObject_Validate (twRPersonaIx, twRMPObjectIx, ObjectHead_Parent_wClass, ObjectHead_Parent_twObjectIx, nError);
            IF nError = 0
          THEN
                   CALL call_RMPObject_Validate_Owner (ObjectHead_Parent_wClass, ObjectHead_Parent_twObjectIx, twRMPObjectIx, Owner_twRPersonaIx, nError);
        END IF ;

            IF nError = 0
          THEN
                   CALL call_RMPObject_Event_Owner (twRMPObjectIx, Owner_twRPersonaIx, bError);
                     IF bError = 0
                   THEN
                             SET bCommit = 1;
                   ELSE
                            CALL call_Error (-1, 'Failed to update RMPObject', nError);
                 END IF ;
        END IF ;
       
            IF bCommit = 1
          THEN
                    SET bCommit = 0;
                 
                   CALL call_RMPObject_Log (RMPOBJECT_OP_OWNER, sIPAddress, twRPersonaIx, twRMPObjectIx, bError);
                     IF bError = 0
                   THEN
                            CALL call_Event_Push (bError);
                              IF bError = 0
                            THEN
                                      SET bCommit = 1;
                            ELSE
                                     CALL call_Error (-9, 'Failed to push events', nError);
                          END IF ;
                   ELSE
                            CALL call_Error (-8, 'Failed to log action', nError);
                 END IF ;
        END IF ;

            IF bCommit = 0
          THEN
                 SELECT dwError, sError FROM Error;

               ROLLBACK ;
          ELSE
                 COMMIT ;
        END IF ;

          DROP TEMPORARY TABLE Error;
          DROP TEMPORARY TABLE Event;

           SET nResult = bCommit - 1 - nError;
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                           MVD_RP1_Map : set_RMPObject_Parent.sql                                           ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                              Copyright 2023-2025 Metaversal Corporation. All rights reserved.                              ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

-- Note that this is not a function of the RMPObject itself, but rather a function of the two parents involved.

DELIMITER $$

CREATE PROCEDURE set_RMPObject_Parent
(
   IN    sIPAddress                    VARCHAR (16),
   IN    twRPersonaIx                  BIGINT,
   IN    twRMPObjectIx                 BIGINT,
   IN    wClass                        SMALLINT,
   IN    twObjectIx                    BIGINT,
   OUT   nResult                       INT
)
BEGIN
       DECLARE SBO_CLASS_RMROOT                           INT DEFAULT 70;
       DECLARE SBO_CLASS_RMCOBJECT                        INT DEFAULT 71;
       DECLARE SBO_CLASS_RMTOBJECT                        INT DEFAULT 72;
       DECLARE SBO_CLASS_RMPOBJECT                        INT DEFAULT 73;
       DECLARE RMPOBJECT_OP_PARENT                        INT DEFAULT 18;

       DECLARE nError  INT DEFAULT 0;
       DECLARE bCommit INT DEFAULT 0;
       DECLARE bError  INT;

       DECLARE ObjectHead_Parent_wClass     SMALLINT;
       DECLARE ObjectHead_Parent_twObjectIx BIGINT;

       DECLARE Name_wsRMPObjectId            VARCHAR (48);
       DECLARE Type_bType                    TINYINT UNSIGNED;
       DECLARE Type_bSubtype                 TINYINT UNSIGNED;
       DECLARE Type_bFiction                 TINYINT UNSIGNED;
       DECLARE Type_bMovable                 TINYINT UNSIGNED;
       DECLARE Owner_twRPersonaIx            BIGINT;
       DECLARE Resource_qwResource           BIGINT;
       DECLARE Resource_sName                VARCHAR (48);
       DECLARE Resource_sReference           VARCHAR (128);
       DECLARE Transform_Position_dX         DOUBLE;
       DECLARE Transform_Position_dY         DOUBLE;
       DECLARE Transform_Position_dZ         DOUBLE;
       DECLARE Transform_Rotation_dX         DOUBLE;
       DECLARE Transform_Rotation_dY         DOUBLE;
       DECLARE Transform_Rotation_dZ         DOUBLE;
       DECLARE Transform_Rotation_dW         DOUBLE;
       DECLARE Transform_Scale_dX            DOUBLE;
       DECLARE Transform_Scale_dY            DOUBLE;
       DECLARE Transform_Scale_dZ            DOUBLE;
       DECLARE Bound_dX                      DOUBLE;
       DECLARE Bound_dY                      DOUBLE;
       DECLARE Bound_dZ                      DOUBLE;

            -- Create the temp Error table
        CREATE TEMPORARY TABLE Error
               (
                  nOrder                        INT             NOT NULL AUTO_INCREMENT PRIMARY KEY,
                  dwError                       INT             NOT NULL,
                  sError                        VARCHAR (255)   NOT NULL
               );

            -- Create the temp Event table
        CREATE TEMPORARY TABLE Event
               (
                  nOrder                        INT             NOT NULL AUTO_INCREMENT PRIMARY KEY,
                  sType                         VARCHAR (50)    NOT NULL,
                  Self_wClass                   SMALLINT        NOT NULL,
                  Self_twObjectIx               BIGINT          NOT NULL,
                  Child_wClass                  SMALLINT        NOT NULL,
                  Child_twObjectIx              BIGINT          NOT NULL,
                  wFlags                        SMALLINT        NOT NULL,
                  twEventIz                     BIGINT          NOT NULL,
                  sJSON_Object                  TEXT            NOT NULL,
                  sJSON_Child                   TEXT            NOT NULL,
                  sJSON_Change                  TEXT            NOT NULL
               );

           SET twRPersonaIx  = IFNULL (twRPersonaIx,  0);
           SET twRMPObjectIx = IFNULL (twRMPObjectIx, 0);

         START TRANSACTION;

          CALL call_RMPObject_Validate (twRPersonaIx, twRMPObjectIx, ObjectHead_Parent_wClass, ObjectHead_Parent_twObjectIx, nError);

            IF nError = 0
          THEN
                     IF ObjectHead_Parent_wClass = wClass  AND  ObjectHead_Parent_twObjectIx = twObjectIx
                   THEN
                            CALL call_Error (99, 'The new parent is the same as the current parent', nError);
                 END IF ;
        END IF ;

            IF nError = 0
          THEN
                 SELECT o.Name_wsRMPObjectId,
                        o.Type_bType,
                        o.Type_bSubtype,
                        o.Type_bFiction,
                        o.Type_bMovable,
                        o.Owner_twRPersonaIx,
                        o.Resource_qwResource,
                        o.Resource_sName,
                        o.Resource_sReference,
                        o.Transform_Position_dX,
                        o.Transform_Position_dY,
                        o.Transform_Position_dZ,
                        o.Transform_Rotation_dX,
                        o.Transform_Rotation_dY,
                        o.Transform_Rotation_dZ,
                        o.Transform_Rotation_dW,
                        o.Transform_Scale_dX,
                        o.Transform_Scale_dY,
                        o.Transform_Scale_dZ,
                        o.Bound_dX,
                        o.Bound_dY,
                        o.Bound_dZ
                   INTO Name_wsRMPObjectId,
                        Type_bType,
                        Type_bSubtype,
                        Type_bFiction,
                        Type_bMovable,
                        Owner_twRPersonaIx,
                        Resource_qwResource,
                        Resource_sName,
                        Resource_sReference,
                        Transform_Position_dX,
                        Transform_Position_dY,
                        Transform_Position_dZ,
                        Transform_Rotation_dX,
                        Transform_Rotation_dY,
                        Transform_Rotation_dZ,
                        Transform_Rotation_dW,
                        Transform_Scale_dX,
                        Transform_Scale_dY,
                        Transform_Scale_dZ,
                        Bound_dX,
                        Bound_dY,
                        Bound_dZ
                   FROM RMPObject AS o
                  WHERE o.ObjectHead_Self_twObjectIx = twRMPObjectIx;

                     IF wClass = SBO_CLASS_RMROOT
                     OR wClass = SBO_CLASS_RMTOBJECT
                     OR wClass = SBO_CLASS_RMPOBJECT
                   THEN
                            CALL call_RMPObject_Validate_Type (wClass, twObjectIx, twRMPObjectIx, Type_bType, Type_bSubtype, Type_bFiction, Type_bMovable, nError);
                   ELSE
                            CALL call_Error (99, 'wClass is invalid', nError);
                 END IF ;
        END IF ;

            IF nError = 0
          THEN
                     IF ObjectHead_Parent_wClass = SBO_CLASS_RMROOT
                   THEN
                            CALL call_RMRoot_Event_RMPObject_Close    (ObjectHead_Parent_twObjectIx, twRMPObjectIx, bError, 1);
                 ELSEIF ObjectHead_Parent_wClass = SBO_CLASS_RMTOBJECT
                   THEN
                            CALL call_RMTObject_Event_RMPObject_Close (ObjectHead_Parent_twObjectIx, twRMPObjectIx, bError, 1);
                 ELSEIF ObjectHead_Parent_wClass = SBO_CLASS_RMPOBJECT
                   THEN
                            CALL call_RMPObject_Event_RMPObject_Close (ObjectHead_Parent_twObjectIx, twRMPObjectIx, bError, 1);
                   ELSE
                            CALL call_Error (99, 'Internal error', nError);
                 END IF ;

                     IF bError = 0
                   THEN


                          UPDATE RMPObject
                             SET ObjectHead_Parent_wClass     = wClass,
                                 ObjectHead_Parent_twObjectIx = twObjectIx
                           WHERE ObjectHead_Self_twObjectIx = twRMPObjectIx;

                             SET bError = IF (ROW_COUNT () = 1, 0, 1);

                              IF bError = 0
                            THEN
                                       IF wClass = SBO_CLASS_RMROOT
                                     THEN
                                              CALL call_RMRoot_Event_RMPObject_Open    (twObjectIx, Name_wsRMPObjectId, Type_bType, Type_bSubtype, Type_bFiction, Type_bMovable, Owner_twRPersonaIx, Resource_qwResource, Resource_sName, Resource_sReference, Transform_Position_dX, Transform_Position_dY, Transform_Position_dZ, Transform_Rotation_dX, Transform_Rotation_dY, Transform_Rotation_dZ, Transform_Rotation_dW, Transform_Scale_dX, Transform_Scale_dY, Transform_Scale_dZ, Bound_dX, Bound_dY, Bound_dZ, twRMPObjectIx, bError, 1);
                                   ELSEIF wClass = SBO_CLASS_RMTOBJECT
                                     THEN
                                              CALL call_RMTObject_Event_RMPObject_Open (twObjectIx, Name_wsRMPObjectId, Type_bType, Type_bSubtype, Type_bFiction, Type_bMovable, Owner_twRPersonaIx, Resource_qwResource, Resource_sName, Resource_sReference, Transform_Position_dX, Transform_Position_dY, Transform_Position_dZ, Transform_Rotation_dX, Transform_Rotation_dY, Transform_Rotation_dZ, Transform_Rotation_dW, Transform_Scale_dX, Transform_Scale_dY, Transform_Scale_dZ, Bound_dX, Bound_dY, Bound_dZ, twRMPObjectIx, bError, 1);
                                   ELSEIF wClass = SBO_CLASS_RMPOBJECT
                                     THEN
                                              CALL call_RMPObject_Event_RMPObject_Open (twObjectIx, Name_wsRMPObjectId, Type_bType, Type_bSubtype, Type_bFiction, Type_bMovable, Owner_twRPersonaIx, Resource_qwResource, Resource_sName, Resource_sReference, Transform_Position_dX, Transform_Position_dY, Transform_Position_dZ, Transform_Rotation_dX, Transform_Rotation_dY, Transform_Rotation_dZ, Transform_Rotation_dW, Transform_Scale_dX, Transform_Scale_dY, Transform_Scale_dZ, Bound_dX, Bound_dY, Bound_dZ, twRMPObjectIx, bError, 1);
                                     ELSE
                                              CALL call_Error (99, 'Internal error', nError);
                                   END IF ;
                  
                                       IF bError = 0
                                     THEN
                                               SET bCommit = 1;
                                     ELSE
                                              CALL call_Error (-3, 'Failed to update new parent');
                                   END IF ;
                            ELSE
                                     CALL call_Error (-2, 'Failed to update RMPObject');
                          END IF ;
                   ELSE
                            CALL call_Error (-1, 'Failed to update old parent');
                 END IF ;
        END IF ;

            IF bCommit = 1
          THEN
                    SET bCommit = 0;
                 
                   CALL call_RMPObject_Log (RMPOBJECT_OP_PARENT, sIPAddress, twRPersonaIx, twRMPObjectIx, bError);
                     IF bError = 0
                   THEN
                            CALL call_Event_Push (bError);
                              IF bError = 0
                            THEN
                                      SET bCommit = 1;
                            ELSE
                                     CALL call_Error (-9, 'Failed to push events', nError);
                          END IF ;
                   ELSE
                            CALL call_Error (-8, 'Failed to log action', nError);
                 END IF ;
        END IF ;

            IF bCommit = 0
          THEN
                 SELECT dwError, sError FROM Error;

               ROLLBACK ;
          ELSE
                 COMMIT ;
        END IF ;

          DROP TEMPORARY TABLE Error;
          DROP TEMPORARY TABLE Event;

           SET nResult = bCommit - 1 - nError;
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                          MVD_RP1_Map : set_RMPObject_Resource.sql                                          ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                              Copyright 2023-2025 Metaversal Corporation. All rights reserved.                              ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE set_RMPObject_Resource
(
   IN    sIPAddress                    VARCHAR (16),
   IN    twRPersonaIx                  BIGINT,
   IN    twRMPObjectIx                 BIGINT,
   IN    Resource_qwResource           BIGINT,
   IN    Resource_sName                VARCHAR (48),
   IN    Resource_sReference           VARCHAR (128),
   OUT   nResult                       INT
)
BEGIN
       DECLARE RMPOBJECT_OP_RESOURCE                      INT DEFAULT 4;

       DECLARE nError  INT DEFAULT 0;
       DECLARE bCommit INT DEFAULT 0;
       DECLARE bError  INT;

       DECLARE ObjectHead_Parent_wClass     SMALLINT;
       DECLARE ObjectHead_Parent_twObjectIx BIGINT;

            -- Create the temp Error table
        CREATE TEMPORARY TABLE Error
               (
                  nOrder                        INT             NOT NULL AUTO_INCREMENT PRIMARY KEY,
                  dwError                       INT             NOT NULL,
                  sError                        VARCHAR (255)   NOT NULL
               );

            -- Create the temp Event table
        CREATE TEMPORARY TABLE Event
               (
                  nOrder                        INT             NOT NULL AUTO_INCREMENT PRIMARY KEY,
                  sType                         VARCHAR (50)    NOT NULL,
                  Self_wClass                   SMALLINT        NOT NULL,
                  Self_twObjectIx               BIGINT          NOT NULL,
                  Child_wClass                  SMALLINT        NOT NULL,
                  Child_twObjectIx              BIGINT          NOT NULL,
                  wFlags                        SMALLINT        NOT NULL,
                  twEventIz                     BIGINT          NOT NULL,
                  sJSON_Object                  TEXT            NOT NULL,
                  sJSON_Child                   TEXT            NOT NULL,
                  sJSON_Change                  TEXT            NOT NULL
               );

           SET twRPersonaIx  = IFNULL (twRPersonaIx,  0);
           SET twRMPObjectIx = IFNULL (twRMPObjectIx, 0);

         START TRANSACTION;

          CALL call_RMPObject_Validate (twRPersonaIx, twRMPObjectIx, ObjectHead_Parent_wClass, ObjectHead_Parent_twObjectIx, nError);
            IF nError = 0
          THEN
                   CALL call_RMPObject_Validate_Resource (ObjectHead_Parent_wClass, ObjectHead_Parent_twObjectIx, twRMPObjectIx, Resource_qwResource, Resource_sName, Resource_sReference, nError);
        END IF ;

            IF nError = 0
          THEN
                   CALL call_RMPObject_Event_Resource (twRMPObjectIx, Resource_qwResource, Resource_sName, Resource_sReference, bError);
                     IF bError = 0
                   THEN
                             SET bCommit = 1;
                   ELSE
                            CALL call_Error (-1, 'Failed to update RMPObject', nError);
                 END IF ;
        END IF ;
       
            IF bCommit = 1
          THEN
                    SET bCommit = 0;
                 
                   CALL call_RMPObject_Log (RMPOBJECT_OP_RESOURCE, sIPAddress, twRPersonaIx, twRMPObjectIx, bError);
                     IF bError = 0
                   THEN
                            CALL call_Event_Push (bError);
                              IF bError = 0
                            THEN
                                      SET bCommit = 1;
                            ELSE
                                     CALL call_Error (-9, 'Failed to push events', nError);
                          END IF ;
                   ELSE
                            CALL call_Error (-8, 'Failed to log action', nError);
                 END IF ;
        END IF ;

            IF bCommit = 0
          THEN
                 SELECT dwError, sError FROM Error;

               ROLLBACK ;
          ELSE
                 COMMIT ;
        END IF ;

          DROP TEMPORARY TABLE Error;
          DROP TEMPORARY TABLE Event;

           SET nResult = bCommit - 1 - nError;
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                       MVD_RP1_Map : set_RMPObject_RMPObject_Close.sql                                      ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                              Copyright 2023-2025 Metaversal Corporation. All rights reserved.                              ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE set_RMPObject_RMPObject_Close
(
   IN    sIPAddress                    VARCHAR (16),
   IN    twRPersonaIx                  BIGINT,
   IN    twRMPObjectIx                 BIGINT,
   IN    twRMPObjectIx_Close           BIGINT,
   IN    bDeleteAll                    TINYINT UNSIGNED,
   OUT   nResult                       INT
)
BEGIN
       DECLARE SBO_CLASS_RMPOBJECT                        INT DEFAULT 73;
       DECLARE RMPOBJECT_OP_RMPOBJECT_CLOSE               INT DEFAULT 17;

       DECLARE nError  INT DEFAULT 0;
       DECLARE bCommit INT DEFAULT 0;
       DECLARE bError  INT;

       DECLARE ObjectHead_Parent_wClass     SMALLINT;
       DECLARE ObjectHead_Parent_twObjectIx BIGINT;

       DECLARE nCount INT;

            -- Create the temp Error table
        CREATE TEMPORARY TABLE Error
               (
                  nOrder                        INT             NOT NULL AUTO_INCREMENT PRIMARY KEY,
                  dwError                       INT             NOT NULL,
                  sError                        VARCHAR (255)   NOT NULL
               );

            -- Create the temp Event table
        CREATE TEMPORARY TABLE Event
               (
                  nOrder                        INT             NOT NULL AUTO_INCREMENT PRIMARY KEY,
                  sType                         VARCHAR (50)    NOT NULL,
                  Self_wClass                   SMALLINT        NOT NULL,
                  Self_twObjectIx               BIGINT          NOT NULL,
                  Child_wClass                  SMALLINT        NOT NULL,
                  Child_twObjectIx              BIGINT          NOT NULL,
                  wFlags                        SMALLINT        NOT NULL,
                  twEventIz                     BIGINT          NOT NULL,
                  sJSON_Object                  TEXT            NOT NULL,
                  sJSON_Child                   TEXT            NOT NULL,
                  sJSON_Change                  TEXT            NOT NULL
               );

           SET twRPersonaIx        = IFNULL (twRPersonaIx,        0);
           SET twRMPObjectIx       = IFNULL (twRMPObjectIx,       0);
           SET twRMPObjectIx_Close = IFNULL (twRMPObjectIx_Close, 0);
           SET bDeleteAll          = IFNULL (bDeleteAll,          0);

         START TRANSACTION;

          CALL call_RMPObject_Validate (twRPersonaIx, twRMPObjectIx, ObjectHead_Parent_wClass, ObjectHead_Parent_twObjectIx, nError);
            IF nError = 0
          THEN
                 SELECT COUNT(*) INTO nCount
                   FROM RMPObject
                  WHERE ObjectHead_Parent_wClass     = SBO_CLASS_RMPOBJECT
                    AND ObjectHead_Parent_twObjectIx = twRMPObjectIx_Close;

                     IF twRMPObjectIx_Close <= 0
                   THEN
                            CALL call_Error (5, 'twRMPObjectIx_Close is invalid',   nError);
                 ELSEIF bDeleteAll = 0 AND nCount > 0
                   THEN
                            CALL call_Error (6, 'twRMPObjectIx_Close is not empty', nError);
                 END IF ;
        END IF ;

            IF nError = 0
          THEN
                   CALL call_RMPObject_Event_RMPObject_Close (twRMPObjectIx, twRMPObjectIx_Close, bError, 0);
                     IF bError = 0
                   THEN
                             SET bCommit = 1;
                   ELSE
                            CALL call_Error (-1, 'Failed to delete RMPObject', nError);
                 END IF ;
        END IF ;
       
            IF bCommit = 1
          THEN
                    SET bCommit = 0;
                 
                   CALL call_RMPObject_Log (RMPOBJECT_OP_RMPOBJECT_CLOSE, sIPAddress, twRPersonaIx, twRMPObjectIx, bError);
                     IF bError = 0
                   THEN
                            CALL call_Event_Push (bError);
                              IF bError = 0
                            THEN
                                      SET bCommit = 1;
                            ELSE
                                     CALL call_Error (-9, 'Failed to push events', nError);
                          END IF ;
                   ELSE
                            CALL call_Error (-8, 'Failed to log action', nError);
                 END IF ;
        END IF ;

            IF bCommit = 0
          THEN
                 SELECT dwError, sError FROM Error;

               ROLLBACK ;
          ELSE
                 COMMIT ;
        END IF ;

          DROP TEMPORARY TABLE Error;
          DROP TEMPORARY TABLE Event;

           SET nResult = bCommit - 1 - nError;
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                       MVD_RP1_Map : set_RMPObject_RMPObject_Open.sql                                       ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                              Copyright 2023-2025 Metaversal Corporation. All rights reserved.                              ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE set_RMPObject_RMPObject_Open
(
   IN    sIPAddress                    VARCHAR (16),
   IN    twRPersonaIx                  BIGINT,
   IN    twRMPObjectIx                 BIGINT,
   IN    Name_wsRMPObjectId            VARCHAR (48),
   IN    Type_bType                    TINYINT UNSIGNED,
   IN    Type_bSubtype                 TINYINT UNSIGNED,
   IN    Type_bFiction                 TINYINT UNSIGNED,
   IN    Type_bMovable                 TINYINT UNSIGNED,
   IN    Owner_twRPersonaIx            BIGINT,
   IN    Resource_qwResource           BIGINT,
   IN    Resource_sName                VARCHAR (48),
   IN    Resource_sReference           VARCHAR (128),
   IN    Transform_Position_dX         DOUBLE,
   IN    Transform_Position_dY         DOUBLE,
   IN    Transform_Position_dZ         DOUBLE,
   IN    Transform_Rotation_dX         DOUBLE,
   IN    Transform_Rotation_dY         DOUBLE,
   IN    Transform_Rotation_dZ         DOUBLE,
   IN    Transform_Rotation_dW         DOUBLE,
   IN    Transform_Scale_dX            DOUBLE,
   IN    Transform_Scale_dY            DOUBLE,
   IN    Transform_Scale_dZ            DOUBLE,
   IN    Bound_dX                      DOUBLE,
   IN    Bound_dY                      DOUBLE,
   IN    Bound_dZ                      DOUBLE,
   OUT   nResult                       INT
)
BEGIN
       DECLARE SBO_CLASS_RMPOBJECT                        INT DEFAULT 73;
       DECLARE RMPOBJECT_OP_RMPOBJECT_OPEN                INT DEFAULT 16;

       DECLARE nError  INT DEFAULT 0;
       DECLARE bCommit INT DEFAULT 0;
       DECLARE bError  INT;

       DECLARE ObjectHead_Parent_wClass     SMALLINT;
       DECLARE ObjectHead_Parent_twObjectIx BIGINT;

       DECLARE twRMPObjectIx_Open           BIGINT;

            -- Create the temp Error table
        CREATE TEMPORARY TABLE Error
               (
                  nOrder                        INT             NOT NULL AUTO_INCREMENT PRIMARY KEY,
                  dwError                       INT             NOT NULL,
                  sError                        VARCHAR (255)   NOT NULL
               );

            -- Create the temp Event table
        CREATE TEMPORARY TABLE Event
               (
                  nOrder                        INT             NOT NULL AUTO_INCREMENT PRIMARY KEY,
                  sType                         VARCHAR (50)    NOT NULL,
                  Self_wClass                   SMALLINT        NOT NULL,
                  Self_twObjectIx               BIGINT          NOT NULL,
                  Child_wClass                  SMALLINT        NOT NULL,
                  Child_twObjectIx              BIGINT          NOT NULL,
                  wFlags                        SMALLINT        NOT NULL,
                  twEventIz                     BIGINT          NOT NULL,
                  sJSON_Object                  TEXT            NOT NULL,
                  sJSON_Child                   TEXT            NOT NULL,
                  sJSON_Change                  TEXT            NOT NULL
               );

           SET twRPersonaIx  = IFNULL (twRPersonaIx,  0);
           SET twRMPObjectIx = IFNULL (twRMPObjectIx, 0);

         START TRANSACTION;

          CALL call_RMPObject_Validate (twRPersonaIx, twRMPObjectIx, ObjectHead_Parent_wClass, ObjectHead_Parent_twObjectIx, nError);
            IF nError = 0
          THEN
                   CALL call_RMPObject_Validate_Name      (SBO_CLASS_RMPOBJECT, twRMPObjectIx, 0, Name_wsRMPObjectId, nError);
                   CALL call_RMPObject_Validate_Type      (SBO_CLASS_RMPOBJECT, twRMPObjectIx, 0, Type_bType, Type_bSubtype, Type_bFiction, Type_bMovable, nError);
                   CALL call_RMPObject_Validate_Owner     (SBO_CLASS_RMPOBJECT, twRMPObjectIx, 0, Owner_twRPersonaIx, nError);
                   CALL call_RMPObject_Validate_Resource  (SBO_CLASS_RMPOBJECT, twRMPObjectIx, 0, Resource_qwResource, Resource_sName, Resource_sReference, nError);
                   CALL call_RMPObject_Validate_Transform (SBO_CLASS_RMPOBJECT, twRMPObjectIx, 0, Transform_Position_dX, Transform_Position_dY, Transform_Position_dZ, Transform_Rotation_dX, Transform_Rotation_dY, Transform_Rotation_dZ, Transform_Rotation_dW, Transform_Scale_dX, Transform_Scale_dY, Transform_Scale_dZ, nError);
                   CALL call_RMPObject_Validate_Bound     (SBO_CLASS_RMPOBJECT, twRMPObjectIx, 0, Bound_dX, Bound_dY, Bound_dZ, nError);
        END IF ;

            IF nError = 0
          THEN
                   CALL call_RMPObject_Event_RMPObject_Open (twRMPObjectIx, Name_wsRMPObjectId, Type_bType, Type_bSubtype, Type_bFiction, Type_bMovable, Owner_twRPersonaIx, Resource_qwResource, Resource_sName, Resource_sReference, Transform_Position_dX, Transform_Position_dY, Transform_Position_dZ, Transform_Rotation_dX, Transform_Rotation_dY, Transform_Rotation_dZ, Transform_Rotation_dW, Transform_Scale_dX, Transform_Scale_dY, Transform_Scale_dZ, Bound_dX, Bound_dY, Bound_dZ, twRMPObjectIx_Open, bError, 0);
                     IF bError = 0
                   THEN
                          SELECT twRMPObjectIx_Open AS twRMPObject;
   
                             SET bCommit = 1;
                   ELSE
                            CALL call_Error (-1, 'Failed to insert RMPObject', nError);
                 END IF ;
        END IF ;
       
            IF bCommit = 1
          THEN
                    SET bCommit = 0;
                 
                   CALL call_RMPObject_Log (RMPOBJECT_OP_RMPOBJECT_OPEN, sIPAddress, twRPersonaIx, twRMPObjectIx, bError);
                     IF bError = 0
                   THEN
                            CALL call_Event_Push (bError);
                              IF bError = 0
                            THEN
                                      SET bCommit = 1;
                            ELSE
                                     CALL call_Error (-9, 'Failed to push events', nError);
                          END IF ;
                   ELSE
                            CALL call_Error (-8, 'Failed to log action', nError);
                 END IF ;
        END IF ;

            IF bCommit = 0
          THEN
                 SELECT dwError, sError FROM Error;

               ROLLBACK ;
          ELSE
                 COMMIT ;
        END IF ;

          DROP TEMPORARY TABLE Error;
          DROP TEMPORARY TABLE Event;

           SET nResult = bCommit - 1 - nError;
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                          MVD_RP1_Map : set_RMPObject_Transform.sql                                         ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                              Copyright 2023-2025 Metaversal Corporation. All rights reserved.                              ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE set_RMPObject_Transform
(
   IN    sIPAddress                    VARCHAR (16),
   IN    twRPersonaIx                  BIGINT,
   IN    twRMPObjectIx                 BIGINT,
   IN    Transform_Position_dX         DOUBLE,
   IN    Transform_Position_dY         DOUBLE,
   IN    Transform_Position_dZ         DOUBLE,
   IN    Transform_Rotation_dX         DOUBLE,
   IN    Transform_Rotation_dY         DOUBLE,
   IN    Transform_Rotation_dZ         DOUBLE,
   IN    Transform_Rotation_dW         DOUBLE,
   IN    Transform_Scale_dX            DOUBLE,
   IN    Transform_Scale_dY            DOUBLE,
   IN    Transform_Scale_dZ            DOUBLE,
   OUT   nResult                       INT
)
BEGIN
       DECLARE RMPOBJECT_OP_TRANSFORM                     INT DEFAULT 5;

       DECLARE nError  INT DEFAULT 0;
       DECLARE bCommit INT DEFAULT 0;
       DECLARE bError  INT;

       DECLARE ObjectHead_Parent_wClass     SMALLINT;
       DECLARE ObjectHead_Parent_twObjectIx BIGINT;

            -- Create the temp Error table
        CREATE TEMPORARY TABLE Error
               (
                  nOrder                        INT             NOT NULL AUTO_INCREMENT PRIMARY KEY,
                  dwError                       INT             NOT NULL,
                  sError                        VARCHAR (255)   NOT NULL
               );

            -- Create the temp Event table
        CREATE TEMPORARY TABLE Event
               (
                  nOrder                        INT             NOT NULL AUTO_INCREMENT PRIMARY KEY,
                  sType                         VARCHAR (50)    NOT NULL,
                  Self_wClass                   SMALLINT        NOT NULL,
                  Self_twObjectIx               BIGINT          NOT NULL,
                  Child_wClass                  SMALLINT        NOT NULL,
                  Child_twObjectIx              BIGINT          NOT NULL,
                  wFlags                        SMALLINT        NOT NULL,
                  twEventIz                     BIGINT          NOT NULL,
                  sJSON_Object                  TEXT            NOT NULL,
                  sJSON_Child                   TEXT            NOT NULL,
                  sJSON_Change                  TEXT            NOT NULL
               );

           SET twRPersonaIx  = IFNULL (twRPersonaIx,  0);
           SET twRMPObjectIx = IFNULL (twRMPObjectIx, 0);

         START TRANSACTION;

          CALL call_RMPObject_Validate (twRPersonaIx, twRMPObjectIx, ObjectHead_Parent_wClass, ObjectHead_Parent_twObjectIx, nError);
            IF nError = 0
          THEN
                   CALL call_RMPObject_Validate_Transform (ObjectHead_Parent_wClass, ObjectHead_Parent_twObjectIx, twRMPObjectIx, Transform_Position_dX, Transform_Position_dY, Transform_Position_dZ, Transform_Rotation_dX, Transform_Rotation_dY, Transform_Rotation_dZ, Transform_Rotation_dW, Transform_Scale_dX, Transform_Scale_dY, Transform_Scale_dZ, nError);
        END IF ;

            IF nError = 0
          THEN
                   CALL call_RMPObject_Event_Transform (twRMPObjectIx, Transform_Position_dX, Transform_Position_dY, Transform_Position_dZ, Transform_Rotation_dX, Transform_Rotation_dY, Transform_Rotation_dZ, Transform_Rotation_dW, Transform_Scale_dX, Transform_Scale_dY, Transform_Scale_dZ, bError);
                     IF bError = 0
                   THEN
                             SET bCommit = 1;
                   ELSE
                            CALL call_Error (-1, 'Failed to update RMPObject', nError);
                 END IF ;
        END IF ;
       
            IF bCommit = 1
          THEN
                    SET bCommit = 0;
                 
                   CALL call_RMPObject_Log (RMPOBJECT_OP_TRANSFORM, sIPAddress, twRPersonaIx, twRMPObjectIx, bError);
                     IF bError = 0
                   THEN
                            CALL call_Event_Push (bError);
                              IF bError = 0
                            THEN
                                      SET bCommit = 1;
                            ELSE
                                     CALL call_Error (-9, 'Failed to push events', nError);
                          END IF ;
                   ELSE
                            CALL call_Error (-8, 'Failed to log action', nError);
                 END IF ;
        END IF ;

            IF bCommit = 0
          THEN
                 SELECT dwError, sError FROM Error;

               ROLLBACK ;
          ELSE
                 COMMIT ;
        END IF ;

          DROP TEMPORARY TABLE Error;
          DROP TEMPORARY TABLE Event;

           SET nResult = bCommit - 1 - nError;
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                            MVD_RP1_Map : set_RMPObject_Type.sql                                            ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                              Copyright 2023-2025 Metaversal Corporation. All rights reserved.                              ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE set_RMPObject_Type
(
   IN    sIPAddress                    VARCHAR (16),
   IN    twRPersonaIx                  BIGINT,
   IN    twRMPObjectIx                 BIGINT,
   IN    Type_bType                    TINYINT UNSIGNED,
   IN    Type_bSubtype                 TINYINT UNSIGNED,
   IN    Type_bFiction                 TINYINT UNSIGNED,
   IN    Type_bMovable                 TINYINT UNSIGNED,
   OUT   nResult                       INT
)
BEGIN
       DECLARE RMPOBJECT_OP_TYPE                          INT DEFAULT 2;

       DECLARE nError  INT DEFAULT 0;
       DECLARE bCommit INT DEFAULT 0;
       DECLARE bError  INT;

       DECLARE ObjectHead_Parent_wClass     SMALLINT;
       DECLARE ObjectHead_Parent_twObjectIx BIGINT;

            -- Create the temp Error table
        CREATE TEMPORARY TABLE Error
               (
                  nOrder                        INT             NOT NULL AUTO_INCREMENT PRIMARY KEY,
                  dwError                       INT             NOT NULL,
                  sError                        VARCHAR (255)   NOT NULL
               );

            -- Create the temp Event table
        CREATE TEMPORARY TABLE Event
               (
                  nOrder                        INT             NOT NULL AUTO_INCREMENT PRIMARY KEY,
                  sType                         VARCHAR (50)    NOT NULL,
                  Self_wClass                   SMALLINT        NOT NULL,
                  Self_twObjectIx               BIGINT          NOT NULL,
                  Child_wClass                  SMALLINT        NOT NULL,
                  Child_twObjectIx              BIGINT          NOT NULL,
                  wFlags                        SMALLINT        NOT NULL,
                  twEventIz                     BIGINT          NOT NULL,
                  sJSON_Object                  TEXT            NOT NULL,
                  sJSON_Child                   TEXT            NOT NULL,
                  sJSON_Change                  TEXT            NOT NULL
               );

           SET twRPersonaIx  = IFNULL (twRPersonaIx,  0);
           SET twRMPObjectIx = IFNULL (twRMPObjectIx, 0);

         START TRANSACTION;

          CALL call_RMPObject_Validate (twRPersonaIx, twRMPObjectIx, ObjectHead_Parent_wClass, ObjectHead_Parent_twObjectIx, nError);
            IF nError = 0
          THEN
                   CALL call_RMPObject_Validate_Type (ObjectHead_Parent_wClass, ObjectHead_Parent_twObjectIx, twRMPObjectIx, Type_bType, Type_bSubtype, Type_bFiction, Type_bMovable, nError);
        END IF ;

            IF nError = 0
          THEN
                   CALL call_RMPObject_Event_Type (twRMPObjectIx, Type_bType, Type_bSubtype, Type_bFiction, Type_bMovable, bError);
                     IF bError = 0
                   THEN
                             SET bCommit = 1;
                   ELSE
                            CALL call_Error (-1, 'Failed to update RMPObject', nError);
                 END IF ;
        END IF ;
       
            IF bCommit = 1
          THEN
                    SET bCommit = 0;
                 
                   CALL call_RMPObject_Log (RMPOBJECT_OP_TYPE, sIPAddress, twRPersonaIx, twRMPObjectIx, bError);
                     IF bError = 0
                   THEN
                            CALL call_Event_Push (bError);
                              IF bError = 0
                            THEN
                                      SET bCommit = 1;
                            ELSE
                                     CALL call_Error (-9, 'Failed to push events', nError);
                          END IF ;
                   ELSE
                            CALL call_Error (-8, 'Failed to log action', nError);
                 END IF ;
        END IF ;

            IF bCommit = 0
          THEN
                 SELECT dwError, sError FROM Error;

               ROLLBACK ;
          ELSE
                 COMMIT ;
        END IF ;

          DROP TEMPORARY TABLE Error;
          DROP TEMPORARY TABLE Event;

           SET nResult = bCommit - 1 - nError;
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                            MVD_RP1_Map : call_RMTMatrix_Car.sql                                            ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2023 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE call_RMTMatrix_Car
(
   IN    twRMTObjectIx                 BIGINT,
   IN    dX                            DOUBLE,
   IN    dY                            DOUBLE,
   IN    dZ                            DOUBLE,
   OUT   nResult                       INT
)
BEGIN
       DECLARE RMTMATRIX_COORD_CAR                       INT DEFAULT 1;

        INSERT INTO RMTSubsurface
               ( twRMTObjectIx, tnGeometry,          dA, dB, dC )
        VALUES ( twRMTObjectIx, RMTMATRIX_COORD_CAR, dX, dY, dZ );

        INSERT INTO RMTMatrix
               (  bnMatrix,

                  d00, d01, d02, d03,
                  d10, d11, d12, d13,
                  d20, d21, d22, d23,
                  d30, d31, d32, d33
               )
        VALUES ( twRMTObjectIx,

                  1 ,  0 ,  0 ,  dX ,
                  0 ,  1 ,  0 ,  dY ,
                  0 ,  0 ,  1 ,  dZ ,
                  0 ,  0 ,  0 ,  1
               );

        INSERT INTO RMTMatrix
               ( bnMatrix           )
        VALUES ( 0 - twRMTObjectIx );

          CALL call_RMTMatrix_Inverse (twRMTObjectIx, nResult);
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                            MVD_RP1_Map : call_RMTMatrix_Cyl.sql                                            ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2023 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE call_RMTMatrix_Cyl
(
   IN    twRMTObjectIx                 BIGINT,
   IN    dTheta                        DOUBLE,
   IN    dY                            DOUBLE,
   IN    dRadius                       DOUBLE,
   OUT   nResult                       INT
)
BEGIN
       DECLARE RMTMATRIX_COORD_CYL                       INT DEFAULT 2;

            -- right handed (counter-clockwise rotation), Y up, negative Z forward
            -- theta == 0 degrees aligns with the +z axis
         
            -- this is a special case of the geographic coordiate system with latitude = 0

       DECLARE dThe    DOUBLE DEFAULT RADIANS (dTheta);
            -- dY      DOUBLE DEFAULT          dY;
       DECLARE dRad    DOUBLE DEFAULT          dRadius;
       DECLARE dOI     DOUBLE DEFAULT 1;

       DECLARE dCThe DOUBLE DEFAULT COS (dThe);
       DECLARE dSThe DOUBLE DEFAULT SIN (dThe);

            IF dRad < 0
          THEN
               SET dRad = dRad * -1;
               SET dOI = dOI * -1;
            END IF ;

            -- MXform_Identity     (MXform);
            -- MXform_Translate    (MXform, dRad * dCLat * dSThe, dRad * dSLat, dRad * dCLat * dCThe);
            -- MXform_Rotate_Y     (MXform, dThe);                                                              -- +z axis aligns with theta
            -- MXform_Rotate_X     (MXform, 90);                                                                -- +y axis aligns with latitude = 0
            -- MXform_Rotate_Z     (MXform, 90 +/- 90);                                                         -- +y axis aligns with latitude = 0 (direction depends on dOI)
         
            -- Matrix multiplication progresses left to right
         
            -- [ 1   0   0   0 ]     [ 1   0   0   X ]     [  dCThe   0   dSThe   0 ]     [ 1   0    0   0 ]     [ dOI   0     0   0 ]
            -- [ 0   1   0   0 ]  X  [ 0   1   0   Y ]  X  [  0       1   0       0 ]  X  [ 0   0   -1   0 ]  X  [ 0     dOI   0   0 ]
            -- [ 0   0   1   0 ]     [ 0   0   1   Z ]     [ -dSThe   0   dCThe   0 ]     [ 0   1    0   0 ]     [ 0     0     1   0 ]
            -- [ 0   0   0   1 ]     [ 0   0   0   1 ]     [  0       0   0       1 ]     [ 0   0    0   1 ]     [ 0     0     0   1 ]

        SET nResult = 0;

        INSERT INTO RMTSubsurface
               ( twRMTObjectIx, tnGeometry,          dA,     dB, dC      )
        VALUES ( twRMTObjectIx, RMTMATRIX_COORD_CYL, dTheta, dY, dRadius );

        INSERT INTO RMTMatrix
               ( bnMatrix,

                 d00,                 d01,                d02,     d03,
                 d10,                 d11,                d12,     d13,
                 d20,                 d21,                d22,     d23,
                 d30,                 d31,                d32,     d33
               )
        VALUES ( twRMTObjectIx,

                 dOI *  dCThe ,     dOI * dSThe ,      0 ,     dRad * dSThe ,
                        0     ,           0     ,     -1 ,     dY           ,
                 dOI * -dSThe ,     dOI * dCThe ,      0 ,     dRad * dCThe ,
                        0     ,           0     ,      0 ,     1             
               );

        INSERT INTO RMTMatrix
               ( bnMatrix           )
        VALUES ( 0 - twRMTObjectIx );

          CALL call_RMTMatrix_Inverse(twRMTObjectIx, nResult);
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                            MVD_RP1_Map : call_RMTMatrix_Geo.sql                                            ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2023 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE call_RMTMatrix_Geo
(
   IN    twRMTObjectIx                 BIGINT,
   IN    dLatitude                     DOUBLE,
   IN    dLongitude                    DOUBLE,
   IN    dRadius                       DOUBLE,
   OUT   nResult                       INT
)
BEGIN
       DECLARE RMTMATRIX_COORD_GEO                       INT DEFAULT 3;

       DECLARE nResult INT DEFAULT 0;

            -- right handed (counter-clockwise rotation), Y up, negative Z forward
            -- longitude == 0 degrees (the prime meridian) aligns with the +z axis

       DECLARE dLatX   DOUBLE DEFAULT RADIANS (90.0 - dLatitude);
       DECLARE dLat    DOUBLE DEFAULT RADIANS (dLatitude);
       DECLARE dLon    DOUBLE DEFAULT RADIANS (dLongitude);
       DECLARE dRad    DOUBLE DEFAULT dRadius;
       DECLARE dOI     DOUBLE DEFAULT 1;

       DECLARE dCLatX  DOUBLE DEFAULT COS (dLatX);
       DECLARE dSLatX  DOUBLE DEFAULT SIN (dLatX);
       DECLARE dCLat   DOUBLE DEFAULT COS (dLat);
       DECLARE dSLat   DOUBLE DEFAULT SIN (dLat);
       DECLARE dCLon   DOUBLE DEFAULT COS (dLon);
       DECLARE dSLon   DOUBLE DEFAULT SIN (dLon);

            IF dRad < 0
          THEN
               SET dRad = dRad * -1;
               SET dOI = dOI * -1;
            END IF ;

            -- MXform_Identity     (MXform);
            -- MXform_Translate    (MXform, dRad * dCLat * dSLon, dRad * dSLat, dRad * dCLat * dCLon);
            -- MXform_Rotate_Y     (MXform, dLon);                                                              -- +z axis aligns with longitude
            -- MXform_Rotate_X     (MXform, dLatX);                                                             -- +y axis aligns with latitude
            -- MXform_Rotate_Z     (MXform, 90 +/- 90);                                                         -- +y axis aligns with latitude (direction depends on dOI)

            -- Matrix multiplication progresses left to right

            -- [ 1   0   0   0 ]     [ 1   0   0   X ]     [  dCLon   0   dSLon   0 ]     [ 1   0         0        0 ]     [ dOI   0     0   0 ]
            -- [ 0   1   0   0 ]  X  [ 0   1   0   Y ]  X  [  0       1   0       0 ]  X  [ 0   dCLatX   -dSLatX   0 ]  X  [ 0     dOI   0   0 ]
            -- [ 0   0   1   0 ]     [ 0   0   1   Z ]     [ -dSLon   0   dCLon   0 ]     [ 0   dSLatX    dCLatX   0 ]     [ 0     0     1   0 ]
            -- [ 0   0   0   1 ]     [ 0   0   0   1 ]     [  0       0   0       1 ]     [ 0   0         0        1 ]     [ 0     0     0   1 ]

        INSERT INTO RMTSubsurface
               ( twRMTObjectIx, tnGeometry,          dA,        dB,         dC      )
        VALUES ( twRMTObjectIx, RMTMATRIX_COORD_GEO, dLatitude, dLongitude, dRadius );

        INSERT INTO RMTMatrix
               ( bnMatrix,

                 d00,                 d01,                           d02,                   d03,
                 d10,                 d11,                           d12,                   d13,
                 d20,                 d21,                           d22,                   d23,
                 d30,                 d31,                           d32,                   d33
               )
        VALUES ( twRMTObjectIx,

                 dOI *  dCLon ,     dOI * dSLon * dSLatX ,      dSLon * dCLatX ,     dRad * dCLat * dSLon ,
                        0     ,     dOI * dCLatX         ,     -dSLatX         ,     dRad * dSLat         ,
                 dOI * -dSLon ,     dOI * dCLon * dSLatX ,      dCLon * dCLatX ,     dRad * dCLat * dCLon ,
                        0     ,           0              ,      0              ,     1
               );

        INSERT INTO RMTMatrix
               ( bnMatrix          )
        VALUES ( 0 - twRMTObjectIx );

          CALL call_RMTMatrix_Inverse(twRMTObjectIx, nResult);
END$$

DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                          MVD_RP1_Map : call_RMTMatrix_Inverse.sql                                          ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2023 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE call_RMTMatrix_Inverse
(
   IN    bnMatrix                      BIGINT,
   OUT   nResult                       INT
)
BEGIN
       DECLARE d00 DOUBLE; DECLARE d01 DOUBLE; DECLARE d02 DOUBLE; DECLARE d03 DOUBLE;
       DECLARE d10 DOUBLE; DECLARE d11 DOUBLE; DECLARE d12 DOUBLE; DECLARE d13 DOUBLE;
       DECLARE d20 DOUBLE; DECLARE d21 DOUBLE; DECLARE d22 DOUBLE; DECLARE d23 DOUBLE;
       DECLARE d30 DOUBLE; DECLARE d31 DOUBLE; DECLARE d32 DOUBLE; DECLARE d33 DOUBLE;

       DECLARE s0 DOUBLE; DECLARE s1 DOUBLE; DECLARE s2 DOUBLE; DECLARE s3 DOUBLE;
       DECLARE s4 DOUBLE; DECLARE s5 DOUBLE;
       DECLARE c0 DOUBLE; DECLARE c1 DOUBLE; DECLARE c2 DOUBLE; DECLARE c3 DOUBLE;
       DECLARE c4 DOUBLE; DECLARE c5 DOUBLE;
       DECLARE dDeterminant DOUBLE; DECLARE dDeterminant_ DOUBLE;

           SET nResult = 0;

        SELECT d00, d01, d02, d03,
               d10, d11, d12, d13,
               d20, d21, d22, d23,
               d30, d31, d32, d33
          INTO d00, d01, d02, d03,
               d10, d11, d12, d13,
               d20, d21, d22, d23,
               d30, d31, d32, d33
          FROM RMTMatrix
         WHERE bnMatrix = bnMatrix;

           SET s0 = d00 * d11 - d10 * d01;
           SET s1 = d00 * d12 - d10 * d02;
           SET s2 = d00 * d13 - d10 * d03;
           SET s3 = d01 * d12 - d11 * d02;
           SET s4 = d01 * d13 - d11 * d03;
           SET s5 = d02 * d13 - d12 * d03;

           SET c5 = d22 * d33 - d32 * d23;
           SET c4 = d21 * d33 - d31 * d23;
           SET c3 = d21 * d32 - d31 * d22;
           SET c2 = d20 * d33 - d30 * d23;
           SET c1 = d20 * d32 - d30 * d22;
           SET c0 = d20 * d31 - d30 * d21;

           SET dDeterminant = s0 * c5 - s1 * c4 + s2 * c3 + s3 * c2 - s4 * c1 + s5 * c0;

            IF dDeterminant <> 0
          THEN
                SET dDeterminant_ = 1 / dDeterminant;
           
                 UPDATE RMTMatrix
                    SET d00 = ( d11 * c5 - d12 * c4 + d13 * c3) * dDeterminant_,
                        d01 = (-d01 * c5 + d02 * c4 - d03 * c3) * dDeterminant_,
                        d02 = ( d31 * s5 - d32 * s4 + d33 * s3) * dDeterminant_,
                        d03 = (-d21 * s5 + d22 * s4 - d23 * s3) * dDeterminant_,
           
                        d10 = (-d10 * c5 + d12 * c2 - d13 * c1) * dDeterminant_,
                        d11 = ( d00 * c5 - d02 * c2 + d03 * c1) * dDeterminant_,
                        d12 = (-d30 * s5 + d32 * s2 - d33 * s1) * dDeterminant_,
                        d13 = ( d20 * s5 - d22 * s2 + d23 * s1) * dDeterminant_,
           
                        d20 = ( d10 * c4 - d11 * c2 + d13 * c0) * dDeterminant_,
                        d21 = (-d00 * c4 + d01 * c2 - d03 * c0) * dDeterminant_,
                        d22 = ( d30 * s4 - d31 * s2 + d33 * s0) * dDeterminant_,
                        d23 = (-d20 * s4 + d21 * s2 - d23 * s0) * dDeterminant_,
           
                        d30 = (-d10 * c3 + d11 * c1 - d12 * c0) * dDeterminant_,
                        d31 = ( d00 * c3 - d01 * c1 + d02 * c0) * dDeterminant_,
                        d32 = (-d30 * s3 + d31 * s1 - d32 * s0) * dDeterminant_,
                        d33 = ( d20 * s3 - d21 * s1 + d22 * s0) * dDeterminant_
                  WHERE bnMatrix = 0 - bnMatrix;

                    SET nResult = 1;
        END IF ;
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                            MVD_RP1_Map : call_RMTMatrix_Mult.sql                                           ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2023 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE call_RMTMatrix_Mult
(
   IN    bnMatrix_R                    BIGINT,
   IN    bnMatrix_L                    BIGINT
)
BEGIN
        UPDATE RMTMatrix AS mr
          JOIN RMTMatrix AS ml ON ml.bnMatrix = bnMatrix_L
           SET mr.d00 = (ml.d00 * mr.d00) + (ml.d01 * mr.d10) + (ml.d02 * mr.d20) + (ml.d03 * mr.d30),
               mr.d01 = (ml.d00 * mr.d01) + (ml.d01 * mr.d11) + (ml.d02 * mr.d21) + (ml.d03 * mr.d31),
               mr.d02 = (ml.d00 * mr.d02) + (ml.d01 * mr.d12) + (ml.d02 * mr.d22) + (ml.d03 * mr.d32),
               mr.d03 = (ml.d00 * mr.d03) + (ml.d01 * mr.d13) + (ml.d02 * mr.d23) + (ml.d03 * mr.d33),

               mr.d10 = (ml.d10 * mr.d00) + (ml.d11 * mr.d10) + (ml.d12 * mr.d20) + (ml.d13 * mr.d30),
               mr.d11 = (ml.d10 * mr.d01) + (ml.d11 * mr.d11) + (ml.d12 * mr.d21) + (ml.d13 * mr.d31),
               mr.d12 = (ml.d10 * mr.d02) + (ml.d11 * mr.d12) + (ml.d12 * mr.d22) + (ml.d13 * mr.d32),
               mr.d13 = (ml.d10 * mr.d03) + (ml.d11 * mr.d13) + (ml.d12 * mr.d23) + (ml.d13 * mr.d33),

               mr.d20 = (ml.d20 * mr.d00) + (ml.d21 * mr.d10) + (ml.d22 * mr.d20) + (ml.d23 * mr.d30),
               mr.d21 = (ml.d20 * mr.d01) + (ml.d21 * mr.d11) + (ml.d22 * mr.d21) + (ml.d23 * mr.d31),
               mr.d22 = (ml.d20 * mr.d02) + (ml.d21 * mr.d12) + (ml.d22 * mr.d22) + (ml.d23 * mr.d32),
               mr.d23 = (ml.d20 * mr.d03) + (ml.d21 * mr.d13) + (ml.d22 * mr.d23) + (ml.d23 * mr.d33),

               mr.d30 = (ml.d30 * mr.d00) + (ml.d31 * mr.d10) + (ml.d32 * mr.d20) + (ml.d33 * mr.d30),
               mr.d31 = (ml.d30 * mr.d01) + (ml.d31 * mr.d11) + (ml.d32 * mr.d21) + (ml.d33 * mr.d31),
               mr.d32 = (ml.d30 * mr.d02) + (ml.d31 * mr.d12) + (ml.d32 * mr.d22) + (ml.d33 * mr.d32),
               mr.d33 = (ml.d30 * mr.d03) + (ml.d31 * mr.d13) + (ml.d32 * mr.d23) + (ml.d33 * mr.d33)

         WHERE mr.bnMatrix = bnMatrix_R;
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                            MVD_RP1_Map : call_RMTMatrix_Nul.sql                                            ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2023 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE call_RMTMatrix_Nul
(
   IN    ObjectHead_Parent_wClass      SMALLINT,
   IN    ObjectHead_Parent_twObjectIx  BIGINT,
   IN    twRMTObjectIx                 BIGINT,
   IN    Transform_Position_dX         DOUBLE,
   IN    Transform_Position_dY         DOUBLE,
   IN    Transform_Position_dZ         DOUBLE,
   IN    Transform_Rotation_dX         DOUBLE,
   IN    Transform_Rotation_dY         DOUBLE,
   IN    Transform_Rotation_dZ         DOUBLE,
   IN    Transform_Rotation_dW         DOUBLE,
   IN    Transform_Scale_dX            DOUBLE,
   IN    Transform_Scale_dY            DOUBLE,
   IN    Transform_Scale_dZ            DOUBLE,
   OUT   nResult                       INT
)
BEGIN
       DECLARE SBO_CLASS_RMTOBJECT                       INT DEFAULT 72;
       DECLARE RMTMATRIX_COORD_NUL                       INT DEFAULT 0;

        INSERT INTO RMTSubsurface
               (  twRMTObjectIx, tnGeometry,            dA,  dB,  dC )
        VALUES ( twRMTObjectIx, RMTMATRIX_COORD_NUL,   0,   0,   0 );

        INSERT INTO RMTMatrix
               ( bnMatrix       )
        VALUES ( twRMTObjectIx );

            IF ObjectHead_Parent_wClass = SBO_CLASS_RMTOBJECT AND ObjectHead_Parent_twObjectIx <> 0
          THEN
               CALL call_RMTMatrix_Mult(twRMTObjectIx, ObjectHead_Parent_twObjectIx);
        END IF ;

          CALL call_RMTMatrix_Translate(twRMTObjectIx, Transform_Position_dX, Transform_Position_dY, Transform_Position_dZ);

          CALL call_RMTMatrix_Rotate(twRMTObjectIx, Transform_Rotation_dX, Transform_Rotation_dY, Transform_Rotation_dZ, Transform_Rotation_dW);

          CALL call_RMTMatrix_Scale(twRMTObjectIx, Transform_Scale_dX, Transform_Scale_dY, Transform_Scale_dZ);

        INSERT INTO RMTMatrix
               ( bnMatrix           )
        VALUES ( 0 - twRMTObjectIx );

          CALL call_RMTMatrix_Inverse(twRMTObjectIx, nResult);
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                          MVD_RP1_Map : call_RMTMatrix_Relative.sql                                         ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2023 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE call_RMTMatrix_Relative
(
   IN ObjectHead_Parent_wClass     SMALLINT,
   IN ObjectHead_Parent_twObjectIx BIGINT,
   IN twRMTObjectIx                BIGINT
)
BEGIN
       DECLARE SBO_CLASS_RMTOBJECT                       INT DEFAULT 72;

       DECLARE d00 DOUBLE; DECLARE d01 DOUBLE; DECLARE d02 DOUBLE; DECLARE d03 DOUBLE;
       DECLARE d10 DOUBLE; DECLARE d11 DOUBLE; DECLARE d12 DOUBLE; DECLARE d13 DOUBLE;
       DECLARE d20 DOUBLE; DECLARE d21 DOUBLE; DECLARE d22 DOUBLE; DECLARE d23 DOUBLE;
       DECLARE d30 DOUBLE; DECLARE d31 DOUBLE; DECLARE d32 DOUBLE; DECLARE d33 DOUBLE;

       DECLARE dTX DOUBLE; DECLARE dTY DOUBLE; DECLARE dTZ DOUBLE;
       DECLARE dRX DOUBLE; DECLARE dRY DOUBLE; DECLARE dRZ DOUBLE; DECLARE dRW DOUBLE;
       DECLARE dSX DOUBLE; DECLARE dSY DOUBLE; DECLARE dSZ DOUBLE;

       DECLARE dTrace DOUBLE;
       DECLARE dS     DOUBLE;
       DECLARE dN     DOUBLE;

            IF ObjectHead_Parent_wClass = SBO_CLASS_RMTOBJECT AND ObjectHead_Parent_twObjectIx <> 0
          THEN
                     -- perform a mult into local variables

                 SELECT (ml.d00 * mr.d00) + (ml.d01 * mr.d10) + (ml.d02 * mr.d20) + (ml.d03 * mr.d30),
                        (ml.d00 * mr.d01) + (ml.d01 * mr.d11) + (ml.d02 * mr.d21) + (ml.d03 * mr.d31),
                        (ml.d00 * mr.d02) + (ml.d01 * mr.d12) + (ml.d02 * mr.d22) + (ml.d03 * mr.d32),
                        (ml.d00 * mr.d03) + (ml.d01 * mr.d13) + (ml.d02 * mr.d23) + (ml.d03 * mr.d33),

                        (ml.d10 * mr.d00) + (ml.d11 * mr.d10) + (ml.d12 * mr.d20) + (ml.d13 * mr.d30),
                        (ml.d10 * mr.d01) + (ml.d11 * mr.d11) + (ml.d12 * mr.d21) + (ml.d13 * mr.d31),
                        (ml.d10 * mr.d02) + (ml.d11 * mr.d12) + (ml.d12 * mr.d22) + (ml.d13 * mr.d32),
                        (ml.d10 * mr.d03) + (ml.d11 * mr.d13) + (ml.d12 * mr.d23) + (ml.d13 * mr.d33),

                        (ml.d20 * mr.d00) + (ml.d21 * mr.d10) + (ml.d22 * mr.d20) + (ml.d23 * mr.d30),
                        (ml.d20 * mr.d01) + (ml.d21 * mr.d11) + (ml.d22 * mr.d21) + (ml.d23 * mr.d31),
                        (ml.d20 * mr.d02) + (ml.d21 * mr.d12) + (ml.d22 * mr.d22) + (ml.d23 * mr.d32),
                        (ml.d20 * mr.d03) + (ml.d21 * mr.d13) + (ml.d22 * mr.d23) + (ml.d23 * mr.d33),

                        (ml.d30 * mr.d00) + (ml.d31 * mr.d10) + (ml.d32 * mr.d20) + (ml.d33 * mr.d30),
                        (ml.d30 * mr.d01) + (ml.d31 * mr.d11) + (ml.d32 * mr.d21) + (ml.d33 * mr.d31),
                        (ml.d30 * mr.d02) + (ml.d31 * mr.d12) + (ml.d32 * mr.d22) + (ml.d33 * mr.d32),
                        (ml.d30 * mr.d03) + (ml.d31 * mr.d13) + (ml.d32 * mr.d23) + (ml.d33 * mr.d33)

                   INTO d00, d01, d02, d03, 
                        d10, d11, d12, d13,
                        d20, d21, d22, d23,
                        d30, d31, d32, d33

                   FROM RMTMatrix AS ml
                   JOIN RMTMatrix AS mr ON mr.bnMatrix = twRMTObjectIx
                  WHERE ml.bnMatrix = 0 - ObjectHead_Parent_twObjectIx;                 -- parent's inverse matrix
          ELSE
                     -- copy matrix to local variables

                 SELECT mr.d00,
                        mr.d01,
                        mr.d02,
                        mr.d03,

                        mr.d10,
                        mr.d11,
                        mr.d12,
                        mr.d13,

                        mr.d20,
                        mr.d21,
                        mr.d23,
                        mr.d22,

                        mr.d30,
                        mr.d31,
                        mr.d32,
                        mr.d33

                   INTO d00, d01, d02, d03, 
                        d10, d11, d12, d13,
                        d20, d21, d22, d23,
                        d30, d31, d32, d33

                   FROM RMTMatrix AS mr
                  WHERE mr.bnMatrix = twRMTObjectIx;
        END IF ;

            -- Extract the translation from the matrix

           SET dTX = d03;
           SET dTY = d13;
           SET dTZ = d23;

-- SELECT 'T', dTX, dTY, dTZ

            -- Extract the rotation (quaternion) from the matrix

           SET dTrace = d00 + d11 + d22;

            IF dTrace > 0
          THEN
                  SET dS = 1 / (SQRT(dTrace + 1) * 2);

                  SET dRX = (d21 - d12) * dS;
                  SET dRY = (d02 - d20) * dS;
                  SET dRZ = (d10 - d01) * dS;
                  SET dRW = 1 / (dS * 4);
        ELSEIF d00 > d11 AND d00 > d22
          THEN
                  SET dS = 2 * SQRT(1 + d00 - d11 - d22);

                  SET dRX = dS / 4;
                  SET dRY = (d01 + d10) / dS;
                  SET dRZ = (d02 + d20) / dS;
                  SET dRW = (d21 - d12) / dS;
        ELSEIF d11 > d22
          THEN
                  SET dS = 2 * SQRT(1 + d11 - d00 - d22);

                  SET dRX = (d01 + d10) / dS;
                  SET dRY = dS / 4;
                  SET dRZ = (d12 + d21) / dS;
                  SET dRW = (d02 - d20) / dS;
          ELSE
                  SET dS = 2 * SQRT(1 + d22 - d00 - d11);

                  SET dRX = (d02 + d20) / dS;
                  SET dRY = (d12 + d21) / dS;
                  SET dRZ = dS / 4;
                  SET dRW = (d10 - d01) / dS;
        END IF ;

           SET dN = SQRT((dRX * dRX) + (dRY * dRY) + (dRZ * dRZ) + (dRW * dRW));

           SET dRX = dRX / dN;
           SET dRY = dRY / dN;
           SET dRZ = dRZ / dN;
           SET dRW = dRW / dN;

-- SELECT 'R', dRX, dRY, dRZ, dRW

            -- Extract the scale from the matrix

           SET dSX = SQRT((d00 * d00) + (d10 * d10) + (d20 * d20));
           SET dSY = SQRT((d01 * d01) + (d11 * d11) + (d21 * d21));
           SET dSZ = SQRT((d02 * d02) + (d12 * d12) + (d22 * d22));

            -- Update the relative transform in the object

        UPDATE RMTObject
           SET Transform_Position_dX = dTX,
               Transform_Position_dY = dTY,
               Transform_Position_dZ = dTZ,
               Transform_Rotation_dX = dRX,
               Transform_Rotation_dY = dRY,
               Transform_Rotation_dZ = dRZ,
               Transform_Rotation_dW = dRW,
               Transform_Scale_dX    = dSX,
               Transform_Scale_dY    = dSY,
               Transform_Scale_dZ    = dSZ
         WHERE ObjectHead_Self_twObjectIx = twRMTObjectIx;
END$$

DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                           MVD_RP1_Map : call_RMTMatrix_Rotate.sql                                          ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2023 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE call_RMTMatrix_Rotate
(
   IN bnMatrix_L                   BIGINT,
   IN dX                           DOUBLE,
   IN dY                           DOUBLE,
   IN dZ                           DOUBLE,
   IN dW                           DOUBLE
)
BEGIN
       DECLARE d00 DOUBLE DEFAULT 1 - 2 * dY * dY - 2 * dZ * dZ;
       DECLARE d01 DOUBLE DEFAULT     2 * dX * dY - 2 * dZ * dW;
       DECLARE d02 DOUBLE DEFAULT     2 * dX * dZ + 2 * dY * dW;
       DECLARE d03 DOUBLE DEFAULT                                 0;

       DECLARE d10 DOUBLE DEFAULT     2 * dX * dY + 2 * dZ * dW;
       DECLARE d11 DOUBLE DEFAULT 1 - 2 * dX * dX - 2 * dZ * dZ;
       DECLARE d12 DOUBLE DEFAULT     2 * dY * dZ - 2 * dX * dW;
       DECLARE d13 DOUBLE DEFAULT                                 0;

       DECLARE d20 DOUBLE DEFAULT     2 * dX * dZ - 2 * dY * dW;
       DECLARE d21 DOUBLE DEFAULT     2 * dY * dZ + 2 * dX * dW;
       DECLARE d22 DOUBLE DEFAULT 1 - 2 * dX * dX - 2 * dY * dY;
       DECLARE d23 DOUBLE DEFAULT                                 0;

       DECLARE d30 DOUBLE DEFAULT                                 0;
       DECLARE d31 DOUBLE DEFAULT                                 0;
       DECLARE d32 DOUBLE DEFAULT                                 0;
       DECLARE d33 DOUBLE DEFAULT                                 1;

        UPDATE RMTMatrix AS ml
           SET ml.d00 = (ml.d00 * d00) + (ml.d01 * d10) + (ml.d02 * d20) + (ml.d03 * d30),
               ml.d01 = (ml.d00 * d01) + (ml.d01 * d11) + (ml.d02 * d21) + (ml.d03 * d31),
               ml.d02 = (ml.d00 * d02) + (ml.d01 * d12) + (ml.d02 * d22) + (ml.d03 * d32),
               ml.d03 = (ml.d00 * d03) + (ml.d01 * d13) + (ml.d02 * d23) + (ml.d03 * d33),

               ml.d10 = (ml.d10 * d00) + (ml.d11 * d10) + (ml.d12 * d20) + (ml.d13 * d30),
               ml.d11 = (ml.d10 * d01) + (ml.d11 * d11) + (ml.d12 * d21) + (ml.d13 * d31),
               ml.d12 = (ml.d10 * d02) + (ml.d11 * d12) + (ml.d12 * d22) + (ml.d13 * d32),
               ml.d13 = (ml.d10 * d03) + (ml.d11 * d13) + (ml.d12 * d23) + (ml.d13 * d33),

               ml.d20 = (ml.d20 * d00) + (ml.d21 * d10) + (ml.d22 * d20) + (ml.d23 * d30),
               ml.d21 = (ml.d20 * d01) + (ml.d21 * d11) + (ml.d22 * d21) + (ml.d23 * d31),
               ml.d22 = (ml.d20 * d02) + (ml.d21 * d12) + (ml.d22 * d22) + (ml.d23 * d32),
               ml.d23 = (ml.d20 * d03) + (ml.d21 * d13) + (ml.d22 * d23) + (ml.d23 * d33),

               ml.d30 = (ml.d30 * d00) + (ml.d31 * d10) + (ml.d32 * d20) + (ml.d33 * d30),
               ml.d31 = (ml.d30 * d01) + (ml.d31 * d11) + (ml.d32 * d21) + (ml.d33 * d31),
               ml.d32 = (ml.d30 * d02) + (ml.d31 * d12) + (ml.d32 * d22) + (ml.d33 * d32),
               ml.d33 = (ml.d30 * d03) + (ml.d31 * d13) + (ml.d32 * d23) + (ml.d33 * d33)

         WHERE ml.bnMatrix = bnMatrix_L;
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                           MVD_RP1_Map : call_RMTMatrix_Scale.sql                                           ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2023 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE call_RMTMatrix_Scale
(
   IN bnMatrix_L                   BIGINT,
   IN dX                           DOUBLE,
   IN dY                           DOUBLE,
   IN dZ                           DOUBLE
)
BEGIN
       DECLARE d00 DOUBLE DEFAULT dX;
       DECLARE d01 DOUBLE DEFAULT 0;
       DECLARE d02 DOUBLE DEFAULT 0;
       DECLARE d03 DOUBLE DEFAULT 0;

       DECLARE d10 DOUBLE DEFAULT 0;
       DECLARE d11 DOUBLE DEFAULT dY;
       DECLARE d12 DOUBLE DEFAULT 0;
       DECLARE d13 DOUBLE DEFAULT 0;

       DECLARE d20 DOUBLE DEFAULT 0;
       DECLARE d21 DOUBLE DEFAULT 0;
       DECLARE d22 DOUBLE DEFAULT dZ;
       DECLARE d23 DOUBLE DEFAULT 0;

       DECLARE d30 DOUBLE DEFAULT 0;
       DECLARE d31 DOUBLE DEFAULT 0;
       DECLARE d32 DOUBLE DEFAULT 0;
       DECLARE d33 DOUBLE DEFAULT 1;

        UPDATE RMTMatrix AS ml
           SET ml.d00 = (ml.d00 * d00) + (ml.d01 * d10) + (ml.d02 * d20) + (ml.d03 * d30),
               ml.d01 = (ml.d00 * d01) + (ml.d01 * d11) + (ml.d02 * d21) + (ml.d03 * d31),
               ml.d02 = (ml.d00 * d02) + (ml.d01 * d12) + (ml.d02 * d22) + (ml.d03 * d32),
               ml.d03 = (ml.d00 * d03) + (ml.d01 * d13) + (ml.d02 * d23) + (ml.d03 * d33),

               ml.d10 = (ml.d10 * d00) + (ml.d11 * d10) + (ml.d12 * d20) + (ml.d13 * d30),
               ml.d11 = (ml.d10 * d01) + (ml.d11 * d11) + (ml.d12 * d21) + (ml.d13 * d31),
               ml.d12 = (ml.d10 * d02) + (ml.d11 * d12) + (ml.d12 * d22) + (ml.d13 * d32),
               ml.d13 = (ml.d10 * d03) + (ml.d11 * d13) + (ml.d12 * d23) + (ml.d13 * d33),

               ml.d20 = (ml.d20 * d00) + (ml.d21 * d10) + (ml.d22 * d20) + (ml.d23 * d30),
               ml.d21 = (ml.d20 * d01) + (ml.d21 * d11) + (ml.d22 * d21) + (ml.d23 * d31),
               ml.d22 = (ml.d20 * d02) + (ml.d21 * d12) + (ml.d22 * d22) + (ml.d23 * d32),
               ml.d23 = (ml.d20 * d03) + (ml.d21 * d13) + (ml.d22 * d23) + (ml.d23 * d33),

               ml.d30 = (ml.d30 * d00) + (ml.d31 * d10) + (ml.d32 * d20) + (ml.d33 * d30),
               ml.d31 = (ml.d30 * d01) + (ml.d31 * d11) + (ml.d32 * d21) + (ml.d33 * d31),
               ml.d32 = (ml.d30 * d02) + (ml.d31 * d12) + (ml.d32 * d22) + (ml.d33 * d32),
               ml.d33 = (ml.d30 * d03) + (ml.d31 * d13) + (ml.d32 * d23) + (ml.d33 * d33)

         WHERE ml.bnMatrix = bnMatrix_L;
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                         MVD_RP1_Map : call_RMTMatrix_Translate.sql                                         ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2023 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE call_RMTMatrix_Translate
(
   IN bnMatrix_L                   BIGINT,
   IN dX                           DOUBLE,
   IN dY                           DOUBLE,
   IN dZ                           DOUBLE
)
BEGIN
       DECLARE d00 DOUBLE DEFAULT 1;
       DECLARE d01 DOUBLE DEFAULT 0;
       DECLARE d02 DOUBLE DEFAULT 0;
       DECLARE d03 DOUBLE DEFAULT dX;

       DECLARE d10 DOUBLE DEFAULT 0;
       DECLARE d11 DOUBLE DEFAULT 1;
       DECLARE d12 DOUBLE DEFAULT 0;
       DECLARE d13 DOUBLE DEFAULT dY;

       DECLARE d20 DOUBLE DEFAULT 0;
       DECLARE d21 DOUBLE DEFAULT 0;
       DECLARE d22 DOUBLE DEFAULT 1;
       DECLARE d23 DOUBLE DEFAULT dZ;

       DECLARE d30 DOUBLE DEFAULT 0;
       DECLARE d31 DOUBLE DEFAULT 0;
       DECLARE d32 DOUBLE DEFAULT 0;
       DECLARE d33 DOUBLE DEFAULT 1;

        UPDATE RMTMatrix AS ml
           SET ml.d00 = (ml.d00 * d00) + (ml.d01 * d10) + (ml.d02 * d20) + (ml.d03 * d30),
               ml.d01 = (ml.d00 * d01) + (ml.d01 * d11) + (ml.d02 * d21) + (ml.d03 * d31),
               ml.d02 = (ml.d00 * d02) + (ml.d01 * d12) + (ml.d02 * d22) + (ml.d03 * d32),
               ml.d03 = (ml.d00 * d03) + (ml.d01 * d13) + (ml.d02 * d23) + (ml.d03 * d33),

               ml.d10 = (ml.d10 * d00) + (ml.d11 * d10) + (ml.d12 * d20) + (ml.d13 * d30),
               ml.d11 = (ml.d10 * d01) + (ml.d11 * d11) + (ml.d12 * d21) + (ml.d13 * d31),
               ml.d12 = (ml.d10 * d02) + (ml.d11 * d12) + (ml.d12 * d22) + (ml.d13 * d32),
               ml.d13 = (ml.d10 * d03) + (ml.d11 * d13) + (ml.d12 * d23) + (ml.d13 * d33),

               ml.d20 = (ml.d20 * d00) + (ml.d21 * d10) + (ml.d22 * d20) + (ml.d23 * d30),
               ml.d21 = (ml.d20 * d01) + (ml.d21 * d11) + (ml.d22 * d21) + (ml.d23 * d31),
               ml.d22 = (ml.d20 * d02) + (ml.d21 * d12) + (ml.d22 * d22) + (ml.d23 * d32),
               ml.d23 = (ml.d20 * d03) + (ml.d21 * d13) + (ml.d22 * d23) + (ml.d23 * d33),

               ml.d30 = (ml.d30 * d00) + (ml.d31 * d10) + (ml.d32 * d20) + (ml.d33 * d30),
               ml.d31 = (ml.d30 * d01) + (ml.d31 * d11) + (ml.d32 * d21) + (ml.d33 * d31),
               ml.d32 = (ml.d30 * d02) + (ml.d31 * d12) + (ml.d32 * d22) + (ml.d33 * d32),
               ml.d33 = (ml.d30 * d03) + (ml.d31 * d13) + (ml.d32 * d23) + (ml.d33 * d33)

         WHERE ml.bnMatrix = bnMatrix_L;
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                           MVD_RP1_Map : call_RMTObject_Event.sql                                           ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2025 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE call_RMTObject_Event
(
   IN    twRMTObjectIx                 BIGINT,
   OUT   twEventIz                     BIGINT,
   OUT   bError                        INT
)
BEGIN
        SELECT ObjectHead_twEventIz
          INTO twEventIz
          FROM RMTObject
         WHERE ObjectHead_Self_twObjectIx = twRMTObjectIx;

            -- Success will be tested on the update below

        UPDATE RMTObject
           SET ObjectHead_twEventIz = ObjectHead_twEventIz + 1
         WHERE ObjectHead_Self_twObjectIx = twRMTObjectIx;

           SET bError = IF (ROW_COUNT () = 1, 0, 1);
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                        MVD_RP1_Map : call_RMTObject_Event_Bound.sql                                        ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2023 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE call_RMTObject_Event_Bound
(
   IN    twRMTObjectIx                 BIGINT,
   IN    Bound_dX                      DOUBLE,
   IN    Bound_dY                      DOUBLE,
   IN    Bound_dZ                      DOUBLE,
   OUT   bError                        INT
)
BEGIN
       DECLARE SBO_CLASS_NULL                             INT DEFAULT 0;
       DECLARE SBO_CLASS_RMTOBJECT                        INT DEFAULT 72;

       DECLARE twEventIz BIGINT;

          CALL call_RMTObject_Event (twRMTObjectIx, twEventIz, bError);
            IF bError = 0
          THEN
                 UPDATE RMTObject
                    SET Bound_dX = Bound_dX,
                        Bound_dY = Bound_dY,
                        Bound_dZ = Bound_dZ
                  WHERE ObjectHead_Self_twObjectIx = twRMTObjectIx;

                    SET bError = IF (ROW_COUNT () = 1, 0, 1);

                     IF bError = 0
                   THEN
                          INSERT INTO Event
                                 (sType, Self_wClass, Self_twObjectIx, Child_wClass, Child_twObjectIx, wFlags, twEventIz, sJSON_Object, sJSON_Child, sJSON_Change)
                          SELECT 'BOUND',

                                 SBO_CLASS_RMTOBJECT,
                                 twRMTObjectIx,
                                 SBO_CLASS_NULL,
                                 0,
                                 0,
                                 twEventIz,

                                 CONCAT
                                 (
                                   '{ ',
                                     '"pBound": ',        Format_Bound
                                                          (
                                                             Bound_dX,
                                                             Bound_dY,
                                                             Bound_dZ
                                                          ),
                                  ' }'
                                 ),

                                 '{ }',

                                 '{ }';

                             SET bError = IF (ROW_COUNT () = 1, 0, 1);
                 END IF ;
        END IF ;
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                         MVD_RP1_Map : call_RMTObject_Event_Name.sql                                        ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2023 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE call_RMTObject_Event_Name
(
   IN    twRMTObjectIx                 BIGINT,
   IN    Name_wsRMTObjectId            VARCHAR (48),
   OUT   bError                        INT
)
BEGIN
       DECLARE SBO_CLASS_NULL                             INT DEFAULT 0;
       DECLARE SBO_CLASS_RMTOBJECT                        INT DEFAULT 72;

       DECLARE twEventIz BIGINT;

          CALL call_RMTObject_Event (twRMTObjectIx, twEventIz, bError);
            IF bError = 0
          THEN
                 UPDATE RMTObject
                    SET Name_wsRMTObjectId = Name_wsRMTObjectId
                  WHERE ObjectHead_Self_twObjectIx = twRMTObjectIx;

                    SET bError = IF (ROW_COUNT () = 1, 0, 1);

                     IF bError = 0
                   THEN
                          INSERT INTO Event
                                 (sType, Self_wClass, Self_twObjectIx, Child_wClass, Child_twObjectIx, wFlags, twEventIz, sJSON_Object, sJSON_Child, sJSON_Change)
                          SELECT 'NAME',

                                 SBO_CLASS_RMTOBJECT,
                                 twRMTObjectIx,
                                 SBO_CLASS_NULL,
                                 0,
                                 0,
                                 twEventIz,

                                 CONCAT
                                 (
                                   '{ ',
                                     '"pName": ',         Format_Name_T
                                                          (
                                                             Name_wsRMTObjectId
                                                          ),
                                  ' }'
                                 ),

                                 '{ }',

                                 '{ }';

                             SET bError = IF (ROW_COUNT () = 1, 0, 1);
                 END IF ;
        END IF ;
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                        MVD_RP1_Map : call_RMTObject_Event_Owner.sql                                        ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2023 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE call_RMTObject_Event_Owner
(
   IN    twRMTObjectIx                 BIGINT,
   IN    Owner_twRPersonaIx            BIGINT,
   OUT   bError                        INT
)
BEGIN
       DECLARE SBO_CLASS_NULL                             INT DEFAULT 0;
       DECLARE SBO_CLASS_RMTOBJECT                        INT DEFAULT 72;

       DECLARE twEventIz BIGINT;

          CALL call_RMTObject_Event (twRMTObjectIx, twEventIz, bError);
            IF bError = 0
          THEN
                 UPDATE RMTObject
                    SET Owner_twRPersonaIx = Owner_twRPersonaIx
                  WHERE ObjectHead_Self_twObjectIx = twRMTObjectIx;

                    SET bError = IF (ROW_COUNT () = 1, 0, 1);

                     IF bError = 0
                   THEN
                          INSERT INTO Event
                                 (sType, Self_wClass, Self_twObjectIx, Child_wClass, Child_twObjectIx, wFlags, twEventIz, sJSON_Object, sJSON_Child, sJSON_Change)
                          SELECT 'OWNER',

                                 SBO_CLASS_RMTOBJECT,
                                 twRMTObjectIx,
                                 SBO_CLASS_NULL,
                                 0,
                                 0,
                                 twEventIz,

                                 CONCAT
                                 (
                                   '{ ',
                                     '"pOwner": ',        Format_Owner
                                                          (
                                                             Owner_twRPersonaIx
                                                          ),
                                  ' }'
                                 ),

                                 '{ }',

                                 '{ }';

                             SET bError = IF (ROW_COUNT () = 1, 0, 1);
                 END IF ;
        END IF ;
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                      MVD_RP1_Map : call_RMTObject_Event_Properties.sql                                     ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2023 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE call_RMTObject_Event_Properties
(
   IN    twRMTObjectIx                 BIGINT,
   IN    Properties_bLockToGround      TINYINT UNSIGNED,
   IN    Properties_bYouth             TINYINT UNSIGNED,
   IN    Properties_bAdult             TINYINT UNSIGNED,
   IN    Properties_bAvatar            TINYINT UNSIGNED,
   OUT   bError                        INT
)
BEGIN
       DECLARE SBO_CLASS_NULL                             INT DEFAULT 0;
       DECLARE SBO_CLASS_RMTOBJECT                        INT DEFAULT 72;

       DECLARE twEventIz BIGINT;

          CALL call_RMTObject_Event (twRMTObjectIx, twEventIz, bError);
            IF bError = 0
          THEN
                 UPDATE RMTObject
                    SET Properties_bLockToGround = Properties_bLockToGround,
                        Properties_bYouth        = Properties_bYouth,
                        Properties_bAdult        = Properties_bAdult,
                        Properties_bAvatar       = Properties_bAvatar
                  WHERE ObjectHead_Self_twObjectIx = twRMTObjectIx;

                    SET bError = IF (ROW_COUNT () = 1, 0, 1);

                     IF bError = 0
                   THEN
                          INSERT INTO Event
                                 (sType, Self_wClass, Self_twObjectIx, Child_wClass, Child_twObjectIx, wFlags, twEventIz, sJSON_Object, sJSON_Child, sJSON_Change)
                          SELECT 'PROPERTIES',

                                 SBO_CLASS_RMTOBJECT,
                                 twRMTObjectIx,
                                 SBO_CLASS_NULL,
                                 0,
                                 0,
                                 twEventIz,

                                 CONCAT
                                 (
                                   '{ ',
                                     '"pProperties": ',   Format_Properties_T
                                                          (
                                                             Properties_bLockToGround,
                                                             Properties_bYouth,
                                                             Properties_bAdult,
                                                             Properties_bAvatar
                                                          ),
                                  ' }'
                                 ),

                                 '{ }',

                                 '{ }';

                             SET bError = IF (ROW_COUNT () = 1, 0, 1);
                 END IF ;
        END IF ;
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                       MVD_RP1_Map : call_RMTObject_Event_Resource.sql                                      ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2023 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE call_RMTObject_Event_Resource
(
   IN    twRMTObjectIx                 BIGINT,
   IN    Resource_qwResource           BIGINT,
   IN    Resource_sName                VARCHAR (48),
   IN    Resource_sReference           VARCHAR (128),
   OUT   bError                        INT
)
BEGIN
       DECLARE SBO_CLASS_NULL                             INT DEFAULT 0;
       DECLARE SBO_CLASS_RMTOBJECT                        INT DEFAULT 72;

       DECLARE twEventIz BIGINT;

          CALL call_RMTObject_Event (twRMTObjectIx, twEventIz, bError);
            IF bError = 0
          THEN
                 UPDATE RMTObject
                    SET Resource_qwResource = Resource_qwResource,
                        Resource_sName      = Resource_sName,
                        Resource_sReference = Resource_sReference       
                  WHERE ObjectHead_Self_twObjectIx = twRMTObjectIx;

                    SET bError = IF (ROW_COUNT () = 1, 0, 1);

                     IF bError = 0
                   THEN
                          INSERT INTO Event
                                 (sType, Self_wClass, Self_twObjectIx, Child_wClass, Child_twObjectIx, wFlags, twEventIz, sJSON_Object, sJSON_Child, sJSON_Change)
                          SELECT 'RESOURCE',

                                 SBO_CLASS_RMTOBJECT,
                                 twRMTObjectIx,
                                 SBO_CLASS_NULL,
                                 0,
                                 0,
                                 twEventIz,

                                 CONCAT
                                 (
                                   '{ ',
                                     '"pResource": ',     Format_Resource
                                                          (
                                                             Resource_qwResource,
                                                             Resource_sName,
                                                             Resource_sReference
                                                          ),
                                  ' }'
                                 ),

                                 '{ }',

                                 '{ }';

                             SET bError = IF (ROW_COUNT () = 1, 0, 1);
                 END IF ;
        END IF ;
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                   MVD_RP1_Map : call_RMTObject_Event_RMPObject_Close.sql                                   ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2023 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE call_RMTObject_Event_RMPObject_Close
(
   IN    twRMTObjectIx                 BIGINT,
   IN    twRMPObjectIx_Close           BIGINT,
   OUT   bError                        INT,
   IN    bReparent                     TINYINT UNSIGNED
)
BEGIN
       DECLARE SBO_CLASS_RMTOBJECT                        INT DEFAULT 72;
       DECLARE SBO_CLASS_RMPOBJECT                        INT DEFAULT 73;
       DECLARE SBA_SUBSCRIBE_REFRESH_EVENT_EX_FLAG_CLOSE  INT DEFAULT 0x02;

       DECLARE twEventIz BIGINT;

          CALL call_RMTObject_Event (twRMTObjectIx, twEventIz, bError);
            IF bError = 0
          THEN
                     IF bReparent = 0
                   THEN
                          DELETE FROM RMPObject                                        -- we actually want to delete the entire tree - all the way down to the pobject!
                           WHERE ObjectHead_Self_twObjectIx = twRMPObjectIx_Close;
         
                             SET bError = IF (ROW_COUNT () = 1, 0, 1);
                 END IF ;

                     IF bError = 0
                   THEN
                          INSERT INTO Event
                                 (sType, Self_wClass, Self_twObjectIx, Child_wClass, Child_twObjectIx, wFlags, twEventIz, sJSON_Object, sJSON_Child, sJSON_Change)
                          SELECT 'RMPOBJECT_CLOSE',

                                 SBO_CLASS_RMTOBJECT,
                                 twRMTObjectIx,
                                 SBO_CLASS_RMPOBJECT,
                                 twRMPObjectIx_Close,
                                 SBA_SUBSCRIBE_REFRESH_EVENT_EX_FLAG_CLOSE,
                                 twEventIz,

                                 '{ }',

                                 '{ }',

                                 '{ }';

                             SET bError = IF (ROW_COUNT () = 1, 0, 1);
                 END IF ;
        END IF ;
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                    MVD_RP1_Map : call_RMTObject_Event_RMPObject_Open.sql                                   ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2023 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE call_RMTObject_Event_RMPObject_Open
(
   IN    twRMTObjectIx                 BIGINT,
   IN    Name_wsRMPObjectId            VARCHAR (48),
   IN    Type_bType                    TINYINT UNSIGNED,
   IN    Type_bSubtype                 TINYINT UNSIGNED,
   IN    Type_bFiction                 TINYINT UNSIGNED,
   IN    Type_bMovable                 TINYINT UNSIGNED,
   IN    Owner_twRPersonaIx            BIGINT,
   IN    Resource_qwResource           BIGINT,
   IN    Resource_sName                VARCHAR (48),
   IN    Resource_sReference           VARCHAR (128),
   IN    Transform_Position_dX         DOUBLE,
   IN    Transform_Position_dY         DOUBLE,
   IN    Transform_Position_dZ         DOUBLE,
   IN    Transform_Rotation_dX         DOUBLE,
   IN    Transform_Rotation_dY         DOUBLE,
   IN    Transform_Rotation_dZ         DOUBLE,
   IN    Transform_Rotation_dW         DOUBLE,
   IN    Transform_Scale_dX            DOUBLE,
   IN    Transform_Scale_dY            DOUBLE,
   IN    Transform_Scale_dZ            DOUBLE,
   IN    Bound_dX                      DOUBLE,
   IN    Bound_dY                      DOUBLE,
   IN    Bound_dZ                      DOUBLE,
   OUT   twRMPObjectIx_Open            BIGINT,
   OUT   bError                        INT,
   IN    bReparent                     TINYINT UNSIGNED
)
BEGIN
       DECLARE SBO_CLASS_RMTOBJECT                        INT DEFAULT 72;
       DECLARE SBO_CLASS_RMPOBJECT                        INT DEFAULT 73;
       DECLARE SBA_SUBSCRIBE_REFRESH_EVENT_EX_FLAG_OPEN   INT DEFAULT 0x01;

       DECLARE twEventIz BIGINT;

          CALL call_RMTObject_Event (twRMTObjectIx, twEventIz, bError);
            IF bError = 0
          THEN
                     IF bReparent = 0
                   THEN
                          INSERT INTO RMPObject
                                 (ObjectHead_Parent_wClass, ObjectHead_Parent_twObjectIx, ObjectHead_Self_wClass, ObjectHead_twEventIz, ObjectHead_wFlags, Name_wsRMPObjectId, Type_bType, Type_bSubtype, Type_bFiction, Type_bMovable, Owner_twRPersonaIx, Resource_qwResource, Resource_sName, Resource_sReference, Transform_Position_dX, Transform_Position_dY, Transform_Position_dZ, Transform_Rotation_dX, Transform_Rotation_dY, Transform_Rotation_dZ, Transform_Rotation_dW, Transform_Scale_dX, Transform_Scale_dY, Transform_Scale_dZ, Bound_dX, Bound_dY, Bound_dZ)
                          VALUES (SBO_CLASS_RMTOBJECT,      twRMTObjectIx,                SBO_CLASS_RMPOBJECT,    0,                    32,                Name_wsRMPObjectId, Type_bType, Type_bSubtype, Type_bFiction, Type_bMovable, Owner_twRPersonaIx, Resource_qwResource, Resource_sName, Resource_sReference, Transform_Position_dX, Transform_Position_dY, Transform_Position_dZ, Transform_Rotation_dX, Transform_Rotation_dY, Transform_Rotation_dZ, Transform_Rotation_dW, Transform_Scale_dX, Transform_Scale_dY, Transform_Scale_dZ, Bound_dX, Bound_dY, Bound_dZ);
         
                             SET bError = IF (ROW_COUNT () = 1, 0, 1);

                             SET twRMPObjectIx_Open = LAST_INSERT_ID ();
                 END IF ;

                     IF bError = 0
                   THEN
                          INSERT INTO Event
                                 (sType, Self_wClass, Self_twObjectIx, Child_wClass, Child_twObjectIx, wFlags, twEventIz, sJSON_Object, sJSON_Child, sJSON_Change)
                          SELECT 'RMPOBJECT_OPEN',

                                 SBO_CLASS_RMTOBJECT,
                                 twRMTObjectIx,
                                 SBO_CLASS_RMPOBJECT,
                                 twRMPObjectIx_Open,
                                 SBA_SUBSCRIBE_REFRESH_EVENT_EX_FLAG_OPEN,
                                 twEventIz,

                                 '{ }',

                                 CONCAT
                                 (
                                   '{ ',
                                     '"pName": ',         Format_Name_P
                                                          (
                                                             Name_wsRMPObjectId
                                                          ),
                                   ', "pType": ',         Format_Type_P
                                                          (
                                                             Type_bType,
                                                             Type_bSubtype,
                                                             Type_bFiction,
                                                             Type_bMovable
                                                          ),
                                   ', "pOwner": ',        Format_Owner
                                                          (
                                                             Owner_twRPersonaIx
                                                          ),
                                   ', "pResource": ',     Format_Resource
                                                          (
                                                             Resource_qwResource,
                                                             Resource_sName,
                                                             Resource_sReference
                                                          ),
                                   ', "pTransform": ',    Format_Transform
                                                          (
                                                             Transform_Position_dX,
                                                             Transform_Position_dY,
                                                             Transform_Position_dZ,
                                                             Transform_Rotation_dX,
                                                             Transform_Rotation_dY,
                                                             Transform_Rotation_dZ,
                                                             Transform_Rotation_dW,
                                                             Transform_Scale_dX,
                                                             Transform_Scale_dY,
                                                             Transform_Scale_dZ
                                                          ),
                                   ', "pBound": ',        Format_Bound
                                                          (
                                                             Bound_dX,
                                                             Bound_dY,
                                                             Bound_dZ
                                                          ),
                                  ' }'
                                 ),

                                 '{ }';

                             SET bError = IF (ROW_COUNT () = 1, 0, 1);
                  END IF ;
        END IF ;
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                   MVD_RP1_Map : call_RMTObject_Event_RMTObject_Close.sql                                   ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2023 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE call_RMTObject_Event_RMTObject_Close
(
   IN    twRMTObjectIx                 BIGINT,
   IN    twRMTObjectIx_Close           BIGINT,
   OUT   bError                        INT
)
BEGIN
       DECLARE SBO_CLASS_RMTOBJECT                        INT DEFAULT 72;
       DECLARE SBA_SUBSCRIBE_REFRESH_EVENT_EX_FLAG_CLOSE  INT DEFAULT 0x02;

       DECLARE twEventIz BIGINT;

       DECLARE nCount    INT DEFAULT 0;

          CALL call_RMTObject_Event (twRMTObjectIx, twEventIz, bError);
            IF bError = 0
          THEN
                 DELETE FROM RMTMatrix                                        -- we actually want to delete the entire tree - all the way down to the pobject!
                  WHERE bnMatrix =     twRMTObjectIx_Close
                     OR bnMatrix = 0 - twRMTObjectIx_Close;

                    SET nCount = nCount + ROW_COUNT (); -- 2

                 DELETE FROM RMTSubsurface                                    -- we actually want to delete the entire tree - all the way down to the pobject!
                  WHERE twRMTObjectIx = twRMTObjectIx_Close;

                    SET nCount = nCount + ROW_COUNT (); -- 1

                 DELETE FROM RMTObject                                        -- we actually want to delete the entire tree - all the way down to the pobject!
                  WHERE ObjectHead_Self_twObjectIx = twRMTObjectIx_Close;

                    SET nCount = nCount + ROW_COUNT (); -- 1

                    SET bError = IF (nCount = 4, 0, 1); -- this will only return the error of the last delete statement

                     IF bError = 0
                   THEN
                          INSERT INTO Event
                                 (sType, Self_wClass, Self_twObjectIx, Child_wClass, Child_twObjectIx, wFlags, twEventIz, sJSON_Object, sJSON_Child, sJSON_Change)
                          SELECT 'RMTOBJECT_CLOSE',

                                 SBO_CLASS_RMTOBJECT,
                                 twRMTObjectIx,
                                 SBO_CLASS_RMTOBJECT,
                                 twRMTObjectIx_Close,
                                 SBA_SUBSCRIBE_REFRESH_EVENT_EX_FLAG_CLOSE,
                                 twEventIz,

                                 '{ }',

                                 '{ }',

                                 '{ }';

                             SET bError = IF (ROW_COUNT () = 1, 0, 1);
                 END IF ;
        END IF ;
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                    MVD_RP1_Map : call_RMTObject_Event_RMTObject_Open.sql                                   ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2023 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE call_RMTObject_Event_RMTObject_Open
(
   IN    twRMTObjectIx                 BIGINT,
   IN    Name_wsRMTObjectId            VARCHAR (48),
   IN    Type_bType                    TINYINT UNSIGNED,
   IN    Type_bSubtype                 TINYINT UNSIGNED,
   IN    Type_bFiction                 TINYINT UNSIGNED,
   IN    Owner_twRPersonaIx            BIGINT,
   IN    Resource_qwResource           BIGINT,
   IN    Resource_sName                VARCHAR (48),
   IN    Resource_sReference           VARCHAR (128),
   IN    Transform_Position_dX         DOUBLE,
   IN    Transform_Position_dY         DOUBLE,
   IN    Transform_Position_dZ         DOUBLE,
   IN    Transform_Rotation_dX         DOUBLE,
   IN    Transform_Rotation_dY         DOUBLE,
   IN    Transform_Rotation_dZ         DOUBLE,
   IN    Transform_Rotation_dW         DOUBLE,
   IN    Transform_Scale_dX            DOUBLE,
   IN    Transform_Scale_dY            DOUBLE,
   IN    Transform_Scale_dZ            DOUBLE,
   IN    Bound_dX                      DOUBLE,
   IN    Bound_dY                      DOUBLE,
   IN    Bound_dZ                      DOUBLE,
   IN    Properties_bLockToGround      TINYINT UNSIGNED,
   IN    Properties_bYouth             TINYINT UNSIGNED,
   IN    Properties_bAdult             TINYINT UNSIGNED,
   IN    Properties_bAvatar            TINYINT UNSIGNED,
   OUT   twRMTObjectIx_Open            BIGINT,
   OUT   bError                        INT
)
BEGIN
       DECLARE SBO_CLASS_RMTOBJECT                        INT DEFAULT 72;
       DECLARE SBA_SUBSCRIBE_REFRESH_EVENT_EX_FLAG_OPEN   INT DEFAULT 0x01;

       DECLARE twEventIz BIGINT;

          CALL call_RMTObject_Event (twRMTObjectIx, twEventIz, bError);
            IF bError = 0
          THEN
                 INSERT INTO RMTObject
                        (ObjectHead_Parent_wClass, ObjectHead_Parent_twObjectIx, ObjectHead_Self_wClass, ObjectHead_twEventIz, ObjectHead_wFlags, Name_wsRMTObjectId, Type_bType, Type_bSubtype, Type_bFiction, Owner_twRPersonaIx, Resource_qwResource, Resource_sName, Resource_sReference, Transform_Position_dX, Transform_Position_dY, Transform_Position_dZ, Transform_Rotation_dX, Transform_Rotation_dY, Transform_Rotation_dZ, Transform_Rotation_dW, Transform_Scale_dX, Transform_Scale_dY, Transform_Scale_dZ, Bound_dX, Bound_dY, Bound_dZ, Properties_bLockToGround, Properties_bYouth, Properties_bAdult, Properties_bAvatar)
                 VALUES (SBO_CLASS_RMTOBJECT,      twRMTObjectIx,                SBO_CLASS_RMTOBJECT,    0,                    32,                Name_wsRMTObjectId, Type_bType, Type_bSubtype, Type_bFiction, Owner_twRPersonaIx, Resource_qwResource, Resource_sName, Resource_sReference, Transform_Position_dX, Transform_Position_dY, Transform_Position_dZ, Transform_Rotation_dX, Transform_Rotation_dY, Transform_Rotation_dZ, Transform_Rotation_dW, Transform_Scale_dX, Transform_Scale_dY, Transform_Scale_dZ, Bound_dX, Bound_dY, Bound_dZ, Properties_bLockToGround, Properties_bYouth, Properties_bAdult, Properties_bAvatar);

                    SET bError = IF (ROW_COUNT () = 1, 0, 1);

                     IF bError = 0
                   THEN
                             SET twRMTObjectIx_Open = LAST_INSERT_ID ();

                          INSERT INTO Event
                                 (sType, Self_wClass, Self_twObjectIx, Child_wClass, Child_twObjectIx, wFlags, twEventIz, sJSON_Object, sJSON_Child, sJSON_Change)
                          SELECT 'RMTOBJECT_OPEN',

                                 SBO_CLASS_RMTOBJECT,
                                 twRMTObjectIx,
                                 SBO_CLASS_RMTOBJECT,
                                 twRMTObjectIx_Open,
                                 SBA_SUBSCRIBE_REFRESH_EVENT_EX_FLAG_OPEN,
                                 twEventIz,

                                 '{ }',

                                 CONCAT
                                 (
                                   '{ ',
                                     '"pName": ',         Format_Name_T
                                                          (
                                                             Name_wsRMTObjectId
                                                          ),
                                   ', "pType": ',         Format_Type_T
                                                          (
                                                             Type_bType,
                                                             Type_bSubtype,
                                                             Type_bFiction
                                                          ),
                                   ', "pOwner": ',        Format_Owner
                                                          (
                                                             Owner_twRPersonaIx
                                                          ),
                                   ', "pResource": ',     Format_Resource
                                                          (
                                                             Resource_qwResource,
                                                             Resource_sName,
                                                             Resource_sReference
                                                          ),
                                   ', "pTransform": ',    Format_Transform
                                                          (
                                                             Transform_Position_dX,
                                                             Transform_Position_dY,
                                                             Transform_Position_dZ,
                                                             Transform_Rotation_dX,
                                                             Transform_Rotation_dY,
                                                             Transform_Rotation_dZ,
                                                             Transform_Rotation_dW,
                                                             Transform_Scale_dX,
                                                             Transform_Scale_dY,
                                                             Transform_Scale_dZ
                                                          ),
                                   ', "pBound": ',        Format_Bound
                                                          (
                                                             Bound_dX,
                                                             Bound_dY,
                                                             Bound_dZ
                                                          ),
                                   ', "pProperties": ',   Format_Properties_T
                                                          (
                                                             Properties_bLockToGround,
                                                             Properties_bYouth,
                                                             Properties_bAdult,
                                                             Properties_bAvatar
                                                          ),
                                  ' }'
                                 ),

                                 '{ }';

                             SET bError = IF (ROW_COUNT () = 1, 0, 1);
                 END IF ;
        END IF ;
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                      MVD_RP1_Map : call_RMTObject_Event_Transform.sql                                      ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2023 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE call_RMTObject_Event_Transform
(
   IN    twRMTObjectIx                 BIGINT,
   IN    Transform_Position_dX         DOUBLE,
   IN    Transform_Position_dY         DOUBLE,
   IN    Transform_Position_dZ         DOUBLE,
   IN    Transform_Rotation_dX         DOUBLE,
   IN    Transform_Rotation_dY         DOUBLE,
   IN    Transform_Rotation_dZ         DOUBLE,
   IN    Transform_Rotation_dW         DOUBLE,
   IN    Transform_Scale_dX            DOUBLE,
   IN    Transform_Scale_dY            DOUBLE,
   IN    Transform_Scale_dZ            DOUBLE,
   OUT   bError                        INT
)
BEGIN
       DECLARE SBO_CLASS_NULL                             INT DEFAULT 0;
       DECLARE SBO_CLASS_RMTOBJECT                        INT DEFAULT 72;

       DECLARE twEventIz BIGINT;

          CALL call_RMTObject_Event (twRMTObjectIx, twEventIz, bError);
            IF bError = 0
          THEN
                 UPDATE RMTObject
                    SET Transform_Position_dX = Transform_Position_dX,
                        Transform_Position_dY = Transform_Position_dY,
                        Transform_Position_dZ = Transform_Position_dZ,
                        Transform_Rotation_dX = Transform_Rotation_dX,
                        Transform_Rotation_dY = Transform_Rotation_dY,
                        Transform_Rotation_dZ = Transform_Rotation_dZ,
                        Transform_Rotation_dW = Transform_Rotation_dW,
                        Transform_Scale_dX    = Transform_Scale_dX,
                        Transform_Scale_dY    = Transform_Scale_dY,
                        Transform_Scale_dZ    = Transform_Scale_dZ
                  WHERE ObjectHead_Self_twObjectIx = twRMTObjectIx;

                    SET bError = IF (ROW_COUNT () = 1, 0, 1);

                     IF bError = 0
                   THEN
                          INSERT INTO Event
                                 (sType, Self_wClass, Self_twObjectIx, Child_wClass, Child_twObjectIx, wFlags, twEventIz, sJSON_Object, sJSON_Child, sJSON_Change)
                          SELECT 'TRANSFORM',

                                 SBO_CLASS_RMTOBJECT,
                                 twRMTObjectIx,
                                 SBO_CLASS_NULL,
                                 0,
                                 0,
                                 twEventIz,

                                 CONCAT
                                 (
                                   '{ ',
                                     '"pTransform": ',    Format_Transform
                                                          (
                                                             Transform_Position_dX,
                                                             Transform_Position_dY,
                                                             Transform_Position_dZ,
                                                             Transform_Rotation_dX,
                                                             Transform_Rotation_dY,
                                                             Transform_Rotation_dZ,
                                                             Transform_Rotation_dW,
                                                             Transform_Scale_dX,
                                                             Transform_Scale_dY,
                                                             Transform_Scale_dZ
                                                          ),
                                  ' }'
                                 ),

                                 '{ }',

                                 '{ }';

                             SET bError = IF (ROW_COUNT () = 1, 0, 1);
                 END IF ;
        END IF ;
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                         MVD_RP1_Map : call_RMTObject_Event_Type.sql                                        ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2023 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE call_RMTObject_Event_Type
(
   IN    twRMTObjectIx                 BIGINT,
   IN    Type_bType                    TINYINT UNSIGNED,
   IN    Type_bSubtype                 TINYINT UNSIGNED,
   IN    Type_bFiction                 TINYINT UNSIGNED,
   OUT   bError                        INT
)
BEGIN
       DECLARE SBO_CLASS_NULL                             INT DEFAULT 0;
       DECLARE SBO_CLASS_RMTOBJECT                        INT DEFAULT 72;

       DECLARE twEventIz BIGINT;

          CALL call_RMTObject_Event (twRMTObjectIx, twEventIz, bError);
            IF bError = 0
          THEN
                 UPDATE RMTObject
                    SET Type_bType    = Type_bType,
                        Type_bSubtype = Type_bSubtype,
                        Type_bFiction = Type_bFiction
                  WHERE ObjectHead_Self_twObjectIx = twRMTObjectIx;

                    SET bError = IF (ROW_COUNT () = 1, 0, 1);

                     IF bError = 0
                   THEN
                          INSERT INTO Event
                                 (sType, Self_wClass, Self_twObjectIx, Child_wClass, Child_twObjectIx, wFlags, twEventIz, sJSON_Object, sJSON_Child, sJSON_Change)
                          SELECT 'TYPE',

                                 SBO_CLASS_RMTOBJECT,
                                 twRMTObjectIx,
                                 SBO_CLASS_NULL,
                                 0,
                                 0,
                                 twEventIz,

                                 CONCAT
                                 (
                                   '{ ',
                                     '"pType": ',         Format_Type_T
                                                          (
                                                             Type_bType,
                                                             Type_bSubtype,
                                                             Type_bFiction
                                                          ),
                                  ' }'
                                 ),

                                 '{ }',

                                 '{ }';
                                                                                                                                                                                                                                                     
                             SET bError = IF (ROW_COUNT () = 1, 0, 1);
                 END IF ;
        END IF ;
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                            MVD_RP1_Map : call_RMTObject_Log.sql                                            ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2025 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE call_RMTObject_Log
(
   IN    bOp                           TINYINT UNSIGNED,
   IN    sIPAddress                    VARCHAR (16),
   IN    twRPersonaIx                  BIGINT,
   IN    twRMTObjectIx                 BIGINT,
   OUT   bError                        INT
)
BEGIN
       DECLARE dwIPAddress BINARY (4) DEFAULT IPstob (sIPAddress);

        INSERT INTO RMTObjectLog
               (bOp, dwIPAddress, twRPersonaIx, twRMTObjectIx)
        VALUES (bOp, dwIPAddress, twRPersonaIx, twRMTObjectIx);
 
           SET bError = IF (ROW_COUNT () = 1, 0, 1);
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                           MVD_RP1_Map : call_RMTObject_Select.sql                                          ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2023 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

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
                    '"pObjectHead": ',   Format_ObjectHead
                                         (
                                            t.ObjectHead_Parent_wClass,
                                            t.ObjectHead_Parent_twObjectIx,
                                            t.ObjectHead_Self_wClass,
                                            t.ObjectHead_Self_twObjectIx,
                                            IF (nResultSet = 0, OBJECTHEAD_FLAG_SUBSCRIBE_FULL, OBJECTHEAD_FLAG_SUBSCRIBE_PARTIAL),
                                            t.ObjectHead_twEventIz
                                         ),

                  ', "twRMTObjectIx": ', t.ObjectHead_Self_twObjectIx,      -- is this necessary

                  ', "pName": ',         Format_Name_T
                                         (
                                            t.Name_wsRMTObjectId
                                         ),
                  ', "pType": ',         Format_Type_T
                                         (
                                            t.Type_bType,
                                            t.Type_bSubtype,
                                            t.Type_bFiction
                                         ),
                  ', "pOwner": ',        Format_Owner
                                         (
                                            t.Owner_twRPersonaIx
                                         ),
                  ', "pResource": ',     Format_Resource
                                         (
                                            t.Resource_qwResource,
                                            t.Resource_sName,
                                            t.Resource_sReference
                                         ),
                  ', "pTransform": ',    Format_Transform
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
                  ', "pBound": ',        Format_Bound
                                         (
                                            t.Bound_dX,
                                            t.Bound_dY,
                                            t.Bound_dZ
                                         ),
                  ', "pProperties": ',   Format_Properties_T
                                         (
                                            t.Properties_bLockToGround,
                                            t.Properties_bYouth,
                                            t.Properties_bAdult,
                                            t.Properties_bAvatar
                                         ),

                  ', "nChildren":  ',    IFNULL (cat.nCount, 0) + IFNULL (cap.nCount, 0),
                 ' }'               
               ) AS `Object`
          FROM Results   AS x
          JOIN RMTObject AS t on t.ObjectHead_Self_twObjectIx = x.ObjectHead_Self_twObjectIx
     LEFT JOIN (SELECT ObjectHead_Parent_twObjectIx, COUNT(*) AS nCount FROM RMTObject WHERE ObjectHead_Parent_wClass = SBO_CLASS_RMTOBJECT GROUP BY ObjectHead_Parent_twObjectIx) AS cat ON cat.ObjectHead_Parent_twObjectIx = t.ObjectHead_Self_twObjectIx
     LEFT JOIN (SELECT ObjectHead_Parent_twObjectIx, COUNT(*) AS nCount FROM RMPObject WHERE ObjectHead_Parent_wClass = SBO_CLASS_RMTOBJECT GROUP BY ObjectHead_Parent_twObjectIx) AS cap ON cap.ObjectHead_Parent_twObjectIx = t.ObjectHead_Self_twObjectIx
         WHERE x.nResultSet = nResultSet;
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                          MVD_RP1_Map : call_RMTObject_Validate.sql                                         ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2023 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE call_RMTObject_Validate
(
   IN    twRPersonaIx                  BIGINT,
   IN    twRMTObjectIx                 BIGINT,
   OUT   ObjectHead_Parent_wClass      SMALLINT,
   OUT   ObjectHead_Parent_twObjectIx  BIGINT,
   INOUT nError                        INT
)
BEGIN
       DECLARE nCount INT;

        SELECT o.ObjectHead_Parent_wClass, o.ObjectHead_Parent_twObjectIx
          INTO   ObjectHead_Parent_wClass,   ObjectHead_Parent_twObjectIx
          FROM RMTObject AS o
         WHERE o.ObjectHead_Self_twObjectIx = twRMTObjectIx;

           SET nCount = ROW_COUNT ();

            IF twRPersonaIx <= 0
          THEN
                   CALL call_Error (1, 'twRPersonaIx is invalid',  nError);
        ELSEIF twRMTObjectIx <= 0
          THEN
                   CALL call_Error (2, 'twRMTObjectIx is invalid', nError);
        ELSEIF nCount <> 1
          THEN
                   CALL call_Error (3, 'twRMTObjectIx is unknown', nError);
        ELSEIF twRPersonaIx <> twRPersonaIx
          THEN                                                                -- TBD
                   CALL call_Error (4, 'Invalid rights',           nError);
        END IF ;
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                       MVD_RP1_Map : call_RMTObject_Validate_Bound.sql                                      ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2023 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE call_RMTObject_Validate_Bound
(
   IN    ObjectHead_Parent_wClass      SMALLINT,
   IN    ObjectHead_Parent_twObjectIx  BIGINT,
   IN    twRMTObjectIx                 BIGINT,
   IN    Bound_dX                      DOUBLE,
   IN    Bound_dY                      DOUBLE,
   IN    Bound_dZ                      DOUBLE,
   INOUT nError                        INT
)
BEGIN
            IF Bound_dX IS NULL OR Bound_dX <> Bound_dX
          THEN
                   CALL call_Error (21, 'Bound_dX is NULL or NaN', nError);
        ELSEIF Bound_dX < 0
          THEN
                   CALL call_Error (21, 'Bound_dX is invalid',     nError);
        END IF ;

            IF Bound_dY IS NULL OR Bound_dY <> Bound_dY
          THEN
                   CALL call_Error (21, 'Bound_dY is NULL or NaN', nError);
        ELSEIF Bound_dY < 0
          THEN
                   CALL call_Error (21, 'Bound_dY is invalid',     nError);
        END IF ;

            IF Bound_dZ IS NULL OR Bound_dZ <> Bound_dZ
          THEN
                   CALL call_Error (21, 'Bound_dZ is NULL or NaN', nError);
        ELSEIF Bound_dZ < 0
          THEN
                   CALL call_Error (21, 'Bound_dZ is invalid',     nError);
        END IF ;

            IF nError = 0
          THEN
                     -- validate bound is inside  parent's   bound
                     -- validate bound is outside children's bound
                    SET nError = nError;
        END IF ;
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                     MVD_RP1_Map : call_RMTObject_Validate_Coord_Car.sql                                    ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2023 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE call_RMTObject_Validate_Coord_Car
(
   IN    ObjectHead_Parent_wClass      SMALLINT,
   IN    ObjectHead_Parent_twObjectIx  BIGINT,
   IN    twRMTObjectIx                 BIGINT,
   IN    dX                            DOUBLE,
   IN    dY                            DOUBLE,
   IN    dZ                            DOUBLE,
   INOUT nError                        INT
)
BEGIN
            IF dX IS NULL OR dX <> dX
          THEN
                   CALL call_Error (21, 'dX is NULL or NaN', nError);
        END IF ;

            IF dY IS NULL OR dY <> dY
          THEN
                   CALL call_Error (21, 'dY is NULL or NaN', nError);
        END IF ;

            IF dZ IS NULL OR dZ <> dZ
          THEN
                   CALL call_Error (21, 'dZ is NULL or NaN', nError);
        END IF ;

            IF nError = 0
          THEN
                     -- validate position is inside parent's bound
                    SET nError = nError;
        END IF ;
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                     MVD_RP1_Map : call_RMTObject_Validate_Coord_Cyl.sql                                    ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2023 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE call_RMTObject_Validate_Coord_Cyl
(
   IN    ObjectHead_Parent_wClass      SMALLINT,
   IN    ObjectHead_Parent_twObjectIx  BIGINT,
   IN    twRMTObjectIx                 BIGINT,
   IN    dTheta                        DOUBLE,
   IN    dY                            DOUBLE,
   IN    dRadius                       DOUBLE,
   INOUT nError                        INT
)
BEGIN
            IF dTheta IS NULL OR dTheta <> dTheta
          THEN
                   CALL call_Error (21, 'dTheta is NULL or NaN',  nError);
        ELSEIF dTheta NOT BETWEEN -180 AND 180
          THEN
                   CALL call_Error (21, 'dTheta is invalid',      nError);
        END IF ;

            IF dY IS NULL OR dY <> dY
          THEN
                   CALL call_Error (21, 'dY is NULL or NaN',      nError);
        END IF ;

            IF dRadius IS NULL OR dRadius <> dRadius
          THEN
                   CALL call_Error (21, 'dRadius is NULL or NaN', nError);
        ELSEIF dRadius = 0
          THEN
                   CALL call_Error (21, 'dRadius is invalid',     nError);
        END IF ;

            IF nError = 0
          THEN
                     -- validate position is inside parent's bound
                    SET nError = nError;
        END IF ;
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                     MVD_RP1_Map : call_RMTObject_Validate_Coord_Geo.sql                                    ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2023 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE call_RMTObject_Validate_Coord_Geo
(
   IN    ObjectHead_Parent_wClass      SMALLINT,
   IN    ObjectHead_Parent_twObjectIx  BIGINT,
   IN    twRMTObjectIx                 BIGINT,
   IN    dLatitude                     DOUBLE,
   IN    dLongitude                    DOUBLE,
   IN    dRadius                       DOUBLE,
   INOUT nError                        INT
)
BEGIN
            IF dLatitude IS NULL OR dLatitude <> dLatitude
          THEN
                   CALL call_Error (21, 'dLatitude is NULL or NaN',  nError);
        ELSEIF dLatitude NOT BETWEEN -180 AND 180
          THEN
                   CALL call_Error (21, 'dLatitude is invalid',      nError);
        END IF ;

            IF dLongitude IS NULL OR dLongitude <> dLongitude
          THEN
                   CALL call_Error (21, 'dLongitude is NULL or NaN', nError);
        ELSEIF dLongitude NOT BETWEEN -180 AND 180
          THEN
                   CALL call_Error (21, 'dLongitude is invalid',     nError);
        END IF ;

            IF dRadius IS NULL OR dRadius <> dRadius
          THEN
                   CALL call_Error (21, 'dRadius is NULL or NaN',    nError);
        ELSEIF dRadius = 0
          THEN
                   CALL call_Error (21, 'dRadius is invalid',        nError);
        END IF ;

            IF nError = 0
          THEN
                     -- validate position is inside parent's bound
                    SET nError = nError;
        END IF ;
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                     MVD_RP1_Map : call_RMTObject_Validate_Coord_Nul.sql                                    ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2023 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE call_RMTObject_Validate_Coord_Nul
(
   IN    ObjectHead_Parent_wClass      SMALLINT,
   IN    ObjectHead_Parent_twObjectIx  BIGINT,
   IN    twRMTObjectIx                 BIGINT,
   IN    Transform_Position_dX         DOUBLE,
   IN    Transform_Position_dY         DOUBLE,
   IN    Transform_Position_dZ         DOUBLE,
   IN    Transform_Rotation_dX         DOUBLE,
   IN    Transform_Rotation_dY         DOUBLE,
   IN    Transform_Rotation_dZ         DOUBLE,
   IN    Transform_Rotation_dW         DOUBLE,
   IN    Transform_Scale_dX            DOUBLE,
   IN    Transform_Scale_dY            DOUBLE,
   IN    Transform_Scale_dZ            DOUBLE,
   INOUT nError                        INT
)
BEGIN
            IF Transform_Position_dX IS NULL OR Transform_Position_dX <> Transform_Position_dX
          THEN
                   CALL call_Error (21, 'Transform_Position_dX is NULL or NaN', nError);
        END IF ;
            IF Transform_Position_dY IS NULL OR Transform_Position_dY <> Transform_Position_dY
          THEN
                   CALL call_Error (21, 'Transform_Position_dY is NULL or NaN', nError);
        END IF ;
            IF Transform_Position_dZ IS NULL OR Transform_Position_dZ <> Transform_Position_dZ
          THEN
                   CALL call_Error (21, 'Transform_Position_dZ is NULL or NaN', nError);
        END IF ;

            IF Transform_Rotation_dX IS NULL OR Transform_Rotation_dX <> Transform_Rotation_dX
          THEN
                   CALL call_Error (21, 'Transform_Rotation_dX is NULL or NaN', nError);
        END IF ;
            IF Transform_Rotation_dY IS NULL OR Transform_Rotation_dY <> Transform_Rotation_dY
          THEN
                   CALL call_Error (21, 'Transform_Rotation_dY is NULL or NaN', nError);
        END IF ;
            IF Transform_Rotation_dZ IS NULL OR Transform_Rotation_dZ <> Transform_Rotation_dZ
          THEN
                   CALL call_Error (21, 'Transform_Rotation_dZ is NULL or NaN', nError);
        END IF ;
            IF Transform_Rotation_dW IS NULL OR Transform_Rotation_dW <> Transform_Rotation_dW
          THEN
                   CALL call_Error (21, 'Transform_Rotation_dW is NULL or NaN', nError);
        END IF ;

            IF Transform_Scale_dX IS NULL OR Transform_Scale_dX <> Transform_Scale_dX
          THEN
                   CALL call_Error (21, 'Transform_Scale_dX is NULL or NaN',    nError);
        END IF ;
            IF Transform_Scale_dY IS NULL OR Transform_Scale_dY <> Transform_Scale_dY
          THEN
                   CALL call_Error (21, 'Transform_Scale_dY is NULL or NaN',    nError);
        END IF ;
            IF Transform_Scale_dZ IS NULL OR Transform_Scale_dZ <> Transform_Scale_dZ
          THEN
                      CALL call_Error (21, 'Transform_Scale_dZ is NULL or NaN',    nError);
        END IF ;

            IF nError = 0
          THEN
                     -- validate position is inside parent's bound
                    SET nError = nError;
        END IF ;
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                       MVD_RP1_Map : call_RMTObject_Validate_Name.sql                                       ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2023 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE call_RMTObject_Validate_Name
(
   IN    ObjectHead_Parent_wClass      SMALLINT,
   IN    ObjectHead_Parent_twObjectIx  BIGINT,
   IN    twRMTObjectIx                 BIGINT,
   IN    Name_wsRMTObjectId            VARCHAR (48),
   INOUT nError                        INT
)
BEGIN
            IF Name_wsRMTObjectId IS NULL
          THEN
                   CALL call_Error (21, 'Name_wsRMTObjectId is NULL', nError);
        END IF ;
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                       MVD_RP1_Map : call_RMTObject_Validate_Owner.sql                                      ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2023 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE call_RMTObject_Validate_Owner
(
   IN    ObjectHead_Parent_wClass      SMALLINT,
   IN    ObjectHead_Parent_twObjectIx  BIGINT,
   IN    twRMTObjectIx                 BIGINT,
   IN    Owner_twRPersonaIx            BIGINT,
   INOUT nError                        INT
)
BEGIN
            IF Owner_twRPersonaIx IS NULL
          THEN
                   CALL call_Error (21, 'Owner_twRPersonaIx is NULL',    nError);
        ELSEIF Owner_twRPersonaIx NOT BETWEEN 1 AND 0x0000FFFFFFFFFFFC
          THEN
                   CALL call_Error (21, 'Owner_twRPersonaIx is invalid', nError);
        END IF ;
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                    MVD_RP1_Map : call_RMTObject_Validate_Properties.sql                                    ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2023 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE call_RMTObject_Validate_Properties
(
   IN    ObjectHead_Parent_wClass      SMALLINT,
   IN    ObjectHead_Parent_twObjectIx  BIGINT,
   IN    twRMTObjectIx                 BIGINT,
   IN    Properties_bLockToGround      TINYINT UNSIGNED,
   IN    Properties_bYouth             TINYINT UNSIGNED,
   IN    Properties_bAdult             TINYINT UNSIGNED,
   IN    Properties_bAvatar            TINYINT UNSIGNED,
   INOUT nError                        INT
)
BEGIN
            IF Properties_bLockToGround IS NULL
          THEN
                   CALL call_Error (21, 'Properties_bLockToGround is NULL',    nError);
        ELSEIF Properties_bLockToGround NOT BETWEEN 0 AND 1
          THEN
                   CALL call_Error (21, 'Properties_bLockToGround is invalid', nError);
        END IF ;

            IF Properties_bYouth IS NULL
          THEN
                   CALL call_Error (21, 'Properties_bYouth is NULL',           nError);
        ELSEIF Properties_bYouth NOT BETWEEN 0 AND 1
          THEN
                   CALL call_Error (21, 'Properties_bYouth is invalid',        nError);
        END IF ;

            IF Properties_bAdult IS NULL
          THEN
                   CALL call_Error (21, 'Properties_bAdult is NULL',           nError);
        ELSEIF Properties_bAdult NOT BETWEEN 0 AND 1
          THEN
                   CALL call_Error (21, 'Properties_bAdult is invalid',        nError);
        END IF ;

            IF Properties_bAvatar IS NULL
          THEN
                   CALL call_Error (21, 'Properties_bAvatar is NULL',          nError);
        ELSEIF Properties_bAvatar NOT BETWEEN 0 AND 1
          THEN
                   CALL call_Error (21, 'Properties_bAvatar is invalid',       nError);
        END IF ;
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                     MVD_RP1_Map : call_RMTObject_Validate_Resource.sql                                     ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2023 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE call_RMTObject_Validate_Resource
(
   IN    ObjectHead_Parent_wClass      SMALLINT,
   IN    ObjectHead_Parent_twObjectIx  BIGINT,
   IN    twRMTObjectIx                 BIGINT,
   IN    Resource_qwResource           BIGINT,
   IN    Resource_sName                VARCHAR (48),
   IN    Resource_sReference           VARCHAR (128),
   INOUT nError                        INT
)
BEGIN
            IF Resource_qwResource IS NULL
          THEN
                   CALL call_Error (21, 'Resource_qwResource is NULL', nError);
        END IF ;
            IF Resource_sName IS NULL
          THEN
                   CALL call_Error (21, 'Resource_sName is NULL',      nError);
        END IF ;
            IF Resource_sReference IS NULL
          THEN
                   CALL call_Error (21, 'Resource_sReference is NULL', nError);
        END IF ;

            -- do we want to check sName and sReference for length or invalid characters
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                     MVD_RP1_Map : call_RMTObject_Validate_Transform.sql                                    ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2023 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE call_RMTObject_Validate_Transform
(
   IN    ObjectHead_Parent_wClass      SMALLINT,
   IN    ObjectHead_Parent_twObjectIx  BIGINT,
   IN    twRMTObjectIx                 BIGINT,
   IN    Transform_Position_dX         DOUBLE,
   IN    Transform_Position_dY         DOUBLE,
   IN    Transform_Position_dZ         DOUBLE,
   IN    Transform_Rotation_dX         DOUBLE,
   IN    Transform_Rotation_dY         DOUBLE,
   IN    Transform_Rotation_dZ         DOUBLE,
   IN    Transform_Rotation_dW         DOUBLE,
   IN    Transform_Scale_dX            DOUBLE,
   IN    Transform_Scale_dY            DOUBLE,
   IN    Transform_Scale_dZ            DOUBLE,
   INOUT nError                        INT
)
BEGIN
            IF Transform_Position_dX IS NULL OR Transform_Position_dX <> Transform_Position_dX
          THEN
                   CALL call_Error (21, 'Transform_Position_dX is NULL or NaN', nError);
        END IF ;
            IF Transform_Position_dY IS NULL OR Transform_Position_dY <> Transform_Position_dY
          THEN
                   CALL call_Error (21, 'Transform_Position_dY is NULL or NaN', nError);
        END IF ;
            IF Transform_Position_dZ IS NULL OR Transform_Position_dZ <> Transform_Position_dZ
          THEN
                   CALL call_Error (21, 'Transform_Position_dZ is NULL or NaN', nError);
        END IF ;

            IF Transform_Rotation_dX IS NULL OR Transform_Rotation_dX <> Transform_Rotation_dX
          THEN
                   CALL call_Error (21, 'Transform_Rotation_dX is NULL or NaN', nError);
        END IF ;
            IF Transform_Rotation_dY IS NULL OR Transform_Rotation_dY <> Transform_Rotation_dY
          THEN
                   CALL call_Error (21, 'Transform_Rotation_dY is NULL or NaN', nError);
        END IF ;
            IF Transform_Rotation_dZ IS NULL OR Transform_Rotation_dZ <> Transform_Rotation_dZ
          THEN
                   CALL call_Error (21, 'Transform_Rotation_dZ is NULL or NaN', nError);
        END IF ;
            IF Transform_Rotation_dW IS NULL OR Transform_Rotation_dW <> Transform_Rotation_dW
          THEN
                   CALL call_Error (21, 'Transform_Rotation_dW is NULL or NaN', nError);
        END IF ;

            IF Transform_Scale_dX IS NULL OR Transform_Scale_dX <> Transform_Scale_dX
          THEN
                   CALL call_Error (21, 'Transform_Scale_dX is NULL or NaN',    nError);
        END IF ;
            IF Transform_Scale_dY IS NULL OR Transform_Scale_dY <> Transform_Scale_dY
          THEN
                   CALL call_Error (21, 'Transform_Scale_dY is NULL or NaN',    nError);
        END IF ;
            IF Transform_Scale_dZ IS NULL OR Transform_Scale_dZ <> Transform_Scale_dZ
          THEN
                   CALL call_Error (21, 'Transform_Scale_dZ is NULL or NaN',    nError);
        END IF ;

            IF nError = 0
          THEN
                     -- validate position is inside parent's bound
                    SET nError = nError;
        END IF ;
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                       MVD_RP1_Map : call_RMTObject_Validate_Type.sql                                       ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2023 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE call_RMTObject_Validate_Type
(
   IN    ObjectHead_Parent_wClass      SMALLINT,
   IN    ObjectHead_Parent_twObjectIx  BIGINT,
   IN    twRMTObjectIx                 BIGINT,
   IN    Type_bType                    TINYINT UNSIGNED,
   IN    Type_bSubtype                 TINYINT UNSIGNED,
   IN    Type_bFiction                 TINYINT UNSIGNED,
   INOUT nError                        INT
)
BEGIN
       DECLARE SBO_CLASS_RMCOBJECT                        INT DEFAULT 71;
       DECLARE SBO_CLASS_RMTOBJECT                        INT DEFAULT 72;
       DECLARE MVO_RMCOBJECT_TYPE_SURFACE                 INT DEFAULT 17;

       DECLARE Parent_bType    TINYINT UNSIGNED;
       DECLARE Parent_bSubtype TINYINT UNSIGNED;
       DECLARE Self_bType      TINYINT UNSIGNED;
       DECLARE Self_bSubtype   TINYINT UNSIGNED;

            IF ObjectHead_Parent_wClass = SBO_CLASS_RMTOBJECT
          THEN
                 SELECT o.Type_bType, o.Type_bSubtype
                   INTO Parent_bType, Parent_bSubtype
                   FROM RMTObject AS o
                  WHERE o.ObjectHead_Self_twObjectIx = ObjectHead_Parent_twObjectIx;
        END IF ;

            IF twRMTObjectIx > 0
          THEN
                 SELECT o.Type_bType, o.Type_bSubtype
                   INTO   Self_bType,   Self_bSubtype
                   FROM RMTObject AS o
                  WHERE o.ObjectHead_Self_twObjectIx = twRMTObjectIx;
-- get max children's type and subtype

        END IF ;

-- attachment points can't have cildren

            IF Type_bType IS NULL
          THEN
                   CALL call_Error (21, 'Type_bType is NULL',       nError);
        END IF ;

            IF Type_bSubtype IS NULL
          THEN
                   CALL call_Error (21, 'Type_bSubtype is NULL',    nError);
        END IF ;

            IF Type_bFiction IS NULL
          THEN
                   CALL call_Error (21, 'Type_bFiction is NULL',    nError);
        ELSEIF Type_bFiction NOT BETWEEN 0 AND 1
          THEN
                   CALL call_Error (21, 'Type_bFiction is invalid', nError);
        END IF ;

            IF ObjectHead_Parent_wClass = SBO_CLASS_RMCOBJECT  AND  Parent_bType <> MVO_RMCOBJECT_TYPE_SURFACE
          THEN
                   CALL call_Error (21, 'Parent\'s Type_bType must be equal to SURFACE when its parent\'s class is RMCOBJECT', nError);
        ELSEIF ObjectHead_Parent_wClass = SBO_CLASS_RMTOBJECT AND Type_bType < Parent_bType
          THEN
                   CALL call_Error (21, 'Type_bType must be greater than or equal to its parent\'s Type_bType', nError);
        ELSEIF ObjectHead_Parent_wClass = SBO_CLASS_RMTOBJECT AND Type_bType = Parent_bType AND Type_bSubtype <= Parent_bSubtype
          THEN
                   CALL call_Error (21, 'Type_bSubtype must be greater than its parent\'s Type_bType', nError);
        END IF ;
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                           MVD_RP1_Map : get_RMTObject_Update.sql                                           ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2025 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

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

       DECLARE bType TINYINT UNSIGNED;

            -- Create the temp Error table
        CREATE TEMPORARY TABLE Error
               (
                  nOrder                        INT             NOT NULL AUTO_INCREMENT PRIMARY KEY,
                  dwError                       INT             NOT NULL,
                  sError                        VARCHAR (255)   NOT NULL
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

                     IF ROW_COUNT () = 1  AND  bType IS NOT NULL
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

          DROP TEMPORARY TABLE Error;
          DROP TEMPORARY TABLE Results;

           SET nResult = bCommit - 1 - nError;

END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                             MVD_RP1_Map : search_RMTObject.sql                                             ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2023 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE search_RMTObject
(
   IN    sIPAddress                    VARCHAR (16),
   IN    twRPersonaIx                  BIGINT,
   IN    twRMTObjectIx                 BIGINT,
   IN    dX                            DOUBLE,
   IN    dY                            DOUBLE,
   IN    dZ                            DOUBLE,
   IN    sText                         VARCHAR (48)
)
BEGIN
       DECLARE MVO_RMTOBJECT_TYPE_COMMUNITY              INT DEFAULT 9;

       DECLARE bError  INT;
       DECLARE bCommit INT DEFAULT 0;
       DECLARE nError  INT;

       DECLARE bType   TINYINT UNSIGNED;
       DECLARE dRange  DOUBLE;
       DECLARE nCount  INT DEFAULT 0;

       DECLARE dRadius DOUBLE DEFAULT 6371000; -- where do we get this?
       DECLARE dNormal DOUBLE DEFAULT dRadius / SQRT ((dX * dX) + (dY * dY) + (dZ * dZ));

            -- Create the temp Error table
        CREATE TEMPORARY TABLE Error
               (
                  nOrder                        INT             NOT NULL AUTO_INCREMENT PRIMARY KEY,
                  dwError                       INT             NOT NULL,
                  sError                        VARCHAR (255)   NOT NULL
               );

            -- Create the temp Result table
        CREATE TEMPORARY TABLE Result
               (
                  nOrder                        INT                      AUTO_INCREMENT PRIMARY KEY,
                  ObjectHead_Self_twObjectIx    BIGINT,
                  dFactor                       DOUBLE,
                  dDistance                     DOUBLE
               );

        SELECT Type_bType INTO bType
          FROM RMTObject
         WHERE ObjectHead_Self_twObjectIx = twRMTObjectIx;

            IF bType IS NULL
          THEN
                SET bError = 1;
        END IF ;

            IF bError = 0
          THEN
                    SET sText = TRIM (IFNULL (sText, ''));

                     IF sText <> ''
                   THEN
                              -- positions must be normalized to the surface

                             SET dX = dX * dNormal;
                             SET dY = dY * dNormal;
                             SET dZ = dZ * dNormal;

                          INSERT INTO Result
                               (
                                 ObjectHead_Self_twObjectIx, 
                                 dFactor,
                                 dDistance
                               )
                          SELECT 
                                 o.ObjectHead_Self_twObjectIx, 
                                 POW (4.0, o.Type_bType - 7) AS dFactor, 
                                 ArcLength (dRadius, dX, dY, dZ, m.d03, m.d13, m.d23) AS dDistance
                            FROM RMTObject AS o
                            JOIN RMTMatrix AS m ON m.bnMatrix = o.ObjectHead_Self_twObjectIx

                           WHERE o.Name_wsRMTObjectId LIKE CONCAT(sText, '%')
                             AND o.Type_bType BETWEEN bType + 1 AND MVO_RMTOBJECT_TYPE_COMMUNITY
                        ORDER BY POW (4.0, o.Type_bType - 7) * ArcLength (dRadius, dX, dY, dZ, m.d03, m.d13, m.d23), o.Name_wsRMTObjectId
                           LIMIT 10;

                          SELECT o.ObjectHead_Parent_wClass     AS ObjectHead_wClass_Parent,  -- change client to new names
                                 o.ObjectHead_Parent_twObjectIx AS ObjectHead_twParentIx,     -- change client to new names
                                 o.ObjectHead_Self_wClass       AS ObjectHead_wClass_Object,  -- change client to new names
                                 o.ObjectHead_Self_twObjectIx   AS ObjectHead_twObjectIx,     -- change client to new names
                                 o.ObjectHead_wFlags,
                                 o.ObjectHead_twEventIz,
                                 o.Name_wsRMTObjectId,
                                 o.Type_bType,
                                 o.Type_bSubtype,
                                 o.Type_bFiction,
                                 r.nOrder,
                                 r.dFactor,
                                 r.dDistance
                            FROM RMTObject AS o
                            JOIN Result    AS r ON r.ObjectHead_Self_twObjectIx = o.ObjectHead_Self_twObjectIx
                        ORDER BY r.nOrder;

                              -- select also all of the ancestors of the result set

                            WITH RECURSIVE Tree AS
                                 (
                                   SELECT oa.ObjectHead_Parent_wClass,
                                          oa.ObjectHead_Parent_twObjectIx,
                                          oa.ObjectHead_Self_wClass,
                                          oa.ObjectHead_Self_twObjectIx,
                                          r.nOrder,
                                          0                               AS nAncestor
                                     FROM RMTObject AS oa
                                     JOIN Result    AS r  ON r.ObjectHead_Self_twObjectIx = oa.ObjectHead_Self_twObjectIx
 
                                    UNION ALL
 
                                   SELECT ob.ObjectHead_Parent_wClass,
                                          ob.ObjectHead_Parent_twObjectIx,
                                          ob.ObjectHead_Self_wClass,
                                          ob.ObjectHead_Self_twObjectIx,
                                          x.nOrder,
                                          x.nAncestor + 1                 AS nAncestor
                                     FROM RMTObject AS ob
                                     JOIN Tree      AS x  ON x.ObjectHead_Parent_twObjectIx = ob.ObjectHead_Self_twObjectIx
                                                         AND x.ObjectHead_Parent_wClass     = ob.ObjectHead_Self_wClass
                                 )
                          SELECT o.ObjectHead_Parent_wClass     AS ObjectHead_wClass_Parent,  -- change client to new names
                                 o.ObjectHead_Parent_twObjectIx AS ObjectHead_twParentIx,     -- change client to new names
                                 o.ObjectHead_Self_wClass       AS ObjectHead_wClass_Object,  -- change client to new names
                                 o.ObjectHead_Self_twObjectIx   AS ObjectHead_twObjectIx,     -- change client to new names
                                 o.ObjectHead_wFlags,
                                 o.ObjectHead_twEventIz,
                                 o.Name_wsRMTObjectId,
                                 o.Type_bType,
                                 o.Type_bSubtype,
                                 o.Type_bFiction,
                                 x.nOrder,
                                 x.nAncestor
                            FROM RMTObject AS o
                            JOIN Tree      AS x ON x.ObjectHead_Self_twObjectIx = o.ObjectHead_Self_twObjectIx
                           WHERE x.nAncestor > 0
                        ORDER BY x.nOrder,
                                 x.nAncestor;
                   ELSE
                          SELECT NULL AS Unused LIMIT 0;
                          SELECT NULL AS Unused LIMIT 0;
                 END IF ;

                    SET bCommit = 1;
          ELSE
                   CALL call_Error (1, 'twRMTObjectIx is invalid', nError);
        END IF ;

            IF bCommit = 0
          THEN
                  SELECT dwError, sError FROM Error;
        END IF ;

          DROP TEMPORARY TABLE Error;
          DROP TEMPORARY TABLE Result;
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                            MVD_RP1_Map : set_RMTObject_Bound.sql                                           ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                              Copyright 2023-2025 Metaversal Corporation. All rights reserved.                              ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE set_RMTObject_Bound
(
   IN    sIPAddress                    VARCHAR (16),
   IN    twRPersonaIx                  BIGINT,
   IN    twRMTObjectIx                 BIGINT,
   IN    Bound_dX                      DOUBLE,
   IN    Bound_dY                      DOUBLE,
   IN    Bound_dZ                      DOUBLE,
   OUT   nResult                       INT
)
BEGIN
       DECLARE RMTOBJECT_OP_BOUND                         INT DEFAULT 8;

       DECLARE nError  INT DEFAULT 0;
       DECLARE bCommit INT DEFAULT 0;
       DECLARE bError  INT;

       DECLARE ObjectHead_Parent_wClass     SMALLINT;
       DECLARE ObjectHead_Parent_twObjectIx BIGINT;

            -- Create the temp Error table
        CREATE TEMPORARY TABLE Error
               (
                  nOrder                        INT             NOT NULL AUTO_INCREMENT PRIMARY KEY,
                  dwError                       INT             NOT NULL,
                  sError                        VARCHAR (255)   NOT NULL
               );

            -- Create the temp Event table
        CREATE TEMPORARY TABLE Event
               (
                  nOrder                        INT             NOT NULL AUTO_INCREMENT PRIMARY KEY,
                  sType                         VARCHAR (50)    NOT NULL,
                  Self_wClass                   SMALLINT        NOT NULL,
                  Self_twObjectIx               BIGINT          NOT NULL,
                  Child_wClass                  SMALLINT        NOT NULL,
                  Child_twObjectIx              BIGINT          NOT NULL,
                  wFlags                        SMALLINT        NOT NULL,
                  twEventIz                     BIGINT          NOT NULL,
                  sJSON_Object                  TEXT            NOT NULL,
                  sJSON_Child                   TEXT            NOT NULL,
                  sJSON_Change                  TEXT            NOT NULL
               );

           SET twRPersonaIx  = IFNULL (twRPersonaIx,  0);
           SET twRMTObjectIx = IFNULL (twRMTObjectIx, 0);

         START TRANSACTION;

          CALL call_RMTObject_Validate (twRPersonaIx, twRMTObjectIx, ObjectHead_Parent_wClass, ObjectHead_Parent_twObjectIx, nError);
            IF nError = 0
          THEN
                   CALL call_RMTObject_Validate_Bound (ObjectHead_Parent_wClass, ObjectHead_Parent_twObjectIx, twRMTObjectIx, Bound_dX, Bound_dY, Bound_dZ, nError);
        END IF ;

            IF nError = 0
          THEN
                   CALL call_RMTObject_Event_Bound (twRMTObjectIx, Bound_dX, Bound_dY, Bound_dZ, bError);
                     IF bError = 0
                   THEN
                             SET bCommit = 1;
                   ELSE
                            CALL call_Error (-1, 'Failed to update RMTObject', nError);
                 END IF ;
        END IF ;
       
            IF bCommit = 1
          THEN
                    SET bCommit = 0;
                 
                   CALL call_RMTObject_Log (RMTOBJECT_OP_BOUND, sIPAddress, twRPersonaIx, twRMTObjectIx, bError);
                     IF bError = 0
                   THEN
                            CALL call_Event_Push (bError);
                              IF bError = 0
                            THEN
                                      SET bCommit = 1;
                            ELSE
                                     CALL call_Error (-9, 'Failed to push events', nError);
                          END IF ;
                   ELSE
                            CALL call_Error (-8, 'Failed to log action', nError);
                 END IF ;
        END IF ;

            IF bCommit = 0
          THEN
                 SELECT dwError, sError FROM Error;

               ROLLBACK ;
          ELSE
                 COMMIT ;
        END IF ;

          DROP TEMPORARY TABLE Error;
          DROP TEMPORARY TABLE Event;

           SET nResult = bCommit - 1 - nError;
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                            MVD_RP1_Map : set_RMTObject_Name.sql                                            ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                              Copyright 2023-2025 Metaversal Corporation. All rights reserved.                              ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE set_RMTObject_Name
(
   IN    sIPAddress                    VARCHAR (16),
   IN    twRPersonaIx                  BIGINT,
   IN    twRMTObjectIx                 BIGINT,
   IN    Name_wsRMTObjectId            VARCHAR (48),
   OUT   nResult                       INT
)
BEGIN
       DECLARE RMTOBJECT_OP_NAME                          INT DEFAULT 1;

       DECLARE nError  INT DEFAULT 0;
       DECLARE bCommit INT DEFAULT 0;
       DECLARE bError  INT;

       DECLARE ObjectHead_Parent_wClass     SMALLINT;
       DECLARE ObjectHead_Parent_twObjectIx BIGINT;

            -- Create the temp Error table
        CREATE TEMPORARY TABLE Error
               (
                  nOrder                        INT             NOT NULL AUTO_INCREMENT PRIMARY KEY,
                  dwError                       INT             NOT NULL,
                  sError                        VARCHAR (255)   NOT NULL
               );

            -- Create the temp Event table
        CREATE TEMPORARY TABLE Event
               (
                  nOrder                        INT             NOT NULL AUTO_INCREMENT PRIMARY KEY,
                  sType                         VARCHAR (50)    NOT NULL,
                  Self_wClass                   SMALLINT        NOT NULL,
                  Self_twObjectIx               BIGINT          NOT NULL,
                  Child_wClass                  SMALLINT        NOT NULL,
                  Child_twObjectIx              BIGINT          NOT NULL,
                  wFlags                        SMALLINT        NOT NULL,
                  twEventIz                     BIGINT          NOT NULL,
                  sJSON_Object                  TEXT            NOT NULL,
                  sJSON_Child                   TEXT            NOT NULL,
                  sJSON_Change                  TEXT            NOT NULL
               );

           SET twRPersonaIx  = IFNULL (twRPersonaIx,  0);
           SET twRMTObjectIx = IFNULL (twRMTObjectIx, 0);

         START TRANSACTION;

          CALL call_RMTObject_Validate (twRPersonaIx, twRMTObjectIx, ObjectHead_Parent_wClass, ObjectHead_Parent_twObjectIx, nError);
            IF nError = 0
          THEN
                   CALL call_RMTObject_Validate_Name (ObjectHead_Parent_wClass, ObjectHead_Parent_twObjectIx, twRMTObjectIx, Name_wsRMTObjectId, nError);
        END IF ;

            IF nError = 0
          THEN
                   CALL call_RMTObject_Event_Name (twRMTObjectIx, Name_wsRMTObjectId, bError);
                     IF bError = 0
                   THEN
                             SET bCommit = 1;
                   ELSE 
                            CALL call_Error (-1, 'Failed to update RMTObject', nError);
                 END IF ;
        END IF ;
       
            IF bCommit = 1
          THEN
                    SET bCommit = 0;
                 
                   CALL call_RMTObject_Log (RMTOBJECT_OP_NAME, sIPAddress, twRPersonaIx, twRMTObjectIx, bError);
                     IF bError = 0
                   THEN
                            CALL call_Event_Push (bError);
                              IF bError = 0
                            THEN
                                      SET bCommit = 1;
                            ELSE
                                     CALL call_Error (-9, 'Failed to push events', nError);
                          END IF ;
                   ELSE
                            CALL call_Error (-8, 'Failed to log action', nError);
                 END IF ;
        END IF ;

            IF bCommit = 0
          THEN
                 SELECT dwError, sError FROM Error;

               ROLLBACK ;
          ELSE
                 COMMIT ;
        END IF ;

          DROP TEMPORARY TABLE Error;
          DROP TEMPORARY TABLE Event;

           SET nResult = bCommit - 1 - nError;
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                            MVD_RP1_Map : set_RMTObject_Owner.sql                                           ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                              Copyright 2023-2025 Metaversal Corporation. All rights reserved.                              ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE set_RMTObject_Owner
(
   IN    sIPAddress                    VARCHAR (16),
   IN    twRPersonaIx                  BIGINT,
   IN    twRMTObjectIx                 BIGINT,
   IN    Owner_twRPersonaIx            BIGINT,
   OUT   nResult                       INT
)
BEGIN
       DECLARE RMTOBJECT_OP_OWNER                         INT DEFAULT 3;

       DECLARE nError  INT DEFAULT 0;
       DECLARE bCommit INT DEFAULT 0;
       DECLARE bError  INT;

       DECLARE ObjectHead_Parent_wClass     SMALLINT;
       DECLARE ObjectHead_Parent_twObjectIx BIGINT;

            -- Create the temp Error table
        CREATE TEMPORARY TABLE Error
               (
                  nOrder                        INT             NOT NULL AUTO_INCREMENT PRIMARY KEY,
                  dwError                       INT             NOT NULL,
                  sError                        VARCHAR (255)   NOT NULL
               );

            -- Create the temp Event table
        CREATE TEMPORARY TABLE Event
               (
                  nOrder                        INT             NOT NULL AUTO_INCREMENT PRIMARY KEY,
                  sType                         VARCHAR (50)    NOT NULL,
                  Self_wClass                   SMALLINT        NOT NULL,
                  Self_twObjectIx               BIGINT          NOT NULL,
                  Child_wClass                  SMALLINT        NOT NULL,
                  Child_twObjectIx              BIGINT          NOT NULL,
                  wFlags                        SMALLINT        NOT NULL,
                  twEventIz                     BIGINT          NOT NULL,
                  sJSON_Object                  TEXT            NOT NULL,
                  sJSON_Child                   TEXT            NOT NULL,
                  sJSON_Change                  TEXT            NOT NULL
               );

           SET twRPersonaIx  = IFNULL (twRPersonaIx,  0);
           SET twRMTObjectIx = IFNULL (twRMTObjectIx, 0);

         START TRANSACTION;

          CALL call_RMTObject_Validate (twRPersonaIx, twRMTObjectIx, ObjectHead_Parent_wClass, ObjectHead_Parent_twObjectIx, nError);
            IF nError = 0
          THEN
                   CALL call_RMTObject_Validate_Owner (ObjectHead_Parent_wClass, ObjectHead_Parent_twObjectIx, twRMTObjectIx, Owner_twRPersonaIx, nError);
        END IF ;

            IF nError = 0
          THEN
                   CALL call_RMTObject_Event_Owner (twRMTObjectIx, Owner_twRPersonaIx, bError);
                     IF bError = 0
                   THEN
                             SET bCommit = 1;
                   ELSE 
                            CALL call_Error (-1, 'Failed to update RMTObject', nError);
                 END IF ;
        END IF ;
       
            IF bCommit = 1
          THEN
                    SET bCommit = 0;
                 
                   CALL call_RMTObject_Log (RMTOBJECT_OP_OWNER, sIPAddress, twRPersonaIx, twRMTObjectIx, bError);
                     IF bError = 0
                   THEN
                            CALL call_Event_Push (bError);
                              IF bError = 0
                            THEN
                                      SET bCommit = 1;
                            ELSE
                                     CALL call_Error (-9, 'Failed to push events', nError);
                          END IF ;
                   ELSE
                            CALL call_Error (-8, 'Failed to log action', nError);
                 END IF ;
        END IF ;

            IF bCommit = 0
          THEN
                 SELECT dwError, sError FROM Error;

               ROLLBACK ;
          ELSE
                 COMMIT ;
        END IF ;

          DROP TEMPORARY TABLE Error;
          DROP TEMPORARY TABLE Event;

           SET nResult = bCommit - 1 - nError;
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                         MVD_RP1_Map : set_RMTObject_Properties.sql                                         ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                              Copyright 2023-2025 Metaversal Corporation. All rights reserved.                              ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE set_RMTObject_Properties
(
   IN    sIPAddress                    VARCHAR (16),
   IN    twRPersonaIx                  BIGINT,
   IN    twRMTObjectIx                 BIGINT,
   IN    Properties_bLockToGround      TINYINT UNSIGNED,
   IN    Properties_bYouth             TINYINT UNSIGNED,
   IN    Properties_bAdult             TINYINT UNSIGNED,
   IN    Properties_bAvatar            TINYINT UNSIGNED,
   OUT   nResult                       INT
)
BEGIN
       DECLARE RMTOBJECT_OP_PROPERTIES                    INT DEFAULT 9;

       DECLARE nError  INT DEFAULT 0;
       DECLARE bCommit INT DEFAULT 0;
       DECLARE bError  INT;

       DECLARE ObjectHead_Parent_wClass     SMALLINT;
       DECLARE ObjectHead_Parent_twObjectIx BIGINT;

            -- Create the temp Error table
        CREATE TEMPORARY TABLE Error
               (
                  nOrder                        INT             NOT NULL AUTO_INCREMENT PRIMARY KEY,
                  dwError                       INT             NOT NULL,
                  sError                        VARCHAR (255)   NOT NULL
               );

            -- Create the temp Event table
        CREATE TEMPORARY TABLE Event
               (
                  nOrder                        INT             NOT NULL AUTO_INCREMENT PRIMARY KEY,
                  sType                         VARCHAR (50)    NOT NULL,
                  Self_wClass                   SMALLINT        NOT NULL,
                  Self_twObjectIx               BIGINT          NOT NULL,
                  Child_wClass                  SMALLINT        NOT NULL,
                  Child_twObjectIx              BIGINT          NOT NULL,
                  wFlags                        SMALLINT        NOT NULL,
                  twEventIz                     BIGINT          NOT NULL,
                  sJSON_Object                  TEXT            NOT NULL,
                  sJSON_Child                   TEXT            NOT NULL,
                  sJSON_Change                  TEXT            NOT NULL
               );

           SET twRPersonaIx  = IFNULL (twRPersonaIx,  0);
           SET twRMTObjectIx = IFNULL (twRMTObjectIx, 0);

         START TRANSACTION;

          CALL call_RMTObject_Validate (twRPersonaIx, twRMTObjectIx, ObjectHead_Parent_wClass, ObjectHead_Parent_twObjectIx, nError);
            IF nError = 0
          THEN
                   CALL call_RMTObject_Validate_Properties (ObjectHead_Parent_wClass, ObjectHead_Parent_twObjectIx, twRMTObjectIx, Properties_bLockToGround, Properties_bYouth, Properties_bAdult, Properties_bAvatar, nError);
        END IF ;

            IF nError = 0
          THEN
                   CALL call_RMTObject_Event_Properties (twRMTObjectIx, Properties_bLockToGround, Properties_bYouth, Properties_bAdult, Properties_bAvatar, bError);
                     IF bError = 0
                   THEN
                             SET bCommit = 1;
                   ELSE 
                            CALL call_Error (-1, 'Failed to update RMTObject', nError);
                 END IF ;
        END IF ;
       
            IF bCommit = 1
          THEN
                    SET bCommit = 0;
                 
                   CALL call_RMTObject_Log (RMTOBJECT_OP_PROPERTIES, sIPAddress, twRPersonaIx, twRMTObjectIx, bError);
                     IF bError = 0
                   THEN
                            CALL call_Event_Push (bError);
                              IF bError = 0
                            THEN
                                      SET bCommit = 1;
                            ELSE
                                     CALL call_Error (-9, 'Failed to push events', nError);
                          END IF ;
                   ELSE
                            CALL call_Error (-8, 'Failed to log action', nError);
                 END IF ;
        END IF ;

            IF bCommit = 0
          THEN
                 SELECT dwError, sError FROM Error;

               ROLLBACK ;
          ELSE
                 COMMIT ;
        END IF ;

          DROP TEMPORARY TABLE Error;
          DROP TEMPORARY TABLE Event;

           SET nResult = bCommit - 1 - nError;
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                          MVD_RP1_Map : set_RMTObject_Resource.sql                                          ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                              Copyright 2023-2025 Metaversal Corporation. All rights reserved.                              ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE set_RMTObject_Resource
(
   IN    sIPAddress                    VARCHAR (16),
   IN    twRPersonaIx                  BIGINT,
   IN    twRMTObjectIx                 BIGINT,
   IN    Resource_qwResource           BIGINT,
   IN    Resource_sName                VARCHAR (48),
   IN    Resource_sReference           VARCHAR (128),
   OUT   nResult                       INT
)
BEGIN
       DECLARE RMTOBJECT_OP_RESOURCE                      INT DEFAULT 4;

       DECLARE nError  INT DEFAULT 0;
       DECLARE bCommit INT DEFAULT 0;
       DECLARE bError  INT;

       DECLARE ObjectHead_Parent_wClass     SMALLINT;
       DECLARE ObjectHead_Parent_twObjectIx BIGINT;

            -- Create the temp Error table
        CREATE TEMPORARY TABLE Error
               (
                  nOrder                        INT             NOT NULL AUTO_INCREMENT PRIMARY KEY,
                  dwError                       INT             NOT NULL,
                  sError                        VARCHAR (255)   NOT NULL
               );

            -- Create the temp Event table
        CREATE TEMPORARY TABLE Event
               (
                  nOrder                        INT             NOT NULL AUTO_INCREMENT PRIMARY KEY,
                  sType                         VARCHAR (50)    NOT NULL,
                  Self_wClass                   SMALLINT        NOT NULL,
                  Self_twObjectIx               BIGINT          NOT NULL,
                  Child_wClass                  SMALLINT        NOT NULL,
                  Child_twObjectIx              BIGINT          NOT NULL,
                  wFlags                        SMALLINT        NOT NULL,
                  twEventIz                     BIGINT          NOT NULL,
                  sJSON_Object                  TEXT            NOT NULL,
                  sJSON_Child                   TEXT            NOT NULL,
                  sJSON_Change                  TEXT            NOT NULL
               );

           SET twRPersonaIx  = IFNULL (twRPersonaIx,  0);
           SET twRMTObjectIx = IFNULL (twRMTObjectIx, 0);

         START TRANSACTION;

          CALL call_RMTObject_Validate (twRPersonaIx, twRMTObjectIx, ObjectHead_Parent_wClass, ObjectHead_Parent_twObjectIx, nError);
            IF nError = 0
          THEN
                   CALL call_RMTObject_Validate_Resource (ObjectHead_Parent_wClass, ObjectHead_Parent_twObjectIx, twRMTObjectIx, Resource_qwResource, Resource_sName, Resource_sReference, nError);
        END IF ;

            IF nError = 0
          THEN
                   CALL call_RMTObject_Event_Resource (twRMTObjectIx, Resource_qwResource, Resource_sName, Resource_sReference, bError);
                     IF bError = 0
                   THEN
                             SET bCommit = 1;
                   ELSE 
                            CALL call_Error (-1, 'Failed to update RMTObject', nError);
                 END IF ;
        END IF ;
       
            IF bCommit = 1
          THEN
                    SET bCommit = 0;
                 
                   CALL call_RMTObject_Log (RMTOBJECT_OP_RESOURCE, sIPAddress, twRPersonaIx, twRMTObjectIx, bError);
                     IF bError = 0
                   THEN
                            CALL call_Event_Push (bError);
                              IF bError = 0
                            THEN
                                      SET bCommit = 1;
                            ELSE
                                     CALL call_Error (-9, 'Failed to push events', nError);
                          END IF ;
                   ELSE
                            CALL call_Error (-8, 'Failed to log action', nError);
                 END IF ;
        END IF ;

            IF bCommit = 0
          THEN
                 SELECT dwError, sError FROM Error;

               ROLLBACK ;
          ELSE
                 COMMIT ;
        END IF ;

          DROP TEMPORARY TABLE Error;
          DROP TEMPORARY TABLE Event;

           SET nResult = bCommit - 1 - nError;
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                       MVD_RP1_Map : set_RMTObject_RMPObject_Close.sql                                      ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                              Copyright 2023-2025 Metaversal Corporation. All rights reserved.                              ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE set_RMTObject_RMPObject_Close
(
   IN    sIPAddress                    VARCHAR (16),
   IN    twRPersonaIx                  BIGINT,
   IN    twRMTObjectIx                 BIGINT,
   IN    twRMPObjectIx_Close           BIGINT,
   IN    bDeleteAll                    TINYINT UNSIGNED,
   OUT   nResult                       INT
)
BEGIN
       DECLARE SBO_CLASS_RMPOBJECT                        INT DEFAULT 73;
       DECLARE RMTOBJECT_OP_RMPOBJECT_CLOSE               INT DEFAULT 17;

       DECLARE nError  INT DEFAULT 0;
       DECLARE bCommit INT DEFAULT 0;
       DECLARE bError  INT;

       DECLARE ObjectHead_Parent_wClass     SMALLINT;
       DECLARE ObjectHead_Parent_twObjectIx BIGINT;

       DECLARE nCount INT;

            -- Create the temp Error table
        CREATE TEMPORARY TABLE Error
               (
                  nOrder                        INT             NOT NULL AUTO_INCREMENT PRIMARY KEY,
                  dwError                       INT             NOT NULL,
                  sError                        VARCHAR (255)   NOT NULL
               );

            -- Create the temp Event table
        CREATE TEMPORARY TABLE Event
               (
                  nOrder                        INT             NOT NULL AUTO_INCREMENT PRIMARY KEY,
                  sType                         VARCHAR (50)    NOT NULL,
                  Self_wClass                   SMALLINT        NOT NULL,
                  Self_twObjectIx               BIGINT          NOT NULL,
                  Child_wClass                  SMALLINT        NOT NULL,
                  Child_twObjectIx              BIGINT          NOT NULL,
                  wFlags                        SMALLINT        NOT NULL,
                  twEventIz                     BIGINT          NOT NULL,
                  sJSON_Object                  TEXT            NOT NULL,
                  sJSON_Child                   TEXT            NOT NULL,
                  sJSON_Change                  TEXT            NOT NULL
               );

           SET twRPersonaIx        = IFNULL (twRPersonaIx,        0);
           SET twRMTObjectIx       = IFNULL (twRMTObjectIx,       0);
           SET twRMPObjectIx_Close = IFNULL (twRMPObjectIx_Close, 0);
           SET bDeleteAll          = IFNULL (bDeleteAll,          0);

         START TRANSACTION;

          CALL call_RMTObject_Validate (twRPersonaIx, twRMTObjectIx, ObjectHead_Parent_wClass, ObjectHead_Parent_twObjectIx, nError);
            IF nError = 0
          THEN
                 SELECT COUNT(*) INTO nCount
                   FROM RMTObject
                  WHERE ObjectHead_Parent_wClass     = SBO_CLASS_RMTOBJECT
                    AND ObjectHead_Parent_twObjectIx = twRMPObjectIx_Close;

                     IF twRMPObjectIx_Close <= 0
                   THEN
                            CALL call_Error (5, 'twRMPObjectIx_Close is invalid',   nError);
                 ELSEIF bDeleteAll = 0 AND nCount > 0
                   THEN
                            CALL call_Error (6, 'twRMPObjectIx_Close is not empty', nError);
                 END IF ;
        END IF ;

            IF nError = 0
          THEN
                   CALL call_RMTObject_Event_RMPObject_Close (twRMTObjectIx, twRMPObjectIx_Close, bError, 0);
                     IF bError = 0
                   THEN
                             SET bCommit = 1;
                   ELSE 
                            CALL call_Error (-1, 'Failed to update RMTObject', nError);
                 END IF ;
        END IF ;
       
            IF bCommit = 1
          THEN
                    SET bCommit = 0;
                 
                   CALL call_RMTObject_Log (RMTOBJECT_OP_RMPOBJECT_CLOSE, sIPAddress, twRPersonaIx, twRMTObjectIx, bError);
                     IF bError = 0
                   THEN
                            CALL call_Event_Push (bError);
                              IF bError = 0
                            THEN
                                      SET bCommit = 1;
                            ELSE
                                     CALL call_Error (-9, 'Failed to push events', nError);
                          END IF ;
                   ELSE
                            CALL call_Error (-8, 'Failed to log action', nError);
                 END IF ;
        END IF ;

            IF bCommit = 0
          THEN
                 SELECT dwError, sError FROM Error;

               ROLLBACK ;
          ELSE
                 COMMIT ;
        END IF ;

          DROP TEMPORARY TABLE Error;
          DROP TEMPORARY TABLE Event;

           SET nResult = bCommit - 1 - nError;
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                       MVD_RP1_Map : set_RMTObject_RMPObject_Open.sql                                       ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                              Copyright 2023-2025 Metaversal Corporation. All rights reserved.                              ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE set_RMTObject_RMPObject_Open
(
   IN    sIPAddress                    VARCHAR (16),
   IN    twRPersonaIx                  BIGINT,
   IN    twRMTObjectIx                 BIGINT,
   IN    Name_wsRMPObjectId            VARCHAR (48),
   IN    Type_bType                    TINYINT UNSIGNED,
   IN    Type_bSubtype                 TINYINT UNSIGNED,
   IN    Type_bFiction                 TINYINT UNSIGNED,
   IN    Type_bMovable                 TINYINT UNSIGNED,
   IN    Owner_twRPersonaIx            BIGINT,
   IN    Resource_qwResource           BIGINT,
   IN    Resource_sName                VARCHAR (48),
   IN    Resource_sReference           VARCHAR (128),
   IN    Transform_Position_dX         DOUBLE,
   IN    Transform_Position_dY         DOUBLE,
   IN    Transform_Position_dZ         DOUBLE,
   IN    Transform_Rotation_dX         DOUBLE,
   IN    Transform_Rotation_dY         DOUBLE,
   IN    Transform_Rotation_dZ         DOUBLE,
   IN    Transform_Rotation_dW         DOUBLE,
   IN    Transform_Scale_dX            DOUBLE,
   IN    Transform_Scale_dY            DOUBLE,
   IN    Transform_Scale_dZ            DOUBLE,
   IN    Bound_dX                      DOUBLE,
   IN    Bound_dY                      DOUBLE,
   IN    Bound_dZ                      DOUBLE,
   OUT   nResult                       INT
)
BEGIN
       DECLARE SBO_CLASS_RMTOBJECT                        INT DEFAULT 72;
       DECLARE RMTOBJECT_OP_RMPOBJECT_OPEN                INT DEFAULT 16;

       DECLARE nError  INT DEFAULT 0;
       DECLARE bCommit INT DEFAULT 0;
       DECLARE bError  INT;

       DECLARE ObjectHead_Parent_wClass     SMALLINT;
       DECLARE ObjectHead_Parent_twObjectIx BIGINT;

       DECLARE twRMPObjectIx_Open           BIGINT;

            -- Create the temp Error table
        CREATE TEMPORARY TABLE Error
               (
                  nOrder                        INT             NOT NULL AUTO_INCREMENT PRIMARY KEY,
                  dwError                       INT             NOT NULL,
                  sError                        VARCHAR (255)   NOT NULL
               );

            -- Create the temp Event table
        CREATE TEMPORARY TABLE Event
               (
                  nOrder                        INT             NOT NULL AUTO_INCREMENT PRIMARY KEY,
                  sType                         VARCHAR (50)    NOT NULL,
                  Self_wClass                   SMALLINT        NOT NULL,
                  Self_twObjectIx               BIGINT          NOT NULL,
                  Child_wClass                  SMALLINT        NOT NULL,
                  Child_twObjectIx              BIGINT          NOT NULL,
                  wFlags                        SMALLINT        NOT NULL,
                  twEventIz                     BIGINT          NOT NULL,
                  sJSON_Object                  TEXT            NOT NULL,
                  sJSON_Child                   TEXT            NOT NULL,
                  sJSON_Change                  TEXT            NOT NULL
               );

           SET twRPersonaIx  = IFNULL (twRPersonaIx,  0);
           SET twRMTObjectIx = IFNULL (twRMTObjectIx, 0);

         START TRANSACTION;

          CALL call_RMTObject_Validate (twRPersonaIx, twRMTObjectIx, ObjectHead_Parent_wClass, ObjectHead_Parent_twObjectIx, nError);
            IF nError = 0
          THEN
                   CALL call_RMPObject_Validate_Name      (SBO_CLASS_RMTOBJECT, twRMTObjectIx, 0, Name_wsRMPObjectId, nError);
                   CALL call_RMPObject_Validate_Type      (SBO_CLASS_RMTOBJECT, twRMTObjectIx, 0, Type_bType, Type_bSubtype, Type_bFiction, Type_bMovable, nError);
                   CALL call_RMPObject_Validate_Owner     (SBO_CLASS_RMTOBJECT, twRMTObjectIx, 0, Owner_twRPersonaIx, nError);
                   CALL call_RMPObject_Validate_Resource  (SBO_CLASS_RMTOBJECT, twRMTObjectIx, 0, Resource_qwResource, Resource_sName, Resource_sReference, nError);
                   CALL call_RMPObject_Validate_Transform (SBO_CLASS_RMTOBJECT, twRMTObjectIx, 0, Transform_Position_dX, Transform_Position_dY, Transform_Position_dZ, Transform_Rotation_dX, Transform_Rotation_dY, Transform_Rotation_dZ, Transform_Rotation_dW, Transform_Scale_dX, Transform_Scale_dY, Transform_Scale_dZ, nError);
                   CALL call_RMPObject_Validate_Bound     (SBO_CLASS_RMTOBJECT, twRMTObjectIx, 0, Bound_dX, Bound_dY, Bound_dZ, nError);
        END IF ;

            IF nError = 0
          THEN
                   CALL call_RMTObject_Event_RMPObject_Open (twRMTObjectIx, Name_wsRMPObjectId, Type_bType, Type_bSubtype, Type_bFiction, Type_bMovable, Owner_twRPersonaIx, Resource_qwResource, Resource_sName, Resource_sReference, Transform_Position_dX, Transform_Position_dY, Transform_Position_dZ, Transform_Rotation_dX, Transform_Rotation_dY, Transform_Rotation_dZ, Transform_Rotation_dW, Transform_Scale_dX, Transform_Scale_dY, Transform_Scale_dZ, Bound_dX, Bound_dY, Bound_dZ, twRMPObjectIx_Open, bError, 0);
                     IF bError = 0
                   THEN
                          SELECT twRMPObjectIx_Open AS twRMPObject;
   
                             SET bCommit = 1;
                   ELSE 
                            CALL call_Error (-1, 'Failed to insert RMPObject', nError);
                 END IF ;
        END IF ;
       
            IF bCommit = 1
          THEN
                    SET bCommit = 0;
                 
                   CALL call_RMTObject_Log (RMTOBJECT_OP_RMPOBJECT_OPEN, sIPAddress, twRPersonaIx, twRMTObjectIx, bError);
                     IF bError = 0
                   THEN
                            CALL call_Event_Push (bError);
                              IF bError = 0
                            THEN
                                      SET bCommit = 1;
                            ELSE
                                     CALL call_Error (-9, 'Failed to push events', nError);
                          END IF ;
                   ELSE
                            CALL call_Error (-8, 'Failed to log action', nError);
                 END IF ;
        END IF ;

            IF bCommit = 0
          THEN
                 SELECT dwError, sError FROM Error;

               ROLLBACK ;
          ELSE
                 COMMIT ;
        END IF ;

          DROP TEMPORARY TABLE Error;
          DROP TEMPORARY TABLE Event;

           SET nResult = bCommit - 1 - nError;
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                       MVD_RP1_Map : set_RMTObject_RMTObject_Close.sql                                      ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                              Copyright 2023-2025 Metaversal Corporation. All rights reserved.                              ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE set_RMTObject_RMTObject_Close
(
   IN    sIPAddress                    VARCHAR (16),
   IN    twRPersonaIx                  BIGINT,
   IN    twRMTObjectIx                 BIGINT,
   IN    twRMTObjectIx_Close           BIGINT,
   IN    bDeleteAll                    TINYINT UNSIGNED,
   OUT   nResult                       INT
)
BEGIN
       DECLARE SBO_CLASS_RMTOBJECT                        INT DEFAULT 72;
       DECLARE RMTOBJECT_OP_RMTOBJECT_CLOSE               INT DEFAULT 15;

       DECLARE nError  INT DEFAULT 0;
       DECLARE bCommit INT DEFAULT 0;
       DECLARE bError  INT;

       DECLARE ObjectHead_Parent_wClass     SMALLINT;
       DECLARE ObjectHead_Parent_twObjectIx BIGINT;

       DECLARE nCount INT;

            -- Create the temp Error table
        CREATE TEMPORARY TABLE Error
               (
                  nOrder                        INT             NOT NULL AUTO_INCREMENT PRIMARY KEY,
                  dwError                       INT             NOT NULL,
                  sError                        VARCHAR (255)   NOT NULL
               );

            -- Create the temp Event table
        CREATE TEMPORARY TABLE Event
               (
                  nOrder                        INT             NOT NULL AUTO_INCREMENT PRIMARY KEY,
                  sType                         VARCHAR (50)    NOT NULL,
                  Self_wClass                   SMALLINT        NOT NULL,
                  Self_twObjectIx               BIGINT          NOT NULL,
                  Child_wClass                  SMALLINT        NOT NULL,
                  Child_twObjectIx              BIGINT          NOT NULL,
                  wFlags                        SMALLINT        NOT NULL,
                  twEventIz                     BIGINT          NOT NULL,
                  sJSON_Object                  TEXT            NOT NULL,
                  sJSON_Child                   TEXT            NOT NULL,
                  sJSON_Change                  TEXT            NOT NULL
               );

           SET twRPersonaIx        = IFNULL (twRPersonaIx,        0);
           SET twRMTObjectIx       = IFNULL (twRMTObjectIx,       0);
           SET twRMTObjectIx_Close = IFNULL (twRMTObjectIx_Close, 0);
           SET bDeleteAll          = IFNULL (bDeleteAll,          0);

         START TRANSACTION;

          CALL call_RMTObject_Validate (twRPersonaIx, twRMTObjectIx, ObjectHead_Parent_wClass, ObjectHead_Parent_twObjectIx, nError);
            IF nError = 0
          THEN
                 SELECT COUNT(*) INTO nCount
                   FROM RMTObject
                  WHERE ObjectHead_Parent_wClass     = SBO_CLASS_RMTOBJECT
                    AND ObjectHead_Parent_twObjectIx = twRMTObjectIx_Close;

                 SELECT COUNT(*) + nCount INTO nCount
                   FROM RMPObject
                  WHERE ObjectHead_Parent_wClass     = SBO_CLASS_RMTOBJECT
                    AND ObjectHead_Parent_twObjectIx = twRMTObjectIx_Close;

                     IF twRMTObjectIx_Close <= 0
                   THEN
                            CALL call_Error (5, 'twRMTObjectIx_Close is invalid',   nError);
                 ELSEIF bDeleteAll = 0 AND nCount > 0
                   THEN
                            CALL call_Error (6, 'twRMTObjectIx_Close is not empty', nError);
                 END IF ;
        END IF ;

            IF nError = 0
          THEN
                   CALL call_RMTObject_Event_RMTObject_Close (twRMTObjectIx, twRMTObjectIx_Close, bError);
                     IF bError = 0
                   THEN
                             SET bCommit = 1;
                   ELSE 
                            CALL call_Error (-1, 'Failed to delete RMTObject', nError);
                 END IF ;
        END IF ;
       
            IF bCommit = 1
          THEN
                    SET bCommit = 0;
                 
                   CALL call_RMTObject_Log (RMTOBJECT_OP_RMTOBJECT_CLOSE, sIPAddress, twRPersonaIx, twRMTObjectIx, bError);
                     IF bError = 0
                   THEN
                            CALL call_Event_Push (bError);
                              IF bError = 0
                            THEN
                                      SET bCommit = 1;
                            ELSE
                                     CALL call_Error (-9, 'Failed to push events', nError);
                          END IF ;
                   ELSE
                            CALL call_Error (-8, 'Failed to log action', nError);
                 END IF ;
        END IF ;

            IF bCommit = 0
          THEN
                 SELECT dwError, sError FROM Error;

               ROLLBACK ;
          ELSE
                 COMMIT ;
        END IF ;

          DROP TEMPORARY TABLE Error;
          DROP TEMPORARY TABLE Event;

           SET nResult = bCommit - 1 - nError;
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                       MVD_RP1_Map : set_RMTObject_RMTObject_Open.sql                                       ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                              Copyright 2023-2025 Metaversal Corporation. All rights reserved.                              ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE set_RMTObject_RMTObject_Open
(
   IN    sIPAddress                    VARCHAR (16),
   IN    twRPersonaIx                  BIGINT,
   IN    twRMTObjectIx                 BIGINT,
   IN    Name_wsRMTObjectId            VARCHAR (48),
   IN    Type_bType                    TINYINT UNSIGNED,
   IN    Type_bSubtype                 TINYINT UNSIGNED,
   IN    Type_bFiction                 TINYINT UNSIGNED,
   IN    Owner_twRPersonaIx            BIGINT,
   IN    Resource_qwResource           BIGINT,
   IN    Resource_sName                VARCHAR (48),
   IN    Resource_sReference           VARCHAR (128),
   IN    Transform_Position_dX         DOUBLE,
   IN    Transform_Position_dY         DOUBLE,
   IN    Transform_Position_dZ         DOUBLE,
   IN    Transform_Rotation_dX         DOUBLE,
   IN    Transform_Rotation_dY         DOUBLE,
   IN    Transform_Rotation_dZ         DOUBLE,
   IN    Transform_Rotation_dW         DOUBLE,
   IN    Transform_Scale_dX            DOUBLE,
   IN    Transform_Scale_dY            DOUBLE,
   IN    Transform_Scale_dZ            DOUBLE,
   IN    Bound_dX                      DOUBLE,
   IN    Bound_dY                      DOUBLE,
   IN    Bound_dZ                      DOUBLE,
   IN    Properties_bLockToGround      TINYINT UNSIGNED,
   IN    Properties_bYouth             TINYINT UNSIGNED,
   IN    Properties_bAdult             TINYINT UNSIGNED,
   IN    Properties_bAvatar            TINYINT UNSIGNED,
   IN    bCoord                        TINYINT UNSIGNED,
   IN    dA                            DOUBLE,
   IN    dB                            DOUBLE,
   IN    dC                            DOUBLE,
   OUT   nResult                       INT
)
BEGIN
       DECLARE SBO_CLASS_RMTOBJECT                        INT DEFAULT 72;
       DECLARE RMTOBJECT_OP_RMTOBJECT_OPEN                INT DEFAULT 14;
       DECLARE RMTMATRIX_COORD_NUL                        INT DEFAULT 0;
       DECLARE RMTMATRIX_COORD_CAR                        INT DEFAULT 1;
       DECLARE RMTMATRIX_COORD_CYL                        INT DEFAULT 2;
       DECLARE RMTMATRIX_COORD_GEO                        INT DEFAULT 3;

       DECLARE nError  INT DEFAULT 0;
       DECLARE bCommit INT DEFAULT 0;
       DECLARE bError  INT;

       DECLARE ObjectHead_Parent_wClass     SMALLINT;
       DECLARE ObjectHead_Parent_twObjectIx BIGINT;

       DECLARE twRMTObjectIx_Open           BIGINT;

            -- Create the temp Error table
        CREATE TEMPORARY TABLE Error
               (
                  nOrder                        INT             NOT NULL AUTO_INCREMENT PRIMARY KEY,
                  dwError                       INT             NOT NULL,
                  sError                        VARCHAR (255)   NOT NULL
               );

            -- Create the temp Event table
        CREATE TEMPORARY TABLE Event
               (
                  nOrder                        INT             NOT NULL AUTO_INCREMENT PRIMARY KEY,
                  sType                         VARCHAR (50)    NOT NULL,
                  Self_wClass                   SMALLINT        NOT NULL,
                  Self_twObjectIx               BIGINT          NOT NULL,
                  Child_wClass                  SMALLINT        NOT NULL,
                  Child_twObjectIx              BIGINT          NOT NULL,
                  wFlags                        SMALLINT        NOT NULL,
                  twEventIz                     BIGINT          NOT NULL,
                  sJSON_Object                  TEXT            NOT NULL,
                  sJSON_Child                   TEXT            NOT NULL,
                  sJSON_Change                  TEXT            NOT NULL
               );

           SET twRPersonaIx  = IFNULL (twRPersonaIx,  0);
           SET twRMTObjectIx = IFNULL (twRMTObjectIx, 0);

         START TRANSACTION;

          CALL call_RMTObject_Validate (twRPersonaIx, twRMTObjectIx, ObjectHead_Parent_wClass, ObjectHead_Parent_twObjectIx, nError);
            IF nError = 0
          THEN
                   CALL call_RMTObject_Validate_Name       (SBO_CLASS_RMTOBJECT, twRMTObjectIx, 0, Name_wsRMTObjectId, nError);
                   CALL call_RMTObject_Validate_Type       (SBO_CLASS_RMTOBJECT, twRMTObjectIx, 0, Type_bType, Type_bSubtype, Type_bFiction, nError);
                   CALL call_RMTObject_Validate_Owner      (SBO_CLASS_RMTOBJECT, twRMTObjectIx, 0, Owner_twRPersonaIx, nError);
                   CALL call_RMTObject_Validate_Resource   (SBO_CLASS_RMTOBJECT, twRMTObjectIx, 0, Resource_qwResource, Resource_sName, Resource_sReference, nError);
                -- CALL call_RMTObject_Validate_Transform  (SBO_CLASS_RMTOBJECT, twRMTObjectIx, 0, Transform_Position_dX, Transform_Position_dY, Transform_Position_dZ, Transform_Rotation_dX, Transform_Rotation_dY, Transform_Rotation_dZ, Transform_Rotation_dW, Transform_Scale_dX, Transform_Scale_dY, Transform_Scale_dZ, nError);
                   CALL call_RMTObject_Validate_Bound      (SBO_CLASS_RMTOBJECT, twRMTObjectIx, 0, Bound_dX, Bound_dY, Bound_dZ, nError);
                   CALL call_RMTObject_Validate_Properties (SBO_CLASS_RMTOBJECT, twRMTObjectIx, 0, Properties_bLockToGround, Properties_bYouth, Properties_bAdult, Properties_bAvatar, nError);

                     IF bCoord = 3 -- RMTMATRIX_COORD_NUL
                   THEN
                        CALL call_RMTObject_Validate_Coord_Nul (SBO_CLASS_RMTOBJECT, twRMTObjectIx, 0, Transform_Position_dX, Transform_Position_dY, Transform_Position_dZ, Transform_Rotation_dX, Transform_Rotation_dY, Transform_Rotation_dZ, Transform_Rotation_dW, Transform_Scale_dX, Transform_Scale_dY, Transform_Scale_dZ, nError);
                 ELSEIF bCoord = 2 -- RMTMATRIX_COORD_CAR
                   THEN
                        CALL call_RMTObject_Validate_Coord_Car (SBO_CLASS_RMTOBJECT, twRMTObjectIx, 0, dA, dB, dC, nError);
                 ELSEIF bCoord = 1 -- RMTMATRIX_COORD_CYL
                   THEN
                        CALL call_RMTObject_Validate_Coord_Cyl (SBO_CLASS_RMTOBJECT, twRMTObjectIx, 0, dA, dB, dC, nError);
                 ELSEIF bCoord = 0 -- RMTMATRIX_COORD_GEO
                   THEN
                        CALL call_RMTObject_Validate_Coord_Geo (SBO_CLASS_RMTOBJECT, twRMTObjectIx, 0, dA, dB, dC, nError);
                   ELSE 
                        CALL call_Error (99, 'bCoord is invalid', nError);
                 END IF ;
        END IF ;

            IF nError = 0
          THEN
                   CALL call_RMTObject_Event_RMTObject_Open (twRMTObjectIx, Name_wsRMTObjectId, Type_bType, Type_bSubtype, Type_bFiction, Owner_twRPersonaIx, Resource_qwResource, Resource_sName, Resource_sReference, Transform_Position_dX, Transform_Position_dY, Transform_Position_dZ, Transform_Rotation_dX, Transform_Rotation_dY, Transform_Rotation_dZ, Transform_Rotation_dW, Transform_Scale_dX, Transform_Scale_dY, Transform_Scale_dZ, Bound_dX, Bound_dY, Bound_dZ, Properties_bLockToGround, Properties_bYouth, Properties_bAdult, Properties_bAvatar, twRMTObjectIx_Open, bError);
                     IF bError = 0
                   THEN
                              IF bCoord = 3 -- RMTMATRIX_COORD_NUL
                            THEN
                                 CALL call_RMTMatrix_Nul (SBO_CLASS_RMTOBJECT, twRMTObjectIx, twRMTObjectIx_Open, Transform_Position_dX, Transform_Position_dY, Transform_Position_dZ, Transform_Rotation_dX, Transform_Rotation_dY, Transform_Rotation_dZ, Transform_Rotation_dW, Transform_Scale_dX, Transform_Scale_dY, Transform_Scale_dZ);
                          ELSEIF bCoord = 2 -- RMTMATRIX_COORD_CAR
                            THEN
                                 CALL call_RMTMatrix_Car (twRMTObjectIx_Open, dA, dB, dC);
                          ELSEIF bCoord = 1 -- RMTMATRIX_COORD_CYL
                            THEN
                                 CALL call_RMTMatrix_Cyl (twRMTObjectIx_Open, dA, dB, dC);
                          ELSEIF bCoord = 0 -- RMTMATRIX_COORD_GEO
                            THEN
                                 CALL call_RMTMatrix_Geo (twRMTObjectIx_Open, dA, dB, dC);
                          END IF ;

                            CALL call_RMTMatrix_Relative (SBO_CLASS_RMTOBJECT, twRMTObjectIx, twRMTObjectIx_Open);

                          SELECT twRMTObjectIx_Open AS twRMTObject;
   
                             SET bCommit = 1;
                   ELSE 
                            CALL call_Error (-1, 'Failed to insert RMTObject', nError);
                 END IF ;
        END IF ;
       
            IF bCommit = 1
          THEN
                    SET bCommit = 0;
                 
                   CALL call_RMTObject_Log (RMTOBJECT_OP_RMTOBJECT_OPEN, sIPAddress, twRPersonaIx, twRMTObjectIx, bError);
                     IF bError = 0
                   THEN
                            CALL call_Event_Push (bError);
                              IF bError = 0
                            THEN
                                      SET bCommit = 1;
                            ELSE
                                     CALL call_Error (-9, 'Failed to push events', nError);
                          END IF ;
                   ELSE
                            CALL call_Error (-8, 'Failed to log action', nError);
                 END IF ;
        END IF ;

            IF bCommit = 0
          THEN
                 SELECT dwError, sError FROM Error;

               ROLLBACK ;
          ELSE
                 COMMIT ;
        END IF ;

          DROP TEMPORARY TABLE Error;
          DROP TEMPORARY TABLE Event;

           SET nResult = bCommit - 1 - nError;
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                          MVD_RP1_Map : set_RMTObject_Transform.sql                                         ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                              Copyright 2023-2025 Metaversal Corporation. All rights reserved.                              ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE set_RMTObject_Transform
(
   IN    sIPAddress                    VARCHAR (16),
   IN    twRPersonaIx                  BIGINT,
   IN    twRMTObjectIx                 BIGINT,
   IN    Transform_Position_dX         DOUBLE,
   IN    Transform_Position_dY         DOUBLE,
   IN    Transform_Position_dZ         DOUBLE,
   IN    Transform_Rotation_dX         DOUBLE,
   IN    Transform_Rotation_dY         DOUBLE,
   IN    Transform_Rotation_dZ         DOUBLE,
   IN    Transform_Rotation_dW         DOUBLE,
   IN    Transform_Scale_dX            DOUBLE,
   IN    Transform_Scale_dY            DOUBLE,
   IN    Transform_Scale_dZ            DOUBLE,
   IN    bCoord                        TINYINT UNSIGNED,
   IN    dA                            DOUBLE,
   IN    dB                            DOUBLE,
   IN    dC                            DOUBLE,
   OUT   nResult                       INT
)
BEGIN
       DECLARE RMTOBJECT_OP_TRANSFORM                     INT DEFAULT 5;
       DECLARE RMTMATRIX_COORD_NUL                        INT DEFAULT 0;
       DECLARE RMTMATRIX_COORD_CAR                        INT DEFAULT 1;
       DECLARE RMTMATRIX_COORD_CYL                        INT DEFAULT 2;
       DECLARE RMTMATRIX_COORD_GEO                        INT DEFAULT 3;

       DECLARE nError  INT DEFAULT 0;
       DECLARE bCommit INT DEFAULT 0;
       DECLARE bError  INT;

       DECLARE ObjectHead_Parent_wClass     SMALLINT;
       DECLARE ObjectHead_Parent_twObjectIx BIGINT;

            -- Create the temp Error table
        CREATE TEMPORARY TABLE Error
               (
                  nOrder                        INT             NOT NULL AUTO_INCREMENT PRIMARY KEY,
                  dwError                       INT             NOT NULL,
                  sError                        VARCHAR (255)   NOT NULL
               );

            -- Create the temp Event table
        CREATE TEMPORARY TABLE Event
               (
                  nOrder                        INT             NOT NULL AUTO_INCREMENT PRIMARY KEY,
                  sType                         VARCHAR (50)    NOT NULL,
                  Self_wClass                   SMALLINT        NOT NULL,
                  Self_twObjectIx               BIGINT          NOT NULL,
                  Child_wClass                  SMALLINT        NOT NULL,
                  Child_twObjectIx              BIGINT          NOT NULL,
                  wFlags                        SMALLINT        NOT NULL,
                  twEventIz                     BIGINT          NOT NULL,
                  sJSON_Object                  TEXT            NOT NULL,
                  sJSON_Child                   TEXT            NOT NULL,
                  sJSON_Change                  TEXT            NOT NULL
               );

           SET twRPersonaIx  = IFNULL (twRPersonaIx,  0);
           SET twRMTObjectIx = IFNULL (twRMTObjectIx, 0);

         START TRANSACTION;

          CALL call_RMTObject_Validate (twRPersonaIx, twRMTObjectIx, ObjectHead_Parent_wClass, ObjectHead_Parent_twObjectIx, nError);
            IF nError = 0
          THEN
                     IF bCoord = 3 -- RMTMATRIX_COORD_NUL
                   THEN
                        CALL call_RMTObject_Validate_Coord_Nul (ObjectHead_Parent_wClass, ObjectHead_Parent_twObjectIx, twRMTObjectIx, Transform_Position_dX, Transform_Position_dY, Transform_Position_dZ, Transform_Rotation_dX, Transform_Rotation_dY, Transform_Rotation_dZ, Transform_Rotation_dW, Transform_Scale_dX, Transform_Scale_dY, Transform_Scale_dZ, nError);
                 ELSEIF bCoord = 2 -- RMTMATRIX_COORD_CAR
                   THEN
                        CALL call_RMTObject_Validate_Coord_Car (ObjectHead_Parent_wClass, ObjectHead_Parent_twObjectIx, twRMTObjectIx, dA, dB, dC, nError);
                 ELSEIF bCoord = 1 -- RMTMATRIX_COORD_CYL
                   THEN
                        CALL call_RMTObject_Validate_Coord_Cyl (ObjectHead_Parent_wClass, ObjectHead_Parent_twObjectIx, twRMTObjectIx, dA, dB, dC, nError);
                 ELSEIF bCoord = 0 -- RMTMATRIX_COORD_GEO
                   THEN
                        CALL call_RMTObject_Validate_Coord_Geo (ObjectHead_Parent_wClass, ObjectHead_Parent_twObjectIx, twRMTObjectIx, dA, dB, dC, nError);
                   ELSE 
                        CALL call_Error (99, 'bCoord is invalid', nError);
                 END IF ;
        END IF ;

            IF nError = 0
          THEN
                   CALL call_RMTObject_Event_Transform(twRMTObjectIx, Transform_Position_dX, Transform_Position_dY, Transform_Position_dZ, Transform_Rotation_dX, Transform_Rotation_dY, Transform_Rotation_dZ, Transform_Rotation_dW, Transform_Scale_dX, Transform_Scale_dY, Transform_Scale_dZ, bError);
                     IF bError = 0
                   THEN
                          DELETE FROM RMTMatrix
                           WHERE bnMatrix = twRMTObjectIx
                              OR bnMatrix = 0 - twRMTObjectIx;

                          -- SET nCount += @@ROWCOUNT -- 2

                          DELETE FROM RMTSubsurface
                           WHERE twRMTObjectIx = twRMTObjectIx;

                          -- SET nCount += @@ROWCOUNT -- 1

                          -- assume these succeeded for now

                              IF bCoord = 3 -- RMTMATRIX_COORD_NUL
                            THEN
                                 CALL call_RMTMatrix_Nul(ObjectHead_Parent_wClass, ObjectHead_Parent_twObjectIx, twRMTObjectIx, Transform_Position_dX, Transform_Position_dY, Transform_Position_dZ, Transform_Rotation_dX, Transform_Rotation_dY, Transform_Rotation_dZ, Transform_Rotation_dW, Transform_Scale_dX, Transform_Scale_dY, Transform_Scale_dZ);
                          ELSEIF bCoord = 2 -- RMTMATRIX_COORD_CAR
                            THEN
                                 CALL call_RMTMatrix_Car(twRMTObjectIx, dA, dB, dC);
                          ELSEIF bCoord = 1 -- RMTMATRIX_COORD_CYL
                            THEN
                                 CALL call_RMTMatrix_Cyl(twRMTObjectIx, dA, dB, dC);
                          ELSEIF bCoord = 0 -- RMTMATRIX_COORD_GEO
                            THEN
                                 CALL call_RMTMatrix_Geo(twRMTObjectIx, dA, dB, dC);
                          END IF ;

                            CALL call_RMTMatrix_Relative(ObjectHead_Parent_wClass, ObjectHead_Parent_twObjectIx, twRMTObjectIx);

                             SET bCommit = 1;
                   ELSE 
                            CALL call_Error (-1, 'Failed to update RMTObject', nError);
                 END IF ;
        END IF ;
       
            IF bCommit = 1
          THEN
                    SET bCommit = 0;
                 
                   CALL call_RMTObject_Log (RMTOBJECT_OP_TRANSFORM, sIPAddress, twRPersonaIx, twRMTObjectIx, bError);
                     IF bError = 0
                   THEN
                            CALL call_Event_Push (bError);
                              IF bError = 0
                            THEN
                                      SET bCommit = 1;
                            ELSE
                                     CALL call_Error (-9, 'Failed to push events', nError);
                          END IF ;
                   ELSE
                            CALL call_Error (-8, 'Failed to log action', nError);
                 END IF ;
        END IF ;

            IF bCommit = 0
          THEN
                 SELECT dwError, sError FROM Error;

               ROLLBACK ;
          ELSE
                 COMMIT ;
        END IF ;

          DROP TEMPORARY TABLE Error;
          DROP TEMPORARY TABLE Event;

           SET nResult = bCommit - 1 - nError;
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                             MVD_RP1_Map : set_RMTObject_Type.sql                                           ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                              Copyright 2023-2025 Metaversal Corporation. All rights reserved.                              ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE set_RMTObject_Type
(
   IN    sIPAddress                    VARCHAR (16),
   IN    twRPersonaIx                  BIGINT,
   IN    twRMTObjectIx                 BIGINT,
   IN    Type_bType                    TINYINT UNSIGNED,
   IN    Type_bSubtype                 TINYINT UNSIGNED,
   IN    Type_bFiction                 TINYINT UNSIGNED,
   OUT   nResult                       INT
)
BEGIN
       DECLARE RMTOBJECT_OP_TYPE                          INT DEFAULT 2;

       DECLARE nError  INT DEFAULT 0;
       DECLARE bCommit INT DEFAULT 0;
       DECLARE bError  INT;

       DECLARE ObjectHead_Parent_wClass     SMALLINT;
       DECLARE ObjectHead_Parent_twObjectIx BIGINT;

            -- Create the temp Error table
        CREATE TEMPORARY TABLE Error
               (
                  nOrder                        INT             NOT NULL AUTO_INCREMENT PRIMARY KEY,
                  dwError                       INT             NOT NULL,
                  sError                        VARCHAR (255)   NOT NULL
               );

            -- Create the temp Event table
        CREATE TEMPORARY TABLE Event
               (
                  nOrder                        INT             NOT NULL AUTO_INCREMENT PRIMARY KEY,
                  sType                         VARCHAR (50)    NOT NULL,
                  Self_wClass                   SMALLINT        NOT NULL,
                  Self_twObjectIx               BIGINT          NOT NULL,
                  Child_wClass                  SMALLINT        NOT NULL,
                  Child_twObjectIx              BIGINT          NOT NULL,
                  wFlags                        SMALLINT        NOT NULL,
                  twEventIz                     BIGINT          NOT NULL,
                  sJSON_Object                  TEXT            NOT NULL,
                  sJSON_Child                   TEXT            NOT NULL,
                  sJSON_Change                  TEXT            NOT NULL
               );

           SET twRPersonaIx  = IFNULL (twRPersonaIx,  0);
           SET twRMTObjectIx = IFNULL (twRMTObjectIx, 0);

         START TRANSACTION;

          CALL call_RMTObject_Validate (twRPersonaIx, twRMTObjectIx, ObjectHead_Parent_wClass, ObjectHead_Parent_twObjectIx, nError);
            IF nError = 0
          THEN
                   CALL call_RMTObject_Validate_Type (twRMTObjectIx, Type_bType, Type_bSubtype, Type_bFiction, nError);
        END IF ;

            IF nError = 0
          THEN
                   CALL call_RMTObject_Event_Type (twRMTObjectIx, Type_bType, Type_bSubtype, Type_bFiction, bError);
                     IF bError = 0
                   THEN
                             SET bCommit = 1;
                   ELSE 
                            CALL call_Error (-1, 'Failed to update RMTObject', nError);
                 END IF ;
        END IF ;
       
            IF bCommit = 1
          THEN
                    SET bCommit = 0;
                 
                   CALL call_RMTObject_Log (RMTOBJECT_OP_TYPE, sIPAddress, twRPersonaIx, twRMTObjectIx, bError);
                     IF bError = 0
                   THEN
                            CALL call_Event_Push (bError);
                              IF bError = 0
                            THEN
                                      SET bCommit = 1;
                            ELSE
                                     CALL call_Error (-9, 'Failed to push events', nError);
                          END IF ;
                   ELSE
                            CALL call_Error (-8, 'Failed to log action', nError);
                 END IF ;
        END IF ;

            IF bCommit = 0
          THEN
                 SELECT dwError, sError FROM Error;

               ROLLBACK ;
          ELSE
                 COMMIT ;
        END IF ;

          DROP TEMPORARY TABLE Error;
          DROP TEMPORARY TABLE Event;

           SET nResult = bCommit - 1 - nError;
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                           MVD_RP1_Map : call_RMCObject_Event.sql                                           ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2025 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE call_RMCObject_Event
(
   IN    twRMCObjectIx                 BIGINT,
   OUT   twEventIz                     BIGINT,
   OUT   bError                        INT
)
BEGIN
        SELECT ObjectHead_twEventIz
          INTO twEventIz
          FROM RMCObject
         WHERE ObjectHead_Self_twObjectIx = twRMCObjectIx;

            -- Success will be tested on the update below

        UPDATE RMCObject
           SET ObjectHead_twEventIz = ObjectHead_twEventIz + 1
         WHERE ObjectHead_Self_twObjectIx = twRMCObjectIx;

           SET bError = IF (ROW_COUNT () = 1, 0, 1);
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                        MVD_RP1_Map : call_RMCObject_Event_Bound.sql                                        ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2023 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE call_RMCObject_Event_Bound
(
   IN    twRMCObjectIx                 BIGINT,
   IN    Bound_dX                      DOUBLE,
   IN    Bound_dY                      DOUBLE,
   IN    Bound_dZ                      DOUBLE,
   OUT   bError                        INT
)
BEGIN
       DECLARE SBO_CLASS_NULL                             INT DEFAULT 0;
       DECLARE SBO_CLASS_RMCOBJECT                        INT DEFAULT 71;

       DECLARE twEventIz BIGINT;

          CALL call_RMCObject_Event (twRMCObjectIx, twEventIz, bError);
            IF bError = 0
          THEN
                 UPDATE RMCObject
                    SET Bound_dX = Bound_dX,
                        Bound_dY = Bound_dY,
                        Bound_dZ = Bound_dZ
                  WHERE ObjectHead_Self_twObjectIx = twRMCObjectIx;

                    SET bError = IF (ROW_COUNT () = 1, 0, 1);

                     IF bError = 0
                   THEN
                          INSERT INTO Event
                                 (sType, Self_wClass, Self_twObjectIx, Child_wClass, Child_twObjectIx, wFlags, twEventIz, sJSON_Object, sJSON_Child, sJSON_Change)
                          SELECT 'BOUND',

                                 SBO_CLASS_RMCOBJECT,
                                 twRMCObjectIx,
                                 SBO_CLASS_NULL,
                                 0,
                                 0,
                                 twEventIz,

                                 CONCAT
                                 (
                                   '{ ',
                                     '"pBound": ',        Format_Bound
                                                          (
                                                             Bound_dX,
                                                             Bound_dY,
                                                             Bound_dZ
                                                          ),
                                  ' }'
                                 ),

                                 '{ }',

                                 '{ }';

                             SET bError = IF (ROW_COUNT () = 1, 0, 1);
                 END IF ;
        END IF ;
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                         MVD_RP1_Map : call_RMCObject_Event_Name.sql                                        ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2023 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE call_RMCObject_Event_Name
(
   IN    twRMCObjectIx                 BIGINT,
   IN    Name_wsRMCObjectId            VARCHAR (48),
   OUT   bError                        INT
)
BEGIN
       DECLARE SBO_CLASS_NULL                             INT DEFAULT 0;
       DECLARE SBO_CLASS_RMCOBJECT                        INT DEFAULT 71;

       DECLARE twEventIz BIGINT;

          CALL call_RMCObject_Event (twRMCObjectIx, twEventIz, bError);
            IF bError = 0
          THEN
                 UPDATE RMCObject
                    SET Name_wsRMCObjectId = Name_wsRMCObjectId
                  WHERE ObjectHead_Self_twObjectIx = twRMCObjectIx;

                    SET bError = IF (ROW_COUNT () = 1, 0, 1);

                     IF bError = 0
                   THEN
                          INSERT INTO Event
                                 (sType, Self_wClass, Self_twObjectIx, Child_wClass, Child_twObjectIx, wFlags, twEventIz, sJSON_Object, sJSON_Child, sJSON_Change)
                          SELECT 'NAME',

                                 SBO_CLASS_RMCOBJECT,
                                 twRMCObjectIx,
                                 SBO_CLASS_NULL,
                                 0,
                                 0,
                                 twEventIz,

                                 CONCAT
                                 (
                                   '{ ',
                                     '"pName": ',         Format_Name_C
                                                          (
                                                             Name_wsRMCObjectId
                                                          ),
                                  ' }'
                                 ),

                                 '{ }',

                                 '{ }';

                             SET bError = IF (ROW_COUNT () = 1, 0, 1);
                 END IF ;
        END IF ;
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                      MVD_RP1_Map : call_RMCObject_Event_Orbit_Spin.sql                                     ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2023 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE call_RMCObject_Event_Orbit_Spin
(
   IN    twRMCObjectIx                 BIGINT,
   IN    Orbit_Spin_tmPeriod           DOUBLE,
   IN    Orbit_Spin_tmStart            DOUBLE,
   IN    Orbit_Spin_dA                 DOUBLE,
   IN    Orbit_Spin_dB                 DOUBLE,
   OUT   bError                        INT
)
BEGIN
       DECLARE SBO_CLASS_NULL                             INT DEFAULT 0;
       DECLARE SBO_CLASS_RMCOBJECT                        INT DEFAULT 71;

       DECLARE twEventIz BIGINT;

          CALL call_RMCObject_Event (twRMCObjectIx, twEventIz, bError);
            IF bError = 0
          THEN
                 UPDATE RMCObject
                    SET Orbit_Spin_tmPeriod = Orbit_Spin_tmPeriod,
                        Orbit_Spin_tmStart  = Orbit_Spin_tmStart,
                        Orbit_Spin_dA       = Orbit_Spin_dA,
                        Orbit_Spin_dB       = Orbit_Spin_dB
                  WHERE ObjectHead_Self_twObjectIx = twRMCObjectIx;
  
                    SET bError = IF (ROW_COUNT () = 1, 0, 1);
  
                     IF bError = 0
                   THEN
                          INSERT INTO Event
                                 (sType, Self_wClass, Self_twObjectIx, Child_wClass, Child_twObjectIx, wFlags, twEventIz, sJSON_Object, sJSON_Child, sJSON_Change)
                          SELECT 'ORBIT_SPIN',
    
                                 SBO_CLASS_RMCOBJECT,
                                 twRMCObjectIx,
                                 SBO_CLASS_NULL,
                                 0,
                                 0,
                                 twEventIz,
    
                                 CONCAT
                                 (
                                   '{ ',
                                     '"pOrbit_Spin": ',   Format_Orbit_Spin
                                                          (
                                                             Orbit_Spin_tmPeriod,
                                                             Orbit_Spin_tmStart,
                                                             Orbit_Spin_dA,
                                                             Orbit_Spin_dB
                                                          ),
                                  ' }'
                                 ),
    
                                 '{ }',
    
                                 '{ }';
    
                             SET bError = IF (ROW_COUNT () = 1, 0, 1);
                 END IF ;
        END IF ;
END$$

DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                        MVD_RP1_Map : call_RMCObject_Event_Owner.sql                                        ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2023 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE call_RMCObject_Event_Owner
(
   IN    twRMCObjectIx                 BIGINT,
   IN    Owner_twRPersonaIx            BIGINT,
   OUT   bError                        INT
)
BEGIN
       DECLARE SBO_CLASS_NULL                             INT DEFAULT 0;
       DECLARE SBO_CLASS_RMCOBJECT                        INT DEFAULT 71;

       DECLARE twEventIz BIGINT;

          CALL call_RMCObject_Event (twRMCObjectIx, twEventIz, bError);
            IF bError = 0
          THEN
                 UPDATE RMCObject
                    SET Owner_twRPersonaIx = Owner_twRPersonaIx
                  WHERE ObjectHead_Self_twObjectIx = twRMCObjectIx;

                    SET bError = IF (ROW_COUNT () = 1, 0, 1);

                     IF bError = 0
                   THEN
                          INSERT INTO Event
                                 (sType, Self_wClass, Self_twObjectIx, Child_wClass, Child_twObjectIx, wFlags, twEventIz, sJSON_Object, sJSON_Child, sJSON_Change)
                          SELECT 'OWNER',

                                 SBO_CLASS_RMCOBJECT,
                                 twRMCObjectIx,
                                 SBO_CLASS_NULL,
                                 0,
                                 0,
                                 twEventIz,

                                 CONCAT
                                 (
                                   '{ ',
                                     '"pOwner": ',        Format_Owner
                                                          (
                                                             Owner_twRPersonaIx
                                                          ),
                                  ' }'
                                 ),

                                 '{ }',

                                 '{ }';

                             SET bError = IF (ROW_COUNT () = 1, 0, 1);
                 END IF ;
        END IF ;
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                      MVD_RP1_Map : call_RMCObject_Event_Properties.sql                                     ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2023 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE call_RMCObject_Event_Properties
(
   IN    twRMCObjectIx                 BIGINT,
   IN    Properties_fMass              FLOAT,
   IN    Properties_fGravity           FLOAT,
   IN    Properties_fColor             FLOAT,
   IN    Properties_fBrightness        FLOAT,
   IN    Properties_fReflectivity      FLOAT,
   OUT   bError                        INT
)
BEGIN
       DECLARE SBO_CLASS_NULL                             INT DEFAULT 0;
       DECLARE SBO_CLASS_RMCOBJECT                        INT DEFAULT 71;

       DECLARE twEventIz BIGINT;

          CALL call_RMCObject_Event (twRMCObjectIx, twEventIz, bError);
            IF bError = 0
          THEN
                 UPDATE RMCObject
                    SET Properties_fMass         = Properties_fMass,
                        Properties_fGravity      = Properties_fGravity,
                        Properties_fColor        = Properties_fColor,
                        Properties_fBrightness   = Properties_fBrightness,
                        Properties_fReflectivity = Properties_fReflectivity
                  WHERE ObjectHead_Self_twObjectIx = twRMCObjectIx;

                    SET bError = IF (ROW_COUNT () = 1, 0, 1);

                     IF bError = 0
                   THEN
                          INSERT INTO Event
                                 (sType, Self_wClass, Self_twObjectIx, Child_wClass, Child_twObjectIx, wFlags, twEventIz, sJSON_Object, sJSON_Child, sJSON_Change)
                          SELECT 'PROPERTIES',

                                 SBO_CLASS_RMCOBJECT,
                                 twRMCObjectIx,
                                 SBO_CLASS_NULL,
                                 0,
                                 0,
                                 twEventIz,

                                 CONCAT
                                 (
                                   '{ ',
                                     '"pProperties": ',   Format_Properties_C
                                                          (
                                                             Properties_fMass,
                                                             Properties_fGravity,
                                                             Properties_fColor,
                                                             Properties_fBrightness,
                                                             Properties_fReflectivity
                                                          ),
                                  ' }'
                                 ),

                                 '{ }',

                                 '{ }';

                             SET bError = IF (ROW_COUNT () = 1, 0, 1);
                 END IF ;
        END IF ;
END$$

DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                       MVD_RP1_Map : call_RMCObject_Event_Resource.sql                                      ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2023 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE call_RMCObject_Event_Resource
(
   IN    twRMCObjectIx                 BIGINT,
   IN    Resource_qwResource           BIGINT,
   IN    Resource_sName                VARCHAR (48),
   IN    Resource_sReference           VARCHAR (128),
   OUT   bError                        INT
)
BEGIN
       DECLARE SBO_CLASS_NULL                             INT DEFAULT 0;
       DECLARE SBO_CLASS_RMCOBJECT                        INT DEFAULT 71;

       DECLARE twEventIz BIGINT;

          CALL call_RMCObject_Event (twRMCObjectIx, twEventIz, bError);
            IF bError = 0
          THEN
                 UPDATE RMCObject
                    SET Resource_qwResource = Resource_qwResource,
                        Resource_sName      = Resource_sName,
                        Resource_sReference = Resource_sReference       
                  WHERE ObjectHead_Self_twObjectIx = twRMCObjectIx;

                    SET bError = IF (ROW_COUNT () = 1, 0, 1);

                     IF bError = 0
                   THEN
                          INSERT INTO Event
                                 (sType, Self_wClass, Self_twObjectIx, Child_wClass, Child_twObjectIx, wFlags, twEventIz, sJSON_Object, sJSON_Child, sJSON_Change)
                          SELECT 'RESOURCE',

                                 SBO_CLASS_RMCOBJECT,
                                 twRMCObjectIx,
                                 SBO_CLASS_NULL,
                                 0,
                                 0,
                                 twEventIz,

                                 CONCAT
                                 (
                                   '{ ',
                                     '"pResource": ',     Format_Resource
                                                          (
                                                             Resource_qwResource,
                                                             Resource_sName,
                                                             Resource_sReference
                                                          ),
                                  ' }'
                                 ),

                                 '{ }',

                                 '{ }';

                             SET bError = IF (ROW_COUNT () = 1, 0, 1);
                 END IF ;
        END IF ;
  END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                   MVD_RP1_Map : call_RMCObject_Event_RMCObject_Close.sql                                   ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2023 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE call_RMCObject_Event_RMCObject_Close
(
   IN    twRMCObjectIx                 BIGINT,
   IN    twRMCObjectIx_Close           BIGINT,
   OUT   bError                        INT
)
BEGIN
       DECLARE SBO_CLASS_RMCOBJECT                        INT DEFAULT 71;
       DECLARE SBA_SUBSCRIBE_REFRESH_EVENT_EX_FLAG_CLOSE  INT DEFAULT 0x02;

       DECLARE twEventIz BIGINT;

          CALL call_RMCObject_Event (twRMCObjectIx, twEventIz, bError);
            IF bError = 0
          THEN
                 DELETE FROM RMCObject                                        -- we actually want to delete the entire tree - all the way down to the pobject!
                  WHERE ObjectHead_Self_twObjectIx = twRMCObjectIx_Close;

                    SET bError = IF (ROW_COUNT () = 1, 0, 1);

                     IF bError = 0
                   THEN
                          INSERT INTO Event
                                 (sType, Self_wClass, Self_twObjectIx, Child_wClass, Child_twObjectIx, wFlags, twEventIz, sJSON_Object, sJSON_Child, sJSON_Change)
                          SELECT 'RMCOBJECT_CLOSE',

                                 SBO_CLASS_RMCOBJECT,
                                 twRMCObjectIx,
                                 SBO_CLASS_RMCOBJECT,
                                 twRMCObjectIx_Close,
                                 SBA_SUBSCRIBE_REFRESH_EVENT_EX_FLAG_CLOSE,
                                 twEventIz,

                                 '{ }',

                                 '{ }',

                                 '{ }';

                             SET bError = IF (ROW_COUNT () = 1, 0, 1);
                 END IF ;
        END IF ;
END$$

DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                    MVD_RP1_Map : call_RMCObject_Event_RMCObject_Open.sql                                   ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2023 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE call_RMCObject_Event_RMCObject_Open
(
   IN    twRMCObjectIx                 BIGINT,
   IN    Name_wsRMCObjectId            VARCHAR (48),
   IN    Type_bType                    TINYINT UNSIGNED,
   IN    Type_bSubtype                 TINYINT UNSIGNED,
   IN    Type_bFiction                 TINYINT UNSIGNED,
   IN    Owner_twRPersonaIx            BIGINT,
   IN    Resource_qwResource           BIGINT,
   IN    Resource_sName                VARCHAR (48),
   IN    Resource_sReference           VARCHAR (128),
   IN    Transform_Position_dX         DOUBLE,
   IN    Transform_Position_dY         DOUBLE,
   IN    Transform_Position_dZ         DOUBLE,
   IN    Transform_Rotation_dX         DOUBLE,
   IN    Transform_Rotation_dY         DOUBLE,
   IN    Transform_Rotation_dZ         DOUBLE,
   IN    Transform_Rotation_dW         DOUBLE,
   IN    Transform_Scale_dX            DOUBLE,
   IN    Transform_Scale_dY            DOUBLE,
   IN    Transform_Scale_dZ            DOUBLE,
   IN    Orbit_Spin_tmPeriod           BIGINT,
   IN    Orbit_Spin_tmStart            BIGINT,
   IN    Orbit_Spin_dA                 DOUBLE,
   IN    Orbit_Spin_dB                 DOUBLE,
   IN    Bound_dX                      DOUBLE,
   IN    Bound_dY                      DOUBLE,
   IN    Bound_dZ                      DOUBLE,
   IN    Properties_fMass              FLOAT,
   IN    Properties_fGravity           FLOAT,
   IN    Properties_fColor             FLOAT,
   IN    Properties_fBrightness        FLOAT,
   IN    Properties_fReflectivity      FLOAT,
   OUT   twRMCObjectIx_Open            BIGINT,
   OUT   bError                        INT
)
BEGIN
       DECLARE SBO_CLASS_RMCOBJECT                        INT DEFAULT 71;
       DECLARE SBA_SUBSCRIBE_REFRESH_EVENT_EX_FLAG_OPEN   INT DEFAULT 0x01;

       DECLARE twEventIz BIGINT;

          CALL call_RMCObject_Event (twRMCObjectIx, twEventIz, bError);
            IF bError = 0
          THEN
                 INSERT INTO RMCObject
                        (ObjectHead_Parent_wClass, ObjectHead_Parent_twObjectIx, ObjectHead_Self_wClass, ObjectHead_twEventIz, ObjectHead_wFlags, Name_wsRMCObjectId, Type_bType, Type_bSubtype, Type_bFiction, Owner_twRPersonaIx, Resource_qwResource, Resource_sName, Resource_sReference, Transform_Position_dX, Transform_Position_dY, Transform_Position_dZ, Transform_Rotation_dX, Transform_Rotation_dY, Transform_Rotation_dZ, Transform_Rotation_dW, Transform_Scale_dX, Transform_Scale_dY, Transform_Scale_dZ, Orbit_Spin_tmPeriod, Orbit_Spin_tmStart, Orbit_Spin_dA, Orbit_Spin_dB, Bound_dX, Bound_dY, Bound_dZ, Properties_fMass, Properties_fGravity, Properties_fColor, Properties_fBrightness, Properties_fReflectivity)
                 VALUES (SBO_CLASS_RMCOBJECT,      twRMCObjectIx,                SBO_CLASS_RMCOBJECT,    0,                    32,                Name_wsRMCObjectId, Type_bType, Type_bSubtype, Type_bFiction, Owner_twRPersonaIx, Resource_qwResource, Resource_sName, Resource_sReference, Transform_Position_dX, Transform_Position_dY, Transform_Position_dZ, Transform_Rotation_dX, Transform_Rotation_dY, Transform_Rotation_dZ, Transform_Rotation_dW, Transform_Scale_dX, Transform_Scale_dY, Transform_Scale_dZ, Orbit_Spin_tmPeriod, Orbit_Spin_tmStart, Orbit_Spin_dA, Orbit_Spin_dB, Bound_dX, Bound_dY, Bound_dZ, Properties_fMass, Properties_fGravity, Properties_fColor, Properties_fBrightness, Properties_fReflectivity);
  
                    SET bError = IF (ROW_COUNT () = 1, 0, 1);
  
                     IF bError = 0
                   THEN
                             SET twRMCObjectIx_Open = LAST_INSERT_ID ();
  
                          INSERT INTO Event
                                 (sType, Self_wClass, Self_twObjectIx, Child_wClass, Child_twObjectIx, wFlags, twEventIz, sJSON_Object, sJSON_Child, sJSON_Change)
                          SELECT 'RMCOBJECT_OPEN',
    
                                 SBO_CLASS_RMCOBJECT,
                                 twRMCObjectIx,
                                 SBO_CLASS_RMCOBJECT,
                                 twRMCObjectIx_Open,
                                 SBA_SUBSCRIBE_REFRESH_EVENT_EX_FLAG_OPEN,
                                 twEventIz,
    
                                 '{ }',
    
                                 CONCAT
                                 (
                                   '{ ',
                                     '"pName": ',         Format_Name_C
                                                          (
                                                             Name_wsRMCObjectId
                                                          ),
                                   ', "pType": ',         Format_Type_C
                                                          (
                                                             Type_bType,
                                                             Type_bSubtype,
                                                             Type_bFiction
                                                          ),
                                   ', "pOwner": ',        Format_Owner
                                                          (
                                                             Owner_twRPersonaIx
                                                          ),
                                   ', "pResource": ',     Format_Resource
                                                          (
                                                             Resource_qwResource,
                                                             Resource_sName,
                                                             Resource_sReference
                                                          ),
                                   ', "pTransform": ',    Format_Transform
                                                          (
                                                             Transform_Position_dX,
                                                             Transform_Position_dY,
                                                             Transform_Position_dZ,
                                                             Transform_Rotation_dX,
                                                             Transform_Rotation_dY,
                                                             Transform_Rotation_dZ,
                                                             Transform_Rotation_dW,
                                                             Transform_Scale_dX,
                                                             Transform_Scale_dY,
                                                             Transform_Scale_dZ
                                                          ),
                                   ', "pOrbit_Spin": ',   Format_Orbit_Spin
                                                          (
                                                             Orbit_Spin_tmPeriod,
                                                             Orbit_Spin_tmStart,
                                                             Orbit_Spin_dA,
                                                             Orbit_Spin_dB
                                                          ),
                                   ', "pBound": ',        Format_Bound
                                                          (
                                                             Bound_dX,
                                                             Bound_dY,
                                                             Bound_dZ
                                                          ),
                                   ', "pProperties": ',   Format_Properties_C
                                                          (
                                                             Properties_fMass,
                                                             Properties_fGravity,
                                                             Properties_fColor,
                                                             Properties_fBrightness,
                                                             Properties_fReflectivity
                                                          ),
                                  ' }'
                                 ),
    
                                 '{ }';
    
                             SET bError = IF (ROW_COUNT () = 1, 0, 1);
                   END IF ;
        END IF ;
END$$

DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                   MVD_RP1_Map : call_RMCObject_Event_RMTObject_Close.sql                                   ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2023 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE call_RMCObject_Event_RMTObject_Close
(
   IN    twRMCObjectIx                 BIGINT,
   IN    twRMTObjectIx_Close           BIGINT,
   OUT   bError                        INT
)
BEGIN
       DECLARE SBO_CLASS_RMCOBJECT                        INT DEFAULT 71;
       DECLARE SBO_CLASS_RMTOBJECT                        INT DEFAULT 72;
       DECLARE SBA_SUBSCRIBE_REFRESH_EVENT_EX_FLAG_CLOSE  INT DEFAULT 0x02;

       DECLARE twEventIz BIGINT;
       DECLARE nCount    INT DEFAULT 0;

          CALL call_RMCObject_Event (twRMCObjectIx, twEventIz, bError);
            IF bError = 0
          THEN
                 DELETE FROM RMTMatrix                                        -- we actually want to delete the entire tree - all the way down to the pobject!
                  WHERE bnMatrix = twRMTObjectIx_Close
                     OR bnMatrix = 0 - twRMTObjectIx_Close;

                    SET nCount = nCount + ROW_COUNT ();

                 DELETE FROM RMTSubsurface                                    -- we actually want to delete the entire tree - all the way down to the pobject!
                  WHERE twRMTObjectIx = twRMTObjectIx_Close;

                    SET nCount = nCount + ROW_COUNT ();

                 DELETE FROM RMTObject                                        -- we actually want to delete the entire tree - all the way down to the pobject!
                  WHERE ObjectHead_Self_twObjectIx = twRMTObjectIx_Close;

                    SET nCount = nCount + ROW_COUNT ();

                    SET bError = IF (nCount = 4, 0, 1);

                     IF bError = 0
                   THEN
                          INSERT INTO Event
                                 (sType, Self_wClass, Self_twObjectIx, Child_wClass, Child_twObjectIx, wFlags, twEventIz, sJSON_Object, sJSON_Child, sJSON_Change)
                          SELECT 'RMTOBJECT_CLOSE',

                                 SBO_CLASS_RMCOBJECT,
                                 twRMCObjectIx,
                                 SBO_CLASS_RMTOBJECT,
                                 twRMTObjectIx_Close,
                                 SBA_SUBSCRIBE_REFRESH_EVENT_EX_FLAG_CLOSE,
                                 twEventIz,

                                 '{ }',

                                 '{ }',

                                 '{ }';

                             SET bError = IF (ROW_COUNT () = 1, 0, 1);
                 END IF ;
        END IF ;
END$$

DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                    MVD_RP1_Map : call_RMCObject_Event_RMTObject_Open.sql                                   ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2023 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE call_RMCObject_Event_RMTObject_Open
(
   IN    twRMCObjectIx                 BIGINT,
   IN    Name_wsRMTObjectId            VARCHAR (48),
   IN    Type_bType                    TINYINT UNSIGNED,
   IN    Type_bSubtype                 TINYINT UNSIGNED,
   IN    Type_bFiction                 TINYINT UNSIGNED,
   IN    Owner_twRPersonaIx            BIGINT,
   IN    Resource_qwResource           BIGINT,
   IN    Resource_sName                VARCHAR (48),
   IN    Resource_sReference           VARCHAR (128),
   IN    Transform_Position_dX         DOUBLE,
   IN    Transform_Position_dY         DOUBLE,
   IN    Transform_Position_dZ         DOUBLE,
   IN    Transform_Rotation_dX         DOUBLE,
   IN    Transform_Rotation_dY         DOUBLE,
   IN    Transform_Rotation_dZ         DOUBLE,
   IN    Transform_Rotation_dW         DOUBLE,
   IN    Transform_Scale_dX            DOUBLE,
   IN    Transform_Scale_dY            DOUBLE,
   IN    Transform_Scale_dZ            DOUBLE,
   IN    Bound_dX                      DOUBLE,
   IN    Bound_dY                      DOUBLE,
   IN    Bound_dZ                      DOUBLE,
   IN    Properties_bLockToGround      TINYINT UNSIGNED,
   IN    Properties_bYouth             TINYINT UNSIGNED,
   IN    Properties_bAdult             TINYINT UNSIGNED,
   IN    Properties_bAvatar            TINYINT UNSIGNED,
   OUT   twRMTObjectIx                 BIGINT,
   OUT   bError                        INT
)
BEGIN
       DECLARE SBO_CLASS_RMCOBJECT                        INT DEFAULT 71;
       DECLARE SBO_CLASS_RMTOBJECT                        INT DEFAULT 72;
       DECLARE SBA_SUBSCRIBE_REFRESH_EVENT_EX_FLAG_OPEN   INT DEFAULT 0x01;

       DECLARE twEventIz BIGINT;

          CALL call_RMCObject_Event (twRMCObjectIx, twEventIz, bError);
            IF bError = 0
          THEN
                 INSERT INTO RMTObject
                        (ObjectHead_Parent_wClass, ObjectHead_Parent_twObjectIx, ObjectHead_Self_wClass, ObjectHead_twEventIz, ObjectHead_wFlags, Name_wsRMTObjectId, Type_bType, Type_bSubtype, Type_bFiction, Owner_twRPersonaIx, Resource_qwResource, Resource_sName, Resource_sReference, Transform_Position_dX, Transform_Position_dY, Transform_Position_dZ, Transform_Rotation_dX, Transform_Rotation_dY, Transform_Rotation_dZ, Transform_Rotation_dW, Transform_Scale_dX, Transform_Scale_dY, Transform_Scale_dZ, Bound_dX, Bound_dY, Bound_dZ, Properties_bLockToGround, Properties_bYouth, Properties_bAdult, Properties_bAvatar)
                 VALUES (SBO_CLASS_RMCOBJECT,      twRMCObjectIx,                SBO_CLASS_RMTOBJECT,    0,                    32,                Name_wsRMTObjectId, Type_bType, Type_bSubtype, Type_bFiction, Owner_twRPersonaIx, Resource_qwResource, Resource_sName, Resource_sReference, Transform_Position_dX, Transform_Position_dY, Transform_Position_dZ, Transform_Rotation_dX, Transform_Rotation_dY, Transform_Rotation_dZ, Transform_Rotation_dW, Transform_Scale_dX, Transform_Scale_dY, Transform_Scale_dZ, Bound_dX, Bound_dY, Bound_dZ, Properties_bLockToGround, Properties_bYouth, Properties_bAdult, Properties_bAvatar);
  
                    SET bError = IF (ROW_COUNT () = 1, 0, 1);
  
                     IF bError = 0
                   THEN
                             SET twRMTObjectIx = LAST_INSERT_ID ();
  
                          INSERT INTO Event
                                 (sType, Self_wClass, Self_twObjectIx, Child_wClass, Child_twObjectIx, wFlags, twEventIz, sJSON_Object, sJSON_Child, sJSON_Change)
                          SELECT 'RMTOBJECT_OPEN',
    
                                 SBO_CLASS_RMCOBJECT,
                                 twRMCObjectIx,
                                 SBO_CLASS_RMTOBJECT,
                                 twRMTObjectIx,
                                 SBA_SUBSCRIBE_REFRESH_EVENT_EX_FLAG_OPEN,
                                 twEventIz,
    
                                 '{ }',
    
                                 CONCAT
                                 (
                                   '{ ',
                                     '"pName": ',         Format_Name_T
                                                          (
                                                             Name_wsRMTObjectId
                                                          ),
                                   ', "pType": ',         Format_Type_T
                                                          (
                                                             Type_bType,
                                                             Type_bSubtype,
                                                             Type_bFiction
                                                          ),
                                   ', "pOwner": ',        Format_Owner
                                                          (
                                                             Owner_twRPersonaIx
                                                          ),
                                   ', "pResource": ',     Format_Resource
                                                          (
                                                             Resource_qwResource,
                                                             Resource_sName,
                                                             Resource_sReference
                                                          ),
                                   ', "pTransform": ',    Format_Transform
                                                          (
                                                             Transform_Position_dX,
                                                             Transform_Position_dY,
                                                             Transform_Position_dZ,
                                                             Transform_Rotation_dX,
                                                             Transform_Rotation_dY,
                                                             Transform_Rotation_dZ,
                                                             Transform_Rotation_dW,
                                                             Transform_Scale_dX,
                                                             Transform_Scale_dY,
                                                             Transform_Scale_dZ
                                                          ),
                                   ', "pBound": ',        Format_Bound
                                                          (
                                                             Bound_dX,
                                                             Bound_dY,
                                                             Bound_dZ
                                                          ),
                                   ', "pProperties": ',   Format_Properties_T
                                                          (
                                                             Properties_bLockToGround,
                                                             Properties_bYouth,
                                                             Properties_bAdult,
                                                             Properties_bAvatar
                                                          ),
                                  ' }'
                                 ),
    
                                 '{ }';
    
                             SET bError = IF (ROW_COUNT () = 1, 0, 1);
                   END IF ;
          END IF ;
END$$

DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                      MVD_RP1_Map : call_RMCObject_Event_Transform.sql                                      ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2023 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE call_RMCObject_Event_Transform
(
   IN    twRMCObjectIx                 BIGINT,
   IN    Transform_Position_dX         DOUBLE,
   IN    Transform_Position_dY         DOUBLE,
   IN    Transform_Position_dZ         DOUBLE,
   IN    Transform_Rotation_dX         DOUBLE,
   IN    Transform_Rotation_dY         DOUBLE,
   IN    Transform_Rotation_dZ         DOUBLE,
   IN    Transform_Rotation_dW         DOUBLE,
   IN    Transform_Scale_dX            DOUBLE,
   IN    Transform_Scale_dY            DOUBLE,
   IN    Transform_Scale_dZ            DOUBLE,
   OUT   bError                        INT
)
BEGIN
       DECLARE SBO_CLASS_NULL                             INT DEFAULT 0;
       DECLARE SBO_CLASS_RMCOBJECT                        INT DEFAULT 71;

       DECLARE twEventIz BIGINT;

          CALL call_RMCObject_Event (twRMCObjectIx, twEventIz, bError);
            IF bError = 0
          THEN
                 UPDATE RMCObject
                    SET Transform_Position_dX = Transform_Position_dX,
                        Transform_Position_dY = Transform_Position_dY,
                        Transform_Position_dZ = Transform_Position_dZ,
                        Transform_Rotation_dX = Transform_Rotation_dX,
                        Transform_Rotation_dY = Transform_Rotation_dY,
                        Transform_Rotation_dZ = Transform_Rotation_dZ,
                        Transform_Rotation_dW = Transform_Rotation_dW,
                        Transform_Scale_dX    = Transform_Scale_dX,
                        Transform_Scale_dY    = Transform_Scale_dY,
                        Transform_Scale_dZ    = Transform_Scale_dZ
                  WHERE ObjectHead_Self_twObjectIx = twRMCObjectIx;

                    SET bError = IF (ROW_COUNT () = 1, 0, 1);

                     IF bError = 0
                   THEN
                          INSERT INTO Event
                                 (sType, Self_wClass, Self_twObjectIx, Child_wClass, Child_twObjectIx, wFlags, twEventIz, sJSON_Object, sJSON_Child, sJSON_Change)
                          SELECT 'TRANSFORM',

                                 SBO_CLASS_RMCOBJECT,
                                 twRMCObjectIx,
                                 SBO_CLASS_NULL,
                                 0,
                                 0,
                                 twEventIz,

                                 CONCAT
                                 (
                                   '{ ',
                                     '"pTransform": ',    Format_Transform
                                                          (
                                                             Transform_Position_dX,
                                                             Transform_Position_dY,
                                                             Transform_Position_dZ,
                                                             Transform_Rotation_dX,
                                                             Transform_Rotation_dY,
                                                             Transform_Rotation_dZ,
                                                             Transform_Rotation_dW,
                                                             Transform_Scale_dX,
                                                             Transform_Scale_dY,
                                                             Transform_Scale_dZ
                                                          ),
                                  ' }'
                                 ),

                                 '{ }',

                                 '{ }';

                             SET bError = IF (ROW_COUNT () = 1, 0, 1);
                 END IF ;
        END IF ;
END$$

DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                         MVD_RP1_Map : call_RMCObject_Event_Type.sql                                        ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2023 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE call_RMCObject_Event_Type
(
   IN    twRMCObjectIx                 BIGINT,
   IN    Type_bType                    TINYINT UNSIGNED,
   IN    Type_bSubtype                 TINYINT UNSIGNED,
   IN    Type_bFiction                 TINYINT UNSIGNED,
   OUT   bError                        INT
)
BEGIN
       DECLARE SBO_CLASS_NULL                             INT DEFAULT 0;
       DECLARE SBO_CLASS_RMCOBJECT                        INT DEFAULT 71;

       DECLARE twEventIz BIGINT;

          CALL call_RMCObject_Event (twRMCObjectIx, twEventIz, bError);
            IF bError = 0
          THEN
                 UPDATE RMCObject
                    SET Type_bType    = Type_bType,
                        Type_bSubtype = Type_bSubtype,
                        Type_bFiction = Type_bFiction
                  WHERE ObjectHead_Self_twObjectIx = twRMCObjectIx;

                    SET bError = IF (ROW_COUNT () = 1, 0, 1);

                     IF bError = 0
                   THEN
                          INSERT INTO Event
                                 (sType, Self_wClass, Self_twObjectIx, Child_wClass, Child_twObjectIx, wFlags, twEventIz, sJSON_Object, sJSON_Child, sJSON_Change)
                          SELECT 'TYPE',

                                 SBO_CLASS_RMCOBJECT,
                                 twRMCObjectIx,
                                 SBO_CLASS_NULL,
                                 0,
                                 0,
                                 twEventIz,

                                 CONCAT
                                 (
                                   '{ ',
                                     '"pType": ',         Format_Type_C
                                                          (
                                                             Type_bType,
                                                             Type_bSubtype,
                                                             Type_bFiction
                                                          ),
                                  ' }'
                                 ),

                                 '{ }',

                                 '{ }';

                             SET bError = IF (ROW_COUNT () = 1, 0, 1);
                 END IF ;
        END IF ;
END$$

DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                            MVD_RP1_Map : call_RMCObject_Log.sql                                            ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2025 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE call_RMCObject_Log
(
   IN    bOp                           TINYINT UNSIGNED,
   IN    sIPAddress                    VARCHAR (16),
   IN    twRPersonaIx                  BIGINT,
   IN    twRMCObjectIx                 BIGINT,
   OUT   bError                        INT
)
BEGIN
       DECLARE dwIPAddress BINARY (4) DEFAULT IPstob (sIPAddress);

        INSERT INTO RMCObjectLog
               (bOp, dwIPAddress, twRPersonaIx, twRMCObjectIx)
        VALUES (bOp, dwIPAddress, twRPersonaIx, twRMCObjectIx);
 
           SET bError = IF (ROW_COUNT () = 1, 0, 1);
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                           MVD_RP1_Map : call_RMCObject_Select.sql                                          ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2023 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

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
                    '"pObjectHead": ',   Format_ObjectHead
                                         (
                                            c.ObjectHead_Parent_wClass,
                                            c.ObjectHead_Parent_twObjectIx,
                                            c.ObjectHead_Self_wClass,
                                            c.ObjectHead_Self_twObjectIx,
                                            IF (nResultSet = 0, OBJECTHEAD_FLAG_SUBSCRIBE_FULL, OBJECTHEAD_FLAG_SUBSCRIBE_PARTIAL),
                                            c.ObjectHead_twEventIz
                                         ),

                  ', "twRMCObjectIx": ', c.ObjectHead_Self_twObjectIx,      -- is this necessary

                  ', "pName": ',         Format_Name_C
                                         (
                                            c.Name_wsRMCObjectId
                                         ),
                  ', "pType": ',         Format_Type_C
                                         (
                                            c.Type_bType,
                                            c.Type_bSubtype,
                                            c.Type_bFiction
                                         ),
                  ', "pOwner": ',        Format_Owner
                                         (
                                            c.Owner_twRPersonaIx
                                         ),
                  ', "pResource": ',     Format_Resource
                                         (
                                            c.Resource_qwResource,
                                            c.Resource_sName,
                                            c.Resource_sReference
                                         ),
                  ', "pTransform": ',    Format_Transform
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
                  ', "pOrbit_Spin": ',   Format_Orbit_Spin
                                         (
                                            c.Orbit_Spin_tmPeriod,
                                            c.Orbit_Spin_tmStart,
                                            c.Orbit_Spin_dA,
                                            c.Orbit_Spin_dB
                                         ),
                  ', "pBound": ',        Format_Bound
                                         (
                                            c.Bound_dX,
                                            c.Bound_dY,
                                            c.Bound_dZ
                                         ),
                  ', "pProperties": ',   Format_Properties_C
                                         (
                                            c.Properties_fMass,
                                            c.Properties_fGravity,
                                            c.Properties_fColor,
                                            c.Properties_fBrightness,
                                            c.Properties_fReflectivity
                                         ),

                  ', "nChildren":  ',    IFNULL (cac.nCount, 0) + IFNULL (cat.nCount, 0),
                 ' }'               
               ) AS `Object`
          FROM Results   AS x
          JOIN RMCObject AS c on c.ObjectHead_Self_twObjectIx = x.ObjectHead_Self_twObjectIx
     LEFT JOIN (SELECT ObjectHead_Parent_twObjectIx, COUNT(*) AS nCount FROM RMCObject WHERE ObjectHead_Parent_wClass = SBO_CLASS_RMCOBJECT GROUP BY ObjectHead_Parent_twObjectIx) AS cac ON cac.ObjectHead_Parent_twObjectIx = c.ObjectHead_Self_twObjectIx
     LEFT JOIN (SELECT ObjectHead_Parent_twObjectIx, COUNT(*) AS nCount FROM RMTObject WHERE ObjectHead_Parent_wClass = SBO_CLASS_RMCOBJECT GROUP BY ObjectHead_Parent_twObjectIx) AS cat ON cat.ObjectHead_Parent_twObjectIx = c.ObjectHead_Self_twObjectIx
         WHERE x.nResultSet = nResultSet;
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                          MVD_RP1_Map : call_RMCObject_Validate.sql                                         ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2023 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE call_RMCObject_Validate
(
   IN    twRPersonaIx                  BIGINT,
   IN    twRMCObjectIx                 BIGINT,
   OUT   ObjectHead_Parent_wClass      SMALLINT,
   OUT   ObjectHead_Parent_twObjectIx  BIGINT,
   INOUT nError                        INT
)
BEGIN
       DECLARE nCount INT;

        SELECT o.ObjectHead_Parent_wClass, o.ObjectHead_Parent_twObjectIx
          INTO   ObjectHead_Parent_wClass,   ObjectHead_Parent_twObjectIx
          FROM RMCObject AS o
         WHERE o.ObjectHead_Self_twObjectIx = twRMCObjectIx;

           SET nCount = ROW_COUNT ();

            IF twRPersonaIx <= 0
          THEN
                   CALL call_Error (1, 'twRPersonaIx is invalid',  nError);
        ELSEIF twRMCObjectIx <= 0
          THEN
                   CALL call_Error (2, 'twRMCObjectIx is invalid', nError);
        ELSEIF nCount <> 1
          THEN
                   CALL call_Error (3, 'twRMCObjectIx is unknown', nError);
        ELSEIF twRPersonaIx <> twRPersonaIx
          THEN                                                                -- TBD
                   CALL call_Error (4, 'Invalid rights',           nError);
        END IF ;
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                       MVD_RP1_Map : call_RMCObject_Validate_Bound.sql                                      ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2023 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE call_RMCObject_Validate_Bound
(
   IN    ObjectHead_Parent_wClass      SMALLINT,
   IN    ObjectHead_Parent_twObjectIx  BIGINT,
   IN    twRMCObjectIx                 BIGINT,
   IN    Bound_dX                      DOUBLE,
   IN    Bound_dY                      DOUBLE,
   IN    Bound_dZ                      DOUBLE,
   INOUT nError                        INT
)
BEGIN
            IF Bound_dX IS NULL OR Bound_dX <> Bound_dX
          THEN
                   CALL call_Error (21, 'Bound_dX is NULL or NaN', nError);
        ELSEIF Bound_dX < 0
          THEN
                   CALL call_Error (21, 'Bound_dX is invalid',     nError);
        END IF ;

            IF Bound_dY IS NULL OR Bound_dY <> Bound_dY
          THEN
                   CALL call_Error (21, 'Bound_dY is NULL or NaN', nError);
        ELSEIF Bound_dY < 0
          THEN
                   CALL call_Error (21, 'Bound_dY is invalid',     nError);
        END IF ;

            IF Bound_dZ IS NULL OR Bound_dZ <> Bound_dZ
          THEN
                   CALL call_Error (21, 'Bound_dZ is NULL or NaN', nError);
        ELSEIF Bound_dZ < 0
          THEN
                   CALL call_Error (21, 'Bound_dZ is invalid',     nError);
        END IF ;

            IF nError = 0
          THEN
                     -- validate bound is inside  parent's   bound
                     -- validate bound is outside children's bound
                    SET nError = nError;
        END IF ;
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                       MVD_RP1_Map : call_RMCObject_Validate_Name.sql                                       ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2023 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE call_RMCObject_Validate_Name
(
   IN    ObjectHead_Parent_wClass      SMALLINT,
   IN    ObjectHead_Parent_twObjectIx  BIGINT,
   IN    twRMCObjectIx                 BIGINT,
   IN    Name_wsRMCObjectId            VARCHAR (48),
   INOUT nError                        INT
)
BEGIN
            IF Name_wsRMCObjectId IS NULL
          THEN
                   CALL call_Error (21, 'Name_wsRMCObjectId is NULL', nError);
        END IF ;
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                    MVD_RP1_Map : call_RMCObject_Validate_Orbit_Spin.sql                                    ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2023 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE call_RMCObject_Validate_Orbit_Spin
(
   IN    ObjectHead_Parent_wClass      SMALLINT,
   IN    ObjectHead_Parent_twObjectIx  BIGINT,
   IN    twRMCObjectIx                 BIGINT,
   IN    Orbit_Spin_tmPeriod           BIGINT,
   IN    Orbit_Spin_tmStart            BIGINT,
   IN    Orbit_Spin_dA                 DOUBLE,
   IN    Orbit_Spin_dB                 DOUBLE,
   INOUT nError                        INT
)
BEGIN
            IF Orbit_Spin_tmPeriod IS NULL
          THEN
                   CALL call_Error (21, 'Orbit_Spin_tmPeriod is NULL',    nError);
        ELSEIF Orbit_Spin_tmPeriod < 0
          THEN
                   CALL call_Error (21, 'Orbit_Spin_tmPeriod is invalid', nError);
        END IF ;

            IF Orbit_Spin_tmStart IS NULL
          THEN
                   CALL call_Error (21, 'Orbit_Spin_tmStart is NULL',     nError);
        ELSEIF Orbit_Spin_tmStart NOT BETWEEN 0 AND Orbit_Spin_tmPeriod
          THEN
                   CALL call_Error (21, 'Orbit_Spin_tmStart is invalid',  nError);
        END IF ;

            IF Orbit_Spin_dA IS NULL OR Orbit_Spin_dA <> Orbit_Spin_dA
          THEN
                   CALL call_Error (21, 'Orbit_Spin_dA is NULL or NaN',   nError);
        ELSEIF Orbit_Spin_dA < 0
          THEN
                   CALL call_Error (21, 'Orbit_Spin_dA is invalid',       nError);
        END IF ;

            IF Orbit_Spin_dB IS NULL OR Orbit_Spin_dB <> Orbit_Spin_dB
          THEN
                   CALL call_Error (21, 'Orbit_Spin_dB is NULL or NaN',   nError);
        ELSEIF Orbit_Spin_dB < 0
          THEN
                   CALL call_Error (21, 'Orbit_Spin_dB is invalid',       nError);
        END IF ;

            IF nError = 0
          THEN
                     -- validate bound is inside  parent's   bound
                     -- validate bound is outside children's bound
                    SET nError = nError;
        END IF ;
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                       MVD_RP1_Map : call_RMCObject_Validate_Owner.sql                                      ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2023 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE call_RMCObject_Validate_Owner
(
   IN    ObjectHead_Parent_wClass      SMALLINT,
   IN    ObjectHead_Parent_twObjectIx  BIGINT,
   IN    twRMCObjectIx                 BIGINT,
   IN    Owner_twRPersonaIx            BIGINT,
   INOUT nError                        INT
)
BEGIN
            IF Owner_twRPersonaIx IS NULL
          THEN
                   CALL call_Error (21, 'Owner_twRPersonaIx is NULL',    nError);
        ELSEIF Owner_twRPersonaIx NOT BETWEEN 1 AND 0x0000FFFFFFFFFFFC
          THEN
                   CALL call_Error (21, 'Owner_twRPersonaIx is invalid', nError);
        END IF ;
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                    MVD_RP1_Map : call_RMCObject_Validate_Properties.sql                                    ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2023 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE call_RMCObject_Validate_Properties
(
   IN    ObjectHead_Parent_wClass      SMALLINT,
   IN    ObjectHead_Parent_twObjectIx  BIGINT,
   IN    twRMCObjectIx                 BIGINT,
   IN    Properties_fMass              FLOAT,
   IN    Properties_fGravity           FLOAT,
   IN    Properties_fColor             FLOAT,
   IN    Properties_fBrightness        FLOAT,
   IN    Properties_fReflectivity      FLOAT,
   INOUT nError                        INT
)
BEGIN
            IF Properties_fMass IS NULL OR Properties_fMass <> Properties_fMass
          THEN
                   CALL call_Error (21, 'Properties_fMass is NULL or NaN',        nError);
        ELSEIF Properties_fMass < 0
          THEN
                   CALL call_Error (21, 'Properties_fMass is invalid',            nError);
        END IF ;

            IF Properties_fGravity IS NULL OR Properties_fGravity <> Properties_fGravity
          THEN
                   CALL call_Error (21, 'Properties_fGravity is NULL or NaN',     nError);
        ELSEIF Properties_fGravity < 0
          THEN
                   CALL call_Error (21, 'Properties_fGravity is invalid',         nError);
        END IF ;

            IF Properties_fColor IS NULL OR Properties_fColor <> Properties_fColor
          THEN
                   CALL call_Error (21, 'Properties_fColor is NULL or NaN',       nError);
        ELSEIF Properties_fColor < 0
          THEN
                   CALL call_Error (21, 'Properties_fColor is invalid',           nError);
        END IF ;

            IF Properties_fBrightness IS NULL OR Properties_fBrightness <> Properties_fBrightness
          THEN
                   CALL call_Error (21, 'Properties_fBrightness is NULL or NaN',  nError);
        ELSEIF Properties_fBrightness < 0
          THEN
                   CALL call_Error (21, 'Properties_fBrightness is invalid',      nError);
        END IF ;

            IF Properties_fReflectivity IS NULL OR Properties_fReflectivity <> Properties_fReflectivity
          THEN
                  CALL call_Error (21, 'Properties_fReflectivity is NULL or NaN', nError);
        ELSEIF Properties_fReflectivity < 0
          THEN
                   CALL call_Error (21, 'Properties_fReflectivity is invalid',    nError);
        END IF ;
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                     MVD_RP1_Map : call_RMCObject_Validate_Resource.sql                                     ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2023 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE call_RMCObject_Validate_Resource
(
   IN    ObjectHead_Parent_wClass      SMALLINT,
   IN    ObjectHead_Parent_twObjectIx  BIGINT,
   IN    twRMCObjectIx                 BIGINT,
   IN    Resource_qwResource           BIGINT,
   IN    Resource_sName                VARCHAR (48),
   IN    Resource_sReference           VARCHAR (128),
   INOUT nError                        INT
)
BEGIN
            IF Resource_qwResource IS NULL
          THEN
                   CALL call_Error (21, 'Resource_qwResource is NULL', nError);
        END IF ;

            IF Resource_sName IS NULL
          THEN
                   CALL call_Error (21, 'Resource_sName is NULL',      nError);
        END IF ;

            IF Resource_sReference IS NULL
          THEN
                   CALL call_Error (21, 'Resource_sReference is NULL', nError);
        END IF ;

            -- do we want to check sName and sReference for length or invalid characters
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                     MVD_RP1_Map : call_RMCObject_Validate_Transform.sql                                    ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2023 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE call_RMCObject_Validate_Transform
(
   IN    ObjectHead_Parent_wClass      SMALLINT,
   IN    ObjectHead_Parent_twObjectIx  BIGINT,
   IN    twRMCObjectIx                 BIGINT,
   IN    Transform_Position_dX         DOUBLE,
   IN    Transform_Position_dY         DOUBLE,
   IN    Transform_Position_dZ         DOUBLE,
   IN    Transform_Rotation_dX         DOUBLE,
   IN    Transform_Rotation_dY         DOUBLE,
   IN    Transform_Rotation_dZ         DOUBLE,
   IN    Transform_Rotation_dW         DOUBLE,
   IN    Transform_Scale_dX            DOUBLE,
   IN    Transform_Scale_dY            DOUBLE,
   IN    Transform_Scale_dZ            DOUBLE,
   INOUT nError                        INT
)
BEGIN
            IF Transform_Position_dX IS NULL OR Transform_Position_dX <> Transform_Position_dX
          THEN
                   CALL call_Error (21, 'Transform_Position_dX is NULL or NaN', nError);
        END IF ;
            IF Transform_Position_dY IS NULL OR Transform_Position_dY <> Transform_Position_dY
          THEN
                   CALL call_Error (21, 'Transform_Position_dY is NULL or NaN', nError);
        END IF ;
            IF Transform_Position_dZ IS NULL OR Transform_Position_dZ <> Transform_Position_dZ
          THEN
                   CALL call_Error (21, 'Transform_Position_dZ is NULL or NaN', nError);
        END IF ;

            IF Transform_Rotation_dX IS NULL OR Transform_Rotation_dX <> Transform_Rotation_dX
          THEN
                   CALL call_Error (21, 'Transform_Rotation_dX is NULL or NaN', nError);
        END IF ;
            IF Transform_Rotation_dY IS NULL OR Transform_Rotation_dY <> Transform_Rotation_dY
          THEN
                   CALL call_Error (21, 'Transform_Rotation_dY is NULL or NaN', nError);
        END IF ;
            IF Transform_Rotation_dZ IS NULL OR Transform_Rotation_dZ <> Transform_Rotation_dZ
          THEN
                   CALL call_Error (21, 'Transform_Rotation_dZ is NULL or NaN', nError);
        END IF ;
            IF Transform_Rotation_dW IS NULL OR Transform_Rotation_dW <> Transform_Rotation_dW
          THEN
                   CALL call_Error (21, 'Transform_Rotation_dW is NULL or NaN', nError);
        END IF ;

            IF Transform_Scale_dX IS NULL OR Transform_Scale_dX <> Transform_Scale_dX
          THEN
                   CALL call_Error (21, 'Transform_Scale_dX is NULL or NaN',    nError);
        END IF ;
            IF Transform_Scale_dY IS NULL OR Transform_Scale_dY <> Transform_Scale_dY
          THEN
                   CALL call_Error (21, 'Transform_Scale_dY is NULL or NaN',    nError);
        END IF ;
            IF Transform_Scale_dZ IS NULL OR Transform_Scale_dZ <> Transform_Scale_dZ
          THEN
                   CALL call_Error (21, 'Transform_Scale_dZ is NULL or NaN',    nError);
        END IF ;

            IF nError = 0
          THEN
                     -- validate position is inside parent's bound
                    SET nError = nError;
        END IF ;
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                       MVD_RP1_Map : call_RMCObject_Validate_Type.sql                                       ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2023 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE call_RMCObject_Validate_Type
(
   IN    ObjectHead_Parent_wClass      SMALLINT,
   IN    ObjectHead_Parent_twObjectIx  BIGINT,
   IN    twRMCObjectIx                 BIGINT,
   IN    Type_bType                    TINYINT UNSIGNED,
   IN    Type_bSubtype                 TINYINT UNSIGNED,
   IN    Type_bFiction                 TINYINT UNSIGNED,
   INOUT nError                        INT
)
BEGIN
       DECLARE SBO_CLASS_RMCOBJECT                        INT DEFAULT 71;

       DECLARE Parent_bType    TINYINT UNSIGNED;
       DECLARE Parent_bSubtype TINYINT UNSIGNED;
       DECLARE Self_bType      TINYINT UNSIGNED;
       DECLARE Self_bSubtype   TINYINT UNSIGNED;

            IF ObjectHead_Parent_wClass = SBO_CLASS_RMCOBJECT
          THEN
                 SELECT o.Type_bType, o.Type_bSubtype
                   INTO Parent_bType, Parent_bSubtype
                   FROM RMCObject AS o
                  WHERE o.ObjectHead_Self_twObjectIx = ObjectHead_Parent_twObjectIx;
        END IF ;

            IF twRMCObjectIx > 0
          THEN
                 SELECT o.Type_bType, o.Type_bSubtype
                   INTO   Self_bType,   Self_bSubtype
                   FROM RMCObject AS o
                  WHERE o.ObjectHead_Self_twObjectIx = twRMCObjectIx;
-- get max children's type and subtype

        END IF ;

-- attachment points can't have cildren

            IF Type_bType IS NULL
          THEN
                   CALL call_Error (21, 'Type_bType is NULL',       nError);
        END IF ;

            IF Type_bSubtype IS NULL
          THEN
                   CALL call_Error (21, 'Type_bSubtype is NULL',    nError);
        END IF ;

            IF Type_bFiction IS NULL
          THEN
                   CALL call_Error (21, 'Type_bFiction is NULL',    nError);
        ELSEIF Type_bFiction NOT BETWEEN 0 AND 1
          THEN
                   CALL call_Error (21, 'Type_bFiction is invalid', nError);
        END IF ;

            IF ObjectHead_Parent_wClass = SBO_CLASS_RMCOBJECT AND Type_bType < Parent_bType
          THEN
                   CALL call_Error (21, 'Type_bType must be greater than or equal to its parent\'s Type_bType', nError);
        ELSEIF ObjectHead_Parent_wClass = SBO_CLASS_RMCOBJECT AND Type_bType = Parent_bType AND Type_bSubtype <= Parent_bSubtype
          THEN
                   CALL call_Error (21, 'Type_bSubtype must be greater than its parent\'s Type_bType', nError);
        END IF ;
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                           MVD_RP1_Map : get_RMCObject_Update.sql                                           ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2025 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

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

       DECLARE bType TINYINT UNSIGNED;

            -- Create the temp Error table
        CREATE TEMPORARY TABLE Error
               (
                  nOrder                        INT             NOT NULL AUTO_INCREMENT PRIMARY KEY,
                  dwError                       INT             NOT NULL,
                  sError                        VARCHAR (255)   NOT NULL
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

                     IF ROW_COUNT () = 1  AND  bType IS NOT NULL
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

          DROP TEMPORARY TABLE Error;
          DROP TEMPORARY TABLE Results;

           SET nResult = bCommit - 1 - nError;

END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                             MVD_RP1_Map : search_RMCObject.sql                                             ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2023 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE search_RMCObject
(
   IN    sIPAddress                   VARCHAR (16),
   IN    twRPersonaIx                 BIGINT,
   IN    twRMCObjectIx                BIGINT,
   IN    dX                           DOUBLE,
   IN    dY                           DOUBLE,
   IN    dZ                           DOUBLE,
   IN    sText                        VARCHAR (48)
)
BEGIN
       DECLARE MVO_RMCOBJECT_TYPE_SATELLITE              INT DEFAULT 15;

       DECLARE bError  INT;
       DECLARE bCommit INT DEFAULT 0;
       DECLARE nError  INT DEFAULT 0;

       DECLARE bType   TINYINT UNSIGNED;
       DECLARE dRange  DOUBLE;
       DECLARE nCount  INT DEFAULT 0;

            -- Create the temp Error table
        CREATE TEMPORARY TABLE Error
               (
                  nOrder                        INT             NOT NULL AUTO_INCREMENT PRIMARY KEY,
                  dwError                       INT             NOT NULL,
                  sError                        VARCHAR (255)   NOT NULL
               );

        SELECT Type_bType INTO bType
          FROM RMCObject
         WHERE ObjectHead_Self_twObjectIx = twRMCObjectIx;

            IF bType IS NULL
          THEN
               SET bError = 1;
        END IF ;

            IF bError = 0
          THEN
                 SET sText = TRIM (IFNULL (sText, ''));

                  IF sText <> ''
                THEN
                      CREATE TEMPORARY TABLE Result
                                      (
                                         nOrder                          INT         AUTO_INCREMENT PRIMARY KEY,
                                         ObjectHead_Self_twObjectIx      BIGINT,
                                         dFactor                         DOUBLE,
                                         dDistance                       DOUBLE
                                      );

                       INSERT INTO Result
                            (
                              ObjectHead_Self_twObjectIx, 
                              dFactor,
                              dDistance
                            )
                       SELECT 
                              o.ObjectHead_Self_twObjectIx, 
                              POW(4.0, o.Type_bType - 7) AS dFactor, 
                              -1 AS dDistance
                         FROM RMCObject AS o
                        WHERE o.Name_wsRMCObjectId LIKE CONCAT(sText, '%')
                          AND o.Type_bType BETWEEN bType + 1 AND MVO_RMCOBJECT_TYPE_SATELLITE
                     ORDER BY POW(4.0, o.Type_bType - 7) * (-1) DESC, o.Name_wsRMCObjectId
                        LIMIT 10;

                       SELECT o.ObjectHead_Parent_wClass     AS ObjectHead_wClass_Parent,
                              o.ObjectHead_Parent_twObjectIx AS ObjectHead_twParentIx,
                              o.ObjectHead_Self_wClass       AS ObjectHead_wClass_Object,
                              o.ObjectHead_Self_twObjectIx   AS ObjectHead_twObjectIx,
                              o.ObjectHead_wFlags,
                              o.ObjectHead_twEventIz,
                              o.Name_wsRMCObjectId,
                              o.Type_bType,
                              o.Type_bSubtype,
                              o.Type_bFiction,
                              r.dFactor,
                              r.dDistance
                         FROM RMCObject AS o
                         JOIN Result    AS r ON r.ObjectHead_Self_twObjectIx = o.ObjectHead_Self_twObjectIx
                     ORDER BY r.nOrder;

                       WITH RECURSIVE Tree AS
                              (
                                SELECT oa.ObjectHead_Parent_wClass,
                                       oa.ObjectHead_Parent_twObjectIx,
                                       oa.ObjectHead_Self_wClass,
                                       oa.ObjectHead_Self_twObjectIx,
                                       r.nOrder,
                                       0                               AS nAncestor
                                  FROM RMCObject AS oa
                                  JOIN Result    AS r  ON r.ObjectHead_Self_twObjectIx = oa.ObjectHead_Self_twObjectIx
 
                                 UNION ALL
 
                                SELECT ob.ObjectHead_Parent_wClass,
                                       ob.ObjectHead_Parent_twObjectIx,
                                       ob.ObjectHead_Self_wClass,
                                       ob.ObjectHead_Self_twObjectIx,
                                       x.nOrder,
                                       x.nAncestor + 1                 AS nAncestor
                                  FROM RMCObject AS ob
                                  JOIN Tree      AS x  ON x.ObjectHead_Parent_twObjectIx = ob.ObjectHead_Self_twObjectIx
                                                      AND x.ObjectHead_Parent_wClass     = ob.ObjectHead_Self_wClass
                              )
                       SELECT o.ObjectHead_Parent_wClass     AS ObjectHead_wClass_Parent,
                              o.ObjectHead_Parent_twObjectIx AS ObjectHead_twParentIx,
                              o.ObjectHead_Self_wClass       AS ObjectHead_wClass_Object,
                              o.ObjectHead_Self_twObjectIx   AS ObjectHead_twObjectIx,
                              o.ObjectHead_wFlags,
                              o.ObjectHead_twEventIz,
                              o.Name_wsRMCObjectId,
                              o.Type_bType,
                              o.Type_bSubtype,
                              o.Type_bFiction,
                              x.nAncestor
                         FROM RMCObject AS o
                         JOIN Tree      AS x ON x.ObjectHead_Self_twObjectIx = o.ObjectHead_Self_twObjectIx
                        WHERE x.nAncestor > 0
                     ORDER BY x.nOrder,
                              x.nAncestor;

                       DROP TEMPORARY TABLE Result;
                 ELSE
                       SELECT NULL AS Unused LIMIT 0;
                       SELECT NULL AS Unused LIMIT 0;
             END IF ;

                 SET bCommit = 1;
          ELSE 
                CALL call_Error (1, 'twRMCObjectIx is invalid', nError);
        END IF ;

            IF bCommit = 0
          THEN
                 SELECT dwError, sError FROM Error;
        END IF ;

        DROP TEMPORARY TABLE Error;

        SET nError = bCommit - bError - 1;
END$$
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                            MVD_RP1_Map : set_RMCObject_Bound.sql                                           ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                              Copyright 2023-2025 Metaversal Corporation. All rights reserved.                              ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE set_RMCObject_Bound
(
   IN    sIPAddress                    VARCHAR (16),
   IN    twRPersonaIx                  BIGINT,
   IN    twRMCObjectIx                 BIGINT,
   IN    Bound_dX                      DOUBLE,
   IN    Bound_dY                      DOUBLE,
   IN    Bound_dZ                      DOUBLE,
   OUT   nResult                       INT
)
BEGIN
       DECLARE RMCOBJECT_OP_BOUND                         INT DEFAULT 7;

       DECLARE nError  INT DEFAULT 0;
       DECLARE bCommit INT DEFAULT 0;
       DECLARE bError  INT;

       DECLARE ObjectHead_Parent_wClass     SMALLINT;
       DECLARE ObjectHead_Parent_twObjectIx BIGINT;

            -- Create the temp Error table
        CREATE TEMPORARY TABLE Error
               (
                  nOrder                        INT             NOT NULL AUTO_INCREMENT PRIMARY KEY,
                  dwError                       INT             NOT NULL,
                  sError                        VARCHAR (255)   NOT NULL
               );

            -- Create the temp Event table
        CREATE TEMPORARY TABLE Event
               (
                  nOrder                        INT             NOT NULL AUTO_INCREMENT PRIMARY KEY,
                  sType                         VARCHAR (50)    NOT NULL,
                  Self_wClass                   SMALLINT        NOT NULL,
                  Self_twObjectIx               BIGINT          NOT NULL,
                  Child_wClass                  SMALLINT        NOT NULL,
                  Child_twObjectIx              BIGINT          NOT NULL,
                  wFlags                        SMALLINT        NOT NULL,
                  twEventIz                     BIGINT          NOT NULL,
                  sJSON_Object                  TEXT            NOT NULL,
                  sJSON_Child                   TEXT            NOT NULL,
                  sJSON_Change                  TEXT            NOT NULL
               );

           SET twRPersonaIx  = IFNULL (twRPersonaIx,  0);
           SET twRMCObjectIx = IFNULL (twRMCObjectIx, 0);

         START TRANSACTION;

          CALL call_RMCObject_Validate (twRPersonaIx, twRMCObjectIx, ObjectHead_Parent_wClass, ObjectHead_Parent_twObjectIx, nError);
            IF nError = 0
          THEN
                   CALL call_RMCObject_Validate_Bound (ObjectHead_Parent_wClass, ObjectHead_Parent_twObjectIx, twRMCObjectIx, Bound_dX, Bound_dY, Bound_dZ, nError);
        END IF ;

            IF nError = 0
          THEN
                   CALL call_RMCObject_Event_Bound (twRMCObjectIx, Bound_dX, Bound_dY, Bound_dZ, bError);
                     IF bError = 0
                   THEN
                             SET bCommit = 1;
                   ELSE 
                            CALL call_Error (-1, 'Failed to update RMCObject', nError);
                 END IF ;
        END IF ;
       
            IF bCommit = 1
          THEN
                    SET bCommit = 0;
                 
                   CALL call_RMCObject_Log (RMCOBJECT_OP_BOUND, sIPAddress, twRPersonaIx, twRMCObjectIx, bError);
                     IF bError = 0
                   THEN
                            CALL call_Event_Push (bError);
                              IF bError = 0
                            THEN
                                      SET bCommit = 1;
                            ELSE
                                     CALL call_Error (-9, 'Failed to push events', nError);
                          END IF ;
                   ELSE
                            CALL call_Error (-8, 'Failed to log action', nError);
                 END IF ;
        END IF ;

            IF bCommit = 0
          THEN
                 SELECT dwError, sError FROM Error;

               ROLLBACK ;
          ELSE
                 COMMIT ;
        END IF ;

          DROP TEMPORARY TABLE Error;
          DROP TEMPORARY TABLE Event;

           SET nResult = bCommit - 1 - nError;
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                            MVD_RP1_Map : set_RMCObject_Name.sql                                            ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                              Copyright 2023-2025 Metaversal Corporation. All rights reserved.                              ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE set_RMCObject_Name
(
   IN    sIPAddress                    VARCHAR (16),
   IN    twRPersonaIx                  BIGINT,
   IN    twRMCObjectIx                 BIGINT,
   IN    Name_wsRMCObjectId            VARCHAR (48),
   OUT   nResult                       INT
)
BEGIN
       DECLARE RMCOBJECT_OP_NAME                          INT DEFAULT 1;

       DECLARE nError  INT DEFAULT 0;
       DECLARE bCommit INT DEFAULT 0;
       DECLARE bError  INT;

       DECLARE ObjectHead_Parent_wClass     SMALLINT;
       DECLARE ObjectHead_Parent_twObjectIx BIGINT;

            -- Create the temp Error table
        CREATE TEMPORARY TABLE Error
               (
                  nOrder                        INT             NOT NULL AUTO_INCREMENT PRIMARY KEY,
                  dwError                       INT             NOT NULL,
                  sError                        VARCHAR (255)   NOT NULL
               );

            -- Create the temp Event table
        CREATE TEMPORARY TABLE Event
               (
                  nOrder                        INT             NOT NULL AUTO_INCREMENT PRIMARY KEY,
                  sType                         VARCHAR (50)    NOT NULL,
                  Self_wClass                   SMALLINT        NOT NULL,
                  Self_twObjectIx               BIGINT          NOT NULL,
                  Child_wClass                  SMALLINT        NOT NULL,
                  Child_twObjectIx              BIGINT          NOT NULL,
                  wFlags                        SMALLINT        NOT NULL,
                  twEventIz                     BIGINT          NOT NULL,
                  sJSON_Object                  TEXT            NOT NULL,
                  sJSON_Child                   TEXT            NOT NULL,
                  sJSON_Change                  TEXT            NOT NULL
               );

           SET twRPersonaIx  = IFNULL (twRPersonaIx,  0);
           SET twRMCObjectIx = IFNULL (twRMCObjectIx, 0);

         START TRANSACTION;

          CALL call_RMCObject_Validate (twRPersonaIx, twRMCObjectIx, ObjectHead_Parent_wClass, ObjectHead_Parent_twObjectIx, nError);
            IF nError = 0
          THEN
                   CALL call_RMCObject_Validate_Name (ObjectHead_Parent_wClass, ObjectHead_Parent_twObjectIx, twRMCObjectIx, Name_wsRMCObjectId, nError);
        END IF ;

            IF nError = 0
          THEN
                   CALL call_RMCObject_Event_Name (twRMCObjectIx, Name_wsRMCObjectId, bError);
                     IF bError = 0
                   THEN
                             SET bCommit = 1;
                   ELSE 
                            CALL call_Error (-1, 'Failed to update RMCObject', nError);
                 END IF ;
        END IF ;
       
            IF bCommit = 1
          THEN
                    SET bCommit = 0;
                 
                   CALL call_RMCObject_Log (RMCOBJECT_OP_NAME, sIPAddress, twRPersonaIx, twRMCObjectIx, bError);
                     IF bError = 0
                   THEN
                            CALL call_Event_Push (bError);
                              IF bError = 0
                            THEN
                                      SET bCommit = 1;
                            ELSE
                                     CALL call_Error (-9, 'Failed to push events', nError);
                          END IF ;
                   ELSE
                            CALL call_Error (-8, 'Failed to log action', nError);
                 END IF ;
        END IF ;

            IF bCommit = 0
          THEN
                 SELECT dwError, sError FROM Error;

               ROLLBACK ;
          ELSE
                 COMMIT ;
        END IF ;

          DROP TEMPORARY TABLE Error;
          DROP TEMPORARY TABLE Event;

           SET nResult = bCommit - 1 - nError;
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                         MVD_RP1_Map : set_RMCObject_Orbit_Spin.sql                                         ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                              Copyright 2023-2025 Metaversal Corporation. All rights reserved.                              ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE set_RMCObject_Orbit_Spin
(
   IN    sIPAddress                    VARCHAR (16),
   IN    twRPersonaIx                  BIGINT,
   IN    twRMCObjectIx                 BIGINT,
   IN    Orbit_Spin_tmPeriod           DOUBLE,
   IN    Orbit_Spin_tmStart            DOUBLE,
   IN    Orbit_Spin_dA                 DOUBLE,
   IN    Orbit_Spin_dB                 DOUBLE,
   OUT   nResult                       INT
)
BEGIN
       DECLARE RMCOBJECT_OP_ORBIT_SPIN                    INT DEFAULT 6;

       DECLARE nError  INT DEFAULT 0;
       DECLARE bCommit INT DEFAULT 0;
       DECLARE bError  INT;

       DECLARE ObjectHead_Parent_wClass     SMALLINT;
       DECLARE ObjectHead_Parent_twObjectIx BIGINT;

            -- Create the temp Error table
        CREATE TEMPORARY TABLE Error
               (
                  nOrder                        INT             NOT NULL AUTO_INCREMENT PRIMARY KEY,
                  dwError                       INT             NOT NULL,
                  sError                        VARCHAR (255)   NOT NULL
               );

            -- Create the temp Event table
        CREATE TEMPORARY TABLE Event
               (
                  nOrder                        INT             NOT NULL AUTO_INCREMENT PRIMARY KEY,
                  sType                         VARCHAR (50)    NOT NULL,
                  Self_wClass                   SMALLINT        NOT NULL,
                  Self_twObjectIx               BIGINT          NOT NULL,
                  Child_wClass                  SMALLINT        NOT NULL,
                  Child_twObjectIx              BIGINT          NOT NULL,
                  wFlags                        SMALLINT        NOT NULL,
                  twEventIz                     BIGINT          NOT NULL,
                  sJSON_Object                  TEXT            NOT NULL,
                  sJSON_Child                   TEXT            NOT NULL,
                  sJSON_Change                  TEXT            NOT NULL
               );

           SET twRPersonaIx  = IFNULL (twRPersonaIx,  0);
           SET twRMCObjectIx = IFNULL (twRMCObjectIx, 0);

         START TRANSACTION;

          CALL call_RMCObject_Validate (twRPersonaIx, twRMCObjectIx, ObjectHead_Parent_wClass, ObjectHead_Parent_twObjectIx, nError);
            IF nError = 0
          THEN
                   CALL call_RMCObject_Validate_Orbit_Spin(ObjectHead_Parent_wClass, ObjectHead_Parent_twObjectIx, twRMCObjectIx, Orbit_Spin_tmPeriod, Orbit_Spin_tmStart, Orbit_Spin_dA, Orbit_Spin_dB, nError);
        END IF ;

            IF nError = 0
          THEN
                   CALL call_RMCObject_Event_Orbit_Spin(twRMCObjectIx, Orbit_Spin_tmPeriod, Orbit_Spin_tmStart, Orbit_Spin_dA, Orbit_Spin_dB, bError);
                     IF bError = 0
                   THEN
                             SET bCommit = 1;
                   ELSE 
                            CALL call_Error (-1, 'Failed to update RMCObject', nError);
                 END IF ;
        END IF ;
       
            IF bCommit = 1
          THEN
                    SET bCommit = 0;
                 
                   CALL call_RMCObject_Log (RMCOBJECT_OP_ORBIT_SPIN, sIPAddress, twRPersonaIx, twRMCObjectIx, bError);
                     IF bError = 0
                   THEN
                            CALL call_Event_Push (bError);
                              IF bError = 0
                            THEN
                                      SET bCommit = 1;
                            ELSE
                                     CALL call_Error (-9, 'Failed to push events', nError);
                          END IF ;
                   ELSE
                            CALL call_Error (-8, 'Failed to log action', nError);
                 END IF ;
        END IF ;

            IF bCommit = 0
          THEN
                 SELECT dwError, sError FROM Error;

               ROLLBACK ;
          ELSE
                 COMMIT ;
        END IF ;

          DROP TEMPORARY TABLE Error;
          DROP TEMPORARY TABLE Event;

           SET nResult = bCommit - 1 - nError;
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                            MVD_RP1_Map : set_RMCObject_Owner.sql                                           ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                              Copyright 2023-2025 Metaversal Corporation. All rights reserved.                              ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE set_RMCObject_Owner
(
   IN    sIPAddress                    VARCHAR (16),
   IN    twRPersonaIx                  BIGINT,
   IN    twRMCObjectIx                 BIGINT,
   IN    Owner_twRPersonaIx            BIGINT,
   OUT   nResult                       INT
)
BEGIN
       DECLARE RMCOBJECT_OP_OWNER                         INT DEFAULT 3;

       DECLARE nError  INT DEFAULT 0;
       DECLARE bCommit INT DEFAULT 0;
       DECLARE bError  INT;

       DECLARE ObjectHead_Parent_wClass     SMALLINT;
       DECLARE ObjectHead_Parent_twObjectIx BIGINT;

            -- Create the temp Error table
        CREATE TEMPORARY TABLE Error
               (
                  nOrder                        INT             NOT NULL AUTO_INCREMENT PRIMARY KEY,
                  dwError                       INT             NOT NULL,
                  sError                        VARCHAR (255)   NOT NULL
               );

            -- Create the temp Event table
        CREATE TEMPORARY TABLE Event
               (
                  nOrder                        INT             NOT NULL AUTO_INCREMENT PRIMARY KEY,
                  sType                         VARCHAR (50)    NOT NULL,
                  Self_wClass                   SMALLINT        NOT NULL,
                  Self_twObjectIx               BIGINT          NOT NULL,
                  Child_wClass                  SMALLINT        NOT NULL,
                  Child_twObjectIx              BIGINT          NOT NULL,
                  wFlags                        SMALLINT        NOT NULL,
                  twEventIz                     BIGINT          NOT NULL,
                  sJSON_Object                  TEXT            NOT NULL,
                  sJSON_Child                   TEXT            NOT NULL,
                  sJSON_Change                  TEXT            NOT NULL
               );

           SET twRPersonaIx  = IFNULL (twRPersonaIx,  0);
           SET twRMCObjectIx = IFNULL (twRMCObjectIx, 0);

         START TRANSACTION;

          CALL call_RMCObject_Validate (twRPersonaIx, twRMCObjectIx, ObjectHead_Parent_wClass, ObjectHead_Parent_twObjectIx, nError);
            IF nError = 0
          THEN
                   CALL call_RMCObject_Validate_Owner (ObjectHead_Parent_wClass, ObjectHead_Parent_twObjectIx, twRMCObjectIx, Owner_twRPersonaIx, nError);
        END IF ;

            IF nError = 0
          THEN
                   CALL call_RMCObject_Event_Owner (twRMCObjectIx, Owner_twRPersonaIx, bError);
                     IF bError = 0
                   THEN
                             SET bCommit = 1;
                   ELSE 
                            CALL call_Error (-1, 'Failed to update RMCObject', nError);
                 END IF ;
        END IF ;
       
            IF bCommit = 1
          THEN
                    SET bCommit = 0;
                 
                   CALL call_RMCObject_Log (RMCOBJECT_OP_OWNER, sIPAddress, twRPersonaIx, twRMCObjectIx, bError);
                     IF bError = 0
                   THEN
                            CALL call_Event_Push (bError);
                              IF bError = 0
                            THEN
                                      SET bCommit = 1;
                            ELSE
                                     CALL call_Error (-9, 'Failed to push events', nError);
                          END IF ;
                   ELSE
                            CALL call_Error (-8, 'Failed to log action', nError);
                 END IF ;
        END IF ;

            IF bCommit = 0
          THEN
                 SELECT dwError, sError FROM Error;

               ROLLBACK ;
          ELSE
                 COMMIT ;
        END IF ;

          DROP TEMPORARY TABLE Error;
          DROP TEMPORARY TABLE Event;

           SET nResult = bCommit - 1 - nError;
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                         MVD_RP1_Map : set_RMCObject_Properties.sql                                         ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                              Copyright 2023-2025 Metaversal Corporation. All rights reserved.                              ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE set_RMCObject_Properties
(
   IN    sIPAddress                    VARCHAR (16),
   IN    twRPersonaIx                  BIGINT,
   IN    twRMCObjectIx                 BIGINT,
   IN    Properties_fMass              FLOAT,
   IN    Properties_fGravity           FLOAT,
   IN    Properties_fColor             FLOAT,
   IN    Properties_fBrightness        FLOAT,
   IN    Properties_fReflectivity      FLOAT,
   OUT   nResult                       INT
)
BEGIN
       DECLARE RMCOBJECT_OP_PROPERTIES                    INT DEFAULT 8;

       DECLARE nError  INT DEFAULT 0;
       DECLARE bCommit INT DEFAULT 0;
       DECLARE bError  INT;

       DECLARE ObjectHead_Parent_wClass     SMALLINT;
       DECLARE ObjectHead_Parent_twObjectIx BIGINT;

            -- Create the temp Error table
        CREATE TEMPORARY TABLE Error
               (
                  nOrder                        INT             NOT NULL AUTO_INCREMENT PRIMARY KEY,
                  dwError                       INT             NOT NULL,
                  sError                        VARCHAR (255)   NOT NULL
               );

            -- Create the temp Event table
        CREATE TEMPORARY TABLE Event
               (
                  nOrder                        INT             NOT NULL AUTO_INCREMENT PRIMARY KEY,
                  sType                         VARCHAR (50)    NOT NULL,
                  Self_wClass                   SMALLINT        NOT NULL,
                  Self_twObjectIx               BIGINT          NOT NULL,
                  Child_wClass                  SMALLINT        NOT NULL,
                  Child_twObjectIx              BIGINT          NOT NULL,
                  wFlags                        SMALLINT        NOT NULL,
                  twEventIz                     BIGINT          NOT NULL,
                  sJSON_Object                  TEXT            NOT NULL,
                  sJSON_Child                   TEXT            NOT NULL,
                  sJSON_Change                  TEXT            NOT NULL
               );

           SET twRPersonaIx  = IFNULL (twRPersonaIx,  0);
           SET twRMCObjectIx = IFNULL (twRMCObjectIx, 0);

         START TRANSACTION;

          CALL call_RMCObject_Validate (twRPersonaIx, twRMCObjectIx, ObjectHead_Parent_wClass, ObjectHead_Parent_twObjectIx, nError);
            IF nError = 0
          THEN
                   CALL call_RMCObject_Validate_Properties (ObjectHead_Parent_wClass, ObjectHead_Parent_twObjectIx, twRMCObjectIx, Properties_fMass, Properties_fGravity, Properties_fColor, Properties_fBrightness, Properties_fReflectivity, nError);
        END IF ;

            IF nError = 0
          THEN
                   CALL call_RMCObject_Event_Properties (twRMCObjectIx, Properties_fMass, Properties_fGravity, Properties_fColor, Properties_fBrightness, Properties_fReflectivity, bError);
                     IF bError = 0
                   THEN
                             SET bCommit = 1;
                   ELSE 
                            CALL call_Error (-1, 'Failed to update RMCObject', nError);
                 END IF ;
        END IF ;
       
            IF bCommit = 1
          THEN
                    SET bCommit = 0;
                 
                   CALL call_RMCObject_Log (RMCOBJECT_OP_PROPERTIES, sIPAddress, twRPersonaIx, twRMCObjectIx, bError);
                     IF bError = 0
                   THEN
                            CALL call_Event_Push (bError);
                              IF bError = 0
                            THEN
                                      SET bCommit = 1;
                            ELSE
                                     CALL call_Error (-9, 'Failed to push events', nError);
                          END IF ;
                   ELSE
                            CALL call_Error (-8, 'Failed to log action', nError);
                 END IF ;
        END IF ;

            IF bCommit = 0
          THEN
                 SELECT dwError, sError FROM Error;

               ROLLBACK ;
          ELSE
                 COMMIT ;
        END IF ;

          DROP TEMPORARY TABLE Error;
          DROP TEMPORARY TABLE Event;

           SET nResult = bCommit - 1 - nError;
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                          MVD_RP1_Map : set_RMCObject_Resource.sql                                          ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                              Copyright 2023-2025 Metaversal Corporation. All rights reserved.                              ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE set_RMCObject_Resource
(
   IN    sIPAddress                    VARCHAR (16),
   IN    twRPersonaIx                  BIGINT,
   IN    twRMCObjectIx                 BIGINT,
   IN    Resource_qwResource           BIGINT,
   IN    Resource_sName                VARCHAR (48),
   IN    Resource_sReference           VARCHAR (128),
   OUT   nResult                       INT
)
BEGIN
       DECLARE RMCOBJECT_OP_RESOURCE                      INT DEFAULT 4;

       DECLARE nError  INT DEFAULT 0;
       DECLARE bCommit INT DEFAULT 0;
       DECLARE bError  INT;

       DECLARE ObjectHead_Parent_wClass     SMALLINT;
       DECLARE ObjectHead_Parent_twObjectIx BIGINT;

            -- Create the temp Error table
        CREATE TEMPORARY TABLE Error
               (
                  nOrder                        INT             NOT NULL AUTO_INCREMENT PRIMARY KEY,
                  dwError                       INT             NOT NULL,
                  sError                        VARCHAR (255)   NOT NULL
               );

            -- Create the temp Event table
        CREATE TEMPORARY TABLE Event
               (
                  nOrder                        INT             NOT NULL AUTO_INCREMENT PRIMARY KEY,
                  sType                         VARCHAR (50)    NOT NULL,
                  Self_wClass                   SMALLINT        NOT NULL,
                  Self_twObjectIx               BIGINT          NOT NULL,
                  Child_wClass                  SMALLINT        NOT NULL,
                  Child_twObjectIx              BIGINT          NOT NULL,
                  wFlags                        SMALLINT        NOT NULL,
                  twEventIz                     BIGINT          NOT NULL,
                  sJSON_Object                  TEXT            NOT NULL,
                  sJSON_Child                   TEXT            NOT NULL,
                  sJSON_Change                  TEXT            NOT NULL
               );

           SET twRPersonaIx  = IFNULL (twRPersonaIx,  0);
           SET twRMCObjectIx = IFNULL (twRMCObjectIx, 0);

         START TRANSACTION;

          CALL call_RMCObject_Validate (twRPersonaIx, twRMCObjectIx, ObjectHead_Parent_wClass, ObjectHead_Parent_twObjectIx, nError);
            IF nError = 0
          THEN
                   CALL call_RMCObject_Validate_Resource(ObjectHead_Parent_wClass, ObjectHead_Parent_twObjectIx, twRMCObjectIx, Resource_qwResource, Resource_sName, Resource_sReference, nError);
        END IF ;

            IF nError = 0
          THEN
                   CALL call_RMCObject_Event_Resource(twRMCObjectIx, Resource_qwResource, Resource_sName, Resource_sReference, bError);
                     IF bError = 0
                   THEN
                             SET bCommit = 1;
                   ELSE 
                            CALL call_Error (-1, 'Failed to update RMCObject', nError);
                 END IF ;
        END IF ;
       
            IF bCommit = 1
          THEN
                    SET bCommit = 0;
                 
                   CALL call_RMCObject_Log (RMCOBJECT_OP_RESOURCE, sIPAddress, twRPersonaIx, twRMCObjectIx, bError);
                     IF bError = 0
                   THEN
                            CALL call_Event_Push (bError);
                              IF bError = 0
                            THEN
                                      SET bCommit = 1;
                            ELSE
                                     CALL call_Error (-9, 'Failed to push events', nError);
                          END IF ;
                   ELSE
                            CALL call_Error (-8, 'Failed to log action', nError);
                 END IF ;
        END IF ;

            IF bCommit = 0
          THEN
                 SELECT dwError, sError FROM Error;

               ROLLBACK ;
          ELSE
                 COMMIT ;
        END IF ;

          DROP TEMPORARY TABLE Error;
          DROP TEMPORARY TABLE Event;

           SET nResult = bCommit - 1 - nError;
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                       MVD_RP1_Map : set_RMCObject_RMCObject_Close.sql                                      ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                              Copyright 2023-2025 Metaversal Corporation. All rights reserved.                              ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE set_RMCObject_RMCObject_Close
(
   IN    sIPAddress                    VARCHAR (16),
   IN    twRPersonaIx                  BIGINT,
   IN    twRMCObjectIx                 BIGINT,
   IN    twRMCObjectIx_Close           BIGINT,
   IN    bDeleteAll                    TINYINT UNSIGNED,
   OUT   nResult                       INT
)
BEGIN
       DECLARE SBO_CLASS_RMCOBJECT                        INT DEFAULT 71;
       DECLARE RMCOBJECT_OP_RMCOBJECT_CLOSE               INT DEFAULT 12;

       DECLARE nError  INT DEFAULT 0;
       DECLARE bCommit INT DEFAULT 0;
       DECLARE bError  INT;

       DECLARE ObjectHead_Parent_wClass     SMALLINT;
       DECLARE ObjectHead_Parent_twObjectIx BIGINT;

       DECLARE nCount INT;

            -- Create the temp Error table
        CREATE TEMPORARY TABLE Error
               (
                  nOrder                        INT             NOT NULL AUTO_INCREMENT PRIMARY KEY,
                  dwError                       INT             NOT NULL,
                  sError                        VARCHAR (255)   NOT NULL
               );

            -- Create the temp Event table
        CREATE TEMPORARY TABLE Event
               (
                  nOrder                        INT             NOT NULL AUTO_INCREMENT PRIMARY KEY,
                  sType                         VARCHAR (50)    NOT NULL,
                  Self_wClass                   SMALLINT        NOT NULL,
                  Self_twObjectIx               BIGINT          NOT NULL,
                  Child_wClass                  SMALLINT        NOT NULL,
                  Child_twObjectIx              BIGINT          NOT NULL,
                  wFlags                        SMALLINT        NOT NULL,
                  twEventIz                     BIGINT          NOT NULL,
                  sJSON_Object                  TEXT            NOT NULL,
                  sJSON_Child                   TEXT            NOT NULL,
                  sJSON_Change                  TEXT            NOT NULL
               );

           SET twRPersonaIx        = IFNULL (twRPersonaIx,        0);
           SET twRMCObjectIx       = IFNULL (twRMCObjectIx,       0);
           SET twRMCObjectIx_Close = IFNULL (twRMCObjectIx_Close, 0);
           SET bDeleteAll          = IFNULL (bDeleteAll,          0);

         START TRANSACTION;

          CALL call_RMCObject_Validate (twRPersonaIx, twRMCObjectIx, ObjectHead_Parent_wClass, ObjectHead_Parent_twObjectIx, nError);
            IF nError = 0
          THEN
                 SELECT COUNT(*) INTO nCount
                   FROM RMCObject
                  WHERE ObjectHead_Parent_wClass     = SBO_CLASS_RMCOBJECT
                    AND ObjectHead_Parent_twObjectIx = twRMCObjectIx_Close;

                 SELECT COUNT(*) + nCount INTO nCount
                   FROM RMTObject
                  WHERE ObjectHead_Parent_wClass     = SBO_CLASS_RMCOBJECT
                    AND ObjectHead_Parent_twObjectIx = twRMCObjectIx_Close;

                     IF twRMCObjectIx_Close <= 0
                   THEN
                            CALL call_Error (5, 'twRMCObjectIx_Close is invalid',   nError);
                 ELSEIF bDeleteAll = 0 AND nCount > 0
                   THEN
                            CALL call_Error (6, 'twRMCObjectIx_Close is not empty', nError);
                 END IF ;
        END IF ;

            IF nError = 0
          THEN
                   CALL call_RMCObject_Event_RMCObject_Close (twRMCObjectIx, twRMCObjectIx_Close, bError);
                     IF bError = 0
                   THEN
                             SET bCommit = 1;
                   ELSE 
                            CALL call_Error (-1, 'Failed to delete RMCObject', nError);
                 END IF ;
        END IF ;
       
            IF bCommit = 1
          THEN
                    SET bCommit = 0;
                 
                   CALL call_RMCObject_Log (RMCOBJECT_OP_RMCOBJECT_CLOSE, sIPAddress, twRPersonaIx, twRMCObjectIx, bError);
                     IF bError = 0
                   THEN
                            CALL call_Event_Push (bError);
                              IF bError = 0
                            THEN
                                      SET bCommit = 1;
                            ELSE
                                     CALL call_Error (-9, 'Failed to push events', nError);
                          END IF ;
                   ELSE
                            CALL call_Error (-8, 'Failed to log action', nError);
                 END IF ;
        END IF ;

            IF bCommit = 0
          THEN
                 SELECT dwError, sError FROM Error;

               ROLLBACK ;
          ELSE
                 COMMIT ;
        END IF ;

          DROP TEMPORARY TABLE Error;
          DROP TEMPORARY TABLE Event;

           SET nResult = bCommit - 1 - nError;
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                       MVD_RP1_Map : set_RMCObject_RMCObject_Open.sql                                       ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                              Copyright 2023-2025 Metaversal Corporation. All rights reserved.                              ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE set_RMCObject_RMCObject_Open
(
   IN    sIPAddress                    VARCHAR (16),
   IN    twRPersonaIx                  BIGINT,
   IN    twRMCObjectIx                 BIGINT,
   IN    Name_wsRMCObjectId            VARCHAR (48),
   IN    Type_bType                    TINYINT UNSIGNED,
   IN    Type_bSubtype                 TINYINT UNSIGNED,
   IN    Type_bFiction                 TINYINT UNSIGNED,
   IN    Owner_twRPersonaIx            BIGINT,
   IN    Resource_qwResource           BIGINT,
   IN    Resource_sName                VARCHAR (48),
   IN    Resource_sReference           VARCHAR (128),
   IN    Transform_Position_dX         DOUBLE,
   IN    Transform_Position_dY         DOUBLE,
   IN    Transform_Position_dZ         DOUBLE,
   IN    Transform_Rotation_dX         DOUBLE,
   IN    Transform_Rotation_dY         DOUBLE,
   IN    Transform_Rotation_dZ         DOUBLE,
   IN    Transform_Rotation_dW         DOUBLE,
   IN    Transform_Scale_dX            DOUBLE,
   IN    Transform_Scale_dY            DOUBLE,
   IN    Transform_Scale_dZ            DOUBLE,
   IN    Orbit_Spin_tmPeriod           BIGINT,
   IN    Orbit_Spin_tmStart            BIGINT,
   IN    Orbit_Spin_dA                 DOUBLE,
   IN    Orbit_Spin_dB                 DOUBLE,
   IN    Bound_dX                      DOUBLE,
   IN    Bound_dY                      DOUBLE,
   IN    Bound_dZ                      DOUBLE,
   IN    Properties_fMass              FLOAT,
   IN    Properties_fGravity           FLOAT,
   IN    Properties_fColor             FLOAT,
   IN    Properties_fBrightness        FLOAT,
   IN    Properties_fReflectivity      FLOAT,
   OUT   nResult                       INT
)
BEGIN
       DECLARE SBO_CLASS_RMCOBJECT                        INT DEFAULT 71;
       DECLARE RMCOBJECT_OP_RMCOBJECT_OPEN                INT DEFAULT 11;

       DECLARE nError  INT DEFAULT 0;
       DECLARE bCommit INT DEFAULT 0;
       DECLARE bError  INT;

       DECLARE ObjectHead_Parent_wClass     SMALLINT;
       DECLARE ObjectHead_Parent_twObjectIx BIGINT;

       DECLARE twRMCObjectIx_Open           BIGINT;

            -- Create the temp Error table
        CREATE TEMPORARY TABLE Error
               (
                  nOrder                        INT             NOT NULL AUTO_INCREMENT PRIMARY KEY,
                  dwError                       INT             NOT NULL,
                  sError                        VARCHAR (255)   NOT NULL
               );

            -- Create the temp Event table
        CREATE TEMPORARY TABLE Event
               (
                  nOrder                        INT             NOT NULL AUTO_INCREMENT PRIMARY KEY,
                  sType                         VARCHAR (50)    NOT NULL,
                  Self_wClass                   SMALLINT        NOT NULL,
                  Self_twObjectIx               BIGINT          NOT NULL,
                  Child_wClass                  SMALLINT        NOT NULL,
                  Child_twObjectIx              BIGINT          NOT NULL,
                  wFlags                        SMALLINT        NOT NULL,
                  twEventIz                     BIGINT          NOT NULL,
                  sJSON_Object                  TEXT            NOT NULL,
                  sJSON_Child                   TEXT            NOT NULL,
                  sJSON_Change                  TEXT            NOT NULL
               );

           SET twRPersonaIx  = IFNULL (twRPersonaIx,  0);
           SET twRMCObjectIx = IFNULL (twRMCObjectIx, 0);

         START TRANSACTION;

          CALL call_RMCObject_Validate (twRPersonaIx, twRMCObjectIx, ObjectHead_Parent_wClass, ObjectHead_Parent_twObjectIx, nError);
            IF nError = 0
          THEN
                   CALL call_RMCObject_Validate_Name       (SBO_CLASS_RMCOBJECT, twRMCObjectIx, 0, Name_wsRMCObjectId, nError);
                   CALL call_RMCObject_Validate_Type       (SBO_CLASS_RMCOBJECT, twRMCObjectIx, 0, Type_bType, Type_bSubtype, Type_bFiction, nError);
                   CALL call_RMCObject_Validate_Owner      (SBO_CLASS_RMCOBJECT, twRMCObjectIx, 0, Owner_twRPersonaIx, nError);
                   CALL call_RMCObject_Validate_Resource   (SBO_CLASS_RMCOBJECT, twRMCObjectIx, 0, Resource_qwResource, Resource_sName, Resource_sReference, nError);
                   CALL call_RMCObject_Validate_Transform  (SBO_CLASS_RMCOBJECT, twRMCObjectIx, 0, Transform_Position_dX, Transform_Position_dY, Transform_Position_dZ, Transform_Rotation_dX, Transform_Rotation_dY, Transform_Rotation_dZ, Transform_Rotation_dW, Transform_Scale_dX, Transform_Scale_dY, Transform_Scale_dZ, nError);
                   CALL call_RMCObject_Validate_Orbit_Spin (SBO_CLASS_RMCOBJECT, twRMCObjectIx, 0, Orbit_Spin_tmPeriod, Orbit_Spin_tmStart, Orbit_Spin_dA, Orbit_Spin_dB, nError);
                   CALL call_RMCObject_Validate_Bound      (SBO_CLASS_RMCOBJECT, twRMCObjectIx, 0, Bound_dX, Bound_dY, Bound_dZ, nError);
                   CALL call_RMCObject_Validate_Properties (SBO_CLASS_RMCOBJECT, twRMCObjectIx, 0, Properties_fMass, Properties_fGravity, Properties_fColor, Properties_fBrightness, Properties_fReflectivity, nError);
        END IF ;

            IF nError = 0
          THEN
                   CALL call_RMCObject_Event_RMCObject_Open (twRMCObjectIx, Name_wsRMCObjectId, Type_bType, Type_bSubtype, Type_bFiction, Owner_twRPersonaIx, Resource_qwResource, Resource_sName, Resource_sReference, Transform_Position_dX, Transform_Position_dY, Transform_Position_dZ, Transform_Rotation_dX, Transform_Rotation_dY, Transform_Rotation_dZ, Transform_Rotation_dW, Transform_Scale_dX, Transform_Scale_dY, Transform_Scale_dZ, Orbit_Spin_tmPeriod, Orbit_Spin_tmStart, Orbit_Spin_dA, Orbit_Spin_dB, Bound_dX, Bound_dY, Bound_dZ, Properties_fMass, Properties_fGravity, Properties_fColor, Properties_fBrightness, Properties_fReflectivity, twRMCObjectIx_Open, bError);
                     IF bError = 0
                   THEN
                          SELECT twRMCObjectIx_Open AS twRMCObject;
   
                             SET bCommit = 1;
                   ELSE 
                            CALL call_Error (-1, 'Failed to insert RMCObject', nError);
                 END IF ;
        END IF ;
       
            IF bCommit = 1
          THEN
                    SET bCommit = 0;
                 
                   CALL call_RMCObject_Log (RMCOBJECT_OP_RMCOBJECT_OPEN, sIPAddress, twRPersonaIx, twRMCObjectIx, bError);
                     IF bError = 0
                   THEN
                            CALL call_Event_Push (bError);
                              IF bError = 0
                            THEN
                                      SET bCommit = 1;
                            ELSE
                                     CALL call_Error (-9, 'Failed to push events', nError);
                          END IF ;
                   ELSE
                            CALL call_Error (-8, 'Failed to log action', nError);
                 END IF ;
        END IF ;

            IF bCommit = 0
          THEN
                 SELECT dwError, sError FROM Error;

               ROLLBACK ;
          ELSE
                 COMMIT ;
        END IF ;

          DROP TEMPORARY TABLE Error;
          DROP TEMPORARY TABLE Event;

           SET nResult = bCommit - 1 - nError;
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                       MVD_RP1_Map : set_RMCObject_RMTObject_Close.sql                                      ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                              Copyright 2023-2025 Metaversal Corporation. All rights reserved.                              ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE set_RMCObject_RMTObject_Close
(
   IN    sIPAddress                    VARCHAR (16),
   IN    twRPersonaIx                  BIGINT,
   IN    twRMCObjectIx                 BIGINT,
   IN    twRMTObjectIx_Close           BIGINT,
   IN    bDeleteAll                    TINYINT UNSIGNED,
   OUT   nResult                       INT
)
BEGIN
       DECLARE SBO_CLASS_RMTOBJECT                        INT DEFAULT 72;
       DECLARE RMCOBJECT_OP_RMTOBJECT_CLOSE               INT DEFAULT 14;

       DECLARE nError  INT DEFAULT 0;
       DECLARE bCommit INT DEFAULT 0;
       DECLARE bError  INT;

       DECLARE ObjectHead_Parent_wClass     SMALLINT;
       DECLARE ObjectHead_Parent_twObjectIx BIGINT;

       DECLARE nCount INT;

            -- Create the temp Error table
        CREATE TEMPORARY TABLE Error
               (
                  nOrder                        INT             NOT NULL AUTO_INCREMENT PRIMARY KEY,
                  dwError                       INT             NOT NULL,
                  sError                        VARCHAR (255)   NOT NULL
               );

            -- Create the temp Event table
        CREATE TEMPORARY TABLE Event
               (
                  nOrder                        INT             NOT NULL AUTO_INCREMENT PRIMARY KEY,
                  sType                         VARCHAR (50)    NOT NULL,
                  Self_wClass                   SMALLINT        NOT NULL,
                  Self_twObjectIx               BIGINT          NOT NULL,
                  Child_wClass                  SMALLINT        NOT NULL,
                  Child_twObjectIx              BIGINT          NOT NULL,
                  wFlags                        SMALLINT        NOT NULL,
                  twEventIz                     BIGINT          NOT NULL,
                  sJSON_Object                  TEXT            NOT NULL,
                  sJSON_Child                   TEXT            NOT NULL,
                  sJSON_Change                  TEXT            NOT NULL
               );

           SET twRPersonaIx        = IFNULL (twRPersonaIx,        0);
           SET twRMCObjectIx       = IFNULL (twRMCObjectIx,       0);
           SET twRMTObjectIx_Close = IFNULL (twRMTObjectIx_Close, 0);
           SET bDeleteAll          = IFNULL (bDeleteAll,          0);

         START TRANSACTION;

          CALL call_RMCObject_Validate (twRPersonaIx, twRMCObjectIx, ObjectHead_Parent_wClass, ObjectHead_Parent_twObjectIx, nError);
            IF nError = 0
          THEN
                 SELECT COUNT(*) INTO nCount
                   FROM RMTObject
                  WHERE ObjectHead_Parent_wClass     = SBO_CLASS_RMTOBJECT
                    AND ObjectHead_Parent_twObjectIx = twRMTObjectIx_Close;

                     IF twRMTObjectIx_Close <= 0
                   THEN
                            CALL call_Error (5, 'twRMTObjectIx_Close is invalid',   nError);
                 ELSEIF bDeleteAll = 0 AND nCount > 0
                   THEN
                            CALL call_Error (6, 'twRMTObjectIx_Close is not empty', nError);
                 END IF ;
        END IF ;

            IF nError = 0
          THEN
                   CALL call_RMCObject_Event_RMTObject_Close (twRMCObjectIx, twRMTObjectIx_Close, bError);
                     IF bError = 0
                   THEN
                             SET bCommit = 1;
                   ELSE 
                            CALL call_Error (-1, 'Failed to delete RMTObject', nError);
                 END IF ;
        END IF ;
       
            IF bCommit = 1
          THEN
                    SET bCommit = 0;
                 
                   CALL call_RMCObject_Log (RMCOBJECT_OP_RMTOBJECT_CLOSE, sIPAddress, twRPersonaIx, twRMCObjectIx, bError);
                     IF bError = 0
                   THEN
                            CALL call_Event_Push (bError);
                              IF bError = 0
                            THEN
                                      SET bCommit = 1;
                            ELSE
                                     CALL call_Error (-9, 'Failed to push events', nError);
                          END IF ;
                   ELSE
                            CALL call_Error (-8, 'Failed to log action', nError);
                 END IF ;
        END IF ;

            IF bCommit = 0
          THEN
                 SELECT dwError, sError FROM Error;

               ROLLBACK ;
          ELSE
                 COMMIT ;
        END IF ;

          DROP TEMPORARY TABLE Error;
          DROP TEMPORARY TABLE Event;

           SET nResult = bCommit - 1 - nError;
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                       MVD_RP1_Map : set_RMCObject_RMTObject_Open.sql                                       ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                              Copyright 2023-2025 Metaversal Corporation. All rights reserved.                              ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE set_RMCObject_RMTObject_Open
(
   IN    sIPAddress                    VARCHAR (16),
   IN    twRPersonaIx                  BIGINT,
   IN    twRMCObjectIx                 BIGINT,
   IN    Name_wsRMTObjectId            VARCHAR (48),
   IN    Type_bType                    TINYINT UNSIGNED,
   IN    Type_bSubtype                 TINYINT UNSIGNED,
   IN    Type_bFiction                 TINYINT UNSIGNED,
   IN    Owner_twRPersonaIx            BIGINT,
   IN    Resource_qwResource           BIGINT,
   IN    Resource_sName                VARCHAR (48),
   IN    Resource_sReference           VARCHAR (128),
   IN    Transform_Position_dX         DOUBLE,
   IN    Transform_Position_dY         DOUBLE,
   IN    Transform_Position_dZ         DOUBLE,
   IN    Transform_Rotation_dX         DOUBLE,
   IN    Transform_Rotation_dY         DOUBLE,
   IN    Transform_Rotation_dZ         DOUBLE,
   IN    Transform_Rotation_dW         DOUBLE,
   IN    Transform_Scale_dX            DOUBLE,
   IN    Transform_Scale_dY            DOUBLE,
   IN    Transform_Scale_dZ            DOUBLE,
   IN    Bound_dX                      DOUBLE,
   IN    Bound_dY                      DOUBLE,
   IN    Bound_dZ                      DOUBLE,
   IN    Properties_bLockToGround      TINYINT UNSIGNED,
   IN    Properties_bYouth             TINYINT UNSIGNED,
   IN    Properties_bAdult             TINYINT UNSIGNED,
   IN    Properties_bAvatar            TINYINT UNSIGNED,
   IN    bCoord                        TINYINT UNSIGNED,
   IN    dA                            DOUBLE,
   IN    dB                            DOUBLE,
   IN    dC                            DOUBLE,
   OUT   nResult                       INT
)
BEGIN
       DECLARE SBO_CLASS_RMCOBJECT                        INT DEFAULT 71;
       DECLARE RMCOBJECT_OP_RMTOBJECT_OPEN                INT DEFAULT 13;
       DECLARE RMTMATRIX_COORD_NUL                        INT DEFAULT 0;
       DECLARE RMTMATRIX_COORD_CAR                        INT DEFAULT 1;
       DECLARE RMTMATRIX_COORD_CYL                        INT DEFAULT 2;
       DECLARE RMTMATRIX_COORD_GEO                        INT DEFAULT 3;

       DECLARE nError  INT DEFAULT 0;
       DECLARE bCommit INT DEFAULT 0;
       DECLARE bError  INT;

       DECLARE ObjectHead_Parent_wClass     SMALLINT;
       DECLARE ObjectHead_Parent_twObjectIx BIGINT;

       DECLARE twRMTObjectIx_Open           BIGINT;

            -- Create the temp Error table
        CREATE TEMPORARY TABLE Error
               (
                  nOrder                        INT             NOT NULL AUTO_INCREMENT PRIMARY KEY,
                  dwError                       INT             NOT NULL,
                  sError                        VARCHAR (255)   NOT NULL
               );

            -- Create the temp Event table
        CREATE TEMPORARY TABLE Event
               (
                  nOrder                        INT             NOT NULL AUTO_INCREMENT PRIMARY KEY,
                  sType                         VARCHAR (50)    NOT NULL,
                  Self_wClass                   SMALLINT        NOT NULL,
                  Self_twObjectIx               BIGINT          NOT NULL,
                  Child_wClass                  SMALLINT        NOT NULL,
                  Child_twObjectIx              BIGINT          NOT NULL,
                  wFlags                        SMALLINT        NOT NULL,
                  twEventIz                     BIGINT          NOT NULL,
                  sJSON_Object                  TEXT            NOT NULL,
                  sJSON_Child                   TEXT            NOT NULL,
                  sJSON_Change                  TEXT            NOT NULL
               );

           SET twRPersonaIx  = IFNULL (twRPersonaIx,  0);
           SET twRMCObjectIx = IFNULL (twRMCObjectIx, 0);

         START TRANSACTION;

          CALL call_RMCObject_Validate (twRPersonaIx, twRMCObjectIx, ObjectHead_Parent_wClass, ObjectHead_Parent_twObjectIx, nError);
            IF nError = 0
          THEN
                   CALL call_RMTObject_Validate_Name       (SBO_CLASS_RMCOBJECT, twRMCObjectIx, 0, Name_wsRMTObjectId, nError);
                   CALL call_RMTObject_Validate_Type       (SBO_CLASS_RMCOBJECT, twRMCObjectIx, 0, Type_bType, Type_bSubtype, Type_bFiction, nError);
                   CALL call_RMTObject_Validate_Owner      (SBO_CLASS_RMCOBJECT, twRMCObjectIx, 0, Owner_twRPersonaIx, nError);
                   CALL call_RMTObject_Validate_Resource   (SBO_CLASS_RMCOBJECT, twRMCObjectIx, 0, Resource_qwResource, Resource_sName, Resource_sReference, nError);
                -- CALL call_RMTObject_Validate_Transform  (SBO_CLASS_RMCOBJECT, twRMCObjectIx, 0, Transform_Position_dX, Transform_Position_dY, Transform_Position_dZ, Transform_Rotation_dX, Transform_Rotation_dY, Transform_Rotation_dZ, Transform_Rotation_dW, Transform_Scale_dX, Transform_Scale_dY, Transform_Scale_dZ, nError);
                   CALL call_RMTObject_Validate_Bound      (SBO_CLASS_RMCOBJECT, twRMCObjectIx, 0, Bound_dX, Bound_dY, Bound_dZ, nError);
                   CALL call_RMTObject_Validate_Properties (SBO_CLASS_RMCOBJECT, twRMCObjectIx, 0, Properties_bLockToGround, Properties_bYouth, Properties_bAdult, Properties_bAvatar, nError);

                     IF bCoord = 3 -- RMTMATRIX_COORD_NUL
                   THEN
                        CALL call_RMTObject_Validate_Coord_Nul (SBO_CLASS_RMCOBJECT, twRMCObjectIx, 0, Transform_Position_dX, Transform_Position_dY, Transform_Position_dZ, Transform_Rotation_dX, Transform_Rotation_dY, Transform_Rotation_dZ, Transform_Rotation_dW, Transform_Scale_dX, Transform_Scale_dY, Transform_Scale_dZ, nError);
                 ELSEIF bCoord = 2 -- RMTMATRIX_COORD_CAR
                   THEN
                        CALL call_RMTObject_Validate_Coord_Car (SBO_CLASS_RMCOBJECT, twRMCObjectIx, 0, dA, dB, dC, nError);
                 ELSEIF bCoord = 1 -- RMTMATRIX_COORD_CYL
                   THEN
                        CALL call_RMTObject_Validate_Coord_Cyl (SBO_CLASS_RMCOBJECT, twRMCObjectIx, 0, dA, dB, dC, nError);
                 ELSEIF bCoord = 0 -- RMTMATRIX_COORD_GEO
                   THEN
                        CALL call_RMTObject_Validate_Coord_Geo (SBO_CLASS_RMCOBJECT, twRMCObjectIx, 0, dA, dB, dC, nError);
                   ELSE 
                        CALL call_Error (99, 'bCoord is invalid', nError);
                 END IF ;
        END IF ;

            IF nError = 0
          THEN
                   CALL call_RMCObject_Event_RMTObject_Open (twRMCObjectIx, Name_wsRMTObjectId, Type_bType, Type_bSubtype, Type_bFiction, Owner_twRPersonaIx, Resource_qwResource, Resource_sName, Resource_sReference, Transform_Position_dX, Transform_Position_dY, Transform_Position_dZ, Transform_Rotation_dX, Transform_Rotation_dY, Transform_Rotation_dZ, Transform_Rotation_dW, Transform_Scale_dX, Transform_Scale_dY, Transform_Scale_dZ, Bound_dX, Bound_dY, Bound_dZ, Properties_bLockToGround, Properties_bYouth, Properties_bAdult, Properties_bAvatar, twRMTObjectIx_Open, bError);
                     IF bError = 0
                   THEN
                              IF bCoord = 3 -- RMTMATRIX_COORD_NUL
                            THEN
                                 CALL call_RMTMatrix_Nul (SBO_CLASS_RMCOBJECT, twRMCObjectIx, twRMTObjectIx_Open, Transform_Position_dX, Transform_Position_dY, Transform_Position_dZ, Transform_Rotation_dX, Transform_Rotation_dY, Transform_Rotation_dZ, Transform_Rotation_dW, Transform_Scale_dX, Transform_Scale_dY, Transform_Scale_dZ);
                          ELSEIF bCoord = 2 -- RMTMATRIX_COORD_CAR
                            THEN
                                 CALL call_RMTMatrix_Car (twRMTObjectIx_Open, dA, dB, dC);
                          ELSEIF bCoord = 1 -- RMTMATRIX_COORD_CYL
                            THEN
                                 CALL call_RMTMatrix_Cyl (twRMTObjectIx_Open, dA, dB, dC);
                          ELSEIF bCoord = 0 -- RMTMATRIX_COORD_GEO
                            THEN
                                 CALL call_RMTMatrix_Geo (twRMTObjectIx_Open, dA, dB, dC);
                          END IF ;

                            CALL call_RMTMatrix_Relative (SBO_CLASS_RMCOBJECT, twRMCObjectIx, twRMTObjectIx_Open);

                          SELECT twRMTObjectIx_Open AS twRMTObject;
   
                             SET bCommit = 1;
                   ELSE 
                            CALL call_Error (-1, 'Failed to insert RMTObject', nError);
                 END IF ;
        END IF ;
       
            IF bCommit = 1
          THEN
                    SET bCommit = 0;
                 
                   CALL call_RMCObject_Log (RMCOBJECT_OP_RMTOBJECT_OPEN, sIPAddress, twRPersonaIx, twRMCObjectIx, bError);
                     IF bError = 0
                   THEN
                            CALL call_Event_Push (bError);
                              IF bError = 0
                            THEN
                                      SET bCommit = 1;
                            ELSE
                                     CALL call_Error (-9, 'Failed to push events', nError);
                          END IF ;
                   ELSE
                            CALL call_Error (-8, 'Failed to log action', nError);
                 END IF ;
        END IF ;

            IF bCommit = 0
          THEN
                 SELECT dwError, sError FROM Error;

               ROLLBACK ;
          ELSE
                 COMMIT ;
        END IF ;

          DROP TEMPORARY TABLE Error;
          DROP TEMPORARY TABLE Event;

           SET nResult = bCommit - 1 - nError;
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                          MVD_RP1_Map : set_RMCObject_Transform.sql                                         ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                              Copyright 2023-2025 Metaversal Corporation. All rights reserved.                              ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE set_RMCObject_Transform
(
   IN    sIPAddress                    VARCHAR (16),
   IN    twRPersonaIx                  BIGINT,
   IN    twRMCObjectIx                 BIGINT,
   IN    Transform_Position_dX         DOUBLE,
   IN    Transform_Position_dY         DOUBLE,
   IN    Transform_Position_dZ         DOUBLE,
   IN    Transform_Rotation_dX         DOUBLE,
   IN    Transform_Rotation_dY         DOUBLE,
   IN    Transform_Rotation_dZ         DOUBLE,
   IN    Transform_Rotation_dW         DOUBLE,
   IN    Transform_Scale_dX            DOUBLE,
   IN    Transform_Scale_dY            DOUBLE,
   IN    Transform_Scale_dZ            DOUBLE,
   OUT   nResult                       INT
)
BEGIN
       DECLARE RMCOBJECT_OP_TRANSFORM                     INT DEFAULT 5;

       DECLARE nError  INT DEFAULT 0;
       DECLARE bCommit INT DEFAULT 0;
       DECLARE bError  INT;

       DECLARE ObjectHead_Parent_wClass     SMALLINT;
       DECLARE ObjectHead_Parent_twObjectIx BIGINT;

            -- Create the temp Error table
        CREATE TEMPORARY TABLE Error
               (
                  nOrder                        INT             NOT NULL AUTO_INCREMENT PRIMARY KEY,
                  dwError                       INT             NOT NULL,
                  sError                        VARCHAR (255)   NOT NULL
               );

            -- Create the temp Event table
        CREATE TEMPORARY TABLE Event
               (
                  nOrder                        INT             NOT NULL AUTO_INCREMENT PRIMARY KEY,
                  sType                         VARCHAR (50)    NOT NULL,
                  Self_wClass                   SMALLINT        NOT NULL,
                  Self_twObjectIx               BIGINT          NOT NULL,
                  Child_wClass                  SMALLINT        NOT NULL,
                  Child_twObjectIx              BIGINT          NOT NULL,
                  wFlags                        SMALLINT        NOT NULL,
                  twEventIz                     BIGINT          NOT NULL,
                  sJSON_Object                  TEXT            NOT NULL,
                  sJSON_Child                   TEXT            NOT NULL,
                  sJSON_Change                  TEXT            NOT NULL
               );

           SET twRPersonaIx  = IFNULL (twRPersonaIx,  0);
           SET twRMCObjectIx = IFNULL (twRMCObjectIx, 0);

         START TRANSACTION;

          CALL call_RMCObject_Validate (twRPersonaIx, twRMCObjectIx, ObjectHead_Parent_wClass, ObjectHead_Parent_twObjectIx, nError);
            IF nError = 0
          THEN
                   CALL call_RMCObject_Validate_Transform (ObjectHead_Parent_wClass, ObjectHead_Parent_twObjectIx, twRMCObjectIx, Transform_Position_dX, Transform_Position_dY, Transform_Position_dZ, Transform_Rotation_dX, Transform_Rotation_dY, Transform_Rotation_dZ, Transform_Rotation_dW, Transform_Scale_dX, Transform_Scale_dY, Transform_Scale_dZ, nError);
        END IF ;

            IF nError = 0
          THEN
                   CALL call_RMCObject_Event_Transform (twRMCObjectIx, Transform_Position_dX, Transform_Position_dY, Transform_Position_dZ, Transform_Rotation_dX, Transform_Rotation_dY, Transform_Rotation_dZ, Transform_Rotation_dW, Transform_Scale_dX, Transform_Scale_dY, Transform_Scale_dZ, bError);
                     IF bError = 0
                   THEN
                             SET bCommit = 1;
                   ELSE 
                            CALL call_Error (-1, 'Failed to update RMCObject', nError);
                 END IF ;
        END IF ;
       
            IF bCommit = 1
          THEN
                    SET bCommit = 0;
                 
                   CALL call_RMCObject_Log (RMCOBJECT_OP_TRANSFORM, sIPAddress, twRPersonaIx, twRMCObjectIx, bError);
                     IF bError = 0
                   THEN
                            CALL call_Event_Push (bError);
                              IF bError = 0
                            THEN
                                      SET bCommit = 1;
                            ELSE
                                     CALL call_Error (-9, 'Failed to push events', nError);
                          END IF ;
                   ELSE
                            CALL call_Error (-8, 'Failed to log action', nError);
                 END IF ;
        END IF ;

            IF bCommit = 0
          THEN
                 SELECT dwError, sError FROM Error;

               ROLLBACK ;
          ELSE
                 COMMIT ;
        END IF ;

          DROP TEMPORARY TABLE Error;
          DROP TEMPORARY TABLE Event;

           SET nResult = bCommit - 1 - nError;
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                            MVD_RP1_Map : set_RMCObject_Type.sql                                            ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                              Copyright 2023-2025 Metaversal Corporation. All rights reserved.                              ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE set_RMCObject_Type
(
   IN    sIPAddress                    VARCHAR (16),
   IN    twRPersonaIx                  BIGINT,
   IN    twRMCObjectIx                 BIGINT,
   IN    Type_bType                    TINYINT UNSIGNED,
   IN    Type_bSubtype                 TINYINT UNSIGNED,
   IN    Type_bFiction                 TINYINT UNSIGNED,
   OUT   nResult                       INT
)
BEGIN
       DECLARE RMCOBJECT_OP_TYPE                          INT DEFAULT 2;

       DECLARE nError  INT DEFAULT 0;
       DECLARE bCommit INT DEFAULT 0;
       DECLARE bError  INT;

       DECLARE ObjectHead_Parent_wClass     SMALLINT;
       DECLARE ObjectHead_Parent_twObjectIx BIGINT;

            -- Create the temp Error table
        CREATE TEMPORARY TABLE Error
               (
                  nOrder                        INT             NOT NULL AUTO_INCREMENT PRIMARY KEY,
                  dwError                       INT             NOT NULL,
                  sError                        VARCHAR (255)   NOT NULL
               );

            -- Create the temp Event table
        CREATE TEMPORARY TABLE Event
               (
                  nOrder                        INT             NOT NULL AUTO_INCREMENT PRIMARY KEY,
                  sType                         VARCHAR (50)    NOT NULL,
                  Self_wClass                   SMALLINT        NOT NULL,
                  Self_twObjectIx               BIGINT          NOT NULL,
                  Child_wClass                  SMALLINT        NOT NULL,
                  Child_twObjectIx              BIGINT          NOT NULL,
                  wFlags                        SMALLINT        NOT NULL,
                  twEventIz                     BIGINT          NOT NULL,
                  sJSON_Object                  TEXT            NOT NULL,
                  sJSON_Child                   TEXT            NOT NULL,
                  sJSON_Change                  TEXT            NOT NULL
               );

           SET twRPersonaIx  = IFNULL (twRPersonaIx,  0);
           SET twRMCObjectIx = IFNULL (twRMCObjectIx, 0);

         START TRANSACTION;

          CALL call_RMCObject_Validate (twRPersonaIx, twRMCObjectIx, ObjectHead_Parent_wClass, ObjectHead_Parent_twObjectIx, nError);
            IF nError = 0
          THEN
                   CALL call_RMCObject_Validate_Type (ObjectHead_Parent_wClass, ObjectHead_Parent_twObjectIx, twRMCObjectIx, Type_bType, Type_bSubtype, Type_bFiction, nError);
        END IF ;

            IF nError = 0
          THEN
                   CALL call_RMCObject_Event_Type (twRMCObjectIx, Type_bType, Type_bSubtype, Type_bFiction, bError);
                     IF bError = 0
                   THEN
                             SET bCommit = 1;
                   ELSE 
                            CALL call_Error (-1, 'Failed to update RMCObject', nError);
                 END IF ;
        END IF ;
       
            IF bCommit = 1
          THEN
                    SET bCommit = 0;
                 
                   CALL call_RMCObject_Log (RMCOBJECT_OP_TYPE, sIPAddress, twRPersonaIx, twRMCObjectIx, bError);
                     IF bError = 0
                   THEN
                            CALL call_Event_Push (bError);
                              IF bError = 0
                            THEN
                                      SET bCommit = 1;
                            ELSE
                                     CALL call_Error (-9, 'Failed to push events', nError);
                          END IF ;
                   ELSE
                            CALL call_Error (-8, 'Failed to log action', nError);
                 END IF ;
        END IF ;

            IF bCommit = 0
          THEN
                 SELECT dwError, sError FROM Error;

               ROLLBACK ;
          ELSE
                 COMMIT ;
        END IF ;

          DROP TEMPORARY TABLE Error;
          DROP TEMPORARY TABLE Event;

           SET nResult = bCommit - 1 - nError;
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                             MVD_RP1_Map : call_RMRoot_Event.sql                                            ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2025 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE call_RMRoot_Event
(
   IN    twRMRootIx                    BIGINT,
   OUT   twEventIz                     BIGINT,
   OUT   bError                        INT
)
BEGIN
        SELECT ObjectHead_twEventIz
          INTO twEventIz
          FROM RMRoot
         WHERE ObjectHead_Self_twObjectIx = twRMRootIx;

            -- Success will be tested on the update below

        UPDATE RMRoot
           SET ObjectHead_twEventIz = ObjectHead_twEventIz + 1
         WHERE ObjectHead_Self_twObjectIx = twRMRootIx;

           SET bError = IF (ROW_COUNT () = 1, 0, 1);
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                          MVD_RP1_Map : call_RMRoot_Event_Name.sql                                          ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2023 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE call_RMRoot_Event_Name
(
   IN    twRMRootIx                    BIGINT,
   IN    Name_wsRMRootId               VARCHAR (48),
   OUT   bError                        INT
)
BEGIN
       DECLARE SBO_CLASS_NULL                             INT DEFAULT 0;
       DECLARE SBO_CLASS_RMROOT                           INT DEFAULT 70;

       DECLARE twEventIz BIGINT;

          CALL call_RMRoot_Event (twRMRootIx, twEventIz, bError);
            IF bError = 0
          THEN
                 UPDATE RMRoot
                    SET Name_wsRMRootId = Name_wsRMRootId
                  WHERE ObjectHead_Self_twObjectIx = twRMRootIx;

                    SET bError = IF (ROW_COUNT () = 1, 0, 1);

                     IF bError = 0
                   THEN
                          INSERT INTO Event
                                 (sType, Self_wClass, Self_twObjectIx, Child_wClass, Child_twObjectIx, wFlags, twEventIz, sJSON_Object, sJSON_Child, sJSON_Change)
                          SELECT 'NAME',

                                 SBO_CLASS_RMROOT,
                                 twRMRootIx,
                                 SBO_CLASS_NULL,
                                 0,
                                 0,
                                 twEventIz,

                                 CONCAT
                                 (
                                   '{ ',
                                     '"pName": ',         Format_Name_R
                                                          (
                                                             Name_wsRMRootId
                                                          ),
                                  ' }'
                                 ),

                                 '{ }',

                                 '{ }';

                               SET bError = IF (ROW_COUNT () = 1, 0, 1);
                 END IF ;
        END IF ;
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                          MVD_RP1_Map : call_RMRoot_Event_Owner.sql                                         ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2023 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE call_RMRoot_Event_Owner
(
   IN    twRMRootIx                    BIGINT,
   IN    Owner_twRPersonaIx            BIGINT,
   OUT   bError                        INT
)
BEGIN
       DECLARE SBO_CLASS_NULL                             INT DEFAULT 0;
       DECLARE SBO_CLASS_RMROOT                           INT DEFAULT 70;

       DECLARE twEventIz BIGINT;

          CALL call_RMRoot_Event (twRMRootIx, twEventIz, bError);
            IF bError = 0
          THEN
                 UPDATE RMRoot
                    SET Owner_twRPersonaIx = Owner_twRPersonaIx
                  WHERE ObjectHead_Self_twObjectIx = twRMRootIx;

                    SET bError = IF (ROW_COUNT () = 1, 0, 1);

                     IF bError = 0
                   THEN
                          INSERT INTO Event
                                 (sType, Self_wClass, Self_twObjectIx, Child_wClass, Child_twObjectIx, wFlags, twEventIz, sJSON_Object, sJSON_Child, sJSON_Change)
                          SELECT 'OWNER',

                                 SBO_CLASS_RMROOT,
                                 twRMRootIx,
                                 SBO_CLASS_NULL,
                                 0,
                                 0,
                                 twEventIz,

                                 CONCAT
                                 (
                                   '{ ',
                                     '"pOwner": ',        Format_Owner
                                                          (
                                                             Owner_twRPersonaIx
                                                          ),
                                  ' }'
                                 ),

                                 '{ }',

                                 '{ }';

                               SET bError = IF (ROW_COUNT () = 1, 0, 1);
                 END IF ;
        END IF ;
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                     MVD_RP1_Map : call_RMRoot_Event_RMCObject_Close.sql                                    ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2023 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE call_RMRoot_Event_RMCObject_Close
(
   IN    twRMRootIx                    BIGINT,
   IN    twRMCObjectIx                 BIGINT,
   OUT   bError                        INT
)
BEGIN
       DECLARE SBO_CLASS_RMROOT                           INT DEFAULT 70;
       DECLARE SBO_CLASS_RMCOBJECT                        INT DEFAULT 71;
       DECLARE SBA_SUBSCRIBE_REFRESH_EVENT_EX_FLAG_CLOSE  INT DEFAULT 0x02;

       DECLARE twEventIz BIGINT;

          CALL call_RMRoot_Event (twRMRootIx, twEventIz, bError);
            IF bError = 0
          THEN
                 DELETE FROM RMCObject                                        -- we actually want to delete the entire tree - all the way down to the pobject!
                  WHERE ObjectHead_Self_twObjectIx = twRMCObjectIx;

                    SET bError = IF (ROW_COUNT () = 1, 0, 1);

                     IF bError = 0
                   THEN
                          INSERT INTO Event
                                 (sType, Self_wClass, Self_twObjectIx, Child_wClass, Child_twObjectIx, wFlags, twEventIz, sJSON_Object, sJSON_Child, sJSON_Change)
                          SELECT 'RMCOBJECT_CLOSE',

                                 SBO_CLASS_RMROOT,
                                 twRMRootIx,
                                 SBO_CLASS_RMCOBJECT,
                                 twRMCObjectIx,
                                 SBA_SUBSCRIBE_REFRESH_EVENT_EX_FLAG_CLOSE,
                                 twEventIz,

                                 '{ }',

                                 '{ }',

                                 '{ }';

                               SET bError = IF (ROW_COUNT () = 1, 0, 1);
                 END IF ;
        END IF ;
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                     MVD_RP1_Map : call_RMRoot_Event_RMCObject_Open.sql                                     ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2023 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE call_RMRoot_Event_RMCObject_Open
(
   IN    twRMRootIx                    BIGINT,
   IN    Name_wsRMCObjectId            VARCHAR (48),
   IN    Type_bType                    TINYINT UNSIGNED,
   IN    Type_bSubtype                 TINYINT UNSIGNED,
   IN    Type_bFiction                 TINYINT UNSIGNED,
   IN    Owner_twRPersonaIx            BIGINT,
   IN    Resource_qwResource           BIGINT,
   IN    Resource_sName                VARCHAR (48),
   IN    Resource_sReference           VARCHAR (128),
   IN    Transform_Position_dX         DOUBLE,
   IN    Transform_Position_dY         DOUBLE,
   IN    Transform_Position_dZ         DOUBLE,
   IN    Transform_Rotation_dX         DOUBLE,
   IN    Transform_Rotation_dY         DOUBLE,
   IN    Transform_Rotation_dZ         DOUBLE,
   IN    Transform_Rotation_dW         DOUBLE,
   IN    Transform_Scale_dX            DOUBLE,
   IN    Transform_Scale_dY            DOUBLE,
   IN    Transform_Scale_dZ            DOUBLE,
   IN    Orbit_Spin_tmPeriod           BIGINT,
   IN    Orbit_Spin_tmStart            BIGINT,
   IN    Orbit_Spin_dA                 DOUBLE,
   IN    Orbit_Spin_dB                 DOUBLE,
   IN    Bound_dX                      DOUBLE,
   IN    Bound_dY                      DOUBLE,
   IN    Bound_dZ                      DOUBLE,
   IN    Properties_fMass              FLOAT,
   IN    Properties_fGravity           FLOAT,
   IN    Properties_fColor             FLOAT,
   IN    Properties_fBrightness        FLOAT,
   IN    Properties_fReflectivity      FLOAT,
   OUT   twRMCObjectIx                 BIGINT,
   OUT   bError                        INT
)
BEGIN
       DECLARE SBO_CLASS_RMROOT                           INT DEFAULT 70;
       DECLARE SBO_CLASS_RMCOBJECT                        INT DEFAULT 71;
       DECLARE SBA_SUBSCRIBE_REFRESH_EVENT_EX_FLAG_OPEN   INT DEFAULT 0x01;

       DECLARE twEventIz BIGINT;

          CALL call_RMRoot_Event (twRMRootIx, twEventIz, bError);
            IF bError = 0
          THEN
                 INSERT INTO RMCObject
                        (ObjectHead_Parent_wClass, ObjectHead_Parent_twObjectIx, ObjectHead_Self_wClass, ObjectHead_twEventIz, ObjectHead_wFlags, Name_wsRMCObjectId, Type_bType, Type_bSubtype, Type_bFiction, Owner_twRPersonaIx, Resource_qwResource, Resource_sName, Resource_sReference, Transform_Position_dX, Transform_Position_dY, Transform_Position_dZ, Transform_Rotation_dX, Transform_Rotation_dY, Transform_Rotation_dZ, Transform_Rotation_dW, Transform_Scale_dX, Transform_Scale_dY, Transform_Scale_dZ, Orbit_Spin_tmPeriod, Orbit_Spin_tmStart, Orbit_Spin_dA, Orbit_Spin_dB, Bound_dX, Bound_dY, Bound_dZ, Properties_fMass, Properties_fGravity, Properties_fColor, Properties_fBrightness, Properties_fReflectivity)
                 VALUES (SBO_CLASS_RMROOT,         twRMRootIx,                   SBO_CLASS_RMCOBJECT,    0,                    32,                Name_wsRMCObjectId, Type_bType, Type_bSubtype, Type_bFiction, Owner_twRPersonaIx, Resource_qwResource, Resource_sName, Resource_sReference, Transform_Position_dX, Transform_Position_dY, Transform_Position_dZ, Transform_Rotation_dX, Transform_Rotation_dY, Transform_Rotation_dZ, Transform_Rotation_dW, Transform_Scale_dX, Transform_Scale_dY, Transform_Scale_dZ, Orbit_Spin_tmPeriod, Orbit_Spin_tmStart, Orbit_Spin_dA, Orbit_Spin_dB, Bound_dX, Bound_dY, Bound_dZ, Properties_fMass, Properties_fGravity, Properties_fColor, Properties_fBrightness, Properties_fReflectivity);

                    SET bError = IF (ROW_COUNT () = 1, 0, 1);

                     IF bError = 0
                   THEN
                             SET twRMCObjectIx = LAST_INSERT_ID ();

                          INSERT INTO Event
                                 (sType, Self_wClass, Self_twObjectIx, Child_wClass, Child_twObjectIx, wFlags, twEventIz, sJSON_Object, sJSON_Child, sJSON_Change)
                          SELECT 'RMCOBJECT_OPEN',

                                 SBO_CLASS_RMROOT,
                                 twRMRootIx,
                                 SBO_CLASS_RMCOBJECT,
                                 twRMCObjectIx,
                                 SBA_SUBSCRIBE_REFRESH_EVENT_EX_FLAG_OPEN,
                                 twEventIz,

                                 '{ }',

                                 CONCAT
                                 (
                                   '{ ',
                                     '"pName": ',         Format_Name_C
                                                          (
                                                             Name_wsRMCObjectId
                                                          ),
                                   ', "pType": ',         Format_Type_C
                                                          (
                                                             Type_bType,
                                                             Type_bSubtype,
                                                             Type_bFiction
                                                          ),
                                   ', "pOwner": ',        Format_Owner
                                                          (
                                                             Owner_twRPersonaIx
                                                          ),
                                   ', "pResource": ',     Format_Resource
                                                          (
                                                             Resource_qwResource,
                                                             Resource_sName,
                                                             Resource_sReference
                                                          ),
                                   ', "pTransform": ',    Format_Transform
                                                          (
                                                             Transform_Position_dX,
                                                             Transform_Position_dY,
                                                             Transform_Position_dZ,
                                                             Transform_Rotation_dX,
                                                             Transform_Rotation_dY,
                                                             Transform_Rotation_dZ,
                                                             Transform_Rotation_dW,
                                                             Transform_Scale_dX,
                                                             Transform_Scale_dY,
                                                             Transform_Scale_dZ
                                                          ),
                                   ', "pOrbit_Spin": ',   Format_Orbit_Spin
                                                          (
                                                             Orbit_Spin_tmPeriod,
                                                             Orbit_Spin_tmStart,
                                                             Orbit_Spin_dA,
                                                             Orbit_Spin_dB
                                                          ),
                                   ', "pBound": ',        Format_Bound
                                                          (
                                                             Bound_dX,
                                                             Bound_dY,
                                                             Bound_dZ
                                                          ),
                                   ', "pProperties": ',   Format_Properties_C
                                                          (
                                                             Properties_fMass,
                                                             Properties_fGravity,
                                                             Properties_fColor,
                                                             Properties_fBrightness,
                                                             Properties_fReflectivity
                                                          ),
                                  ' }'
                                 ),

                                 '{ }';

                             SET bError = IF (ROW_COUNT () = 1, 0, 1);
                 END IF ;
        END IF ;
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                     MVD_RP1_Map : call_RMRoot_Event_RMPObject_Close.sql                                    ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2023 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE call_RMRoot_Event_RMPObject_Close
(
   IN    twRMRootIx                    BIGINT,
   IN    twRMPObjectIx_Close           BIGINT,
   OUT   bError                        INT,
   IN    bReparent                     TINYINT UNSIGNED
)
BEGIN
       DECLARE SBO_CLASS_RMROOT                           INT DEFAULT 70;
       DECLARE SBO_CLASS_RMPOBJECT                        INT DEFAULT 73;
       DECLARE SBA_SUBSCRIBE_REFRESH_EVENT_EX_FLAG_CLOSE  INT DEFAULT 0x02;

       DECLARE twEventIz BIGINT;

          CALL call_RMRoot_Event (twRMRootIx, twEventIz, bError);
            IF bError = 0
          THEN
                     IF bReparent = 0
                   THEN
                          DELETE FROM RMPObject                                        -- we actually want to delete the entire tree - all the way down to the pobject!
                           WHERE ObjectHead_Self_twObjectIx = twRMPObjectIx_Close;
         
                             SET bError = IF (ROW_COUNT () = 1, 0, 1);
                 END IF ;

                     IF bError = 0
                   THEN
                          INSERT INTO Event
                                 (sType, Self_wClass, Self_twObjectIx, Child_wClass, Child_twObjectIx, wFlags, twEventIz, sJSON_Object, sJSON_Child, sJSON_Change)
                          SELECT 'RMPOBJECT_CLOSE',

                                 SBO_CLASS_RMROOT,
                                 twRMRootIx,
                                 SBO_CLASS_RMPOBJECT,
                                 twRMPObjectIx_Close,
                                 SBA_SUBSCRIBE_REFRESH_EVENT_EX_FLAG_CLOSE,
                                 twEventIz,

                                 '{ }',

                                 '{ }',

                                 '{ }';

                             SET bError = IF (ROW_COUNT () = 1, 0, 1);
                 END IF ;
        END IF ;
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                     MVD_RP1_Map : call_RMRoot_Event_RMPObject_Open.sql                                     ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2023 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE call_RMRoot_Event_RMPObject_Open
(
   IN    twRMRootIx                    BIGINT,
   IN    Name_wsRMPObjectId            VARCHAR (48),
   IN    Type_bType                    TINYINT UNSIGNED,
   IN    Type_bSubtype                 TINYINT UNSIGNED,
   IN    Type_bFiction                 TINYINT UNSIGNED,
   IN    Type_bMovable                 TINYINT UNSIGNED,
   IN    Owner_twRPersonaIx            BIGINT,
   IN    Resource_qwResource           BIGINT,
   IN    Resource_sName                VARCHAR (48),
   IN    Resource_sReference           VARCHAR (128),
   IN    Transform_Position_dX         DOUBLE,
   IN    Transform_Position_dY         DOUBLE,
   IN    Transform_Position_dZ         DOUBLE,
   IN    Transform_Rotation_dX         DOUBLE,
   IN    Transform_Rotation_dY         DOUBLE,
   IN    Transform_Rotation_dZ         DOUBLE,
   IN    Transform_Rotation_dW         DOUBLE,
   IN    Transform_Scale_dX            DOUBLE,
   IN    Transform_Scale_dY            DOUBLE,
   IN    Transform_Scale_dZ            DOUBLE,
   IN    Bound_dX                      DOUBLE,
   IN    Bound_dY                      DOUBLE,
   IN    Bound_dZ                      DOUBLE,
   OUT   twRMPObjectIx_Open            BIGINT,
   OUT   bError                        INT,
   IN    bReparent                     TINYINT UNSIGNED
)
BEGIN
       DECLARE SBO_CLASS_RMROOT                           INT DEFAULT 70;
       DECLARE SBO_CLASS_RMPOBJECT                        INT DEFAULT 73;
       DECLARE SBA_SUBSCRIBE_REFRESH_EVENT_EX_FLAG_OPEN   INT DEFAULT 0x01;

       DECLARE twEventIz BIGINT;

          CALL call_RMRoot_Event (twRMRootIx, twEventIz, bError);
            IF bError = 0
          THEN
                     IF bReparent = 0
                   THEN
                          INSERT INTO RMPObject
                                 (ObjectHead_Parent_wClass, ObjectHead_Parent_twObjectIx, ObjectHead_Self_wClass, ObjectHead_twEventIz, ObjectHead_wFlags, Name_wsRMPObjectId, Type_bType, Type_bSubtype, Type_bFiction, Type_bMovable, Owner_twRPersonaIx, Resource_qwResource, Resource_sName, Resource_sReference, Transform_Position_dX, Transform_Position_dY, Transform_Position_dZ, Transform_Rotation_dX, Transform_Rotation_dY, Transform_Rotation_dZ, Transform_Rotation_dW, Transform_Scale_dX, Transform_Scale_dY, Transform_Scale_dZ, Bound_dX, Bound_dY, Bound_dZ)
                          VALUES (SBO_CLASS_RMROOT,         twRMRootIx,                   SBO_CLASS_RMPOBJECT,    0,                    32,                Name_wsRMPObjectId, Type_bType, Type_bSubtype, Type_bFiction, Type_bMovable, Owner_twRPersonaIx, Resource_qwResource, Resource_sName, Resource_sReference, Transform_Position_dX, Transform_Position_dY, Transform_Position_dZ, Transform_Rotation_dX, Transform_Rotation_dY, Transform_Rotation_dZ, Transform_Rotation_dW, Transform_Scale_dX, Transform_Scale_dY, Transform_Scale_dZ, Bound_dX, Bound_dY, Bound_dZ);
         
                             SET bError = IF (ROW_COUNT () = 1, 0, 1);

                             SET twRMPObjectIx_Open = LAST_INSERT_ID ();
                 END IF ;

                     IF bError = 0
                   THEN
                          INSERT INTO Event
                                 (sType, Self_wClass, Self_twObjectIx, Child_wClass, Child_twObjectIx, wFlags, twEventIz, sJSON_Object, sJSON_Child, sJSON_Change)
                          SELECT 'RMPOBJECT_OPEN',

                                 SBO_CLASS_RMROOT,
                                 twRMRootIx,
                                 SBO_CLASS_RMPOBJECT,
                                 twRMPObjectIx_Open,
                                 SBA_SUBSCRIBE_REFRESH_EVENT_EX_FLAG_OPEN,
                                 twEventIz,

                                 '{ }',

                                 CONCAT
                                 (
                                   '{ ',
                                     '"pName": ',         Format_Name_P
                                                          (
                                                             Name_wsRMPObjectId
                                                          ),
                                   ', "pType": ',         Format_Type_P
                                                          (
                                                             Type_bType,
                                                             Type_bSubtype,
                                                             Type_bFiction,
                                                             Type_bMovable
                                                          ),
                                   ', "pOwner": ',        Format_Owner
                                                          (
                                                             Owner_twRPersonaIx
                                                          ),
                                   ', "pResource": ',     Format_Resource
                                                          (
                                                             Resource_qwResource,
                                                             Resource_sName,
                                                             Resource_sReference
                                                          ),
                                   ', "pTransform": ',    Format_Transform
                                                          (
                                                             Transform_Position_dX,
                                                             Transform_Position_dY,
                                                             Transform_Position_dZ,
                                                             Transform_Rotation_dX,
                                                             Transform_Rotation_dY,
                                                             Transform_Rotation_dZ,
                                                             Transform_Rotation_dW,
                                                             Transform_Scale_dX,
                                                             Transform_Scale_dY,
                                                             Transform_Scale_dZ
                                                          ),
                                   ', "pBound": ',        Format_Bound
                                                          (
                                                             Bound_dX,
                                                             Bound_dY,
                                                             Bound_dZ
                                                          ),
                                  ' }'
                                 ),

                                 '{ }';

                             SET bError = IF (ROW_COUNT () = 1, 0, 1);
                 END IF ;
        END IF ;
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                     MVD_RP1_Map : call_RMRoot_Event_RMTObject_Close.sql                                    ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2023 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE call_RMRoot_Event_RMTObject_Close
(
   IN    twRMRootIx                    BIGINT,
   IN    twRMTObjectIx                 BIGINT,
   OUT   bError                        INT
)
BEGIN
       DECLARE SBO_CLASS_RMROOT                           INT DEFAULT 70;
       DECLARE SBO_CLASS_RMTOBJECT                        INT DEFAULT 72;
       DECLARE SBA_SUBSCRIBE_REFRESH_EVENT_EX_FLAG_CLOSE  INT DEFAULT 0x02;

       DECLARE twEventIz BIGINT;

          CALL call_RMRoot_Event (twRMRootIx, twEventIz, bError);
            IF bError = 0
          THEN
                 DELETE FROM RMTObject                                        -- we actually want to delete the entire tree - all the way down to the pobject!
                  WHERE ObjectHead_Self_twObjectIx = twRMTObjectIx;

                    SET bError = IF (ROW_COUNT () = 1, 0, 1);

                     IF bError = 0
                   THEN
                          INSERT INTO Event
                                 (sType, Self_wClass, Self_twObjectIx, Child_wClass, Child_twObjectIx, wFlags, twEventIz, sJSON_Object, sJSON_Child, sJSON_Change)
                          SELECT 'RMTOBJECT_Close',

                                 SBO_CLASS_RMROOT,
                                 twRMRootIx,
                                 SBO_CLASS_RMTOBJECT,
                                 twRMTObjectIx,
                                 SBA_SUBSCRIBE_REFRESH_EVENT_EX_FLAG_CLOSE,
                                 twEventIz,

                                 '{ }',

                                 '{ }',

                                 '{ }';

                             SET bError = IF (ROW_COUNT () = 1, 0, 1);
                 END IF ;
        END IF ;
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                     MVD_RP1_Map : call_RMRoot_Event_RMTObject_Open.sql                                     ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2023 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE call_RMRoot_Event_RMTObject_Open
(
   IN    twRMRootIx                    BIGINT,
   IN    Name_wsRMTObjectId            VARCHAR (48),
   IN    Type_bType                    TINYINT UNSIGNED,
   IN    Type_bSubtype                 TINYINT UNSIGNED,
   IN    Type_bFiction                 TINYINT UNSIGNED,
   IN    Owner_twRPersonaIx            BIGINT,
   IN    Resource_qwResource           BIGINT,
   IN    Resource_sName                VARCHAR (48),
   IN    Resource_sReference           VARCHAR (128),
   IN    Transform_Position_dX         DOUBLE,
   IN    Transform_Position_dY         DOUBLE,
   IN    Transform_Position_dZ         DOUBLE,
   IN    Transform_Rotation_dX         DOUBLE,
   IN    Transform_Rotation_dY         DOUBLE,
   IN    Transform_Rotation_dZ         DOUBLE,
   IN    Transform_Rotation_dW         DOUBLE,
   IN    Transform_Scale_dX            DOUBLE,
   IN    Transform_Scale_dY            DOUBLE,
   IN    Transform_Scale_dZ            DOUBLE,
   IN    Bound_dX                      DOUBLE,
   IN    Bound_dY                      DOUBLE,
   IN    Bound_dZ                      DOUBLE,
   IN    Properties_bLockToGround      TINYINT UNSIGNED,
   IN    Properties_bYouth             TINYINT UNSIGNED,
   IN    Properties_bAdult             TINYINT UNSIGNED,
   IN    Properties_bAvatar            TINYINT UNSIGNED,
   OUT   twRMTObjectIx                 BIGINT,
   OUT   bError                        INT
)
BEGIN
       DECLARE SBO_CLASS_RMROOT                           INT DEFAULT 70;
       DECLARE SBO_CLASS_RMTOBJECT                        INT DEFAULT 72;
       DECLARE SBA_SUBSCRIBE_REFRESH_EVENT_EX_FLAG_OPEN   INT DEFAULT 0x01;

       DECLARE twEventIz BIGINT;

          CALL call_RMRoot_Event (twRMRootIx, twEventIz, bError);
            IF bError = 0
          THEN
                 INSERT INTO RMTObject
                        (ObjectHead_Parent_wClass, ObjectHead_Parent_twObjectIx, ObjectHead_Self_wClass, ObjectHead_twEventIz, ObjectHead_wFlags, Name_wsRMTObjectId, Type_bType, Type_bSubtype, Type_bFiction, Owner_twRPersonaIx, Resource_qwResource, Resource_sName, Resource_sReference, Transform_Position_dX, Transform_Position_dY, Transform_Position_dZ, Transform_Rotation_dX, Transform_Rotation_dY, Transform_Rotation_dZ, Transform_Rotation_dW, Transform_Scale_dX, Transform_Scale_dY, Transform_Scale_dZ, Bound_dX, Bound_dY, Bound_dZ, Properties_bLockToGround, Properties_bYouth, Properties_bAdult, Properties_bAvatar)
                 VALUES (SBO_CLASS_RMROOT,         twRMRootIx,                   SBO_CLASS_RMTOBJECT,    0,                    32,                Name_wsRMTObjectId, Type_bType, Type_bSubtype, Type_bFiction, Owner_twRPersonaIx, Resource_qwResource, Resource_sName, Resource_sReference, Transform_Position_dX, Transform_Position_dY, Transform_Position_dZ, Transform_Rotation_dX, Transform_Rotation_dY, Transform_Rotation_dZ, Transform_Rotation_dW, Transform_Scale_dX, Transform_Scale_dY, Transform_Scale_dZ, Bound_dX, Bound_dY, Bound_dZ, Properties_bLockToGround, Properties_bYouth, Properties_bAdult, Properties_bAvatar);

                    SET bError = IF (ROW_COUNT () = 1, 0, 1);

                     IF bError = 0
                   THEN
                             SET twRMTObjectIx = LAST_INSERT_ID ();

                          INSERT INTO Event
                                 (sType, Self_wClass, Self_twObjectIx, Child_wClass, Child_twObjectIx, wFlags, twEventIz, sJSON_Object, sJSON_Child, sJSON_Change)
                          SELECT 'RMTOBJECT_OPEN',

                                 SBO_CLASS_RMROOT,
                                 twRMRootIx,
                                 SBO_CLASS_RMTOBJECT,
                                 twRMTObjectIx,
                                 SBA_SUBSCRIBE_REFRESH_EVENT_EX_FLAG_OPEN,
                                 twEventIz,

                                 '{ }',

                                 CONCAT
                                 (
                                   '{ ',
                                     '"pName": ',         Format_Name_T
                                                          (
                                                             Name_wsRMTObjectId
                                                          ),
                                   ', "pType": ',         Format_Type_T
                                                          (
                                                             Type_bType,
                                                             Type_bSubtype,
                                                             Type_bFiction
                                                          ),
                                   ', "pOwner": ',        Format_Owner
                                                          (
                                                             Owner_twRPersonaIx
                                                          ),
                                   ', "pResource": ',     Format_Resource
                                                          (
                                                             Resource_qwResource,
                                                             Resource_sName,
                                                             Resource_sReference
                                                          ),
                                   ', "pTransform": ',    Format_Transform
                                                          (
                                                             Transform_Position_dX,
                                                             Transform_Position_dY,
                                                             Transform_Position_dZ,
                                                             Transform_Rotation_dX,
                                                             Transform_Rotation_dY,
                                                             Transform_Rotation_dZ,
                                                             Transform_Rotation_dW,
                                                             Transform_Scale_dX,
                                                             Transform_Scale_dY,
                                                             Transform_Scale_dZ
                                                          ),
                                   ', "pBound": ',        Format_Bound
                                                          (
                                                             Bound_dX,
                                                             Bound_dY,
                                                             Bound_dZ
                                                          ),
                                   ', "pProperties": ',   Format_Properties_T
                                                          (
                                                             Properties_bLockToGround,
                                                             Properties_bYouth,
                                                             Properties_bAdult,
                                                             Properties_bAvatar
                                                          ),
                                  ' }'
                                 ),

                                 '{ }';

                             SET bError = IF (ROW_COUNT () = 1, 0, 1);
                 END IF ;
        END IF ;
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                              MVD_RP1_Map : call_RMRoot_Log.sql                                             ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2025 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE call_RMRoot_Log
(
   IN    bOp                           TINYINT UNSIGNED,
   IN    sIPAddress                    VARCHAR (16),
   IN    twRPersonaIx                  BIGINT,
   IN    twRMRootIx                    BIGINT,
   OUT   bError                        INT
)
BEGIN
       DECLARE dwIPAddress BINARY (4) DEFAULT IPstob (sIPAddress);

        INSERT INTO RMRootLog
               (bOp, dwIPAddress, twRPersonaIx, twRMRootIx)
        VALUES (bOp, dwIPAddress, twRPersonaIx, twRMRootIx);
 
           SET bError = IF (ROW_COUNT () = 1, 0, 1);
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                            MVD_RP1_Map : call_RMRoot_Select.sql                                            ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2023 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

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
                    '"pObjectHead": ',   Format_ObjectHead
                                         (
                                            r.ObjectHead_Parent_wClass,
                                            r.ObjectHead_Parent_twObjectIx,
                                            r.ObjectHead_Self_wClass,
                                            r.ObjectHead_Self_twObjectIx,
                                            IF (nResultSet = 0, OBJECTHEAD_FLAG_SUBSCRIBE_FULL, OBJECTHEAD_FLAG_SUBSCRIBE_PARTIAL),
                                            r.ObjectHead_twEventIz
                                         ),
 
                  ', "twRMRootIx": ',    r.ObjectHead_Self_twObjectIx,      -- is this necessary
 
                  ', "pName": ',         Format_Name_R
                                         (
                                            r.Name_wsRMRootId
                                         ),
                  ', "pOwner": ',        Format_Owner
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

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                           MVD_RP1_Map : call_RMRoot_Validate.sql                                           ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2023 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE call_RMRoot_Validate
(
   IN    twRPersonaIx                  BIGINT,
   IN    twRMRootIx                    BIGINT,
   OUT   ObjectHead_Parent_wClass      SMALLINT,
   OUT   ObjectHead_Parent_twObjectIx  BIGINT,
   INOUT nError                        INT
)
BEGIN
       DECLARE nCount INT;

        SELECT o.ObjectHead_Parent_wClass, o.ObjectHead_Parent_twObjectIx
          INTO   ObjectHead_Parent_wClass,   ObjectHead_Parent_twObjectIx
          FROM RMRoot AS o
         WHERE o.ObjectHead_Self_twObjectIx = twRMRootIx;

           SET nCount = ROW_COUNT ();

            IF twRPersonaIx <= 0
          THEN
                   CALL call_Error (1, 'twRPersonaIx is invalid', nError);
        ELSEIF twRMRootIx <= 0
          THEN
                   CALL call_Error (2, 'twRMRootIx is invalid',   nError);
        ELSEIF nCount <> 1
          THEN
                   CALL call_Error (3, 'twRMRootIx is unknown',   nError);
        ELSEIF twRPersonaIx <> twRPersonaIx
          THEN                                                             -- TBD
                   CALL call_Error (4, 'Invalid rights',          nError);
        END IF ;
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                         MVD_RP1_Map : call_RMRoot_Validate_Name.sql                                        ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2023 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE call_RMRoot_Validate_Name
(
   IN    ObjectHead_Parent_wClass      SMALLINT,
   IN    ObjectHead_Parent_twObjectIx  BIGINT,
   IN    twRMRootIx                    BIGINT,
   IN    Name_wsRMRootId               VARCHAR (48),
   INOUT nError                        INT
)
BEGIN
            IF Name_wsRMRootId IS NULL
          THEN
                   CALL call_Error (21, 'Name_wsRMRootId is NULL', nError);
        END IF ;
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                        MVD_RP1_Map : call_RMRoot_Validate_Owner.sql                                        ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2023 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE call_RMRoot_Validate_Owner
(
   IN    ObjectHead_Parent_wClass      SMALLINT,
   IN    ObjectHead_Parent_twObjectIx  BIGINT,
   IN    twRMRootIx                    BIGINT,
   IN    Owner_twRPersonaIx            BIGINT,
   INOUT nError                        INT
)
BEGIN
            IF Owner_twRPersonaIx IS NULL
          THEN
                   CALL call_Error (21, 'Owner_twRPersonaIx is NULL',    nError);
        ELSEIF Owner_twRPersonaIx NOT BETWEEN 1 AND 0x0000FFFFFFFFFFFC
          THEN
                   CALL call_Error (21, 'Owner_twRPersonaIx is invalid', nError);
        END IF ;
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                             MVD_RP1_Map : get_RMRoot_Update.sql                                            ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2025 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

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

            -- Create the temp Error table
        CREATE TEMPORARY TABLE Error
               (
                  nOrder                        INT             NOT NULL AUTO_INCREMENT PRIMARY KEY,
                  dwError                       INT             NOT NULL,
                  sError                        VARCHAR (255)   NOT NULL
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

                     IF ROW_COUNT () = 1
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

          DROP TEMPORARY TABLE Error;
          DROP TEMPORARY TABLE Results;

           SET nResult = bCommit - 1 - nError;

END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                              MVD_RP1_Map : set_RMRoot_Name.sql                                             ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                              Copyright 2023-2025 Metaversal Corporation. All rights reserved.                              ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE set_RMRoot_Name
(
   IN    sIPAddress                    VARCHAR (16),
   IN    twRPersonaIx                  BIGINT,
   IN    twRMRootIx                    BIGINT,
   IN    Name_wsRMRootId               VARCHAR (48),
   OUT   nResult                       INT
)
BEGIN
       DECLARE RMROOT_OP_NAME                             INT DEFAULT 1;

       DECLARE nError  INT DEFAULT 0;
       DECLARE bCommit INT DEFAULT 0;
       DECLARE bError  INT;

       DECLARE ObjectHead_Parent_wClass     SMALLINT;
       DECLARE ObjectHead_Parent_twObjectIx BIGINT;

            -- Create the temp Error table
        CREATE TEMPORARY TABLE Error
               (
                  nOrder                        INT             NOT NULL AUTO_INCREMENT PRIMARY KEY,
                  dwError                       INT             NOT NULL,
                  sError                        VARCHAR (255)   NOT NULL
               );

            -- Create the temp Event table
        CREATE TEMPORARY TABLE Event
               (
                  nOrder                        INT             NOT NULL AUTO_INCREMENT PRIMARY KEY,
                  sType                         VARCHAR (50)    NOT NULL,
                  Self_wClass                   SMALLINT        NOT NULL,
                  Self_twObjectIx               BIGINT          NOT NULL,
                  Child_wClass                  SMALLINT        NOT NULL,
                  Child_twObjectIx              BIGINT          NOT NULL,
                  wFlags                        SMALLINT        NOT NULL,
                  twEventIz                     BIGINT          NOT NULL,
                  sJSON_Object                  TEXT            NOT NULL,
                  sJSON_Child                   TEXT            NOT NULL,
                  sJSON_Change                  TEXT            NOT NULL
               );

           SET twRPersonaIx  = IFNULL (twRPersonaIx,  0);
           SET twRMRootIx    = IFNULL (twRMRootIx,    0);

         START TRANSACTION;

          CALL call_RMRoot_Validate (twRPersonaIx, twRMRootIx, ObjectHead_Parent_wClass, ObjectHead_Parent_twObjectIx, nError);
            IF nError = 0
          THEN
                   CALL call_RMRoot_Validate_Name (ObjectHead_Parent_wClass, ObjectHead_Parent_twObjectIx, twRMRootIx, Name_wsRMRootId, nError);
        END IF ;

            IF nError = 0
          THEN
                   CALL call_RMRoot_Event_Name (twRMRootIx, Name_wsRMRootId, bError);
                     IF bError = 0
                   THEN
                             SET bCommit = 1;
                   ELSE
                            CALL call_Error (-1, 'Failed to update RMRoot', nError);
                 END IF ;
        END IF ;
       
            IF bCommit = 1
          THEN
                    SET bCommit = 0;
                 
                   CALL call_RMRoot_Log (RMROOT_OP_NAME, sIPAddress, twRPersonaIx, twRMRootIx, bError);
                     IF bError = 0
                   THEN
                            CALL call_Event_Push (bError);
                              IF bError = 0
                            THEN
                                      SET bCommit = 1;
                            ELSE
                                     CALL call_Error (-9, 'Failed to push events', nError);
                          END IF ;
                   ELSE
                            CALL call_Error (-8, 'Failed to log action', nError);
                 END IF ;
        END IF ;

            IF bCommit = 0
          THEN
                 SELECT dwError, sError FROM Error;

               ROLLBACK ;
          ELSE
                 COMMIT ;
        END IF ;

          DROP TEMPORARY TABLE Error;
          DROP TEMPORARY TABLE Event;

           SET nResult = bCommit - 1 - nError;
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                             MVD_RP1_Map : set_RMRoot_Owner.sql                                             ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                              Copyright 2023-2025 Metaversal Corporation. All rights reserved.                              ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE set_RMRoot_Owner
(
   IN    sIPAddress                    VARCHAR (16),
   IN    twRPersonaIx                  BIGINT,
   IN    twRMRootIx                    BIGINT,
   IN    Owner_twRPersonaIx            BIGINT,
   OUT   nResult                       INT
)
BEGIN
       DECLARE RMROOT_OP_OWNER                            INT DEFAULT 3;

       DECLARE nError  INT DEFAULT 0;
       DECLARE bCommit INT DEFAULT 0;
       DECLARE bError  INT;

       DECLARE ObjectHead_Parent_wClass     SMALLINT;
       DECLARE ObjectHead_Parent_twObjectIx BIGINT;

            -- Create the temp Error table
        CREATE TEMPORARY TABLE Error
               (
                  nOrder                        INT             NOT NULL AUTO_INCREMENT PRIMARY KEY,
                  dwError                       INT             NOT NULL,
                  sError                        VARCHAR (255)   NOT NULL
               );

            -- Create the temp Event table
        CREATE TEMPORARY TABLE Event
               (
                  nOrder                        INT             NOT NULL AUTO_INCREMENT PRIMARY KEY,
                  sType                         VARCHAR (50)    NOT NULL,
                  Self_wClass                   SMALLINT        NOT NULL,
                  Self_twObjectIx               BIGINT          NOT NULL,
                  Child_wClass                  SMALLINT        NOT NULL,
                  Child_twObjectIx              BIGINT          NOT NULL,
                  wFlags                        SMALLINT        NOT NULL,
                  twEventIz                     BIGINT          NOT NULL,
                  sJSON_Object                  TEXT            NOT NULL,
                  sJSON_Child                   TEXT            NOT NULL,
                  sJSON_Change                  TEXT            NOT NULL
               );

           SET twRPersonaIx  = IFNULL (twRPersonaIx,  0);
           SET twRMRootIx    = IFNULL (twRMRootIx,    0);

         START TRANSACTION;

          CALL call_RMRoot_Validate (twRPersonaIx, twRMRootIx, ObjectHead_Parent_wClass, ObjectHead_Parent_twObjectIx, nError);
            IF nError = 0
          THEN
                   CALL call_RMRoot_Validate_Owner (ObjectHead_Parent_wClass, ObjectHead_Parent_twObjectIx, twRMRootIx, Owner_twRPersonaIx, nError);
        END IF ;

            IF nError = 0
          THEN
                   CALL call_RMRoot_Event_Owner (twRMRootIx, Owner_twRPersonaIx, bError);
                     IF bError > 0
                   THEN
                             SET bCommit = 1;
                   ELSE
                            CALL call_Error (-1, 'Failed to update RMRoot', nError);
                 END IF ;
        END IF ;
       
            IF bCommit = 1
          THEN
                    SET bCommit = 0;
                 
                   CALL call_RMRoot_Log (RMROOT_OP_OWNER, sIPAddress, twRPersonaIx, twRMRootIx, bError);
                     IF bError = 0
                   THEN
                            CALL call_Event_Push (bError);
                              IF bError = 0
                            THEN
                                      SET bCommit = 1;
                            ELSE
                                     CALL call_Error (-9, 'Failed to push events', nError);
                          END IF ;
                   ELSE
                            CALL call_Error (-8, 'Failed to log action', nError);
                 END IF ;
        END IF ;

            IF bCommit = 0
          THEN
                 SELECT dwError, sError FROM Error;

               ROLLBACK ;
          ELSE
                 COMMIT ;
        END IF ;

          DROP TEMPORARY TABLE Error;
          DROP TEMPORARY TABLE Event;

           SET nResult = bCommit - 1 - nError;
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                        MVD_RP1_Map : set_RMRoot_RMCObject_Close.sql                                        ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                              Copyright 2023-2025 Metaversal Corporation. All rights reserved.                              ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE set_RMRoot_RMCObject_Close
(
   IN    sIPAddress                    VARCHAR (16),
   IN    twRPersonaIx                  BIGINT,
   IN    twRMRootIx                    BIGINT,
   IN    twRMCObjectIx_Close           BIGINT,
   IN    bDeleteAll                    TINYINT UNSIGNED,
   OUT   nResult                       INT
)
BEGIN
       DECLARE SBO_CLASS_RMCOBJECT                        INT DEFAULT 71;
       DECLARE RMROOT_OP_RMCOBJECT_CLOSE                  INT DEFAULT 14;

       DECLARE nError  INT DEFAULT 0;
       DECLARE bCommit INT DEFAULT 0;
       DECLARE bError  INT;

       DECLARE ObjectHead_Parent_wClass     SMALLINT;
       DECLARE ObjectHead_Parent_twObjectIx BIGINT;

       DECLARE nCount INT;

            -- Create the temp Error table
        CREATE TEMPORARY TABLE Error
               (
                  nOrder                        INT             NOT NULL AUTO_INCREMENT PRIMARY KEY,
                  dwError                       INT             NOT NULL,
                  sError                        VARCHAR (255)   NOT NULL
               );

            -- Create the temp Event table
        CREATE TEMPORARY TABLE Event
               (
                  nOrder                        INT             NOT NULL AUTO_INCREMENT PRIMARY KEY,
                  sType                         VARCHAR (50)    NOT NULL,
                  Self_wClass                   SMALLINT        NOT NULL,
                  Self_twObjectIx               BIGINT          NOT NULL,
                  Child_wClass                  SMALLINT        NOT NULL,
                  Child_twObjectIx              BIGINT          NOT NULL,
                  wFlags                        SMALLINT        NOT NULL,
                  twEventIz                     BIGINT          NOT NULL,
                  sJSON_Object                  TEXT            NOT NULL,
                  sJSON_Child                   TEXT            NOT NULL,
                  sJSON_Change                  TEXT            NOT NULL
               );

           SET twRPersonaIx        = IFNULL (twRPersonaIx,        0);
           SET twRMRootIx          = IFNULL (twRMRootIx,          0);
           SET twRMCObjectIx_Close = IFNULL (twRMCObjectIx_Close, 0);
           SET bDeleteAll          = IFNULL (bDeleteAll,          0);

         START TRANSACTION;

          CALL call_RMRoot_Validate (twRPersonaIx, twRMRootIx, ObjectHead_Parent_wClass, ObjectHead_Parent_twObjectIx, nError);
            IF nError = 0
          THEN
                 SELECT COUNT(*) INTO nCount
                   FROM RMCObject
                  WHERE ObjectHead_Parent_wClass     = SBO_CLASS_RMCOBJECT
                    AND ObjectHead_Parent_twObjectIx = twRMCObjectIx_Close;

                     IF twRMCObjectIx_Close <= 0
                   THEN
                            CALL call_Error (5, 'twRMCObjectIx_Close is invalid',   nError);
                 ELSEIF bDeleteAll = 0 AND nCount > 0
                   THEN
                            CALL call_Error (6, 'twRMCObjectIx_Close is not empty', nError);
                 END IF ;
        END IF ;

            IF nError = 0
          THEN
                   CALL call_RMRoot_Event_RMCObject_Close (twRMRootIx, twRMCObjectIx_Close, bError);
                     IF bError = 0
                   THEN
                             SET bCommit = 1;
                   ELSE
                            CALL call_Error (-1, 'Failed to delete RMCObject', nError);
                 END IF ;
        END IF ;
       
            IF bCommit = 1
          THEN
                    SET bCommit = 0;
                 
                   CALL call_RMRoot_Log (RMROOT_OP_RMCOBJECT_CLOSE, sIPAddress, twRPersonaIx, twRMRootIx, bError);
                     IF bError = 0
                   THEN
                            CALL call_Event_Push (bError);
                              IF bError = 0
                            THEN
                                      SET bCommit = 1;
                            ELSE
                                     CALL call_Error (-9, 'Failed to push events', nError);
                          END IF ;
                   ELSE
                            CALL call_Error (-8, 'Failed to log action', nError);
                 END IF ;
        END IF ;

            IF bCommit = 0
          THEN
                 SELECT dwError, sError FROM Error;

               ROLLBACK ;
          ELSE
                 COMMIT ;
        END IF ;

          DROP TEMPORARY TABLE Error;
          DROP TEMPORARY TABLE Event;

           SET nResult = bCommit - 1 - nError;
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                         MVD_RP1_Map : set_RMRoot_RMCObject_Open.sql                                        ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                              Copyright 2023-2025 Metaversal Corporation. All rights reserved.                              ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE set_RMRoot_RMCObject_Open
(
   IN    sIPAddress                    VARCHAR (16),
   IN    twRPersonaIx                  BIGINT,
   IN    twRMRootIx                    BIGINT,
   IN    Name_wsRMCObjectId            VARCHAR (48),
   IN    Type_bType                    TINYINT UNSIGNED,
   IN    Type_bSubtype                 TINYINT UNSIGNED,
   IN    Type_bFiction                 TINYINT UNSIGNED,
   IN    Owner_twRPersonaIx            BIGINT,
   IN    Resource_qwResource           BIGINT,
   IN    Resource_sName                VARCHAR (48),
   IN    Resource_sReference           VARCHAR (128),
   IN    Transform_Position_dX         DOUBLE,
   IN    Transform_Position_dY         DOUBLE,
   IN    Transform_Position_dZ         DOUBLE,
   IN    Transform_Rotation_dX         DOUBLE,
   IN    Transform_Rotation_dY         DOUBLE,
   IN    Transform_Rotation_dZ         DOUBLE,
   IN    Transform_Rotation_dW         DOUBLE,
   IN    Transform_Scale_dX            DOUBLE,
   IN    Transform_Scale_dY            DOUBLE,
   IN    Transform_Scale_dZ            DOUBLE,
   IN    Orbit_Spin_tmPeriod           BIGINT,
   IN    Orbit_Spin_tmStart            BIGINT,
   IN    Orbit_Spin_dA                 DOUBLE,
   IN    Orbit_Spin_dB                 DOUBLE,
   IN    Bound_dX                      DOUBLE,
   IN    Bound_dY                      DOUBLE,
   IN    Bound_dZ                      DOUBLE,
   IN    Properties_fMass              FLOAT,
   IN    Properties_fGravity           FLOAT,
   IN    Properties_fColor             FLOAT,
   IN    Properties_fBrightness        FLOAT,
   IN    Properties_fReflectivity      FLOAT,
   OUT   nResult                       INT
)
BEGIN
       DECLARE SBO_CLASS_RMROOT                           INT DEFAULT 79;
       DECLARE RMROOT_OP_RMCOBJECT_OPEN                   INT DEFAULT 12;

       DECLARE nError  INT DEFAULT 0;
       DECLARE bCommit INT DEFAULT 0;
       DECLARE bError  INT;

       DECLARE ObjectHead_Parent_wClass     SMALLINT;
       DECLARE ObjectHead_Parent_twObjectIx BIGINT;

       DECLARE twRMCObjectIx_Open           BIGINT;

            -- Create the temp Error table
        CREATE TEMPORARY TABLE Error
               (
                  nOrder                        INT             NOT NULL AUTO_INCREMENT PRIMARY KEY,
                  dwError                       INT             NOT NULL,
                  sError                        VARCHAR (255)   NOT NULL
               );

            -- Create the temp Event table
        CREATE TEMPORARY TABLE Event
               (
                  nOrder                        INT             NOT NULL AUTO_INCREMENT PRIMARY KEY,
                  sType                         VARCHAR (50)    NOT NULL,
                  Self_wClass                   SMALLINT        NOT NULL,
                  Self_twObjectIx               BIGINT          NOT NULL,
                  Child_wClass                  SMALLINT        NOT NULL,
                  Child_twObjectIx              BIGINT          NOT NULL,
                  wFlags                        SMALLINT        NOT NULL,
                  twEventIz                     BIGINT          NOT NULL,
                  sJSON_Object                  TEXT            NOT NULL,
                  sJSON_Child                   TEXT            NOT NULL,
                  sJSON_Change                  TEXT            NOT NULL
               );

           SET twRPersonaIx  = IFNULL (twRPersonaIx,  0);
           SET twRMRootIx    = IFNULL (twRMRootIx,    0);

         START TRANSACTION;

          CALL call_RMRoot_Validate (twRPersonaIx, twRMRootIx, ObjectHead_Parent_wClass, ObjectHead_Parent_twObjectIx, nError);
            IF nError = 0
          THEN
                   CALL call_RMCObject_Validate_Name       (SBO_CLASS_RMROOT, twRMRootIx, 0, Name_wsRMCObjectId, nError);
                   CALL call_RMCObject_Validate_Type       (SBO_CLASS_RMROOT, twRMRootIx, 0, Type_bType, Type_bSubtype, Type_bFiction, nError);
                   CALL call_RMCObject_Validate_Owner      (SBO_CLASS_RMROOT, twRMRootIx, 0, Owner_twRPersonaIx, nError);
                   CALL call_RMCObject_Validate_Resource   (SBO_CLASS_RMROOT, twRMRootIx, 0, Resource_qwResource, Resource_sName, Resource_sReference, nError);
                   CALL call_RMCObject_Validate_Transform  (SBO_CLASS_RMROOT, twRMRootIx, 0, Transform_Position_dX, Transform_Position_dY, Transform_Position_dZ, Transform_Rotation_dX, Transform_Rotation_dY, Transform_Rotation_dZ, Transform_Rotation_dW, Transform_Scale_dX, Transform_Scale_dY, Transform_Scale_dZ, nError);
                   CALL call_RMCObject_Validate_Orbit_Spin (SBO_CLASS_RMROOT, twRMRootIx, 0, Orbit_Spin_tmPeriod, Orbit_Spin_tmStart, Orbit_Spin_dA, Orbit_Spin_dB, nError);
                   CALL call_RMCObject_Validate_Bound      (SBO_CLASS_RMROOT, twRMRootIx, 0, Bound_dX, Bound_dY, Bound_dZ, nError);
                   CALL call_RMCObject_Validate_Properties (SBO_CLASS_RMROOT, twRMRootIx, 0, Properties_fMass, Properties_fGravity, Properties_fColor, Properties_fBrightness, Properties_fReflectivity, nError);
        END IF ;

            IF nError = 0
          THEN
                   CALL call_RMRoot_Event_RMCObject_Open (twRMRootIx, Name_wsRMCObjectId, Type_bType, Type_bSubtype, Type_bFiction, Owner_twRPersonaIx, Resource_qwResource, Resource_sName, Resource_sReference, Transform_Position_dX, Transform_Position_dY, Transform_Position_dZ, Transform_Rotation_dX, Transform_Rotation_dY, Transform_Rotation_dZ, Transform_Rotation_dW, Transform_Scale_dX, Transform_Scale_dY, Transform_Scale_dZ, Orbit_Spin_tmPeriod, Orbit_Spin_tmStart, Orbit_Spin_dA, Orbit_Spin_dB, Bound_dX, Bound_dY, Bound_dZ, Properties_fMass, Properties_fGravity, Properties_fColor, Properties_fBrightness, Properties_fReflectivity, twRMCObjectIx_Open, bError);
                     IF bError = 0
                   THEN
                          SELECT twRMCObjectIx_Open AS twRMCObject;
   
                             SET bCommit = 1;
                   ELSE
                            CALL call_Error (-1, 'Failed to insert RMCObject', nError);
                 END IF ;
        END IF ;
       
            IF bCommit = 1
          THEN
                    SET bCommit = 0;
                 
                   CALL call_RMRoot_Log (RMROOT_OP_RMCOBJECT_OPEN, sIPAddress, twRPersonaIx, twRMRootIx, bError);
                     IF bError = 0
                   THEN
                            CALL call_Event_Push (bError);
                              IF bError = 0
                            THEN
                                      SET bCommit = 1;
                            ELSE
                                     CALL call_Error (-9, 'Failed to push events', nError);
                          END IF ;
                   ELSE
                            CALL call_Error (-8, 'Failed to log action', nError);
                 END IF ;
        END IF ;

            IF bCommit = 0
          THEN
                 SELECT dwError, sError FROM Error;

               ROLLBACK ;
          ELSE
                 COMMIT ;
        END IF ;

          DROP TEMPORARY TABLE Error;
          DROP TEMPORARY TABLE Event;

           SET nResult = bCommit - 1 - nError;
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                        MVD_RP1_Map : set_RMRoot_RMPObject_Close.sql                                        ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                              Copyright 2023-2025 Metaversal Corporation. All rights reserved.                              ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE set_RMRoot_RMPObject_Close
(
   IN    sIPAddress                    VARCHAR (16),
   IN    twRPersonaIx                  BIGINT,
   IN    twRMRootIx                    BIGINT,
   IN    twRMPObjectIx_Close           BIGINT,
   IN    bDeleteAll                    TINYINT UNSIGNED,
   OUT   nResult                       INT
)
BEGIN
       DECLARE SBO_CLASS_RMPOBJECT                        INT DEFAULT 73;
       DECLARE RMROOT_OP_RMPOBJECT_CLOSE                  INT DEFAULT 17;

       DECLARE nError  INT DEFAULT 0;
       DECLARE bCommit INT DEFAULT 0;
       DECLARE bError  INT;

       DECLARE ObjectHead_Parent_wClass     SMALLINT;
       DECLARE ObjectHead_Parent_twObjectIx BIGINT;

       DECLARE nCount INT;

            -- Create the temp Error table
        CREATE TEMPORARY TABLE Error
               (
                  nOrder                        INT             NOT NULL AUTO_INCREMENT PRIMARY KEY,
                  dwError                       INT             NOT NULL,
                  sError                        VARCHAR (255)   NOT NULL
               );

            -- Create the temp Event table
        CREATE TEMPORARY TABLE Event
               (
                  nOrder                        INT             NOT NULL AUTO_INCREMENT PRIMARY KEY,
                  sType                         VARCHAR (50)    NOT NULL,
                  Self_wClass                   SMALLINT        NOT NULL,
                  Self_twObjectIx               BIGINT          NOT NULL,
                  Child_wClass                  SMALLINT        NOT NULL,
                  Child_twObjectIx              BIGINT          NOT NULL,
                  wFlags                        SMALLINT        NOT NULL,
                  twEventIz                     BIGINT          NOT NULL,
                  sJSON_Object                  TEXT            NOT NULL,
                  sJSON_Child                   TEXT            NOT NULL,
                  sJSON_Change                  TEXT            NOT NULL
               );

           SET twRPersonaIx        = IFNULL (twRPersonaIx,        0);
           SET twRMRootIx          = IFNULL (twRMRootIx,          0);
           SET twRMPObjectIx_Close = IFNULL (twRMPObjectIx_Close, 0);
           SET bDeleteAll          = IFNULL (bDeleteAll,          0);

         START TRANSACTION;

          CALL call_RMRoot_Validate (twRPersonaIx, twRMRootIx, ObjectHead_Parent_wClass, ObjectHead_Parent_twObjectIx, nError);
            IF nError = 0
          THEN
                 SELECT COUNT(*) INTO nCount
                   FROM RMPObject
                  WHERE ObjectHead_Parent_wClass     = SBO_CLASS_RMPOBJECT
                    AND ObjectHead_Parent_twObjectIx = twRMPObjectIx_Close;

                     IF twRMPObjectIx_Close <= 0
                   THEN
                            CALL call_Error (5, 'twRMPObjectIx_Close is invalid',   nError);
                 ELSEIF bDeleteAll = 0 AND nCount > 0
                   THEN
                            CALL call_Error (6, 'twRMPObjectIx_Close is not empty', nError);
                 END IF ;
        END IF ;

            IF nError = 0
          THEN
                   CALL call_RMRoot_Event_RMPObject_Close (twRMRootIx, twRMPObjectIx_Close, bError, 0);
                     IF bError = 0
                   THEN
                             SET bCommit = 1;
                   ELSE
                            CALL call_Error (-1, 'Failed to delete RMPObject', nError);
                 END IF ;
        END IF ;
       
            IF bCommit = 1
          THEN
                    SET bCommit = 0;
                 
                   CALL call_RMRoot_Log (RMROOT_OP_RMPOBJECT_CLOSE, sIPAddress, twRPersonaIx, twRMRootIx, bError);
                     IF bError = 0
                   THEN
                            CALL call_Event_Push (bError);
                              IF bError = 0
                            THEN
                                      SET bCommit = 1;
                            ELSE
                                     CALL call_Error (-9, 'Failed to push events', nError);
                          END IF ;
                   ELSE
                            CALL call_Error (-8, 'Failed to log action', nError);
                 END IF ;
        END IF ;

            IF bCommit = 0
          THEN
                 SELECT dwError, sError FROM Error;

               ROLLBACK ;
          ELSE
                 COMMIT ;
        END IF ;

          DROP TEMPORARY TABLE Error;
          DROP TEMPORARY TABLE Event;

           SET nResult = bCommit - 1 - nError;
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                         MVD_RP1_Map : set_RMRoot_RMPObject_Open.sql                                        ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                              Copyright 2023-2025 Metaversal Corporation. All rights reserved.                              ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE set_RMRoot_RMPObject_Open
(
   IN    sIPAddress                    VARCHAR (16),
   IN    twRPersonaIx                  BIGINT,
   IN    twRMRootIx                    BIGINT,
   IN    Name_wsRMPObjectId            VARCHAR (48),
   IN    Type_bType                    TINYINT UNSIGNED,
   IN    Type_bSubtype                 TINYINT UNSIGNED,
   IN    Type_bFiction                 TINYINT UNSIGNED,
   IN    Type_bMovable                 TINYINT UNSIGNED,
   IN    Owner_twRPersonaIx            BIGINT,
   IN    Resource_qwResource           BIGINT,
   IN    Resource_sName                VARCHAR (48),
   IN    Resource_sReference           VARCHAR (128),
   IN    Transform_Position_dX         DOUBLE,
   IN    Transform_Position_dY         DOUBLE,
   IN    Transform_Position_dZ         DOUBLE,
   IN    Transform_Rotation_dX         DOUBLE,
   IN    Transform_Rotation_dY         DOUBLE,
   IN    Transform_Rotation_dZ         DOUBLE,
   IN    Transform_Rotation_dW         DOUBLE,
   IN    Transform_Scale_dX            DOUBLE,
   IN    Transform_Scale_dY            DOUBLE,
   IN    Transform_Scale_dZ            DOUBLE,
   IN    Bound_dX                      DOUBLE,
   IN    Bound_dY                      DOUBLE,
   IN    Bound_dZ                      DOUBLE,
   OUT   nResult                       INT
)
BEGIN
       DECLARE SBO_CLASS_RMROOT                           INT DEFAULT 70;
       DECLARE RMROOT_OP_RMPOBJECT_OPEN                   INT DEFAULT 16;

       DECLARE nError  INT DEFAULT 0;
       DECLARE bCommit INT DEFAULT 0;
       DECLARE bError  INT;

       DECLARE ObjectHead_Parent_wClass     SMALLINT;
       DECLARE ObjectHead_Parent_twObjectIx BIGINT;

       DECLARE twRMPObjectIx_Open           BIGINT;

            -- Create the temp Error table
        CREATE TEMPORARY TABLE Error
               (
                  nOrder                        INT             NOT NULL AUTO_INCREMENT PRIMARY KEY,
                  dwError                       INT             NOT NULL,
                  sError                        VARCHAR (255)   NOT NULL
               );

            -- Create the temp Event table
        CREATE TEMPORARY TABLE Event
               (
                  nOrder                        INT             NOT NULL AUTO_INCREMENT PRIMARY KEY,
                  sType                         VARCHAR (50)    NOT NULL,
                  Self_wClass                   SMALLINT        NOT NULL,
                  Self_twObjectIx               BIGINT          NOT NULL,
                  Child_wClass                  SMALLINT        NOT NULL,
                  Child_twObjectIx              BIGINT          NOT NULL,
                  wFlags                        SMALLINT        NOT NULL,
                  twEventIz                     BIGINT          NOT NULL,
                  sJSON_Object                  TEXT            NOT NULL,
                  sJSON_Child                   TEXT            NOT NULL,
                  sJSON_Change                  TEXT            NOT NULL
               );

           SET twRPersonaIx  = IFNULL (twRPersonaIx,  0);
           SET twRMRootIx    = IFNULL (twRMRootIx,    0);

         START TRANSACTION;

          CALL call_RMRoot_Validate (twRPersonaIx, twRMRootIx, ObjectHead_Parent_wClass, ObjectHead_Parent_twObjectIx, nError);
            IF nError = 0
          THEN
                   CALL call_RMPObject_Validate_Name      (SBO_CLASS_RMROOT, twRMRootIx, 0, Name_wsRMPObjectId, nError);
                   CALL call_RMPObject_Validate_Type      (SBO_CLASS_RMROOT, twRMRootIx, 0, Type_bType, Type_bSubtype, Type_bFiction, Type_bMovable, nError);
                   CALL call_RMPObject_Validate_Owner     (SBO_CLASS_RMROOT, twRMRootIx, 0, Owner_twRPersonaIx, nError);
                   CALL call_RMPObject_Validate_Resource  (SBO_CLASS_RMROOT, twRMRootIx, 0, Resource_qwResource, Resource_sName, Resource_sReference, nError);
                   CALL call_RMPObject_Validate_Transform (SBO_CLASS_RMROOT, twRMRootIx, 0, Transform_Position_dX, Transform_Position_dY, Transform_Position_dZ, Transform_Rotation_dX, Transform_Rotation_dY, Transform_Rotation_dZ, Transform_Rotation_dW, Transform_Scale_dX, Transform_Scale_dY, Transform_Scale_dZ, nError);
                   CALL call_RMPObject_Validate_Bound     (SBO_CLASS_RMROOT, twRMRootIx, 0, Bound_dX, Bound_dY, Bound_dZ, nError);
        END IF ;

            IF nError = 0
          THEN
                   CALL call_RMRoot_Event_RMPObject_Open (twRMRootIx, Name_wsRMPObjectId, Type_bType, Type_bSubtype, Type_bFiction, Type_bMovable, Owner_twRPersonaIx, Resource_qwResource, Resource_sName, Resource_sReference, Transform_Position_dX, Transform_Position_dY, Transform_Position_dZ, Transform_Rotation_dX, Transform_Rotation_dY, Transform_Rotation_dZ, Transform_Rotation_dW, Transform_Scale_dX, Transform_Scale_dY, Transform_Scale_dZ, Bound_dX, Bound_dY, Bound_dZ, twRMPObjectIx_Open, bError, 0);
                     IF bError = 0
                   THEN
                          SELECT twRMPObjectIx_Open AS twRMPObject;
   
                             SET bCommit = 1;
                   ELSE
                            CALL call_Error (-1, 'Failed to insert RMPObject', nError);
                 END IF ;
        END IF ;
       
            IF bCommit = 1
          THEN
                    SET bCommit = 0;
                 
                   CALL call_RMRoot_Log (RMROOT_OP_RMPOBJECT_OPEN, sIPAddress, twRPersonaIx, twRMRootIx, bError);
                     IF bError = 0
                   THEN
                            CALL call_Event_Push (bError);
                              IF bError = 0
                            THEN
                                      SET bCommit = 1;
                            ELSE
                                     CALL call_Error (-9, 'Failed to push events', nError);
                          END IF ;
                   ELSE
                            CALL call_Error (-8, 'Failed to log action', nError);
                 END IF ;
        END IF ;

            IF bCommit = 0
          THEN
                 SELECT dwError, sError FROM Error;

               ROLLBACK ;
          ELSE
                 COMMIT ;
        END IF ;

          DROP TEMPORARY TABLE Error;
          DROP TEMPORARY TABLE Event;

           SET nResult = bCommit - 1 - nError;
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                        MVD_RP1_Map : set_RMRoot_RMTObject_Close.sql                                        ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                              Copyright 2023-2025 Metaversal Corporation. All rights reserved.                              ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE set_RMRoot_RMTObject_Close
(
   IN    sIPAddress                    VARCHAR (16),
   IN    twRPersonaIx                  BIGINT,
   IN    twRMRootIx                    BIGINT,
   IN    twRMTObjectIx_Close           BIGINT,
   IN    bDeleteAll                    TINYINT UNSIGNED,
   OUT   nResult                       INT
)
BEGIN
       DECLARE SBO_CLASS_RMTOBJECT                        INT DEFAULT 72;
       DECLARE RMROOT_OP_RMTOBJECT_CLOSE                  INT DEFAULT 14;

       DECLARE nError  INT DEFAULT 0;
       DECLARE bCommit INT DEFAULT 0;
       DECLARE bError  INT;

       DECLARE ObjectHead_Parent_wClass     SMALLINT;
       DECLARE ObjectHead_Parent_twObjectIx BIGINT;

       DECLARE nCount INT;

            -- Create the temp Error table
        CREATE TEMPORARY TABLE Error
               (
                  nOrder                        INT             NOT NULL AUTO_INCREMENT PRIMARY KEY,
                  dwError                       INT             NOT NULL,
                  sError                        VARCHAR (255)   NOT NULL
               );

            -- Create the temp Event table
        CREATE TEMPORARY TABLE Event
               (
                  nOrder                        INT             NOT NULL AUTO_INCREMENT PRIMARY KEY,
                  sType                         VARCHAR (50)    NOT NULL,
                  Self_wClass                   SMALLINT        NOT NULL,
                  Self_twObjectIx               BIGINT          NOT NULL,
                  Child_wClass                  SMALLINT        NOT NULL,
                  Child_twObjectIx              BIGINT          NOT NULL,
                  wFlags                        SMALLINT        NOT NULL,
                  twEventIz                     BIGINT          NOT NULL,
                  sJSON_Object                  TEXT            NOT NULL,
                  sJSON_Child                   TEXT            NOT NULL,
                  sJSON_Change                  TEXT            NOT NULL
               );

           SET twRPersonaIx        = IFNULL (twRPersonaIx,        0);
           SET twRMRootIx          = IFNULL (twRMRootIx,          0);
           SET twRMTObjectIx_Close = IFNULL (twRMTObjectIx_Close, 0);
           SET bDeleteAll          = IFNULL (bDeleteAll,          0);

         START TRANSACTION;

          CALL call_RMRoot_Validate (twRPersonaIx, twRMRootIx, ObjectHead_Parent_wClass, ObjectHead_Parent_twObjectIx, nError);
            IF nError = 0
          THEN
                 SELECT COUNT(*) INTO nCount
                   FROM RMTObject
                  WHERE ObjectHead_Parent_wClass     = SBO_CLASS_RMTOBJECT
                    AND ObjectHead_Parent_twObjectIx = twRMTObjectIx_Close;

                     IF twRMTObjectIx_Close <= 0
                   THEN
                            CALL call_Error (5, 'twRMTObjectIx_Close is invalid',   nError);
                 ELSEIF bDeleteAll = 0 AND nCount > 0
                   THEN
                            CALL call_Error (6, 'twRMTObjectIx_Close is not empty', nError);
                 END IF ;
        END IF ;

            IF nError = 0
          THEN
                   CALL call_RMRoot_Event_RMTObject_Close (twRMRootIx, twRMTObjectIx_Close, bError);
                     IF bError = 0
                   THEN
                             SET bCommit = 1;
                   ELSE
                            CALL call_Error (-1, 'Failed to delete RMTObject', nError);
                 END IF ;
        END IF ;
       
            IF bCommit = 1
          THEN
                    SET bCommit = 0;
                 
                   CALL call_RMRoot_Log (RMROOT_OP_RMTOBJECT_CLOSE, sIPAddress, twRPersonaIx, twRMRootIx, bError);
                     IF bError = 0
                   THEN
                            CALL call_Event_Push (bError);
                              IF bError = 0
                            THEN
                                      SET bCommit = 1;
                            ELSE
                                     CALL call_Error (-9, 'Failed to push events', nError);
                          END IF ;
                   ELSE
                            CALL call_Error (-8, 'Failed to log action', nError);
                 END IF ;
        END IF ;

            IF bCommit = 0
          THEN
                 SELECT dwError, sError FROM Error;

               ROLLBACK ;
          ELSE
                 COMMIT ;
        END IF ;

          DROP TEMPORARY TABLE Error;
          DROP TEMPORARY TABLE Event;

           SET nResult = bCommit - 1 - nError;
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                         MVD_RP1_Map : set_RMRoot_RMTObject_Open.sql                                        ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                              Copyright 2023-2025 Metaversal Corporation. All rights reserved.                              ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE set_RMRoot_RMTObject_Open
(
   IN    sIPAddress                    VARCHAR (16),
   IN    twRPersonaIx                  BIGINT,
   IN    twRMRootIx                    BIGINT,
   IN    Name_wsRMTObjectId            VARCHAR (48),
   IN    Type_bType                    TINYINT UNSIGNED,
   IN    Type_bSubtype                 TINYINT UNSIGNED,
   IN    Type_bFiction                 TINYINT UNSIGNED,
   IN    Owner_twRPersonaIx            BIGINT,
   IN    Resource_qwResource           BIGINT,
   IN    Resource_sName                VARCHAR (48),
   IN    Resource_sReference           VARCHAR (128),
   IN    Transform_Position_dX         DOUBLE,
   IN    Transform_Position_dY         DOUBLE,
   IN    Transform_Position_dZ         DOUBLE,
   IN    Transform_Rotation_dX         DOUBLE,
   IN    Transform_Rotation_dY         DOUBLE,
   IN    Transform_Rotation_dZ         DOUBLE,
   IN    Transform_Rotation_dW         DOUBLE,
   IN    Transform_Scale_dX            DOUBLE,
   IN    Transform_Scale_dY            DOUBLE,
   IN    Transform_Scale_dZ            DOUBLE,
   IN    Bound_dX                      DOUBLE,
   IN    Bound_dY                      DOUBLE,
   IN    Bound_dZ                      DOUBLE,
   IN    Properties_bLockToGround      TINYINT UNSIGNED,
   IN    Properties_bYouth             TINYINT UNSIGNED,
   IN    Properties_bAdult             TINYINT UNSIGNED,
   IN    Properties_bAvatar            TINYINT UNSIGNED,
   IN    bCoord                        TINYINT UNSIGNED,
   IN    dA                            DOUBLE,
   IN    dB                            DOUBLE,
   IN    dC                            DOUBLE,
   OUT   nResult                       INT
)
BEGIN
       DECLARE SBO_CLASS_RMROOT                           INT DEFAULT 70;
       DECLARE RMROOT_OP_RMTOBJECT_OPEN                   INT DEFAULT 13;
       DECLARE RMTMATRIX_COORD_NUL                        INT DEFAULT 0;
       DECLARE RMTMATRIX_COORD_CAR                        INT DEFAULT 1;
       DECLARE RMTMATRIX_COORD_CYL                        INT DEFAULT 2;
       DECLARE RMTMATRIX_COORD_GEO                        INT DEFAULT 3;

       DECLARE nError  INT DEFAULT 0;
       DECLARE bCommit INT DEFAULT 0;
       DECLARE bError  INT;

       DECLARE ObjectHead_Parent_wClass     SMALLINT;
       DECLARE ObjectHead_Parent_twObjectIx BIGINT;

       DECLARE twRMTObjectIx_Open           BIGINT;

            -- Create the temp Error table
        CREATE TEMPORARY TABLE Error
               (
                  nOrder                        INT             NOT NULL AUTO_INCREMENT PRIMARY KEY,
                  dwError                       INT             NOT NULL,
                  sError                        VARCHAR (255)   NOT NULL
               );

            -- Create the temp Event table
        CREATE TEMPORARY TABLE Event
               (
                  nOrder                        INT             NOT NULL AUTO_INCREMENT PRIMARY KEY,
                  sType                         VARCHAR (50)    NOT NULL,
                  Self_wClass                   SMALLINT        NOT NULL,
                  Self_twObjectIx               BIGINT          NOT NULL,
                  Child_wClass                  SMALLINT        NOT NULL,
                  Child_twObjectIx              BIGINT          NOT NULL,
                  wFlags                        SMALLINT        NOT NULL,
                  twEventIz                     BIGINT          NOT NULL,
                  sJSON_Object                  TEXT            NOT NULL,
                  sJSON_Child                   TEXT            NOT NULL,
                  sJSON_Change                  TEXT            NOT NULL
               );

           SET twRPersonaIx  = IFNULL (twRPersonaIx,  0);
           SET twRMRootIx    = IFNULL (twRMRootIx,    0);

         START TRANSACTION;

          CALL call_RMRoot_Validate (twRPersonaIx, twRMRootIx, ObjectHead_Parent_wClass, ObjectHead_Parent_twObjectIx, nError);
            IF nError = 0
          THEN
                   CALL call_RMTObject_Validate_Name       (SBO_CLASS_RMROOT, twRMRootIx, 0, Name_wsRMTObjectId, nError);
                   CALL call_RMTObject_Validate_Type       (SBO_CLASS_RMROOT, twRMRootIx, 0, Type_bType, Type_bSubtype, Type_bFiction, nError);
                   CALL call_RMTObject_Validate_Owner      (SBO_CLASS_RMROOT, twRMRootIx, 0, Owner_twRPersonaIx, nError);
                   CALL call_RMTObject_Validate_Resource   (SBO_CLASS_RMROOT, twRMRootIx, 0, Resource_qwResource, Resource_sName, Resource_sReference, nError);
                -- CALL call_RMTObject_Validate_Transform  (SBO_CLASS_RMROOT, twRMRootIx, 0, Transform_Position_dX, Transform_Position_dY, Transform_Position_dZ, Transform_Rotation_dX, Transform_Rotation_dY, Transform_Rotation_dZ, Transform_Rotation_dW, Transform_Scale_dX, Transform_Scale_dY, Transform_Scale_dZ, nError);
                   CALL call_RMTObject_Validate_Bound      (SBO_CLASS_RMROOT, twRMRootIx, 0, Bound_dX, Bound_dY, Bound_dZ, nError);
                   CALL call_RMTObject_Validate_Properties (SBO_CLASS_RMROOT, twRMRootIx, 0, Properties_bLockToGround, Properties_bYouth, Properties_bAdult, Properties_bAvatar, nError);

                     IF bCoord = 3 -- RMTMATRIX_COORD_NUL
                   THEN
                        CALL call_RMTObject_Validate_Coord_Nul (SBO_CLASS_RMROOT, twRMRootIx, 0, Transform_Position_dX, Transform_Position_dY, Transform_Position_dZ, Transform_Rotation_dX, Transform_Rotation_dY, Transform_Rotation_dZ, Transform_Rotation_dW, Transform_Scale_dX, Transform_Scale_dY, Transform_Scale_dZ, nError);
                 ELSEIF bCoord = 2 -- RMTMATRIX_COORD_CAR
                   THEN
                        CALL call_RMTObject_Validate_Coord_Car (SBO_CLASS_RMROOT, twRMRootIx, 0, dA, dB, dC, nError);
                 ELSEIF bCoord = 1 -- RMTMATRIX_COORD_CYL
                   THEN
                        CALL call_RMTObject_Validate_Coord_Cyl (SBO_CLASS_RMROOT, twRMRootIx, 0, dA, dB, dC, nError);
                 ELSEIF bCoord = 0 -- RMTMATRIX_COORD_GEO
                   THEN
                        CALL call_RMTObject_Validate_Coord_Geo (SBO_CLASS_RMROOT, twRMRootIx, 0, dA, dB, dC, nError);
                   ELSE
                        CALL call_Error (99, 'bCoord is invalid', nError);
                 END IF ;
        END IF ;

            IF nError = 0
          THEN
                   CALL call_RMRoot_Event_RMTObject_Open (twRMRootIx, Name_wsRMTObjectId, Type_bType, Type_bSubtype, Type_bFiction, Owner_twRPersonaIx, Resource_qwResource, Resource_sName, Resource_sReference, Transform_Position_dX, Transform_Position_dY, Transform_Position_dZ, Transform_Rotation_dX, Transform_Rotation_dY, Transform_Rotation_dZ, Transform_Rotation_dW, Transform_Scale_dX, Transform_Scale_dY, Transform_Scale_dZ, Bound_dX, Bound_dY, Bound_dZ, Properties_bLockToGround, Properties_bYouth, Properties_bAdult, Properties_bAvatar, twRMTObjectIx_Open, bError);
                     IF bError = 0
                   THEN
                              IF bCoord = 3 -- RMTMATRIX_COORD_NUL
                            THEN
                                 CALL call_RMTMatrix_Nul (SBO_CLASS_RMROOT, twRMRootIx, twRMTObjectIx_Open, Transform_Position_dX, Transform_Position_dY, Transform_Position_dZ, Transform_Rotation_dX, Transform_Rotation_dY, Transform_Rotation_dZ, Transform_Rotation_dW, Transform_Scale_dX, Transform_Scale_dY, Transform_Scale_dZ);
                          ELSEIF bCoord = 2 -- RMTMATRIX_COORD_CAR
                            THEN
                                 CALL call_RMTMatrix_Car (twRMTObjectIx_Open, dA, dB, dC);
                          ELSEIF bCoord = 1 -- RMTMATRIX_COORD_CYL
                            THEN
                                 CALL call_RMTMatrix_Cyl (twRMTObjectIx_Open, dA, dB, dC);
                          ELSEIF bCoord = 0 -- RMTMATRIX_COORD_GEO
                            THEN
                                 CALL call_RMTMatrix_Geo (twRMTObjectIx_Open, dA, dB, dC);
                          END IF ;

                            CALL call_RMTMatrix_Relative (SBO_CLASS_RMROOT, twRMRootIx, twRMTObjectIx_Open);

                          SELECT twRMTObjectIx_Open AS twRMTObject;
   
                             SET bCommit = 1;
                   ELSE
                            CALL call_Error (-1, 'Failed to insert RMTObject', nError);
                 END IF ;
        END IF ;
       
            IF bCommit = 1
          THEN
                    SET bCommit = 0;
                 
                   CALL call_RMRoot_Log (RMROOT_OP_RMTOBJECT_OPEN, sIPAddress, twRPersonaIx, twRMRootIx, bError);
                     IF bError = 0
                   THEN
                            CALL call_Event_Push (bError);
                              IF bError = 0
                            THEN
                                      SET bCommit = 1;
                            ELSE
                                     CALL call_Error (-9, 'Failed to push events', nError);
                          END IF ;
                   ELSE
                            CALL call_Error (-8, 'Failed to log action', nError);
                 END IF ;
        END IF ;

            IF bCommit = 0
          THEN
                 SELECT dwError, sError FROM Error;

               ROLLBACK ;
          ELSE
                 COMMIT ;
        END IF ;

          DROP TEMPORARY TABLE Error;
          DROP TEMPORARY TABLE Event;

           SET nResult = bCommit - 1 - nError;
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                             MVD_RP1_Map : init_DefaultScene.sql                                            ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2025 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE init_DefaultScene
(
)
BEGIN
       DECLARE nResult INT;

       CALL set_RMRoot_RMPObject_Open
       (
          '0.0.0.0',                 -- sIPAddress           
          1,                         -- twRPersonaIx         
          1,                         -- twRMRootIx           
          'My First Scene',          -- Name_wsRMPObjectId   
          1,                         -- Type_bType           
          0,                         -- Type_bSubtype        
          1,                         -- Type_bFiction        
          0,                         -- Type_bMovable        
          1,                         -- Owner_twRPersonaIx   
          0,                         -- Resource_qwResource  
          '',                        -- Resource_sName       
          '',                        -- Resource_sReference  
          0,                         -- Transform_Position_dX
          0,                         -- Transform_Position_dY
          0,                         -- Transform_Position_dZ
          0,                         -- Transform_Rotation_dX
          0,                         -- Transform_Rotation_dY
          0,                         -- Transform_Rotation_dZ
          1,                         -- Transform_Rotation_dW
          1,                         -- Transform_Scale_dX   
          1,                         -- Transform_Scale_dY   
          1,                         -- Transform_Scale_dZ   
          150,                       -- Bound_dX             
          150,                       -- Bound_dY             
          150,                       -- Bound_dZ             
          nResult                    -- nResult
       );
       -- twRMPObjectIx = 1

       CALL set_RMPObject_RMPObject_Open
       (
          '0.0.0.0',                 -- sIPAddress           
          1,                         -- twRPersonaIx         
          1,                         -- twRMPObjectIx        
          'Hello World!',            -- Name_wsRMPObjectId   
          2,                         -- Type_bType           
          0,                         -- Type_bSubtype        
          1,                         -- Type_bFiction        
          0,                         -- Type_bMovable        
          1,                         -- Owner_twRPersonaIx   
          0,                         -- Resource_qwResource  
          '',                        -- Resource_sName       
          '/scenes/hello_world.glb', -- Resource_sReference  
          0,                         -- Transform_Position_dX
          0,                         -- Transform_Position_dY
          0,                         -- Transform_Position_dZ
          0,                         -- Transform_Rotation_dX
          0,                         -- Transform_Rotation_dY
          0,                         -- Transform_Rotation_dZ
          1,                         -- Transform_Rotation_dW
          1,                         -- Transform_Scale_dX   
          1,                         -- Transform_Scale_dY   
          1,                         -- Transform_Scale_dZ   
          134.65382385253906,        -- Bound_dX             
          13.596150933846705,        -- Bound_dY             
          129.60743890149325,        -- Bound_dZ             
          nResult                    -- nResult
       );
       -- twRMPObjectIx = 2
END$$
  
DELIMITER ;

CALL init_DefaultScene ();

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
