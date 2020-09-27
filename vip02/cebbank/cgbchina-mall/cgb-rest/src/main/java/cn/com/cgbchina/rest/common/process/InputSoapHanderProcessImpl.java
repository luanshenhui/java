package cn.com.cgbchina.rest.common.process;

import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.Iterator;

import javax.xml.namespace.QName;
import javax.xml.soap.SOAPElement;
import javax.xml.soap.SOAPException;
import javax.xml.soap.SOAPHeader;
import javax.xml.soap.SOAPMessage;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

import cn.com.cgbchina.rest.common.annotation.Special;
import cn.com.cgbchina.rest.common.constants.Constant;
import cn.com.cgbchina.rest.common.exception.ConverErrorException;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.common.utils.SOAPUtils;
import cn.com.cgbchina.rest.common.utils.StringUtil;
import lombok.extern.slf4j.Slf4j;

/**
 * Comment: Created by 11150321050126 on 2016/4/27.
 */
@Service
@Slf4j
public class InputSoapHanderProcessImpl implements PackProcess<String, SoapModel> {

	private SoapModel packing(String xml) {
		SoapModel model = null;
		try {
			SOAPMessage soapMessage = SOAPUtils.formatSoapString(xml, Constant.CHARSET_GBK);
			SOAPHeader headElement = soapMessage.getSOAPHeader();
			QName qName = new QName("http://www.agree.com.cn/GDBGateway", "HeadType", "gateway");
			Iterator<SOAPElement> headType = headElement.getChildElements(qName);
			if (headType == null || !headType.hasNext()) {
				throw new ConverErrorException("【报文体不正确】");
			}
			SOAPElement headType2 = headType.next();
			Iterator<SOAPElement> iterator = headType2.getChildElements();
			SoapModel result = new SoapModel();
			SOAPElement element = null;
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
						throw new ConverErrorException();
					}
				}
				String key = element.getElementQName().getLocalPart();
				if (StringUtils.isEmpty(key)) {
					throw new ConverErrorException();
				}
				String value = element.getValue();
				try {
					Field field = SoapModel.class.getDeclaredField(key);
					Method setMethod = SoapModel.class.getDeclaredMethod("set" + StringUtil.captureName(key),
							field.getType());
					String special = null;
					if ("java.util.Date".equals(field.getType())) {
						Special annotation = field.getAnnotation(Special.class);
						if (annotation != null) {
							special = annotation.value();
						}
					}
					setMethod.invoke(result, BeanUtils.convert2Obj(value, field.getType(), special));
				} catch (NoSuchFieldException e) {
					log.debug("【Soap头部实体缺少字段 " + key + " 】:\n" + soapMessage.getSOAPPart().getContent());
				} catch (NoSuchMethodException e) {
					throw new ConverErrorException("【Soap头部实体变量 " + key + " 缺少get/set方法】", e);
				} catch (IllegalAccessException e) {
					throw new ConverErrorException("【Soap头部实体变量 " + key + " 不可用】", e);
				} catch (InvocationTargetException e) {
					throw new ConverErrorException("【Soap头部实体变量 " + key + " 不可用】", e);
				}
			}
			model = result;
		} catch (SOAPException e) {
			throw new ConverErrorException("【Soap报文体不正确】", e);
		} catch (ConverErrorException e) {
			throw new ConverErrorException("【Soap报文内容格式不正确】", e);
		}
		return model;
	}

	@Override
	public SoapModel packing(String s, Class<SoapModel> t) {
		return packing(s);
	}
}
