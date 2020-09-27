package cn.com.cgbchina.rest.common.process;

import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.nio.ByteBuffer;

import org.springframework.stereotype.Service;

import cn.com.cgbchina.rest.common.exception.ConverErrorException;
import cn.com.cgbchina.rest.common.utils.CommunicationNatp;
import cn.com.cgbchina.rest.common.utils.StringUtil;
import cn.com.cgbchina.rest.visit.vo.sms.SendSMSInfoVO;

import com.spirit.util.JsonMapper;

@Service
public class OutputSMSProcessImpl<T> implements
		PackProcess<T, CommunicationNatp> {

	private JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();

	@Override
	public CommunicationNatp packing(T r, Class<CommunicationNatp> t) {
		Class clazz = r.getClass();
		CommunicationNatp natp = new CommunicationNatp();
		int natpVersion = 16;
		String transCode = "MSEND";
		String templateCode = "300001";
		String reservedCode = "SMSP";
		natp.init(natpVersion, transCode, templateCode, reservedCode);
		Field[] fields = clazz.getDeclaredFields();
		for (Field fidld : fields) {
			String fieldName = fidld.getName();
			Method method;
			try {
				method = clazz.getDeclaredMethod("get"
						+ StringUtil.captureName(fieldName));
				Object value = method.invoke(r);
				String valueOf = String.valueOf(value);
				natp.pack(fieldName.toUpperCase(), valueOf);
			} catch (NoSuchMethodException | SecurityException e) {
				throw new RuntimeException("实时发送短信方法出错，没有该属性的GET方法", e);
			} catch (IllegalAccessException | IllegalArgumentException
					| InvocationTargetException e) {
				throw new RuntimeException("实时发送短信方法出错，调用GET方法出错", e);
			} catch (Exception e) {
				throw new RuntimeException("实时发送短信方法出错，打包成报文方法出错", e);
			}

		}
		return natp;
	}
	
	public static void main(String[] args) throws Exception {
		SendSMSInfoVO vo=new SendSMSInfoVO();
		vo.setTop("8000");
		vo.setMobile("13802103004");
		vo.setSendBranch("010000");
		vo.setChannelCode("072");
		vo.setSerial("2016102627422400");
		vo.setTemplateId("072FH00024");
		vo.setSmsId("FH");
		OutputSMSProcessImpl impl=new OutputSMSProcessImpl<>();
		CommunicationNatp natp = impl.packing(vo, CommunicationNatp.class);
		String str=natp.exchange_result("21.96.166.165" + ":" + "58088" + ":5");
		System.out.println(str);
	}

}
