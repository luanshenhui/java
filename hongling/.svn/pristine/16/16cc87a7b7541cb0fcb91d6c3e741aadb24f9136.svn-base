package chinsoft.business;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;
import org.apache.struts2.ServletActionContext;
import org.hibernate.HibernateException;
import org.hibernate.Query;

import chinsoft.core.CVersion;
import chinsoft.core.DataAccessObject;
import chinsoft.core.HttpContext;
import chinsoft.core.LogPrinter;
import chinsoft.core.ResourceHelper;
import chinsoft.core.Utility;
import chinsoft.entity.Component;
import chinsoft.entity.Contrast;
import chinsoft.entity.CrossRule;
import chinsoft.entity.Detail;
import chinsoft.entity.Dict;
import chinsoft.entity.Embroidery;
import chinsoft.entity.Fabric;
import chinsoft.entity.FixedStyle;
import chinsoft.entity.Orden;
import chinsoft.entity.OrdenDetail;
import chinsoft.entity.SizeStandard;
import chinsoft.tempService.MapUtil;

public class ClothingManager {

	DataAccessObject	dao	= new DataAccessObject();

	public List<Dict> getInterliningTypeCategory() {
		List<Dict> InterliningTypeCategory = new ArrayList<Dict>();
		InterliningTypeCategory.add(CDict.ArtCategory2);
		InterliningTypeCategory.add(CDict.ArtCategory3);
		InterliningTypeCategory.add(CDict.ArtCategory4);
		InterliningTypeCategory.add(CDict.ArtCategory5);
		InterliningTypeCategory.add(CDict.ArtCategory6);
		InterliningTypeCategory.add(CDict.ArtCategory7);
		InterliningTypeCategory.add(CDict.ArtCategory8);
		InterliningTypeCategory.add(CDict.ArtCategory9);
		return InterliningTypeCategory;
	}

	// 取得我影响的工艺
	public List<Dict> getAffectedAllowByMe(Integer nDictID) {
		List<Dict> affectedByMe = new ArrayList<Dict>();
		List<Dict> affected = this.getAllAffectedAllow();
		for (Dict dict : affected) {
			for (String affectedAllow : dict.getAffectedAllow().split("\\|")) {
				for (String partAffect : Utility.getStrArray(affectedAllow)) {
					if (Utility.toSafeString(nDictID).equals(partAffect)) {
						if (!affectedByMe.contains(dict)) {
							affectedByMe.add(dict);
							break;
						}
					}
				}
			}
		}
		return affectedByMe;
	}

	public boolean disabledByOther(String strComponentIDs, Dict component) {
		if (component != null) {
			List<Dict> allClothings = DictManager.getDicts(CDictCategory.ClothingCategory.getID());
			for (Dict clothing : allClothings) {
				if (clothing.getAffectedDisabled() != null && !"".equals(clothing.getAffectedDisabled())) {
					if (Utility.contains(strComponentIDs, Utility.toSafeString(clothing.getID()))) {
						String parts = clothing.getAffectedDisabled();
						if (Utility.contains(parts, Utility.toSafeString(component.getID()))) {
							return true;
						}
					}
				}
			}
		}
		return false;
	}

	public boolean allowedByOther(List<Dict> components, Dict component) {
		boolean nAllowed = true;
		if (component != null && component.getAffectedAllow() != null && !"".equals(component.getAffectedAllow())) {
			nAllowed = false;
			String strAffectedAllow = component.getAffectedAllow();
			String[] affectedAllows = strAffectedAllow.split("\\|");
			if (affectedAllows != null && affectedAllows.length > 0) {
				for (String affectedAllow : affectedAllows) {
					String[] partAffects = Utility.getStrArray(affectedAllow);
					if (partAffects != null && partAffects.length > 0) {
						int nTotalTrue = 0;
						for (String partAffect : partAffects) {
							if (this.partInAllow(partAffect, components)) {
								nTotalTrue++;
							}
						}
						if (nTotalTrue == partAffects.length) {
							return true;
						}
					}

				}
			}
		}
		return nAllowed;
	}

	public List<Dict> getDefaultComponent(Integer nClothingID, String strFabricCode) {
		List<Dict> singleClothings = new ClothingManager().getSingleClothings(nClothingID);
		List<Dict> defaultComponents = new ArrayList<Dict>();
		List<Dict> all = DictManager.getDicts(CDictCategory.ClothingCategory.getID());

		for (Dict singleClothing : singleClothings) {
			for (Dict c : all) {
				if (CDict.Component.getID().equals(c.getStatusID()) || CDict.Parameter.getID().equals(c.getStatusID())) {
					if (CDict.YES.getID().equals(c.getIsDefault()) && c.getCode().startsWith(singleClothing.getCode().substring(0, 4))) {
						defaultComponents.add(c);
					}
				}

				if (CDict.YES.getID().equals(c.getIsElement()) && c.getCode().startsWith(singleClothing.getCode().substring(0, 4))) {
					if (StringUtils.isNotEmpty(c.getParentFabric()) && StringUtils.isNotEmpty(strFabricCode)) {
						if (Utility.contains(c.getParentFabric(), strFabricCode)) {
							defaultComponents.add(c);
						}
					}
				}

			}
		}

		List<Dict> validDefaultComponents = new ArrayList<Dict>();
		for (Dict defaultComponent : defaultComponents) {
			validDefaultComponents.add((Dict) defaultComponent.clone());
		}

		// 去掉Disabled
		for (Dict defaultComponent : defaultComponents) {
			if (StringUtils.isNotEmpty(defaultComponent.getAffectedDisabled())) {
				String[] disabledComponents = Utility.getStrArray(defaultComponent.getAffectedDisabled());
				for (String disabledComponent : disabledComponents) {
					Dict dict = DictManager.getDictByID(Utility.toSafeInt(disabledComponent));
					if (dict != null) {
						validDefaultComponents.remove(dict);
					}
				}
			}
		}

		// allowed
		List<Dict> valids = new ArrayList<Dict>();
		for (Dict component : validDefaultComponents) {
			if (this.allowedByOther(validDefaultComponents, component)) {
				valids.add(component);
			}
		}

		return valids;
	}

	public List<Dict> getComponentsByIDs(String strComponentIDs) {
		String[] componentIDs = Utility.getStrArray(strComponentIDs);
		List<Dict> components = new ArrayList<Dict>();
		for (String componentID : componentIDs) {
			Dict component = DictManager.getDictByID(Utility.toSafeInt(componentID));
			components.add(component);
		}

		return components;
	}

	// 取得我禁止的工艺
	public List<Dict> getAffectedDisableByMe(Integer nDictID) {
		List<Dict> disableByMe = new ArrayList<Dict>();
		Dict dict = DictManager.getDictByID(nDictID);
		if (StringUtils.isNotEmpty(dict.getAffectedDisabled())) {
			String[] disables = Utility.getStrArray(dict.getAffectedDisabled());
			for (String disable : disables) {
				Dict d = DictManager.getDictByID(Utility.toSafeInt(disable));
				if (d != null) {
					disableByMe.add(d);
				}

			}
		}
		return disableByMe;
	}

	private List<Dict> getAllAffectedAllow() {
		List<Dict> affectedComponents = new ArrayList<Dict>();
		List<Dict> clothings = DictManager.getDicts(CDictCategory.ClothingCategory.getID());
		for (Dict clothing : clothings) {
			if (!"".equals(clothing.getAffectedAllow()) && clothing.getAffectedAllow() != null) {
				affectedComponents.add(clothing);
			}
		}
		return affectedComponents;
	}

	private boolean partInAllow(String part, List<Dict> defaultComponent) {
		boolean b = false;
		for (Dict d : defaultComponent) {

			if (Utility.toSafeString(d.getID()).equals(part)) {
				b = true;
				break;
			}
		}
		return b;
	}

	public List<Dict> getComponentCategory(int nSingleClothingID) {
		List<Dict> categorys = new ArrayList<Dict>();
		List<Dict> normalComponents = this.getAllNormalComponents(nSingleClothingID);
		for (Dict component : normalComponents) {
			if (haveChildDict(normalComponents, component.getID(), nSingleClothingID)) {
				categorys.add(component);
			}
		}
		// 文本框没有下级，需要补上
		for (Dict component : normalComponents) {
			if (CDict.ComponentText.getID().equals(component.getStatusID())) {
				categorys.add(component);
			}
		}
		return categorys;
	}

	private boolean haveChildDict(List<Dict> all, Integer nDictID, int nSingleClothingID) {
		for (Dict dict : all) {
			if (dict.getParentID().equals(nDictID)) {
				return true;
			}
		}
		return false;
	}

	public List<Dict> getAllNormalComponents(int nSingleClothingID) {
		Dict singleClothing = DictManager.getDictByID(nSingleClothingID);
		String strSingleClothingCode = Utility.toSafeString(singleClothing.getCode()).trim();
		List<Dict> normalComponents = new ArrayList<Dict>();
		List<Dict> clothings = DictManager.getDicts(CDictCategory.ClothingCategory.getID());
		for (Dict clothing : clothings) {
			if (CDict.Component.getID().equals(clothing.getStatusID()) || CDict.Parameter.getID().equals(clothing.getStatusID()) || "".equals(clothing.getStatusID()) || clothing.getStatusID() == null || CDict.ComponentText.getID().equals(clothing.getStatusID())

			) {
				if (clothing.getCode().startsWith(strSingleClothingCode)) {
					normalComponents.add(clothing);
				}
			}
		}
		return normalComponents;
	}

	public List<Dict> getSingleComponents(String strComponentIDs, int nSingleClothingID) {
		List<Dict> allNormalComponents = this.getAllNormalComponents(nSingleClothingID);
		List<Dict> singleComponents = new ArrayList<Dict>();
		for (Dict component : allNormalComponents) {
			if (Utility.contains(strComponentIDs, Utility.toSafeString(component.getID()))) {
				singleComponents.add(component);
			}
		}
		return singleComponents;
	}

	// 取服装
	public List<Dict> getClothing() {
		List<Dict> dicts = new ClothingManager().getClothingCategory(0);
		return CurrentInfo.getAuthorityFunction(dicts);
	}

	public List<Dict> getClothing2() {
		List<Dict> dicts = null;
		String hql = "FROM Dict d where d.CategoryID=1 AND d.Code in ('0001','0002','0003','0004','0005','0006','0007')";
		Query query = DataAccessObject.openSession().createQuery(hql);
		dicts = query.list();
		return dicts;
	}

	public List<Dict> getAccordion(int nParentID) {
		List<Dict> all = new ArrayList<Dict>();
		all.addAll(new FabricManager().getFabricCategory(nParentID));
		all.addAll(new ClothingManager().getClothingMenu(nParentID));
		return all;
	}

	public List<Dict> getMenu(int nParentID) {
		List<Dict> all = new ArrayList<Dict>();
		Dict dictParent = DictManager.getDictByID(nParentID);
		if (dictParent != null) {
			if (dictParent.getCategoryID().equals(CDictCategory.ClothingCategory.getID())) {
				all.addAll(new ClothingManager().getClothingMenu(nParentID));
			}
			if (dictParent.getCategoryID().equals(CDictCategory.FabricCategory.getID())) {
				all.addAll(new FabricManager().getFabricCategory(nParentID));
			}
		}
		return all;
	}

	public List<Component> getComponent(int nParentID) {
		List<Component> components = new ArrayList<Component>();
		Dict dictParent = DictManager.getDictByID(nParentID);

		if (dictParent.getCategoryID().equals(CDictCategory.FabricCategory.getID())) {
			Component component = new Component();
			component.setCategory(nParentID);
			List<Detail> details = new ArrayList<Detail>();
			for (Fabric fabric : new FabricManager().getFabricsByCategory(0, 1000000, nParentID)) {
				details.add(convertFabricToComponentDetail(fabric));
			}
			component.setDetails(details);
			components.add(component);
		} else {
			if (DownLevelIsComponentCategory(nParentID)) {

				List<Dict> list = new ClothingManager().getClothingComponent(nParentID);
				for (Dict componentCategory : list) {
					components.add(convertDictsToComponent(componentCategory.getID()));
				}
			} else {
				components.add(convertDictsToComponent(nParentID));
			}
		}
		return components;
	}

	/**
	 * 根据服装id和经销商id查面料
	 * 
	 * @param nParentID
	 * @param areaid
	 * @return
	 */
	public List<Component> getComponent(int nParentID, int areaid) {
		List<Component> components = new ArrayList<Component>();
		Dict dictParent = DictManager.getDictByID(nParentID);
		// FilterAreaFabric filter = new FilterAreaFabric();
		if (dictParent.getCategoryID().equals(CDictCategory.FabricCategory.getID())) {
			Component component = new Component();
			component.setCategory(nParentID);
			List<Detail> details = new ArrayList<Detail>();
			List<Fabric> fabricList = new FabricManager().getFabricsByCategory(0, 10000, nParentID, areaid);
			for (Fabric fabric : fabricList) {
				// 把不是登陆用户所在经销处 维护价格的面料 去掉 补:和停用的
				// if (!filter.isOurFabric(areaid, fabric) ||
				// fabric.getIsStop()==10050) {
				// continue;
				// }
				details.add(convertFabricToComponentDetail(fabric));
			}
			component.setDetails(details);
			components.add(component);
		} else {
			if (DownLevelIsComponentCategory(nParentID)) {

				List<Dict> list = new ClothingManager().getClothingComponent(nParentID);
				for (Dict componentCategory : list) {
					components.add(convertDictsToComponent(componentCategory.getID()));
				}
			} else {
				components.add(convertDictsToComponent(nParentID));
			}
		}
		return components;
	}

	public List<Dict> getComponentText(int nParentID) {
		List<Dict> texts = new ArrayList<Dict>();
		List<Dict> dicts = DictManager.getDicts(CDictCategory.ClothingCategory.getID(), nParentID);
		if (dicts != null && dicts.size() > 0) {
			for (Dict dict : dicts) {
				if (CDict.ComponentText.getID().equals(dict.getStatusID())) {
					texts.add(dict);
				}
			}
		}
		return texts;
	}

	public List<Dict> getParameterCategory(int nParentID) {
		List<Dict> parameterCategory = new ArrayList<Dict>();
		List<Dict> dicts = DictManager.getDicts(CDictCategory.ClothingCategory.getID(), nParentID);
		if (dicts != null && dicts.size() > 0) {
			for (Dict dict : dicts) {
				if (CDict.Parameter.getID().equals(dict.getStatusID())) {
					parameterCategory.add(dict);
				}
			}
		}

		return parameterCategory;
	}

	// 下级是组件分类还是组件
	private boolean DownLevelIsComponentCategory(int nParentID) {
		boolean haveDownLevel = false;
		List<Dict> downLevel = new ClothingManager().getClothingComponent(nParentID);
		for (Dict dict : downLevel) {
			List<Dict> downDownLevel = new ClothingManager().getClothingComponent(dict.getID());
			if (downDownLevel.size() > 0) {
				haveDownLevel = true;
			}
		}
		return haveDownLevel;
	}

	private Component convertDictsToComponent(int nParentID) {
		Component component = new Component();
		component.setCategory(nParentID);
		List<Dict> dicts = new ClothingManager().getClothingComponent(nParentID);
		List<Detail> details = new ArrayList<Detail>();
		String strFabricCode = "";
		if (CDict.COLORFABRIC.indexOf(Utility.toSafeString(nParentID)) >= 0) {
			strFabricCode = Utility.toSafeString(HttpContext.getSessionValue(CDict.SessionKey_FabricCode));
		}
		for (Dict dict : dicts) {
			if (!strFabricCode.equals(dict.getEcode())) {
				details.add(this.convertDictToComponentDetail(dict));
			}
		}
		component.setDetails(details);
		return component;
	}

	public Detail convertDictToComponentDetail(Dict dictSub) {
		Detail detail = new Detail();
		detail.setID(dictSub.getID().toString());
		detail.setName(dictSub.getEcode() == null ? dictSub.getName() : dictSub.getName() + "[" + dictSub.getEcode() + "]");
		detail.setZindex(dictSub.getZindex());
		detail.setJsEvent("$.csOrden.clickLoadMediumComponent('" + dictSub.getID() + "','" + dictSub.getExtension() + "')");

		return detail;
	}

	private Detail convertFabricToComponentDetail(Fabric fabric) {
		Detail detail = new Detail();
		detail.setID(fabric.getCode());
		detail.setName(fabric.getCode());
		detail.setJsEvent("$.csOrden.clickLoadMediumFabric('" + fabric.getCode() + "')");
		detail.setImgUrl(getFabricImgSmall(fabric.getCode()));
		return detail;
	}

	private String getFabricImg(String strFabricCode, String strSize) {
		return "../../process/fabric/" + strFabricCode + "_" + strSize + ".png";
	}

	public String getFabricImgSmall(String strFabricCode) {
		return this.getFabricImg(strFabricCode, "S");
	}

	public String getFabricImgMedium(String strFabricCode) {
		return this.getFabricImg(strFabricCode, "M");
	}

	private String getElementImg(String strElementID, String strSize) {
		Dict element = DictManager.getDictByID(Utility.toSafeInt(strElementID));
		Dict category = DictManager.getDictByID(element.getParentID());
		if (category != null) {
			return "../../process/" + category.getID() + "/" + strElementID + "_" + strSize + ".png";
		}
		return "";
	}

	private List<Dict> getCrossComponent(String strComponentIDs, Dict component) {
		List<CrossRule> crossRules = new CrossRuleManager().getCrossRules();
		CrossRule myCrossRule = null;
		for (CrossRule crossRule : crossRules) {
			if (Utility.contains(crossRule.getRules(), Utility.toSafeString(component.getParentID()))) {
				myCrossRule = crossRule;
				break;
			}
		}

		List<Dict> crossComponents = new ArrayList<Dict>();
		if (myCrossRule != null) {
			String[] rules = Utility.getStrArray(myCrossRule.getRules());
			for (String rule : rules) {
				List<Dict> subs = DictManager.getDicts(CDictCategory.ClothingCategory.getID(), Utility.toSafeInt(rule));
				for (Dict sub : subs) {
					if (Utility.contains(strComponentIDs, Utility.toSafeString(sub.getID()))) {
						Dict shapeLinkedImage = getShapeLinkedImage(strComponentIDs, sub);
						if (shapeLinkedImage != null) {
							sub = shapeLinkedImage;
						}
						crossComponents.add(sub);
					}
				}
			}
		}

		if (crossComponents == null || crossComponents.size() == 0) {
			crossComponents.add(component);
		}

		return crossComponents;
	}

	public String getElementImgSmall(String strElementID) {
		return this.getElementImg(strElementID, "S");
	}

	public String getElementImgMedium(String strElementID) {
		return this.getElementImg(strElementID, "M");
	}

	private String getComponentImg(String strPathCode, List<Dict> crossComponents, String strSize) {
		String strID = "";
		String strImg = "";
		boolean bHasSubImg = false;
		for (Dict crossComponent : crossComponents) {
			strID += crossComponent.getID() + "_";
			if (StringUtils.isNotEmpty(crossComponent.getShapeLinkIDs()) && "M".equals(strSize)) {
				bHasSubImg = true;
			}
		}
		// 中图
		strImg = "../../process/component/" + strPathCode + "/" + strID + strSize + ".png";
		if (bHasSubImg) {
			strImg += ",../../process/component/" + strPathCode + "/" + strID + "N" + ".png";
		}
		return strImg;
	}

	public String getComponentImgSmall(String strPathCode, Dict component) {
		List<Dict> components = new ArrayList<Dict>();
		components.add(component);
		return this.getComponentImg(strPathCode, components, "S");
	}

	public String getComponentImgMedium(String strComponentIDs, String strPathCode, Dict component) {
		List<Dict> crossComponents = this.getCrossComponent(strComponentIDs, component);
		return this.getComponentImg(strPathCode, crossComponents, "M");
	}

	public String getComponentImgLarge(String strComponentIDs, String strPathCode, Dict component) {
		List<Dict> crossComponents = this.getCrossComponent(strComponentIDs, component);
		String strViewCode = "Q";
		Dict dictView = DictManager.getDictByID(Utility.toSafeInt(component.getExtension()));
		if (dictView != null) {
			strViewCode = dictView.getExtension();
		}
		return this.getComponentImg(strPathCode, crossComponents, "L" + strViewCode);
	}

	public String getComponentImgBackground(String strPathCode, Dict component) {
		List<Dict> components = new ArrayList<Dict>();
		components.add(component);
		return this.getComponentImg(strPathCode, components, "B");
	}

	public Dict getShapeLinkedImage(String strTempComponentIDs, Dict component) {
		List<Dict> subs = DictManager.getDicts(CDictCategory.ClothingCategory.getID(), component.getID());
		if (subs != null && subs.size() > 0) {
			for (Dict sub : subs) {
				if (sub.getShapeLinkIDs() != null && !("").equals(sub.getShapeLinkIDs())) {
					String[] shapeLinkedIDs = Utility.getStrArray(sub.getShapeLinkIDs());
					for (String shapeLinkedID : shapeLinkedIDs) {
						if (Utility.contains(strTempComponentIDs, shapeLinkedID)) {
							return sub;
						}
					}
				}
			}
		}
		return null;
	}

	public List<Detail> getMediumComponents(String strComponentIDs, String strFabricCode, Dict component) {

		List<Dict> groupComponents = new ArrayList<Dict>();
		if (component != null && component.getMediumGroupID() != null) {

			List<Dict> allClothings = DictManager.getDicts(CDictCategory.ClothingCategory.getID());

			for (Dict clothing : allClothings) {
				if (clothing.getMediumGroupID() != null) {
					if (clothing.getMediumGroupID().equals(component.getMediumGroupID())) {
						if (Utility.contains(strComponentIDs, Utility.toSafeString(clothing.getID()))) {
							groupComponents.add(clothing);
						}
					}
				}
			}
		}

		if (groupComponents == null || groupComponents.size() == 0) {
			if (Utility.contains(strComponentIDs, Utility.toSafeString(component.getID()))) {
				groupComponents.add(component);
			}

		}

		List<Detail> details = new ArrayList<Detail>();
		for (Dict groupComponent : groupComponents) {

			// 添加分类的背景图
			Dict category = DictManager.getDictByID(groupComponent.getParentID());
			Detail detailCategory = convertDictToComponentDetail(category);
			detailCategory.setJsEvent("");
			detailCategory.setImgUrl(this.getComponentImgBackground(strFabricCode, category));
			details.add(detailCategory);

			// 譬如平驳头下带多个图
			Dict shapeLinkedImage = getShapeLinkedImage(strComponentIDs, groupComponent);
			if (shapeLinkedImage != null) {
				groupComponent = shapeLinkedImage;
			}

			Detail detail = convertDictToComponentDetail(groupComponent);
			detail.setJsEvent("");
			String strDictID = Utility.toSafeString(groupComponent.getID());

			if (CDict.YES.getID().equals(groupComponent.getIsElement())) {
				detail.setImgUrl(this.getElementImgMedium(strDictID));
			} else {
				detail.setImgUrl(this.getComponentImgMedium(strComponentIDs, strFabricCode, groupComponent));
			}
			details.add(detail);
			this.addProductDetailByElement(strComponentIDs, details, groupComponent, "M");
		}
		if (Utility.contains(strComponentIDs, Utility.toSafeString(component.getID()))) {
			this.addProductDetailByElement(strComponentIDs, details, component, "M");
		}
		return details;
	}

	public List<Detail> getProduct(String strFabricCode, String strComponentIDs, int nViewID, Dict singleClothing) {
		String[] ComponentIDs = Utility.getStrArray(strComponentIDs);
		List<Detail> details = new ArrayList<Detail>();
		for (String strComponentID : ComponentIDs) {
			Dict component = DictManager.getDictByID(Utility.toSafeInt(strComponentID));
			if (component != null && Utility.contains(Utility.toSafeString(component.getExtension()).trim(), Utility.toSafeString(nViewID)) && component.getCode().substring(0, 4).equals(singleClothing.getCode().substring(0, 4)) && (component.getIsElement() == null || !CDict.YES.getID().equals(component.getIsElement()))) {
				component.setExtension(Utility.toSafeString(nViewID));

				addProductDetailByFabric(strFabricCode, strComponentIDs, details, component);
				addProductDetailByElement(strComponentIDs, details, component, "L");
				// 经典设计（驳头撞色）
				if (CDict.CLASSICDICT.indexOf(Utility.toSafeString(component.getID())) > -1) {
					addProductDetailByElementClassic(strComponentIDs, details, component, "L");
				}
			}
		}
		return details;
	}

	private void addProductDetailByFabric(String strFabricCode, String strComponentIDs, List<Detail> details, Dict component) {
		Detail detail = convertDictToComponentDetail(component);
		detail.setJsEvent("");
		detail.setZindex(this.GetZindex(component));
		// 默认图片就是组件的大图
		Dict dictImage = component;
		// 譬如平驳头下带多个图
		Dict shapeLinkedImage = getShapeLinkedImage(strComponentIDs, component);
		if (shapeLinkedImage != null) {
			dictImage = shapeLinkedImage;
		}
		detail.setImgUrl(getComponentImgLarge(strComponentIDs, strFabricCode, dictImage));
		details.add(detail);
	}

	private void addProductDetailByElement(String strComponentIDs, List<Detail> details, Dict component, String strSize) {
		// 取出上级看ColorLinkedIDs如果不为空 譬如 35 扣数 | 375（扣） 363（钉扣线颜色） 313（大身里料）
		try {
			if ("M".equals(strSize)) {
				// LogPrinter.info(component.getID());
			}
			if (component.getParentID() != null) {
				Dict componentParent = DictManager.getDictByID(component.getParentID());
				if (componentParent != null) {

					String strColorLinkedIDs = componentParent.getColorLinkIDs();

					if (StringUtils.isNotEmpty(strColorLinkedIDs)) {
						String[] colorLinkedIDs = Utility.getStrArray(strColorLinkedIDs);
						for (String colorLinkedID : colorLinkedIDs) {
							List<Dict> colorComponents = DictManager.getDicts(CDictCategory.ClothingCategory.getID(), Utility.toSafeInt(colorLinkedID));
							for (Dict colorComponent : colorComponents) {
								if (Utility.contains(strComponentIDs, Utility.toSafeString(colorComponent.getID()))) {
									boolean bCanAdd = true;

									List<Contrast> contrasts = new ContrastManager().getContrasts();
									for (Contrast contrast : contrasts) {
										if (contrast.getColorCategoryID() != null) {
											if (Utility.toSafeString(contrast.getColorCategoryID()).equals(colorLinkedID)) {
												if (contrast.getComponentIDs().equals(Utility.toSafeString(componentParent.getID()))) {
													if (!Utility.contains(strComponentIDs, Utility.toSafeString(contrast.getPositionID()))) {
														bCanAdd = false;
													}
												}
											}
										}
									}
									if (bCanAdd) {
										Detail detail = convertDictToComponentDetail(component);
										detail.setJsEvent("");
										detail.setZindex(this.GetZindex(strComponentIDs, component, colorComponent));

										if ("L".equals(strSize)) {
											Dict dictImage = component;
											// 譬如平驳头下带多个图
											Dict shapeLinkedImage = getShapeLinkedImage(strComponentIDs, component);
											if (shapeLinkedImage != null) {
												dictImage = shapeLinkedImage;
											}
											detail.setImgUrl(this.getComponentImgLarge(strComponentIDs, Utility.toSafeString(colorComponent.getID()), dictImage));
										} else {
											detail.setImgUrl(this.getComponentImgMedium(strComponentIDs, Utility.toSafeString(colorComponent.getID()), component));
										}
										details.add(detail);
									}
								}
							}
						}
					}
				}
			}
		} catch (Exception e) {
			LogPrinter.debug("getProduct" + e.getLocalizedMessage());
		}
	}

	// 经典设计（驳头撞色）
	private void addProductDetailByElementClassic(String strComponentIDs, List<Detail> details, Dict component, String strSize) {
		try {
			Dict parent = DictManager.getDictByID(Utility.toSafeInt(component.getParentID()));
			if (parent.getParentID() != null) {
				Dict componentParent = DictManager.getDictByID(parent.getParentID());
				strComponentIDs = strComponentIDs + "," + parent.getParentID();
				if (componentParent != null) {

					String strColorLinkedIDs = componentParent.getColorLinkIDs();

					if (StringUtils.isNotEmpty(strColorLinkedIDs)) {

						String[] colorLinkedIDs = Utility.getStrArray(strColorLinkedIDs);
						for (String colorLinkedID : colorLinkedIDs) {
							List<Dict> colorComponents = DictManager.getDicts(CDictCategory.ClothingCategory.getID(), Utility.toSafeInt(colorLinkedID));
							for (Dict colorComponent : colorComponents) {
								if (Utility.contains(strComponentIDs, Utility.toSafeString(colorComponent.getID()))) {

									boolean bCanAdd = true;

									List<Contrast> contrasts = new ContrastManager().getContrasts();
									for (Contrast contrast : contrasts) {
										if (contrast.getColorCategoryID() != null) {
											if (Utility.toSafeString(contrast.getColorCategoryID()).equals(colorLinkedID)) {
												if (contrast.getComponentIDs().equals(Utility.toSafeString(componentParent.getID()))) {
													if (!Utility.contains(strComponentIDs, Utility.toSafeString(contrast.getPositionID()))) {
														bCanAdd = false;
													}
												}
											}
										}
									}
									if (bCanAdd) {
										Detail detail = convertDictToComponentDetail(parent);
										detail.setJsEvent("");
										detail.setZindex(this.GetZindex(strComponentIDs, parent, colorComponent));

										if ("L".equals(strSize)) {
											Dict dictImage = parent;
											// 譬如平驳头下带多个图
											Dict shapeLinkedImage = getShapeLinkedImage(strComponentIDs, parent);
											if (shapeLinkedImage != null) {
												dictImage = shapeLinkedImage;
											}
											detail.setImgUrl(this.getComponentImgLarge(strComponentIDs, Utility.toSafeString(colorComponent.getID()), dictImage));
											String url = "";
											String[] urls = detail.getImgUrl().split("/");
											for (int i = 0; i < urls.length - 1; i++) {
												url += urls[i] + "/";
											}
											url += component.getID() + "_LQ.png";
											detail.setImgUrl(url);
										}
										details.add(detail);
									}
								}
							}
						}
					}
				}
			}
		} catch (Exception e) {
			LogPrinter.debug("getProduct" + e.getLocalizedMessage());
		}
	}

	private int GetZindex(String strComponentIDs, Dict component, Dict colorComponent) {
		int nIndex = component.getZindex();
		List<Contrast> contrasts = new ContrastManager().getContrasts();
		for (Contrast contrast : contrasts) {
			if (Utility.contains(strComponentIDs, Utility.toSafeString(contrast.getPositionID()))) {
				List<Dict> contrastComponents = DictManager.getDicts(CDictCategory.ClothingCategory.getID(), Utility.toSafeInt(contrast.getComponentIDs()));
				for (Dict contrastComponent : contrastComponents) {
					if (component.getID().equals(contrastComponent.getID()) && colorComponent.getParentID().equals(contrast.getColorCategoryID())) {
						nIndex = nIndex + 101;
					}
				}
			}
		}

		return nIndex + Utility.toSafeInt(colorComponent.getZindex());
	}

	private int GetZindex(Dict component) {
		return Utility.toSafeInt(component.getZindex());
	}

	public String saveTempComponentIDs(String strTempComponentIDs, int nCurrentComponentID) {
		String strCurrentComponentID = Utility.toSafeString(nCurrentComponentID);

		int[] currentComponentIDs = new int[3];
		if (strCurrentComponentID.length() >= 8) {// 经典设计套装
			currentComponentIDs[0] = Utility.toSafeInt(strCurrentComponentID.substring(0, 4));
			currentComponentIDs[1] = Utility.toSafeInt(strCurrentComponentID.substring(4, 8));
			if (strCurrentComponentID.length() == 12) {
				currentComponentIDs[2] = Utility.toSafeInt(strCurrentComponentID.substring(8, 12));
			}
			strTempComponentIDs = "";
			for (int i = 0; i < currentComponentIDs.length; i++) {
				if (currentComponentIDs[i] != 0) {
					if (new FixedStyleManager().isFixStyle(currentComponentIDs[i])) {
						FixedStyle fixStyle = new FixedStyleManager().getFixedStyleByID(currentComponentIDs[i]);
						if (fixStyle != null) {
							strTempComponentIDs += "," + fixStyle.getStyles();
						}
					}
					strTempComponentIDs += "," + currentComponentIDs[i];
				}
			}
			strTempComponentIDs = strTempComponentIDs.substring(1, strTempComponentIDs.length());
		} else {
			List<FixedStyle> fixedStyles = new FixedStyleManager().getFixedStyles();
			for (FixedStyle fixedStyle : fixedStyles) {
				if (Utility.contains(strTempComponentIDs, Utility.toSafeString(fixedStyle.getFixedID()))) {
					strTempComponentIDs = Utility.replace(strTempComponentIDs, Utility.toSafeString(fixedStyle.getFixedID()));
				}
			}
			if (new FixedStyleManager().isFixStyle(nCurrentComponentID)) {
				FixedStyle fixStyle = new FixedStyleManager().getFixedStyleByID(nCurrentComponentID);
				if (fixStyle != null) {
					strTempComponentIDs = fixStyle.getStyles();
				}
			}
			Dict currentComponent = DictManager.getDictByID(nCurrentComponentID);
			if (currentComponent != null) {
				List<Dict> allComponents = new ClothingManager().getClothingCategory(currentComponent.getParentID());
				for (Dict component : allComponents) {
					if (Utility.contains(strTempComponentIDs, Utility.toSafeString(component.getID()))) {
						Dict parentComponent = DictManager.getDictByID(component.getParentID());
						if (component.getStatusID() != 10008 && component.getStatusID() != 10002) {
							strTempComponentIDs = Utility.replace(strTempComponentIDs, Utility.toSafeString(component.getID()));
						} else if (component.getStatusID() == 10002 && null != parentComponent.getIsSingleCheck()) {
							strTempComponentIDs = Utility.replace(strTempComponentIDs, Utility.toSafeString(component.getID()));
						}
					}
				}
				strTempComponentIDs += "," + nCurrentComponentID;
			}
			strTempComponentIDs = removeDisabled(strTempComponentIDs, nCurrentComponentID);
			strTempComponentIDs = addDefault(strTempComponentIDs, nCurrentComponentID, currentComponent);

			// 大衣扣数
			if (4264 == nCurrentComponentID) {// 双排六扣三
				if (Utility.contains(strTempComponentIDs, "4066") || Utility.contains(strTempComponentIDs, "4068")) {
					strTempComponentIDs = Utility.replace(strTempComponentIDs, "4066");// 尖下口
					strTempComponentIDs = Utility.replace(strTempComponentIDs, "4068");// 平下口圆摆
					strTempComponentIDs = Utility.replace(strTempComponentIDs, "4067");// 平下口直摆
				}
				strTempComponentIDs = strTempComponentIDs + ",4067";
			}
			if (Utility.contains("4036,4037,4038,4039,4040", Utility.toSafeString(nCurrentComponentID))) {// 单排
				// 单排3粒扣、单排4粒扣、单排5粒扣、单排6粒扣、单排7粒扣
				if (Utility.contains(strTempComponentIDs, "4067") || Utility.contains(strTempComponentIDs, "4066")) {
					strTempComponentIDs = Utility.replace(strTempComponentIDs, "4067");
					strTempComponentIDs = Utility.replace(strTempComponentIDs, "4067");
					strTempComponentIDs = Utility.replace(strTempComponentIDs, "4066");
					strTempComponentIDs = strTempComponentIDs + ",4066";

				}

			}
			// 上衣双排扣--直下摆
			if (Utility.contains("41,42,43,44,45,46,47,48", Utility.toSafeString(nCurrentComponentID))) {
				// 双排四扣二、双排六扣二、双排二扣一、双排四扣一、双排六扣一、双排六扣三、双排八扣四、双排暗门襟扣二
				if (!Utility.contains(strTempComponentIDs, "1995")) {
					strTempComponentIDs = strTempComponentIDs + ",1995";// 直下摆
				}
			} else {// 单排扣去掉直下摆
				if (Utility.contains(strTempComponentIDs, "1995") && "35".equals(Utility.toSafeString(currentComponent.getParentID()))) {
					strTempComponentIDs = Utility.replace(strTempComponentIDs, "1995");
				}
			}

		}

		return strTempComponentIDs;
	}

	public String saveTempParameterIDs(String strTempComponentIDs, int nCurrentComponentID) {
		String strCurrentParameterID = Utility.toSafeString(nCurrentComponentID);
		Dict currentComponent = DictManager.getDictByID(nCurrentComponentID);
		Dict parent = DictManager.getDictByID(currentComponent.getParentID());
		if (parent != null) {

			if (CDict.YES.getID().equals(parent.getIsSingleCheck())) {
				if (currentComponent != null) {

					List<Dict> allComponents = new ClothingManager().getClothingCategory(currentComponent.getParentID());
					for (Dict component : allComponents) {

						if (Utility.contains(strTempComponentIDs, Utility.toSafeString(component.getID()))) {
							strTempComponentIDs = Utility.replace(strTempComponentIDs, Utility.toSafeString(component.getID()));

						}
					}

					strTempComponentIDs += "," + nCurrentComponentID;

				}
			} else {
				if (Utility.contains(strTempComponentIDs, strCurrentParameterID)) {
					strTempComponentIDs = Utility.replace(strTempComponentIDs, strCurrentParameterID);
					// 上衣撞色-肘部贴布 取消 肘垫形式-圆型肘垫
					if ("305".equals(strCurrentParameterID) && Utility.contains(strTempComponentIDs, "1771")) {
						strTempComponentIDs = Utility.replace(strTempComponentIDs, "1771");
					}
				} else {
					strTempComponentIDs += "," + strCurrentParameterID;
					// 上衣撞色-肘部贴布 添加 肘垫形式-圆型肘垫
					if ("305".equals(strCurrentParameterID) && !Utility.contains(strTempComponentIDs, "1771")) {
						strTempComponentIDs += ",1771";
					}
				}
			}
		}

		strTempComponentIDs = removeDisabled(strTempComponentIDs, nCurrentComponentID);
		strTempComponentIDs = addDefault(strTempComponentIDs, nCurrentComponentID, currentComponent);

		return strTempComponentIDs;
	}

	/*
	 * private String addDefault(String strTempComponentIDs,int
	 * nCurrentComponentID, Dict currentComponent) { // 获得当前选中工艺的 同一大类的 所有工艺的
	 * 冲突代码 ，遍历每个冲突工艺，如果是默认值 就保存 List<Dict> siblings =
	 * DictManager.getDicts(CDictCategory.ClothingCategory.getID(),
	 * currentComponent.getParentID()); for(Dict sibling :siblings){
	 * if(Utility.toSafeInt(sibling.getID())!= nCurrentComponentID){
	 * if(StringUtils.isNotEmpty(sibling.getAffectedDisabled())){ String[]
	 * disables = Utility.getStrArray(sibling.getAffectedDisabled()); for(String
	 * disable:disables){ Dict d =
	 * DictManager.getDictByID(Utility.toSafeInt(disable)); if(d != null){
	 * if(CDict.YES.getID().equals(d.getIsDefault())){
	 * if(!Utility.contains(strTempComponentIDs,
	 * Utility.toSafeString(d.getID()))){ strTempComponentIDs += "," +
	 * d.getID(); } } } } } } } return strTempComponentIDs; }
	 */
	private String addDefault(String strTempComponentIDs, int nCurrentComponentID, Dict currentComponent) {
		// 获得当前选中代码的 冲突工艺，获得与每个冲突工艺同一大类的工艺，遍历所有工艺，如果是默认值 就保存
		if (StringUtils.isNotEmpty(currentComponent.getAffectedDisabled())) {
			String[] strDisabled = Utility.getStrArray(currentComponent.getAffectedDisabled());
			String[] strTempComponentID = Utility.getStrArray(strTempComponentIDs);
			String strParentIDs = "";
			for (String str : strTempComponentID) {
				Dict dict = DictManager.getDictByID(Utility.toSafeInt(str));
				Dict dictParent = DictManager.getDictByID(dict.getParentID());
				if (CDict.Component.getID().equals(dict.getStatusID()) || (CDict.Parameter.getID().equals(dict.getStatusID()) && CDict.YES.getID().equals(dictParent.getIsSingleCheck()))) {
					strParentIDs += dict.getParentID() + ",";
				}
			}
			for (String str : strDisabled) {
				Dict dict = DictManager.getDictByID(Utility.toSafeInt(str));
				List<Dict> dicts = DictManager.getDicts(1, dict.getParentID());
				for (Dict d : dicts) {// 不为冲突工艺、是默认工艺、不存在当前所选工艺中,不在同一大类下
					if (!Utility.contains(currentComponent.getAffectedDisabled(), Utility.toSafeString(d.getID())) && "10050".equals(Utility.toSafeString(d.getIsDefault()))) {
						if (!Utility.contains(strParentIDs, Utility.toSafeString(d.getParentID()))) {
							strTempComponentIDs += "," + d.getID();
						}

					}
				}
			}
		} else {// 珠边(1223,396,2517,2529,4642,4643,6608)-暂时解决方案
				// 大衣下口袋(6122,6124,6126,6125,6127)
			if (Utility.contains("1223,396,2517,2529,4642,4643,6608,6122,6124,6126,6125,6127", Utility.toSafeString(nCurrentComponentID))) {
				// 添加当前选中工艺同一大类下的其他工艺中被冲突掉的工艺
				List<Dict> siblings = DictManager.getDicts(CDictCategory.ClothingCategory.getID(), currentComponent.getParentID());
				for (Dict sibling : siblings) {
					if (Utility.toSafeInt(sibling.getID()) != nCurrentComponentID) {
						if (StringUtils.isNotEmpty(sibling.getAffectedDisabled())) {
							String[] disables = Utility.getStrArray(sibling.getAffectedDisabled());
							for (String disable : disables) {
								Dict d = DictManager.getDictByID(Utility.toSafeInt(disable));
								if (d != null) {
									if (CDict.YES.getID().equals(d.getIsDefault())) {
										if (!Utility.contains(strTempComponentIDs, Utility.toSafeString(d.getID()))) {
											strTempComponentIDs += "," + d.getID();
										}
									}
								}
							}
						}
					}
				}
			}
		}
		return strTempComponentIDs;
	}

	private String removeDisabled(String strTempComponentIDs, int nCurrentComponentID) {
		List<Dict> disableds = this.getAffectedDisableByMe(nCurrentComponentID);
		for (Dict disabled : disableds) {
			String strID = Utility.toSafeString(disabled.getID());
			if (Utility.contains(strTempComponentIDs, strID)) {
				strTempComponentIDs = Utility.replace(strTempComponentIDs, Utility.toSafeString(disabled.getID()));
				// break;
			}
		}
		return strTempComponentIDs;
	}

	public String saveTempComponentTexts(String strTempComponentTexts, String strNewKeyValue) {
		String strResult = "";

		boolean addedFlag = false;
		String[] newKeyValue = strNewKeyValue.split(":");
		String[] tempComponentTexts = Utility.getStrArray(strTempComponentTexts);
		for (String tempComponentText : tempComponentTexts) {
			String[] tempKeyValue = tempComponentText.split(":");
			if (tempKeyValue[0].equals(newKeyValue[0])) {
				strResult += strNewKeyValue + ",";
				addedFlag = true;
			} else {
				strResult += tempComponentText + ",";
			}
		}

		if (addedFlag == false) {
			strResult += strNewKeyValue;
		}

		if (strResult.endsWith(",")) {
			strResult = strResult.substring(0, strResult.length() - 1);
		}
		return strResult;
	}

	public List<Dict> NotShowOnFront(List<Dict> dicts) {
		List<Dict> validDicts = new ArrayList<Dict>();
		for (Dict dict : dicts) {
			if (!CDict.YES.getID().equals(dict.getNotShowOnFront())) {
				validDicts.add(dict);
			}
		}
		return validDicts;
	}

	public boolean isInterliningType(int nComponentID) {
		Dict dict = DictManager.getDictByID(nComponentID);
		if (dict != null) {
			if (

			dict.getParentID().equals(CDict.ArtCategory2.getID()) || dict.getParentID().equals(CDict.ArtCategory3.getID())) {
				return true;
			}
		}
		return false;
	}

	// 取服装
	public List<Dict> getClothingMenu(int nParentID) {
		List<Dict> list = new ArrayList<Dict>();
		if (nParentID == 0) {
			list = DictManager.getDicts(CDictCategory.ClothingCategory.getID(), 0);
		} else {
			Dict dictParent = DictManager.getDictByID(nParentID);
			if (dictParent.getParentID().equals(0) && dictParent.getCategoryID().equals(CDictCategory.ClothingCategory.getID())) {
				list = getClothingMenuByExtension(dictParent.getExtension());
			} else {
				List<Dict> allMenu = getClothingCategory(nParentID);
				for (int i = 0; i < allMenu.size(); i++) {
					if (isMenu(allMenu.get(i))) {
						// if
						// (CDict.FABRICLABEL.indexOf(Utility.toSafeString(allMenu.get(i).getID()))>=0)
						// {
						// String
						// fabricCode=Utility.toSafeString(HttpContext.getSessionValue(CDict.SessionKey_FabricCode));
						// Fabric fabric= new
						// FabricManager().getFabricByCode(fabricCode);
						// if
						// (fabric!=null&&fabric.getFabricSupplyCategoryID().equals(CDict.FabricSupplyCategoryRedCollar.getID()))
						// {
						// continue;
						// }
						// }
						list.add(allMenu.get(i));
					}
				}
			}
		}

		return CurrentInfo.getAuthorityFunction(list);
	}

	private boolean isMenu(Dict dict) {
		if (dict != null && (dict.getStatusID() == null || Utility.toSafeString(dict.getStatusID()).equals(""))) {
			return true;
		}

		return false;
	}

	private boolean isComponent(Dict dict) {
		if (dict != null && dict.getStatusID().equals(CDict.Component.getID())) {
			return true;
		}
		return false;
	}

	private boolean isParameter(Dict dict) {
		if (dict != null && dict.getStatusID().equals(CDict.Parameter.getID())) {
			return true;
		}
		return false;
	}

	// 取服装分类
	private List<Dict> getClothingMenuByExtension(String strExtension) {
		List<Dict> dicts = null;
		try {
			dicts = new ArrayList<Dict>();
			String[] parentIDs = strExtension.split(",");
			// 套装
			if (parentIDs.length > 1) {
				for (int i = 0; i < parentIDs.length; i++) {
					Dict dict = DictManager.getDictByID(Utility.toSafeInt(parentIDs[i]));
					if (dict != null) {
						dict.setName(dict.getName() + ResourceHelper.getValue("Orden_Style"));
						dicts.add(dict);
					}
				}
			} else {
				// 单件
				dicts = DictManager.getDicts(CDictCategory.ClothingCategory.getID(), Utility.toSafeInt(strExtension));
			}
		} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		}

		return dicts;
	}

	// 取组件
	public List<Dict> getClothingComponent(int nParentID) {
		List<Dict> list = new ArrayList<Dict>();
		List<Dict> allClothingCategory = getClothingCategory(nParentID);
		for (int i = 0; i < allClothingCategory.size(); i++) {
			if (isComponent(allClothingCategory.get(i))) {
				list.add(allClothingCategory.get(i));
			}
		}
		return CurrentInfo.getAuthorityFunction(list);
	}

	// 取组件
	public List<Dict> getClothingParameter(int nParentID) {
		List<Dict> list = new ArrayList<Dict>();
		List<Dict> allClothingCategory = getClothingCategory(nParentID);
		for (int i = 0; i < allClothingCategory.size(); i++) {
			if (isParameter(allClothingCategory.get(i))) {
				list.add(allClothingCategory.get(i));
			}
		}

		return CurrentInfo.getAuthorityFunction(list);
	}

	public List<Dict> getClothingCategory(int nParentID) {
		List<Dict> list = DictManager.getDicts(CDictCategory.ClothingCategory.getID(), nParentID);
		return CurrentInfo.getAuthorityFunction(list);
	}

	public Dict getSingleClothingByComponentID(int nComponentID) {
		Dict component = DictManager.getDictByID(nComponentID);
		if (component != null) {

			List<Dict> clothings = DictManager.getDicts(CDictCategory.ClothingCategory.getID(), 0);
			for (Dict clothing : clothings) {
				if (clothing.getCode().substring(0, 4).equals(component.getCode().substring(0, 4))) {
					return clothing;
				}
			}
		}

		return null;
	}

	public List<Dict> getSingleClothings(int nClothingID) {
		List<Dict> dicts = new ArrayList<Dict>();
		Dict dictClothing = DictManager.getDictByID(nClothingID);
		String[] arraySingleClothing = Utility.getStrArray(dictClothing.getExtension());
		for (String strSingleClothing : arraySingleClothing) {
			dicts.add(DictManager.getDictByID(Utility.toSafeInt(strSingleClothing)));
		}
		return dicts;
	}

	@SuppressWarnings("unused")
	public List<Dict> GetComponentByKeyword(String strKeyword, int nSingleClothingID, String strType) {
		List<Dict> list = DictManager.getDicts(CDictCategory.ClothingCategory.getID());
		Dict d = DictManager.getDictByID(nSingleClothingID);
		List<Dict> newList = new ArrayList<Dict>();
		int i = 0;
		for (Dict dict : list) {
			if (i == 10) {
				break;
			}
			if (!"".equals(dict.getEcode()) && dict.getEcode() != null && (dict.getIsShow() == null || dict.getIsShow() != 2)) {
				if (dict.getEcode().startsWith(strKeyword) && dict.getCode().startsWith(d.getCode())) {
					Dict dictParent = DictManager.getDictByID(dict.getParentID());
					Dict dictParentParent = DictManager.getDictByID(dictParent.getParentID());
					// 配件工艺要符合所属系列
					if (nSingleClothingID != 5000 || (nSingleClothingID == 5000 && !"".equals(strType) && strType.equals(Utility.toSafeString(dictParentParent.getSequenceNo()))) || (nSingleClothingID == 5000 && "".equals(strType))) {
						if (dictParentParent != null) {
							dict.setAllName(dictParentParent.getName() + " " + dictParent.getName() + ":" + dict.getName());
						} else if (dictParent != null) {
							dict.setAllName(dictParent.getName() + ":" + dict.getName());
						} else {
							dict.setAllName(dict.getName());
						}
						if (!Utility.contains(CDict.EMBROID, Utility.toSafeString(dictParentParent.getID())) && !Utility.contains(CDict.EMBROID, Utility.toSafeString(dict.getParentID()))) {
							// if (!Utility.contains(CDict.EMBROID,
							// Utility.toSafeString(dictParentParent.getParentID()))&&!Utility.contains(CDict.EMBROID,Utility.toSafeString(dict.getParentID())))
							// {
							newList.add(dict);
							i++;
						}
					}
				}
			}
		}
		return CurrentInfo.getAuthorityFunction(newList);
	}

	public List<Dict> GetEmbroids(int nSingleClothingID) {
		String strEmbroids = CDict.EMBROID;
		Dict singleClothingDict = DictManager.getDictByID(nSingleClothingID);
		String[] embroids = strEmbroids.split(",");
		Integer nID = 0;
		for (String embroidID : embroids) {
			Dict embroidDict = DictManager.getDictByID(Utility.toSafeInt(embroidID));
			if (embroidDict == null) {
				continue;
			}
			if (embroidDict.getCode().startsWith(singleClothingDict.getCode())) {
				nID = embroidDict.getID();
			}
		}
		List<Dict> list = DictManager.getDicts(CDictCategory.ClothingCategory.getID(), nID);
		return list;
	}

	/*public List<MapUtil> GetOrdenEmbroids(Orden orden, String[] clothArr, Integer clothingID) {
		List<MapUtil> cloths_embroids = new ArrayList<MapUtil>();
		List<Embroidery> embroideryLoactionList = new ArrayList<Embroidery>();

		Dict cloth;
		StringBuffer embroidHtml;
		StringBuffer loactionBuffer = null;
		StringBuffer colorBuffer = null;
		StringBuffer fontBuffer = null;
		StringBuffer contentBuffer = null;
		MapUtil cloths_embroids_map;

		// 迭代服装大类 上衣/西裤/马甲 ...
		for (int i = 0; i < clothArr.length; i++) {
			cloths_embroids_map = new MapUtil();
			embroidHtml = new StringBuffer();
			cloth = DictManager.getDictByID(Utility.toSafeInt(clothArr[i]));

			cloths_embroids_map.setKey_obj(cloth);
			// 订单中 此 服装大类 的 所有的刺绣信息记录
			embroideryLoactionList = getEmbroideryLoaction(orden, Utility.toSafeInt(clothArr[i]));

			embroidHtml.append("<table id=\"category_embroid_" + cloth.getID() + "\" class=\"list_result\"><tbody>");
			// 循环 大类服装 的刺绣条数
			for (int j = 0; j < embroideryLoactionList.size(); j++) {

				embroidHtml.append(" <tr index=" + j + " align=\"center\">");
				// 获得每个服装分类 下的 刺绣设计(位置/颜色/字体/内容 /大小)
				List<Dict> list = GetEmbroids(Utility.toSafeInt(clothArr[i]));
				for (int k = 0; k < list.size(); k++) {
					if (k == 0) {
						colorBuffer = new StringBuffer();
						colorBuffer.append("<td><span>" + list.get(k).getName() + ":</span>" + "<select id=\"category_label_" + cloth.getID() + "_Position_" + j + "\" style=\"width: 120px\">");
						// 颜色
						// 第二步 根据ID 获得下级所有dict(二件1 三件套2 上衣3 裤2000)
						Integer parentID = list.get(k).getID();
						// 工艺信息的 catecoreID 都 是 1
						List<Dict> eachCXList = DictManager.getDicts(1, parentID);

						// 第三步 循环拼接HTML
						for (int v = 0; v < eachCXList.size(); v++) {
							// 如果是 此服装 大类下的 此条刺绣记录 中的颜色值 与 此服装 下所有的刺绣颜色 中某一条 相等
							// 则设置 为 选 中
							if (embroideryLoactionList.get(j).getColor().getID() == eachCXList.get(v).getID()) {
								colorBuffer.append("<option title=\"" + eachCXList.get(v).getName() + "\" selected='selected' value=\"" + eachCXList.get(v).getID() + "\">" + eachCXList.get(v).getName() + "</option>");
							} else {
								colorBuffer.append("<option title=\"" + eachCXList.get(v).getName() + "\" value=\"" + eachCXList.get(v).getID() + "\">" + eachCXList.get(v).getName() + "</option>");
							}
						}
						colorBuffer.append("</select></td>");
					}
					if (k == 1) {
						fontBuffer = new StringBuffer();
						// 字体
						fontBuffer.append("<td><span>" + list.get(k).getName() + ":</span>" + "<select id=\"category_label_" + cloth.getID() + "_Position_" + j + "\" style=\"width: 120px\">");

						// 第二步 根据ID 获得下级所有dict
						Integer parentID = list.get(k).getID();
						// 工艺信息的 catecoreID 都 是 1
						List<Dict> eachCXList = DictManager.getDicts(1, parentID);
						// 第三步 循环拼接HTML
						for (int v = 0; v < eachCXList.size(); v++) {
							// 如果是 此服装 大类下的 此条刺绣记录 中的颜色值 与 此服装 下所有的刺绣颜色 中某一条 相等
							// 则设置 为 选 中
							if (embroideryLoactionList.get(j).getFont().getID() == eachCXList.get(v).getID()) {
								fontBuffer.append("<option title=\"" + eachCXList.get(v).getName() + "\" selected='selected' value=\"" + eachCXList.get(v).getID() + "\">" + eachCXList.get(v).getName() + "</option>");
							} else {
								fontBuffer.append("<option title=\"" + eachCXList.get(v).getName() + "\" value=\"" + eachCXList.get(v).getID() + "\">" + eachCXList.get(v).getName() + "</option>");
							}
						}
						fontBuffer.append("</select></td>");
					}
					if (k == 2) {
						// 内容
						contentBuffer = new StringBuffer();
						Integer parentID = list.get(k).getID();
						List<Dict> eachCXList = DictManager.getDicts(1, parentID);

						contentBuffer.append("<td><span>" + list.get(k).getName() + ":</span><input id=\"category_textbox_2207\" style=\"width:120px;background-color: #131313; border: 1px solid #626061; color: #EAE9E9;height: 20px;line-height: 20px;\" class=\"category_textbox_2000_Content_1\" type=\"text\" value=\"刺绣内容\">");

						contentBuffer.append("</td>");
					}
					if (k == 3) {
						loactionBuffer = new StringBuffer();
						// 位置
						loactionBuffer.append("<td><span>" + list.get(k).getName() + ":</span>" + "<select id=\"category_label_" + cloth.getID() + "_Position_" + j + "\" style=\"width: 120px\">");

						// 第二步 根据ID 获得下级所有dict
						Integer parentID = list.get(k).getID();
						// 工艺信息的 catecoreID 都 是 1
						List<Dict> eachCXList = DictManager.getDicts(1, parentID);
						// 第三步 循环拼接HTML
						for (int v = 0; v < eachCXList.size(); v++) {
							// 如果是 此服装 大类下的 此条刺绣记录 中的颜色值 与 此服装 下所有的刺绣颜色 中某一条 相等
							// 则设置 为 选 中
							if (embroideryLoactionList.get(j).getLocation().getID() == eachCXList.get(v).getID()) {
								loactionBuffer.append("<option title=\"" + eachCXList.get(v).getName() + "\" selected='selected' value=\"" + eachCXList.get(v).getID() + "\">" + eachCXList.get(v).getName() + "</option>");
							} else {
								loactionBuffer.append("<option title=\"" + eachCXList.get(v).getName() + "\" value=\"" + eachCXList.get(v).getID() + "\">" + eachCXList.get(v).getName() + "</option>");
							}
						}
						loactionBuffer.append("</select></td>");
					}
					if (CDict.ClothingChenYi.getID().equals(Utility.toSafeInt(clothArr[i]))) {
						// 如果是衬衣
						if (j == 3) {
							// 大小

							// 第二步 根据ID 获得下级所有dict
							Integer parentid = list.get(k).getID();

							// 第三步 循环拼接HTML
						}
						if (j == 4) {
							// 位置

							// 第二步 根据ID 获得下级所有dict
							Integer parentID = list.get(k).getID();

							// 第三步 循环拼接HTML
						}
					} else {
						if (j == 3) {
							// 位置

							// 第二步 根据ID 获得下级所有dict
							Integer parentID = list.get(k).getID();

							// 第三步 循环拼接HTML
						}
					}
				}

				embroidHtml.append(loactionBuffer).append(colorBuffer).append(fontBuffer).append(colorBuffer);
				embroidHtml.append("<td onclick='$(this).parent().remove()' style='width:30px'><a class='remove'></a></td>");
				embroidHtml.append("</tr>");
			}
			cloths_embroids_map.setValue_obj(embroidHtml.toString());
			cloths_embroids.add(cloths_embroids_map);
		}

		return cloths_embroids;

	}*/

	/**
	 * 根据订单获取 刺绣的HTML
	 * 
	 * @param orden
	 * @return
	 */
	public List<MapUtil> GetOrdenEmbroids(Orden orden) {
		List<MapUtil> cloths_embroids = new ArrayList<MapUtil>();
		List<Embroidery> ordenEmbroidery = new ArrayList<Embroidery>();
		List<OrdenDetail> ordenDetailList = orden.getOrdenDetails();
		Dict cloth;
		StringBuffer embroidHtml;
		StringBuffer loactionBuffer = null;
		StringBuffer colorBuffer = null;
		StringBuffer fontBuffer = null;
		StringBuffer contentBuffer = null;
		StringBuffer fontSizeBuffer = null;
		MapUtil cloths_embroids_map;

		Integer singleclothID;
		if (ordenDetailList == null) {
			ordenDetailList = new ArrayList<OrdenDetail>();
		}
		// 迭代服装大类 上衣/西裤/马甲 ...
		for (int i = 0; i < ordenDetailList.size(); i++) {
			cloths_embroids_map = new MapUtil();
			singleclothID = Utility.toSafeInt(ordenDetailList.get(i).getSingleClothingID());
			embroidHtml = new StringBuffer();
			cloth = DictManager.getDictByID(singleclothID);
			cloths_embroids_map.setKey_obj(cloth);

			ordenEmbroidery = ordenDetailList.get(i).getEmberoidery();
			embroidHtml.append("<table id=\"category_embroid_" + cloth.getID() + "\" class=\"list_result\"><tbody>");

			if (null != ordenEmbroidery && !ordenEmbroidery.isEmpty()) {
				cloths_embroids_map.setTemp_obj(ordenEmbroidery.size() - 1);
				// 循环 大类服装 的刺绣条数
				for (int j = 0; j < ordenEmbroidery.size(); j++) {
					if (null == ordenEmbroidery.get(j).getContentID()) {
						continue;
					}
					String displayStr = "";
					embroidHtml.append(" <tr index=" + j + " align=\"center\">");
					// 获得每个服装分类 下的 刺绣设计(位置/颜色/字体/内容 /大小)
					List<Dict> embroidsInfo = GetEmbroids(singleclothID);
					for (int k = 0; k < embroidsInfo.size(); k++) {
						if (k == 0) {
							colorBuffer = new StringBuffer();
							colorBuffer.append("<td><span>" + embroidsInfo.get(k).getName() + ":</span>" + "<select id=\"category_label_" + cloth.getID() + "_Color_" + j + "\" " + displayStr + " style=\"width: 120px\" >");
							// 颜色
							Integer parentID = embroidsInfo.get(k).getID();
							// 工艺信息的 catecoreID 都 是 1
							List<Dict> eachCXList = DictManager.getDicts(1, parentID);

							// 第三步 循环拼接HTML
							for (int v = 0; v < eachCXList.size(); v++) {
								// 如果是 此服装 大类下的 此条刺绣记录 中的颜色值 与 此服装 下所有的刺绣颜色 中某一条
								// 相等 则设置 为 选 中
								if (ordenEmbroidery.get(j).getColor() != null && ordenEmbroidery.get(j).getColor().getID() == eachCXList.get(v).getID()) {
									colorBuffer.append("<option title=\"" + eachCXList.get(v).getName() + "\" selected='selected' value=\"" + eachCXList.get(v).getID() + "\">" + eachCXList.get(v).getName() + "</option>");
								} else {
									colorBuffer.append("<option title=\"" + eachCXList.get(v).getName() + "\" value=\"" + eachCXList.get(v).getID() + "\">" + eachCXList.get(v).getName() + "</option>");
								}
							}
							embroidHtml.append("</select></td>");
						}
						if (k == 1) {
							fontBuffer = new StringBuffer();
							// 字体
							fontBuffer.append("<td><span>" + embroidsInfo.get(k).getName() + ":</span>" + "<select id=\"category_label_" + cloth.getID() + "_Font_" + j + "\" " + displayStr + " style=\"width: 120px\">");

							// 第二步 根据ID 获得下级所有dict
							Integer parentID = embroidsInfo.get(k).getID();
							// 工艺信息的 catecoreID 都 是 1
							List<Dict> eachCXList = DictManager.getDicts(1, parentID);
							// 第三步 循环拼接HTML
							for (int v = 0; v < eachCXList.size(); v++) {
								// 如果是 此服装 大类下的 此条刺绣记录 中的颜色值 与 此服装 下所有的刺绣颜色 中某一条
								// 相等 则设置 为 选 中
								if (ordenEmbroidery.get(j).getFont() != null && ordenEmbroidery.get(j).getFont().getID() == eachCXList.get(v).getID()) {
									fontBuffer.append("<option title=\"" + eachCXList.get(v).getName() + "\" selected='selected' value=\"" + eachCXList.get(v).getID() + "\">" + eachCXList.get(v).getName() + "</option>");
								} else {
									fontBuffer.append("<option title=\"" + eachCXList.get(v).getName() + "\" value=\"" + eachCXList.get(v).getID() + "\">" + eachCXList.get(v).getName() + "</option>");
								}
							}
							fontBuffer.append("</select></td>");
						}
						if (k == 2) {
							contentBuffer = new StringBuffer();
							// 内容
							contentBuffer.append("<td><span>" + embroidsInfo.get(k).getName() + ":</span><input id=\"category_textbox_" + embroidsInfo.get(k).getID() + "\" style=\"width:120px;background-color: #FFF; border: 1px solid #626061; color: #000;height: 20px;line-height: 20px;\" class=\"category_textbox_" + singleclothID + "_Content_" + j + "\" type=\"text\" value=\"" + ordenEmbroidery.get(j).getContent() + "\">");

							contentBuffer.append("</td>");
						}
						if (CDict.ClothingChenYi.getID().equals(singleclothID)) {
							// 如果是衬衣
							if (k == 3) {
								// 大小
								fontSizeBuffer = new StringBuffer();
								fontSizeBuffer.append("<td><span>" + embroidsInfo.get(k).getName() + ":</span>" + "<select id=\"category_label_" + cloth.getID() + "_Size_" + j + "\" " + displayStr + " style=\"width: 120px\">");
								// 第二步 根据ID 获得下级所有dict
								Integer parentID = embroidsInfo.get(k).getID();
								// 工艺信息的 catecoreID 都 是 1
								List<Dict> eachCXList = DictManager.getDicts(1, parentID);
								// 第三步 循环拼接HTML
								for (int v = 0; v < eachCXList.size(); v++) {
									// 如果是 此服装 大类下的 此条刺绣记录 中的颜色值 与 此服装 下所有的刺绣颜色
									// 中某一条 相等 则设置 为 选 中
									if (ordenEmbroidery.get(j).getSize() == null) {
										ordenEmbroidery.get(j).setSize(DictManager.getDictByID(3261));// 7mm
									}
									if (ordenEmbroidery.get(j).getSize().getID() == eachCXList.get(v).getID()) {
										fontSizeBuffer.append("<option title=\"" + eachCXList.get(v).getName() + "\" selected='selected' value=\"" + eachCXList.get(v).getID() + "\">" + eachCXList.get(v).getName() + "</option>");
									} else {
										fontSizeBuffer.append("<option title=\"" + eachCXList.get(v).getName() + "\" value=\"" + eachCXList.get(v).getID() + "\">" + eachCXList.get(v).getName() + "</option>");
									}
								}
								fontSizeBuffer.append("</select></td>");
								// 第三步 循环拼接HTML
							}
							if (k == 4) {
								loactionBuffer = new StringBuffer();
								// 位置
								loactionBuffer.append("<td><span>" + embroidsInfo.get(k).getName() + ":</span>" + "<select id=\"category_label_" + cloth.getID() + "_Position_" + j + "\" style=\"width: 120px\">");

								// 第二步 根据ID 获得下级所有dict
								Integer parentID = embroidsInfo.get(k).getID();
								// 工艺信息的 catecoreID 都 是 1
								List<Dict> eachCXList = DictManager.getDicts(1, parentID);
								// 第三步 循环拼接HTML
								for (int v = 0; v < eachCXList.size(); v++) {
									// 如果是 此服装 大类下的 此条刺绣记录 中的颜色值 与 此服装 下所有的刺绣颜色
									// 中某一条 相等 则设置 为 选 中
									if (ordenEmbroidery.get(j).getLocation() != null && ordenEmbroidery.get(j).getLocation().getID() == eachCXList.get(v).getID()) {
										loactionBuffer.append("<option title=\"" + eachCXList.get(v).getName() + "\" memo=\" "+eachCXList.get(v).getMemo()+"\" selected='selected' value=\"" + eachCXList.get(v).getID() + "\">" + eachCXList.get(v).getName() + "</option>");
									} else {
										loactionBuffer.append("<option title=\"" + eachCXList.get(v).getName() + "\" memo=\" "+eachCXList.get(v).getMemo()+"\" value=\"" + eachCXList.get(v).getID() + "\">" + eachCXList.get(v).getName() + "</option>");
									}
								}
								loactionBuffer.append("</select></td>");
							}
						} else {
							if (k == 3) {
								loactionBuffer = new StringBuffer();
								// 位置
								loactionBuffer.append("<td><span>" + embroidsInfo.get(k).getName() + ":</span>" + "<select id=\"category_label_" + cloth.getID() + "_Position_" + j + "\" style=\"width: 120px\" onchange=$.csOrdenPost.changePosition('" + singleclothID + "','" + j + "')>");

								// 第二步 根据ID 获得下级所有dict
								Integer parentID = embroidsInfo.get(k).getID();
								// 工艺信息的 catecoreID 都 是 1
								List<Dict> eachCXList = DictManager.getDicts(1, parentID);
								// 第三步 循环拼接HTML
								for (int v = 0; v < eachCXList.size(); v++) {
									// 如果是 此服装 大类下的 此条刺绣记录 中的颜色值 与 此服装 下所有的刺绣颜色
									// 中某一条 相等 则设置 为 选 中
									if (ordenEmbroidery.get(j).getLocation() != null && ordenEmbroidery.get(j).getLocation().getID() == eachCXList.get(v).getID()) {
										loactionBuffer.append("<option title=\"" + eachCXList.get(v).getName() + "\" memo=\" "+eachCXList.get(v).getMemo()+"\" selected='selected' value=\"" + eachCXList.get(v).getID() + "\">" + eachCXList.get(v).getName() + "</option>");
									} else {
										loactionBuffer.append("<option title=\"" + eachCXList.get(v).getName() + "\" memo=\" "+eachCXList.get(v).getMemo()+"\" value=\"" + eachCXList.get(v).getID() + "\">" + eachCXList.get(v).getName() + "</option>");
									}
								}
								loactionBuffer.append("</select></td>");
							}
							if (k == 4 && CDict.ClothingPeiJian.getID().equals(singleclothID)) {
								// 大小
								fontSizeBuffer = new StringBuffer();
								fontSizeBuffer.append("<td><span>" + embroidsInfo.get(k).getName() + ":</span>" + "<select id=\"category_label_" + cloth.getID() + "_Size_" + j + "\" " + displayStr + " style=\"width: 120px\">");
								// 第二步 根据ID 获得下级所有dict
								Integer parentID = embroidsInfo.get(k).getID();
								// 工艺信息的 catecoreID 都 是 1
								List<Dict> eachCXList = DictManager.getDicts(1, parentID);
								// 第四步 循环拼接HTML
								for (int v = 0; v < eachCXList.size(); v++) {
									// 如果是 此服装 大类下的 此条刺绣记录 中的颜色值 与 此服装 下所有的刺绣颜色
									// 中某一条 相等 则设置 为 选 中
									if (ordenEmbroidery.get(j).getSize() == null) {
										ordenEmbroidery.get(j).setSize(DictManager.getDictByID(80978));// 7mm
									}
									if (Utility.toSafeString(ordenEmbroidery.get(j).getSize().getID()).equals(Utility.toSafeString(eachCXList.get(v).getID()))) {
										fontSizeBuffer.append("<option title=\"" + eachCXList.get(v).getName() + "\" selected='selected' value=\"" + eachCXList.get(v).getID() + "\">" + eachCXList.get(v).getName() + "</option>");
									} else {
										fontSizeBuffer.append("<option title=\"" + eachCXList.get(v).getName() + "\" value=\"" + eachCXList.get(v).getID() + "\">" + eachCXList.get(v).getName() + "</option>");
									}
								}
								fontSizeBuffer.append("</select></td>");
								// 第四步 循环拼接HTML
							}
						}
					}
					embroidHtml.append(loactionBuffer == null ? "" : loactionBuffer).append(colorBuffer == null ? "" : colorBuffer).append(fontBuffer == null ? "" : fontBuffer).append(contentBuffer == null ? "" : contentBuffer).append(fontSizeBuffer == null ? "" : fontSizeBuffer);
					embroidHtml.append("<td onclick='$(this).parent().remove()' style='width:30px'><a class='remove'></a></td>");
					embroidHtml.append("</tr>");
				}
			}
			embroidHtml.append("</tbody></table>");
			cloths_embroids_map.setValue_obj(embroidHtml.toString());
			cloths_embroids.add(cloths_embroids_map);
		}

		return cloths_embroids;

	}

	public String getPosition(Integer nContentID, String strTempComponentIDs) {
		String strPosition = "110,60";
		try {
			Dict content = DictManager.getDictByID(nContentID);
			if (content != null) {
				Dict cixiu = DictManager.getDictByID(content.getParentID());
				if (cixiu != null) {
					List<Dict> dicts = DictManager.getDicts(CDictCategory.ClothingCategory.getID(), cixiu.getID());
					if (dicts.size() > 0) {
						List<Dict> allParts = DictManager.getDicts(CDictCategory.ClothingCategory.getID(), dicts.get(dicts.size() - 1).getID());
						for (Dict part : allParts) {
							if (Utility.contains(strTempComponentIDs, Utility.toSafeString(part.getID()))) {
								strPosition = part.getPosition();
							}
						}
					}
				}
			}

		} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		}
		return strPosition;
	}

	// 获得所有刺绣
	/*
	 * public Embroidery getEmbroideryLoaction(Orden orden,int
	 * nSingleClothingID){ List<Dict> singleComponents = new
	 * OrdenManager().getSingleDesignedComponents
	 * (orden.getComponents(),nSingleClothingID); List<Dict>
	 * embroideryProcess=new ArrayList<Dict>(); for(Dict
	 * component:singleComponents){ if( !"".equals(component.getEcode())){ Dict
	 * dictParent = DictManager.getDictByID(component.getParentID());
	 * if(dictParent==null){ continue; } Dict
	 * dictParentParent=DictManager.getDictByID(dictParent.getParentID()); if
	 * (Utility.contains(CDict.EMBROID,
	 * Utility.toSafeString(dictParentParent.getID()))) {
	 * embroideryProcess.add(component); } } }
	 * 
	 * Embroidery emb=null; List<Dict> dicts=new
	 * ClothingManager().GetEmbroids(nSingleClothingID); if(dicts.size()>0){
	 * emb=new Embroidery(); } for(int i=0;i<dicts.size();i++){ for (Dict
	 * embroideryProces : embroideryProcess) {
	 * if(dicts.get(i).getID().equals(embroideryProces.getParentID())&&i==0){
	 * emb.setColor(embroideryProces); }
	 * if(dicts.get(i).getID().equals(embroideryProces.getParentID())&&i==1){
	 * emb.setFont(embroideryProces); } if(i==2){
	 * if(orden.getComponentTexts()!=null){ String[]
	 * texts=Utility.getStrArray(orden.getComponentTexts()); for (String text :
	 * texts) { String[] idvalue=text.split(":"); if
	 * (idvalue.length>1&&idvalue[0
	 * ].equals(Utility.toSafeString(dicts.get(i).getID()))){
	 * emb.setContent(idvalue[1]);
	 * emb.setContentID(Utility.toSafeInt(idvalue[0])); } } } }
	 * if(nSingleClothingID==CDict.ClothingChenYi.getID()){
	 * if(dicts.get(i).getID().equals(embroideryProces.getParentID())&&i==4){
	 * emb.setLocation(embroideryProces); }
	 * if(dicts.get(i).getID().equals(embroideryProces.getParentID())&&i==3){
	 * emb.setSize(embroideryProces); } }else{
	 * if(dicts.get(i).getID().equals(embroideryProces.getParentID())&&i==3){
	 * emb.setLocation(embroideryProces); } }
	 * 
	 * } } return emb; }
	 */
	/**
	 * 获取订单 明细 中的刺绣信息
	 * 
	 * @param orden
	 * @param nSingleClothingID
	 * @author MHD
	 * @return
	 */
	public List<Embroidery> getEmbroidery(Orden orden, int nSingleClothingID) {
		List<Embroidery> embs = new ArrayList<Embroidery>();
		String ordenProcess = orden.getComponents();

		String componentTexts = orden.getComponentTexts();
		String[] texts = {};
		if (componentTexts != null && componentTexts.startsWith(",")) {
			componentTexts = componentTexts.substring(1, componentTexts.length());
			texts = componentTexts.split(",");
		}

		if (ordenProcess == null || ordenProcess.length() <= 0 || ordenProcess.indexOf("_") <= 0) {
			return embs;
		}
		String[] procArr = ordenProcess.split(",");

		List<Dict> singleAllComponents = new ClothingManager().getAllNormalComponents(nSingleClothingID);
		DictManager dictManager = new DictManager();
		Dict position = null;
		Dict color = null;
		Dict font = null;
		Dict size = null;
		String[] embArr = null;
		Embroidery embroidery = null;
		int textCount = 0;
		for (String proccess : procArr) {
			boolean clothFlag = false;
			if (null != proccess && proccess.length() > 0 && proccess.indexOf("_") > 0) {
				embroidery = new Embroidery();
				embArr = proccess.split("_");

				position = dictManager.getDictByID(Utility.toSafeInt(embArr[0]));
				// 验证当前刺绣工艺是否是 该服装类下的工艺 如否.重来
				for (Dict component : singleAllComponents) {
					if (position != null && position.getID() != null && Utility.toSafeString(position.getID()).equals(Utility.toSafeString(component.getID()))) {
						clothFlag = true;
						break;
					}
				}
				if (!clothFlag) {
					continue;
				}

				color = dictManager.getDictByID(Utility.toSafeInt(embArr[1]));
				font = dictManager.getDictByID(Utility.toSafeInt(embArr[2]));
				embroidery.setColor(color);
				embroidery.setFont(font);
				embroidery.setLocation(position);
				
				if (nSingleClothingID == CDict.ClothingChenYi.getID() || nSingleClothingID == CDict.ClothingPeiJian.getID()) {
					size = dictManager.getDictByID(Utility.toSafeInt(embArr[3]));
					embroidery.setSize(size);
				}
				Dict cat = null;
				try{
					cat = dictManager.getDictByID(position == null ?null:Utility.toSafeInt(position.getParentID()));
					for (String text : texts) {
						String[] idvalue = text.split(":");
						Dict content = dictManager.getDictByID(Utility.toSafeInt(idvalue[0].trim()));
						if (content != null && Utility.toSafeString(content.getParentID()).equals(Utility.toSafeString(cat.getParentID()))) {
							embroidery.setContentID(Utility.toSafeInt(idvalue[0]));
							embroidery.setContent(idvalue[1].split("_")[textCount]);
						}
					}
				}catch(Exception e){
					System.out.println("刺绣位置没有查到");
				}
				
				embs.add(embroidery);
				textCount++;
			}
		}
		return embs;
	}

	public List<Embroidery> getEmbroideryLoaction(Orden orden, int nSingleClothingID) {
		List<Dict> singleComponents = new OrdenManager().getSingleDesignedComponents(orden.getComponents(), nSingleClothingID);
		List<Dict> embroideryProcess = new ArrayList<Dict>();
		for (Dict component : singleComponents) {
			if (!"".equals(component.getEcode())) {
				Dict dictParent = DictManager.getDictByID(component.getParentID());
				if (dictParent == null) {
					continue;
				}
				Dict dictParentParent = DictManager.getDictByID(dictParent.getParentID());
				if (Utility.contains(CDict.EMBROID, Utility.toSafeString(dictParentParent.getID()))) {
					embroideryProcess.add(component);
				}
			}
		}

		Embroidery emb = null;
		List<Dict> dicts = new ClothingManager().GetEmbroids(nSingleClothingID);
		if (dicts.size() > 0) {
			emb = new Embroidery();
		}
		List<Embroidery> embs = new ArrayList<Embroidery>();
		int num = 0;
		int pnum = 0;
		for (int i = 0; i < dicts.size(); i++) {
			for (Dict embroidery : embroideryProcess) {
				if (nSingleClothingID == CDict.ClothingChenYi.getID()) {
					if (dicts.get(i).getID().equals(embroidery.getParentID()) && i == 4) {
						num++;
					}
				} else {
					if (dicts.get(i).getID().equals(embroidery.getParentID()) && i == 3) {
						num++;
					}
				}
			}
		}
		for (int i = 0; i < dicts.size(); i++) {
			for (Dict embroideryProces : embroideryProcess) {
				if (dicts.get(i).getID().equals(embroideryProces.getParentID()) && i == 0) {
					emb.setColor(embroideryProces);
				}
				if (dicts.get(i).getID().equals(embroideryProces.getParentID()) && i == 1) {
					emb.setFont(embroideryProces);
				}
				if (i == 2) {
					if (orden.getComponentTexts() != null) {
						String[] texts = Utility.getStrArray(orden.getComponentTexts());
						for (String text : texts) {
							String[] idvalue = text.split(":");
							if (idvalue.length > 1 && idvalue[0].equals(Utility.toSafeString(dicts.get(i).getID()))) {
								emb.setContent(idvalue[1]);
								emb.setContentID(Utility.toSafeInt(idvalue[0]));
							}
						}
					}
				}
				if (nSingleClothingID == CDict.ClothingChenYi.getID()) {
					if (dicts.get(i).getID().equals(embroideryProces.getParentID()) && i == 4) {
						pnum++;
						if (num > 1 && pnum > 1) {
							Embroidery emb0 = new Embroidery();
							emb0.setLocation(embroideryProces);
							embs.add(emb0);
						} else {
							emb.setLocation(embroideryProces);
							embs.add(emb);
						}
					}
					if (dicts.get(i).getID().equals(embroideryProces.getParentID()) && i == 3) {
						emb.setSize(embroideryProces);
					}
				} else {
					if (dicts.get(i).getID().equals(embroideryProces.getParentID()) && i == 3) {
						pnum++;
						if (num > 1 && pnum > 1) {
							Embroidery emb0 = new Embroidery();
							emb0.setLocation(embroideryProces);
							embs.add(emb0);
						} else {
							emb.setLocation(embroideryProces);
							embs.add(emb);
						}
					}
				}

			}
		}
		if (embs.size() > 0) {
			String content = embs.get(0).getContent();
			for (int i = 0; i < embs.size(); i++) {
				embs.get(i).setContentID(embs.get(0).getContentID());
				embs.get(i).setColor(embs.get(0).getColor());
				embs.get(i).setFont(embs.get(0).getFont());
				embs.get(i).setSize(embs.get(0).getSize());
				if (content != null && content.length() > 0) {
					if (content.split("_").length <= 1 && i > 0) {
						embs.get(i).setContent("");
					} else {
						embs.get(i).setContent(content.split("_")[i]);
					}
				} else {
					embs.get(i).setContent("");
				}
			}
		} else {
			embs.add(emb);
		}

		return embs;
	}

	// 获得所有工艺
	public List<Dict> getOrderProcess(Orden orden, int nSingleClothingID) {
		List<Dict> singleComponents = new OrdenManager().getSingleDesignedComponents(orden.getComponents(), nSingleClothingID);
		String[] texts = Utility.getStrArray(Utility.toSafeString(orden.getComponentTexts()));
		List<Dict> ordersProcess = new ArrayList<Dict>();
		for (Dict component : singleComponents) {
			if (component.getEcode() != null && !"".equals(component.getEcode())) {
				Dict dictParent = DictManager.getDictByID(component.getParentID());
				if (dictParent == null) {
					continue;
				}
				Dict dictParentParent = DictManager.getDictByID(dictParent.getParentID());
				if (!Utility.contains(CDict.EMBROID, Utility.toSafeString(dictParentParent.getID())) && !Utility.contains(CDict.EMBROID, Utility.toSafeString(component.getParentID()))) {
					if (!ordersProcess.contains(dictParentParent)) {
						for (String text : texts) {
							String[] idvalue = text.split(":");
							if (idvalue.length > 1 && idvalue[0].equals(Utility.toSafeString(component.getID()))) {
								component.setMemo(idvalue[1]);
							}
						}
						ordersProcess.add(component);
					}
				}
			}
		}
		// 配件系列放在第一个
		if (nSingleClothingID == 5000) {
			List<Dict> process = new ArrayList<Dict>();
			for (Dict dict : ordersProcess) {
				if ("5023".equals(Utility.toSafeString(dict.getParentID()))) {
					process.add(dict);
					break;
				}
			}
			for (Dict dict : ordersProcess) {
				if (!"5023".equals(Utility.toSafeString(dict.getParentID()))) {
					process.add(dict);
				}
			}
			return process;
		}
		return ordersProcess;
	}

	// 获取订单工艺的HTML
	public String getOrderProcessHtml(String strOrdenID, int nSingleClothingID) {
		Orden orden = (Orden) dao.getEntityByID(Orden.class, strOrdenID);
		List<Dict> Process = this.getOrderProcess(orden, nSingleClothingID);
		int i = 1;
		StringBuffer sbfRow = new StringBuffer();

		for (Dict dict : Process) {
			Dict parentDict = DictManager.getDictByID(dict.getParentID());
			List<Dict> lowerLevelDatas = DictManager.getDicts(dict.getCategoryID(), parentDict.getID());
			Dict pDict = DictManager.getDictByID(parentDict.getParentID());

			sbfRow.append("<tr index='").append(i).append("'><td><input type='text'  disabled='disabled' id='component_").append(nSingleClothingID).append("_").append(dict.getID()).append("'  value='");
			if (lowerLevelDatas.size() > 0 && parentDict.getEcode() != null) {
				sbfRow.append(parentDict.getEcode()).append("' style='width:80px' class='textbox'/> ");
				int temp = i + 1;
				sbfRow.append(parentDict.getName()).append("<input type='text' id='component_textbox_").append(dict.getID()).append("' style='width:80px' value='").append(dict.getEcode()).append("' class='textbox'/>").append(dict.getName()).append("<input type='hidden' id='temp_").append(temp).append("' value='").append(temp).append("'/>");

			} else {
				sbfRow.append(dict.getEcode()).append("' style='width:80px' class='textbox'/> ");
				if ((lowerLevelDatas.size() > 0 && dict.getStatusID() != null && dict.getStatusID() == 10008) || (lowerLevelDatas.size() > 0 && dict.getStatusID() == null)) {
					String strMemo = "";
					if (dict.getMemo() != null) {// 去掉文本框中的null
						strMemo = dict.getMemo();
					}
					sbfRow.append(pDict.getName()).append(":").append(dict.getName()).append("<input type='text' id='category_textbox_").append(dict.getID()).append("' value='").append(strMemo).append("' style='width:80px' class='textbox'/>");
				} else {
					sbfRow.append(parentDict.getName()).append(":").append(dict.getName());

				}
			}
			sbfRow.append("</td> <td onclick='$(this).parent().remove()' style='width:30px'><a class='remove'></a></td></tr>");
			i++;
		}
		sbfRow.append("<tr index='"+i+"'>");
		sbfRow.append("<td><input type='text' id='text_"+nSingleClothingID+"_"+i+"' style='width:80px' class='textbox'/><span/></td>");
		sbfRow.append("</tr>");
		return sbfRow.toString();
	}

	private SizeManager	sizeManager	= new SizeManager();

	/** 获取尺寸分类初始HTML */
	public String getOrdenSize_categoryHtml(Orden orden) {
		Integer clothID;
		Integer size_categoryID;

		if (null != orden) {
			clothID = orden.getClothingID();
			size_categoryID = orden.getSizeCategoryID();
		} else {
			// 默认是二件套的
			clothID = 1;
			size_categoryID = 10052;
		}
		StringBuffer size_categoryBuffer = new StringBuffer();
		// size_categoryBuffer.append("<ul><li class='size_category'><label><s:text name='Size_Category'/></label></li>");
		List<Dict> sizeCategoryList = sizeManager.getSizeCategory(Utility.toSafeInt(clothID));
		String checked = "";
		for (Dict tempSize : sizeCategoryList) {
			if (size_categoryID == tempSize.getID() || size_categoryID.equals(tempSize.getID())) {
				checked = "checked";
			} else {
				checked = "";
			}
			size_categoryBuffer.append("<li class='size_category'><label><input type='radio' value='" + tempSize.getID() + "' name='size_category' " + checked + " onclick='$.csSize.generateArea()'/>" + tempSize.getName() + "</label></li>");
		}
		// size_categoryBuffer.append("</ul>");
		return size_categoryBuffer.toString();
	}

	/** 获取 尺寸单位 初始 HTML 厘米英寸 */
	public String getOrdenSize_unitHtml(Orden orden) {
		StringBuffer size_unitBuffer = new StringBuffer();
		size_unitBuffer.append("");
		Integer categoryid = 30;
		List<Dict> size_unitList = DictManager.getDicts(categoryid);
		// getSizeUnit();
		String checked;

		for (Dict tempUit : size_unitList) {
			checked = "";
			if (null == orden) {
				HttpServletRequest request = ServletActionContext.getRequest();
				String path = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath();
				// 测试本地英寸
				// if(path.indexOf("127.0.0.1")>0 ||
				// path.indexOf("localhost")>0){
				// if(("10265".equals(tempUit.getID().toString()) || 10265 ==
				// tempUit.getID())){
				// checked = "checked = 'checked'";
				// }
				// }
				// 美州区默认英寸
				if (path.indexOf("us.rcmtm.com") > 0 || path.indexOf("172.17.4.5") > 0) {
					if ("10265".equals(tempUit.getID().toString()) || 10265 == tempUit.getID()) {
						checked = "checked = 'checked'";
					}
				} else if (("10266".equals(tempUit.getID().toString()) || 10266 == tempUit.getID())) {
					// 默认选 中厘米
					checked = "checked = 'checked'";
				}
			} else if (tempUit.getID() == orden.getSizeUnitID()) {
				checked = "checked = 'checked'";
			} else {
				checked = "";
			}
			size_unitBuffer.append("<label style='display:inline;clear:none;'><input  type='radio'  " + checked + "  name='sizeUnitID' value='" + tempUit.getID() + "' onClick='$.csSize.changeSizeUnit()' />" + tempUit.getName() + "</label>");
		}
		return size_unitBuffer.toString();
	}

	private List<Dict> getSizeUnit() {
		List<Dict> dictList = new ArrayList<Dict>();
		String hql = "From Dict t where t.CategoryID = 30";
		try {
			Query query = DataAccessObject.openSession().createQuery(hql);
			dictList = query.list();
		} catch (HibernateException e) {
			dictList.clear();
			System.out.println("快速下单 单位查询出错");
		}
		return dictList;
	}

	/** 尺码 : 英美码..欧码.. */
	public String getOrdenSize_areaHtml(Orden orden) {
		StringBuffer areaBuffer = new StringBuffer();
		if ((null == orden || null == orden.getOrdenID() || "".equals(orden.getOrdenID())) && (null == orden.getClothingID() || "".equals(orden.getClothingID()))) {
			return "";
		} else if (orden.getSizeCategoryID() != 10054) {
			return "";
		} else {
			areaBuffer.append("");
			// 只有标准号加 有尺码
			Integer nSizeCategoryID = orden.getSizeCategoryID();
			Integer clothID = orden.getClothingID();

			List<Dict> areaList = sizeManager.getArea(clothID, nSizeCategoryID);
			// 测试阶段--成功后删除 去掉客户指定号型 ; sizejsp.js --> areas.length-1
			/*if (areaList.size() == 5 && !"TESTAA".equals(CurrentInfo.getCurrentMember().getUsername())) {
				areaList.remove(4);
			}*/

			areaBuffer.append("<ul><li>" + ResourceHelper.getValue("Size_Code") + "：</li>");
			String checked = "";
			for (Dict tempArea : areaList) {
				
				/*因现在客户号型测试不通，所以选不显示在页面客户号   ><!客户号型^^  ><!客户号型^^><!客户号型^^><!客户号型^^><!客户号型^^><!客户号型^^><!客户号型^^><!客户号型^^><!客户号型^^><!客户号型^^><!客户号型^^
				 * ><!客户号型^^><!客户号型^^><!客户号型^^><!客户号型^^><!客户号型^^><!客户号型^^><!客户号型^^><!客户号型^^><!客户号型^^><!客户号型^^><!客户号型^^><!客户号型^^><!客户号型^^><!客户号型^^
				 * ><!客户号型^^><!客户号型^^><!客户号型^^><!客户号型^^><!客户号型^^><!客户号型^^><!客户号型^^><!客户号型^^><!客户号型^^><!客户号型^^><!客户号型^^><!客户号型^^><!客户号型^^  */
				if(null!=tempArea.getID() && "10204".equals(tempArea.getID().toString())
						&& !"MTO".equals(CurrentInfo.getCurrentMember().getUsername()) && !"MOSSMTO".equals(CurrentInfo.getCurrentMember().getUsername())
						&& (clothID ==1 || clothID == 2 || clothID == 4 || clothID == 3 || clothID == 2000 || clothID == 4000 || clothID == 6) ){
					continue;
				}
				if (null != orden.getSizeAreaID() && !"".equals(orden.getSizeAreaID())) {
					if (tempArea.getID().toString().equals(orden.getSizeAreaID().toString()) || tempArea.getID() == orden.getSizeAreaID()) {
						checked = "checked = 'checked'";
					} else {
						checked = "";
					}
				}

				areaBuffer.append("<li><label><input type='radio' " + checked + " value='" + tempArea.getID() + "' name='area' onclick='$.csSize.generateSpec()'/>" + tempArea.getName() + "</label></li>");

			}
			areaBuffer.append("</ul>");
		}
		return areaBuffer.toString();
	}

	/** 正常 长短款 */
	public String getOrdenStyle_titleHtml(Orden orden) {
		StringBuffer titleBuffer = new StringBuffer();
		List<Dict> titleList = DictManager.getDicts(41);
		Integer title;
		if (null == orden) {
			title = 20100;
		} else {
			title = orden.getStyleID();
		}
		if (null != orden && ("2000".equals(orden.getClothingID().toString()) || "3000".equals(orden.getClothingID().toString()) || "4000".equals(orden.getClothingID().toString()) || "5000".equals(orden.getClothingID().toString()) || "98000".equals(orden.getClothingID().toString()))) {
			titleList.clear();
		}
		String checked;
		for (Dict dict : titleList) {
			checked = "";
			if (dict.getID() == title || dict.getID().toString().equals(title.toString())) {
				checked = "checked = 'true'";
			} else {
				checked = "";
			}
			if (orden != null && "6000".equals(Utility.toSafeString(orden.getClothingID())) && !"20102".equals(Utility.toSafeString(dict.getID()))) {
				titleBuffer.append("<label style='display:inline;clear:none;'><input type='radio' " + checked + " name='styleID' value='" + dict.getID() + "'>" + dict.getName() + "</label>");
			} else if (orden != null && !"6000".equals(Utility.toSafeString(orden.getClothingID()))) {
				titleBuffer.append("<label style='display:inline;clear:none;'><input type='radio' " + checked + " name='styleID' value='" + dict.getID() + "'>" + dict.getName() + "</label>");
			} else if (orden == null) {
				titleBuffer.append("<label style='display:inline;clear:none;'><input type='radio' " + checked + " name='styleID' value='" + dict.getID() + "'>" + dict.getName() + "</label>");
			}
		}
		if (orden != null && "6000".equals(Utility.toSafeString(orden.getClothingID())) && "10052".equals(Utility.toSafeString(orden.getSizeCategoryID()))) {
			String arr[] = { "0A02", "0A01" };
			String checkedDY = "";
			String styDY = "";
			for (int i = 0; i < arr.length; i++) {
				if (arr[i].equals(orden.getStyleDY())) {
					checkedDY = " checked='true' ";
				} else {
					checkedDY = "";
				}
				styDY += "<input type='radio' name='styleDY' value='" + arr[i] + "' " + checkedDY + "/>" + ResourceHelper.getValue("DY_" + arr[i]);
			}
			titleBuffer.append(styDY);
		}
		return titleBuffer.toString();
	}

	public String showImg(Orden orden) {
		StringBuffer impBuffer = new StringBuffer();

		HttpServletRequest request = ServletActionContext.getRequest();
		// System.out.println(request.getScheme() + "://"
		// + request.getServerName() + ":" + request.getServerPort()
		// + request.getContextPath());
		// String path =
		// ServletActionContext.getServletContext().getRealPath("/");
		String path = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath();

		int currentVersion = CVersion.getCurrentVersionID();
		path = path + "/size/" + currentVersion + "/";

		Integer width = 240;
		Integer height = 180;

		Integer nSingleClothingID = null == orden ? 3 : orden.getClothingID();
		Integer nSizeCategoryID = null == orden ? 10052 : orden.getSizeCategoryID();
		if (10052 != nSizeCategoryID) {
			return "";
		}
		Integer nAreaID = -1;
		String strSpecHeight = "undefined";
		String strSpecChest = "undefined";
		Integer nUnitID = null == orden ? -1 : Utility.toSafeInt(orden.getSizeUnitID());
		List<SizeStandard> sizeStandards = new SizeManager().getSizeStandard(nSingleClothingID, nSizeCategoryID, nAreaID, strSpecHeight, strSpecChest, nUnitID);
		// sizeStandards.get(0).getPartID();
		String file = path + sizeStandards.get(0).getPartID() + ".png";

		impBuffer.append("<img style='margin-top:4px;width:" + width + "px;height:" + height + "px;' src='" + file + "'/>");

		return impBuffer.toString();
	}

	/**
	 * 获取面料库存显示信息
	 * 
	 * @param orden
	 * @return
	 */
	public String getFabric_resultHtml(Orden orden) {
		StringBuffer frBuffer = new StringBuffer();
		if (null == orden.getAutoID() || "".equals(orden.getAutoID())) {
			Double dblResult = new FabricManager().getFabricInventory(orden.getFabricCode());

			frBuffer.append(ResourceHelper.getValue("Fabric_Inventory") + ":" + dblResult);
		}
		return frBuffer.toString();
	}

	/** 获取面料托管信息的显示 */
	public String getAutoContainerHtml(Orden orden) {
		StringBuffer autoBuffer = new StringBuffer();
		if (null != orden.getAutoID() && !"".equals(orden.getAutoID())) {
			List<Dict> autoList = DictManager.getDicts(36);
//			autoBuffer.append("<label style='color:red;'>" + ResourceHelper.getValue("Orden_FabricArrivedControl") + "</label><br/>"); 暂时隐藏
			String checked = "";
			for (Dict dict : autoList) {
				if (dict.getID().toString().equals(orden.getAutoID().toString())) {
					checked = "checked = 'true'";
				} else {
					checked = "";
				}
				autoBuffer.append("<label><input type='radio' value=" + dict.getID() + " name='autoID' " + checked + ">" + dict.getName() + "</label>");
			}
		}
		return autoBuffer.toString();
	}
}