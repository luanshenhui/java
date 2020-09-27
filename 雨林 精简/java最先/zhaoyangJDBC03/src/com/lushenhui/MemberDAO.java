package com.lushenhui;

import java.util.List;

public interface MemberDAO {

	List<Member> getAll();

	List<Member> search(String string, double i, double j);

}
