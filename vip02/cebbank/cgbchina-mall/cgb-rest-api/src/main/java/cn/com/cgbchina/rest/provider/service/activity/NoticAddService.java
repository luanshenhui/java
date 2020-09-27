package cn.com.cgbchina.rest.provider.service.activity;

import cn.com.cgbchina.rest.provider.model.activity.NoticAdd;
import cn.com.cgbchina.rest.provider.model.activity.NoticAddReturn;

/**
 * MAL331 添加提醒
 * 
 * @author lizy 2016/4/28.
 */
public interface NoticAddService {
	NoticAddReturn add(NoticAdd nodticAdd);
}
