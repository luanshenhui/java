package cn.com.cgbchina.restful.provider.service.coupon;

import cn.com.cgbchina.related.model.CouponInfModel;
import cn.com.cgbchina.related.service.CouPonInfService;
import cn.com.cgbchina.rest.common.annotation.TradeCode;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.common.util.MallReturnCode;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.model.coupon.PrivilegeTypeQuery;
import cn.com.cgbchina.rest.provider.model.coupon.PrivilegeTypeQueryReturn;
import cn.com.cgbchina.rest.provider.service.SoapProvideService;
import cn.com.cgbchina.rest.provider.service.coupon.PrivilegeTypeQueryService;
import cn.com.cgbchina.rest.provider.vo.coupon.PrivilegeTypeQueryReturnVO;
import cn.com.cgbchina.rest.provider.vo.coupon.PrivilegeTypeQueryVO;
import com.spirit.category.model.BackCategory;
import com.spirit.category.service.BackCategoryService;
import com.spirit.common.model.Response;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;

/**
 * MAL120 商户、类别查询（优惠券） 从soap对象生成的vo转为 接口调用的bean
 * 
 * @author Lizy
 */
@Service
@TradeCode(value = "MAL120")
@Slf4j
public class PrivilegeTypeQueryProvideServiceImpl implements
		SoapProvideService<PrivilegeTypeQueryVO, PrivilegeTypeQueryReturnVO> {
	@Resource
	PrivilegeTypeQueryService privilegeTypeQueryService;
	@Resource
	CouPonInfService restCouponsService;
	@Resource
	BackCategoryService backCategoriesService;

	@Override
	public PrivilegeTypeQueryReturnVO process(SoapModel<PrivilegeTypeQueryVO> model, PrivilegeTypeQueryVO content) {
		PrivilegeTypeQuery privilegeTypeQuery = BeanUtils.copy(content, PrivilegeTypeQuery.class);
		PrivilegeTypeQueryReturn privilegeTypeQueryReturn = privilegeTypeQueryService.query(privilegeTypeQuery);
		PrivilegeTypeQueryReturnVO privilegeTypeQueryReturnVO = BeanUtils.copy(privilegeTypeQueryReturn,
				PrivilegeTypeQueryReturnVO.class);
		Response<CouponInfModel> couponInfResponse = restCouponsService.findById(privilegeTypeQuery.getProjectNO());
		if (couponInfResponse.isSuccess()) {
			CouponInfModel couponInfModel = couponInfResponse.getResult();
			if (couponInfModel != null) {
				Response<BackCategory> backCategoryResponse = backCategoriesService.findById(Long
						.valueOf(couponInfModel.getBackCategoryId()));
				privilegeTypeQueryReturnVO.setReturnCode(MallReturnCode.RETURN_SUCCESS_CODE);
				privilegeTypeQueryReturnVO.setReturnDes("");
				privilegeTypeQueryReturnVO.setProjectNO(couponInfModel.getCouponId());
				privilegeTypeQueryReturnVO.setProjectNM(couponInfModel.getCouponNm());
				privilegeTypeQueryReturnVO.setTypeIds(couponInfModel.getBackCategoryId());
				if (backCategoryResponse.isSuccess()) {// 根据后台类目获取pid
					privilegeTypeQueryReturnVO.setTypePids(String.valueOf(backCategoryResponse.getResult()
							.getParentId()));
				} else {// 如果获取不到后台类目信息，返回空字符串
					privilegeTypeQueryReturnVO.setTypePids("");
				}
				privilegeTypeQueryReturnVO.setTypeNms(couponInfModel.getBackCategoryNm());
				privilegeTypeQueryReturnVO.setVendorIds(couponInfModel.getVendorId());
				privilegeTypeQueryReturnVO.setVendorNms(couponInfModel.getVendorNms());
			}else {
				privilegeTypeQueryReturnVO.setReturnCode(MallReturnCode.RETURN_SUCCESS_CODE);
				privilegeTypeQueryReturnVO.setErrormsg("找不到该优惠券信息");
			}
		} else {
			privilegeTypeQueryReturnVO.setReturnCode(MallReturnCode.RETURN_SYSERROR_CODE);
			privilegeTypeQueryReturnVO.setErrormsg(MallReturnCode.RETURN_SYSERROR_MSG);
		}
		return privilegeTypeQueryReturnVO;
	}

}
