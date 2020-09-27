package chinsoft.service.orden;

import java.security.interfaces.RSAPrivateKey;
import java.text.DateFormat;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.List;
import java.util.Timer;
import java.util.TimerTask;
import rcmtm.business.ConfigSR;
import rcmtm.business.RcmtmManager;
import rcmtm.encrypt.CCBInterfaceUtil;
import rcmtm.encrypt.CCBRsaUtil;
import chinsoft.business.OrdenManager;
import chinsoft.business.XmlManager;
import chinsoft.core.ConfigHelper;
import chinsoft.core.Utility;
import chinsoft.entity.Orden;

public class AutoUpdateOrdenStatus {
	DateFormat dateFormat = DateFormat.getDateInstance(DateFormat.FULL);
	GregorianCalendar cal = new GregorianCalendar();
	
	public AutoUpdateOrdenStatus() {
		Timer timer = new Timer();// 定义定时器
		TimerTask task = new TimerTask() {
			@Override
			public void run() {
				// TODO 工作内容
				String WebService_Erp_Address = Utility.toSafeString(ConfigHelper.getContextParam().get("WebService_Erp_Address"));
				String WebService_NameSpace = Utility.toSafeString(ConfigHelper.getContextParam().get("WebService_NameSpace"));
				cal.setTime(new Date());
				Date date = cal.getTime();
				cal.set(GregorianCalendar.MONTH, Calendar.MONTH - 1);
				Date endDate = cal.getTime();
				List<?> ordens = new OrdenManager().getOrdensByStatusID(10030,date, endDate);
				Object[] objes = ordens.toArray();
				String strSysCodes = Arrays.toString(objes);
				if (ordens!=null) {
					strSysCodes=strSysCodes.replace("[", "");
					strSysCodes=strSysCodes.replace("]", "");
					
					Object[] params = new Object[] { strSysCodes};
					try {
						// TODO 处理生产中订单
						Object obj = XmlManager.invokeService(WebService_Erp_Address, WebService_NameSpace,"getOrdenStatusBySyscode", params,new Class[] { String.class });
						if (obj!=null) {
							String[] orderInfo=Utility.getStrArray(obj.toString());
							for (String order : orderInfo) {
								if (order.length()>17) {
									Orden orden=new OrdenManager().getOrdenByOrdenID(order.substring(0,12));
									OrdenManager.updateOrderStates(orden.getSysCode(),OrdenManager.getNumber(order),order.substring(13,18),orden.getOrdenID());
								}
							}
						}
					} catch (Exception e) {
						// TODO 处理生产中订单时候异常
						e.printStackTrace();
					}
				}

				ordens = new OrdenManager().getOrdensByStatusID(10031, date,endDate);
				if (ordens!=null) {
					objes = ordens.toArray();
					strSysCodes = Arrays.toString(objes);
					strSysCodes=strSysCodes.replace("[", "");
					strSysCodes=strSysCodes.replace("]", "");
					Object[] params = new Object[] { strSysCodes};
					try {
						// TODO 处理入库订单
						Object obj = XmlManager.invokeService(WebService_Erp_Address, WebService_NameSpace,"getOrdenStatusBySyscode", params,new Class[] { String.class });
						if (obj!=null) {
							String[] orderInfo=Utility.getStrArray(obj.toString());
							for (String order : orderInfo) {
								if (order.length()<17) {
									continue;	
								}
								int nStatusID=Utility.toSafeInt(order.substring(13,18));
								if (nStatusID>10031) {
									Orden orden=new OrdenManager().getOrdenByOrdenID(order.substring(0,12));
									OrdenManager.updateOrderStates(orden.getSysCode(),OrdenManager.getNumber(order),order.substring(13,18),orden.getOrdenID());
								}
							}
						}
					} catch (Exception e) {
						// TODO 处理入库订单时候异常
						e.printStackTrace();
					}
				}
				ordens = new OrdenManager().getOrdensByStatusID(10032, date,endDate);
				if (ordens!=null) {
					objes = ordens.toArray();
					strSysCodes = Arrays.toString(objes);
					strSysCodes=strSysCodes.replace("[", "");
					strSysCodes=strSysCodes.replace("]", "");
					Object[] params = new Object[] { strSysCodes};
					try {
						// TODO 处理出库订单
						Object obj = XmlManager.invokeService(WebService_Erp_Address, WebService_NameSpace,"getOrdenStatusBySyscode", params,new Class[] { String.class });
						if (obj!=null) {
							String[] orderInfo=Utility.getStrArray(obj.toString());
							for (String order : orderInfo) {
								if (order.length()<17) {
									continue;	
								}
								int nStatusID=Utility.toSafeInt(order.substring(13,18));
								if (nStatusID>10032) {
									Orden orden=new OrdenManager().getOrdenByOrdenID(order.substring(0,12));
									OrdenManager.updateOrderStates(orden.getSysCode(),OrdenManager.getNumber(order),order.substring(13,18),orden.getOrdenID());
								}
							}
						}
					} catch (Exception e) {
						// TODO 处理出库订单时候异常
						e.printStackTrace();
					}
				}
				ordens = new OrdenManager().getOrdensByStatusID(10033, date,endDate);
				if (ordens!=null) {
					objes = ordens.toArray();
					strSysCodes = Arrays.toString(objes);
					strSysCodes=strSysCodes.replace("[", "");
					strSysCodes=strSysCodes.replace("]", "");
					Object[] params = new Object[] { strSysCodes};
					String strSysCode = "";//发送善融订单
					try {
						// TODO 处理结清订单
						Object obj = XmlManager.invokeService(WebService_Erp_Address, WebService_NameSpace,"getOrdenStatusBySyscode", params,new Class[] { String.class });
						if (obj!=null) {
							String[] orderInfo=Utility.getStrArray(obj.toString());
							for (String order : orderInfo) {
								if (order.length()<17) {
									continue;	
								}
								int nStatusID=Utility.toSafeInt(order.substring(13,18));
								if (nStatusID>10033) {
									Orden orden=new OrdenManager().getOrdenByOrdenID(order.substring(0,12));
									OrdenManager.updateOrderStates(orden.getSysCode(),OrdenManager.getNumber(order),order.substring(13,18),orden.getOrdenID());
									strSysCode += orden.getSysCode()+",";
								}
							}
						}
					} catch (Exception e) {
						// TODO 处理结清订单时候异常
						e.printStackTrace();
					}
					//传送订单信息给善融
					System.out.println("订单结清--所有"+strSysCode);
				}
			}
		};
		timer.schedule(task, 1000 * 600, 1000 * 60 * 60);
	}
}
