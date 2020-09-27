package chinsoft.service.logistic.bean;

import java.io.ByteArrayOutputStream;
import java.io.StringReader;

import javax.xml.bind.JAXBContext;
import javax.xml.bind.Marshaller;
import javax.xml.bind.Unmarshaller;

public class XmlManager {

	public static String doObjectToStrXml(Object obj) {
		String strXml = "";
		try {
			JAXBContext context = JAXBContext.newInstance(obj.getClass());
			Marshaller marshaller = context.createMarshaller();
			marshaller.setProperty(Marshaller.JAXB_ENCODING, "GB2312");
			marshaller.setProperty(Marshaller.JAXB_FORMATTED_OUTPUT, true);
			ByteArrayOutputStream os = new ByteArrayOutputStream();
			marshaller.marshal(obj, os);
			strXml = new String(os.toByteArray());
		} catch (Exception e) {
			e.printStackTrace();
		}
		return strXml;
	}

	public static Object doStrXmlToObject(String strXml, Class<?> classType) {
		try {
			JAXBContext context = JAXBContext.newInstance(classType);
			Unmarshaller marshaller = context.createUnmarshaller();
			Object xmlBean = marshaller.unmarshal(new StringReader(strXml));
			return xmlBean;
		} catch (Exception e) {
			System.out.println(e.getLocalizedMessage());
		}
		return null;
	}
}
