/*
    프로시져(PROCEDURE)
     - PL/SQL문을 저장해서 재사용하는 객체
     - 필요할 때마다 작성해둔 PL/SQL문을 호출할 수 있다
     
    프로시져 생성방법
    CREATE [OR REPLACE] PROCEDURE 프로시져명[(매개변수)]
    IS 
    PL/SQL문
    
    프로시져 실행방법
    EXEC 프로시져명;
*/
CREATE TABLE PRO_TEST
AS SELECT * FROM EMPLOYEE;

CREATE PROCEDURE DEL_DATA
IS
BEGIN
    DELETE FROM PRO_TEST;
    COMMIT;
END;
/

EXEC DEL_DATA;

SELECT * FROM PRO_TEST;

-- 프로시져에서 매개변수 사용
-- IN : 프로시져 실행시 필요한 값을 받는 변수로, 일반적인 매개변수와 동일한 역할 수행
-- OUT : 호출한 곳으로 되돌려주는 변수(RETURN의 역할을 수행)
CREATE OR REPLACE PROCEDURE PRO_EMP(V_EMP_ID IN NUMBER ,
                                    V_EMP_NAME OUT EMPLOYEE.EMP_NAME%TYPE,
                                    V_SALARY OUT EMPLOYEE.SALARY%TYPE ,
                                    V_BONUS OUT EMPLOYEE.BONUS%TYPE
                                    )
IS
BEGIN
    SELECT EMP_NAME, SALARY, BONUS 
     INTO V_EMP_NAME , V_SALARY, V_BONUS
     FROM EMPLOYEE
    WHERE EMP_ID = V_EMP_ID;
END;
/
-- CTRL + ENTER
VAR EMP_NAME VARCHAR2(20); 
VAR SALARY NUMBER;
VAR BONUS NUMBER;

EXEC PRO_EMP(200, :EMP_NAME, :SALARY, :BONUS);

PRINT EMP_NAME;
PRINT SALARY;
PRINT BONUS;
/*
    프로시져 장점
    1. 처리속도가 빠름
    2. 대용량 데이터 처리서 유리함
    
    프로시져 단점
    1. 관리적 측면에서 자바소스코드, 오라클 코드를 동시에 형상관리하기 어려움
    2. DB자원을 직접 사용하기 때문에 DB에 좀더 많은 부하를 주게 된다
*/
--------------------------------------------------------------------
/*
    <FUNCTION>
     - 프로시져와 유사하지만, 실행결과를 반환해준다.
     
     FUNCTION 생성방법
     CREATE OR REPLACE FUNCTION 함수명(매개변수)
     RETURN 반환되는 값의 자료형
     IS 
     PL/SQL
*/
CREATE OR REPLACE FUNCTION MY_FUNC(V_STR VARCHAR2)
RETURN VARCHAR2
IS
    RESULT VARCHAR2(1000);
BEGIN
    RESULT := '*' || V_STR || '*';
    RETURN RESULT;
END;
/

SELECT MY_FUNC('크로클') FROM DUAL;

-- EMP_ID를 전달받아 연봉을 계산해서 반환해주는 함수 만들기
CREATE OR REPLACE FUNCTION SALARY_FUNC(V_EMP_ID NUMBER)
RETURN NUMBER
IS
    E EMPLOYEE%ROWTYPE;
    RESULT NUMBER;
BEGIN
    SELECT *
     INTO E
     FROM EMPLOYEE 
    WHERE EMP_ID = V_EMP_ID;
    
    RESULT := (E.SALARY + E.SALARY * NVL(E.BONUS,0)) * 12;
    RETURN RESULT;
END;
/
SELECT EMP_ID , SALARY_FUNC(EMP_ID)
FROM EMPLOYEE;