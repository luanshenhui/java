package cn.com.cgbchina.restful.model;

import java.util.Iterator;
import java.util.List;

import org.apache.commons.beanutils.BeanUtils;
import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;

import cn.com.cgbchina.rest.common.utils.ReflectUtil;
import cn.com.cgbchina.rest.common.utils.ValidateUtil;
import cn.com.cgbchina.rest.provider.model.order.MsgReceipReturn;
import cn.com.cgbchina.rest.provider.vo.order.SendCodeInfoVO;

public class tmp {
	public static void main(String[] args) throws Exception {
		SendCodeInfoVO obj = new SendCodeInfoVO();
		obj.setOrderNo("11");
		obj.setSum(11);
		Object obj2 = null;
		String str = ValidateUtil.validateModel(obj);
		System.out.println(str.length());

	}

	public static void main2(String[] args) throws DocumentException, InstantiationException, IllegalAccessException {
		Document document = DocumentHelper.parseText(
				"<?xml version=\"1.0\" encoding=\"UTF-8\"?><request_message><message><orderno>10000</orderno><sum>2</sum><organ_id>2</organ_id>		<payment>100</payment>"
						+ "<items>" + "<item><suborderno>1234324234435566</suborderno>" + "</item>	"
						+ "<item><suborderno>1234324234435566</suborderno>" + "</item>"
						+ "</items>	</message></request_message>");

		Element root = document.getRootElement();
		// getElement(root, AddOrderCode.class);
		SendCodeInfoVO result = new SendCodeInfoVO();

		Iterator eleIterator = root.element("message").elementIterator();
		Long sTime = System.currentTimeMillis();

		/*
		 * while (eleIterator.hasNext()) { Element childEle = (Element) eleIterator.next(); String key =
		 * childEle.getName(); String value = childEle.getText(); System.out.println(key + " " + value);
		 * ReflectUtil.loop(AddOrderCode.class, result, key, value); }
		 */

		// getElement(root, result);
		Long eTime = System.currentTimeMillis();
		System.out.println((eTime - sTime) + "ms");

		System.out.println(result.getItems().get(0).getSubOrderNo());

	}

	private static <T> void getElement(Element element, T result)
			throws InstantiationException, IllegalAccessException {
		List list = element.elements();
		for (Iterator its = list.iterator(); its.hasNext();) {
			Element chileEle = (Element) its.next();
			ReflectUtil.loop(SendCodeInfoVO.class, (SendCodeInfoVO) result, chileEle.getName(), chileEle.getText());
			getElement(chileEle, result);
			// System.out.println("节点：" + chileEle.getName() + ",内容：" + chileEle.getText());
		}

	}
}
