/**
 * 
 */
package cn.rkylin.apollo.enums;

/**
 * @author pangzihua
 * DataTime:2016-1-13 下午3:31:11
 * Desp:
 */
public enum BusinessExceptionEnum {
	ADD_DATA("1","插入数据库异常!"),
	UPDATE_DATA("2","更新数据库异常！"),
	PARAMS("3","参数不完整"),
	;
	BusinessExceptionEnum(String c,String s){
		this.c = c;
		this.s = s;
	}
	private final String c;
	private final String s;
	public String getC() {
		return c;
	}
	public String getS() {
		return s;
	}	
}
