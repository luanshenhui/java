package cn.com.cgbchina.batch.manager;

import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;
import cn.com.cgbchina.batch.dao.SynBonusDao;
import lombok.extern.slf4j.Slf4j;

/**
 * Created by txy on 2016/7/27.
 */
@Component
@Slf4j
@Transactional
public class SynBonusManager {
	@Resource
	private SynBonusDao synBonusDao;
	@Transactional
	public void update(Map<String, Object> params) {
		synBonusDao.update(params);
	}
	@Transactional
	public void create(Map<String, Object> createParams) {
		synBonusDao.create(createParams);
	}
}
