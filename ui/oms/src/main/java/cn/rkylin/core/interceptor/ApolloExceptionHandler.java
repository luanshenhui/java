package cn.rkylin.core.interceptor;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.ibatis.ognl.OgnlException;
import org.apache.log4j.Logger;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.method.HandlerMethod;
import org.springframework.web.servlet.HandlerExceptionResolver;
import org.springframework.web.servlet.ModelAndView;

import cn.rkylin.core.exception.BusinessException;
import cn.rkylin.core.utils.LogUtils;

import com.alibaba.fastjson.JSON;

/**
 * 
 * ClassName: MyExceptionHandler
 * 
 * @Description: 统一异常拦截器
 * @author shixiaofeng@tootoo.cn
 * @date 2015年12月24日 下午1:54:13
 */
public class ApolloExceptionHandler implements HandlerExceptionResolver {

	private static Logger logger = Logger.getLogger(LogUtils.LOG_BOSS);

	private String loginUrl;

	public String getLoginUrl() {
		return loginUrl;
	}

	public void setLoginUrl(String loginUrl) {
		this.loginUrl = loginUrl;
	}


	public ModelAndView resolveException(HttpServletRequest request,
			HttpServletResponse response, Object handler, Exception throwable) {
		Map<String, Object> model = new HashMap<String, Object>();
		model.put("ex", throwable);
		String uuid = "" ;
		if(null != request.getAttribute("uuid") && !"".equals(request.getAttribute("uuid"))){
			request.getAttribute("uuid").toString();
		}

		Map<String, String> errorMap = createFriendlyErrMsg(throwable);
		LogUtils.error(logger, uuid, errorMap.get("errorLog"), throwable);

		HandlerMethod mathod = (HandlerMethod) handler;
		ResponseBody body = mathod.getMethodAnnotation(ResponseBody.class);
		// 判断有没有@ResponseBody的注解没有的话调用父方法
		if (body == null) {// 跳转到jsp页面
			return new ModelAndView("redirect:"+loginUrl, model);
		}

		ModelAndView mv = new ModelAndView();
		// 设置状态码
		response.setStatus(HttpStatus.OK.value());
		// 设置ContentType
		response.setContentType(MediaType.APPLICATION_JSON_VALUE);
		// 避免乱码
		response.setCharacterEncoding("UTF-8");
		response.setHeader("Cache-Control", "no-cache, must-revalidate");
		String errorJson = JSON.toJSONString(errorMap);
		try {
			response.getWriter().write(errorJson);
		} catch (IOException e) {
			e.printStackTrace();
		}
		return mv;
	}

	private Map<String, String> createFriendlyErrMsg(Throwable throwable) {
		
		Map<String, String> errorMap = new HashMap<String, String>();
		if (throwable instanceof NumberFormatException) {
			errorMap.put("errorCode", "-1");
			errorMap.put("errorMessage", "数字格式化错误");
			errorMap.put("errorLog", "【SystemException】数字格式化错误:"
					+ (throwable.getCause() == null ? throwable.getMessage()
							: throwable.getCause()));
			return errorMap;
		} else if (throwable instanceof NullPointerException) {
			errorMap.put("errorCode", "-1");
			errorMap.put("errorMessage", "调用了未经初始化的对象或者是不存在的对象");
			errorMap.put("errorLog", "【SystemException】调用了未经初始化的对象或者是不存在的对象:"
					+ (throwable.getCause() == null ? throwable.getMessage()
							: throwable.getCause()));
			return errorMap;
		} else if (throwable instanceof IOException) {
			errorMap.put("errorCode", "-1");
			errorMap.put("errorMessage", "IO异常");
			errorMap.put("errorLog", "【SystemException】IO异常:"
					+ (throwable.getCause() == null ? throwable.getMessage()
							: throwable.getCause()));
			return errorMap;
		} else if (throwable instanceof ClassNotFoundException) {
			errorMap.put("errorCode", "-1");
			errorMap.put("errorMessage", "指定的类不存在");
			errorMap.put("errorLog", "【SystemException】指定的类不存在:"
					+ (throwable.getCause() == null ? throwable.getMessage()
							: throwable.getCause()));
			return errorMap;
		} else if (throwable instanceof ArithmeticException) {
			errorMap.put("errorCode", "-1");
			errorMap.put("errorMessage", "数学运算异常");
			errorMap.put("errorLog", "【SystemException】数学运算异常:"
					+ (throwable.getCause() == null ? throwable.getMessage()
							: throwable.getCause()));
			return errorMap;
		} else if (throwable instanceof ArrayIndexOutOfBoundsException) {
			errorMap.put("errorCode", "-1");
			errorMap.put("errorMessage", "数组下标越界");
			errorMap.put("errorLog", "【SystemException】数组下标越界:"
					+ (throwable.getCause() == null ? throwable.getMessage()
							: throwable.getCause()));
			return errorMap;
		} else if (throwable instanceof IllegalArgumentException) {
			errorMap.put("errorCode", "-1");
			errorMap.put("errorMessage", "方法的参数错误");
			errorMap.put("errorLog", "【SystemException】方法的参数错误:"
					+ (throwable.getCause() == null ? throwable.getMessage()
							: throwable.getCause()));
			return errorMap;
		} else if (throwable instanceof ClassCastException) {
			errorMap.put("errorCode", "-1");
			errorMap.put("errorMessage", "类型强制转换错误");
			errorMap.put("errorLog", "【SystemException】类型强制转换错误:"
					+ (throwable.getCause() == null ? throwable.getMessage()
							: throwable.getCause()));
			return errorMap;
		} else if (throwable instanceof SecurityException) {
			errorMap.put("errorCode", "-1");
			errorMap.put("errorMessage", "违背安全原则异常");
			errorMap.put("errorLog", "【SystemException】违背安全原则异常:"
					+ (throwable.getCause() == null ? throwable.getMessage()
							: throwable.getCause()));
			return errorMap;
		} else if (throwable instanceof SQLException) {
			errorMap.put("errorCode", "-1");
			errorMap.put("errorMessage", "操作数据库异常");
			errorMap.put("errorLog", "【SystemException】操作数据库异常:"
					+ (throwable.getCause() == null ? throwable.getMessage()
							: throwable.getCause()));
			return errorMap;
		} else if (throwable instanceof NoSuchMethodError) {
			errorMap.put("errorCode", "-1");
			errorMap.put("errorMessage", "方法末找到异常");
			errorMap.put("errorLog", "【SystemException】方法末找到异常:"
					+ (throwable.getCause() == null ? throwable.getMessage()
							: throwable.getCause()));
			return errorMap;
		} else if (throwable instanceof InternalError) {
			errorMap.put("errorCode", "-1");
			errorMap.put("errorMessage", "Java虚拟机发生了内部错误");
			errorMap.put("errorLog", "【SystemException】Java虚拟机发生了内部错误:"
					+ (throwable.getCause() == null ? throwable.getMessage()
							: throwable.getCause()));
			return errorMap;
		} else if (throwable instanceof Exception) {
			if (throwable instanceof BusinessException) {
				BusinessException be = (BusinessException) throwable;
				errorMap.put("errorCode", be.getErrorCode());
				errorMap.put("errorMessage", be.getErrorMessage());
				errorMap.put("errorLog", "【BusinessException】业务异常:"
						+ be.getMessage());
				return errorMap;
			} else {
				errorMap.put("errorCode", "-1");
				errorMap.put("errorMessage", "程序内部错误，操作失败");
				errorMap.put("errorLog", "【SystemException】程序内部错误，操作失败:"
						+ (throwable.getCause() == null ? throwable
								.getMessage() : throwable.getCause()));
				return errorMap;
			}
		} else if (throwable instanceof OgnlException) {
			errorMap.put("errorCode", "-1");
			errorMap.put("errorMessage", "自定义反向执行JAVA类操作失败");
			errorMap.put("errorLog", "【SystemException】自定义反向执行JAVA类操作失败:"
					+ (throwable.getCause() == null ? throwable.getMessage()
							: throwable.getCause()));
			return errorMap;
		}
		errorMap.put("errorCode", "-1");
		errorMap.put("errorMessage", "发生未知异常");
		errorMap.put("errorLog", "【SystemException】发生未知异常:"
				+ (throwable.getCause() == null ? throwable.getMessage()
						: throwable.getCause()));
		return errorMap;
	}
}