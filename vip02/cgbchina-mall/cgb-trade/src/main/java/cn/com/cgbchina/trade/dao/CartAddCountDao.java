package cn.com.cgbchina.trade.dao;

import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import redis.clients.jedis.Jedis;
import cn.com.cgbchina.common.utils.DateHelper;
import cn.com.cgbchina.trade.dto.CartAddCountDto;

import com.google.common.base.Strings;
import com.google.common.collect.Lists;
import com.spirit.redis.JedisTemplate;
import com.spirit.redis.dao.RedisBaseDao;
import com.spirit.util.JsonMapper;

@Repository
public class CartAddCountDao extends RedisBaseDao<String> {
	private final static JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();

	@Autowired
	public CartAddCountDao(JedisTemplate jedisTemplate) {
		super(jedisTemplate);
	}

	/**
	 * Description : 建立/更新数据
	 * 
	 * @param cartAddCountDto
	 * @return
	 */
	public Long update(final CartAddCountDto cartAddCountDto) {
		final String keyCartAddCount;
		final String valueCartAddCount;
		if (cartAddCountDto != null) {
			String addDateStr = DateHelper.getyyyyMM(cartAddCountDto.getAddDate());
			String weekStr = String.valueOf(cartAddCountDto.getWeek());
			String malltype = cartAddCountDto.getMallType()==null?"":cartAddCountDto.getMallType();
			keyCartAddCount ="month:"+ addDateStr + ":" + weekStr + ":" + cartAddCountDto.getGoodsId() + ":" + malltype;
			if (exist(keyCartAddCount)) {
				String exsitCartCount = getValueCartAddCount(keyCartAddCount);
				Long cartConutL = new Long(0);
				if (!Strings.isNullOrEmpty(exsitCartCount)) {
					try {
						cartConutL = Long.parseLong(exsitCartCount) + 1;
					} catch (Exception e) {
						e.printStackTrace();
						cartConutL = new Long(1);
					}
				}
				valueCartAddCount = String.valueOf(cartConutL);
			} else {
				valueCartAddCount = "1";
			}
			// 添加数据
			jedisTemplate.execute(new JedisTemplate.JedisActionNoResult() {
				@Override
				public void action(Jedis jedis) {
					jedis.set(keyCartAddCount, valueCartAddCount);
				}
			});
			return new Long(1);
		} else {
			return new Long(0);
		}
	}

	/**
	 * Description : 根据key直接获取数值
	 * 
	 * @param keyCartAddCount
	 * @return
	 */
	public String getValueCartAddCount(final String keyCartAddCount) {
		return jedisTemplate.execute(new JedisTemplate.JedisAction<String>() {
			@Override
			public String action(Jedis jedis) {
				return jedis.get(keyCartAddCount);
			}
		});
	}
	
	/**
	 * Description : 删除
	 * @param cartAddCountDto
	 * @return
	 */
	public String delete(CartAddCountDto cartAddCountDto){
		if (cartAddCountDto != null) {
			String addDateStr = DateHelper.getyyyyMM(cartAddCountDto.getAddDate());
			String weekStr = String.valueOf(cartAddCountDto.getWeek());
			String malltype = "";
			String  keyCartAddCount = "month:"+addDateStr + ":" + weekStr + ":" + cartAddCountDto.getGoodsId() + ":" + malltype;
			return delete(keyCartAddCount);
		}else {
			return "";
		}
		
	}
	
	/**
	 * Description : 根据key删除
	 * @param keyCartAddCount
	 * @return
	 */
	public String delete(final String keyCartAddCount){
		return jedisTemplate.execute(new JedisTemplate.JedisAction<String>() {
			@Override
			public String action(Jedis jedis) {
				jedis.del(keyCartAddCount);
				return keyCartAddCount;
			}
		});
	}

	/**
	 * Description : 判断是否存在
	 * 
	 * @param keyCartAddCount
	 * @return
	 */
	public Boolean exist(final String keyCartAddCount) {
		return jedisTemplate.execute(new JedisTemplate.JedisAction<Boolean>() {
			@Override
			public Boolean action(Jedis jedis) {
				return jedis.exists(keyCartAddCount);
			}
		});
	}

	/**
	 * Description : 获取指定周数的购物车数据
	 * 
	 * @param year 指定年份 格式为yyyy
	 * @param week 指定周数
	 * @return
	 */
	public List<CartAddCountDto> getWeekList(String year, String week) {
		final String pattern = "month:"+year+"??:"+week+":*";//example: 201608:34:00000000001:JF
		List<CartAddCountDto> cartAddCountDtos = getCartAddCountDtoByKeyPatten(pattern);
		return cartAddCountDtos;
	}

	/**
	 * Description : 获取指定年月的购物车数据 格式为yyyyMM
	 * 
	 * @param yearMonth 指定年月
	 * @return
	 */
	public List<CartAddCountDto> getMonthList(String yearMonth) {
		final String pattern = "month:"+yearMonth+":*";//example: 201608:34:00000000001:JF
		List<CartAddCountDto> cartAddCountDtos = getCartAddCountDtoByKeyPatten(pattern);
		return cartAddCountDtos;
	}

	/**
	 * Description : 根据pattern模糊搜索购物车数据
	 * 
	 * @param pattern
	 * @return
	 */
	private List<CartAddCountDto> getCartAddCountDtoByKeyPatten(final String pattern) {
		List<CartAddCountDto> cartAddCountDtos = Lists.newArrayList();
		List<String> ids = jedisTemplate.execute(new JedisTemplate.JedisAction<List<String>>() {
			@Override
			public List<String> action(Jedis jedis) {
				return Lists.newArrayList(jedis.keys(pattern));
			}
		});
		for (String id : ids) {
			String valueCartAddCount = getValueCartAddCount(id);
			CartAddCountDto cartAddCountDto = convertForKey(id, valueCartAddCount);
			cartAddCountDtos.add(cartAddCountDto);
		}
		return cartAddCountDtos;
	}

	/**
	 * Description : 转换成Dto
	 * @param id
	 * @param valueCartAddCount
	 * @return
	 */
	private CartAddCountDto convertForKey(String id, String valueCartAddCount) {
		CartAddCountDto cartAddCountDto = new CartAddCountDto();
		if (!Strings.isNullOrEmpty(id)) {
			String[] params = id.split(":");// month:年月:周数:goodsId:商城
			try {
				if (params.length == 5) {
					Date addDate = DateHelper.parseTimestamp(params[1], "yyyyMM");
					Integer week = Integer.valueOf(params[2]);
					String goodsId = params[3];
					String mallType = params[4];
					cartAddCountDto.setAddDate(addDate);
					cartAddCountDto.setWeek(week);
					cartAddCountDto.setGoodsId(goodsId);
					cartAddCountDto.setMallType(mallType);
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return cartAddCountDto;
	}
}
