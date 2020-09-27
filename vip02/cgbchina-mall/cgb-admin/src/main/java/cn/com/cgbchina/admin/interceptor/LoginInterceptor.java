package cn.com.cgbchina.admin.interceptor;

import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import cn.com.cgbchina.common.contants.Contants;
import com.spirit.exception.ResponseException;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import com.spirit.common.model.Response;
import com.spirit.common.utils.CommonConstants;
import com.spirit.user.User;
import com.spirit.user.UserUtil;

import cn.com.cgbchina.admin.container.AuthContainer;
import cn.com.cgbchina.user.dto.UserInfoDto;
import cn.com.cgbchina.user.service.AdminMenuMagService;
import cn.com.cgbchina.user.service.UserInfoService;
import lombok.extern.slf4j.Slf4j;

@Slf4j
public class LoginInterceptor extends HandlerInterceptorAdapter {

	@Resource
	private UserInfoService userInfoService;
	@Resource
	private AdminMenuMagService adminMenuMagService;

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		HttpSession session = request.getSession(false);
		if (session != null) {
			Object userId = session.getAttribute(CommonConstants.SESSION_USER_ID);
			if (userId != null) {
				Response<UserInfoDto> result = userInfoService.findUserById(userId.toString());
				if (!result.isSuccess()) {
					log.error("failed to find user where id={},error code:{}", userId, result.getError());
					return false;
				}
				UserInfoDto userInfoDto = result.getResult();
				User user = new User(userInfoDto.getId(), userInfoDto.getName());
				user.setOrgCode(userInfoDto.getOrgCode());
				user.setName(userInfoDto.getName());
				user.setOrgName(userInfoDto.getOrgName());
				UserUtil.putUser(user);

				// 当前用户拥有的访问权限
				Response<List<Long>> userAuthMenu = adminMenuMagService.findMenuByUserId(userId.toString());
				if(!userAuthMenu.isSuccess()){
					log.error("Response.error,error code: {}", userAuthMenu.getError());
					throw new ResponseException(Contants.ERROR_CODE_500, "Response.error,error code");
				}
				AuthContainer.put(userAuthMenu.getResult());
			}
		}
		return true;
	}

	@Override
	public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex)
			throws Exception {
		UserUtil.removeCurrentUser();
		AuthContainer.remove();
	}
}
