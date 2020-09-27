package com.market.action;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.apache.struts2.ServletActionContext;

import com.market.service.CardService;
import com.market.service.MemberService;
import com.market.util.Constants;
import com.market.util.DataSource;
import com.market.util.PageBean;
import com.market.vo.Card;
import com.market.vo.Member;
import com.opensymphony.xwork2.ActionSupport;

public class CardWebAction extends ActionSupport {

	/**
	 * Service层实例
	 */
	private CardService cardService;

	private MemberService memberService;

	/**
	 * 日志
	 */
	private Logger log = Logger.getLogger(this.getClass());

	private Card card = new Card();

	private Long id;

	@SuppressWarnings("unchecked")
	public String queryCard() {
		log.debug("queryCard" + "开始");
		HttpServletRequest request = ServletActionContext.getRequest();
		initSelect(request);

		int resultSize = 0;
		PageBean pageBean = null;
		resultSize = cardService.getCount(card);
		pageBean = PageBean.getPageBean(Constants.DISPLAYID_CARD, resultSize,
				request);
		List list = cardService.findPageInfoCard(card, pageBean);
		request.setAttribute(Constants.CARD_LIST, list);
		log.debug("queryCard" + "结束");
		return Constants.LIST;
	}

	/**
	 * 
	 * 进入增加界面
	 * 
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public String toAddCard() {
		log.debug("toAddCard" + "开始");
		HttpServletRequest request = ServletActionContext.getRequest();
		initSelect(request);
		log.debug("toAddCard" + "结束");
		return Constants.ADD;
	}

	/**
	 * 
	 * 增加
	 * 
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public String addCard() {
		log.debug("addCard" + "开始");
		try {
			cardService.save(card);

			Member member = memberService.getMember(Long.valueOf(card
					.getMemberId()));
			member.setCardNo(card.getCardNo());
			memberService.update(member);
			card = new Card();
		} catch (Exception e) {
			log.error("addCard failed" + card.toString());
		}
		log.debug("addCard" + "结束");
		return queryCard();
	}

	/**
	 * 
	 * 删除
	 * 
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public String delCard() {
		log.debug("delCard" + "开始");
		try {
			card.setId(id);
			cardService.delete(card);
		} catch (Exception e) {
			log.error("delCard failed" + card.toString());
		}
		log.debug("delCard" + "结束");
		return queryCard();
	}

	/**
	 * 
	 * 进入编辑界面
	 * 
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public String toEditCard() {
		log.debug("toEditCard" + "开始");
		HttpServletRequest request = ServletActionContext.getRequest();
		// card = cardService.getCard(id);

		Card queryCard = new Card();
		queryCard.setId(id);
		List<Card> listCard = cardService.findPageInfoCard(queryCard, null);
		card = listCard.get(0);
		initSelect(request);
		log.debug("toEditCard" + "结束");
		return Constants.EDIT;
	}

	/**
	 * 
	 * 查看信息
	 * 
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public String viewCard() {
		log.debug("viewCard" + "开始");
		Card queryCard = new Card();
		queryCard.setId(id);
		List<Card> listCard = cardService.findPageInfoCard(queryCard, null);
		card = listCard.get(0);
		log.debug("viewCard" + "结束");
		return Constants.VIEW;
	}

	/**
	 * 
	 * 编辑
	 * 
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public String editCard() {
		log.debug("editCard" + "开始");
		try {
			cardService.update(card);
			card = new Card();
		} catch (Exception e) {
			log.error("editCard failed" + card.toString());
		}
		log.debug("editCard" + "结束");
		return queryCard();
	}

	/**
	 * @param CardService
	 *            the CardService to set
	 */
	public void setCardService(CardService cardService) {
		this.cardService = cardService;
	}

	public Card getCard() {
		return card;
	}

	public void setCard(Card card) {
		this.card = card;
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public void initSelect(HttpServletRequest request) {
		request.setAttribute("cardType", DataSource.CARD_TYPE);
		Member queryMember = new Member();
		queryMember.setCardNo("-1");
		List<Member> listMember = memberService.findPageInfoMember(queryMember,
				null);
		if (listMember == null) {
			listMember = new ArrayList();
		}
		request.setAttribute("member", listMember);
		// request.setAttribute("ywfw",DataSource.YWFW);
		// request.setAttribute("jydy",DataSource.JYDY);
		// request.setAttribute("gszt",DataSource.GSZT);
	}

	public MemberService getMemberService() {
		return memberService;
	}

	public void setMemberService(MemberService memberService) {
		this.memberService = memberService;
	}

}
