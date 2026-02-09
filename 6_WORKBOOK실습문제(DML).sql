 -- 1. 과목유형 테이블(TB_CLASS_TYPE)에 데이터 입력
INSERT INTO TB_CLASS_TYPE VALUES(01,'전공필수');
INSERT INTO TB_CLASS_TYPE VALUES(02,'전공선택');
INSERT INTO TB_CLASS_TYPE VALUES(03,'교양필수');
INSERT INTO TB_CLASS_TYPE VALUES(04,'교양선택');
INSERT INTO TB_CLASS_TYPE VALUES(05,'논문지도');

-- 2. 대학교 학생들의 정보가 포함된 학생일반정보 테이블을 만들고자 한다
-- 서브쿼리를 이용
CREATE TABLE TB_학생일반정보
AS SELECT STUDENT_NO 학번 , STUDENT_NAME 학생이름
, STUDENT_ADDRESS 주소 FROM TB_STUDENT;

-- 3. 국어국문학과 학생들의 정보만 포함되어 있는 학과정보 테이블 생성
-- 테이블이름 : TB_국어국문학과
-- 컬럼 : 학번, 학생이름, 출생년도(네자리 년도 표기), 교수이름
CREATE TABLE TB_국어국문학과
AS SELECT STUDENT_NO 학번, STUDENT_NAME 학생이름,
'19' || SUBSTR(STUDENT_SSN,1,2) 출생년도, PROFESSOR_NAME 교수이름
FROM TB_STUDENT
JOIN TB_DEPARTMENT D USING (DEPARTMENT_NO)
LEFT JOIN TB_PROFESSOR ON (COACH_PROFESSOR_NO = PROFESSOR_NO)
WHERE D.DEPARTMENT_NAME = '국어국문학과';

-- 4. 현 학과들의 정원을 10% 증가시키게 되었다 이에 사용할 SQL 작성
-- 반올림 사용하여 소수점 X
UPDATE TB_DEPARTMENT
SET CAPACITY = ROUND(CAPACITY * 1.1);

-- 5. 학번 A413042인 박건우 학생의 주소 변경 
-- 변경 주소 : "서울시 종로구 숭인동 181-21"
UPDATE TB_STUDENT
SET STUDENT_ADDRESS = '서울시 종로구 숭인동 181-21'
WHERE STUDENT_NO = 'A413042';

-- 6. 주민등록번호 보호법에 따라 학생정보 테이블에서 주민번호 뒷자리 저장 X
UPDATE TB_STUDENT
SET STUDENT_SSN = SUBSTR(STUDENT_SSN,1,6);

-- 7. 의학과 김명훈 학생은 2005년 1학기에 자신이 수강학 '피부생리학' 점수가 
-- 잘못되었다는 것을 발견하고 정정 요청. -> 3.5
UPDATE TB_GRADE
SET POINT = 3.5
WHERE CLASS_NO = (
    SELECT CLASS_NO
    FROM TB_CLASS
    WHERE CLASS_NAME = '피부생리학'
)
AND SUBSTR(TERM_NO,1,6) = '200501';

-- 8. 성적 테이블(TB_GRADE) 에서 휴학생들의 성적항목 제거
SELECT * 
FROM TB_GRADE
WHERE STUDENT_NO IN (
    SELECT STUDENT_NO
    FROM TB_STUDENT
    WHERE ABSENCE_YN = 'N'
);
