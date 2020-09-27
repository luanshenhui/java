/*
 * 
 * Copyright 2016 by www.cgbchina.com.cn All rights reserved.
 * 
 */
package cn.com.cgbchina.item.dao;

import java.util.List;
import java.util.Map;

import javax.swing.text.TabableView;

import org.mybatis.spring.support.SqlSessionDaoSupport;
import org.springframework.stereotype.Repository;

import cn.com.cgbchina.item.model.StageMallGoodsQueryExtend;

import com.spirit.common.model.Pager;

/**
 * 日期 : 2016-7-19<br>
 * 作者 : xiewl<br>
 * 项目 : cgb-item<br>
 * 功能 : <br>
 */
@Repository
public class RestItemDao extends SqlSessionDaoSupport {

	public Pager<StageMallGoodsQueryExtend> findByPager(Map<String, Object> queryParams) {
		Pager<StageMallGoodsQueryExtend> pager = new Pager<>();
		long total = getSqlSession().selectOne("Rest.countStageMallGoodsQueryModel", queryParams);
		pager.setTotal(total);
		if (total > 0) {
			List<StageMallGoodsQueryExtend> stageMallGoodsQueryModelExtends = getSqlSession().selectList(
					"Rest.findStageMallGoodsQueryModel", queryParams);
			pager.setData(stageMallGoodsQueryModelExtends);
		}
		return pager;
	}

}
