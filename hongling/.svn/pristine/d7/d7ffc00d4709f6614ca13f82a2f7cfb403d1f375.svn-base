package rcmtm.synchronousOrden;

import java.lang.reflect.Field;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

import net.sf.json.JSONArray;
import net.sf.json.JsonConfig;

import chinsoft.business.CompanysManager;
import chinsoft.business.OrdenManager;
import chinsoft.core.LogPrinter;
import chinsoft.entity.Companys;
import chinsoft.entity.Orden;

/**
 * 定时搜索 状态 不同步的订单 分线程发送
 * 
 * @author Administrator
 * 
 */
public class SearchOrdenTask implements Runnable {
	private OrdenManager ordenManager = new OrdenManager();
	private final static ScheduledExecutorService service = Executors
			.newScheduledThreadPool(10);

	@Override
	public void run() {
//		System.out.println(new SimpleDateFormat("yyyy-mm-dd_HH:mm:ss")
//				.format(new Date()) + "  扫瞄状态不同步的订单***********");
		LogPrinter.info(new SimpleDateFormat("yyyy-mm-dd_HH:mm:ss")
		.format(new Date()) + "  扫瞄需要同步的订单");
		
		List<Orden> eachCompanysOrdens;
		List<Companys> companys = new CompanysManager().findAll();
		for (Companys temp : companys) {
			eachCompanysOrdens = ordenManager
					.findSynchronousOrdensByCompanysCode(temp.getCompanycode());
			// System.out.println(" \n********  公司名为" + temp.getCompanyname()
			// + "的公司有" + eachCompanysOrdens.size() + "条订单");
			if (!eachCompanysOrdens.isEmpty()) {
				if ("RC000003".equals(temp.getCompanycode())) {
					// 善融发货、收货
					service.schedule(new SynchronousOrdenStatusTask(
							eachCompanysOrdens), 0, TimeUnit.MILLISECONDS);

				} else {
					//不是善融 主要是电商
					this.sendOrdenByCompanyArdess(temp.getCompanycode(),eachCompanysOrdens.size(),
							temp.getUpdateaddress(), temp.getUpdateReturn());
				}
			}
		}
	}

	/**
	 * 搜索到状态不同步的订单信息 分线程 发送数据调用
	 * 
	 * @param ordens
	 * @param updateaddress
	 * @param returnValue
	 */
	private void sendOrdenByCompanyArdess(List<Orden> ordens,
			String updateaddress, String returnValue) {
		// 执行时间 间隔 此处定义为每半小时执行一次
		// long period = 1000 * 3;
		// 从现在开始delay毫秒(不延迟执行)之后，每隔period 毫秒执行一次job
		long delay = 0;
		String sendData = "";
		StringBuffer dataBuffer = new StringBuffer();
		// 满一千条发送一次
		for (int i = 0; i < ordens.size(); i++) {
			// 拼成 {"id":"xx","status":"xx"}
			dataBuffer.append("{" + "\"" + "serverorderid" + "\"" + ":" + "\""
					+ ordens.get(i).getOrdenID() + "\"" + "," + "\"" + "status"
					+ "\"" + ":" + "\"" + ordens.get(i).getStatusID() + "\""
					+ "},");
			// 满一千条发送
			if (i != 0 && (i + 1) % 1000 == 0) {
				sendData = dataBuffer.toString();
				if (sendData.endsWith(",")) {
					sendData = sendData.substring(0, sendData.lastIndexOf(","));
				}
				sendData = "[" + sendData + "]";
				service.schedule(new SynchronousOrdenTask(sendData,
						updateaddress, returnValue,""), delay,
						TimeUnit.MILLISECONDS);
				// 清空buffer
				dataBuffer.delete(0, dataBuffer.length());
			}
		}
		// 最后不足一千的的发送
		sendData = dataBuffer.toString();
		if (!"".equals(sendData) && sendData.length() != 0) {
			if (sendData.endsWith(",")) {
				sendData = sendData.substring(0, sendData.lastIndexOf(","));
			}
			sendData = "[" + sendData + "]";
			service.schedule(new SynchronousOrdenTask(sendData, updateaddress,
					returnValue,""), delay, TimeUnit.MILLISECONDS);
		}
	}
	
	/**
	 * 根据要发送的订单总条数 确定分批 处理并发送
	 * @param oudenCount 订单条数
	 * @param updateaddress	发送地址
	 * @param returnValue 成功应返回的值
	 */
	public void sendOrdenByCompanyArdess(String companyCode, int ordenCount,
			String updateaddress, String returnValue) {
		if(ordenCount == 0){
			return;
		}
		// 定义每次发送处理的最大条数
		int maxCount = 1000;
		// 计算总共份数
		int pages;
		List<Orden> ordenList = new ArrayList<Orden>();
		String jsonData = "";
		String ids = "";
		// 大于一次
		if (ordenCount > maxCount) {
			if (ordenCount % maxCount == 0) {
				pages = ordenCount / maxCount;
			} else {
				pages = ordenCount / maxCount + 1;
			}

			for (int i = 0; i < pages; i++) {
				ordenList = ordenManager
						.findSynchronousOrdensByCompanysCodeAndPage(
								companyCode, i, maxCount);
				ids = getIDsBycodesAndPage(companyCode, i, maxCount);
				ids = formatIds(ids);
				sendOrdenByCompanyArdess(ordenList,ids,updateaddress,returnValue);
			}
		} else {
			ordenList = ordenManager
					.findSynchronousOrdensByCompanysCode(companyCode);
			ids = getIDsBycodesAndPage(companyCode, 0, maxCount);
			ids = formatIds(ids);
			sendOrdenByCompanyArdess(ordenList,ids,updateaddress,returnValue);
		}
	}

	/**
	 * 把[id,id,id]转换成'','id','id'....
	 * @param ids
	 */
	private String formatIds(String ids) {
		//
		ids = ids.replace(" ", "").replace("[", "'").replace("]", "'")
				.replace(",", "','");
		return ids;
	}
	/**
	 * 查找一份订单的 id拼接的字符串
	 * @param companyCode 公司code
	 * @param nPageIndex 页序
	 * @param nPageSize 每页条数
	 * @return
	 */
	private String getIDsBycodesAndPage(String companyCode,int nPageIndex,int nPageSize){
		String ids =  ordenManager.findSynchronousOrdenIDSByCompanysCodeAndPage(companyCode,nPageIndex,nPageSize);
		return ids;
	}

	private void sendOrdenByCompanyArdess(List<Orden> ordens, String ids,
			String updateaddress, String returnValue) {
		long delay = 0;
		String sendData = formatJSONData(ordens);
		// System.out.println("sendData" + sendData);
		// StringBuffer dataBuffer = new StringBuffer();
		// for (int i = 0; i < ordens.size(); i++) {
		// dataBuffer.append("{" + "\"" + "serverorderid" + "\"" + ":" + "\""
		// + ordens.get(i).getOrdenID() + "\"" + "," + "\"" + "status"
		// + "\"" + ":" + "\"" + ordens.get(i).getStatusID() + "\""
		// + "},");
		// }
		// sendData = dataBuffer.toString();
		// if (sendData.endsWith(",")) {
		// sendData = sendData.substring(0, sendData.lastIndexOf(","));
		// }
		// sendData = "[" + sendData + "]";
		service.schedule(new SynchronousOrdenTask(sendData, updateaddress,
				returnValue, ids), delay, TimeUnit.MILLISECONDS);
	}

	/**
	 * 把ordenList变成JSON格式的
	 * 
	 * @param ordens
	 * @return
	 */
	private String formatJSONData(List<Orden> ordens) {
		Class ordenClass = new Orden().getClass();
		Field[] fieldlist = ordenClass.getDeclaredFields();
		StringBuffer buffer = new StringBuffer();
		for (int i = 0; i < fieldlist.length; i++) {
			Field fld = fieldlist[i];
			// System.out.print("name = " + fld.getName()+",");
			// System.out.print("decl class = " + fld.getDeclaringClass() +
			// ",");
			// System.out.print("type = " + fld.getType() + ".");
			// System.out.println();
			if (!"ordenID".equals(fld.getName())
					&& !"statusID".equals(fld.getName())) {
				buffer.append(fld.getName() + ",");
			}
		}
		String properties = buffer.toString();
		if (properties.endsWith(",")) {
			properties = properties.substring(0, properties.lastIndexOf(","));
		}

		JsonConfig config = new JsonConfig();
		// 过滤除id和stateID之外所有属性
		config.setExcludes(properties.split(","));
		JSONArray jsonArray = JSONArray.fromObject(ordens, config);
		String targetJsonStr = jsonArray.toString()
				.replace("ordenID", "serverorderid")
				.replace("statusID", "status");

		return targetJsonStr;
	}
}
