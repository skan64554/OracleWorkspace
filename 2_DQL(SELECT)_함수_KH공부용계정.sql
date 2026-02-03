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