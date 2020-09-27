package com.market.service;

import java.util.List;

import com.market.dao.MemberDAO;
import com.market.util.PageBean;
import com.market.vo.Member;

public class MemberServiceImpl implements MemberService {
	private MemberDAO memberDAO;

	public void save(Member member) {
		memberDAO.save(member);
	}

	public void update(Member member) {
		memberDAO.update(member);
	}

	public Member getMember(Member member) {
		return memberDAO.getMember(member);
	}

	public Member getMember(Long id) {
		return memberDAO.getMember(id);
	}

	public void delete(Member member) {
		memberDAO.delete(member);
	}

	public List<Member> findPageInfoMember(Member member, PageBean pageBean) {
		return memberDAO.findPageInfoMember(member, pageBean);
	}

	public Integer getCount(Member member) {
		return memberDAO.getCount(member);
	}

	public void setMemberDAO(MemberDAO memberDAO) {
		this.memberDAO = memberDAO;
	}
}
