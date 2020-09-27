package cn.com.cgbchina.restful.debug;

import java.io.InputStream;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.spirit.util.JsonMapper;

import cn.com.cgbchina.rest.common.model.O2OSendModel;
import cn.com.cgbchina.rest.common.process.InputSoapBodyProcessImpl;
import cn.com.cgbchina.rest.common.process.InputSoapHanderProcessImpl;
import cn.com.cgbchina.rest.common.process.OutputSoapProcessImpl;
import cn.com.cgbchina.rest.common.utils.HttpClientUtil;
import cn.com.cgbchina.restful.controller.BaseOutputContrller;
import cn.com.cgbchina.restful.controller.OutputController;
import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class LoopTestService extends BaseOutputContrller {

	@Resource
	private InputSoapHanderProcessImpl inputSoapHanderProcess;
	@Resource
	private InputSoapBodyProcessImpl<?> inputSoapBodyProcessImpl;
	@Resource
	private OutputSoapProcessImpl outputSoapProcessImpl;

	public void process() {
		while (true) {
			try {
				InputStream stream = this.getClass().getResourceAsStream("/test.properties");
				Properties properties = new Properties();
				properties.load(stream);

				String tradeCode = properties.getProperty("tradeCode");
				String serverUrlLoop=properties.getProperty("serverUrlLoop");
				String serverUrlChange=properties.getProperty("serverUrlChange");
				
				stream.close();
				String str = "tradeCode=" + tradeCode;
				log.info("[请求" + serverUrlLoop + "参数]" + str);
				String result = HttpClientUtil.getInstance().sendHttpPost(serverUrlLoop, str);
				if (!"No result".equals(result) && !"".equals(result)) {
					String response = super.malRealProcess(result);
					Map<String, String> map = new HashMap<>();
					map.put("content", response);
					map.put("tradeCode", tradeCode);
					HttpClientUtil.getInstance().sendHttpPost(serverUrlChange, map);
				}
				Thread.sleep(3000);

			} catch (Exception e) {
				log.error("出错了", e);
				try {
					Thread.sleep(3000);
				} catch (InterruptedException e1) {
					log.error("出错了", e1);
				}
			}
		}
	}
	private JsonMapper jsonMapper=JsonMapper.nonDefaultMapper();
	public void process2() {
		while (true) {
			try {
				InputStream stream = this.getClass().getResourceAsStream("/test.properties");
				Properties properties = new Properties();
				properties.load(stream);

				String tradeCode = properties.getProperty("tradeCode");
				String serverUrlLoop=properties.getProperty("serverUrlLoop");
				String serverUrlChange=properties.getProperty("serverUrlChange");
				
				stream.close();
				String str = "tradeCode=" + tradeCode;
				log.info("[请求" + serverUrlLoop + "参数]" + str);
				String result = HttpClientUtil.getInstance().sendHttpPost(serverUrlLoop, str);
				if (!"No result".equals(result) && !"".equals(result)) {
					O2OSendModel o2oSendModel=jsonMapper.fromJson(result, O2OSendModel.class);
					String response = super.outSystemRealProcess(o2oSendModel);
					Map<String, String> map = new HashMap<>();
					map.put("content", response);
					map.put("tradeCode", tradeCode);
					HttpClientUtil.getInstance().sendHttpPost(serverUrlChange, map);
				}
				Thread.sleep(3000);

			} catch (Exception e) {
				log.error("出错了", e);
				try {
					Thread.sleep(3000);
				} catch (InterruptedException e1) {
					log.error("出错了", e1);
				}
			}
		}
	}
}
