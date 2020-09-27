package com.dhc.authorization.delegate.dao.ibatis;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import org.springframework.orm.ibatis.support.SqlMapClientDaoSupport;

import com.dhc.authorization.delegate.dao.IDelegateDAO;
import com.dhc.authorization.delegate.domain.WF_ORG_DELEGATE;
import com.dhc.authorization.delegate.domain.WF_ORG_DELEITEM;
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
 * Description: 权限委托数据访问对象实现
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
public class DelegateDAOImpl extends SqlMapClientDaoSupport implements IDelegateDAO {

	/**
	 * 构造函数
	 */
	public DelegateDAOImpl() {

	}

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
	public WF_ORG_DELEGATE createDelegate(WF_ORG_DELEGATE delegateVO) throws DataAccessException {
		try {
			this.getSqlMapClient().insert("WF_ORG_DELEGATE.insert", delegateVO);
			// 插入人员
			List roleList = delegateVO.getRoleItemList();
			if (roleList != null) {
				for (int i = 0; i < roleList.size(); i++) {
					WF_ORG_DELEITEM deleitemVO = (WF_ORG_DELEITEM) roleList.get(i);
					this.getSqlMapClient().insert("WF_ORG_DELEITEM.insert", deleitemVO);
				}
			}
			// 插入岗位
			List staList = delegateVO.getStationItemList();
			if (staList != null) {
				for (int i = 0; i < staList.size(); i++) {
					WF_ORG_DELEITEM deleitemVO = (WF_ORG_DELEITEM) staList.get(i);
					this.getSqlMapClient().insert("WF_ORG_DELEITEM.insert", deleitemVO);
				}
			}
			// 插入组织
			List unitList = delegateVO.getUnitItemList();
			if (unitList != null) {
				for (int i = 0; i < unitList.size(); i++) {
					WF_ORG_DELEITEM deleitemVO = (WF_ORG_DELEITEM) unitList.get(i);
					this.getSqlMapClient().insert("WF_ORG_DELEITEM.insert", deleitemVO);
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
			throw new DataAccessException("数据库操作异常");
		}
		return null;
	}

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
	public WF_ORG_DELEGATE updateDelegate(WF_ORG_DELEGATE delegateVO) throws DataAccessException {
		try {
			this.getSqlMapClient().insert("WF_ORG_DELEGATE.update", delegateVO);
			String deleId = delegateVO.getDeleId();
			this.getSqlMapClient().delete("WF_ORG_DELEITEM.deleteForUpdate", deleId);
			// 插入人员
			List roleList = delegateVO.getRoleItemList();
			if (roleList != null) {
				for (int i = 0; i < roleList.size(); i++) {
					WF_ORG_DELEITEM deleitemVO = (WF_ORG_DELEITEM) roleList.get(i);
					this.getSqlMapClient().insert("WF_ORG_DELEITEM.insert", deleitemVO);
				}
			}
			// 插入岗位
			List staList = delegateVO.getStationItemList();
			if (staList != null) {
				for (int i = 0; i < staList.size(); i++) {
					WF_ORG_DELEITEM deleitemVO = (WF_ORG_DELEITEM) staList.get(i);
					this.getSqlMapClient().insert("WF_ORG_DELEITEM.insert", deleitemVO);
				}
			}
			// 插入组织
			List unitList = delegateVO.getUnitItemList();
			if (unitList != null) {
				for (int i = 0; i < unitList.size(); i++) {
					WF_ORG_DELEITEM deleitemVO = (WF_ORG_DELEITEM) unitList.get(i);
					this.getSqlMapClient().insert("WF_ORG_DELEITEM.insert", deleitemVO);
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
			throw new DataAccessException("数据库操作异常");
		}
		return null;
	}

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
	public List getDelegateByCondition(WF_ORG_DELEGATE delegateVO) throws DataAccessException {
		List resultList = new ArrayList();
		try {
			resultList = this.getSqlMapClient().queryForList("WF_ORG_DELEGATE.select", delegateVO);
		} catch (SQLException e) {
			e.printStackTrace();
			throw new DataAccessException("数据访问错误");
		}
		return resultList;
	}

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
	public void deleteDelegate(List delegateIDs) throws DataAccessException {
		try {
			for (int i = 0; i < delegateIDs.size(); i++) {
				String deleId = delegateIDs.get(i).toString();
				if (!deleId.equals("")) {
					this.getSqlMapClient().delete("WF_ORG_DELEITEM.delete", deleId);
					this.getSqlMapClient().delete("WF_ORG_DELEGATE.delete", deleId);
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
			throw new DataAccessException("数据访问错误");
		}
	}

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
	public List getDelegateDetail(String delegateID) throws DataAccessException {
		List resultList = new ArrayList();
		try {
			resultList = this.getSqlMapClient().queryForList("WF_ORG_DELEGATE.selectDelegateDetail", delegateID);
		} catch (SQLException e) {
			e.printStackTrace();
			throw new DataAccessException("RoleDAO数据访问错误");
		}
		return resultList;

	}

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
	public List getDeleitemDetail(String delegateID) throws DataAccessException {
		List resultList = new ArrayList();
		try {
			resultList = this.getSqlMapClient().queryForList("WF_ORG_DELEITEM.selectDeleitemDetail", delegateID);
		} catch (SQLException e) {
			e.printStackTrace();
			throw new DataAccessException("RoleDAO数据访问错误");
		}
		return resultList;

	}

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
	public int getDelegateCount(WF_ORG_DELEGATE delegateParam) {
		int returnValue = 0;
		try {
			returnValue = (Integer) this.getSqlMapClient().queryForObject("WF_ORG_DELEGATE.count", delegateParam);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return returnValue;
	}
}
