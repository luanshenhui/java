package cn.com.cgbchina.admin.event;

import com.google.common.eventbus.AsyncEventBus;
import com.google.common.eventbus.EventBus;
import org.springframework.stereotype.Component;

import java.util.concurrent.Executors;

/**
 * Created by 11140721050130 on 2016/5/17.
 */
@Component
public class AdminEventBus extends EventBus {

	private final AsyncEventBus eventBus;

	public AdminEventBus() {
		this.eventBus = new AsyncEventBus(Executors.newFixedThreadPool(4));
	}

	@Override
	public void register(Object object) {
		eventBus.register(object);
	}

	@Override
	public void post(Object event) {
		eventBus.post(event);
	}

	@Override
	public void unregister(Object object) {
		eventBus.unregister(object);
	}
}
