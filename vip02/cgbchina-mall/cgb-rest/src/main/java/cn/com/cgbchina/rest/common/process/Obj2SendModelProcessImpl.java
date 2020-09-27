package cn.com.cgbchina.rest.common.process;

import cfca.sadk.algorithm.common.PKIException;
import cfca.sadk.cgb.toolkit.BASE64Toolkit;
import cn.com.cgbchina.common.utils.SM2EncryptUtils;
import cn.com.cgbchina.rest.common.annotation.XMLNodeName;
import cn.com.cgbchina.rest.common.constants.Constant;
import cn.com.cgbchina.rest.common.exception.ConverErrorException;
import cn.com.cgbchina.rest.common.model.O2OModel;
import cn.com.cgbchina.rest.common.model.O2OSendModel;
import cn.com.cgbchina.rest.common.util.SignUtils;
import cn.com.cgbchina.rest.common.utils.ReflectUtil;
import lombok.extern.slf4j.Slf4j;
import org.dom4j.Document;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.beans.IntrospectionException;
import java.beans.PropertyDescriptor;
import java.io.UnsupportedEncodingException;
import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.lang.reflect.Modifier;
import java.security.PrivateKey;
import java.security.PublicKey;
import java.util.List;

@Service
@Slf4j
public class Obj2SendModelProcessImpl {
	@Autowired
	private OutputVisitXMLReflectPackingImpl reflectPacking;
	private static int  PRIVATE_MODIFIER=Modifier.PRIVATE;
	public O2OSendModel packing(O2OModel<?> r, byte[] vendorKeyByte, byte[] mallKeyByte) {
		O2OSendModel result;
		try {
			result = new O2OSendModel();
			result.setMsgtype(r.getMsgType());
			result.setFormat(r.getFormat());
			result.setVersion(r.getVersion());
			result.setShopid(r.getShopId());
			result.setTimestamp(r.getTimestamp());
			result.setMethod(r.getMethod());
			Object obj = r.getMessage();
			Document document = DocumentHelper.createDocument();
			Element requestMessageElem = document.addElement("request_message");
			Element messageElem = requestMessageElem.addElement("message");
			ReflectUtil.unpacking(messageElem,obj.getClass(),obj,reflectPacking);
//			createXml(obj, messageElem);
			String message = document.asXML();
			log.info("[加密前的message]"+message);
			PublicKey vendorPuk = SM2EncryptUtils.readPublicKey(vendorKeyByte);
			PrivateKey mallPvk = SM2EncryptUtils.readPrivateKey(mallKeyByte);
			byte[] encryptByte = SM2EncryptUtils.getSM2Toolkit().SM2EncryptData(vendorPuk, message.getBytes(Constant.CHARSET_UTF8));
			String encryptMessage = BASE64Toolkit.encode(encryptByte);
			result.setMessage(encryptMessage);
			String sign = SignUtils.getSign(result, Constant.O2O_SIGN_ORDER);
			log.info("[签名前的串]"+sign);
			byte[] decryptSign = SM2EncryptUtils.getSM2Toolkit().SM2Sign(mallPvk, sign.getBytes(Constant.CHARSET_UTF8));
			// sign做base64加密
			String encrptSign = BASE64Toolkit.encode(decryptSign);
			result.setSign(encrptSign);
		} catch (UnsupportedEncodingException | PKIException e) {
			throw new ConverErrorException("o2o包装异常", e);
		}
		return result;
	}
	private void createXml(Object obj, Element messageElem) {
		Class<? extends Object> clazz = obj.getClass();
		Field[] fields = ReflectUtil.getFileds(clazz);
		for (Field field : fields) {
			if (List.class.isAssignableFrom(field.getType())) {
				Element items = messageElem.addElement("items");
				List<?> list = (List<?>) getMethod(field.getName(), obj);
				if (list != null) {
					for (int i = 0; i < list.size(); i++) {
						Element item = items.addElement("item");
						createXml(list.get(i), item);
					}
				}
			} else {
				setXml(obj, field, messageElem);
			}
		}
	}

	private void setXml(Object obj, Field field, Element elem) {
		try {
			if(field.getModifiers()==PRIVATE_MODIFIER){
				String fieldName = field.getName();
				Object valueObj = getMethod(fieldName, obj);
				XMLNodeName node = field.getAnnotation(XMLNodeName.class);
				if (node != null) {
					fieldName = node.value();
				}
				Element addElem = elem.addElement(fieldName);
				if (valueObj != null) {
					addElem.addText(String.valueOf(valueObj));
				}
			}
		} catch (IllegalArgumentException e) {
			throw new ConverErrorException("o2o转换异常", e);
		}

	}

	private Object getMethod(String name, Object obj) {
		Object result = null;
		try {
			PropertyDescriptor getPd = new PropertyDescriptor(name, obj.getClass());
			Method getMethod = getPd.getReadMethod();
			result = getMethod.invoke(obj);
		} catch (IllegalAccessException | IllegalArgumentException | InvocationTargetException
				| IntrospectionException e) {
			throw new ConverErrorException("o2o转换异常", e);
		}
		return result;
	}

}
