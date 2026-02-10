/*
    <시퀀스 SEQUENCE> only oracle
     - 자동으로 번호를 생성시켜주는 역할을 수행하는 객체
     - 정수값을 순차적으로 생성시켜준다.
     - 회원번호, 사번, 교수번호 등 "순차적으로 겹치지 않는 숫자"를 사용하는
       컬럼에서 주로 사용한다.
    
    1. 시퀀스 객체 생성 구문
    [표현법]
    CREATE SEQUENCE 시퀀스명
    START WITH 시작값 -> 시작값지정(DEFAULT1) 
    INCREMENT BY 증가값 -> 증가값지정(DEFAULT2)
    MAXVALUE 최대값 -> 최대값지정 (DEFAULT 99999999999999...)
    MINVALUE 최소값 -> 최소값지정 (1)
    CYCLE / NOCYCLE -> 순환여부 지정 , DEFAULT = NOCYCLE
    CACHE / NOCACHE -> 캐시 메모리 여부 (웬만하면 쓰는게 좋다)
    ( 기본값은 CACHE 20BYTE )
*/
CREATE SEQUENCE SEQ_TEST;

SELECT * FROM USER_SEQUENCES;

CREATE SEQUENCE SEQ_EMPNO
START WITH 300 
INCREMENT BY 5
MAXVALUE 310 
NOCYCLE
NOCACHE;

/*
    2. 시퀀스 사용 구문
    시퀀스명.CURRVAL : 현재 시퀀스의 값("현재 세션에서" 마지막으로 채번한 값)
    시퀀스명.NEXTVAL : 다음 시퀀스의 값을 INCREMENT BY만큼 증가시킨 값
    
    시퀀스 생성 후 첫번째 NEXTVAL은 START WITH으로 지정된 시작값으로 발생한다
    * 주의사항 :
     - 현재 세션에서 NEXTVAL을 한 번도 수행하지 않은 경우 CURRVAL을 수행할 수 없다.
*/
-- sequence SEQ_EMPNO.CURRVAL is not yet defined in this session
-- CURRVAL은 현재 세션에서 NEXTVAL이 호출되어야 사용할 수 있다
SELECT SEQ_EMPNO.CURRVAL FROM DUAL;

SELECT SEQ_EMPNO.NEXTVAL FROM DUAL; -- 300
SELECT SEQ_EMPNO.CURRVAL FROM DUAL; -- 300

SELECT SEQ_EMPNO.NEXTVAL FROM DUAL; -- 305
SELECT SEQ_EMPNO.CURRVAL FROM DUAL; -- 305

SELECT SEQ_EMPNO.NEXTVAL FROM DUAL; -- 310
SELECT SEQ_EMPNO.NEXTVAL FROM DUAL; -- NOCYCLE에 MAX 초과로 인한 오류

/*
    3. 시퀀스 변경
    ALTER SEQUENCE 시퀀스명
    옵션...
    
    - START WITH은 변경 불가능하며 다른 옵션들은 변경가능.
*/
ALTER SEQUENCE SEQ_EMPNO
INCREMENT BY 10
MAXVALUE 400;

SELECT SEQ_EMPNO.CURRVAL FROM DUAL; -- 310
SELECT SEQ_EMPNO.NEXTVAL FROM DUAL; -- 320
