package cn.com.cgbchina.vendor.interceptor;

import static com.google.common.base.Objects.equal;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.user.service.VendorMenuService;
import cn.com.cgbchina.vendor.container.AuthContainer;
import com.spirit.exception.ResponseException;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import com.spirit.common.model.Response;
import com.spirit.common.utils.CommonConstants;
import com.spirit.user.User;
import com.spirit.user.UserUtil;

import cn.com.cgbchina.user.model.VendorModel;
import cn.com.cgbchina.user.service.VendorUserService;
import lombok.extern.slf4j.Slf4j;

import java.util.List;

@Slf4j
public class LoginInterceptor extends HandlerInterceptorAdapter {

	@Resource
	private VendorUserService vendorUserService;
	@Resource
	private VendorMenuService vendorMenuService;
	@Value("#{app.context}")
	private String context;
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
				if(equal("0101",vendorModel.getStatus())){
					request.getSession().invalidate();
					response.setContentType("text/html;charset=UTF-8");
					response.sendRedirect( this.context + "/login");
					return false;
//					throw new UnAuthorize401Exception("用户未启用");
				}

				User baseUser = new User(vendorModel.getId(), vendorModel.getName());
				baseUser.setId(vendorModel.getId());
				baseUser.setVendorId(vendorModel.getVendorId());
				baseUser.setUserType(vendorModel.getShopType());
				UserUtil.putUser(baseUser);
				Response<List<Long>> userAuthMenu;
				if (vendorModel.getIsSub().equals("0")) {
					String userType = baseUser.getUserType();
					String shopTypenot = null;
					if (Contants.ORDERTYPEID_YG.equals(userType)){
						shopTypenot = Contants.ORDERTYPEID_JF;
					}
					if (Contants.ORDERTYPEID_JF.equals(userType)){
						shopTypenot = Contants.ORDERTYPEID_YG;
					}
					userAuthMenu = vendorMenuService.getLongResourcesByNotOrderType(shopTypenot);
				}else{
					// 当前用户拥有的访问权限
					userAuthMenu = vendorMenuService.findMenuByUserId(baseUser.getId());
				}
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
	}
}
