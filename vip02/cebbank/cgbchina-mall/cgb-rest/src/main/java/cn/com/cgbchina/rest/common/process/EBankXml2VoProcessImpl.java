package cn.com.cgbchina.rest.common.process;

import java.lang.reflect.Method;
import java.util.Iterator;
import java.util.List;

import org.dom4j.Document;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;
import org.dom4j.Node;
import org.springframework.stereotype.Service;

import cn.com.cgbchina.rest.common.exception.ConverErrorException;
import cn.com.cgbchina.rest.common.utils.ReflectUtil;

@Service
public class EBankXml2VoProcessImpl<T> implements PackProcess<String, T> {

	@Override
	public T packing(String r, Class<T> t) {
		Document document = null;
		T result = null;
		try {
			result = t.newInstance();
			document = DocumentHelper.parseText(r);
			String ec = (document.selectSingleNode("//root/ec").getText());
			String em = (document.selectSingleNode("//root/em").getText());
			String syn = (document.selectSingleNode("//root/syn").getText());
			if ("0".equals(ec)) {
				ec = "00000000";
			} else if ("1".equals(ec)) {
				ec = "00000001";
			} else if ("2".equals(ec)) {
				ec = "00000002";
			}
			if (!em.equals("000000") && !em.equals("00000001")) {
				Method setCode = result.getClass().getSuperclass().getDeclaredMethod("setRetCode", String.class);
				Method setMsg = result.getClass().getSuperclass().getDeclaredMethod("setRetErrMsg", String.class);
				setCode.invoke(result, ec);
				setMsg.invoke(result, em);
			}
			ReflectUtil.loop(t, result, "ec", ec);
			ReflectUtil.loop(t, result, "em", em);

			Node cdNode = document.selectSingleNode("//root/cd");
			Element cdRoot = cdNode.getDocument().getRootElement();
			Iterator<Element> child = cdRoot.elementIterator();
			while (child.hasNext()) {
				Element next = child.next();
				// TODO: 不知道写的对不对
				String nodeName = next.getName();
				if ("iColl".equals(nodeName)) {
					List<Element> nodes = next.selectNodes("/kColl");
					for (Element n : nodes) {
						Iterator<Element> it = n.elementIterator();
						while (it.hasNext()) {
							Element el = it.next();
							String key = el.getName();
							String value = el.getTextTrim();
							ReflectUtil.loop(t, result, key, value);
						}
					}

				}
				if ("cd".equals(nodeName)) {
					List<Element> nodes = next.elements();
					for (Element n : nodes) {
						// Iterator<Attribute> it = n.attributeIterator();
						// while(it.hasNext()){
						// Attribute att = it.next();
						// String key = att.getName();
						// String value =att.getValue();
						// ReflectUtil.loop(t, result, key, value);
						// }
						String key = n.attributeValue("id");
						if ("iAccountStoreList".equals(key)) {
							List<Element> nodes2 = n.elements();
							for (Element elt : nodes2) {
								List<Element> nodes3 = elt.elements();
								for (Element elt2 : nodes3) {
									String key1 = elt2.attributeValue("id");
									String value1 = elt2.attributeValue("value");
									if (key1 != null && value1 != null) {
										ReflectUtil.loop(t, result, key1, value1);
									}
								}
							}
						}
						String value = n.attributeValue("value");
						if (key != null && value != null) {
							ReflectUtil.loop(t, result, key, value);
						}
					}
				}
				String nodeValue = next.getTextTrim();
				ReflectUtil.loop(t, result, nodeName, nodeValue);

			}
		} catch (Exception e) {
			throw new ConverErrorException(e);
		}
		return result;
	}

}
