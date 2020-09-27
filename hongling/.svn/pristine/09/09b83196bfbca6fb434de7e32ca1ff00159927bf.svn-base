package centling.business;

import org.hibernate.HibernateException;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.Transaction;

import centling.entity.DeliveryPlus;
import chinsoft.core.DataAccessObject;
import chinsoft.core.LogPrinter;

public class BlDeliveryPlusManager {
	DataAccessObject dao = new DataAccessObject();
	
	/**
	 * 保存发货明细
	 * @param deliveryPlus
	 */
	public void saveDeliveryPlus(DeliveryPlus deliveryPlus) {
		if (deliveryPlus == null || "".equals(deliveryPlus)) {
			return;
		}
		try {
			dao.saveOrUpdate(deliveryPlus);
		} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		}
	}

	/**
	 * 删除发货明细
	 * @param deliveryId
	 * @param strOrdenId
	 */
	public void deleteDeliveryPlus(String deliveryId, String strOrdenId) {
		String sql = "DELETE FROM DeliveryPlus WHERE DeliveryID=:DeliveryID AND OrdenID=:OrdenID ";
		Session session = null;
		Transaction transaction = null;
		
		try {
			session = DataAccessObject.openSession();
			transaction = session.beginTransaction();
			Query query = session.createQuery(sql);
			query.setString("DeliveryID", deliveryId);
			query.setString("OrdenID", strOrdenId);
			query.executeUpdate();
			transaction.commit();
		} catch (HibernateException e) {
			LogPrinter.error(e.getMessage());
		} finally {
			if (session != null) {
				session.close();
			}
		}
	}
}