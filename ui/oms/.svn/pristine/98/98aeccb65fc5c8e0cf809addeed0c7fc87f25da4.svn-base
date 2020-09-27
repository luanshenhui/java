package cn.rkylin.core.interceptor;

import cn.rkylin.core.exception.BusinessException;
import cn.rkylin.core.utils.LogUtils;
import cn.rkylin.core.vo.ApiResult;
import com.alibaba.fastjson.JSON;
import org.apache.ibatis.ognl.OgnlException;
import org.apache.log4j.Logger;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.web.servlet.HandlerExceptionResolver;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

/**
 * 
 * @Description: api工程统一异常拦截器
 */
public class ApiExceptionResultHandler implements HandlerExceptionResolver {

	private static Logger logger = Logger.getLogger(LogUtils.LOG_BOSS);


	public ModelAndView resolveException(HttpServletRequest request,
			HttpServletResponse response, Object handler, Exception throwable) {
		Map<String, Object> model = new HashMap<String, Object>();
		model.put("ex", throwable);
		String uuid = request.getAttribute("uuid").toString();
		
		Map<String, String> errorMap = createFriendlyErrMsg(throwable);
		ApiResult result = new ApiResult();
		result.setStatus(Integer.parseInt(errorMap.get("statusCode")));
		result.setMessage(errorMap.get("statusMessage"));
		LogUtils.error(logger, uuid, errorMap.toString(), throwable);

		ModelAndView mv = new ModelAndView();
		// 设置状态码
		response.setStatus(HttpStatus.OK.value());
		// 设置ContentType
		response.setContentType(MediaType.APPLICATION_JSON_VALUE);
		// 避免乱码
		response.setCharacterEncoding("UTF-8");
		response.setHeader("Cache-Control", "no-cache, must-revalidate");
		String errorJson = JSON.toJSONString(result);
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
			errorMap.put("statusCode", "-1");
			errorMap.put("statusMessage", "数字格式化错误");
			errorMap.put("errorLog", "【SystemException】数字格式化错误:"
					+ (throwable.getCause() == null ? throwable.getMessage()
							: throwable.getCause()));
			return errorMap;
		} else if (throwable instanceof NullPointerException) {
			errorMap.put("statusCode", "-1");
			errorMap.put("statusMessage", "调用了未经初始化的对象或者是不存在的对象");
			errorMap.put("errorLog", "【SystemException】调用了未经初始化的对象或者是不存在的对象:"
					+ (throwable.getCause() == null ? throwable.getMessage()
							: throwable.getCause()));
			return errorMap;
		} else if (throwable instanceof IOException) {
			errorMap.put("statusCode", "-1");
			errorMap.put("statusMessage", "IO异常");
			errorMap.put("errorLog", "【SystemException】IO异常:"
					+ (throwable.getCause() == null ? throwable.getMessage()
							: throwable.getCause()));
			return errorMap;
		} else if (throwable instanceof ClassNotFoundException) {
			errorMap.put("statusCode", "-1");
			errorMap.put("statusMessage", "指定的类不存在");
			errorMap.put("errorLog", "【SystemException】指定的类不存在:"
					+ (throwable.getCause() == null ? throwable.getMessage()
							: throwable.getCause()));
			return errorMap;
		} else if (throwable instanceof ArithmeticException) {
			errorMap.put("statusCode", "-1");
			errorMap.put("statusMessage", "数学运算异常");
			errorMap.put("errorLog", "【SystemException】数学运算异常:"
					+ (throwable.getCause() == null ? throwable.getMessage()
							: throwable.getCause()));
			return errorMap;
		} else if (throwable instanceof ArrayIndexOutOfBoundsException) {
			errorMap.put("statusCode", "-1");
			errorMap.put("statusMessage", "数组下标越界");
			errorMap.put("errorLog", "【SystemException】数组下标越界:"
					+ (throwable.getCause() == null ? throwable.getMessage()
							: throwable.getCause()));
			return errorMap;
		} else if (throwable instanceof IllegalArgumentException) {
			errorMap.put("statusCode", "-1");
			errorMap.put("statusMessage", "方法的参数错误");
			errorMap.put("errorLog", "【SystemException】方法的参数错误:"
					+ (throwable.getCause() == null ? throwable.getMessage()
							: throwable.getCause()));
			return errorMap;
		} else if (throwable instanceof ClassCastException) {
			errorMap.put("statusCode", "-1");
			errorMap.put("statusMessage", "类型强制转换错误");
			errorMap.put("errorLog", "【SystemException】类型强制转换错误:"
					+ (throwable.getCause() == null ? throwable.getMessage()
							: throwable.getCause()));
			return errorMap;
		} else if (throwable instanceof SecurityException) {
			errorMap.put("statusCode", "-1");
			errorMap.put("statusMessage", "违背安全原则异常");
			errorMap.put("errorLog", "【SystemException】违背安全原则异常:"
					+ (throwable.getCause() == null ? throwable.getMessage()
							: throwable.getCause()));
			return errorMap;
		} else if (throwable instanceof SQLException) {
			errorMap.put("statusCode", "-1");
			errorMap.put("statusMessage", "操作数据库异常");
			errorMap.put("errorLog", "【SystemException】操作数据库异常:"
					+ (throwable.getCause() == null ? throwable.getMessage()
							: throwable.getCause()));
			return errorMap;
		} else if (throwable instanceof NoSuchMethodError) {
			errorMap.put("statusCode", "-1");
			errorMap.put("statusMessage", "方法末找到异常");
			errorMap.put("errorLog", "【SystemException】方法末找到异常:"
					+ (throwable.getCause() == null ? throwable.getMessage()
							: throwable.getCause()));
			return errorMap;
		} else if (throwable instanceof InternalError) {
			errorMap.put("statusCode", "-1");
			errorMap.put("statusMessage", "Java虚拟机发生了内部错误");
			errorMap.put("errorLog", "【SystemException】Java虚拟机发生了内部错误:"
					+ (throwable.getCause() == null ? throwable.getMessage()
							: throwable.getCause()));
			return errorMap;
		} else if (throwable instanceof Exception) {
			if (throwable instanceof BusinessException) {
				BusinessException be = (BusinessException) throwable;
				errorMap.put("statusCode", (be.getBusinessCode()==null||"".equals(be.getBusinessCode())?be.getErrorCode():be.getBusinessCode()));
				errorMap.put("statusMessage", be.getErrorMessage());
				errorMap.put("errorLog", "【BusinessException】业务异常:"
						+ be.getMessage());
				return errorMap;
			} else {
				errorMap.put("statusCode", "-1");
				errorMap.put("statusMessage", "程序内部错误，操作失败");
				errorMap.put("errorLog", "【SystemException】程序内部错误，操作失败:"
						+ (throwable.getCause() == null ? throwable
								.getMessage() : throwable.getCause()));
				return errorMap;
			}
		} else if (throwable instanceof OgnlException) {
			errorMap.put("statusCode", "-1");
			errorMap.put("statusMessage", "自定义反向执行JAVA类操作失败");
			errorMap.put("errorLog", "【SystemException】自定义反向执行JAVA类操作失败:"
					+ (throwable.getCause() == null ? throwable.getMessage()
							: throwable.getCause()));
			return errorMap;
		}
		errorMap.put("statusCode", "-1");
		errorMap.put("statusMessage", "发生未知异常");
		errorMap.put("errorLog", "【SystemException】发生未知异常:"
				+ (throwable.getCause() == null ? throwable.getMessage()
						: throwable.getCause()));
		return errorMap;
	}
}