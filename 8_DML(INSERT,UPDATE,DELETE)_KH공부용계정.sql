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
