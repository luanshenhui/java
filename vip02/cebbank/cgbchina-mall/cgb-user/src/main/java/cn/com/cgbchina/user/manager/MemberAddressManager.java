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
	 * 根据收货地址id删除
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
}