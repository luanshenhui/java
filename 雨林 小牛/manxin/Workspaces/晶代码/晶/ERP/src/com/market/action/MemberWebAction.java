package com.market.action;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.apache.struts2.ServletActionContext;

import com.market.service.MemberService;
import com.market.util.Constants;
import com.market.util.DataSource;
import com.market.util.PageBean;
import com.market.vo.Member;
import com.opensymphony.xwork2.ActionSupport;

public class MemberWebAction extends ActionSupport {

	/**
	 * Service层实例
	 */
	private MemberService memberService;

	/**
	 * 日志
	 */
	private Logger log = Logger.getLogger(this.getClass());

	private Member member = new Member();

	private Long id;

	@SuppressWarnings("unchecked")
	public String queryMember() {
		log.debug("queryMember" + "开始");
		HttpServletRequest request = ServletActionContext.getRequest();
		initSelect(request);

		int resultSize = 0;
		PageBean pageBean = null;
		resultSize = memberService.getCount(member);
		pageBean = PageBean.getPageBean(Constants.DISPLAYID_MEMBER, resultSize,
				request);
		List list = memberService.findPageInfoMember(member, pageBean);
		request.setAttribute(Constants.MEMBER_LIST, list);
		log.debug("queryMember" + "结束");
		return Constants.LIST;
	}

	public String selectMember() {
		log.debug("selectMember" + "开始");
		HttpServletRequest request = ServletActionContext.getRequest();
		initSelect(request);

		int resultSize = 0;
		PageBean pageBean = null;
		resultSize = memberService.getCount(member);
		pageBean = PageBean.getPageBean(Constants.DISPLAYID_MEMBER, resultSize,
				request);
		List list = memberService.findPageInfoMember(member, pageBean);
		request.setAttribute(Constants.MEMBER_LIST, list);
		log.debug("selectMember" + "结束");
		return "selectMember";
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
	public String toAddMember() {
		log.debug("toAddMember" + "开始");
		HttpServletRequest request = ServletActionContext.getRequest();
		initSelect(request);
		log.debug("toAddMember" + "结束");
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
	public String addMember() {
		log.debug("addMember" + "开始");
		try {
			memberService.save(member);
			member = new Member();
		} catch (Exception e) {
			log.error("addMember failed" + member.toString());
		}
		log.debug("addMember" + "结束");
		return queryMember();
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
	public String delMember() {
		log.debug("delMember" + "开始");
		try {
			member.setId(id);
			memberService.delete(member);
		} catch (Exception e) {
			log.error("delMember failed" + member.toString());
		}
		log.debug("delMember" + "结束");
		return queryMember();
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
	public String toEditMember() {
		log.debug("toEditMember" + "开始");
		HttpServletRequest request = ServletActionContext.getRequest();
		member = memberService.getMember(id);
		initSelect(request);
		log.debug("toEditMember" + "结束");
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
	public String viewMember() {
		log.debug("viewMember" + "开始");
		member = memberService.getMember(id);
		log.debug("viewMember" + "结束");
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
	public String editMember() {
		log.debug("editMember" + "开始");
		try {
			memberService.update(member);
			member = new Member();
		} catch (Exception e) {
			log.error("editMember failed" + member.toString());
		}
		log.debug("editMember" + "结束");
		return queryMember();
	}

	/**
	 * @param MemberService
	 *            the MemberService to set
	 */
	public void setMemberService(MemberService memberService) {
		this.memberService = memberService;
	}

	public Member getMember() {
		return member;
	}

	public void setMember(Member member) {
		this.member = member;
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public void initSelect(HttpServletRequest request) {
		request.setAttribute("sex", DataSource.SEX);
		// request.setAttribute("ywfw",DataSource.YWFW);
		// request.setAttribute("jydy",DataSource.JYDY);
		// request.setAttribute("gszt",DataSource.GSZT);
	}

}
