/*
    <PL/SQL>
     - PROCEDURE LANGUAGE EXTENSTION TO SQL
     
     오라클 자체에 내장되어 있는 절차적 언어
     SQL문 내에서 변수선언, 조건처리(IF), 반복처리(FOR), 예외처리등을 지원한다.
     
     * PL/SQL 구조
     선언부(DECLARE SECTION)
     DECLARE
        변수선언
     실행부(EXECUTABLE SECTION)
     BEGIN
        SQL문 또는 제어문이나 반복문 사용 가능
     END
     예외처리부(EXCEPTION SECTION)
     EXCEPTION
        예외처리구문
*/
-- 콘솔창 출력옵션 ON
SET SERVEROUTPUT ON;

BEGIN 
    DBMS_OUTPUT.PUT_LINE('HELLO ORACLE');
END;
/
-- /로 PL구분 /뒤에 주석조차 쓰면 안된다
/*
    1.DECLARE 선언부
     변수 및 상수 선언 공간
     일반타입 변수, 레퍼런스 변수, ROW타입변수가 존재
     
    1) 일반타입 변수 선언 및 초기화
    변수명 [CONSTANT] 자료형 [:= 값];
*/
DECLARE 
    EID NUMBER;
    ENAME VARCHAR2(20);
    PI CONSTANT NUMBER := 3.14;
BEGIN
    EID := 800;
    -- ENAME := '크로클';
    ENAME := '&이름';
    
    DBMS_OUTPUT.PUT_LINE('EID : ' || EID);
    DBMS_OUTPUT.PUT_LINE('ENAME : ' || ENAME);
    DBMS_OUTPUT.PUT_LINE('PI : ' || PI);  
END;
/
-- 2) 레퍼런스 타입 변수 선언 및 초기화
-- 자료형을 참조할 테이블명과 컬럼명이 필요
-- 변수명 테이블명.컬럼명%TYPE;
DECLARE 
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    SAL EMPLOYEE.SALARY%TYPE;
BEGIN

    -- 사번이 200번인 사원의 사번, 사번명 월급 조회
    SELECT EMP_ID, EMP_NAME, SALARY
     INTO EID , ENAME, SAL
    FROM EMPLOYEE
    WHERE EMP_ID = 200;
    
    DBMS_OUTPUT.PUT_LINE('EID '|| EID);
    DBMS_OUTPUT.PUT_LINE('ENAME ' || ENAME);
    DBMS_OUTPUT.PUT_LINE('SAL ' || SAL);  
END;
/
---------------------------------------실습문제----------------------------------------------------
/*
    레퍼런스 타입 변수로 EID, ENAME , JCODE , SAL,  DTITLE을 선언하고
    각 자료형 EMPLYEE(EMP_ID, EMP_NAME, JOB_CODE, SALARY)
    DEPARTMENT(DEPT_TITLE)들을 참조하도록

    사용자가 입력한 사번인 사원의 사번, 사원명 ,직급코드 , 급여 ,부서명 조회후
    변수에 담아서 출력.
*/
DECLARE 
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    JCODE EMPLOYEE.JOB_CODE%TYPE;
    SAL EMPLOYEE.SALARY%TYPE;
    DTITLE DEPARTMENT.DEPT_TITLE%TYPE;
BEGIN
    SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY, DEPT_TITLE
    INTO EID , ENAME, JCODE , SAL , DTITLE
    FROM EMPLOYEE
    JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
    WHERE EMP_ID = &사번;
    
    DBMS_OUTPUT.PUT_LINE
    (EID || ',' || ENAME || ',' || JCODE || ',' || SAL || ',' || DTITLE );
END;
/
-- 3) ROW타입 변수 선언
-- 테이블 한 행에 대한 모든 컬럼값을 담을 수 있는 변수
-- 변수명 테이블명 % ROWTYPE;

DECLARE
    E EMPLOYEE % ROWTYPE;
BEGIN
    SELECT * 
      INTO E
    FROM EMPLOYEE
    WHERE EMP_ID = &사번;
    
    -- 사원명, 급여, 보너스 출력
    DBMS_OUTPUT.PUT_LINE('사원명 : ' || E.EMP_NAME);
    DBMS_OUTPUT.PUT_LINE('급여 : ' || E.SALARY);
    DBMS_OUTPUT.PUT_LINE('보너스 : ' || E.BONUS); -- 값이 없으면 빈칸으로 표시  
END;
/
----------------------------------------------
/*
    2. BEGIN 실행부
    <조건문>
    
    1) IF 조건식 THEN 실행내용
       END IF;
*/
-- 사번 입력 후, 해당 사원의 사번,이름,급여,보너스율을 출력.
-- 단, 보너스를 받지 않는 사원의 경우 '보너스를 받지 않는 사원입니다'만 출력
DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    SALARY EMPLOYEE.SALARY%TYPE;
    BONUS EMPLOYEE.BONUS%TYPE;
BEGIN
    SELECT EMP_ID, EMP_NAME, SALARY, BONUS
      INTO EID, ENAME, SALARY, BONUS
    FROM EMPLOYEE
    WHERE EMP_ID = &사번;
    
    IF BONUS IS NULL
       THEN DBMS_OUTPUT.PUT_LINE('보너스를 지급받지 않는 사원입니다.');
    END IF;
    
    IF BONUS IS NOT NULL
       THEN DBMS_OUTPUT.PUT_LINE('사번 ' || EID );
            DBMS_OUTPUT.PUT_LINE('이름 ' || ENAME);
            DBMS_OUTPUT.PUT_LINE('급여 ' || SALARY);
            DBMS_OUTPUT.PUT_LINE('보너스 ' || BONUS*100 || '%');
    END IF;
END;
/
-- 2) IF 조건식 THEN 실행내용 ELSE 실행내용 END IF; (IF - ELSE)
DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    SALARY EMPLOYEE.SALARY%TYPE;
    BONUS EMPLOYEE.BONUS%TYPE;
BEGIN
    SELECT EMP_ID, EMP_NAME, SALARY, BONUS
      INTO EID, ENAME, SALARY, BONUS
    FROM EMPLOYEE
    WHERE EMP_ID = &사번;
    
    IF BONUS IS NULL
       THEN DBMS_OUTPUT.PUT_LINE('보너스를 지급받지 않는 사원입니다.');
    ELSE DBMS_OUTPUT.PUT_LINE('사번 ' || EID );
         DBMS_OUTPUT.PUT_LINE('이름 ' || ENAME);
         DBMS_OUTPUT.PUT_LINE('급여 ' || SALARY);
         DBMS_OUTPUT.PUT_LINE('보너스 ' || BONUS*100 || '%');
    END IF;
END;
/

-- 3) IF 조건식 THEN ELSIF 조건식 THEN ELSE 실행할코드 END IF;
-- 급여가 500만원 이상이면 고급
-- 급여가 300만원 이상하면 중급
-- 그외 초급
DECLARE
    SAL NUMBER;
    GRADE VARCHAR2(10);
BEGIN
    SELECT SALARY
      INTO SAL
      FROM EMPLOYEE
    WHERE EMP_ID = &사번;
    
    IF SAL >= 5000000 THEN GRADE := '고급'; 
    ELSIF SAL >= 3000000 THEN GRADE := '중급';
    ELSE GRADE := '초급';
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('해당 사원의 급여등급은 : ' || GRADE || '입니다/');
END;
/

-- 4) CASE 비교대상 WHEN 동등비교값 THEN 결과값 WHEN 비교값 THEN 결과값 ... END
DECLARE 
    EMP EMPLOYEE%ROWTYPE;
    DNAME VARCHAR2(15);
BEGIN
    SELECT *
      INTO EMP
      FROM EMPLOYEE 
     WHERE EMP_ID = &사번;
     
     DNAME := CASE EMP.DEPT_CODE
                   WHEN 'D1' THEN '인사팀'
                   WHEN 'D2' THEN '회계팀'
                   WHEN 'D3' THEN '마케팅팀'
                   WHEN 'D9' THEN '총무팀'
                   ELSE '해외영업팀' 
     END;
     DBMS_OUTPUT.PUT_LINE(EMP.EMP_NAME || '은 ' || DNAME ||'에서 근무중');
END;
/
---------------------------------------------------------------------
/*
    반복문
    1) BASIC LOOP문
    [표현법]
    LOOP 
        반복적으로 실행할 구문
        
        * 반복문을 빠져나갈 수 있는 구문
    END LOOP;
    
    반복문을 빠져나갈 수 있는 구문 2가지
    1) IF 조건식 THEN EXIT; END IF;
    2) EXIT WHEN 조건식; 
*/
-- 1~5까지 순차적으로 I값으 증가시키는 반복문
DECLARE
    I NUMBER := 1;
BEGIN
    LOOP
        DBMS_OUTPUT.PUT_LINE('현재 I의 값 : ' || I);
        I := I + 1;
        
        EXIT WHEN I > 5;
    END LOOP;
END;
/
/*
    2) FOR LOOP문
    FOR 변수 IN [REVERSE] 초기값..최종값 OR 서브쿼리
    LOOP
        실행할구문;
    END LOOP;
*/
BEGIN
    
    FOR I IN 1..5
    LOOP
        DBMS_OUTPUT.PUT_LINE(I);
    END LOOP;
END;
/

--모든 사원의 사번, 이름, 직급명을 조회
BEGIN
    FOR EMP IN (SELECT EMP_ID,EMP_NAME,JOB_NAME FROM EMPLOYEE JOIN JOB USING(JOB_CODE))
    LOOP
        DBMS_OUTPUT.PUT_LINE(EMP.EMP_ID || ' ' || EMP.EMP_NAME || ' ' || EMP.JOB_NAME);
    END LOOP;
END;
/

-- 중첩 반복문(NESTED LOOP)
-- EMPLOYEE 테이블과 DEPARTMENT 테이블을 JOIN이 아닌 중첩반복문을 활용하여 연결
BEGIN
    FOR EMP IN (SELECT EMP_ID, DEPT_CODE FROM EMPLOYEE)
    LOOP
        FOR DEPT IN (SELECT DEPT_TITLE FROM DEPARTMENT WHERE DEPT_ID = EMP.DEPT_CODE)
        LOOP
            DBMS_OUTPUT.PUT_LINE(EMP.EMP_ID || ' ' || DEPT.DEPT_TITLE);
        END LOOP;
    END LOOP;
END;
/

/*
    -- 3) WHILE LOOP 문
    WHILE 반복수행조건 
    LOOP 
        반복문
    END LOOP;
*/
DECLARE
    I NUMBER := 1;
BEGIN
    WHILE I < 6
    LOOP 
        DBMS_OUTPUT.PUT_LINE(I);
        I := I + 1;
    END LOOP;
END;
/
/*
실습
1. 사원의 연봉을 구하는 PL/SQL 블럭 작성, 보너스가 있는 사원은 보너스도 포함하여 계산 
2. 구구단 짝수단 출력 2-1) FOR LOOP 2-2) WHILE LOOP
*/
1) 
DECLARE
    EMP EMPLOYEE%ROWTYPE;
    SAL NUMBER;
BEGIN
    SELECT *
    INTO EMP
    FROM EMPLOYEE
    WHERE EMP_ID = &사번;
    
    IF EMP.BONUS IS NULL
    THEN
        SAL := EMP.SALARY * 12;
    ELSE
        SAL := (EMP.SALARY + EMP.SALARY * EMP.BONUS) * 12;
    END IF;
    DBMS_OUTPUT.PUT_LINE(EMP.EMP_NAME || '의 연봉은 ' || SAL || '입니다');
END;
/
-- 2-1) FOR LOOP
DECLARE 
    X NUMBER;
    Y NUMBER := 1;
BEGIN 
    FOR X IN 1..9
    
        LOOP
        IF MOD(X,2) = 0 THEN
            FOR Y IN 1..9
            LOOP
            DBMS_OUTPUT.PUT_LINE(X || '*' || Y || '=' || X*Y);
            END LOOP;
        END IF; 
    END LOOP;
END;
/
-- 2-2) WHILE LOOP
DECLARE 
    X2 NUMBER := 2;
    Y2 NUMBER := 1;
BEGIN 
    WHILE X2 < 9
    LOOP
        Y2 := 1;
        DBMS_OUTPUT.PUT_LINE(X2 || '*' || Y2 || '=' || X2*Y2);
        X2 := X2 + 2;
            WHILE Y2 <= 9
            LOOP
                DBMS_OUTPUT.PUT_LINE(X2 || '*' || Y2 || '=' || X2*Y2);       
                Y2 := Y2 + 1;
            END LOOP;
        
    END LOOP;
END;
/
-- 4)예외처리부
/*
    예외(EXCEPITON) : 실행 중 발생하는 오류
    
    EXCEPTION 
        WHEN 예외1 THEN 예외처리구문;
        WHEN 예외2 THEN 예외처리구문;
        ...
        WHEN OTHERS THEN 예외처리꾸문 N;
    
    * 시스템예외
     - NO_DATA_FOUND : SELECT한 결과가 한 행도 없는 경우
     - TOO_MANY_ROWS : SELECT한 결과가 여러 행인 경우
     - ZERO_DIVIDE : 0으로 나눌 때
     - DUP_VAL_ON_INDEX : UNIQUE 제약조건 위배
     ...
*/
-- 사용자가 입력한 수로 나눗셈 연산하는 프로그램
DECLARE
    RESULT NUMBER;
BEGIN
    RESULT := 10 / &숫자;
    DBMS_OUTPUT.PUT_LINE('결과 : ' || RESULT );
EXCEPTION
    WHEN ZERO_DIVIDE THEN DBMS_OUTPUT.PUT_LINE('0으로 나눌 수 없습니다.');
END;
/

-- UNIQUE 제약조건 위배
BEGIN
    UPDATE EMPLOYEE
    SET EMP_ID = &사번
    WHERE EMP_NAME = '노옹철';
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN DBMS_OUTPUT.PUT_LINE('중복된 사번입니다.');
END;
/

DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
BEGIN
    SELECT EMP_ID, EMP_NAME
     INTO EID, ENAME
     FROM EMPLOYEE
     WHERE MANAGER_ID = &사수사번;
EXCEPTION
    WHEN TOO_MANY_ROWS THEN DBMS_OUTPUT.PUT_LINE('너무 많은 행이 조회되었습니다.');
    WHEN NO_DATA_FOUND THEN DBMS_OU ㅒTPUT.PUT_LINE('데이터가 없습니다,');
END;
/