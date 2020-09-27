package com.dpn.ciqqlc.webservice;

import javax.jws.WebMethod;
import javax.jws.WebService;
import javax.jws.soap.SOAPBinding;

import com.dpn.ciqqlc.webservice.io.VslDecIo;
import com.dpn.ciqqlc.webservice.io.VslUpdateDecIo;
import com.dpn.ciqqlc.webservice.vo.ServiceResult;

@WebService	
@SOAPBinding(style = SOAPBinding.Style.RPC)
public interface ShipWebService {

	@WebMethod
	ServiceResult vslDecService(VslDecIo vslDecIo );
	
	@WebMethod
	ServiceResult vslAprService(VslUpdateDecIo vslDecIo );
}
