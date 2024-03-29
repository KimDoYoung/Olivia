drop sequence sys_seq;
CREATE SEQUENCE sys_seq START 1;

-- 다시 설계한다. 늦었다고 생각하는 그 순간이 가장 빠른 때이다!
-- fb_node
drop table if exists public.fb_node;
CREATE TABLE IF NOT EXISTS public.fb_node (
    node_id serial not null,
    node_type char(1) NOT NULL CHECK (node_type IN ('D', 'F', 'L')), -- D: dir, F:file, L:link 
    parent_id int not null,
    owner_id varchar(30) NOT NULL,
    node_name varchar(300) not null,
    owner_auth char(3) NOT NULL DEFAULT 'RWX',
    group_auth char(3) NOT NULL DEFAULT 'RWX',
    guest_auth char(3) NOT NULL DEFAULT 'RWX',
    create_on timestamp not null default current_timestamp,
    create_by varchar(30) null,
    CONSTRAINT pk_node PRIMARY KEY(node_id),
    CONSTRAINT fk_parent_id FOREIGN KEY(parent_id) REFERENCES public.fb_node(node_id) ON DELETE RESTRICT,
    CONSTRAINT uq_parent_id_name UNIQUE (parent_id, node_name)
);
COMMENT ON TABLE public.fb_node IS '파일디렉토리';
COMMENT ON COLUMN public.fb_node.node_id IS 'Id';
COMMENT ON COLUMN public.fb_node.node_type IS 'node타입';
COMMENT ON COLUMN public.fb_node.parent_id IS '부모id';
COMMENT ON COLUMN public.fb_node.owner_id IS ' 소유자id';
COMMENT ON COLUMN public.fb_node.node_name IS '파일박스명';
COMMENT ON COLUMN public.fb_node.owner_auth IS '소유자권한';
COMMENT ON COLUMN public.fb_node.group_auth IS 'group권한';
COMMENT ON COLUMN public.fb_node.guest_auth IS 'guest권한';
COMMENT ON COLUMN public.fb_node.create_on IS '생성시간';
COMMENT ON COLUMN public.fb_node.create_by IS '생성자';


-- fb_file
drop table if exists public.fb_file;
CREATE table if not exists public.fb_file (
	file_id serial NOT NULL,
	node_id int4 NOT NULL,
	phy_folder varchar(300) NOT NULL,
	phy_name varchar(300) NOT NULL,
	org_name varchar(300) not NULL,
	mime_type varchar(100) NULL,
	file_size int4 NULL,
	ext varchar(50) NULL,
	note varchar(1000) NULL,
	width int4 null,
	height int4 null,
	status char(1) NOT NULL DEFAULT 'N', -- 'N' normal, 'D' :  deleted 
	create_on timestamp not null default current_timestamp,
	create_by varchar(30) null,
	CONSTRAINT pk_fb_file PRIMARY KEY (file_id),
	constraint fk_node_id  foreign key(node_id) REFERENCES fb_node(node_id) ON DELETE RESTRICT
);
COMMENT ON TABLE public.fb_file IS '파일정보(파일)';
COMMENT ON COLUMN public.fb_file.file_id IS 'file id';
COMMENT ON COLUMN public.fb_file.node_id IS 'node id';
COMMENT ON COLUMN public.fb_file.phy_folder IS '저장폴더path';
COMMENT ON COLUMN public.fb_file.phy_name IS '물리적파일명';
COMMENT ON COLUMN public.fb_file.org_name IS '원래파일명';
COMMENT ON COLUMN public.fb_file.mime_type IS 'mime type';
COMMENT ON COLUMN public.fb_file.file_size IS '파일크기';
COMMENT ON COLUMN public.fb_file.ext IS '확장자';
COMMENT ON COLUMN public.fb_file.note IS '설명';
COMMENT ON COLUMN public.fb_file.width IS '이미지넓이';
COMMENT ON COLUMN public.fb_file.height IS '이미지높이';
COMMENT ON COLUMN public.fb_file.status IS '상태: D  deleted, N : Normal';
COMMENT ON COLUMN public.fb_file.create_on IS '생성시각';
COMMENT ON COLUMN public.fb_file.create_by IS '생성자 ID';

-- ************************************************************************* --
-- ************************************************************************* --
-- ************************************************************************* --
-- ************************************************************************* --
-- ************************************************************************* --




--
-- filebox : directory에 해당한다
--
drop table if exists public.fb_file;
create table if not exists public.fb_file (
	filebox_id serial not null,
	parent_id int not null,
	folder_nm varchar(300) not null,
	note varchar(1000) null,
	create_on timestamp not null default current_timestamp,
	create_by varchar(30) null,
	constraint pk_file_box primary key(box_id),
	CONSTRAINT unique_parent_id_name UNIQUE (parent_id, folder_nm)
);
COMMENT ON TABLE public.file_box IS '파일박스(디렉토리)';
COMMENT ON COLUMN public.file_box.box_id IS 'Id';
COMMENT ON COLUMN public.file_box.parent_id IS '부모id';
COMMENT ON COLUMN public.file_box.folder_nm IS '파일박스명';
COMMENT ON COLUMN public.file_box.note IS '설명';
COMMENT ON COLUMN public.file_box.create_on IS '생성시간';
COMMENT ON COLUMN public.file_box.create_by IS '생성자';

-- file_info : file에 해당한다
drop table if exists public.file_info;
CREATE table if not exists public.file_info (
	file_info_id serial NOT NULL,
	box_id int4 NOT NULL,
	phy_folder varchar(300) NOT NULL,
	phy_name varchar(300) NOT NULL,
	org_name varchar(300) not NULL,
	mime_type varchar(100) NULL,
	file_size int4 NULL,
	ext varchar(50) NULL,
	note varchar(1000) NULL,
	width int4 null,
	height int4 null,
	status char(1) null, -- 'D' :  deleted 
	create_on timestamp not null default current_timestamp,
	create_by varchar(30) null,
	CONSTRAINT pk_file_info PRIMARY KEY (file_info_id),
	constraint fk_box_id  foreign key(box_id) REFERENCES file_box(box_id) ON DELETE RESTRICT
);
COMMENT ON TABLE public.file_info IS '파일정보(파일)';
COMMENT ON COLUMN public.file_info.file_info_id IS 'file id';
COMMENT ON COLUMN public.file_info.box_id IS 'box id';
COMMENT ON COLUMN public.file_info.phy_folder IS '저장폴더path';
COMMENT ON COLUMN public.file_info.phy_name IS '물리적파일명';
COMMENT ON COLUMN public.file_info.org_name IS '원래파일명';
COMMENT ON COLUMN public.file_info.mime_type IS 'mime type';
COMMENT ON COLUMN public.file_info.file_size IS '파일크기';
COMMENT ON COLUMN public.file_info.ext IS '확장자';
COMMENT ON COLUMN public.file_info.note IS '설명';
COMMENT ON COLUMN public.file_info.width IS '이미지넓이';
COMMENT ON COLUMN public.file_info.height IS '이미지높이';
COMMENT ON COLUMN public.file_info.status IS '상태: D  deleted, N : Normal';
COMMENT ON COLUMN public.file_info.create_on IS '생성시각';
COMMENT ON COLUMN public.file_info.create_by IS '생성자 ID';

--
-- file_match :  융통성을 위해서 
--
drop table if exists public.file_match;
CREATE table if not exists public.file_match(
	box_id int4 NOT NULL,
	file_info_id int4 NOT NULL,
	CONSTRAINT pk_board PRIMARY KEY (box_id,file_info_id)
);

COMMENT ON TABLE public.file_match IS '파일박스파일Match';
COMMENT ON COLUMN public.file_match.box_id IS 'box id';
COMMENT ON COLUMN public.file_match.file_info_id IS 'file id';

select * from public.file_box fb ;
insert into public.file_box (folder_nm,parent_id) values('해외영업부',1);
insert into public.file_box (folder_nm,parent_id) values('개발부',1);
select * from public.file_box fb ;

--
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
	last_modify_on timestamp null,
	modify_count int null,
	create_on timestamp not null default current_timestamp,
	create_by varchar(30) null,	
	CONSTRAINT pk_board1 PRIMARY KEY (board_id)
);
COMMENT ON TABLE public.board IS '게시판';
COMMENT ON COLUMN public.board.board_id IS '게시판id';
COMMENT ON COLUMN public.board.board_type IS '게시물종류 9:공지, 1.일반게시물';
COMMENT ON COLUMN public.board.title IS '제목';
COMMENT ON COLUMN public.board.content IS '내용';
COMMENT ON COLUMN public.board.view_count IS '조회횟수';
COMMENT ON COLUMN public.board.start_ymd IS '게시시작일';
COMMENT ON COLUMN public.board.end_ymd IS '게시종료일';
COMMENT ON COLUMN public.board.status IS '상태:0작성중, 1게시';
COMMENT ON COLUMN public.board.last_modify_on IS '최종수정일시';
COMMENT ON COLUMN public.board.modify_count IS '수정횟수';
COMMENT ON COLUMN public.board.create_on IS '작성일시';
COMMENT ON COLUMN public.board.create_by IS '작성자id';

drop table if exists public.board_file_match;
--CREATE table if not exists public.board_file_match(
--	board_id int NOT NULL,
--	board_file_id int not null,
--	seq int not null,
--	deleted_yn char(1) not null default 'N',
--	CONSTRAINT pk_file_match PRIMARY KEY (board_id, board_file_id)
--);
--COMMENT ON TABLE public.board_file_match IS '게시판파일매치';
--COMMENT ON COLUMN public.board_file_match.board_id IS '게시판id';
--COMMENT ON COLUMN public.board_file_match.board_file_id IS 'file id';
--COMMENT ON COLUMN public.board_file_match.board_id IS '순번';
--COMMENT ON COLUMN public.board_file_match.board_id IS '삭제여부';


drop table if exists public.board_file;
CREATE table if not exists public.board_file (
	board_file_id int NOT NULL,
	board_id int NOT NULL, 
	seq int NOT NULL, 
	phy_folder varchar(500) not null,
	phy_name varchar(300) NOT NULL,
	org_name varchar(200) not NULL,
	mime_type varchar(100) NULL,
	file_size int4 NULL,
	ext varchar(50) NULL,
	note varchar(1000) NULL,
	create_on timestamp not null default current_timestamp,
	create_by varchar(30) null,
	CONSTRAINT pk_board_file PRIMARY KEY (board_file_id),
	constraint fk_board_id  foreign key(board_id) REFERENCES board(board_id) ON DELETE CASCADE
);
COMMENT ON TABLE public.board_file IS '첨부파일';
COMMENT ON COLUMN public.board_file.board_file_id IS 'board file id';
COMMENT ON COLUMN public.board_file.board_id IS '게시판 id';
COMMENT ON COLUMN public.board_file.seq IS '순서';
COMMENT ON COLUMN public.board_file.phy_folder IS '물리적폴더명';
COMMENT ON COLUMN public.board_file.phy_name IS '물리적파일명';
COMMENT ON COLUMN public.board_file.org_name IS '원래파일명';
COMMENT ON COLUMN public.board_file.mime_type IS 'mimetype';
COMMENT ON COLUMN public.board_file.file_size IS 'file size';
COMMENT ON COLUMN public.board_file.ext IS '확장자';
COMMENT ON COLUMN public.board_file.note IS '노트';
COMMENT ON COLUMN public.board_file.create_on IS '생성일시';
COMMENT ON COLUMN public.board_file.create_by IS '생성자id';


DROP TABLE IF EXISTS public.board_tag_match;
CREATE table if not exists public.board_tag_match (
	board_id int NOT NULL,
	tag_id int NOT NULL,
	CONSTRAINT pk_board_tag_match PRIMARY KEY (board_id, tag_id),
	constraint fk_board_id  foreign key(board_id) REFERENCES board(board_id) ON DELETE RESTRICT
	constraint fk_tag_id  foreign key(tag_id) REFERENCES tags(tag_id) ON DELETE RESTRICT
);
COMMENT ON TABLE public.board_tag_match IS '게시판태그매치';
COMMENT ON COLUMN public.board_tag_match.board_id IS 'board id';
COMMENT ON COLUMN public.board_tag_match.tag_id IS 'tag id';



DROP TABLE IF EXISTS public.tags;
CREATE table if not exists public.tags (
	tag_id int NOT NULL,
	name varchar(100) NOT null  CONSTRAINT tag_must_1 UNIQUE,
	CONSTRAINT pk_tags PRIMARY KEY (tag_id)
);
COMMENT ON TABLE public.tags IS '게시판태그매치';
COMMENT ON COLUMN public.tags.tag_id IS 'board id';
COMMENT ON COLUMN public.tags.name IS 'tag name';

--select * from public.board_tag;
--select * from public.board_tag_match ;
--select * from public.board_file ;
--select * from public.board_file_match ;
--select * from public.board ;
-- 
--
--delete from public.board_tag;
--delete from public.board_tag_match ;
--delete from public.board_file ;
--delete from public.board_file_match ;
--delete from public.board ;
--
--
--INSERT INTO public.board_file_match (board_id, board_file_id, seq, deleted_yn ) VALUES (12, 13, 1, 'N');
