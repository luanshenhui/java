package cn.com.cgbchina.user.service;

import com.spirit.common.model.Response;

import java.util.List;

/**
 * Created by 郝文佳 on 2016/5/20.
 */
public interface AdminRoleMenuService {
	Response<List<Long>> getMenuByRoleId(Long id);
}
