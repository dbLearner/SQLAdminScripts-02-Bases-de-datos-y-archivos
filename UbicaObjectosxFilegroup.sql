select TableNAME = o.name, ObjectName = i.name, i.indid, s.groupname
                  from sysfilegroups s, sysindexes i, sysobjects o
                  where i.id = o.id
                        and o.type in ('S ','U ') --system or user table
                        and i.groupid = s.groupid
AND s.groupname <> 'PRIMARY'
