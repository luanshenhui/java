package chinsoft.business;

import java.io.File;
import java.util.List;

import javax.servlet.http.HttpServletRequest;


import chinsoft.core.HttpContext;
import chinsoft.core.Utility;
import chinsoft.entity.Fabric;

public class FixManager{

	//拼出 面料		
	public String getFabricImgByParentClothingID(int id,int nUserBusinessUnit,HttpServletRequest request){
		List<Fabric> fabricAll = null;
//		if(nUserBusinessUnit == 20137 || nUserBusinessUnit == 20138
//				|| nUserBusinessUnit == 20139 || nUserBusinessUnit == 20140
//				|| nUserBusinessUnit == 20144){
//			fabricAll = new FabricManager().getFabricByKeyword("", Utility.toSafeString(id));
//		}else{
			fabricAll = new FabricManager().getFabricByUserBusinessUnit(Utility.toSafeString(id),nUserBusinessUnit);
//		}
		String strFabrics ="";
		for(Fabric f : fabricAll){
			String strRealPathH = request.getSession().getServletContext().getRealPath("/process/fabric/" + f.getCode() +"_S.png");
			if(new File(strRealPathH).exists()){
				strFabrics += f.getCode()+",";//系统面料
			}
		}
		String[] strFabric = strFabrics.split(",");
		String strHtml = "<div id='more_fabric' class='scrollCss' style='width:747px; height:233px;'>"
				+ "<table cellspacing='0' width='225px'><tr>";
		String strMemo ="</tr><tr>";
		for (int i=0;i<strFabric.length;i++) {
			int n = i+1;
			String strCss = "style='width:32px;height:32px;border: 1px solid #e2e1e3;padding: 1px;margin-right:45px;margin-top:15px;background-color: #FFFFFF;cursor:pointer;'";
			String strICss="";
			if(i==0){
				HttpContext.setSessionValue(CDict.SessionKey_FabricCode, strFabric[i]);
				strICss="style='display: block;'";
				strCss = "style='width:32px;height:32px;border: 2px solid #DF0001;padding: 1px;margin-right:45px;margin-top:15px;background-color: #FFFFFF;cursor:pointer;'";
			}
			strHtml += "<td class='fabric_img'><img id='ml_img"+ n +"' src='../../process/fabric/"+ strFabric[i] +"_S.png'  "+ strCss +"" 
					+ " onclick=$.csSelect.changeFabric('"+ strFabric[i] +"',"+ n +","+ strFabric.length +") onmouseover='$.csSelect.mlOver("+ n +")' onmouseout='$.csSelect.mlOut("+ n +")' title='"+ strFabric[i] +"'/>" 
					+ "<i id='ml"+ n +"' class='ml' "+strICss+"></i></td>";
			strMemo += "<td align='left'>"+strFabric[i]+"</td>";
			//每7款面料一换行
			int m = n%8;
			if(m == 0){
				strHtml += strMemo+"</tr><tr>";
				strMemo ="</tr><tr>";
			}else if(i == strFabric.length-1){
				strHtml += strMemo;
			}
		}
		strHtml += "</tr></table></div>";
		return strHtml;
	}
}