/**
 * 
 */
package cn.rkylin.core.vo;

/**
 * @author pangzihua
 * DataTime:2016-2-16 下午2:22:09
 * Desp:API接口返回值
 */
public class ApiResult {
    private Integer status;
    private String message;
    private Object result;
    
	
	public Integer getStatus() {
		return status;
	}
	public void setStatus(Integer status) {
		this.status = status;
	}
	public String getMessage() {
		return message;
	}
	public void setMessage(String message) {
		this.message = message;
	}
	public Object getResult() {
		return result;
	}
	public void setResult(Object result) {
		this.result = result;
	}      
}
