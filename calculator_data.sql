select
countyname,
case when city = 'Santa Fe' then 'SANTA FE'
when city = 'Rio Rancho' then 'RIO RANCHO'
when city = 'Farmington' then 'FARMINGTON'
when city = 'Clovis' then 'CLOVIS'
when city = 'Albuquerque' then 'ALBUQUERQUE'
when city = 'Las Vegas' then 'LAS VEGAS'
when city  = 'Los Alamos' then 'LOS ALAMOS'
else 'Other' end as city
, '2010' as year
, sex
, case 
when age_raw<25 then '18 to 24' 
when age_raw<35 then '25 to 34' 
when age_raw<50 then '35 to 49' 
when age_raw<65 then '50 to 64' 
when age_raw<110 then '65+' 
else 'NoAge' end as age_bucket
, case
when race='African American' then 'African American'
when race = 'Native American' then 'Native American'
when race='Hispanic/ Latino' then 'Hispanic/Latino'
when race = 'Asian American' then 'Asian American'
when race='Caucasian' then 'Caucasian' else 'Other/Unknown' end as race
, party
, generic_score_bucket
, count(g2010) as total_to
, count(*) as total_reg
, count(case when g2010 in ('E','A') then a.personid end) as total_early
from dccc_projects.nationwide_2010_electorate a
left join golden.precinct b on a.precinctid = b.precinctid
where a.state||'-'||right(congressionaldistrict,2) in ('NM-03') and isactive = true
group by 1,2,3,4,5,6, 7, 8
union all
select
countyname,
case when city = 'Santa Fe' then 'SANTA FE'
when city = 'Rio Rancho' then 'RIO RANCHO'
when city = 'Farmington' then 'FARMINGTON'
when city = 'Clovis' then 'CLOVIS'
when city = 'Albuquerque' then 'ALBUQUERQUE'
when city = 'Las Vegas' then 'LAS VEGAS'
when city  = 'Los Alamos' then 'LOS ALAMOS'
else 'Other' end as city
, '2012' as year
, sex
, case 
when age_raw<25 then '18 to 24' 
when age_raw<35 then '25 to 34' 
when age_raw<50 then '35 to 49' 
when age_raw<65 then '50 to 64' 
when age_raw<110 then '65+' 
else 'NoAge' end as age_bucket 
, case
when race='African American' then 'African American'
when race = 'Native American' then 'Native American'
when race='Hispanic/ Latino' then 'Hispanic/Latino'
when race = 'Asian American' then 'Asian American'
when race='Caucasian' then 'Caucasian' else 'Other/Unknown' end as race
, party
, generic_score_bucket
, count(g2012) as total_to
, count(*) as total_reg
, count(case when g2012 in ('E','A') then a.personid end) as total_early
from dccc_projects.nationwide_2012_electorate a
left join golden.precinct b on a.precinctid = b.precinctid
where a.state||'-'||right(congressionaldistrict,2) in ('NM-03') and isactive = true
group by 1,2,3,4,5,6, 7, 8
union all
select
countyname,
case when city = 'Santa Fe' then 'SANTA FE'
when city = 'Rio Rancho' then 'RIO RANCHO'
when city = 'Farmington' then 'FARMINGTON'
when city = 'Clovis' then 'CLOVIS'
when city = 'Albuquerque' then 'ALBUQUERQUE'
when city = 'Las Vegas' then 'LAS VEGAS'
when city  = 'Los Alamos' then 'LOS ALAMOS'
else 'Other' end as city
, '2014' as year
, case when sex = 'F' then 'Female' 
when sex = 'M' then 'Male'
else 'Unknown' end as 'sex'
, case 
when age_raw<25 then '18 to 24' 
when age_raw<35 then '25 to 34' 
when age_raw<50 then '35 to 49' 
when age_raw<65 then '50 to 64' 
when age_raw<110 then '65+' 
else 'NoAge' end as age_bucket
, case
when race='African American' then 'African American'
when race = 'Native American' then 'Native American'
when race='Hispanic/ Latino' then 'Hispanic/Latino'
when race = 'Asian American' then 'Asian American'
when race='Caucasian' then 'Caucasian' else 'Other/Unknown' end as race
, party
, generic_support_score_bucket
, count(g2014) as total_to
, count(*) as total_reg
, count(case when g2014 in ('E','A') then a.personid end) as total_early
from dccc_projects.nationwide_2014_electorate a
left join golden.precinct b on a.precinctid = b.precinctid
where a.state||'-'||right(congressionaldistrict,2) in ('NM-03')
group by 1,2,3,4,5,6, 7, 8

