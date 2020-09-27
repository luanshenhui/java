package chinsoft.business;

import java.util.ArrayList;
import java.util.List;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.Transaction;

import chinsoft.core.DataAccessObject;
import chinsoft.core.LogPrinter;
import chinsoft.entity.Logistic;
import chinsoft.entity.Receipt;

public class ReceiptManager {

	DataAccessObject dao = new DataAccessObject();

	// 添加&修改
	public void saveReceipt(Receipt receipt) {
		dao.saveOrUpdate(receipt);
	}
	// 根据ID查询
	public Receipt getReceiptByOrdenID(String strOrdenID) {
		Receipt receipt = new Receipt();
		List<Receipt> receipts = new ArrayList<Receipt>();
		try{
			String hql ="from Receipt l where l.ordenID =:ordenID";
			Query query = DataAccessObject.openSession().createQuery(hql);
			query.setString("ordenID", strOrdenID);
			receipts= query.list();
			if(receipts.size()>0){
				receipt = receipts.get(0);
			}
		}catch (Exception e) {
			LogPrinter.error(e.getMessage());
		}finally{
			DataAccessObject.closeSession();
		}
		return receipt;
	}
	public Receipt getReceiptByOrdenID2(String strOrdenID) {
		Receipt receipt = null;
		List<Receipt> receipts = new ArrayList<Receipt>();
		try{
			String hql ="from Receipt l where l.ordenID =:ordenID";
			Query query = DataAccessObject.openSession().createQuery(hql);
			query.setString("ordenID", strOrdenID);
			receipts= query.list();
			if(receipts.size()>0){
				receipt=new Receipt();
				receipt = receipts.get(0);
			}
		}catch (Exception e) {
			LogPrinter.error(e.getMessage());
		}finally{
			DataAccessObject.closeSession();
		}
		return receipt;
	}
	//删除发票信息
	public void removeReceiptByOrdenID(String strID) {
		String deleteSql = "DELETE FROM Receipt WHERE ordenID=:ordenID";

		Session session = null;
		Transaction transaction = null;
		try {
			session = DataAccessObject.openSession();
			transaction = session.beginTransaction();
			Query deleteQuery = session.createQuery(deleteSql);
			deleteQuery.setString("ordenID", strID);
			deleteQuery.executeUpdate();
			
			transaction.commit();
		} catch (Exception e) {
			transaction.rollback();
			LogPrinter.error(e.getMessage());
		} finally {
			DataAccessObject.closeSession();
		}
	}
}