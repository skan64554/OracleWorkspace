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
    Isolation
    Durablity
