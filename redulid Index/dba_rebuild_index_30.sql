/****** Object: Procedure [dbo].[dba_rebuild_index_30]   Script Date: 2017/6/16 16:51:19 ******/
USE [datayesdb];
GO
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO


CREATE PROCEDURE [dbo].[dba_rebuild_index_30]
AS
declare @tblname varchar(100),
@sql varchar(4000)

begin
declare mycursor cursor for 	
--select distinct tbl_name,'ALTER INDEX ['+ idx_name +'] ON '+ tbl_name+' REBUILD 'from DBCenter..tmp_index_stats
--where tbl_name like '%eco_%' and avg_fragmentation_pct >30 and idx_name is not null --and record_time = cast(getdate() as date)
--order by tbl_name
select distinct a.[tbl_name],'ALTER INDEX ['+ a.idx_name +'] ON '+ tbl_name+' REBUILD '
from [DBCenter].[dbo].[tmp_index_stats] a with(nolock) ,
	[DBCenter].[dbo].[viewTableSpace] b with(nolock)
where b.database_name='datayesdb' 
	  and a.tbl_name='[dbo].['+b.table_name+']'	
      --and a.tbl_name like '%eco_data%'
	  and a.idx_name is not null
	  and b.row_count>50000
	  and a.[avg_fragmentation_pct]>=30
order by a.tbl_name

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
	truncate table [DBCenter].[dbo].[viewTableSpace]
end


GO

