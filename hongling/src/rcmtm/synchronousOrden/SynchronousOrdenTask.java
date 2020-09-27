package rcmtm.synchronousOrden;

import chinsoft.business.OrdenManager;
import chinsoft.core.LogPrinter;

/**
 * 发送订单数据的任务
 * 
 * @author dell
 * 
 */
public class SynchronousOrdenTask implements Runnable {
	private String ordenJson;
	private String updateaddress;
	private String returnValue;
	private String ids;

	public SynchronousOrdenTask() {
	};

	public SynchronousOrdenTask(String ordenJson, String updateaddress,
			String returnValue,String ids) {
		this.ordenJson = ordenJson;
		this.updateaddress = updateaddress;
		this.returnValue = returnValue;
		this.ids= ids;
	};

	@Override
	public void run() {
//		System.out.println("线程" + Thread.currentThread().getName()
//				+ "发送订单数据 \n   updateaddress是:" + updateaddress + "\n   数据是:"
//				+ ordenJson + "\n   发送成功应返回:" + returnValue);
//		String url = "http://172.16.2.121:8080/redcollarec-website/ws_updateOrderState_POST.do";
		try {
			String successReturn = new SendOrden().readContentFromPost(updateaddress,
					ordenJson);
			// String successReturn = "N";
//			System.out.println("返回的值是:" + successReturn);

			if (null != successReturn && !"".equals(successReturn)) {
				if (returnValue.equals(successReturn)) {
					new OrdenManager().updateSendSuccessOrdens(ids);
				}
				// 发送失败的订单返回订单号
				else if (successReturn.length() > 1) {
					new OrdenManager().updateSendSuccessOrdens(ids);
					new OrdenManager().updateSendfailedOrdens(successReturn);
				}
			}
		} catch (Exception e) {
//			System.out.println("发送订单数据出异常了");
			LogPrinter.info("发送订单数据出异常了");
//			e.printStackTrace();
		}

	}

	public String getUpdateaddress() {
		return updateaddress;
	}

	public void setUpdateaddress(String updateaddress) {
		this.updateaddress = updateaddress;
	}

	public String getOrdenJson() {
		return ordenJson;
	}

	public void setOrdenJson(String ordenJson) {
		this.ordenJson = ordenJson;
	}

	public String getReturnValue() {
		return returnValue;
	}

	public void setReturnValue(String returnValue) {
		this.returnValue = returnValue;
	}

}
