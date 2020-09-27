package cn.com.cgbchina.user.service;

import cn.com.cgbchina.user.dao.AdminRoleMenuDao;
import com.google.common.collect.Lists;
import com.spirit.common.model.Response;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

/**
 * Created by 郝文佳 on 2016/5/20.
 */
@Service
@Slf4j
public class AdminRoleMenuServiceImpl implements AdminRoleMenuService {
	@Resource
	private AdminRoleMenuDao adminRoleMenuDao;

	@Override
	public Response<List<Long>> getMenuByRoleId(Long id) {
		Response<List<Long>> response = new Response<>();
		try {
			List<Long> menuByRoleId = adminRoleMenuDao.getMenuByRoleId(Lists.newArrayList(id));
			response.setResult(menuByRoleId);
		} catch (Exception e) {
			log.error("fail to load menu");
			response.setError("find.menu.error");
		}
		return response;
	}
}
