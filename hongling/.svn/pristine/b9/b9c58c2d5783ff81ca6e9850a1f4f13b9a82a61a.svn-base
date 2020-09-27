package work.business;

import java.io.IOException;
import java.io.StringReader;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.JDOMException;
import org.jdom.Text;
import org.jdom.input.SAXBuilder;
import org.jdom.xpath.XPath;
import org.xml.sax.InputSource;

import chinsoft.entity.Customer;
import chinsoft.entity.Member;
import chinsoft.entity.Orden;
public class XmlMG {
	private String createXmlByOrderDetail(Orden order) {
		String exp = "[^,].+[^,]";
		Pattern p = Pattern.compile(exp);
		StringBuffer xml=new StringBuffer();
		xml.append("<OrderDetails>");
		for (int i = 0; i <order.getOrdenDetails().size(); i++) {
			xml.append("<OrderDetail id ='"+(i+1)+"'>");
			xml.append("<OrderDetailInformation>");
			xml.append("<SizeSpecChest></SizeSpecChest>");
			xml.append("<SizeSpecHeight>").append(order.getOrdenDetails().get(i).getSpecHeight()).append("</SizeSpecHeight>");
			xml.append("<Categories>").append(order.getOrdenDetails().get(i).getSingleClothingID()).append("</Categories>");
			xml.append("<Quantity>").append(order.getOrdenDetails().get(i).getAmount()).append("</Quantity>");
			xml.append("<BodyStyle></BodyStyle>");
			xml.append("</OrderDetailInformation>");
			if (i==0) {
				xml.append("<EmbroideryProcess></EmbroideryProcess>");
				xml.append("<Style></Style>");
				Matcher m = p.matcher(order.getComponents()==null?"":order.getComponents());
				m.find();
				String ordersProcess=m.group();
				xml.append("<OrdersProcess>").append(ordersProcess).append("</OrdersProcess>");
				m = p.matcher(order.getComponentTexts()==null?"":order.getComponentTexts());
				m.find();
				String ordersProcessContent=m.group();
				xml.append("<OrdersProcessContent>").append(ordersProcessContent).append("</OrdersProcessContent>");
			}
			xml.append("</OrderDetail>");
		}
		xml.append("</OrderDetails>");
		return xml.toString();
	}

	private String createXmlByCustomer(Customer customer) {
		StringBuffer xml=new StringBuffer();
		xml.append("<CustomerInformation>");
		xml.append("<CustomerName>").append(customer.getName()).append("</CustomerName>");
		xml.append("<Height>").append(customer.getHeight()).append("</Height>");
		xml.append("<HeightUnitID>").append(customer.getHeightUnitID()).append("</HeightUnitID>");
		xml.append("<Weight>").append(customer.getWeight()).append("</Weight>");
		xml.append("<WeightUnitID>").append(customer.getWeightUnitID()).append("</WeightUnitID>");
		xml.append("<Email>").append(customer.getEmail()==null?"":customer.getEmail()).append("</Email>");
		xml.append("<Address>").append(customer.getAddress()==null?"":customer.getAddress()).append("</Address>");
		xml.append("<Tel>").append(customer.getTel()==null?"":customer.getTel()).append("</Tel>");
		xml.append("<GenderID>10040</GenderID>");
		xml.append("</CustomerInformation>");
		return xml.toString();
	}

	public String createXmlByOrder(Orden order,Member member) {
		StringBuffer xml=new StringBuffer("<?xml version=\"1.0\" encoding=\"UTF-8\"?> ");
		xml.append("<Order>");
		
		//订单基本信息
		xml.append("<OrderInformation>");
		xml.append("<OrderDate>").append(order.getPubDate()).append("</OrderDate>");
		xml.append("<Createman>TESTAA</Createman>");
		xml.append("<Password>123456</Password>");
		xml.append("<ClothingID>").append(order.getClothingID()).append("</ClothingID>");
		xml.append("<SizeCategoryID>").append(order.getSizeCategoryID()).append("</SizeCategoryID>");
		xml.append("<SizeAreaID>").append(order.getSizeAreaID()==null?"":order.getSizeAreaID()).append("</SizeAreaID>");
		xml.append("<Fabrics>").append(order.getFabricCode()).append("</Fabrics>");
		xml.append("<SizeUnitID>").append(order.getSizeUnitID()).append("</SizeUnitID>");
		xml.append("<ClothingStyle>").append(order.getStyleID().equals(-1)?"":order.getStyleID()).append("</ClothingStyle>");
		xml.append("<CustormerBody>").append(order.getSizeBodyTypeValues()).append("</CustormerBody>");
		xml.append("<ClothingSize>").append(order.getSizePartValues()).append("</ClothingSize>");
		xml.append("<CompanyCode></CompanyCode>");
		xml.append("<VersionCode>1</VersionCode>");
		xml.append("<Save>1</Save>");
		xml.append("<UserNo>").append(order.getOrdenID()).append("</UserNo>");
		xml.append("<JTSize></JTSize>");
		xml.append("</OrderInformation>");
		
		//客户基本信息
		xml.append(createXmlByCustomer(order.getCustomer()));
		
		//订单明细信息
		xml.append(createXmlByOrderDetail(order));
		xml.append("</Order>");
		return  xml.toString();
	}
	
	public static void main(String[] args) throws JDOMException, IOException {
		StringBuffer strXml=new StringBuffer("<Orden><Result>FAIL</Result><OrdenID></OrdenID><Content>我是错误内容</Content></Orden>");
		StringBuffer strSuccess=new StringBuffer("<Orden><Result>SUCCESS</Result><OrdenID>我是订单号</OrdenID><Content></Content></Orden>");
		if (strXml.indexOf("FAIL")>0) {
			System.out.println(strXml.subSequence(strXml.indexOf("<Content>")+9, strXml.indexOf("</Content>")));
		}
		if (strSuccess.indexOf("SUCCESS")>0) {
			System.out.println(strSuccess.subSequence(strSuccess.indexOf("<OrdenID>")+9, strSuccess.indexOf("</OrdenID>")));
		}
	}
}
