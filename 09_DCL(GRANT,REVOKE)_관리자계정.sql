/*
    DCL(DATA CONTROL LANGUAGE) -- 관리자 계정 접속
     - 데이터 제어 언어
     - 계정에 시스템권한 혹은 객체접근 권한을 부여하거나 회수하는 언어
     
     - 권한부여(GRANT)
     시스템권한 : 특정 DB에 접근가능한 권한
                객체들을 생성할 수 있는 권한
     객체접근권한 : 특정 객체들에 접근해서 조작할 수 있는 권한
    
    [표현법]
    GRANT 권한1, 권한2, ... TO 계정명;
    
    - 시스템권한의 종류
      CREATE SESSION
      CREATE TABLE
      CREATE VIEW
      CREATE SEQUENCE
      CREATE USER
      ... 
*/
-- 1. SAMPLE계정생성
CREATE USER SAMPLE IDENTIFIED BY SAMPLE;

-- 2. 계정에 CREATE SESSION권한 부여
GRANT CREATE SESSION TO SAMPLE;

-- SAMPLE로 접속 ID,PW : SAMPLE
-- SAMPLE과 병행하면서 코딩

-- 3-1. SAMPLE계정에 테이블 생성권한 부여 (CREATE TABLE)
GRANT CREATE TABLE TO SAMPLE;

-- 3-2. SAMPLE계정에 테이블 스페이스 할당(2MEGA TYPE)
-- ALTER문
ALTER USER SAMPLE QUOTA 2M ON SYSTEM;

-- 4. SAMPLE계정에 뷰를 생성할 수 있는 CREATE VIEW 권한 부여하기
GRANT CREATE VIEW TO SAMPLE;

GRANT CREATE VIEW TO WORKBOOK;
/*
    - 객체권한
    특정 객체들을 조작(DML+DQL) 할 수 있는 권한
    
    [표현법]
    GRANT 권한종류 ON 특정객체 TO 계정명;
    
    권한종류 : SELECT/INSERT/UPDATE/DELETE
    특정객체 : TABLE, VIEW, SEQUENCE
*/

-- 5. SAMPLE계정에 KH.EMPLOYEE테이블을 조회(SELECT)할 수 있는 권한 부여
GRANT SELECT ON KH.EMPLOYEE TO SAMPLE;

-- 6. SAMPLE계정에 KH.DEPARTMENT 테이블에 행을 삽입할 수 있는 권한 부여
GRANT INSERT ON KH.DEPARTMENT TO SAMPLE; 
/*
    <롤 권한>
     특정 권한들을 하나의 집합으로 모아 놓은 권한
     
     CONNECT : CREATE SESSION(데이터베이스에 접속할 수 있는 권한)
     RESOURCE : CREATE TABLE, CREATE SEQUENCE, CREATE INDEX , SELECT , ... 
*/

/*
    권한 회수 (REVOKE)
     - 권한을 회수할때 사용하는 명령어
     
     [표현법]
     REVOKE 권한1, 권한2 ... FROM 계정명;
*/
-- 7. SAMPLE 계정에서 테이블을 생성할 수 없도록 권한 회수
REVOKE CREATE TABLE FROM SAMPLE;

