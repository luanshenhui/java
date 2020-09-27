package com.market.service;

import java.util.List;

import com.market.util.PageBean;
import com.market.vo.Member;

public interface MemberService {
	public void save(Member member);

	public void update(Member member);

	public void delete(Member member);

	public Member getMember(Member member);

	public Member getMember(Long id);

	public List<Member> findPageInfoMember(Member member, PageBean pageBean);

	public Integer getCount(Member member);
}
