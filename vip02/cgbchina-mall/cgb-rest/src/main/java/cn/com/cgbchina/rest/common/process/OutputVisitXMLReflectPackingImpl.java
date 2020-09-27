package cn.com.cgbchina.rest.common.process;

import cn.com.cgbchina.rest.common.utils.ReflectUtil;
import com.spirit.util.JsonMapper;
import org.dom4j.Document;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

/**
 * Comment:
 * Created by 11150321050126 on 2016/11/2.
 */
@Service
public class OutputVisitXMLReflectPackingImpl implements ReflectPacking {
    @Override
    public <T> T processObjPacking(T element, String name, String value) {
        Element elem= (Element) element;
        if (value != null) {
            elem.addElement(name).addText(value);
        } else {
            elem.addElement(name);
        }
        return element;
    }

    @Override
    public <T> T processListPacking(T element, List list, Integer level, Integer index) {
        Element elem= (Element) element;
        if(index==0){
            elem = elem.addElement("items");
        }else {
            elem=elem.element("items");
        }
        elem = elem.addElement("item");
        return (T) elem;
    }
    public static void main(String args[]) {
        OutputVisitXMLReflectPackingImpl impl=new OutputVisitXMLReflectPackingImpl();
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

        Document document = DocumentHelper.createDocument();
        Element requestMessageElem = document.addElement("request_message");
        Element messageElem = requestMessageElem.addElement("message");
        ReflectUtil.unpacking(messageElem,list.getClass(),list,impl);
        System.out.println(document.asXML());
        JsonMapper jsonMapper=JsonMapper.nonDefaultMapper();
        System.out.println(jsonMapper.toJson(list));
    }
}
