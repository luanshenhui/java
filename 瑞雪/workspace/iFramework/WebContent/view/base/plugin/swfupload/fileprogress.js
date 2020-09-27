function FileProgress(file, targetID, swfuploadInstance, check) {
	if (check === 1) {
		this.fileProgressID = "singleWindow";
	} else {
		this.fileProgressID = file.id;
	}
	this.opacity = 100;
	this.height = 0;

	this.fileProgressWrapper = document.getElementById(this.fileProgressID);
	if (!this.fileProgressWrapper) {
		this.fileProgressWrapper = document.createElement("div");
		this.fileProgressWrapper.className = "swfupload_box";
		this.fileProgressWrapper.style.vilibility = "visible";
		this.fileProgressWrapper.id = this.fileProgressID;

		// create element of tips_info
		this.fileProgressTips = document.createElement("div");
		this.fileProgressTips.className = "tips_info";

		this.fileProgressfilename = document.createElement("span");
		this.fileProgressfilename.className = "filename_span";
		this.fileProgressfilename.innerHTML = file.name;
		this.fileProgressfilename.title=file.name;

		this.fileProgressfileurl = document.createElement("span");
		this.fileProgressfileurl.className = "fileurl_span";
		// this.fileProgressfileurl.setAttribute("title", "");

		this.fileProgressfiletips = document.createElement("span");
		this.fileProgressfiletips.className = "tips_span";

		this.fileProgressTips.appendChild(this.fileProgressfilename);
		this.fileProgressTips.appendChild(this.fileProgressfileurl);
		this.fileProgressTips.appendChild(this.fileProgressfiletips);
		// create element of progress_box

		this.fileProgressbox = document.createElement("div");
		this.fileProgressbox.className = "progress_box topleft";
		this.fileProgressbox.style.visibility = "visible";

		this.fileProgressbar = document.createElement("div");
		this.fileProgressbar.className = "progress_bar width";

		this.fileProgressok = document.createElement("div");
		this.fileProgressok.className = "progress_ok";

		this.fileProgresscancel = document.createElement("div");
		this.fileProgresscancel.className = "progress_cancel";
		this.fileProgresscancel.title = CANCEL_TIPS;
		

		this.fileProgresscancel.onclick = function() {
			swfuploadInstance.cancelUpload(this.fileProgressID, true);
		};

		this.fileProgressbar.appendChild(this.fileProgressok);
		this.fileProgressbar.appendChild(this.fileProgresscancel);

		this.fileProgressbox.appendChild(this.fileProgressbar);

		this.fileProgressWrapper.appendChild(this.fileProgressTips);
		this.fileProgressWrapper.appendChild(this.fileProgressbox);

		document.getElementById(targetID).appendChild(this.fileProgressWrapper);
	} else {
		this.fileProgressTips = this.fileProgressWrapper.childNodes[0];
		this.fileProgressbox = this.fileProgressWrapper.childNodes[1];
		this.fileProgressfilename = this.fileProgressTips.childNodes[0];
		this.fileProgressfileurl = this.fileProgressTips.childNodes[1];
		this.fileProgressfiletips = this.fileProgressTips.childNodes[2];
		this.fileProgressbar = this.fileProgressbox.childNodes[0];
		this.fileProgressok = this.fileProgressbar.childNodes[0];
		this.fileProgresscancel = this.fileProgressbar.childNodes[1];

		this.fileProgressfilename.innerHTML = file.name;
	}
}

FileProgress.prototype.reset = function(file) {
	if (file.filestatus != SWFUpload.FILE_STATUS.QUEUED) {
		this.setQueuedError();
		this.setComplete(file, false);
	} else {
		this.setQueued();
		this.setStatus(UPLOAD_READY_STATUS);
		this.setCancelTitle(CANCEL_TIPS);
	}
};

// 设置计时器
FileProgress.prototype.setTimer = function(timer) {
	this.fileProgressbox["FP_TIMER"] = timer;
};

// 获取计时器
FileProgress.prototype.getTimer = function(timer) {
	return this.fileProgressbox["FP_TIMER"] || null;
};

// 设置文件队列的样式
FileProgress.prototype.setQueued = function() {
	// class settings
	this.fileProgressWrapper.className = "swfupload_box"; // "swfupload_box"
	this.fileProgresscancel.className = ""; // progress_cancel
	this.fileProgressTips.className = "tips_info"; // "tips_info"
	this.fileProgressfilename.className = "filename_span"; // "filename_span"
	this.fileProgressfileurl.className = "fileurl_span"; // "fileurl_span"
	this.fileProgressfiletips.className = ""; // "tips_span";
	this.fileProgressbox.className = "progress_box topleft"; // "progress_box
	// topleft"
	this.fileProgressbar.className = "progress_bar width"; // "progress_bar
	// width"
	this.fileProgressok.className = "progress_ok"; // "progress_ok"

	// attributes settings
	this.fileProgressok.style.width = "0%";

};

// 设置文件队列错误的样式
FileProgress.prototype.setQueuedError = function() {
	// class settings
	this.fileProgressWrapper.className = "swfupload_box border"; // "swfupload_box
	// border"
	this.fileProgresscancel.className = ""; // progress_cancel
	this.fileProgressTips.className = "tips_info"; // "tips_info"
	this.fileProgressfilename.className = "filename_span"; // "filename_span"
	this.fileProgressfileurl.className = "fileurl_span"; // "fileurl_span"
	this.fileProgressfiletips.className = "tips_span"; // "tips_span";
	this.fileProgressbox.className = "progress_box topleft"; // "progress_box
	// topleft"
	this.fileProgressbar.className = "progress_bar width"; // "progress_bar
	// width"
	this.fileProgressok.className = "progress_ok"; // "progress_ok"

	// attributes settings
	this.fileProgressok.style.width = "0%";
};

// 设置文件上传过程中的样式
FileProgress.prototype.setProgress = function(percentage) {
	// class settings
	this.fileProgressWrapper.className = "swfupload_box"; // "swfupload_box"
	this.fileProgresscancel.className = "progress_cancel"; // progress_cancel
	this.fileProgressTips.className = "tips_info"; // "tips_info"
	this.fileProgressfilename.className = "filename_span"; // "filename_span"
	this.fileProgressfileurl.className = "fileurl_span"; // "fileurl_span"
	this.fileProgressfiletips.className = ""; // "tips_span";
	this.fileProgressbox.className = "progress_box topleft"; // "progress_box
	// topleft"
	this.fileProgressbar.className = "progress_bar width"; // "progress_bar
	// width"
	this.fileProgressok.className = "progress_ok"; // "progress_ok"

	// attributes settings
	this.fileProgressbox.style.visibility = "visible";
	this.fileProgressok.style.width = percentage + "%";
	this.appear();
};

// 设置文件上传成功的样式
FileProgress.prototype.setSuccess = function() {
	// class settings
	this.fileProgressWrapper.className = "swfupload_box border2"; // "swfupload_box"
	this.fileProgresscancel.className = ""; // progress_cancel
	this.fileProgressTips.className = "tips_info"; // "tips_info"
	this.fileProgressfilename.className = "filename_span"; // "filename_span"
	this.fileProgressfileurl.className = "fileurl_span"; // "fileurl_span"
	this.fileProgressfiletips.className = ""; // "tips_span";
	this.fileProgressbox.className = "progress_box topleft"; // "progress_box
	// topleft"
	this.fileProgressbar.className = "progress_bar width"; // "progress_bar
	// width"
	this.fileProgressok.className = "progress_ok"; // "progress_ok"

	// attributes settings
	this.fileProgressbox.style.visibility = "visible";
	this.fileProgressok.style.width = "100%";
};

// 设置文件上传操作后（无论成功与否）的样式
FileProgress.prototype.setComplete = function(file, isfadein) {
	// 当文件上传未成功时的样式
	if (file.filestatus != SWFUpload.FILE_STATUS.COMPLETE) {
		// class settings
		this.fileProgressWrapper.className = "swfupload_box border"; // "swfupload_box
		// border"
		this.fileProgresscancel.className = ""; // progress_cancel
		this.fileProgressTips.className = "tips_info"; // "tips_info"
		this.fileProgressfilename.className = "filename_span"; // "filename_span"
		this.fileProgressfileurl.className = "fileurl_span"; // "fileurl_span"
		this.fileProgressfiletips.className = "tips_span"; // "tips_span";
		this.fileProgressbox.className = "progress_box topleft"; // "progress_box
		// topleft"
		this.fileProgressbar.className = "progress_bar width"; // "progress_bar
		// width"
		this.fileProgressok.className = "progress_ok"; // "progress_ok"

		// attributes settings
		this.fileProgressbox.style.visibility = "visible";
		this.fileProgressok.style.width = "0%";

		// 5秒后栏目消失
		if (isfadein) {
			var oSelf = this;
			this.setTimer(setTimeout(function() {
				oSelf.disappear();
			}, 5000));
		}
	}
	// 当文件上传成功时的样式
	else {
		// class settings
		this.fileProgressWrapper.className = "swfupload_box border2"; // "swfupload_box
		// border"
		this.fileProgresscancel.className = ""; // progress_cancel
		this.fileProgressTips.className = "tips_info"; // "tips_info"
		this.fileProgressfilename.className = "filename_span"; // "filename_span"
		this.fileProgressfileurl.className = "fileurl_span"; // "fileurl_span"
		this.fileProgressfiletips.className = ""; // "tips_span";
		this.fileProgressbox.className = "progress_box topleft"; // "progress_box
		// topleft"
		this.fileProgressbar.className = "progress_bar width"; // "progress_bar
		// width"
		this.fileProgressok.className = "progress_ok"; // "progress_ok"

		// attributes settings
		this.fileProgressbox.style.visibility = "visible";
		this.fileProgressok.style.width = "100%";
	}
};

// 设置出错样式
FileProgress.prototype.setError = function(isfadein) {
	// class settings
	this.fileProgressWrapper.className = "swfupload_box border"; // "swfupload_box
	// border"
	this.fileProgresscancel.className = ""; // progress_cancel
	this.fileProgressTips.className = "tips_info"; // "tips_info"
	this.fileProgressfilename.className = "filename_span"; // "filename_span"
	this.fileProgressfileurl.className = "fileurl_span"; // "fileurl_span"
	this.fileProgressfiletips.className = "tips_span"; // "tips_span";
	this.fileProgressbox.className = "progress_box topleft"; // "progress_box
	// topleft"
	this.fileProgressbar.className = "progress_bar width"; // "progress_bar
	// width"
	this.fileProgressok.className = "progress_ok"; // "progress_ok"

	// attributes settings
	this.fileProgressbox.style.visibility = "visible";
	this.fileProgressok.style.width = "0%";

	// 5秒后栏目消失
	if (isfadein) {
		var oSelf = this;
		this.setTimer(setTimeout(function() {
			oSelf.disappear();
		}, 5000));
	}
};

// 设置取消上传的样式
FileProgress.prototype.setCancelled = function(isfadein) {
	// class settings
	this.fileProgressWrapper.className = "swfupload_box border"; // "swfupload_box
	// border"
	this.fileProgresscancel.className = ""; // progress_cancel
	this.fileProgressTips.className = "tips_info"; // "tips_info"
	this.fileProgressfilename.className = "filename_span"; // "filename_span"
	this.fileProgressfileurl.className = "fileurl_span"; // "fileurl_span"
	this.fileProgressfiletips.className = "tips_span"; // "tips_span";
	this.fileProgressbox.className = "progress_box topleft"; // "progress_box
	// topleft"
	this.fileProgressbar.className = "progress_bar width"; // "progress_bar
	// width"
	this.fileProgressok.className = "progress_ok"; // "progress_ok"

	// attributes settings
	this.fileProgressbox.style.visibility = "visible";

	// 5秒后栏目消失
	if (isfadein) {
		var oSelf = this;
		this.setTimer(setTimeout(function() {
			oSelf.disappear();
		}, 5000));
	}
};

FileProgress.prototype.setText=function(status, tips)
{
	this.fileProgressfileurl.innerHTML = status;
	this.fileProgressfiletips.innerHTML = tips;
};

// 设置标签信息
FileProgress.prototype.setCancelTitle = function(title) {
	this.fileProgresscancel.setAttribute("title", title);
};

// 淡入样式
FileProgress.prototype.appear = function() {
	if (this.getTimer() !== null) {
		clearTimeout(this.getTimer());
		this.setTimer(null);
	}

	if (this.fileProgressWrapper.filters) {
		try {
			this.fileProgressWrapper.filters
					.item("DXImageTransform.Microsoft.Alpha").opacity = 100;
		} catch (e) {
			// If it is not set initially, the browser will throw an error. This
			// will set it if it is not set yet.
			this.fileProgressWrapper.style.filter = "progid:DXImageTransform.Microsoft.Alpha(opacity=100)";
		}
	} else {
		this.fileProgressWrapper.style.opacity = 1;
	}

	this.fileProgressWrapper.style.height = "";

	this.height = this.fileProgressWrapper.offsetHeight;
	this.opacity = 100;
	this.fileProgressWrapper.style.display = "";
};

// 淡出样式
FileProgress.prototype.disappear = function() {

	var reduceOpacityBy = 15;
	var reduceHeightBy = 4;
	var rate = 30; // 15 fps

	if (this.opacity > 0) {
		this.opacity -= reduceOpacityBy;
		if (this.opacity < 0) {
			this.opacity = 0;
		}

		if (this.fileProgressWrapper.filters) {
			try {
				this.fileProgressWrapper.filters
						.item("DXImageTransform.Microsoft.Alpha").opacity = this.opacity;
			} catch (e) {
				// If it is not set initially, the browser will throw an error.
				// This will set it if it is not set yet.
				this.fileProgressWrapper.style.filter = "progid:DXImageTransform.Microsoft.Alpha(opacity="
						+ this.opacity + ")";
			}
		} else {
			this.fileProgressWrapper.style.opacity = this.opacity / 100;
		}
	}

	if (this.height > 0) {
		this.height -= reduceHeightBy;
		if (this.height < 0) {
			this.height = 0;
		}

		this.fileProgressWrapper.style.height = this.height + "px";
	}

	if (this.height > 0 || this.opacity > 0) {
		var oSelf = this;
		this.setTimer(setTimeout(function() {
			oSelf.disappear();
		}, rate));
	} else {
		this.fileProgressWrapper.style.display = "none";
		this.setTimer(null);
	}
};