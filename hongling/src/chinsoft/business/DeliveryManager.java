package chinsoft.business;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.Transaction;

import chinsoft.core.DataAccessObject;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.entity.Delivery;
import chinsoft.entity.Member;
import chinsoft.entity.Orden;

public class DeliveryManager {

	DataAccessObject dao = new DataAccessObject();

	// 构造
	public DeliveryManager() {
	}

	/**
	 * 保存发货信息
	 * @param delivery
	 * @param strOrdens
	 * @return
	 */
	public String submitDelivery(Delivery delivery,String strOrdens) {
		Session session = null;
		Transaction tx = null;
		
		try {
			session = DataAccessObject.openSession();
			tx = session.beginTransaction();
			Member member = CurrentInfo.getCurrentMember();
			// 保存发货信息
			delivery.setPubMemberID(member.getID());
			delivery.setPhoneNumber(member.getPhoneNumber());
			session.saveOrUpdate(delivery);
		
			// 设置用户发货方式、发货地址及快递公司
			member.setApplyDeliveryTypeID(CDict.ManualDeliveryType.getID());
			member.setCountryCode(delivery.getCountryCode());
			member.setCompanyName(delivery.getCountryName());
			member.setDivision(delivery.getDivision());
			member.setDivisionCode(delivery.getDivisionCode());
			member.setCity(delivery.getCity());
			member.setAddressLine1(delivery.getAddressLine1());
			member.setAddressLine2(delivery.getAddressLine2());
			member.setPostalCode(delivery.getPostalCode());
			member.setExpressComId(delivery.getExpressComId());
//			member.setApplyDeliveryAddress(delivery.getDeliveryAddress());
			session.saveOrUpdate(member);
			CurrentInfo.setCurrentMember(member);
		
			// 更新订单信息
			String[] ordens = Utility.getStrArray(strOrdens);
			for(String strOrdenID :ordens){
				AssignDeliveryToOrden(session,strOrdenID, delivery.getID(), delivery.getDeliveryDate());
			}
			tx.commit();
		} catch (Exception e) {
			tx.rollback();
			LogPrinter.error(e.getMessage());
		} finally {
			if (session != null) {
				session.close();
			}
		}
		return Utility.RESULT_VALUE_OK;
	}

	/**
	 * 根据发货信息，更新订单信息
	 * @param strOrdenID 订单编号
	 * @param strDeliveryID 发货ID
	 * @param deliveryDate 发货日期
	 */
	private void AssignDeliveryToOrden(Session session,String strOrdenID, String strDeliveryID, Date deliveryDate){
		Orden orden = (Orden)session.load(Orden.class, strOrdenID);
		if(orden != null){
			orden.setDeliveryID(strDeliveryID);
			orden.setDeliveryDate(deliveryDate);
			
			session.saveOrUpdate(orden);
		}
	}
	
	public Delivery getDeliveryByID(String strDeliveryID) {
		Delivery delivery = (Delivery) dao.getEntityByID(Delivery.class, strDeliveryID);
		this.extendDelivery(delivery);
		List<Orden> ordens = new OrdenManager().getOrdensByDeliveryID(strDeliveryID);
		delivery.setOrdens(ordens);
		return delivery;
	}

	@SuppressWarnings("unchecked")
	public List<Delivery> getDeliverys(int nPageIndex, int nPageSize, String strMemberCode)
    {
		List<Delivery> list= new ArrayList<Delivery>();
    	try {
	    	Query query = getDeliverysQuery("d", strMemberCode);
			query.setFirstResult(nPageIndex * nPageSize);
			query.setMaxResults(nPageSize);
			list=query.list();
			for(Delivery delivery: list){
				extendDelivery(delivery);
			}
    	} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		}finally{
			DataAccessObject.closeSession();
		}
    	
    	return list;
    }

	private Query getDeliverysQuery(String strChange,String strMemberCode) {
		String hql = "SELECT " +strChange+ " FROM Delivery d,Member m WHERE d.PubMemberID = m.ID AND m.Code LIKE :MemberCode ORDER BY PlanDeliveryDate DESC" ;
		Query query = DataAccessObject.openSession().createQuery(hql);
		query.setString("MemberCode", strMemberCode + "%");
		return query;
	}

	private void extendDelivery(Delivery delivery) {
		Member member = new MemberManager().getMemberByID(delivery.getPubMemberID());
		if(member != null){
			delivery.setPubMemberName(member.getName());
			delivery.setMoneySignId(member.getMoneySignID());
			delivery.setMoneySignName(member.getMoneySignName());
		}
	}

	public long getDeliverysCount(String strMemberCode)
    {
		long count = 0;
    	try {
    		Query query = getDeliverysQuery("COUNT(*)", strMemberCode);
			count=Utility.toSafeLong(query.uniqueResult());
    	} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		}finally{
			DataAccessObject.closeSession();
		}
    	
    	return count;
    }

	/**
	 * 判断订单是否为同一类型
	 * @param strOrdens 所选订单
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public boolean checkOrdens(String strOrdens) {
		boolean flag = false;
		String[] ordens = Utility.getStrArray(strOrdens);
		
		String sql = "select distinct ClothingID from Orden where OrdenID in (:OrdenID)";
		
		Query query = DataAccessObject.openSession().createQuery(sql);
		query.setParameterList("OrdenID", ordens);
		
		List<Integer> list = query.list();
		
		if (list.size() > 1 && list.contains(CDict.ClothingChenYi.getID())) {
			flag = false;
		} else {
			flag = true;
		}
		return flag;
	}
}