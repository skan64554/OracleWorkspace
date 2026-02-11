/*
    <트리거>
     - 내가 트리거로 지정한 테이블에 INSERT, UPDATE, DELETE문이 실행되는 경우
       자동으로 함께 실행할 내용을 정의해두는 객체
     - EX) 회원탈퇴시 기존의 회원테이블에서 데이터를 삭제(DELETE)후, 곧바로 탈퇴된
       회원들만 보관하는 테이블에 자동으로 INSERT해야되는 경우
       신고횟수가 일정수를 넘었을떄 해당 회원의 정보를 즉시 변경하는 경우
       
     * 트리거 종류
     SQL문의 실행시기에 따른 분류
     1. BEFORE TRIGGER
      - 내가 트리거를 지정한 테이블이 DML이 발생되기 "전"에 트리거를 먼저 실행
     2. AFTER TRIGGER
      - 내가 트리거로 지정한 테이블이 DML이 발생된 "후"에 트리거를 실행
      
     SQL문에 의해 영향을 받는 각 행에 따른 분류
     1. STATEMENT TRIGGER
      - 이벤트(DML)가 발생한 SQL문에 대해 딱 한번만 실행되는 트리거
     2. ROW TRIGGER
      - SQL문 실행시마다 매번 실행되게하는 트리거(FOR EACH ROW옵션기술시 ROW TRIGGER로 설정)
    
    * 트리거 생성구문
    CREATE OR REPLACE TRIGGER 트리거명
    BEFORE|AFTER INSERT|DELETE|UPDATE ON 테이블명
    [FOR EACH ROW]
    PL/SQL문
*/
-- EMPLOYEE테이블에 새로운 행이 추가될 때마다 자동으로 메세지를 출력해주는 트리거
CREATE OR REPLACE TRIGGER TRG_01
AFTER INSERT ON EMPLOYEE
BEGIN
    DBMS_OUTPUT.PUT_LINE('신입사원님 환영합니다!');
END;
/
INSERT INTO EMPLOYEE(EMP_ID,EMP_NAME,EMP_NO,EMAIL,JOB_CODE,SAL_LEVEL)
VALUES (777,'로클','123456-1234567','로클@naver.com','J1','S1');

-- 상품 입고 및 출고 관련 트리거 예시
-- 1. 상품에 대한 데이터 보관할 테이블(TB_PRODUCT)
CREATE TABLE TB_PRODUCT(
    PCODE NUMBER PRIMARY KEY, -- 상품번호
    PNAME VARCHAR2(30) NOT NULL, -- 상품명
    BRAND VARCHAR2(30) NOT NULL, -- 브랜드명
    PRICE NUMBER, -- 가격
    STOCK NUMBER DEFAULT 0  -- 재고수량
);

-- 상품번호 중복 안되게끔 매번 새로운 번호를 발생시키는 시퀀스 생성(SEQ_PCODE)
CREATE SEQUENCE SEQ_PCODE
START WITH 200
INCREMENT BY 5
NOCACHE;

-- 샘플데이터 추가하기
INSERT INTO TB_PRODUCT VALUES(SEQ_PCODE.NEXTVAL, '갤럭시Z플립4','삼성',1350000,DEFAULT);
INSERT INTO TB_PRODUCT VALUES(SEQ_PCODE.NEXTVAL, '갤럭시S10','삼성',1350000,10);
INSERT INTO TB_PRODUCT VALUES(SEQ_PCODE.NEXTVAL, '아이폰13','애플',1500000,20);

SELECT * FROM TB_PRODUCT;

COMMIT;

-- 2. 상품 입출고 상세 이력 테이블(TB_PRODETAIL)
--    어떤 상품이 어떤 날짜에 몇개가 입고 또는 출고가 되었는지에 대한 데이터를 기록하는 테이블.
CREATE TABLE TB_PRODETAIL(
    DCODE NUMBER PRIMARY KEY, -- 이력번호
    PCODE NUMBER REFERENCES TB_PRODUCT, -- 상품번호
    PDATE DATE NOT NULL, -- 상품입출고일
    AMOUNT NUMBER NOT NULL, -- 입출고 수량
    STATUS CHAR(6) CHECK(STATUS IN ('입고','출고')) -- 상태(입고 , 출고)
);

CREATE SEQUENCE SEQ_DCODE;

-- 200번 상품이 오늘 날짜로 10개 입고
INSERT INTO TB_PRODETAIL
VALUE (SEQ_DCODE.NEXTVAL ,200, SYSDATE, 10, '입고');

UPDATE TB_PRODUCT
SET STOCK = STOCK + 10
WHERE PCODE = 200;

COMMIT;

SELECT * FROM TB_PRODUCT;

-- 트리거를 통해 자동화 관리
-- TB_PRODETAIL에 입,출고 이력이 추가되는 경우,
-- TB_PRODUCT의 재고수량이 UPDATE되도록 트리거 정의
CREATE OR REPLACE TRIGGER TRG_02
AFTER INSERT ON TB_PRODETAIL 
FOR EACH ROW
BEGIN
    -- 상품이 입고된 경우
    -- :NEW 새롭게 추가된 행
    IF :NEW.STATUS = '입고'
        THEN
            UPDATE TB_PRODUCT
               SET STOCK = STOCK + :NEW.AMOUNT
               WHERE PCODE = :NEW.PCODE;
    ELSE
        UPDATE TB_PRODUCT
            SET STOCK = STOCK - :NEW.AMOUNT
        WHERE PCODE = :NEW.PCODE;
    END IF;
END;
/

-- 210번 상품 7개 출고
INSERT INTO TB_PRODETAIL
VALUES (SEQ_DCODE.NEXTVAL, 210, SYSDATE, 7, '출고');
-- 200번 상품 100개 입고
INSERT INTO TB_PRODETAIL
VALUES (SEQ_DCODE.NEXTVAL, 200, SYSDATE, 100, '입고');

SELECT * FROM TB_PRODUCT;

/*
    트리거 장점 
    1. 데이터 추가, 수정, 삭제시 자동으로 데이터 관리를 해줌으로써 데이터베이스의 무결성 보장
    2. 데이터베이스의 관리 자동화 (현실적으로 힘듦)
    
    트리거 단점
    1. 빈번한 추가, 수정, 삭제시 다른 테이블의 행또한 추가로 수정,추가,삭제가 되므로 
       성능이 좋지 못하다.
    2. 관리적 측면에서 형상관리가 불가능하다.
    3. 트리거를 남용하게 되는 경우 유지보수가 힘들다.
*/