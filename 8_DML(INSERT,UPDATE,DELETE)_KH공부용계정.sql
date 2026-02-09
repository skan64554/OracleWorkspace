/*
    * DML
     - 데이터 조작 언어
     - 테이블에 새로운 데이터를 삽입(INSERT)하거나, 수정(UPDATE)하거나, 삭제(DELETE)하는 구문
*/

/*
    1. INSERT (비추천)
     - 테이블에 새로운 행을 추가하는 구문
    
     * INSERT INTO 계열
     1) INSERT INTO 테이블명 VALUES(값1, 값2, 값3, ...);
      - 테이블에 들어갈 "모든"컬럼에 대해 추가할 값을 내가 직접 제시하여 추가하는 방법
      - 컬럼을 순서, 자료형, 갯수를 모두 완벽히 맞춰서 준비해야 한다
*/
-- EMPLOYEE 테이블에 사원 정보를 추가
INSERT INTO EMPLOYEE
VALUES (900,'김갑생','971008-2211221','CROCKLE@VELOG.com'
,'01012345678','D1','J7','S6',1800000 , 0.2, 200, SYSDATE, NULL, DEFAULT);

/*
    2) INSERT INTO 테이블명(칼럼1, 칼럼2, ...) (추천)
    VALUES (값1,값2,...)
     - 테이블에 특정컬럼들만 선택하여 그 컬럼에 추가할 값을 제시할 경우 사용
     - 선택되지 않은 컬럼은 NULL값 혹은 DEFAULT설정이 완료된 경우 DEFAULT값이 추가된다
     - NOT NULL컬럼중, DEFAULT값 설정이 되지 않은 컬럼은 필수로 값을 추가해야 한다
*/
INSERT INTO EMPLOYEE(EMP_ID, EMP_NAME, EMP_NO, JOB_CODE, SAL_LEVEL)
VALUES(901,'크로클','951026-1234567','J1','S1');

SELECT * FROM EMPLOYEE WHERE EMP_ID = 901;

/*
    3) INSERT INTO 테이블명 (서브쿼리); ( 추천 )
     - 서브쿼리 수행 결과값을 한번에 INSERT하는 문법
     - 여러행의 값을 한번에 INSERT할 수 있다
*/
CREATE TABLE EMP_01(
    EMP_ID NUMBER,
    EMP_NAME VARCHAR2(30),
    DEPT_TITLE VARCHAR2(20)
);
INSERT INTO EMP_01
(SELECT EMP_ID, EMP_NAME, DEPT_TITLE FROM EMPLOYEE
JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID);

INSERT INTO EMP_01
(
    SELECT * FROM (
        SELECT 902 EMP_ID, '아무개1' EMP_NAME, '총무부' DEPT_TITLE
        FROM DUAL 
        UNION ALL
        SELECT 903 EMP_ID, '아무개2' EMP_NAME, '인사부' DEPT_TITLE
        FROM DUAL
        UNION ALL 
        SELECT 904 EMP_ID, '아무개3' EMP_NAME, '해외영업부' DEPT_TITLE
        FROM DUAL
    )
);
/*
    * INSERT ALL 계열
     - 두 개 이상의 테이블이 각각 INSERT할 때 사용하는 쿼리문
     
     1) INSERT ALL
        INTO 테이블1 VALUES (컬럼명1, 컬럼명2,...)
        INTO 테이블2 VALUES (컬럼명1, 컬럼명2,...)
        ...
        서브쿼리 
*/
-- EMP_JOB / EMP_ID, EMP_NAME, JOB_NAME
-- EMP_DEPT / EMP_ID, EMP_NAME, DEPT_CODE
CREATE TABLE EMP_JOB (
    EMP_ID NUMBER,
    EMP_NAME VARCHAR2(30),
    JOB_NAME VARCHAR2(20)
);
CREATE TABLE EMP_DEPT(
    EMP_ID NUMBER,
    EMP_NAME VARCHAR2(30),
    DEPT_TITLE VARCHAR2(30)
);

-- 급여가 300만원 이상인 사원의 정보 조회
SELECT EMP_ID, EMP_NAME, JOB_NAME, DEPT_TITLE
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
JOIN JOB USING(JOB_CODE)
WHERE SALARY > 3000000;

INSERT ALL
INTO EMP_JOB VALUES(EMP_ID, EMP_NAME, JOB_NAME)
INTO EMP_DEPT VALUES(EMP_ID, EMP_NAME, DEPT_TITLE)
    SELECT EMP_ID, EMP_NAME, JOB_NAME, DEPT_TITLE
    FROM EMPLOYEE
    LEFT JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
    JOIN JOB USING(JOB_CODE)
    WHERE SALARY > 3000000;

/*
    2) INSERT ALL
       WHEN 조건1 THEN 
            INTO 테이블 VALUES(...)
       WHEN 조건2 THEN
            INTO 테이블 VALUES(...)
            서브쿼리.
*/
-- 조건을 활용한 INSERT
-- 2010년 이전 입사자 정보를 저장할 테이블 EMP_OLD
-- 2010년 이후 입사자 정보를 저장할 테이블 EMP_NEW
CREATE TABLE EMP_OLD
AS SELECT EMP_ID, EMP_NAME, HIRE_DATE, SALARY FROM EMPLOYEE WHERE 1=0;

SELECT * FROM EMP_OLD;

CREATE TABLE EMP_NEW
AS SELECT EMP_ID, EMP_NAME, HIRE_DATE, SALARY 
FROM EMPLOYEE 
WHERE 1=0;

INSERT ALL
    WHEN HIRE_DATE < '2010/01/01' THEN 
        INTO EMP_OLD VALUES (EMP_ID, EMP_NAME, HIRE_DATE, SALARY)
    WHEN HIRE_DATE >= '2010/01/01' THEN
        INTO EMP_NEW VALUES (EMP_ID, EMP_NAME, HIRE_DATE, SALARY)
    SELECT * FROM EMPLOYEE;
    
SELECT * FROM EMP_OLD;

-- 2026/02/09

/*
    2. UPDATE
     - 테이블에 저장된 데이터를 "수정"하는 구문
    [표현법]
    UPDATE 테이블명
    SET 컬럼명 = 바꿀값 ,
        컬럼멸 = 바꿀값 ,
        ...
    WHERE 조건식
*/

-- 복사본테이블
CREATE TABLE DEPT_COPY
AS SELECT * FROM DEPARTMENT;

SELECT * FROM DEPT_COPY;

UPDATE DEPT_COPY
SET DEPT_TITLE = '전략기획부'; -- 조건이 없어 DEPT_TILE 행 전부 전략기획부로 변경

ROLLBACK;  -- TCL문법. 변경사항(DML)을 되돌리는 명령어

UPDATE DEPT_COPY
SET DEPT_TITLE = '전략기획부'
WHERE DEPT_ID = 'D9';

-- EMPLOYEE 복사본 테이블
CREATE TABLE EMP_SALARY
AS SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY, BONUS
FROM EMPLOYEE;

SELECT * FROM EMP_SALARY;

-- EMP_SALARY 테이블에서 노홍철 사원의 월급을 1000만원으로 변경
-- EMP_SALARY 테이블에서 선동일 사원의 급여의 700만원, 보너스를 0.2로 변경
UPDATE EMP_SALARY
SET SALARY = 10000000
WHERE EMP_NAME = '노옹철';

ROLLBACK;

UPDATE EMP_SALARY
SET SALARY = 7000000 ,
    BONUS = 0.2
WHERE EMP_NAME = '선동일';

ROLLBACK;

-- 전체 사원들의 급여를 기존 급여의 20% 인상한 금액으로 변경
UPDATE EMP_SALARY 
SET SALARY = SALARY * 1.2;

ROLLBACK;


/*
    3. 서브쿼리를 활용한 UPDATE
    [표현법]
    UPDATE 테이블명
    SET 컬럼명 = (서브쿼리)
    SET (컬럼1,컬럼2) = (MULTI COLUMNS 서브쿼리)
    WHERE 조건식;
*/
-- EMP_SALARY 테이블에 크로클 사원의 부서코드를 선동일 사원의 부서코드로 변경
SELECT * FROM EMP_SALARY;

UPDATE EMP_SALARY
SET DEPT_CODE = (SELECT DEPT_CODE FROM EMP_SALARY WHERE EMP_NAME = '선동일')
WHERE EMP_NAME = '크로클';

ROLLBACK;

-- 방명수 사원의 급여, 보너스를 유재식 사원의 급여와 보너스값으로 변경
UPDATE EMP_SALARY
SET (SALARY,BONUS) = (SELECT SALARY,BONUS FROM EMP_SALARY WHERE EMP_NAME = '유재식')
WHERE EMP_NAME = '방명수';

ROLLBACK;

-- 사번이 200번인 사원의 이름을 NULL로 변경해보기
SELECT * FROM EMPLOYEE;

UPDATE EMPLOYEE
SET EMP_NAME = NULL
WHERE EMP_ID = 200; -- 제약조건 상 위배됨으로 오류 발생
COMMIT; -- 변경사항(DML)을 확정하는 명령어

/*
    4. DELETE
     - 테이블에 기록된 데이터를 "행"단위로 삭제하는 구문
     [표현법]
     DELETE FROM 테이블명
     WHERE 조건식
*/
DELETE FROM EMPLOYEE;

SELECT * FROM EMPLOYEE; -- 없음

ROLLBACK;

DELETE FROM EMPLOYEE
WHERE EMP_NAME = '김갑생';

COMMIT;

-- DEPARTMENT 테이블에 DEPT_ID가 D1인 부서 삭제하기.
DELETE FROM DEPARTMENT 
WHERE DEPT_ID = 'D1'; -- 자식테이블에서 컬럼명을 사용하고 있으므로 불가

/*
    TRUNCATE 
     - 테이블의 전체 행을 모두 삭제할 때 사용하는 구문
     - 별도의 조건제시가 불가능하며 롤백도 불가능하다
     - DELETE문보다 수행속도가 빠르다
*/
SELECT * FROM EMP_SALARY;

DELETE FROM EMP_SALARY;
ROLLBACK; -- 롤백가능
TRUNCATE TABLE EMP_SALARY; -- Table EMP_SALARY이(가) 잘렸습니다. (롤백 불가능)