package centling.business;

import java.util.List;

import chinsoft.business.CDictCategory;
import chinsoft.business.DictManager;
import chinsoft.core.DataAccessObject;
import chinsoft.entity.Dict;

public class BlClothingManager {
	
	DataAccessObject dao = new DataAccessObject();
	
	// 取服装
	public List<Dict> getDiscountClothing() {
		List<Dict> dicts = new BlClothingManager().getDiscountClothingCategory(0);
		return dicts;
	}
	//取折扣服装种类
	public List<Dict> getDiscountClothingCategory(int nParentID) {
		List<Dict> list = DictManager.getDicts(CDictCategory.DiscountClothingCategory.getID(), nParentID);
		return list;
	}
}