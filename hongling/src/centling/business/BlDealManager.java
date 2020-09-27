package centling.business;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.hibernate.Query;
import org.hibernate.SQLQuery;

import centling.dto.DealDto;
import centling.dto.StatementDto;
import centling.entity.Deal;
import chinsoft.business.CDict;
import chinsoft.business.ClothingManager;
import chinsoft.business.CurrentInfo;
import chinsoft.business.CustomerManager;
import chinsoft.business.DictCategoryManager;
import chinsoft.business.DictManager;
import chinsoft.business.MemberManager;
import chinsoft.business.SizeManager;
import chinsoft.core.DataAccessObject;
import chinsoft.core.DateHelper;
import chinsoft.core.LogPrinter;
import chinsoft.core.ResourceHelper;
import chinsoft.core.Utility;
import chinsoft.entity.Customer;
import chinsoft.entity.Dict;
import chinsoft.entity.Embroidery;
import chinsoft.entity.Member;
import chinsoft.entity.Orden;
import chinsoft.entity.OrdenDetail;
import chinsoft.entity.SizeStandard;

public class BlDealManager {
	
	DataAccessObject dao = new DataAccessObject();

	// 构造
	public BlDealManager() {
	}

	// 添加&修改交易项目
	public void saveDeal(Deal deal) {
		dao.saveOrUpdate(deal);
	}
	
	@SuppressWarnings("unchecked")
	public List<DealDto> getDeals(int nPageIndex, int nPageSize, String blmemberid,
			String blKeyword, Date blFromDate, Date blToDate)
    {
		List<DealDto> list= new ArrayList<DealDto>();
    	try {
    		/*String strChange = "to_char(d.dealdate,'yyyy-mm-dd hh24:mi:ss') as dealdate,nvl(m.CompanyName,' ') as companyName,nvl(m.CompanyShortName,' ') as companyShortName,"+
    				"nvl(m.Username,' ') as username,nvl(di.Name,' ') as dealItemName,m.MoneySignID as moneySignId,d.AccountIn as accountIn,d.AccountOut as accountOut,"+
    				"CASE d.DealItemId WHEN 45 THEN nvl(d.DeliveryId,'/') ELSE nvl(d.OrdenId,'/') end as ordenId,nvl(d.DeliveryId,'/') as deliveryId, d.LocalNum as localNum,nvl(d.Memo,' ') as memo";*/
    		String strChange = "to_char(d.dealdate,'yyyy-mm-dd hh24:mi:ss') as dealdate,nvl(m.CompanyName,' ') as companyName,nvl(m.CompanyShortName,' ') as companyShortName,"+
    				"nvl(m.Username,' ') as username,di.ID as dealItemName,m.MoneySignID as moneySignId,d.AccountIn as accountIn,d.AccountOut as accountOut,"+
    				"CASE d.DealItemId WHEN 45 THEN nvl(d.DeliveryId,'/') ELSE nvl(d.OrdenId,'/') end as ordenId,nvl(d.DeliveryId,'/') as deliveryId, d.LocalNum as localNum,nvl(d.Memo,' ') as memo";
	    	Query query = getDealsQuery(strChange, blmemberid, blKeyword, blFromDate, blToDate);
			query.setFirstResult(nPageIndex * nPageSize);
			query.setMaxResults(nPageSize);
			List<Object[]> list1=query.list();
			for(Object[] o: list1){
				String accountIn = "";
				String accountOut = "";
				if (o[6]!=null && !"".equals(o[6].toString().trim())){
					accountIn = "+" + o[6].toString().trim();
				} else if (o[7]!=null && !"".equals(o[7].toString().trim())){
					accountOut = "-" + o[7].toString().trim();
				}
				String deamName ="";
				if(o[4]!=null && !"".equals(o[4].toString().trim())){
					deamName =ResourceHelper.getValue("DealItem_"+o[4]);
				}
				DealDto dto = new DealDto(
						o[0].toString().trim(),
						o[1].toString().trim(),
						o[2].toString().trim(),
						o[3].toString().trim(),
//						o[4].toString().trim(),
						deamName,
						DictManager.getDictNameByID(Integer.valueOf(o[5].toString().trim())),
						accountIn,
						accountOut,
						o[8].toString().trim(),
						o[9].toString().trim(),
						o[10].toString().trim(),
						o[11].toString().trim()
						);
				list.add(dto);
			}
    	} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		}finally{
			DataAccessObject.closeSession();
		}
    	return list;
    }
	
	public long getDealsCount(String blmemberid, String blKeyword, Date blFromDate, Date blToDate)
    {
		long count = 0;
    	try {
    		Query query = getDealsQuery("COUNT(*)", blmemberid, blKeyword, blFromDate, blToDate);
			count=Utility.toSafeLong(query.uniqueResult());
    	} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		}finally{
			DataAccessObject.closeSession();
		}
    	return count;
    }

	private Query getOrdensQuery(String strChange,String blmemberid, String blKeyword, Date blFromDate, Date blToDate) {
		String hql = "SELECT "
				+ strChange
				+ " FROM Orden o,Deal d , Member m,Cash c,DealItem di"
				+ " WHERE o.OrdenID=d.OrdenId AND d.MemberId=m.ID AND m.StatusID=10042  AND d.MemberId=c.PubMemberID AND c.StatusId=10042 ";
				
		if (blmemberid!=null && !"".equals(blmemberid)){
			hql = hql + "        and d.MemberId=:memberid ";
		}
		if (blKeyword!=null && !"".equals(blKeyword)){
			hql = hql + "        AND d.DealItemId=di.ID ";
			hql = hql + "        and (upper(m.CompanyName) like upper(:keyword) ";
			hql = hql + "             or upper(m.CompanyShortName) like upper(:keyword) ";
			hql = hql + "             or upper(m.Username) like upper(:keyword) ";
			hql = hql + "             or upper(di.Name) like upper(:keyword) ";
			hql = hql + "             or upper(d.OrdenId) like upper(:keyword) ";
			hql = hql + "             or upper(d.AccountIn) like upper(:keyword) ";
			hql = hql + "             or upper(d.AccountOut) like upper(:keyword) ";
			hql = hql + "             or upper(d.LocalNum) like upper(:keyword) ";
			hql = hql + "             or upper(d.Memo) like upper(:keyword)) ";
		}
		if (blFromDate != null && !"".equals(blFromDate)) {
			hql += " AND TO_CHAR(d.dealdate, 'yyyy-MM-dd')>=TO_CHAR(:fromDate,'yyyy-MM-dd') ";
		}
		if (blToDate != null && !"".equals(blToDate)) {
			hql += " AND TO_CHAR(d.dealdate, 'yyyy-MM-dd')<= TO_CHAR(:toDate,'yyyy-MM-dd')";
		}
		Query query = DataAccessObject.openSession().createQuery(hql);
		if (blmemberid!=null && !"".equals(blmemberid)){
			query.setString("memberid", blmemberid);
		}
		if (blKeyword!=null && !"".equals(blKeyword)){
			query.setString("keyword", "%" + blKeyword + "%");
		}
		if (blFromDate != null && !"".equals(blFromDate)) {
			query.setDate("fromDate", blFromDate);
		}
		if (blToDate != null && !"".equals(blToDate)) {
			query.setDate("toDate", blToDate);
		}
		return query;
	}
	
	private Query getDealsQuery(String strChange,String blmemberid, String blKeyword, Date blFromDate, Date blToDate) {
		StringBuffer sb = new StringBuffer();
		sb.append("select " + strChange + " ");
		sb.append("from Deal d left join (select mem.*,d.Name as moneySignName ");
		sb.append("                       from Member mem left join Dict d ");
		sb.append("                                       on mem.moneySignID=d.ID ");
		sb.append("                       where mem.StatusID=10042) m ");
		sb.append("            on d.MemberId=m.ID ");
		sb.append("            left join (select ca.* from Cash ca where ca.StatusId=10042) c ");
		sb.append("            on d.MemberId=c.PubMemberID ");
		sb.append("            left join DealItem di ");
		sb.append("            on d.DealItemId=di.ID ");
		sb.append("            left join (select deli.* from Delivery deli where deli.StatusID=10042) dl ");
		sb.append("            on d.DeliveryId=dl.ID and d.MemberId=dl.PubMemberID ");
		sb.append("where 1=1 ");
		if (blmemberid!=null && !"".equals(blmemberid)){
			sb.append("        and d.MemberId=:memberid ");
		}
		if (blKeyword!=null && !"".equals(blKeyword)){
			sb.append("        and (upper(m.CompanyName) like upper(:keyword) ");        // 客户公司名称
			sb.append("             or upper(m.CompanyShortName) like upper(:keyword) ");// 客户简称
			sb.append("             or upper(m.Username) like upper(:keyword) ");        // 账户名
			sb.append("             or upper(di.Name) like upper(:keyword) ");           // 交易项目
			sb.append("             or upper(m.moneySignName) like upper(:keyword) ");   // 币种
			sb.append("             or upper(d.accountIn) like upper(:keyword) ");       // 记账金额（收入）
			sb.append("             or upper(d.accountOut) like upper(:keyword) ");      // 记账金额（支出）
			sb.append("             or upper(d.OrdenId) like upper(:keyword) ");         // 订单号
			sb.append("             or upper(dl.YundanId) like upper(:keyword) ");       // 运单号
			sb.append("             or upper(d.localNum) like upper(:keyword) ");        // 当前余额
			sb.append("             or upper(d.Memo) like upper(:keyword)) ");           // 备注
		}
		if (blFromDate != null && !"".equals(blFromDate)) {
			sb.append(" AND TO_CHAR(d.dealdate,'yyyy-MM-dd')>=TO_CHAR(:fromDate,'yyyy-MM-dd')");
		}
		if (blToDate != null && !"".equals(blToDate)) {
			sb.append(" AND TO_CHAR(d.dealdate,'yyyy-MM-dd')<=TO_CHAR(:toDate, 'yyyy-MM-dd')");
		}
		sb.append(" order by d.DealDate desc ");
		Query query = DataAccessObject.openSession().createSQLQuery(sb.toString());
		if (blmemberid!=null && !"".equals(blmemberid)){
			query.setString("memberid", blmemberid);
		}
		if (blKeyword!=null && !"".equals(blKeyword)){
			query.setString("keyword", "%" + blKeyword + "%");
		}
		if (blFromDate != null && !"".equals(blFromDate)) {
			query.setDate("fromDate", blFromDate);
		}
		if (blToDate != null && !"".equals(blToDate)) {
			query.setDate("toDate", blToDate);
		}
		return query;
	}
	@SuppressWarnings("unchecked")
	public List<Orden> getOrdens(int nPageIndex, int nPageSize,String strKeyword, String blmemberid, Date fromDate,
			Date toDate) {
		List<Orden> ordens = new ArrayList<Orden>();
		try {
			Query query = getOrdensQuery("o", blmemberid, strKeyword, fromDate,
					toDate);
			query.setFirstResult(nPageIndex * nPageSize);
			query.setMaxResults(nPageSize);
			ordens = (List<Orden>) query.list();
			int i = 0;
			for (Orden orden : ordens) {
				orden.number = (++i);
				extendOrden(orden);
			}
		} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		} finally {
			DataAccessObject.closeSession();
		}
		return ordens;
	}
	public Orden extendOrden(Orden orden) {
		if (orden.getCustomerID() != null && !"".equals(orden.getCustomerID())) {
			Customer customer = new CustomerManager().getCustomerByID(orden
					.getCustomerID());
			orden.setCustomer(customer);
		}
		if (orden.getPubMemberID() != null
				&& !"".equals(orden.getPubMemberID())) {
			Member member = new MemberManager().getMemberByID(orden
					.getPubMemberID());
			if (member != null) {
				orden.setPubMemberName(member.getName());
				orden.setUsername(member.getUsername());
			}
		}
		if (orden.getSizeUnitID() != null && !"".equals(orden.getSizeUnitID())) {
			orden.setSizeUnitName(DictManager.getDictNameByID(orden
					.getSizeUnitID()));
		}
		if (orden.getStyleID() != null && !"".equals(orden.getStyleID())) {
			orden.setStyleName(DictManager.getDictNameByID(orden.getStyleID()));
		}
		if (orden.getClothingID() != null && !"".equals(orden.getClothingID())) {
			orden.setClothingName(DictManager.getDictNameByID(orden
					.getClothingID()));
		}
		// 设置是否已申请发货
		if (orden.getDeliveryID() != null && !"".equals(orden.getDeliveryID())) {
			orden.setDeliveryStatusName(CDict.YES.getName());
		} else {
			orden.setDeliveryStatusName(CDict.NO.getName());
		}
		if (orden.getSizeCategoryID() != null
				&& !"".equals(orden.getSizeCategoryID())) {
			orden.setSizeCategoryName(DictManager.getDictNameByID(orden
					.getSizeCategoryID()));
			if (orden.getSizeAreaID() != null
					&& !"".equals(orden.getSizeAreaID())) {
				orden.setSizeCategoryName(orden.getSizeCategoryName()
						+ DictManager.getDictNameByID(orden.getSizeAreaID())
						+ " ");
				if (orden.getSizeSpec() != null
						&& !"".equals(orden.getSizeSpec())) {
					orden.setSizeCategoryName(orden.getSizeCategoryName()
							+ orden.getSizeSpec());
				}
			}
		}
		if (orden.getSizeBodyTypeValues() != null && !"".equals(orden.getSizeBodyTypeValues())) {
			String[] strIDs = Utility.getStrArray(orden.getSizeBodyTypeValues());
			String strBodyTypes = "";
			for (String strID : strIDs) {
//				//着装风格
				int nCategoryID = DictManager.getDictByID(Utility.toSafeInt(strID)).getCategoryID();
//				if(CDict.CLOTHINGSTYLE.equals(Utility.toSafeString(nCategoryID))){
//					orden.setClothingStyleName(DictManager.getDictNamesByIDs(strID));
//				}else{//特体信息
				    strBodyTypes += DictCategoryManager.getDictCategoryNameByID(nCategoryID)+":";
					strBodyTypes += DictManager.getDictNamesByIDs(strID)+"&nbsp;";
//				}
			}
			orden.setSizeBodyTypeNames(strBodyTypes.substring(0, strBodyTypes.length()-1));
		}
		List<OrdenDetail> details = this.getOrdenDetails(orden);
		if (details != null && details.size() > 0) {
			orden.setOrdenDetails(details);
		}
		//着装风格
		String clothingStyleNames ="";
		for (OrdenDetail ordenDetail : details) {
			String styles = orden.getComponentTexts();
			//System.out.println(styles);
			if(!"".equals(styles) && styles != null){
				String[] style = styles.split(",");
				for(int i=0;i<style.length;i++){
					String[] clothingstyle = style[i].split(":");
					if(Utility.toSafeString(ordenDetail.getSingleClothingID()).equals(clothingstyle[0])){
						clothingStyleNames += DictManager.getDictNamesByIDs(clothingstyle[0])+":"+DictManager.getDictNamesByIDs(clothingstyle[1])+"&nbsp;";
					}
				}
			}
		}
		orden.setClothingStyleName(clothingStyleNames);
		
		String str = "";
		for (OrdenDetail ordenDetail : details) {
			if (ordenDetail.getSingleClothingID().equals(
					CDict.ClothingPants.getID())) {
				if (ordenDetail.getAmount() > 1) {
					orden.setClothingName(orden.getClothingName() + "+"
							+ ordenDetail.getSingleClothingName());
				}
			}
			str += this.getSizePartName(orden, ordenDetail.getSingleClothingID())+"<br>";
		}
		orden.setSizePartNames(str);
		if (orden.getStopCause() != null && !"".equals(orden.getStopCause())
				&& !"-1".equals(orden.getStopCause())) {
			orden.setStopCauseName(DictManager.getDictNamesByIDs(Utility
					.toSafeString(orden.getStopCause())));
		}

		if (orden.getStatusID() != null && !"".equals(orden.getStatusID())) {
			Dict currentStatus = DictManager.getDictByID(orden.getStatusID());
			if (currentStatus != null) {
				orden.setStatusName(currentStatus.getName());
				if (isBeforPlateMaking(currentStatus)) {

					if (orden.getPubDate() != null) {
						Date overdueDate = DateHelper.getDateSkipHours(
								orden.getPubDate(), 72);

						if (new Date().after(overdueDate)) {
							orden.setIsPubOverdue(CDict.YES.getID());
						}
					}
				}
				String strOperationStop = "";// 是否停滞
				if (orden.getIsStop() != null && !"".equals(orden.getIsStop())) {
					if (CDict.NO.getID().equals(orden.getIsStop())) {
						strOperationStop = "<a class='operation' onclick=$.csOrdenList.isStop('"
								+ orden.getOrdenID()
								+ "','"
								+ orden.getIsStop()
								+ "')>"
								+ ResourceHelper.getValue("Button_Stop")
								+ "</a>";
					} else if (CDict.YES.getID().equals(orden.getIsStop())) {
						strOperationStop = "<a class='operation' onclick=$.csOrdenList.isStop('"
								+ orden.getOrdenID()
								+ "','"
								+ orden.getIsStop()
								+ "')>"
								+ ResourceHelper.getValue("Button_Cancel")
								+ "</a>";
						orden.setStatusName(ResourceHelper
								.getValue("Button_IsStop"));
					}
				}

				String strOperationRemove = "<a class='operation' onclick=$.csOrdenList.remove('"
						+ orden.getOrdenID()
						+ "')>"
						+ ResourceHelper.getValue("Button_Remove") + "</a>";
				String strOperation = "<a class='operation' onclick=$.csOrdenList.openEdit('"
						+ orden.getOrdenID()
						+ "')>"
						+ ResourceHelper.getValue("Button_Edit") + "</a>";
				if (CDict.OrdenStatusSaving.getID().equals(orden.getStatusID())) {// 订单状态=保存中
					orden.setConstDefine(orden.getConstDefine() + strOperation
							+ strOperationRemove);
				}

				// if(CurrentInfo.isPubMember(orden.getPubMemberID()) &&
				// CDict.OrdenStatusReject.getID().equals(currentStatus.getID())){
				// String strOperation =
				// "<a class='operation' onclick=$.csOrdenList.openEdit('"+orden.getOrdenID()+"')>"+ResourceHelper.getValue("Button_Edit")+"</a>";
				// strOperation += strOperationRemove;
				// orden.setConstDefine(strOperation);
				// }
				// if(CurrentInfo.isAdmin() &&
				// CDict.OrdenStatusNotSubmit.getID().equals(currentStatus.getID())){
				// String strOperation =
				// "<a class='operation' onclick=$.csOrdenList.approveOrden('"+orden.getOrdenID()+"')>"+ResourceHelper.getValue("Button_Approve")+"</a>";
				// //strOperation +=
				// "<a class='operation' onclick=$.csOrdenList.rejectOrden('"+orden.getOrdenID()+"')>"+ResourceHelper.getValue("Button_Reject")+"</a>";
				// orden.setConstDefine(strOperation);
				// }
				if (CurrentInfo.isAdmin() && isBeforPlateMaking(currentStatus)) {
					// orden.setConstDefine(orden.getConstDefine() +
					// strOperationRemove + strOperationStop);
					orden.setConstDefine(orden.getConstDefine()
							+ strOperationStop);
				} else if (CurrentInfo.isAdmin()) {
					orden.setConstDefine(strOperationStop);
				}
			}
		}
		return orden;
	}
	@SuppressWarnings("unchecked")
	private List<OrdenDetail> getOrdenDetails(Orden orden) {
		List<OrdenDetail> ordenDetails = new ArrayList<OrdenDetail>();
		try {
			String hql = "FROM OrdenDetail d WHERE d.OrdenID = ? ";
			Query query = DataAccessObject.openSession().createQuery(hql);
			query.setString(0, orden.getOrdenID());
			ordenDetails = query.list();
			for (OrdenDetail ordenDetail : ordenDetails) {
				extendOrdenDetail(orden, ordenDetail);
			}
		} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		} finally {
			DataAccessObject.closeSession();
		}
		return ordenDetails;
	}

	private void extendOrdenDetail(Orden orden, OrdenDetail ordenDetail) {
		int nSingleClothingID = ordenDetail.getSingleClothingID();
		ordenDetail.setSingleClothingName(DictManager
				.getDictNameByID(nSingleClothingID));
		List<Dict> singleDesignedComponents = new ClothingManager()
				.getOrderProcess(orden, nSingleClothingID);
		List<Embroidery> emberoidery = new ClothingManager().getEmbroideryLoaction(
				orden, nSingleClothingID);
		ordenDetail
				.setSingleComponents(getSingleDesignedComponentsName(singleDesignedComponents,orden.getComponentTexts()));
		ordenDetail
				.setSingleEmbroiderys(getSingleDesignedEmbroiderysName(emberoidery));
		//衣服大小号
		List<OrdenDetail> ordenDetails = orden.getOrdenDetails();
		if(ordenDetails != null){
			for(OrdenDetail od : ordenDetails){
				if(od.getSingleClothingID().equals(ordenDetail.getSingleClothingID())){
					ordenDetail.setSpecHeight(od.getSpecHeight());
				}
			}
		}
	}
	private String getSingleDesignedComponentsName(
			List<Dict> singleDesignedComponents,String strCompentText) {
		String strSingleDesignedComponentsName = "";
		for (Dict component : singleDesignedComponents) {
			if (strCompentText != null && strCompentText.indexOf(Utility.toSafeString(component.getID()))>-1) {//款式号、价格
				String[] strCompents = strCompentText.split(",");
				for(int i=1;i<strCompents.length;i++){
					if(Utility.toSafeString(component.getID()).equals(strCompents[i].split(":")[0])){
						strSingleDesignedComponentsName +="<span><label>"
								+ component.getName() + "</label> : "
								+ strCompents[i].split(":")[1]+ "</span>";
					}
				}
			}else{
				Dict parent = DictManager.getDictByID(component.getParentID());
				if (parent != null) {
					strSingleDesignedComponentsName += "<span><label>"
							+ parent.getName() + "</label> : "
							+ component.getName() + "</span>";
				}
			}
		}
		return strSingleDesignedComponentsName;
	}
	private String getSingleDesignedEmbroiderysName(List<Embroidery> emberoiderys) {
		String strSingleDesignedEmbroiderysName = "";
		for(Embroidery emberoidery : emberoiderys){
			if (emberoidery != null) {
				if (emberoidery.getColor() != null) {
					strSingleDesignedEmbroiderysName += "<span><label>"
							+ DictManager.getDictNameByID(emberoidery.getColor()
									.getParentID()) + "</label> : "
							+ emberoidery.getColor().getName() + "</span>";
				}
				if (emberoidery.getFont() != null) {
					strSingleDesignedEmbroiderysName += "<span><label>"
							+ DictManager.getDictNameByID(emberoidery.getFont()
									.getParentID()) + "</label> : "
							+ emberoidery.getFont().getName() + "</span>";
				}
				if (emberoidery.getLocation() != null) {
					strSingleDesignedEmbroiderysName += "<span><label>"
							+ DictManager.getDictNameByID(emberoidery.getLocation()
									.getParentID()) + "</label> : "
							+ emberoidery.getLocation().getName() + "</span>";
				}
				if (emberoidery.getContent() != null) {
					strSingleDesignedEmbroiderysName += "<span><label>"
							+ DictManager.getDictNameByID(421) + "</label> : "
							+ emberoidery.getContent() + "</span>";
				}
				if (emberoidery.getSize() != null) {
					strSingleDesignedEmbroiderysName += "<span><label>"
							+ DictManager.getDictNameByID(emberoidery.getSize()
									.getParentID()) + "</label> : "
							+ emberoidery.getSize().getName() + "</span>";
				}
			}
		
		}
		return strSingleDesignedEmbroiderysName;
	}
	public String getSizePartName(Orden orden, int nClothingID) {
		// 默认值
		int nAreaID = -1;
		String strSpecHeight = "undefined";
		if (orden.getSizeCategoryID() == CDict.CLOTHINGSIZEID) {// 西服、西裤 标准号加减
			nAreaID = 10201;// 英美码
			strSpecHeight = "34";
		}
		if (nClothingID == CDict.ClothingChenYi.getID()
				&& orden.getSizeCategoryID() == CDict.CLOTHINGSIZEID) {// 衬衣
																		// 标准号加减
			nAreaID = 10201;// 英美码
			strSpecHeight = "38/XXS";
		}
		List<SizeStandard> sizeStandards = new SizeManager().getSizeStandard(
				nClothingID, orden.getSizeCategoryID(), nAreaID, strSpecHeight,
				"undefined", orden.getSizeUnitID());

		//int strUnitSize = orden.getSizeUnitID();
		String strPartNames = "";
		for (SizeStandard size : sizeStandards) {
			for (Map.Entry<Integer, Float> entry : this.getSizePartValue(orden)
					.entrySet()) {
				Integer key = entry.getKey();
				Float value = entry.getValue();
				if (size.getPartID().equals(key)) {
					strPartNames += "<label>"+ DictManager.getDictNameByID(key)+ "</label> : " + value+"&nbsp;";
				}
			}
		}
		return strPartNames;
	}
	public Map<Integer, Float> getSizePartValue(Orden orden) {
		Map<Integer, Float> mapPartValue = new HashMap<Integer, Float>();
		String[] partValues = Utility.getStrArray(orden.getSizePartValues());
		for (String partValue : partValues) {
			String[] pv = partValue.split(":");
			if (pv != null && pv.length == 2) {
				float value = Utility.toSafeFloat(pv[1]);
				/*
				 * if(CDict.UnitInch.getID().equals(orden.getSizeUnitID())){
				 * value = Utility.cmToInch(value); }
				 */
				mapPartValue.put(Utility.toSafeInt(pv[0]), value);
			}
		}
		return mapPartValue;
	}
	private boolean isBeforPlateMaking(Dict currentStatus) {
		return currentStatus.getSequenceNo() <= CDict.OrdenStatusPlateMaking
				.getSequenceNo();
	}

	/**
	 * 获取对账单
	 * @param blFromDate 开始日期
	 * @param blToDate 结束日期
	 * @param blmemberid 用户ID
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public Map<String,String> getStateMentList(Date blFromDate, Date blToDate,
			String blmemberid) {
		Map<String, String> statementMap = new HashMap<String, String>();
		StringBuffer buffer = new StringBuffer();
		buffer.append("select d.dealitemid, count(d.dealitemid) as qyt, ");
		buffer.append("case dl.ioflag when 20119 then nvl(sum(accountin),0) else nvl(sum(accountout),0)end as amount, dl.ioflag ");
		buffer.append("from deal d left join dealitem dl on d.dealitemid=dl.id ");
		buffer.append(" where d.memberId=? and TO_CHAR(d.dealDate,'yyyy-MM-dd')>=TO_CHAR(?,'yyyy-MM-dd') ");
		buffer.append(" and TO_CHAR(d.dealDate,'yyyy-MM-dd')<=TO_CHAR(?,'yyyy-MM-dd') ");
		buffer.append(" group by d.dealitemid, dl.ioflag ");
		
		try {
			SQLQuery sqlQuery = DataAccessObject.openSession().createSQLQuery(buffer.toString());
			
			sqlQuery.setString(0, blmemberid);
			sqlQuery.setDate(1, blFromDate);
			sqlQuery.setDate(2, blToDate);
			
			List<Object[]> resultList = sqlQuery.list();
			
			List<StatementDto> tempList = new ArrayList<StatementDto>();
			
			if (resultList.size() > 0) {
				for (Object[] obj: resultList) {
					StatementDto dto = new StatementDto();
					dto.setDealItemId(Utility.toSafeString(obj[0]));
					dto.setQyt(Utility.toSafeString(obj[1]));
					dto.setAmount(Utility.toSafeString(obj[2]));
					dto.setIoFlag(Utility.toSafeInt(obj[3]));
					tempList.add(dto);
				}
			}
			
			Integer garmentsQty = 0;
			Double garmentsAmount = 0.0;
			Integer shippingQty = 0;
			Double shippingAmount = 0.0;
			Integer swatchesQty = 0;
			Double swatchesAmount = 0.0;
			Integer discountQty = 0;
			Double discountAmount = 0.0;
			Integer chargeQty = 0;
			Double chargeAmount = 0.0;
			Integer otherQty = 0;
			Double otherAmount = 0.0;
			for (StatementDto statementDto : tempList) {
				if (Constant.STATEMENT_CHD_ORDENS_DEBIT.equals(statementDto.getDealItemId()) 
						|| Constant.STATEMENT_ORDENS_DEBIT.equals(statementDto.getDealItemId())) {
					garmentsQty += Utility.toSafeInt(statementDto.getQyt());
					garmentsAmount += Utility.toSafeDouble(statementDto.getAmount());
				} else if(Constant.STATEMENT_SHIP.equals(statementDto.getDealItemId())) {
					shippingQty += Utility.toSafeInt(statementDto.getQyt());
					shippingAmount += Utility.toSafeDouble(statementDto.getAmount());
				} else if(Constant.STATEMENT_SWATCHES.equals(statementDto.getDealItemId())) {
					swatchesQty += Utility.toSafeInt(statementDto.getQyt());
					swatchesAmount += Utility.toSafeDouble(statementDto.getAmount());
				} else if(Constant.STATEMENT_DISCOUNT.equals(statementDto.getDealItemId())) {
					discountQty += Utility.toSafeInt(statementDto.getQyt());
					discountAmount += Utility.toSafeDouble(statementDto.getAmount());
				} else if(Constant.STATEMENT_CHARGE.equals(statementDto.getDealItemId())) {
					chargeQty += Utility.toSafeInt(statementDto.getQyt());
					chargeAmount += Utility.toSafeDouble(statementDto.getAmount());
				} else {
					if (!Constant.STATEMENT_DEPOSIT.equals(statementDto.getDealItemId())) {
						otherQty += Utility.toSafeInt(statementDto.getQyt());
						if (CDict.IOFLAG_I==statementDto.getIoFlag()) {
							otherAmount -= Utility.toSafeDouble(statementDto.getAmount());
						} else {
							otherAmount += Utility.toSafeDouble(statementDto.getAmount());
						}
					}
				}
			}
			
			statementMap.put("garmentQty", Utility.toSafeString(garmentsQty));
			statementMap.put("garmentsAmount", Utility.toSafeString(garmentsAmount));
			statementMap.put("shippingQty", Utility.toSafeString(shippingQty));
			statementMap.put("shippingAmount", Utility.toSafeString(shippingAmount));
			statementMap.put("swatchesQty", Utility.toSafeString(swatchesQty));
			statementMap.put("swatchesAmount", Utility.toSafeString(swatchesAmount));
			statementMap.put("discountQty", Utility.toSafeString(discountQty));
			statementMap.put("discountAmount", Utility.toSafeString(discountAmount));
			statementMap.put("otherQty", Utility.toSafeString(otherQty));
			statementMap.put("otherAmount", Utility.toSafeString(otherAmount));
			statementMap.put("chargeQty", Utility.toSafeString(chargeQty));
			statementMap.put("chargeAmount", Utility.toSafeString(chargeAmount));
			statementMap.put("totalQty", Utility.toSafeString(garmentsQty+shippingQty+swatchesQty+discountQty+otherQty));
			statementMap.put("totalAmount", Utility.toSafeString(garmentsAmount+shippingAmount+swatchesAmount+discountAmount+otherAmount));
		} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		} finally {
			DataAccessObject.closeSession();
		}
		return statementMap;
	}
	
	/**
	 * 得到账单明细
	 * @param blmemberid
	 * @param blFromDate
	 * @param blToDate
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<DealDto> getDeals(String blmemberid, Date blFromDate, Date blToDate) {
		List<DealDto> dealDtoList = new ArrayList<DealDto>();
		
		StringBuffer buffer = new StringBuffer();
		
		buffer.append("SELECT to_char(d.dealdate,'yyyy/mm/dd') as dealdate,nvl(m.CompanyName,' ') as companyName,");
		buffer.append("nvl(m.CompanyShortName,' ') as companyShortName,nvl(m.Username,' ') as username,");
		buffer.append("nvl(di.Name,' ') as dealItemName,m.MoneySignID as moneySignId,d.AccountIn as accountIn,");
		buffer.append("d.AccountOut as accountOut,CASE d.DealItemId WHEN 45 THEN nvl(d.DeliveryId,'/') ELSE nvl(d.OrdenId,'/') end as ordenId,");
		buffer.append("d.LocalNum as localNum,nvl(d.Memo,' ') as memo ");
		buffer.append(" from deal d left join member m on d.memberid=m.id ");
		buffer.append(" left join dealitem di on d.dealitemid=di.id ");
		buffer.append(" where d.memberid=? and to_char(d.dealdate,'yyyy-mm-dd')>=to_char(?,'yyyy-MM-dd') ");
		buffer.append(" and to_char(d.dealdate,'yyyy-MM-dd')<=to_char(?,'yyyy-MM-dd')");
		
		try {
			SQLQuery sqlQuery = DataAccessObject.openSession().createSQLQuery(buffer.toString());
			
			sqlQuery.setString(0, blmemberid);
			sqlQuery.setDate(1, blFromDate);
			sqlQuery.setDate(2, blToDate);
			
			List<Object[]> resultList = sqlQuery.list();
			
			if (resultList.size() > 0) {
				for (Object[] o: resultList) {
					String accountIn = "";
					String accountOut = "";
					if (o[6]!=null && !"".equals(o[6].toString().trim())){
						accountIn = "+" + o[6].toString().trim();
					} else if (o[7]!=null && !"".equals(o[7].toString().trim())){
						accountOut = "-" + o[7].toString().trim();
					}
					DealDto dto = new DealDto(
							o[0].toString().trim(),
							o[1].toString().trim(),
							o[2].toString().trim(),
							o[3].toString().trim(),
							o[4].toString().trim(),
							DictManager.getDictNameByID(Integer.valueOf(o[5].toString().trim())),
							accountIn,
							accountOut,
							o[8].toString().trim(),
							"",
							o[9].toString().trim(),
							o[10].toString().trim()
							);
					dealDtoList.add(dto);
				}
			}
		} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		} finally {
			DataAccessObject.closeSession();
		}
		return dealDtoList;
	}
	
	public List<Deal> getDeals(String memberId,String deliveryId,int dealItemId){
		List<Deal> dealList = new ArrayList<Deal>();
		String hql="from Deal d where d.MemberId=? and d.DeliveryId=? and d.DealItemId=?";
		try {
			Query query = DataAccessObject.openSession().createQuery(hql);
			query.setString(0, memberId);
			query.setString(1, deliveryId);
			query.setInteger(2, dealItemId);
			dealList = query.list();
		} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		} finally {
			DataAccessObject.closeSession();
		}
		return dealList;
		
	}

	public void saveOrUpdate(Deal deal) {
		dao.saveOrUpdate(deal);
	}
	public int searchDealByOrdenId(String ordenId){
		
		StringBuffer buffer=new StringBuffer();
		buffer.append("select count(*) from deal t where t.ordenid= '"+ordenId+"'");
		SQLQuery sqlQuery = DataAccessObject.openSession().createSQLQuery(buffer.toString());
		int count=(int) Utility.toSafeLong(sqlQuery.uniqueResult());
		
		return count;
	}

}
