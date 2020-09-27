package centling.business;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.hibernate.Query;
import org.hibernate.SQLQuery;
import org.hibernate.Session;
import org.hibernate.Transaction;

import centling.dto.DeliveryDetailDto;
import centling.dto.DeliveryDto;
import centling.dto.DeliveryOrdenDetailDto;
import centling.util.BlDateUtil;
import chinsoft.business.CDict;
import chinsoft.business.DeliveryManager;
import chinsoft.business.DictManager;
import chinsoft.business.MemberManager;
import chinsoft.core.DataAccessObject;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.entity.Delivery;
import chinsoft.entity.Dict;
import chinsoft.entity.Member;
import chinsoft.entity.Orden;

public class BlDeliveryManager {
	
	DataAccessObject dao = new DataAccessObject();
	
	public BlDeliveryManager(){
	}
	
	/**
	 * 保存发货信息
	 * @param delivery
	 */
	public void saveDelivery(Delivery delivery) {
		if (delivery == null || "".equals(delivery)) {
			return;
		}
		dao.saveOrUpdate(delivery);
	}
	
	@SuppressWarnings("unchecked")
	public List<DeliveryDetailDto> getBlDeliveryDetailList(int nPageIndex, int nPageSize, String currentMemberId, 
			String blDetailKeyword, Date deliverFromDate, Date deliverToDate){
		List<DeliveryDetailDto>  DeliveryDetailDtos = new ArrayList<DeliveryDetailDto>();
		
		Query query = getBlDeliveryDetailQuery("o", currentMemberId, 
				blDetailKeyword, deliverFromDate, deliverToDate);
		query.setFirstResult(nPageIndex * nPageSize);
		query.setMaxResults(nPageSize);
		List<Orden> ordens = (List<Orden>)query.list();
		if (ordens!=null && ordens.size()!=0) {
			DeliveryDetailDtos=ordensTO_DeliveryDetailDto(ordens);
		}
		return DeliveryDetailDtos;
	}
	
	private Query getBlDeliveryDetailQuery(String strChange, String currentMemberId, 
			String blDetailKeyword, Date deliverFromDate, Date deliverToDate) {
		StringBuffer queryString = new StringBuffer();
		queryString.append("select " + strChange + " ");
		queryString.append("from Orden o,Member m,Delivery d ");
		queryString.append("where o.PubMemberID=m.ID and o.DeliveryID=d.ID ");
		if (!"".equals(currentMemberId)){
			queryString.append("and m.ID=:currentMemberId ");
		}
		if (!"".equals(blDetailKeyword)){
			queryString.append("and (upper(m.Username) LIKE upper(:Keyword) OR upper(m.CompanyShortName) LIKE upper(:Keyword) OR upper(d.DeliveryAddress) LIKE upper(:Keyword)) ");
		}
		if (deliverFromDate!=null && deliverToDate!=null){
			queryString.append("and o.DeliveryDate>=:deliverFromDate and o.DeliveryDate<=:deliverToDate ");
		}
		queryString.append("order by o.DeliveryDate desc ");
		Query query = DataAccessObject.openSession().createQuery(queryString.toString());
		if (!"".equals(currentMemberId)){
			query.setString("currentMemberId", currentMemberId);
		}
		if (!"".equals(blDetailKeyword)){
			query.setString("Keyword", "%" + blDetailKeyword + "%");
		}
		if (deliverFromDate != null && deliverToDate != null) {
			query.setDate("deliverFromDate", deliverFromDate);
			query.setDate("deliverToDate", deliverToDate);
		}
		return query;
	}
	
	public List<DeliveryDetailDto> ordensTO_DeliveryDetailDto(List<Orden> ordens){
		List<DeliveryDetailDto> temps = new ArrayList<DeliveryDetailDto>();
		int i=0;
		for (Orden orden: ordens){
			DeliveryDetailDto temp = new DeliveryDetailDto();
			Member member = new MemberManager().getMemberByID(orden.getPubMemberID());
			Delivery delivery = new DeliveryManager().getDeliveryByID(orden.getDeliveryID());
			temp.setNumber(++i);
			temp.setOrdenID(orden.getOrdenID());
			temp.setUsername(member.getUsername());
			temp.setCompanyshortname(member.getCompanyShortName());
			temp.setDeliveryaddress(delivery.getDeliveryAddress());
			temp.setPlandeliverydate(delivery.getDeliveryDate());
			temp.setDeliverydate(orden.getDeliveryDate());
			/**
			 * TODO
			 */
			temp.setExport("");
			temp.setTrackingnumber("");// 运单号
			temps.add(temp);
		}
		return temps;
	}
	
	public long getBlDeliveryDetailCount(String currentMemberId, 
			String blDetailKeyword, Date deliverFromDate, Date deliverToDate) {
		long count = 0;
		try {
			StringBuffer queryString = new StringBuffer();
			queryString.append("select count(*) ");
			queryString.append("from Orden o,Member m,Delivery d ");
			queryString.append("where o.PubMemberID=m.ID and o.DeliveryID=d.ID ");
			if (!"".equals(currentMemberId)){
				queryString.append("and m.ID=:currentMemberId ");
			}
			if (!"".equals(blDetailKeyword)){
				queryString.append("and (upper(m.Username) LIKE upper(:Keyword) OR upper(m.CompanyShortName) LIKE upper(:Keyword) OR upper(d.DeliveryAddress) LIKE upper(:Keyword)) ");
			}
			if (deliverFromDate!=null && deliverToDate!=null){
				queryString.append("and o.DeliveryDate>=:deliverFromDate and o.DeliveryDate<=:deliverToDate ");
			}
			Query query = DataAccessObject.openSession().createQuery(queryString.toString());
			if (!"".equals(currentMemberId)){
				query.setString("currentMemberId", currentMemberId);
			}
			if (!"".equals(blDetailKeyword)){
				query.setString("Keyword", "%" + blDetailKeyword + "%");
			}
			if (deliverFromDate != null && deliverToDate != null) {
				query.setDate("deliverFromDate", deliverFromDate);
				query.setDate("deliverToDate", deliverToDate);
			}
			count = Utility.toSafeLong(query.uniqueResult());
		} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		} finally {
			DataAccessObject.closeSession();
		}
		return count;
	}
	
	/**
	 * 根据发货日期与发货周期(周)自动生成发货列表
	 * @param deliveryWeekDay 发货周期(周)
	 * @param deliveryDate 发货日期
	 * @return 执行结果  0:成功 1：失败
	 */
	public int autoGenerateDelivery(int deliveryWeekDay, Date deliveryDate) {
		int retValue = 0;
		
		// 调用存储过程，生成发货列表
		String proc = "{call BL_PROC_AUTOGENERATEDELIVERY(?,?,?)}";
		
		Session session = null;
		Transaction transaction = null;
		try {
			session = DataAccessObject.openSession();
			transaction = session.beginTransaction();
			SQLQuery sqlQuery = session.createSQLQuery(proc);
			sqlQuery.setInteger(0, deliveryWeekDay);
			sqlQuery.setDate(1, deliveryDate);
			sqlQuery.setInteger(2, Constant.BL_DELIVERY_DAYS);
			sqlQuery.executeUpdate();
			transaction.commit();
		} catch(Exception e) {
			retValue = 2;
			transaction.rollback();
			LogPrinter.error(e.getMessage());
		} finally {
			if (session != null) {
				session.close();
			}
		}
		return retValue;
	}
	
	/**
	 * 根据用户所选发货日期及订单得到提示发货日期
	 * @param deliveryDate 用户所选择的发货日期
	 * @param strOrdens 用户所选择的订单
	 * @return 系统得到的提示发货日期
	 */
	public String getHintDeliveryDateByOrden(String deliveryDate,
			String strOrdens) {
		String retValue = null;
		String sql = "SELECT MAX(jhrq) FROM Orden o WHERE OrdenID IN (:ordenIds)";
		try {
			SQLQuery sqlQuery = DataAccessObject.openSession().createSQLQuery(sql);
			sqlQuery.setParameterList("ordenIds", Utility.getStrArray(strOrdens));
			
			// 得到所选订单最大的交货日期
			Date tempDate = (Date)sqlQuery.uniqueResult();
			
			// 得到所选订单最大的发货日期
			String maxDeliveryDate = BlDateUtil.formatDate(
					BlDateUtil.addWorkDay(tempDate, Constant.BL_DELIVERY_DAYS), "yyyy-MM-dd");
			
			/**
			 * 得到提示发货日期
			 */
			if (deliveryDate.compareTo(maxDeliveryDate) < 0) {
				retValue = maxDeliveryDate;
			} else {
				retValue = deliveryDate;
			}
		} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		} finally {
			DataAccessObject.closeSession();
		}
		return retValue;
	}
	
	/**
	 * 查询发货列表
	 * @param nPageIndex 开始条数
	 * @param pageSize 每页面显示的条数
	 * @param currentMemberId 当前用户ID
	 * @param blKeyword 关键字
	 * @param deliverFromDate 开始日期
	 * @param deliverToDate 结束日期
	 * @return 查询到的发货列表
	 */
	@SuppressWarnings("unchecked")
	public List<DeliveryDto> getBlDeliveryList(int nPageIndex, int nPageSize,
			String currentMemberId, String blKeyword, String deliverFromDate,
			String deliverToDate) {
		List<DeliveryDto> list = new ArrayList<DeliveryDto>();
		
		StringBuffer sql = new StringBuffer();
		sql.append("SELECT a.ID,b.username,b.name,(a.addressline2||a.addressline1||a.city||a.countryname) as deliveryAddress,a.applyDate,a.deliveryDate,NVL(a.yundanId, '') AS yundanId, a.statusId, a.expressComId, c.name AS expressComName  ");
		sql.append("FROM Delivery a left join Member b on a.pubMemberID=b.ID left join ExpressCom c on a.expressComId = c.ID WHERE a.StatusID<>:StatusID ");
		if (currentMemberId!=null && !"".equals(currentMemberId)) {
			sql.append(" AND b.ID=:currentMemberId");
		}
		if (blKeyword!=null && !"".equals(blKeyword)) { 
			sql.append(" AND (b.username LIKE :blKeyword OR b.companyShortName LIKE :blKeyword OR a.deliveryAddress LIKE :blKeyword)");
		}
		if (deliverFromDate!=null && !"".equals(deliverFromDate)) {
			sql.append(" AND TO_CHAR(a.deliveryDate,'yyyy-MM-dd')>=:deliverFromDate");
		}
		if (deliverToDate!=null && !"".equals(deliverToDate)) {
			sql.append(" AND TO_CHAR(a.deliveryDate,'yyyy-MM-dd')<=:deliverToDate");
		}
		sql.append(" ORDER BY a.applyDate desc,a.deliveryDate desc");
		
		try {
			SQLQuery sqlQuery = DataAccessObject.openSession().createSQLQuery(sql.toString());
			
			if (currentMemberId!=null && !"".equals(currentMemberId)){
				sqlQuery.setString("currentMemberId", currentMemberId);
			}
			if (blKeyword!=null && !"".equals(blKeyword)){
				sqlQuery.setString("blKeyword", "%" + blKeyword + "%");
			}
			if (deliverFromDate != null && !"".equals(deliverFromDate)) {
				sqlQuery.setString("deliverFromDate", deliverFromDate);
			}
			if (deliverToDate != null && !"".equals(deliverToDate)) {
				sqlQuery.setString("deliverToDate", deliverToDate);
			}
			sqlQuery.setInteger("StatusID", CDict.DeliveryStateCancle.getID());
			
			sqlQuery.setFirstResult(nPageIndex * nPageSize);
			sqlQuery.setMaxResults(nPageSize);
			
			List<Object[]> resultList = sqlQuery.list();
			
			if (resultList.size() > 0) {
				// 转换结果集
				AssingnDeliveryList(resultList, list);
			}
		} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		} finally {
			DataAccessObject.closeSession();
		}
 		return list;
	}

	/**
	 * 转换结果集
	 * @param resultList
	 * @param list
	 */
	private void AssingnDeliveryList(List<Object[]> resultList,
			List<DeliveryDto> list) {
		for (int i=0; i<resultList.size(); i++) {
			Object[] obj = resultList.get(i);
			DeliveryDto DeliveryDto = new DeliveryDto();
			if (obj[0] != null) {
				DeliveryDto.setID(obj[0].toString());
			}
			if (obj[1] != null) {
				DeliveryDto.setUsername(obj[1].toString());
			}
			if (obj[2] != null) {
				DeliveryDto.setName(obj[2].toString());
			}
			if (obj[3] != null) {
				DeliveryDto.setDeliveryAddress(obj[3].toString());
			}
			if (obj[4] != null) {
				DeliveryDto.setApplyDate((Date)obj[4]);
			}
			if (obj[5] != null) {
				DeliveryDto.setDeliveryDate((Date)obj[5]);
			}
			if (obj[6] != null) {
				DeliveryDto.setYundanId(obj[6].toString());
			}
			if (obj[7] != null) {
				DeliveryDto.setStatusId(obj[7].toString());
				if (Utility.toSafeString(CDict.DeliveryStateLade.getID()).equals(DeliveryDto.getStatusId())) {
					DeliveryDto.setStatusName("是");
				} else {
					DeliveryDto.setStatusName("否");
				}
			}
			if (obj[8] != null) {
				DeliveryDto.setExpressComId(obj[8].toString());
			}
			if (obj[9] != null) {
				DeliveryDto.setExpressComName(obj[9].toString());
			}
			DeliveryDto.setNumber(i+1);
			list.add(DeliveryDto);
		}
	}

	/**
	 * 查询发货条数
	 * @param currentMemberId 当前用户ID
	 * @param blKeyword 关键字
	 * @param deliverFromDate 开始日期
	 * @param deliverToDate 结束日期
	 * @return
	 */
	public long getBlDeliveryCount(String currentMemberId, String blKeyword,
			String deliverFromDate, String deliverToDate) {
		long count = 0;
		StringBuffer sql = new StringBuffer();
		sql.append("SELECT count(*) ");
		sql.append("FROM Delivery a , Member b where a.pubMemberID=b.ID AND a.StatusID<>:StatusID ");
		if (currentMemberId!=null && !"".equals(currentMemberId)) {
			sql.append(" AND b.ID=:currentMemberId");
		}
		if (blKeyword!=null && !"".equals(blKeyword)) { 
			sql.append(" AND (b.username LIKE :blKeyword OR b.companyShortName LIKE :blKeyword OR a.deliveryAddress LIKE :blKeyword)");
		}
		if (deliverFromDate!=null && !"".equals(deliverFromDate)) {
			sql.append(" AND TO_CHAR(a.deliveryDate,'yyyy-MM-dd')>=:deliverFromDate");
		}
		if (deliverToDate!=null && !"".equals(deliverToDate)) {
			sql.append(" AND TO_CHAR(a.deliveryDate,'yyyy-MM-dd')<=:deliverToDate");
		}
		
		try {
			SQLQuery sqlQuery = DataAccessObject.openSession().createSQLQuery(sql.toString());
			
			if (currentMemberId!=null && !"".equals(currentMemberId)){
				sqlQuery.setString("currentMemberId", currentMemberId);
			}
			if (blKeyword!=null && !"".equals(blKeyword)){
				sqlQuery.setString("blKeyword", "%" + blKeyword + "%");
			}
			if (deliverFromDate != null && !"".equals(deliverFromDate)) {
				sqlQuery.setString("deliverFromDate", deliverFromDate);
			}
			if (deliverToDate != null && !"".equals(deliverToDate)) {
				sqlQuery.setString("deliverToDate", deliverToDate);
			}
			
			sqlQuery.setInteger("StatusID", CDict.DeliveryStateCancle.getID());
			
			count = Utility.toSafeLong(sqlQuery.uniqueResult());
		} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		} finally {
			DataAccessObject.closeSession();
		}
		
		return count;
	}

	/**
	 * 根据发货单ID得到发货明细
	 * @param strDeliveryID 发货单ID
	 * @return 查询到的发货单列表
	 */
	@SuppressWarnings("unchecked")
	public List<DeliveryOrdenDetailDto> getDeliveryDetailByDeliveryId(String strDeliveryID) {
		List<DeliveryOrdenDetailDto> list = new ArrayList<DeliveryOrdenDetailDto>();
		
		StringBuffer sql = new StringBuffer();
		sql.append("SELECT A.ordenID, TO_CHAR(CASE clothingID WHEN 1 THEN '1T' WHEN 2 THEN '1T+1C' WHEN 3 THEN '1A' WHEN 2000 THEN '1B' WHEN 3000 THEN '1CY' ");
		sql.append("WHEN 4000 THEN '1C' WHEN 6000 THEN '1E' END) AS amount, TO_CHAR(D.name) AS compositionName, TO_CHAR(B.GENDERID) as customSex, a.statusId, '1' AS type, a.deliveryID ");
		sql.append("FROM Orden A ");
		sql.append("LEFT JOIN Customer B ON A.CustomerID = B.ID ");
		sql.append("LEFT JOIN FABRIC C ON A.FabricID = C.ID ");
		sql.append("LEFT JOIN Dict D ON C.COMPOSITIONID = D.ID ");
		sql.append("WHERE A.DeliveryID=:deliveryID AND D.CATEGORYID='8' ");
		sql.append(" UNION ALL ");
		sql.append(" SELECT ordenID, TO_CHAR(amount) AS amount, TO_CHAR(fabricComposition) AS compositionName,TO_CHAR('1') AS customSex, statusId, '2' AS type, deliveryID FROM deliveryplus WHERE deliveryID=:deliveryPlusID ");
		sql.append(" ORDER BY ordenID ");
		
		SQLQuery sqlQuery = DataAccessObject.openSession().createSQLQuery(sql.toString());
		sqlQuery.setString("deliveryID", strDeliveryID);
		sqlQuery.setString("deliveryPlusID", strDeliveryID);
		
		List<Object[]> resultList = sqlQuery.list();
		
		if (resultList.size() > 0) {
			// 转换结果集
			AssingnDeliveryDetailList(resultList, list);
		}
		
		return list;
	}
	
	/**
	 * 获取符合条件的发货单明细
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<DeliveryOrdenDetailDto> getDeliveryDetailByDeliveryId(String currentMemberId, String strBlKeyword, String deliveryFromDate, String deliveryToDate ) {
		List<DeliveryOrdenDetailDto> list = new ArrayList<DeliveryOrdenDetailDto>();
		
		// 得到发货单ID集合
		StringBuffer deliveryIdSql = new StringBuffer();
		deliveryIdSql.append("SELECT a.ID ");
		if (currentMemberId!=null && !"".equals(currentMemberId)) {
			deliveryIdSql.append("FROM Delivery a INNER JOIN Member b on a.pubMemberID=b.ID AND a.StatusID<>:StatusID  ");
		}else{
			deliveryIdSql.append("FROM Delivery a INNER JOIN Member b on a.pubMemberID=b.ID AND a.StatusID=:StatusID ");
		}
		
		if (currentMemberId!=null && !"".equals(currentMemberId)) {
			deliveryIdSql.append(" AND b.ID=:currentMemberId");
		}
		if (strBlKeyword!=null && !"".equals(strBlKeyword)) { 
			deliveryIdSql.append(" AND (b.username LIKE :blKeyword OR b.companyShortName LIKE :blKeyword OR a.deliveryAddress LIKE :blKeyword)");
		}
		if (deliveryFromDate!=null && !"".equals(deliveryFromDate)) {
			deliveryIdSql.append(" AND TO_CHAR(a.deliveryDate,'yyyy-MM-dd')>=:deliverFromDate");
		}
		if (deliveryToDate!=null && !"".equals(deliveryToDate)) {
			deliveryIdSql.append(" AND TO_CHAR(a.deliveryDate,'yyyy-MM-dd')<=:deliverToDate");
		}
		
		// 查询发货单明细
		StringBuffer sql = new StringBuffer();
		sql.append("SELECT A.ordenID, TO_CHAR(CASE clothingID WHEN 1 THEN '1T' WHEN 2 THEN '1T+1C' WHEN 3 THEN '1A' WHEN 2000 THEN '1B' WHEN 3000 THEN '1CY' ");
		sql.append("WHEN 4000 THEN '1C' WHEN 6000 THEN '1E' END) AS amount, TO_CHAR(D.name) AS compositionName, TO_CHAR(B.GENDERID) as customSex, a.statusId,'1' AS type, A.deliveryID ");
		sql.append("FROM Orden A ");
		sql.append("LEFT JOIN Customer B ON A.CustomerID = B.ID ");
		sql.append("LEFT JOIN FABRIC C ON A.FabricID = C.ID ");
		sql.append("LEFT JOIN Dict D ON C.COMPOSITIONID = D.ID ");
		sql.append("WHERE D.CATEGORYID='8' AND A.deliveryID IN (:deliveryID)");
		sql.append(" UNION ALL ");
		sql.append(" SELECT ordenID, TO_CHAR(amount) AS amount, TO_CHAR(fabricComposition) AS compositionName,TO_CHAR('1') AS customSex, statusId, '2' AS type, deliveryID FROM deliveryplus WHERE deliveryID IN(:deliveryID) ");

		try {
			SQLQuery deliverySqlQuery = DataAccessObject.openSession().createSQLQuery(deliveryIdSql.toString());
			
			if (currentMemberId!=null && !"".equals(currentMemberId)){
				deliverySqlQuery.setString("currentMemberId", currentMemberId);
			}
			if (strBlKeyword!=null && !"".equals(strBlKeyword)){
				deliverySqlQuery.setString("blKeyword", "%" + strBlKeyword + "%");
			}
			if (deliveryFromDate != null && !"".equals(deliveryFromDate)) {
				deliverySqlQuery.setString("deliverFromDate", deliveryFromDate);
			}
			if (deliveryToDate != null && !"".equals(deliveryToDate)) {
				deliverySqlQuery.setString("deliverToDate", deliveryToDate);
			}
			if (currentMemberId!=null && !"".equals(currentMemberId)) {
				deliverySqlQuery.setInteger("StatusID", CDict.DeliveryStateCancle.getID());
			}else{
				deliverySqlQuery.setInteger("StatusID", CDict.DeliveryStateLade.getID());
			}
			
			
			List<Object[]> resultList = deliverySqlQuery.list();
		
			SQLQuery sqlQuery = DataAccessObject.openSession().createSQLQuery(sql.toString());
			sqlQuery.setParameterList("deliveryID", resultList);
		
			List<Object[]> detailResultList = sqlQuery.list();
		
			if (detailResultList.size() > 0) {
				// 转换结果集
				AssingnDeliveryDetailList(detailResultList, list);
			}
		} catch (Exception e) {
			LogPrinter.debug(e.getMessage());
		}
		
		return list;
	}
	
	/**
	 * 转换结果集
	 * @param resultList
	 * @param list
	 */
	private void AssingnDeliveryDetailList(List<Object[]> resultList,
			List<DeliveryOrdenDetailDto> list) {
		for (int i=0; i<resultList.size(); i++) {
			Object[] obj = resultList.get(i);
			DeliveryOrdenDetailDto DeliveryOrdenDetailDto = new DeliveryOrdenDetailDto();
			if (obj[0] != null) {
				DeliveryOrdenDetailDto.setOrdenID(obj[0].toString());
			}
			if (obj[1] != null) {
				DeliveryOrdenDetailDto.setAmount(obj[1].toString());
			}
			if (obj[2] != null) {
				DeliveryOrdenDetailDto.setCompositionName(obj[2].toString());
			}
			DeliveryOrdenDetailDto.setClosingType("男装");
//			if (obj[3] != null) {
//				if (CDict.GenderFemale.getID().equals(Integer.parseInt(obj[3].toString()))) {
//					DeliveryOrdenDetailDto.setClosingType("男装");
//				} else {
//					DeliveryOrdenDetailDto.setClosingType("女装");
//				}
//			}
			if (obj[4] != null) {
				DeliveryOrdenDetailDto.setStatusId(obj[4].toString());
				Dict currentStatus = DictManager.getDictByID(Integer.parseInt(obj[4].toString()));
				if (currentStatus != null) {
					DeliveryOrdenDetailDto.setStatusName(currentStatus.getName());
				}
			}
			if (obj[5] != null) {
				DeliveryOrdenDetailDto.setType(obj[5].toString());
			}
			if (obj[6] != null) {
				DeliveryOrdenDetailDto.setDeliveryID(obj[6].toString());
			}
			
			DeliveryOrdenDetailDto.setNumber(i+1);
			list.add(DeliveryOrdenDetailDto);
		}
	}
	
	/**
	 * 更新发货单明细
	 * @param strDeliveryId 发货单ID
	 * @param ordenIds 待更新的订单ID
	 */
	public void updateDeliveryDetail(String strDeliveryId, String ordenIds) {
		// 得到发货单信息
		Delivery delivery = new DeliveryManager().getDeliveryByID(strDeliveryId);
		
		String sql = "UPDATE Orden SET DeliveryID=:DeliveryID, DeliveryDate=:DeliveryDate WHERE OrdenID IN (:OrdenID)";
		
		Session session = null;
		Transaction transaction = null;
		
		try {
			session = DataAccessObject.openSession();
			transaction = session.beginTransaction();
			Query query = session.createQuery(sql);
			query.setString("DeliveryID", strDeliveryId);
			query.setDate("DeliveryDate", delivery.getDeliveryDate());
			query.setParameterList("OrdenID", Utility.getStrArray(ordenIds));
			query.executeUpdate();
			transaction.commit();
		} catch (Exception e) {
			transaction.rollback();
			LogPrinter.error(e.getMessage());
		} finally {
			if (session != null) {
				session.close();
			}
		}
	}
	
	/**
	 * 根据发货ID提货
	 * @param strDeliveryId 发货ID
	 * @param strMemo 
	 */
	public void ladeDeliveryById(String strDeliveryId, String strMemo, String yundanId) {
		String sql = "UPDATE Delivery SET StatusID=:StatusID, Memo=:Memo,YundanId=:YundanId WHERE ID=:ID";
		
		Session session = null;
		Transaction transaction = null;
		try {
			session = DataAccessObject.openSession();
			transaction = session.beginTransaction();
			Query query = session.createQuery(sql);
			query.setInteger("StatusID", CDict.DeliveryStateLade.getID());
			query.setString("Memo", strMemo);
			query.setString("ID", strDeliveryId);
			query.setString("YundanId", yundanId);
			query.executeUpdate();
			transaction.commit();
		} catch (Exception e) {
			transaction.rollback();
			LogPrinter.error(e.getMessage());
		} finally {
			DataAccessObject.closeSession();
		}
	}
	
	/**
	 * 更新运单号
	 * @param deliveryId 发货ID
	 * @param yundanId 运单号ID
	 */
	public void updateYunDanIdByDeliveryId(String deliveryId, String yundanId) {
		String sql = "UPDATE Delivery SET YundanId=:YundanId WHERE ID=:DeliveryID";
		
		Session session = null;
		Transaction transaction = null;
		try {
			session = DataAccessObject.openSession();
			transaction = session.beginTransaction();
			Query query = session.createQuery(sql);
			query.setString("YundanId", yundanId);
			query.setString("DeliveryID", deliveryId);
			query.executeUpdate();
			transaction.commit();
		} catch (Exception e) {
			transaction.rollback();
			LogPrinter.error(e.getMessage());
		} finally {
			DataAccessObject.closeSession();
		}
	}
	
	/**
	 * 撤销发货单
	 * @param strDeliveryId
	 */
	public void cancleDelivery(String strDeliveryId) {
		String sql = "UPDATE Delivery SET StatusID=:StatusID WHERE ID=:DeliveryID";
		String updateOrdenSql = "UPDATE Orden SET DeliveryID='' , DeliveryDate='' WHERE DeliveryID=:DeliveryID";
		String deleteSql = "DELETE FROM DeliveryPlus WHERE DeliveryID=:DeliveryID";
		
		Session session = null;
		Transaction transaction = null;
		try {
			session = DataAccessObject.openSession();
			transaction = session.beginTransaction();
			Query query = session.createQuery(sql);
			query.setInteger("StatusID", CDict.DeliveryStateCancle.getID());
			query.setString("DeliveryID", strDeliveryId);
			query.executeUpdate();
			
			Query updateOrdenQuery = session.createQuery(updateOrdenSql);
			updateOrdenQuery.setString("DeliveryID", strDeliveryId);
			updateOrdenQuery.executeUpdate();
			
			Query deleteQuery = session.createQuery(deleteSql);
			deleteQuery.setString("DeliveryID", strDeliveryId);
			deleteQuery.executeUpdate();
			
			transaction.commit();
		} catch (Exception e) {
			transaction.rollback();
			LogPrinter.error(e.getMessage());
		} finally {
			DataAccessObject.closeSession();
		}
	}
	
	/**
	 * 批量导出发货明细
	 * @param strBlKeyword 关键字
	 * @param deliveryFromDate 开始日期
	 * @param deliveryToDate 结束日期
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<Map<String, String>> getBatchHeadMapList(String currentMemberId, String strBlKeyword, String deliveryFromDate, String deliveryToDate) {
		List<Map<String, String>> headMapList = new ArrayList<Map<String,String>>();
		StringBuffer sql = new StringBuffer();
		sql.append("SELECT b.username, TO_CHAR(a.deliveryDate,'yyyy-MM-dd') AS deliveryDate,a.ID, a.memo ");
		if (currentMemberId!=null && !"".equals(currentMemberId)){
			sql.append("FROM Delivery a INNER JOIN Member b on a.pubMemberID=b.ID AND a.StatusID<>:StatusID ");
		}else{
			sql.append("FROM Delivery a INNER JOIN Member b on a.pubMemberID=b.ID AND a.StatusID=:StatusID ");
		}
		
		if (currentMemberId!=null && !"".equals(currentMemberId)) {
			sql.append(" AND b.ID=:currentMemberId");
		}
		if (strBlKeyword!=null && !"".equals(strBlKeyword)) { 
			sql.append(" AND (b.username LIKE :blKeyword OR b.companyShortName LIKE :blKeyword OR a.deliveryAddress LIKE :blKeyword)");
		}
		if (deliveryFromDate!=null && !"".equals(deliveryFromDate)) {
			sql.append(" AND TO_CHAR(a.deliveryDate,'yyyy-MM-dd')>=:deliverFromDate");
		}
		if (deliveryToDate!=null && !"".equals(deliveryToDate)) {
			sql.append(" AND TO_CHAR(a.deliveryDate,'yyyy-MM-dd')<=:deliverToDate");
		}
		
		try {
			SQLQuery sqlQuery = DataAccessObject.openSession().createSQLQuery(sql.toString());
			
			if (currentMemberId!=null && !"".equals(currentMemberId)){
				sqlQuery.setString("currentMemberId", currentMemberId);
			}
			if (strBlKeyword!=null && !"".equals(strBlKeyword)){
				sqlQuery.setString("blKeyword", "%" + strBlKeyword + "%");
			}
			if (deliveryFromDate != null && !"".equals(deliveryFromDate)) {
				sqlQuery.setString("deliverFromDate", deliveryFromDate);
			}
			if (deliveryToDate != null && !"".equals(deliveryToDate)) {
				sqlQuery.setString("deliverToDate", deliveryToDate);
			}
			if (currentMemberId!=null && !"".equals(currentMemberId)){
				sqlQuery.setInteger("StatusID", CDict.DeliveryStateCancle.getID());
			}else{
				sqlQuery.setInteger("StatusID", CDict.DeliveryStateLade.getID());
			}
			
			
			List<Object[]> resultList = sqlQuery.list();
			
			if (resultList.size() > 0) {
				AssignResultList(resultList, headMapList);
			}
		} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		} finally {
			DataAccessObject.closeSession();
		}
		
		return headMapList;
	}

	/**
	 * 转换结果集
	 * @param resultList
	 * @param headMapList
	 */
	private void AssignResultList(List<Object[]> resultList, List<Map<String, String>> headMapList) {
		for (Object[] obj : resultList) {
			Map<String, String> map = new HashMap<String, String>();
			if (obj[0] != null) {
				map.put("pubMemberName", obj[0].toString());
			}
			if (obj[1] != null) {
				map.put("deliveryDate", obj[1].toString());
			}
			if (obj[2] != null) {
				map.put("deliveryID", obj[2].toString());
			}
			if (obj[3] != null) {
				map.put("memo", obj[3].toString());
			}
			map.put("sheetName", obj[0].toString());
			map.put("bizPerson", "王程程");
			headMapList.add(map);
		}
	}
	
	/**
	 * 根据发货单号得到订单ID
	 * @param strDeliveryId 发货单号
	 * @return 订单ID集合
	 */
	@SuppressWarnings("unchecked")
	public List<String> getOrdenIdByDeliveryId(String strDeliveryId) {
		String sql = "select OrdenID from Orden where DeliveryID=:DeliveryID ";
		
		Query sqlQuery = DataAccessObject.openSession().createQuery(sql);
		sqlQuery.setString("DeliveryID", strDeliveryId);
		
		List<String> list = sqlQuery.list();
		return list;
	}
} 