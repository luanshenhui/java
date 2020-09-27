package com.market.dao;

import java.util.List;

import com.market.util.PageBean;
import com.market.vo.Member;

public interface MemberDAO {

	public void save(Member member);

	public void update(Member member);

	public void delete(Member member);

	public Member getMember(Member member);

	public Member getMember(Long id);

	/**
	 * 获得Member的分页列表
	 * 
	 * @param pageBean
	 * @return
	 */
	public List<Member> findPageInfoMember(Member member, PageBean pageBean);

	public Integer getCount(Member member);
}
