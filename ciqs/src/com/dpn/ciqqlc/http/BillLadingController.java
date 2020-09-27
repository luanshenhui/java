package com.dpn.ciqqlc.http;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.BufferedReader;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.net.URL;
import java.net.URLEncoder;
import java.security.MessageDigest;
import java.security.SecureRandom;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.crypto.Cipher;
import javax.crypto.SecretKey;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.DESKeySpec;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.util.EntityUtils;
import org.apache.poi.POIXMLDocument;
import org.apache.poi.POIXMLTextExtractor;
import org.apache.poi.hwpf.HWPFDocument;
import org.apache.poi.hwpf.extractor.WordExtractor;
import org.apache.poi.hwpf.usermodel.Range;
import org.apache.poi.openxml4j.opc.OPCPackage;
import org.apache.poi.xwpf.extractor.XWPFWordExtractor;
import org.apache.poi.xwpf.usermodel.XWPFDocument;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.dpn.ciqqlc.common.util.Constants;
import com.dpn.ciqqlc.common.util.DateUtil;
import com.dpn.ciqqlc.common.util.FileUtil;
import com.dpn.ciqqlc.common.util.XmlUtil;
import com.dpn.ciqqlc.common.util.ApInterface.SentSmsServiceImpl;
import com.dpn.ciqqlc.service.AppServerDb;
import com.dpn.ciqqlc.standard.model.BillCiqGoodModel;
import com.dpn.ciqqlc.standard.model.BillLadingBookingDTO;
import com.dpn.ciqqlc.standard.model.BillLadingDTO;
import com.dpn.ciqqlc.standard.model.BillLadingDTO2;
import com.dpn.ciqqlc.standard.model.BillladingBookModel;
import com.dpn.ciqqlc.standard.model.BilllingModel;
import com.dpn.ciqqlc.standard.model.CheckJobDTO;
import com.dpn.ciqqlc.standard.model.CiqGoodsDeclDTO;
import com.dpn.ciqqlc.standard.model.CiqPaperLessAttachBean;
import com.dpn.ciqqlc.standard.model.ContaDTO;
import com.dpn.ciqqlc.standard.model.ContaEventDTO;
import com.dpn.ciqqlc.standard.model.DywUnQualifyRecordDto;
import com.dpn.ciqqlc.standard.model.GoodsDTO;
import com.dpn.ciqqlc.standard.model.LabDtailDTO;
import com.dpn.ciqqlc.standard.model.LaboratoryDTO;
import com.dpn.ciqqlc.standard.model.LimsDTO;
import com.dpn.ciqqlc.standard.model.SelectModel;
import com.dpn.ciqqlc.standard.model.TfSysProcessLog;
import com.dpn.ciqqlc.standard.model.TfVsaSignRecordDTO;
import com.dpn.ciqqlc.standard.model.UserInfoDTO;
import com.dpn.ciqqlc.standard.model.VideoEventDTO;
import com.dpn.ciqqlc.standard.model.VslDecDto;
import com.dpn.ciqqlc.standard.model.WarningDto;
import com.dpn.ciqqlc.standard.model.XunJobDTO;
import com.dpn.ciqqlc.standard.service.BillLadingService;
import com.itextpdf.text.pdf.AcroFields;
import com.itextpdf.text.pdf.BaseFont;
import com.itextpdf.text.pdf.PdfReader;
import com.itextpdf.text.pdf.PdfStamper;

@Controller
@RequestMapping(value = "/billlading")
public class BillLadingController {
	private final Logger logger_ = LoggerFactory.getLogger(this.getClass());
	@Autowired
	private BillLadingService billLadingFlowService;
	@Autowired
	@Qualifier("appServerDbServ")
	private AppServerDb commonUtil = null;
	
	@Autowired
	private SentSmsServiceImpl sentSmsServiceImpl;

	@InitBinder
	public void InitBinder(WebDataBinder binder) {
		try {
			SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
			dateFormat.setLenient(false);
			binder.registerCustomEditor(Date.class, new CustomDateEditor(
					dateFormat, true));
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * http://localhost:7001/ciqs/billlading/billladingList
	 */
	@RequestMapping("/billladingList")
	public String billladingList(HttpServletRequest request,
			BillCiqGoodModel billCiqGood) {
		try {
			HttpSession session = request.getSession();
			UserInfoDTO user = (UserInfoDTO)session.getAttribute(Constants.USER_KEY);
			if (billCiqGood.getInsp_user() == null) {
				billCiqGood.setInsp_user("1");
			}
			
			billCiqGood.setBill_no(billCiqGood.getBill_no() == null ? null
					: billCiqGood.getBill_no().trim());
			billCiqGood.setDecl_no(billCiqGood.getDecl_no() == null ? null
					: billCiqGood.getDecl_no().trim());
			int pages = 1;
			if (request.getParameter("page") != null
					&& !"".equals(request.getParameter("page"))) {
				pages = Integer
						.parseInt(request.getParameter("page") == null ? "1"
								: request.getParameter("page"));
			}
			billCiqGood.setFirstRcd(String.valueOf((pages - 1)
					* Constants.PAGE_NUM + 1));
			billCiqGood.setLastRcd(String.valueOf(pages * Constants.PAGE_NUM
					+ 1));
			billCiqGood.setOrg_code(user.getOrg_code());
			if("210100".equals(user.getOrg_code())){
				billCiqGood.setPort_dept_code(user.getDept_code());
			}
			List<BillCiqGoodModel> list = billLadingFlowService
					.findBillList(billCiqGood);
			int counts = billLadingFlowService.findBillCount(billCiqGood);
			List<SelectModel> deptList = commonUtil.findDeptCode(request,
					billCiqGood.getPort_dept_code());

			List<Map<String, String>> orgMap = billLadingFlowService.findOrg();
			// if(list.isEmpty()){
			// List<BillCiqGoodModel> list2 =
			// billLadingFlowService.findOldBillList(billCiqGood);
			// int counts2 =
			// billLadingFlowService.findOldBillCount(billCiqGood);
			// if(!list2.isEmpty()){
			// request.setAttribute("list", list2);
			// request.setAttribute("counts",counts2);
			// }else{
			// request.setAttribute("list", list);
			// request.setAttribute("counts",counts);
			// }
			// }else{
			request.setAttribute("list", list);
			request.setAttribute("counts", counts);
			// }
			request.setAttribute("pages", Integer.toString(pages));// 当前页码
			request.setAttribute("itemInPage", Constants.PAGE_NUM);// 每页显示的记录数
			request.setAttribute("obj", billCiqGood);
			request.setAttribute("deptList", deptList);// 科室
			request.setAttribute("orgMap", orgMap);// 科室
			List<Map<String , String>> checkList = new ArrayList<Map<String , String>>();
			Map<String , String> m1 = new HashMap<String , String>();
			m1.put("CODE", "2");
			m1.put("NAME", "未查验");		
			Map<String , String> m2 = new HashMap<String , String>();
			m2.put("CODE", "0");
			m2.put("NAME", "审单直放");		
			Map<String , String> m4 = new HashMap<String , String>();
			m4.put("CODE", "4");
			m4.put("NAME", "实验室检测");		
			Map<String , String> m5 = new HashMap<String , String>();
			m5.put("CODE", "3");
			m5.put("NAME", "查验放行");		
			Map<String , String> m3 = new HashMap<String , String>();
			m3.put("CODE", "");
			m3.put("NAME", "全部");
			checkList.add(m1);
			checkList.add(m2);
			checkList.add(m4);
			checkList.add(m5);
			checkList.add(m3);
			request.setAttribute("checkList", checkList);
			
			
		} catch (Exception e) {
			logger_.error("***********/billlading/billladingList************",
					e);
		}
		return "billlading/list";
	}

	/**
	 * 详情页面
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("/showInfo")
	public String showInfo(HttpServletRequest request,
			@RequestParam(value = "decl_no", required = true) String decl_no) {
		try {
			request.setAttribute("decl_no", decl_no);
		} catch (Exception e) {
			logger_.error("***********/billlading/showInfo************", e);
		}
		return "billlading/info";
	}

	@RequestMapping("/rlqr")
	public String rlqr(HttpServletRequest request) {
		String i = "1";
		try {
			i = request.getParameter("a");
		} catch (Exception e) {
			logger_.error("***********/billlading/rlqr************", e);
		}
		return "billlading/rlqr" + i;
	}

	@RequestMapping(value = "/sampling", method = RequestMethod.GET)
	public String sampling(HttpServletRequest request,
			HttpServletResponse response,
			@RequestParam(value = "id", required = true) String id) {
		try {
			List<LaboratoryDTO> laboratoryList = billLadingFlowService
					.queryLaboratoryById(id);
			List<LabDtailDTO> labDtailList = billLadingFlowService
					.queryLabDtailById(id);
			request.setAttribute("laboratoryList", laboratoryList.get(0));
			request.setAttribute("labDtailList", labDtailList);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "billlading/sampling_voucher";
	}

	@ResponseBody
	@RequestMapping(value = "/getData", method = RequestMethod.GET)
	public Map<String, Object> getData(HttpServletRequest request,
			HttpServletResponse response,
			@RequestParam(value = "decl_no", required = true) String decl_no,
			@RequestParam(value = "bill_id", required = true) String bill_id,
			String book_no, BillCiqGoodModel paramModel) {
		Map<String, Object> map = new HashMap<String, Object>();
		BilllingModel billlingModel = new BilllingModel();
		String type = request.getParameter("type");
		try {
			// map=this.getPaperlessInfo(request, response);
			billlingModel.setBill_id(bill_id);
			ContaEventDTO contaEvent = null;
			if (null == type || type.equals("new")) {// 新数据
				contaEvent = billLadingFlowService
						.getContaEventDTO(billlingModel);// 3派工方式,派工人员
				List<TfSysProcessLog> contaEventList1 = billLadingFlowService
						.queryTfSysProcessLogByDecl_no(decl_no);
				if (contaEventList1 != null && contaEventList1.size() != 0) {
					if (contaEvent != null) {
						contaEvent.setPlan_date(contaEventList1.get(0).getEnd_date());
					}
				} else {
					if (contaEvent != null) {
						contaEvent.setPlan_date("");
					}
				}
				
				CheckJobDTO checkJob = billLadingFlowService
						.getCheckJobDTO(billlingModel);// 3检查结果
				List<VideoEventDTO> videoEvent = billLadingFlowService
						.getVideoEventDTO(billlingModel);// 3检查时间，人员
				billlingModel.setDecl_no(decl_no);
				CiqGoodsDeclDTO goodsDecl = billLadingFlowService
						.getCiqGoodsDeclDTO(billlingModel);// 2[审单布控]，报检时间，报检企业
				BilllingModel model = billLadingFlowService
						.getBillladingData(billlingModel);// 2[审单布控]，受理
				BillLadingDTO billLading = billLadingFlowService
						.getBillLadingDTO(billlingModel);// 6[签证放行]
				billLading.setOp_str_date(DateUtil.DateToString(
						billLading.getOp_date(), "yyyy-MM-dd HH:mm:ss"));
				billlingModel.setDecl_no(decl_no);
				billlingModel.setBook_no(null != billLading ? billLading
						.getBook_no() : null);
//				billlingModel.setBook_no("DLDYW1803068478692");
				BillLadingBookingDTO billLadingBooking = billLadingFlowService
						.getBillLadingBookingDTO(billlingModel);// 6[流向监控]
				BillCiqGoodModel vo = billLadingFlowService
						.findOneBillCiqGood(billlingModel);
//				vo.setShip_name_en("TY IRIS");
				VslDecDto dec = billLadingFlowService.getVslDecOne(vo);
				paramModel.setBook_no(null);
				List<DywUnQualifyRecordDto> dywUnQualifyRecordList = billLadingFlowService
						.findDywUnQualifyRecordList(paramModel);
				List<ContaDTO> contaList = billLadingFlowService
						.contaList(billLading.getBill_no());
				List<LimsDTO> limsList = billLadingFlowService
						.queryLims(decl_no);
				
				
				/*List<ContaEventDTO> contaEventList = billLadingFlowService
						.queryContaEventCy(billLading.getBill_id());*/
				List<TfSysProcessLog> contaEventList = billLadingFlowService
						.queryTfSysProcessLog(goodsDecl.getDecl_no());
				
				
				
				
				// 查询实验室检验检疫
//				decl_no="117000007646424";
				List<LaboratoryDTO> laboratoryList = billLadingFlowService
						.queryLaboratory(decl_no);
				List<TfVsaSignRecordDTO> tfVsaList = billLadingFlowService
						.queryCertRcd(decl_no);
				

				map.put("laboratoryList", laboratoryList);
				map.put("tfVsaList", tfVsaList);
				map.put("data", model);
				map.put("contaEvent", contaEvent);
				map.put("checkJob", checkJob);
				map.put("videoEvent", videoEvent);
				map.put("billLading", billLading);
				map.put("limsList", limsList);
				map.put("contaEventList", contaEventList);
				map.put("goodsDecl", goodsDecl);
				map.put("contaList", contaList);
				map.put("billLadingBooking", billLadingBooking);
				map.put("vo", vo);
				map.put("vslDec", dec);
				map.put("dywUnQualifyRecordList", dywUnQualifyRecordList);
			} else {// 历史数据
				contaEvent = billLadingFlowService
						.getOldContaEventDTO(billlingModel);// 3派工方式,派工人员
				List<TfSysProcessLog> contaEventList1 = billLadingFlowService
						.queryTfSysProcessLogByDecl_no(decl_no);
				if (contaEventList1 != null && contaEventList1.size() != 0) {
					if (contaEvent != null) {
						contaEvent.setPlan_date(contaEventList1.get(0).getEnd_date());
					}
				} else {
					if (contaEvent != null) {
						contaEvent.setPlan_date("");
					}
				}
				CheckJobDTO checkJob = billLadingFlowService
						.getCheckJobDTO(billlingModel);// 3检查结果
				List<VideoEventDTO> videoEvent = billLadingFlowService
						.getVideoEventDTO(billlingModel);// 3检查时间，人员
				billlingModel.setDecl_no(decl_no);
				CiqGoodsDeclDTO goodsDecl = billLadingFlowService
						.getOldCiqGoodsDeclDTO(billlingModel);// 2[审单布控]，报检时间，报检企业
				BilllingModel model = billLadingFlowService
						.getBillladingData(billlingModel);// 2[审单布控]，受理
				BillLadingDTO billLading = billLadingFlowService
						.getOldBillLadingDTO(billlingModel);// 6[签证放行]
				billLading.setOp_str_date(DateUtil.DateToString(
						billLading.getOp_date(), "yyyy-MM-dd HH:mm:ss"));
				billlingModel.setDecl_no(decl_no);
				billlingModel.setBook_no(null != billLading ? billLading
						.getBook_no() : null);
				BillLadingBookingDTO billLadingBooking = billLadingFlowService
						.getOldBillLadingBookingDTO(billlingModel);// 6[流向监控]
				BillCiqGoodModel vo = billLadingFlowService
						.findOldOneBillCiqGood(billlingModel);
				VslDecDto dec = billLadingFlowService.getVslDecOne(vo);
				paramModel.setBook_no(null);
				List<DywUnQualifyRecordDto> dywUnQualifyRecordList = billLadingFlowService
						.findDywUnQualifyRecordList(paramModel);
				map.put("data", model);
				map.put("contaEvent", contaEvent);
				map.put("checkJob", checkJob);
				map.put("videoEvent", videoEvent);
				map.put("billLading", billLading);
				map.put("goodsDecl", goodsDecl);
				map.put("billLadingBooking", billLadingBooking);
				map.put("vo", vo);
				map.put("vslDec", dec);
				map.put("dywUnQualifyRecordList", dywUnQualifyRecordList);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return map;
	}

	@ResponseBody
	@RequestMapping(value = "/getInterfice", method = RequestMethod.GET)
	public Map<String, Object> getPaperlessInfo(HttpServletRequest request,
			HttpServletResponse response) {
		Map<String, Object> map = new HashMap<String, Object>();
		try {
			// String url =
			// "http://218.25.158.51:8089/npsys_service/getAttachList?user=declsign";
			String url = "http://10.21.0.153/npsys_service/getAttachList?user=declsign";
			String password = "aqsiq2016";
			String decl_no = request.getParameter("decl_no");

			// 得到一个信息摘要器
			// String strs = "aqsiq2016"/*+DateHelp.getyyyyMMddHH()*/;
			String strs = "aqsiq2016"
					+ DateUtil.DateToString(new Date(), "yyyyMMddHH");
			MessageDigest digest = MessageDigest.getInstance("md5");
			byte[] result = digest.digest(strs.getBytes());
			StringBuffer buffer = new StringBuffer();
			// 把没一个byte 做一个与运算 0xff;
			for (byte b : result) {
				// 与运算
				int number = b & 0xff;// 加盐
				String str = Integer.toHexString(number);
				if (str.length() == 1) {
					buffer.append("0");
				}
				buffer.append(str);
			}

			byte[] bytes = decl_no.getBytes();
			SecureRandom random = new SecureRandom();
			DESKeySpec desKey = new DESKeySpec(password.getBytes());
			// 创建一个密匙工厂，然后用它把DESKeySpec转换成
			SecretKeyFactory keyFactory = SecretKeyFactory.getInstance("DES");
			SecretKey securekey = keyFactory.generateSecret(desKey);
			// Cipher对象实际完成加密操作
			Cipher cipher = Cipher.getInstance("DES");
			// 用密匙初始化Cipher对象
			cipher.init(Cipher.ENCRYPT_MODE, securekey, random);
			// 现在，获取数据并加密
			// 正式执行加密操作

			byte[] ssArr = cipher.doFinal(bytes);
			StringBuffer ssbuffer = new StringBuffer();
			// 把没一个byte 做一个与运算 0xff;
			for (byte b : ssArr) {
				// 与运算
				int number = b & 0xff;// 加盐
				String str = Integer.toHexString(number);
				if (str.length() == 1) {
					ssbuffer.append("0");
				}
				ssbuffer.append(str);
			}
			url = url + "&pwd=" + buffer.toString() + "&declno="
					+ ssbuffer.toString();

			DefaultHttpClient httpclient = new DefaultHttpClient();
			HttpGet httpget = new HttpGet(url);
			HttpResponse httpResponse = httpclient.execute(httpget);
			HttpEntity entity = httpResponse.getEntity();
			String xmlStr = EntityUtils.toString(entity);
			//
			// logger_.debug(xmlStr);
			// String xmlStr =
			// "<?xml version=\"1.0\" encoding=\"UTF-8\"?><ROOT><RESULT>0</RESULT><DESC><CONTENT><DECLNO>217000001238953</DECLNO><ATTACHS><ATTACHINFO><UUID>76DF68EFF30C48E887CB</UUID><ATTACHNAME>厂检单</ATTACHNAME><ATTACHTYPECODE>102041</ATTACHTYPECODE><ATTACHTYPENAME>厂检单</ATTACHTYPENAME><ATTACHURL>http://10.21.0.153/npsys_service/getattachinfo?attType=3&amp;attId=76DF68EFF30C48E887CB</ATTACHURL><ATTACHTIME>2017-04-24 16:47</ATTACHTIME></ATTACHINFO><ATTACHINFO><UUID>A4503D9C977A4BCFACBE</UUID><ATTACHNAME>装箱单</ATTACHNAME><ATTACHTYPECODE>102004</ATTACHTYPECODE><ATTACHTYPENAME>装箱单</ATTACHTYPENAME><ATTACHURL>http://10.21.0.153/npsys_service/getattachinfo?attType=3&amp;attId=A4503D9C977A4BCFACBE</ATTACHURL><ATTACHTIME>2017-04-26 15:30</ATTACHTIME></ATTACHINFO><ATTACHINFO><UUID>68863357FFB348F9A168</UUID><ATTACHNAME>合同</ATTACHNAME><ATTACHTYPECODE>102001</ATTACHTYPECODE><ATTACHTYPENAME>合同</ATTACHTYPENAME><ATTACHURL>http://10.21.0.153/npsys_service/getattachinfo?attType=3&amp;attId=68863357FFB348F9A168</ATTACHURL><ATTACHTIME>2017-04-26 15:28</ATTACHTIME></ATTACHINFO><ATTACHINFO><UUID>790CAFC374A7442CBCBC</UUID><ATTACHNAME>发票</ATTACHNAME><ATTACHTYPECODE>102002</ATTACHTYPECODE><ATTACHTYPENAME>发票</ATTACHTYPENAME><ATTACHURL>http://10.21.0.153/npsys_service/getattachinfo?attType=3&amp;attId=790CAFC374A7442CBCBC</ATTACHURL><ATTACHTIME>2017-04-26 15:29</ATTACHTIME></ATTACHINFO><ATTACHINFO><UUID>0F5ED07774D04461B3C6</UUID><ATTACHNAME>配舱回执</ATTACHNAME><ATTACHTYPECODE>102999</ATTACHTYPECODE><ATTACHTYPENAME>其他单据</ATTACHTYPENAME><ATTACHURL>http://10.21.0.153/npsys_service/getattachinfo?attType=3&amp;attId=0F5ED07774D04461B3C6</ATTACHURL><ATTACHTIME>2017-04-26 15:31</ATTACHTIME></ATTACHINFO><ATTACHINFO><UUID>DAF866A342424A60A3C4</UUID><ATTACHNAME>无木质包装声明</ATTACHNAME><ATTACHTYPECODE>102999</ATTACHTYPECODE><ATTACHTYPENAME>其他单据</ATTACHTYPENAME><ATTACHURL>http://10.21.0.153/npsys_service/getattachinfo?attType=3&amp;attId=DAF866A342424A60A3C4</ATTACHURL><ATTACHTIME>2017-04-26 15:32</ATTACHTIME></ATTACHINFO></ATTACHS></CONTENT></DESC></ROOT>";

			int i = xmlStr.indexOf("<RESULT>");
			int j = xmlStr.indexOf("</RESULT>");
			String resultStr = xmlStr.substring(i, j).replace("<RESULT>", "");
			CiqPaperLessAttachBean ciqPaperLessAttachBean = new CiqPaperLessAttachBean();
			if ("0".equals(resultStr)) {
				ciqPaperLessAttachBean = XmlUtil.toBean(xmlStr,
						CiqPaperLessAttachBean.class);
				map.put("resultStr", resultStr);
				map.put("list", ciqPaperLessAttachBean.getDESC().getCONTENT()
						.getATTACHS().getATTACHINFO());
				map.put("decl_no", ciqPaperLessAttachBean.getDESC()
						.getCONTENT().getDECLNO());
			}
			if ("1".equals(resultStr)) {
				map.put("resultStr", resultStr);
				map.put("desc",
						xmlStr.substring(xmlStr.indexOf("<DESC>"),
								xmlStr.indexOf("</DESC>"))
								.replace("<DESC>", ""));
			}

		} catch (Throwable e) {
			logger_.error(e.getMessage());
			e.printStackTrace();
		}
		return map;
	}

	/**
	 * 跳转电子表格
	 * 
	 * @param request
	 * @return
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	@RequestMapping("/billladingText")
	public String jumpText(HttpServletRequest request,
			BillCiqGoodModel paramModel) {
		String t = request.getParameter("t");
		t = t == null || t.equals("1") ? "" : "3";
		try {
			if (!t.equals("3")) {
				String type = request.getParameter("type");
				String good = "";
				if (null != type && type.equals("new")) {
					BillladingBookModel book = billLadingFlowService
							.findBillladingBook(paramModel);
					List<BillladingBookModel> goods = billLadingFlowService
							.findGoodsName(paramModel);
					if (!goods.isEmpty()) {
						for (BillladingBookModel g : goods) {
							good += g.getGoods_cname() + ",";
						}
					}
					if (null != paramModel.getBook_no()) {
						List<DywUnQualifyRecordDto> dywUnQualifyRecordList = billLadingFlowService
								.findDywUnQualifyRecordList(paramModel);
						if (!dywUnQualifyRecordList.isEmpty()) {
							request.setAttribute("obj",
									dywUnQualifyRecordList.get(0));
						}
					}
					request.setAttribute("book", book);
					// good.substring(0, good.length()-1);
					request.setAttribute("goods", good);
				}
			} else {
				String billId = paramModel.getBill_id();
				String bookNo = paramModel.getBook_no();
				// sentSmsService.SentSMS("13130496439","billId"+billId+"bookNo"+bookNo);
				Map queryMap = new HashMap();
				queryMap.put("billId", billId);
				queryMap.put("bookNo", bookNo);
				// 提单信息
				XunJobDTO billInfo = billLadingFlowService
						.queryXunbill(queryMap);
				// 熏蒸信息
				List xunList = billLadingFlowService.queryXunJob(queryMap);
				XunJobDTO xunJobDTO = new XunJobDTO();
				if (xunList != null && xunList.size() > 0) {
					String contaInfo = "";
					for (int i = 0; i < xunList.size(); i++) {
						if (contaInfo.length() > 1000) {
							break;
						} else {
							contaInfo += ((XunJobDTO) xunList.get(i))
									.getConta_no()
									+ "/"
									+ ((XunJobDTO) xunList.get(i))
											.getConta_model()
									+ "/"
									+ ((XunJobDTO) xunList.get(i))
											.getGoods_volume() + ";";
						}
					}
					xunJobDTO = (XunJobDTO) xunList.get(0);
					xunJobDTO.setBook_no(billInfo.getBook_no());
					xunJobDTO.setDec_org_name(billInfo.getDec_org_name());
					xunJobDTO.setDec_user(billInfo.getDec_user());
					xunJobDTO.setOrigin_country_name(billInfo
							.getOrigin_country_name());
					xunJobDTO.setDecl_no(billInfo.getDecl_no());
					xunJobDTO.setTelephone(billInfo.getTelephone());
					xunJobDTO.setGoods_cname(billInfo.getGoods_cname());
					xunJobDTO.setWeight(billInfo.getWeight());
					xunJobDTO.setWeight_unit_name(billInfo
							.getWeight_unit_name());
					xunJobDTO.setQty(billInfo.getQty());
					xunJobDTO.setQty_unit_name(billInfo.getQty_unit_name());
					xunJobDTO.setWood_count(billInfo.getWood_count());
					xunJobDTO.setLand_area_code(billInfo.getLand_area_code());
					xunJobDTO.setLand_place(billInfo.getLand_place());
					xunJobDTO.setConta_mode20(billInfo.getConta_mode20());
					xunJobDTO.setConta_mode40(billInfo.getConta_mode40());
					xunJobDTO.setConta_model(contaInfo);
				}
				request.setAttribute("xunJobDTO", xunJobDTO);

			}
		} catch (Exception e) {
			logger_.error("***********/billlading/billladingText************",
					e);
		}
		return "billlading/book" + t;
	}

	@RequestMapping("/showCar")
	public String showCar(HttpServletRequest request,
			@RequestParam(value = "conta", required = true) String conta) {
		try {
			request.setAttribute("conta", conta);
		} catch (Exception e) {
			logger_.error("***********/billlading/showCar************", e);
		}
		return "billlading/car";
	}
	
	
	@RequestMapping("/showShip")
	public String showShip(HttpServletRequest request,
			@RequestParam(value = "shipname", required = true) String shipname) {
		try {
			request.setAttribute("shipname", shipname);
		} catch (Exception e) {
			logger_.error("***********/billlading/showShip************", e);
		}
		return "billlading/shipxy";
	}

	@RequestMapping("/queryLimsContent")
	public void queryLimsContent(HttpServletRequest request,
			HttpServletResponse response,
			@RequestParam(value = "id", required = true) String id) {
		try {
			LimsDTO limsDTO = billLadingFlowService.queryLimsContent(id);
			String contentType = "application/x-msdownload";
			if (limsDTO != null) {
				String fileName = "";
				// 判断获取文件类型
				String fileType = FileUtil.judgeFileType(limsDTO.getContent());
				// 将文件落在服务器上
				FileUtil.createFileByDB(id + "." + fileType,
						limsDTO.getContent());

				fileName = id + "." + fileType;

				if ("doc".equals(fileType) || "docx".equals(fileType)) {
					FileUtil.wordToPdf(id + "." + fileType, id + ".pdf");
					fileName = id + ".pdf";
				}
				try {
					File file = new File(Constants.LIMS_FILE_PATH + fileName);
					if (file.exists()) {
						String filename = file.getName();
						filename = URLEncoder.encode(file.getName(), "GB2312");
						response.reset();
						response.setContentType(contentType);
						response.addHeader("Content-Disposition",
								"attachment; filename=\"" + filename + "\"");
						int fileLength = (int) file.length();
						response.setContentLength(fileLength);
						if (fileLength != 0) {
							InputStream inStream = new FileInputStream(file);
							ServletOutputStream servletOS = response
									.getOutputStream();
							byte buf[] = new byte[4096];
							int readLength;
							while ((readLength = inStream.read(buf)) != -1)
								servletOS.write(buf, 0, readLength);
							inStream.close();
							servletOS.flush();
							servletOS.close();
						}
						response.setStatus(200);
						response.flushBuffer();
					}
				} catch (Exception ex) {
					contentType = "text/html; charset=UTF-8";
					response.setContentType(contentType);
					PrintWriter out = response.getWriter();
					out.println("<html>");
					out.println("<head><title>Servlet1</title></head>");
					out.println("<body bgcolor=\"#ffffff\">");
					out.println("<p><script type=\"text/javascript\">");
					out.println("alert('\u6587\u4EF6\u4E0B\u8F7D\u5931\u8D25...');");
					out.println("window.opener=null;window.close();");
					out.println("</script></p>");
					out.println("</body>");
					out.println("</html>");
					out.close();
					throw new ServletException(ex);
				}
			}
		} catch (Exception e) {
			logger_.error(
					"***********/billlading/queryLimsContent************", e);
		}
	}
	
	/**
	 * 提单详情
	 */
	@RequestMapping("/billDetailByNo")
	public String billDetailByNo(HttpServletRequest request,
			HttpServletResponse response,
			@RequestParam(value = "billNo", required = true) String billNo) {
		
		try {
			BillLadingDTO2 billLadingDTO  = billLadingFlowService.billDetailByNo(billNo);
			String status = billLadingDTO.getStatus();
			 String now_Sta="";
			   if(!"0".equals(status.substring(8,9))) now_Sta="已放行"; 
			   else if("1".equals(status.substring(7,8))) now_Sta="检验完毕";
			   else if("1".equals(status.substring(3,4))) now_Sta="查验中";
			   else if(!"0".equals(status.substring(2,3))) now_Sta="提箱预约";
			   billLadingDTO.setStatus(now_Sta);
			request.setAttribute("billLadingDTO", billLadingDTO);
		} catch (Exception e) {
			logger_.error(
					"***********/billlading/billDetailByNo************", e);
		}
		return "billlading/billDetail";
	}
	
	/**
	 * 报检详情
	 */
	@SuppressWarnings("rawtypes")
	@RequestMapping("/declDetailByNo")
	public String declDetailByNo(HttpServletRequest request,
			HttpServletResponse response,
			@RequestParam(value = "declNo", required = true) String declNo) {
		GoodsDTO goodsDTO;
		try {
			goodsDTO = billLadingFlowService.getCiq2000DeclByEx(declNo);
			List goodsDTOList = billLadingFlowService.getCiq2000GoodsByEx(declNo);
			request.setAttribute("goodsDTO", goodsDTO);
			request.setAttribute("goodsDTOList", goodsDTOList);
		} catch (Exception e) {
			logger_.error(
					"***********/billlading/declDetailByNo************", e);
		}
		return "billlading/declDetail";
	}
	
	/**
	 * 获取报警信息
	 * @throws Exception 
	 */

	
	@RequestMapping("/getWaring")
	public void getWaring(HttpServletRequest request,
			HttpServletResponse response,
			@RequestParam(value = "bill_id", required = true) String bill_id) {
		try {
			response.reset();
			WarningDto w=new WarningDto();
			w.setBill_id(bill_id);
			List<WarningDto> list = billLadingFlowService.getWarningDto(w);
			if(list.size()>0){
				String docname=list.get(0).getWarning_id();
				String filePath=Constants.UP_LOAD_P+"warningDoc/"+docname+".doc";
				File f = new File(filePath);
			        if (!f.exists()) {
			            response.sendError(404, "File not found!");
			            return;
			        }
			        int size=(int) f.length();
			        BufferedInputStream br = new BufferedInputStream(new FileInputStream(f));
			        byte[] buf = new byte[1024];
			        int len = 0;
			        response.reset(); 
			        response.setContentType("application/x-msdownload");
			        response.setContentLength(size);
			        String fileName = new String(f.getName().getBytes(), "ISO-8859-1"); 
			        response.setHeader("Content-Disposition", "attachment; filename=" + fileName);
			        OutputStream out = response.getOutputStream();
			        while ((len = br.read(buf)) > 0)
			            out.write(buf, 0, len);
			        br.close();
			        out.close();
			}
		
		} catch (Exception e) {
			logger_.error(
					"***********/billlading/getWaring************", e);
		}
	}
	
	
}
