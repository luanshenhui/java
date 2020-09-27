package cn.com.cgbchina.trade.manager;

import cn.com.cgbchina.trade.dao.TblEspCustCartDao;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.List;

/**
 *
 * Created by zhoupeng on 2016/9/23.
 */
@Component
@Transactional
public class EspCustCartManager {

	@Resource
	TblEspCustCartDao tblEspCustCartDao;

	/**
	 * 根据集合id 删除
	 *
	 * @param ids 集合id
	 * @return Integer
	 */
	public Integer deleteByIds(List<String> ids) {
		return tblEspCustCartDao.deleteByIds(ids);
	}
}
