/*
    DDL
    
    1. ALTER (실무가서 쓸 일은 많이 없음)
     - 객체의 구조를 수정하는 구문
     
    < 테이블 수정 >
    ALTER TABLE 테이블명 수정할 내용;
    
    - 수정할 내용
    1) 칼럼 추가 / 수정 / 삭제
    2) 제약조건 추가 / 삭제 => 수정은 불가
    3) 테이블명 / 컬럼명 / 제약조건명 수정 가능
*/
SELECT * FROM DEPT_COPY;

-- CNAME 컬럼을 새로 추가.
-- 칼럼추가 (ADD) : ADD 컬럼명 자료형 [DEFAULT 기본값]
ALTER TABLE DEPT_COPY ADD CNAME VARCHAR2(20);

-- LNAME 컬럼을 DEPT_COPY에 추가하고 기본값으로 '한국'을 부여
ALTER TABLE DEPT_COPY ADD LNAME VARCHAR2(20) DEFAULT '한국';

-- 컬럼 수정(MODIFY)
-- 칼럼의 자료형 수정 : MODIFY 수정할 컬럼명 바꿀자료형
-- 칼럼의 기본값 수정 : MODIFY 수정할 컬럼명 DEFAULT 바꿀 기본값
-- DEPT_COPY의 DEPT_ID컬럼의 자료형을 CHAR (3)으로 변경
ALTER TABLE DEPT_COPY MODIFY DEPT_ID CHAR(3); -- CHAR(2) -> CHAR(3)

-- DEPT_ID컬럼을 NUMBER로 변경
ALTER TABLE DEPT_COPY MODIFY DEPT_ID NUBMER; -- CHAR(3) -> NUMBER? 오류
-- 값이 이미 추가된 경우 변경이 불가능 -> 바꾸고자 한다면 DEPT_ID의 모든 값을 NULL로 변경

-- DEPT_ID컬럼의 값을 CHAR(2)로 변경
ALTER TABLE DEPT_COPY MODIFY DEPT_ID CHAR(2);
-- CHAR(2)보다 더 큰 값이 저장된 경우 변경이 불가능하다

-- 문자 -> 숫자 (x) / 문자열 사이즈 축소 (x) / 문자열 사이즈 확대(O)
-- 한번에 여러 개의 컬럼값 변경
-- DEPT_TITLE을 VARCHAR2(40)
-- LOCATION_ID를 VARCHAR2(2)
-- LNAME의 기본값을 '미국'
ALTER TABLE DEPT_COPY
MODIFY DEPT_TITLE VARCHAR2(40)
MODIFY LOCATION_ID VARCHAR2(2)
MODIFY LNAME DEFAULT '미국';

SELECT * FROM DEPT_COPY;

-- 컬럼삭제(DROP COLUMN) : DROP COLUMN 컬럼명
CREATE TABLE DEPT_COPY2
AS SELECT * FROM DEPT_COPY;

ALTER TABLE DEPT_COPY2 DROP COLUMN DEPT_ID;

SELECT * FROM DEPT_COPY2;
-- DDL은 ROOLBACK으로 복구 불가

ALTER TABLE DEPT_COPY2 DROP COLUMN DEPT_TITLE;
ALTER TABLE DEPT_COPY2 DROP COLUMN LOCATION_ID;
ALTER TABLE DEPT_COPY2 DROP COLUMN CNAME;
ALTER TABLE DEPT_COPY2 DROP COLUMN LNAME; -- 마지막 남은 컬럼을 삭제하진 못함

/*
    2. 제약조건
    제약조건추가
    - NOT NULL : MODIFY 컬럼명 NOT NULL;
    - PRIMARY KEY/FOREIGN KEY/UNIQUE/CHECK
      ADD 제약조건(컬럼명/조건식) 
*/
-- DEPT_COPY 테이블의 DEPT_ID에 PRIMARY KEY 제약조건 추가
-- DEPT_TITLE에 UNIQUE 제약조건, LNAME컬럼에 NOT NULL 제약조건 추가
ALTER TABLE DEPT_COPY
ADD CONSTRAINT DCOPY_PK PRIMARY KEY(DEPT_ID)
ADD UNIQUE(DEPT_TITLE)
MODIFY LNAME NOT NULL;
-- 제약조건 이름부여는 필수 X

-- 제약조건 삭제
-- DROP CONSTRAINT 제약조건명; 
-- NOT NULL : MODIFY 컬럼명 NULL;

-- DCOPY_PK 제약조건 삭제
ALTER TABLE DEPT_COPY DROP CONSTRAINT DCOPY_PK;
ALTER TABLE DEPT_COPY MODIFY LNAME NULL; -- 삭제

-- 3. 컬럼명 / 제약조건명 / 테이블 변경 (RENAME)
-- 컬럼명 변경 : RENAME COLUMN 기존 컬럼명 TO 변경할 컬럼명
ALTER TABLE DEPT_COPY RENAME COLUMN DEPT_TITLE TO DEPT_NAME;

-- 제약조건명 변경 : RENAME CONSTRAINT A TO B
-- SYS_C007171 -> DCOPY_DN_UQ
ALTER TABLE DEPT_COPY RENAME CONSTRAINT SYS_C007171 TO DCOPY_DN_UQ;

-- 테이블명 변경 : ALTER TABLE 테이블명 TO 바꿀 테이블명
ALTER TABLE DEPT_COPY RENAME TO DEPT_TEST; 

/*
    2. DROP
     - 객체를 삭제하는 구문
     
     DROP TABLE 테이블명 [CASCADE CONSTRAINT];
*/
DROP TABLE EMP_NEW;

-- 부모테이블 삭제학기
-- ALTER를 이용하여 부모-자식 관계 만들기
-- DEPT_TEST(부모), EMPLOYEE-COPY(자식)
ALTER TABLE DEPT_TEST ADD PRIMARY KEY(DEPT_ID);
ALTER TABLE EMPLOYEE_COPY ADD FOREIGN KEY(DEPT_CODE) REFERENCES DEPT_TEST;

DROP TABLE DEPT_TEST; -- 참조로 인한 삭제 불가
-- 어딘가에서 참조되고 있는 부모테이블은 바로 삭제되지 않는다.
-- 이 부모테이블을 삭제하고 싶다면
-- 방법1) 자식테이블을 삭제 후 부모테이블을 삭제
DROP TABLE 자식;
DROP TABLE 부모;
-- 방법2) 부모테이블 삭제시 맞물린 외래키 제약조건도 함께 삭제하는 방식
DROP TABLE DEPT_TEST CASCADE CONSTRAINT;
