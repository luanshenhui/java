package cn.rkylin.oms.system.facade.exception;

/**
 * brief description
 * <p>
 * Date : 2010/05/13
 * </p>
 * <p>
 * Module : 组织机构权限管理接口
 * </p>
 * <p>
 * Description: 组织机构异常
 * </p>
 * <p>
 * Remark :
 * </p>
 * 
 * @author 王潇艺
 * @version
 *          <p>
 * 			------------------------------------------------------------
 *          </p>
 *          <p>
 *          修改历史
 *          </p>
 *          <p>
 *          序号 日期 修改人 修改原因
 *          </p>
 *          <p>
 *          1
 *          </p>
 */
public class OrgFacadeException extends Exception {

	/**
	 * @param cause
	 */
	public OrgFacadeException(Throwable cause) {
		super(cause);
	}

	/**
	 * @param message
	 * @param cause
	 */
	public OrgFacadeException(String message, Throwable cause) {
		super(message, cause);
	}

	/**
	 * @param message
	 */
	public OrgFacadeException(String message) {
		super(message);
	}

	public OrgFacadeException() {

	}
}
