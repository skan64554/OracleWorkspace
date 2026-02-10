/*
    TCL(TRANSACTION CONTROL LANGUAGE)
     - 트랜잭션 제어 언어
        * 트랜잭션
            - 데이터베이스의 논리적인 작업 단위
     - DMBS는 데이터베이스의 변경사항(DML)들을 하나의 트랜젹선으로 묶어 두고, TCL문에
     의해 실제 데이터베이스에 반영되거나 취소처리 된다. (ALL OR NOTHING)
     
     - COMMIT : 하나의 트랜잭션에 담겨있는 변경사항들을 실제 DB에 반영하는 명렁어
                COMMIT 실행후, 트랜잭션 내부의 변경사항은 모두 비워진다(CLEAN)
     - ROLLBACK : 하나의 트랜잭션에 담겨있는 변경사항들을 실제 DB에 반영하지 않고
                  취소하는 명령어.
                  트랜잭션에 담겨있는 변경사항도 모두 삭제한 후 마지막 COMMIT 시점으로 귀환
     - SAVEPOINT 포인트명 : 현재 시점에 임시저장점을 정의해 두는 문법
     - ROLLBACK TO 포인트명 : 전체 변경사항을 취소하는게아니라, 포인트 지점까지의
     트랜잭션만 롤백하는 명령어
*/
/*
    ACID
    1. Atomicity(원자성) 
     - 원자 ? 더이상 나눌 수 없는 기본단위
     - 트랜잭션의 작업들은 모두 하나로 묶어서 처리된다. (모두 commit되거나 모두 rollback)
     - 즉, 트랜잭션 내부작업을 commit, rollback으로 상세하게 쪼개어 처리할 수 없기 때문에
     원자성의 특징을 가진다
*/
-- EMP_01 테이블생성
CREATE TABLE EMP_01
AS SELECT EMP_ID, EMP_NAME, DEPT_TITLE
FROM EMPLOYEE
JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID;

SELECT * FROM EMP_01; -- 26

-- 사번이 902번인 사원 삭제
DELETE FROM EMP_01
WHERE EMP_ID = 902;
-- 사번이 903번인 사원 삭제
DELETE FROM EMP_01
WHERE EMP_ID = 903;

SELECT * FROM EMP_01; --24

-- 관리자계정
SELECT * FROM KH.EMP_01; -- 다른 세션(계정)에서는 변경 사항이 반영되지 않은 26명으로 보임

-- 트랜잭션에는 2개의 DML이 쌓여있으며 이를 분리하는것은 불가능하다 (원자성)
ROLLBACK;
SELECT * FROM EMP_01;
--------------------------------------------------------------------------------
/*
    2. Consistency(일관성)
     - 트랜잭션이 실행될 때 그 실행결과로 인해 "데이터베이스의 일관성"이 깨지지 않도록
     유지해주는 속성
      * 데이터베이스의 일관성
       - 데이터가 일관된 상태를 유지함을 의미한다.
       - 데이터베이스가 일관성을 유지한다는 것은 데이터가 "정의된 제약조건을 준수"함을 의미함
    
*/
-- 제약조건이 추가된 테이블에 제약조건을 준수한 데이터,
-- 준수하지 않은 데이터를 추가
ALTER TABLE EMP_01 ADD PRIMARY KEY(EMP_ID);

-- 기본키 제약조건 위배.
-- 데이터베이스의 일관성 유지를 위해 아래 DML문은 트랜잭션에 추가도 안됨
INSERT INTO EMP_01 VALUES(200,'선동일2','총무부');
INSERT INTO EMP_01 VALUES(800,'선동일2','총무부');
COMMIT;

/*
    3. Isolation(격리성)
     - 서로 다른 세션에서 동시에 여러 트랜잭션이 실행되는 경우, 각 트랜잭션이
     서로의 작업에 영향을 끼치지 않고 독립적으로 실행됨을 보장하는 속성
     - 만약 하나의 테이블에 대해 동시에 여러 세션에서 DML이 수행되는 경우, 내가
     테이블의 중간상태를 보고 작성한 코드가 제대로 실행되지 않을 수 있다.
     이를 방지하기 위해서 RDBMS는 트랜잭션의 DML이 완전히 COMMIT, ROLLBACK되기 전까지는
     다른 세션에서 DML을  수행하지 못하도록 LOCK을 걸어버린다
     
     -- 1) 선동일 사원의 DEPT_CODE를 D2로 바꿔라
     UPDATE EMPLOYEE SET DEPT_CODE = 'D2' WHERE EMP_NAME  = '선동일';
     -- 2) 사번이 200번인 사원의 이름을 '민동일'로 바꿔라.
     UPDATE EMPLOYEE SET EMP_NAME = '민동일' WHERE EMP_ID ='200';
*/
-- 사번이 200번인 사원 삭제
DELETE FROM EMP_02
WHERE EMP_ID = 200;
-- 사번이 801, 홍길동, 총무부 사원 추가
INSERT INTO EMP_02 
VALUES(801,'홍길동','총무부');
COMMIT;

/*
    4. Durability(지속성)
     - 한번 반영된 트랜잭션은 DMBS에 영구히 반영되도록 보장하는 속성
*/

-- SAVEPOINT , ROLLBACK TO
-- EMP_01테이블에서 사번이 217,216,214인 사원 삭제
DELETE FROM EMP_01
WHERE EMP_ID IN (217,216,214);

SELECT * FROM EMP_01;

SAVEPOINT SP1;

-- 사번이 218번인 사원 삭제
DELETE FROM EMP_01
WHERE EMP_ID = 219;

SELECT * FROM EMP_01;

-- 사원 수 24
INSERT INTO EMP_01
VALUES (999, '김말똥','인사부');

-- 사원 수 25

ROLLBACK TO SP1;

SELECT * FROM EMP_01;

/*
    주의사항
    DDL구문(CREATE, ALTER, DROP)을 실행하는 순간 기존 트랜잭션에 있던 모든 변경사항들은
    무조건 COMMIT을 시킨 후에 DDL이 수행된다.
*/
COMMIT; -- 25명 확정
DELETE FROM EMP_01;

-- 테이블 생성
CREATE TABLE TEST (
    TID NUMBER
);

ROLLBACK;

SELECT * FROM EMP_01; -- 롤백을 했음에도 불구하고 데이터 X




