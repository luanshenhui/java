package cn.com.cgbchina.user.manager;

import cn.com.cgbchina.user.dao.MemberAddressDao;
import cn.com.cgbchina.user.model.MemberAddressModel;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;

/**
 * Created by niufw on 16-3-18.
 */
@Transactional
@Component
public class MemberAddressManager {
	@Resource
	private MemberAddressDao memberAddressDao;

	/**
	 * 根据收货地址id新增
	 *
	 * @param memberAddressModel
	 * @return
	 */
	public boolean create(MemberAddressModel memberAddressModel) {
		boolean result = memberAddressDao.insert(memberAddressModel) == 1;
		return result;
	}

	/**
	 * 根据收货地址id修改
	 *
	 * @param memberAddressModel
	 * @return
	 */
	public boolean update(MemberAddressModel memberAddressModel) {
		boolean result = memberAddressDao.update(memberAddressModel) == 1;
		return result;
	}

	/**
	 * 根据收货地址id删除非默认地址
	 *
	 * @param id
	 * @return
	 */
	public boolean delete(Long id) {
		boolean result = memberAddressDao.delete(id) == 1;
		return result;
	}

	/**
	 * 根据收货地址id设置默认
	 *
	 * @param id
	 * @return
	 */
	public boolean setDefault(Long id) {
		boolean result = memberAddressDao.setDefault(id) == 1;
		return result;
	}


	/**
	 *  根据用户id将所有地址更新为 非默认地址
	 * @param custId 用户id
	 * @return 更新结果
	 *
	 * geshuo 20160809
	 */
	public Integer updateDefaultByCustId(String custId){
		return memberAddressDao.updateDefaultByCustId(custId);
	}

	/**
	 *  根据用户id,地址id设置默认地址
	 * @param custId 用户id
	 * @return 更新结果
	 *
	 */
	public Integer updateDefaultByCustIdid(Long id ,String custId){
		memberAddressDao.updateDefaultByCustId(custId);
		return memberAddressDao.setDefault(id);
	}
}