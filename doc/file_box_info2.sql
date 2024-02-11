--
-- fb_node, fb_file 
--
drop table if exists public.fb_file;
drop table if exists public.fb_node;

CREATE TABLE IF NOT EXISTS public.fb_node (
    node_id serial not null,
    node_type char(1) NOT NULL CHECK (node_type IN ('D', 'F', 'L')), -- D: dir, F:file, L:link 
    parent_id int not null,
    owner_id varchar(30) NOT NULL,
    node_name varchar(300)  null, 
    owner_auth char(3) NOT NULL DEFAULT 'RWX',
    group_auth char(3) NOT NULL DEFAULT 'RWX',
    guest_auth char(3) NOT NULL DEFAULT 'RWX',
    create_on timestamp not null default current_timestamp,
    create_by varchar(30) null,
    CONSTRAINT pk_node PRIMARY KEY(node_id),
    CONSTRAINT fk_parent_id FOREIGN KEY(parent_id) REFERENCES public.fb_node(node_id) ON DELETE RESTRICT,
    CONSTRAINT uq_parent_id_name UNIQUE (parent_id, node_name)
);
COMMENT ON TABLE public.fb_node IS '���ϵ��丮';
COMMENT ON COLUMN public.fb_node.node_id IS 'Id';
COMMENT ON COLUMN public.fb_node.node_type IS 'nodeŸ��';
COMMENT ON COLUMN public.fb_node.parent_id IS '�θ�id';
COMMENT ON COLUMN public.fb_node.owner_id IS ' ������id';
COMMENT ON COLUMN public.fb_node.node_name IS '���Ϲڽ���';
COMMENT ON COLUMN public.fb_node.owner_auth IS '�����ڱ���';
COMMENT ON COLUMN public.fb_node.group_auth IS 'group����';
COMMENT ON COLUMN public.fb_node.guest_auth IS 'guest����';
COMMENT ON COLUMN public.fb_node.create_on IS '�����ð�';
COMMENT ON COLUMN public.fb_node.create_by IS '������';


-- fb_file
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
COMMENT ON TABLE public.fb_file IS '��������(����)';
COMMENT ON COLUMN public.fb_file.file_id IS 'file id';
COMMENT ON COLUMN public.fb_file.node_id IS 'node id';
COMMENT ON COLUMN public.fb_file.phy_folder IS '��������path';
COMMENT ON COLUMN public.fb_file.phy_name IS '���������ϸ�';
COMMENT ON COLUMN public.fb_file.org_name IS '�������ϸ�';
COMMENT ON COLUMN public.fb_file.mime_type IS 'mime type';
COMMENT ON COLUMN public.fb_file.file_size IS '����ũ��';
COMMENT ON COLUMN public.fb_file.ext IS 'Ȯ����';
COMMENT ON COLUMN public.fb_file.note IS '����';
COMMENT ON COLUMN public.fb_file.width IS '�̹�������';
COMMENT ON COLUMN public.fb_file.height IS '�̹�������';
COMMENT ON COLUMN public.fb_file.status IS '����: D  deleted, N : Normal';
COMMENT ON COLUMN public.fb_file.create_on IS '�����ð�';
COMMENT ON COLUMN public.fb_file.create_by IS '������ ID';

INSERT INTO public.fb_node (node_id, node_type,parent_id,owner_id,node_name,create_by )
SELECT 0, 'D',0,'system','ROOT','system';


INSERT INTO public.fb_node (node_type,parent_id,owner_id,node_name,create_by )
SELECT 'D',0,'kdy987','Kim Do Young','kdy987' UNION ALL
SELECT 'D',0,'admin','Admin','admin'   
;
SELECT * FROM public.fb_node fn WHERE node_id = 20;
SELECT * FROM public.fb_file ff WHERE node_id = 34;
SELECT * FROM public.fb_node WHERE node_type = 'F' AND parent_id = 20;
--
-- board, board_file, board_tag_match, tags 
-- 
DROP TABLE IF EXISTS public.board_tag_match;
DROP TABLE IF EXISTS public.tags;
drop table if exists public.board_file;
drop table if exists public.board;

CREATE table if not exists public.board(
	board_id serial NOT NULL,
	board_type char(1) not null default '1', /** 9: ����, 1: �ϹݰԽù�*/ 
	title varchar(200) not null,
	content text not null,
	view_count int NOT NULL DEFAULT 0,
	start_ymd varchar(8) not null default  TO_CHAR(NOW(), 'YYYYMMDD'), /*�Խý�����*/
	end_ymd varchar(8) not null default '99991231', /*�Խ�������*/
	status char(1) not null default '0', /* 0: �ۼ���, 1:�Խ� */
	last_modify_on timestamp null,
	modify_count int NOT NULL DEFAULT 0,
	create_on timestamp not null default current_timestamp,
	create_by varchar(30) null,	
	CONSTRAINT pk_board1 PRIMARY KEY (board_id)
);
COMMENT ON TABLE public.board IS '�Խ���';
COMMENT ON COLUMN public.board.board_id IS '�Խ���id';
COMMENT ON COLUMN public.board.board_type IS '�Խù����� 9:����, 1.�ϹݰԽù�';
COMMENT ON COLUMN public.board.title IS '����';
COMMENT ON COLUMN public.board.content IS '����';
COMMENT ON COLUMN public.board.view_count IS '��ȸȽ��';
COMMENT ON COLUMN public.board.start_ymd IS '�Խý�����';
COMMENT ON COLUMN public.board.end_ymd IS '�Խ�������';
COMMENT ON COLUMN public.board.status IS '����:0�ۼ���, 1�Խ�';
COMMENT ON COLUMN public.board.last_modify_on IS '���������Ͻ�';
COMMENT ON COLUMN public.board.modify_count IS '����Ƚ��';
COMMENT ON COLUMN public.board.create_on IS '�ۼ��Ͻ�';
COMMENT ON COLUMN public.board.create_by IS '�ۼ���id';



CREATE table if not exists public.board_file (
	board_file_id serial NOT NULL,
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
COMMENT ON TABLE public.board_file IS '÷������';
COMMENT ON COLUMN public.board_file.board_file_id IS 'board file id';
COMMENT ON COLUMN public.board_file.board_id IS '�Խ��� id';
COMMENT ON COLUMN public.board_file.seq IS '����';
COMMENT ON COLUMN public.board_file.phy_folder IS '������������';
COMMENT ON COLUMN public.board_file.phy_name IS '���������ϸ�';
COMMENT ON COLUMN public.board_file.org_name IS '�������ϸ�';
COMMENT ON COLUMN public.board_file.mime_type IS 'mimetype';
COMMENT ON COLUMN public.board_file.file_size IS 'file size';
COMMENT ON COLUMN public.board_file.ext IS 'Ȯ����';
COMMENT ON COLUMN public.board_file.note IS '��Ʈ';
COMMENT ON COLUMN public.board_file.create_on IS '�����Ͻ�';
COMMENT ON COLUMN public.board_file.create_by IS '������id';

-- tags

CREATE table if not exists public.tags (
	tag_id serial NOT NULL,
	use_count int NOT NULL DEFAULT 1,
	last_use_on timestamp NOT NULL DEFAULT current_timestamp,
	name varchar(100) NOT null  CONSTRAINT tag_must_1 UNIQUE,
	CONSTRAINT pk_tags PRIMARY KEY (tag_id)
);
COMMENT ON TABLE public.tags IS '�Խ����±׸�ġ';
COMMENT ON COLUMN public.tags.tag_id IS 'board id';
COMMENT ON COLUMN public.tags.use_count IS '����� Ƚ��';
COMMENT ON COLUMN public.tags.name IS 'tag name';


CREATE table if not exists public.board_tag_match (
	board_id int NOT NULL,
	tag_id int NOT NULL,
	CONSTRAINT pk_board_tag_match PRIMARY KEY (board_id, tag_id)
);
COMMENT ON TABLE public.board_tag_match IS '�Խ����±׸�ġ';
COMMENT ON COLUMN public.board_tag_match.board_id IS 'board id';
COMMENT ON COLUMN public.board_tag_match.tag_id IS 'tag id';


SELECT * FROM public.board  ;
SELECT * FROM public.board_file ;
SELECT * FROM public.board_tag_match btm ;
SELECT * FROM public.tags t ;
--DELETE FROM public.tags;
	select 
		  B.board_file_id AS boardFileId
		, B.seq 		  AS seq   
		, B.phy_folder    AS phyFolder   
		, B.phy_name      AS phyName     
		, B.org_name      AS orgName     
		, B.mime_type     AS mimeType    
		, B.file_size     AS fileSize    
		, B.ext           AS ext         
		, B.note          AS note        
		, B.create_on     AS createOn    
		, B.create_by     AS createBy
	from 
		board_file B 
	where 1=1
		and B.board_id  = 7
	order by B.seq   ;

SELECT COALESCE (max(seq),0) + 1 AS nextSeq FROM board_file WHERE board_id = 6;
