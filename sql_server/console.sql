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





