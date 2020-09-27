package com.cebbank.ccis.cebmall.item.manager;

import com.cebbank.ccis.cebmall.item.dao.ItemDao;
import com.google.common.base.Splitter;
import com.spirit.util.JsonMapper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;

/**
 * Created by 陈乐 on 2016/4/23.
 */
@Component
@Transactional
@Slf4j
public class GoodsManager {

	private static JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();
	@Resource
	private ItemDao itemDao;
	private final Splitter splitter = Splitter.on(',').trimResults();


}
