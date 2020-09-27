package chinsoft.service.logistic;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import chinsoft.core.Utility;
import chinsoft.service.core.BaseServlet;
import chinsoft.service.logistic.LogistcManager;
import chinsoft.service.logistic.bean.BasicControls;

public class GetInfoByLogisticNO extends BaseServlet {
	private static final long serialVersionUID = -4591305344336387704L;
	@Override
	protected void service(HttpServletRequest request,HttpServletResponse response) {
		String strLogisticNo = Utility.toSafeString(getParameter("id"));//运单号
		String strCompanyName = Utility.toSafeString(getParameter("company"));//物流公司
		String result = "";
		if ("顺丰速运".equals(strCompanyName)) {
			String xmlString= new LogistcManager().getMsgBySF(strLogisticNo);
//			String xmlString="<?xml version='1.0' encoding='UTF-8'?><Response service=\"RouteService\"><Head>OK</Head><Body><RouteResponse mailno=\"966995339067\"><Route remark=\"派件已签收\" accept_time=\"2013-10-17 17:10:49\" accept_address=\"深圳市\" opcode=\"80\"/><Route remark=\"派件已签收\" accept_time=\"2013-10-18 11:03:29\" accept_address=\"成都市\" opcode=\"80\"/></RouteResponse></Body></Response>";
			String strJSON=BasicControls.getJSONStringFromXml(xmlString);
			result=strJSON.replace("@", "");
		}else if("圆通速递".equals(strCompanyName)){
			String xmlString=new LogistcManager().getMsgByYT(strLogisticNo);
			result=BasicControls.getJSONStringFromXml(xmlString);
		}else if("元智快递".equals(strCompanyName)){
			String xmlString=new LogistcManager().getMsgByYZ(strLogisticNo);
//			String xmlString="<BatchQueryResponse><logisticProviderID>ND</logisticProviderID><orders><order><mailNo>880052855860</mailNo><mailType></mailType><orderStatus></orderStatus><steps><step><acceptTime>2013-10-06 19:28:00.0 CST</acceptTime><acceptAddress>山东即墨能达</acceptAddress><name></name><status>true</status><remark>快件离开</remark></step><step><acceptTime>2013-10-06 20:25:00.0 CST</acceptTime><acceptAddress>青岛分拨中心</acceptAddress><name></name><status>true</status><remark>快件到达</remark></step><step><acceptTime>2013-10-07 06:25:00.0 CST</acceptTime><acceptAddress>青岛分拨中心</acceptAddress><name></name><status>true</status><remark>快件离开</remark></step><step><acceptTime>2013-10-07 07:57:00.0 CST</acceptTime><acceptAddress>山东青岛延安三路能达</acceptAddress><name></name><status>true</status><remark>快件到达</remark></step><step><acceptTime>2013-10-08 13:32:00.0 CST</acceptTime><acceptAddress>山东青岛延安三路能达</acceptAddress><name>高长宣</name><status>true</status><remark>正在派件</remark></step><step><acceptTime>2013-10-08 17:09:00.0 CST</acceptTime><acceptAddress>山东青岛延安三路能达</acceptAddress><name>图片扫描</name><status>true</status><remark>已签收</remark></step></steps></order></orders></BatchQueryResponse>";
			result=BasicControls.getJSONStringFromXml(xmlString);
		}else if("邮政速递".equals(strCompanyName)){
			result=new LogistcManager().getMsgByEMS(strLogisticNo);
//			result="{\"traces\":[{\"acceptTime\":\"2013-10-30 09:27:00\",\"acceptAddress\":\"莆田市邮政速递物流分公司秀屿揽投部\",\"remark\":\"揽收\"},{\"acceptTime\":\"2013-10-30 09:27:00\",\"acceptAddress\":\"莆田市邮政速递物流分公司秀屿揽投部\",\"remark\":\"收寄\"},{\"acceptTime\":\"2013-10-30 11:42:22\",\"acceptAddress\":\"莆田市邮政速递物流分公司秀屿揽投部\",\"remark\":\"离开处理中心,发往莆田市\"},{\"acceptTime\":\"2013-10-30 12:18:06\",\"acceptAddress\":\"莆田市\",\"remark\":\"到达处理中心,来自莆田市邮政速递物流分公司秀屿揽投部\"},{\"acceptTime\":\"2013-10-30 16:08:28\",\"acceptAddress\":\"莆田市\",\"remark\":\"离开处理中心,发往长乐机场\"},{\"acceptTime\":\"2013-10-30 23:26:18\",\"acceptAddress\":\"福州速递邮航处理中心\",\"remark\":\"离开处理中心,发往太原市\"},{\"acceptTime\":\"2013-10-31 19:11:50\",\"acceptAddress\":\"太原市\",\"remark\":\"到达处理中心,来自太原市\"},{\"acceptTime\":\"2013-11-01 02:06:53\",\"acceptAddress\":\"太原市\",\"remark\":\"离开处理中心,发往祁县\"},{\"acceptTime\":\"2013-11-01 18:13:00\",\"acceptAddress\":\"祁县\",\"remark\":\"未妥投\"},{\"acceptTime\":\"2013-11-02 18:46:00\",\"acceptAddress\":\"祁县\",\"remark\":\"妥投\"}]}";
		}
		
		output(result);
	}
}
