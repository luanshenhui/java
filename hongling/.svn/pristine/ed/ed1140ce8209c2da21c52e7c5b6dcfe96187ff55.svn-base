package centling.service.delivery;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.dom4j.Document;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;
import org.dom4j.io.SAXReader;
import org.dom4j.io.XMLWriter;

import centling.business.Constant;
import centling.dto.DeliveryTrackDto;
import centling.service.webservice.DHLClient;
import centling.util.BlDateUtil;
import centling.util.BlFileUtil;
import chinsoft.core.PagingData;
import chinsoft.service.core.BaseServlet;

/**
 * 查看物流信息
 *
 */
public class BlGetTrackByYundanId extends BaseServlet {
	private static final long serialVersionUID = 3897191502719109344L;

	/**
	 * 查看物流信息
	 */
	@SuppressWarnings("deprecation")
	@Override
	protected void service(HttpServletRequest request, HttpServletResponse response) {
		super.service();
		
		// 得到运单号
		String yundanId = getParameter("yundanId");
		
		// 创建请求xml文件
		String fileName = request.getRealPath("/") + "requestXML/" + yundanId + BlDateUtil.formatDate(new Date(), "yyyy_MM_dd_hh_mm_ss_SSS")+".xml";
		createRequestXmlFile(fileName, yundanId);
		
		String responseMessagePath = request.getRealPath("/") + "responseXML/";
		String httpURL = "https://xmlpitest-ea.dhl.com/XMLShippingServlet";
		
		String responseFileName = DHLClient.getResponseXML(fileName,httpURL,responseMessagePath);
		
		String responseFilePath = responseMessagePath + responseFileName;
		
		List<DeliveryTrackDto> list = parseResponseXmlFile(responseFilePath);
		
		// 对list进行排序
		Collections.sort(list);
		
		// 将xml文件删除
		List<String> filePaths = new ArrayList<String>();
		filePaths.add(fileName);
		filePaths.add(responseFilePath);
		BlFileUtil.deleteFile(filePaths);
		
		long nCount = 1;
		PagingData pagingData = new PagingData();
		pagingData.setCount(nCount);
		pagingData.setData(list);
		output(pagingData);
	}

	/**
	 * 创建xml文件
	 * @param fileName 文件名
	 * @param yundanId 运单号
	 */
	private void createRequestXmlFile(String fileName, String yundanId) {
		Document document = DocumentHelper.createDocument();
		
		// 创建根元素
		Element rootElement = document.addElement("req:KnownTrackingRequest");
		rootElement.addAttribute("xmlns:req", "http://www.dhl.com");
		rootElement.addAttribute("xmlns:xsi", "http://www.w3.org/2001/XMLSchema-instance");
		rootElement.addAttribute("xsi:schemaLocation", "http://www.dhl.com TrackingRequestKnown.xsd");
		
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
		
		Element languageCode = rootElement.addElement("LanguageCode");
//		Locale defaultLocale = Locale.getDefault();
//		languageCode.addText(defaultLocale.getLanguage());
		languageCode.addText(Constant.BL_DHL_LANGUAGE_CODE);
		
		Element AWBNumber = rootElement.addElement("AWBNumber");
		AWBNumber.setText(yundanId);
		
		Element levelOfDetails = rootElement.addElement("LevelOfDetails");
		levelOfDetails.addText(Constant.BL_DHL_LEVEL_OF_DETAILS);
		
		try {
			XMLWriter output = new XMLWriter(new FileWriter(new File(fileName)));
			output.write(document);
			output.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	/**
	 * 解析xml文件
	 * @param responseFilePath 待解析的xml文件路径
	 * @return
	 */
	@SuppressWarnings("rawtypes")
	private List<DeliveryTrackDto> parseResponseXmlFile(String responseFilePath) {
		List<DeliveryTrackDto> list = new ArrayList<DeliveryTrackDto>();
		
		SAXReader saxReader = new SAXReader();
		
		try {
			Document document = saxReader.read(new File(responseFilePath));
			Element rootElement = document.getRootElement();
			Element AWBInfo = rootElement.element("AWBInfo");
			Element shipmentInfo = AWBInfo.element("ShipmentInfo");
			if (shipmentInfo != null && !"".equals(shipmentInfo)) {
				int num = 1;
				for (Iterator iter = shipmentInfo.elementIterator(); iter.hasNext();) {
					DeliveryTrackDto deliveryTrackDto = new DeliveryTrackDto();
					Element element = (Element) iter.next();
					if ("ShipmentEvent".equals(element.getName())) {
						if (element != null) {
							String date = element.elementText("Date");
							String time = element.elementText("Time");
							Element serviceEvent = element.element("ServiceEvent");
							if (serviceEvent != null) {
								String info = serviceEvent.elementText("Description").replace("\n", "").replaceAll("\\s+"," ");
								deliveryTrackDto.setOperateInfo(info);
							}
							deliveryTrackDto.setNumber(String.valueOf(num));
							deliveryTrackDto.setOperateTime(date + " " + time);
							list.add(deliveryTrackDto);
							num++;
						}
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}
}