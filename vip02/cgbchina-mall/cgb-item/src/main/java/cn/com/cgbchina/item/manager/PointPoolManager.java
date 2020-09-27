package cn.com.cgbchina.item.manager;

import cn.com.cgbchina.item.dao.PointPoolDao;
import cn.com.cgbchina.item.model.PointPoolModel;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.Map;

/**
 * Created by niufw on 16-3-18.
 */
@Transactional
@Component
public class PointPoolManager {
	@Resource
	private PointPoolDao pointPoolDao;

	/**
	 * 积分池添加
	 *
	 * @param pointPoolModel
	 * @return
	 */
	public boolean create(PointPoolModel pointPoolModel) {
		boolean result = pointPoolDao.insert(pointPoolModel) == 1;
		return result;
	}

	/**
	 * 积分池编辑
	 *
	 * @param pointPoolModel
	 * @return
	 */
	public boolean update(PointPoolModel pointPoolModel) {
		boolean result = pointPoolDao.update(pointPoolModel) == 1;
		return result;
	}

	/**
	 * 商城合作商删除
	 *
	 * @param id
	 * @return
	 */
	public boolean delete(Long id) {
		boolean result = pointPoolDao.updateFordelete(id) == 1;
		return result;
	}

    public void dealPointPoolForDate(Map<String, Object> paramMap) {
        pointPoolDao.dealPointPoolForDate(paramMap);
    }

	/**
	 * 增加已用积分
	 * @param paramMap
	 * @return
	 */
	public boolean subtractPointPool(Map<String, Object> paramMap) {
		boolean result = pointPoolDao.subtractPointPool(paramMap) == 1;
		return result;
	}

	@Transactional
	public void dealPointPool(Map<String, Object> paramMap){
		pointPoolDao.dealPointPool(paramMap);
	}
	
	/**
	 * 积分池编辑
	 *
	 * @param pointPoolModel
	 * @return
	 */
	public boolean updateById(PointPoolModel pointPoolModel) {
		boolean result = pointPoolDao.updateById(pointPoolModel) == 1;
		return result;
	}
}
