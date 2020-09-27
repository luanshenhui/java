package chinsoft.business;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.hibernate.Query;

import chinsoft.core.CVersion;
import chinsoft.core.DataAccessObject;
import chinsoft.core.HttpContext;
import chinsoft.core.LogPrinter;
import chinsoft.core.ResourceHelper;
import chinsoft.core.Utility;
import chinsoft.entity.Dict;
import chinsoft.entity.Fabric;
import chinsoft.entity.FashionDict;

public class FashionManager{

	DataAccessObject dao = new DataAccessObject();
	
	//获取系列名称
	@SuppressWarnings("unchecked")
	public List<FashionDict> getFashions(){
		List<FashionDict> dicts = new ArrayList<FashionDict>();
		try {
			String hql = "SELECT fd FROM FashionDict fd WHERE fd.ParentID = 0 order by ID";
			Query query = DataAccessObject.openSession().createQuery(hql);
			dicts = (List<FashionDict>) query.list();
		} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		} finally {
			DataAccessObject.closeSession();
		}
		
		return dicts;
		
	}
	//根据ParentID获取List<FashionDict> （根据系列id获取旗下款式）
	@SuppressWarnings("unchecked")
	public List<FashionDict> getFashionsByParentID(int nParentID){
		List<FashionDict> dicts = new ArrayList<FashionDict>();
		try {
			String hql = "SELECT fd FROM FashionDict fd WHERE fd.ParentID = ? order by Code,ID ";
			Query query = DataAccessObject.openSession().createQuery(hql);
			query.setInteger(0, nParentID);
			dicts = (List<FashionDict>) query.list();
		} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		} finally {
			DataAccessObject.closeSession();
		}
		
		return dicts;
		
	}
	//拼出 首页款式图片
	public String getFashionsImgByParentID(int nParentID){
		String strHtml = "";
		List<FashionDict> dicts = getFashionsByParentID(nParentID);
		List<FashionDict> parentDicts = getFashions();
		String strTitle = "";
		for(FashionDict dict : parentDicts){
			if(nParentID == dict.getID()){
				String v = Utility.toSafeString(CVersion.getCurrentVersionID());
				if(CDict.EN.equals(v)){
					strTitle = dict.getNameEN();
				}else if(CDict.DE.equals(v)){
					strTitle = dict.getNameDE();
				}else if(CDict.FR.equals(v)){
					strTitle = dict.getNameFR();
				}else if(CDict.JA.equals(v)){
					strTitle = dict.getNameJA();
				}else{
					strTitle = dict.getName();
				}
				break;
			}
		}
		for (FashionDict dict : dicts) {
			if(dict.getIsShow() == 0){
				String strValue = "";
				List<FashionDict> fzfldDicts = getFashionsByParentID(dict.getID());
				for (FashionDict fzfldDict : fzfldDicts) {
					new DictManager();
					Dict dictm = DictManager.getDictByID(fzfldDict.getCode());
					strValue += dictm.getName()+"  ";
				}
				strHtml += "<a rel='../../fashionIMG/"+nParentID+"/"+dict.getName()+".JPG' title='"+ strTitle+dict.getName() +"' href='#'>"+ strValue +"</a>";
			}
		}
//		System.out.println(strHtml);
		return strHtml;
		
	}
	//拼出 左侧款式图片
	public String getFashionLeftImgByParentID(int id,HttpServletRequest request){
		String strHtml = "";
		String strDisplayHtml="";
		List<FashionDict> dicts = getFashionsByParentID(id);//款式下级--西服、西裤
		FashionDict fd = getFashionsByID(id);//款式
		FashionDict xl = getFashionsByID(fd.getParentID());//系列
		for (int i=0;i<dicts.size();i++) {
			String background ="";
			//服装模型
			String strRealPathM = request.getSession().getServletContext().getRealPath("/fashionIMG/"+ xl.getID() +"/"+ fd.getName()+ "_" +dicts.get(i).getCode() +"SM.JPG");
			//大图
			if(i == 0){
				if(new File(strRealPathM).exists()){
					background ="background: url(../../fashionIMG/img/cp_s_now.gif)";
					strHtml = "<div id='top_model'><a href='../../fashionIMG/"+ xl.getID() +"/"+ fd.getName() +"_"+ dicts.get(0).getCode() +"LM.JPG' class='jqzoom'>"
					+"<img src='../../fashionIMG/"+ xl.getID() +"/"+ fd.getName() +"_"+ dicts.get(0).getCode() +"MM.JPG'/></a></div>";
				}else{
					background ="background: url(../../fashionIMG/img/cp_s_now.gif)";
					strHtml = "<div id='top_model'><a href='../../fashionIMG/"+ xl.getID() +"/"+ fd.getName() +"_"+ dicts.get(0).getCode() +"LQ.JPG' class='jqzoom'>"
					+"<img src='../../fashionIMG/"+ xl.getID() +"/"+ fd.getName() +"_"+ dicts.get(0).getCode() +"MQ.JPG'/></a></div>";
				}
			}
			int all = dicts.get(dicts.size()-1).getID()+1;
			
			if(new File(strRealPathM).exists()){
				strHtml += "<div id='bottom_modelM"+ dicts.get(i).getID() +"' "
						+ " style='float: left; height: 114px; margin-left: 8px; margin-top: 5px; width: 85px;'>"
						+ "<img id='small_imgM"+ dicts.get(i).getID() +"' src='../../fashionIMG/"+ xl.getID() +"/"+ fd.getName()+ "_" +dicts.get(i).getCode() +"SM.JPG' class='small'"
						+ " onmouseover=$.csFashion_post.flOver('"+ dicts.get(i).getID() +"','"+ xl.getID() +"/"+ fd.getName()+ "_" +dicts.get(i).getCode()+"','M') onmouseout=$.csFashion_post.flOut('"+ dicts.get(i).getID() +"','M') alt=''/></div>";
			}
			
			//小前景图
			String strRealPathQ = request.getSession().getServletContext().getRealPath("/fashionIMG/"+ xl.getID() +"/"+ fd.getName()+ "_" +dicts.get(i).getCode() +"SQ.JPG");
			if(new File(strRealPathQ).exists()){
				strHtml += "<div id='bottom_model"+ dicts.get(i).getID() +"' onclick='$.csFashion_post.changebg("+ dicts.get(i).getID() +","+ dicts.get(0).getID() +","+ all +")'"
						+ " style='float: left; height: 114px; margin-left: 8px; margin-top: 5px; width: 85px;"+ background +"'>"
						+ "<img id='small_img"+ dicts.get(i).getID() +"' src='../../fashionIMG/"+ xl.getID() +"/"+ fd.getName()+ "_" +dicts.get(i).getCode() +"SQ.JPG' class='small'"
						+ " onmouseover=$.csFashion_post.flOver('"+ dicts.get(i).getID() +"','"+ xl.getID() +"/"+ fd.getName()+ "_" +dicts.get(i).getCode()+"','Q') onmouseout=$.csFashion_post.flOut('"+ dicts.get(i).getID() +"','Q') alt=''/></div>";
			}
			//小背景图
			String strRealPathH = request.getSession().getServletContext().getRealPath("/fashionIMG/"+ xl.getID() +"/"+ fd.getName()+ "_" +dicts.get(i).getCode() +"SH.JPG");
			if(new File(strRealPathH).exists()){
				strHtml +="<div id='bottom_model"+ 0+dicts.get(i).getID() +"' "
						+ " style='float: left; height: 114px; margin-left: 8px; margin-top: 5px; width: 85px;'>"
						+ "<img id='small_img"+ 0+dicts.get(i).getID() +"' src='../../fashionIMG/"+ xl.getID() +"/"+fd.getName()+"_"+dicts.get(i).getCode() +"SH.JPG' class='small'"
						+ " onmouseover=$.csFashion_post.flOver('"+ 0+dicts.get(i).getID() +"','"+ xl.getID() +"/"+ fd.getName()+ "_" +dicts.get(i).getCode()+"','H') onmouseout=$.csFashion_post.flOut('"+ 0+dicts.get(i).getID() +"','H') alt=''/></div>";
			}
			strDisplayHtml +="<div id='"+ dicts.get(i).getID() +"' style='display:none;'></div>";
		}
		return strHtml + strDisplayHtml;
		
	}
	//拼出 可选工艺
	public String getFashionRightImgByParentID(int id,int start){
		if(start == 1){
			List<FashionDict> dicts = getFashionsByParentID(id);
			id = dicts.get(0).getID();
		}
		String strHtml = "";
		List<FashionDict> dicts = getFashionsByParentID(id);
		for (int i=0;i<dicts.size();i++) {
			new DictManager();
			Dict parentdict = DictManager.getDictByID(dicts.get(i).getCode());
			strHtml += "<tr><td><label style='color:#5B0A0A;'>"+ parentdict.getName() +"</label></td><td>";
		    String[] process = dicts.get(i).getExtension().split(",");
			for (int j=0;j<process.length;j++) {
				int n = j+1;
				new DictManager();
				Dict dict = DictManager.getDictByID(Utility.toSafeInt(process[j]));
				String strClassName="";
				String strCssi = "";
				String strCss = "";
				if(dicts.get(i).getIsDefault() != null && dicts.get(i).getIsDefault() == Utility.toSafeInt(process[j])){
					strCssi = "style='display: block;'";
					strCss = "style='border: 2px solid #DF0001;'";
					strClassName=" commom_class";
				}
				strHtml += "<div class='gys "+ strClassName +"' id='gy_"+ id + i +"_"+ n +"' "+ strCss +"><div id='gy' onclick=$.csFashion_post.changebg2('"+ dict.getID() +"',"+ n +","+ id + i +","+ process.length +") onmouseover=$.csFashion_post.gyOver('"+ id + i +"_"+ n +"') onmouseout=$.csFashion_post.gyOut('"+ id + i +"_"+ n +"')>"+ dict.getName() +"</div>"
						+ " <i id='gyimg_"+ id + i +"_"+ n +"' class='gyimg' "+ strCssi +"></i></div>";
			}
			strHtml += "</td></tr>";
			strHtml += "<tr width='80px;'><td colspan='2' style='border-bottom:3px double #e7e7e7;'></td></tr>";
		}
		return strHtml;
	}
	//拼出 面料		
	public String getFabricImgByParentID(int id,HttpServletRequest request){
		String strHtml = "<table><tr>";
		FashionDict dict = getFashionsByID(id);
		List<Fabric> fabricAll = new FabricManager().getFabricByKeyword("", Utility.toSafeString(dict.getCode()));
		String strFabrics ="";
		String strFabricMore="";
		int num=0;
		for(Fabric f : fabricAll){
			String strRealPathH = request.getSession().getServletContext().getRealPath("/process/fabric/" + f.getCode() +"_S.png");
			if(new File(strRealPathH).exists() && !f.getCode().equals(dict.getExtension())){
				num ++;
				if(num <7){
					strFabrics += f.getCode()+",";//系统面料
				}else{
					strFabricMore += f.getCode()+",";//更多面料
				}
			}
		}
		strFabrics = dict.getExtension()+","+ strFabrics;
		String[] strFabric = strFabrics.split(",");
		String[] moreFabric = strFabricMore.split(",");
		int strLen = strFabric.length+moreFabric.length;
		for (int i=0;i<strFabric.length;i++) {
			int n = i+1;
			String strClassName="";
			String strCssi = "";
			String strCss = "style='width:32px;height:32px;border: 1px solid #e2e1e3;padding: 1px;margin-right:3px;background-color: #FFFFFF;cursor:pointer;'";
			if(i==0){//款式面料
				strClassName=" commom_class";
				strCssi = "style='display: block;'";
				strCss = "style='border: 2px solid #DF0001; width:32px;height:32px;padding: 1px;margin-right:3px;background-color: #FFFFFF;cursor:pointer;'";
				strHtml += "<td class='fabric_img'><img id='ml_img"+ n +"' src='../../fashionIMG/fabric/"+ strFabric[i] +".jpg'  "+ strCss +"" 
						+ " onclick=$.csFashion_post.changebg1('"+ strFabric[i] +"',"+ n +","+ strLen +") onmouseover='$.csFashion_post.mlOver("+ n +")' onmouseout='$.csFashion_post.mlOut("+ n +")' title='"+ strFabric[i] +"'/>" 
						+ "<i id='ml"+ n +"' class='ml "+ strClassName +"' "+ strCssi +"></i></td>";
			}else{//系统面料
				strHtml += "<td class='fabric_img'><img id='ml_img"+ n +"' src='../../process/fabric/"+ strFabric[i] +"_S.png'  "+ strCss +"" 
						+ " onclick=$.csFashion_post.changebg1('"+ strFabric[i] +"',"+ n +","+ strLen +") onmouseover='$.csFashion_post.mlOver("+ n +")' onmouseout='$.csFashion_post.mlOut("+ n +")' title='"+ strFabric[i] +"'/>" 
						+ "<i id='ml"+ n +"' class='ml "+ strClassName +"' "+ strCssi +"></i></td>";
			}
		}
		//更多面料
		if(strFabricMore.length()>0){
			strHtml += "<td id='more' onclick=$.csFashion_post.openFabric() valign='bottom' style='color: #5B0A0A; font-family: 微软雅黑;padding-left:10px;cursor: pointer;'> "+ResourceHelper.getValue("Label_FabricOpen")+" </td></tr></table>";
			
			strHtml += "<div id='more_fabric' style='width:300px; height:80px; overflow-y:scroll;display: none;margin-top: 5px;SCROLLBAR-FACE-COLOR: #fcfcfc; "
					+ " SCROLLBAR-HIGHLIGHT-COLOR: #6c6c90;  SCROLLBAR-SHADOW-COLOR: #fcfcfc;  SCROLLBAR-3DLIGHT-COLOR: #fcfcfc;  SCROLLBAR-ARROW-COLOR: #240024;  SCROLLBAR-TRACK-COLOR: #fcfcfc;  SCROLLBAR-DARKSHADOW-COLOR: #48486c; SCROLLBAR-BASE-COLOR: #fcfcfc '>"
					+ "<table cellspacing='0' width='225px'><tr>";
			for (int i=0;i<moreFabric.length;i++) {
				int n = i+strFabric.length+1;
				String strCss = "style='width:32px;height:32px;border: 1px solid #e2e1e3;padding: 1px;margin-right:3px;margin-top:3px;background-color: #FFFFFF;cursor:pointer;'";
				strHtml += "<td class='fabric_img'><img id='ml_img"+ n +"' src='../../process/fabric/"+ moreFabric[i] +"_S.png'  "+ strCss +"" 
						+ " onclick=$.csFashion_post.changebg1('"+ moreFabric[i] +"',"+ n +","+ strLen +") onmouseover='$.csFashion_post.mlOver("+ n +")' onmouseout='$.csFashion_post.mlOut("+ n +")' title='"+ moreFabric[i] +"'/>" 
						+ "<i id='ml"+ n +"' class='ml'></i></td>";
				//每7款面料一换行
				if(i>0){
					int m = (i+1)%7;
					if(m == 0){
						strHtml += "</tr><tr>";
					}
				}
			}
			strHtml += "</tr></table></div>";
		}
		return strHtml;
		
	}
	//根据款式id获取FashionDict
	@SuppressWarnings("unchecked")
	public FashionDict getFashionsByID(int nID){
		List<FashionDict> dicts = new ArrayList<FashionDict>();
		FashionDict dict = null;
		try {
			String hql = "SELECT fd FROM FashionDict fd WHERE fd.ID = ? ";
			Query query = DataAccessObject.openSession().createQuery(hql);
			query.setInteger(0, nID);
			dicts = (List<FashionDict>) query.list();
			if(dicts.size()>0){
				dict = dicts.get(0);
			}
			
		} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		} finally {
			DataAccessObject.closeSession();
		}
		
		return dict;
		
	}
	//根据款式号获取FashionDict
	@SuppressWarnings("unchecked")
	public FashionDict getFashionsByName(int nID,String strName){
		List<FashionDict> dicts = new ArrayList<FashionDict>();
		FashionDict dict = null;
		try {
			String hql = "SELECT fd FROM FashionDict fd WHERE fd.ParentID =? and fd.Name = ? ";
			Query query = DataAccessObject.openSession().createQuery(hql);
			query.setInteger(0, nID);
			query.setString(1, strName);
			dicts = (List<FashionDict>) query.list();
			if(dicts.size()>0){
				dict = dicts.get(0);
			}
			
		} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		} finally {
			DataAccessObject.closeSession();
		}
		
		return dict;
		
	}
	//获取默认工艺
	public String getDefaultProcess(int id){
		HttpContext.setSessionValue("SESSION_BXLB","");
		List<FashionDict> dicts = this.getFashionsByParentID(id);
		String strProcess = "";//默认工艺
		String strParam = "";//默认参数
		String strParamKh = "";//默认客户指定
		String strSelectProcess = "";//默认可选工艺
		String strBxlb ="";//版型类别
		for(FashionDict fd : dicts){
			if(!"".equals(fd.getExtension())){
				String[] strExtension = fd.getExtension().split(";");
				if(strExtension.length>1){
					strProcess += strExtension[0];
					strParam += strExtension[1];
					if(strExtension.length == 3){
						strParamKh += strExtension[2];
					}
				}else{
					strProcess += fd.getExtension();
				}
			}
			if(!"".equals(fd.getBxlb())){
				strBxlb += fd.getCode()+":"+fd.getBxlb()+",";
			}
			List<FashionDict> dict_clothing = this.getFashionsByParentID(fd.getID());
			for(FashionDict dc : dict_clothing){
				if(dc.getIsDefault() != null){
					strSelectProcess += dc.getIsDefault()+",";
				}
			}
		}
		String str = strProcess + strSelectProcess +";"+ strParam+";"+strParamKh;
		HttpContext.setSessionValue("SESSION_BXLB",strBxlb);
		return str;
	}
	
}