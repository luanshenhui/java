package hongling.business;
import hongling.util.DateUtils;
import java.util.Date;
import java.util.List;
import org.apache.commons.lang.StringUtils;
import org.hibernate.SQLQuery;
import chinsoft.core.DataAccessObject;

public class CustomerAssessManager {
	
	private DataAccessObject dao = new DataAccessObject();
	
	/**
	 * 获取分类周期评价报表
	 * @param code
	 * @param date
	 * @return
	 */
	public List getCategoryPeriodAppraiseReport(String name, Date date) {
		if (date == null) {
			date = new Date();
		}
		String time = DateUtils.formatDate(date, "yyyy-MM-dd");
		String daytime = time;
		String monthtime = time.substring(0, 7);
		String yeartime = time.substring(0, 4);
		String strSQL = "";
		strSQL += "SELECT" + " DICT1.ID,DICT1.NAME," + "SUM(CASE WHEN to_char(ORDEN.DELIVERYDATE,'yyyy-MM-dd hh24:mi:ss') LIKE '" + daytime + "%' THEN 1 ELSE 0 END)," + "SUM(CASE WHEN ORDER_APPRAISE.CREATE_TIME LIKE '" + daytime
				+ "%' THEN 1 ELSE 0 END)," + "SUM(CASE WHEN ORDER_APPRAISE.CREATE_TIME LIKE '" + daytime + "%' AND ORDER_APPRAISE.SATISFY=1  THEN 1 ELSE 0 END),"
				+ "SUM(CASE WHEN ORDER_APPRAISE.CREATE_TIME LIKE '" + daytime + "%' AND ORDER_APPRAISE.SATISFY=2  THEN 1 ELSE 0 END)," + "SUM(CASE WHEN to_char(ORDEN.DELIVERYDATE,'yyyy-MM-dd hh24:mi:ss') LIKE '" + monthtime
				+ "%' THEN 1 ELSE 0 END)," + "SUM(CASE WHEN ORDER_APPRAISE.CREATE_TIME LIKE '" + monthtime + "%' THEN 1 ELSE 0 END)," + "SUM(CASE WHEN ORDER_APPRAISE.CREATE_TIME LIKE '" + monthtime
				+ "%' AND ORDER_APPRAISE.SATISFY=1  THEN 1 ELSE 0 END)," + "SUM(CASE WHEN ORDER_APPRAISE.CREATE_TIME LIKE '" + monthtime + "%' AND ORDER_APPRAISE.SATISFY=2  THEN 1 ELSE 0 END),"
				+ "SUM(CASE WHEN to_char(ORDEN.DELIVERYDATE,'yyyy-MM-dd hh24:mi:ss') LIKE '" + yeartime + "%' THEN 1 ELSE 0 END)," + "SUM(CASE WHEN ORDER_APPRAISE.CREATE_TIME LIKE '" + yeartime + "%' THEN 1 ELSE 0 END),"
				+ "SUM(CASE WHEN ORDER_APPRAISE.CREATE_TIME LIKE '" + yeartime + "%' AND ORDER_APPRAISE.SATISFY=1  THEN 1 ELSE 0 END)," + "SUM(CASE WHEN ORDER_APPRAISE.CREATE_TIME LIKE '" + yeartime
				+ "%' AND ORDER_APPRAISE.SATISFY=2  THEN 1 ELSE 0 END)," + "NVL(ROUND(SUM(CASE WHEN ORDER_APPRAISE.CREATE_TIME LIKE '" + monthtime
				+ "%' AND ORDER_APPRAISE.SATISFY=1  THEN 1 ELSE 0 END)/DECODE(SUM(CASE WHEN ORDER_APPRAISE.CREATE_TIME LIKE '" + monthtime + "%' THEN 1 ELSE 0 END),0,1,SUM(CASE WHEN ORDER_APPRAISE.CREATE_TIME LIKE '" + monthtime + "%' THEN 1 ELSE 0 END))*100,2),0),"
				+ "NVL(ROUND(SUM(CASE WHEN ORDER_APPRAISE.CREATE_TIME LIKE '" + monthtime + "%' AND ORDER_APPRAISE.SATISFY=2  THEN 1 ELSE 0 END)/DECODE(SUM(CASE WHEN ORDER_APPRAISE.CREATE_TIME LIKE '"
				+ monthtime + "%' THEN 1 ELSE 0 END),0,1,SUM(CASE WHEN ORDER_APPRAISE.CREATE_TIME LIKE '"
				+ monthtime + "%' THEN 1 ELSE 0 END))*100,2),0)," + "NVL(ROUND(SUM(CASE WHEN ORDER_APPRAISE.CREATE_TIME LIKE '" + yeartime
				+ "%' AND ORDER_APPRAISE.SATISFY=1  THEN 1 ELSE 0 END)/DECODE(SUM(CASE WHEN ORDER_APPRAISE.CREATE_TIME LIKE '" + yeartime + "%' THEN 1 ELSE 0 END),0,1,SUM(CASE WHEN ORDER_APPRAISE.CREATE_TIME LIKE '" + yeartime + "%' THEN 1 ELSE 0 END))*100,2),0),"
				+ "NVL(ROUND(SUM(CASE WHEN ORDER_APPRAISE.CREATE_TIME LIKE '" + yeartime + "%' AND ORDER_APPRAISE.SATISFY=2  THEN 1 ELSE 0 END)/DECODE(SUM(CASE WHEN ORDER_APPRAISE.CREATE_TIME LIKE '"
				+ yeartime + "%' THEN 1 ELSE 0 END),0,1,SUM(CASE WHEN ORDER_APPRAISE.CREATE_TIME LIKE '"
				+ yeartime + "%' THEN 1 ELSE 0 END))*100,2),0)," 
				+ "NVL(ROUND(SUM(CASE WHEN ORDER_APPRAISE.CREATE_TIME LIKE '" + daytime
				+ "%' AND ORDER_APPRAISE.SATISFY=1  THEN 1 ELSE 0 END)/DECODE(SUM(CASE WHEN ORDER_APPRAISE.CREATE_TIME LIKE '" + daytime + "%' THEN 1 ELSE 0 END),0,1,SUM(CASE WHEN ORDER_APPRAISE.CREATE_TIME LIKE '" + daytime + "%' THEN 1 ELSE 0 END))*100,2),0),"
				+ "NVL(ROUND(SUM(CASE WHEN ORDER_APPRAISE.CREATE_TIME LIKE '" + daytime + "%' AND ORDER_APPRAISE.SATISFY=2  THEN 1 ELSE 0 END)/DECODE(SUM(CASE WHEN ORDER_APPRAISE.CREATE_TIME LIKE '"
				+ daytime + "%' THEN 1 ELSE 0 END),0,1,SUM(CASE WHEN ORDER_APPRAISE.CREATE_TIME LIKE '"
				+ daytime + "%' THEN 1 ELSE 0 END))*100,2),0)"
				+ " FROM DICT1 LEFT JOIN ORDEN ON (DICT1.ID=ORDEN.CLOTHINGID) LEFT JOIN ORDER_APPRAISE ON ORDEN.ORDENID=ORDER_APPRAISE.ORDER_NO"
				+ " WHERE DICT1.CATEGORYID=1 AND DICT1.PARENTID=0";
		if(StringUtils.isNotBlank(name)){
			strSQL+=" AND DICT1.NAME like'"+name+"%'";
		}
		strSQL+=" GROUP BY DICT1.ID,DICT1.NAME";
		SQLQuery sql = dao.openSession().createSQLQuery(strSQL);
		List list = sql.list();
		return list;
	}
    /**
     * 获取客户周期评价报表
     * @param username
     * @param date
     * @param pageIndex
     * @param pageSize
     * @return
     */
	public List getCustomerPeriodAppraiseReport(String username,Date date,int pageIndex,int pageSize) {
		if(date==null){
			date=new Date();
		}
		String time=DateUtils.formatDate(date, "yyyy-MM-dd");
		String daytime = time;
		String monthtime = time.substring(0, 7);
		String yeartime = time.substring(0, 4);
		String strSQL = "";
		strSQL += "SELECT MEMBER.USERNAME,MEMBER.NAME," + "SUM(CASE WHEN to_char(ORDEN.DELIVERYDATE,'yyyy-MM-dd hh24:mi:ss') LIKE '"+daytime+"%' THEN 1 ELSE 0 END),"
				+ "SUM(CASE WHEN ORDER_APPRAISE.CREATE_TIME LIKE '"+daytime+"%' THEN 1 ELSE 0 END),"
				+ "SUM(CASE WHEN ORDER_APPRAISE.CREATE_TIME LIKE '"+daytime+"%' AND ORDER_APPRAISE.SATISFY=1  THEN 1 ELSE 0 END),"
				+ "SUM(CASE WHEN ORDER_APPRAISE.CREATE_TIME LIKE '"+daytime+"%' AND ORDER_APPRAISE.SATISFY=2  THEN 1 ELSE 0 END),"
				+ "SUM(CASE WHEN to_char(ORDEN.DELIVERYDATE,'yyyy-MM-dd hh24:mi:ss') LIKE '"+monthtime+"%' THEN 1 ELSE 0 END)," + "SUM(CASE WHEN ORDER_APPRAISE.CREATE_TIME LIKE '"+monthtime+"%' THEN 1 ELSE 0 END),"
				+ "SUM(CASE WHEN ORDER_APPRAISE.CREATE_TIME LIKE '"+monthtime+"%' AND ORDER_APPRAISE.SATISFY=1  THEN 1 ELSE 0 END),"
				+ "SUM(CASE WHEN ORDER_APPRAISE.CREATE_TIME LIKE '"+monthtime+"%' AND ORDER_APPRAISE.SATISFY=2  THEN 1 ELSE 0 END)," + "SUM(CASE WHEN to_char(ORDEN.DELIVERYDATE,'yyyy-MM-dd hh24:mi:ss') LIKE '"+yeartime+"%' THEN 1 ELSE 0 END),"
				+ "SUM(CASE WHEN ORDER_APPRAISE.CREATE_TIME LIKE '"+yeartime+"%' THEN 1 ELSE 0 END),"
				+ "SUM(CASE WHEN ORDER_APPRAISE.CREATE_TIME LIKE '"+yeartime+"%' AND ORDER_APPRAISE.SATISFY=1  THEN 1 ELSE 0 END),"
				+ "SUM(CASE WHEN ORDER_APPRAISE.CREATE_TIME LIKE '"+yeartime+"%' AND ORDER_APPRAISE.SATISFY=2  THEN 1 ELSE 0 END),"
				+"NVL(ROUND(SUM(CASE WHEN ORDER_APPRAISE.CREATE_TIME LIKE '"+monthtime+"%' AND ORDER_APPRAISE.SATISFY=1  THEN 1 ELSE 0 END)/DECODE(SUM(CASE WHEN ORDER_APPRAISE.CREATE_TIME LIKE '"+monthtime+"%' THEN 1 ELSE 0 END),0,1,SUM(CASE WHEN ORDER_APPRAISE.CREATE_TIME LIKE '"+monthtime+"%' THEN 1 ELSE 0 END))*100,2),0),"
                +"NVL(ROUND(SUM(CASE WHEN ORDER_APPRAISE.CREATE_TIME LIKE '"+monthtime+"%' AND ORDER_APPRAISE.SATISFY=2  THEN 1 ELSE 0 END)/DECODE(SUM(CASE WHEN ORDER_APPRAISE.CREATE_TIME LIKE '"+monthtime+"%' THEN 1 ELSE 0 END),0,1,SUM(CASE WHEN ORDER_APPRAISE.CREATE_TIME LIKE '"+monthtime+"%' THEN 1 ELSE 0 END))*100,2),0),"
                +"NVL(ROUND(SUM(CASE WHEN ORDER_APPRAISE.CREATE_TIME LIKE '"+yeartime+"%' AND ORDER_APPRAISE.SATISFY=1  THEN 1 ELSE 0 END)/DECODE(SUM(CASE WHEN ORDER_APPRAISE.CREATE_TIME LIKE '"+yeartime+"%' THEN 1 ELSE 0 END),0,1,SUM(CASE WHEN ORDER_APPRAISE.CREATE_TIME LIKE '"+yeartime+"%' THEN 1 ELSE 0 END))*100,2),0),"
                +"NVL(ROUND(SUM(CASE WHEN ORDER_APPRAISE.CREATE_TIME LIKE '"+yeartime+"%' AND ORDER_APPRAISE.SATISFY=2  THEN 1 ELSE 0 END)/DECODE(SUM(CASE WHEN ORDER_APPRAISE.CREATE_TIME LIKE '"+yeartime+"%' THEN 1 ELSE 0 END),0,1,SUM(CASE WHEN ORDER_APPRAISE.CREATE_TIME LIKE '"+yeartime+"%' THEN 1 ELSE 0 END))*100,2),0),"
                +"CASE WHEN SUM(CASE WHEN ORDER_APPRAISE.CREATE_TIME LIKE '"+daytime+"%' THEN 1 ELSE 0 END)=0 THEN 0 ELSE NVL(ROUND(SUM(CASE WHEN ORDER_APPRAISE.CREATE_TIME LIKE '"+daytime+"%' AND ORDER_APPRAISE.SATISFY=1  THEN 1 ELSE 0 END)/DECODE(SUM(CASE WHEN ORDER_APPRAISE.CREATE_TIME LIKE '"+daytime+"%' THEN 1 ELSE 0 END),0,1,SUM(CASE WHEN ORDER_APPRAISE.CREATE_TIME LIKE '"+daytime+"%' THEN 1 ELSE 0 END))*100,2),0) END,"
                +"CASE WHEN SUM(CASE WHEN ORDER_APPRAISE.CREATE_TIME LIKE '"+daytime+"%' THEN 1 ELSE 0 END)=0 THEN 0 ELSE NVL(ROUND(SUM(CASE WHEN ORDER_APPRAISE.CREATE_TIME LIKE '"+daytime+"%' AND ORDER_APPRAISE.SATISFY=2  THEN 1 ELSE 0 END)/DECODE(SUM(CASE WHEN ORDER_APPRAISE.CREATE_TIME LIKE '"+daytime+"%' THEN 1 ELSE 0 END),0,1,SUM(CASE WHEN ORDER_APPRAISE.CREATE_TIME LIKE '"+daytime+"%' THEN 1 ELSE 0 END))*100,2),0) END"
				+" FROM MEMBER INNER JOIN ORDER_APPRAISE ON ORDER_APPRAISE.MEMBER_ID=MEMBER.ID INNER JOIN ORDEN ON ORDEN.ORDENID=ORDER_APPRAISE.ORDER_NO"
				+ " WHERE MEMBER.STATUSID=10042 AND MEMBER.GROUPID IN(10015,10016,10017,10018) ";
				if(StringUtils.isNotBlank(username)){
					strSQL+="AND MEMBER.USERNAME like '"+username+"%'";
				}
				strSQL+=" GROUP BY MEMBER.USERNAME,MEMBER.NAME";
		SQLQuery sql=dao.openSession().createSQLQuery(strSQL);
		if(pageSize!=0){
			sql.setFirstResult(pageIndex*pageSize);
			sql.setMaxResults(pageSize);
		}
		List list=sql.list();
		return list;
	}

	/**
	 * 获取客户评价报表
	 * @param username
	 * @param appraisetimeStart
	 * @param appraisetimeStop
	 * @param pageIndex
	 * @param pageSize
	 * @return
	 */
	public List getAppraiseReport(String username, String appraisetimeStart, String appraisetimeStop, int pageIndex, int pageSize) {
		String strSQL = "";
		strSQL += "SELECT m.USERNAME,m.NAME," + "COUNT(oa.ID) ," + "SUM(DECODE(SATISFY,1,1,0))," + "SUM(DECODE(SATISFY,2,1,0))," + "NVL(ROUND(SUM(DECODE(SATISFY,1,1))/COUNT(oa.ID)*100,2),0),"
				+ "NVL(ROUND(SUM(DECODE(SATISFY,2,1))/COUNT(oa.ID)*100,2),0)," + "SUM(CASE WHEN REASON LIKE '1' THEN 1 WHEN REASON LIKE '1,%' THEN 1 WHEN REASON LIKE '%,1,%' THEN 1 ELSE 0 END  ),"
				+ "SUM(CASE WHEN REASON LIKE '2' THEN 1 WHEN REASON LIKE '2,%' THEN 1 WHEN REASON LIKE '%,2,%' THEN 1 ELSE 0 END  ),"
				+ "SUM(CASE WHEN REASON LIKE '3' THEN 1 WHEN REASON LIKE '3,%' THEN 1 WHEN REASON LIKE '%,3,%' THEN 1 ELSE 0 END  ),"
				+ "SUM(CASE WHEN REASON LIKE '4' THEN 1 WHEN REASON LIKE '4,%' THEN 1 WHEN REASON LIKE '%,4,%' THEN 1 ELSE 0 END  )" + "FROM Order_Appraise oa"
				+ " INNER JOIN MEMBER m ON oa.Member_Id=m.ID";
		strSQL += " where 1=1";
		if (StringUtils.isNotBlank(username)) {
			strSQL += " and m.USERNAME like '" + username + "%'";
		}
		if (StringUtils.isNotBlank(appraisetimeStart)) {
			strSQL += " and oa.create_time>='" + appraisetimeStart + "'";
		}
		if (StringUtils.isNotBlank(appraisetimeStop)) {
			strSQL += " and oa.create_time<'" + appraisetimeStop + "'";
		}
		strSQL += " GROUP BY m.USERNAME,m.NAME";
		SQLQuery sql = dao.openSession().createSQLQuery(strSQL);
		if (pageSize != 0) {
			sql.setFirstResult(pageIndex*pageSize);
			sql.setMaxResults(pageSize);
		}
		List list = sql.list();
		return list;
	}

}
