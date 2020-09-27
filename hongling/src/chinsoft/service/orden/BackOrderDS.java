package chinsoft.service.orden;

import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.commons.lang.StringUtils;

import rcmtm.business.ConfigSR;
import chinsoft.bean.SingleSingOnBean;
import chinsoft.business.CDict;
import chinsoft.business.ClothingManager;
import chinsoft.business.DictManager;
import chinsoft.core.Utility;
import chinsoft.entity.Companys;
import chinsoft.entity.Dict;
import chinsoft.service.core.BaseServlet;
import chinsoft.service.core.Encryption;
import chinsoft.service.logistic.InterfaceUtil;

public class BackOrderDS extends BaseServlet {
	private static final long serialVersionUID = -4591305344336387404L;
	@Override
	public void service(HttpServletRequest request, HttpServletResponse response) {
			super.service();
			String httpURL="http://www.rctailor.com/ws_saveOrdenWhereFromBackPlat_POST.do";//电商域名
//			String httpURL="http://115.28.6.96/ws_saveOrdenWhereFromBackPlat_POST.do";
			String param = "";
			try {
				Companys company=(Companys) request.getSession().getAttribute("company");
				SingleSingOnBean bean= company.getSingOnBean();
				StringBuffer info = new StringBuffer();
				String strFabricCode = this.getTempFabricCode();//面料
				String strClothingID = this.getTempClothingID();//服装分类ID
				String strClothingName = DictManager.getDictNameByID(Utility.toSafeInt(strClothingID));//服装分类名称
				//工艺
				String strComponentIDs = this.getTempComponentIDs();
				List<Dict> defaultComponents = new ClothingManager().getDefaultComponent(Utility.toSafeInt(strClothingID), strFabricCode);
				for(Dict component:defaultComponents){
					if(StringUtils.isNotEmpty(strComponentIDs)){
						strComponentIDs = Utility.replace(strComponentIDs, Utility.toSafeString(component.getID()));
					}
				}
				//去除(冲突关系)残余默认值(珠边部位)
				if(!"".equals(strComponentIDs)){
					String[] strComponentID = strComponentIDs.split(",");
					for(String strComponent :strComponentID){
						Dict compontent = DictManager.getDictByID(Utility.toSafeInt(strComponent));
						if(CDict.YES.getID().equals(compontent.getIsDefault())){
							strComponentIDs = Utility.replace(strComponentIDs, Utility.toSafeString(compontent.getID()));
						}
					}
				}
				//特殊工艺
				String strComponentTexts = this.getTempComponentTexts();
				if(!"".equals(strComponentTexts) && ",".equals(strComponentTexts.substring(0, 1))){
					strComponentTexts = strComponentTexts.substring(1, strComponentTexts.length());
				}
				
				info.append("{\"customerID\":").append("\""+bean.getCustomerID()+"\"");
				info.append(",\"fabricNo\":").append("\""+strFabricCode+"\"");
				info.append(",\"processID\":").append("\""+strComponentIDs+"\"");
				info.append(",\"key\":").append("\""+bean.getCustomerName()+"\"");//Key存在CustomerName中
				info.append(",\"title\":").append("\""+strClothingName+"\"");
				info.append(",\"categoryID\":").append("\""+strClothingID+"\"");
				info.append(",\"processContent\":").append("\""+strComponentTexts+"\"");
				info.append(",\"status\":").append("\""+bean.getStatus()+"\"").append("}");
				param = Encryption.encrypt(info.toString(),"RC000001");//电商加密
				System.out.println("电商提供大后台回传的订单信息:"+info.toString());
				System.out.println("电商提供大后台回传的订单信息加密："+param);
				
				
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			StringBuffer sbHtml = new StringBuffer();
	        sbHtml.append("<form id=\"DSsubmit\" name=\"ccbsubmit\" action=\"" + httpURL + "\" method=\"post\">");
	        sbHtml.append("<input type=\"hidden\" name=\"encryptionJsonStr\" value=\""+ param +"\"/>");
	        sbHtml.append("<input type=\"submit\" value=\"toDS\" style=\"display:none;\"></form>");
	        sbHtml.append("<script>document.forms['DSsubmit'].submit();</script>");
	       
	        output(sbHtml.toString());
	}
}
