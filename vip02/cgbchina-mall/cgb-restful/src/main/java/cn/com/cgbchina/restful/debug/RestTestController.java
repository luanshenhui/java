package cn.com.cgbchina.restful.debug;

import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.spirit.util.JsonMapper;

import cn.com.cgbchina.common.utils.NetworkUtil;
import cn.com.cgbchina.rest.common.model.O2OSendModel;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.common.process.InputSoapHanderProcessImpl;
import cn.com.cgbchina.restful.controller.BaseOutputContrller;
import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
public class RestTestController extends BaseOutputContrller {
	private int loop = 20;
	private int time = 500;
	@Resource
	private InputSoapHanderProcessImpl inputSoapHanderProcess;
	private static Map<String, Bean> mapps = new HashMap<>();
	@Resource
	private LoopTestService loopTest;
	private JsonMapper jsonMapper=JsonMapper.nonDefaultMapper();

	@RequestMapping(value = "/GatewayReceiveServlet", method = RequestMethod.POST, produces = "text/plain;charset=GBK")
	@ResponseBody
	public String debugCode(HttpServletRequest request) {
		String uuid = UUID.randomUUID().toString().replace("-", "");
		try {
			String xml = super.getXml(request);
			log.info("[" + uuid + "]【接受到的xml报文】:\n" + xml);
			SoapModel<?> model = inputSoapHanderProcess.packing(xml, SoapModel.class,"UTF-8");
			String tradeCode = model.getTradeCode();
			Bean bean2 = mapps.get(tradeCode);
			if (bean2 == null) {
				Bean bean = new Bean();
				bean.tradeCode = tradeCode;
				bean.content = xml;
				bean.status = Status.REQUEST.state;
				mapps.put(tradeCode, bean);
				for (int i = 0; i < loop; i++) {
					bean2 = mapps.get(tradeCode);
					if (bean2 == null) {
						log.info("[" + uuid + "][被其他机器处理掉了]");
						return "";
					} else {
						if (Status.FINISH.state == bean2.status) {
							log.info("[" + uuid + "]["+bean2.ip+"处理结果：]" + bean2.content);
							mapps.remove(tradeCode);
							return bean2.content;
						}
					}
					Thread.sleep(time);
				}
				mapps.remove(tradeCode);
			}
			log.info("[" + uuid + "][请求未找到指定机器]");
			String result = super.malRealProcess(xml);
			return result;
		} catch (Exception e) {
			log.error("出错了", e);
		}
		return "[" + uuid + "][好奇怪的节点]";
	}
	@RequestMapping(value = "/OutSystemBackServlet", method = RequestMethod.POST, produces = "text/plain;charset=UTF-8")
	@ResponseBody
	public String debugCodeOut(HttpServletRequest request) {
		String uuid = UUID.randomUUID().toString().replace("-", "");
		try {
			O2OSendModel o2oSendModel=super.getO2OModel(request);
			String json = jsonMapper.toJson(o2oSendModel);
			log.info("[" + uuid + "]【接受到的xml报文】:\n" + json);
			String tradeCode = o2oSendModel.getMethod();
			Bean bean2 = mapps.get(tradeCode);
			if (bean2 == null) {
				Bean bean = new Bean();
				bean.tradeCode = tradeCode;
				bean.content = json;
				bean.status = Status.REQUEST.state;
				mapps.put(tradeCode, bean);
				for (int i = 0; i < loop; i++) {
					bean2 = mapps.get(tradeCode);
					if (bean2 == null) {
						log.info("[" + uuid + "][被其他机器处理掉了]");
						return "";
					} else {
						if (Status.FINISH.state == bean2.status) {
							log.info("[" + uuid + "]["+bean2.ip+"处理结果：]" + bean2.content);
							mapps.remove(tradeCode);
							return bean2.content;
						}
					}
					Thread.sleep(time);
				}
				mapps.remove(tradeCode);
			}
			log.info("[" + uuid + "][请求未找到指定机器]");
			String result = super.outSystemRealProcess(o2oSendModel);
			return result;
		} catch (Exception e) {
			log.error("出错了", e);
		}
		return "[" + uuid + "][好奇怪的节点]";
	}
	@RequestMapping(value = "/changeTime")
	@ResponseBody
	public String changeTime(Integer time) {
		if (time < 0) {
			return "时间不能小于0";
		} else {
			this.time = time / loop;
			return "修改成功,时间：" + this.time + ",loop:" + this.loop;
		}
	}

	public static void main(String[] args) {
		RestTestController test = new RestTestController();
		System.out.println(test.changeTime(30));
	}

	@RequestMapping(value = "/debugLoop", method = RequestMethod.POST)
	@ResponseBody
	public String debugLoop(String tradeCode) {
		Bean bean = mapps.get(tradeCode);
		if (bean != null && Status.REQUEST.state == bean.status) {
			return bean.content;
		}
		return "No result";
	}

	@RequestMapping(value = "/debugChange", method = RequestMethod.POST)
	@ResponseBody
	public String debugChange(HttpServletRequest request,String tradeCode, String content) {
		Bean bean = mapps.get(tradeCode);
		if (bean != null && Status.REQUEST.state == bean.status) {
			bean.content = content;
			bean.status = Status.FINISH.state;
			bean.ip=NetworkUtil.getIpAddress(request);
			return "OK";
		}
		return "No result";
	}

//	 @PostConstruct
	public void loop() {
		Thread thread = new Thread(new Runnable() {

			@Override
			public void run() {
				loopTest.process();
			}
		});
		thread.start();

	}
//	@PostConstruct
	public void loop2(){
		Thread thread = new Thread(new Runnable() {

			@Override
			public void run() {
				loopTest.process2();
			}
		});
		thread.start();
	}

	class Bean {
		public String tradeCode;
		public String content;
		public Integer status;
		public String ip;
	}

	public enum Status {
		REQUEST(1), PROCESS(2), FINISH(3);
		private final int state;

		private Status(int state) {
			this.state = state;
		}

		public int getState() {
			return state;
		}
	}
}
