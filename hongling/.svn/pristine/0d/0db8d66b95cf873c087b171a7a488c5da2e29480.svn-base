package hongling.service.styleUI;

import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import chinsoft.business.DictManager;
import chinsoft.core.LogPrinter;
import chinsoft.core.ResourceHelper;
import chinsoft.core.Utility;
import chinsoft.entity.Dict;
import chinsoft.service.core.BaseServlet;

public class UISearchBar extends BaseServlet {
	private static final long serialVersionUID = -7892754396898316791L;

	@Override
	protected void service(HttpServletRequest request,
			HttpServletResponse response) {
		super.service();
		try {
			String strClothingID = getParameter("clothingID");
			String strSearch = "";
			if("1".equals(strClothingID)){//套装2
				//驳头型
				List <Dict> lapels = DictManager.getDicts(1, 50);
				strSearch += "<label>"+ResourceHelper.getValue("Dict_1119")+"</label>";
				strSearch += "<select id='lapel_xf'><option value=''></option>";
				for(Dict lapel : lapels){
					if("10001".equals(Utility.toSafeString(lapel.getStatusID()))){
						strSearch += "<option value='"+lapel.getID()+"' title='"+lapel.getName()+"'>"+lapel.getName()+"</option>";
					}
				}
				strSearch += "</select>";
				//前门扣
				List <Dict> buttons = DictManager.getDicts(1, 35);
				strSearch += "<label>"+ResourceHelper.getValue("Dict_35")+"</label>";
				strSearch += "<select id='button_xf'><option value=''></option>";
				for(Dict button : buttons){
					if("10001".equals(Utility.toSafeString(button.getStatusID()))){
						strSearch += "<option value='"+button.getID()+"' title='"+button.getName()+"'>"+button.getName()+"</option>";
					}
				}
				strSearch += "</select>";
				//裤褶
				List <Dict> pleats = DictManager.getDicts(1, 2032);
				strSearch += "<label>"+ResourceHelper.getValue("Dict_2031")+"</label>";
				strSearch += "<select id='pleat_xk'><option value=''></option>";
				for(Dict pleat : pleats){
					if("10001".equals(Utility.toSafeString(pleat.getStatusID()))){
						strSearch += "<option value='"+pleat.getID()+"' title='"+pleat.getName()+"'>"+pleat.getName()+"</option>";
					}
				}
				strSearch += "</select>";
			}else if("2".equals(strClothingID)){//套装3
				//驳头型
				List <Dict> lapels = DictManager.getDicts(1, 50);
				strSearch += "<label>"+ResourceHelper.getValue("Dict_1119")+"</label>";
				strSearch += "<select id='lapel_xf'><option value=''></option>";
				for(Dict lapel : lapels){
					if("10001".equals(Utility.toSafeString(lapel.getStatusID()))){
						strSearch += "<option value='"+lapel.getID()+"' title='"+lapel.getName()+"'>"+lapel.getName()+"</option>";
					}
				}
				strSearch += "</select>";
				//前门扣
				List <Dict> buttons = DictManager.getDicts(1, 35);
				strSearch += "<label>"+ResourceHelper.getValue("Dict_35")+"</label>";
				strSearch += "<select id='button_xf'><option value=''></option>";
				for(Dict button : buttons){
					if("10001".equals(Utility.toSafeString(button.getStatusID()))){
						strSearch += "<option value='"+button.getID()+"' title='"+button.getName()+"'>"+button.getName()+"</option>";
					}
				}
				strSearch += "</select>";
				//裤褶
				List <Dict> pleats = DictManager.getDicts(1, 2032);
				strSearch += "<label>"+ResourceHelper.getValue("Dict_2031")+"</label>";
				strSearch += "<select id='pleat_xk'><option value=''></option>";
				for(Dict pleat : pleats){
					if("10001".equals(Utility.toSafeString(pleat.getStatusID()))){
						strSearch += "<option value='"+pleat.getID()+"' title='"+pleat.getName()+"'>"+pleat.getName()+"</option>";
					}
				}
				strSearch += "</select>";
				//领形
				List <Dict> lapelss = DictManager.getDicts(1, 4022);
				strSearch += "<label>"+ResourceHelper.getValue("Dict_4022")+"</label>";
				strSearch += "<select id='lapel_mj'><option value=''></option>";
				for(Dict lapel : lapelss){
					if("10001".equals(Utility.toSafeString(lapel.getStatusID()))){
						strSearch += "<option value='"+lapel.getID()+"' title='"+lapel.getName()+"'>"+lapel.getName()+"</option>";
					}
				}
				strSearch += "</select>";
				//前门扣
				List <Dict> buttonss = DictManager.getDicts(1, 4035);
				strSearch += "<label>"+ResourceHelper.getValue("Dict_4035")+"</label>";
				strSearch += "<select id='button_mj'><option value=''></option>";
				for(Dict button : buttonss){
					if("10001".equals(Utility.toSafeString(button.getStatusID()))){
						strSearch += "<option value='"+button.getID()+"' title='"+button.getName()+"'>"+button.getName()+"</option>";
					}
				}
				strSearch += "</select>";
			}else if("3".equals(strClothingID)){//上衣
				//驳头型
				List <Dict> lapels = DictManager.getDicts(1, 50);
				strSearch += "<label>"+ResourceHelper.getValue("Dict_1119")+"</label>";
				strSearch += "<select id='lapel_xf'><option value=''></option>";
				for(Dict lapel : lapels){
					if("10001".equals(Utility.toSafeString(lapel.getStatusID()))){
						strSearch += "<option value='"+lapel.getID()+"' title='"+lapel.getName()+"'>"+lapel.getName()+"</option>";
					}
				}
				strSearch += "</select>";
				//前门扣
				List <Dict> buttons = DictManager.getDicts(1, 35);
				strSearch += "<label>"+ResourceHelper.getValue("Dict_35")+"</label>";
				strSearch += "<select id='button_xf'><option value=''></option>";
				for(Dict button : buttons){
					if("10001".equals(Utility.toSafeString(button.getStatusID()))){
						strSearch += "<option value='"+button.getID()+"' title='"+button.getName()+"'>"+button.getName()+"</option>";
					}
				}
				strSearch += "</select>";
			}else if("2000".equals(strClothingID)){//西裤
				//裤褶
				List <Dict> pleats = DictManager.getDicts(1, 2032);
				strSearch += "<label>"+ResourceHelper.getValue("Dict_2031")+"</label>";
				strSearch += "<select id='pleat_xk'><option value=''></option>";
				for(Dict pleat : pleats){
					if("10001".equals(Utility.toSafeString(pleat.getStatusID()))){
						strSearch += "<option value='"+pleat.getID()+"' title='"+pleat.getName()+"'>"+pleat.getName()+"</option>";
					}
				}
				strSearch += "</select>";
			}else if("3000".equals(strClothingID)){//衬衣
				//领形
				List <Dict> lapels = DictManager.getDicts(1, 3062);
				strSearch += "<label>"+ResourceHelper.getValue("Dict_3062")+"</label>";
				strSearch += "<select id='lapel_cy'><option value=''></option>";
				for(Dict lapel : lapels){
					if("10001".equals(Utility.toSafeString(lapel.getStatusID()))){
						strSearch += "<option value='"+lapel.getID()+"' title='"+lapel.getName()+"'>"+lapel.getName()+"</option>";
					}
				}
				strSearch += "</select>";
			}else if("4000".equals(strClothingID)){//马夹
				//领形
				List <Dict> lapels = DictManager.getDicts(1, 4022);
				strSearch += "<label>"+ResourceHelper.getValue("Dict_4022")+"</label>";
				strSearch += "<select id='lapel_mj'><option value=''></option>";
				for(Dict lapel : lapels){
					if("10001".equals(Utility.toSafeString(lapel.getStatusID()))){
						strSearch += "<option value='"+lapel.getID()+"' title='"+lapel.getName()+"'>"+lapel.getName()+"</option>";
					}
				}
				strSearch += "</select>";
				//前门扣
				List <Dict> buttons = DictManager.getDicts(1, 4035);
				strSearch += "<label>"+ResourceHelper.getValue("Dict_4035")+"</label>";
				strSearch += "<select id='button_mj'><option value=''></option>";
				for(Dict button : buttons){
					if("10001".equals(Utility.toSafeString(button.getStatusID()))){
						strSearch += "<option value='"+button.getID()+"' title='"+button.getName()+"'>"+button.getName()+"</option>";
					}
				}
				strSearch += "</select>";
			}else if("6000".equals(strClothingID)){//大衣
				//驳头型
				List <Dict> lapels = DictManager.getDicts(1, 6028);
				strSearch += "<label>"+ResourceHelper.getValue("Dict_6027")+"</label>";
				strSearch += "<select id='lapel_dy'><option value=''></option>";
				for(Dict lapel : lapels){
					if("10001".equals(Utility.toSafeString(lapel.getStatusID()))){
						strSearch += "<option value='"+lapel.getID()+"' title='"+lapel.getName()+"'>"+lapel.getName()+"</option>";
					}
				}
				strSearch += "</select>";
				//前门扣
				List <Dict> buttons = DictManager.getDicts(1, 6013);
				strSearch += "<label>"+ResourceHelper.getValue("Dict_6013")+"</label>";
				strSearch += "<select id='button_dy'><option value=''></option>";
				for(Dict button : buttons){
					if("10001".equals(Utility.toSafeString(button.getStatusID()))){
						strSearch += "<option value='"+button.getID()+"' title='"+button.getName()+"'>"+button.getName()+"</option>";
					}
				}
				strSearch += "</select>";
			}
			output(strSearch);
		} catch (Exception e) {
			e.printStackTrace();
			LogPrinter.debug("GetStyleMenus_err" + "----" + e.getMessage());
		}
	}
}
