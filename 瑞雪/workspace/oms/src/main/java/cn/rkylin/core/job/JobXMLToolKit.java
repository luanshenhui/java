package cn.rkylin.core.job;

import org.apache.log4j.Logger;
import org.dom4j.Document;
import org.dom4j.Element;
import org.dom4j.io.SAXReader;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.*;

public class JobXMLToolKit {
    private static Logger logger = Logger.getLogger(JobXMLToolKit.class);

    private static final String ROOT_ELEMENT_TRIGGERS_NAME = "triggers";
    private static final String ROOT_ELEMENT_BEAN_NAME = "bean";
    private static final String ELEMENT_TRIGGERS_LIST_NAME = "list";
    private static final String ELEMENT_REF_NAME = "ref";
    private static final String ELEMENT_SCEND_NAME = "property";
    private static final String ATTRIBUTE_VALUE_0_NAME = "id";
    private static final String ATTRIBUTE_VALUE_1_NAME = "name";
    private static final String ATTRIBUTE_VALUE_2_VALUE = "value";
    private static final String ATTRIBUTE_VALUE_3_VALUE = "bean";

    /**
     * 解析文件
     * @param file
     * @return
     * @throws Exception
     */
    public Map<String, JobInitVO> analyze(File file) throws Exception {
        return analyze(new FileInputStream(file));
    }

    /**
     * 解析文件
     * @param in
     * @return
     * @throws Exception
     */
    public Map<String, JobInitVO> analyze(InputStream in) throws Exception {
        SAXReader reader = new SAXReader();
        Document document = reader.read(in);
        Element rootElm = document.getRootElement();
        Element triggers = rootElm.element(ROOT_ELEMENT_TRIGGERS_NAME);
        if (null == triggers) {
            logger.error(this.getClass().getName() + ": Content '" + ROOT_ELEMENT_TRIGGERS_NAME + "' is not Found");
            return null;
        }
        Element triggerList = triggers.element(ELEMENT_TRIGGERS_LIST_NAME);
        if (null == triggerList) {
            logger.error(this.getClass().getName() + ": Content '" + ELEMENT_TRIGGERS_LIST_NAME + "' is not Found");
            return null;
        }
        List<Element> beans = rootElm.elements(ROOT_ELEMENT_BEAN_NAME);
        if (null == beans || beans.isEmpty()) {
            logger.error(this.getClass().getName() + ": Content '" + ROOT_ELEMENT_BEAN_NAME + "' is not Found");
            return null;
        }
        List<Element> beanRefList = triggerList.elements(ELEMENT_REF_NAME);
        if(null == beanRefList || beanRefList.isEmpty()){
            logger.error(this.getClass().getName() + ": Content '" + ELEMENT_REF_NAME + "' is not Found");
            return new HashMap<String, JobInitVO>();
        }
        String beanId = "";
        Set<String> beanIdSet = new HashSet<String>();
        for(Element ref : beanRefList){
            beanId = ref.attributeValue(ATTRIBUTE_VALUE_3_VALUE);
            if(null != beanId && !beanIdSet.contains(beanId)){
                beanIdSet.add(beanId);
            }else if(beanIdSet.contains(beanId)){
                logger.error(this.getClass().getName() + ": Content '" + ELEMENT_REF_NAME + "' has repeat bean id ["+beanId+"]!");
                return null;
            }
        }
        if(beanIdSet.isEmpty()){
            logger.error(this.getClass().getName() + ": Content '" + ATTRIBUTE_VALUE_3_VALUE + "' is not Found");
            return null;
        }

        String id = "";
        Map<String, JobInitVO> map = new HashMap<String, JobInitVO>();
        for (Element bean : beans) {
            id = bean.attributeValue(ATTRIBUTE_VALUE_0_NAME);

            if(!beanIdSet.contains(id)){
                logger.error(this.getClass().getName() + "： Job Init Error, Job id is [" + id + "], not add in trigger!");
                continue;
            }

            if (null != map.get(id)) {
                logger.error(this.getClass().getName() + "： Job Init Error, Job id is repeat [" + id + "]");
                throw new Exception(this.getClass().getName() + "： Job Init Error, Job id is repeat [" + id + "]");
            }

            List<Element> properties = bean.elements(ELEMENT_SCEND_NAME);
            if (null == properties || properties.isEmpty()) {
                logger.error(this.getClass().getName() + ": Content '" + ELEMENT_SCEND_NAME + "' is not Found");
                throw new Exception(this.getClass().getName() + "： Job Init Error, Job id is ["+id+"]");
            }
            if(2 > properties.size()){
                logger.error(this.getClass().getName() + ": Content property is not enough! Job id is ["+id+"]");
                throw new Exception(this.getClass().getName() + ": Content property is not enough! Job id is ["+id+"]");
            }
            String value = "";
            String name = "";

            JobInitVO vo = new JobInitVO();
            for (Element property : properties) {
                name = property.attributeValue(ATTRIBUTE_VALUE_1_NAME);
                value = property.attributeValue(ATTRIBUTE_VALUE_2_VALUE);

                invoke(vo, name, value);
            }
            if(!vo.check()){
                logger.error(this.getClass().getName() + ": Content property is not enough! Job id is ["+id+"]");
                throw new Exception(this.getClass().getName() + ": Content property is not enough! Job id is ["+id+"]");
            }
            map.put(id, vo);
        }
        return map;
    }

    /**
     * 反射设置属性值
     * @param vo
     * @param name
     * @param value
     * @throws java.lang.reflect.InvocationTargetException
     * @throws IllegalAccessException
     */
    private void invoke(JobInitVO vo, String name, String value) throws InvocationTargetException, IllegalAccessException {
        Method[] methods = vo.getClass().getMethods();
        for(Method m : methods){
            if(m.getName().toLowerCase().equals("set" + name.toLowerCase())){
                m.invoke(vo, value);
            }
        }
    }
}
