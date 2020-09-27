package com.yulin.lsh;

import java.util.List;

public interface DAO {

	void add(Member member);

	Member getMemberByName(String string);

	void update(Member member);

	void delete(Member member);

	List<Member> getAll();

	

}
