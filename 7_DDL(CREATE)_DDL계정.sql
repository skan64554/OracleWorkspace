/*
    <DDL>
     - 데이터 정의 언어
     - 오라클에서 제공하는 객체를 새롭게 만들고(CREATE), 구조를 변경하고(ALTER),
     구조를 삭제하는(DROP) 명령어의 집합
     - 구조를 정의하는 언어로, DB관리자나 설계자가 주로 사용한다. 
*/
/*
    <CREATE TABLE>
    테이블 : 행과 열로 구성된 데이터베이스의 객체
            데이터베이스의 "모든" 정보는 테이블에 저장된다
    
    [표현법]
    CREATE TABLE 테이블명 (
    컬럼명 자료형,
    ...
    );
    
    <자료형>
    1. 문자형(CHAR(크기)/VARCHAR2(크기))
        - 크기는 기본단위는 BYTE이며, 글자수로도 지정이 가능하다(글자수 CHAR)
        CHAR(크기) : 최대 2000BYTE까지 저장 가능
                    고정길이
                    들어갈 값의 글자 수가 정해진 경우 사용한다
                    EX) 주민번호, 성별 , 참/거짓값 등
                    
        VARCHAR2(크기) : 최대 4000BYTE까지 저장 가능
                        가변길이
                        들어갈 값의 길이가 정해지지 않은 경우 사용한다
                        EX) 이름, 아이디, 비밀번호...
        
        NCHAR, NVARCHAR -> UNICODE 참조

    2. 숫자형(NUMBER): 정수/실수 상관없이 NUMBER로 관리
    
    3. 날짜형(DATE) : 년 월,일,시,분,초를 관리하는 데이터
    
    4. LOB형 : 큰 용량의 데이터를 관리할 때 사용하는 자료형
*/
-- 관리자계정으로 접속
CREATE USER DDL IDENTIFIED BY DDL;
GRANT CONNECT, RESOURCE TO DDL;
/*

    -- DDL계정으로 접속


*/

-- 회원테이블(아이디,비번,이름,생년월일)
CREATE TABLE MEMBER(
    MEM_ID VARCHAR2(20) ,
    MEM_PWD VARCHAR2(20) ,
    MEM_NAME VARCHAR2(20) ,
    MEM_BDATE DATE 
);

SELECT * FROM MEMBER;
/*
    데이터 딕셔너리
     - 다양한 객체들의 정보를 저장하고 있는 시스템 테이블
     - USER_객체명S
     - DBA_객체명s
*/
SELECT * FROM USER_TABLES;
SELECT * FROM USER_TAB_COLUMNS;
/*
    칼럼에 주석달기 (권장)
    [표현법]
    COMMENT ON COLUMN 테이블명.칼럼명 IS '주석';
*/
COMMENT ON COLUMN MEMBER.MEM_ID IS '회원아이디';
COMMENT ON COLUMN MEMBER.MEM_PWD IS '회원비밀번호';
COMMENT ON COLUMN MEMBER.MEM_NAME IS '회원이름';
COMMENT ON COLUMN MEMBER.MEM_BDATE IS '회원생년월일';

INSERT INTO MEMBER VALUES('user01', 'pass01', '홍길동', '1980-10-06');
INSERT INTO MEMBER VALUES('user02', 'pass02', '김갑생', '99/05/10');
INSERT INTO MEMBER VALUES('user03', 'pass03', '박말똥', SYSDATE);
INSERT INTO MEMBER VALUES(NULL,NULL,NULL,NULL);
INSERT INTO MEMBER VALUES('user03', 'pass03', '크로클', SYSDATE);
SELECT * FROM MEMBER;

/*
    칼럼에 null값이 들어가면 안되거나, 중복값이 들어가면 안되는 경우가 있다.
    유효한 데이터값을 유지하기 위해서는 칼럼에 제약조건을 추가해야 한다
    제약조건 추가시 데이터의 무결성을 보장할 수 있다
    
    <제약조건 CONSTRAINTS>
     - 원하는 형태의 데이터값을 유지하기 위해서 특정 컬럼마다 설정하는 제약
     - 제약조건이 부여된 컬럼에 들어올 데이터에 문제가 있는지 검사할 수 있다.
     - 종류 : NOT NULL , UNIQUE, CHECK , PRIMARY KEY , FOREIGN KEY
     - 제약조건 부여방식 : 칼럼레벨방식 / 테이블레벨방식
*/
/*
    1. NOT NULL 제약조건
     - 해당 칼럼에 반드시 값이 존재해야만 할 경우 사용
     - 즉, NULL값이 절대 들어와서는 안되는 칼럼에 부여하는 제약조건
     - 컬럼레벨 방식으로만 제약조건 부여 가능.
*/
-- NOT NULL 제약조건이 추가된 테이블 생성
-- 칼럼레벨방식
CREATE TABLE MEM_NOTNULL (
    MEM_NO NUMBER NOT NULL,
    MEM_ID VARCHAR2(20) NOT NULL,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL
);
INSERT INTO MEM_NOTNULL
VALUES(2,NULL,NULL,'로클');

-- 제약조건 확인방법
SELECT * FROM USER_CONSTRAINTS;

/*
    2. UNIQUE 제약조건
     - 칼럼에 중복값을 제한하는 제약조건
     - 칼럼에 값이 삽입/수정될 때 기존에 해당 칼럼값 중 중복값이 있을 경우
       추가 또는 수정되지 않게 제약한다.
*/
CREATE TABLE MEM_UNIQUE (
    MEM_NO NUMBER NOT NULL UNIQUE,
    MEM_ID VARCHAR2(20) NOT NULL UNIQUE,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL
);
-- DROP문
DROP TABLE MEM_UNIQUE;

-- 테이블레벨 부여방식
CREATE TABLE MEM_UNIQUE (
    MEM_NO NUMBER NOT NULL,
    MEM_ID VARCHAR2(20) NOT NULL,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    UNIQUE(MEM_NO),
    UNIQUE(MEM_ID)
);

INSERT INTO MEM_UNIQUE VALUES (1,'user01','pass01','길동');

INSERT INTO MEM_UNIQUE VALUES (2,'user01','pass01','길동');
/*
    unique제약조건 위배시 제약조건의 이름만으로 어떤 컬럼이
    위배되었는지 알기 힘들다.
    
    제약조건 부여시 제약조건의 이름을 부여하면, 어떠한 칼럼의 
    제약조건위배인지 한눈에 파악이 가능하다
*/
/*
    * 제약조건에 이름 부여하는 방법
    > 칼럼레벨 방식
    컬럼명 자료형 CONSTRAINT 제약조건명 제약조건(UNIQUE, NOT NULL 등)
    
    > 테이블레벨 방식
    CONSTRAINT 제약조건명 제약조건(칼럼명)
*/
CREATE TABLE MEM_CON_NM (
    MEM_NO NUMBER NOT NULL CONSTRAINT MEM_NO_UQ UNIQUE,
    MEM_ID VARCHAR2(20) NOT NULL,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    CONSTRAINT MEM_ID_UQ UNIQUE(MEM_ID)
);

INSERT INTO MEM_CON_NM VALUES (1,'user01','pass01','길동');

INSERT INTO MEM_CON_NM VALUES (2,'user01','pass01','길동');
-- ORA-00001: unique constraint (DDL.MEM_ID_UQ) violated

/*
    3. CHECK 제약조건
     - 칼럼에 들어갈 값에 대한 조건식을 직접 설정할 때 사용
     - CHACK(조건식)
*/

CREATE TABLE MEM_CHECK (
    MEM_NO NUMBER NOT NULL UNIQUE,
    MEM_ID VARCHAR2(20) NOT NULL,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK(GENDER IN ('남','여')) NOT NULL,
    UNIQUE(MEM_ID)
);

INSERT INTO MEM_CHECK VALUES
(1,'user01','pass01','로클','남');

-- CHECK제약조건으로 NULL값 추가를 방지하고 싶다면 NOT NULL 제약조건을 추가
INSERT INTO MEM_CHECK VALUES
(2,'user02','pass02','반클',NULL);

/*
    *DEFAULT 설정
     - 특정 컬럼에 들어올 값에 대한 기본값 설정
     - 제약조건은 아님
*/
CREATE TABLE MEM_DEF (
    MEM_NO NUMBER NOT NULL UNIQUE,
    MEM_ID VARCHAR2(20) NOT NULL,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK(GENDER IN ('남','여')),
    MEM_DATE DATE DEFAULT SYSDATE,
    UNIQUE(MEM_ID)
);

INSERT INTO MEM_DEF(MEM_NO, MEM_ID, MEM_PWD,MEM_NAME,GENDER)
VALUES(1,'user01','1234','로클','남');

INSERT INTO MEM_DEF
VALUES(2,'user02','1234','반클','여',DEFAULT);

SELECT * FROM MEM_DEF;

/*
    4. PRIMARY KEY (기본키 제약조건)
     - 테이블에서 각 행들의 정보를 유일하게 식별할 수 있는
     칼럼에만 부여하는 제약조건
     - 한 테이블당 기본키는 한번만 지정할 수 있다.
     - 주로 각 행들의 정보를 고유하게 식별할 수 있는 컬럼에 부여한다
     - NOT NULL제약조건과 UNIQUE제약조건의 기능이 합쳐져 있다.
*/
CREATE TABLE MEM_PRIMARYKEY1 (
    MEM_NO NUMBER PRIMARY KEY,
    MEM_ID VARCHAR2(20) NOT NULL,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK(GENDER IN ('남','여')),
    MEM_DATE DATE DEFAULT SYSDATE NOT NULL,
    UNIQUE(MEM_ID)
);
INSERT INTO MEM_PRIMARYKEY1
VALUES (1,'user01','pass01','로클','남',DEFAULT);
-- VALUES (1,'user01','pass01','로클','남',DEFAULT);

CREATE TABLE MEM_PRIMARYKEY2 (
    MEM_NO NUMBER,
    MEM_ID VARCHAR2(20) NOT NULL,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK(GENDER IN ('남','여')),
    MEM_DATE DATE DEFAULT SYSDATE NOT NULL,
    UNIQUE(MEM_ID),
    PRIMARY KEY (MEM_NO , MEM_ID)
);
INSERT INTO MEM_PRIMARYKEY2
VALUES (1,'user01','pass01','로클','남',DEFAULT);

INSERT INTO MEM_PRIMARYKEY2
VALUES (1,'user02','pass01','로클','남',DEFAULT);

SELECT * FROM MEM_PRIMARYKEY2;
-- MEM_NO는 같지만 MEM_ID는 달라 중복이 아니라 판단
-- 복합기는 그래서 사용처도 적음

/*
    5. FOREIGN KEY(외래키)
     - 컬럼에 들어갈 값을 다른 테이블에 존재하는 값만 들어오게끔 설정하는 제약조건
     [표현법]
      - 컬럼 레벨 방식
      컬럼명 자료형 [CONSTRAINT 제약조건명] REFERENCES 참조테이블명(참조컬럼명)
      
      - 테이블 레벨 방식
      [CONSTRAINT 제약조건명] FOREIGN KEY(컬럼명) REFERENCES 참조테이블명(참조컬럼명)
*/
-- 부모테이블
-- 회원등급에 대한 데이터 테이블
CREATE TABLE MEM_GRADE (
    GRADE_CODE CHAR(2) PRIMARY KEY ,
    GRADE_NAME VARCHAR2(20) NOT NULL 
);
INSERT INTO MEM_GRADE
VALUES('G1', '일반회원');

INSERT INTO MEM_GRADE
VALUES('G2', '우수회원');

INSERT INTO MEM_GRADE
VALUES('G3', '특별회원');

CREATE TABLE MEM (
    MEM_NO NUMBER,
    MEM_ID VARCHAR2(20) NOT NULL,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK(GENDER IN ('남','여')),
    MEM_DATE DATE DEFAULT SYSDATE NOT NULL,
    MEM_GRADE CHAR(2), -- 컬럼레벨방식 REFERENCES MEM_GRADE(GRADE_CODE), 
    UNIQUE(MEM_ID),
    PRIMARY KEY(MEM_NO , MEM_ID),
    -- 테이블레벨방식
    FOREIGN KEY(MEM_GRADE) REFERENCES MEM_GRADE 
    -- 참조컬럼 생략시 해당테이블의 기본키가 설정됨
);
INSERT INTO MEM
VALUES (1, 'user01','pass01','홍길동','남',DEFAULT,'G1');

INSERT INTO MEM
VALUES (2, 'user02','pass01','홍길동','남',DEFAULT,'G2');

INSERT INTO MEM
VALUES (3, 'user03','pass01','홍길동','남',DEFAULT,'G3');

INSERT INTO MEM
VALUES (4, 'user04','pass01','홍길동','남',DEFAULT,NULL);

INSERT INTO MEM
VALUES (5, 'user04','pass01','홍길동','남',DEFAULT,'G4');
-- G4는 부모테이블에 존재하지 않는 값이기 때문에 사용불가

-- 외래키 제약조건 추가후, 부모테이블의 값을 변경하고자 하는 케이스
DELETE FROM MEM_GRADE
WHERE GRADE_CODE = 'G1';
-- 자식테이블에서 변경/삭제하고자하는 행을 참조하는 경우, 제대로된 변경/삭제 불가능
-- G1을 참조하고 있는 자식행이 존재하므로 삭제 불가능

/*
    * FOREIGN KEY 삭제 옵션
     - 부모테이블의 데이터가 삭제되는 경우, 자식테이블에서는 이를 어떻게 처리할지 옵션
     으로 정해둘 수 있다.
     1. ON DELETE RESTRICTED : 삭제제한 옵션(기본값)
     2. ON DELETE SET NULL : 부모데이터 삭제시 해당 데이터를 사용하는 자식데이터를
        NULL로 변환
     3. ON DELETE CASCADE : 부모데이터 삭제시 해당 데이터를 사용하고 있는
        자식데이터를 함께 삭제하는 옵션
*/
DROP TABLE MEM;

CREATE TABLE MEM (
    MEM_NO NUMBER,
    MEM_ID VARCHAR2(20) NOT NULL,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK(GENDER IN ('남','여')),
    MEM_DATE DATE DEFAULT SYSDATE NOT NULL,
    MEM_GRADE CHAR(2), -- 컬럼레벨방식 REFERENCES MEM_GRADE(GRADE_CODE), 
    UNIQUE(MEM_ID),
    PRIMARY KEY(MEM_NO , MEM_ID),
    -- 테이블레벨방식
    FOREIGN KEY(MEM_GRADE) REFERENCES MEM_GRADE ON DELETE SET NULL
);
INSERT INTO MEM
VALUES (1, 'user01','pass01','홍길동','남',DEFAULT,'G1');

INSERT INTO MEM
VALUES (2, 'user02','pass01','홍길동','남',DEFAULT,'G2');

INSERT INTO MEM
VALUES (3, 'user03','pass01','홍길동','남',DEFAULT,'G3');

INSERT INTO MEM
VALUES (4, 'user04','pass01','홍길동','남',DEFAULT,NULL);

DELETE FROM MEM_GRADE
WHERE GRADE_CODE = 'G1';

DROP TABLE MEM;

CREATE TABLE MEM (
    MEM_NO NUMBER,
    MEM_ID VARCHAR2(20) NOT NULL,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK(GENDER IN ('남','여')),
    MEM_DATE DATE DEFAULT SYSDATE NOT NULL,
    MEM_GRADE CHAR(2), -- 컬럼레벨방식 REFERENCES MEM_GRADE(GRADE_CODE), 
    UNIQUE(MEM_ID),
    PRIMARY KEY(MEM_NO , MEM_ID),
    -- 테이블레벨방식
    FOREIGN KEY(MEM_GRADE) REFERENCES MEM_GRADE ON DELETE CASCADE
);
INSERT INTO MEM
VALUES (1, 'user01','pass01','홍길동','남',DEFAULT,'G2');

INSERT INTO MEM
VALUES (2, 'user02','pass01','홍길동','남',DEFAULT,'G3');

INSERT INTO MEM
VALUES (3, 'user03','pass01','홍길동','남',DEFAULT,'G4');

INSERT INTO MEM
VALUES (4, 'user04','pass01','홍길동','남',DEFAULT,NULL);
SELECT * FROM MEM;

DELETE FROM MEM_GRADE
WHERE GRADE_CODE = 'G2';
-- 자식레코드 함께 삭제

-----------------------------------------------------------
/*
    KH계정으로 변환
    * SUBQUERY를 이용한 테이블 생성
    
    [표현법]
    CREATE TABLE 테이블명
    AS 서브쿼리;
*/
-- EMPLOYEE테이블을 복제한 새로운 테이블 생성
CREATE TABLE EMPLOYEE_COPY 
AS SELECT * FROM EMPLOYEE;

SELECT * FROM EMPLOYEE_COPY;
-- 서브쿼리로 복사시 NOT NULL을 제외한 제약조건들은 제대로 복사되지 않는다
-- 실제 데이터만 복사하는 행위

-- 전체 사원들 중 급여가 300만원 이상인 사원들의 정보만 복사
CREATE TABLE EMPLOYEE_COPY2
AS SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY 
FROM EMPLOYEE
WHERE SALARY >= 3000000;

SELECT * FROM EMPLOYEE_COPY2;
