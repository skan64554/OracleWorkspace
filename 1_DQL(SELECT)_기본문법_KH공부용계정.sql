-- DQL == DML

/*
    DML : 데이터 조작 언어 : INSERT, UPDATE, DELETE, SELECT(DQL)
    DDL : 데이터 정의 언어 : CREATE, ALTER, DROP ...
    DCL : 권한부여 : GRANT , REVOKE
    TCL : 트랜잭션 제어 : COMMIT, ROLLBACK
*/
/*
    <SELECT> 
     - 데이터를 조회하거나 검색할 때 사용하는 명령어
     
     * RESULTSET
      - SELECT구문을 통해 조회된 데이터의 결과물(조회된 행들의 집합)
      
      쿼리 작성시 대문자로 가성하는것이 관례, 구분은 '_'로 처리
*/
SELECT EMP_ID, EMP_NAME, SALARY FROM EMPLOYEE;

-- EMPLOYEE 테이블의 전체 사원들의 사번, 이름, 급여 칼럼을 조회
SELECT EMP_NO , EMP_NAME, SALARY FROM EMPLOYEE;

-- EMPLOYEE 테이블의 모든 행의 모든 칼럼을 조회
SELECT * FROM EMPLOYEE;

-- EMPLOYEE 테이블의 전체 사원들의 이름, 이메일, 휴대폰 번호 조회
SELECT EMP_NAME , EMAIL, PHONE FROM EMPLOYEE;