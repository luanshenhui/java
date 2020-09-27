package cn.com.cgbchina.restful.testEntity;

import org.springframework.stereotype.Service;

import lombok.extern.slf4j.Slf4j;

import com.spirit.util.JsonMapper;

import cn.com.cgbchina.rest.visit.model.coupon.QueryCouponInfo;
import cn.com.cgbchina.rest.visit.model.coupon.CouponProjectPage;
import cn.com.cgbchina.rest.visit.model.coupon.ActivateCouponInfo;
import cn.com.cgbchina.rest.visit.model.coupon.ProvideCouponPage;

@Slf4j
@Service
public class CouponTestEntity {
	JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();
	String idcard = "440628198903154359";

	public String QueryCouponInfoJson() {
		QueryCouponInfo info = new QueryCouponInfo();
		info.setQryType("01");
		info.setRowsPage("10");
		info.setCurrentPage("1");
		info.setContIdType("0");
		info.setContIdCard(idcard);
		String json = jsonMapper.toJson(info);
		return json;
	}

	public String CouponProjectPageJson() {
		CouponProjectPage info = new CouponProjectPage();
		info.setCurrentPage("1");
		info.setRowsPage("20");
		String json = jsonMapper.toJson(info);
		return json;
	}

	public String ActivateCouponInfoJson() {
		ActivateCouponInfo info = new ActivateCouponInfo();
		info.setContIdCard(idcard);

		String json = jsonMapper.toJson(info);
		return json;
	}

	public String ProvideCouponPageJson() {
		ProvideCouponPage info = new ProvideCouponPage();
		info.setContIdCard(idcard);
		info.setGrantType(new Byte("1"));
		String json = jsonMapper.toJson(info);
		return json;
	}

}
