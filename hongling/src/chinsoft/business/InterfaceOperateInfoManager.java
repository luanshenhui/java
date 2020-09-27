package chinsoft.business;

import java.util.ArrayList;
import java.util.List;

import org.hibernate.HibernateException;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.Transaction;

import centling.entity.Deal;
import chinsoft.core.DataAccessObject;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.entity.InterfaceOperateInfo;
import chinsoft.entity.WorkflowRequestinfoItems;

public class InterfaceOperateInfoManager {
	
	DataAccessObject dao = new DataAccessObject();
	private static List<InterfaceOperateInfo> ioiLists = null;
	
	@SuppressWarnings("unchecked")
	private List<InterfaceOperateInfo> getAll()
    {
    	try {
    		if(ioiLists == null){		
    			Query query = DataAccessObject.openSession().createQuery("FROM InterfaceOperateInfo");
    			ioiLists=query.list();
    		}
    		
    	} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		}finally{
			DataAccessObject.closeSession();
		}
    	List<InterfaceOperateInfo> ioiList= new ArrayList<InterfaceOperateInfo>();
    	if(null!=ioiLists&&ioiLists.size()>0){
    		for(InterfaceOperateInfo ioi: ioiLists){
    			ioiList.add(ioi);
    		}
    	}
    	return ioiList;
    }

	public List<InterfaceOperateInfo> getInterfaceOperateInfo(Long userId, Long workflowId) {
		
		List<InterfaceOperateInfo> wriiList=new ArrayList<InterfaceOperateInfo>();
		
		String hql="from InterfaceOperateInfo d where d.workflowId=? and d.userId=?";
		try {
			Query query = DataAccessObject.openSession().createQuery(hql);
			query.setLong(0, workflowId);
			query.setLong(1, userId);
			wriiList = query.list();
		} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		} finally {
			DataAccessObject.closeSession();
		}
		return wriiList;
		
	}

	public void update(InterfaceOperateInfo ioi) {
		Session session= DataAccessObject.openSessionFactory().openSession();
		Transaction transaction=session.beginTransaction();
		try {
			session.update(ioi);
			transaction.commit();
		} catch (Exception e) {
			e.printStackTrace();
			transaction.rollback();
		}finally{
			session.close();
		}

	}


	public long getMaxInterfaceId(long userId,long workflowId) {
		long id=0;
		StringBuffer hql = new StringBuffer();
		hql.append("SELECT max(d.ID)  FROM INTERFACE_OPERATE_INFO d where d.user_Id = "+userId+" and d.workflow_Id="+workflowId);
		try {
				Query query = DataAccessObject.openSession().createSQLQuery(hql.toString());
				id = Utility.toSafeLong(query.uniqueResult());
				
			} catch (HibernateException e) {
				e.printStackTrace();
			} finally {
				DataAccessObject.closeSession();
			}
		return id;
	}


	public InterfaceOperateInfo getInterfaceById(long maxInterfaceId) {
		
		List<InterfaceOperateInfo> ioiList = new ArrayList<InterfaceOperateInfo>();
		InterfaceOperateInfo ioi=null;
		StringBuffer hql = new StringBuffer();
		hql.append("FROM InterfaceOperateInfo d where d.id = ?");
		try {
			Query query = DataAccessObject.openSession().createQuery(hql.toString());
			query.setLong(0, maxInterfaceId);
			ioiList = query.list();
			if(null!=ioiList&&ioiList.size()>0){
				ioi=ioiList.get(0);
			}
		} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		} finally {
			DataAccessObject.closeSession();
		}
		return ioi;
	}

	public InterfaceOperateInfo save(InterfaceOperateInfo ioi) {
		Session session= DataAccessObject.openSessionFactory().openSession();
		Transaction transaction=session.beginTransaction();
		InterfaceOperateInfo ioiNew=null;
		try {
			ioiNew=(InterfaceOperateInfo) dao.save(session, ioi);
			transaction.commit();
		} catch (Exception e) {
			e.printStackTrace();
			transaction.rollback();
		}finally{
			session.close();
		}
		return ioiNew;
	}

}
