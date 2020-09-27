package hongling.business;
import hongling.util.DateUtils;

import java.util.Date;

import org.apache.commons.lang.StringUtils;
import org.hibernate.Query;
import chinsoft.core.DataAccessObject;
import chinsoft.core.Utility;
public class ShippinglistManager {
	
	private DataAccessObject dao=new DataAccessObject();
	/**
	 * 获取用户在一定时间内发货的订单数
	 * @param memberid 用户id
	 * @param time 时间 "yyyy-MM-dd hh:mm:ss"
	 * @return
	 */
	public long getOrdenCountByMemberAndTime(String memberid,Date date,int dateamount){
		if(date==null){
			date=new Date();
		}
		Date date2=DateUtils.dateAddDay(date, dateamount);
		String time=DateUtils.formatDate(date2,"yyyy-MM-dd");
		String time2=DateUtils.formatDate(date,"yyyy-MM-dd");
		String sql="";
		sql+="select count(*) from Orden where deliveryid in(select code from ShippingList where shipping_date>='"+time+"' and shipping_date<='"+time2+"' and member_id='"+memberid+"')";
		Query query=dao.openSession().createQuery(sql);
		return Utility.toSafeLong(query.uniqueResult());
	}
	/**
	 * 获取服装分类在一定时间内发货的订单数
	 * @param clothType
	 * @param date
	 * @param dateamount
	 * @return
	 */
	public long getOrdenCountByclothtypeAndTime(String clothType,Date date,int dateamount){
		if(date==null){
			date=new Date();
		}
		Date date2=DateUtils.dateAddDay(date, dateamount);
		String time=DateUtils.formatDate(date2,"yyyy-MM-dd");
		String nowdate=DateUtils.formatDate(date,"yyyy-MM-dd");
		String sql="";
		sql+="select id from Dict where categoryid=1 and parentid=0 and code='"+clothType+"'";
		Query q=dao.openSession().createQuery(sql);
		String clothid=Utility.toSafeString(q.uniqueResult());
		sql="";
		sql+="select count(*) from Orden where deliveryid in(select code from ShippingList where shipping_date>='"+time+"' and shipping_date<='"+nowdate+"') and clothingid="+clothid;
		//System.out.println(sql);
		Query query=dao.openSession().createQuery(sql);
		return Utility.toSafeLong(query.uniqueResult());
		
	}

}
