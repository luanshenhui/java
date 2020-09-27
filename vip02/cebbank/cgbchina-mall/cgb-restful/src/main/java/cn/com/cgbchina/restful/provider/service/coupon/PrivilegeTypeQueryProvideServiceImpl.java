package cn.com.cgbchina.restful.provider.service.coupon;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import cn.com.cgbchina.rest.common.annotation.TradeCode;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.service.SoapProvideService;
import cn.com.cgbchina.rest.provider.model.coupon.PrivilegeTypeQuery;
import cn.com.cgbchina.rest.provider.model.coupon.PrivilegeTypeQueryReturn;
import cn.com.cgbchina.rest.provider.service.coupon.PrivilegeTypeQueryService;
import cn.com.cgbchina.rest.provider.vo.coupon.PrivilegeTypeQueryReturnVO;
import cn.com.cgbchina.rest.provider.vo.coupon.PrivilegeTypeQueryVO;
import lombok.extern.slf4j.Slf4j;

/**
 * MAL120 商户、类别查询（优惠券） 从soap对象生成的vo转为 接口调用的bean
 * 
 * @author Lizy
 * 
 */
@Service
@TradeCode(value = "MAL120")
@Slf4j
public class PrivilegeTypeQueryProvideServiceImpl implements  SoapProvideService <PrivilegeTypeQueryVO,PrivilegeTypeQueryReturnVO>{
	@Resource
	PrivilegeTypeQueryService privilegeTypeQueryService;

	@Override
	public PrivilegeTypeQueryReturnVO process(SoapModel<PrivilegeTypeQueryVO> model, PrivilegeTypeQueryVO content) {
		PrivilegeTypeQuery privilegeTypeQuery = BeanUtils.copy(content, PrivilegeTypeQuery.class);
		PrivilegeTypeQueryReturn privilegeTypeQueryReturn = privilegeTypeQueryService.query(privilegeTypeQuery);
		PrivilegeTypeQueryReturnVO privilegeTypeQueryReturnVO = BeanUtils.copy(privilegeTypeQueryReturn,
				PrivilegeTypeQueryReturnVO.class);
		return privilegeTypeQueryReturnVO;
	}

}
