
package com.dhc.organization.position.dao;

import java.util.List;

import com.dhc.base.exception.DataAccessException;
import com.dhc.organization.position.domain.WF_ORG_STATION;

/**
 * brief description
 * <p>
 * Date : 2010/05/06
 * </p>
 * <p>
 * Module : 岗位管理
 * </p>
 * <p>
 * Description: 岗位管理数据访问对象接口
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
public interface IPositionDAO {

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 根据条件获取岗位
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 * 
	 * @param positionVO
	 *            - 岗位vo
	 * @return 如果找到，返回List<WF_ORG_POSITION> 如果没有找到，返回null
	 * @throws DataAccessException
	 */
	public List getStationByCondition(WF_ORG_STATION positionVO) throws DataAccessException;

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 新建岗位，包括（岗位基本信息、人员信息）
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 * 
	 * @param stationVO
	 *            - 含有人员列表的岗位vo
	 * @throws DataAccessException
	 */
	public void createStation(WF_ORG_STATION stationVO) throws DataAccessException;

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 修改岗位，包括（岗位基本信息、人员信息）
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 * 
	 * @param stationVO
	 *            - 含有人员列表的岗位vo
	 * @throws DataAccessException
	 */
	public void updateStation(WF_ORG_STATION stationVO) throws DataAccessException;

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 删除岗位。如果组织单元下人员，或岗位被组织单元使用，则该岗位不能删除
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 * 
	 * @param stationID
	 *            - 岗位id
	 * @throws DataAccessException
	 */
	public void deleteStation(WF_ORG_STATION stationVO) throws DataAccessException;

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 获取某组织下的所有子组织，需要考虑当前组织，该用户是否能管理
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 * 
	 * @param stationID
	 *            - 岗位id
	 * @return 如果找到，返回带有岗位下人员的WF_ORG_STATION VO 如果没有找到，返回null
	 * @throws DataAccessException
	 */
	public List getStationWithUsers(WF_ORG_STATION staVO) throws DataAccessException;
}
