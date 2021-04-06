-- Задание: 51 (Fiolent: 2004-06-23)
-- Найти квадраты, которые окрашивались не менее 3 раз подряд
--     баллончиками одного и того
-- же цвета. При одновременной окраске считать, что баллончики
--     используются в порядке
-- возрастания их номеров. Вывести номер квадрата,
-- цвет и количество окрасок подряд этим цветом (группа),
--     дата-время первой окраски в этой группе, дата-время последней окраски в этой группе.
INSERT INTO utb(b_datetime, b_q_id, b_v_id, b_vol)
VALUES ('2003-01-01 01:12:11.000', '4', '37', '1');
INSERT INTO utb(b_datetime, b_q_id, b_v_id, b_vol)
VALUES ('2003-01-01 01:12:15.000', '4', '37', '1');
INSERT INTO utb(b_datetime, b_q_id, b_v_id, b_vol)
VALUES ('2003-01-01 01:12:16.000', '4', '37', '1');
INSERT INTO utb(b_datetime, b_q_id, b_v_id, b_vol)
VALUES ('2003-01-01 01:12:17.000', '4', '9', '1');
INSERT INTO utb(b_datetime, b_q_id, b_v_id, b_vol)
VALUES ('2003-01-01 01:12:18.000', '4', '37', '1');
INSERT INTO utb(b_datetime, b_q_id, b_v_id, b_vol)
VALUES ('2003-01-01 01:12:19.000', '4', '37', '1');
INSERT INTO utb(b_datetime, b_q_id, b_v_id, b_vol)
VALUES ('2003-01-01 01:12:20.000', '4', '37', '1');
INSERT INTO utb(b_datetime, b_q_id, b_v_id, b_vol)
VALUES ('2003-01-01 01:13:14.000', '16', '42', '1');

with res_color as (
    select B_DATETIME as datetime, b_q_id as qid, B_V_ID as vid, b_vol as vol, V_COLOR as color
    from utB
             inner join utV on utv.V_ID = utB.B_V_ID),
     res as (
         select qid,
                row_number() over (order by qid,datetime,vid)                        as num,
                row_number() over (partition by qid,color order by qid,datetime,vid) as numb,
                row_number() over (order by qid,datetime)                            as number,
                row_number() over (order by qid,datetime,color,vid) -
                row_number() over (partition by qid,color order by qid,datetime,vid) as diff,
                color,
                vid,
                datetime
         from res_color),
     res_end as (
         select qid, count(diff) as cnt, diff
         from res
         group by qid, diff
         having count(diff) > 2),
     new as (
         select res.qid, datetime, color, cnt, res.diff
         from res
                  inner join res_end on res_end.qid = res.qid and res.diff = res_end.diff)
select vid,
       qid,
       color,
       datetime,
       color,
       count(*) over (order by qid,datetime,vid rows between 1 preceding and 1 following) as cnt
from res_color;


select distinct qid,
                color,
                cnt,
                (select min(datetime) from new where new.qid = res_new.qid and new.diff = res_new.diff) as min,
                (select max(datetime) from new where new.qid = res_new.qid and new.diff = res_new.diff) as max
from new as res_new;


with res as (SELECT i, f, RN = ROW_NUMBER() OVER (ORDER BY I) - ROW_NUMBER() OVER (PARTITION BY f ORDER BY i)
             FROM #t1)
SELECT i, f, RN, N = MAX(I) OVER (PARTITION BY f, RN) - MIN(I) OVER (PARTITION BY f, RN) + 1
FROM res
ORDER BY i;

with res_color as (
    select B_DATETIME as datetime, b_q_id as qid, B_V_ID as vid, b_vol as vol, V_COLOR as color
    from utB
             inner join utV on utv.V_ID = utB.B_V_ID),
     res as (
         select qid,
                row_number() over (order by qid,datetime,vid)                        as num,
                row_number() over (partition by qid,color order by qid,datetime,vid) as numb,
                row_number() over (order by qid,datetime)                            as number,
                row_number() over (order by qid,datetime,color,vid) -
                row_number() over (partition by qid,color order by qid,datetime,vid) as diff,
                color,
                vid,
                datetime
         from res_color),
     res_row as (
         select row_number() over (partition by qid order by qid,datetime,vid)            num,
                qid,
                vid,
                color,
                datetime,
                count(color) over (partition by qid order by color range current row ) as cnt
         from res_color
     ),
     res_end as (
         select qid, count(diff) as cnt, diff
         from res
         group by qid, diff
         having count(diff) > 2),
     new as (
         select res.qid, datetime, color, cnt, res.diff
         from res
                  inner join res_end on res_end.qid = res.qid and res.diff = res_end.diff)
select num,
       qid,
       vid,
       color,
       datetime,
       dense_rank() over (partition by qid,color order by datetime,vid)       as rank,
       count(color) over (partition by qid order by color range current row ) as cnt,
       min(num) over (partition by qid order by color range current row )     as min_num,
       max(num) over (partition by qid order by color range current row )     as max_num,
       max(num) over (partition by qid order by color range current row ) -
       min(num) over (partition by qid order by color range current row ) + 1 as diff
from res_row;

select row_number() over (partition by qid order by qid,datetime,vid)                     num,
       qid,
       vid,
       color,
       datetime,
       color,
       count(color) over (partition by qid order by color range current row )          as cnt,
       count(color) over (partition by qid,datetime order by color range current row ) as cnt,
       min() over (partition by qid order by color range current row ),
       max(datetime) over (partition by qid order by color range current row )
from res_color;
with res_color as (
    select B_DATETIME as datetime, b_q_id as qid, B_V_ID as vid, b_vol as vol, V_COLOR as color
    from utB
             inner join utV on utv.V_ID = utB.B_V_ID),
     res_row as (
         select row_number() over (order by qid,datetime,vid) num,
                res_color.qid,
                vid,
                color,
                datetime
         from res_color)
select res.num, res.qid, res.vid, res.color, res.datetime, res_row.num
from res_row as res
         left join res_row on res_row.qid = res.qid and res_row.color = res.color and
                              res.datetime < res_row.datetime and res.vid != res_row.vid;

INSERT INTO utb(b_datetime, b_q_id, b_v_id, b_vol) VALUES('2003-01-01 01:13:14.000', '16', '42', '1');
INSERT INTO utb(b_datetime, b_q_id, b_v_id, b_vol) VALUES('2003-01-01 01:13:15.000', '16', '42', '1');
INSERT INTO utb(b_datetime, b_q_id, b_v_id, b_vol) VALUES('2003-01-01 01:13:16.000', '16', '42', '1');
with res_color as (
    select B_DATETIME as datetime, b_q_id as qid, B_V_ID as vid, b_vol as vol, V_COLOR as color
    from utB
             inner join utV on utv.V_ID = utB.B_V_ID),
     res_group as (
         select qid, datetime, min(vid) as vid from res_color group by qid, datetime),
     res_col as (
         select distinct res_group.qid, res_group.datetime, res_group.vid, res_color.color
         from res_group
                  inner join res_color on res_group.vid = res_color.vid),
     res_row as (
         select row_number() over (order by qid,datetime,vid) as                     number,
                row_number() over (partition by qid,color order by qid,datetime,vid) num,
                row_number() over (partition by qid,datetime order by vid)           num_vid,
                row_number() over (order by qid,datetime,vid)                        id,
                qid,
                datetime,
                vid,
                color
         from res_color),
     res_num as (
         select number,
                num,
                num_vid,
                qid,
                datetime,
                vid,
                color,
                id,
                number - num     as color_gr,
                number - num_vid as vid_gr
         from res_row),
     res_cnt as (
         select color_gr,
                vid_gr,
                qid,
                vid,
                color,
                datetime,
                num,
                id,
                count(color_gr) over ( partition by qid order by color_gr range current row ) as cnt
         from res_num),
     res_next as (
         select qid,
                datetime,
                vid,
                color,
                cnt,
                vid_gr,
                id,
                id - row_number() over (partition by qid order by id) as grou
         from res_cnt
         where cnt > 2),
     res_new as (
         select qid,
                datetime,
                vid,
                color,
                cnt,
                vid_gr,
                id,
                grou,
                count(*) over ( partition by qid,grou order by color range current row ) as cnt_control
         from res_next),
     res_end as (
         select qid,
                datetime,
                vid,
                color,
                cnt,
                id,
                grou,
                max(cnt_control) over ( partition by qid,grou order by id) as max_cnt
         from res_new),
     prepare as (
         select qid,
                datetime,
                vid,
                color,
                cnt,
                id,
                grou,
                max_cnt
         from res_end
         where max_cnt = cnt)
select * from prepare;
select distinct qid,
                color,
                cnt,
                min(datetime) over ( partition by qid,grou order by datetime)                                                 as min,
                max(datetime)
                    over ( partition by qid,grou order by datetime rows between unbounded preceding and unbounded following ) as max

from prepare;
