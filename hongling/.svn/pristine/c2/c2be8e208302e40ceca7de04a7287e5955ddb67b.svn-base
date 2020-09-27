jQuery.csBlListTrack={
	moduler : "BlListTrack",

	/**
	 * 根据运单ID，查询运单明细
	 * @param yundanId
	 */
	list: function(yundanId) {
		var param = $.csControl.appendKeyValue("","yundanId",yundanId);
		var data = $.csCore.invoke($.csCore.buildServicePath('/service/delivery/getTrackbyYundanid'),param);
		$.csCore.processList($.csBlListTrack.moduler, data);
		$.csBlListTrackCommon.bindLabel();
	},
	
	
	/**
	 * 初始化
	 * @param yundanId
	 */
	init:function(yundanId){
		$.csBlListTrackCommon.bindLabel();
		$.csBlListTrack.list(yundanId);
		$.csBlListTrackCommon.bindLabel();
	}
};

jQuery.csBlListTrackCommon={
	bindLabel: function() {
		$.csCore.getValue("Delivery_Track",null,"h3");
		$.csCore.getValue("Common_Index",null,".blLblTrackNumber");
		$.csCore.getValue("Delivery_TrackTime",null,".blLblTrackTime");
		$.csCore.getValue("Delivery_TrackMemo",null,".blLblTrackMemo");
	}
};