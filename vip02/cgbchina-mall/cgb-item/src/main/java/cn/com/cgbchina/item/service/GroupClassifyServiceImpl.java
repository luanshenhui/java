package cn.com.cgbchina.item.service;

import cn.com.cgbchina.item.dao.GroupClassifyRedisDao;
import cn.com.cgbchina.item.model.GroupClassify;
import com.google.common.base.Throwables;
import com.spirit.Annotation.Param;
import com.spirit.common.model.PageInfo;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Slf4j
@Service
public class GroupClassifyServiceImpl implements GroupClassifyService {

	@Autowired
	private GroupClassifyRedisDao groupClassifyRedisDao;

	@Override
	public Response<Boolean> groupClassifyAdd(String name) {
		Response<Boolean> response = Response.newResponse();
		try {
			groupClassifyRedisDao.groupClassifyAdd(name);
			response.setResult(Boolean.TRUE);
		} catch (Exception e) {
			log.error("更新活动单品销量失败{}", Throwables.getStackTraceAsString(e));
			response.setError("prom.update.sale.count.error");
		}
		return response;
	}

	@Override
	public Response<Boolean> groupClassifDel(Long id) {
		Response<Boolean> response = Response.newResponse();
		try {
			groupClassifyRedisDao.groupClassifyDel(id);
			response.setResult(Boolean.TRUE);
		} catch (Exception e) {
			log.error("更新活动单品销量失败{}", Throwables.getStackTraceAsString(e));
			response.setError("prom.update.sale.count.error");
		}
		return response;
	}

	@Override
	public Response<Pager<GroupClassify>> find(@Param("pageNo") Integer pageNo, @Param("size") Integer size) {
		Response<Pager<GroupClassify>> response = Response.newResponse();
		try {
			PageInfo pageInfo = new PageInfo(pageNo, size);
			List<GroupClassify> list = groupClassifyRedisDao.findByPager(pageInfo);
			Pager<GroupClassify> pager = new Pager<>();
			pager.setData(list);
			pager.setTotal(groupClassifyRedisDao.allKeySize());
			response.setResult(pager);

		} catch (Exception e) {
            log.error("查找团购分类失败",e);
			response.setError("query.error");
		}
		return response;
	}
    @Override
	public Response<List<GroupClassify>> allGroupClassify() {
		Response<List<GroupClassify>> response = Response.newResponse();
		try {
			List<GroupClassify> groupClassifies = groupClassifyRedisDao.allGroupClassify();
			response.setResult(groupClassifies);
		} catch (Exception e) {
			log.error("group classify error", e);
			response.setError("group.classify.error");
		}
		return response;
	}

}
