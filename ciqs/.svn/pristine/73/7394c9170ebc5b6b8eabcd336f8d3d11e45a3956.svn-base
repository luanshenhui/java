package com.dpn.ciqqlc.webclient.good;

import java.util.Map;

import org.ksoap2.SoapEnvelope;
import org.ksoap2.serialization.SoapObject;
import org.ksoap2.serialization.SoapSerializationEnvelope;
import org.ksoap2.transport.HttpTransportSE;
import org.kxml2.kdom.Element;
import org.kxml2.kdom.Node;

public class soapXml {

//	public static void main(String args[]) {
//		
////		String m_strSessionID = soapXml.fetchInitial();
////		String loginFlag = soapXml.fetchUserLogin(m_strSessionID);
//		Map<String, Object> params = new HashMap<String,Object>();
////		params.put("PackageSize", 20);
////		params.put("GoodsIDMin", goodId);
//		
//		params.put("PackageSize", 100);
//		params.put("GoodsIDMin", 5238402);
//		soapXml.fetchSoapXml("GetIntcpDataTotalCount", "i2lbvoqfitrsutttmg43zleb", params);
////		String tqx = Constants.DOM_PARENT_BEGIN+ goodStr.substring(goodStr.indexOf(DOM_TQUAR_BEGIN),(goodStr.lastIndexOf(DOM_TQUAR_END)+DOM_TQUAR_END.length()) ) +Constants.DOM_PARENT_END;
//		System.out.println();
//		System.out.println(soapXml.fetchSoapXml("GetIntcpQuarDataAsXML","i2lbvoqfitrsutttmg43zleb", params));
//												 
////		System.out.println(soapXml.fetchSoapXml("Initial", params));
//
//	}
    public static String fetchSoapXml(String MethodName,String sessionId,Map<String, Object> params){
    	
        try {
        	
            String url = "http://10.239.31.5/Service/IntcpDataPort.asmx?wsdl";
            String NameSpace = "http://info.apqchina.org/";
            String soapAction = NameSpace + MethodName;

            SoapObject soapObeject = new SoapObject(NameSpace, MethodName);
            
            //根据具体参数个数输入参数，Packgesize(1~100),起始ID设可以0从开始查找，其他的可以设置为空""......
            for (Map.Entry<String, Object> entry : params.entrySet()) { 
            	soapObeject.addProperty(entry.getKey(), entry.getValue()); 
            }
            
            HttpTransportSE transport = new HttpTransportSE(url);
            transport.debug = true;

            //因目前没有启用用户验证，报头可以暂时不用管，下一步使用。
            Element[] header = new Element[1];
            header[0] = new Element().createElement(NameSpace,"SoapAgency");

            Element SessionID = new Element().createElement(NameSpace, "UserID");
            SessionID.addChild(Node.IGNORABLE_WHITESPACE, sessionId);//string
            header[0].addChild(Node.ELEMENT, SessionID);

            SoapSerializationEnvelope envelope ;//envelope
            envelope= new SoapSerializationEnvelope(SoapEnvelope.VER11);// 1.0=10 1.1=11 1.2=12
            envelope.headerOut = header;// add header to envelope
            envelope.bodyOut = transport;
            envelope.dotNet = true;
            envelope.setOutputSoapObject(soapObeject);

                transport.call(soapAction, envelope);

                //因目前没有启用用户验证，报头可以暂时不用管，下一步使用。读取返回报头
                String strTemp ="返回报头:\n";
                Element[] respHeader =  envelope.headerIn;
                Element e ;
                String m_strSessionID = "";
                String m_strIsErrorOccured = "";
                String m_strDescription = "";
//                System.out.println(respHeader.toString());
                for(int i=0;i<respHeader[0].getChildCount();i++){
                    e= (Element) respHeader[0].getChild(i);
                    strTemp+=e.getName()+"\n";
                    if(e.getName().equals("UserID") && e.getChildCount()>0){
                        m_strSessionID=(String)e.getChild(0);
                    }

                    if(e.getName().equals("ISErrorOccured") && e.getChildCount()>0){
                        m_strIsErrorOccured=(String)e.getChild(0);
                    }

                    if(e.getName().equals("Description") && e.getChildCount()>0){
                        m_strDescription=(String)e.getChild(0);
                    }
                }
                
//                if(MethodName.equals("Initial")){
//                	soapXml.fetchUserLogin(m_strSessionID);
//                }
//                if(m_strIsErrorOccured.equals("true")){
//                	params.put("UserID", m_strSessionID);
//                	return soapXml.fetchSoapXml("Initial", params);
//                }

                //读取返回正文
                if(envelope.bodyIn!=null){
                    SoapObject so = (SoapObject) envelope.bodyIn;
                    String xmlMessage = so.toString();
                    strTemp+="返回正文：";
                    strTemp+="属性标签个数："+ so.getAttributeCount();
                    strTemp+="属性字段个数："+ so.getPropertyCount();
                    if(so.getPropertyCount()>0){
                        String strResult= so.getPropertyAsString(MethodName+"Result");
                        System.out.println(strResult);
                    }
                    return (xmlMessage);
                }			
		} catch (Exception e) {
			e.printStackTrace();
			return "";
		}
    	return "";
    }	
    
    public static String fetchInitial(){
    	
    	try {
    		String MethodName = "Initial";
            String url = "http://10.239.31.5/Service/IntcpDataPort.asmx?wsdl";
            String NameSpace = "http://info.apqchina.org/";
            String soapAction = NameSpace + MethodName;

            SoapObject soapObeject = new SoapObject(NameSpace, MethodName);
            
            HttpTransportSE transport = new HttpTransportSE(url);
            transport.debug = true;

            //因目前没有启用用户验证，报头可以暂时不用管，下一步使用。
            Element[] header = new Element[1];
            header[0] = new Element().createElement(NameSpace,"SoapAgency");

            Element SessionID = new Element().createElement(NameSpace, "UserID");
            SessionID.addChild(Node.IGNORABLE_WHITESPACE, "m_strSessionID");//string
            header[0].addChild(Node.ELEMENT, SessionID);

            SoapSerializationEnvelope envelope ;//envelope
            envelope= new SoapSerializationEnvelope(SoapEnvelope.VER11);// 1.0=10 1.1=11 1.2=12
            envelope.headerOut = header;// add header to envelope
            envelope.bodyOut = transport;
            envelope.dotNet = true;
            envelope.setOutputSoapObject(soapObeject);

                transport.call(soapAction, envelope);

                //因目前没有启用用户验证，报头可以暂时不用管，下一步使用。读取返回报头
                Element[] respHeader =  envelope.headerIn;
                Element e ;
                String m_strSessionID = "";
                System.out.println(respHeader.toString());
                for(int i=0;i<respHeader[0].getChildCount();i++){
                    e= (Element) respHeader[0].getChild(i);
                    if(e.getName().equals("UserID") && e.getChildCount()>0){
                        m_strSessionID=(String)e.getChild(0);
                        return m_strSessionID;
                    }
                }
		} catch (Exception e) {
			return "";
		}
    	return "";
    }
    public static String fetchUserLogin(String userId){
    	
        try {
        	
            String url = "http://10.239.31.5/Service/IntcpDataPort.asmx?wsdl";
            String NameSpace = "http://info.apqchina.org/";
            String MethodName = "UserLogon";
            String soapAction = NameSpace + MethodName;

            SoapObject soapObeject = new SoapObject(NameSpace, MethodName);
        	soapObeject.addProperty("Username", "IntcpWsForLiaoN"); 
        	soapObeject.addProperty("Password", "180101");
        	soapObeject.addProperty("VrifyNo", "");
        	soapObeject.addProperty("intLogonType", 2);
            
            HttpTransportSE transport = new HttpTransportSE(url);
            transport.debug = true;

            //因目前没有启用用户验证，报头可以暂时不用管，下一步使用。
            Element[] header = new Element[1];
            header[0] = new Element().createElement(NameSpace,"SoapAgency");

            Element SessionID = new Element().createElement(NameSpace, "UserID");
            SessionID.addChild(Node.IGNORABLE_WHITESPACE, userId);//string
//            SessionID.addChild(Node.TEXT, userId);
            header[0].addChild(Node.ELEMENT, SessionID);

            SoapSerializationEnvelope envelope ;//envelope
            envelope= new SoapSerializationEnvelope(SoapEnvelope.VER11);// 1.0=10 1.1=11 1.2=12
            envelope.headerOut = header;// add header to envelope
            envelope.bodyOut = transport;
            envelope.dotNet = true;
            envelope.setOutputSoapObject(soapObeject);

            transport.call(soapAction, envelope);

                //因目前没有启用用户验证，报头可以暂时不用管，下一步使用。读取返回报头
                String strTemp ="返回报头:\n";
                Element[] respHeader =  envelope.headerIn;
                Element e ;
                String m_strSessionID = "";
                String m_strIsErrorOccured = "";
                String m_strDescription = "";
                System.out.println(respHeader.toString());
                for(int i=0;i<respHeader[0].getChildCount();i++){
                    e= (Element) respHeader[0].getChild(i);
                    strTemp+=e.getName()+"\n";
                    if(e.getName().equals("UserID") && e.getChildCount()>0){
                        m_strSessionID=(String)e.getChild(0);
                    }

                    if(e.getName().equals("ISErrorOccured") && e.getChildCount()>0){
                        m_strIsErrorOccured=(String)e.getChild(0);
                        
                    }

                    if(e.getName().equals("Description") && e.getChildCount()>0){
                        m_strDescription=(String)e.getChild(0);
                        System.out.println(m_strDescription);
                    }
                }	
                return m_strIsErrorOccured;
		} catch (Exception e) {
			return "";
		}
        
    }
}
