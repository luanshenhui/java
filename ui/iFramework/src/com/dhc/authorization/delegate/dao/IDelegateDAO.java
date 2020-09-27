package com.dhc.authorization.delegate.dao;

import java.util.List;

import com.dhc.authorization.delegate.domain.WF_ORG_DELEGATE;
import com.dhc.base.exception.DataAccessException;

/**
 * brief description
 * <p>
 * Date : 2010/07/09
 * </p>
 * <p>
 * Module : 权限委托管理
 * </p>
 * <p>
 * Description: 权限委托数据访问对象接口
 * </p>
 * <p>
 * Remark :
 * </p>
 * 
 * @author 王潇艺
 * @version
 *          <p>
 *          ------------------------------------------------------------
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
public interface IDelegateDAO {

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 新建权限委托
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 * 
	 * @param delegateVO
	 *            - 权限委托vo
	 * @return 无
	 * @throws DataAccessException
	 */
	public WF_ORG_DELEGATE createDelegate(WF_ORG_DELEGATE delegateVO) throws DataAccessException;

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 修改权限委托
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 * 
	 * @param delegateVO
	 *            - 权限委托vo
	 * @return 无
	 * @throws DataAccessException
	 */
	public WF_ORG_DELEGATE updateDelegate(WF_ORG_DELEGATE delegateVO) throws DataAccessException;

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 根据条件获取权限委托
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 * 
	 * @param delegateVO
	 *            - 权限委托vo
	 * @return 如果找到，返回ArrayList<WF_ORG_DELEGATE> 如果没有找到，返回new ArrayList
	 * @throws DataAccessException
	 */
	public List getDelegateByCondition(WF_ORG_DELEGATE delegateVO) throws DataAccessException;

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 删除权限委托
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 * 
	 * @param delegateIDs
	 *            - 组织单元id数组
	 * @throws DataAccessException
	 */
	public void deleteDelegate(List delegateIDs) throws DataAccessException;

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 获取权限委托
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 * 
	 * @param delegateID
	 *            - 权限委托主键
	 * @return 如果找到，返回WF_ORG_DELEGATE 如果没有找到，返回null
	 * @throws DataAccessException
	 */
	public List getDelegateDetail(String delegateID) throws DataAccessException;

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 获取权限委托
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 * 
	 * @param delegateID
	 *            - 权限委托主键
	 * @return 如果找到，返回WF_ORG_DELEGATE 如果没有找到，返回null
	 * @throws DataAccessException
	 */
	public List getDeleitemDetail(String delegateID) throws DataAccessException;

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 获取权限委托总行数，用于分页
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 * 
	 * @param delegateParam
	 *            - 权限委托查询条件
	 * @return 权限委托总行数
	 * @throws DataAccessException
	 */
	public int getDelegateCount(WF_ORG_DELEGATE delegateParam) throws DataAccessException;
}
