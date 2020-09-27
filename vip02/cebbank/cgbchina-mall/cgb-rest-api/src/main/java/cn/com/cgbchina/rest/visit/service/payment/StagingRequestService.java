package cn.com.cgbchina.rest.visit.service.payment;

import cn.com.cgbchina.rest.visit.model.payment.StagingRequest;
import cn.com.cgbchina.rest.visit.model.payment.StagingRequestResult;
import cn.com.cgbchina.rest.visit.model.payment.WorkOrderQuery;
import cn.com.cgbchina.rest.visit.model.payment.WorkOrderQueryResult;

public interface StagingRequestService {
	StagingRequestResult getStagingRequest(StagingRequest req);

	WorkOrderQueryResult workOrderQuery(WorkOrderQuery query);
}
