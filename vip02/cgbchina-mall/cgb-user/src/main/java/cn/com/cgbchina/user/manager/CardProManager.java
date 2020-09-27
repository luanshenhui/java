/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.user.manager;

import javax.annotation.Resource;

import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import cn.com.cgbchina.user.dao.CardProDao;
import cn.com.cgbchina.user.model.CardPro;

/**
 * @author yuxinxin
 * @version 1.0
 * @Since 16-6-14.
 */
@Component
@Transactional
public class CardProManager {
	@Resource
	private CardProDao cardProDao;

	public boolean updateIsBinding(CardPro cardPro) {
		cardProDao.updateIsBinding(cardPro);
		return true;
	}

	public boolean updateUnBinding(String formatId) {
		return cardProDao.updateUnBinding(formatId) == 1;
	}
	public boolean insert(CardPro cardPro){
		return cardProDao.insert(cardPro) == 1;
	}

	public boolean update(CardPro cardPro){
		return cardProDao.update(cardPro) == 1;
	}
}
