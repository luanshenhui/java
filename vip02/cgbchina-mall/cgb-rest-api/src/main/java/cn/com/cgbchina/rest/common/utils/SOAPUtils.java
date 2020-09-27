package cn.com.cgbchina.rest.common.utils;

import cn.com.cgbchina.rest.common.exception.ConverErrorException;
import cn.com.cgbchina.rest.common.model.EBankModel;
import cn.com.cgbchina.rest.common.model.O2OModel;
import cn.com.cgbchina.rest.common.model.SoapModel;
import com.spirit.util.JsonMapper;
import org.slf4j.Logger;

import javax.xml.soap.MessageFactory;
import javax.xml.soap.MimeHeaders;
import javax.xml.soap.SOAPMessage;
import java.io.ByteArrayInputStream;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * Comment: Created by 11150321050126 on 2016/4/19.
 */
public class SOAPUtils {

	public static final Logger log = org.slf4j.LoggerFactory.getLogger(SOAPUtils.class);
	private static JsonMapper jsonMapper = JsonMapper.nonDefaultMapper();
	private static final String channel = PropertieUtils.getParam().get("channel");
	private static final String webChannel = PropertieUtils.getParam().get("webChannel");
	private static final String SENDER_SN = webChannel + webChannel;

	/**
	 * 把string的xml转换成soap对象
	 * 
	 * @param soapString
	 * @param character
	 * @return
	 */
	public static SOAPMessage formatSoapString(String soapString, String character) throws ConverErrorException {
		MessageFactory msgFactory;
		try {
			soapString = soapString.replaceAll("\\>\\s+\\<", "><");

			soapString = soapString.replaceAll("http:// www.gdb.com.cn /GDBGateway ",
					"http://www.agree.com.cn/GDBGateway");
			soapString = soapString.replaceAll("http://schemas.xmlsoap.org/soap/envelope/ ",
					"http://schemas.xmlsoap.org/soap/envelope/");

			msgFactory = MessageFactory.newInstance();
			SOAPMessage reqMsg = msgFactory.createMessage(new MimeHeaders(),
					new ByteArrayInputStream(soapString.getBytes(character)));
			reqMsg.saveChanges();
			return reqMsg;
		} catch (Exception e) {
			throw new ConverErrorException();
		}
	}

	public static SoapModel createSOAPModel(String senderSN, Object obj) {
		SoapModel model = new SoapModel();
		Date date = new Date();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		SimpleDateFormat sdf2 = new SimpleDateFormat("HHmmss");
		model.setVersionNo("1");
		model.setToEncrypt("0");
		model.setCommCode("500001");
		model.setCommType("0");
		model.setSenderId(channel);
		model.setSenderSN(senderSN);
		model.setSenderDate(sdf.format(date));
		model.setSenderTime(sdf2.format(date));
		model.setContent(obj);
		return model;
	}

	private static SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
	private static SimpleDateFormat sdf2 = new SimpleDateFormat("HHmmss");

	public static <T> EBankModel<T> createEBankModel(String senderSN, T obj) {
		EBankModel<T> eBankModel = new EBankModel<>();
		Date date = new Date();
		eBankModel.setRf("XML");
		eBankModel.setSrcChannel(webChannel);
		eBankModel.setSenderSN(SENDER_SN + senderSN);
		eBankModel.setContent(obj);
		return eBankModel;
	}

	private static SimpleDateFormat sdf3 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

	public static <T> O2OModel<T> createO2OModel(T obj) {
		O2OModel<T> mode = new O2OModel<>();
		mode.setFormat("xml");
		mode.setVersion("1.0");
		mode.setTimestamp(sdf3.format(new Date()));
		mode.setMessage(obj);
		return mode;
	}
}
