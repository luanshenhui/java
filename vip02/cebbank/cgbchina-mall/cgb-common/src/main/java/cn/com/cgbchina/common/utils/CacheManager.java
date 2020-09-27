package cn.com.cgbchina.common.utils;

import com.google.common.cache.LoadingCache;

import java.util.List;

/**
 * Created by 11140721050130 on 2016/5/16.
 */
public class CacheManager {

	public static void refresh(LoadingCache<Long, ?> cache, List<Long> keys) {
		if ((keys == null) || (keys.size() <= 0))
			return;
		refresh(cache, keys.toArray(new Long[0]));
	}

	public static void refresh(LoadingCache<Long, ?> cache, Long[] keys) {
		if ((cache != null) && (keys != null) && (keys.length > 0))
			for (Long key : keys)
				cache.refresh(key);
	}

	public static void invalidate(LoadingCache<Long, ?> cache, List<Long> keys) {
		if ((keys == null) || (keys.size() <= 0))
			return;
		invalidate(cache, keys.toArray(new Long[0]));
	}

	public static void invalidate(LoadingCache<Long, ?> cache, Long[] keys) {
		if ((cache != null) && (keys != null) && (keys.length > 0))
			for (Long key : keys) {
				cache.invalidate(key);
			}
	}
}
