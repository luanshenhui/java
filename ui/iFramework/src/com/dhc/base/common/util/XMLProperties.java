package com.dhc.base.common.util;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.StringWriter;
import java.util.Enumeration;
import java.util.List;
import java.util.Properties;
import java.util.StringTokenizer;

import org.jdom.CDATA;
import org.jdom.Document;
import org.jdom.Element;
import org.jdom.input.SAXBuilder;
import org.jdom.output.Format;
import org.jdom.output.XMLOutputter;

/**
 * <p>
 * Title: XMLProperties
 * </p>
 * <p>
 * Description: 处理XML对象的工具类
 * </p>
 * 
 */

public class XMLProperties {

	private String xPath = null; // 设置的XML方法的路径
	private static String ROOT_PROPERTY = "xml_root_name";
	private static String ROOT_VALUE = "xml_root_value";

	public XMLProperties() {

	}

	/**
	 * 通过文件获取XML对象
	 * 
	 * @param file-文件路径名称(E:\\***\\……\\***\\***.xml)
	 * @return
	 */
	public Document getDocument(String file) {
		Document doc = null;
		try {
			SAXBuilder builder = new SAXBuilder();
			// Strip formatting
			FileInputStream in = new FileInputStream(new File(file));
			// 声明了一个Document对象。使用jdom来解析xml文件。
			doc = builder.build(in);
			in.close();
		} catch (Exception e) {
			System.err.println("Error creating XML parser in " + "XMLProperties.java");
			e.printStackTrace();
		}
		return doc;
	}

	/**
	 * 返回指定名称的节点的值。
	 * 
	 * @param element-需要处理的xml对象
	 * @param name
	 *            传入的形式是"node1.node2.……",其中node2是node1的子节点
	 * @return String
	 */
	public String getProperty(Element element, String _name) {

		// 在name前添加路径信息
		String name = _name;
		if (this.xPath != null)
			name = this.xPath + "." + name;

		String[] propName = parsePropertyName(name);
		// Search for this property by traversing down the XML heirarchy.

		for (int i = 0; i < propName.length; i++) {
			element = element.getChild(propName[i]);
			if (element == null) {
				// This node doesn't match this part of the property name which
				// indicates this property doesn't exist so return null.
				return null;
			}
		}
		// At this point, we found a matching property, so return its value.
		// Empty strings are returned as null.
		String value = element.getText();
		if ("".equals(value.trim())) {
			return null;
		} else {
			// Add to cache so that getting property next time is fast.
			return value.trim();
		}
	}

	/**
	 * 返回根节点名称。
	 * 
	 * @param element-需要处理的xml对象
	 * @return String add by liyj
	 */
	public String getRootProperty(Element element) {

		// At this point, we found a matching property, so return its value.
		// Empty strings are returned as null.
		String value = element.getName();
		if ("".equals(value.trim())) {
			return null;
		} else {
			// Add to cache so that getting property next time is fast.
			return value.trim();
		}
	}

	/**
	 * 返回根节点值
	 * 
	 * @param element-需要处理的xml对象。
	 * @return String add by liyj
	 */
	public String getRootValue(Element element) {
		// At this point, we found a matching property, so return its value.
		// Empty strings are returned as null.
		String value = element.getText();
		if ("".equals(value.trim())) {
			return null;
		} else {
			// Add to cache so that getting property next time is fast.
			return value.trim();
		}
	}

	/**
	 * 返回指定节点的所有的子节点的名称。
	 * 
	 * @param element-需要处理的xml对象
	 * @param parent
	 * @return String[]
	 */
	public String[] getChildrenProperties(Element element, String _parent) {

		// 田径路径信息
		String parent = _parent;

		if (this.xPath != null)
			if (parent.intern() != "".intern())
				parent = this.xPath + "." + parent;
			else
				parent = this.xPath;

		// 获取数据
		String[] propName = parsePropertyName(parent);
		// Search for this property by traversing down the XML heirarchy.

		for (int i = 0; i < propName.length; i++) {
			element = element.getChild(propName[i]);
			if (element == null) {
				// This node doesn't match this part of the property name which
				// indicates this property doesn't exist so return empty array.
				return new String[] {};
			}
		}
		// We found matching property, return names of children.
		List children = element.getChildren();
		int childCount = children.size();
		String[] childrenNames = new String[childCount];
		for (int i = 0; i < childCount; i++) {
			childrenNames[i] = ((Element) children.get(i)).getName();
		}
		return childrenNames;
	}

	/**
	 * 返回xPath的所有的子节点的名称
	 * 
	 * @param element-需要处理的xml对象
	 * @return String[]
	 */
	public String[] getChildrenProperties(Element element) {
		return getChildrenProperties(element, "");
	}

	/**
	 * 获得指定节点的所有的子节点的值
	 * 
	 * @param element-需要处理的xml对象
	 * @param parent
	 * @return String[]
	 */
	public String[] getChildrenValues(Element element, String _parent) {

		// 田径路径信息
		String parent = _parent;

		if (this.xPath != null)
			if (parent.intern() != "".intern())
				parent = this.xPath + "." + parent;
			else
				parent = this.xPath;

		String[] propName = parsePropertyName(parent);
		// Search for this property by traversing down the XML heirarchy.

		for (int i = 0; i < propName.length; i++) {
			element = element.getChild(propName[i]);
			if (element == null) {
				// This node doesn't match this part of the property name which
				// indicates this property doesn't exist so return empty array.
				return new String[] {};
			}
		}
		// We found matching property, return names of children.
		List children = element.getChildren();
		int childCount = children.size();
		String[] childrenNames = new String[childCount];
		for (int i = 0; i < childCount; i++) {
			childrenNames[i] = ((Element) children.get(i)).getText();
		}
		return childrenNames;
	}

	/**
	 * 返回xPath的所有的子节点的值
	 * 
	 * @param element-需要处理的xml对象
	 * @param parent
	 * @return String[]
	 */
	public String[] getChildrenValues(Element element) {
		return getChildrenValues(element, "");
	}

	/**
	 * 更新指定节点的值。
	 * 
	 * @param element-需要处理的xml对象
	 * @param name
	 * @param value
	 */
	public void setProperty(Element element, String _name, String value) {

		// 在name前添加路径信息
		String name = _name;
		if (this.xPath != null)
			name = this.xPath + "." + name;

		String[] propName = parsePropertyName(name);
		// Search for this property by traversing down the XML heirarchy.

		for (int i = 0; i < propName.length; i++) {
			// If we don't find this part of the property in the XML heirarchy
			// we add it as a new node
			if (element.getChild(propName[i]) == null) {
				element.addContent(new Element(propName[i]));
			}
			element = element.getChild(propName[i]);
		}
		// Set the value of the property in this node.
		element.setText(value);
	}

	/**
	 * 给xml对象增加一个新的节点
	 * 
	 * @param ele-需要处理的xml对象
	 * @param _pName
	 *            需要增加子节点的父节点名称
	 * @param _name
	 *            需要增加的子节点名称
	 * @param value
	 *            需要增加的子节点值 add by liyj
	 */
	public void addProperty(Element ele, String _pName, String _name, String value) {

		// 在name前添加路径信息
		String pName = _pName;
		if (this.xPath != null) {
			if (_pName.equals(""))
				pName = this.xPath;
			else
				pName = this.xPath + "." + _pName;
		}

		String[] propName = parsePropertyName(pName);
		Element ele_m = null;
		for (int i = 0; i < propName.length; i++) {
			ele_m = ele.getChild(propName[i]);
			if (ele_m == null) {
				// This node doesn't match this part of the property name which
				// indicates this property doesn't exist so return empty array.
				System.err.println("Error creating XML parser in " + "XMLProperties.java");
			}
		}
		Element ele_a = new Element(_name);
		ele_a.setText(value);
		ele_m.addContent(ele_a);
	}

	/**
	 * 给xml对象的根节点增加一个新的节点
	 * 
	 * @param ele-需要处理的xml对象
	 * @param _name
	 *            需要增加的子节点名称
	 * @param value
	 *            需要增加的子节点值 add by liyj
	 */
	public Element addRootProperty(Element ele, String _name, String value) {
		Element ele_a = new Element(_name);
		ele_a.setText(value);
		ele.addContent(ele_a);
		return ele;
	}

	/**
	 * 对Document对象做了某些操作后，把最终结果返回到xml文件中
	 * 
	 * @param doc-处理过的xml对象
	 * @param file-文件路径名称(E:\\***\\……\\***\\***.xml)
	 * @author liyj
	 */
	public void updateXMLFile(Document doc, String file) {
		XMLOutputter xmlout = new XMLOutputter();
		FileOutputStream output;
		try {
			output = new FileOutputStream(new File(file));
			xmlout.output(doc, output);
			output.close();
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e1) {
			e1.printStackTrace();
		}
	}

	/**
	 * 增加一条新的数据(只适用两级目录)
	 * 
	 * @param doc
	 *            需要处理的xml对象
	 * @param name
	 * @param value
	 *            from kjava author dongzg
	 */
	public void addProperty(Document doc, String _name, String value) {

		// 在name前添加路径信息
		String name = _name;
		if (this.xPath != null)
			name = this.xPath + "." + name;

		String[] propName = parsePropertyName(name);
		// Search for this property by traversing down the XML heirarchy.
		// Element element = doc.getRootElement();
		org.jdom.Element words = new Element("words");
		// words.setName(name);
		words.setText(value);
		Element badwords = new Element("badwords");
		badwords.addContent(words);
		Element root = doc.getRootElement();
		Element first = root.getChild("badwords");
		List children = first.getChildren();
		children.add(children.indexOf(first), words);
		// write the XML properties to disk
	}

	/**
	 * 删除指定的节点。
	 * 
	 * @param element-需要处理的xml对象
	 * @param name
	 */
	public void deleteProperty(Element element, String _name) {

		// 在name前添加路径信息
		String name = _name;
		if (this.xPath != null)
			name = this.xPath + "." + name;

		String[] propName = parsePropertyName(name);
		// Search for this property by traversing down the XML heirarchy.

		for (int i = 0; i < propName.length - 1; i++) {
			element = element.getChild(propName[i]);
			// Can't find the property so return.
			if (element == null) {
				return;
			}
		}
		// Found the correct element to remove, so remove it...
		element.removeChild(propName[propName.length - 1]);
	}

	/**
	 * 将字符串按照.分隔，获得所有的单词数组
	 * 
	 * @param name
	 * @return String[]
	 */
	private String[] parsePropertyName(String name) {
		// Figure out the number of parts of the name (this becomes the size
		// of the resulting array).
		int size = 1;
		for (int i = 0; i < name.length(); i++) {
			if (name.charAt(i) == '.') {
				size++;
			}
		}
		String[] propName = new String[size];
		// Use a StringTokenizer to tokenize the property name.
		StringTokenizer tokenizer = new StringTokenizer(name, ".");
		int i = 0;
		while (tokenizer.hasMoreTokens()) {
			propName[i] = tokenizer.nextToken();
			i++;
		}
		return propName;
	}

	/**
	 * 公用方法:将Document型的信息转化为XML字符串
	 * 
	 * @param Element
	 *            需要转成字符串的Element对象
	 * @return String
	 * @author liyj
	 */
	public String xmlToString(Document docXML) {
		String r = null;
		try {
			StringWriter sw = new StringWriter();
			Format format = Format.getPrettyFormat();
			format.setEncoding("UTF-8");
			XMLOutputter outputter = new XMLOutputter(format);
			// XMLOutputter outputter = new XMLOutputter(" ", true);
			// outputter.setEncoding("UTF-8");
			outputter.output(docXML, sw);
			r = sw.toString();
			sw.close();
		} catch (java.io.IOException e) {
			r = "";
			e.printStackTrace();
		}
		return r;
	}

	/**
	 * 公用方法:将Element型的信息转化为XML字符串
	 * 
	 * @param Element
	 *            需要转成字符串的Element对象
	 * @return String
	 * @author liyj
	 */
	public String xmlToString(Element el) {
		String r = null;
		try {
			StringWriter sw = new StringWriter();
			Format format = Format.getPrettyFormat();
			format.setEncoding("UTF-8");
			XMLOutputter outputter = new XMLOutputter(format);
			// XMLOutputter outputter = new XMLOutputter(" ", true);
			// outputter.setEncoding("UTF-8");
			outputter.output(el, sw);
			r = sw.toString();
			sw.close();
		} catch (java.io.IOException e) {
			r = "";
			e.printStackTrace();
		}
		return r;
	}

	/**
	 * 把XML对象形成CDATA放入指定的XML对象中
	 * 
	 * @param Element
	 *            ele_p需要增加CDATA的父XML对象
	 * @param Element
	 *            ele需要转成CDATA的Element对象
	 * @param String
	 *            newNodeName 增加的CDATA的节点名称，可以为空串""
	 * @param String
	 *            parent 需要增加CDATA的父节点名称
	 * @author liyj
	 */
	public Element addCDATA(Element ele_p, Element ele, String newNodeName, String parent) {

		// 在name前添加路径信息
		String pname = parent;
		if (this.xPath != null)
			pname = this.xPath + "." + parent;

		if (pname.equals("")) {
			if (newNodeName.equals("")) {
				ele_p.addContent(new CDATA(xmlToString(ele)));
			} else {
				Element ele_a = new Element(newNodeName);
				ele_a.addContent(new CDATA(xmlToString(ele)));
				ele_p.addContent(ele_a);
			}
		} else {
			// 获取数据
			String[] propName = parsePropertyName(pname);
			// Search for this property by traversing down the XML heirarchy.

			Element ele_proc = null;

			for (int i = 0; i < propName.length; i++) {
				ele_proc = ele_p.getChild(propName[i]);
				if (ele_proc == null) {
					// This node doesn't match this part of the property name
					// which
					// indicates this property doesn't exist so return empty
					// array.
					System.out.println("XMLProperties.addCDATA is error ....");
				}
			}

			if (newNodeName.equals("")) {
				ele_proc.addContent(new CDATA(xmlToString(ele)));
			} else {
				Element ele_a = new Element(newNodeName);
				ele_a.addContent(new CDATA(xmlToString(ele)));
				ele_proc.addContent(ele_a);
			}
		}
		return ele_p;
	}

	/**
	 * 把xml对象中的CDATA对象转换成String对象
	 * 
	 * @param element
	 *            需要从中获取CDATA数据的XML对象
	 * @param _name
	 *            节点名称
	 * @return
	 * @author liyj
	 */
	public String getCDATAtoString(Element element, String _name) {

		// 在name前添加路径信息
		String name = _name;
		if (this.xPath != null)
			name = this.xPath + "." + name;

		String[] propName = parsePropertyName(name);
		// Search for this property by traversing down the XML heirarchy.

		for (int i = 0; i < propName.length; i++) {
			element = element.getChild(propName[i]);
			if (element == null) {
				// This node doesn't match this part of the property name which
				// indicates this property doesn't exist so return null.
				return null;
			}
		}

		return element.getText().trim();
	}

	/**
	 * 设置操作的节点路径， 当get属性，或者set属性，delete属性的时候，处理的节点前将添加xPath；
	 * 
	 * @param path
	 *            The xPath to set.
	 */
	public void setXPath(String path) {
		xPath = path;
	}

	/**
	 * 切换XML格式数据为可识别的正确格式(XSL可读格式)
	 */
	public static String prepareXml(String s) {
		if (s == null || s.length() == 0)
			return "";

		StringBuffer stringbuffer = new StringBuffer(s.length() + 50);
		for (int i = 0; i < s.length(); i++) {
			char c = s.charAt(i);
			if ('>' == c) {
				stringbuffer.append("&gt;");
				continue;
			} else if ('<' == c) {
				stringbuffer.append("&lt;");
				continue;
			} else if ('&' == c) {
				stringbuffer.append("&amp;");
				continue;
			} else if (c == '"') {
				stringbuffer.append("&quot;");
				continue;
			} else if ('\'' == c) {
				stringbuffer.append("&apos;");
				continue;
			} else
				stringbuffer.append(c);
		}
		return stringbuffer.toString();
	}

	/**
	 * 将Properties对象生成XML的数据.
	 * 
	 * @param props
	 *            Properties 对象.
	 */

	public static String getXML(Properties props) {

		if (props == null)
			return "";

		StringBuffer strBuff = new StringBuffer();

		Enumeration keys = props.keys();
		while (keys.hasMoreElements()) {
			String key = (String) keys.nextElement();
			strBuff.append("<").append(key).append(">").append(props.getProperty(key)).append("</").append(key)
					.append(">\n");
		}

		return strBuff.toString();
	}

	/**
	 * 测试
	 * 
	 * @param args
	 */
	public static void main(String[] args) {
		XMLProperties prop = new XMLProperties();
		Document doc_proc = prop.getDocument("E:" + File.separator + "test" + File.separator + "hello.xml");
		System.out.println(prop.getCDATAtoString(doc_proc.getRootElement(), "RspTransID.add"));

	}
}
