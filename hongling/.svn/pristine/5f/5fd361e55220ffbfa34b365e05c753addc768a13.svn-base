package chinsoft.business;

import java.util.ArrayList;
import java.util.List;

import org.hibernate.Query;

import chinsoft.core.DataAccessObject;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.entity.MixSelected;

public class MixSelectedManager {
	DataAccessObject dao = new DataAccessObject();

	// 构造
	public MixSelectedManager() {
	}
	// 添加&修改资料
	@SuppressWarnings("null")
	public void saveMixSelected(MixSelected mixSelected) {
		if(mixSelected != null || !mixSelected.getId().equals(""))
		{
			dao.saveOrUpdate(mixSelected);
		}
	}
	// 根据ID查询
	public MixSelected getMixSelectedByID(String strMixSelectedID) {
		return (MixSelected) dao.getEntityByID(MixSelected.class, Utility.toSafeString(strMixSelectedID));
	}
	// 删除
	public void removeMixSelectedByID(String strMixSelectedID) {
		dao.remove(MixSelected.class, Utility.toSafeString(strMixSelectedID));
	}
	
	/**
	 * 根据memberid 查询信息
	 */
	@SuppressWarnings("unchecked")
	public List<MixSelected> getMixSelectedByMemberID(String memberID)
    {
		List<MixSelected> list= new ArrayList<MixSelected>();
    	try {
	    	String hql = "FROM MixSelected WHERE  MEMBERID=:MEMBERID" ;
			Query query = DataAccessObject.openSession().createQuery(hql);
			query.setString("MEMBERID", Utility.toSafeString(memberID));
			list=query.list();
    	} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		}finally{
			DataAccessObject.closeSession();
		}
    	return list;
    }

}