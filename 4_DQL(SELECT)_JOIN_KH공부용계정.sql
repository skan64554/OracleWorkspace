/*
    <JOIN>
     - 두 개 이상의 테이블에서 데이터를 같이 조회하고자 할 때 사용되는 구문
     - 조회 결과는 하나의 결과물(RESULT SET)으로 나온다.
     - 관계형데이터베이스(RDBMS)에서는 데이터의 중복을 피하기 위해, 다양한 테이블에 
     데이터를 나눠서 보관하고 있으며, 이 때 여러 테이블의 데이터를 동시에 조회하기 위해서는
     각 테이블이 가지고 있는 외래키를 활용하여 JOIN 시켜줘야 한다
     
     JOIN문은 "오라클전용구문"과 "ANSI구문"으로 나뉘어져 있다
     ANSI구문은 어떤 RDBMS에서도 사용 가능
     
        오라클 전용 구문       |       ANSI 구문
     ===================================================
        등가조인(EQUAL JOIN)  |     내부조인(INNER JOIN)
     ---------------------------------------------------
        포괄조인              |     외부조인(OUTER JOIN)
        (LEFT OUTER JOIN)    |     LEFT OUTER JOIN
        (RIGHT OUTER JOIN)   |     RIGHT OUTER JOIN
                             |      FULL OUTER JOIN
     ---------------------------------------------------
     카테시안의 곱(CARTESIAN PRODUCT) | 교차조인(CROSS JOIN)
     ---------------------------------------------------
        자체조인(SELF JOIN)
        비등가조인(NON EQUAL JOIN)
*/  

/*
    1. 등가조인(EQUAL JOIN) / 내부조인(INNER JOIN)
     - 연결시키고자 하는 컬럼의 값이 "일치"하는 행들만 조인
     
     [표현법]
     등가조인 (오라클 구문)
     SELECT 조회하고자 하는 칼럼명들 나열
     FROM 조인하고자 하는 테이블명 나열
     WHERE 연결할 칼럼에 대한 조건을 제시
     
     내부조인(ANSI구문)
     SELECT 칼럼명들
     FROM 테이블1 
     JOIN 조인할 테이블2 [ON/USING] 연결할 칼럼에 대한 조건 제시
*/

-- 오라클 전용 구문
-- 전체 사원들의 사번, 사원명, 직급코드, 직급명을 알아내고자 한다.
SELECT EMP_ID, EMP_NAME, J.JOB_CODE, JOB_NAME
FROM EMPLOYEE E , JOB J
WHERE E.JOB_CODE = J.JOB_CODE;

-- 전체 사원들의 사번, 사원명, 부서코드, 부서명을 조회
SELECT EMP_ID, EMP_NAME , DEPT_CODE, DEPT_TITLE
FROM EMPLOYEE E, DEPARTMENT D
WHERE DEPT_CODE = DEPT_ID;

-- ANSI 구문
    -- ON 구문
    SELECT EMP_ID, EMP_NAME, E.JOB_CODE, JOB_NAME
    FROM EMPLOYEE E
    /* INNER */JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE);
    -- USING 구문
    --  조인할 두 테이블간의 컬럼명이 동일한 경우에만 사용이 가능하다
    --  동일한 칼럼명 기준으로 각 행을 매칭시켜준다
    SELECT EMP_ID, EMP_NAME, JOB_CODE, JOB_NAME
    FROM EMPLOYEE
    JOIN JOB USING(JOB_CODE);
    
-- 자연조인(NATURAL JOIN)
--  등가조인중 하나로, 동일한 타입과 칼럼명을 가진 칼럼을 조인조건으로 이용하는 조인문
SELECT EMP_ID, EMP_NAME, JOB_CODE, JOB_NAME
FROM EMPLOYEE
NATURAL JOIN JOB;

-- 직급이 대리인 사원들의 다음 정보를 조회
-- 사번, 사원명, 월급, 직급명
SELECT EMP_ID, EMP_NAME, SALARY , JOB_NAME
FROM EMPLOYEE E , JOB J
WHERE E.JOB_CODE = J.JOB_CODE
AND JOB_NAME = '대리';

-- 실습문제 -- 아래 문제를 오라클전용구문과 ANSI구문 모두 사용하여 실행

-- 1. 부서가 '인사관리부' 인 사원들의 사번, 사원명, 보너스를 조회
SELECT EMP_ID, EMP_NAME, BONUS
FROM EMPLOYEE E, DEPARTMENT D
WHERE DEPT_CODE = DEPT_ID
AND DEPT_TITLE = '인사관리부';

SELECT EMP_ID, EMP_NAME, BONUS
FROM EMPLOYEE E
JOIN DEPARTMENT D ON (DEPT_CODE = DEPT_ID AND D.DEPT_TITLE = '인사관리부');
-- 2. 부서가 '총무부' 가 아닌 사원들의 사원명, 급여, 입사일을 조회
SELECT EMP_NAME , SALARY, HIRE_DATE
FROM EMPLOYEE E, DEPARTMENT D
WHERE DEPT_CODE = DEPT_ID
AND D.DEPT_TITLE != '총무부';

SELECT EMP_NAME , SALARY, HIRE_DATE
FROM EMPLOYEE E
JOIN DEPARTMENT D ON (DEPT_CODE = DEPT_ID AND D.DEPT_TITLE != '총무부');
-- 3. 보너스를 받는 사원들의 사번, 사원명, 보너스, 부서명 조회
SELECT EMP_ID, EMP_NAME, BONUS, DEPT_TITLE
FROM EMPLOYEE E, DEPARTMENT D
WHERE DEPT_CODE = DEPT_ID
AND BONUS IS NOT NULL;

SELECT EMP_ID, EMP_NAME, BONUS, DEPT_TITLE
FROM EMPLOYEE E
JOIN DEPARTMENT D ON (DEPT_CODE = DEPT_ID AND BONUS IS NOT NULL);
-- 4. 아래의 두 테이블을 참고해서 부서코드, 부서명, 지역코드, 지역명(LOCAL_NAME) 조회
SELECT DEPT_ID, DEPT_TITLE, LOCATION_ID , LOCAL_NAME
FROM DEPARTMENT D, LOCATION L
WHERE LOCATION_ID = LOCAL_CODE;

SELECT DEPT_ID, DEPT_TITLE, LOCATION_ID , LOCAL_NAME
FROM DEPARTMENT
JOIN LOCATION ON LOCATION_ID = LOCAL_CODE;



/*
    2, 포괄조인 / 외부조인(OUTER JOIN)
     - 테이블간의 JOIN시 "일치하지 않는 행도" 포함시켜 조회하는 기능
     단, 반드시 LEFT/RIGHT를 지정해줘야 한다
*/
-- 전체 사원의 이름, 급여, 부서명 조회
-- ANSI 구문
SELECT EMP_NAME, SALARY, DEPT_TITLE
FROM EMPLOYEE
LEFT /* OUTER */ JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);
-- EMPLOYEE테이블을 기준으로 조회하여, 조인조건과 일치하는 경우,
-- 일치하지 않는 경우 모두 조회되게 한다

-- 오라클 전용구문
SELECT EMP_NAME , SALARY , DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID(+); -- LEFT OUTER

-- 기준으로 삼을 테이블의 반대 테이블의 컬럼명에 (+)를 붙여준다.

-- 2) RIGHT OUTER JOIN
-- ANSI 구문
SELECT EMP_NAME, SALARY, DEPT_TITLE
FROM EMPLOYEE
RIGHT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);

-- 오라클 전용구문
SELECT EMP_NAME , SALARY , DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE(+) = DEPT_ID; -- RIGHT OUTER

-- 3) FULL OUTER JOIN
-- 두 테이블이 가진 모든행을 조회하는 조인문
-- ORACLE 문법에는 존재하지 않고 ANSI 문에서만 사용 가능
SELECT EMP_NAME, SALARY, DEPT_TITLE
FROM EMPLOYEE
FULL JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);

/*
    3. 카테시안의 곱 / 교차조인
     - 모든 테이블의 각 행들이 서로 매핑된 데이터를 반환한다(곱집합)
     - 즉, 두 테이블의 행들이 모두 곱해진 행들의 조합이 출력
*/
-- 사원명, 부서명
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT;
-- ==
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE
CROSS JOIN DEPARTMENT;

/*
    4. 비등가 조인(NON EQUAL JOIN)
     - '='를 사용하지 않는 모든 조인문
*/
-- 사원명, 급여, 급여등급 조회
SELECT EMP_NAME, SALARY , S.SAL_LEVEL
FROM EMPLOYEE, SAL_GRADE S
-- WHERE SALARY >= MIN_SAL AND SALARY <= MAX_SAL;
WHERE SALARY BETWEEN MIN_SAL AND MAX_SAL;

-- ANSI
SELECT EMP_NAME , SALARY , S.SAL_LEVEL
FROM EMPLOYEE
JOIN SAL_GRADE S ON (SALARY BETWEEN MIN_SAL AND MAX_SAL);

/*
    5. SELF JOIN(자체조인)
     - 같은 테이블끼리의 조인 ( A JOIN A )
     - 자체조인을 사용할 경우 각 테이블에 "반드시" 별칭을 부여해야 한다.
     - 계층적인 구조의 데이터를 다룰 때 주로 사용된다.
     
     계층적인 데이터?
      - 부장 팀장 과장 대리처럼 계급(계층)이 있는 데이터
*/
-- 각 사원의 사번, 사원명, 사수의 사번, 사수명
-- 오라클 구문
SELECT E.EMP_ID, E.EMP_NAME, M.EMP_ID, M.EMP_NAME
FROM EMPLOYEE E , EMPLOYEE M
WHERE E.MANAGER_ID = M.EMP_ID;

-- ANSI 구문
SELECT E.EMP_ID, E.EMP_NAME, M.EMP_ID, M.EMP_NAME
FROM EMPLOYEE E 
JOIN EMPLOYEE M ON ( E.MANAGER_ID = M.EMP_ID );

/*
    <다중 JOIN>
     - 3개 이상의 테이블을 조인하는 조인문 
*/
-- 사번, 사원명, 부서명, 직급명
SELECT EMP_ID, EMP_NAME, DEPT_NAME, JOB_NAME
FROM EMPLOYEE E , DEPARTMENT, JOB J
WHERE E.DEPT_CODE = DEPT_ID(+) AND
 E.JOB_CODE = J.JOB_CODE;
 
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME
FROM EMPLOYEE E
LEFT JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE);