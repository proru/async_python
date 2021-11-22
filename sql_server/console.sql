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

INSERT INTO utb(b_datetime, b_q_id, b_v_id, b_vol)
VALUES ('2003-01-01 01:13:14.000', '16', '42', '1');
INSERT INTO utb(b_datetime, b_q_id, b_v_id, b_vol)
VALUES ('2003-01-01 01:13:15.000', '16', '42', '1');
INSERT INTO utb(b_datetime, b_q_id, b_v_id, b_vol)
VALUES ('2003-01-01 01:13:16.000', '16', '42', '1');
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
select *
from prepare;
select qid, datetime, vid, color, num, rsum as sum, rcnt as cnt
from recnt
where rcnt > 2
union
select qid, datetime, vid, color, num, gsum, gcnt
from recnt
where gcnt > 2
union
select qid, datetime, vid, color, num, bsum, bcnt
from recnt
where bcnt > 2;


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
INSERT INTO utb(b_datetime, b_q_id, b_v_id, b_vol)
VALUES ('2003-01-01 01:12:21.000', '4', '9', '1');
INSERT INTO utb(b_datetime, b_q_id, b_v_id, b_vol)
VALUES ('2003-01-01 01:12:22.000', '4', '37', '1');
INSERT INTO utb(b_datetime, b_q_id, b_v_id, b_vol)
VALUES ('2003-01-01 01:12:23.000', '4', '37', '1');
INSERT INTO utb(b_datetime, b_q_id, b_v_id, b_vol)
VALUES ('2003-01-01 01:12:24.000', '4', '37', '1');
INSERT INTO utb(b_datetime, b_q_id, b_v_id, b_vol)
VALUES ('2003-01-01 01:12:25.000', '4', '37', '1');

with res_color as (
    select row_number() over (order by B_Q_ID,B_DATETIME,B_V_ID) num,
           B_DATETIME as                                         datetime,
           b_q_id     as                                         qid,
           B_V_ID     as                                         vid,
           b_vol      as                                         vol,
           V_COLOR    as                                         color
    from utB
             inner join utV on utv.V_ID = utB.B_V_ID),
     rgen as (
         select qid,
                datetime,
                vid,
                color,
                num,
                num - row_number() over (partition by color order by qid,datetime,vid) as numb
         from res_color),
     rend as (
         select qid,
                datetime,
                vid,
                color,
                num,
                numb,
                count(numb) over ( partition by qid,color order by numb range current row ) as rgen
         from rgen)
select distinct qid,
                color,
                rgen,
                min(datetime) over ( partition by qid,numb,rgen)  as min,
                max(datetime) over ( partition by qid,numb,rgen ) as max
from rend
where rgen > 2;
select *
from utv;
select *
from utb;
-- Задание: 52 (Serge I: 2015-01-10)
-- Для каждого цвета имеющейся в БД краски перечислить через запятую идентификаторы баллончиков данного цвета в порядке возрастания.
-- Для более двух идущих подряд ИД использовать дефис. Например, для списка ИД 3,4,7,8,9,12 результат должен быть таким:
-- 3,4,7-9,12.
-- Вывод: цвет (V_COLOR), список идентификаторов.
-- Для этой задачи запрещено использовать:
with res as (
    select v_id - row_number() over (partition by V_COLOR order by v_id) num,
           v_id    as                                                    id,
           v_name  as                                                    name,
           V_COLOR as                                                    color
    from utv),
     resnt as (
         select id,
                color,
                num,
                count(num) over ( partition by color,num order by num range current row ) as cnt
         from res)
select color, string_agg(id, ',') within group ( order by num) as str_end
from (
         select min(num) over (partition by color,num)  as num,
                color,
                cast(min(id) over ( partition by color,num) as varchar) + '-' + cast(max(id) over (
                    partition by color,num) as varchar) as id
         from resnt
         where cnt > 2
         union
         select num, color, cast(id as varchar)
         from resnt
         where cnt < 3) as res
group by color;


alter database [sql-ex] set compatibility_level = 150;


with res as (
    select v_id - row_number() over (partition by V_COLOR order by v_id) num,
           v_id    as                                                    id,
           v_name  as                                                    name,
           V_COLOR as                                                    color
    from utv),
     resnt as (
         select id,
                color,
                num,
                count(num) over ( partition by color,num order by num range current row ) as cnt
         from res)
select color, string_agg(id, ',') within group ( order by num) as str_end
from (
         select min(num) over (partition by color,num)  as num,
                color,
                cast(min(id) over ( partition by color,num) as varchar) + '-' + cast(max(id) over (
                    partition by color,num) as varchar) as id
         from (
                  select id,
                         color,
                         num,
                         count(num) over ( partition by color,num order by num range current row ) as cnt
                  from (
                           select v_id - row_number() over (partition by V_COLOR order by v_id) num,
                                  v_id    as                                                    id,
                                  v_name  as                                                    name,
                                  V_COLOR as                                                    color
                           from utv) as res) as resnt
         where cnt > 2
         union
         select num, color, cast(id as varchar)
         from (
                  select id,
                         color,
                         num,
                         count(num) over ( partition by color,num order by num range current row ) as cnt
                  from (
                           select v_id - row_number() over (partition by V_COLOR order by v_id) num,
                                  v_id    as                                                    id,
                                  v_name  as                                                    name,
                                  V_COLOR as                                                    color
                           from utv) as res) as resnt
         where cnt < 3) as res
group by color;

-- Задание: 53 (DimaN: 2004-03-01)
-- Найти все квадраты, для окраски которых применялись только уникальные пары
-- баллончиков; т.е. если квадрат №1 был окрашен баллончиками 1,2 и 3,
-- то сочетания баллончиков 1-2, 1-3 и 2-3 должны встречаться только на этом квадрате.
-- Вывести id квадратов.

with rescol as (
    select b_q_id as qid,
           B_V_ID as vid
    from utB
),
     runion as (
         select distinct rescol.qid,
                         rescol.vid,
                         res.vid                              as sid,
                         cast(rescol.vid as varchar)
                             + ',' + cast(res.vid as varchar) as stamp
         from rescol
                  inner join rescol as res on res.qid = rescol.qid and
                                              res.vid > rescol.vid),
     recnt as (
         select qid, vid, sid, stamp, count(stamp) over ( order by stamp range current row ) as cnt
         from runion)
select qid
from recnt
    except
select qid
from recnt
where cnt > 1;


-- Задание: 54 (Ozzy: 2008-09-06)
-- Определить, можно ли на циферблатных часах,
-- показывающих время отправления/прибытия рейса,
-- поменять местами часовую и минутную стрелки так,
-- чтобы такое положение стрелок было возможно при естественном ходе часов.
-- Считать, что на циферблат нанесено 60 делений и обе стрелки перемещаются
-- дискретно по этим делениям.
-- При этом не нужно учитывать случаи положения стрелок "одна над другой"
-- (например, для показаний 00:00, 08:43 и т.п.).
-- Вывод:
-- - номер рейса, для которого возможно переставить стрелки ("двойник");
-- - обозначение:
-- 'D' - если есть "двойник" для времени отправления (time_out);
-- 'A' - если есть "двойник" для времени прибытия (time_in);
-- 'DA' - если есть "двойники" как для времени отправления, так и
-- для времени прибытия рейса.
--

select *
from Pass_in_trip;
with res as (
    select trip_no                               as num,
           case
               when datepart(hour, time_out) >= 12 then datepart(hour, time_out) - 12
               else datepart(hour, time_out) end as hout,
           datepart(mi, time_out)                as minout,
           case
               when datepart(hour, time_in) >= 12 then datepart(hour, time_in) - 12
               else datepart(hour, time_in) end  as hin,
           datepart(mi, time_in)                 as minin,
           time_out,
           time_in
    from Trip),
     rend as (
         select num, hout, minout, hin, minin, hout * 5 + minout / 12 as hout_rev, hin * 5 + minin / 12 as hin_rev
         from res),
     runi as (
         select num, 'A' as type, minin as hour, hin_rev as minut
         from rend
         where hin_rev != minin
         union all
         select num, 'D' as type, minout, hout_rev
         from rend
         where hout_rev != minout),
     rnew as (
         select num, type, hour / 5 as fhour, hour % 5 as mhour, hour, minut / 12 as res, minut from runi),
     rlog as (
         select num, type, fhour, mhour, hour, case when mhour = res then 1 else 0 end as logic, minut from rnew)
select num, string_agg(type, '') within group ( order by type DESC ) new
from rlog
where logic = 1
group by num;

-- Задание: 55 (VIG: 2005-06-26)
-- Найти повторяющиеся слова в названиях кораблей из таблицы Ships.
-- Исключить из рассмотрения названия, в которых имеются односимвольные
-- слова или более одного пробела подряд.
-- Замечания:
-- - Тип поля name - varchar(50).
-- - Ведущие пробелы в названиях кораблей отсутствуют в данных.
-- Вывод: слово, количество повторений
-- Для этой задачи запрещено использовать:
with res as (
    select name, value
    from ships
             cross apply string_split(name, ' ')
    where patindex('%  %', name) = 0
      and patindex('_ %', name) = 0
      and patindex('% _ %', name) = 0
      and patindex('% _', name) = 0),
     recnt as (
         select name, value, count(value) over ( order by value range current row ) as cnt
         from res)
select distinct value, cnt
from recnt
where cnt > 1;

with res as (
    select name, value
    from ships
             cross apply string_split(name, ' ')
    where patindex('%  %', name) = 0
      and patindex('_ %', name) = 0
      and patindex('% _ %', name) = 0
      and patindex('% _', name) = 0),
     recnt as (
         select name, value, count(value) over ( order by value range current row ) as cnt
         from res)
select distinct value, cnt
from (
         select name, value, count(value) over ( order by value range current row ) as cnt
         from (
                  select name, value
                  from ships
                           cross apply string_split(name, ' ')
                  where patindex('%  %', name) = 0
                    and patindex('_ %', name) = 0
                    and patindex('% _ %', name) = 0
                    and patindex('% _', name) = 0) as res) as recnt
where cnt > 1;


-- Задание: 56 (Fiolent: 2004-06-22)
--
-- Для каждого белого квадрата вывести распределение окрашивавших его баллончиков по группам при следующих ограничениях:
--
-- 1. Группы для каждого квадрата нумеруются с 1.
--
-- 2. Сначала заполняется первая группа, куда включается только по одному баллончику каждого цвета с наименьшими (по данному цвету) номерами.
--
-- 3. Затем оставшиеся баллончики данного квадрата аналогично п.2 формируют вторую группу и т.д.
--
-- Вывод: имя белого квадрата, номер группы, имя красного баллончика, имя зеленого баллончика, имя синего баллончика.
--     Если баллончика какого-либо цвета в группе нет, то в соответствующем поле выводится NULL.
with res as (
    select B_DATETIME                              as date,
           B_V_ID                                  as vid,
           B_Q_ID                                  as qid,
           V_COLOR                                 as color,
           B_VOL                                   as vol,
           v_name                                  as vname,
           sum(B_VOL) over ( partition by B_Q_ID ) as sum
    from utb
             inner join utV uV on uV.V_ID = utB.B_V_ID),
     rend as (
         select date,
                dense_rank() over (partition by qid,color order by vid ) num,
                vid,
                qid,
                color,
                vol,
                sum,
                vname
         from res
         where sum = 765),
     redinct as (select distinct qid, utq.Q_NAME as name, num
                 from rend
                          inner join utq on utq.Q_ID = rend.qid)
select redinct.name, redinct.num, rer.vname, reg.vname, reb.vname
from redinct
         left join rend as rer on rer.qid = redinct.qid and rer.num = redinct.num and rer.color = 'R'
         left join rend as reg on reg.qid = redinct.qid and reg.num = redinct.num and reg.color = 'G'
         left join rend as reb on reb.qid = redinct.qid and reb.num = redinct.num and reb.color = 'B'


-- Задание: 57 (Kursist: 2020-10-09)
-- Из таблицы Product выбрать все записи, номера моделей которых (без учета ведущих нулей) являются натуральными числами.
-- Для каждого производителя сформировать строку из номеров моделей всех этих записей
--     в порядке возрастания числового представления номера модели.
-- Полученную строку разбить на триплеты по три символа. Лишние символы отбросить.
-- Для каждого производителя вывести все триплеты, числовое значение которых является четным или меньше 256.
-- Вывод: maker, triplet
-- Замечание: Номера моделей не содержат лидирующих и концевых пробелов.

with res as (
    select maker, model
    from product
    where model not LIKE '%[^ 0-9]%'
      and NOT (model not LIKE '%[^0]%' and model LIKE '0%')),
     rend as (
         select maker,
                string_agg(model , '') within group ( order by cast(model as int) ) as ssum
         from res
         group by maker),
     rnew as (
         select row_number() over (partition by maker, ssum order by value) num, maker, ssum, value
         from rend
                  cross apply string_split(replicate('1 1', len(ssum) / 3), ' ')),
     rcnt as (
         select maker, substring(ssum, (num - 1) * 3 + 1, 3) as cnt
         from rnew)
select *
from res;
select maker, cnt
from rcnt
where len(cnt) > 2
  and (cast(cnt as int) % 2 = 0 or cast(cnt as int) < 256);

USE [sql-ex];


with res as (select maker, model
            from Product
            where model not LIKE '%[^0-9]%'
              and NOT (model not LIKE '%[^0]%' and model LIKE '0%')) ,
     rend as (
         select maker,
                string_agg(cast(cast(model as int) as varchar), '') within group ( order by cast(model as int) ) as ssum
         from res
         group by maker),
     rnew as (
         select row_number() over (partition by maker, ssum order by value) num, maker, ssum, value
         from rend
                  cross apply string_split(replicate('1 1', len(ssum) / 3), ' ')),
     rcnt as (
         select maker, substring(ssum, (num - 1) * 3 + 1, 3) as cnt
         from rnew)

select * from res;
select maker, cnt
from (
         select maker, substring(ssum, (num - 1) * 3 + 1, 3) as cnt
         from (
                  select row_number() over (partition by maker, ssum order by value) num, maker, ssum, value
                  from (
                           select maker,
                                  string_agg(model, '')
                                             within group ( order by cast(model as int) ) as ssum
                           from (
                                    select maker, model
                                    from Product
                                    where model not LIKE '%[^0-9]%'
                                      and NOT (model not LIKE '%[^0]%' and model LIKE '0%')) as res
                           group by maker) as rend
                           cross apply string_split(replicate('1 1', len(ssum)), ' ')) as rnew) as rcnt
where len(cnt) =3 and (cast(cnt as int) %2 = 0 or cast(cnt as int) < 256 );

use [sql-ex];

with res as (select maker, model
            from Product
            where model not LIKE '%[^0-9]%'
              and NOT (model not LIKE '%[^0]%' and model LIKE '0%')) ,
     rend as (
         select maker,
                string_agg(cast(cast(model as int) as varchar), '') within group ( order by cast(model as int) ) as ssum
         from res
         group by maker),
     rnew as (
         select row_number() over (partition by maker, ssum order by value) num, maker, ssum, value
         from rend
                  cross apply string_split(replicate('1 1', len(ssum) / 3), ' ')),
     rcnt as (
         select maker, substring(ssum, (num - 1) * 3 + 1, 3) as cnt
         from rnew)

select * from res;
select maker, cnt
from (
         select maker, substring(ssum, (num - 1) * 3 + 1, 3) as cnt
         from (
                  select row_number() over (partition by maker, ssum order by value) num, maker, ssum, value
                  from (
                           select maker,
                                  string_agg(model, '')
                                             within group ( order by cast(model as int) ) as ssum
                           from (
                               select maker, model from Product
                                    except
                                    select maker, model
                                    from Product
                                    where model LIKE '%[^0-9]%'
                                      or (model not LIKE '%[^0]%' and model LIKE '%0')) as res
                           group by maker) as rend
                           cross apply string_split(replicate('1 1', len(ssum)), ' ')) as rnew) as rcnt
where len(cnt) =3 and (cast(cnt as int) %2 = 0 or cast(cnt as int) < 256 );











use [sql-ex];
select * from Product;

with res as (
    select maker, model, replicate('0',(50-len(model))) + model as sort_model
    from Product
    where model not LIKE '%[^0-9]%'
      and (model LIKE '%[^0]%')),
     res_union as (
         select maker, string_agg(model, '') within group ( order by sort_model ) as model
         from res
         group by maker),
     res_split as (
         select maker, model
         from res_union
                  cross apply string_split(REPLICATE('1 1', len(model)), ' ')),
     res_row as (
select row_number() over (partition by maker order by model ) num, maker, model
from res_split ),
     res_sub as (
select maker, model, substring(model,(num-1)*3+1,3) as triplet from res_row),
     res_trip as (
select maker, triplet from res_sub where len(triplet) = 3 and (cast(triplet as int) < 256 or cast(triplet as int )%2 = 0))
select * from res_union;
select Prod.maker, coalesce(triplet,'') as triplet from (select distinct maker from Product) as prod left join res_trip on res_trip.maker = Prod.maker





select maker, triplet
from (
         select maker, model, substring(model COLLATE Latin1_General_CS_AI_KS_WS, (num - 1) * 3 + 1, 3) as triplet
         from (
                  select row_number() over (partition by maker order by model COLLATE Latin1_General_CS_AI_KS_WS) num, maker, model
                  from (
                           select maker, model COLLATE Latin1_General_CS_AI_KS_WS as model
                           from (
                                    select maker,
                                           string_agg(model , '') within group ( order by cast(model as int) ) as model
                                    from (
                                             select maker, model COLLATE Latin1_General_CS_AS as model
                                             from Product
                                             where model COLLATE Latin1_General_CS_AI_KS_WS not LIKE N'%[^0-9]%'
                                               and (model COLLATE Latin1_General_CS_AI_KS_WS LIKE N'%[^0]%')) as res
                                    group by maker ) as res_union
                                    cross apply string_split(REPLICATE('1 1', len(model)), ' ')) as res_split) as res_row) as res_sub
where len(triplet) = 3
  and (cast(triplet as int) < 256 or cast(triplet as int) % 2 = 0);



select maker, triplet
from (
         select maker, model, substring(model, (num - 1) * 3 + 1, 3) as triplet
         from (
                  select row_number() over (partition by maker order by model) num, maker, model
                  from (
                           select maker, model
                           from (
                                    select maker,
                                           string_agg(model, '') within group (order by sort_model) as model
                                    from (
                                             select maker, model, replicate('0',(50-len(model))) + model as sort_model
                                             from product
                                             where model not LIKE N'%[^0-9]%'
                                               and (model LIKE N'%[^0]%')) as res
                                    group by maker) as res_union
                                    cross apply string_split(REPLICATE('1 1', len(model)), ' ')) as res_split) as res_row) as res_sub
where len(triplet) = 3
  and (cast(triplet as int) < 256 or cast(triplet as int) % 2 = 0);



select maker, triplet
from (
         select maker, model, substring(model, (num - 1) * 3 + 1, 3) as triplet
         from (
                  select row_number() over (partition by maker order by model ) num, maker, model
                  from (
                           select maker, model
                           from (
                                    select maker,
                                           string_agg(model, '') within group ( order by model  collate Latin1_General_100_BIN2) as model
                                    from (
                                             select maker, model
                                             from Product
                                             where model not LIKE N'%[^0-9]%'
                                               and (model LIKE N'%[^0]%')) as res
                                    group by maker) as res_union
                                    cross apply string_split(REPLICATE('1 1', len(model)), ' ')) as res_split) as res_row) as res_sub
where len(triplet) = 3
  and (cast(triplet as int) < 256 or cast(triplet as int) % 2 = 0);


-- select maker, cast(model as bigint) from Product;

with res as (
    select row_number() over (partition by B_Q_ID, B_V_ID order by B_DATETIME) num,
           B_DATETIME as                                                       date,
           B_Q_ID     as                                                       qid,
           B_V_ID     as                                                       vid,
           B_VOL      as                                                       vol
    from utB
    ),
     res_left as (
         select res.date, res.qid, res.vid, res.vol, res_left.date as tp, res_left.vol as volp
         from res
                  left join res as res_left
                            on res_left.qid = res.qid and res_left.vid = res.vid and res.num = res_left.num + 1),
     res_agg as (
         select res.date,
                res.qid,
                res.vid,
                string_agg(FORMAT(coalesce(res_left.date, 'NULL'), N'yyyy-MM-dd hh:mm:ss'), ',') within group ( order by res_left.date DESC) as times
         from res
                  left join res as res_left
                            on res_left.qid = res.qid and res_left.vid = res.vid and res.date > res_left.date
         group by res.qid, res.vid, res.date)
select res_left.date, res_left.qid, res_left.vid, res_left.vol, res_left.tp, res_left.volp, times
from res_left
         left join res_agg on res_agg.qid = res_left.qid and res_agg.vid = res_left.vid and res_agg.date = res_left.date;



with res as (
    select row_number() over (partition by B_Q_ID, B_V_ID order by B_DATETIME) num,
           B_DATETIME as                                                       date,
           B_Q_ID     as                                                       qid,
           B_V_ID     as                                                       vid,
           B_VOL      as                                                       vol
    from utB
),
     res_left as (
         select num,
                date,
                qid,
                vid,
                vol,
                LAG(date) OVER (partition by qid,vid ORDER BY num) tp,
                LAG(vol) OVER (partition by qid,vid ORDER BY num)  volp
         from res),
     res_agg as (
         select res.date,
                res.qid,
                res.vid,
                string_agg(CONVERT(NVARCHAR(MAX), res_left.date, 20), ',')
                           within group ( order by res_left.date DESC) as times
         from res
                  left join res as res_left
                            on res_left.qid = res.qid and res_left.vid = res.vid and res.date > res_left.date
         group by res.qid, res.vid, res.date)
select res_left.date, res_left.qid, res_left.vid, res_left.vol, res_left.tp, res_left.volp, times
from res_left
         left join res_agg
                   on res_agg.qid = res_left.qid and res_agg.vid = res_left.vid and res_agg.date = res_left.date;



with res as (
    select row_number() over (partition by B_Q_ID, B_V_ID order by B_DATETIME) num,
           B_DATETIME as                                                       date,
           B_Q_ID     as                                                       qid,
           B_V_ID     as                                                       vid,
           B_VOL      as                                                       vol
    from utB
),
     res_left as (
         select num,
                date,
                qid,
                vid,
                vol,
                LAG(date) OVER (partition by qid,vid ORDER BY num) tp,
                LAG(vol) OVER (partition by qid,vid ORDER BY num)  volp
         from res),
     res_agg as (
         select res.date,
                res.qid,
                res.vid,

                string_agg(FORMAT(res_left.date, N'yyyy-MM-dd hh:mm:ss'), ',')
                           within group ( order by res_left.date DESC) as times
         from res cross apply res as res_left
         group by res.qid, res.vid, res.date),
     res_res as (
         select res_agg.date,
                res_agg.qid,
                res_agg.vid,
                string_agg(res_left.times, ',')
                           within group ( order by res_left.times DESC) as times
         from res_agg cross apply res_agg as res_left
         group by res_agg.qid, res_agg.vid, res_agg.date)
select * from res_res;


string_agg(cast(cast(res_left.date as smalldatetime) as NVARCHAR(MAX)), ',')
-- CONVERT(NVARCHAR(max),FORMAT(res_left.date, 'yyyy-MM-dd hh:mm:ss')), ',')


-- Задача 58
-- Беглый заключенный, оказавшись в аэропорту города town_from, улетел ближайшим рейсом.
-- Для каждого города town_from в Trip рассчитать вероятность того, что беглец окажется в городе town_to.
--     Если в одно время из аэропорта вылетают несколько рейсов, считать возможность выбора заключенным каждого из этих рейсов равновероятной.
-- Вывод: town_from, town_to, вероятность в процентах (число с точностью до тысячных долей).


--
-- select count(*) over (partition by town_from, town_to) num , town_from, town_to,
--        count(*) over ( partition by town_from) general from res_date )
-- select distinct town_from, town_to, round(cast(num as real)/cast(general as real ) * 100.0, 3) as res from res_count


-- 1. Проверьте точность своего вычисления на таком наборе: одновременно вылетают 3 рейса в город А и еще 5 рейсов в город Б.
-- Предыдущий рейс в город В вылетел за час до них.
-- 2. Форматирование числа как строки может приводить к неверному отображению чисел меньше единицы.
-- 3. Для расчёта вероятности важно понимать, что заключённый может оказаться в аэропорту города town_from в произвольный момент времени.

with res as (
    select town_from,
           town_to,
           datetimefromparts(datepart(year, date), datepart(month, date), datepart(day, date),
                             datepart(hour, time_out), datepart(mi, time_out), 0, 0) as date_out
    from trip
             inner join (select datefromparts(2000, 1, 1) as date) as new on date is not null),
     res_dis as (select distinct town_from,
                                 date_out,
                                 min(date_out) over ( partition by town_from order by date_out) as min_date
                 from res),
     res_new as (select town_from, date_out, min_date
                 from res_dis
                 union
                 select town_from, dateadd(day, 1, min_date) as date_out, min_date
                 from res_dis),

     res_lag as (
         select distinct town_from,
                         date_out,
                         min_date,
                         LAG(date_out) OVER (partition by town_from ORDER BY date_out) prev_date
         from res_new),
     res_count as (
         select town_from,
                datediff(mi, prev_date, date_out) as res,
                case
                    when datediff(day, min_date, date_out) = 1
                        then min_date
                    else date_out end             as date_out
         from res_lag
         where prev_date is not null),
     res_date as (
         select res.town_from,
                res.town_to,
                res.date_out,
                res_count.res,
                count(*) over ( partition by res.town_from, res.date_out) num
         from res
                  inner join res_count on res_count.town_from = res.town_from and res.date_out = res_count.date_out),
     res_sum as (
         select town_from, town_to, sum(cast(res as real) / cast(num as real) * 100.0 / 1440.0) as part
         from res_date
         group by town_from, town_to)
select town_from, town_to, case when cast(round(part,4)*10000 as int) % 10 = 5 then cast(round(part + 0.0001,3) as dec(6, 3)) else
cast(round(part,3) as dec(6, 3)) end as part
from res_sum;

-- round(CAST(AS dec(6,3)),3)
-- cast(round(part,3) as dec(6, 3))
-- 1, datetimefromparts(2000, 1, 1,0,0,0,0)
--


select * from Pass_in_trip;
select * from Passenger;



