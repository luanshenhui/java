package cn.com.cgbchina.rest.provider.service.activity;

import cn.com.cgbchina.rest.provider.model.activity.NoticCancel;
import cn.com.cgbchina.rest.provider.model.activity.NoticCancelReturn;

/**
 * MAL332 取消提醒
 * 
 * @author lizy 2016/4/28.
 */
public interface NoticCancelService {
	NoticCancelReturn cancel(NoticCancel noticCancel);
}
