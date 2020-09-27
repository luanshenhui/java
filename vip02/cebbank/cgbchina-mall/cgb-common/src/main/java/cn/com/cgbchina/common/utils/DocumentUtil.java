package cn.com.cgbchina.common.utils;

import java.io.File;
import java.io.InputStream;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.apache.commons.io.IOUtils;
import org.w3c.dom.Document;
import org.w3c.dom.NamedNodeMap;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

/**
 * <b>功能描述：Document的工具类，提供了获取DocumentBuilder、格式化String类型为Document</b> <br>
 * 
 * @version 1.1 2011-02-11
 * @author lizhongyi
 *
 */
public class DocumentUtil {
	public static Document getDocFromInputStream(InputStream is) throws Exception {
		return getDocBuilder().parse(is);
	}

	public static Document getDocFromFile(File f) throws Exception {
		return getDocBuilder().parse(f);
	}

	public static DocumentBuilder getDocBuilder() throws ParserConfigurationException {
		DocumentBuilderFactory docBuilderFactory = DocumentBuilderFactory.newInstance();
		docBuilderFactory.setNamespaceAware(false);
		DocumentBuilder docBuilder = docBuilderFactory.newDocumentBuilder();
		return docBuilder;
	}

	public static Document getDocFromString(String xml) throws Exception {
		InputStream is = IOUtils.toInputStream(xml, "UTF-8");
		return getDocFromInputStream(is);
	}

	public static Document parseXmlData(String repData) throws Exception {
		DocumentBuilder docBuilder = getDocBuilder();
		Document doc = docBuilder.parse(IOUtils.toInputStream(repData, "UTF-8"));
		return doc;
	}

	public static String getNodeValue(Node node, String itemName) {
		String nodeValue = null;
		NodeList messageList = node.getChildNodes();
		for (int i = 0; i < messageList.getLength(); i++) {
			Node aNode = messageList.item(i);
			if (aNode.getChildNodes().getLength() > 0) {
				NamedNodeMap map = aNode.getAttributes();
				Node idNode = map.getNamedItem(itemName);
				nodeValue = idNode.getNodeValue();

				break;
			}
		}

		return nodeValue;
	}

	public static org.w3c.dom.Document parse(org.dom4j.Document doc) throws Exception {
		if (doc == null) {
			return (null);
		}
		java.io.StringReader reader = new java.io.StringReader(doc.asXML());
		org.xml.sax.InputSource source = new org.xml.sax.InputSource(reader);
		javax.xml.parsers.DocumentBuilderFactory documentBuilderFactory = javax.xml.parsers.DocumentBuilderFactory
				.newInstance();
		documentBuilderFactory.setExpandEntityReferences(false);
		javax.xml.parsers.DocumentBuilder documentBuilder = documentBuilderFactory.newDocumentBuilder();
		return (documentBuilder.parse(source));
	}

	public static String getNodeContent(String xmlStr, String nodeName) {

		int start = xmlStr.indexOf("<" + nodeName + ">");
		int end = xmlStr.lastIndexOf("</" + nodeName + ">");
		int ctLength = ("<" + nodeName + ">").length();

		if (start == -1 || end == -1) {
			return null;
		}

		return xmlStr.substring(start + ctLength, end);
	}

	public static String formatGDBNode(String xmlStr) {
		String[] nodeArr = { "erCd", "erMg" };

		for (int i = 0; i < nodeArr.length; i++) {
			xmlStr = formatNode(xmlStr, nodeArr[i]);
		}
		return xmlStr;
	}

	public static String formatNode(String xmlStr, String nodeName) {

		int nodeIndex = xmlStr.indexOf("<" + nodeName + "/>");
		if (nodeIndex != -1) {
			xmlStr = xmlStr.replace("<" + nodeName + "/>", "<" + nodeName + "></" + nodeName + ">");
		}

		return xmlStr;
	}
}
