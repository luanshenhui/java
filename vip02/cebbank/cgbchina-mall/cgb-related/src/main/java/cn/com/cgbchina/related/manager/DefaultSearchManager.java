package cn.com.cgbchina.related.manager;

import cn.com.cgbchina.related.dao.DefaultSearchDao;
import cn.com.cgbchina.related.model.DefaultSearchModel;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by 11150421040212 on 16-4-23.
 */
@Component
@Transactional
public class DefaultSearchManager {
	@Resource
	private DefaultSearchDao defaultSearchDao;

	public boolean create(DefaultSearchModel defaultSearchModel) {
		// 增加默认搜索词不能重复
		Map<String, Object> dataMap = new HashMap<>();
		dataMap.put("termName", defaultSearchModel.getName());
		Integer count = defaultSearchDao.count(dataMap);
		if (count > 0) {
			throw new IllegalArgumentException("default.name.exist");
		}
		return defaultSearchDao.insert(defaultSearchModel) == 1;
	}

	public boolean update(DefaultSearchModel defaultSearchModel) {
		// 编辑默认搜索词不能重复
		Map<String, Object> dataMap = new HashMap<>();
		dataMap.put("termName", defaultSearchModel.getName());
		dataMap.put("id", defaultSearchModel.getId());
		Integer count = defaultSearchDao.countTo(dataMap);
		if (count > 0) {
			throw new IllegalArgumentException("default.name.exist");
		}
		return defaultSearchDao.update(defaultSearchModel) == 1;
	}

	public boolean delete(DefaultSearchModel defaultSearchModel) {
		return defaultSearchDao.delete(defaultSearchModel) == 1;
	}
}
