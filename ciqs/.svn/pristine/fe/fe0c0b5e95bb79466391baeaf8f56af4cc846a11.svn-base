package com.dpn.ciqqlc.http;

import java.io.IOException;
import java.net.MalformedURLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.dpn.ciqqlc.common.util.Constants;
import com.dpn.ciqqlc.common.util.DateUtil;
import com.dpn.ciqqlc.http.result.FormPdf;
import com.dpn.ciqqlc.service.AppServerDb;
import com.dpn.ciqqlc.service.Quartn;
import com.dpn.ciqqlc.standard.model.CheckDocsRcdModel;
import com.dpn.ciqqlc.standard.model.ProsasModel;
import com.dpn.ciqqlc.standard.model.QuartnModel;
import com.dpn.ciqqlc.standard.model.SelectModel;
import com.dpn.ciqqlc.standard.model.VideoEventModel;
import com.itextpdf.text.BadElementException;
import com.itextpdf.text.DocumentException;
import com.itextpdf.text.Image;
import com.itextpdf.text.Rectangle;
import com.itextpdf.text.pdf.AcroFields;
import com.itextpdf.text.pdf.PdfContentByte;
import com.itextpdf.text.pdf.PdfStamper;

/**
 * 
 * 进出境旅客携带物检疫全过程执法记录
 * @author erikWang
 *
 */
@SuppressWarnings("rawtypes")
@Controller
@RequestMapping( value = "/quartn")	   
public class QuartnCheckCargoController extends  FormPdf{
	@Autowired
    private Quartn quartnService;
	
	@Autowired
	@Qualifier("appServerDbServ")
	private AppServerDb commonUtil = null;
	
	private CheckDocsRcdModel docsRcd;
	
	private List<String> op39_t1 = new ArrayList<String>();
	private List<String> op68_t1 = new ArrayList<String>();
	private List<String> op69_t1 = new ArrayList<String>();
	
	private String  area_t1;
	private String  city_t1;
	private String  street_t1;
	
	/**
	 * 
	 * 携带物信息列表
	 * @param PassPort 护照编号
	 * @param time 截获时间
	 * @param pType 物品类别
	 * @return  截留携带物信息列表
	 */
	@RequestMapping( value = "/list")
	public String findList(HttpServletRequest request,QuartnModel quartnModel, Model model){
		try {
//			if(null==quartnModel.getPortDeptCode()){
//				quartnModel.setPortDeptCode("CIQGVLN");
//			}
			if(null==quartnModel.getPortOrgCode()){//分支机构
				quartnModel.setPortOrgCode("210700");
			}
			quartnModel.setCardNo(quartnModel.getCardNo()==null?null:quartnModel.getCardNo().trim());
			int pages = 1;
		    if(request.getParameter("page") != null && !"".equals(request.getParameter("page"))) {
		         pages = Integer.parseInt(request.getParameter("page") == null ? "1" : request.getParameter("page"));
		    }
		    quartnModel.setFirstRcd(String.valueOf((pages-1)*Constants.PAGE_NUM+1));
		    quartnModel.setLastRcd(String.valueOf(pages*Constants.PAGE_NUM+1));
			List<SelectModel> result =commonUtil.findNameAndCode(Constants.CARDTYPE);
			List<SelectModel> discoverWay =commonUtil.findNameAndCode(Constants.DISCOVERWAYTYPE);
			List<SelectModel> outsideWay =commonUtil.findNameAndCode(Constants.OUTSIDEWAYTYPE);
			List<SelectModel> organizes =commonUtil.findNameAndCode(Constants.QLCORGANIZES);
			List<SelectModel> qlcdeptments =commonUtil.findNameAndCode(Constants.QLCDEPTMENTS);
			List<QuartnModel>  list = quartnService.findListPack(quartnModel);
			int counts = quartnService.findQuartnCount(quartnModel);
			model.addAttribute("list", list);
			model.addAttribute("obj", quartnModel);
			model.addAttribute("cardlist", result);
			model.addAttribute("discoverlist", discoverWay);
			model.addAttribute("outsidelist", outsideWay);
			model.addAttribute("organizes", organizes);
			model.addAttribute("qlcdeptments", qlcdeptments);
			request.setAttribute("pages", Integer.toString(pages));// 当前页码
	        request.setAttribute("itemInPage", Constants.PAGE_NUM);// 每页显示的记录数
            request.setAttribute("counts",counts);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "quartn/list";
	}
	
	
	/**
	 * 查找单个截留物品详细信息
	 * @param id 未定义参数
	 * @return 截留物品信息
	 */
	@RequestMapping( value = "/detail")
	public String findPack(String id,Model model){
		model.addAttribute("id",id);
//		Map<String,Object> map = new HashMap<String, Object>();
//		List<VideoEventModel>  vddtl1  = new ArrayList<VideoEventModel>();
//		List<VideoEventModel>  vddtl2  = new ArrayList<VideoEventModel>();
//		List<VideoEventModel>  vddtl3  = new ArrayList<VideoEventModel>();
//		List<VideoEventModel>  vddtl4  = new ArrayList<VideoEventModel>();
//		List<VideoEventModel>  vddtl5  = new ArrayList<VideoEventModel>();
//		Map<String,Object> D_DD_T_L_1 = new HashMap<String, Object>();
//		Map<String,Object> D_DD_T_L_2 = new HashMap<String, Object>();
//		if(StringUtils.isNotBlank(id)){
//			ProsasModel   result =danDong.findById(id);
//				if( result != null ){
//					if(StringUtils.isNotBlank(result.getCardNo())){
//						//根据证件号查询所有的信息
//						map.put("cardNo", result.getCardNo());
//						List<VideoEventModel> videoEventModels =danDong.findByFileEvent(map);
//							if(videoEventModels != null && videoEventModels.size() >0 ){
//								for(VideoEventModel eventModel : videoEventModels){
//									//体温监测
//									if("V_DD_T_L_1".equals(eventModel.getProcType())){
//										vddtl1.add(eventModel);
//										model.addAttribute("vddtl1", vddtl1);
//									//现场隔离拍照
//									}else if("V_DD_T_L_2".equals(eventModel.getProcType())){
//										vddtl2.add(eventModel);
//										model.addAttribute("vddtl2", vddtl2);
//									//现场隔离录像	
//									}else if("V_DD_T_L_3".equals(eventModel.getProcType())){
//										vddtl3.add(eventModel);
//										model.addAttribute("vddtl3", vddtl3);
//									//医护对接拍照
//									}else if("V_DD_T_L_4".equals(eventModel.getProcType())){
//										vddtl4.add(eventModel);
//										model.addAttribute("vddtl4", vddtl4);
//									//医护对接录像
//									}else if("V_DD_T_L_5".equals(eventModel.getProcType())){
//										vddtl5.add(eventModel);
//										model.addAttribute("vddtl5", vddtl5);
//									}
//								}								
//							}							
//					}
//					 //口岸传染病可疑病例流行病学调查表
//					 D_DD_T_L_1.put("ProcMainId", result.getCardNo());
//					 D_DD_T_L_1.put("DocType", "D_DD_T_L_1");					 
//					 CheckDocsRcdModel dddtl1  =danDong.findByDoc(D_DD_T_L_1);
//					 model.addAttribute("dddtl1", dddtl1);
//					 //口岸传染病可疑病例医学排查记录表
//					 D_DD_T_L_2.put("ProcMainId", result.getCardNo());
//					 D_DD_T_L_2.put("DocType", "D_DD_T_L_2");					 
//					 CheckDocsRcdModel dddtl2  =danDong.findByDoc(D_DD_T_L_2);
//					 model.addAttribute("dddtl2", dddtl2);
//				}
//			 model.addAttribute("result", result);
//			 			
//		}
		return "quartn/detailAjx";
	}
	
	@ResponseBody
	@RequestMapping( value = "/detailView")
	public Map<String,Object> detailView(String id,Model model){
		Map<String,Object> map=new HashMap<String,Object>();
		Map<String,Object> resultMap=new HashMap<String,Object>();
		Map<String,Object> D_DD_T_L_1 = new HashMap<String, Object>();
		Map<String,Object> D_DD_T_L_2 = new HashMap<String, Object>();
		if(StringUtils.isNotBlank(id)){
			ProsasModel result =quartnService.findById(id);
				if( result != null ){
					if(null!=result.getBirth()){
						result.setBirthDay(DateUtil.DateToString(result.getBirth(),"yyyy-MM-dd"));
					}
					if(StringUtils.isNotBlank(result.getId())){
						//根据证件号查询所有的信息
						map.put("cardNo", result.getId());
						map.put("proj_code", "DD_T_L"); 
						List<VideoEventModel> videoEventModels =quartnService.findByFileEvent(map);
						resultMap.put("videoEventModels", videoEventModels);
					}
					 //口岸传染病可疑病例流行病学调查表
					 D_DD_T_L_1.put("ProcMainId", result.getId());
					 D_DD_T_L_1.put("DocType", "D_DD_T_L_1");
					 D_DD_T_L_1.put("proj_code", "DD_T_L"); 
					 CheckDocsRcdModel dddtl1  =quartnService.findByDoc(D_DD_T_L_1);
					 if(null!=dddtl1){
						 dddtl1.setModelDecDate(DateUtil.DateToString(dddtl1.getDecDate(),"yyyy-MM-dd HH:mm"));
						 resultMap.put("dddtl1", dddtl1);
					 }
					 //口岸传染病可疑病例医学排查记录表
					 D_DD_T_L_2.put("ProcMainId", result.getId());
					 D_DD_T_L_2.put("DocType", "D_DD_T_L_2");	
					 D_DD_T_L_2.put("proj_code", "DD_T_L");
					 CheckDocsRcdModel dddtl2  =quartnService.findByDoc(D_DD_T_L_2);
					 if(null!=dddtl2){
						 dddtl2.setModelDecDate(DateUtil.DateToString(dddtl2.getDecDate(),"yyyy-MM-dd HH:mm"));
						 resultMap.put("dddtl2", dddtl2);
					 }
					 
					 //采样通知单
					 Map<String,Object> D_DD_T_L_4 = new HashMap<String, Object>();
					 D_DD_T_L_4.put("ProcMainId", result.getId());
					 D_DD_T_L_4.put("DocType", "D_DD_T_L_4");
					 CheckDocsRcdModel dddtl4  =quartnService.findOnlyDoc(D_DD_T_L_4);
					 if(null!=dddtl4){
						 dddtl4.setModelDecDate(DateUtil.DateToString(dddtl4.getDecDate(),"yyyy-MM-dd HH:mm"));
						 resultMap.put("dddtl4", dddtl4);
					 }
					 
					 Map<String,Object> D_DD_T_L_3 = new HashMap<String, Object>();
					 D_DD_T_L_3.put("ProcMainId", result.getId());
					 D_DD_T_L_3.put("DocType", "D_DD_T_L_3");
					 CheckDocsRcdModel dddtl3  =quartnService.findOnlyDoc(D_DD_T_L_3);
					 if(null!=dddtl3){
						 dddtl3.setModelDecDate(DateUtil.DateToString(dddtl3.getDecDate(),"yyyy-MM-dd HH:mm"));
						 resultMap.put("dddtl3", dddtl3);
					 }
				}
				resultMap.put("result", result);
			 			
		}
		return resultMap;
	}
	
	@RequestMapping( value = "/doc")
	public String findDoc(String id,String flag,Model model){
			if("dddtl1".equals(flag)){
				CheckDocsRcdModel dddtl1  =quartnService.findByDocId(id);
				String[] strOp11 = dddtl1.getOption11().split(",");
				String[] strOp39 = dddtl1.getOption39().split(",");
				String[] strOp68 = dddtl1.getOption68().split(",");
				String[] strOp69 = dddtl1.getOption69().split(",");
				List<String> op39 = new ArrayList<String>();
				List<String> op68 = new ArrayList<String>();
				List<String> op69 = new ArrayList<String>();
				for(int i =0;i<strOp39.length;i++){
					op39.add(strOp39[i]);
				}
				for(int i =0;i<strOp68.length;i++){
					op68.add(strOp68[i]);
				}
				for(int i =0;i<strOp69.length;i++){
					op69.add(strOp69[i]);
				}
				if(strOp11.length == 3){
					String area = null;
					String city =null;
					String street =null;
					for(int i =0;i<strOp11.length;i++){
						area =strOp11[0];
						city =strOp11[1];
						street =strOp11[2];
					}
					area_t1=area;
					city_t1=city;
					street_t1=street;
					model.addAttribute("area", area);
					model.addAttribute("city", city);
					model.addAttribute("street", street);
				}				
				op39_t1=op39;
				op68_t1=op68;
				op69_t1=op69;
				docsRcd=dddtl1;
				model.addAttribute("op39", op39);
				model.addAttribute("op68", op68);
				model.addAttribute("op69", op69);
				model.addAttribute("dddtl1", dddtl1);
				return "quartn/chuanranbiandiaochabiao";		
			}else{	 
				 CheckDocsRcdModel dddtl2  =quartnService.findByDocId(id);
				 docsRcd=dddtl2;
				 model.addAttribute("dddtl2", dddtl2);
				return "quartn/chuanranbingjilubiao";		
			}	
				
	}
	
	@RequestMapping( value = "/findtext")
	public String findtext(HttpServletRequest request,String id,Model model){
		String t=request.getParameter("t");
		Map<String,Object> map = new HashMap<String, Object>();
		ProsasModel result =quartnService.findById(id);//根据主键获取对象里业务主键
		if(com.dpn.ciqqlc.common.util.StringUtils.isNotEmpty(t) && t.equals("1")){
			map.put("ProcMainId", result.getId());
			map.put("DocType", "D_DD_T_L_3");
			CheckDocsRcdModel d  =quartnService.findOnlyDoc(map);
			if(null!=d && com.dpn.ciqqlc.common.util.StringUtils.isNotEmpty(d.getOption32())){
				if(d.getOption32().equals("ZXYY")){
					d.setOption32("丹东市中心医院");
				}
				if(d.getOption32().equals("DYYY")){
					d.setOption32("丹东市第一医院");
				}
				if(d.getOption32().equals("230YY")){
					d.setOption32("丹东市230医院");
				}
				if(d.getOption32().equals("RMYY")){
					d.setOption32("丹东市人民医院");
				}
				if(d.getOption32().equals("CRBYY")){
					d.setOption32("丹东市传染病医院");
				}
			}
			docsRcd=d;
			model.addAttribute("obj", d);
		}else{
			map.put("ProcMainId", result.getId());
			map.put("DocType", "D_DD_T_L_4");
			CheckDocsRcdModel d  =quartnService.findOnlyDoc(map);
			docsRcd=d;
			model.addAttribute("obj", d);
		}
		return "quartn/text"+t;	
				
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "downQuartnPdf")
	public void downQuartnPdf(HttpServletRequest request,HttpServletResponse response, String id) {
		String tempete=this.getTemp(request);
		this.toPrintPlanNote(request, response, docsRcd,tempete,request.getParameter("index"),true);
	}


	private String getTemp(HttpServletRequest request) {
		String index=request.getParameter("index");
		return "/message/ciqqlc/pdfModel/quartn"+index+".pdf";
	}


	public CheckDocsRcdModel getDocsRcd() {
		return docsRcd;
	}


	public void setDocsRcd(CheckDocsRcdModel docsRcd) {
		this.docsRcd = docsRcd;
	}


	public List<String> getOp39_t1() {
		return op39_t1;
	}


	public void setOp39_t1(List<String> op39_t1) {
		this.op39_t1 = op39_t1;
	}


	public List<String> getOp68_t1() {
		return op68_t1;
	}


	public void setOp68_t1(List<String> op68_t1) {
		this.op68_t1 = op68_t1;
	}


	public List<String> getOp69_t1() {
		return op69_t1;
	}


	public void setOp69_t1(List<String> op69_t1) {
		this.op69_t1 = op69_t1;
	}


	public String getArea_t1() {
		return area_t1;
	}


	public void setArea_t1(String area_t1) {
		this.area_t1 = area_t1;
	}


	public String getCity_t1() {
		return city_t1;
	}


	public void setCity_t1(String city_t1) {
		this.city_t1 = city_t1;
	}


	public String getStreet_t1() {
		return street_t1;
	}


	public void setStreet_t1(String street_t1) {
		this.street_t1 = street_t1;
	}


	@Override
	protected void formSet(HttpServletRequest request,PdfStamper stamper,AcroFields acroform, Object t, String actionType) {
		// TODO 赋值方法
		CheckDocsRcdModel dto=(CheckDocsRcdModel) t;
		try {
			if(null!=actionType && actionType.equals("1")){
				acroform.setField("a1", dto.getOption1());
				if(null!=dto.getOption2()){
					acroform.setField("a2", dto.getOption2().equals("1")?"女":"男");
				}
				acroform.setField("a3", dto.getOption3());
				acroform.setField("a4", dto.getOption4());
				acroform.setField("a5", dto.getOption5());
				acroform.setField("a6", dto.getOption6());
				acroform.setField("a7", dto.getOption7());
				acroform.setField("a8", dto.getOption8());
				acroform.setField("a9", dto.getOption9());
				acroform.setField("a10", dto.getOption10());
				acroform.setField("a11", area_t1+"省"+city_t1+"市"+street_t1+"街道");
				acroform.setField("a12", dto.getOption67());
				this.myField(acroform,new String[]{"1","2","3"}, dto.getOption15());
				this.myField(acroform,new String[]{"4","5","6"}, dto.getOption16());
				this.myField(acroform,new String[]{"7","8","9"}, dto.getOption17());
				this.myField(acroform,new String[]{"10","11","12"}, dto.getOption18());
				this.myField(acroform,new String[]{"13","14","15"}, dto.getOption19());
				this.myField(acroform,new String[]{"16","17","18"}, dto.getOption20());
				this.myField(acroform,new String[]{"19","20","21"}, dto.getOption21());
				this.myField(acroform,new String[]{"22","23","24"}, dto.getOption22());
				this.myField(acroform,new String[]{"25","26","27"}, dto.getOption23());
				this.myField(acroform,new String[]{"28","29","30"}, dto.getOption24());
				this.myField(acroform,new String[]{"31","32","33"}, dto.getOption25());
				this.myField(acroform,new String[]{"34","35","36"}, dto.getOption26());
				this.myField(acroform,new String[]{"37","38","39"}, dto.getOption27());
				this.myField(acroform,new String[]{"40","41","42"}, dto.getOption28());
				this.myField(acroform,new String[]{"43","44","45"}, dto.getOption29());
				this.myField(acroform,new String[]{"46","47","48"}, dto.getOption30());
				this.myField(acroform,new String[]{"49","50","51"}, dto.getOption31());
				this.myField(acroform,new String[]{"52","53","54"}, dto.getOption32());
				this.myField(acroform,new String[]{"55","56","57"}, dto.getOption33());
				acroform.setField("a8", dto.getOption34());//
				acroform.setField("a8", dto.getOption35());//
				acroform.setField("a13", dto.getOption36());
				acroform.setField("a14", dto.getOption37());
				this.myTableSet(acroform);
				this.myField(acroform,new String[]{"58","59","60"}, dto.getOption38());
				this.myField(acroform,new String[]{"61","62","63"}, dto.getOption40());
				acroform.setField("a39", dto.getOption41());
				this.myField(acroform,new String[]{"64","65","66"}, dto.getOption42());
				acroform.setField("a40", dto.getOption43());
				this.myField(acroform,new String[]{"67","68","69"}, dto.getOption44());
				this.myField(acroform,new String[]{"70","71"}, dto.getOption45());
				acroform.setField("a41", dto.getOption46());
				this.myField(acroform,new String[]{"72","73"}, dto.getOption47());
				acroform.setField("a42", dto.getOption48());
				this.myField(acroform,new String[]{"74","75","76"}, dto.getOption51());//9. 有无重点关注传染病预防接种史
				acroform.setField("a43", dto.getOption52());
				this.myField(acroform,new String[]{"77","78"}, dto.getOption53());//10．有无怀孕
				this.myField(acroform,new String[]{"79","80","81"}, dto.getOption54());//11．有无晕机（车、船）史
				this.myField(acroform,new String[]{"82","83","84"}, dto.getOption55());//12．近期有无用药
				acroform.setField("a44", dto.getOption56());
				this.myField(acroform,new String[]{"85","86"}, dto.getOption57());//13．是否曾住院诊断
				acroform.setField("a45", dto.getOption58());
				this.myField(acroform,new String[]{"87","88"}, dto.getOption59());//14．近期有无输血献血
				acroform.setField("a46", dto.getOption60());
				this.myField(acroform,new String[]{"89","90","91"}, dto.getOption61());//15.有无过敏史
				acroform.setField("a47", dto.getOption62());
				acroform.setField("a48", dto.getOption63());//16.其他相关因素调查
				this.myField(acroform,new String[]{"92","93","94","95","96","97"}, dto.getOption64());
				acroform.setField("a49", dto.getOption65());
				acroform.setField("a50", dto.getOption70());
				acroform.setField("a51", DateUtil.DateToString(dto.getDecDate(),"yyyy-MM-dd"));
			}else if(null!=actionType && actionType.equals("2")){
				acroform.setField("a1", dto.getOption1());
				if(null!=dto.getOption2()){
					acroform.setField("a2", dto.getOption2().equals("0")?"男":"女");
				}
				acroform.setField("a3", dto.getOption3());
				acroform.setField("a4", dto.getOption4());
				acroform.setField("a5", dto.getOption5());
				acroform.setField("a6", dto.getOption6());
				acroform.setField("a7", dto.getOption7());
				acroform.setField("a8", dto.getOption8());
				acroform.setField("a9", dto.getOption9());
				acroform.setField("a10", dto.getOption10());
				this.addImg(stamper,acroform,"a11",dto.getOption11());
				acroform.setField("a12", dto.getOption12());
				acroform.setField("a13", dto.getOption13());
				this.addImg(stamper,acroform,"a14",dto.getOption14());
				acroform.setField("a15", dto.getOption15());
				acroform.setField("a16", dto.getOption16());
				this.addImg(stamper,acroform,"a17",dto.getOption17());
				acroform.setField("a18", dto.getOption18());
				acroform.setField("yw3", dto.getOption19());//
				this.addImg(stamper,acroform,"a19",dto.getOption20());
				acroform.setField("20", dto.getOption21());
				acroform.setField("21", dto.getOption22());
				this.addImg(stamper,acroform,"a22",dto.getOption23());
				acroform.setField("23", dto.getOption24());
				acroform.setField("24", dto.getOption25());
				acroform.setField("m1", dto.getOption26());//
				this.addImg(stamper,acroform,"a25",dto.getOption27());
				acroform.setField("26", dto.getOption28());
				acroform.setField("27", dto.getOption29());
				this.addImg(stamper,acroform,"a28",dto.getOption30());
				acroform.setField("29", dto.getOption31());
				acroform.setField("30", dto.getOption32());
				this.addImg(stamper,acroform,"a31",dto.getOption33());
				acroform.setField("32", dto.getOption34());
			}else if(null!=actionType && actionType.equals("3")){
				acroform.setField("a1", dto.getOption1());
				acroform.setField("a2", dto.getOption2());
				acroform.setField("a3", dto.getOption3());
				acroform.setField("a4", dto.getOption4());
				acroform.setField("a5", dto.getOption5());
				acroform.setField("a6", dto.getOption6());
				acroform.setField("a7", dto.getOption7());
				acroform.setField("a8", dto.getOption8());
				acroform.setField("a9", dto.getOption9());
				acroform.setField("a10", dto.getOption10());
				acroform.setField("a11", dto.getOption11());
				acroform.setField("a12", dto.getOption12());
				acroform.setField("a13", dto.getOption13());
				acroform.setField("a14", dto.getOption14());
				acroform.setField("a15", dto.getOption15());
				acroform.setField("a16", dto.getOption16());
				acroform.setField("a17", dto.getOption17());
				acroform.setField("a18", dto.getOption18());
				acroform.setField("a19", dto.getOption19());
				acroform.setField("a20", dto.getOption20());
				acroform.setField("a21", dto.getOption21());
				acroform.setField("a22", dto.getOption22());
				acroform.setField("a23", dto.getOption23());
				acroform.setField("a24", dto.getOption24());
				acroform.setField("a25_26", dto.getOption25()+"/"+dto.getOption25());
				acroform.setField("a43_27", dto.getOption43()+"/"+dto.getOption27());
				this.addImg(stamper,acroform,"a28",dto.getOption28());
				acroform.setField("a29", dto.getOption29());
				acroform.setField("a30", dto.getOption30());
				acroform.setField("a31", dto.getOption31());
				acroform.setField("a32", dto.getOption32());
				this.addImg(stamper,acroform,"a33",dto.getOption33());
				acroform.setField("a34", dto.getOption34());
				this.addImg(stamper,acroform,"a35",dto.getOption35());
				acroform.setField("a36", dto.getOption36());
				acroform.setField("a37", dto.getOption37());
				this.addImg(stamper,acroform,"a38",dto.getOption38());
				acroform.setField("a39", dto.getOption39());
				acroform.setField("a40", dto.getOption40());
				acroform.setField("a41", dto.getOption41());
				acroform.setField("a42", dto.getOption42());
			}else{
				this.addImg(stamper,acroform,"a1",dto.getOption1());
				acroform.setField("a2", dto.getOption2());
				this.addImg(stamper,acroform,"a3",dto.getOption3());
				acroform.setField("a4", dto.getOption4());
			}
		} catch (IOException e) {
			e.printStackTrace();
		} catch (DocumentException e) {
			e.printStackTrace();
		}
	}




	private void myTableSet(AcroFields acroform) {
		try {
			for(int i=0;i<op39_t1.size();i++){
				acroform.setField("t1_"+i, op39_t1.get(i).toString());
			}
			for(int i=0;i<op68_t1.size();i++){
				acroform.setField("t2_"+i, op68_t1.get(i).toString());
			}
			for(int i=0;i<op69_t1.size();i++){
				acroform.setField("t3_"+i, op69_t1.get(i).toString());
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		
	}


	private void myField(AcroFields acroform, String[] arr, String option) {
		try {
			if(null!=option){
				Integer index=Integer.parseInt(option)-1;
				acroform.setField("c"+arr[index], "√");
			}
		} catch (NumberFormatException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} catch (DocumentException e) {
			e.printStackTrace();
		}
	}


	private void addImg(PdfStamper stamper, AcroFields acroform,
			String key, String path) {
		try {
			// 通过域名获取所在页和坐标，左下角为起点
			int pageNo = acroform.getFieldPositions(key).get(0).page;
			Rectangle signRect = acroform.getFieldPositions(key).get(0).position;
			float x = signRect.getLeft();
			float y = signRect.getBottom();
			// 读图片
			Image image = Image.getInstance(Constants.UP_LOAD_PATH + "/"+ path);
			// 获取操作的页面
			PdfContentByte under = stamper.getOverContent(pageNo);
			// 根据域的大小缩放图片
			image.scaleToFit(signRect.getWidth(), signRect.getHeight());
			// 添加图片
			image.setAbsolutePosition(x, y);
			under.addImage(image);
		} catch (BadElementException e) {
			e.printStackTrace();
		} catch (MalformedURLException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} catch (DocumentException e) {
			e.printStackTrace();
		}

	}


}
