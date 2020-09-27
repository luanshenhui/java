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
import chinsoft.entity.Customer;

public class CustomerManager {

	DataAccessObject dao = new DataAccessObject();

	// 构造
	public CustomerManager() {
	}

	// 添加&修改资料
	public void saveCustomer(Customer customer) {
		if(customer.getID() == null || customer.getID().equals(""))
		{
			customer.setPubDate(new Date());
		}
		
		dao.saveOrUpdate(customer);
	}

	// 根据ID查询
	public Customer getCustomerByID(String strCustomerID) {
		Customer customer  = (Customer) dao.getEntityByID(Customer.class, strCustomerID);
		if(customer.getGenderID() != null){
			customer.setGenderName(DictManager.getDictNameByID(customer.getGenderID()));
		}
		if(customer.getWeightUnitID()!= null){
			customer.setWeightUnitName(DictManager.getDictNameByID(customer.getWeightUnitID()));
		}
		if(customer.getHeightUnitID()!= null){
			customer.setHeightUnitName(DictManager.getDictNameByID(customer.getHeightUnitID()));
		}
		return customer;
	}
	
	@SuppressWarnings("unchecked")
	public List<Customer> getCustomers(String strKeyword, String strPubMemberID)
    {
		List<Customer> list= new ArrayList<Customer>();
    	try {
	    	String hql = "FROM Customer c WHERE c.Name LIKE ? AND c.PubMemberID = ? ORDER BY c.Name" ;
			Query query = DataAccessObject.openSession().createQuery(hql);
			query.setString(0, "%" + strKeyword + "%");
			query.setString(1, strPubMemberID);
			list=query.list();
    	} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		}finally{
			DataAccessObject.closeSession();
		}
    	
    	return list;
    }

	@SuppressWarnings("unchecked")
	public List<Customer> getCustomers(int nPageIndex, int nPageSize, String strKeyword)
    {
		List<Customer> list = new ArrayList<Customer>();;
    	try {
	    	String hql = "FROM Customer c WHERE c.Name LIKE ? ORDER BY PubDate DESC" ;
			Query query = DataAccessObject.openSession().createQuery(hql);
			query.setString(0, "%" + strKeyword + "%");
			query.setFirstResult(nPageIndex * nPageSize);
			query.setMaxResults(nPageSize);
			list=query.list();
    	} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		}finally{
			DataAccessObject.closeSession();
		}
    	
    	return list;
    }

	public long getCustomersCount(String strKeyword)
    {
		long count = 0;
    	try {
    		String hql = "SELECT COUNT(*) FROM Customer i WHERE i.Name LIKE ?" ;
			Query query = DataAccessObject.openSession().createQuery(hql);
			query.setString(0, "%" + strKeyword + "%");
			count=Utility.toSafeLong(query.uniqueResult());
    	} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		}finally{
			DataAccessObject.closeSession();
		}
    	
    	return count;
    }

	// 删除
	public void removeCustomerByID(String strCustomerID) {
		dao.remove(Customer.class, strCustomerID);
	}
	
	public String removeCustomers(String removeIDs)
    {
		if (removeIDs.equals("")) {
			return "请选择待删除项";
		}
		
    	Transaction transaction=null;
    	Session session=null;
    	try {
	    	session= DataAccessObject.openSession();
	    	transaction=session.beginTransaction();
	    	
	    	String[] arrCustomerIDs = Utility.getStrArray(removeIDs);
	    	LogPrinter.debug("length_arr" + arrCustomerIDs.length);
	    	for (Object customerID : arrCustomerIDs) {
	    		if(customerID != null && customerID != "")
	            {
	                this.removeCustomerByID(session, Utility.toSafeString(customerID));
	            }
	    	}
	    	
	    	transaction.commit();
	    	return Utility.RESULT_VALUE_OK;
    	} catch (Exception e) {
	    	transaction.rollback();
			LogPrinter.error(e.getMessage());
			return e.getMessage();
		}finally{
			DataAccessObject.closeSession();
		}
    }
	
	private void removeCustomerByID(Session session ,String strCustomerID) {
		dao.remove(session, Customer.class, strCustomerID);
	}
}