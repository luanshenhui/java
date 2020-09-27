package cn.com.cgbchina.rest.common.process;

import cn.com.cgbchina.rest.common.constants.Constant;
import cn.com.cgbchina.rest.common.exception.ConverErrorException;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.common.utils.ReflectResult;
import cn.com.cgbchina.rest.common.utils.ReflectUtil;
import cn.com.cgbchina.rest.common.utils.SOAPUtils;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.net.bsd.RLoginClient;
import org.springframework.stereotype.Service;

import javax.xml.soap.SOAPElement;
import javax.xml.soap.SOAPException;
import javax.xml.soap.SOAPHeader;
import javax.xml.soap.SOAPMessage;

import java.lang.reflect.InvocationTargetException;
import java.util.Iterator;

/**
 * Comment: Created by 11150321050126 on 2016/4/27.
 */
@Service
@Slf4j
public class InputSoapHanderProcessImpl
        implements PackProcess<String, SoapModel>, EncodingPackProcess<String, SoapModel> {

    @Override
    public SoapModel packing(String s, Class<SoapModel> t) {
        return this.packing(s, t, Constant.CHARSET_GBK);
    }

    @Override
    public SoapModel packing(String xml, Class<SoapModel> t, String encoding) {
        SoapModel model = null;
        try {
            SOAPMessage soapMessage = SOAPUtils.formatSoapString(xml, encoding);
            SOAPHeader headElement = soapMessage.getSOAPHeader();
            Iterator<SOAPElement> headType = headElement.getChildElements();
            if (headType == null || !headType.hasNext()) {
                throw new ConverErrorException("【报文体不正确】");
            }
            SOAPElement headType2 = headType.next();
            Iterator<SOAPElement> iterator = headType2.getChildElements();
            ReflectResult<SoapModel> result = new ReflectResult<>(SoapModel.class);
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
                ReflectUtil.packing(SoapModel.class, result, key, value);
            }
            model = result.getResult();
        } catch (SOAPException e) {
            throw new ConverErrorException("【Soap报文体不正确】", e);
        } catch (ConverErrorException e) {
            throw new ConverErrorException("【Soap报文内容格式不正确】", e);
        } catch (ClassNotFoundException e) {
        	throw new ConverErrorException("【Soap报文内容格式不正确】", e);
		} catch (InstantiationException e) {
			throw new ConverErrorException("【Soap报文内容格式不正确】", e);
		} catch (IllegalAccessException e) {
			throw new ConverErrorException("【Soap报文内容格式不正确】", e);
		} catch (InvocationTargetException e) {
			throw new ConverErrorException("【Soap报文内容格式不正确】", e);
		}
        return model;
    }
}
