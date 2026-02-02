/*
    오라클 계정 생성 문법
     - CREATE USER 계정명 IDENTIFIED BY 비밀번호;
     - 오라클에서 사용자계정을 만들 수 있는 권한은 관리자계정에만 존재
*/
CREATE USER KH IDENTIFIED BY KH;

-- 생성된 계정에 최소한의 작업 권한 부여하기
-- 부여할 권한 : 오라클서버 "접속"권한, 데이터 관리 권한
-- [표현법] : GRANT 권한1, 권한2, ... TO 계정명;
GRANT CONNECT , RESOURCE TO KH;

-- 관리자계정 : DB의 생성과 관리를 담당하는 계정, 모든 권한과 책임을 가지는 계정
-- 사용자계정 : DB에 대해서 질의, 갱신, 보고서 작성등 작업을 수행할 수 있는 계정
--             업무에 필요한 "최소한의 권한"을 가지는 것을 원칙으로 한다.

-- ROLE권한 
-- CONNECT : 사용자가 데이터베이스에 접속 가능하게 하기 위한 CREATE SESSION 권한이 담긴
--           ROLE 권한
-- RESOURCE : CREATE구문을 통해 다양한 객체를 생성할 수 있는 권한과 
--            DML구문을 사용할 수 있는 권한을 묶어둔 ROLE권한