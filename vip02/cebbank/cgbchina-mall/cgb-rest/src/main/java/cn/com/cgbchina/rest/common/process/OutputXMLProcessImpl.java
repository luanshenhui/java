package cn.com.cgbchina.rest.common.process;

import org.dom4j.Document;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;
import org.springframework.stereotype.Service;

import cn.com.cgbchina.rest.provider.vo.BaseEntityVO;
import cn.com.cgbchina.rest.provider.vo.order.MsgReceipReturnVO;
import cn.com.cgbchina.rest.provider.vo.order.SendCodeReturnVO;
import cn.com.cgbchina.rest.provider.vo.order.VerificationNoticReturnVO;

/**
 * 接口返回的bean打包成xml
 * 
 * @author Lizy
 *
 */
//TODO:类名要改成InputXMLProcessImpl
@Service
public class OutputXMLProcessImpl implements PackProcess<Object, String> {

	@Override
	public String packing(Object model, Class<String> t) {
		Document document = DocumentHelper.createDocument();
		Element ele = document.addElement("request_message").addElement("message");
		// ele.addElement("result_code").addText("true");
		// ele.addElement("result_msg").addText("nice");
		BaseEntityVO tmp = null;
		if (model instanceof SendCodeReturnVO) {
			tmp = (SendCodeReturnVO) model;
		} else if (model instanceof MsgReceipReturnVO) {
			tmp = (MsgReceipReturnVO) model;
		} else if (model instanceof VerificationNoticReturnVO) {
			tmp = (VerificationNoticReturnVO) model;
		}
		ele.addElement("result_code").addText(tmp.getReturnCode());
		ele.addElement("result_msg").addText(tmp.getReturnDes());
		return document.asXML();
	}

}
