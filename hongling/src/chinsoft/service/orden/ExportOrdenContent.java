package chinsoft.service.orden;

import java.io.OutputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.hibernate.Query;

import jxl.Workbook;
import jxl.format.UnderlineStyle;
import jxl.write.Colour;
import jxl.write.Label;
import jxl.write.WritableCellFormat;
import jxl.write.WritableFont;
import jxl.write.WritableSheet;
import jxl.write.WritableWorkbook;
import chinsoft.business.CDict;
import chinsoft.business.ClothingManager;
import chinsoft.business.DictManager;
import chinsoft.business.MemberManager;
import chinsoft.business.OrdenManager;
import chinsoft.business.SizeManager;
import chinsoft.business.XmlManager;
import chinsoft.core.DataAccessObject;
import chinsoft.core.ResourceHelper;
import chinsoft.core.Utility;
import chinsoft.entity.ClothingBodyType;
import chinsoft.entity.Dict;
import chinsoft.entity.Embroidery;
import chinsoft.entity.Member;
import chinsoft.entity.Orden;
import chinsoft.entity.OrdenDetail;
import chinsoft.entity.SizeStandard;
import chinsoft.service.core.BaseServlet;

public class ExportOrdenContent extends BaseServlet{
	
	private static final long serialVersionUID = 3941900143054890884L;

	@Override
	protected void service(HttpServletRequest request,HttpServletResponse response) {
		String strType = getParameter("type");
		if("print".equals(strType)){
			String strOrdenID = getParameter("ordenIds");
			Orden orden = this.getOrdenByID(strOrdenID);
			StringBuffer strHtml = new StringBuffer("");
			//标题
			strHtml.append("<table width=1100><tr align='center' style='font-weight:bold;font-size:18px;'><td colspan='3'>");strHtml.append(ResourceHelper.getValue("Common_MTMorden"));strHtml.append("<td></tr>");
			//订单日期、 计划交期 、量体人员
			String strPubDate = ResourceHelper.getValue("Orden_PubDate")+"："+orden.getPubDate();
			strHtml.append("<tr align='left'><td>");strHtml.append(strPubDate);strHtml.append("</td>");
			String strJhrq =Utility.toSafeString(orden.getJhrq())==null?"":Utility.toSafeString(orden.getJhrq());
			strHtml.append("<td>");strHtml.append(ResourceHelper.getValue("Orden_DealDate")+"：");strHtml.append(strJhrq);strHtml.append("</td>");
			String LtName =orden.getCustomer().getLtName()==null?"":orden.getCustomer().getLtName();
			strHtml.append("<td>");strHtml.append(ResourceHelper.getValue("Customer_LtName")+"：");strHtml.append(LtName);strHtml.append("</td></tr></table>");
			//左部分
			strHtml.append("<div style='float:left;'>");
			//客户信息
			//系统号
			strHtml.append("<table border=1><tr align='center'><td>");strHtml.append(ResourceHelper.getValue("Orden_SysCode"));strHtml.append("</td><td>");strHtml.append(orden.getSysCode());strHtml.append("</td></tr>");
			//订单号
			strHtml.append("<tr align='center'><td>");strHtml.append(ResourceHelper.getValue("Fabric_ysddh"));strHtml.append("</td><td>");strHtml.append(orden.getOrdenID());strHtml.append("</td></tr>");
			//客户订单号
			strHtml.append("<tr align='center'><td>");strHtml.append(ResourceHelper.getValue("Customer_No"));strHtml.append("</td><td>");strHtml.append(orden.getUserordeNo()==null?"":orden.getUserordeNo());strHtml.append("</td></tr>");
			//客户名
			strHtml.append("<tr align='center'><td>");strHtml.append(ResourceHelper.getValue("Cash_MemberName"));strHtml.append("</td><td>");strHtml.append(orden.getCustomer().getName());strHtml.append("</td></tr>");
			//性别
			strHtml.append("<tr align='center'><td>");strHtml.append(ResourceHelper.getValue("Common_Gender"));strHtml.append("</td><td>");strHtml.append(orden.getCustomer().getGenderName());strHtml.append("</td></tr>");
			//年龄
			strHtml.append("<tr align='center'><td>");strHtml.append(ResourceHelper.getValue("Common_Age"));strHtml.append("</td><td></td></tr>");
			//身高
			strHtml.append("<tr align='center'><td>");strHtml.append(ResourceHelper.getValue("Customer_Height"));strHtml.append("</td><td>");strHtml.append(Utility.toSafeString(orden.getCustomer().getHeight()));strHtml.append("</td></tr>");
			//体重
			strHtml.append("<tr align='center'><td>");strHtml.append(ResourceHelper.getValue("Customer_Weight"));strHtml.append("</td><td>");strHtml.append(Utility.toSafeString(orden.getCustomer().getWeight()));strHtml.append("</td></tr>");
			//量体信息
			strHtml.append("<tr align='center'><td>");strHtml.append(ResourceHelper.getValue("Size_Part"));strHtml.append("</td><td>");strHtml.append(ResourceHelper.getValue("Dict_10052"));strHtml.append("</td></tr>");
			if(orden.getSizeCategoryID() == 10052){//量体
		    	String[] sizeStandards =Utility.getStrArray(orden.getSizePartValues());
		    	for(String sizeStandard : sizeStandards){
		    		if(sizeStandard.contains(":")){
			    		String[] size = sizeStandard.split(":");
			    		strHtml.append("<tr align='center'><td>");strHtml.append(DictManager.getDictNameByID(Utility.toSafeInt(size[0])));strHtml.append("</td><td>");
			    		if(size.length>1){
			    			 strHtml.append(Utility.toSafeString(size[1]));strHtml.append("</td></tr>");
			    		}else{
			    			strHtml.append("</td></tr>");
			    		}
		    		}
		    	}
		    }else{//成衣、标准号
		    	String sizeStandards ="";
		    	for(OrdenDetail od : orden.getOrdenDetails()){
		    		if(orden.getClothingID()==2 && od.getSingleClothingID()!=4000){
		    			sizeStandards += this.getSizePartName(orden, od.getSingleClothingID(),10052,-1,"undefined");
		    		}else if(orden.getClothingID()!=2){
		    			sizeStandards += this.getSizePartName(orden, od.getSingleClothingID(),10052,-1,"undefined");
		    		}
		    	}
		    	String[] sizeStandard = Utility.getStrArray(sizeStandards);
		    	for(String size :sizeStandard){
		    		String[] sizeName = size.split(":");
				    strHtml.append("<tr align='center'><td>");strHtml.append(sizeName[1]);strHtml.append("</td><td></td></tr>");
		    	}
		    }
			//体型信息
			strHtml.append("<tr align='center'><td colspan='2'>");strHtml.append(ResourceHelper.getValue("Size_BodyType"));strHtml.append("</td></tr>");
			SizeManager size = new SizeManager();
		    int sizeCategouryID = orden.getSizeCategoryID();
		    if(orden.getSizeCategoryID() == 10054){
		    	sizeCategouryID = 10053;
		    }
	    	List<ClothingBodyType> clothingBodyType =size.getClotingBodyType(orden.getClothingID(), sizeCategouryID);
		    if(clothingBodyType.size()>0){
		    	String[] strBodyTypes = {};
		    	if(orden.getSizeBodyTypeValues() != null){
		    		strBodyTypes = Utility.getStrArray(orden.getSizeBodyTypeValues());
		    	}
		    	for(ClothingBodyType cbt : clothingBodyType){
		    		if(cbt.getBodyTypes().size()>0){
		    			if(cbt.getCategoryID()==32){//正常款、长款、短款
		    				strHtml.append("<tr align='center'><td>");strHtml.append(cbt.getCategoryName());strHtml.append("</td><td>");strHtml.append(orden.getStyleName());strHtml.append("</td></tr>");
			    		}else{//特体
			    			List<Dict> dicts = cbt.getBodyTypes();
		    				int j=0;
		    				for(Dict dict : dicts){
				    			for(String strBodyType : strBodyTypes){
				    				if(strBodyType.equals(Utility.toSafeString(dict.getID()))){
				    					j++;
									    strHtml.append("<tr align='center'><td>");strHtml.append(cbt.getCategoryName());strHtml.append("</td><td>");strHtml.append(dict.getName());strHtml.append("</td></tr>");
					    			}
				    			}
				    		}
				    		if(j==0){
				    			strHtml.append("<tr align='center'><td>");strHtml.append(cbt.getCategoryName());strHtml.append("</td><td>");strHtml.append(dicts.get(0).getName());strHtml.append("</td></tr>");
				    		}
			    		}
		    		}
		    	}
		    	if(orden.getSizeBodyTypeValues() == null){//正常款、长款、短款
		    		strHtml.append("<tr align='center'><td>");strHtml.append(ResourceHelper.getValue("DictCategory_32"));strHtml.append("</td><td>");strHtml.append(DictManager.getDictNameByID(20100));strHtml.append("</td></tr>");
		    	}
		    }
		    
			//历史订单
			strHtml.append("<tr><td colspan='2'>");strHtml.append(ResourceHelper.getValue("Common_OrderHistory"));strHtml.append(":</td></tr>");
			//备注
			strHtml.append("<tr><td colspan='2'>");strHtml.append(ResourceHelper.getValue("Cash_Memo"));strHtml.append(":</td></tr></table>");
			strHtml.append("</div><div style='float:left;'>");
			//右部分
			//订单公共信息
			String interliningType=CDict.InterliningType;//半毛衬
	        for(OrdenDetail od : orden.getOrdenDetails()){
				strHtml.append("<table width=800 border=1>");
				strHtml.append("<tr><td  align='center'>");strHtml.append(ResourceHelper.getValue("Fabric_Code"));strHtml.append("</td>");//面料号
				strHtml.append("<td  align='center'>");strHtml.append(ResourceHelper.getValue("Common_Category"));strHtml.append("</td>");//大类
				strHtml.append("<td  align='center'>");strHtml.append(ResourceHelper.getValue("Size_Style"));strHtml.append("</td>");//款式
				strHtml.append("<td  align='center'>");strHtml.append(ResourceHelper.getValue("Dict_435"));strHtml.append("</td>");//工艺类型
				strHtml.append("<td  align='center'>");strHtml.append(ResourceHelper.getValue("Common_Count"));strHtml.append("</td>");//数量
				strHtml.append("<td  align='center'>");strHtml.append(ResourceHelper.getValue("Common_Shape"));strHtml.append("</td>");//号型
				strHtml.append("<td  align='center'>");strHtml.append(ResourceHelper.getValue("Dict_31"));strHtml.append("</td></tr>");//版型要求
				
				strHtml.append("<tr><td  align='center'>");strHtml.append(orden.getFabricCode());strHtml.append("</td>");//面料
				strHtml.append("<td  align='center'>");strHtml.append(od.getSingleClothingName());strHtml.append("</td>");//大类
			    String strKSH = "";
			    Dict dictClothing =DictManager.getDictByID(od.getSingleClothingID());
			    if(orden.getComponentTexts() != null && !"".equals(orden.getComponentTexts())){
					String[] strComponentTexts = orden.getComponentTexts().split(",");
					for(int i=1;i<strComponentTexts.length;i++){
						String[] ComponentText = strComponentTexts[i].split(":");
						Dict dict =DictManager.getDictByID(Utility.toSafeInt((ComponentText[0])));
						if(dict != null){
							String strCode =dict.getCode().substring(0, 4);
							String[] strStyle = CDict.STYLENUM.split(",");
							for(int j=0;j<strStyle.length;j++){
								if(strStyle[j].equals(ComponentText[0]) && strCode.equals(dictClothing.getCode())){
									strKSH = ComponentText[1];
									break;
								}
							}
						}
					}
				}
			    strHtml.append("<td  align='center'>");strHtml.append(strKSH);strHtml.append("</td>");//款式号
			    interliningType= this.getInterliningType(od.getSingleClothingID(),orden.getComponents(),orden,interliningType);
			    strHtml.append("<td  align='center'>");strHtml.append(interliningType);strHtml.append("</td>");//工艺类型
			    strHtml.append("<td  align='center'>");strHtml.append(Utility.toSafeString(od.getAmount()));strHtml.append("</td>");//数量
			    strHtml.append("<td></td>");//号型
			    String strBX =ResourceHelper.getValue("Common_Normal");//正常
			    if(orden.getComponents() != null && !"".equals(orden.getComponents())){
			    	String[] strDicts = Utility.getStrArray(orden.getComponents());
			    	for(String strDict : strDicts){
			    		Dict dict = DictManager.getDictByID(Utility.toSafeInt(strDict));
			    		if(dict !=null){
			    			String strCode =dict.getCode().substring(0, 4);
							String[] strBxlb = CDict.BXLB.split(",");
							for(int j=0;j<strBxlb.length;j++){
								if(Utility.toSafeString(strBxlb[j]).equals(Utility.toSafeString(dict.getID()))
										&& strCode.equals(dictClothing.getCode())){
									strBX = dict.getEcode();
									break;
								}
							}
			    		}
			    	}
			    }
			    String styles = orden.getComponentTexts();
				if(!"".equals(styles) && styles != null){
					String[] style = styles.split(",");
					for(int i=0;i<style.length;i++){
						String[] clothingstyle = style[i].split(":");
						if(Utility.toSafeString(od.getSingleClothingID()).equals(clothingstyle[0]) && clothingstyle.length>1){
							strBX += " " +DictManager.getDictNamesByIDs(clothingstyle[1]);
						}
					}
				}
				strHtml.append("<td  align='center'>");strHtml.append(strBX);strHtml.append("</td></tr>");//版型
				strHtml.append("</table>");
				//刺绣信息
				int i=0;
				for(Embroidery enbroidery : od.getEmberoidery()){
					strHtml.append("<table width=800 border=1>");
					strHtml.append("<tr><td  align='center'>");strHtml.append(ResourceHelper.getValue("Dict_4150"));strHtml.append("</td>");//刺绣颜色
					strHtml.append("<td  align='center'>");strHtml.append(ResourceHelper.getValue("Dict_4155"));strHtml.append("</td>");//字体
					strHtml.append("<td  align='center'>");strHtml.append(ResourceHelper.getValue("Embroid_Position"));strHtml.append("</td>");//位置
					strHtml.append("<td  align='center'>");strHtml.append(ResourceHelper.getValue("Common_Content"));strHtml.append("</td>");//内容
					if(i == 0){
						strHtml.append("<td  align='center'>");strHtml.append(ResourceHelper.getValue("Dict_1993"));strHtml.append("</td></tr>");//半成品试衣
					}
					strHtml.append("<tr><td  align='center'>");strHtml.append(enbroidery.getColor()==null?"":enbroidery.getColor().getName());strHtml.append("</td>");//刺绣颜色
					strHtml.append("<td  align='center'>");strHtml.append(enbroidery.getFont()==null?"":enbroidery.getFont().getName());strHtml.append("</td>");//字体
					strHtml.append("<td  align='center'>");strHtml.append(enbroidery.getLocation()==null?"":enbroidery.getLocation().getName());strHtml.append("</td>");//位置
					strHtml.append("<td  align='center'>");strHtml.append(enbroidery.getContent()==null?"":enbroidery.getContent());strHtml.append("</td>");//内容
				    if(i == 0){
						String strBCP =ResourceHelper.getValue("Dict_246");//否
						if(orden.getComponents() != null && !"".equals(orden.getComponents())){
					    	String[] strDicts = Utility.getStrArray(orden.getComponents());
					    	for(String strDict : strDicts){
					    		if(strDict.indexOf("_")>0){
					    			continue;
					    		}
				    			Dict dict = DictManager.getDictByID(Utility.toSafeInt(strDict));
				    			if(dict != null){
				    				String strCode =dict.getCode().substring(0, 4);
						    		//半成品试衣
									String[] strBcpsy = CDict.BCPSY.split(",");
									for(int j=0;j<strBcpsy.length;j++){
										if(Utility.toSafeString(strBcpsy[j]).equals(Utility.toSafeString(dict.getID()))
												&& strCode.equals(dictClothing.getCode())){
											strBCP =ResourceHelper.getValue("Dict_245");//是
											break;
										}
									}
				    			}
					    	}
					    }
						strHtml.append("<td  align='center'>");strHtml.append(strBCP);strHtml.append("</td></tr>");//半成品试衣
				    }
				    strHtml.append("</table>");
				    i++;
			    }
				//成衣尺寸、标准号
				strHtml.append("<table width=800 border=1>");
				int m=1,n=1;
				strHtml.append("<tr>");//空值
			    String[] strBodyTypes = Utility.getStrArray(orden.getSizePartValues());
			    if(orden.getSizeCategoryID() == 10052){
			    	String sizeStandards = this.getSizePartName(orden, od.getSingleClothingID(),10052,-1,"undefined");
			    	String[] sizeStandard = Utility.getStrArray(sizeStandards);
			    	for(String sizes :sizeStandard){
			    		m++;
			    		String[] sizeName = sizes.split(":");
					    strHtml.append("<td  align='center'>");strHtml.append(sizeName[1]);strHtml.append("</td>");
			    	}
			    	strHtml.append("</tr>");
			    	
			    	strHtml.append("<tr>");//空值
			    	for(String sizes :sizeStandard){
			    		n++;
		    			strHtml.append("<td>&nbsp;</td>");
			    	}
			    	strHtml.append("</tr>");
			    }else{
			    	String strSpecHeight="undefined";
			    	int nAreaID =-1;
			    	if(orden.getSizeCategoryID()==10054){
			    		strSpecHeight=od.getSpecHeight();
			    		nAreaID = orden.getSizeAreaID();
			    	}
			    	strHtml.append("<tr>");//部位
			    	String sizeStandards = this.getSizePartName(orden, od.getSingleClothingID(),orden.getSizeCategoryID(),nAreaID,strSpecHeight);
			    	String[] sizeStandard = Utility.getStrArray(sizeStandards);
			    	for(String sizes :sizeStandard){
			    		String[] sizeID = sizes.split(":");
			    		for(String strBodyType :strBodyTypes){
			    			String[] strBT = strBodyType.split(":");
	    					if(sizeID[0].equals(strBT[0])){
			    				m++;
			    				strHtml.append("<td  align='center'>");strHtml.append(sizeID[1]);strHtml.append("</td>");
			    			}
		    				
			    		}
			    	}
			    	strHtml.append("</tr>");
			    	
			    	strHtml.append("<tr>");//值
			    	for(String sizes :sizeStandard){
			    		String[] sizeID = sizes.split(":");
			    		for(String strBodyType :strBodyTypes){
			    			String[] strBT = strBodyType.split(":");
			    			if((orden.getClothingID()==1 || orden.getClothingID()==2) && od.getSingleClothingID()==2000 && "10108".equals(Utility.toSafeString(sizeID[0]))){
			    				if(strBodyType.indexOf(":")<0){
			    					n++;
				    				strHtml.append("<td  align='center'>");strHtml.append(strBodyType);strHtml.append("</td>");
			    				}
		    				}else{
		    					if(sizeID[0].equals(strBT[0])){
				    				n++;
			    					if(strBT.length>1){
				    					strHtml.append("<td  align='center'>");strHtml.append(strBT[1]);strHtml.append("</td>");
				    				}else{
				    					strHtml.append("<td>&nbsp;</td>");
				    				}
				    			}
		    				}
			    		}
			    	}
			    	strHtml.append("</tr>");
			    	
			    }
				strHtml.append("</table>");
				//工艺要求
				strHtml.append("<table width=800>");
				strHtml.append("<tr align='left'><td colspan='3'>");strHtml.append(ResourceHelper.getValue("Process_Info"));strHtml.append("：<td></tr><tr align='left'>");//工艺要求
				List<Dict> ordersProcessList =new  ClothingManager().getOrderProcess(orden, od.getSingleClothingID());
				String strProcess="";
				for(Dict ordersProcess :ordersProcessList){
					Dict dictParent =  DictManager.getDictByID(ordersProcess.getParentID());
					if(dictParent!= null){
						if(dictParent.getEcode() != null && !"".equals(dictParent.getEcode())){//扣子、锁眼线色、里料等
							strProcess += dictParent.getEcode()+"-"+ordersProcess.getEcode()+":"+dictParent.getName()+"-"+ordersProcess.getName()+",";
						}else{//客户指定工艺
							if(ordersProcess.getStatusID() != null && ordersProcess.getStatusID().equals(CDict.ComponentText.getID())){
								strProcess +=ordersProcess.getEcode()+":"+ordersProcess.getName()+"-"+ordersProcess.getMemo()+",";//客户指定内容
							}else{
								strProcess +=ordersProcess.getEcode()+":"+ ordersProcess.getName()+",";
							}
						}
					}
					
				}
			    String[] strOrdenProcess = Utility.getStrArray(strProcess);
			    int g=0;
			    if(strOrdenProcess.length>0){
			    	for(String sProcess : strOrdenProcess){
			    		g++;
			    		if((g-1)%3 == 0){
				    		strHtml.append("<tr align='left'><td>");strHtml.append(sProcess);strHtml.append("</td>");
			    		}else if(g%3 == 0){
				    		strHtml.append("<td>");strHtml.append(sProcess);strHtml.append("</td></tr>");
			    		}else{
				    		strHtml.append("<td>");strHtml.append(sProcess);strHtml.append("</td>");
			    		}
			    	}
			    }
				//特殊工艺
				strHtml.append("</tr><tr align='left'><td colspan='3'  style='border-top:1px; border-bottom:1px;'>");strHtml.append(ResourceHelper.getValue("Common_SpecialProcess"));strHtml.append(":</td></tr></table>");
	        }
	        strHtml.append("</div>");
			output(strHtml.toString());
		}else{
			try
		    {
		    OutputStream os = response.getOutputStream();// 取得输出流  
	        response.reset();// 清空输出流  
	        String filename = "Order "+ new SimpleDateFormat("yyyy-MM-dd").format(new Date())+".xls";
	        response.setHeader("Content-disposition", "attachment; filename="+filename);// 设定输出文件头  
	        response.setContentType("application/msexcel");// 定义输出类型
	       
	        WritableWorkbook wbook = Workbook.createWorkbook(os); // 建立excel文件  
	        
		    String[] strOrdenIDs = Utility.getStrArray(getParameter("ordenIds"));
			for(String strOrdenID : strOrdenIDs){
				Orden orden = this.getOrdenByID(strOrdenID);
				WritableSheet wsheet = wbook.createSheet(strOrdenID, 0); // sheet名称
	        
//	        WritableSheet wsheet = wbook.createSheet(ResourceHelper.getValue("Common_MTMorden"), 0); // sheet名称 --MTM内部订单
	        
		           
		    // 设置excel标题  
		    WritableFont wfont = new WritableFont(WritableFont.ARIAL, 16,WritableFont.BOLD,
		                           false,UnderlineStyle.NO_UNDERLINE,Colour.BLACK);  
		    WritableCellFormat wcfFC = new WritableCellFormat(wfont);
//		    wcfFC.setBackground(Colour.AQUA);//标题背景
		    wcfFC.setAlignment(jxl.format.Alignment.CENTRE);//横向居中
		    wcfFC.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);//垂直居中
		    wsheet.mergeCells(0, 0, 15, 0);//开始列，开始行，结束列，结束行
		    wsheet.setRowView(0, 600);
		    wsheet.addCell(new Label(0, 0, ResourceHelper.getValue("Common_MTMorden"), wcfFC));//标题  --MTM内部订单
		    
//		    String[] strOrdenIDs = Utility.getStrArray(getParameter("ordenIds"));
//			for(String strOrdenID : strOrdenIDs){
//				Orden orden = this.getOrdenByID(strOrdenID);
					// 开始生成主体内容   --- 订单时间      
				    wfont = new jxl.write.WritableFont(WritableFont.ARIAL, 10,WritableFont.NO_BOLD,
				                       false, UnderlineStyle.NO_UNDERLINE,Colour.BLACK);  
				    WritableCellFormat wcfFW = new WritableCellFormat(wfont);
				    String strPubDate = ResourceHelper.getValue("Orden_PubDate")+"："+orden.getPubDate();//订单日期
				    wsheet.addCell(new Label(0, 1, strPubDate, wcfFW)); 
				    String strJhrq =Utility.toSafeString(orden.getJhrq())==null?"":Utility.toSafeString(orden.getJhrq());
				    wsheet.addCell(new Label(6, 1, ResourceHelper.getValue("Orden_DealDate")+"："+strJhrq, wcfFW)); //计划交期 
				    String LtName =orden.getCustomer().getLtName()==null?"":orden.getCustomer().getLtName();
				    wsheet.addCell(new Label(13, 1, ResourceHelper.getValue("Customer_LtName")+"："+LtName, wcfFW));//量体人员
				    
				    // 开始生成主体内容  --- 客户信息
				    WritableFont wfont1 = new jxl.write.WritableFont(WritableFont.ARIAL, 10,WritableFont.NO_BOLD,
		                    false, UnderlineStyle.NO_UNDERLINE,Colour.BLACK);  
				    WritableCellFormat wcfFX = new WritableCellFormat(wfont1);
				    wcfFX.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN); 
				    wcfFX.setAlignment(jxl.format.Alignment.CENTRE);//横向居中
				    wcfFX.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);//垂直居中
				    wsheet.setColumnView(0, 10);
				    wsheet.setColumnView(1, 15);
				    wsheet.addCell(new Label(0, 2, ResourceHelper.getValue("Fabric_ysddh"), wcfFX));//订单号
				    wsheet.addCell(new Label(1, 2, orden.getOrdenID(), wcfFX));
				    wsheet.addCell(new Label(0, 3, ResourceHelper.getValue("Orden_SysCode"), wcfFX));//系统订单号
				    wsheet.addCell(new Label(1, 3, orden.getSysCode(), wcfFX));
				    wsheet.addCell(new Label(0, 4, ResourceHelper.getValue("Customer_No"), wcfFX));//客户订单号
				    wsheet.addCell(new Label(1, 4, orden.getUserordeNo()==null?"":orden.getUserordeNo(), wcfFX));
				    wsheet.addCell(new Label(0, 5, ResourceHelper.getValue("Cash_MemberName"), wcfFX));//客户名
				    wsheet.addCell(new Label(1, 5, orden.getCustomer().getName(), wcfFX));
				    wsheet.addCell(new Label(0, 6, ResourceHelper.getValue("Common_Gender"), wcfFX));//性别
				    wsheet.addCell(new Label(1, 6, orden.getCustomer().getGenderName(), wcfFX));
				    wsheet.addCell(new Label(0, 7, ResourceHelper.getValue("Common_Age"), wcfFX));//年龄
				    wsheet.addCell(new Label(1, 7, "", wcfFX));
				    wsheet.addCell(new Label(0, 8, ResourceHelper.getValue("Customer_Height"), wcfFX));//身高
				    wsheet.addCell(new Label(1, 8, Utility.toSafeString(orden.getCustomer().getHeight()), wcfFX));
				    wsheet.addCell(new Label(0, 9, ResourceHelper.getValue("Customer_Weight"), wcfFX));//体重
				    wsheet.addCell(new Label(1, 9, Utility.toSafeString(orden.getCustomer().getWeight()), wcfFX));
				    // 开始生成主体内容  --- 净体量体信息
				    wsheet.addCell(new Label(0, 10, ResourceHelper.getValue("Size_Part"), wcfFX));//量体部位
				    wsheet.addCell(new Label(1, 10, ResourceHelper.getValue("Dict_10052"), wcfFX));//净尺寸
				    int num =0;
				    if(orden.getSizeCategoryID() == 10052){//量体
				    	String[] sizeStandards =Utility.getStrArray(orden.getSizePartValues());
				    	int i=0;
				    	for(String sizeStandard : sizeStandards){
				    		if(sizeStandard.contains(":")){
				    			i++;
					    		String[] size = sizeStandard.split(":");
					    		wsheet.addCell(new Label(0, 10+i, DictManager.getDictNameByID(Utility.toSafeInt(size[0])), wcfFX));
					    		if(size.length>1){
					    			 wsheet.addCell(new Label(1, 10+i, Utility.toSafeString(size[1]), wcfFX));
					    		}else{
					    			wsheet.addCell(new Label(1, 10+i, "", wcfFX));
					    		}
							    num = 10+i;
				    		}
				    	}
				    }else{//成衣、标准号
				    	String sizeStandards ="";
				    	for(OrdenDetail od : orden.getOrdenDetails()){
				    		if(orden.getClothingID()==2 && od.getSingleClothingID()!=4000){
				    			sizeStandards += this.getSizePartName(orden, od.getSingleClothingID(),10052,-1,"undefined");
				    		}else if(orden.getClothingID()!=2){
				    			sizeStandards += this.getSizePartName(orden, od.getSingleClothingID(),10052,-1,"undefined");
				    		}
				    	}
				    	String[] sizeStandard = Utility.getStrArray(sizeStandards);
				    	int i=0;
				    	for(String size :sizeStandard){
				    		i++;
				    		String[] sizeName = size.split(":");
				    		wsheet.addCell(new Label(0, 10+i, sizeName[1], wcfFX));
						    wsheet.addCell(new Label(1, 10+i, "", wcfFX));
						    num = 9+i;
				    	}
				    }
				    
				    // 开始生成主体内容  --- 体型信息
				    wsheet.mergeCells(0, num+1, 1, num+1);//开始列，开始行，结束列，结束行
				    wsheet.addCell(new Label(0, num+1, ResourceHelper.getValue("Size_BodyType"), wcfFX));//体型
				    SizeManager size = new SizeManager();
				    int sizeCategouryID = orden.getSizeCategoryID();
				    if(orden.getSizeCategoryID() == 10054){
				    	sizeCategouryID = 10053;
				    }
				    /*配件无特体信息导致格式混乱 暂时改为西服特体代替*/
				    int clothing = orden.getClothingID();
				    if("5000".equals(orden.getClothingID().toString())){
				    	clothing =3;
				    }
			    	List<ClothingBodyType> clothingBodyType =size.getClotingBodyType(clothing, sizeCategouryID);
			    	int n =0;
				    if(clothingBodyType.size()>0){
				    	String[] strBodyTypes = {};
				    	if(orden.getSizeBodyTypeValues() != null){
				    		strBodyTypes = Utility.getStrArray(orden.getSizeBodyTypeValues());
				    	}
				    	int i=num+1;
				    	for(ClothingBodyType cbt : clothingBodyType){
				    		if(cbt.getBodyTypes().size()>0){
				    			i++;
				    			if(cbt.getCategoryID()==32){//正常款、长款、短款
			    					 wsheet.addCell(new Label(0, i, cbt.getCategoryName(), wcfFX));
			    					 wsheet.addCell(new Label(1, i, orden.getStyleName(), wcfFX));
					    		}else{//特体
					    			List<Dict> dicts = cbt.getBodyTypes();
				    				int j=0;
				    				for(Dict dict : dicts){
						    			for(String strBodyType : strBodyTypes){
						    				if(strBodyType.equals(Utility.toSafeString(dict.getID()))){
						    					j++;
						    					wsheet.addCell(new Label(0, i, cbt.getCategoryName(), wcfFX));
											    wsheet.addCell(new Label(1, i, dict.getName(), wcfFX));
							    			}
						    			}
						    		}
						    		if(j==0){
						    			wsheet.addCell(new Label(0, i, cbt.getCategoryName(), wcfFX));
									    wsheet.addCell(new Label(1, i, dicts.get(0).getName(), wcfFX));
						    		}
					    		}
				    			n=i;
				    		}
				    	}
				    	if(orden.getSizeBodyTypeValues() == null){//正常款、长款、短款
				    		 n=n+1;
		   					 wsheet.addCell(new Label(0, n, ResourceHelper.getValue("DictCategory_32"), wcfFX));
		   					 wsheet.addCell(new Label(1, n, DictManager.getDictNameByID(20100), wcfFX));
				    	}
				    }
				    
				    WritableFont wfont2 = new jxl.write.WritableFont(WritableFont.ARIAL, 10,WritableFont.NO_BOLD,
		                    false, UnderlineStyle.NO_UNDERLINE,Colour.BLACK);  
				    WritableCellFormat wcfFS = new WritableCellFormat(wfont2);
				    wcfFS.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN); 
				    wcfFS.setVerticalAlignment(jxl.format.VerticalAlignment.TOP);//垂直居中
				    // 开始生成主体内容  --- 历史订单
				    wsheet.mergeCells(0, n+1, 1, n+2);//开始列，开始行，结束列，结束行
				    wsheet.addCell(new Label(0, n+1, ResourceHelper.getValue("Common_OrderHistory")+"：",wcfFS));//历史订单
				    // 开始生成主体内容  --- 备注
				    wsheet.mergeCells(0, n+3, 1, n+4);//开始列，开始行，结束列，结束行
			        wsheet.addCell(new Label(0, n+3, ResourceHelper.getValue("Cash_Memo")+"：",wcfFS));//备注
			        int zt = 2;
				    int nZT = zt;
//				    String interliningType=CDict.InterliningType;//半毛衬
				    Member member = new MemberManager().getMemberByID(orden.getPubMemberID());
					String interliningType = member.getLiningType();//默认衬类型
			        for(OrdenDetail od : orden.getOrdenDetails()){
			        	// 开始生成主体内容  --- 公共信息
			        	nZT = zt;
					    wsheet.mergeCells(2, nZT, 3, nZT);//开始列，开始行，结束列，结束行
					    wsheet.addCell(new Label(2, nZT, ResourceHelper.getValue("Fabric_Code"), wcfFX));//面料号
					    wsheet.mergeCells(4, nZT, 5, nZT);
					    wsheet.addCell(new Label(4, nZT, ResourceHelper.getValue("Common_Category"), wcfFX));//大类
					    wsheet.mergeCells(6, nZT, 7, nZT);
					    wsheet.addCell(new Label(6, nZT, ResourceHelper.getValue("Size_Style"), wcfFX));//款式
					    wsheet.mergeCells(8, nZT, 9, nZT);
					    wsheet.addCell(new Label(8, nZT, ResourceHelper.getValue("Dict_435"), wcfFX));//工艺类型
					    wsheet.mergeCells(10, nZT, 11, nZT);
					    wsheet.addCell(new Label(10, nZT, ResourceHelper.getValue("Common_Count"), wcfFX));//数量
					    wsheet.mergeCells(12, nZT, 13, nZT);
					    wsheet.addCell(new Label(12, nZT, ResourceHelper.getValue("Common_Shape"), wcfFX));//号型
					    wsheet.mergeCells(14, nZT, 15, nZT);
					    wsheet.addCell(new Label(14, nZT, ResourceHelper.getValue("Dict_31"), wcfFX));//版型要求
					    
					    wsheet.mergeCells(2, nZT+1, 3, nZT+1);
					    wsheet.addCell(new Label(2, nZT+1, orden.getFabricCode(), wcfFX));//面料
					    
					    wsheet.mergeCells(4, nZT+1, 5, nZT+1);
					    wsheet.addCell(new Label(4, nZT+1, od.getSingleClothingName(), wcfFX));//大类
					    
					    wsheet.mergeCells(6, nZT+1, 7, nZT+1);
					    String strKSH = "";
					    Dict dictClothing =DictManager.getDictByID(od.getSingleClothingID());
					    if(orden.getComponentTexts() != null && !"".equals(orden.getComponentTexts())){
							String[] strComponentTexts = orden.getComponentTexts().split(",");
							for(int i=1;i<strComponentTexts.length;i++){
								String[] ComponentText = strComponentTexts[i].split(":");
								Dict dict =DictManager.getDictByID(Utility.toSafeInt((ComponentText[0])));
								String strCode =dict.getCode().substring(0, 4);
								String[] strStyle = CDict.STYLENUM.split(",");
								for(int j=0;j<strStyle.length;j++){
									if(strStyle[j].equals(ComponentText[0]) && strCode.equals(dictClothing.getCode())){
										strKSH = ComponentText[1];
										break;
									}
								}
							}
						}
					    wsheet.addCell(new Label(6, nZT+1, strKSH, wcfFX));//款式号
					    
					    wsheet.mergeCells(8, nZT+1, 9, nZT+1);

					    interliningType= this.getInterliningType(od.getSingleClothingID(),orden.getComponents(),orden,interliningType);
					    wsheet.addCell(new Label(8, nZT+1, interliningType, wcfFX));//工艺类型
					    
					    wsheet.mergeCells(10, nZT+1, 11, nZT+1);
					    wsheet.addCell(new Label(10, nZT+1, Utility.toSafeString(od.getAmount()), wcfFX));//数量
					    
					    wsheet.mergeCells(12, nZT+1, 13, nZT+1);
					    wsheet.addCell(new Label(12, nZT+1, "", wcfFX));//号型
					    
					    wsheet.mergeCells(14, nZT+1, 15, nZT+1);
					    String strBX =ResourceHelper.getValue("Common_Normal");//正常
					    if(orden.getComponents() != null && !"".equals(orden.getComponents())){
					    	String[] strDicts = Utility.getStrArray(orden.getComponents());
					    	for(String strDict : strDicts){
					    		if(strDict.indexOf("_")>0 || "".equals(strDict)){
					    			continue;
					    		}
				    			Dict dict = DictManager.getDictByID(Utility.toSafeInt(strDict));
					    		String strCode =dict.getCode().substring(0, 4);
								String[] strBxlb = CDict.BXLB.split(",");
								for(int j=0;j<strBxlb.length;j++){
									if(Utility.toSafeString(strBxlb[j]).equals(Utility.toSafeString(dict.getID()))
											&& strCode.equals(dictClothing.getCode())){
										strBX = dict.getEcode();
										break;
									}
								}
					    		
					    	}
					    }
					    String styles = orden.getComponentTexts();
						if(!"".equals(styles) && styles != null){
							String[] style = styles.split(",");
							for(int i=0;i<style.length;i++){
								String[] clothingstyle = style[i].split(":");
								if(Utility.toSafeString(od.getSingleClothingID()).equals(clothingstyle[0]) && clothingstyle.length>1){
									strBX += " " +DictManager.getDictNamesByIDs(clothingstyle[1]);
								}
							}
						}
					    wsheet.addCell(new Label(14, nZT+1, strBX, wcfFX));//版型
					    
					    
					    int e = nZT+1;
					    int d = e+1;
					    for(Embroidery enbroidery : od.getEmberoidery()){
					    	e++;
					    	wsheet.mergeCells(2, e, 3, e);//开始列，开始行，结束列，结束行
						    wsheet.addCell(new Label(2, e, ResourceHelper.getValue("Dict_4150"), wcfFX));//刺绣颜色
						    wsheet.mergeCells(4, e, 5, e);
						    wsheet.addCell(new Label(4, e, ResourceHelper.getValue("Dict_4155"), wcfFX));//字体
						    wsheet.mergeCells(6, e, 9, e);
						    wsheet.addCell(new Label(6, e, ResourceHelper.getValue("Embroid_Position"), wcfFX));//位置
						    wsheet.mergeCells(10, e, 13, e);
						    wsheet.addCell(new Label(10, e, ResourceHelper.getValue("Common_Content"), wcfFX));//内容
					    	wsheet.mergeCells(2, e+1, 3, e+1);//开始列，开始行，结束列，结束行
						    wsheet.addCell(new Label(2, e+1, enbroidery.getColor()==null?"":enbroidery.getColor().getName(), wcfFX));//刺绣颜色
						    wsheet.mergeCells(4, e+1, 5, e+1);
						    wsheet.addCell(new Label(4, e+1, enbroidery.getFont()==null?"":enbroidery.getFont().getName(), wcfFX));//字体
						    wsheet.mergeCells(6, e+1, 9, e+1);
						    wsheet.addCell(new Label(6, e+1, enbroidery.getLocation()==null?"":enbroidery.getLocation().getName(), wcfFX));//位置
						    wsheet.mergeCells(10, e+1, 13, e+1);
						    wsheet.addCell(new Label(10, e+1, enbroidery.getContent()==null?"":enbroidery.getContent(), wcfFX));//内容
						    if(e==4 || (e == zt+2 && zt !=2 )){
					    	    wsheet.mergeCells(14, e, 15, e);
								wsheet.addCell(new Label(14, e, ResourceHelper.getValue("Dict_1993"), wcfFX));//半成品试衣
								wsheet.mergeCells(14, e+1, 15, e+1);
								String strBCP =ResourceHelper.getValue("Dict_246");//否
								if(orden.getComponents() != null && !"".equals(orden.getComponents())){
							    	String[] strDicts = Utility.getStrArray(orden.getComponents());
							    	for(String strDict : strDicts){
							    		if(strDict.indexOf("_")>0 || "".equals(strDict)){
							    			break;
							    		}else{
							    			Dict dict = DictManager.getDictByID(Utility.toSafeInt(strDict));
								    		String strCode =dict.getCode().substring(0, 4);
								    		//半成品试衣
											String[] strBcpsy = CDict.BCPSY.split(",");
											for(int j=0;j<strBcpsy.length;j++){
												if(Utility.toSafeString(strBcpsy[j]).equals(Utility.toSafeString(dict.getID()))
														&& strCode.equals(dictClothing.getCode())){
													strBCP =ResourceHelper.getValue("Dict_245");//是
													break;
												}
											}
							    		}
							    	}
							    }
								wsheet.addCell(new Label(14, e+1, strBCP, wcfFX));//半成品试衣
						    }else{
						    	wsheet.mergeCells(14, e, 15, e);
						    	wsheet.addCell(new Label(14, e, "", wcfFX));
						    	wsheet.mergeCells(14, e+1, 15, e+1);
						    	wsheet.addCell(new Label(14, e+1, "", wcfFX));
						    }
						    d = e+1;
						    e++;
					    }
					    
					    // 开始生成主体内容  --- 成衣量体信息
					    int m=1;
					    int ts=0;
					    String[] strBodyTypes = Utility.getStrArray(orden.getSizePartValues());
					    if(orden.getSizeCategoryID() == 10052){
					    	String sizeStandards = this.getSizePartName(orden, od.getSingleClothingID(),10052,-1,"undefined");
					    	String[] sizeStandard = Utility.getStrArray(sizeStandards);
					    	d++;
					    	for(String sizes :sizeStandard){
					    		m++;
					    		String[] sizeName = sizes.split(":");
					    		wsheet.addCell(new Label(m, d, sizeName[1], wcfFX));
							    wsheet.addCell(new Label(m, d+1, "", wcfFX));
					    	}
					    	if(m != 15){
					    		for(int i= m;i<15;i++){
					    			wsheet.addCell(new Label(i+1, d, "", wcfFX));
								    wsheet.addCell(new Label(i+1, d+1, "", wcfFX));
					    		}
					    	}
					    }else{
					    	String strSpecHeight="undefined";
					    	int nAreaID =-1;
					    	if(orden.getSizeCategoryID()==10054){
					    		strSpecHeight=od.getSpecHeight();
					    		nAreaID = orden.getSizeAreaID();
					    	}
					    	String sizeStandards = this.getSizePartName(orden, od.getSingleClothingID(),orden.getSizeCategoryID(),nAreaID,strSpecHeight);
					    	String[] sizeStandard = Utility.getStrArray(sizeStandards);
					    	d++;
					    	for(String sizes :sizeStandard){
					    		String[] sizeID = sizes.split(":");
					    		for(String strBodyType :strBodyTypes){
					    			String[] strBT = strBodyType.split(":");
					    			if((orden.getClothingID()==1 || orden.getClothingID()==2) && od.getSingleClothingID()==2000 && "10108".equals(Utility.toSafeString(sizeID[0]))){
						    			if(strBodyType.indexOf(":")<0){
						    				m++;
						    				wsheet.addCell(new Label(m, d, sizeID[1], wcfFX));
						    				wsheet.addCell(new Label(m, d+1, strBodyType, wcfFX));
						    				ts=d+1;
						    			}
						    		}else{
						    			if(sizeID[0].equals(strBT[0])){
						    				m++;
						    				wsheet.addCell(new Label(m, d, sizeID[1], wcfFX));
							    			if(strBT.length>1){
						    					wsheet.addCell(new Label(m, d+1, strBT[1], wcfFX));
						    				}else{
						    					wsheet.addCell(new Label(m, d+1, "", wcfFX));
						    				}
										    ts=d+1;
						    			}
						    		}
					    		}
					    	}
					    	if(m != 15){
					    		for(int i= m+1;i<=15;i++){
					    			wsheet.addCell(new Label(i, d, "", wcfFX));
								    wsheet.addCell(new Label(i, d+1, "", wcfFX));
					    		}
					    	}
					    }
					    // 开始生成主体内容  --- 工艺信息
					    wsheet.addCell(new Label(2,d+2 , ResourceHelper.getValue("Process_Info")+"："));//工艺要求
					    ts=d+3;
						List<Dict> ordersProcessList =new  ClothingManager().getOrderProcess(orden, od.getSingleClothingID());
						String strProcess="";
						for(Dict ordersProcess :ordersProcessList){
							Dict dictParent =  DictManager.getDictByID(ordersProcess.getParentID());
							if(dictParent!= null){
								if(dictParent.getEcode() != null && !"".equals(dictParent.getEcode())){//扣子、锁眼线色、里料等
									strProcess += dictParent.getEcode()+"-"+ordersProcess.getEcode()+":"+dictParent.getName()+"-"+ordersProcess.getName()+",";
								}else{//客户指定工艺
									if(ordersProcess.getStatusID() != null && ordersProcess.getStatusID().equals(CDict.ComponentText.getID())){
										strProcess +=ordersProcess.getEcode()+":"+ordersProcess.getName()+"-"+ordersProcess.getMemo()+",";//客户指定内容
									}else{
										strProcess +=ordersProcess.getEcode()+":"+ ordersProcess.getName()+",";
									}
								}
							}
							
						}
					    String[] strOrdenProcess = Utility.getStrArray(strProcess);
					    int gy=0;
					    int l=2;
					    int g=0;
					    if(strOrdenProcess.length>0){
					    	for(String sProcess : strOrdenProcess){
					    		g++;
					    		if((g-1)%3 == 0){
					    			gy++;
								    l=2;
					    			wsheet.mergeCells(l, d+2+gy, l+4, d+2+gy);
						    		wsheet.addCell(new Label(l,d+2+gy , sProcess));
					    		}else{
					    			wsheet.mergeCells(l, d+2+gy, l+4, d+2+gy);
						    		wsheet.addCell(new Label(l,d+2+gy , sProcess));
					    		}
					    		l=l+5;
					    		ts=d+2+gy+1;
					    	}
					    }else{
					    	ts=d+3;
					    }
					    
					    // 开始生成主体内容  --- 特殊工艺
					    wsheet.mergeCells(2, ts, 15, ts);
					    wsheet.addCell(new Label(2, ts, ResourceHelper.getValue("Common_SpecialProcess")+"：", wcfFS));//特殊工艺
					    zt=ts+2;
			        }
				    
//				}
			 }
		    // 主体内容生成结束          
		    wbook.write(); // 写入文件  
		    wbook.close();  
		    os.close(); // 关闭流
		    }
		    catch(Exception ex)
		    {
		    ex.printStackTrace();
		    }
		}
	    
	}
	//净体量体
	public String getSizePartName(Orden orden,int nClothingID,int nSizeCategoryID,int nAreaID,String strSpecHeight) {
		List<SizeStandard> sizeStandards=new ArrayList<SizeStandard>();
		String strPartNames ="";
		// 默认值
//			int nAreaID = -1;
//			String strSpecHeight = "undefined";
			String strSpecChest = "undefined";
//			if (nSizeCategoryID == 10054) {// 西服、西裤 标准号加减
//				nAreaID = 10201;// 英美码
//				strSpecHeight = "34S";
//			}
//			if (nClothingID == 3000 && nSizeCategoryID == 10054) {// 衬衣
//				nAreaID = 10201;// 英美码
//				strSpecHeight = "38/XXS";
//			}
    	try {
    		String hql="FROM SizeStandard WHERE SingleClothingID= :SingleClothingID AND SizeCategoryID= :SizeCategoryID ";
    		if(nAreaID!=-1){
    			hql+=" AND AreaID= :AreaID ";
    		}
    		if(StringUtils.isNotEmpty(strSpecHeight) && !"undefined".equals(strSpecHeight)){
    			hql+=" AND SpecHeight= :SpecHeight ";
    		}
    		if(StringUtils.isNotEmpty(strSpecChest) && !"undefined".equals(strSpecChest)){
    			hql+=" AND SpecChest= :SpecChest ";
    		}
    		hql += " ORDER BY SequenceNo ";
        	Query query=DataAccessObject.openSession().createQuery(hql);
        	
        	query.setInteger("SingleClothingID", nClothingID);
        	query.setInteger("SizeCategoryID", nSizeCategoryID);
        	
        	if(nAreaID!=-1){
        		query.setInteger("AreaID", nAreaID);
    		}
        	
        	if(!"".equals(strSpecHeight) && !"undefined".equals(strSpecHeight)){
            	query.setString("SpecHeight", strSpecHeight);
    		}
        	if(!"".equals(strSpecChest) && !"undefined".equals(strSpecChest)){
            	query.setString("SpecChest", strSpecChest);
    		}
        	sizeStandards=query.list();
        	for (SizeStandard sizeStandard : sizeStandards) {
        		if(nClothingID == 3000 || nClothingID == 5000){
					if("10113,10114,10135,10173".contains(Utility.toSafeString(sizeStandard.getPartID()))){//袖长、袖口
						if("3029".equals(Utility.toSafeString(sizeStandard.getPleatID()))&&  Utility.contains(orden.getComponents(), "5001")){//短袖
							strPartNames += sizeStandard.getPartID()+":"+DictManager.getDictNameByID(sizeStandard.getPartID())+",";
						}else if(!"3029".equals(Utility.toSafeString(sizeStandard.getPleatID()))&&  !Utility.contains(orden.getComponents(), "5001") ){//长袖
							strPartNames += sizeStandard.getPartID()+":"+DictManager.getDictNameByID(sizeStandard.getPartID())+",";
						}
					}else{
						strPartNames += sizeStandard.getPartID()+":"+DictManager.getDictNameByID(sizeStandard.getPartID())+",";
					}
        		}else{
        			if(orden.getClothingID()== 1 && nClothingID==3){
//        				if(sizeStandard.getPartID()!=10108){
        					strPartNames += sizeStandard.getPartID()+":"+DictManager.getDictNameByID(sizeStandard.getPartID())+",";
//            			}
        			}else{
        				strPartNames += sizeStandard.getPartID()+":"+DictManager.getDictNameByID(sizeStandard.getPartID())+",";
        			}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			DataAccessObject.closeSession();
		}
		return strPartNames;
	}
	
	//取得工艺类别
	public String getInterliningType(int nSingleClothingID, String strAllDesignedComponents,Orden orden,String interliningType){
			//女装默认00C3
			if(nSingleClothingID == 95000 || nSingleClothingID == 98000){
				interliningType="00C3";
		    }
			List<Dict> InterliningTypeCategory = new ClothingManager().getInterliningTypeCategory();
			List<Dict> dicts = new OrdenManager().getSingleDesignedComponents(strAllDesignedComponents, nSingleClothingID);
			String strEocde="";
			for(Dict dict :dicts){
				for(Dict typeCategory:InterliningTypeCategory){
					if(dict.getParentID().equals(typeCategory.getID())){
						strEocde+=dict.getEcode()+",";
					}
				}
			}
			strEocde=new XmlManager().EcodeRedirect(","+strEocde);
			
			if(!"".equals(strEocde) && !",".equals(strEocde)){
				strEocde=strEocde.substring(1,strEocde.length()-1);
					interliningType =strEocde;
			}
			if(CDict.ClothingShangYi.getID().equals(nSingleClothingID) 
					|| CDict.ClothingDaYi.getID().equals(nSingleClothingID)
					|| CDict.ClothingPants.getID().equals(nSingleClothingID)
					|| CDict.ClothingLF.getID().equals(nSingleClothingID)
					|| CDict.ClothingNXF.getID().equals(nSingleClothingID)
					|| CDict.ClothingNXK.getID().equals(nSingleClothingID)){//西服、西裤、大衣
				strEocde=interliningType;
			}else if(CDict.ClothingPants.getID().equals(orden.getClothingID()) ){//西裤 
				strEocde=CDict.InterliningType;//半毛衬
			}else if(CDict.ClothingSuit3PCS.getID().equals(orden.getClothingID())
					&& CDict.ClothingMaJia.getID().equals(nSingleClothingID)){//3件套--马夹
				strEocde=interliningType;
			}else if(CDict.ClothingMaJia.getID().equals(orden.getClothingID())){//马夹
				strEocde=CDict.InterliningType_MJ;//高档粘合衬
			}else{//衬衣
				strEocde="";
			}
			return strEocde;
		}
	
}