--step 1 rebuildIDX_eco
datayesdb..get_idx_tbl_info

--exec sp_MSforeachtable 'insert into DBCenter..tmp_index_stats SELECT ''?'',a.index_id, name, avg_fragmentation_in_percent  
--FROM sys.dm_db_index_physical_stats (DB_ID(N''datayesdb''), 
--      OBJECT_ID(N''?''), NULL, NULL, NULL) AS a  
--   JOIN sys.indexes AS b with (nolock)
--      ON a.object_id = b.object_id AND a.index_id = b.index_id' 

--exec sp_MSforeachtable 'insert into DBCenter..index_stats_his ([tbl_name],[idx_id],[idx_name],[avg_fragmentation_pct]) SELECT ''?'',a.index_id, name, avg_fragmentation_in_percent  
--FROM sys.dm_db_index_physical_stats (DB_ID(N''datayesdb''), 
--      OBJECT_ID(N''?''), NULL, NULL, NULL) AS a  
--    JOIN sys.indexes AS b with (nolock)
--      ON a.object_id = b.object_id AND a.index_id = b.index_id' 

--select distinct tbl_name,'ALTER INDEX ['+ idx_name +'] ON '+ tbl_name+' REBUILD 'from DBCenter..index_stats_his
--where tbl_name like '%eco_%' and avg_fragmentation_pct >50 and idx_name is not null 
--order by tbl_name

--truncate table DBCenter..tmp_index_stats
--truncate table DBCenter..index_stats_his 



--step 2 rebuild_eco_index_30
[dbo].[dba_rebuild_index_30]
truncate table DBCenter..tmp_index_stats
/*declare @tblname varchar(100),
@sql varchar(4000)

BEGIN
declare mycursor cursor for 	
select distinct tbl_name,'ALTER INDEX ['+ idx_name +'] ON '+ tbl_name+' REBUILD 'from DBCenter..tmp_index_stats
where tbl_name like '%eco_%' and avg_fragmentation_pct >30 and idx_name is not null --and record_time = cast(getdate() as date)
order by tbl_name
    --打开游标  
    open mycursor      
    --从游标里取出数据赋值到我们刚才声明的2个变量中  
    fetch next from mycursor into @tblname,@sql

    --判断游标的状态  
    -- 0 fetch语句成功      
    ---1 fetch语句失败或此行不在结果集中      
    ---2 被提取的行不存在  
    while (@@fetch_status=0)  
    begin 
	EXEC (@sql)
	print 'rebuild idex on '+@tblname
	--print @sql
    --用游标去取下一条记录  -
       fetch next from mycursor into @tblname,@sql
	end
	--关闭游标  
    close mycursor		
    --撤销游标  
    DEALLOCATE mycursor
	truncate table DBCenter..tmp_index_stats
END
*/