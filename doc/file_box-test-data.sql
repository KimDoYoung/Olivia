select * from file_box;
select * from file_info ;
select * from file_match ;
delete from file_box;
ALTER TABLE public.file_box ALTER COLUMN box_id SET DEFAULT 1;
insert into public.file_box (box_id,folder_nm, parent_id, note,create_by) values(1,'ROOT',0, 'ROOT', 'System');
insert into public.file_box (box_id,folder_nm, parent_id, note,create_by) values(2,'해외영업부',1, NULL, 'System');
insert into public.file_box (box_id,folder_nm, parent_id, note,create_by) values(3,'개발부',1, NULL, 'System');
insert into public.file_box (box_id,folder_nm, parent_id, note,create_by) values(4,'총무부',1, NULL, 'System');
insert into public.file_box (box_id,folder_nm, parent_id, note,create_by) values(5,'walmart',2, NULL, 'System');
insert into public.file_box (box_id,folder_nm, parent_id, note,create_by) values(6,'kroger',2, NULL, 'System');
insert into public.file_box (box_id,folder_nm, parent_id, note,create_by) values(7,'망고',5, NULL, 'System');
insert into public.file_box (box_id,folder_nm, parent_id, note,create_by) values(8,'파인애플',5, NULL, 'System');
insert into public.file_box (box_id,folder_nm, parent_id, note,create_by) values(9,'감귤',5, NULL, 'System');
insert into public.file_box (box_id,folder_nm, parent_id, note,create_by) values(10,'망고',6, NULL, 'System');
insert into public.file_box (box_id,folder_nm, parent_id, note,create_by) values(11,'파인애플',7, NULL, 'System');
insert into public.file_box (box_id,folder_nm, parent_id, note,create_by) values(12,'감귤',8, NULL, 'System');
--개발부
insert into public.file_box (box_id,folder_nm, parent_id, note,create_by) values(13,'홈페이지팀',3, NULL, 'System');
insert into public.file_box (box_id,folder_nm, parent_id, note,create_by) values(14,'제품팀',3, NULL, 'System');
insert into public.file_box (box_id,folder_nm, parent_id, note,create_by) values(15,'Julia',3, NULL, 'System');

WITH RECURSIVE subfolders (box_id, parent_id, folder_nm, note, create_on, create_by, level, path, cycle) 
AS(
   SELECT f.box_id, f.parent_id, f.folder_nm, f.note,f.create_on, f.create_by, 0, ARRAY[f.box_id], false
   FROM public.file_box f
   WHERE f.parent_id = 5   
   UNION ALL
   SELECT d.box_id, d.parent_id, d.folder_nm, d.note,d.create_on, d.create_by, level + 1, path || d.box_id, d.box_id = ANY(path)
   FROM public.file_box d, subfolders s
   WHERE d.parent_id = s.box_id
   AND NOT CYCLE
)
SELECT box_id, parent_id, folder_nm, note, create_on, create_by, level, path 
FROM subfolders
--where parent_id = 1
ORDER BY path
;
