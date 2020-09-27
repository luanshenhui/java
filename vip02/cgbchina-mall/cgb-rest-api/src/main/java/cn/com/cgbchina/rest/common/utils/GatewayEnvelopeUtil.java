package cn.com.cgbchina.rest.common.utils;

import cn.com.cgbchina.rest.provider.vo.order.NoAs400GWEnvelopeVo;
import com.github.kevinsawicki.http.HttpRequest;
import lombok.extern.slf4j.Slf4j;
import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;
import org.dom4j.io.OutputFormat;
import org.dom4j.io.SAXReader;
import org.dom4j.io.XMLWriter;


import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.StringWriter;
import java.util.List;

@Slf4j
public class GatewayEnvelopeUtil {

    private static String url = PropertieUtils.getParam().get("gateway.url");

    private static int timeOut = Integer.parseInt(PropertieUtils.getParam().get("gateway.timeout"));

    public static Document genGatewayEnvelope(NoAs400GWEnvelopeVo noAs400GWEnvelopeVo) {

        Document document = DocumentHelper.createDocument();
        Element soapenv = document.addElement("soapenv:Envelope");
        soapenv.addNamespace("soapenv",
                "http://schemas.xmlsoap.org/soap/envelope/");
        soapenv.addNamespace("gateway", "http://www.agree.com.cn/GDBGateway");
        // 通用报文头
        Element header = soapenv.addElement("soapenv:Header");
        Element headType = header.addElement("gateway:HeadType");
        headType.addElement("gateway:versionNo").addText(
                noAs400GWEnvelopeVo.getVersionNo());
        headType.addElement("gateway:toEncrypt").addText(
                noAs400GWEnvelopeVo.getToEncrypt());
        headType.addElement("gateway:commCode").addText(
                noAs400GWEnvelopeVo.getCommCode());
        headType.addElement("gateway:commType").addText(
                noAs400GWEnvelopeVo.getCommType());
        headType.addElement("gateway:receiverId").addText(
                noAs400GWEnvelopeVo.getReceiverId());
        headType.addElement("gateway:senderId").addText(
                noAs400GWEnvelopeVo.getSenderId());
        headType.addElement("gateway:senderSN").addText(
                noAs400GWEnvelopeVo.getSenderSN());
        headType.addElement("gateway:senderDate").addText(
                noAs400GWEnvelopeVo.getSenderDate());
        headType.addElement("gateway:senderTime").addText(
                noAs400GWEnvelopeVo.getSenderTime());
        headType.addElement("gateway:tradeCode").addText(
                noAs400GWEnvelopeVo.getTradeCode());
        headType.addElement("gateway:gwErrorCode").addText(
                noAs400GWEnvelopeVo.getGwErrorCode());
        headType.addElement("gateway:gwErrorMessage").addText(
                noAs400GWEnvelopeVo.getGwErrorMessage());
        // 报文体
        Element body = soapenv.addElement("soapenv:Body");
        Element noAS400 = body.addElement("gateway:NoAS400");
        List bodyList = noAs400GWEnvelopeVo.getEnvelopeBody();
        if (bodyList != null && bodyList.size() > 0)
            for (int bodyCount = 0; bodyCount < bodyList.size(); bodyCount++) {
                String[] bodyEle = (String[]) bodyList.get(bodyCount);
                noAS400.addElement("gateway:field").addAttribute("name",
                        bodyEle[0]).addText(bodyEle[1] == null ? "" : bodyEle[1]);
            }
        return document;
    }


    public static Document genGatewayEnvelope(
            NoAs400GWEnvelopeVo noAs400GWEnvelopeVo, String bodyNameSpace) {
        Document document = DocumentHelper.createDocument();
        Element soapenv = document.addElement("soapenv:Envelope");
        soapenv.addNamespace("soapenv",
                "http://schemas.xmlsoap.org/soap/envelope/");
        soapenv.addNamespace(bodyNameSpace, "http://www.agree.com.cn/GDBGateway");
        // 通用报文头
        Element header = soapenv.addElement("soapenv:Header");
        Element headType = header.addElement(bodyNameSpace + ":HeadType");
        headType.addElement(bodyNameSpace + ":versionNo").addText(
                noAs400GWEnvelopeVo.getVersionNo());
        headType.addElement(bodyNameSpace + ":toEncrypt").addText(
                noAs400GWEnvelopeVo.getToEncrypt());
        headType.addElement(bodyNameSpace + ":commCode").addText(
                noAs400GWEnvelopeVo.getCommCode());
        headType.addElement(bodyNameSpace + ":commType").addText(
                noAs400GWEnvelopeVo.getCommType());
        headType.addElement(bodyNameSpace + ":receiverId").addText(
                noAs400GWEnvelopeVo.getReceiverId());
        headType.addElement(bodyNameSpace + ":senderId").addText(
                noAs400GWEnvelopeVo.getSenderId());
        headType.addElement(bodyNameSpace + ":senderSN").addText(
                noAs400GWEnvelopeVo.getSenderSN());
        headType.addElement(bodyNameSpace + ":senderDate").addText(
                noAs400GWEnvelopeVo.getSenderDate());
        headType.addElement(bodyNameSpace + ":senderTime").addText(
                noAs400GWEnvelopeVo.getSenderTime());
        headType.addElement(bodyNameSpace + ":tradeCode").addText(
                noAs400GWEnvelopeVo.getTradeCode());
        headType.addElement(bodyNameSpace + ":gwErrorCode").addText(
                noAs400GWEnvelopeVo.getGwErrorCode());
        headType.addElement(bodyNameSpace + ":gwErrorMessage").addText(
                noAs400GWEnvelopeVo.getGwErrorMessage());
        // 报文体
        Element body = soapenv.addElement("soapenv:Body");
        Element noAS400 = body.addElement(bodyNameSpace + ":NoAS400");
        List bodyList = noAs400GWEnvelopeVo.getEnvelopeBody();
        if (bodyList != null && bodyList.size() > 0)
            for (int bodyCount = 0; bodyCount < bodyList.size(); bodyCount++) {
                String[] bodyEle = (String[]) bodyList.get(bodyCount);
                noAS400.addElement(bodyNameSpace + ":field").addAttribute("name",
                        bodyEle[0]).addText(bodyEle[1] == null ? "" : bodyEle[1]);
            }
        return document;
    }


    /**
     * 取得非AS400主机报文中 <soapenv:Body><gateway:NoAS400><gateway:field
     * name='******'>的属性值
     *
     * @param document
     * @param name
     * @return
     * @throws IOException
     * @throws DocumentException
     */
    public static String getNoAS400BodyField(Document document, String name, String ns1, String ns2) {


        Element bodyElement = (Element) document
                .selectSingleNode("//" + ns1 + ":Envelope/" + ns1 + ":Body/" + ns2 + ":NoAS400");
        Element fieldNamElement = (Element) bodyElement
                .selectSingleNode("//" + ns2 + ":field[@name='" + name + "']");

        // return fieldNamElement==null?null:fieldNamElement.getStringValue();
        if (fieldNamElement == null)
            return null;

        return fieldNamElement.getStringValue() == null ? null
                : fieldNamElement.getStringValue().trim();

    }


    public static String getSenderSN(Document document) {
        Element root = (Element) document.getRootElement();
        String rootNS = root.getNamespacePrefix();

        Element senderSNElement = (Element) document
                .selectSingleNode("//" + rootNS + ":Envelope/" + rootNS + ":Header/gateway:HeadType/gateway:senderSN");

        // return fieldNamElement==null?null:fieldNamElement.getStringValue();
        if (senderSNElement == null)
            return "";

        return senderSNElement.getStringValue() == null ? ""
                : senderSNElement.getStringValue().trim();

    }


    /**
     * 取得非AS400主机报文中 <soapenv:Body><gateway:NoAS400><gateway:field
     * name='******'>的属性值
     *
     * @param document
     * @param name
     * @return
     */
    public static String[] getNoAS400BodyFieldArray(Document document,
                                                    String name, String ns1, String ns2) {
        Element bodyElement = (Element) document
                .selectSingleNode("//" + ns1 + ":Envelope/" + ns1 + ":Body/gateway:NoAS400");
        List fieldList = bodyElement.selectNodes("//" + ns2 + ":field[@name='"
                + name + "']");
        String[] fieldNameArray;
        if (fieldList != null && fieldList.size() > 0) {
            fieldNameArray = new String[fieldList.size()];
            for (int count = 0; count < fieldList.size(); count++) {
                Element fieldNamElement = (Element) fieldList.get(count);

                fieldNameArray[count] = fieldNamElement.getStringValue() == null ? null
                        : fieldNamElement.getStringValue().trim();
            }
        } else {
            fieldNameArray = new String[0];
        }
        return fieldNameArray;
    }

    /**
     * 向柜面网关发送SOAP报文并返回柜面网关的响应报文
     *
     * @param soapEnvelope
     * @return
     * @throws IOException
     * @throws DocumentException
     */
    public static Document sendEnvelope(Document soapEnvelope) throws IOException, DocumentException {

        OutputFormat format = OutputFormat.createCompactFormat();
        format.setEncoding("GBK");
        StringWriter writer = new StringWriter();
        XMLWriter xmlWriter = new XMLWriter(writer, format);
        xmlWriter.write(soapEnvelope);


        // 发送报文
        InputStream in = new ByteArrayInputStream(writer.toString().getBytes("GBK"));
        HttpRequest httpRequest = HttpRequest.post(url, false).send(in).connectTimeout(timeOut).readTimeout(timeOut);
        httpRequest.header("Content-type", "text/xml;charset=GBK");
        httpRequest.header("Connection", "close");

        log.info("发送报文:" + writer);

        InputStream response = null;
        Document returnDocument = null;
        try {
            response = httpRequest.stream();
            SAXReader reader = new SAXReader();
            reader.setEncoding("GBK");
            returnDocument = reader.read(response);
            log.info("收到报文:" + returnDocument.asXML());
        } catch (Exception e) {
            log.error("exception", e);
        } finally {
            if (response != null) {
                response.close();
            }
        }

        return returnDocument;


    }

    /**
     * 取得物流接口报文
     *
     * @param document
     * @param name
     * @return
     */
    public static String[] getLogisticsFieldArray(Document document,
                                                  String name) {
        List fieldList = document.getRootElement().selectNodes(name);
        String[] fieldNameArray;
        if (fieldList != null && fieldList.size() > 0) {
            fieldNameArray = new String[fieldList.size()];
            for (int count = 0; count < fieldList.size(); count++) {
                Element fieldNamElement = (Element) fieldList.get(count);

                fieldNameArray[count] = fieldNamElement.getStringValue() == null ? null
                        : fieldNamElement.getStringValue().trim();
            }
        } else {
            fieldNameArray = new String[0];
        }
        return fieldNameArray;
    }


}
