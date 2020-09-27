package chinsoft.service.orden;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.CDict;
import chinsoft.business.CDictCategory;
import chinsoft.business.ClothingManager;
import chinsoft.business.CurrentInfo;
import chinsoft.business.DictManager;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.entity.Component;
import chinsoft.entity.Detail;
import chinsoft.entity.Dict;
import chinsoft.entity.Member;
import chinsoft.service.core.BaseServlet;

public class GetComponent extends BaseServlet {

	private static final long serialVersionUID = -1759095870257433218L;

	@Override
	public void service(HttpServletRequest request, HttpServletResponse response) {
		try {
			// super.service();
			// 获取登陆用户的经营单位
			Member loginUser = CurrentInfo.getCurrentMember();
			Integer areaid = loginUser.getBusinessUnit();

			String strFabricCode = getTempFabricCode();
			int nParentID = Utility.toSafeInt(getParameter("parentid"));
			String strComponentIDs = this.getTempComponentIDs();
			List<Component> components = new ClothingManager().getComponent(
					nParentID, areaid);
			setComponentClientImg(this.getTempComponentIDs(), strFabricCode,
					components);

			List<Component> validComponents = new ArrayList<Component>();
			for (Component component : components) {
				Dict dictCategory = DictManager.getDictByID(component
						.getCategory());
				if (!new ClothingManager().disabledByOther(strComponentIDs,
						dictCategory)) {
					if (dictCategory != null) {
						if (!CDict.YES.getID().equals(
								dictCategory.getNotShowOnFront())) {
							validComponents.add(component);
						}
					} else {
						validComponents.add(component);
					}
				}
			}
			List<Dict> tempComponents = new ClothingManager()
					.getComponentsByIDs(strComponentIDs);
			for (Component component : validComponents) {
				List<Detail> validDetails = new ArrayList<Detail>();
				for (Detail detail : component.getDetails()) {

					// 把不是登陆用户所在经销处 维护价格的面料 去掉
					// if (!filter.isOurFabric(loginUser.getBusinessUnit(),
					// detail.getName())) {
					// continue;
					// }
					checkDetail(request, detail);
					Dict dict = DictManager.getDictByID(Utility
							.toSafeInt(detail.getID()));
					if (!new ClothingManager().disabledByOther(strComponentIDs,
							dict)
							&& new ClothingManager().allowedByOther(
									tempComponents, dict)) {
						if (dict != null) {
							if (!CDict.YES.getID().equals(
									dict.getNotShowOnFront())) {
								validDetails.add(detail);
							}
						} else {
							validDetails.add(detail);
						}
					}
				}

				component.setDetails(trimDetails(validDetails));
			}
			output(validComponents);
		} catch (Exception e) {
			LogPrinter.debug(e.getMessage());
		}
	}

	/**
	 * 设置客户面料 图片 路径
	 * @param strTempComponentIDs
	 * @param strFabricCode
	 * @param components
	 */
	private void setComponentClientImg(String strTempComponentIDs,
			String strFabricCode, List<Component> components) {
		for (Component component : components) {
			Dict category = DictManager.getDictByID(component.getCategory());
			if (category != null
					&& !category.getCategoryID().equals(
							CDictCategory.FabricCategory.getID())) {
				// 根据ColorLinkedID取出变的路径图
				// String strColorLinkedIDs = category.getColorLinkIDs();
				// if(strColorLinkedIDs != null && !"".equals(strColorLinkedIDs)
				// && !"F".equals(category.getMemo())){
				// String[] arrayColorLinkedIDs =
				// Utility.getStrArray(strColorLinkedIDs);
				// if(arrayColorLinkedIDs.length > 0){
				// String colorLinkedID = arrayColorLinkedIDs[0];
				// List<Dict> colorComponents =
				// DictManager.getDicts(CDictCategory.ClothingCategory.getID(),Utility.toSafeInt(colorLinkedID));
				// for(Dict colorComponent:colorComponents){
				// if(Utility.contains(strTempComponentIDs,
				// Utility.toSafeString(colorComponent.getID()))){
				// strFabricCode = Utility.toSafeString(colorComponent.getID());
				// }
				// }
				// }
				// }

				for (Detail detail : component.getDetails()) {
					Integer nDictID = Utility.toSafeInt(detail.getID());
					// 判断Component下是否有子图片，有，根据子图片的ShapeLinkedIDs的值，取出唯一图片
					Dict imgDict = DictManager.getDictByID(nDictID);
					Dict shapeLinkedImage = new ClothingManager()
							.getShapeLinkedImage(strTempComponentIDs, imgDict);
					if (shapeLinkedImage != null) {
						nDictID = shapeLinkedImage.getID();
					}
					String strDir = "component/" + strFabricCode;
					Dict dictDetail = DictManager.getDictByID(Utility
							.toSafeInt(nDictID));
					if (dictDetail != null) {
						if (CDict.YES.getID().equals(dictDetail.getIsElement())) {
							strDir = Utility.toSafeString(dictDetail
									.getParentID());
						}
					}

					detail.setImgUrl("../../process/" + strDir + "/" + nDictID
							+ "_S.png");
				}

			}
		}
	}
}