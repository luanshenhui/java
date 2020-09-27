package cn.rkylin.oms.system.dictionary.dao;


import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Repository;
import cn.rkylin.core.IDataBaseFactory;
import cn.rkylin.oms.system.dictionary.domain.OMS_DICT;
import cn.rkylin.oms.system.dictionary.vo.DictVO;

/**
 * <p>
 * Module : 参数管理
 * </p>
 * <p>
 * Description: 角色业务对象
 * </p>
 * <p>
 * Remark :
 * </p>
 */
@Repository(value = "dictDAO")
public class DictDAOImpl implements IDictDAO {
	
	/**
	 * 自定义baseDao 增删改查方法
	 */
	@Autowired
	protected IDataBaseFactory dao;
	
	/**
	 * 自定义baseDao 增删改查方法
	 */
	@Autowired
	private IDataBaseFactory dataBaseFactory;

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 新增参数
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 * 
	 * @param roleVO
	 * @return 无
	 * @throws DataAccessException
	 */
	@Override
	public void insert(String string, OMS_DICT dict) throws Exception {
		dao.insert(string, dict);
	}

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 删除参数
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 * 
	 * @param OMS_DICT
	 *            
	 * @return 无
	 * @throws DataAccessException
	 */
	@Override
	public void delete(String stationParam, String string) throws Exception {
		dao.delete(stationParam, string);
	}

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 修改参数
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 * 
	 * @param OMS_DICT
	 *            
	 * @return 无
	 * @throws DataAccessException
	 */
	@Override
	public void update(String stationParam, OMS_DICT ur) throws Exception {
		dao.update(stationParam, ur);
	}

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 获取参数类型
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 * 
	 * @param roleVO
	 *            - 角色vo，包含角色下的人员、角色可管理的组织列表
	 * @return 无
	 * @throws DataAccessException
	 */
	@Override
	public List getParamDictByCode(OMS_DICT dict) throws Exception {
		return dao.findAllList("getParamDictByCode", dict);
	}
	
	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 代码是否重复校验
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 * 
	 * @param roleVO
	 *            - 角色vo，包含角色下的人员、角色可管理的组织列表
	 * @return 无
	 * @throws DataAccessException
	 */
	@Override
	public List getDictByCondition(DictVO dictVO) throws Exception {
		return dao.findAllList("getDictByCondition", dictVO);
	}

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 查找参数类型
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 * 
	 * @param roleVO
	 *            - 角色vo，包含角色下的人员、角色可管理的组织列表
	 * @return 无
	 * @throws DataAccessException
	 */
	@Override
	public List getDictTypeList(OMS_DICT dict) throws Exception {
		return dao.findAllList("getDictTypeList", dict);
	}
}
