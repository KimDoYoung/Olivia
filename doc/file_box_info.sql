drop sequence sys_seq;
CREATE SEQUENCE sys_seq START 1;
-- directory에 해당한다
drop table if exists public.file_box;
create table if not exists public.file_box (
	box_id int not null,
	parent_id int not null,
	name varchar(300) not null,
	note varchar(1000) null,
	create_on timestamp not null default current_timestamp,
	create_by varchar(30) null,
	constraint pk_file_box primary key(box_id)
);

-- file_info
drop table if exists public.file_info;
CREATE table if not exists public.file_info (
	file_info_id int NOT NULL,
	box_id int NOT NULL,
	phy_name varchar(300) NOT NULL,
	org_name varchar(300) not NULL,
	mime_type varchar(100) NULL,
	file_size int4 NULL,
	ext varchar(50) NULL,
	note varchar(1000) NULL,
	create_on timestamp not null default current_timestamp,
	create_by varchar(30) null,
	CONSTRAINT pk_file_info PRIMARY KEY (file_info_id),
	constraint fk_box_id  foreign key(box_id) REFERENCES file_box(box_id) ON DELETE RESTRICT
);

insert into public.file_box (box_id, name, parent_id) values(nextval('sys_seq'),'ROOT',0);
select * from public.file_box fb ;
insert into public.file_box (name,parent_id) values('해외영업부',1);
insert into public.file_box (name,parent_id) values('개발부',1);
select * from public.file_box fb ;


-- board
--
drop table if exists public.board;
CREATE table if not exists public.board(
	board_id int NOT NULL,
	board_type char(1) not null default '1', /** 9: 공지, 1: 일반게시물*/ 
	title varchar(200) not null,
	content text not null,
	view_count int NOT NULL DEFAULT 0,
	start_ymd varchar(8) not null default  TO_CHAR(NOW(), 'YYYYMMDD'), /*게시시작일*/
	end_ymd varchar(8) not null default '99991231', /*게시종료일*/
	status char(1) not null default '0', /* 0: 작성중, 1:게시 */
	create_on timestamp not null default current_timestamp,
	create_by varchar(30) null,	
	CONSTRAINT pk_board1 PRIMARY KEY (board_id)
);

drop table if exists public.board_file_match;
CREATE table if not exists public.board_file_match(
	board_id int NOT NULL,
	board_file_id int not null,
	seq int not null,
	deleted_yn char(1) not null default 'N',
	CONSTRAINT pk_file_match PRIMARY KEY (board_id, board_file_id)
);

drop table if exists public.board_file;
CREATE table if not exists public.board_file (
	board_file_id int NOT NULL,
	phy_folder varchar(500) not null,
	phy_name varchar(300) NOT NULL,
	org_name varchar(200) not NULL,
	mime_type varchar(100) NULL,
	file_size int4 NULL,
	ext varchar(50) NULL,
	note varchar(1000) NULL,
	create_on timestamp not null default current_timestamp,
	create_by varchar(30) null,
	CONSTRAINT pk_board_file PRIMARY KEY (board_file_id)
);

DROP TABLE IF EXISTS public.board_tag_match;
CREATE table if not exists public.board_tag_match (
	board_id int NOT NULL,
	tag_id int NOT NULL,
	CONSTRAINT pk_board_tag_match PRIMARY KEY (board_id, tag_id)
);
DROP TABLE IF EXISTS public.board_tag;
CREATE table if not exists public.board_tag (
	tag_id int NOT NULL,
	name varchar(100) NOT null  CONSTRAINT tag_must_1 UNIQUE,
	CONSTRAINT pk_board_tag PRIMARY KEY (tag_id)
);

delete from public.board_tag;
delete from public.board_tag_match ;
delete from public.board_file ;
delete from public.board_file_match ;
delete from public.board ;


INSERT INTO public.board_file_match (board_id, board_file_id, seq, deleted_yn ) VALUES (12, 13, 1, 'N');
