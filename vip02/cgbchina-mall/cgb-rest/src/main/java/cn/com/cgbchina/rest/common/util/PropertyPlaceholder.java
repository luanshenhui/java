package cn.com.cgbchina.rest.common.util;

import com.google.common.collect.Maps;
import org.springframework.beans.BeansException;
import org.springframework.beans.factory.config.ConfigurableListableBeanFactory;
import org.springframework.beans.factory.config.PropertyPlaceholderConfigurer;

import java.util.Map;
import java.util.Properties;

/**
 * Created by lvzd on 2016/10/1.
 */
public class PropertyPlaceholder extends PropertyPlaceholderConfigurer {

    private static Map<String,String> propertyMap;

    @Override
    protected void processProperties(ConfigurableListableBeanFactory beanFactoryToProcess, Properties props) throws BeansException {
        super.processProperties(beanFactoryToProcess, props);
        propertyMap = Maps.newHashMap();
        for (Object key : props.keySet()) {
            String keyStr = key.toString();
            String value = props.getProperty(keyStr);
            propertyMap.put(keyStr, value);
        }
    }
    public static String getProperty(String name) {
        return (String)propertyMap.get(name);
    }
}