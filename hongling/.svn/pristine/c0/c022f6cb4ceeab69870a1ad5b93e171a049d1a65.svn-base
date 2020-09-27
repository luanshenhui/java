package centling.business;

import java.util.ArrayList;
import java.util.List;

import org.hibernate.Query;

import centling.dto.DealItemDto;
import centling.entity.DealItem;
import chinsoft.core.DataAccessObject;
import chinsoft.core.LogPrinter;
import chinsoft.core.ResourceHelper;
import chinsoft.core.Utility;

public class BlDealItemManager {
	
	private static DataAccessObject dao = new DataAccessObject();
	private static List<DealItem> allDealItems = null;
	
	// 构造
	public BlDealItemManager() {
	}

	// 添加&修改交易项目
	public void saveDealItem(DealItem dealItem) {
		dao.saveOrUpdate(dealItem);
	}
	
	@SuppressWarnings("unchecked")
	public static List<DealItem> getAllDealItems() {
		if (BlDealItemManager.allDealItems == null) {
			BlDealItemManager.allDealItems = (List<DealItem>) dao.getAll(DealItem.class,"ID");
		}
		return BlDealItemManager.allDealItems;
	}
	
	public DealItem getDealItemByID(Integer dealItemID) {
		DealItem dealItem = null;
		if (dealItemID <= 0) {
			return null;
		}
		try {
			dealItem = (DealItem)dao.getEntityByID(DealItem.class, dealItemID);
		} catch (Exception e) {

		}
		if (dealItem != null) {
			return dealItem;
		} else {
			return null;
		}
	}
	
	@SuppressWarnings("unchecked")
	public List<DealItemDto> getDealItems(int nPageIndex, int nPageSize, String blKeyword)
    {
		List<DealItem> list= new ArrayList<DealItem>();
		List<DealItemDto> listdto = new ArrayList<DealItemDto>();
    	try { 
    		String strChange = "di";
	    	Query query = getDealItemsQuery(strChange, blKeyword);
			query.setFirstResult(nPageIndex * nPageSize);
			query.setMaxResults(nPageSize);
			list=query.list();
			for(DealItem di: list){
				String ioflagname = ResourceHelper.getValue("Dict_" + di.getIoFlag());
				listdto.add(new DealItemDto(di.getID(),di.getMemo(),di.getName(),di.getIoFlag(),ioflagname, di.getEn()));
			}
    	} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		}finally{
			DataAccessObject.closeSession();
		}
    	return listdto;
    }
	
	public long getDealItemsCount(String blKeyword)
    {
		long count = 0;
    	try {
    		Query query = getDealItemsQuery("COUNT(*)", blKeyword);
			count=Utility.toSafeLong(query.uniqueResult());
    	} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		}finally{
			DataAccessObject.closeSession();
		}
    	return count;
    }
	
	private Query getDealItemsQuery(String strChange,String blKeyword) {
		StringBuffer sb = new StringBuffer();
		sb.append("select " + strChange + " ");
		sb.append("from DealItem di, Dict d ");
		sb.append("where di.IoFlag=d.ID ");
		if (blKeyword!=null && !"".equals(blKeyword)){
			sb.append("  and (upper(di.ID) like upper(:keyword) ");      // 交易项目ID
			sb.append("       or upper(di.Name) like upper(:keyword) "); // 交易项目名称
			sb.append("       or upper(d.Name) like upper(:keyword) ");  // 收入支出标志
			sb.append("       or upper(di.Memo) like upper(:keyword)) ");// 备注
		}
		sb.append("order by di.ID asc ");
		Query query = DataAccessObject.openSession().createQuery(sb.toString());
		if (blKeyword!=null && !"".equals(blKeyword)){
			query.setString("keyword", "%" + blKeyword + "%");
		}
		return query;
	}
}
