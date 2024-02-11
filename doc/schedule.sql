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

COMMENT ON TABLE special_day IS '특별한 날짜 정보를 저장하는 테이블';
COMMENT ON COLUMN special_day.loc_date IS '날짜';
COMMENT ON COLUMN special_day.seq IS '순번';
COMMENT ON COLUMN special_day.date_kind IS '종류';
COMMENT ON COLUMN special_day.holiday_yn IS '공공기관 휴일여부';
COMMENT ON COLUMN special_day.date_name IS '명칭';
COMMENT ON COLUMN special_day.created_by IS '생성자';
COMMENT ON COLUMN special_day.created_on IS '생성일시';