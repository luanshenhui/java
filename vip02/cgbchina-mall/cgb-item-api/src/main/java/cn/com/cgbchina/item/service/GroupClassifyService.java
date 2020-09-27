package cn.com.cgbchina.item.service;

import cn.com.cgbchina.item.model.GroupClassify;
import com.spirit.Annotation.Param;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;

import java.util.List;

public interface GroupClassifyService {

	Response<Boolean> groupClassifyAdd(String name);

	Response<Boolean> groupClassifDel(Long id);

	Response<Pager<GroupClassify>> find(@Param("pageNo") Integer pageNo, @Param("size") Integer size);
	public Response<List<GroupClassify>> allGroupClassify();
}
