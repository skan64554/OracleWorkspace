/*
    <함수 FUNCTION>
     - 매개변수로 전달된 값들을 읽어 계산한 결과를 반환한다
    
     - 단일행 함수 : 
             N개의 값을 읽어서 N개의 결과를 리턴하는 함수.(매행마다 함수 실행후 결과 반환)
     - 그룹 함수 :
             N개의 값을 읽어서 M개의 결과를 리턴하는 함수.(그룹별 함수 실행후 결과 반환)
    
    단일행 함수와 그룹 함수는 함께 사용할 수 없음
     - 결과 행의 갯수가 다르기 때문에 함께 사용 불가.
*/

------- 단일행 함수 -------
/*
    <문자열과 관련된 함수>
    LENGTH / LENGTHB
     - 전달된 문자열의 글자 수를 반환하는 메서드
     - 결과값은 숫자형식으로 반환된다
*/
SELECT LENGTH('오라클!'), LENGTHB('오라클!')
FROM DUAL;
-- DUAL : 가상 테이블 , 산술연산이나 가상 칼럼값등을 출력하고자 할 때 사용
-- LENGTHB : 한글 3byte , 영어 숫자 특수문자 1byte

SELECT EMAIL, LENGTH(EMAIL), LENGTHB(EMAIL) 
FROM EMPLOYEE;

/*
    INSTR
     - 문자열로부터 특정 문자의 위치값 반환
     - INSTR(문자열, 찾을문자, 찾을 위치의 시작값, 순번)
*/
SELECT INSTR('AABAACAABBAA','B') 
FROM DUAL;
-- INSTR은 인덱스가 1부터임

SELECT INSTR('AABAACAABBAA','B', -1 , 2) 
FROM DUAL;
-- 음수 제시시 우측에서부터 문자를 찾고 2번째 위치의 B값을 세서 반환

SELECT INSTR('AABAACAABBAA','B', -1 , 0) 
FROM DUAL; -- 범위를 벗어난 경우 에러 발생

-- EMAIL에서 각 사원의 @의 위치를 찾으려면?
SELECT INSTR(EMAIL , '@') AS "@위치"
FROM EMPLOYEE;

/*
    SUBSTR
     - 문자열에서 특정 문자열을 추출하는 함수
     - SUBSTR(문자열, 시작위치, 추출할 갯수)
     - 추출할 갯수 생략시 시작위치에서부터 끝까지 모두 출력한다
     - 시작위치는 음수로 제시가능하며, 음수로 제시시 뒤에서부터 N번째 위치에서부터 시작함을 의미
*/
SELECT SUBSTR('SHOWMETHEMONEY',7)
FROM DUAL;

SELECT SUBSTR('SHOWMETHEMONEY',7 , 3)
FROM DUAL;
 
SELECT SUBSTR('SHOWMETHEMONEY',-8 , 3)
FROM DUAL;

SELECT SUBSTR('SHOWMETHEMONEY',-8)
FROM DUAL;

-- 주민등록번호에서 성별 부분을 추출해서 남자/여자를 체크
SELECT EMP_NAME , SUBSTR(EMP_NO,8,1) AS 성별 
FROM EMPLOYEE;

/*
    <LPAD / RPAD>
     - LPAD/RPAD(문자열, 최종적으로 반환할 길이, 덧붙일 문자열)
     - 제시한 문자열에 덧붙이고자 하는 문자를 왼쪽/오른쪽에 덧붙여서
     최종반환할 길이만큼의 문자열로 변환 후 반환
     - 3번째 매개변수를 제외하면 공백으로 추가
*/
SELECT EMAIL, LENGTH(EMAIL), LPAD(EMAIL, 16)
FROM EMPLOYEE;

-- 주민등록번호 조회 : 610101-1******
SELECT EMP_NAME, EMP_NO, RPAD(SUBSTR(EMP_NO,1,8), 14,'*') 
FROM EMPLOYEE;

/*
    LTRIM/RTRIM
     - LTRIM/RTRIM(문자열, 제거할문자)
     - 문자열기준 왼쪽/오른쪽에서 부터 제거시키고자 하는 문자들을 찾아서 
     제거한 나머지를 반환
     - 제거할 문자 생략시 기본값은 ' '.
*/
SELECT LTRIM('    K    H    ') AS 왼쪽공백제거
FROM DUAL;

SELECT LTRIM('0000123040560000','0')
FROM DUAL;

SELECT RTRIM('0000123040560000','0')
FROM DUAL;

SELECT LTRIM('123123KH123','123')
FROM DUAL;

SELECT LTRIM('1313KH123','123')
FROM DUAL;

/*
    TRIM
    - TRIM(BOTH(디폴트)/LEADING/TRAILING '제거할문자' FROM '문자열')
    - 옵션과 제거할 문자 생략시 기본값으로 BOTH, ' ' 이 선택된다.
*/
SELECT TRIM('    K     H      ')
FROM DUAL;

-- BOTH 기본값 탑재
SELECT TRIM('Z' FROM 'ZZZKHZZZ')
FROM DUAL;

SELECT TRIM(LEADING 'Z' FROM 'ZZZKHZZZ')
FROM DUAL;

SELECT TRIM(TRAILING 'Z' FROM 'ZZZKHZZZ')
FROM DUAL;

/*
    LOWER/UPPER/INITCAP 
*/
SELECT LOWER('Welcome to G class'),
       UPPER('Welcome to G class'),
       INITCAP('Welcome to G class')
FROM DUAL;

/*
    CONCAT
     - CONCAT(문자열1, 문자열2)
     - 전달된 두 문자열을 하나로 합쳐서 반환
*/
SELECT CONCAT('가나다','ABC')
FROM DUAL;

-- 오라클 한정
SELECT '가나다' || 'ABC'
FROM DUAL;

SELECT '가나다' || 'ABC' || '123'
FROM DUAL;

SELECT CONCAT(CONCAT('가나다','ABC'),'123')
FROM DUAL;

/*
    REPLACE
     - REPLACE(문자열, 찾을 문자, 바꿀 문자)
     - 문자열로부터 찾을 문자를 찾아서 바꿀 문자로 바꾼 문자열을 반환
*/
SELECT REPLACE('서울시 강남구 역삼동','역삼동','신목동')
FROM DUAL;
---------------------------------------------------
/*
    <숫자와 관련된 함수>
    ABS
     - ABS(절대값을 구할 숫자) : 절대값을 구하는 함수
*/
SELECT ABS(-10)
FROM DUAL;

/*
    MOD
     - MOD(숫자, 나눌값) : 두 수를 나눈 "나머지"값을 반환
*/
SELECT MOD(10,3)
FROM DUAL;

SELECT MOD(-10,3)
FROM DUAL;

SELECT MOD(10.9,3)
FROM DUAL;

/*
    ROUND
     - ROUND(숫자, 반올림할 위치)
     - 반올림할 위치 : 소숫점 기준 N번째 수에서 반올림 처리해주며 생략가능
                     생략시 소숫점을 모두 없애버린다.
*/
SELECT ROUND(123.456 , 0) 
FROM DUAL; -- 0은 기본값

SELECT ROUND(123.456 , 1)
FROM DUAL;

SELECT ROUND(123.456 , -1)
FROM DUAL;

/*
    CEIL
     - 올림처리 메서드
*/
SELECT CEIL(123.156 * 10) / 10
FROM DUAL;

/*
    FLOOR
     - 내림처리 메서드
*/
SELECT FLOOR(123.999)
FROM DUAL;

SELECT EMP_NAME , FLOOR(SYSDATE - HIRE_DATE) AS 근무일수
FROM EMPLOYEE;
/*
    TRUNC
     - TRUNC(버림처리할 숫자, 위치값)
     - 위치지정이 가능한 버림처리 함수
*/
SELECT TRUNC(123.789)
FROM DUAL;

SELECT FLOOR(123.789)
FROM DUAL;

SELECT TRUNC(123.789, 0)
FROM DUAL; -- 123

SELECT TRUNC(123.789 , -1)
FROM DUAL;

-------------------------------------------------------------
/*
    <날짜 관련 함수>
    DATE타입 : 년,월,일,시,분,초를 포함한 자료형
*/
SELECT SYSDATE FROM DUAL;

-- 1. MONTHS_BETWEEN (DATE1, DATE2)
-- 두 날짜 사이의 개월수를 반환하는 함수
-- DATE1이 DATE2보다 더 미래의 값이어야 한다.
SELECT EMP_NAME , FLOOR(SYSDATE - HIRE_DATE) "근무일수"
, FLOOR(MONTHS_BETWEEN(SYSDATE, HIRE_DATE)) "근무개월수"
FROM EMPLOYEE;

-- 2. ADD_MONTHS(DATE, NUMBER)
-- 특정 날짜에 해당 숫자만큼의 개월수를 더한 날짜를 반환
SELECT ADD_MONTHS(SYSDATE, 5)
FROM DUAL;

-- 3. NEXT_DAY(DATE, 요일(문자/숫자))
-- 특정 날짜에서 가장 가까운 요일을 찾아 그 날짜를 반환
-- 1일요일, 7 토요일
SELECT NEXT_DAY(SYSDATE, 3)
FROM DUAL;

-- 한글도 되지만 숫자 권장
SELECT NEXT_DAY(SYSDATE, '토')
FROM DUAL;

-- 언어설정변경
-- ALTER SESSION SET NLS_LANGUAGE = KOREAN; --AMERICAN

-- 4. LAST_DAY(DATE)
-- 해당 특정날짜 달의 마지막 날짜를 구해서 반환
SELECT LAST_DAY(SYSDATE)
FROM DUAL;

/*
    5. EXTRACT
     - DATE에서 년도, 월 또는 일을 추출해서 반환하는 함수
     - EXTRACT(YEAR FROM 날짜) : 년도만 추출
     - EXTRACT(MONTH FROM 날짜) : 월만 추출
     - EXTRACT(DAY FROM 날짜) : 일만 추출
*/
SELECT EXTRACT(YEAR FROM SYSDATE)
      ,EXTRACT(MONTH FROM SYSDATE)
      ,EXTRACT(DAY FROM SYSDATE)
FROM DUAL;
-----------------------------------------------------------
/*
    <형변환 함수>
    NUMBER/DATE => CHARACTER
    
    TO_CHAR(NUMBER/DATE , 포맷)
     - 숫자형 또는 날짜형 데이터를 문자형타입으로 반환(포맷에 맞춰서)
*/

-- 숫자를 문자로 1234 -> '1234'
SELECT TO_CHAR(1234)
FROM DUAL;

SELECT TO_CHAR(1234,'00000')
FROM DUAL; -- 빈칸을 0으로 채움

SELECT TO_CHAR(1234,'99999')
FROM DUAL; -- 빈칸을 ' '으로 채움

SELECT TO_CHAR(1234,'00000')
FROM DUAL;

SELECT TO_CHAR(1234,'L99999')
FROM DUAL; -- L : Local 통화 기호

SELECT TO_CHAR(1234,'99,999')
FROM DUAL; -- 세 자리마다 ','

-- 날짜를 문자열로 변경
SELECT SYSDATE FROM DUAL;

SELECT TO_CHAR(SYSDATE)
FROM DUAL;

SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD')
FROM DUAL;

-- 시 분 초
SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD')
FROM DUAL;

-- 요일
SELECT TO_CHAR(SYSDATE,'MON DY DAY')
FROM DUAL; -- 2월 수 수요일

-- 년도로써 사용할 수 있는 포맷
SELECT TO_CHAR(SYSDATE,'YYYY'),
       TO_CHAR(SYSDATE,'RRRR'),
       TO_CHAR(SYSDATE,'YY'),
       TO_CHAR(SYSDATE,'RR'),
       TO_CHAR(SYSDATE,'YEAR')
FROM DUAL;

/*
    YY와 RR의 차이점
     - R의 뜻은 ROUND(반올림)
     -- YY : 앞자리에 무조건 20이 붙는다
     -- RR : 50년을 기준으로 현재년도가 50보다 낮으면 앞자리에 20이 붙고,
             더 크면 19가 붙는다
*/

-- 월로 사용 가능한 포맷
SELECT 
    TO_CHAR(SYSDATE, 'MM'),
    TO_CHAR(SYSDATE, 'MON'),
    TO_CHAR(SYSDATE, 'MONTH'),
    TO_CHAR(SYSDATE, 'RM'),
    TO_CHAR(SYSDATE, 'DAY')
FROM DUAL;

-- 일로써 사용 가능한 포맷
SELECT
    TO_CHAR(SYSDATE, 'D'),
    TO_CHAR(SYSDATE, 'DD'),
    TO_CHAR(SYSDATE, 'DDD')
FROM DUAL;
-- D : 1주일 기준 현재 요일
-- DD : 월 기준 현재 요일
-- DDD : 년 기준 현재 요일

/*
    NUMBER / CHARACTER => DATE
    - TO_DATE(NUMBER/CHARACTER, 포맷)
*/
SELECT TO_DATE(260206)
FROM DUAL;

SELECT TO_DATE('260206')
FROM DUAL;

SELECT TO_DATE('20000229','YYYYMMDD')
FROM DUAL;

SELECT TO_DATE('041030 143021', 'YYMMDD HH24:MI:SS')
FROM DUAL;

SELECT TO_DATE('980630','RRMMDD')
FROM DUAL;

/*
    CHARACTER => NUMBER
    - TO_NUMBER(CHARACTER , 포맷)
*/
SELECT '123'+'123'
FROM DUAL; -- 자동 형변환 -> 246

SELECT '10,000' + '50,000'
FROM DUAL; -- 문자가 포함된 경우 자동 파싱 불가

SELECT TO_NUMBER('10,000','99999') + TO_NUMBER('50,000','99999')
FROM DUAL; -- -> 60000

SELECT TO_NUMBER('0123')
FROM DUAL;

--------------------------------------------------------------------
/*
    <NULL처리 함수>
    - NVL(컬럼명, 해당칼럼이 NULL일 경우 반환할 값)
    - NVL은 컬럼에 값이 존재하는 경우 컬럼값을, 존재하지 않는 경우 대체값을 반환
*/
-- 사원명, 보너스, 보너스가 없는 경우 0으로 출력
SELECT EMP_NAME, BONUS
       ,NVL(BONUS, 0)
FROM EMPLOYEE;

-- 보너스 포함 연봉 조회
SELECT EMP_NAME, (SALARY + SALARY *NVL(BONUS,0)) * 12 "연봉"
FROM EMPLOYEE;

-- NVL2(컬럼명 , 결과값1, 결과값2)
-- 해당 칼럼에 값이 존재할 경우(NULL이 아닐경우) 결과값1 반환
-- 컬럼값이 NULL일 경우 결과값2 반환
-- NVL(BONUS , 0) == NVL2(BONUS , BONUS , 0)

-- 사원의 이름과, 보너스, 보너스가 있는 사원은 '보너스 있음', 없는 사원은 '보너스 없음' 조회
SELECT EMP_NAME, BONUS, NVL2(BONUS, '보너스 있음' , '보너스 없음') 보너스유무
FROM EMPLOYEE;

-- NULLIF(비교대상1, 비교대상2)
-- 두 값이 동일한 경우 NULL 반환
-- 두 값이 동일하지 않은 경우 비교대상1 반환
SELECT NULLIF('123','123')
FROM DUAL;

SELECT NULLIF('123','456')
FROM DUAL;

-- 선택함수 : DECODE (자바의 SWITCH문과 유사)
-- 선택함수의 친구 : CASE WITH THEN 구문 => IF/SWITCH문과 유사
/*
    <선택함수>
    - DEOCDE(칼럼, 값1, 결과값1, 값2, 결과값2, 값3, 결과값3, ... , 결과값)
    - SWITCH문과 유사
    switch(비교대상칼럼){
    case 값1 -> 결과값1;
    case 값2 -> 결과값2;
    ...
    default -> 결과값
    }
*/
-- 사번, 사원명, 주민등록번호, 성별
SELECT EMP_ID, EMP_NAME , EMP_NO , 
DECODE( SUBSTR(EMP_NO,8,1) , 1 ,'남자' , 2, '여자' , '3', '남자', '4', '여자', NULL ) "성별"
FROM EMPLOYEE;

/*
    CASE WHEN THEN 구문
    - DECODE는 조건검사시 동등비교만을 수행한다면, CASE WHEN THEN 구문은 내마음대로
    조건을 설정할 수 있다.
    
    [표현법]
    CASE [칼럼값] WHEN 조건식1 THEN 결과값1
                 WHEN 조건식2 THEN 결과값2
                 WHEN 조건식3 THEN 결과값3
                 ... ELSE 결과값
    END
*/
-- CASE WHEN THEN 구문으로 성별 구하기
SELECT EMP_ID, EMP_NAME, EMP_NO , 
        CASE WHEN SUBSTR(EMP_NO,8,1) IN (1,3) THEN '남자'
             WHEN SUBSTR(EMP_NO,8,1) IN (2,4) THEN '여자'
             ELSE '중성'
        END
FROM EMPLOYEE;

SELECT EMP_ID, EMP_NAME, EMP_NO , 
        CASE SUBSTR(EMP_NO,8,1) WHEN '1' THEN '남자'    
                                WHEN '2' THEN '여자'
                                WHEN '3' THEN '남자'
                                WHEN '4' THEN '여자'
                                ELSE '중성'
        END
FROM EMPLOYEE;

---------------------------------------------------------------
/* 
    그룹함수 
     - 그룹함수는 데이터들의 합, 평균 등을 구할때 사용한다.
     - N개의 값을 읽어서 그룹의 개수만큼의 결과를 반환한다.
*/
-- 1. SUM(숫자타입컬럼) : 해당 칼럼들의 총 합계를 반환해주는 함수
-- 전체 사원들의 총 급여 합
SELECT SUM(SALARY)
FROM EMPLOYEE;
-- WHERE 1 = 0 -> FALSE;
-- 조건에 맞는 값이 하나도 없는 경우 기본값 NULL

-- 남자 사원들의 총 급여 합계.
SELECT SUM(SALARY)
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO,8,1) IN (1,3);

-- 2. AVG(숫자타입컬럼)
-- 전체사원들의 평균 급여 
SELECT AVG(SALARY)
FROM EMPLOYEE;
-- WHERE 1=0 -- -> FALSE 조건에 맞는 값이 없는 경우 기본값 NULL

-- 3. COUNT(*/컬럼이름/ DISTINCT 칼럼)
-- 조회된 행의 갯수를 세서 반환하는 함수
-- COUNT(*) : 조회결과에 해당하는 모든 행의 갯수를 세서 반환
-- COUNT(칼럼) : 조회결과중 칼럼값이 NULL이 아닌 행만 세서 반환
-- COUNT(DISTINCT 칼럼) : 제시한 칼럼값에 중복이 있을 경우 1개로 세서 반환(NULL미포함)
SELECT COUNT(*)
FROM EMPLOYEE;
--WHERE 1 = 0 -- FALSE시 기본값 0 ( NULL X )

-- 부서배치가 완료된 사원의 수
SELECT COUNT(*)
FROM EMPLOYEE
WHERE DEPT_CODE IS NOT NULL;

SELECT COUNT(DEPT_CODE)
FROM EMPLOYEE; -- 조회된 행의 값 중 NULL은 제외하고 카운트

-- 현재 사원들이 속해있는 부서의 갯수
SELECT COUNT(DISTINCT DEPT_CODE) 
FROM EMPLOYEE; 

-- 4. MAX(ANY칼럼)
-- 칼럼 중 가장 큰 값을 반환
SELECT MAX(SALARY) , MAX(EMP_NAME), MAX(EMAIL), MAX(HIRE_DATE)
FROM EMPLOYEE;

-- 5. MIN(ANY칼럼)
-- 정수기준 가장 작은값, 문자기준으로는 사전등록 순서상 가장 낮은값, 날짜기준으로는 가장 과거
SELECT MIN(SALARY), MIN(EMP_NAME) , MIN(HIRE_DATE)
FROM EMPLOYEE;

---------------------------------------------------------------------------
/*
    - 윈도우 함수 (WINDOW FUNCTION)
     - 분석함수 ,순위함수
     - SQL에서 ResultSet을 특정부분으로 분할하거나 나누는 논리적인 개념을 window
     - 즉, window를 통해 데이터를 관찰 및 분석하고 순위를 매기는 함수들이 window function
     
    1. 순위를 매기는 함수
    RANK() OVER (그룹화기준 정렬기준)
     - 공동순위가 존재하는 경우 공동순위의 다음 순위는 공동순위+공동순위의 갯수만큼 뒤로해서 부여
     - EX) 공동 1위가 3명, 다음 순위는 4위
    DENSE_RANK() OVER(그룹화기준 정렬기준)
     - 공동 1위가 3명이라 해도, 그 다음 순위는 무조건 2위로 처리하는 방식
    ROW_NUMBER() OVER(그룹화기준 정렬기준)
     - 결과값에 대해 고유한 번호를 부여하는 함수로, 공동순위가 존재하지 않는다.
    
    OVER([PARTITION BY 칼럼] ORDER BY 칼럼)
     - PARTITION : 데이터를 분할하는 행위를 의미하며, 칼럼기준으로 데이터를 분할할 수 있다.
     - 파티션으로 데이터를 분할하는 경우, 분할된 데이터 안에서 순위 매기기가 가능하다.
     - WINDOW 함수의 ORDER BY절은 SELECT절에서 작성하며, NULLS FIRST/NULLS LAST옵션은
     기술 불가능
*/
-- 사원들의 급여가 높은 순서대로 순위를 매겨서, 그 사원의 이름, 급여, 순위 조회
SELECT EMP_NAME, SALARY , RANK() OVER(ORDER BY SALARY DESC) 순위
FROM EMPLOYEE;
-- ORDER BY SALARY DESC

SELECT EMP_NAME, SALARY , DENSE_RANK() OVER(ORDER BY SALARY DESC) 순위
FROM EMPLOYEE;

SELECT EMP_NAME, SALARY , ROW_NUMBEr() OVER(ORDER BY SALARY DESC) 순위
FROM EMPLOYEE;

-- DEPT_CODE별로 데이터 분할 후, 월급 기준 내림차순 정렬 후 순위 매기기
SELECT EMP_NAME, SALARY , DEPT_CODE, 
DENSE_RANK() OVER(PARTITION BY DEPT_CODE ORDER BY SALARY DESC) 순위
FROM EMPLOYEE;

SELECT EMP_NAME, SALARY , DEPT_CODE, 
DENSE_RANK() OVER(PARTITION BY DEPT_CODE ORDER BY SALARY DESC) 순위
FROM EMPLOYEE;
-- ORDER BY EMP_ID DESC;
/*
    그룹내 행순서를 가져오는 함수
    1) LAG(LEAD AND GET)
     - 앞에서 사져오다.
     - 현재행 기준 앞 행의 값을 가져올 때 사용
     - LAG(가져올 칼럼, 가져올 행번호, 기본값) OVER(분할기준, 정렬기준)
     
    2) LEAD 
     - 나아가다
     - 현재행 기준 뒤의 값을 가져올때 사용
     - LEAD(가져올 칼럼, 행번호, 기본값) OVER(분할기준, 정렬기준)
*/
-- 조회결과내에서 월급기준 내림차순 정렬 수행후, 현재행 기준 이전 행의 월급 가져오기.
SELECT EMP_NAME, DEPT_CODE, SALARY, LAG(SALARY) OVER(ORDER BY SALARY DESC) "이전직원월급"
FROM EMPLOYEE;

SELECT EMP_NAME, DEPT_CODE, SALARY, LEAD(SALARY) OVER(ORDER BY SALARY DESC) "이전직원월급"
FROM EMPLOYEE;

SELECT EMP_NAME, DEPT_CODE, SALARY, LEAD(SALARY,2,0) OVER(ORDER BY SALARY DESC) "이전직원월급"
FROM EMPLOYEE;

-- 실습 --
-- 직원의 사원번호, 이름, 직급코드 , 월급을 조회한 후
-- 조회결과내에서 직급코드별로 그룹화 하여, 소그룹내에서 전사람의 월급을 가져오시오
-- 단 가져올 데이터가 없는 경우 0원으로 표시하며, 소그룹내에서는 사원번호 기준 오름차순 정렬
SELECT EMP_ID, EMP_NAME , JOB_CODE, SALARY ,LAG(SALARY,1,0) 
OVER(PARTITION BY JOB_CODE ORDER BY EMP_ID ASC) "정렬"
FROM EMPLOYEE;





