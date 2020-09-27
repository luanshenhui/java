package cn.com.cgbchina.vendor.interceptor;

import cn.com.cgbchina.user.dto.VendorInfoDto;
import cn.com.cgbchina.user.model.UserInfoModel;
import cn.com.cgbchina.user.model.VendorModel;
import cn.com.cgbchina.user.service.UserInfoService;
import cn.com.cgbchina.user.service.VendorUserService;
import com.spirit.common.model.Response;
import com.spirit.common.utils.CommonConstants;
import com.spirit.user.User;
import com.spirit.user.UserUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@Slf4j
public class LoginInterceptor extends HandlerInterceptorAdapter {

	@Resource
	private VendorUserService vendorUserService;

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		HttpSession session = request.getSession(false);
		if (session != null) {
			Object vendorUserId = session.getAttribute(CommonConstants.SESSION_USER_ID);
			if (vendorUserId != null) {
				Response<VendorModel> result = vendorUserService
						.findVendorById(Long.parseLong(vendorUserId.toString()));
				if (!result.isSuccess()) {
					log.error("failed to find user where id={},error code:{}", vendorUserId, result.getError());
					return false;
				}
				VendorModel vendorModel = result.getResult();
				User baseUser = new User(vendorModel.getId(), vendorModel.getName());
				baseUser.setId(vendorModel.getId());
				baseUser.setVendorId(vendorModel.getVendorId());
				UserUtil.putUser(baseUser);
			}
		}
		return true;
	}

	@Override
	public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex)
			throws Exception {
		UserUtil.removeCurrentUser();
	}
}
