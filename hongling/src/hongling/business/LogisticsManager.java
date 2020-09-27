package hongling.business;

import hongling.entity.Logistics;
import hongling.entity.LogisticsCompany;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.hibernate.HibernateException;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.Transaction;

import chinsoft.core.DataAccessObject;
import chinsoft.core.Utility;

public class LogisticsManager {
	
	@SuppressWarnings("unchecked")
	public List<Logistics> getLogisticses(int pageNo,int pageSize,String sendTo,String sendEnd,String sendMode,String status,String companyid){
		
		List<Logistics> logisticses=new ArrayList<Logistics>();
		Query query=getLogisticsQuery("l",sendTo,sendEnd,sendMode,status,companyid);
		query.setFirstResult(pageNo*pageSize);
		query.setMaxResults(pageSize);
		logisticses=(List<Logistics>)query.list();
		for(Logistics logistics:logisticses){
			if(this.getLogisticsCompanyByID(logistics.getCompany())!=null){
				logistics.setLogisticsCompany(this.getLogisticsCompanyByID(logistics.getCompany()));
			}
		}
		return logisticses;
	}
	public LogisticsCompany getLogisticsCompanyByID(String id){
		LogisticsCompany logisticscompany=null;
		String hql="from LogisticsCompany l where l.id=:id";
		Query query=DataAccessObject.openSession().createQuery(hql);
//		query.setString("id", id);
		query.setInteger("id", Utility.toSafeInt(id));
		logisticscompany=(LogisticsCompany)query.list().get(0);
		return logisticscompany;
	}
	public void saveLogistics(Logistics logistics){
		new DataAccessObject().saveOrUpdate(logistics);
	}
	public int getLogisticsesCount(String sendTo,String sendEnd,String sendMode,String status,String companyid){
		int count=0;
		Query query=getLogisticsQuery("COUNT(*)",sendTo,sendEnd,sendMode,status,companyid);
		count=Utility.toSafeInt(query.uniqueResult());
		return count;
	}
	public String deleteLogisticses(String id,Date nTime,String name){
		Transaction trans=null;
		Session session=null;
		Query query=null;
		try {
			session=DataAccessObject.openSession();
			trans=session.beginTransaction();
			String hql="UPDATE Logistics as l SET l.status=2,l.closeby=:closeby,l.closetime=:closetime WHERE l.id=:id";
			query=session.createQuery(hql);
//			query.setString("id", id);
			query.setInteger("id", Utility.toSafeInt(id));
			query.setString("closeby", name);
			query.setTimestamp("closetime", nTime);
			query.executeUpdate();
			trans.commit();
			return Utility.RESULT_VALUE_OK;
		} catch (HibernateException e) {
			trans.rollback();
			e.printStackTrace();
			return e.getMessage();
		}
		finally{
			DataAccessObject.closeSession();
		}
		
	}
	public LogisticsCompany getLogisticsByID(int ID){
		return (LogisticsCompany)new DataAccessObject().getEntityByID(LogisticsCompany.class, ID);
	}
	public Logistics getLogisticsById(String id){
		return (Logistics)new DataAccessObject().getEntityByID(Logistics.class, Utility.toSafeInt(id));
		
	}
	public void saveLogisticsCompany(LogisticsCompany logisticscompany){
		new DataAccessObject().saveOrUpdate(logisticscompany);
	}
	public List<LogisticsCompany> getCompanyList(){
		List<LogisticsCompany> companys=new ArrayList<LogisticsCompany>();
		String hql="from LogisticsCompany";
		Query query=DataAccessObject.openSession().createQuery(hql);
		companys=(List<LogisticsCompany>)query.list();
		return companys;
	}
	public String removeCompany(String id){
		Transaction transaction=null;
    	Session session=null;
    	
    	try {
			session= DataAccessObject.openSession();
			transaction=session.beginTransaction();
			new DataAccessObject().remove(session,LogisticsCompany.class, Utility.toSafeInt(id));
			transaction.commit();
			return Utility.RESULT_VALUE_OK;
		} catch (HibernateException e) {
			e.printStackTrace();
			return e.getMessage();
		}
	}
	public boolean checkCompanyInLogistics(String id){
		boolean flag=false;
		String hql="From Logistics s where s.company=:ID";
		Query query=DataAccessObject.openSession().createQuery(hql);
//		query.setString("ID", id);
		query.setInteger("id", Utility.toSafeInt(id));
		if(query.list().size()>0){
			flag=false;
		}
		else
		{
			flag=true;
		}
		return flag;
	}
	public List<LogisticsCompany> getCompanyList(int pageNo,int pageSize){
		List<LogisticsCompany> companys=new ArrayList<LogisticsCompany>();
		String hql="from LogisticsCompany";
		Query query=DataAccessObject.openSession().createQuery(hql);
		query.setFirstResult(pageNo*pageSize);
		query.setMaxResults(pageSize);
		companys=(List<LogisticsCompany>)query.list();
		return companys;
		
	}
	private Query getLogisticsQuery(String strChange,String sendTo,String sendEnd,String sendMode,String status,String companyid){
		
		Query query=null;
		int stat=Utility.toSafeInt(status);
		if(stat==0){
			String hql="SELECT "+strChange+" from Logistics l WHERE l.sendto like :sendTo and l.sendend like :sendEnd and l.sendmode like :sendMode and l.company like :company ";
			query=DataAccessObject.openSession().createQuery(hql);
			query.setString("sendTo", "%"+sendTo+"%");
			query.setString("sendEnd", "%"+sendEnd+"%");
			query.setString("sendMode", "%"+sendMode+"%");
			query.setString("company", "%"+companyid+"%");
		}
		else
		{
			String hql="SELECT "+strChange+" from Logistics l WHERE  l.sendto like :sendTo and l.sendend like :sendEnd and l.sendmode like :sendMode and l.status=:status and l.company like :company ";
			query=DataAccessObject.openSession().createQuery(hql);
			query.setString("sendTo", "%"+sendTo+"%");
			query.setString("sendEnd", "%"+sendEnd+"%");
			query.setString("sendMode", "%"+sendMode+"%");
			query.setInteger("status", stat);
			query.setString("company", "%"+companyid+"%");
		}
		
		return query;
	}
}
