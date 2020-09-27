package chinsoft.tempService;

import java.util.ArrayList;
import java.util.List;

import org.apache.struts2.json.bridge.StringBridge;

import chinsoft.business.CDict;
import chinsoft.business.ClothingManager;
import chinsoft.business.DictManager;
import chinsoft.business.FabricManager;
import chinsoft.business.SizeManager;
import chinsoft.core.ResourceHelper;
import chinsoft.core.Utility;
import chinsoft.entity.Dict;
import chinsoft.entity.Embroidery;
import chinsoft.entity.Orden;
import chinsoft.entity.OrdenDetail;

/**
 * 服装大类切换时，页面内容变化
 * 
 * @author Administrator
 * 
 */
public class ClothingChangeService {

	private Orden orden;
	private ClothingManager clothingManager = new ClothingManager();
	private SpliceHtmlStr spliceHtmlStr = new SpliceHtmlStr();
	private SizeManager sizeManager = new SizeManager();

	public ClothingChangeService() {

	}

	public ClothingChangeService(Orden orden) {
		this.orden = orden;
	}

	/**
	 * 获取订单的工艺信息
	 * 
	 * @return
	 */
	public String getProcessHtml() {
		StringBuffer processBuffer = new StringBuffer();
		String[] clothArr;
		switch (orden.getClothingID()) {
		case 1:
			clothArr = new String[] { "3", "2000" };
			break;
		case 2:
			clothArr = new String[] { "3", "2000", "4000" };
			break;
		case 4:
			clothArr = new String[] { "4000", "2000" };
			break;
		case 5:
			clothArr = new String[] { "90000", "2000" };
			break;
		case 6:
			clothArr = new String[] { "3", "4000" };
			break;
		case 7:
			clothArr = new String[] { "95000", "98000" };
			break;
		default:
			clothArr = new String[] { orden.getClothingID().toString() };
			break;
		}
		// 工艺
		Dict clothTemp = null;
		for (int i = 0; i < clothArr.length; i++) {
			clothTemp = DictManager.getDictByID(Utility.toSafeInt(clothArr[i]));
			processBuffer.append("<div class='list_search'>"
					+ clothTemp.getName()
					+ "</div>");
			processBuffer.append("<table id='category_" + clothTemp.getID()
					+ "' class='list_result'><tbody>");
			if(null!=orden.getClothingID() && 3000 == orden.getClothingID()
					&&( null==orden.getFabricCode() ||"".equals(orden.getFabricCode()))){
				processBuffer.append("<tr index='1'><td><input id='component_3000_3028' class='textbox' type='text' " +
						"style='width:130px' value='5000' disabled='disabled'><span style='color: rgb(153, 153, 153);'>" +
						"长袖</span></td><td style='width:30px' onclick='$(this).parent().remove()'><a class='remove'></a>" +
						"</td></tr>");
			}
			if (null != orden.getOrdenID() && !"".equals(orden.getOrdenID())) {
				processBuffer.append(clothingManager.getOrderProcessHtml(
						orden.getOrdenID(), Utility.toSafeInt(clothArr[i])));
			}else{
				processBuffer.append("<tr>");
				processBuffer.append("<td><input type='text' id='text_"+clothArr[i]+"_1' style='width:80px' class='textbox'/><span/></td>");
				processBuffer.append("</tr>");
			}
			processBuffer.append("</tbody></table>");
		}
		return processBuffer.toString();
	}

	/**
	 * 查面料库存
	 * @return
	 */
	public Double getFabricInventory(){
		Double fabricInventory = 0.0;
		Double dblResult = new FabricManager().getFabricInventory(orden.getFabricCode());
		if(null != dblResult && 0 !=dblResult){
			fabricInventory = dblResult;
		}
		return fabricInventory;
	}
	
	/**
	 * 获取订单的面料信息
	 * 
	 * @return
	 */
	public String getFabricHtml() {

		return "";
	}

	/**
	 * 获取订单的 刺绣信息
	 * 
	 * @return
	 */
	public String getEmbroidsHtml(Orden orden) {
		StringBuffer embroideryBuffer = new StringBuffer();
		String[] clothArr;
		switch (orden.getClothingID()) {
		case 1:
			clothArr = new String[] { "3", "2000" };
			break;
		case 2:
			clothArr = new String[] { "3", "2000", "4000" };
			break;
		case 4:
			clothArr = new String[] { "4000", "2000" };
			break;
		case 5:
			clothArr = new String[] { "90000", "2000" };
			break;
		case 6:
			clothArr = new String[] { "3", "4000" };
			break;
		case 7:
			clothArr = new String[] { "95000", "98000" };
			break;
		default:
			clothArr = new String[] { orden.getClothingID().toString() };
			break;
		}
		if (null == orden.getOrdenID() || "".equals(orden.getOrdenID())) {
			for (String clothID : clothArr) {
				embroideryBuffer
						.append(this.generateEmptyEbroideryRow(clothID));
			}
		} else {
			for (String clothID : clothArr) {
				embroideryBuffer
						.append(this.getEmbroidseryHtml(orden, clothID));
			}
		}
		return embroideryBuffer.toString();
	}

	/**
	 * 根据ID生成刺绣空行, 注：行号全是0的
	 * */
	private String generateEmptyEbroideryRow(String clothID) {
		StringBuffer embroideryBuffer = new StringBuffer();
		StringBuffer loactionBuffer = null;
		StringBuffer colorBuffer = null;
		StringBuffer fontBuffer = null;
		StringBuffer contentBuffer = null;
		StringBuffer fontSizeBuffer = null;

		Dict dict;
		String size = "";

		dict = DictManager.getDictByID(Utility.toSafeInt(clothID));
		embroideryBuffer.append("<div class='list_search'>" + dict.getName()
				+ "<a onclick='$.csOrdenPost.addEmbroidRow(" + dict.getID()
				+ ")'>" + ResourceHelper.getValue("Button_Add")
				+ "</a><input id='clothing'" + dict.getID()
				+ " style=' display: none;'></div>");

		embroideryBuffer.append("<table id='category_embroid_" + dict.getID()
				+ "' class='list_result'><tbody>");
		embroideryBuffer.append(" <tr index=" + 0 + " align=\"center\">");
		// if("3000".equals(clothID)){
		// size = "<td ><span/><select id='category_label_" + dict.getID() +
		// "_Size_"+0+"' style='width: 120px' /></td>";
		// }
		// List<Dict> embroidsInfo =
		// clothingManager.GetEmbroids(Utility.toSafeInt(clothID));
		
		
		String contentID = "";
			switch (Utility.toSafeInt(clothID)) {
			//上衣
			case 3: contentID ="421";	break;
			//西裤
			case 2000: contentID ="2207";	break;
			//衫
			case 3000: contentID ="3676";	break;
			//马夹
			case 4000: contentID ="4149";	break;
			//配件
			case 5000: contentID ="5082";	break;
			//大衣
			case 6000: contentID ="6396";	break;
			default:contentID ="2207";	break;
			}
		List<Dict> list = clothingManager.GetEmbroids(Utility
				.toSafeInt(clothID));
		for (int k = 0; k < list.size(); k++) {
			if (k == 0) {
				colorBuffer = new StringBuffer();
				colorBuffer.append("<td><span>" + list.get(k).getName()
						+ ":</span>" + "<select id=\"category_label_" + clothID
						+ "_Color_" + 0 + "\" style=\"width: 120px\">");
				colorBuffer.append("<option title='"
						+ ResourceHelper.getValue("SSB_SELECT")
						+ ResourceHelper.getValue("Dict_422") + "' value='-1'>"
						+ ResourceHelper.getValue("SSB_SELECT")
						+ ResourceHelper.getValue("Dict_422") + "</option>");
				// 颜色
				// 第二步 根据ID 获得下级所有dict(二件1 三件套2 上衣3 裤2000)
				Integer parentID = list.get(k).getID();
				// 工艺信息的 catecoreID 都 是 1
				List<Dict> eachCXList = DictManager.getDicts(1, parentID);
				// 第三步 循环拼接HTML
				for (int v = 0; v < eachCXList.size(); v++) {
					colorBuffer.append("<option title=\""
							+ eachCXList.get(v).getName() + "\" value=\""
							+ eachCXList.get(v).getID() + "\">"
							+ eachCXList.get(v).getName() + "</option>");
				}
				colorBuffer.append("</select></td>");
			}
			if (k == 1) {
				fontBuffer = new StringBuffer();
				// 字体
				fontBuffer.append("<td><span>" + list.get(k).getName()
						+ ":</span>" + "<select id=\"category_label_" + clothID
						+ "_Font_" + 0 + "\" style=\"width: 120px\">");
				fontBuffer.append("<option title='"
						+ ResourceHelper.getValue("SSB_SELECT")
						+ ResourceHelper.getValue("Dict_518") + "' value='-1'>"
						+ ResourceHelper.getValue("SSB_SELECT")
						+ ResourceHelper.getValue("Dict_518") + "</option>");
				// 第二步 根据ID 获得下级所有dict
				Integer parentID = list.get(k).getID();
				// 工艺信息的 catecoreID 都 是 1
				List<Dict> eachCXList = DictManager.getDicts(1, parentID);
				// 第三步 循环拼接HTML
				for (int v = 0; v < eachCXList.size(); v++) {
					fontBuffer.append("<option title=\""
							+ eachCXList.get(v).getName() + "\" value=\""
							+ eachCXList.get(v).getID() + "\">"
							+ eachCXList.get(v).getName() + "</option>");
				}
				fontBuffer.append("</select></td>");
			}
			if (k == 2) {
				// 内容
				contentBuffer = new StringBuffer();
				Integer parentID = list.get(k).getID();
				List<Dict> eachCXList = DictManager.getDicts(1, parentID);
				contentBuffer
						.append("<td><span>"
								+ list.get(k).getName()
								//; color: #EAE9E9 ;background-color: #131313
								+ ":</span><input id=\"category_textbox_"+contentID+"\" style=\"width:120px;background-color: #FFF; border: 1px solid #626061;height: 20px;line-height: 20px;\" class=\"category_textbox_"+clothID+"_Content_0\" type=\"text\" value=''>");
				contentBuffer.append("</td>");
			}
			if (k == 3) {
				loactionBuffer = new StringBuffer();
				// 位置
				loactionBuffer.append("<td><span>" + list.get(k).getName()
						+ ":</span>" + "<select id=\"category_label_" + clothID
						+ "_Position_" + 0 + "\" style=\"width: 120px\">");
				loactionBuffer.append("<option title='"
						+ ResourceHelper.getValue("SSB_SELECT")
						+ ResourceHelper.getValue("Dict_387") + "' value='-1'>"
						+ ResourceHelper.getValue("SSB_SELECT")
						+ ResourceHelper.getValue("Dict_387") + "</option>");

				// 第二步 根据ID 获得下级所有dict
				Integer parentID = list.get(k).getID();
				// 工艺信息的 catecoreID 都 是 1
				List<Dict> eachCXList = DictManager.getDicts(1, parentID);
				// 第三步 循环拼接HTML
				for (int v = 0; v < eachCXList.size(); v++) {
					loactionBuffer.append("<option title=\""
							+ eachCXList.get(v).getName() + "\" memo=\""
							+ eachCXList.get(v).getMemo() +"\" value=\""
							+ eachCXList.get(v).getID() + "\">"
							+ eachCXList.get(v).getName() + "</option>");
				}
				loactionBuffer.append("</select></td>");
			}
			if (CDict.ClothingChenYi.getID().toString().equals(clothID)) {
				// 如果是衬衣
				if (k == 3) {
					// 大小
					fontSizeBuffer = new StringBuffer();
					fontSizeBuffer.append("<td><span>" + list.get(k).getName()
							+ ":</span>" + "<select id=\"category_label_"
							+ clothID + "_Size_" + 0
							+ "\"   style=\"width: 120px\">");
					fontSizeBuffer.append("<option title='"
							+ ResourceHelper.getValue("SSB_SELECT")
							+ ResourceHelper.getValue("Dict_3259")
							+ "' value='-1'>"
							+ ResourceHelper.getValue("SSB_SELECT")
							+ ResourceHelper.getValue("Dict_3259")
							+ "</option>");
					// 第二步 根据ID 获得下级所有dict
					Integer parentID = list.get(k).getID();
					// 工艺信息的 catecoreID 都 是 1
					List<Dict> eachCXList = DictManager.getDicts(1, parentID);
					// 第三步 循环拼接HTML
					for (int v = 0; v < eachCXList.size(); v++) {
						fontSizeBuffer.append("<option title=\""
								+ eachCXList.get(v).getName() + "\" value=\""
								+ eachCXList.get(v).getID() + "\">"
								+ eachCXList.get(v).getName() + "</option>");
					}
					fontSizeBuffer.append("</select></td>");
					// 第三步 循环拼接HTML
				}
				if (k == 4) {
					loactionBuffer = new StringBuffer();
					// 位置
					loactionBuffer.append("<td><span>" + list.get(k).getName()
							+ ":</span>" + "<select id=\"category_label_"
							+ clothID + "_Position_" + 0
							+ "\" style=\"width: 120px\">");
					loactionBuffer
							.append("<option title='"
									+ ResourceHelper.getValue("SSB_SELECT")
									+ ResourceHelper.getValue("Dict_387")
									+ "' value='-1'>"
									+ ResourceHelper.getValue("SSB_SELECT")
									+ ResourceHelper.getValue("Dict_387")
									+ "</option>");
					// 第二步 根据ID 获得下级所有dict
					Integer parentID = list.get(k).getID();
					// 工艺信息的 catecoreID 都 是 1
					List<Dict> eachCXList = DictManager.getDicts(1, parentID);
					// 第三步 循环拼接HTML
					for (int v = 0; v < eachCXList.size(); v++) {
						loactionBuffer.append("<option title=\""
								+ eachCXList.get(v).getName() + "\" memo=\""
								+ eachCXList.get(v).getMemo() +"\" value=\""
								+ eachCXList.get(v).getID() + "\">"
								+ eachCXList.get(v).getName() + "</option>");
					}
					loactionBuffer.append("</select></td>");
				}
			} else {
				if (k == 3) {
					loactionBuffer = new StringBuffer();
					// 位置
					loactionBuffer.append("<td><span>" + list.get(k).getName()
							+ ":</span>" + "<select id=\"category_label_"
							+ clothID + "_Position_" + 0
							+ "\" style=\"width: 120px\" onchange=$.csOrdenPost.changePosition('"+clothID+"','0')>");
					loactionBuffer
							.append("<option title='"
									+ ResourceHelper.getValue("SSB_SELECT")
									+ ResourceHelper.getValue("Dict_387")
									+ "' value='-1'>"
									+ ResourceHelper.getValue("SSB_SELECT")
									+ ResourceHelper.getValue("Dict_387")
									+ "</option>");
					// 第二步 根据ID 获得下级所有dict
					Integer parentID = list.get(k).getID();
					// 工艺信息的 catecoreID 都 是 1
					List<Dict> eachCXList = DictManager.getDicts(1, parentID);
					// 第三步 循环拼接HTML
					for (int v = 0; v < eachCXList.size(); v++) {
						loactionBuffer.append("<option title=\""
								+ eachCXList.get(v).getName() + "\" memo=\""
								+ eachCXList.get(v).getMemo() +"\" value=\""
								+ eachCXList.get(v).getID() + "\">"
								+ eachCXList.get(v).getName() + "</option>");
					}
					loactionBuffer.append("</select></td>");
				}
				if(k == 4 && "5000".equals(clothID)){
					// 大小
					fontSizeBuffer = new StringBuffer();
					fontSizeBuffer.append("<td><span>" + list.get(k).getName()
							+ ":</span>" + "<select id=\"category_label_"
							+ clothID + "_Size_" + 0
							+ "\"   style=\"width: 120px\">");
					fontSizeBuffer.append("<option title='"
							+ ResourceHelper.getValue("SSB_SELECT")
							+ ResourceHelper.getValue("Dict_3259")
							+ "' value='-1'>"
							+ ResourceHelper.getValue("SSB_SELECT")
							+ ResourceHelper.getValue("Dict_3259")
							+ "</option>");
					// 第二步 根据ID 获得下级所有dict
					Integer parentID = list.get(k).getID();
					// 工艺信息的 catecoreID 都 是 1
					List<Dict> eachCXList = DictManager.getDicts(1, parentID);
					// 第三步 循环拼接HTML
					for (int v = 0; v < eachCXList.size(); v++) {
						fontSizeBuffer.append("<option title=\""
								+ eachCXList.get(v).getName() + "\" value=\""
								+ eachCXList.get(v).getID() + "\">"
								+ eachCXList.get(v).getName() + "</option>");
					}
					fontSizeBuffer.append("</select></td>");
					// 第三步 循环拼接HTML
				}

			}
		}
		embroideryBuffer.append(loactionBuffer == null ? "" : loactionBuffer)
				.append(colorBuffer == null ? "" : colorBuffer)
				.append(fontBuffer == null ? "" : fontBuffer)
				.append(contentBuffer == null ? "" : contentBuffer)
				.append(fontSizeBuffer == null ? "" : fontSizeBuffer);
		embroideryBuffer
				.append("<td onclick='$(this).parent().remove()' style='width:30px'><a class='remove'></a></td>");
		embroideryBuffer.append("</tr>");
		embroideryBuffer.append("</tbody></table>");
		return embroideryBuffer.toString();
	}

	/**
	 * 获取订单的 尺寸分类信息
	 * 
	 * @return
	 */
	public String getSize_cateGoryHtml() {
		StringBuffer size_categoryBuffer = new StringBuffer();
		List<Dict> sizeCategoryList = sizeManager.getSizeCategory(Utility
				.toSafeInt(orden.getClothingID()));
		Integer size_categoryID = (null == orden.getSizeCategoryID() || "".equals(orden.getSizeCategoryID())) ?
				10052 : orden.getSizeCategoryID();
		String checked = "";
		for (Dict tempSize : sizeCategoryList) {
			if(size_categoryID == tempSize.getID() || size_categoryID.equals(tempSize.getID())){
				checked = "checked";
			}else if(null != orden.getClothingID() && 5000 == orden.getClothingID() && tempSize.getID()==10053){
				checked = "checked";
			}else{
				checked = "";
			}
			size_categoryBuffer.append("<li class='size_category'><label><input type='radio' value='" + tempSize.getID() + "' name='size_category' "+checked+" onclick='$.csSize.generateArea()'/>" + tempSize.getName() + "</label></li>");
		}
		return size_categoryBuffer.toString();
	}
	/**
	 * 获取 编辑页面时订单尺码区域性
	 * @return
	 */
	public String  getSize_areaHtml(){
		
		return clothingManager.getOrdenSize_areaHtml(orden);
	}

	/**
	 * 获取订单的尺寸录入信息
	 * 
	 * @return
	 */
	public String getSize_inputHtml() {
		StringBuffer bodyBuffer = new StringBuffer();
		String[] clothArr;
		switch (orden.getClothingID()) {
		case 1:
			clothArr = new String[] { "3", "2000" };
			break;
		case 2:
			clothArr = new String[] { "3", "2000", "4000" };
			break;
		case 4:
			clothArr = new String[] { "4000", "2000" };
			break;
		case 5:
			clothArr = new String[] { "90000", "2000" };
			break;
		case 6:
			clothArr = new String[] { "3", "4000" };
			break;
		case 7:
			clothArr = new String[] { "95000", "98000" };
			break;
		default:
			clothArr = new String[] { orden.getClothingID().toString() };
			break;
		}
		for(String clothID :clothArr){
			bodyBuffer.append(spliceHtmlStr.getSingleClothSpecialBodyInput(orden, clothID));
		}
		return bodyBuffer.toString();
	}

	/**
	 * 获取订单的特体信息
	 * 
	 * @return
	 */
	public String getSize_bodyTypeHtml() throws Exception {
		String tempString = "";
		try {
			tempString = spliceHtmlStr.spliceSizeBodyType(orden);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return tempString;
	}

	/**
	 * 获取订单 款式风格
	 * 
	 * @return
	 */
	public String getSize_styleHtml() {

		return "";
	}

	/**
	 * 获取订单 长短款
	 * 
	 * @return
	 */
	public String getSize_titleHtml() {
		StringBuffer titleBuffer = new StringBuffer();
		List<Dict> titleList =  DictManager.getDicts(41);
		Integer title;
		if(null == orden.getOrdenID() || "".equals(orden.getOrdenID())){
			title = 20100;
		}
		else if(null != orden && (null == orden.getStyleID() || "".equals(orden.getStyleID())) || orden.getStyleID() == -1){
			title = 20100;
		}
		else{
			title = orden.getStyleID();
		}
		if(!"10052".equals(orden.getSizeCategoryID().toString()) ||
				("2000".equals(orden.getClothingID().toString()) || "3000".equals(orden.getClothingID().toString())
						||"4000".equals(orden.getClothingID().toString())||"5000".equals(orden.getClothingID().toString())||"98000".equals(orden.getClothingID().toString()))){
			titleList.clear();
		}
		String checked ;
		for(Dict dict: titleList){
			checked = "";
			if(dict.getID() == title || dict.getID().toString().equals(title.toString())){
				checked = "checked = 'true'";
			}else{
				checked = "";
			}
			if(orden != null && "6000".equals(Utility.toSafeString(orden.getClothingID())) && !"20102".equals(Utility.toSafeString(dict.getID()))){
				titleBuffer.append("<label style='display:inline;clear:none;'><input type='radio' "+checked+" name='styleID' value='"+dict.getID()+"'>"+dict.getName()+"</label>");
			}else if(orden != null && !"6000".equals(Utility.toSafeString(orden.getClothingID()))){
				titleBuffer.append("<label style='display:inline;clear:none;'><input type='radio' "+checked+" name='styleID' value='"+dict.getID()+"'>"+dict.getName()+"</label>");
			}else if(orden == null){
				titleBuffer.append("<label style='display:inline;clear:none;'><input type='radio' "+checked+" name='styleID' value='"+dict.getID()+"'>"+dict.getName()+"</label>");
			}
		}
		if(orden != null && "6000".equals(Utility.toSafeString(orden.getClothingID())) && "10052".equals(Utility.toSafeString(orden.getSizeCategoryID()))){
			String arr[]={"0A02","0A01"};
			String checkedDY="";
			String styDY="";
			for(int i=0;i<arr.length;i++){
				checkedDY="";
				//新添加的订单没有布料号 - -!
				if(null != orden.getFabricCode() && !"".equals(orden.getFabricCode())){
					if(arr[i].equals(orden.getStyleDY())){
						checkedDY=" checked='true' ";
					}else if((null == orden.getStyleDY() || "".equals(orden.getStyleDY()))
							&& "0A02".equals(arr[i])){
						checkedDY=" checked='true' ";
					}
					else{
						checkedDY="";
					} 
				}else{
					if("0A02".equals(arr[i])){
						checkedDY=" checked='true' ";
					}
				}
				
				styDY+="<input type='radio' name='styleDY' value='"+arr[i]+"' "+checkedDY+"/>"+ResourceHelper.getValue("DY_"+arr[i]);
			}
			titleBuffer.append(styDY);
		}
		return titleBuffer.toString();
	}

	/**
	 * 获取大衣是否套西信息
	 * 
	 * @return
	 */
	public String getin_clothHtml() {

		return "";
	}

	/** 生成单类服装的刺绣信息 */
	private String getEmbroidseryHtml(Orden orden, String clothID) {
		List<Embroidery> ordenEmbroidery = new ArrayList<Embroidery>();
		List<OrdenDetail> ordenDetailList = orden.getOrdenDetails();
		OrdenDetail detail = null;
		for (OrdenDetail ordenDetail : ordenDetailList) {
			if (ordenDetail.getSingleClothingID().toString().equals(clothID)) {
				detail = ordenDetail;
			}
		}
		Dict cloth;
		StringBuffer embroidHtml;
		StringBuffer loactionBuffer = null;
		StringBuffer colorBuffer = null;
		StringBuffer fontBuffer = null;
		StringBuffer contentBuffer = null;
		StringBuffer fontSizeBuffer = null;
		Integer singleclothID = Utility.toSafeInt(clothID);
		// 迭代服装大类 上衣/西裤/马甲 ...
		embroidHtml = new StringBuffer();
		cloth = DictManager.getDictByID(singleclothID);
		if (null != detail) {
			ordenEmbroidery = detail.getEmberoidery();
		}
		if (null != ordenEmbroidery && !ordenEmbroidery.isEmpty()) {
			embroidHtml.append("<div class='list_search'>" + cloth.getName()
					+ "<a onclick='$.csOrdenPost.addEmbroidRow("
					+ cloth.getID() + ")'>"
					+ ResourceHelper.getValue("Button_Add")
					+ " </a><input id='clothing'" + cloth.getID() + " value="
					+ (ordenDetailList.size() - 1)
					+ " style='display:none;'></div>");
			embroidHtml.append("<table id=\"category_embroid_" + cloth.getID()
					+ "\" class=\"list_result\"><tbody>");

			// 循环 大类服装 的刺绣条数
			for (int j = 0; j < ordenEmbroidery.size(); j++) {
				if (null == ordenEmbroidery.get(j).getContentID()) {
					continue;
				}
				String displayStr = "";
				embroidHtml.append(" <tr index=" + j + " align=\"center\">");
				// 获得每个服装分类 下的 刺绣设计(位置/颜色/字体/内容 /大小)
				List<Dict> embroidsInfo = clothingManager
						.GetEmbroids(singleclothID);
				for (int k = 0; k < embroidsInfo.size(); k++) {
					if (k == 0) {
						colorBuffer = new StringBuffer();
						colorBuffer.append("<td><span>"
								+ embroidsInfo.get(k).getName() + ":</span>"
								+ "<select id=\"category_label_"
								+ cloth.getID() + "_Color_" + j + "\" "
								+ displayStr + " style=\"width: 120px\" >");
						// 颜色
						Integer parentID = embroidsInfo.get(k).getID();
						// 工艺信息的 catecoreID 都 是 1
						List<Dict> eachCXList = DictManager.getDicts(1,
								parentID);

						// 第三步 循环拼接HTML
						for (int v = 0; v < eachCXList.size(); v++) {
							// 如果是 此服装 大类下的 此条刺绣记录 中的颜色值 与 此服装 下所有的刺绣颜色 中某一条 相等
							// 则设置 为 选 中
							if (ordenEmbroidery.get(j).getColor().getID() == eachCXList
									.get(v).getID()) {
								colorBuffer.append("<option title=\""
										+ eachCXList.get(v).getName()
										+ "\" selected='selected' value=\""
										+ eachCXList.get(v).getID() + "\">"
										+ eachCXList.get(v).getName()
										+ "</option>");
							} else {
								colorBuffer.append("<option title=\""
										+ eachCXList.get(v).getName()
										+ "\" value=\""
										+ eachCXList.get(v).getID() + "\">"
										+ eachCXList.get(v).getName()
										+ "</option>");
							}
						}
						embroidHtml.append("</select></td>");
					}
					if (k == 1) {
						fontBuffer = new StringBuffer();
						// 字体
						fontBuffer.append("<td><span>"
								+ embroidsInfo.get(k).getName() + ":</span>"
								+ "<select id=\"category_label_"
								+ cloth.getID() + "_Font_" + j + "\" "
								+ displayStr + " style=\"width: 120px\">");

						// 第二步 根据ID 获得下级所有dict
						Integer parentID = embroidsInfo.get(k).getID();
						// 工艺信息的 catecoreID 都 是 1
						List<Dict> eachCXList = DictManager.getDicts(1,
								parentID);
						// 第三步 循环拼接HTML
						for (int v = 0; v < eachCXList.size(); v++) {
							// 如果是 此服装 大类下的 此条刺绣记录 中的颜色值 与 此服装 下所有的刺绣颜色 中某一条 相等
							// 则设置 为 选 中
							if (ordenEmbroidery.get(j).getFont().getID() == eachCXList
									.get(v).getID()) {
								fontBuffer.append("<option title=\""
										+ eachCXList.get(v).getName()
										+ "\" selected='selected' value=\""
										+ eachCXList.get(v).getID() + "\">"
										+ eachCXList.get(v).getName()
										+ "</option>");
							} else {
								fontBuffer.append("<option title=\""
										+ eachCXList.get(v).getName()
										+ "\" value=\""
										+ eachCXList.get(v).getID() + "\">"
										+ eachCXList.get(v).getName()
										+ "</option>");
							}
						}
						fontBuffer.append("</select></td>");
					}
					if (k == 2) {
						contentBuffer = new StringBuffer();
						// 内容
						contentBuffer
								.append("<td><span>"
										+ embroidsInfo.get(k).getName()
										+ ":</span><input id=\"category_textbox_"
										+ embroidsInfo.get(k).getID()
										+ "\" style=\"width:120px;background-color: #ffffff; border: 1px solid #626061; color: #000000;height: 20px;line-height: 20px;\" class=\"category_textbox_"
										+ singleclothID + "_Content_" + j
										+ "\" type=\"text\" value=\""
										+ ordenEmbroidery.get(j).getContent()
										+ "\">");

						contentBuffer.append("</td>");
					}
					if (CDict.ClothingChenYi.getID().equals(singleclothID)) {
						// 如果是衬衣
						if (k == 3) {
							// 大小
							fontSizeBuffer = new StringBuffer();
							fontSizeBuffer.append("<td><span>"
									+ embroidsInfo.get(k).getName()
									+ ":</span>"
									+ "<select id=\"category_label_"
									+ cloth.getID() + "_Size_" + j + "\" "
									+ displayStr + " style=\"width: 120px\">");
							// 第二步 根据ID 获得下级所有dict
							Integer parentID = embroidsInfo.get(k).getID();
							// 工艺信息的 catecoreID 都 是 1
							List<Dict> eachCXList = DictManager.getDicts(1,
									parentID);
							// 第三步 循环拼接HTML
							for (int v = 0; v < eachCXList.size(); v++) {
								// 如果是 此服装 大类下的 此条刺绣记录 中的颜色值 与 此服装 下所有的刺绣颜色 中某一条
								// 相等 则设置 为 选 中
								if (ordenEmbroidery.get(j).getSize().getID() == eachCXList
										.get(v).getID()) {
									fontSizeBuffer.append("<option title=\""
											+ eachCXList.get(v).getName()
											+ "\" selected='selected' value=\""
											+ eachCXList.get(v).getID() + "\">"
											+ eachCXList.get(v).getName()
											+ "</option>");
								} else {
									fontSizeBuffer.append("<option title=\""
											+ eachCXList.get(v).getName()
											+ "\" value=\""
											+ eachCXList.get(v).getID() + "\">"
											+ eachCXList.get(v).getName()
											+ "</option>");
								}
							}
							fontSizeBuffer.append("</select></td>");
							// 第三步 循环拼接HTML
						}
						if (k == 4) {
							loactionBuffer = new StringBuffer();
							// 位置
							loactionBuffer.append("<td><span>"
									+ embroidsInfo.get(k).getName()
									+ ":</span>"
									+ "<select id=\"category_label_"
									+ cloth.getID() + "_Position_" + j
									+ "\" style=\"width: 120px\">");

							// 第二步 根据ID 获得下级所有dict
							Integer parentID = embroidsInfo.get(k).getID();
							// 工艺信息的 catecoreID 都 是 1
							List<Dict> eachCXList = DictManager.getDicts(1,
									parentID);
							// 第三步 循环拼接HTML
							for (int v = 0; v < eachCXList.size(); v++) {
								// 如果是 此服装 大类下的 此条刺绣记录 中的颜色值 与 此服装 下所有的刺绣颜色 中某一条
								// 相等 则设置 为 选 中
								if (ordenEmbroidery.get(j).getLocation()
										.getID() == eachCXList.get(v).getID()) {
									loactionBuffer.append("<option title=\""
											+ eachCXList.get(v).getName()
											+ "\" selected='selected' memo=\""+eachCXList.get(v).getMemo()+"\" value=\""
											+ eachCXList.get(v).getID() + "\">"
											+ eachCXList.get(v).getName()
											+ "</option>");
								} else {
									loactionBuffer.append("<option title=\""
											+ eachCXList.get(v).getName()
											+ "\" memo=\""+eachCXList.get(v).getMemo()+"\" value=\""
											+ eachCXList.get(v).getID() + "\">"
											+ eachCXList.get(v).getName()
											+ "</option>");
								}
							}
							loactionBuffer.append("</select></td>");
						}
					} else {
						if (k == 3) {
							loactionBuffer = new StringBuffer();
							// 位置
							loactionBuffer.append("<td><span>"
									+ embroidsInfo.get(k).getName()
									+ ":</span>"
									+ "<select id=\"category_label_"
									+ cloth.getID() + "_Position_" + j
									+ "\" style=\"width: 120px\">");

							// 第二步 根据ID 获得下级所有dict
							Integer parentID = embroidsInfo.get(k).getID();
							// 工艺信息的 catecoreID 都 是 1
							List<Dict> eachCXList = DictManager.getDicts(1,
									parentID);
							// 第三步 循环拼接HTML
							for (int v = 0; v < eachCXList.size(); v++) {
								// 如果是 此服装 大类下的 此条刺绣记录 中的颜色值 与 此服装 下所有的刺绣颜色 中某一条
								// 相等 则设置 为 选 中
								if (ordenEmbroidery.get(j).getLocation()
										.getID() == eachCXList.get(v).getID()) {
									loactionBuffer.append("<option title=\""
											+ eachCXList.get(v).getName()
											+ "\" selected='selected' memo=\""+eachCXList.get(v).getMemo()+"\" value=\""
											+ eachCXList.get(v).getID() + "\">"
											+ eachCXList.get(v).getName()
											+ "</option>");
								} else {
									loactionBuffer.append("<option title=\""
											+ eachCXList.get(v).getName()
											+ "\" memo=\""+eachCXList.get(v).getMemo()+"\" value=\""
											+ eachCXList.get(v).getID() + "\">"
											+ eachCXList.get(v).getName()
											+ "</option>");
								}
							}
							loactionBuffer.append("</select></td>");
						}

					}
				}
				embroidHtml
						.append(loactionBuffer == null ? "" : loactionBuffer)
						.append(colorBuffer == null ? "" : colorBuffer)
						.append(fontBuffer == null ? "" : fontBuffer)
						.append(contentBuffer == null ? "" : contentBuffer)
						.append(fontSizeBuffer == null ? "" : fontSizeBuffer);
				embroidHtml
						.append("<td onclick='$(this).parent().remove()' style='width:30px'><a class='remove'></a></td>");
				embroidHtml.append("</tr>");
			}
			embroidHtml.append("</tbody></table>");
		} else {
			embroidHtml.append(generateEmptyEbroideryRow(clothID));
		}

		return embroidHtml.toString();
	}
}
