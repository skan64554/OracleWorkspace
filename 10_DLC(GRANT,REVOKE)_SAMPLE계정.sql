-- 3-1.
-- CREATE TABLE권한 부여받기 전
CREATE TABLE TEST(
    TEST_ID NUMBER
);
-- 3-2. CREATE TABLE권한 부여받은 후
CREATE TABLE TEST(
    TEST_ID NUMBER
);
-- no privileges on tablespace 'SYSTEM'
-- SAMPLE 계정에는 TABLESPACE가 할당되지 않아 오류 발생

-- 테이블저장공간을 할당받은 후(2M)
CREATE TABLE TEST(
    TEST_ID NUMBER
);
-- 테이블 생성권한을 부여받게 되면, 현재 계정이 소유하고 있는 테이블들을 조작(DML)하는 것도
-- 가능해진다.
INSERT INTO TEST VALUES(1);
SELECT * FROM TEST;

-- 4. 뷰 생성권한 부여받은 후
CREATE VIEW V_TEST
AS SELECT * FROM TEST;

SELECT * FROM V_TEST; 

-- 5. SAMPLE계정에서 KH계정의 테이블에 접근해서 조회
SELECT * FROM KH.EMPLOYEE;

-- 6. KH.DEPARTMENT 테이블 조회
SELECT * FROM KH.DEPARTMENT;

INSERT INTO KH.DEPARTMENT VALUES('D0','회계부','L2');
COMMIT;

-- 7. 권한 회수후 테이블 생성
CREATE TABLE TEST2(
    TEST_ID NUMBER
);
