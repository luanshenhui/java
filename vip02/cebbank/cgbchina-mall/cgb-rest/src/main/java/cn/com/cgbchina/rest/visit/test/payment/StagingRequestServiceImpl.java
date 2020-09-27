package cn.com.cgbchina.rest.visit.test.payment;

import org.springframework.stereotype.Service;

import cn.com.cgbchina.rest.common.utils.TestClass;
import cn.com.cgbchina.rest.visit.model.payment.StagingRequest;
import cn.com.cgbchina.rest.visit.model.payment.StagingRequestResult;
import cn.com.cgbchina.rest.visit.model.payment.WorkOrderQuery;
import cn.com.cgbchina.rest.visit.model.payment.WorkOrderQueryResult;
import cn.com.cgbchina.rest.visit.service.payment.StagingRequestService;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class StagingRequestServiceImpl implements StagingRequestService {

	@Override
	public StagingRequestResult getStagingRequest(StagingRequest req) {
		return TestClass.debugMethod(StagingRequestResult.class);
	}

	@Override
	public WorkOrderQueryResult workOrderQuery(WorkOrderQuery query) {
		return TestClass.debugMethod(WorkOrderQueryResult.class);
	}

}
