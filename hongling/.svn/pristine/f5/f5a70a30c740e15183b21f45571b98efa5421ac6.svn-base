package chinsoft.business;

import hongling.util.DateUtils;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.hibernate.Query;
import org.hibernate.SQLQuery;

import chinsoft.bean.RepairOrdenBean;
import chinsoft.core.DataAccessObject;
import chinsoft.core.Utility;

public class RepairOrdenManager {
	
	private DataAccessObject dao=new DataAccessObject();
	
	/**
	 * 返修一级报表
	 * @param category
	 * @param begindate
	 * @return
	 */

	public List<RepairOrdenBean> getOrdenOneReport(String name,Date date) {
		if(date==null){
			date = new Date();
		}
		String time = DateUtils.formatDate(date, "yyyy-MM-dd");
		String daytime = time;    //日
		String monthtime = time.substring(0, 7);   //月
		String yeartime = time.substring(0, 4);    //年
		String strSQL="";
		strSQL  = " select ";
		strSQL += "    REPAIR_DETAIL.CLOTH,";
		strSQL += "    max(DICT.NAME),";
		strSQL += "    COUNT(REPAIR_DETAIL.ID),";

        //获取日下单量
		strSQL += "    (SELECT COUNT(ORDENDETAIL.ID) "
				+ "         FROM ORDEN INNER JOIN ORDENDETAIL ON  ORDENDETAIL.ORDENID=ORDEN.ORDENID"
				+ "         INNER JOIN DICT ON DICT.ID=ORDENDETAIL.SINGLECLOTHINGID "
				+ "         WHERE TO_CHAR(ORDEN.PUBDATE,'yyyy-MM-dd') ='"+daytime+"' AND DICT.ECODE=REPAIR_DETAIL.CLOTH and ORDEN.ISDELETE is null and ORDEN.STATUSID not in(10035,10370,10372)),";
        //获取月下单量
		strSQL += "    (SELECT COUNT(ORDENDETAIL.ID) FROM ORDEN ";
		strSQL += "    INNER JOIN ORDENDETAIL ON  ORDENDETAIL.ORDENID=ORDEN.ORDENID ";
		strSQL += "    INNER JOIN DICT ON DICT.ID=ORDENDETAIL.SINGLECLOTHINGID ";
		strSQL += "    WHERE TO_CHAR(ORDEN.PUBDATE,'yyyy-MM-dd') LIKE '"+monthtime+"%' AND DICT.ECODE=REPAIR_DETAIL.CLOTH and ORDEN.ISDELETE is null and ORDEN.STATUSID not in(10035,10370,10372)),";
        //获取年下单量
		strSQL += "    (SELECT COUNT(ORDENDETAIL.ID) FROM ORDEN ";
		strSQL += "    INNER JOIN ORDENDETAIL ON  ORDENDETAIL.ORDENID=ORDEN.ORDENID ";
		strSQL += "    INNER JOIN DICT ON DICT.ID=ORDENDETAIL.SINGLECLOTHINGID ";
		strSQL += "    WHERE TO_CHAR(ORDEN.PUBDATE,'yyyy-MM-dd') LIKE '"+yeartime+"%' AND DICT.ECODE=REPAIR_DETAIL.CLOTH and ORDEN.ISDELETE is null and ORDEN.STATUSID not in(10035,10370,10372)),";

		strSQL += "    SUM(CASE WHEN REPAIR_ORDER.CREATE_TIME ='"+daytime+"' THEN 1 ELSE 0 END) 日返修量,";
		strSQL += "    SUM(CASE WHEN REPAIR_ORDER.CREATE_TIME LIKE '"+daytime+"%' AND REPAIR_DETAIL.Responsibility=1 THEN 1 ELSE 0 END) 尺寸原因,";
		strSQL += "    SUM(CASE WHEN REPAIR_ORDER.CREATE_TIME LIKE '"+daytime+"%' AND REPAIR_DETAIL.Responsibility=2 THEN 1 ELSE 0 END) 做工原因,";
		strSQL += "    SUM(CASE WHEN REPAIR_ORDER.CREATE_TIME LIKE '"+daytime+"%' AND REPAIR_DETAIL.Responsibility=3 THEN 1 ELSE 0 END) 版型原因,";
		strSQL += "    SUM(CASE WHEN REPAIR_ORDER.CREATE_TIME LIKE '"+daytime+"%' AND REPAIR_DETAIL.Responsibility=4 THEN 1 ELSE 0 END) 面辅料原因,";
		strSQL += "    SUM(CASE WHEN REPAIR_ORDER.CREATE_TIME LIKE '"+daytime+"%' AND REPAIR_DETAIL.Responsibility=5 THEN 1 ELSE 0 END) 顾客原因,";
		strSQL += "    SUM(CASE WHEN REPAIR_ORDER.CREATE_TIME LIKE '"+daytime+"%' AND REPAIR_DETAIL.Responsibility=6 THEN 1 ELSE 0 END) 更改款式,";
		strSQL += "    SUM(CASE WHEN REPAIR_ORDER.CREATE_TIME LIKE '"+daytime+"%' AND REPAIR_DETAIL.Responsibility=7 THEN 1 ELSE 0 END) 更改工艺,";
		strSQL += "    SUM(CASE WHEN REPAIR_ORDER.CREATE_TIME LIKE '"+daytime+"%' AND REPAIR_DETAIL.Responsibility=8 THEN 1 ELSE 0 END) 更改附件及配色料,";
		strSQL += "    NVL(ROUND(SUM(CASE WHEN REPAIR_ORDER.CREATE_TIME ='"+daytime+"' THEN 1 ELSE 0 END)/(SELECT case when COUNT (ORDENDETAIL. ID)=0 then 1 else  COUNT (ORDENDETAIL. ID) end FROM ORDEN INNER JOIN ORDENDETAIL ON  ORDENDETAIL.ORDENID=ORDEN.ORDENID INNER JOIN DICT ON DICT.ID=ORDENDETAIL.SINGLECLOTHINGID WHERE TO_CHAR(ORDEN.PUBDATE,'yyyy-MM-dd') ='"+daytime+"' AND DICT.ECODE=REPAIR_DETAIL.CLOTH)*100,2),0) 日返修率,";
		strSQL += "    SUM(CASE WHEN REPAIR_ORDER.CREATE_TIME LIKE '"+monthtime+"%' THEN 1 ELSE 0 END) 月返修量,";
		strSQL += "    SUM(CASE WHEN REPAIR_ORDER.CREATE_TIME LIKE '"+monthtime+"%' AND REPAIR_DETAIL.Responsibility=1 THEN 1 ELSE 0 END) 尺寸原因1,";
		strSQL += "    SUM(CASE WHEN REPAIR_ORDER.CREATE_TIME LIKE '"+monthtime+"%' AND REPAIR_DETAIL.Responsibility=2 THEN 1 ELSE 0 END) 做工原因1,";
		strSQL += "    SUM(CASE WHEN REPAIR_ORDER.CREATE_TIME LIKE '"+monthtime+"%' AND REPAIR_DETAIL.Responsibility=3 THEN 1 ELSE 0 END) 版型原因1,";
		strSQL += "    SUM(CASE WHEN REPAIR_ORDER.CREATE_TIME LIKE '"+monthtime+"%' AND REPAIR_DETAIL.Responsibility=4 THEN 1 ELSE 0 END) 面辅料原因1,";
		strSQL += "    SUM(CASE WHEN REPAIR_ORDER.CREATE_TIME LIKE '"+monthtime+"%' AND REPAIR_DETAIL.Responsibility=5 THEN 1 ELSE 0 END) 顾客原因1,";
		strSQL += "    SUM(CASE WHEN REPAIR_ORDER.CREATE_TIME LIKE '"+monthtime+"%' AND REPAIR_DETAIL.Responsibility=6 THEN 1 ELSE 0 END) 更改款式1,";
		strSQL += "    SUM(CASE WHEN REPAIR_ORDER.CREATE_TIME LIKE '"+monthtime+"%' AND REPAIR_DETAIL.Responsibility=7 THEN 1 ELSE 0 END) 更改工艺1,";
		strSQL += "    SUM(CASE WHEN REPAIR_ORDER.CREATE_TIME LIKE '"+monthtime+"%' AND REPAIR_DETAIL.Responsibility=8 THEN 1 ELSE 0 END) 更改附件及配色料1,";
		strSQL += "    NVL(ROUND(SUM(CASE WHEN REPAIR_ORDER.CREATE_TIME LIKE '"+monthtime+"%' THEN 1 ELSE 0 END)/(SELECT case when COUNT (ORDENDETAIL. ID)=0 then 1 else  COUNT (ORDENDETAIL. ID) end FROM ORDEN INNER JOIN ORDENDETAIL ON  ORDENDETAIL.ORDENID=ORDEN.ORDENID INNER JOIN DICT ON DICT.ID=ORDENDETAIL.SINGLECLOTHINGID WHERE TO_CHAR(ORDEN.PUBDATE,'yyyy-MM-dd') LIKE '"+monthtime+"%' AND DICT.ECODE=REPAIR_DETAIL.CLOTH)*100,2),0) 月返修率,";
		strSQL += "    SUM(CASE WHEN REPAIR_ORDER.CREATE_TIME LIKE '"+yeartime+"%' THEN 1 ELSE 0 END) 年返修量,";
		strSQL += "    SUM(CASE WHEN REPAIR_ORDER.CREATE_TIME LIKE '"+yeartime+"%' AND REPAIR_DETAIL.Responsibility=1 THEN 1 ELSE 0 END) 尺寸原因2,";
		strSQL += "    SUM(CASE WHEN REPAIR_ORDER.CREATE_TIME LIKE '"+yeartime+"%' AND REPAIR_DETAIL.Responsibility=2 THEN 1 ELSE 0 END) 做工原因2,";
		strSQL += "    SUM(CASE WHEN REPAIR_ORDER.CREATE_TIME LIKE '"+yeartime+"%' AND REPAIR_DETAIL.Responsibility=3 THEN 1 ELSE 0 END) 版型原因2,";
		strSQL += "    SUM(CASE WHEN REPAIR_ORDER.CREATE_TIME LIKE '"+yeartime+"%' AND REPAIR_DETAIL.Responsibility=4 THEN 1 ELSE 0 END) 面辅料原因2,";
		strSQL += "    SUM(CASE WHEN REPAIR_ORDER.CREATE_TIME LIKE '"+yeartime+"%' AND REPAIR_DETAIL.Responsibility=5 THEN 1 ELSE 0 END) 顾客原因2,";
		strSQL += "    SUM(CASE WHEN REPAIR_ORDER.CREATE_TIME LIKE '"+yeartime+"%' AND REPAIR_DETAIL.Responsibility=6 THEN 1 ELSE 0 END) 更改款式2,";
		strSQL += "    SUM(CASE WHEN REPAIR_ORDER.CREATE_TIME LIKE '"+yeartime+"%' AND REPAIR_DETAIL.Responsibility=7 THEN 1 ELSE 0 END) 更改工艺2,";
		strSQL += "    SUM(CASE WHEN REPAIR_ORDER.CREATE_TIME LIKE '"+yeartime+"%' AND REPAIR_DETAIL.Responsibility=8 THEN 1 ELSE 0 END) 更改附件及配色料2,";
		strSQL += "    NVL(ROUND(SUM(CASE WHEN REPAIR_ORDER.CREATE_TIME LIKE '"+yeartime+"%' THEN 1 ELSE 0 END)/(SELECT case when COUNT (ORDENDETAIL. ID)=0 then 1 else  COUNT (ORDENDETAIL. ID) end FROM ORDEN INNER JOIN ORDENDETAIL ON  ORDENDETAIL.ORDENID=ORDEN.ORDENID INNER JOIN DICT ON DICT.ID=ORDENDETAIL.SINGLECLOTHINGID WHERE TO_CHAR(ORDEN.PUBDATE,'yyyy-MM-dd') LIKE '"+yeartime+"%' AND DICT.ECODE=REPAIR_DETAIL.CLOTH)*100,2),0) 年返修率";
		strSQL += "    FROM REPAIR_ORDER INNER JOIN REPAIR_DETAIL ON REPAIR_ORDER.REPAIR_NO=REPAIR_DETAIL.REPAIR_NO INNER JOIN ORDENDETAIL ON ORDENDETAIL.ORDENID=REPAIR_ORDER.ORDER_NO";
		strSQL += "    INNER JOIN DICT ON DICT.ECODE = REPAIR_DETAIL.CLOTH";
		
		
		if(!name.equals("-1")){   //通过获取的品类名称查询
			strSQL+="  AND DICT.ID ='"+name+"'";
		}
		strSQL += "    where REPAIR_ORDER.status != 10372";
		//strSQL += "    and ORDEN.isdelete is null and ORDEN.statusid not in(10035,10370,10372)";
		strSQL += "    GROUP BY REPAIR_DETAIL.CLOTH,DICT.ECODE";





		SQLQuery sql = dao.openSession().createSQLQuery(strSQL);
		List list = sql.list();
		Iterator it = list.iterator();
		List<RepairOrdenBean> repair = new ArrayList<RepairOrdenBean>();
		while(it.hasNext()){
			Object[] result = (Object[]) it.next();
			RepairOrdenBean bean = new RepairOrdenBean();
			bean.setUserName((String) result[1]);
			bean.setNianXiadan(((BigDecimal) result[5]).toString());
			bean.setYueXiadan(((BigDecimal) result[4]).toString());
			bean.setRiXiadan(((BigDecimal) result[3]).toString());
			//bean.setNianRepair(((BigDecimal) result[26]).toString());
			//bean.setYueRepair(((BigDecimal) result[16]).toString());
			//bean.setRiRepair(((BigDecimal) result[6]).toString());
			bean.setNianRepairchicun(((BigDecimal) result[27]).toString());
			bean.setNianRepairzuogong(((BigDecimal) result[28]).toString());
			bean.setNianRepairbanxing(((BigDecimal) result[29]).toString());
			bean.setNianRepairmianfuliao(((BigDecimal) result[30]).toString());
			bean.setNianRepairgenggaiks(((BigDecimal) result[32]).toString());
			bean.setNianRepairgenggaigy(((BigDecimal) result[33]).toString());
			bean.setNianRepairgukeyy(((BigDecimal) result[31]).toString());
			bean.setNianRepairgenggaifjjpsl(((BigDecimal) result[34]).toString());
			
			bean.setYueRepairchicun(((BigDecimal) result[17]).toString());
			bean.setYueRepairzuogong(((BigDecimal) result[18]).toString());
			bean.setYueRepairbanxing(((BigDecimal) result[19]).toString());
			bean.setYueRepairmianfuliao(((BigDecimal) result[20]).toString());
			bean.setYueRepairgenggaiks(((BigDecimal) result[22]).toString());
			bean.setYueRepairgenggaigy(((BigDecimal) result[23]).toString());
			bean.setYueRepairgukeyy(((BigDecimal) result[21]).toString());
			bean.setYueRepairgenggaifjjpsl(((BigDecimal) result[24]).toString());
			
			bean.setRiRepairchicun(((BigDecimal) result[7]).toString());
			bean.setRiRepairzuogong(((BigDecimal) result[8]).toString());
			bean.setRiRepairbanxing(((BigDecimal) result[9]).toString());
			bean.setRiRepairmianfuliao(((BigDecimal) result[10]).toString());
			bean.setRiRepairgenggaiks(((BigDecimal) result[12]).toString());
			bean.setRiRepairgenggaigy(((BigDecimal) result[13]).toString());
			bean.setRiRepairgukeyy(((BigDecimal) result[11]).toString());
			bean.setRiRepairgenggaifjjpsl(((BigDecimal) result[14]).toString());
			
			bean.setNianRepairlv(((BigDecimal) result[35]).toString());
			bean.setYueRepairlv(((BigDecimal) result[25]).toString());
			bean.setRiRepairlv(((BigDecimal) result[15]).toString());
			
			repair.add(bean);
		}
		return repair;
	}

}
