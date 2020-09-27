package chinsoft.business;

import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.Transaction;

import centling.entity.Deal;
import chinsoft.core.DataAccessObject;
import chinsoft.core.LogPrinter;
import chinsoft.entity.WorkflowRequestinfoItems;

public class WorkflowRequestInfoItemsManager {
	
	DataAccessObject dao = new DataAccessObject();
	private static List<WorkflowRequestinfoItems> wriiLists = null;
	
	@SuppressWarnings("unchecked")
	private List<WorkflowRequestinfoItems> getAll()
    {
    	try {
    		if(wriiLists == null){		
    			Query query = DataAccessObject.openSession().createQuery("FROM WorkflowRequestinfoItems");
    			wriiLists=query.list();
    		}
    		
    	} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		}finally{
			DataAccessObject.closeSession();
		}
    	List<WorkflowRequestinfoItems> wriiList= new ArrayList<WorkflowRequestinfoItems>();
    	for(WorkflowRequestinfoItems wrii: wriiLists){
    		wriiList.add(wrii);
    	}
    	return wriiList;
    }

	public WorkflowRequestinfoItems getWorkflowRequestInfoItemsById(Integer id){
		List<WorkflowRequestinfoItems> wriiList=new ArrayList<WorkflowRequestinfoItems>();
		
		String hql="from InterfaceOperateInfo d where d.id=? ";
		try {
			Query query = DataAccessObject.openSession().createQuery(hql);
			query.setLong(0, id);
			wriiList = query.list();
		} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		} finally {
			DataAccessObject.closeSession();
		}
		if(null!=wriiList&&wriiList.size()>0){
			return wriiList.get(0);
		}
		return null;
	}
	
	public List<WorkflowRequestinfoItems> getAllByInterfaceId(Long id,Long workflowid ,Long userid,Date date) {
		
			List<WorkflowRequestinfoItems> wriiList=new ArrayList<WorkflowRequestinfoItems>();
			SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd");
			String dateTime=sdf.format(date);
			String hql="from WorkflowRequestinfoItems d where d.interfaceId=? and d.workflowId=? and d.userId=? and to_char(d.workflowTime ,'yyyy-mm-dd')=?";
			try {
				Query query = DataAccessObject.openSession().createQuery(hql);
				query.setLong(0, id);
				query.setLong(1, workflowid);
				query.setLong(2, userid);
				query.setString(3, dateTime);
				wriiList = query.list();
			} catch (Exception e) {
				LogPrinter.error(e.getMessage());
			} finally {
				DataAccessObject.closeSession();
			}
			return wriiList;
			
	}

	public void saveOrUpdate(WorkflowRequestinfoItems wrii) {
		Session session= DataAccessObject.openSessionFactory().openSession();
		Transaction transaction=session.beginTransaction();
		try {
			session.saveOrUpdate(wrii);
			transaction.commit();
		} catch (Exception e) {
			e.printStackTrace();
			transaction.rollback();
		}finally{
			session.close();
		}
		
	}

	public List<WorkflowRequestinfoItems> getAllWorkflowInfoByInterfaceId(Long id) {
		List<WorkflowRequestinfoItems> wriiList=new ArrayList<WorkflowRequestinfoItems>();
		
		String hql="from WorkflowRequestinfoItems d where d.interfaceId=?";
		try {
			Query query = DataAccessObject.openSession().createQuery(hql);
			query.setLong(0, id);
			wriiList = query.list();
		} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		} finally {
			DataAccessObject.closeSession();
		}
		return wriiList;
		
	}

}
