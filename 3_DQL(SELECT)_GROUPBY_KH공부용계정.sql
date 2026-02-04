/*
    <GROUP BY 절>
     - 그룹을 묶어줄 기준을 제시할 수 있는 구문
     - 제시된 기준별로 그룹을 묶을 수 있다.
     - 여러 개의 값들을 하나의 그룹으로 묶어서 처리할 목적으로 사용한다.
     
     [표현법]
     GROUP BY 칼럼
*/
-- 각 부서별 총 급여의 합
SELECT DEPT_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE;

-- 'D1' 부서의 총 급여의 합
SELECT SUM(SALARY)
FROM EMPLOYEE
WHERE DEPT_CODE = 'D1';

-- 각 부서별 사원의 수
SELECT COUNT(*), DEPT_CODE
FROM EMPLOYEE
GROUP BY DEPT_CODE;

-- 각 부서별 총 급여의 합을 내림차순으로 정렬 후 조회
SELECT DEPT_CODE, SUM(SALARY) --4
FROM EMPLOYEE -- 1
-- WHERE 1=1 -- 2
GROUP BY DEPT_CODE -- 3
ORDER BY SUM(SALARY)DESC; --5

-- 성별별 사원의 수 구하기.
SELECT DECODE(SUBSTR(EMP_NO,8,1),'1','남','3','남','여') , COUNT(EMP_NAME)
FROM EMPLOYEE
GROUP BY DECODE(SUBSTR(EMP_NO,8,1),'1','남','3','남','여');

-- 부서별 사수가 존재하는 사원의 수 구하기
-- 부서내 모든 사람이 사수가 없다면 0을 출력
SELECT COUNT(MANAGER_ID)
FROM EMPLOYEE
--WHERE MANAGER_ID IS NOT NULL;
GROUP BY DEPT_CODE;

-- 부서 별 월급이 200만원 이하인 사원의 수
-- 부서 별 월급 200만원 이하인 부서가 없으면 0
SELECT DEPT_CODE, COUNT( CASE WHEN SALARY <= 2000000 THEN 1 ELSE NULL END)
FROM EMPLOYEE
--WHERE SALARY <= 2000000
GROUP BY DEPT_CODE;

-- 각 부서별 평균 급여가 300만원 이상인 부서들만 조회
SELECT DEPT_CODE, ROUND(AVG(SALARY)) 평균급여
FROM EMPLOYEE
-- WHERE ROUND (AVG(SALARY)) >= 3000000 문법상 그룹함수를 WHERE절에서 사용 불가능
GROUP BY DEPT_CODE;

/*
    <HAVING 절>
     - 그룹에 대한 조건을 제시하고자 할 때 사용되는 구문
     - 항상 GROUP BY 절과 함께 사용되며, 주로 그룹함수를 조건으로 제시한다
*/
SELECT DEPT_CODE, ROUND(AVG(SALARY)) 평균급여
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING AVG(SALARY) >= 3000000;

-- 각 직급별 총 급여합이 1000만원 이상인 직급의 직급코드, 급여합을 조회
SELECT JOB_CODE , SUM(SALARY) 급여합
FROM EMPLOYEE 
GROUP BY JOB_CODE
HAVING SUM(SALARY) >= 10000000;

/*
    <SELECT 문 구조 및 실행순서>
    5. SELECT 조회할 칼럼
    1. FROM 조회할 테이블
    2. WHERE 조건식
    3. GROUP BY 그룹에 해당하는 칼럼
    4. HAVING 그룹에 대한 조건식
    6. ORDER BY 정렬기준
    
    순서 : FROM - WHERE - GROUP - HAVING - SELECT - ORDER
*/
---------------------------------------------------------
/*
    <집합 연산자 SET OPERATOR>
     - 여러 개의 쿼리문을 실행하여 하나의 RESULTSET을 만드는 연산자
     
     1. UNION(합집합) : 두 쿼리문을 수행한 결과값을 더한 후 중복되는 부분은 제거한 결과 반환
     2. UNION ALL : UNION 집합결과에서 중복값을 제거하지 않은 결과 반환
     3. INTERSECT(교집합) : 두 쿼리문의 수행 결과값의 중복된 부분 반환
     4. MINUS(차집합) : 선행쿼리문의 결과에서 후행쿼리문의 결과를 뺀 나머지 값
*/
-- 1. UNION(합집합)
--  부서코드가 D5이거나 또는 급여가 300만원을 초과하는 사원들의 사번, 사원명, 부서코드, 급여조회
SELECT EMP_ID , EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5';

SELECT EMP_ID , EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY >= 3000000;

SELECT EMP_ID , EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'
UNION
SELECT EMP_ID , EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY >= 3000000;

-- 직급코드가 J6이거나 부서코드가 D1인 사원들을 조회(UNION활용)
SELECT JOB_CODE , DEPT_CODE
FROM EMPLOYEE
WHERE JOB_CODE = 'J6'
UNION
SELECT JOB_CODE , DEPT_CODE
FROM EMPLOYEE
WHERE DEPT_CODE = 'D1';

-- 2. UNION ALL : UNION처럼 여러 개의 쿼리의 결과를 하나로 합쳐 반환하는 연산자로,
-- UNION과는 달리 중복값을 제거하지 않는다

-- 직급코드가 J6이거나 부서가 코드가 D1인 사원들의 (사번,사원명,부서코드,직급코드) 조회
SELECT EMP_ID, EMP_NAME, JOB_CODE , DEPT_CODE
FROM EMPLOYEE
WHERE JOB_CODE = 'J6'
UNION ALL
SELECT EMP_ID, EMP_NAME, JOB_CODE , DEPT_CODE
FROM EMPLOYEE
WHERE DEPT_CODE = 'D1';


