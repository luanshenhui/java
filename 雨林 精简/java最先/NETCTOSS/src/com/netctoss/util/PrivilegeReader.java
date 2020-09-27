package com.netctoss.util;

import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;

import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.Element;
import org.dom4j.io.SAXReader;

import com.netctoss.role.entity.Privilege;

/**
 * ����privileges.xml������
 */
public class PrivilegeReader {

	// ���ڴ洢privileges.xml��Ȩ�޲�����Ϣ
	private static List<Privilege> privileges = new ArrayList<Privilege>();

	static {
		InputStream xml = PrivilegeReader.class.getClassLoader()
				.getResourceAsStream("privileges.xml");
		privileges = toModuleList(xml);
	}

	/**
	 * ����XML������Ȩ������
	 * 
	 * @return
	 */
	public static List<Privilege> getPrivileges() {
		return privileges;
	}

	/**
	 * ����Ȩ��ID��ѯģ������
	 * 
	 * @param id
	 * @return
	 */
	public static String getPrivilegeNameById(String id) {
		List<Privilege> privileges = getPrivileges();
		for (Privilege privilege : privileges) {
			if (privilege.getId().equals(id)) {
				return privilege.getName();
			}
		}
		return null;
	}

	/**
	 * ����privileges.xml�ļ�
	 * 
	 * @param xml
	 * @return
	 */
	@SuppressWarnings("unchecked")
	protected static List<Privilege> toModuleList(InputStream xml) {
		List<Privilege> modules = new ArrayList<Privilege>();
		try {
			SAXReader reader = new SAXReader();
			Document doc = reader.read(xml);
			Element root = doc.getRootElement();
			List<Element> moduleElements = root.elements("privilege");
			for (Element moduleElement : moduleElements) {
				Privilege module = new Privilege();
				module.setId(moduleElement.attributeValue("id"));
				module.setName(moduleElement.elementText("name"));
				Element urlElement = moduleElement.element("urls");
				List<Element> urlElements = urlElement.elements();
				List<String> urls = new ArrayList<String>();
				for (Element element : urlElements) {
					urls.add(element.getText());
				}
				module.setUrls(urls);
				modules.add(module);
			}

			return modules;
		} catch (DocumentException e) {
			e.printStackTrace();
			throw new RuntimeException("����Ȩ���ļ�ʧ�ܣ�", e);
		}
	}

	public static void main(String[] args) {
		List<Privilege> list = PrivilegeReader.getPrivileges();
		for (Privilege p : list) {
			System.out.println(p.getId() + " " + p.getName());
		}
	}

}
