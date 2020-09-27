package cn.com.cgbchina.related.manager;

import cn.com.cgbchina.related.dao.HotSearchTermDao;
import cn.com.cgbchina.related.model.HotSearchTermModel;
import com.google.common.collect.Maps;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by 11150721040343 on 16-4-21.
 */
@Component
@Transactional
public class HotSearchManager {
	@Resource
	private HotSearchTermDao hotSearchTermDao;

	/**
	 * 更新热搜词 热搜词不允许重复
	 * 
	 * @param dataMap
	 * @return
	 */
	public Integer update(Map<String, Object> dataMap) {
		Map<String, Object> dataMap1 = Maps.newHashMap();
		HotSearchTermModel hotSearchTermModel = (HotSearchTermModel) dataMap.get("hotSearchTermModel");
		Long id = (Long) dataMap.get("id");
		dataMap1.put("termName", hotSearchTermModel.getName());
		dataMap1.put("id", id);
		Integer count = hotSearchTermDao.countTo(dataMap1);
		if (count > 0) {
			throw new IllegalArgumentException("term.name.exist");
		}
		return hotSearchTermDao.update(dataMap);
	}

	/**
	 * 新增热搜词 热搜词不允许重复
	 * 
	 * @param hotSearchTermModel
	 * @return
	 */
	public Integer insert(HotSearchTermModel hotSearchTermModel) {
		Map<String, Object> dataMap = new HashMap<>();
		dataMap.put("termName", hotSearchTermModel.getName());
		Integer count = hotSearchTermDao.count(dataMap);
		if (count > 0) {
			throw new IllegalArgumentException("term.name.exist");
		}
		return hotSearchTermDao.insert(hotSearchTermModel);
	}

	/**
	 * 删除热搜词
	 * 
	 * @param hotSearchTermModel
	 * @return
	 */
	public Integer delete(HotSearchTermModel hotSearchTermModel) {
		return hotSearchTermDao.delete(hotSearchTermModel);
	}

}
