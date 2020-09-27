package cn.com.cgbchina.web.interceptor;

import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.visit.model.user.LoginCardInfo;
import cn.com.cgbchina.rest.visit.model.user.LoginResult;
import com.google.common.base.Strings;
import com.spirit.common.utils.CommonConstants;
import com.spirit.user.User;
import com.spirit.user.UserAccount;
import com.spirit.user.UserUtil;
import com.spirit.util.BeanMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class LoginInterceptor extends HandlerInterceptorAdapter {
    private final static Logger log = LoggerFactory.getLogger(LoginInterceptor.class);

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
            throws Exception {
        HttpSession session = request.getSession(false);
        if (session != null) {
            Object userId = session.getAttribute(CommonConstants.SESSION_USER_ID);
            if (userId != null) {
                Object obj = request.getSession().getAttribute(userId.toString());
                if (obj != null) {
                    Map<String, Object> loginResult = (Map<String, Object>) obj;
                    // 存User信息
                    User user = new User();
                    user.setId(loginResult.get("customerId").toString());
                    user.setName(loginResult.get("customerName").toString());
                    user.setMobile(Strings.nullToEmpty(String.valueOf(loginResult.get("mobileNo"))));
                    user.setCertNo(Strings.nullToEmpty(String.valueOf(loginResult.get("certNo"))));
                    user.setCertType(Strings.nullToEmpty(String.valueOf(loginResult.get("certType"))));
                    user.setAddress(Strings.nullToEmpty(String.valueOf(loginResult.get("address"))));
                    user.setEmail(Strings.nullToEmpty(String.valueOf(loginResult.get("email"))));
                    user.setPhoneNo(Strings.nullToEmpty(String.valueOf(loginResult.get("phoneNo"))));
                    user.setZipCode(Strings.nullToEmpty(String.valueOf(loginResult.get("zipCode"))));
                    loginResult.get("loginCardInfos");
                    List<HashMap> mapList = (List<HashMap>) loginResult.get("loginCardInfos");
                    List<UserAccount> accountList = new ArrayList<>();
                    for (HashMap map : mapList) {
                        UserAccount userAccount = new UserAccount();
                        userAccount.setBranchNo(Strings.nullToEmpty(String.valueOf(map.get("branchNo"))));
                        userAccount.setCardNo(Strings.nullToEmpty(String.valueOf(map.get("cardNo"))));
                        userAccount.setCardType(
                                UserAccount.CardType.fromNumber(Integer.valueOf(String.valueOf(map.get("cardType")))));
                        accountList.add(userAccount);
                    }
                    user.setAccountList(accountList);
                    user.setCustId(user.getId());
                    UserUtil.putUser(user);
                }
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
