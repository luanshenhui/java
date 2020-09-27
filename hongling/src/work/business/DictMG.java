package work.business;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.hibernate.Query;
import chinsoft.business.CDict;
import chinsoft.business.CDictCategory;
import chinsoft.business.CurrentInfo;
import chinsoft.business.DictManager;
import chinsoft.core.DataAccessObject;
import chinsoft.core.HttpContext;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.entity.Dict;
import chinsoft.vo.ProductDictVO;

public class DictMG {

	public Map<String, List<ProductDictVO>> getAllDictVO(String strProductId, String strType) {
		Map<String, List<ProductDictVO>> productMap = new HashMap<String, List<ProductDictVO>>();
		String clothingId = strProductId;
		Dict tempDict = null;
		try {
			if ("7".equals(strProductId) || "5".equals(strProductId) || "4".equals(strProductId) || "6".equals(strProductId) || "2".equals(strProductId) || "1".equals(strProductId)) {
				// 套装需要分开的
				String hql = " FROM Dict d WHERE d.id=:ProductId";
				Query query = DataAccessObject.openSession().createQuery(hql);
				query.setString("ProductId", strProductId);
				tempDict = (Dict) query.list().get(0);
				clothingId = tempDict.getExtension();
			}
			String[] tempIds = clothingId.split(",");
			for (String categoryId : tempIds) {
				productMap.put(categoryId, this.getComponentByKeyword(Utility.toSafeInt(categoryId), strType));
			}
		} catch (Exception e) {
			e.printStackTrace();
			LogPrinter.error(e.getMessage());
		} finally {
			DataAccessObject.closeSession();
		}
		return productMap;
	}

	public List<ProductDictVO> getComponentByKeyword(int nSingleClothingID, String strType) {
		String menuIDs=CurrentInfo.getCurrentMember().getMenuIDs();
		List<Dict> list = DictManager.getDicts(CDictCategory.ClothingCategory.getID());
		Dict d = DictManager.getDictByID(nSingleClothingID);
		List<ProductDictVO> newList = new ArrayList<ProductDictVO>();
		for (Dict dict : list) {
			if (!"".equals(dict.getEcode()) && dict.getEcode() != null && (dict.getIsShow() == null || dict.getIsShow() != 2)) {
				if (dict.getCode().startsWith(d.getCode()) && dict.getParentID() > 0) {
					Dict dictParent = DictManager.getDictByID(dict.getParentID());
					Dict dictParentParent = DictManager.getDictByID(dictParent.getParentID());
					// 配件工艺要符合所属系列
					if (nSingleClothingID != 5000 || (nSingleClothingID == 5000 && !"".equals(strType) && strType.equals(Utility.toSafeString(dictParentParent.getSequenceNo()))) || (nSingleClothingID == 5000 && "".equals(strType))) {
						if (dictParentParent != null && nSingleClothingID == 5000) {
							dict.setAllName(dictParentParent.getName() + " " + dictParent.getName() + ":" + dict.getName());
						} else if (dictParent != null) {
							if (dict.getName().indexOf(dictParent.getName()) < 0) {
								dict.setAllName(dictParent.getName() + ":" + dict.getName());
							} else {
								dict.setAllName(dict.getName());
							}
						}
						if (!Utility.contains(CDict.EMBROID, Utility.toSafeString(dictParentParent.getID())) && !Utility.contains(CDict.EMBROID, Utility.toSafeString(dict.getParentID()))&&Utility.contains(menuIDs, Utility.toSafeString(dict.getID()))&&dict.getEcode().length()<=4) {
							ProductDictVO dictVO = new ProductDictVO();
							dictVO.setId(Utility.toSafeString(dict.getID()));
							dictVO.setName(dict.getAllName());
							dictVO.setCode(dict.getEcode());
							dictVO.setIsDefault(dict.getIsDefault());
							dictVO.setParentId(dict.getParentID());
							dictVO.setCategoryID(dict.getCategoryID());
							dictVO.setStatusID(dict.getStatusID());
							newList.add(dictVO);
						}
					}
				}
			}
		}
		return newList;
	}

	// 根据ParentID取值
	/**
	 * @param nParentID
	 * @return
	 */
	public List<ProductDictVO> getDictByKeyword(int nParentID) {

		List<ProductDictVO> newList = new ArrayList<ProductDictVO>();
		String hql = " FROM Dict d WHERE  parentID=" + nParentID;
		Query query = DataAccessObject.openSession().createQuery(hql);
		String menus = CurrentInfo.getCurrentMember().getMenuIDs();
		String language = Utility.toSafeString(HttpContext.getSessionValue(Utility.SessionKey_Version));
		@SuppressWarnings("unchecked")
		List<Dict> list = query.list();
		for (Dict dict : list) {
			if (Utility.contains(menus, Utility.toSafeString(dict.getID()))) {
				ProductDictVO dictVO = new ProductDictVO();
				dictVO.setId(Utility.toSafeString(dict.getID()));
				dictVO.setCode(dict.getEcode());
				dictVO.setIsDefault(dict.getIsDefault());
				dictVO.setParentId(dict.getParentID());
				dictVO.setCategoryID(dict.getCategoryID());
				dictVO.setStatusID(dict.getStatusID());
				if (language.length() <= 0 || "1".equals(language)) {
					dictVO.setName(dict.getName());
				} else if ("2".equals(language)) {
					// en
					dictVO.setName(dict.getEn());
				} else if ("3".equals(language)) {
					// de
					dictVO.setName(dict.getDe());
				} else if ("4".equals(language)) {
					// fr
					dictVO.setName(dict.getFr());
				} else if ("5".equals(language)) {
					// ja
					dictVO.setName(dict.getJa());
				}
				newList.add(dictVO);
			}
		}
		return newList;
	}
}
