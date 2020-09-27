package centling.business;

import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

import org.hibernate.Query;
import org.hibernate.SQLQuery;
import org.hibernate.transform.Transformers;

import centling.dto.DeliveredOrdenDto;
import chinsoft.business.CDict;
import chinsoft.business.DictManager;
import chinsoft.core.DataAccessObject;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.entity.Dict;

public class BlOrdenManager {
	DataAccessObject dao = new DataAccessObject();
	
	@SuppressWarnings("unchecked")
	public List<DeliveredOrdenDto> getBlDeliveredOrdenDtos(int nPageIndex, int nPageSize,
			String strKeyword, int nStatusID, int nClothingID, 
			Date pubDate,Date pubToDate,Date deliveryDate,Date deliveryToDate, Date dealDate, Date dealToDate, 
			String strPubMemberID) {
		List<DeliveredOrdenDto> list = new ArrayList<DeliveredOrdenDto>();
		try {
			Query query = getBlDeliveredOrdenDtosQuery(
					"o.OrdenID as ordenID,cn.Name as clothingName,c.Name as customerName,o.FabricCode as fabricCode," +
					"to_char(o.PubDate,'yyyy-mm-dd') as pubDate,to_char(o.DeliveryDate,'yyyy-mm-dd') as deliveryDate,to_char(o.Jhrq,'yyyy-mm-dd') as dealDate,nvl(o.ChuKudanId,' ') as chukudanId,o.statusID,o.UserordeNo",
					strKeyword, nStatusID, nClothingID, 
					pubDate,pubToDate,deliveryDate,deliveryToDate, dealDate, dealToDate, 
					strPubMemberID);
			query.setFirstResult(nPageIndex * nPageSize);
			query.setMaxResults(nPageSize);
			List<Object[]> list1=query.list();
			int i=0;
			for(Object[] o: list1){
				String strStatusName = DictManager.getDictNameByID(Utility.toSafeInt(o[8]));
				DeliveredOrdenDto dto = new DeliveredOrdenDto(
						++i,
						o[0].toString().trim(),
						o[1].toString().trim(),
						o[2].toString().trim(),
						o[3].toString().trim(),
						o[4].toString().trim(),
						o[5]==null?"":o[5].toString().trim(),
						o[6]==null?"":o[6].toString().trim(),
						o[7]==null?"":o[7].toString().trim(),
						strStatusName,
						o[9]==null?"":o[9].toString().trim()
						);
				list.add(dto);
			}
		} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		} finally {
			DataAccessObject.closeSession();
		}
		return list;
	}
	
	public long getBlDeliveredOrdenDtosCount(String strKeyword, int nStatusID, int nClothingID, 
			Date pubDate,Date pubToDate,Date deliveryDate, Date deliveryToDate, Date dealDate, Date dealToDate, 
			String strPubMemberID) {
		long count = 0;
		try {
			Query query = getBlDeliveredOrdenDtosQuery("COUNT(*)", strKeyword, nStatusID, nClothingID, 
					pubDate,pubToDate,deliveryDate,deliveryToDate, dealDate, dealToDate, 
					strPubMemberID);
			count = Utility.toSafeLong(query.uniqueResult());
		} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		} finally {
			DataAccessObject.closeSession();
		}
		return count;
	}
	
	private Query getBlDeliveredOrdenDtosQuery(String strChange, String strKeyword, int nStatusID, int nClothingID, 
			Date pubDate,Date pubToDate,Date deliveryDate,Date deliveryToDate, Date dealDate, Date dealToDate, 
			String strPubMemberID) {
		StringBuffer sb = new StringBuffer();
		sb.append("select " + strChange + " ");
		sb.append("from Orden o left join Dict cn  ");
		sb.append("             on o.clothingid=cn.ID  ");
		sb.append("             left join Member m ");
		sb.append("             on o.pubMemberID=m.ID ");
		sb.append("             left join Customer c  ");
		sb.append("             on o.customerid=c.ID  ");
		sb.append("             left join Delivery d  ");
		sb.append("             on o.deliveryid=d.ID  ");
		sb.append("where 1=1 ");
		if (strKeyword!=null && !"".equals(strKeyword)){
			sb.append(" AND (upper(o.OrdenID) like upper(:Keyword)");       // 订单号
			sb.append("      OR upper(cn.Name) like upper(:Keyword)");      // 产品分类
			sb.append("      OR upper(c.Name) like upper(:Keyword)");       // 姓名
			sb.append("      OR upper(o.FabricCode) like upper(:Keyword)"); // 面料
			sb.append("      OR upper(o.ChuKudanId) like upper(:Keyword)");// 出库单号
			sb.append("      OR upper(o.UserordeNo) like upper(:Keyword))");// 客户单号
		}
		if (nStatusID != -1 && !CDict.OrdenStatusStop.getID().equals(nStatusID)) {
			sb.append(" AND o.StatusID = :StatusID  AND o.IsStop = :IsStop ");
		}
		if (nClothingID != -1) {
			sb.append(" AND o.ClothingID = :ClothingID ");
		}
		if (CDict.OrdenStatusStop.getID().equals(nStatusID)) {
			sb.append(" AND o.IsStop = :IsStop ");
		}
		if (pubDate != null && pubToDate != null) {
			sb.append(" AND o.PubDate >= :PubDate AND o.PubDate <= :PubToDate ");
		}
		if (deliveryDate != null && deliveryToDate != null) {
			sb.append(" AND o.DeliveryDate >= :DeliveryDate AND o.DeliveryDate <= :DeliveryToDate ");
		}
		if (dealDate != null && dealToDate != null) {
			sb.append(" AND o.Jhrq >= :DealDate AND o.Jhrq <= :DealToDate ");
		}
		if (!"-1".equals(strPubMemberID)) {
			sb.append(" AND o.PubMemberID = :PubMemberID ");
		}
		sb.append(" ORDER BY o.SysCode DESC ");
		Query query = DataAccessObject.openSession().createSQLQuery(sb.toString());		
		if (strKeyword!=null && !"".equals(strKeyword)){
			query.setString("Keyword", "%" + strKeyword + "%");
		}
		if (nStatusID != -1 && !CDict.OrdenStatusStop.getID().equals(nStatusID)) {
			query.setInteger("StatusID", nStatusID);
			query.setInteger("IsStop", CDict.NO.getID());
		}
		if (nClothingID != -1) {
			query.setInteger("ClothingID", nClothingID);
		}
		if (CDict.OrdenStatusStop.getID().equals(nStatusID)) {
			query.setInteger("IsStop", CDict.YES.getID());
		}		
		if (pubDate != null && pubToDate != null) {
			query.setDate("PubDate", pubDate);
			query.setDate("PubToDate", pubToDate);
		}	
		if (deliveryDate != null && deliveryToDate != null) {
			query.setDate("DeliveryDate", deliveryDate);
			query.setDate("DeliveryToDate", deliveryToDate);
		}	
		if (dealDate != null && dealToDate != null) {
			query.setDate("DealDate", dealDate);
			query.setDate("DealToDate", dealToDate);
		}
		if (!"-1".equals(strPubMemberID)) {
			query.setString("PubMemberID", strPubMemberID);
		}
		return query;
	}

	/**
	 * 获取订单状态及条数
	 * @param strKeyword
	 * @param nClothingID
	 * @param strPubMemberID
	 * @param fromDate
	 * @param toDate
	 * @param dealDate
	 * @param dealToDate
	 * @param strMemberCode
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<Dict> getStatusStatistic(String strKeyword, int nClothingID,
			String strPubMemberID, Date fromDate, Date toDate, Date dealDate,
			Date dealToDate, String strMemberCode) {
		if(nClothingID==10000){
			nClothingID=1;
		}
		List<Dict> status = new ArrayList<Dict>();
		try {
			StringBuffer hql = new StringBuffer();
			hql.append("SELECT o.StatusID,COUNT(1) FROM Orden o,Member m,Customer c WHERE o.PubMemberID = m.ID AND c.ID = o.CustomerID AND m.Code LIKE  :Code  AND o.IsStop = :IsStop ");
			hql.append("AND (upper(c.Tel) LIKE upper(:Keyword) OR upper(c.Address) LIKE upper(:Keyword) OR upper(c.Name) LIKE upper(:Keyword) OR o.OrdenID LIKE :Keyword OR o.FabricCode LIKE :Keyword or o.userordeNo LIKE :Keyword) ");
			if (nClothingID != -1) {
				hql.append(" AND o.ClothingID = :ClothingID ");
			}
			if (!"-1".equals(strPubMemberID)) {
				hql.append(" AND o.PubMemberID = :PubMemberID ");
			}
			if (fromDate != null && !"".equals(fromDate)) {
				hql.append(" AND TO_CHAR(o.PubDate,'yyyy-MM-dd')>=TO_CHAR(:FromDate,'yyyy-MM-dd') ");
			}
			if (toDate != null && !"".equals(toDate)) {
				hql.append(" AND TO_CHAR(o.PubDate,'yyyy-MM-dd')<=TO_CHAR(:ToDate,'yyyy-MM-dd') ");
			}
			if (dealDate!=null && !"".equals(dealDate)) {
				hql.append(" AND TO_CHAR(o.Jhrq,'yyyy-MM-dd')>=TO_CHAR(:DealDate,'yyyy-MM-dd') ");
			}
			if (dealToDate != null && !"".equals(dealToDate)) {
				hql.append(" AND TO_CHAR(o.Jhrq,'yyyy-MM-dd')<=TO_CHAR(:DealToDate,'yyyy-MM-dd') ");
			}
			hql.append("GROUP BY o.StatusID");
			SQLQuery query = DataAccessObject.openSession().createSQLQuery(hql.toString());
			query.setString("Code", strMemberCode + "%");
			query.setInteger("IsStop", CDict.NO.getID());
			query.setString("Keyword", "%"+strKeyword+"%");
			if (nClothingID != -1) {
				query.setInteger("ClothingID", nClothingID);
			}
			if (!"-1".equals(strPubMemberID)) {
				query.setString("PubMemberID", strPubMemberID);
			}
			if (fromDate != null && !"".equals(fromDate)) {
				query.setDate("FromDate", fromDate);
			}
			if (toDate != null && !"".equals(toDate)) {
				query.setDate("ToDate", toDate);
			}
			if (dealDate!=null && !"".equals(dealDate)) {
				query.setDate("DealDate", dealDate);
			}
			if (dealToDate != null && !"".equals(dealToDate)) {
				query.setDate("DealToDate", dealToDate);
			}
			List<Object[]> result = query.list();
			for (Iterator<Object[]> it = result.iterator(); it.hasNext();) {
				Object[] row = it.next();
				Dict dict = DictManager.getDictByID(Utility.toSafeInt(row[0]));
				dict.setName(dict.getName() + "(" + row[1] + ")");
				status.add(dict);
			}
			StringBuffer hql1 = new StringBuffer();
			
			hql1.append("SELECT o.IsStop,COUNT(1) FROM Orden o,Member m,Customer c  WHERE o.PubMemberID = m.ID AND c.ID = o.CustomerID AND m.Code LIKE  :Code AND o.IsStop = :IsStop ");
			hql1.append("AND (upper(c.Tel) LIKE upper(:Keyword) OR upper(c.Address) LIKE upper(:Keyword) OR upper(c.Name) LIKE upper(:Keyword) OR o.OrdenID LIKE :Keyword OR o.FabricCode LIKE :Keyword or o.userordeNo LIKE :Keyword) ");
			if (nClothingID != -1) {
				hql1.append(" AND o.ClothingID = :ClothingID ");
			}
			if (!"-1".equals(strPubMemberID)) {
				hql1.append(" AND o.PubMemberID = :PubMemberID ");
			}
			if (fromDate != null && !"".equals(fromDate)) {
				hql1.append(" AND TO_CHAR(o.PubDate,'yyyy-MM-dd')>=TO_CHAR(:FromDate,'yyyy-MM-dd') ");
			}
			if (toDate != null && !"".equals(toDate)) {
				hql1.append(" AND TO_CHAR(o.PubDate,'yyyy-MM-dd')<=TO_CHAR(:ToDate,'yyyy-MM-dd') ");
			}
			if (dealDate!=null && !"".equals(dealDate)) {
				hql1.append(" AND TO_CHAR(o.Jhrq,'yyyy-MM-dd')>=TO_CHAR(:DealDate,'yyyy-MM-dd') ");
			}
			if (dealToDate != null && !"".equals(dealToDate)) {
				hql1.append(" AND TO_CHAR(o.Jhrq,'yyyy-MM-dd')<=TO_CHAR(:DealToDate,'yyyy-MM-dd') ");
			}
			hql1.append(" GROUP BY o.IsStop");
			SQLQuery query1 = DataAccessObject.openSession().createSQLQuery(hql1.toString());
			query1.setString("Code", strMemberCode + "%");
			query1.setInteger("IsStop", CDict.YES.getID());
			query1.setString("Keyword", "%"+strKeyword+"%");
			if (nClothingID != -1) {
				query1.setInteger("ClothingID", nClothingID);
			}
			if (!"-1".equals(strPubMemberID)) {
				query1.setString("PubMemberID", strPubMemberID);
			}
			if (fromDate != null && !"".equals(fromDate)) {
				query1.setDate("FromDate", fromDate);
			}
			if (toDate != null && !"".equals(toDate)) {
				query1.setDate("ToDate", toDate);
			}
			if (dealDate!=null && !"".equals(dealDate)) {
				query1.setDate("DealDate", dealDate);
			}
			if (dealToDate != null && !"".equals(dealToDate)) {
				query1.setDate("DealToDate", dealToDate);
			}
			List<Object[]> result1 = query1.list();
			for (Iterator<Object[]> it1 = result1.iterator(); it1.hasNext();) {
				Object[] row = (Object[]) it1.next();
				if (row[0] != null) {
					Dict dict = DictManager.getDictByID(CDict.OrdenStatusStop
							.getID());
					dict.setName(dict.getName() + "(" + row[1] + ")");
					status.add(dict);
				}
			}
		} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		} finally {
			DataAccessObject.closeSession();
		}
		return status;
	}
	
	public List getStatusList(
			String strKeyword, String strMemberCode,
			int nClothingID, String dealDate, String dealToDate, String fromDate,
			String toDate, String strPubMemberID){
		
		if(nClothingID==10000){
			nClothingID=1;
		}
		StringBuilder sb=new StringBuilder();
		sb.append("select o.statusid,o.isstop,(select d.name from dict d where d.id=o.statusid) as sname,count(1) c from orden o ")
		.append(" left join member m on o.pubmemberid=m.id left join customer c on c.id=o.customerid left join dict d on o.clothingid=d.id")
		.append(" where (upper(c.tel) like '%"+strKeyword+"%' or upper(c.address) like '%"+strKeyword+"%' or upper(c.name) like '%"+strKeyword+"%' or upper(o.ordenid) like '%"+strKeyword+"%' or upper(o.fabriccode) like '%"+strKeyword+"%' or upper(o.userordeNo) like '%" + strKeyword + "%') ");
		sb.append(" and m.code like '%"+strMemberCode+"%'");
		if (!"-1".equals(strPubMemberID)) {
			sb.append(" and o.pubmemberid ='"+strPubMemberID+"'");
		}
		if (nClothingID != -1) {
		  sb.append(" and o.clothingid ="+nClothingID);
		}
		if (fromDate != null && !"".equals(fromDate)) {
		  sb.append(" and to_char(o.pubdate,'yyyy-MM-dd')>='"+fromDate+"'");
		}
		if (toDate != null && !"".equals(toDate)) {
		  sb.append(" and to_char(o.pubdate,'yyyy-MM-dd')<='"+toDate+"'");
		}
		if (dealDate != null&&!"".equals(dealDate)&&!"".equals(dealToDate)&& dealToDate != null) {
			  sb.append(" and to_char(o.jhrq,'yyyy-MM-dd')>='"+dealDate+"'and to_char(o.jhrq,'yyyy-MM-dd')<='"+dealToDate+"'");
		}
		sb.append(" group by o.statusid,o.isstop");
		 Query query=DataAccessObject.openSession().createSQLQuery(sb.toString()).setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP);
		List list=query.list();
		return list;
	}
}
