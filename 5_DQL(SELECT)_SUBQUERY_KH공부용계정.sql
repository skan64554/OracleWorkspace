/*
    <SUBQUERY>
     - 하나의 주된 SQL안에 포함된 또 다른 SELECT문
     - 메인 SQL문을 보조하기 위해 사용
     - SELECT, FROM, WHERE때 위치에 따라 다양하게 활용되며, 부르는 명칭이 다르다
     - SELECT절에서 사용되는 서브쿼리 -> 스칼라 서브쿼리
     - FROM절에서 사용되는 서브쿼리 => 인라인 뷰
     - WHERE, HAVING절 등에서 사용되는 서브쿼리 ->프레디게이트 서브쿼리
*/
-- 노옹철 사원과 같은 부서인 사원들 조회
SELECT EMP_NAME
FROM EMPLOYEE
WHERE DEPT_CODE = (SELECT DEPT_CODE FROM EMPLOYEE WHERE EMP_NAME = '노옹철');

-- 전체사원의 평균 급여보다 더 많은 급여를 받고 있는 사원들의 사번, 이름, 직급코드 조회
SELECT EMP_ID, EMP_NAME, JOB_CODE
FROM EMPLOYEE
WHERE SALARY > (SELECT AVG(SALARY) FROM EMPLOYEE);

/*
    서브쿼리의 구분
     - 서브쿼리를 실행한 결과값이 몇 행 몇 열 이냐에 따라서 분류한다.
     
     - 단일행 서브쿼리 : 서브쿼리를 수행한 결과값이 오직 1개일 때 
     - 다중행 서브쿼리 : 서브쿼리를 수행한 결과값이 여러 행인 경우
     - 다중열 서브쿼리 : 서브쿼리를 수행한 결과값이 여러 열인 경우
     - 다중행 다중열 서브쿼리 : 서브쿼리 수행한 결과가 여러행 여러열인 경우
*/

/*
    1. 단일행 (단일열) 서브쿼리(SINGLE ROW SUBQUERY)
     - 일반 연산자를 사용할 수 있다. ( = , != , > , < ... )   
*/
-- 전 직원의 평균 급여보다 더 적게 받는 사원들의 사원명, 직급코드, 급여를 조회
SELECT EMP_NAME , JOB_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY < (SELECT AVG(SALARY) FROM EMPLOYEE);

-- 노옹철 사원의 급여보다 더 많이 받는 사원들의 사번, 이름, 부서명, 급여 조회
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
WHERE SALARY > (SELECT SALARY FROM EMPLOYEE WHERE EMP_NAME ='노옹철');

-- 부서별 급여 합이 가장 큰 부서 하나만의 조회. 부서코드, 부서명, 급여 합 출력
SELECT MAX(SUM(SALARY))
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
GROUP BY DEPT_CODE, DEPT_TITLE
HAVING SUM(SALARY) = (SELECT MAX(SUM(SALARY))
FROM EMPLOYEE
GROUP BY DEPT_CODE);

/*
    2. 다중행 서브쿼리 (MULTIROW SUBQUERY)
     - 서브쿼리 조회 결과값이 여러 행인 경우
     
     - IN (서브쿼리) : 여러 개의 결과값 중 하나라도 일치하는 것이 있다면 참 반환
     - 칼럼 [>/<] ANY (서브쿼리) : 여러 개의 결과값 중 "하나라도" 크거나 작을 경우 참 반환
     - 칼럼 [>/<] ALL (서브쿼리) : 여러 개의 결과값의 "모든"값보다 크거나 작을 경우 참 반환
     - EXISTS (서브쿼리) : 서브쿼리로 반환되는 행이 하나라도 존재하는 경우 참을 반환
     
*/
-- 1) 각 부서별 최고 급여를 받는 사원의 이름, 직급코드, 급여 조회
SELECT EMP_NAME , JOB_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY IN ( SELECT MAX(SALARY) FROM EMPLOYEE GROUP BY DEPT_CODE );

-- 2) ANY
-- 대리직급임에도 불구하고 과장 직급의 급여보다 많이 받는 사원들 조회 (사번, 이름, 직급명, 급여)
SELECT SALARY, JOB_NAME
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE = J.JOB_CODE
AND JOB_NAME IN ('과장','대리');

SELECT EMP_ID , EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE SALARY > ANY (SELECT SALARY
        FROM EMPLOYEE E, JOB J
        WHERE E.JOB_CODE = J.JOB_CODE
        AND JOB_NAME IN ('과장'))
AND JOB_NAME = '대리';

-- 과장 직급임에도, 모든 차장직급의 급여보다 더 많이 받는 직원 조회
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '과장' AND SALARY > ALL (
    SELECT SALARY
    FROM EMPLOYEE
    JOIN JOB USING(JOB_CODE)
    WHERE JOB_NAME = '차장'
);

-- EXISTS(서브쿼리)
-- 사수가 존재하는 사원의 사번, 사원명, 사수번호
SELECT EMP_ID, EMP_NAME, MANAGER_ID
FROM EMPLOYEE E1 
-- 연관쿼리(외부 SQL문의 칼럼값을 참조하여 사용하는 서브쿼리)
WHERE EXISTS(
    SELECT 1
    FROM EMPLOYEE E2
    WHERE E1.EMP_ID = E2.EMP_ID 
    AND E2.MANAGER_ID IS NOT NULL);

/*
    3. (단일행) 다중열 서브쿼리
     - 서브쿼리 조회결과가 한 행이지만, 컬럼의 갯수가 2개 이상인 경우
*/
-- 하이유 사원과 같은 부서코드, 같은 직급코드에 해당하는 사원들 정보를 조회
-- (사원명, 부서코드, 직급코드, 고용일)

-- 다중열 서브쿼리(비교할 값의 순서를 맞춰줘야한다)
-- (비교대상칼럼1, 비교대상칼럼2) = (비교할값1, 비교할값2)
SELECT EMP_NAME, DEPT_CODE, JOB_CODE, HIRE_DATE
FROM EMPLOYEE
WHERE (DEPT_CODE , JOB_CODE) = (
    SELECT DEPT_CODE , JOB_CODE FROM EMPLOYEE WHERE EMP_NAME = '하이유'
);

/*
    4. 다중행 다중열 서브쿼리
     - 서브쿼리 조회 결과가 여러 행 여러 컬럼인 경우
*/

-- 각 직급별 최소 급여를 받는 사원들의 사번, 이름, 직급코드, 급여를 조회
SELECT JOB_CODE, MIN(SALARY)
FROM EMPLOYEE
GROUP BY JOB_CODE;

SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE (JOB_CODE, SALARY) IN (SELECT JOB_CODE, MIN(SALARY)
                             FROM EMPLOYEE
                             GROUP BY JOB_CODE);
-- 각 부서별 최고급여를 받는 사원들의 사번, 이름, 부서코드, 급여를 조회
-- 소속된 부서가 없는 경우 NULL처리 함수를 통해 부서없음으로 조회하시오.

SELECT EMP_ID, EMP_NAME, NVL(DEPT_CODE,'부서없음') 부서코드 , SALARY
FROM EMPLOYEE
WHERE (NVL(DEPT_CODE,'부서없음') , SALARY) IN( 
SELECT NVL(DEPT_CODE,'부서없음'),MAX(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE);

------------------------------------------------------------------
/*
    5. 스칼라 서브쿼리
     - 단일행 단일열 서브쿼리의 일종으로 SELECT절에서 사용되는 서브쿼리를 의미한다.
       SELECT절이 실행될 때마다 서브쿼리문이 실행되면서 조회결과값을 반환한다.
     - 현재 조회된 행의 칼럼값을 서브쿼리내에서 기술이 가능하며, 기술하는 경우
       연관쿼리라고 부른다
     - 매 행마다 실행되기 때문에 대규모 데이터 처리서 효율이 좋지 못하다(연관쿼리)
*/
-- 직원번호, 직원이름, 부서명조회 (단, JOIN 없이)
SELECT EMP_ID, EMP_NAME, 
(SELECT DEPT_TITLE FROM DEPARTMENT WHERE E.DEPT_CODE = DEPT_ID) DEPT_TITLE
FROM EMPLOYEE E;

-- LOCATAION 테이블에서 지역코드와 스칼라 서브쿼리를 이용하여 국가명 조회
SELECT LOCAL_CODE ,
(SELECT NATIONAL_NAME FROM NATION 
WHERE L.NATIONAL_CODE = NATIONAL_CODE )
FROM LOCATION L;

/*
    6. 인라인 뷰(INLINE VIEW)
     - FROM절에서 사용하는 서브쿼리
     - 서브쿼리를 수행한 결과값(RESULT SET)을 테이블 대신 사용한다
*/
-- 보너스 포함 연봉이 3000만원 이상인 사원들의 사번, 이름, 보너스포함연봉, 부서코드 조회
SELECT EMP_ID, EMP_NAME, (SALARY + SALARY * NVL(BONUS,0))*12 "보너스포함연봉",
DEPT_CODE
FROM EMPLOYEE
WHERE (SALARY + SALARY * NVL(BONUS,0)) * 12 >= 30000000
;
SELECT EMP_ID , EMP_NAME , 보너스포함연봉
FROM(
SELECT EMP_ID, EMP_NAME, (SALARY + SALARY * NVL(BONUS,0))*12 "보너스포함연봉"
FROM EMPLOYEE
)
WHERE 보너스포함연봉 >= 30000000;
-- 인라인 뷰를 주로 사용하는 예시
-- TOP-N분석
-- 데이터베이스 자료 중 최상위 N개의 자료를 보기 위해 사용

-- 전 직원 중 급여가 가장 높은 상위 5명 조회(순위,사원명,급여)
-- *ROWNUM : 오라클에서 제공해주는 칼럼. 조회된 순서대로 1부터 겹치지 않는 순번을 부여하는 칼럼
SELECT ROWNUM, EMP_NAME, SALARY
FROM EMPLOYEE
WHERE ROWNUM <= 5
ORDER BY SALARY DESC;

-- 해결방법 : 먼저 ORDER BY로 정렬을 시킨 테이블을 가지고 ROWNUM을 부여하기
SELECT ROWNUM, EMP_NAME, SALARY
FROM (
    SELECT *
    FROM EMPLOYEE
    ORDER BY SALARY DESC
)
WHERE ROWNUM <= 5;

-- 월급 5위부터 10위까지 구하기
SELECT R, EMP_NAME, SALARY
FROM (SELECT ROWNUM AS R, EMP_NAME, SALARY
FROM (
    SELECT *
    FROM EMPLOYEE
    ORDER BY SALARY DESC
) 
)
WHERE R >= 5 AND R <= 10;

-- 가장 최근에 입사한 사원 5명을 조회.(사원명,급여,입사일)
SELECT EMP_NAME, SALARY, HIRE_DATE
FROM(
    SELECT *
    FROM EMPLOYEE
    ORDER BY HIRE_DATE DESC
)
WHERE ROWNUM <= 5;

-- WITH절
-- 서브쿼리의 결과를 미리 정의하여 재사용할 수 있는 문법
-- WITH 임시테이블명 AS (서브쿼리)
WITH EMP_HIRE AS(
    SELECT EMP_NAME, SALARY, HIRE_DATE
    FROM EMPLOYEE
    ORDER BY HIRE_DATE DESC
)
SELECT *
FROM EMP_HIRE
WHERE ROWNUM <= 5;