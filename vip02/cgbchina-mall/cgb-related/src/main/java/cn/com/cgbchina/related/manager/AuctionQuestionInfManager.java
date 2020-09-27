package cn.com.cgbchina.related.manager;

import javax.annotation.Resource;

import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import cn.com.cgbchina.related.dao.AuctionQuestionInfDao;
import cn.com.cgbchina.related.model.AuctionQuestionInfModel;

/**
 * Created by 11150421040212 on 16-4-23.
 */
@Component
@Transactional
public class AuctionQuestionInfManager {
	@Resource
	private AuctionQuestionInfDao auctionQuestionInfDao;

	/**
	 * 添加数据
	 * 
	 * @param auctionQuestionInfModel
	 * @return
	 */
	public Integer insertAuctionQuestion(AuctionQuestionInfModel auctionQuestionInfModel) {
		return auctionQuestionInfDao.insert(auctionQuestionInfModel);
	}

	/**
	 * 修改白名单
	 * 
	 * @param auctionQuestion
	 * @return
	 */
	public Integer updateAuctionQuestion(AuctionQuestionInfModel auctionQuestion) {
		return auctionQuestionInfDao.update(auctionQuestion);
	}

	/**
	 * 删除
	 * 
	 * @param id
	 * @return
	 */
	public Integer deleteAuctionQuestion(Long id) {
		return auctionQuestionInfDao.updateDelFlag(id);
	}
}
