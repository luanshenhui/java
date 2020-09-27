package centling.service.delivery;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.text.DecimalFormat;
import java.text.NumberFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.dom4j.Document;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;
import org.dom4j.io.SAXReader;
import org.dom4j.io.XMLWriter;

import centling.business.BlDeliveryManager;
import centling.business.Constant;
import centling.business.DHLCountryManager;
import centling.entity.DHLCountry;
import centling.service.webservice.DHLClient;
import centling.util.BlDateUtil;
import centling.util.BlFileUtil;
import chinsoft.business.CDict;
import chinsoft.business.DeliveryManager;
import chinsoft.business.MemberManager;
import chinsoft.business.XmlManager;
import chinsoft.core.ConfigHelper;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.entity.Delivery;
import chinsoft.entity.Errors;
import chinsoft.entity.Member;
import chinsoft.entity.Orden;
import chinsoft.service.core.BaseServlet;

public class BlLadeDeiveryByDeliveryId extends BaseServlet {
	private static final long serialVersionUID = 2488550864882343049L;
	private String WebService_Erp_Address = Utility.toSafeString(ConfigHelper.getContextParam().get("WebService_Erp_Address"));
	private String WebService_NameSpace = Utility.toSafeString(ConfigHelper.getContextParam().get("WebService_NameSpace"));
	
	/**
	 * 提货
	 */
	@SuppressWarnings("deprecation")
	@Override
	protected void service(HttpServletRequest request, HttpServletResponse response) {
		try {
			super.service();
			// 得到发货单ID
			String strDeliveryId = getParameter("deliveryid");
			
			// 得到发货备注
			String strMemo = getParameter("deliveryMemo");
			
			// 判断所有的发货是否是已入库状态
			Delivery delivery = new DeliveryManager().getDeliveryByID(strDeliveryId);
			List<Orden> ordens = delivery.getOrdens();
			
			boolean flag = true;
			
			for (Orden orden : ordens) {
				if (!CDict.OrdenStatusStorage.getID().equals(orden.getStatusID())) {
//					flag = false;
					break;
				}
			}
			
			if (flag) {
				// 在ERP端实现提货功能
				String result = ladeDeliveryToErp(delivery);
				
				if (Utility.RESULT_VALUE_OK.equals(result)) {
					
					// 得到用户的快递公司
					// 得到用户信息
					Member member = new MemberManager().getMemberByID(delivery.getPubMemberID());
					String expressComName = member.getExpressComName();
					String yundanId = "";
					if ("DHL".equalsIgnoreCase(expressComName)) {
						// 创建请求XML文件
						String fileName = request.getRealPath("/") + "requestXML/ShipmentValidateRequest_APToAP_" + BlDateUtil.formatDate(new Date(), "yyyy_MM_dd_hh_mm_ss_SSS")+".xml";
						createRequestXmlFile(fileName, delivery);
						
						String responseMessagePath = request.getRealPath("/") + "responseXML/";
						String httpURL = "https://xmlpitest-ea.dhl.com/XMLShippingServlet";
						
						String responseFileName = DHLClient.getResponseXML(fileName,httpURL,responseMessagePath);
						
						String responseFilePath = responseMessagePath + responseFileName;
						
						try {
							yundanId = parseResponseXmlFile(responseFilePath);
						} catch (Exception e) {
							LogPrinter.error("获取运单号时发生异常："+e.getMessage());
						}
						
						// 删除xml文件
						List<String> filePaths = new ArrayList<String>();
						filePaths.add(fileName);
						filePaths.add(responseFilePath);
						BlFileUtil.deleteFile(filePaths);
					}
					// 提货
					new BlDeliveryManager().ladeDeliveryById(strDeliveryId,strMemo, yundanId);
					
					output(Utility.RESULT_VALUE_OK);
				} else {
					output("failure");
				}
			} else {
				output("error");
			}
		} catch (Exception e) {
			LogPrinter.error("BlLadeDeiveryByDeliveryId_err"+e.getMessage());
		}
	}
	
	/**
	 * 提交ERP
	 * @param strDeliveryId 发货ID
	 * @return
	 */
	private String ladeDeliveryToErp(Delivery delivery) {
		String strResult = "";
		
		List<Orden> ordens = delivery.getOrdens();
		
		StringBuffer buffer = new StringBuffer();
		
		if (ordens.size() > 0) {
			for (Orden orden : ordens) {
				buffer.append(orden.getSysCode()+",");
			}
		}
		
		// 得到订单
		String strSysCodes = buffer.substring(0, buffer.length()-1).toString();
		
		// 得到用户信息
		Member member = new MemberManager().getMemberByID(delivery.getPubMemberID());
		 
		// 得到门店
		String ownedStore = member.getOwnedStore();
		
		// 得到用户姓名
		String userName = member.getName();
		
		// 得到货币类型
		Integer monSignId = member.getMoneySignID();
		
		String monSingName = "";
		if (CDict.MoneySignDollar.getID().equals(monSignId)) {
			monSingName = "USD";
		} else if (CDict.MoneySignRmb.getID().equals(monSignId)) {
			monSingName = "RMB";
		}
		
		String type = "";
		Integer cloghingId = ordens.get(0).getClothingID();
		if (CDict.ClothingChenYi.getID().equals(cloghingId)) {
			type = "CY";
		} else {
			type = "XF";
		}
		//自动提货操作-ERP
		Object[] params = new Object[] {strSysCodes, userName, ownedStore, monSingName, type};
		Class<?>[] classTypes=new Class<?>[]{String.class,String.class,String.class,String.class,String.class};
		try {
			strResult = Utility.toSafeString(XmlManager.invokeService(WebService_Erp_Address, WebService_NameSpace, "doAutoDelivery", params,classTypes));
			if (strResult.length()>0) {
				Errors errors=(Errors) XmlManager.doStrXmlToObject(strResult, Errors.class);
				strResult=errors.getList().get(0).getContent();
				System.out.println(strResult);
			}else{
				strResult=Utility.RESULT_VALUE_OK;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return strResult;
	}

	/**
	 * 创建xml文件
	 * @param fileName 文件名
	 */
	private void createRequestXmlFile(String fileName, Delivery delivery) {
		Member member = new MemberManager().getMemberByID(delivery.getPubMemberID());
		DHLCountry country = new DHLCountryManager().getDHLCountryByCountryCode(member.getCountryCode());
		
		Document document = DocumentHelper.createDocument();
		
		// 创建根元素
		Element rootElement = document.addElement("req:ShipmentValidateRequestAP");
		rootElement.addAttribute("xmlns:req", "http://www.dhl.com");
		rootElement.addAttribute("xmlns:xsi", "http://www.w3.org/2001/XMLSchema-instance");
		rootElement.addAttribute("xsi:schemaLocation", "http://www.dhl.com ship-val-req_AP.xsd");
		
		// Request
		createRequest(rootElement);
		
		// LanguageCode
		createLanguageCode(rootElement);
		
		// Billing
		createBilling(rootElement, member);
		
		// Consignee（收货人）
		createConsignee(rootElement, member, country);
		
		// 创建申报价值
		createDutiable(rootElement, country, delivery);
		
		// ShipmentDetails
		createShipmentDetails(rootElement, delivery);
		
		// Shipper（发货人）
		createShipper(rootElement);
		
		try {
			XMLWriter output = new XMLWriter(new FileWriter(new File(fileName)));
			output.write(document);
			output.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}


	/**
	 * request
	 * @param rootElement
	 */
	private void createRequest(Element rootElement){
		Element request = rootElement.addElement("Request");
		
		Element serviceHeaderElement = request.addElement("ServiceHeader");
		
		Element messageTime = serviceHeaderElement.addElement("MessageTime");
		String messageText = BlDateUtil.formatDate(new Date(), "yyyy-MM-dd") + "T" + BlDateUtil.formatDate(new Date(), "hh:mm:ss")
				+ "-08:00";
		messageTime.setText(messageText);
		
		Element siteID = serviceHeaderElement.addElement("SiteID");
		siteID.setText(Constant.BL_DHL_SITEID);
		
		Element password = serviceHeaderElement.addElement("Password");
		password.setText(Constant.BL_DHL_PASSWORD);
	}
	
	/**
	 * LanguageCode
	 * @param rootElement
	 */
	private void createLanguageCode(Element rootElement){
		Element languageCode = rootElement.addElement("LanguageCode");
		languageCode.addText(Constant.BL_DHL_LANGUAGE_CODE);
	}
	
	/**
	 * Billing
	 * @param rootElement
	 * @param member
	 */
	private void createBilling(Element rootElement, Member member){
		Element billing = rootElement.addElement("Billing");
		
		Element shipperAccountNumber = billing.addElement("ShipperAccountNumber");
		shipperAccountNumber.setText(Constant.BL_DHL_SHIPPER_ACCOUNT_NO);
		Element shippingPaymentType = billing.addElement("ShippingPaymentType");
		if (member.getShippingPaymentType()!=null&& CDict.SHIPPINGPAYMENTTYPE_S.getID().equals(member.getShippingPaymentType())){
			shippingPaymentType.setText(Constant.BL_DHL_SHIPPER_PAY);
		} else if (member.getShippingPaymentType()!=null&& CDict.SHIPPINGPAYMENTTYPE_R.getID().equals(member.getShippingPaymentType())){
			shippingPaymentType.setText(Constant.BL_DHL_RECEIVER_PAY);
		}
	}
	
	/**
	 * Consignee（收货人）
	 * @param rootElement
	 * @param member
	 * @param country
	 */
	private void createConsignee(Element rootElement, Member member, DHLCountry country){
		Element consignee = rootElement.addElement("Consignee");
		
		Element companyName = consignee.addElement("CompanyName");
		companyName.setText(member.getCompanyName());
		Element addressLine0 = consignee.addElement("AddressLine");
		if (member.getAddressLine2()!=null && !"".equals(member.getAddressLine2())) {
			addressLine0.setText(member.getAddressLine2());
			Element addressLine1 = consignee.addElement("AddressLine");
			addressLine1.setText(member.getAddressLine1());
		} else {
			addressLine0.setText(member.getAddressLine1());
		}
		Element city = consignee.addElement("City");
		city.setText(member.getCity());
		if ("US".equals(member.getCountryCode())) {
			Element divisionCode = consignee.addElement("DivisionCode");
			divisionCode.setText(member.getDivisionCode());
		}
		Element postalCode = consignee.addElement("PostalCode");
		postalCode.setText(member.getPostalCode());
		Element countryCode = consignee.addElement("CountryCode");
		countryCode.setText(member.getCountryCode());
		Element countryName = consignee.addElement("CountryName");
		countryName.setText(country.getEn());
		Element contact = consignee.addElement("Contact");
		Element personName = contact.addElement("PersonName");
		personName.setText(member.getUsername());
		Element phoneNumber = contact.addElement("PhoneNumber");
		phoneNumber.setText(member.getPhoneNumber());
	}
	
	/**
	 * Dutiable
	 * @param rootElement
	 * @param country
	 * @param delivery
	 */
	private void createDutiable(Element rootElement, DHLCountry country, Delivery delivery) {
		Element dutiable = rootElement.addElement("Dutiable");
		List<Orden> ordens = delivery.getOrdens();
		Double amount = Double.valueOf(0);		
		for (Orden orden: ordens) {
			amount += orden.getOrdenPrice();
		}
		
		Element declaredValue = dutiable.addElement("DeclaredValue");
		NumberFormat df = new DecimalFormat("0.00");
		declaredValue.setText(df.format(amount));
		
		Element declaredCurrency = dutiable.addElement("DeclaredCurrency");
		declaredCurrency.setText(country.getCurrencyCode());
	}
	
	/**
	 * ShipmentDetails
	 * @param rootElement
	 * @param ordens
	 */
	private void createShipmentDetails(Element rootElement, Delivery delivery){
		Element shipmentDetails = rootElement.addElement("ShipmentDetails");
		List<Orden> ordens = delivery.getOrdens();
		
		DHLCountry country = new DHLCountryManager().getDHLCountryByCountryCode(Constant.BL_SHIPPER_COUNTRYCODE);
		
		Element numberOfPieces = shipmentDetails.addElement("NumberOfPieces");
		numberOfPieces.setText(String.valueOf(ordens.size()));
		Element currencyCode = shipmentDetails.addElement("CurrencyCode");
		currencyCode.setText(country.getCurrencyCode());
		Element pieces = shipmentDetails.addElement("Pieces");
		Double weight = Double.valueOf(0);
		for (Orden orden : ordens){
			Element piece = pieces.addElement("Piece");
			Element pieceID = piece.addElement("PieceID");
			pieceID.setText(orden.getOrdenID());
			Element pieceContents = piece.addElement("PieceContents");
			pieceContents.setText(Utility.toSafeString(orden.getClothingID()));
			if (orden.getClothingID().equals(CDict.ClothingSuit2PCS.getID())
					|| orden.getClothingID().equals(CDict.ClothingSuit3PCS.getID())){
				weight+=Constant.WEIGTH_ClothingSuits;
			} else if (orden.getClothingID().equals(CDict.ClothingShangYi.getID())){
				weight+=Constant.WEIGTH_ClothingJackets;
			} else if (orden.getClothingID().equals(CDict.ClothingPants.getID())){
				weight+=Constant.WEIGTH_ClothingPants;
			} else if (orden.getClothingID().equals(CDict.ClothingChenYi.getID())){
				weight+=Constant.WEIGTH_ClothingShirts;
			}
		}
		
		Element packageType = shipmentDetails.addElement("PackageType");
		packageType.setText(Constant.PACKAGETYPE);
		Element weight1 = shipmentDetails.addElement("Weight");
		NumberFormat df = new DecimalFormat("0.00");
		weight1.setText(df.format(weight));
		Element dimensionUnit = shipmentDetails.addElement("DimensionUnit");
		if ("IN".equals(country.getDimensionalUnit())) {
			dimensionUnit.setText("I");
		} else {
			dimensionUnit.setText("C");
		}
		Element weightUnit = shipmentDetails.addElement("WeightUnit");
		weightUnit.setText(Constant.WEIGHT_UNIT);
		Element globalProductCode = shipmentDetails.addElement("GlobalProductCode");
		globalProductCode.setText(Constant.GLOBALPRODUCTCODE);
		Element localProductCode = shipmentDetails.addElement("LocalProductCode");
		localProductCode.setText(Constant.LOCALPRODUCTCODE);
		Element doorTo = shipmentDetails.addElement("DoorTo");
		doorTo.setText(Constant.DOORTO);
		Element date = shipmentDetails.addElement("Date");
		date.setText(Utility.dateToStr(new Date(), "yyyy-MM-dd"));
		Element contents = shipmentDetails.addElement("Contents");
		contents.setText("Garent");
	}
	
	/**
	 * Shipper（发货人）
	 * @param rootElement
	 */
	private void createShipper(Element rootElement){
		Element shipper = rootElement.addElement("Shipper");
		
		Element shipperID = shipper.addElement("ShipperID");
		shipperID.setText(Constant.BL_DHL_SHIPPER_ACCOUNT_NO);
		Element companyName00 = shipper.addElement("CompanyName");
		companyName00.setText(Constant.BL_SHIPPER_COMPANYNAME);
		Element addressLine00 = shipper.addElement("AddressLine");
		addressLine00.setText(Constant.BL_SHIPPER_ADDRESSLINE1);
		Element addressLine11 = shipper.addElement("AddressLine");
		addressLine11.setText(Constant.BL_SHIPPER_ADDRESSLINE2);
		Element city00 = shipper.addElement("City");
		city00.setText(Constant.BL_SHIPPER_CITY);
		Element countryCode00 = shipper.addElement("CountryCode");
		countryCode00.setText(Constant.BL_SHIPPER_COUNTRYCODE);
		Element countryName00 = shipper.addElement("CountryName");
		countryName00.setText(Constant.BL_SHIPPER_COUNTRYNAME);
		Element contact00 = shipper.addElement("Contact");
		Element personName00 = contact00.addElement("PersonName");
		personName00.setText(Constant.BL_SHIPPER_PERSONNAME);
		Element phoneNumber00 = contact00.addElement("PhoneNumber");
		phoneNumber00.setText(Constant.BL_SHIPPER_PHONENUMBER);
	}
	
	/**
	 * 解析xml文件
	 * @param responseFilePath 待解析的xml文件路径
	 * @return
	 */
	private String parseResponseXmlFile(String responseFilePath) {
		SAXReader saxReader = new SAXReader();
		String yundanId = "";
		try {
			Document document = saxReader.read(new File(responseFilePath));
			Element rootElement = document.getRootElement();
			Element airwayBillNumber = rootElement.element("AirwayBillNumber");
			yundanId = airwayBillNumber.getText();
		} catch (Exception e) {
			LogPrinter.error("parseResponseXmlFile_err"+e.getMessage());
		}
		return yundanId;
	}
}