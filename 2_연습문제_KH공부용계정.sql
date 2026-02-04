--1. EMPLOYEE테이블에서 사원 명과 직원의 주민번호를 이용하여 생년, 생월, 생일 조회
SELECT EMP_NAME , SUBSTR(EMP_NO,1,2) 생년 , SUBSTR(EMP_NO,3,2) 생월 , SUBSTR(EMP_NO, 5, 2) 생일
FROM EMPLOYEE;

--2. EMPLOYEE테이블에서 사원명, 주민번호 조회 (단, 주민번호는 생년월일만 보이게 하고, '-'다음 값은 '*'로 바꾸기)
SELECT EMP_NAME , RPAD(SUBSTR(EMP_NO,1,7), 14,'*') 
FROM EMPLOYEE;

--3. EMPLOYEE테이블에서 사원명, 입사일-오늘, 오늘-입사일 조회
-- (단, 각 별칭은 근무일수1, 근무일수2가 되도록 하고 모두 정수(내림), 양수가 되도록 처리)
SELECT EMP_NAME , ABS(FLOOR(HIRE_DATE - SYSDATE))  "근무일수" , FLOOR(SYSDATE-HIRE_DATE) "오늘-입사일"
FROM EMPLOYEE;

--4. EMPLOYEE테이블에서 사번이 홀수인 직원들의 정보 모두 조회
SELECT *
FROM EMPLOYEE
WHERE MOD(EMP_ID,2) = 1;

--5. EMPLOYEE테이블에서 근무 년수가 20년 이상인 직원 정보 조회
SELECT * 
FROM EMPLOYEE
WHERE EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE) >= 20;
-- WHERE ADD_MONTH(HIRE_DATE , 240) <= SYSDATE;

--6. EMPLOYEE 테이블에서 사원명, 급여 조회 (단, 급여는 '\9,000,000' 형식으로 표시)
SELECT EMP_NAME , TO_CHAR(SALARY,'L999,999,999')
FROM EMPLOYEE;

--7. EMPLOYEE테이블에서 직원 명, 부서코드, 생년월일, 나이(만) 조회
-- (단, 생년월일은 주민번호에서 추출해서 00년 00월 00일로 출력되게 하며
-- 나이는 주민번호에서 출력해서 날짜데이터로 변환한 다음 계산)
SELECT EMP_NAME , DEPT_CODE, 
SUBSTR(EMP_NO,1,2) || '년 ' || SUBSTR(EMP_NO,3,2) || '월 ' || SUBSTR(EMP_NO,5,2) || '일' 생년월일 ,
EXTRACT(YEAR FROM SYSDATE) -
EXTRACT(YEAR FROM 
-- RR패턴으로 문자열형태의 데이트값을 실제 날짜형으로 반환
-- 단, 주민번호 뒷자리를 체크하여 1,2가 들어가는 경우 19,3혹은 4가 들어가는 경우 20
TO_DATE(
CASE WHEN SUBSTR(EMP_NO,8,1) IN (1,2) THEN 19 || SUBSTR(EMP_NO,1,6)
     WHEN SUBSTR(EMP_NO,8,1) IN (3,4) THEN 20 || SUBSTR(EMP_NO,1,6)
END
)
) "나이"
FROM EMPLOYEE;

--8. EMPLOYEE테이블에서 부서코드가 D5, D6, D9인 사원만 조회하되 D5면 총무부, D6면 기획부, D9면 영업부로 처리
-- (단, 부서코드 오름차순으로 정렬)
SELECT EMP_NAME,
       DECODE(DEPT_CODE ,'D6','총무부','D5','기획부','D9','영업부')
FROM EMPLOYEE
WHERE DEPT_CODE IN ('D5','D6','D9');

--9. EMPLOYEE테이블에서 사번이 201번인 사원명, 주민번호 앞자리, 주민번호 뒷자리,
-- 주민번호 앞자리와 뒷자리의 합 조회
SELECT EMP_NAME, SUBSTR(EMP_NO,1,6) "주민번호 앞자리", SUBSTR(EMP_NO,8,14) "주민번호 뒷자리"
, SUBSTR(EMP_NO,1,6) + SUBSTR(EMP_NO,8,14) "앞자리와 뒷자리의 합"
FROM EMPLOYEE;

--10. EMPLOYEE테이블에서 부서코드가 D5인 직원의 보너스 포함 연봉 합 조회
SELECT EMP_NAME , (SALARY + SALARY * NVL(BONUS,0)) * 12 "보너스 포함 연봉 합"
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5';

--11. EMPLOYEE테이블에서 직원들의 입사일로부터 년도만 가지고 각 년도별 입사 인원수 조회
--전체 직원 수, 2001년, 2002년, 2003년, 2004년
-- HIRE_DATE의 년도만 가지고
SELECT
    COUNT(*) AS "전체 직원 수",
    -- COUNT(DECODE(EXTRACT(YEAR FROM HIRE_DATE),2001,HIRE_DATE,NULL))
    SUM(CASE WHEN TO_CHAR(HIRE_DATE, 'YYYY') = '2001' THEN 1 ELSE 0 END) AS "2001년",
    SUM(CASE WHEN TO_CHAR(HIRE_DATE, 'YYYY') = '2002' THEN 1 ELSE 0 END) AS "2002년",
    SUM(CASE WHEN TO_CHAR(HIRE_DATE, 'YYYY') = '2003' THEN 1 ELSE 0 END) AS "2003년",
    SUM(CASE WHEN TO_CHAR(HIRE_DATE, 'YYYY') = '2004' THEN 1 ELSE 0 END) AS "2004년"
FROM EMPLOYEE;