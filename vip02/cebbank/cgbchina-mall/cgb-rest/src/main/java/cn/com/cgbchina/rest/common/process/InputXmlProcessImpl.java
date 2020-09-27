package cn.com.cgbchina.rest.common.process;

import java.lang.reflect.InvocationTargetException;
import java.util.Iterator;
import java.util.List;

import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;
import org.springframework.stereotype.Service;

import cn.com.cgbchina.rest.common.exception.ConverErrorException;
import cn.com.cgbchina.rest.common.utils.ReflectUtil;
import cn.com.cgbchina.rest.provider.vo.order.SendCodeInfoVO;
import lombok.extern.slf4j.Slf4j;

/**
 * Xml pack处理类
 * 
 * @author Lizy
 *
 * @param <T>
 */
@Service
@Slf4j
public class InputXmlProcessImpl<T> implements PackProcess<String, T> {

	private static final String ERROR_TITLE = "【解析XML报文】";

	@Override
	public T packing(String strXml, Class<T> rootClazz) throws ConverErrorException {
		T result = null;
		// 将字符串转化为XML文档对象
		try {
			Document document = DocumentHelper.parseText(strXml);
			String _$ = "$";
			if (rootClazz.getName().indexOf(_$) > -1) {
				String[] classNames = rootClazz.getName().split("\\" + _$);
				String nameStr = "";
				Object obj = null;
				for (String name : classNames) {
					if (obj == null) {
						nameStr += name;
					} else {
						nameStr += _$ + name;
					}
					Class<?> clazzz = Class.forName(nameStr);
					if (obj == null) {
						obj = clazzz.getDeclaredConstructors()[0].newInstance();
					} else {
						obj = clazzz.getDeclaredConstructors()[0].newInstance(obj);
					}
				}
				result = (T) obj;
			} else {
				result = rootClazz.newInstance();
			}
			getElement(document.getRootElement(), result);
			if (result != null)
				return result;
		} catch (ClassNotFoundException e) {
			String message = ERROR_TITLE + "【entity定义不正确】：";
			throw new ConverErrorException(message, e);
		} catch (InstantiationException e) {
			String message = ERROR_TITLE + "【entity定义不正确】：\n";
			throw new ConverErrorException(message, e);
		} catch (IllegalAccessException e) {
			String message = ERROR_TITLE + "【entity定义不正确】：\n";
			throw new ConverErrorException(message, e);
		} catch (InvocationTargetException e) {
			String message = ERROR_TITLE + "【entity定义不正确】：\n";
			throw new ConverErrorException(message, e);
		} catch (DocumentException e) {
			throw new ConverErrorException(ERROR_TITLE, e);
		}
		return null;
	}

	private static <T> void getElement(Element element, T result)
			throws InstantiationException, IllegalAccessException {
		List list = element.elements();
		for (Iterator its = list.iterator(); its.hasNext();) {
			Element chileEle = (Element) its.next();
			ReflectUtil.loop(result.getClass(), result, chileEle.getName(), chileEle.getText());
			getElement(chileEle, result);
			// System.out.println("节点：" + chileEle.getName() + ",内容：" +
			// chileEle.getText());
		}

	}

}
