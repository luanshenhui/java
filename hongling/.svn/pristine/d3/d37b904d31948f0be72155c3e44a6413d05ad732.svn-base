package hongling.service.styleUI;

import java.util.ArrayList;
import java.util.List;
import hongling.business.StyleUIManager;
import hongling.entity.Assemble;
import hongling.entity.KitStyle;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.service.core.BaseServlet;

public class GetStyleByStyleID extends BaseServlet {
	private static final long serialVersionUID = -7892754396898316719L;
	@Override
	protected void service(HttpServletRequest request,
			HttpServletResponse response) {
		super.service();
		try {
			String strClothingID = getParameter("clothingID");//服装分类
			String styleID = getParameter("styleID");//款式风格
			String strStyle = getParameter("styleCode");//款式号
			String strLapel_xf = getParameter("lapel_xf");//西服驳头型
			String strButton_xf = getParameter("button_xf");//西服前门扣
			String strBleat_xk = getParameter("pleat_xk");//西裤裤褶
			String strLapel_mj = getParameter("lapel_mj");//马甲领型
			String strButton_mj = getParameter("button_mj");//马甲扣数
			String strLapel_cy = getParameter("lapel_cy");//衬衣领型
			String strLapel_dy = getParameter("lapel_dy");//大衣驳头型
			String strButton_dy = getParameter("button_dy");//大衣前门扣
			String xf = "";
			if(!"".equals(strLapel_xf)){
				xf = strLapel_xf +",";
			}
			if(!"".equals(strButton_xf)){
				xf += strButton_xf +",";
			}
			String mj = "";
			if(!"".equals(strLapel_mj)){
				mj = strLapel_mj +",";
			}
			if(!"".equals(strButton_mj)){
				mj += strButton_mj +",";
			}
			String dy = "";
			if(!"".equals(strLapel_dy)){
				dy = strLapel_dy +",";
			}
			if(!"".equals(strButton_dy)){
				dy += strButton_dy +",";
			}
			
			if(Utility.toSafeInt(strClothingID)>2){//单件
//				List<Assemble> assembles = new StyleUIManager().getAllAssemblesByClothingID(strClothingID,styleID,strStyle);
				List<Assemble> assembles = new StyleUIManager().getAllStyleByClothingID(strClothingID,styleID,strStyle);
				if("".equals(strLapel_xf) && "".equals(strButton_xf) && "".equals(strBleat_xk)
						 && "".equals(strLapel_mj) && "".equals(strButton_mj) && "".equals(strLapel_cy) 
						 && "".equals(strLapel_dy)&& "".equals(strButton_dy)){
					output(assembles);//服装类型、款式风格、款式号
				}else{//搜索工艺条件
					List<Assemble> assembleList = new ArrayList<Assemble>();
					for(Assemble assemble : assembles){
						if("3".equals(strClothingID) && !"".equals(xf)){
							String[] str = Utility.getStrArray(xf);
							int n = 0;
							for(int i=0; i<str.length; i++){
								if(Utility.contains(assemble.getProcess(), str[i])){
									n++;
								}
							}
							if(n == str.length){
								assembleList.add(assemble);
							}
						}else if("2000".equals(strClothingID) && !"".equals(strBleat_xk)){
							if(Utility.contains(assemble.getProcess(), strBleat_xk)){
								assembleList.add(assemble);
							}
						}else if("3000".equals(strClothingID) && !"".equals(strLapel_cy)){
							if(Utility.contains(assemble.getProcess(), strLapel_cy)){
								assembleList.add(assemble);
							}
						}else if("4000".equals(strClothingID) && !"".equals(mj)){
							String[] str = Utility.getStrArray(mj);
							int n = 0;
							for(int i=0; i<str.length; i++){
								if(Utility.contains(assemble.getProcess(), str[i])){
									n++;
								}
							}
							if(n == str.length){
								assembleList.add(assemble);
							}
						}else if("6000".equals(strClothingID) && !"".equals(dy)){
							String[] str = Utility.getStrArray(dy);
							int n = 0;
							for(int i=0; i<str.length; i++){
								if(Utility.contains(assemble.getProcess(), str[i])){
									n++;
								}
							}
							if(n == str.length){
								assembleList.add(assemble);
							}
						}
					}
					output(assembleList);
				}
			}else{//套装
				//服装类型、款式风格、款式号
				List<KitStyle> kitStyles = new StyleUIManager().getAllKitStylesByClothingID(strClothingID,strStyle,styleID);
				if("".equals(strLapel_xf) && "".equals(strButton_xf) && "".equals(strBleat_xk)
						 && "".equals(strLapel_mj) && "".equals(strButton_mj)){
					output(kitStyles);
				}else{//搜索工艺
					String pcs2 ="";
					if(!"".equals(strBleat_xk)){
						pcs2 = strBleat_xk+",";
					}
					if(!"".equals(xf)){
						pcs2 += xf;
					}
//					List<Assemble> assembless = new StyleUIManager().getAllAssemblesByClothingID("","","");
					List<Assemble> assembless = new StyleUIManager().getAllStyleByClothingID("","","");
					List<KitStyle> kitStyle = new ArrayList<KitStyle>();
					for(KitStyle style : kitStyles){
						for(Assemble assemble : assembless){
							if(Utility.contains(style.getCategoryID(), assemble.getCode())){
								if("1".equals(strClothingID)){//pcs2
									String[] str = Utility.getStrArray(pcs2);
									int n = 0;
									for(int i=0; i<str.length; i++){
										if(Utility.contains(assemble.getProcess(), str[i])){
											n++;
										}
									}
									if(n == str.length){
										for(KitStyle k : kitStyle){
											if(k.getCode() == style.getCode()){
												n=0;
											}
										}
										if(n>0){
											kitStyle.add(style);
										}
									}
								}else if("2".equals(strClothingID)){//pcs3
									String pcs3="";
									if(!"".equals(pcs2)){
										pcs3 = pcs2;
									}
									if(!"".equals(mj)){
										pcs3 += mj;
									}
									String[] str = Utility.getStrArray(pcs3);
									int n = 0;
									for(int i=0; i<str.length; i++){
										if(Utility.contains(assemble.getProcess(), str[i])){
											n++;
										}
									}
									if(n == str.length){
										for(KitStyle k : kitStyle){
											if(k.getCode() == style.getCode()){
												n=0;
											}
										}
										if(n>0){
											kitStyle.add(style);
										}
									}
								}
							}
						}
					}
					output(kitStyle);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			LogPrinter.debug("GetStyleByStyleID_err" + "----" + e.getMessage());
		}
	}
}
