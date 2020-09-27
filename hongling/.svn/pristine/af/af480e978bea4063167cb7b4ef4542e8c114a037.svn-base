package rcmtm.synchronousOrden;

import java.security.interfaces.RSAPrivateKey;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import rcmtm.business.ConfigSR;
import rcmtm.business.RcmtmManager;
import rcmtm.encrypt.CCBInterfaceUtil;
import rcmtm.encrypt.CCBRsaUtil;
import rcmtm.entity.OrdenBatch;
import chinsoft.business.MemberManager;
import chinsoft.business.OrdenManager;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.entity.Member;
import chinsoft.entity.Orden;

/**
 * 管理发送订单数据的任务
 * 
 * @author dell
 * 
 */
public class SynchronousOrdenStatusTask implements Runnable {
	private List<Orden> ordenList;

	public SynchronousOrdenStatusTask() {
	};

	public SynchronousOrdenStatusTask(List<Orden> ordenList) {
		this.setOrdenList(ordenList);
	};

	@Override
	public void run() {

		try {
			LogPrinter.info("执行善融更新");
			changeStatus(ordenList);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	public List<Orden> getOrdenList() {
		return ordenList;
	}

	public void setOrdenList(List<Orden> ordenList) {
		this.ordenList = ordenList;
	}

	public void changeSendOrderStatus(List<Orden> ordens) {
		// 订单发货（状态为出库）
		String strBatchNos = batchNoStatus(ordens);
		if (!"".equals(strBatchNos)) {
			String[] batchNos = Utility.getStrArray(strBatchNos);
			for (String batchNo : batchNos) {
				String code = ordenInfo(batchNo);
				try {
					// 私钥加密
					RSAPrivateKey privk = CCBRsaUtil
							.getRSAPrivateKeyPair(ConfigSR.PRIVATE_KEY);
					String json = "{\"cpcode\":\"" + code
							+ "\",\"orderid\":\"" + batchNo
							+ "\",\"remark\":\"\"}";
					System.out.println("订单发货--回传善融" + json);
					String enStr = CCBRsaUtil.encryptByPriKey(privk, json);
					StringBuffer para = new StringBuffer();
					para.append("cpcode=").append(code)
							.append("&uniondata=").append(enStr);

					new CCBInterfaceUtil().sendData(ConfigSR.URL_SENDORDER,
							para.toString());
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
		}

	}

	public void changeReceiveOrderStatus(List<Orden> ordens) {
		// 订单收到（状态为收到）
		String strBatchNos = batchNoStatus(ordens);
		if (!"".equals(strBatchNos)) {
			String[] batchNos = Utility.getStrArray(strBatchNos);
			for (String batchNo : batchNos) {
				String code = ordenInfo(batchNo);
				try {
					// 私钥加密
					RSAPrivateKey privk = CCBRsaUtil
							.getRSAPrivateKeyPair(ConfigSR.PRIVATE_KEY);
					String json = "{\"cpcode\":\"" + code
							+ "\",\"orderid\":\"" + batchNo
							+ "\",\"remark\":\"\"}";
					System.out.println("订单收到--回传善融" + json);
					String enStr = CCBRsaUtil.encryptByPriKey(privk, json);
					StringBuffer para = new StringBuffer();
					para.append("cpcode=").append(code)
							.append("&uniondata=").append(enStr);

					new CCBInterfaceUtil().sendData(ConfigSR.URL_RECEIVEORDER,
							para.toString());
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
		}
	}

	public String batchNoStatus(List<Orden> ordens) {

		String sendBatchNos = "";// 批次号
		String strBatchNos = new RcmtmManager().getBatchNo(ordens);// 所有的批次号
		String[] batchNos = Utility.getStrArray(strBatchNos);
		for (String batchNo : batchNos) {
			List<OrdenBatch> ordenBatchs = new RcmtmManager()
					.getBatchNos(batchNo);// 每个批次号包含的订单号
			int num = 0;
			for (OrdenBatch ordenBatch : ordenBatchs) {
				for (Orden o : ordens) {
					if (ordenBatch.getOrdenIDs().equals(o.getOrdenID())) {
						num++;
					}
				}
			}
			// 一个批次号中的所有订单状态都为发货或收到
			if (num == ordenBatchs.size()) {
				sendBatchNos += batchNo + ",";
			}
		}
		if (!"".equals(sendBatchNos)) {
			sendBatchNos = sendBatchNos.substring(0, sendBatchNos.length() - 1);
		}
		return sendBatchNos;

	}

	public void changeStatus(List<Orden> ordenList) {
		// 善融发货、收货
		List<Orden> ordensSend = new ArrayList<Orden>();
		List<Orden> ordensReceive = new ArrayList<Orden>();
		for (Orden orden : ordenList) {
			if ("10033".equals(Utility.toSafeString(orden.getStatusID()))) {// 出库
				ordensSend.add(orden);
			} else if ("10034"
					.equals(Utility.toSafeString(orden.getStatusID()))) {// 收到
				ordensReceive.add(orden);
			}
		}
		if (ordensSend.size() > 0) {
			changeSendOrderStatus(ordensSend);
		}
		if (ordensReceive.size() > 0) {
			changeReceiveOrderStatus(ordensReceive);
		}
	}

	public String ordenInfo(String strBatchNo) {
		String code ="";
		try {
			List<OrdenBatch> ordenBatchs = new RcmtmManager()
					.getBatchNos(strBatchNo);
			Orden o = new OrdenManager().getordenByOrderId(ordenBatchs.get(0).getOrdenIDs());
			Member m = new MemberManager().getMemberByID(o.getPubMemberID());
			code = Utility.toSafeString(m.getCompanyID());
			String json = new RcmtmManager().ordenDetailInfo(strBatchNo,ordenBatchs,code);
			System.out.println(new Date() + "订单明细信息红领传递(加密前)" + json);

			// 私钥加密
			RSAPrivateKey privk = new CCBRsaUtil().getRSAPrivateKeyPair(ConfigSR.PRIVATE_KEY);
			String enStr = new CCBRsaUtil().encryptByPriKey(privk, json);
			StringBuffer para = new StringBuffer();
			para.append("cpcode=").append(m.getCompanyID()).append("&uniondata=").append(enStr);
			System.out.println("订单明细信息红领传递(加密后)" + para.toString());

			new CCBInterfaceUtil().sendData(ConfigSR.URL_TRADESET,
					para.toString());
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return code;

	}
}
