package chinsoft.business;

import java.util.List;

import chinsoft.core.DataAccessObject;
import chinsoft.core.ResourceHelper;
import chinsoft.entity.DictCategory;

public class DictCategoryManager {
	private static DataAccessObject dao = new DataAccessObject();
	private static List<DictCategory> allDictCategory = null;

	@SuppressWarnings("unchecked")
	public static List<DictCategory> getAllDictCategory() {
		if (DictCategoryManager.allDictCategory == null) {
			DictCategoryManager.allDictCategory = (List<DictCategory>)dao.getAll(DictCategory.class);
		}
		return DictCategoryManager.allDictCategory;
	}

	// / <summary>
	// / 根据ID取得一个字典分类档
	// / </summary>
	// / <param name="nDictCategoryID"></param>
	// / <returns></returns>
	public static DictCategory getDictCategoryByID(int nDictCategoryID) {
		List<DictCategory> allDictCategory = DictCategoryManager.getAllDictCategory();
		for (DictCategory dictCategory : allDictCategory) {
			if (dictCategory.getID() == nDictCategoryID) {
				return dictCategory;
			}
		}
		return null;
	}
	
	public static String getDictCategoryNameByID(Integer nDictCategoryID) {
		String strName = "";
		if(nDictCategoryID != null){
			try{
				strName = ResourceHelper.getValue("DictCategory_" + nDictCategoryID);
			}
			catch(Exception e){}
		}
		
		return strName;
	}
}
