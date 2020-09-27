package centling.business;

import java.util.ArrayList;
import java.util.List;

import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.Transaction;

import centling.entity.ExpressCom;
import chinsoft.business.CDict;
import chinsoft.core.DataAccessObject;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;

/**
 * 
 * 快递公司Manager
 */
public class BlExpressComManager {
	DataAccessObject dao = new DataAccessObject();
	
	/**
	 * 分页查找快递公司
	 * @param nPageIndex
	 * @param nPageSize
	 * @param strKeyword
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<ExpressCom> getExpressComs(int nPageIndex, int nPageSize,String strKeyword) {
		List<ExpressCom> list = new ArrayList<ExpressCom>();
		String hql = "FROM ExpressCom e WHERE Name LIKE :Keyword AND StatusID= :StatusID ORDER BY Seq ";
		try {
			Query query = DataAccessObject.openSession().createQuery(hql);
			query.setFirstResult(nPageIndex * nPageSize);
			query.setMaxResults(nPageSize);
			query.setString("Keyword", "%" + strKeyword + "%");
			query.setInteger("StatusID", CDict.NO.getID());
			list=query.list();
			
			// 添加显示序号
			int i = 0;
			for (ExpressCom expressCom : list) {
				expressCom.setNumber(++i);
			}
		} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		} finally {
			DataAccessObject.closeSession();
		}
		return list;
	}
	
	/**
	 * 根据关键字查询条数
	 * @param strKeyword
	 * @return
	 */
	public long getExpressComCount(String strKeyword) {
		long count = 0;
		String hql = "SELECT COUNT(*) FROM ExpressCom e WHERE Name LIKE :Keyword AND StatusID= :StatusID";
		
		try {
			Query query = DataAccessObject.openSession().createQuery(hql);
			query.setString("Keyword", "%" + strKeyword + "%");
			query.setInteger("StatusID", CDict.NO.getID());
			count=Utility.toSafeLong(query.uniqueResult());
		} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		} finally {
			DataAccessObject.closeSession();
		}
		return count;
	}

	/**
	 * 保存快递公司
	 * @param expressCom 待保存的快递公司实体
	 */
	public void saveExpressCom(ExpressCom expressCom) {
		if (expressCom == null || "".equals(expressCom)) {
			return;
		}
		expressCom.setStatusID(CDict.NO.getID());
		dao.saveOrUpdate(expressCom);
	}

	/**
	 * 根据主键查询快递公司
	 * @param strExpressComId 待查询的快递公司主键
	 * @return 查询到的快递公司
	 */
	public ExpressCom getExpressComById(String strExpressComId) {
		return (ExpressCom)dao.getEntityByID(ExpressCom.class, strExpressComId);
	}
	
	/**
	 * 批量删除快递公司
	 * @param removedIDs 待删除的快递公司ID
	 * @return 删除结果
	 */
	public String removeExpressComs(String removeIDs) {
		if ("".equals(removeIDs)) {
			return "请选择待删除项";
		}
		
		// 得到待删除的快递公司ID
		String[] arrExpressComIDs = Utility.getStrArray(removeIDs);
		
		// 判断是否有用户再使用要删除的快递
		for (String arrExpreseComId : arrExpressComIDs) {
			String hql = "SELECT COUNT(*) FROM Member m WHERE expressComId= :expressComId";
			Query query = DataAccessObject.openSession().createQuery(hql);
			query.setString("expressComId", arrExpreseComId);
			long count=Utility.toSafeLong(query.uniqueResult());
			if (count > 0) {
				return "您要删除的快递公司有用户正在使用，不能删除";
			}
		}
		
		Transaction transaction=null;
    	Session session=null;
    	
    	try {
    		session = DataAccessObject.openSession();
    		transaction = session.beginTransaction();
    				
	    	for (String expressComID : arrExpressComIDs) {
	    		if(expressComID != null && !"".equals(expressComID)) {
	    			ExpressCom expressCom = (ExpressCom)session.load(ExpressCom.class, expressComID);
	    			expressCom.setStatusID(CDict.YES.getID());
	    			session.update(expressCom);
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
	
	/**
	 * 检索全部的快递公司
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<ExpressCom> getAllExpressComs() {
		List<ExpressCom> list = new ArrayList<ExpressCom>();
		String hql = "FROM ExpressCom e WHERE StatusID= :StatusID ORDER BY Seq ";
		try {
			Query query = DataAccessObject.openSession().createQuery(hql);
			query.setInteger("StatusID", CDict.NO.getID());
			list=query.list();
		} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		} finally {
			DataAccessObject.closeSession();
		}
		return list;
	}
}