package cn.com.cgbchina.rest.common.process;

import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.util.HashMap;
import java.util.Map;

import org.springframework.stereotype.Service;

import cn.com.cgbchina.rest.common.annotation.XMLNodeName;
import cn.com.cgbchina.rest.common.exception.ConverErrorException;
import cn.com.cgbchina.rest.common.model.EBankModel;
import cn.com.cgbchina.rest.common.utils.StringUtil;

@Service
public class EBankVo2XMLProcessImpl implements PackProcess<EBankModel<?>, Map> {

	@Override
	public Map<String, String> packing(EBankModel<?> r, Class<Map> class2) {
		Map<String, String> map = new HashMap<>();
		map.put("rf", r.getRf());
		map.put("senderSN", r.getSenderSN());
		map.put("srcChannel", r.getSrcChannel());
		Object obj = r.getContent();
		Class<? extends Object> class1 = obj.getClass();
		Field[] fields = class1.getDeclaredFields();
		for (Field field : fields) {
			String name = field.getName();
			Method valueMethod;
			Object value;
			try {
				valueMethod = class1.getDeclaredMethod("get" + StringUtil.captureName(name));
				value = valueMethod.invoke(obj);
				XMLNodeName nodeName = field.getAnnotation(XMLNodeName.class);
				if (nodeName != null) {
					name = nodeName.value();
				}
			} catch (Exception e) {
				throw new ConverErrorException("[个人网银][包装数据异常]", e);
			}
			if (value != null) {
				map.put(name, String.valueOf(value));
			} else {
				map.put(name, null);
			}
		}
		return map;
	}

}
