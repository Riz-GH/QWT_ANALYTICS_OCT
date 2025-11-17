{# {{ config(materialized = 'table', schema = 'transforming_dev') }} #}
{{ config(materialized = 'table', schema = env_var('DBT_STGSCHEMA_NAME', 'TRANSFORMING_DEV')) }}
 
with recursive managers
 
      (indent, employeeid, office, firstname, managername, title, hiredate, extension, yearsalary)
    as
   
      (
 
       
        select '' as indent, employeeid, office, firstname, firstname as managername, title , hiredate, extension, yearsalary
          from {{ref('stg_employees')}}
          where title = 'President'
        union all
 
     
        select indent || '* ',
            e.employeeid, e.office, e.firstname, m.firstname as managername, e.title, e.hiredate, e.extension, e.yearsalary
          from {{ref('stg_employees')}} as e join managers as m
            on e.reportsto = m.employeeid
      )
      ,
 
      offices (officeid, officecity, officestate, officecountry)
      as
      (
        select office, officecity, OFFICESTATEPROVINCE, officecountry
        from
        {{ref('stg_offices')}}
      )
 
 
  select indent || title as title, employeeid, firstname, managername, hiredate, extension, yearsalary,
  o.officecity, o.officestate, o.officecountry
    from managers as m inner join offices as o on o.officeid = m.office