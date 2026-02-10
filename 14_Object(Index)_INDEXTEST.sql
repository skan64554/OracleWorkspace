/*
    Object(Index)
     - 데이터를 빠르게 검색하기 위한 객체로 데이터의 정렬 및 탐색과 같은 DBMS의 성능향상을
     목적으로 사용한다.
     - INDEX는 책의 목차와 같은 역할을 한다
     - 테이블의 찾고자하는 컬럼값을 인덱스로 만들면, 인덱스로 지정된 컬럼은
     별도의 저장공간에 컬럼값과 위치정보(ROWID)를 함께 저장한다. 이때 검색의 편리성을 위해
     컬럼값 기준 오름차순 정렬하여 데이터를 보관한다
     - 즉, INDEX는 데이터를 빠르게 조회하기 위해 "데이터에 대한 정보"와 
     데이터를 찾기위한 정보(ROWID)를 함께 저장하는 객체
     - 인덱스의 일반적인 자료구조는 B*Tree방식으로 구현되어 있다.
     
     B*Tree
      - 루트, 브랜치, 리프노드가 존재하며, 루트노드에서 리프까지의 깊이가 
        항상 균등한(Balanced) 형태의 자료구조이다
      - 루트노드와 브랜치노드는 "값의 범위"를 키값으로 저장하고 있고,
        리프노드에 실제 인덱스의 키값과 해당 칼럼에 접근할 수 있는 위치값(ROWID)을 보관
        
    인덱스 활용 위치
     - 인덱스는 강재로 사용할 수도 있지만, 일반적으로는 DBMS에 의해 
     자동으로 호출되어 사용한다
     - select, join문이 실행될 때 join조건절, where의 조건절에 인덱스로 지정된 컬럼이
     사용될 경우 DBMS에 의해 사용될 수 있다
     - 테이블에 PRIMARY KEY 제약조건을 추가하는 경우, 혹은 UNIQUE 제약조건을 추가하는 경우
     자동으로 인덱스가 생성된다
     
    [표현법]
    CREATE INDEX 인덱스명 ON 테이블명(..컬럼);
    
*/
CREATE USER INDEXTEST IDENTIFIED BY INDEXTEST;
GRANT CONNECT, RESOURCE TO INDEXTEST;

SELECT COUNT(*) FROM USER_MOCK_DATA;

SELECT * FROM USER_MOCK_DATA
WHERE ID = 22222;
-- 계획 설명
-- OPTIONS : FULL, CARDINALITY(예상 반환행) : 5, 비용 : 136 

SELECT * FROM USER_MOCK_DATA
WHERE EMAIL = 'niacobassi65@shareasale.com';
-- 계획 설명
-- OPTIONS : FULL, CARDINALITY(예상 반환행) : 5, 비용 : 136 

SELECT * FROM USER_MOCK_DATA
WHERE GENDER = 'Male';

SELECT * FROM USER_MOCK_DATA
WHERE FIRST_NAME LIKE 'R%';
-- 예상행 2630, 비용 : 136, FULL SCAN

-- 제약조건 추가 PK, UQ
ALTER TABLE USER_MOCK_DATA ADD CONSTRAINT PK_ID PRIMARY KEY(ID);
ALTER TABLE USER_MOCK_DATA ADD UNIQUE(EMAIL);
-- 현재 계정의 인덱스 확인
SELECT * FROM USER_INDEXES;

SELECT * FROM USER_MOCK_DATA
WHERE ID = 22222;
-- INDEX UNIQUE SCAN , 예상 반환 행 : 1, COST : 2

SELECT * FROM USER_MOCK_DATA
WHERE EMAIL = 'niacobassi65@shareasale.com';
--예상 반환 행 : 1, COST : 2

SELECT * FROM USER_MOCK_DATA
WHERE GENDER = 'Male';
-- OPTIONS : FAST FULL SCAN(정렬 수행후 FULL SCAN), 예상 반환 행 : 22643 , COST : 136
-- DBMS 성능에 따라 인덱스를 타는경우, 타지 않는 경우로 나뉨
-- 인덱스를 타지 않기 때문에, 여전히 FULL SCAN을 한다

CREATE INDEX IDX_USER_MOCK_DATA_GENDER ON USER_MOCK_DATA(GENDER);

CREATE INDEX IDX_USER_MOCK_DATA_FIRST_NAME ON USER_MOCK_DATA(FIRST_NAME);

SELECT * FROM USER_MOCK_DATA
WHERE FIRST_NAME LIKE 'R%';
-- OPTION : INDEX RANGE SCAN, 예상행 : 415 -> 2630 , COST 3 -> 135

/*
    * 인덱스를 효율적으로 쓰기 위해서는 어떤 컬럼에 적용시키는 것이 좋은가?
     - 데이터의 분포도가 높고 , 조건절에 자주 사용되며, 중복값이 적은 컬럼
     
    1) 조건절에 자주 등장하는 컬럼
    2) JOIN절에 자주 등장하는 컬럼
    3) 항상 =로 비교되는 컬럼
    4) 중복되는 데이터가 적은 컬럼(분포도가 높은 컬럼)
    5) ORDER BY절에 자주 사용되는 컬럼
    
    인덱스의 장점
    1) WHERE, JOIN에서 인덱스컬럼을 타게되면 훨씬 빠르게 조회가 가능
    2) 인덱스 컬럼기준으로 조회시, ORDER BY 연산이 필요 없을 수 있다.
    3) 인덱스 컬럼을 통해 MIN,MAX함수 호출시 연산속도가 매우 빠르다.
    
    인덱스의 단점
    1) INDEX를 활용한 SCAN이 단순 FULL SCAN보다 더 성능이 나쁠 수도 있다.
    2) 인덱스가 많을수록 저장공간을 잡아먹는다. 즉, 인덱스를 많이 만들수록 
    저장공간이 부족해질 수 있다
    3) DML에 취약하다
    INSERT, UPDATE, DELETE등 데이터가 새롭게 추가 및 삭제되면 인덱스 테이블
    안에 있는 값들을 다시 정렬하고 물리적 주소를 수정해줘야 할 수 있다.
     -> 주기적으로 INDEX를 삭제 후 재생성해줘야 최적화된 INDEX를 사용할 수 있다
*/