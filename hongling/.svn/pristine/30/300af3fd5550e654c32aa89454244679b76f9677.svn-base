package chinsoft.business;

import hongling.util.DateUtils;

import java.util.Date;
import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.hibernate.SQLQuery;

import chinsoft.core.DataAccessObject;
import chinsoft.core.LogPrinter;

/**
 * @author Lizuoqi
 * @time 2015.04.09
 * */
public class RepairOrdenTwoManager {
	
	
	
	/**
	 * 得到返修报表信息
	 * @author Lizuoqi
	 * @time 2015.04.09
	 * @param Date date 时间
	 * @param String cloth 品类
	 * @param String memberName 客户名称
	 * */
	public List getRepairInfo(Date date,String cloth,String memberName,int pageIndex,int pageSize){
		
		//处理前台传递的时间 
		if (date == null) {
			date = new Date();
		}
		
		String time = DateUtils.formatDate(date, "yyyy-MM-dd");
		//格式XXXX-XX-XX
		String daytime = time;
		//截取 到XXXX-XX
		String monthtime = time.substring(0, 7);
		//截取到XXXX
		String yeartime = time.substring(0, 4);
		//存放二级返修报表集合
		List list = null;
		try {	
			 String	sql ="SELECT MEMBER.USERNAME,MEMBER.NAME,REPAIR_DETAIL.CLOTH,"
						+"SUM(CASE WHEN REPAIR_ORDER.CREATE_TIME LIKE :day THEN 1 ELSE 0 END) AS 天下单量,"
						+"SUM(CASE WHEN REPAIR_ORDER.CREATE_TIME LIKE :month THEN 1 ELSE 0 END) as 月下单量,"
						+"SUM(CASE WHEN REPAIR_ORDER.CREATE_TIME LIKE :year THEN 1 ELSE 0 END) as 年下单量,"
						+"NVL(SUM(CASE WHEN REPAIR_ORDER.CREATE_TIME LIKE :year THEN REPAIR_DETAIL.PRICE ELSE 0 END),0) as 年累计扣款,"
						+"NVL(SUM(CASE WHEN REPAIR_ORDER.CREATE_TIME LIKE :month THEN REPAIR_DETAIL.PRICE ELSE 0 END) ,0)as 月累计扣款,"
						+"NVL(SUM(CASE WHEN REPAIR_ORDER.CREATE_TIME LIKE :day THEN REPAIR_DETAIL.PRICE ELSE 0 END),0) as 日累计扣款,"
						+"SUM(CASE WHEN REPAIR_ORDER.CREATE_TIME LIKE :year and REPAIR_DETAIL.RESPONSIBILITY =1 THEN 1 ELSE 0 END) as 年尺寸原因,"
						+"SUM(CASE WHEN REPAIR_ORDER.CREATE_TIME LIKE :year and REPAIR_DETAIL.RESPONSIBILITY =2 THEN 1 ELSE 0 END) as 年做工原因,"
						+"SUM(CASE WHEN REPAIR_ORDER.CREATE_TIME LIKE :year and REPAIR_DETAIL.RESPONSIBILITY =3 THEN 1 ELSE 0 END) as 年版型原因,"
						+"SUM(CASE WHEN REPAIR_ORDER.CREATE_TIME LIKE :year and REPAIR_DETAIL.RESPONSIBILITY =4 THEN 1 ELSE 0 END) as 年面辅料原因,"
						+"SUM(CASE WHEN REPAIR_ORDER.CREATE_TIME LIKE :year and REPAIR_DETAIL.RESPONSIBILITY =5 THEN 1 ELSE 0 END) as 年顾客原因,"
						+"SUM(CASE WHEN REPAIR_ORDER.CREATE_TIME LIKE :year and REPAIR_DETAIL.RESPONSIBILITY =6 THEN 1 ELSE 0 END) as 年更改款式,"
						+"SUM(CASE WHEN REPAIR_ORDER.CREATE_TIME LIKE :year and REPAIR_DETAIL.RESPONSIBILITY =7 THEN 1 ELSE 0 END) as 年更改工艺,"
						+"SUM(CASE WHEN REPAIR_ORDER.CREATE_TIME LIKE :year and REPAIR_DETAIL.RESPONSIBILITY =8 THEN 1 ELSE 0 END) as 年更改附件及配色料,"
						+"SUM(CASE WHEN REPAIR_ORDER.CREATE_TIME LIKE :month and REPAIR_DETAIL.RESPONSIBILITY =1 THEN 1 ELSE 0 END) as 月尺寸原因,"
						+"SUM(CASE WHEN REPAIR_ORDER.CREATE_TIME LIKE :month and REPAIR_DETAIL.RESPONSIBILITY =2 THEN 1 ELSE 0 END) as 月做工原因,"
						+"SUM(CASE WHEN REPAIR_ORDER.CREATE_TIME LIKE :month and REPAIR_DETAIL.RESPONSIBILITY =3 THEN 1 ELSE 0 END) as 月版型原因,"
						+"SUM(CASE WHEN REPAIR_ORDER.CREATE_TIME LIKE :month and REPAIR_DETAIL.RESPONSIBILITY =4 THEN 1 ELSE 0 END) as 月面辅料原因,"
						+"SUM(CASE WHEN REPAIR_ORDER.CREATE_TIME LIKE :month and REPAIR_DETAIL.RESPONSIBILITY =5 THEN 1 ELSE 0 END) as 月顾客原因,"
						+"SUM(CASE WHEN REPAIR_ORDER.CREATE_TIME LIKE :month and REPAIR_DETAIL.RESPONSIBILITY =6 THEN 1 ELSE 0 END) as 月更改款式,"
						+"SUM(CASE WHEN REPAIR_ORDER.CREATE_TIME LIKE :month and REPAIR_DETAIL.RESPONSIBILITY =7 THEN 1 ELSE 0 END) as 月更改工艺,"
						+"SUM(CASE WHEN REPAIR_ORDER.CREATE_TIME LIKE :month and REPAIR_DETAIL.RESPONSIBILITY =8 THEN 1 ELSE 0 END) as 月更改附件及配色料,"
						+"SUM(CASE WHEN REPAIR_ORDER.CREATE_TIME LIKE :day and REPAIR_DETAIL.RESPONSIBILITY =1 THEN 1 ELSE 0 END) as 天尺寸原因,"
						+"SUM(CASE WHEN REPAIR_ORDER.CREATE_TIME LIKE :day and REPAIR_DETAIL.RESPONSIBILITY =2 THEN 1 ELSE 0 END) as 天做工原因,"
						+"SUM(CASE WHEN REPAIR_ORDER.CREATE_TIME LIKE :day and REPAIR_DETAIL.RESPONSIBILITY =3 THEN 1 ELSE 0 END) as 天版型原因,"
						+"SUM(CASE WHEN REPAIR_ORDER.CREATE_TIME LIKE :day and REPAIR_DETAIL.RESPONSIBILITY =4 THEN 1 ELSE 0 END) as 天面辅料原因,"
						+"SUM(CASE WHEN REPAIR_ORDER.CREATE_TIME LIKE :day and REPAIR_DETAIL.RESPONSIBILITY =5 THEN 1 ELSE 0 END) as 天顾客原因,"
						+"SUM(CASE WHEN REPAIR_ORDER.CREATE_TIME LIKE :day and REPAIR_DETAIL.RESPONSIBILITY =6 THEN 1 ELSE 0 END) as 天更改款式,"
						+"SUM(CASE WHEN REPAIR_ORDER.CREATE_TIME LIKE :day and REPAIR_DETAIL.RESPONSIBILITY =7 THEN 1 ELSE 0 END) as 天更改工艺,"
						+"SUM(CASE WHEN REPAIR_ORDER.CREATE_TIME LIKE :day and REPAIR_DETAIL.RESPONSIBILITY =8 THEN 1 ELSE 0 END) as 天更改附件及配色料 "
						+"FROM REPAIR_ORDER INNER JOIN REPAIR_DETAIL ON REPAIR_ORDER.REPAIR_NO=REPAIR_DETAIL.REPAIR_NO INNER JOIN MEMBER ON MEMBER.ID=REPAIR_ORDER.MEMBER_ID  WHERE 1 = 1 ";
			 			if(StringUtils.isNotBlank(memberName)){
			 				sql += " and MEMBER.NAME like '" + memberName+ "%' ";
		        	      }
			 			if(!cloth.equals("-1")){
			 				sql += " AND REPAIR_DETAIL.CLOTH='"+cloth+"'";
		        	      }
					sql +="GROUP BY MEMBER.ID,MEMBER.USERNAME,MEMBER.NAME,REPAIR_DETAIL.CLOTH ORDER BY MEMBER.USERNAME,REPAIR_DETAIL.CLOTH ";
        	SQLQuery query = DataAccessObject.openSession().createSQLQuery(sql);
        	query.setString("day",daytime+"%");
    		query.setString("month",monthtime+"%");
    		query.setString("year",yeartime+"%");
        	//设置分页
    		if(pageSize!=0){
    			query.setFirstResult(pageIndex*pageSize);
    			query.setMaxResults(pageSize);
    		}
		    list = query.list();
    	} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		}finally{
			DataAccessObject.closeSession();
		}
		return list;
		
	}
}
