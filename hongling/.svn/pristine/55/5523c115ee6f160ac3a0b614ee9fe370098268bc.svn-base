package chinsoft.service.delivery;

import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONObject;

import rcmtm.endpoint.IServiceToLogisticsProxy;
import rcmtm.endpoint.TLogistics;
import chinsoft.business.CDict;
import chinsoft.business.CurrentInfo;
import chinsoft.business.DeliveryManager;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.entity.Delivery;
import chinsoft.service.core.BaseServlet;

public class SubmitDelivery extends BaseServlet {

	private static final long serialVersionUID = -3752715900655015725L;

	@Override
	public void service(HttpServletRequest request, HttpServletResponse response) {
		try {
			//super.service();
			// 得到所选订单
			String strOrdens = getParameter("ordens");
			
			// 判断所选订单是否为同一类型
			boolean flag = new DeliveryManager().checkOrdens(strOrdens);
			
			if (flag) {
				// 得到发货地址
//				String strAddress = getParameter("address");
				
				// 得到发货国家
				String strCountryName = getParameter("countryName");
				String strCountryCode = getParameter("countryCode");
				
				// 得到州
				String strDivision = Utility.toSafeString(getParameter("division"));
				String strDivisionCode = Utility.toSafeString(getParameter("divisionCode"));
				
				// 得到城市 
				String strCity = getParameter("city");
				String cityCode = getParameter("cityCode");
				
				// 得到区
				String district = getParameter("district");
				String districtCode = getParameter("districtCode");
				
				// 得到地址
				String strAddressLine1 = getParameter("addressLine1");
				String strAddressLine2 = Utility.toSafeString(getParameter("addressLine2"));
				
				// 得到邮政编码
				String strPostalCode = getParameter("postalCode");
				
				// 得到发货日期
				Date deliveryDate = Utility.toSafeDateTime(getParameter("date"));
				
				// 得到快递公司
				String expressComId = getParameter("expressComId");
				
				// 设置出货信息
				Delivery delivery = new Delivery();
//				delivery.setDeliveryAddress(strAddress);
				delivery.setCountryCode(strCountryCode);
				delivery.setCountryName(strCountryName);
				delivery.setDivision(strDivision);
				delivery.setDivisionCode(strDivisionCode);
				delivery.setCity(strCity);
				delivery.setCityCode(cityCode);
				delivery.setDistrict(district);
				delivery.setDistrictCode(districtCode);
				delivery.setAddressLine1(strAddressLine1);
				delivery.setAddressLine2(strAddressLine2);
				delivery.setPostalCode(strPostalCode);
				delivery.setExpressComId(expressComId);
				delivery.setDeliveryDate(deliveryDate);
				delivery.setApplyDate(new Date());
				delivery.setStatusID(CDict.DeliveryStateApply.getID());
				
				output(new DeliveryManager().submitDelivery(delivery, strOrdens));
				
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
				TLogistics tl = new TLogistics();
//				tl.setCarryType()
				tl.setDeliverDate(sdf.format(delivery.getDeliveryDate()));
				tl.setLogisticCompany(getParameter("expressComName"));
				tl.setOrderNo(strOrdens);
				tl.setReceiverAddress(delivery.getAddressLine1());
				tl.setReceiverCity(delivery.getCity());
				tl.setReceiverCountry(delivery.getCountryName());
				tl.setReceiverDistrict(delivery.getDistrict());
				tl.setReceiverName(CurrentInfo.getCurrentMember().getName());
				tl.setReceiverPhoneno(delivery.getPhoneNumber());
				tl.setRemark("");
				tl.setReceiverProvince(delivery.getDivision());
				tl.setTransportFee(0.0d);
				String rs = new IServiceToLogisticsProxy().doSaveLogistic(JSONObject.fromObject(tl).toString());
				System.out.println(rs);
			} else {
				output("faliure");
			}
		} catch (Exception err) {
			LogPrinter.error("SubmitDelivery_err"+err.getMessage());
		}
	}
}