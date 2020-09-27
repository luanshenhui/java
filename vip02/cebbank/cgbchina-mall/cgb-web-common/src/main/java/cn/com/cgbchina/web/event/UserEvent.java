package cn.com.cgbchina.web.event;

import com.google.common.eventbus.EventBus;

/**
 * Created by 11140721050130 on 2016/5/17.
 */
public class UserEvent extends EventBus {

	@Override
	public void register(Object object) {
		super.register(object);
	}

	@Override
	public void unregister(Object object) {
		super.unregister(object);
	}

	@Override
	public void post(Object event) {
		super.post(event);
	}
}
