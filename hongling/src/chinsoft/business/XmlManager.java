package chinsoft.business;

import hongling.business.StyleProcessManager;
import hongling.entity.StyleProcess;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;
import java.io.StringReader;
import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.bind.JAXBContext;
import javax.xml.bind.Marshaller;
import javax.xml.bind.Unmarshaller;
import javax.xml.namespace.QName;

import org.apache.axis2.addressing.EndpointReference;
import org.apache.axis2.client.Options;
import org.apache.axis2.rpc.client.RPCServiceClient;
import org.apache.axis2.transport.http.HTTPConstants;
import org.hibernate.Query;
import org.jdom.Document;
import org.jdom.Element;
import org.jdom.JDOMException;
import org.jdom.Text;
import org.jdom.input.SAXBuilder;
import org.jdom.xpath.XPath;
import org.xml.sax.InputSource;

import centling.business.BlDeliveryManager;
import chinsoft.core.DEncrypt;
import chinsoft.core.DataAccessObject;
import chinsoft.core.HttpContext;
import chinsoft.core.LogPrinter;
import chinsoft.core.ResourceHelper;
import chinsoft.core.Utility;
import chinsoft.entity.BlOrdenLadeXmlBean;
import chinsoft.entity.Customer;
import chinsoft.entity.Delivery;
import chinsoft.entity.Dict;
import chinsoft.entity.EcodeRedirect;
import chinsoft.entity.Embroidery;
import chinsoft.entity.Fabric;
import chinsoft.entity.Logistic;
import chinsoft.entity.LogisticXMLBean;
import chinsoft.entity.Member;
import chinsoft.entity.Orden;
import chinsoft.entity.OrdenDetail;
import chinsoft.entity.OrdenDetailXMLBean;
import chinsoft.entity.OrdenXMLBean;
import chinsoft.entity.Receipt;
import chinsoft.entity.SizeStandard;
import chinsoft.service.core.ChangeVersion;
import chinsoft.wsdl.IServiceToBxppServiceLocator;

public class XmlManager {
	private static RPCServiceClient serviceClient;

	public static Object invokeService(String strAddress, String strNameSpace,
			String strMethodName, Object[] params, Class<?>[] classTypes)
			throws Exception {
		EndpointReference targetEPR = new EndpointReference(strAddress);
		serviceClient = new RPCServiceClient();
		Options options = serviceClient.getOptions();
		options.setManageSession(true);
		options.setTimeOutInMilliSeconds((long)60000);
		options.setProperty(HTTPConstants.REUSE_HTTP_CLIENT, true);
		options.setTo(targetEPR);
		QName opAddEntry = new QName(strNameSpace, strMethodName);
		Object[] objs = serviceClient.invokeBlocking(opAddEntry, params,
				classTypes);
		serviceClient.cleanupTransport();// 防止连接超时
		if (objs != null) {
			return objs[0];
		} else {
			return "";
		}
	}

	// 保存订单-BXPP
	public String submitToErp(Orden orden) {
		String strResult = "";
		String strXml = "";
		try{
			strXml = getXmlFromOrden(orden);
			LogPrinter.info(orden.getOrdenID() + "订单提交前时间：" + new Date()+"/n"+strXml);
		} catch (Exception e) {
			e.printStackTrace();
			return "Error";
		}
		try {
			strResult = new IServiceToBxppServiceLocator().getIServiceToBxppPort().doSaveOrder(strXml);
			LogPrinter.info(orden.getOrdenID() + "订单提交后时间：" + new Date());
		} catch (Exception e) {
			LogPrinter.info(orden.getOrdenID() + "订单提交后异常时间：" + new Date());
			e.printStackTrace();
			return "Bl_Error_152";
		}
		return strResult;
	}
	
	// 预提交订单
		public String preSubmitToErp(Orden orden,String tg,String tgkd,String fk) {
			String strResult = "OK";
			String strXml = "";
			try{
				strXml = getXmlFromOrden(orden);
				LogPrinter.info(orden.getOrdenID() + "预提交订单：" + new Date()+"/n"+strXml);
			} catch (Exception e) {
				e.printStackTrace();
				return "订单信息获取失败";
			}
			try {
				strResult = new IServiceToBxppServiceLocator().getIServiceToBxppPort().doAdvanceSaveOrder(strXml,tg,tgkd,fk);
			} catch (Exception e) {
				e.printStackTrace();
				return "Bl_Error_152";
			}
			return strResult;
		}

	public String getDictEcodes(Dict dictClothing,List<Dict> ordersProcessList, Orden orden, boolean isExist) {
		List<Dict> processLists = new ArrayList<Dict>();
		String strOrdersProcess = "";
		int labelN = 0, labelM = 0;// 累计
		String strLabelPosition = "";
		Dict dictContrast = null;
		boolean isEcodeExist = false;
		for (Dict component : ordersProcessList) {
			if (component.getEcode() != null && !"".equals(component.getEcode())) {
				Dict dictParent = DictManager.getDictByID(component.getParentID());
				if (dictParent != null) {
					// 处理客户名牌
					if (Utility.contains("2827,4265,1589,6056", dictParent.getID().toString())) {
						isEcodeExist = true;
					}

					if (dictParent.getEcode() != null && !"".equals(dictParent.getEcode())) {// 扣子、锁眼线色、里料等
						// strOrdersProcess+=dictParent.getEcode()+":"+component.getEcode()+",";
						if (Utility.contains(CDict.CONTRASTALL,Utility.toSafeString(dictParent.getParentID()))) {
							dictContrast = component;
						} else {// 撞色面料
							strOrdersProcess += dictParent.getEcode() + ":"+ component.getEcode() + ",";
						}
					} else {
						if (Utility.contains(CDict.CUSTOMERLABELID,
								Utility.toSafeString(component.getID()))) {// 商标、面料标自定义内容ID
							labelN++; // 剔除
						} else {
							if (component.getStatusID() != null
									&& component.getStatusID().equals(CDict.ComponentText.getID())) {
								strOrdersProcess += component.getEcode() + ":"
										+ component.getMemo() + ",";// 客户指定内容
							} else {
								if (Utility.contains(CDict.CUSTOMERLABELSITEID,
										Utility.toSafeString(component.getParentID()))) {// 商标、面料标位置ID
									labelM++;
									if (orden.getComponentTexts() != null
											&& !"".equals(orden.getComponentTexts())) {
										String[] strComponentTexts = orden.getComponentTexts().split(",");
										strLabelPosition += dictParent.getParentID() + ",";
										for (int j = 1; j < strComponentTexts.length; j++) {
											String[] ComponentText = strComponentTexts[j]
													.split(":");
											Dict dict = DictManager.getDictByID(Utility.toSafeInt((ComponentText[0])));
											if (dict.getParentID().equals(
													dictParent.getParentID())&& ComponentText.length > 1) {
												strOrdersProcess += component.getEcode()
														+ ":"+ ComponentText[1]+ ",";// 位置:自定义内容
												break;
											} else if (dict.getParentID().equals(dictParent.getParentID())
													|| j == strComponentTexts.length - 1) {
												strOrdersProcess += component.getEcode() + ": ,";
												break;
											}
										}
									}
								} else {// 普通工艺
									strOrdersProcess += component.getEcode()+ ",";
									processLists.add(component);
								}
							}
						}
					}
				}
			}
		}

		// 处理客户名牌
		if ((isExist && ordersProcessList.size() == 0) || (isExist && !isEcodeExist)) {
			if (dictClothing.getEcode().equals("MXF")) {
				strOrdersProcess += "0873,";
			} else if (dictClothing.getEcode().equals("MXK")) {
				strOrdersProcess += "3652,";
			} else if (dictClothing.getEcode().equals("MMJ")) {
				strOrdersProcess += "46D1,";
			} else if (dictClothing.getEcode().equals("MDY")) {
				strOrdersProcess += "6873,";
			}
		}
		boolean contrast = false;
		for (Dict d : processLists) {
			Dict dictParent = DictManager.getDictByID(d.getParentID());
			if (Utility.contains(CDict.CONTRASTALL,Utility.toSafeString(dictParent.getParentID()))
					&& dictParent != null) {
				if (dictContrast != null) {
					strOrdersProcess = strOrdersProcess.replace(d.getEcode()+ ",", 
							d.getEcode() + ":" + dictContrast.getEcode()+ ",");
					contrast = true;
				} else {// 默认面料
					String strDefault = CDict.DEFAULTFABRIC;// 西服、西裤、马夹
					if ("3000".equals(Utility.toSafeString(dictClothing.getID()))) {
						strDefault = CDict.CYDEFAULTFABRIC;// 衬衣
					} else if ("6000".equals(Utility.toSafeString(dictClothing.getID()))) {
						strDefault = CDict.DYDEFAULTFABRIC;// 大衣
					}
					strOrdersProcess = strOrdersProcess.replace(d.getEcode()+ ",", 
							d.getEcode() + ":" + strDefault + ",");
				}
			}
		}
		if (dictContrast != null && contrast == false) {// 没录撞色位置
			Dict dictParent = DictManager.getDictByID(dictContrast.getParentID());
			strOrdersProcess += dictParent.getEcode() + ":"+ dictContrast.getEcode() + ",";
		}
		if (labelN != labelM && orden.getComponentTexts() != null
				&& !"".equals(orden.getComponentTexts())) {// 面料标、商标--有内容，无位置
			String[] strComponentTexts = orden.getComponentTexts().split(",");
			for (int j = 1; j < strComponentTexts.length; j++) {
				String[] ComponentText = strComponentTexts[j].split(":");
				if (ComponentText.length > 1) {
					Dict dict = DictManager.getDictByID(Utility.toSafeInt((ComponentText[0])));
					if (dict.getCode().substring(0, 4).equals(dictClothing.getCode())
							&& Utility.contains(CDict.LABELPARENTID,Utility.toSafeString(dict.getParentID()))) {
						if (!Utility.contains(strLabelPosition,Utility.toSafeString(dict.getParentID()))) {
							strOrdersProcess += dict.getEcode() + ":"+ ComponentText[1] + ",";
						}
					}
				}
			}
		}
		String strOrderProcess = strOrdersProcess;// 纯订单工艺
		List<Dict> defaultComponents = new OrdenManager().GetComponent(
				ordersProcessList, dictClothing.getID(), orden.getFabricCode());
		String strDefaultComponents = "";
		if (ordersProcessList.size() > 0) {// 默认工艺
			for (Dict dict : defaultComponents) {
				if (dict.getEcode() != null) {
					strOrdersProcess += dict.getEcode() + ",";
					strDefaultComponents += dict.getEcode() + ",";// 纯默认工艺
				}
			}
		}
		strOrdersProcess = EcodeRedirect("," + strOrdersProcess);// 代码拆分
		if (ordersProcessList.size() > 0) {
			for (Dict dict : defaultComponents) {
				if (dict.getEcode() != null) {
					if (strOrdersProcess.contains("," + dict.getEcode() + ",")) {
						strOrdersProcess = strOrdersProcess.replace("," + dict.getEcode() + ",", ",");
					}
				}
			}
		}
		strDefaultComponents = EcodeRedirect("," + strDefaultComponents);// 默认工艺代码拆分
		String[] strDefault = Utility.getStrArray(strDefaultComponents);
		for (String str : strDefault) {
			// 剔除订单未选择的默认工艺
			if (strOrdersProcess.contains("," + str + ",") && !strOrderProcess.contains("," + str + ",")) {
				strOrdersProcess = strOrdersProcess.replace("," + str + ",",",");// 剔除默认工艺代码拆分
			}
		}
		// 撞色工艺替换
		String[] strProcess = strOrdersProcess.split(",");// 工艺ecode
		if (CDict.ClothingShangYi.getID().equals(dictClothing.getID())) {// 上衣
			String strPocket = CDict.CONTRAST_POCKET_DG;// 撞色--袋盖下口袋
			if (strOrdersProcess.contains("," + strPocket + ":")) {// 存在下口袋撞色
				for (int i = 1; i < strProcess.length; i++) {
					if (CDict.POCKET_KX.contains("," + strProcess[i] + ",")) {// 开线下口袋
						strOrdersProcess = strOrdersProcess.replace(","+ strPocket + ":", 
								","+ CDict.CONTRAST_POCKET_KX + ":");
						break;
					} else if (CDict.POCKET_MT.contains("," + strProcess[i]+ ",")) {// 明贴下口袋
						strOrdersProcess = strOrdersProcess.replace(","+ strPocket + ":", 
								","+ CDict.CONTRAST_POCKET_MT + ":");
						break;
					}
				}
			}
			String strTicketPocket = CDict.CONTRAST_TICKETPOCKET_DG;// 撞色-票袋袋盖
			if (strOrdersProcess.contains("," + strTicketPocket + ":")) {
				for (int i = 1; i < strProcess.length; i++) {
					if (CDict.TICKETPOCKET_KX.contains("," + strProcess[i]+ ",")) {// 票袋开线
						strOrdersProcess = strOrdersProcess.replace(","+ strTicketPocket + ":", 
								","+ CDict.CONTRAST_TICKETPOCKET_KX + ":");
						break;
					}
				}
			}

		} else if (CDict.ClothingMaJia.getID().equals(dictClothing.getID())) {// 马夹
			String strBesom = CDict.CONTRAST_CHEST_POCKET_DG;// 撞色-胸口袋袋盖
			if (strOrdersProcess.contains("," + strBesom + ":")) {
				for (int i = 1; i < strProcess.length; i++) {
					if (CDict.CHEST_POCKET_KX.contains("," + strProcess[i]+ ",")) {// 胸袋开线
						strOrdersProcess = strOrdersProcess.replace(","+ strBesom + ":", 
								","+ CDict.CONTRAST_CHEST_POCKET_KX + ":");
						break;
					}
				}
			}
			String strPocketFlap = CDict.CONTRAST_POCKET_FLAP_DG;// 撞色-下口袋袋盖
			if (strOrdersProcess.contains("," + strPocketFlap + ":")) {
				for (int i = 1; i < strProcess.length; i++) {
					if (CDict.POCKET_FLAP_KX.contains("," + strProcess[i] + ",")) {// 下口袋开线
						strOrdersProcess = strOrdersProcess.replace(","+ strPocketFlap + ":", 
								","+ CDict.CONTRAST_POCKET_FLAP_KX + ":");
						break;
					}
				}
			}
		} else if (CDict.ClothingChenYi.getID().equals(dictClothing.getID())) {// 衬衣
			// 立领 上领面5552 底领里5549 改为 立领配色 领子面配色5518 领子里配色5517
			if (strOrdersProcess.contains(",5250,")) {// 立领
				if (strOrdersProcess.contains(",5552:")) {
					strOrdersProcess = strOrdersProcess.replace(",5552:",",5518:");
				}
				if (strOrdersProcess.contains(",5549:")) {
					strOrdersProcess = strOrdersProcess.replace(",5549:",",5517:");
				}
			}

			// 衬衣锁眼形式 无 袖头锁45度斜眼560B 袖头锁横眼560A 袖头锁135度斜眼560C
			// 直带袖袢三眼一扣 \法式直带袢六眼两扣 \法式直带袢三眼一扣\
			// 短袖--短袖内握\短袖假翻边\短袖内握袖口开衩\短袖假翻边,袖口开叉\短袖袖口外挂边\短袖假翻边,袖口开叉钉一粒扣
			String[] strCuffs = Utility.getStrArray(CDict.CUFF);
			for (String strCuff : strCuffs) {
				if (strOrdersProcess.contains("," + strCuff + ",")) {
					if (strOrdersProcess.contains(",560B,")) {// 袖头锁45度斜眼-剔除
						strOrdersProcess = strOrdersProcess.replace(",560B,",",");
						break;
					} else if (strOrdersProcess.contains(",560A,")) {// 袖头锁横眼-剔除
						strOrdersProcess = strOrdersProcess.replace(",560A,",",");
						break;
					} else if (strOrdersProcess.contains(",560C,")) {// 袖头锁135度斜眼-剔除
						strOrdersProcess = strOrdersProcess.replace(",560C,",",");
						break;
					}
				}
			}
		}
		/*
		 * for(String str : strProcess){ if(Utility.contains(CDict.CHEN_ALL,
		 * str)){ strOrdersProcess=strOrdersProcess.replace(","+str+",",
		 * ",");//剔除衬类型 } }
		 */
		
		//剔除重复值
		String[] processIDs = strOrdersProcess.substring(1).split(",");
		String process = ",";
		if(!"".equals(strOrdersProcess.substring(1))){
			for(int i=0; i<processIDs.length; i++){
				if(!process.contains(","+processIDs[i]+",")){
					process = process + processIDs[i] + ",";
				}
			}
			process = process.substring(1);
		}
		
		return process;
//		return strOrdersProcess.substring(1);
	}

	// 代码拆分处理
	public String EcodeRedirect(String components) {
		List<EcodeRedirect> ecodeRedirects = new EcodeRedirectManager()
				.getEcodeRedirects();
		String strEcode = "";
		for (EcodeRedirect ecodeRedirect : ecodeRedirects) {
			String[] splits = Utility.getStrArray(ecodeRedirect.getSplits());
			int state = 0;
			for (String split : splits) {
				if (Utility.contains(components, split)) {
					state++;
				}
			}
			if (state == splits.length) {
				strEcode += ecodeRedirect.getEcode() + ",";
				for (String split : splits) {
					if (Utility.contains(components, split)) {
						components = components.replace("," + split + ",", ",");
					}
				}
			}
		}
		return components + strEcode;
	}

	public String getXmlFromOrden(Orden orden) {
		// 代码拆分
		orden.setComponents(orden.getComponents());
		DecimalFormat df2 = new DecimalFormat("###.0");
		OrdenXMLBean xmlBean = new OrdenXMLBean();
		xmlBean.setCustomerOrdersNo(orden.getOrdenID());
		xmlBean.setOrderDate(Utility.toSafeString(orden.getPubDate()));
		xmlBean.setContractSerialNumber(orden.getSysCode());
		// xmlBean.setCreateman(CurrentInfo.getCurrentMember().getUsername());
		if (!"".equals(orden.getUsername()) && orden.getUsername() != null) {
			xmlBean.setCreateman(orden.getUsername());
		} else {
			xmlBean.setCreateman(CurrentInfo.getCurrentMember().getUsername());
		}
		xmlBean.setFabrics(orden.getFabricCode());

		// 客户信息
		Customer customer = orden.getCustomer();
		Member member = new MemberManager().getMemberByID(orden.getPubMemberID());
		if (customer != null) {
			String strOwnedPartner = "";
			String strOwnedStore = "";
			String strHeight = "";
//			Member member = new MemberManager().getMemberByID(orden
//					.getPubMemberID());
			if (member.getIsUserNo().equals(CDict.YES.getID())) {
				xmlBean.setCustomerOrdersNo(orden.getUserordeNo());
			}
			xmlBean.setCustomerName(customer.getName());
			if (member != null) {
				strOwnedPartner = member.getOwnedPartner();
				strOwnedStore = member.getOwnedStore();
			}
			if (CDict.UnitInch.getID().equals(customer.getHeightUnitID())) {
				strHeight = Utility
						.toSafeString(df2.format(new BigDecimal(customer
								.getHeight()).multiply(new BigDecimal("2.54"))));
			} else {
				strHeight = Utility.toSafeString(customer.getHeight());
			}
			xmlBean.setOwnedPartner(strOwnedPartner);
			xmlBean.setOwnedStore(strOwnedStore);
			xmlBean.setHeight(strHeight);
			xmlBean.setWeight(Utility.toSafeString(customer.getWeight()));
			xmlBean.setOperatorName(customer.getLtName());// 量体人员姓名
			//系统单号以“TX”开头，并且部门不为空，将部门追加到用户后面以冒号隔开
//			if("TX".equals(orden.getSysCode().substring(0, 2)) && !"".equals(customer.getEmail())){
//				xmlBean.setCreateman(xmlBean.getCreateman()+":"+ customer.getEmail());
//			}
			
			//性别 1男 0女
			xmlBean.setGender("1");
			if("10041".equals(Utility.toSafeString(customer.getGenderID()))){
				xmlBean.setGender("0");
			}
		}
		// 客户单号
		if (!"".equals(orden.getUserordeNo())) {
			xmlBean.setUserordeno(orden.getUserordeNo());
		}
		// 特体信息
		String strBodyType = orden.getSizeBodyTypeValues();
		if (strBodyType != null && !"".equals(strBodyType)) {
			xmlBean.setCustormerBody(this.createBodyType(orden));
		}
		//产品
		Dict dict = DictManager.getDictFromDB(orden.getClothingID());
		String name = orden.getClothingName();
		if (orden.getClothingID() != null && !"".equals(orden.getClothingID())) {
			if (orden.getMorePants() == 10050) {
				name = dict.getName()+"+西裤";
			} else if (orden.getMorePants() == 10051) {
				name = "1 " + dict.getName();
			} else {
				name = orden.getMorePants() +" " + dict.getName();
			}
		}
		xmlBean.setProduct(name);
		//产品金额
		xmlBean.setMoney(Utility.toSafeString(orden.getOrdenPrice()));
		//电话
		if(member.getPriceType() == 20141){//直营店
			xmlBean.setTelPhone(customer.getTel());
		}

		// 量体信息
		if (orden.getSizeCategoryID() == CDict.CUSTORMERSIZEID) {// 净体量体
			if (!"".equals(orden.getSizePartValues())
					&& orden.getSizePartValues() != null) {
				String[] custormerSizes = Utility.getStrArray(orden
						.getSizePartValues());
				for (String idValue : custormerSizes) {
					if (!"".equals(idValue)) {
						String[] idvalue = idValue.split(":");
						if (idvalue.length == 2) {
							String ecode = DictManager.getDictByID(
									Utility.toSafeInt(idvalue[0])).getEcode();
							if (CDict.UnitInch.getID().equals(
									orden.getSizeUnitID())) {
								xmlBean.setCustormerSize(Utility
										.toSafeString(xmlBean
												.getCustormerSize())
										+ ecode
										+ ":"
										+ df2.format(new BigDecimal(idvalue[1])
												.multiply(new BigDecimal("2.54")))
										+ ",");
							} else {
								xmlBean.setCustormerSize(Utility
										.toSafeString(xmlBean
												.getCustormerSize())
										+ ecode + ":" + idvalue[1] + ",");
							}
						}
					}
				}

			}
		}

		// 订单锁定 --善融1，红领0
		xmlBean.setLocking(Utility.toSafeString(orden.getLocking()));
		// 订单明细
		xmlBean.setDetails(createOrderDetail(orden));
		// 订单物流
		xmlBean.setLogistic(createLogistic(orden));
		String xml = "";
		try {
			JAXBContext context = JAXBContext.newInstance(OrdenXMLBean.class);
			Marshaller marshaller = context.createMarshaller();
			marshaller.setProperty(Marshaller.JAXB_ENCODING, "GB2312");
			marshaller.setProperty(Marshaller.JAXB_FORMATTED_OUTPUT, true);
			ByteArrayOutputStream os = new ByteArrayOutputStream();
			marshaller.marshal(xmlBean, os);
			xml = new String(os.toByteArray());
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return xml;
	}

	private List<OrdenDetailXMLBean> createOrderDetail(Orden orden) {
		List<OrdenDetailXMLBean> ordenDetail = new ArrayList<OrdenDetailXMLBean>();
		Member member = new MemberManager().getMemberByID(orden.getPubMemberID());
		String interliningType = member.getLiningType();//默认衬类型
		for (OrdenDetail detail : orden.getOrdenDetails()) {
			OrdenDetailXMLBean newDetail = new OrdenDetailXMLBean();

			newDetail.setModel("");
			// 面料价+加工费+工艺价格
			Double totalNum = Double.valueOf(0);
			detail.setOrdenID(orden.getOrdenID());
			// 得到订单数量
			Integer amount = detail.getAmount();
			// 得到加工费
			Double cmtPrice = detail.getCmtPrice();
			// 得到面料价格
			Double fabricPrice = detail.getFabricPrice();
			// 得到工艺价格
			Double processPrice = detail.getProcessPrice();

			// 得到订单明细的价格
			totalNum += amount * (cmtPrice + fabricPrice + processPrice);
			newDetail.setPrice(totalNum + "");// 订单价格

			// 服装类型
			Dict dictSingleClothing = DictManager.getDictByID(detail
					.getSingleClothingID());
			if (dictSingleClothing != null) {
				newDetail.setCategories(dictSingleClothing.getEcode());
			}
			
			// 毛衬类型
			String strEcode = this.getInterliningType(detail.getSingleClothingID(), orden.getComponents());
			if (!"".equals(strEcode) && !",".equals(strEcode)) {
				strEcode = strEcode.substring(1, strEcode.length() - 1);
				interliningType = strEcode;//已录入衬类型
			}else if (CDict.ClothingLF.getID().equals(detail.getSingleClothingID()) 
					&& CDict.ClothingNXF.getID().equals(detail.getSingleClothingID())){
				interliningType = "00C3";//女装默认衬类型
			}
			
			if(CDict.ClothingChenYi.getID().equals(orden.getClothingID())){
				newDetail.setInterliningType("");
			}else{
				newDetail.setInterliningType(interliningType);
			}
			
			newDetail.setQuantity(Utility.toSafeString(detail.getAmount()));

			// 着装风格（正常、修身、肥）
			// newDetail.setVersionStyle(this.createBodyStyle(orden));
			int num = 0;
			if (orden.getComponentTexts() != null
					&& !"".equals(orden.getComponentTexts())) {
				String[] styles = orden.getComponentTexts().split(",");
				for (int i = 1; i < styles.length; i++) {
					String[] style = styles[i].split(":");
					if (Utility.toSafeString(detail.getSingleClothingID())
							.equals(style[0])) {
						num++;
						Dict dict = DictManager.getDictByID(Utility
								.toSafeInt(style[1]));
						newDetail.setVersionStyle(dict.getEcode());
					}
				}
				if (num == 0) {
					newDetail.setVersionStyle(CDict.BodyStyleNormal);
				}
			} else {
				newDetail.setVersionStyle(CDict.BodyStyleNormal);
			}

			// 款式风格（正常款、长款、短款）
			if (orden.getStyleID() != null
					&& orden.getStyleID() != -1
					&& (!CDict.ClothingPants.getID().equals(detail.getSingleClothingID()) 
							&& !CDict.ClothingMaJia.getID().equals(detail.getSingleClothingID())) 
							&& !CDict.ClothingNXK.getID().equals(detail.getSingleClothingID())) {
				newDetail.setClothingStyle(DictManager.getDictByID(
						Utility.toSafeInt(orden.getStyleID())).getEcode());
			} else {
				newDetail.setClothingStyle(CDict.Normal);// 正常款
			}

			// 量体信息
			String strClothingSize = "";
			if (orden.getSizeCategoryID() != CDict.CUSTORMERSIZEID) {// 标准号、成衣
				DecimalFormat df2 = new DecimalFormat("###.0");
				if (orden.getSizePartValues() != null
						&& !"".equals(orden.getSizePartValues())) {
					List<SizeStandard> standards = new SizeManager()
							.getSizeStandard(detail.getSingleClothingID(),
									orden.getSizeCategoryID(), -1, "", "",
									CDict.UnitInch.getID());
					for (Map.Entry<Integer, Float> entry : new OrdenManager()
							.getSizePartValue(orden,
									detail.getSingleClothingID()).entrySet()) {
						for (SizeStandard standard : standards) {
							if (standard.getPartID() != null
									&& standard.getPartID().equals(
											entry.getKey())) {
								if (CDict.UnitInch.getID().equals(
										orden.getSizeUnitID())) {
									strClothingSize += Utility
											.toSafeString(standard.getEcode())
											+ ":"
											+ Utility
													.toSafeString(df2
															.format(new BigDecimal(
																	entry.getValue())
																	.multiply(new BigDecimal(
																			"2.54"))))
											+ ",";
								} else {
									strClothingSize += Utility
											.toSafeString(standard.getEcode())
											+ ":"
											+ Utility.toSafeString(entry
													.getValue()) + ",";
								}
								break;
							}
						}
					}
				}
			}
			newDetail.setClothingSize(strClothingSize);

			// 工艺信息
			newDetail.setModel("0");

			// 刺绣信息
//			List<Embroidery> embroiderys = new ClothingManager()
//					.getEmbroideryLoaction(orden, detail.getSingleClothingID());
			List<Embroidery> embroiderys =null;
			if(orden.getComponents() == null || orden.getComponents().indexOf("_")<=0){
				embroiderys = new ClothingManager().getEmbroideryLoaction(orden, detail.getSingleClothingID());
			}else{
				embroiderys = new ClothingManager().getEmbroidery(orden, detail.getSingleClothingID());
			}
			String str = "";
			boolean isExist = false;
			for (Embroidery embroidery : embroiderys) {
				if (embroidery.getLocation() != null) {
					str += embroidery.getLocation().getEcode() + ",";
					if (Utility.contains("549,2496,1046,1005", Utility
							.toSafeString(embroidery.getLocation().getEcode()))) {
						isExist = true;
					}
					if (embroidery.getColor() != null) {
						str += (embroidery.getColor().getEcode()==null ? "Dict "+embroidery.getColor().getID()+" 没有Ecode": embroidery.getColor().getEcode()) + ",";
					}
					if (embroidery.getFont() != null) {
						str += (embroidery.getFont().getEcode() ==null ? "Dict "+embroidery.getFont().getID()+" 没有Ecode": embroidery.getFont().getEcode()) + ",";
					}
					if (embroidery.getSize() != null) {
						str += (embroidery.getSize().getEcode() ==null ? "Dict "+embroidery.getSize().getID()+" 没有Ecode": embroidery.getSize().getEcode()) + ",";
					}
					if (embroidery.getContent() != null) {
						str += embroidery.getContent() + ";";
					}
				}
			}
			newDetail.setEmbroidery(str);

			// 工艺代码
			List<Dict> ordersProcessList = new ClothingManager().getOrderProcess(orden, detail.getSingleClothingID());
			Dict dictClothing = DictManager.getDictByID(detail.getSingleClothingID());// 服装分类
//			newDetail.setOrdersProcess(this.getDictEcodes(dictClothing,
//					ordersProcessList, orden, isExist));// 获取工艺组合Ecodes
			String strCodes=this.getDictEcodes(dictClothing,ordersProcessList, orden, isExist);// 获取工艺组合Ecodes
			if(!"".equals(orden.getStyleDY()) && "6000".equals(Utility.toSafeString(orden.getClothingID())) 
					&& "10052".equals(Utility.toSafeString(orden.getSizeCategoryID()))){
				strCodes+=orden.getStyleDY();
			}
			newDetail.setOrdersProcess(strCodes);

			if (orden.getComponentTexts() != null
					&& !"".equals(orden.getComponentTexts())) {
				String[] strComponentTexts = orden.getComponentTexts().split(",");
				for (int i = 1; i < strComponentTexts.length; i++) {
					String[] ComponentText = strComponentTexts[i].split(":");
					Dict dict = DictManager.getDictByID(Utility.toSafeInt((ComponentText[0])));
					String strCode = dict.getCode().substring(0, 4);
					// 价格
					String[] strPrice = CDict.PRICE.split(",");
					for (int j = 0; j < strPrice.length; j++) {
						if (strPrice[j].equals(ComponentText[0])
								&& strCode.equals(dictClothing.getCode())) {
							newDetail.setPrice(ComponentText[1]);
							String strText = DictManager.getDictByID(
									Utility.toSafeInt(ComponentText[0])).getEcode()+ ":" + ComponentText[1] + ",";
							newDetail.setOrdersProcess(newDetail.getOrdersProcess().replace(strText, ""));
							break;
						}
					}
				}
			}
			for (Dict component : ordersProcessList) {
				if (component.getEcode() != null
						&& !"".equals(component.getEcode())) {
					// 版型
					String[] strBxlb = CDict.BXLB.split(",");
					for (int j = 0; j < strBxlb.length; j++) {
						if (Utility.toSafeString(strBxlb[j]).equals(
								Utility.toSafeString(component.getID()))) {
							newDetail.setEdition(component.getEcode());
							String strText = "," + component.getEcode() + ",";
							String strProcess = "," + newDetail.getOrdersProcess();
							newDetail.setOrdersProcess(strProcess.replace(strText, ",").substring(1));
							break;
						}
					}
					// 款式号
					String[] strStyle = CDict.STYLENUM.split(",");
					for (int j = 0; j < strStyle.length; j++) {
						if (strStyle[j].equals(Utility.toSafeString(component
								.getParentID()))) {
							newDetail.setStyleNum(component.getEcode());
							String strText = DictManager.getDictByID(
									component.getParentID()).getEcode()
									+ ":" + component.getEcode() + ",";
							newDetail.setOrdersProcess(newDetail
									.getOrdersProcess().replace(strText, ""));
							break;
						}
					}
					// 半成品试衣
					String[] strBcpsy = CDict.BCPSY.split(",");
					for (int j = 0; j < strBcpsy.length; j++) {
						if (Utility.toSafeString(strBcpsy[j]).equals(
								Utility.toSafeString(component.getID()))) {
							newDetail.setModel("1");
							String strText = component.getEcode() + ",";
							newDetail.setOrdersProcess(newDetail
									.getOrdersProcess().replace(strText, ""));
							break;
						}
					}
				}
			}
			//客户指定号型
			if(orden.getSizeAreaID() != null && !"".equals(orden.getSizeAreaID()) && orden.getSizeAreaID() == 10204){
				newDetail.setOrdersProcess(newDetail.getOrdersProcess()+"BL01:" + detail.getSpecHeight()+",");
			}
			
			ordenDetail.add(newDetail);
		}
		return ordenDetail;
	}

	// 物流信息
	private LogisticXMLBean createLogistic(Orden orden) {
		LogisticXMLBean logisticXML = new LogisticXMLBean();
		Logistic logistic = new LogisticManager().getLogisticByOrdenID(orden.getOrdenID());
		if(logistic.getName() != null && logistic.getAddress() != null && logistic.getMobile() != null 
				&& logistic.getTel() != null && logistic.getSendtime() != null){
			logisticXML.setName(logistic.getName() == null ? "" : logistic.getName());
			logisticXML.setAddress(logistic.getAddress() == null ? "" : logistic.getAddress());
			logisticXML.setMobile(logistic.getMobile() == null ? "" : logistic.getMobile());
			logisticXML.setTel(logistic.getTel() == null ? "" : logistic.getTel());
			logisticXML.setSendtime(logistic.getSendtime() == null ? "" : logistic.getSendtime());
		}
		return logisticXML;

	}

	// 取得工艺类别
	public String getInterliningType(int nSingleClothingID,String strAllDesignedComponents) {
		List<Dict> InterliningTypeCategory = new ClothingManager().getInterliningTypeCategory();
		List<Dict> dicts = new OrdenManager().getSingleDesignedComponents(strAllDesignedComponents, nSingleClothingID);
		String strEocde = "";
		for (Dict dict : dicts) {
			for (Dict typeCategory : InterliningTypeCategory) {
				if (dict.getParentID().equals(typeCategory.getID()) && dict.getEcode() != null) {
					strEocde += dict.getEcode() + ",";
				}
			}
		}
		strEocde = this.EcodeRedirect("," + strEocde);
		return strEocde;
	}

	// 获取特体信息
	private String createBodyType(Orden orden) {
		String strBodyType = orden.getSizeBodyTypeValues();
		String strEcode = "";
		if (strBodyType != null && !"".equals(strBodyType)) {
			String[] strType = strBodyType.split(",");
			Dict dict = new Dict();
			for (int i = 0; i < strType.length; i++) {
				if (!strType[i].equals(Utility
						.toSafeString(CDict.BackNormalStyle.getID()))) {
					dict = DictManager.getDictByID(Utility
							.toSafeInt(strType[i]));
					if (!CDict.BodyStyle.getID().equals(dict.getCategoryID())
							&& dict.getEcode() != null) {
						strEcode += dict.getEcode() + ",";
					}
				}
			}
			if (!"".equals(strEcode)) {
				strEcode = strEcode.substring(0, strEcode.length() - 1);
			}
		}
		return strEcode;
	}

	public static Orden getOrdenFromXml(String strXml) {

		Customer customer = new Customer();
		Orden orden = new Orden();

		try {
			StringReader sr = new StringReader(strXml);
			InputSource is = new InputSource(sr);
			Document doc = (new SAXBuilder()).build(is);
			Element rootElement = doc.getRootElement();

			// 订单信息
			List<?> orderInformation = XPath.selectNodes(rootElement,
					"/Order/OrderInformation");
			// 订单上顾客基本信息
			List<?> customerInformationNodeList = XPath.selectNodes(
					rootElement, "/Order/CustomerInformation");
			// 单条订单明细
			List<?> orderDetailNodeList = XPath.selectNodes(rootElement,
					"/Order/OrderDetails/OrderDetail");

			// 订单时间
			String orderDate = "";
			// 用户
			Member member = new Member();

			// 订单信息
			if (orderInformation.size() == 1) {
				Element element = (Element) orderInformation.get(0);
				
				//语言版本
				try{
					//1中2英3德4法5日
					String strVersionID = getElementValue(element,"//OrderInformation/VersionCode/text()");
					ChangeVersion changeVersion=new ChangeVersion();
					changeVersion.setStrVersionID(strVersionID);
					HttpContext.setSessionValue(Utility.SessionKey_Version, strVersionID);
				}catch(Exception e){e.printStackTrace();}
				
				// 用户名
				String createman = getElementValue(element,
						"//OrderInformation/Createman/text()");
				// 密码
				String password = getElementValue(element,
						"//OrderInformation/Password/text()");

				// 查询是否存在该用户，并且密码正确
				member = new MemberManager().getMemberByUsername(createman);
				if (member == null
						|| !member.getPassword().equals(DEncrypt.md5(password))) {
					return null;
				} else {
					HttpContext.setSessionValue(
							Utility.SessionKey_CurrentMember, member);
				}

				// 日期
				orderDate = getElementValue(element,
						"//OrderInformation/OrderDate/text()");
				// 服装种类
				String clothingID = getElementValue(element,
						"//OrderInformation/ClothingID/text()");
				// 尺寸分类
				String sizeCategoryID = getElementValue(element,
						"//OrderInformation/SizeCategoryID/text()");
				// 面料CODE
				String fabrics = getElementValue(element,
						"//OrderInformation/Fabrics/text()");
				// 尺寸单位
				String sizeUnitID = getElementValue(element,
						"//OrderInformation/SizeUnitID/text()");
				// 成衣尺寸量体部位信息(配件可以不录尺寸)
				String clothingSize = "";
				try{
					clothingSize = getElementValue(element,
							"//OrderInformation/ClothingSize/text()");
					if(clothingSize.indexOf("|")>-1){
						clothingSize = clothingSize.replace("|", ",");
					}
				}catch(Exception e){
				}
				// 客户单号
				String userNo = "";
				try {
					userNo = getElementValue(element,
							"//OrderInformation/UserNo/text()");
					if(!"".equals(userNo)){//判断唯一值
						long count = checkUserOrdenNo(userNo);
						if (count > 0) {// 客户单号重复！
							System.out.println(ResourceHelper.getValue("Error_UserOrdenNo"));
							return null;
						}
					}
				} catch (Exception e) {
				}
				
				// 上传图片
				String photo = "";
				try {
					photo = getElementValue(element,
							"//OrderInformation/Photo/text()");
				} catch (Exception e) {
				}
				//老平台净体（成衣净体都存在时）
				String jtSize ="";
				try {
					jtSize = getElementValue(element,
							"//OrderInformation/JTSize/text()");
				} catch (Exception e) {
				}

				// 面料ID
				Fabric fabric = new Fabric();
				fabric = new FabricManager().getFabricByCode(fabrics);
				if (fabric != null) {
					if (fabric.getID() != null && !"".equals(fabric.getID())) {
						orden.setFabricID(fabric.getID());
					}
				}

				orden.setPubDate(Utility.toSafeDateTime(orderDate));
				orden.setClothingID(Utility.toSafeInt(clothingID));
				orden.setSizeCategoryID(Utility.toSafeInt(sizeCategoryID));
				orden.setFabricCode(fabrics);
				orden.setSizeUnitID(Utility.toSafeInt(sizeUnitID));
				orden.setPubMemberID(member.getID());
				orden.setSizePartValues(clothingSize);
				orden.setPhoto(photo);
				orden.setUserordeNo(userNo);
				orden.setJtSize(jtSize);

				if (orden.getSizeCategoryID().equals(
						CDict.SizeCategoryStandard.getID())) {// 标准号大小
					// 尺寸域码
					String sizeAreaID = getElementValue(element,
							"//OrderInformation/SizeAreaID/text()");
					orden.setSizeAreaID(Utility.toSafeInt(sizeAreaID));
					orden.setStyleID(CDict.NormalStyle.getID());// 默认正常款
				} else {// 净体量体、成衣
						// 客户体型(特体)
					if(!"5000".equals(clothingID)){
						String custormerBody = getElementValue(element,
								"//OrderInformation/CustormerBody/text()");
						orden.setSizeBodyTypeValues(custormerBody);
						if (orden.getSizeCategoryID().equals(
								CDict.SizeCategoryNaked.getID())
								&& orden.getClothingID() <= CDict.ClothingShangYi
										.getID()) {// 净体量体（套装、上衣）
							// 板型风格(款式)
							String clothingStyle = getElementValue(element,
									"//OrderInformation/ClothingStyle/text()");
							orden.setStyleID(Utility.toSafeInt(clothingStyle));
						} else {
							orden.setStyleID(CDict.NormalStyle.getID());// 默认正常款
						}
					}
				}
				//企业code
				try{
					String companyCode = getElementValue(element,"//OrderInformation/CompanyCode/text()");
					orden.setCompanysCode(companyCode);
				}catch(Exception e){}
				
				//是否保存
				try{
					String saveOrden = getElementValue(element,"//OrderInformation/Save/text()");
					orden.setMemo(saveOrden);
				}catch(Exception e){}
				
			}

			// 订单上顾客基本信息
			if (customerInformationNodeList.size() == 1) {
				Element element = (Element) customerInformationNodeList.get(0);

				// 顾客姓名
				String customerName = "";
				try {
					customerName = getElementValue(element,
							"//CustomerInformation/CustomerName/text()");
				} catch (Exception e) {
				}
				// 身高
				String height = "";
				try {
					height = getElementValue(element,
							"//CustomerInformation/Height/text()");
				} catch (Exception e) {
				}
				// 身高单位
				String heightUnitID = "";
				try {
					heightUnitID = getElementValue(element,
							"//CustomerInformation/HeightUnitID/text()");
				} catch (Exception e) {
				}
				// 体重
				String weight = "";
				try {
					weight = getElementValue(element,
							"//CustomerInformation/Weight/text()");
				} catch (Exception e) {
				}
				// 体重单位
				String weightUnitID = "";
				try {
					weightUnitID = getElementValue(element,
							"//CustomerInformation/WeightUnitID/text()");
				} catch (Exception e) {
				}
				// 邮箱
				String email = "";
				try {
					email = getElementValue(element,
							"//CustomerInformation/Email/text()");
				} catch (Exception e) {
				}
				// 地址
				String address = "";
				try {
					address = getElementValue(element,
							"//CustomerInformation/Address/text()");
				} catch (Exception e) {
				}
				// 电话
				String tel = "";
				try {
					tel = getElementValue(element,
							"//CustomerInformation/Tel/text()");
				} catch (Exception e) {
				}
				// 性别
				String genderID = "";
				try {
					genderID = getElementValue(element,
							"//CustomerInformation/GenderID/text()");
				} catch (Exception e) {
				}

				customer.setName(customerName);
				customer.setHeight(Utility.toSafeDouble(height));
				customer.setHeightUnitID(Utility.toSafeInt(heightUnitID));
				customer.setWeight(Utility.toSafeDouble(weight));
				customer.setWeightUnitID(Utility.toSafeInt(weightUnitID));
				customer.setEmail(email);
				customer.setAddress(address);
				customer.setTel(tel);
				customer.setGenderID(Utility.toSafeInt(genderID));
				customer.setPubMemberID(member.getParentID());
				customer.setPubDate(Utility.toSafeDateTime(orderDate));

				orden.setCustomer(customer);
			}
			int nAmountXF=1;

			// 单条订单明细
			if (orderDetailNodeList.size() > 0) {
				String embroideryContents = "";
				String ordersProcessContents = "";
				String gy = "";
				String zzfg = "";
				String sizeSpecChest = "";
				String sizeSpecHeight = "";
				List<OrdenDetail> ordenDetails = new ArrayList<OrdenDetail>();
				for (int i = 0; i < orderDetailNodeList.size(); i++) {
					Element element = (Element) orderDetailNodeList.get(i);
					OrdenDetail ordenDetail = new OrdenDetail();
					String id = element.getAttributeValue("id");

					// 胸围
					try {
						sizeSpecChest = getElementValue(
								element,
								"//OrderDetails/OrderDetail[@id='"
										+ id
										+ "']/OrderDetailInformation/SizeSpecChest/text()");
					} catch (Exception e) {
					}
					// 身高
					try {
						sizeSpecHeight = getElementValue(
								element,
								"//OrderDetails/OrderDetail[@id='"
										+ id
										+ "']/OrderDetailInformation/SizeSpecHeight/text()");
					} catch (Exception e) {
					}
					// 服装种类
					String categories = getElementValue(
							element,
							"//OrderDetails/OrderDetail[@id='"
									+ id
									+ "']/OrderDetailInformation/Categories/text()");
					// 数量
					String quantity = getElementValue(
							element,
							"//OrderDetails/OrderDetail[@id='"
									+ id
									+ "']/OrderDetailInformation/Quantity/text()");
					// 着装风格
					String bodyStyle = "";
					try {
						if (orden.getSizeCategoryID().equals(
								CDict.SizeCategoryNaked.getID())) {// 净体量体
							bodyStyle = getElementValue(
									element,
									"//OrderDetails/OrderDetail[@id='"
											+ id
											+ "']/OrderDetailInformation/BodyStyle/text()");
						}
					} catch (Exception e) {
					}
					if (!"".equals(bodyStyle)) {
						zzfg += "," + categories + ":" + bodyStyle;
					}

					// 刺绣信息
					List<?> embroideryList = XPath.selectNodes(rootElement,
							"/Order/OrderDetails/OrderDetail[@id='" + id
									+ "']/EmbroideryProcess/Embroidery");
					String location = "";
					String font = "";
					String color = "";
					String content = "";
					String size = "";
					String strContents = "";
					String embroideryComponents = "";
					String ordersProcessContent = "";
					if (embroideryList.size() > 0) {
						for (int j = 0; j < embroideryList.size(); j++) {
							Element ele = (Element) embroideryList.get(j);
							String num = ele.getAttributeValue("id");
							// 刺绣位置
							try {
								location = getElementValue(ele,"//EmbroideryProcess/Embroidery[@id='"+ num + "']/Location/text()");
							} catch (Exception e) {
							}
							// 刺绣颜色
							try {
								color = getElementValue(ele,"//EmbroideryProcess/Embroidery[@id='"+ num + "']/Color/text()");
							} catch (Exception e) {
							}
							// 刺绣字体
							try {
								font = getElementValue(ele,"//EmbroideryProcess/Embroidery[@id='"+ num + "']/Font/text()");
							} catch (Exception e) {
							}
							// 刺绣内容
							try {
								content = getElementValue(ele,"//EmbroideryProcess/Embroidery[@id='"+ num + "']/Content/text()");
							} catch (Exception e) {
							}
							
							if (!"".equals(location)) {
								embroideryComponents += location + "_";
							}
							if (!"".equals(color)) {
								embroideryComponents += color + "_";
							}
							if (!"".equals(font)) {
								embroideryComponents += font + ",";
							}
							if(!"".equals(embroideryComponents)){
								// 衬衣绣字大小
								if ("3000".equals(Utility.toSafeString(orden.getClothingID())) 
										|| "5000".equals(Utility.toSafeString(orden.getClothingID()))) {
									try {
										size = getElementValue(ele,
												"//EmbroideryProcess/Embroidery[@id='"
														+ num + "']/Size/text()");
									} catch (Exception e) {
										size="3261";
									}
									embroideryComponents = embroideryComponents.substring(0, embroideryComponents.length()-1)+"_" + size + ",";
								}
							}
							strContents += "," + content;
						}
						if (!",".equals(strContents) && !"".equals(strContents)) {
							String[] contents = strContents.split(",");
							embroideryContents += "," + contents[1];
							if (contents.length > 2) {
								for (int c = 2; c < contents.length; c++) {
									if (contents[c].split(":").length > 1) {
										embroideryContents += "_"
												+ contents[c].split(":")[1];
									}
								}
							}
						}
					}
					// 款式号
					String style = "";
					try {
						style = getElementValue(element,
								"//OrderDetails/OrderDetail[@id='" + id
										+ "']/Style/text()");
					} catch (Exception e) {
					}

					String ordersProcess = "";
					if ("".equals(style)) {
						// 工艺
						try{
							ordersProcess = getElementValue(element,
									"//OrderDetails/OrderDetail[@id='" + id
											+ "']/OrdersProcess/text()");
						} catch (Exception e) {
						}
						// 客户指定、面料标商标内容(文本内容)
						try {
							ordersProcessContent = ","
									+ getElementValue(
											element,
											"//OrderDetails/OrderDetail[@id='"
													+ id
													+ "']/OrdersProcessContent/text()");
						} catch (Exception e) {
						}
						if (!"".equals(ordersProcessContent)) {
							String[] strProcess = ordersProcessContent
									.split(",");
							for (String str : strProcess) {
								if (!"".equals(str.split(":")[0])) {
									if("".equals(ordersProcess)){
										ordersProcess = str.split(":")[0];
									}else{
										ordersProcess += "," + str.split(":")[0];
									}
								}
							}
						}
					} else {
						StyleProcess styleProcess = new StyleProcessManager()
								.getStyleProcessByCode(style,
										orden.getFabricCode());
						ordersProcess = styleProcess.getProcess() == null ? ""
								: styleProcess.getProcess();
						ordersProcessContent = styleProcess.getSpecialProcess() == null ? ""
								: styleProcess.getSpecialProcess();
					}

					// 订单数量
					if("3".equals(categories)){
						nAmountXF = Utility.toSafeInt(quantity);
					}
					if (orden.getClothingID() < 3 && nAmountXF == 1 && "2000".equals(categories)) {
						if (orden.getMorePants() == 1
								&& Utility.toSafeInt(quantity) == 2) {
							orden.setMorePants(CDict.YES.getID());// 追加
						} else if (orden.getMorePants() == 1
								&& Utility.toSafeInt(quantity) == 1) {
							orden.setMorePants(1);// 不追加
						}
					} else {
						orden.setMorePants(Utility.toSafeInt(quantity));
					}

					ordenDetail.setSpecChest(sizeSpecChest);
					ordenDetail.setSpecHeight(sizeSpecHeight);
					ordenDetail.setSingleClothingID(Utility.toSafeInt(categories));
					ordenDetail.setAmount(Utility.toSafeInt(quantity));

					if (!"".equals(ordersProcess)) {
						gy = gy + ordersProcess + "," + embroideryComponents;// 工艺+刺绣
					} else {
						gy = gy + embroideryComponents;// 工艺+刺绣
					}
					ordersProcessContents += ordersProcessContent;
					ordenDetails.add(ordenDetail);
				}
				if("".equals(gy)){
					orden.setComponents(gy);
				}else{
					orden.setComponents(gy.substring(0, gy.length() - 1));
				}
				orden.setComponentTexts(embroideryContents + zzfg + ordersProcessContents);
				orden.setOrdenDetails(ordenDetails);
				orden.setIsStop(CDict.NO.getID());// 是否停滞（默认否）
				
			}
			
			// 设置CMT价格、工艺价格、面料价格
			try{
				new OrdenManager().setPrice(orden);
			}catch(Exception e){
			}

			orden.setStatusID(CDict.OrdenStatusSaving.getID());// 保存状态
//			orden.setStatusID(CDict.OrdenStatusStayPayments.getID());//待支付状态
			orden.setLocking(1);//锁定订单
		} catch (Exception e) {
			LogPrinter.error(e.getMessage());
			e.printStackTrace();
			orden = null;
		}
		return orden;
	}

	public static Logistic getLogisticFromXml(String strXml) {
		Logistic logistic = new Logistic();
		try {
			StringReader sr = new StringReader(strXml);
			InputSource is = new InputSource(sr);
			Document doc = (new SAXBuilder()).build(is);
			Element rootElement = doc.getRootElement();

			// 订单物流信息
			List<?> LogisticInformationNodeList = XPath.selectNodes(
					rootElement, "/Order/Logistic");
			if (LogisticInformationNodeList.size() == 1) {
				Element element = (Element) LogisticInformationNodeList.get(0);
				String name = "";
				String address = "";
				String mobile = "";
				String tel = "";
				String sendtime = "";
				try {
					name = getElementValue(element, "//Logistic/Name/text()");
				} catch (Exception e) {
				}
				try {
					address = getElementValue(element,
							"//Logistic/Address/text()");
				} catch (Exception e) {
				}
				try {
					mobile = getElementValue(element,
							"//Logistic/Mobile/text()");
				} catch (Exception e) {
				}
				try {
					tel = getElementValue(element, "//Logistic/Tel/text()");
				} catch (Exception e) {
				}
				try {
					sendtime = getElementValue(element,
							"//Logistic/SendTime/text()");
				} catch (Exception e) {
				}

				logistic.setName(name);
				logistic.setAddress(address);
				logistic.setMobile(mobile);
				logistic.setTel(tel);
				logistic.setSendtime(sendtime);

				if ("".equals(logistic.getName())
						&& "".equals(logistic.getAddress())
						&& "".equals(logistic.getMobile())
						&& "".equals(logistic.getTel())
						&& "".equals(logistic.getSendtime())) {
					logistic = null;
				}
			} else {
				logistic = null;
			}
		} catch (Exception e) {
			LogPrinter.error(e.getMessage());
			e.printStackTrace();
			logistic = null;
		}
		return logistic;

	}

	public static Receipt getReceiptFromXml(String strXml) {
		Receipt receipt = new Receipt();
		try {
			StringReader sr = new StringReader(strXml);
			InputSource is = new InputSource(sr);
			Document doc = (new SAXBuilder()).build(is);
			Element rootElement = doc.getRootElement();

			// 订单发票信息
			List<?> ReceiptInformationNodeList = XPath.selectNodes(rootElement,
					"/Order/Receipt");
			if (ReceiptInformationNodeList.size() == 1) {
				Element element = (Element) ReceiptInformationNodeList.get(0);
				String type = "";
				String name = "";
				String identity = "";
				String address = "";
				String phone = "";
				String bankname = "";
				String bankcardid = "";
				try {
					type = getElementValue(element, "//Receipt/Type/text()");
				} catch (Exception e) {
				}
				try {
					name = getElementValue(element, "//Receipt/Name/text()");
				} catch (Exception e) {
				}
				try {
					identity = getElementValue(element,
							"//Receipt/Identity/text()");
				} catch (Exception e) {
				}
				try {
					address = getElementValue(element,
							"//Receipt/Address/text()");
				} catch (Exception e) {
				}
				try {
					phone = getElementValue(element, "//Receipt/Phone/text()");
				} catch (Exception e) {
				}
				try {
					bankname = getElementValue(element,
							"//Receipt/Bankname/text()");
				} catch (Exception e) {
				}
				try {
					bankcardid = getElementValue(element,
							"//Receipt/Bankcardid/text()");
				} catch (Exception e) {
				}

				receipt.setType(type);
				receipt.setName(name);
				receipt.setIdentity(identity);
				receipt.setAddress(address);
				receipt.setPhone(phone);
				receipt.setBankname(bankname);
				receipt.setBankcardid(bankcardid);

				if ("".equals(receipt.getType())
						&& "".equals(receipt.getName())
						&& "".equals(receipt.getIdentity())
						&& "".equals(receipt.getAddress())
						&& "".equals(receipt.getPhone())
						&& "".equals(receipt.getBankname())
						&& "".equals(receipt.getBankcardid())) {
					receipt = null;
				}
			} else {
				receipt = null;
			}
		} catch (Exception e) {
			LogPrinter.error(e.getMessage());
			e.printStackTrace();
			receipt = null;
		}
		return receipt;

	}

	public String validateOrden(Orden orden) {
		String result = "";
		String[] strComponents = Utility.getStrArray(orden.getComponents());
		List<Dict> components = new ArrayList<Dict>();
		for (String strComponent : strComponents) {
			Dict dict = DictManager
					.getDictByID(Utility.toSafeInt(strComponent));
			if (dict != null) {
				components.add(dict);
			}
		}
		for (Dict component : components) {
			if (new ClothingManager().disabledByOther(orden.getComponents(),
					component)) {
				// result = "ERROR:" + component.getEcode();
				result = "<Orden><Result>FAIL</Result><OrdenID></OrdenID><Content>"
						+ component.getEcode() + "</Content></Orden>";
			}
		}
		for (Dict component : components) {
			if (!new ClothingManager().allowedByOther(components, component)) {
				// result = "ERROR:" + component.getEcode();
				result = "<Orden><Result>FAIL</Result><OrdenID></OrdenID><Content>"
						+ component.getEcode() + "</Content></Orden>";
			}
		}
		return result;
	}

	private static String getElementValue(Element element, String path) {
		String str = "";
		try {
			str = ((Text) XPath.selectSingleNode(element, path))
					.getTextNormalize();
		} catch (JDOMException e) {
			e.printStackTrace();
		}
		return str;
	}

	/**
	 * 把字符串写入文本中
	 * 
	 * @param fileName
	 *            生成的文件绝对路径
	 * @param content
	 *            文件要保存的内容
	 * @param enc
	 *            文件编码
	 * @return
	 */
	public static boolean writeStringToFile(String fileName, String content,
			String enc) {
		File file = new File(fileName);

		try {
			if (file.exists()) {
				file.delete();
			}
			file.createNewFile();
			OutputStreamWriter os = null;
			if (enc == null || enc.length() == 0) {
				os = new OutputStreamWriter(new FileOutputStream(file));
			} else {
				os = new OutputStreamWriter(new FileOutputStream(file), enc);
			}
			os.write(content);
			os.close();
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
		return true;
	}

	public static void main(String[] args) {
		String str = "";
		System.out.println(Utility.getStrArray(str)[0]);

	}

	/**
	 * 提货
	 * 
	 * @param strDeliveryId
	 *            发货单ID
	 * @return 操作结果
	 */
	public String ladeDeliveryToErp(String strDeliveryId) {
		String strResult = Utility.RESULT_VALUE_OK;

		try {
			String strXml = getXmlFromDeliveryId(strDeliveryId);
			System.out.println(strXml);
			// Object[] params = new Object[] {strXml,"0"};

			// 提交ERP操作
			// strResult =
			// Utility.toSafeString(invokeService(WebService_Erp_Address,
			// WebService_Erp_NameSpace, "doSaveOrder", params));

		} catch (Exception e) {
			e.printStackTrace();
			// return "Bl_Error_152";
		}
		return strResult;
	}

	/**
	 * 得到与WebService交互的字符串
	 * 
	 * @param strDeliveryId
	 *            发货单ID
	 * @return
	 */
	private String getXmlFromDeliveryId(String strDeliveryId) {
		BlOrdenLadeXmlBean xmlBean = new BlOrdenLadeXmlBean();

		// 根据发货单ID得到所有订单编号
		List<String> ordenIds = new BlDeliveryManager()
				.getOrdenIdByDeliveryId(strDeliveryId);

		StringBuffer buffer = new StringBuffer();
		for (String ordenId : ordenIds) {
			buffer.append(ordenId + ",");
		}

		String strOrdenIds = buffer.substring(0, buffer.length() - 1)
				.toString();

		xmlBean.setOrdenIds(strOrdenIds);

		// 得到发货信息
		Delivery delivery = new DeliveryManager()
				.getDeliveryByID(strDeliveryId);
		xmlBean.setMemberId(delivery.getPubMemberID());
		xmlBean.setMemberName(delivery.getPubMemberName());
		xmlBean.setMoneySignId(delivery.getMoneySignId());
		xmlBean.setMoneySignName(delivery.getMoneySignName());

		String xml = "";
		try {
			JAXBContext context = JAXBContext
					.newInstance(BlOrdenLadeXmlBean.class);
			Marshaller marshaller = context.createMarshaller();
			marshaller.setProperty(Marshaller.JAXB_ENCODING, "GB2312");
			marshaller.setProperty(Marshaller.JAXB_FORMATTED_OUTPUT, false);
			ByteArrayOutputStream os = new ByteArrayOutputStream();
			marshaller.marshal(xmlBean, os);
			xml = new String(os.toByteArray());
			XmlManager.writeStringToFile("E:\\demo\\" + strDeliveryId + ".txt",
					xml, "UTF-8");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return xml;
	}

	/**
	 * 根据XML 转换为对象
	 * 
	 * @param strXml
	 *            XML字符串
	 * @param classType
	 *            需要转换的对象类型
	 * @return
	 */
	public static Object doStrXmlToObject(String strXml, Class<?> classType) {
		try {
			JAXBContext context = JAXBContext.newInstance(classType);
			Unmarshaller marshaller = context.createUnmarshaller();
			Object xmlBean = marshaller.unmarshal(new StringReader(strXml));
			return xmlBean;
		} catch (Exception e) {
			// TODO 字符串转换为实体类
			System.out.println(e.getLocalizedMessage());
		}
		return null;
	}
	// 检查客户订单号是否必填、重复
	public static long checkUserOrdenNo(String userNo){
		long count = 0;
		try {
			String hql = "SELECT COUNT(*) FROM Orden o WHERE UserordeNo =:UserordeNo";
			Query query = DataAccessObject.openSession().createQuery(hql);
			query.setString("UserordeNo", userNo);
			count = Utility.toSafeLong(query.uniqueResult());
		} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		} finally {
			DataAccessObject.closeSession();
		}
		return count;
	}
}