/*
    <계층형 쿼리> - 오라클에서만 지원
    1. 계층적인 데이터
     - 부장-팀장-과장-대리처럼 계층이 존재하는 데이터
     - 계층형 데이터에는 상위요소와 하위요소가 있으며 1개의 상위요소는
     N개의 하위요소를 포함하고 있다.
     - 티어, 댓글(대댓글), 카테고리, 조직도
    
    2. 계층형구조의 데이터 관리방법
     1) 여러 테이블의 데이터를 따로 관리하기
      - 상위요소, 하위요소별로 데이터를 별 개의 테이블에 분할시켜 저장
      - 데이터의 중복을 최소화하고, 유연하게 설계할 수 있다
      - 단, 계층구조가 복잡한 경우 사용하지 않는다
      
     2) 하나의 테이블에서 관리
      - 하나의 테이블에 상위요소의 값과 하위요소의 값이 함께 저장되어 있는 구조
      - EX) EMPLOYEE 테이블의 MANAGER_ID는 상위요소, EMP_ID는 하위요소
     
     3) 사용법<START WITH ~ CONNECT BY ~ ORDER SIBLINGS BY ~ >
      - 계층형 구조데이터를 쉽게 조회할 수 있도록 오라클에서 지원하는 문법
      1. START WITH
       - 계층구조의 시작점을 지정하는 구문(최상위 부모를 정한다)
       
      2. CONNECT BY
       - 상위타입과 하위타입의 관계를 규정하는 구문
      
      3. ORDER SIBLINGS BY 
       - 계층구조의 데이터를 정렬할 때만 사용가능한 구문
       - 같은 자식레벨끼리 정렬이 가능
       
    [표현법]
    5. SELECT 칼럼들,...
    1. FROM 테이블
    [JOIN 테이블]
    4. [WHERE 조건식] - 인라인뷰로 적용시 첫 번째로 실행
    2. START WITH 시작조건
    3. CONNECT BY [PRIOR] 상위값 = 하위값
    6. [ORDER SIBLINGS BY 정렬조건]
*/

-- 계층형 쿼리 샘플 스크립트 시작--
-- 1개의 테이블에서 데이터를 관리하는경우 (댓글)
-- 계층형 쿼리 샘플 스크립트 시작--
-- 1개의 테이블에서 데이터를 관리하는경우 (댓글)
CREATE TABLE comments (
    comment_id NUMBER PRIMARY KEY,      -- 댓글 ID
    parent_id NUMBER,                   -- 부모 댓글 ID (루트 댓글은 NULL)
    user_name VARCHAR2(50),             -- 작성자
    content VARCHAR2(200),              -- 댓글 내용
    created_at DATE                     -- 작성일자
);

-- 부모 댓글을 참조하는 외래 키 설정 (자기참조)
ALTER TABLE comments
ADD CONSTRAINT fk_parent_comment
FOREIGN KEY (parent_id)
REFERENCES comments(comment_id);

-- 루트 댓글 (부모 없음)
INSERT INTO comments (comment_id, parent_id, user_name, content, created_at) VALUES (1, NULL, '민경민', '오늘부터 다이어트 시작한다', '2024-11-15');
INSERT INTO comments (comment_id, parent_id, user_name, content, created_at) VALUES (2, NULL, '민경민', '방금발언을 취소한다..', '2024-11-16');

-- 대댓글 (1번 댓글에 대한 답글)
INSERT INTO comments (comment_id, parent_id, user_name, content, created_at) VALUES (3, 1, '임세윤', '저도하겠습니다.', '2024-11-13');
INSERT INTO comments (comment_id, parent_id, user_name, content, created_at) VALUES (4, 1, '김지수', '공감합니다.', '2024-11-14');

-- 대댓글의 대댓글 (3번 댓글에 대한 답글)
INSERT INTO comments (comment_id, parent_id, user_name, content, created_at) VALUES (5, 3, '김민주', '응원합니다.', '2024-11-14');

-- 다른 루트 댓글 (부모 없음)
INSERT INTO comments (comment_id, parent_id, user_name, content, created_at) VALUES (6, NULL, '이창민', '배운게 하나도 없네', '2024-11-16');

-- 또 다른 대댓글 (6번 댓글에 대한 답글)
INSERT INTO comments (comment_id, parent_id, user_name, content, created_at) VALUES (7, 6, '조용우', '저도요ㅋㅋ', '2024-11-16');

COMMIT;

/*
    LEVEL
     - 계층쿼리에서만 사용가능한 칼럼으로, 계층구조의 레벨을 의미한다.
     - 최상위 계층은 1, 자식으로 갈수록 2,3,4로 낮아진다
*/
-- 계층구조의 레벨, 작성자이름, 댓글번호, 부모댓글번호, 댓글내용, 작성시간 조회
SELECT 
    LEVEL ,
    LPAD(' ',(LEVEL -1) *2) || USER_NAME 작성자 ,COMMENT_ID ,PARENT_ID ,CONTENT ,CREATED_AT
    FROM COMMENTS
    -- 계층구조의 시작점을 정의
    START WITH PARENT_ID IS NULL
    -- 부모-자식관계를 정의
    CONNECT BY PRIOR COMMENT_ID = PARENT_ID
    -- 계층형태의 정렬조건을 제시
    ORDER SIBLINGS BY CREATED_AT DESC;
    
-- 댓글테이블에서 작성자, 작성내용, 작성일자를 조회
-- 민경민이 작성한 최상위 댓글과 그 대댓글들만 조회.
SELECT
    LEVEL,
    LPAD(' ', (LEVEL -1) *2) || USER_NAME 작성자, 
    CONTENT, CREATED_AT
    FROM COMMENTS 
    START WITH PARENT_ID IS NULL AND USER_NAME = '민경민'
    CONNECT BY PRIOR COMMENT_ID =PARENT_ID;

-- EMPLOYEE 테이블에서 선동일 사원과 선동일 사원이 사수인 사원들 조회
-- LEVEL, 사번, 사원 이름 , 매니저 ID
SELECT
    LEVEL,
    EMP_ID, LPAD(' ',(LEVEL -1 ) *2) || EMP_NAME, MANAGER_ID
    FROM EMPLOYEE
    START WITH EMP_ID = 200
    CONNECT BY PRIOR EMP_ID = MANAGER_ID;



