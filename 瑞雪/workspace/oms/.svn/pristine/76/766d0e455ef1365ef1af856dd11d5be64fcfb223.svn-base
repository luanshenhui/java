package cn.rkylin.core.exception;

/**
 * 
 * ClassName: BusinessException
 * 
 * @Description: 业务异常类
 * @author shixiaofeng@tootoo.cn
 * @date 2015年12月24日 上午11:05:09
 */
public final class BusinessException extends Exception {

	private static final long serialVersionUID = 1L;

	private String errorCode = "1";// 异常代码
	private String businessCode = "";
	private String errorMessage;// 异常信息

	public BusinessException(String businessCode,String errorMessage) {
		super(errorMessage);
		this.businessCode = businessCode;
		this.errorMessage = errorMessage;
	}
	
	public BusinessException(Throwable e, String errorCode, String errorMessage) {
		super(errorMessage,e);
		this.errorCode = errorCode;
		this.errorMessage = errorMessage;
	}
	
	public BusinessException(String uuid, String errorCode, String errorMessage) {
		super(errorMessage);
		this.errorCode = errorCode;
		this.errorMessage = errorMessage;
	}

	public String getErrorCode() {
		return errorCode;
	}

	public void setErrorCode(String errorCode) {
		this.errorCode = errorCode;
	}

	public String getErrorMessage() {
		return errorMessage;
	}

	public void setErrorMessage(String errorMessage) {
		this.errorMessage = errorMessage;
	}

	public String getBusinessCode() {
		return businessCode;
	}

	public void setBusinessCode(String businessCode) {
		this.businessCode = businessCode;
	}
	
}
