package chinsoft.business;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.Transaction;

import chinsoft.core.DataAccessObject;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.entity.Information;
import chinsoft.entity.Member;

public class InformationManager {

	DataAccessObject dao = new DataAccessObject();

	public InformationManager() {
	}

	// 添加&修改资料
	public void saveInformation(Information information) {
		if(information.getID() == null || "".equals(information.getID()))
		{
			information.setPubDate(new Date());
		}
		
		dao.saveOrUpdate(information);
	}

	// 根据ID查询
	public Information getInformationByID(String strInformationID) {
		Information information = (Information) dao.getEntityByID(Information.class, strInformationID);
		this.extendInformation(information);
		if (StringUtils.isNotEmpty(information.getAttachmentIDs()))
        {
            information.setAttachmentNames(new AttachmentManager().GetAttachmentNames(information.getAttachmentIDs()));
        }
		return information;
	}

	@SuppressWarnings("unchecked")
	public List<Information> getInformations(int nPageIndex, int nPageSize, String strKeyword, int nVersionID,Member member)
    {
		List<Information> informations= new ArrayList<Information>();
    	try {
	    	String hql = "FROM Information i WHERE i.Title LIKE ?  AND i.VersionID = ? AND (accessGroupIDs like ? or pubMemberID=?) ORDER BY PubDate DESC" ;
			Query query = DataAccessObject.openSession().createQuery(hql);
			query.setString(0, "%" + strKeyword + "%");
			query.setInteger(1, nVersionID);
			query.setString(2, "%"+member.getGroupID()+"%");
			query.setString(3, member.getID());

			int nFirstResult = Utility.toSafeInt(nPageIndex * nPageSize);
			query.setFirstResult(nFirstResult);
			query.setMaxResults(nPageSize);
			informations=query.list();
			for(Information information: informations){
				extendInformation(information);
			}
    	} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		}finally{
			DataAccessObject.closeSession();
		}
    	return informations;
    }

	private void extendInformation(Information information) {
		information.setCategoryName(DictManager.getDictNameByID(information.getCategoryID()));
		information.setAccessGroupNames(DictManager.getDictNamesByIDs(information.getAccessGroupIDs()));
	}

	public long getInformationsCount(String strKeyword,int nVersionID,Member member)
    {
		long count = 0;
    	try {
    		String hql = "SELECT COUNT(*) FROM Information i WHERE i.Title LIKE ? AND i.VersionID = ? AND (accessGroupIDs like ? or pubMemberID=?)" ;
			Query query = DataAccessObject.openSession().createQuery(hql);
			query.setString(0, "%" + strKeyword + "%");
			query.setInteger(1, nVersionID);
			query.setString(2, "%"+member.getGroupID()+"%");
			query.setString(3, member.getID());
			count=Utility.toSafeLong(query.uniqueResult());
    	} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		}finally{
			DataAccessObject.closeSession();
		}
    	
    	return count;
    }

	// 删除
	public void removeInformationByID(String strInformationID) {
		dao.remove(Information.class, strInformationID);
	}
	
	public String removeInformations(String removeIDs)
    {
		if (removeIDs.equals("")) {
			return "请选择待删除项";
		}
		
    	Transaction transaction=null;
    	Session session=null;
    	try {
	    	session= DataAccessObject.openSession();
	    	transaction=session.beginTransaction();
	    	
	    	String[] arrInformationIDs = Utility.getStrArray(removeIDs);
	    	LogPrinter.debug("length_arr" + arrInformationIDs.length);
	    	for (Object informationID : arrInformationIDs) {
	    		if(informationID != null && informationID != "")
	            {
	                this.removeInformationByID(session, Utility.toSafeString(informationID));
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
	
	private void removeInformationByID(Session session ,String strInformationID) {
		dao.remove(session, Information.class, strInformationID);
	}
}