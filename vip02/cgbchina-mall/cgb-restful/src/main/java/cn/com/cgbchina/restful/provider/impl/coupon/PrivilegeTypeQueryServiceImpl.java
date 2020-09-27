package cn.com.cgbchina.restful.provider.impl.coupon;

import cn.com.cgbchina.related.model.CouponInfModel;
import cn.com.cgbchina.related.service.CouPonInfService;
import cn.com.cgbchina.rest.provider.model.coupon.PrivilegeTypeQuery;
import cn.com.cgbchina.rest.provider.model.coupon.PrivilegeTypeQueryReturn;
import cn.com.cgbchina.rest.provider.service.coupon.PrivilegeTypeQueryService;
import com.spirit.category.model.BackCategory;
import com.spirit.category.service.BackCategoryService;
import com.spirit.common.model.Response;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;

/**
 * mal120 日期 : 2016-7-19<br>
 * 作者 : xiewenliang<br>
 * 项目 : cgb-rest<br>
 * 功能 : <br>
 */
@Service
public class PrivilegeTypeQueryServiceImpl implements PrivilegeTypeQueryService {
	@Resource
	CouPonInfService couPonInfService;
	@Resource
	BackCategoryService backCategoriesService;

	@Override
	public PrivilegeTypeQueryReturn query(PrivilegeTypeQuery privilegeTypeQuery) {
		PrivilegeTypeQueryReturn privilegeTypeQueryReturn = new PrivilegeTypeQueryReturn();
		Response<CouponInfModel> response = couPonInfService.findById(privilegeTypeQuery.getProjectNO());
		if (response.isSuccess()) {
			CouponInfModel couponInfModel = response.getResult();
			if (couponInfModel != null) {
				privilegeTypeQueryReturn.setReturnCode("000000");
				privilegeTypeQueryReturn.setReturnDes("");
				privilegeTypeQueryReturn.setProjectNM(couponInfModel.getCouponId());
				privilegeTypeQueryReturn.setProjectNO(couponInfModel.getCouponNm());
				privilegeTypeQueryReturn.setTypeIds(couponInfModel.getBackCategoryId());
				privilegeTypeQueryReturn.setTypeNms(couponInfModel.getBackCategoryNm());
				Response<BackCategory> backCategoryResponse = backCategoriesService.findById(Long
						.valueOf(couponInfModel.getBackCategoryId()));
				if (backCategoryResponse.isSuccess()) {
					BackCategory backCategory = backCategoryResponse.getResult();
					privilegeTypeQueryReturn.setTypePids(String.valueOf(backCategory.getParentId()));
				}
				privilegeTypeQueryReturn.setVendorIds(couponInfModel.getVendorId());
			}
		}
		return privilegeTypeQueryReturn;
	}

}
