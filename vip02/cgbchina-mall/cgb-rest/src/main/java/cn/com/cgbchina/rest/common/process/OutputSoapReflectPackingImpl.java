package cn.com.cgbchina.rest.common.process;

import cn.com.cgbchina.common.utils.DateHelper;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.common.utils.ReflectUtil;
import cn.com.cgbchina.rest.common.utils.StringUtil;
import org.dom4j.Document;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;
import org.springframework.stereotype.Service;

import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.List;

/**
 * Comment:
 * Created by 11150321050126 on 2016/11/1.
 */
@Service
public class OutputSoapReflectPackingImpl implements ReflectPacking {
    @Override
    public <T> T processObjPacking(T element, String name, String value) {
        if(value!=null) {
            Element elem = (Element) element;
            elem.addElement("gateway:field").addAttribute("name", name).addText(value);
        }
        return element;
    }

    @Override
    public <T> T processListPacking(T element,List list,Integer level,Integer index) {
        return element;
    }

    public static void main(String args[]) throws NoSuchMethodException, InvocationTargetException, IllegalAccessException {
        OutputSoapReflectPackingImpl impl=new OutputSoapReflectPackingImpl();
        TestList list=new TestList();
        list.setA("a1");
        list.setB("b1");
        ArrayList<TestList> arlist = new ArrayList<TestList>();
        list.setC(arlist);

        TestList list2=new TestList();
        list2.setA("a2");
        list2.setB("b2");

        TestList list3=new TestList();
        list3.setA("a3");
        list3.setB("b3");

        TestList list4=new TestList();
        list4.setA("a4");
        list4.setB("b4");

        TestList list5=new TestList();
        list5.setA("a5");
        list5.setB("b5");

        TestList list6=new TestList();
        list6.setA("a6");
        list6.setB("b6");


        ArrayList<TestList> arlist2=new ArrayList<>();
        arlist2.add(list5);
        arlist2.add(list6);

        arlist.add(list2);
        arlist.add(list3);
        arlist.add(list4);
        list2.setC(arlist2);

        SoapModel model=new SoapModel();
        model.setSenderSN("sssddd");
        model.setSenderDate(DateHelper.YYYYMMDD);
        model.setSenderTime(DateHelper.HHMMSS);
        model.setContent(list);
        Document document = DocumentHelper.createDocument();
            document.setXMLEncoding("UTF-8");
            Element soapenv = document.addElement("soapenv:Envelope");
            soapenv.addNamespace("soapenv", "http://schemas.xmlsoap.org/soap/envelope/");
            soapenv.addNamespace("gateway", "http://www.agree.com.cn/GDBGateway");
            // 通用报文头
            Element header = soapenv.addElement("soapenv:Header");
            Element headType = header.addElement("gateway:HeadType");
            Field[] fields = SoapModel.class.getDeclaredFields();
            for (Field field : fields) {
                if (!"content".equals(field.getName())) {
                    if (!List.class.isAssignableFrom(field.getType())) {
                        Method method = SoapModel.class
                                .getDeclaredMethod("get" + StringUtil.captureName(field.getName()));
                        Object invoke = method.invoke(model);
                        Element elem = headType.addElement("gateway:" + field.getName());
                        if (invoke == null) {
                            invoke = "";
                        }
                        elem.addText(String.valueOf(invoke));
                    }
                }
            }
            Element body = soapenv.addElement("soapenv:Body");
            Element noAS400 = body.addElement("gateway:NoAS400");
            Object content = model.getContent();
            Class<?> rootClass = content.getClass();
            ReflectUtil.unpacking(noAS400, rootClass, content, impl);
        System.out.println(document.asXML());
        }
    }
