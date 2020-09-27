package cn.com.cgbchina.user.service;

import cn.com.cgbchina.user.dao.VendorMenuDao;
import cn.com.cgbchina.user.dao.VendorRoleMenuDao;
import cn.com.cgbchina.user.dao.VendorRoleRefDao;
import cn.com.cgbchina.user.dto.VendorMenuNode;
import cn.com.cgbchina.user.model.VendorMenuModel;
import cn.com.cgbchina.user.model.VendorModel;
import com.google.common.cache.CacheBuilder;
import com.google.common.cache.CacheLoader;
import com.google.common.cache.LoadingCache;
import com.spirit.Annotation.Param;
import com.spirit.common.model.Response;
import com.spirit.user.User;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;
import java.util.concurrent.TimeUnit;

/**
 * Created by 郝文佳 on 2016/5/20.
 */
@Service
@Slf4j
public class VendorMenuServiceImpl implements VendorMenuService {
	private final LoadingCache<Long, List<VendorMenuModel>> cache;

	@Resource
	private VendorMenuDao vendorMenuDao;
	@Resource
	private VendorRoleRefDao vendorRoleRefDao;
	@Resource
	private VendorRoleMenuDao vendorRoleMenuDao;

	@Autowired
	private VendorUserService vendorUserService;
	private List<Long> permisson;

	public VendorMenuServiceImpl() {
		cache = CacheBuilder.newBuilder().expireAfterAccess(5, TimeUnit.MINUTES)
				.build(new CacheLoader<Long, List<VendorMenuModel>>() {
					@Override
					public List<VendorMenuModel> load(Long code) throws Exception {
						// 允许为空
						return vendorMenuDao.findChildById(code);
					}
				});
	}

	@Override
	public Response<VendorMenuNode> buildMenu() {
		Response<VendorMenuNode> response = new Response<>();
		VendorMenuModel vendorMenuModel = new VendorMenuModel();
		vendorMenuModel.setId(0L);
		vendorMenuModel.setName("虚拟根节点");
		VendorMenuNode virtualNode = new VendorMenuNode(vendorMenuModel);
		recursiveBuildMenuTree(virtualNode);
		response.setResult(virtualNode);
		return response;
	}

	@Override
	public Response<VendorMenuNode> menuWithPermisson(@Param("user") User user) {
		Response<VendorMenuNode> response = new Response<>();
		VendorMenuModel vendorMenuModel = new VendorMenuModel();
		vendorMenuModel.setId(0L);
		vendorMenuModel.setName("虚拟根节点");
		VendorMenuNode virtualNode = new VendorMenuNode(vendorMenuModel);
		String id = user.getId();
		// 如果user的level是
		Response<VendorModel> vendorModelResponse = vendorUserService.findVendorById(Long.valueOf(id));
		if (!vendorModelResponse.isSuccess()) {
			response.setError("menu.query.error");
			return response;
		}

		String level = vendorModelResponse.getResult().getLevel();
		// 如果Level等于0 说明是供应商中的管理员账号 权限最大 所有菜单栏都可以获取

		if ("0".equals(level)) {
			withOutPermisson(virtualNode);
			response.setResult(virtualNode);
			return response;
		}
		// 当前用户所有角色
		List<Long> roleIds = vendorRoleRefDao.getRoleIdByUserId(id);
		// 获取角色下能访问的资源权限
		this.permisson = vendorRoleMenuDao.getMenuByRoleId(roleIds);
		withPermisson(virtualNode);
		response.setResult(virtualNode);
		return response;

	}

	@Override
	public Response<List<VendorMenuModel>> getAllResources() {
		Response<List<VendorMenuModel>> response = new Response<>();
		try {
			List<VendorMenuModel> allResources = vendorMenuDao.getAllResources();
			response.setResult(allResources);
		} catch (Exception e) {
			log.error("failed to find menu resource", e);
			response.setError("query.error");
		}
		return response;
	}

	private void withPermisson(VendorMenuNode root) {

		Long id = root.getMenu().getId();
		List<VendorMenuModel> menus = this.cache.getUnchecked(id);
		for (VendorMenuModel vendorMenuModel : menus) {
			if (permisson.contains(vendorMenuModel.getId())) {
				VendorMenuNode subTree = new VendorMenuNode(vendorMenuModel);
				root.addChild(subTree);
				withPermisson(subTree);
			}
		}

	}

	private void withOutPermisson(VendorMenuNode root) {
		Long id = root.getMenu().getId();
		List<VendorMenuModel> menus = this.cache.getUnchecked(id);
		for (VendorMenuModel vendorMenuModel : menus) {
			VendorMenuNode subTree = new VendorMenuNode(vendorMenuModel);
			root.addChild(subTree);
			withOutPermisson(subTree);

		}
	}

	private void recursiveBuildMenuTree(VendorMenuNode root) {
		Long id = root.getMenu().getId();
		List<VendorMenuModel> menus = this.vendorMenuDao.findChildById(id);
		for (VendorMenuModel vendorMenuModel : menus) {
			VendorMenuNode subTree = new VendorMenuNode(vendorMenuModel);
			root.addChild(subTree);
			recursiveBuildMenuTree(subTree);
		}
	}

}
