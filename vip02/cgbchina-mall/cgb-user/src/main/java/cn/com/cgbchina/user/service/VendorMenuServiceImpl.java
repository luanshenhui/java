package cn.com.cgbchina.user.service;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.user.dao.VendorDao;
import cn.com.cgbchina.user.dao.VendorMenuDao;
import cn.com.cgbchina.user.dao.VendorRoleMenuDao;
import cn.com.cgbchina.user.dao.VendorRoleRefDao;
import cn.com.cgbchina.user.dto.VendorMenuNode;
import cn.com.cgbchina.user.model.VendorMenuModel;
import cn.com.cgbchina.user.model.VendorModel;
import com.google.common.base.Strings;
import com.google.common.cache.CacheBuilder;
import com.google.common.cache.CacheLoader;
import com.google.common.cache.LoadingCache;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.spirit.Annotation.Param;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.user.User;
import com.spirit.user.UserUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.concurrent.TimeUnit;

/**
 * Created by 郝文佳 on 2016/5/20.
 */
@Service
@Slf4j
public class VendorMenuServiceImpl implements VendorMenuService {
	private final LoadingCache<Map<String,Object>, List<VendorMenuModel>> cache;

	@Resource
	private VendorMenuDao vendorMenuDao;
	@Resource
	private VendorRoleRefDao vendorRoleRefDao;
	@Resource
	private VendorRoleMenuDao vendorRoleMenuDao;
	@Resource
	private VendorDao vendorDao;

	private final LoadingCache<String, List<Long>> userRoleCache;

	@Autowired
	private VendorUserService vendorUserService;
	private List<Long> permisson;

	public VendorMenuServiceImpl() {
		cache = CacheBuilder.newBuilder().expireAfterAccess(5, TimeUnit.MINUTES)
				.build(new CacheLoader<Map<String,Object>, List<VendorMenuModel>>() {
					@Override
					public List<VendorMenuModel> load(Map<String, Object> paramMap) throws Exception {
						// 允许为空
						return vendorMenuDao.findChildById(paramMap);
					}
				});


		// 根据用户Id,查询用户角色，缓存
		userRoleCache = CacheBuilder.newBuilder().expireAfterWrite(5L, TimeUnit.MINUTES).build(new CacheLoader<String, List<Long>>() {
			@Override
			public List<Long> load(String userId) throws Exception {
				return vendorRoleRefDao.getRoleIdByUserId(userId);
			}
		});
	}

	/**
	 * @param
	 * @return
	 */
	@Override
	public Response<List<VendorMenuModel>> findAll() {
		Response<List<VendorMenuModel>> response = new Response<>();
		try {
			List<VendorMenuModel> all = vendorMenuDao.findAll();
			if (all == null || all.size() == 0) {
				response.setResult(Collections.<VendorMenuModel>emptyList());
				return response;
			}
			response.setResult(all);
		} catch (Exception e) {
			log.error("fail to load menu");
			response.setResult(Collections.<VendorMenuModel>emptyList());
		}
		return response;
	}
	@Override
	public Response<VendorMenuNode> buildMenu(@Param("user") User user) {
		Response<VendorMenuNode> response = new Response<>();
		VendorMenuModel vendorMenuModel = new VendorMenuModel();
		vendorMenuModel.setId(0L);
		vendorMenuModel.setName("虚拟根节点");
		VendorMenuNode virtualNode = new VendorMenuNode(vendorMenuModel);
		recursiveBuildMenuTree(virtualNode,user);
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
		//session中获取用户ID
		String id = user.getId();
        //session中获取用户类型(JF:积分商城；YG：广发商城)
        String shopType = user.getUserType();

		// 如果user的level是
		Response<VendorModel> vendorModelResponse = vendorUserService.findVendorById(Long.valueOf(id));
		if (!vendorModelResponse.isSuccess()) {
			response.setError("menu.query.error");
			return response;
		}

		String level = vendorModelResponse.getResult().getLevel();
		// 如果Level等于0 说明是供应商中的管理员账号 权限最大 所有菜单栏都可以获取

		if ("0".equals(level)) {

			withOutPermisson(virtualNode,shopType);
			response.setResult(virtualNode);
			return response;
		}
		// 当前用户所有角色
		List<Long> roleIds = vendorRoleRefDao.getRoleIdByUserId(id);
		// 获取角色下能访问的资源权限
		this.permisson = vendorRoleMenuDao.getMenuByRoleId(roleIds);
		withPermisson(virtualNode,user);
		response.setResult(virtualNode);
		return response;

	}
	//不展示对应的平台类型
	@Override
	public Response<List<VendorMenuModel>> getResourcesByNotOrderType(String shopType) {
		Response<List<VendorMenuModel>> response = new Response<>();
		try {
			List<VendorMenuModel> allResources = vendorMenuDao.getResourcesByNotOrderType(shopType);
			response.setResult(allResources);
		} catch (Exception e) {
			log.error("failed to find menu resource", e);
			response.setError("query.error");
		}
		return response;
	}
	//不展示对应的平台类型
	public Response<List<Long>> getLongResourcesByNotOrderType(String shopType){
		Response<List<Long>> response = new Response<>();
		try {
			List<Long> allResources = vendorMenuDao.getLongResourcesByNotOrderType(shopType);
			response.setResult(allResources);
		} catch (Exception e) {
			log.error("failed to find menu resource", e);
			response.setError("query.error");
		}
		return response;
	}
	private void withPermisson(VendorMenuNode root,User user) {

		Long id = root.getMenu().getId();
        String shopType = user.getUserType();
        Map<String, Object> paramMap = Maps.newHashMap();
        paramMap.put("pid",id);
        paramMap.put("shopType",shopType);
		paramMap.put("memuType",'1');//检出菜单
        List<VendorMenuModel> menus = this.cache.getUnchecked(paramMap);
		for (VendorMenuModel vendorMenuModel : menus) {
			if (permisson.contains(vendorMenuModel.getId())) {
				VendorMenuNode subTree = new VendorMenuNode(vendorMenuModel);
				root.addChild(subTree);
				withPermisson(subTree,user);
			}
		}

	}

	private void withOutPermisson(VendorMenuNode root,String shopType) {
		Long id = root.getMenu().getId();
		Map<String, Object> paramMap = Maps.newHashMap();
		paramMap.put("pid",id);
		paramMap.put("shopType",shopType);
		paramMap.put("memuType",'1');//检出菜单
        List<VendorMenuModel> menus = this.cache.getUnchecked(paramMap);
		for (VendorMenuModel vendorMenuModel : menus) {
			VendorMenuNode subTree = new VendorMenuNode(vendorMenuModel);
			root.addChild(subTree);
			withOutPermisson(subTree,shopType);

		}
	}

	private void recursiveBuildMenuTree(VendorMenuNode root,User user) {
		Long id = root.getMenu().getId();
        String shopType = user.getUserType();
        Map<String, Object> paramMap = Maps.newHashMap();
        paramMap.put("pid",id);
        paramMap.put("shopType",shopType);
		List<VendorMenuModel> menus = this.vendorMenuDao.findChildById(paramMap);
		for (VendorMenuModel vendorMenuModel : menus) {
			VendorMenuNode subTree = new VendorMenuNode(vendorMenuModel);
			root.addChild(subTree);
			recursiveBuildMenuTree(subTree,user);
		}
	}

	/**
	 * 新建角色权限树
	 */
	public Response<List<VendorMenuModel>> findVendorRoleMenu (User user) {
		Response<List<VendorMenuModel>> response = Response.newResponse();
		String userType = user.getUserType();
		String shopTypenot = null;
		if (Contants.ORDERTYPEID_YG.equals(userType)) {
			shopTypenot = Contants.ORDERTYPEID_JF;
		}
		if (Contants.ORDERTYPEID_JF.equals(userType)) {
			shopTypenot = Contants.ORDERTYPEID_YG;
		}
		if (Strings.isNullOrEmpty(shopTypenot)) {
			response.setError("vendor.role.usertype.null");
			return response;
		}
		Response<List<VendorMenuModel>> result = getResourcesByNotOrderType(shopTypenot);
		if (result.isSuccess()) {
			List<VendorMenuModel> vendorModelList = result.getResult();
			// 如果user的level是
			Response<VendorModel> vendorModelResponse = vendorUserService.findVendorById(Long.valueOf(user.getId()));
			if(!vendorModelResponse.isSuccess()){
				log.error("Response.error,error code: {}", vendorModelResponse.getError());
				throw new ResponseException(Contants.ERROR_CODE_500, "Response.error");
			}
			String level = vendorModelResponse.getResult().getLevel();
			// 如果Level等于0 说明是供应商中的管理员账号 权限最大 所有菜单栏都可以获取
//			if ("0".equals(level)) {
				response.setResult(vendorModelList);
				return response;
//			}
//			// 当前用户所有角色
//			List<Long> roleIds = vendorRoleRefDao.getRoleIdByUserId(user.getId());
//			// 获取角色下能访问的资源权限
//			List<Long> menuByRoleIds = vendorRoleMenuDao.getMenuByRoleId(roleIds);
//			List<VendorMenuModel> menuList = Lists.newArrayList();
//			// 某些资源可能已经被禁用 需要剔除
//			for (VendorMenuModel vendorMenuModel : vendorModelList) {
//				if (menuByRoleIds.contains(vendorMenuModel.getId())) {
//					menuList.add(vendorMenuModel);
//				}
//			}
//			response.setResult(menuList);
//			return response;
		}else {
			response.setError("menu.query.error");
			return response;
		}
	}
	@Override
	public Response<List<Long>> findMenuByUserId(String userId) {
		Response<List<Long>> response = Response.newResponse();
		response.setResult(findMenuIds(userId));
		return response;
	}

	/**
	 * 根据用户Id查询拥有的资源访问权限
	 *
	 * @param userId
	 * @return
	 */
	public List<Long> findMenuIds(String userId) {
		// 当前用户所有角色,读取缓存
		List<Long> roleIds = userRoleCache.getUnchecked(userId);
		// 有些角色可能已经被禁用 需要剔除
		// 获取角色下能访问的资源权限
		List<Long> menuIds = vendorRoleMenuDao.getMenuByRoleId(roleIds);
		return menuIds;
	}
}
