/*
    Object
     - 데이터베이스를 이루는 논리적인 구조물
     - TABLE, USER, VIEW, SEQUENCE, INDEX, ...
     
    <VIEW 뷰>
     - SELECT문을 저장해두는 객체
     - 조회용 임시테이블과 같이 사용한다
     - 실제 데이터가 담겨있는 것이 아니다
*/

/*
    1. VIEW 생성 방법
    [표현법]
    CREATE VIEW 뷰명
    AS 서브쿼리;
    
    CREATE OR REPLACE 뷰명
    AS 서브쿼리;
*/
-- VIEW 생성 권한 부여(관리자계정)
GRANT CREATE VIEW TO KH;

-- '한국'에서 근무하는 사원들의 사번,이름,부서명,급여,근무국가명,직급명 조회
CREATE VIEW VW_EMPLOYEE
AS SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY, NATIONAL_NAME, JOB_NAME
FROM EMPLOYEE E 
JOIN JOB USING(JOB_CODE)
LEFT JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
LEFT JOIN LOCATION ON LOCATION_ID = LOCAL_CODE
LEFT JOIN NATION USING(NATIONAL_CODE)
WHERE NATIONAL_NAME = '한국';

SELECT * FROM VW_EMPLOYEE;

/*
SELECT *
FROM VW_EMPLOYEE
WHERE BONUS IS NULL -- VIEW에 존재하는 않는 컬럼사용시 오류발생
*/

-- 생성 혹은 대체 
CREATE OR REPLACE VIEW VW_EMPLOYEE
AS SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY, NATIONAL_NAME, JOB_NAME , BONUS
FROM EMPLOYEE E 
JOIN JOB USING(JOB_CODE)
LEFT JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
LEFT JOIN LOCATION ON LOCATION_ID = LOCAL_CODE
LEFT JOIN NATION USING(NATIONAL_CODE)
WHERE NATIONAL_NAME = '한국';

/*
    VIEW 컬럼에 별칭 부여하는 방법
*/
-- 사번, 이름, 직급명, 성별, 근무년수 조회
CREATE OR REPLACE VIEW VW_EMP_JOB
AS SELECT EMP_ID, EMP_NAME, JOB_NAME, SUBSTR(EMP_NO, 8 , 1) AS "성별"
, EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE) AS "근무년수"
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE); -- 컬럼에 함수를 사용한 경우 컬럼부여가 필수

SELECT * FROM VW_EMP_JOB;

-- 또다른 별칭부여 방법
CREATE OR REPLACE VIEW VW_EMP_JOB(사번,사원명, 직급명, 성별, 근무년수)
AS SELECT EMP_ID, EMP_NAME, JOB_NAME, SUBSTR(EMP_NO, 8 , 1) 
, EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE) 
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE);

SELECT * FROM VW_EMP_JOB;

/*
    VIEW를 활용한 DML(INSERT,UPDATE,DELETE)
     - 뷰를 통해서 DML을 수행하는 경우, 실제 데이터를 저장하고 있는 테이블에 변경사항 적용
*/
CREATE OR REPLACE VIEW VW_JOB
AS SELECT * FROM JOB;

SELECT * FROM VW_JOB; -- 7행

-- 뷰에 INSERT
INSERT INTO VW_JOB
VALUES('J8','인턴');

SELECT * FROM JOB; -- 실제 테이블에 행이 추가됨 -> 8행
SELECT * FROM VW_JOB;

-- VW_JOB의 J8등급의 직급명을 알바로 변경
UPDATE VW_JOB
SET JOB_NAME = '알바'
WHERE JOB_CODE = 'J8';

/*
    * DML이 가능한 경우 : 서브쿼리를 이용한 결과값이 기존의 테이블과 별도의 차이가 없는 경우
    
    * 뷰를 통해 DML이 불가능한 경우
    1) 뷰에 정의되지 않은 컬럼을 조작한 경우
    2) 뷰에 정의되어 있지 않은 컬럼 중 NOT NULL제약조건이 추가된 컬럼이 존재하는 경우
    3) 산술연산식 또는 함수를 통한 컬럼이 정의되어 있는 경우
    4) 그룹함수나 GROUP BY절이 포함된 경우
    5) DISTINCT구문이 포함된 경우
    6) JOIN을 통해 여러 테이블을 매칭시켜놓은 경우
*/
-- 1) 뷰에 정의되지 않은 컬럼을 조작
-- 2) 뷰에 정의되어 있지 않은 컬럼 중, 원본테이블상에 NOT NULL 제약조건이 추가된 경우
CREATE OR REPLACE VIEW VW_JOB
AS SELECT JOB_NAME FROM JOB;

INSERT INTO VW_JOB(JOB_CODE, JOB_NAME) VALUES ('J9','인턴'); 

UPDATE VW_JOB
SET JOB_NAME = '인턴';

ROLLBACK;

-- 3) 산술연산식 또는 함수를 통한 컬럼의 정의되어 있는 경우
CREATE OR REPLACE VIEW VW_EMP_SAL
AS SELECT EMP_ID , EMP_NAME, SALARY, SALARY * 12 연봉
FROM EMPLOYEE;

-- "virtual column not allowed here" 오류발생
INSERT INTO VW_EMP_SAL VALUES (400,'로클',3000000, 36000000);

-- 4) 그룹함수나, GROUP BY 절이 포함된 경우
CREATE OR REPLACE VIEW VW_GROUPDEPT 
AS SELECT DEPT_CODE, SUM(SALARY) 합
FROM EMPLOYEE
GROUP BY DEPT_CODE;

-- data manipulation operation not legal on this view
UPDATE VIEW VW_GROUPDEPT
SET 합 = 8000000
WHERE DEPT_CODE = 'D1';

-- 5) DISTINCT구문이 포함된 경우 
CREATE OR REPLACE VIEW VW_DT_JOB
AS SELECT DISTINCT JOB_CODE FROM EMPLOYEE;

-- data manipulation operation not legal on this view
INSERT INTO VW_DT_JOB VALUES('J8');

-- 6) JOIN을 이용한 VIEW에 대한 DML
CREATE OR REPLACE VIEW VW_JOINEMP
AS SELECT EMP_ID, EMP_NAME, DEPT_TITLE
FROM EMPLOYEE
JOIN DEPARTMENT ON DEPT_ID = DEPT_CODE;

-- cannot modify more than one base table through a join view
INSERT INTO VW_JOINEMP VALUES(300,'조세오','총무부');

SELECT * FROM VW_JOINEMP;
-- 200번 사원의 이름 변경
UPDATE VW_JOINEMP
SET EMP_NAME = '서동이'
WHERE EMP_ID = 200; -- 하나의 테이블에서 조작이 발생하는 경우 조작 성공

UPDATE VW_JOINEMP -- 버전차이로 되거나 안됨
SET DEPT_TITLE = '회계부'
WHERE EMP_ID = 200;

ROLLBACK;

/*
    VIEW에서 사용 가능한 옵션들
    1. OR REPLACE
    2. FORCE/NOFORCE 옵션
     - 실제 테이블이 없어도 VIEW를 먼저 생성할 수 있게 해주는 옵션.
*/
CREATE FORCE VIEW V_FORCETEST
AS SELECT A,B,C FROM FORCETABLE; -- 존재하지 않는 테이블이지만 뷰를 먼저 만들기

SELECT * FROM V_FORCETEST; -- 테이블 존재 X

CREATE TABLE FORCETABLE(
    A NUMBER,
    B NUMBER,
    C NUMBER
);

-- 3. WITH CHECK OPTION 
-- SELECT문의 WHERE절에서 사용한 컬럼을 수정하지 못하게 막는 옵션
CREATE OR REPLACE VIEW V_CHECKOPTION
AS SELECT EMP_ID, EMP_NAME, SALARY , DEPT_CODE
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5' WITH CHECK OPTION;

-- "view WITH CHECK OPTION where-clause violation"
UPDATE V_CHECKOPTION
SET DEPT_CODE = 'D6'
WHERE EMP_ID = 206; -- D5 -> D6

UPDATE V_CHECKOPTION
SET SALARY = 6000000
WHERE EMP_ID = 206; -- WHERE절에 기술한 컬럼이 아니므로 변경 가능

-- 4. WITH READ ONLY 
-- VIEW의 DML을 차단하는 옵션
CREATE OR REPLACE VIEW V_READ
AS SELECT EMP_ID, EMP_NAME, SALARY
FROM EMPLOYEE WITH READ ONLY;

-- "cannot perform a DML operation on a read-only view"
UPDATE V_READ 
SET SALARY = 1000000000000000;






