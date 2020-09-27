package cn.com.cgbchina.rest.common.process;

import java.io.ByteArrayInputStream;
import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationTargetException;
import java.security.PrivateKey;
import java.security.PublicKey;
import java.util.Iterator;

import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.Element;
import org.dom4j.Node;
import org.dom4j.io.SAXReader;
import org.springframework.stereotype.Service;

import cfca.sadk.algorithm.common.PKIException;
import cfca.sadk.cgb.toolkit.BASE64Toolkit;
import cfca.sadk.cgb.toolkit.SM2Toolkit;
import cfca.sadk.org.bouncycastle.util.encoders.Base64;
import cn.com.cgbchina.common.utils.SM2EncryptUtils;
import cn.com.cgbchina.rest.common.constants.Constant;
import cn.com.cgbchina.rest.common.exception.ConverErrorException;
import cn.com.cgbchina.rest.common.model.O2OSendModel;
import cn.com.cgbchina.rest.common.util.SignUtils;
import cn.com.cgbchina.rest.common.utils.ReflectResult;
import cn.com.cgbchina.rest.common.utils.ReflectUtil;

@Service
public class Str2ObjO2OProcessImpl {

	private SM2Toolkit sm2Toolkit = SM2EncryptUtils.getSM2Toolkit();

	public <T> T packing(O2OSendModel o2oSendModel, Class<T> clazz, byte[] vendorPukByte, byte[] mallPvkByte) {
		try {
			String sign = SignUtils.getSign(o2oSendModel, Constant.O2O_SIGN_ORDER);
			PublicKey vendorPuk = SM2EncryptUtils.readPublicKey(vendorPukByte);
			PrivateKey mallPvk = SM2EncryptUtils.readPrivateKey(mallPvkByte);

			boolean flg = sm2Toolkit.SM2Verify(vendorPuk, sign.getBytes(Constant.CHARSET_UTF8),
					BASE64Toolkit.decode(o2oSendModel.getSign()));
			if (!flg) {
				return null;
			}

			byte[] messageByte = sm2Toolkit.SM2DecryptData(mallPvk, Base64.decode(o2oSendModel.getMessage()));
			String message = new String(messageByte, Constant.CHARSET_UTF8);
			ReflectResult<T> reflectResult=new ReflectResult<>(clazz);
			T result = reflectResult.getResult();
			SAXReader sr = new SAXReader();
			Document document = sr.read(new ByteArrayInputStream(message.getBytes(Constant.CHARSET_UTF8)));
			Node node = document.getRootElement().selectSingleNode("message");
			Element messageElem = (Element) node;
			
			setData(clazz, reflectResult, messageElem);
			return result;
		} catch (ClassNotFoundException | InstantiationException | IllegalAccessException | InvocationTargetException
				| UnsupportedEncodingException | DocumentException | PKIException e) {
			throw new ConverErrorException("o2o包装异常", e);
		}
	}

	private <T> void setData(Class<T> clazz,ReflectResult<T>  reflectResult, Element messageElem) {
		Iterator<Element> iterator = messageElem.elementIterator();
		while (iterator.hasNext()) {
			Element elem = iterator.next();
			String nodeName = elem.getName();
			String nodeValue = elem.getText();
			if ("items".equals(nodeName)) {
				Iterator<Element> iteamIterator = elem.elementIterator();
				while (iteamIterator.hasNext()) {
					Element itmElem = iteamIterator.next();
					setData(clazz, reflectResult, itmElem);
				}
			} else {
				ReflectUtil.packing(clazz, reflectResult, nodeName, nodeValue);
			}
		}
	}
}
