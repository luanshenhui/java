package cn.com.cgbchina.rest.common.process;

import cn.com.cgbchina.rest.common.constants.Constant;
import cn.com.cgbchina.rest.common.exception.ConverErrorException;
import cn.com.cgbchina.rest.common.utils.ReflectResult;
import cn.com.cgbchina.rest.common.utils.ReflectUtil;
import cn.com.cgbchina.rest.common.utils.SOAPUtils;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

import javax.xml.soap.SOAPBody;
import javax.xml.soap.SOAPElement;
import javax.xml.soap.SOAPException;
import javax.xml.soap.SOAPMessage;
import java.lang.reflect.InvocationTargetException;
import java.util.Iterator;

/**
 * Comment: Created by 11150321050126 on 2016/4/27.
 */
@Service
@Slf4j
public class InputSoapBodyProcessImpl<T> implements PackProcess<String, T>, EncodingPackProcess<String, T> {
	@Override
	public T packing(String xml, Class<T> rootClazz) throws ConverErrorException {
		return this.packing(xml, rootClazz, Constant.CHARSET_GBK);
	}

	@Override
	public T packing(String xml, Class<T> rootClazz, String encoding) {
		T result = null;
		try {
			SOAPMessage soapMessage = SOAPUtils.formatSoapString(xml, encoding);
			SOAPBody bodyElement = soapMessage.getSOAPBody();
			Iterator<SOAPElement> bodyType = bodyElement.getChildElements();
			if (bodyType == null || !bodyType.hasNext()) {
				throw new ConverErrorException("【Soap报文内容格式不正确】");
			}
			SOAPElement noAs400 = bodyType.next();
			Iterator<SOAPElement> iterator = noAs400.getChildElements();
			SOAPElement element = null;
			ReflectResult<T> reflectResult=new ReflectResult(rootClazz);
			while (iterator.hasNext()) {
				Object tmp = iterator.next();
				if (!(tmp instanceof SOAPElement)) {
					continue;
				}
				element = (SOAPElement) tmp;
				element.getChildNodes();
				Iterator childrenElem = element.getChildElements();
				while (childrenElem.hasNext()) {
					if (childrenElem.next() instanceof SOAPElement) {
						throw new ConverErrorException("【Soap报文内容格式不正确】");
					}
				}
				String key = element.getAttribute("name");
				if (StringUtils.isEmpty(key)) {
					throw new ConverErrorException("【Soap报文内容格式不正确,缺少key值】");
				}
				String value = element.getValue();
				ReflectUtil.packing(rootClazz, reflectResult, key, value);
			}
			result=reflectResult.getResult();
		} catch (SOAPException e) {
			throw new ConverErrorException("【Soap报文内容格式不正确】", e);
		} catch (ClassNotFoundException|InstantiationException|IllegalAccessException|InvocationTargetException e) {
			throw new ConverErrorException("【entity定义不正确】");
		}
		return result;
	}
}
