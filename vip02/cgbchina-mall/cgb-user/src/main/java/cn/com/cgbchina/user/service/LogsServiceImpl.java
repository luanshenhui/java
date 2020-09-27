package cn.com.cgbchina.user.service;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.user.dao.LogsDao;
import cn.com.cgbchina.user.dto.LogsDto;
import cn.com.cgbchina.user.model.LogsModel;
import com.google.common.base.Optional;
import com.google.common.base.Throwables;
import com.google.common.cache.CacheBuilder;
import com.google.common.cache.CacheLoader;
import com.google.common.cache.LoadingCache;
import com.google.common.collect.ImmutableMap;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.spirit.common.model.PageInfo;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.util.BeanMapper;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;
import java.util.concurrent.TimeUnit;

@Service
@Slf4j
public class LogsServiceImpl implements LogsService {
	@Resource
	private LogsDao logsDao;
	// 本地缓存
	// 分页数据缓存 封装成map
	private final LoadingCache<Map<String, Object>, Pager<LogsModel>> logsCache;

	public LogsServiceImpl() {
		logsCache = CacheBuilder.newBuilder().expireAfterWrite(5, TimeUnit.MINUTES)
				.build(new CacheLoader<Map<String, Object>, Pager<LogsModel>>() {

					@Override
					public Pager<LogsModel> load(Map<String, Object> map) throws Exception {
						return logsDao.findByPage((Map) map.get("paramMap"), (Integer) map.get("offset"),
								(Integer) map.get("limit"));
					}
				});
	}

	/**
	 * 系统日志查询
	 *
	 * @param shopType
	 * @param action
	 * @param user
	 * @param startTime
	 * @param endTime
	 * @param pageNo
	 * @param size
	 * @return
	 */

	@Override
	public Response<Pager<LogsDto>> findAll(Integer pageNo, Integer size, String shopType, String action, String user,
			String startTime, String endTime) {
		Response<Pager<LogsDto>> response = new Response<Pager<LogsDto>>();
		List<LogsDto> list = Lists.newArrayList();
		Map<String, Object> paramMap = Maps.newHashMap();
		// 非空判断
		if (StringUtils.isNotEmpty(shopType)) {
			paramMap.put("shopType", shopType);
		}
		if (StringUtils.isNotEmpty(action)) {
			paramMap.put("action", action);
		}
		if (StringUtils.isNotEmpty(user)) {
			paramMap.put("user", user.trim());
		}
		if (StringUtils.isNotEmpty(startTime)) {
			paramMap.put("startTime", startTime);
		}
		if (StringUtils.isNotEmpty(endTime)) {
			paramMap.put("endTime", endTime);
		}
		PageInfo pageInfo = new PageInfo(pageNo, size);
		paramMap.put("offset", pageInfo.getOffset());
		paramMap.put("limit", pageInfo.getLimit());
		try {
			Map<String, Object> queryMap = Maps.newHashMap();
			queryMap.put("paramMap", paramMap);
			queryMap.put("offset", pageInfo.getOffset());
			queryMap.put("limit", pageInfo.getLimit());
			queryMap.putAll(paramMap);
			// 取得分页数据
			Pager<LogsModel> pager = logsCache.getUnchecked(queryMap);
			if (pager.getTotal() > 0) {
				List<LogsModel> logsModels = pager.getData();
				for (LogsModel logs : logsModels) {
					LogsDto dto = new LogsDto();
					BeanMapper.copy(logs, dto);
					// 平台类型
					if (StringUtils.isNotEmpty(dto.getShopType())) {
						String shopTypeName = dto.getShopType();
						// 广发商城
						if (shopTypeName.equals("yg")) {
							dto.setShopTypeName(Contants.LOGS_TYPE_YG);
						}
						// 积分商城
						if (shopTypeName.equals("jf")) {
							dto.setShopTypeName(Contants.LOGS_TYPE_JF);
						}
						// 内管系统
						if (shopTypeName.equals("ng")) {
							dto.setShopTypeName(Contants.LOGS_TYPE_NG);
						}
						// 供应商系统
						if (shopTypeName.equals("vd")) {
							dto.setShopTypeName(Contants.LOGS_TYPE_VD);
						}
						// calLCenter
						if (shopTypeName.equals("cc")) {
							dto.setShopTypeName(Contants.LOGS_TYPE_CC);
						}
					}
					// 操作动作
					if (StringUtils.isNotEmpty(dto.getAction())) {
						String actionName = dto.getAction();
						// 登陆成功
						if (actionName.equals("0401")) {
							dto.setActionName(Contants.ACTION_TYPE_0401);
						}
						// 登陆失败
						if (actionName.equals("0402")) {
							dto.setActionName(Contants.ACTION_TYPE_0402);
						}
						// 注销
						if (actionName.equals("0403")) {
							dto.setActionName(Contants.ACTION_TYPE_0403);
						}
						// 待付款
						if (actionName.equals(Contants.SUB_ORDER_STATUS_0301)) {
							dto.setActionName(Contants.SUB_ORDER_WITHOUT_PAYMENT);
						}
						// 0316--订单状态未明
						if (actionName.equals(Contants.SUB_ORDER_STATUS_0316)) {
							dto.setActionName(Contants.SUB_ORDER_UNCLEAR);
						}
						// 0308--支付成功
						if (actionName.equals(Contants.SUB_ORDER_STATUS_0308)) {
							dto.setActionName(Contants.SUB_ORDER_PAYMENT_SUCCEED);
						}
						// 0307--支付失败
						if (actionName.equals(Contants.SUB_ORDER_STATUS_0307)) {
							dto.setActionName(Contants.SUB_ORDER_PAYMENT_FAILED);
						}
						// 0305--处理中
						if (actionName.equals(Contants.SUB_ORDER_STATUS_0305)) {
							dto.setActionName(Contants.SUB_ORDER_HANDLING);
						}
						// 0309--已发货
						if (actionName.equals(Contants.SUB_ORDER_STATUS_0309)) {
							dto.setActionName(Contants.SUB_ORDER_DELIVERED);
						}
						// 0306--发货处理中
						if (actionName.equals(Contants.SUB_ORDER_STATUS_0306)) {
							dto.setActionName(Contants.SUB_ORDER_DELIVER_HANDLING);
						}
						// 0310--已签收
						if (actionName.equals(Contants.SUB_ORDER_STATUS_0310)) {
							dto.setActionName(Contants.SUB_ORDER_SIGNED);
						}
						// 0312--已撤单
						if (actionName.equals(Contants.SUB_ORDER_STATUS_0312)) {
							dto.setActionName(Contants.SUB_ORDER_REVOKED);
						}
						// 0304--已废单
						if (actionName.equals(Contants.SUB_ORDER_STATUS_0304)) {
							dto.setActionName(Contants.SUB_ORDER_SCRAPED);
						}
						// 0334--退货申请
						if (actionName.equals(Contants.SUB_ORDER_STATUS_0334)) {
							dto.setActionName(Contants.SUB_ORDER_RETURN_APPLICATION);
						}
						// 0327--退货成功
						if (actionName.equals(Contants.SUB_ORDER_STATUS_0327)) {
							dto.setActionName(Contants.SUB_ORDER_RETURN_SUCCEED);
						}
						// 0335--拒绝退货申请
						if (actionName.equals(Contants.SUB_ORDER_STATUS_0335)) {
							dto.setActionName(Contants.SUB_ORDER__RETURN_APPLICATION_REFUSED);
						}
						// 0380--拒绝签收
						if (actionName.equals(Contants.SUB_ORDER_STATUS_0380)) {
							dto.setActionName(Contants.SUB_ORDER_SIGNED_REFUSED);
						}
						// 0381--无人签收
						if (actionName.equals(Contants.SUB_ORDER_STATUS_0381)) {
							dto.setActionName(Contants.SUB_ORDER_SIGNED_NONE);
						}
						// 0382--订单推送失败
						if (actionName.equals(Contants.SUB_ORDER_STATUS_0382)) {
							dto.setActionName(Contants.SUB_ORDER_PUSH_FAILED);
						}
						// 编辑中
						if (actionName.equals("0500")) {
							dto.setActionName(Contants.GOODS_EDITING);
						}
						// 待初审
						if (actionName.equals("0501")) {
							dto.setActionName(Contants.GOODS_PENDING_TRIAL);
						}
						// 待复审
						if (actionName.equals("0502")) {
							dto.setActionName(Contants.GOODS_PENDING_REVIEW);
						}
						// 商品变更审核
						if (actionName.equals("0503")) {
							dto.setActionName(Contants.GOODS_CHANGE_AUDIT);
						}
						// 价格变更审核
						if (actionName.equals("0504")) {
							dto.setActionName(Contants.PRICE_CHANGE_AUDIT);
						}
						// 下架申请审核
						if (actionName.equals("0505")) {
							dto.setActionName(Contants.NEXT_APPLICATION_AUDIT);
						}
						// 审核通过
						if (actionName.equals("0506")) {
							dto.setActionName(Contants.GOODS_REVIEWED_PASS);
						}
						// 初审拒绝
						if (actionName.equals("0570")) {
							dto.setActionName(Contants.GOODS_PRELIMINARY_REJECTION);
						}
						// 复审拒绝
						if (actionName.equals("0571")) {
							dto.setActionName(Contants.GOODS_REVIEW_REJECT);
						}
						// 商品变更审核拒绝
						if (actionName.equals("0572")) {
							dto.setActionName(Contants.CHANGE_AUDIT_REJECT);
						}
						// 价格变更审核拒绝
						if (actionName.equals("0573")) {
							dto.setActionName(Contants.PRICE_CHANGE_REVIEW);
						}
						// 下架申请审核拒绝
						if (actionName.equals("0574")) {
							dto.setActionName(Contants.NEXT_FRAME_TO_REVIEW);
						}
					}
					list.add(dto);
				}
			}
			Pager<LogsDto> logsDtoPager = new Pager<LogsDto>(pager.getTotal(), list);
			response.setResult(logsDtoPager);
			return response;
		} catch (Exception e) {
			log.error("select.logs.error", Throwables.getStackTraceAsString(e));
			response.setError("select.logs.error");
			return response;
		}
	}
}