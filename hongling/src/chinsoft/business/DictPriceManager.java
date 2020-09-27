package chinsoft.business;

import java.util.ArrayList;
import java.util.List;

import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.Transaction;

import chinsoft.core.DataAccessObject;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.entity.Dictprice;

public class DictPriceManager {

	DataAccessObject dao = new DataAccessObject();

	public DictPriceManager() {
	}

	// 添加&修改资料
	public void saveDictPrice(Dictprice dictprice) {
		try{
			dao.saveOrUpdate(dictprice);
		}catch(Exception e){
			e.printStackTrace();
		}
	}

	// 根据ID查询
	public Dictprice getDictPriceByID(String strDictpriceID) {
		Dictprice dictprice = (Dictprice) dao.getEntityByID(Dictprice.class, Integer.parseInt(strDictpriceID));
		this.extendDictPrice(dictprice);
		
		return dictprice;
	}

	@SuppressWarnings("unchecked")
	public List<Dictprice> getDictPrices(int nPageIndex, int nPageSize, String strKeyword)
    {
		List<Dictprice> dictprices= new ArrayList<Dictprice>();
    	try {
	    	String hql = "FROM Dictprice i WHERE i.code LIKE ?  or i.name LIKE ?  ORDER BY id desc" ;
			Query query = DataAccessObject.openSession().createQuery(hql);
			query.setString(0, "%" + strKeyword + "%");
			query.setString(1, "%" + strKeyword + "%");

			int nFirstResult = Utility.toSafeInt(nPageIndex * nPageSize);
			query.setFirstResult(nFirstResult);
			query.setMaxResults(nPageSize);
			dictprices=query.list();
			for(Dictprice dictprice: dictprices){
				extendDictPrice(dictprice);
			}
    	} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		}finally{
			DataAccessObject.closeSession();
		}
    	return dictprices;
    }

	private void extendDictPrice(Dictprice dictprice) {
		String ismanualInfo="机器收费";
		if(dictprice.getIsmanual() != null && "10050".equals(dictprice.getIsmanual().toString())){
			ismanualInfo="全手工免费";
		}else if(dictprice.getIsmanual() != null && "10051".equals(dictprice.getIsmanual().toString())){
			ismanualInfo="手工机器类收费";
		}
		dictprice.setIsmanualInfo(ismanualInfo);
		String pricetypeInfo="";
		if(dictprice.getPricetype() != null && "36019".equals(dictprice.getPricetype().toString())){
			pricetypeInfo="工艺收费加盟商(BATE)";
		}else if(dictprice.getPricetype() != null && "20142".equals(dictprice.getPricetype().toString())){
			pricetypeInfo="国内加盟商";
		}else if(dictprice.getPricetype() != null && "20143".equals(dictprice.getPricetype().toString())){
			pricetypeInfo="国外加盟商";
		}
		dictprice.setPricetypeInfo(pricetypeInfo);
		if(dictprice.getGroupids() != null){
			dictprice.setGroupidsInfo(DictManager.getDictNamesByIDs(dictprice.getGroupids()));
		}
		
	}

	public long getDictPricesCount(String strKeyword)
    {
		long count = 0;
    	try {
    		String hql = "SELECT COUNT(*) FROM Dictprice i WHERE i.code LIKE ?  AND i.name LIKE ?  ORDER BY groupids,code)" ;
			Query query = DataAccessObject.openSession().createQuery(hql);
			query.setString(0, "%" + strKeyword + "%");
			query.setString(1, "%" + strKeyword + "%");
			
			count=Utility.toSafeLong(query.uniqueResult());
    	} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		}finally{
			DataAccessObject.closeSession();
		}
    	
    	return count;
    }

	// 删除
	public void removeDictPriceByID(String strDictpriceID) {
		dao.remove(Dictprice.class, strDictpriceID);
	}
	
	public String removeDictPrices(String removeIDs)
    {
		if (removeIDs.equals("")) {
			return "请选择待删除项";
		}
		
    	Transaction transaction=null;
    	Session session=null;
    	try {
	    	session= DataAccessObject.openSession();
	    	transaction=session.beginTransaction();
	    	
	    	String[] arrDictpriceIDs = Utility.getStrArray(removeIDs);
	    	LogPrinter.debug("length_arr" + arrDictpriceIDs.length);
	    	for (Object dictpriceID : arrDictpriceIDs) {
	    		if(dictpriceID != null && dictpriceID != "")
	            {
	                this.removeDictPriceByID(session, Utility.toSafeString(dictpriceID));
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
	
	private void removeDictPriceByID(Session session ,String strDictpriceID) {
		dao.remove(session, Dictprice.class, Integer.valueOf(strDictpriceID));
	}
	
	public int getMaxDictPricesID()
    {
		int count = 0;
    	try {
    		String hql = "SELECT MAX(id) FROM Dictprice" ;
			Query query = DataAccessObject.openSession().createQuery(hql);
			
			count=Utility.toSafeInt(query.uniqueResult());
    	} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		}finally{
			DataAccessObject.closeSession();
		}
    	
    	return count;
    }
}