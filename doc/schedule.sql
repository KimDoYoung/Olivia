-- public.schedule definition

-- Drop table

DROP TABLE public.schedule;

CREATE TABLE public.schedule (
	id serial4 NOT NULL,
	lunar_or_solar bpchar(1) NULL,
	repeat_option bpchar(1) NULL,
	ymd varchar(8) NOT NULL,
	"content" varchar(100) NOT NULL,
	created_by varchar(30) NOT NULL,
	created_on timestamp NULL DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT schedule_created_by_check CHECK ((length((created_by)::text) <= 30)),
	CONSTRAINT schedule_lunar_or_solar_check CHECK ((lunar_or_solar = ANY (ARRAY['S'::bpchar, 'M'::bpchar]))),
	CONSTRAINT schedule_pkey PRIMARY KEY (id),
	CONSTRAINT schedule_repeat_option_check CHECK ((repeat_option = ANY (ARRAY['Y'::bpchar, 'M'::bpchar, 'S'::bpchar])))
);

SELECT * FROM public.schedule s 
WHERE 
	CASE repeat_option 
		WHEN 'S' THEN ymd >= TO_CHAR(CURRENT_DATE, 'YYYYMMDD')
		ELSE TRUE
	END
;

DROP TABLE IF EXISTS public.special_day;
CREATE TABLE IF NOT EXISTS public.special_day (
    loc_date VARCHAR(8) NOT NULL,
    seq INT NOT NULL,
    date_kind CHAR(2),
    holiday_yn CHAR(1),
    date_name VARCHAR(50),
	created_by varchar(30) NOT NULL,
	created_on timestamp NULL DEFAULT CURRENT_TIMESTAMP,    
    PRIMARY KEY (loc_date, seq)
);

COMMENT ON TABLE special_day IS 'Ư���� ��¥ ������ �����ϴ� ���̺�';
COMMENT ON COLUMN special_day.loc_date IS '��¥';
COMMENT ON COLUMN special_day.seq IS '����';
COMMENT ON COLUMN special_day.date_kind IS '����';
COMMENT ON COLUMN special_day.holiday_yn IS '������� ���Ͽ���';
COMMENT ON COLUMN special_day.date_name IS '��Ī';
COMMENT ON COLUMN special_day.created_by IS '������';
COMMENT ON COLUMN special_day.created_on IS '�����Ͻ�';