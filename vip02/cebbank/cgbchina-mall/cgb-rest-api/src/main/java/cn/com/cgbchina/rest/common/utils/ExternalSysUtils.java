package cn.com.cgbchina.rest.common.utils;

import java.io.ByteArrayInputStream;
import java.util.Iterator;

import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.Element;
import org.dom4j.io.SAXReader;

import cn.com.cgbchina.rest.common.exception.ConverErrorException;
import cn.com.cgbchina.rest.common.model.ExternalModel;

/**
 * Comment: Created by 11150321050126 on 2016/4/25.
 */
public class ExternalSysUtils {
	public static ExternalModel parseXml(ExternalModel model, String xml) throws ConverErrorException {
		SAXReader reader = new SAXReader();
		Document document = null;
		try {
			document = reader.read(new ByteArrayInputStream(xml.getBytes()));
		} catch (DocumentException e) {
			throw new ConverErrorException("xml转换entity时，xml格式错误");
		}
		Element rootElement = document.getRootElement();
		// if(model.getMsgtype().equals(rootElement.getName())){
		Element messageElem = (Element) rootElement.elementIterator("message").next();
		Iterator iterator = messageElem.elementIterator();
		while (iterator.hasNext()) {

		}
		/*
		 * }else{ throw new FormatErrorException("xml转换entity时，xml格式错误"); }
		 */
		return model;
	}

	public static void main(String[] args) throws ConverErrorException {
		System.out.println(ExternalSysUtils.parseXml(null,
				"<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n" + "<request_message>\n" + "\t<message>\n"
						+ "\t\t<orderno>10000</orderno>\n" + "\t\t<sum>2</sum>\n" + "\t\t<organ_id></organ_id>\n"
						+ "\t\t<payment>100</payment>\n" + "\t\t<items>\n" + "\t\t\t<item>\n"
						+ "\t\t\t\t<sorder_id>21</sorder_id>\n" + "\t\t\t\t<suborderno>11000</suborderno>\n"
						+ "\t\t\t\t<type>0</type>\n" + "\t\t\t\t<number>1</number>\n" + "\t\t\t\t<price>12</price>\n"
						+ "\t\t\t\t<amount>12</amount>\n" + "\t\t\t\t<goods_id>1103</goods_id>\n"
						+ "\t\t\t\t<mobile>13512345678</mobile>\n" + "\t\t\t</item>\n" + "\t\t\t<item>\n"
						+ "\t\t\t\t<sorder_id>21</sorder_id>\n" + "\t\t\t\t<suborderno>11001</suborderno>\n"
						+ "\t\t\t\t<type>0</type>\n" + "\t\t\t\t<number>1</number>\n" + "\t\t\t\t<price>12</price>\n"
						+ "\t\t\t\t<amount>12</amount>\n" + "\t\t\t\t<goods_id>1103</goods_id>\n"
						+ "\t\t\t\t<mobile>13512345888</mobile>\n" + "\t\t\t</item>\n" + "\t\t</items>\n"
						+ "\t</message>\n" + "</request_message>\n"));
	}
}
