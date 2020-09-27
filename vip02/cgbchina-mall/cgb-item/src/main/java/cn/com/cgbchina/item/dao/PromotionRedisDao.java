package cn.com.cgbchina.item.dao;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import cn.com.cgbchina.item.model.PromotionRedisModel;
import com.spirit.redis.dao.RedisBaseDao;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.google.common.collect.Lists;
import com.google.common.math.IntMath;
import com.spirit.redis.JedisTemplate;
import com.spirit.user.User;
import com.spirit.util.JsonMapper;

import cn.com.cgbchina.common.utils.StringUtils;
import cn.com.cgbchina.item.dto.MallPromotionSaleInfoDto;
import lombok.extern.slf4j.Slf4j;
import redis.clients.jedis.Jedis;
import redis.clients.jedis.Pipeline;
import redis.clients.jedis.Response;
import redis.clients.jedis.Transaction;

/**
 * @author wenjia.hao
 * @version 1.0
 * @Since 2016/7/8.
 */
@Repository
@Slf4j
public class PromotionRedisDao extends RedisBaseDao<PromotionRedisModel> {

	private final JsonMapper nonDefaultMapper = JsonMapper.nonDefaultMapper();
	private final DateTimeFormatter dateTimeFormat = DateTimeFormat.forPattern("yyyyMMdd");

	@Autowired
	public PromotionRedisDao(JedisTemplate jedisTemplate) {
		super(jedisTemplate);
	}

	/**
	 * 根据活动ID 查询活动基本信息
	 *
	 * @param id
	 * @return
	 */
	public PromotionRedisModel findPromById(final String id) {

		return jedisTemplate.execute(new JedisTemplate.JedisAction<PromotionRedisModel>() {
			@Override
			public PromotionRedisModel action(Jedis jedis) {

				Map<String, String> stringStringMap = jedis.hgetAll("promotion-redis-batch-model:" + id);
				return stringHashMapper.fromHash(stringStringMap);
			}
		});

	}

	/**
	 * 取得1-6栏位数据（荷兰拍）
	 * 
	 * @param promId 活动ID
	 * @param count 取得的栏位数（暂时使用3、6）
	 */
	public List<Map<String, String>> findAuctionsFieldsByKey(final String promId, final String periodId,
			final Integer count) {
		final List<Map<String, String>> resultList = new ArrayList<Map<String, String>>();
		final List<Response<Map<String, String>>> result = Lists.newArrayList();
		jedisTemplate.execute(new JedisTemplate.JedisActionNoResult() {
			@Override
			public void action(Jedis jedis) {
				Pipeline pipelined = jedis.pipelined();
				for (int i = 1; i < count + 1; i++) {
					Response<Map<String, String>> mapResponse = pipelined
							.hgetAll("prom:auctions:fields" + i + ":" + promId + ":" + periodId);
					result.add(mapResponse);
				}
				pipelined.sync();
				for (Response<Map<String, String>> response : result) {
					resultList.add(response.get());
				}
			}
		});
		return resultList;
	}

	/**
	 * 取得栏位数据
	 */
	public Map<String, String> findAuctionsFieldsByKeyForbatch(final Integer no, final String promId,
			final String periodId) {
		return jedisTemplate.execute(new JedisTemplate.JedisAction<Map<String, String>>() {
			@Override
			public Map<String, String> action(Jedis jedis) {
				return jedis.hgetAll("prom:auctions:fields" + no + ":" + promId + ":" + periodId);
			}
		});
	}

	/**
	 * 取得等候区数据（荷兰拍）
	 */
	public List<String> findAuctionsRangeListByKey(final String promId, final String periodId) {
		return jedisTemplate.execute(new JedisTemplate.JedisAction<List<String>>() {
			@Override
			public List<String> action(Jedis jedis) {
				return jedis.lrange("prom:auctions:wait:" + promId + ":" + periodId, 0, -1);
			}
		});
	}

	/**
	 * 查询一个单品对应的活动ID列表
	 */
	public List<String> findItemList(final String itemCode, final String date) {
		return jedisTemplate.execute(new JedisTemplate.JedisAction<List<String>>() {
			@Override
			public List<String> action(Jedis jedis) {
				return jedis.lrange("prom:item:" + date + ":" + itemCode, 0, -1);
			}
		});
	}

	/**
	 * 根据日期 查找日期-活动 映射结果
	 *
	 * @param date 指定日期
	 * @return
	 */
	public List<String> findPromIdListByDate(final String date) {

		return jedisTemplate.execute(new JedisTemplate.JedisAction<List<String>>() {
			@Override
			public List<String> action(Jedis jedis) {
				return jedis.lrange("prom:" + date, 0, -1);
			}
		});

	}

	/**
	 *  根据活动ID、购买数量 检验用户是否达到限购 用户自己的限购
	 * 下单即计数  就算没付款 也占名额 资格用尽就不让买了
	 * @param promId 活动id
	 * @param buyCount 当前用户要买多少件
	 * @param currentUser 当前用户
	 * @return true 让买 false不让买
	 */
	public Boolean checkUserLimitCount(final String promId, final String periodId, final String buyCount,
			final User currentUser,String itemCode) {
		PromotionRedisModel currentProm = jedisTemplate.execute(new JedisTemplate.JedisAction<PromotionRedisModel>() {
			@Override
			public PromotionRedisModel action(Jedis jedis) {
				Map<String, String> stringStringMap = jedis.hgetAll("promotion-redis-batch-model:" + promId);
				return nonDefaultMapper.getMapper().convertValue(stringStringMap, PromotionRedisModel.class);
			}
		});
		// 获取限购类型 0单场限购 1整个活动限购
		Integer ruleLimitBuyType = currentProm.getRuleLimitBuyType();
		// 获得限购数量的数值
		Integer ruleLimitBuyCount = currentProm.getRuleLimitBuyCount();
		// 无限购
		if (ruleLimitBuyType == null || ruleLimitBuyCount == null) {
			return Boolean.TRUE;// 可购买
		}
		if (ruleLimitBuyType.equals(Integer.valueOf(0))) {
			// 维护个人限购次数 首先取得该用户当日购买数量
			final String userLimitToday = "prom-period-user-limit:" + promId + ":" + periodId + ":"
					+ currentUser.getId() +":"+itemCode;
			String alreadyBuyCount = jedisTemplate.execute(new JedisTemplate.JedisAction<String>() {
				@Override
				public String action(Jedis jedis) {
					return jedis.get(userLimitToday);
				}
			});
			if (StringUtils.isEmpty(alreadyBuyCount)) {
				alreadyBuyCount = "0";
			}
			// 取得当前用户的购买数
			// 已经买过了要检查已经买过的数量 加上 将要购买的数量的和 是否大于单日限购的数量
			if (IntMath.checkedAdd(Integer.parseInt(alreadyBuyCount), Integer.parseInt(buyCount)) > ruleLimitBuyCount) {
				return Boolean.FALSE;// 大于返回false
			} else {
				return Boolean.TRUE;// 小于限购数 可以购买
			}
		} else {
			// 限购类型为整个活动限购 获取整个活动的购买量
			final String userLimitAll = "prom-user-limit:" + promId + ":" + currentUser.getId()+":"+itemCode;
			// 获取已经购买的数量
			String alreadyBuyCount = jedisTemplate.execute(new JedisTemplate.JedisAction<String>() {
				@Override
				public String action(Jedis jedis) {
					return jedis.get(userLimitAll);
				}
			});
			// 拿到当前用户的购买数量
			if (StringUtils.isEmpty(alreadyBuyCount)) {
				alreadyBuyCount="0";
			}
			// 已经买过了要检查已经买过的数量 加上 将要购买的数量的和 是否大于单日限购的数量
			if (IntMath.checkedAdd(Integer.parseInt(alreadyBuyCount), Integer.parseInt(buyCount)) > ruleLimitBuyCount) {
				return Boolean.FALSE;// 大于返回false
			} else {
				return Boolean.TRUE;// 小于限购数 可以购买
			}
		}
	}

	/**
	 * 根据活动ID、场次ID、单品CODE 取得已拍卖次数（荷兰拍专属)
	 *
	 * @param promId 活动ID
	 * @param periodId 场次ID
	 * @return
	 */
	public String getPromForHollandauc(final String promId, final String periodId, final User currentUser) {
		// 当前用户 当前场次拍卖数量
		final String userLimitHollandauc = "prom-period-user-Hollandauc:" + promId + ":" + periodId + ":"
				+ currentUser.getId();
		return jedisTemplate.execute(new JedisTemplate.JedisAction<String>() {
			@Override
			public String action(Jedis jedis) {
				return jedis.get(userLimitHollandauc);
			}
		});
	}

	/**
	 * 根据活动ID、场次ID、单品CODE 记录拍卖次数 （荷兰拍专属)
	 *
	 * @param promId 活动ID
	 * @param periodId 场次ID
	 * @return
	 */
	public Long insertPromForHollandauc(final String promId, final String periodId, final User currentUser) {
		// 当前用户 当前场次购买数量
		final String userLimitHollandauc = "prom-period-user-Hollandauc:" + promId + ":" + periodId + ":"
				+ currentUser.getId();

		// 维护活动销量 跟活动本身有关系
		return jedisTemplate.execute(new JedisTemplate.JedisAction<Long>() {
			@Override
			public Long action(Jedis jedis) {
				Transaction multi = jedis.multi();
				// 增加一次拍卖次数
				Response<Long> longResponse = multi.incrBy(userLimitHollandauc, Long.valueOf(1));
				// 维护一个整个活动的个人购买记录聚合 用于删除管理
				multi.sadd("prom-user-all:" + promId, userLimitHollandauc);
				multi.exec();
				return longResponse.get();
			}
		});
	}

	/**
	 * 根据活动ID、单品CODE 记录销量 （所有种类活动）
	 *
	 * @param promId 活动ID
	 * @param periodId 场次ID
	 * @param itemCode 单品CODE
	 * @return
	 */
	public void insertPromSaleInfo(final String promId, final String periodId, final String itemCode,
			final String buyCount, final User currentUser) {
		final String generalItemKey = "prom-sale:" + promId + ":" + itemCode; // 这个单品整个活动内整体的销量
		final String dateItemKey = "prom-period-sale:" + promId + ":" + periodId + ":" + itemCode;// 单品 单场销量

				if(currentUser!=null && currentUser.getId()!=null) {
			final String userLimitAll = "prom-user-limit:" + promId + ":" + currentUser.getId()+":"+itemCode;// 当前用户整个活动购买数量
			final String userLimitToday = "prom-period-user-limit:" + promId + ":" + periodId + ":" + currentUser.getId()+":"+itemCode;// 当前用户	// 当前场次购买数量
			jedisTemplate.execute(new JedisTemplate.JedisActionNoResult() {
				@Override
				public void action(Jedis jedis) {
					Transaction multi = jedis.multi();
					// 用户整个活动购买记录
					multi.incrBy(userLimitAll, Long.parseLong(buyCount));
					// 用户单场内购买记录
					multi.incrBy(userLimitToday, Long.parseLong(buyCount));
					// 维护一个整个活动的个人购买记录聚合 用于删除管理
					multi.sadd("prom-user-all:" + promId, userLimitAll);
					multi.sadd("prom-user-all:" + promId, userLimitToday);
					multi.exec();
				}
			});
		}

		// 维护活动销量 跟活动本身有关系
		jedisTemplate.execute(new JedisTemplate.JedisActionNoResult() {
			@Override
			public void action(Jedis jedis) {
				Transaction multi = jedis.multi();
				// 一个活动 一个单品 一个销量
				multi.incrBy(generalItemKey, Long.parseLong(buyCount));
				// 单场销量
				multi.incrBy(dateItemKey, Long.parseLong(buyCount));
				// 维护一个活动对应的总单品的销量聚合键 用于删除
				multi.sadd("prom-sale-all:" + promId, generalItemKey);
				multi.sadd("prom-sale-all:" + promId, dateItemKey);
				multi.exec();
			}
		});
	}

	/**
	 * 根据活动ID、单品ID 获取已购买数量
	 *
	 * @param promId 活动ID
	 * @param periodId 场次ID
	 * @param itemCode 单品CODE
	 * @return
	 */
	public MallPromotionSaleInfoDto findPromBuyCount(final String promId, final String periodId,
			final String itemCode) {
		final String generalItemKey = "prom-sale:" + promId + ":" + itemCode;// 这个单品整个活动内整体的销量
		final String dateItemKey = "prom-period-sale:" + promId + ":" + periodId + ":" + itemCode;// 当场销量
		final String promStock = "prom-period-stock:" + promId + ":" + periodId + ":" + itemCode;// 当场库存 如果查询不到 说明没从
		// db把数据同步过来 第一次访问需要同步一下db 以后就是用这个了
		return jedisTemplate.execute(new JedisTemplate.JedisAction<MallPromotionSaleInfoDto>() {
			@Override
			public MallPromotionSaleInfoDto action(Jedis jedis) {
				Pipeline pipelined = jedis.pipelined();
				Response<String> generalItemSale = pipelined.get(generalItemKey);
				Response<String> dateItemSale = pipelined.get(dateItemKey);
				Response<String> promStockCount = pipelined.get(promStock);// 获取库存
				pipelined.sync();
				MallPromotionSaleInfoDto mallPromotionSaleInfoDto = new MallPromotionSaleInfoDto();
				// 如果无销量 那么销量将没有数据 要进行空判断
				if (generalItemSale.get() != null) {
					mallPromotionSaleInfoDto.setSaleAmountAll(Integer.valueOf(generalItemSale.get()));
				}
				if (dateItemSale.get() != null) {
					mallPromotionSaleInfoDto.setSaleAmountToday(Integer.valueOf(dateItemSale.get()));
				}
				if (promStockCount.get() != null) {
					mallPromotionSaleInfoDto.setStockAmountTody(Long.valueOf(promStockCount.get()));
				}
				return mallPromotionSaleInfoDto;
			}
		});
	}

	/**
	 * 把当前db中的库存同步到redis中并返回
	 *
	 * @param periodId 活动ID
	 * @param periodId 场次ID
	 * @param itemCode 单品CODE
	 * @param currentStock 当前库存
	 * @return
	 */
	public Long syncStockByPromItem(final String promId, final String periodId, final String itemCode,
			final Long currentStock) {
		// String today = LocalDate.now().toString("yyyyMMdd");
		// final String promItemStock = "prom-stock:" + periodId + ":" + itemCode + ":" + today;
		final String promItemStock = "prom-period-stock:" + promId + ":" + periodId + ":" + itemCode;
		return jedisTemplate.execute(new JedisTemplate.JedisAction<Long>() {
			@Override
			public Long action(Jedis jedis) {
				return jedis.incrBy(promItemStock, currentStock);
			}
		});
	}

	public void offLineProm(final Integer promId) {
		jedisTemplate.execute(new JedisTemplate.JedisActionNoResult() {
			@Override
			public void action(Jedis jedis) {
				Transaction multi = jedis.multi();
				multi.del("promotion-redis-batch-model:" + promId);// 删除活动基本信息
				multi.srem("prom:id:all", String.valueOf(promId));// 删除活动总集合中的活动id
				multi.exec();
			}
		});
	}

	/**
	 * 根据活动ID、单品ID 获取已购买数量(跑批同样操作)
	 *
	 * @param promId 活动ID
	 * @param periodId 场次ID
	 * @param itemCode 单品CODE
	 */
	public String findPromBuyCountForBatch(final String promId, final String periodId, final String itemCode) {
		final String dateItemKey = "prom-period-sale:" + promId + ":" + periodId + ":" + itemCode;// 当场销量
		return jedisTemplate.execute(new JedisTemplate.JedisAction<String>() {
			@Override
			public String action(Jedis jedis) {
				return jedis.get(dateItemKey);
			}
		});
	}

	/**
	 * 插入栏位
	 */
	public void insertAuctionsFields(final Integer no, final String promId, final String periodId,
			final Map<String, String> paramMap) {
		jedisTemplate.execute(new JedisTemplate.JedisActionNoResult() {
			@Override
			public void action(Jedis jedis) {
				jedis.del("prom:auctions:fields" + no + ":" + promId + ":" + periodId);
				Transaction t = jedis.multi();
				// 新增数据
				t.hmset("prom:auctions:fields" + no + ":" + promId + ":" + periodId, paramMap);
				t.exec();
			}
		});
	}

	/**
	 * 插入备选List
	 */
	public void insertAuctionsRangeList(final String promId, final String periodId, final List<String> list) {
		jedisTemplate.execute(new JedisTemplate.JedisActionNoResult() {
			@Override
			public void action(Jedis jedis) {

				jedis.del("prom:auctions:wait:" + promId + ":" + periodId);
				Pipeline pipelined = jedis.pipelined();
				for (String temp : list) {
					pipelined.rpush("prom:auctions:wait:" + promId + ":" + periodId, temp);
				}
				pipelined.sync();
			}
		});
	}
	public  Integer  getStock(final String promId,final String periodId,final String itemCode){
		final String promItemStock = "prom-period-stock:" + promId + ":" + periodId + ":" + itemCode;
		return jedisTemplate.execute(new JedisTemplate.JedisAction<Integer>() {
			@Override
			public Integer action(Jedis jedis) {
				return Integer.valueOf(jedis.get(promItemStock));
			}
		});
	}
}
