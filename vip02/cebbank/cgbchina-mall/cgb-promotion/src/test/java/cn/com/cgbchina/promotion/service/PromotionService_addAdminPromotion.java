package cn.com.cgbchina.promotion.service;

import cn.com.cgbchina.promotion.dao.PromotionDao;
import cn.com.cgbchina.promotion.model.PromotionModel;
import org.junit.Test;

import cn.com.cgbchina.promotion.BaseTestCase;
import org.unitils.spring.annotation.SpringBean;

import javax.annotation.Resource;
import java.util.Date;

public class PromotionService_addAdminPromotion extends BaseTestCase {

	@SpringBean("promotionDao")
	private PromotionDao promotionDao;

	@Test
	public void testAddAdminPromotion() {
		PromotionModel promotion = new PromotionModel();
		promotion.setId(12323);
		promotion.setCreateOper("323");
		promotion.setCreateTime(new Date());
		promotion.setModifyTime(new Date());
		promotionDao.insert(promotion);

	}

}