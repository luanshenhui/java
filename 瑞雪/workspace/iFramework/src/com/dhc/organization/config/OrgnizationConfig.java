package com.dhc.organization.config;

import java.io.File;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.io.SAXReader;
import org.dom4j.tree.DefaultElement;

import com.dhc.organization.extend.ICodeList;

/**
 * brief description
 * <p>
 * Date : 2010/05/13
 * </p>
 * <p>
 * Module : 组织机构权限管理接口
 * </p>
 * <p>
 * Description: 组织机构配置类
 * </p>
 * <p>
 * Remark :
 * </p>
 * 
 * @author 王潇艺
 * @version
 *          <p>
 * 			------------------------------------------------------------
 *          </p>
 *          <p>
 *          修改历史
 *          </p>
 *          <p>
 *          序号 日期 修改人 修改原因
 *          </p>
 *          <p>
 *          1 Sun Sep 19 14:56:59 2010 wangxy 修改配置文件加载路径问题
 *          </p>
 */
public class OrgnizationConfig {
	/**
	 * 应用程序web根目录
	 */
	public static String APP_WEB_ROOT_PATH = null;

	/**
	 * 构造函数
	 */
	private OrgnizationConfig() {
	}

	/**
	 * 获取业务元素扩展定义
	 * 
	 * @param bizType
	 *            ：user,unit,station
	 * @return bizElementExt模型
	 */
	public static synchronized BizTypeDefine getBizTypeDefine(String bizType) {
		BizTypeDefine returnObject = new BizTypeDefine();
		if (bizElementExt == null) {
			String configFilePath = APP_WEB_ROOT_PATH + File.separator + "WEB-INF" + File.separator + "conf"
					+ File.separator + "organization" + File.separator + "BizElementExt.xml";
			SAXReader saxReader = new SAXReader();
			Document document;
			try {
				document = saxReader.read(new File(configFilePath));
				List list = document.selectNodes("//BizElementExt/BizType");
				BizElementExt bizElementExt2 = new BizElementExt();
				Iterator iter = list.iterator();
				while (iter.hasNext()) {
					DefaultElement bizTypeDef = (DefaultElement) iter.next();
					String tableValue = bizTypeDef.attributeValue("table");
					String typeValue = bizTypeDef.attributeValue("type");
					if (nullOrEmpty(tableValue) || nullOrEmpty(typeValue)) {
						throw new Exception("BizElementExt.xml内容错误");
					}
					BizTypeDefine bizTypeDefine = new BizTypeDefine();
					bizTypeDefine.setTable(tableValue);
					bizTypeDefine.setType(typeValue);
					Iterator elementIter = bizTypeDef.elementIterator();
					while (elementIter.hasNext()) {
						DefaultElement elementDefine = (DefaultElement) elementIter.next();
						String name = elementDefine.attributeValue("name");
						String type = elementDefine.attributeValue("type");
						String column = elementDefine.attributeValue("column");
						String columnType = elementDefine.attributeValue("columnType");
						String label = elementDefine.attributeValue("label");
						String allowBlank = elementDefine.attributeValue("allowBlank");
						String regex = elementDefine.attributeValue("regex");
						String maxLength = elementDefine.attributeValue("maxLength");
						String errorInfoText = elementDefine.attributeValue("errorInfoText");
						String width = elementDefine.attributeValue("width");
						String readOnly = elementDefine.attributeValue("readOnly");
						String format = elementDefine.attributeValue("format");
						String store = elementDefine.attributeValue("store");
						if (nullOrEmpty(name) || nullOrEmpty(column) || nullOrEmpty(columnType)) {
							throw new Exception("BizElementExt.xml内容错误");
						}
						ElementDefine eleDefine = new ElementDefine();
						eleDefine.setName(name);
						eleDefine.setType(type);
						eleDefine.setColumn(column);
						eleDefine.setColumnType(columnType);
						eleDefine.setLabel(label);
						eleDefine.setAllowBlank(allowBlank);
						eleDefine.setRegex(regex);
						eleDefine.setMaxLength(maxLength);
						eleDefine.setErrorInfoText(errorInfoText);
						eleDefine.setWidth(width);
						eleDefine.setReadOnly(readOnly);
						eleDefine.setFormat(format);
						if (store != null && !store.equals("")) {
							eleDefine.setStore(store);
							eleDefine.setStoreValueMap(getStoreValue(store, null));
						}
						bizTypeDefine.getElementList().add(eleDefine);
					}
					bizElementExt2.getBizTypeList().add(bizTypeDefine);
				}
				bizElementExt = bizElementExt2;
			} catch (DocumentException e) {
				e.printStackTrace();
			} catch (Exception ex) {
				ex.printStackTrace();
			}
		}
		if (bizElementExt.getBizTypeList() != null) {
			for (int i = 0; i < bizElementExt.getBizTypeList().size(); i++) {
				BizTypeDefine temp = (BizTypeDefine) bizElementExt.getBizTypeList().get(i);
				if (temp.getType().equalsIgnoreCase(bizType)) {
					returnObject = temp;
				}
			}
		}
		return returnObject;
	}

	public static synchronized Map getStoreValue(String store, Map paramMap) {
		Map returnMap = null;
		try {
			ICodeList codeList = (ICodeList) Class.forName(store).newInstance();
			returnMap = codeList.getDataMap(paramMap);
		} catch (InstantiationException e) {
			e.printStackTrace();
		} catch (IllegalAccessException e) {
			e.printStackTrace();
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		if (returnMap == null)
			returnMap = new HashMap();
		return returnMap;
	}

	private static boolean nullOrEmpty(String param) {
		return param == null || param.equals("");
	}

	/**
	 * 密码的加密算法
	 */
	public static String CRYPTOGRAM_ALGORITHM = "MD5";
	/**
	 * 业务元素扩展定义模型
	 */
	private static BizElementExt bizElementExt;
}