function singleFileProgress(file, targetID,swfuploadInstance) {
	this.fileProgressBox=document.getElementById(targetID);
	this.fileProgressID = "progress_bar";
	this.opacity = 100;
	this.height = 0;

	this.fileProgressBar = document.getElementById(this.fileProgressID);
	if (!this.fileProgressBar) {
		this.fileProgressBar = document.createElement("div");
		this.fileProgressBar.className = "progress_bar";
		this.fileProgressBar.id = this.fileProgressID;

		this.fileProgressok = document.createElement("div");
		this.fileProgressok.className = "progress_ok";

		this.fileProgresscancel = document.createElement("div");
		this.fileProgresscancel.className = "progress_cancel";
		this.fileProgresscancel.title = CANCEL_TIPS;

		this.fileProgresscancel.onclick = function() {
			swfuploadInstance.cancelUpload(this.fileProgressID, true);
		};

		this.fileProgressBar.appendChild(this.fileProgressok);
		this.fileProgressBar.appendChild(this.fileProgresscancel);
		
		document.getElementById(targetID).appendChild(this.fileProgressBar);
	} else {
		this.fileProgressok = this.fileProgressBar.childNodes[0];
		this.fileProgresscancel = this.fileProgressBar.childNodes[1];
	}
}
// 设置计时器
singleFileProgress.prototype.setTimer = function(timer) {
	this.fileProgressBox["FP_TIMER"] = timer;
};

// 获取计时器
singleFileProgress.prototype.getTimer = function(timer) {
	return this.fileProgressBox["FP_TIMER"] || null;
};

// 设置文件队列的样式
singleFileProgress.prototype.setQueued = function() {
	// class settings
	this.fileProgresscancel.className = ""; 
	this.fileProgressok.className = "progress_ok"; // "progress_ok"
	this.fileProgressok.style.width = "0%";
};

// 设置文件队列错误的样式
singleFileProgress.prototype.setQueuedError = function() {
	this.fileProgresscancel.className = ""; 
	this.fileProgressok.className = "progress_ok"; // "progress_ok"
	this.fileProgressok.style.width = "0%";
};

// 设置文件上传过程中的样式
singleFileProgress.prototype.setProgress = function(percentage) {
	this.fileProgresscancel.className = "progress_cancel"; 
	this.fileProgressok.className = "progress_ok"; // "progress_ok"
	this.fileProgressok.style.width = percentage + "%";
};

// 设置文件上传成功的样式
singleFileProgress.prototype.setSuccess = function() {
	// class settings
	this.fileProgresscancel.className = ""; 
	this.fileProgressok.className = "progress_ok"; // "progress_ok"
	this.fileProgressok.style.width = "100%";
};

// 设置文件上传操作后（无论成功与否）的样式
singleFileProgress.prototype.setComplete = function(file, isfadein) {
	// 当文件上传未成功时的样式
	if (file.filestatus != SWFUpload.FILE_STATUS.COMPLETE) {
		// class settings
		this.fileProgresscancel.className = "progress_cancel"; 
		this.fileProgressok.className = "progress_ok"; // "progress_ok"
		this.fileProgressok.style.width = "0%";

		// 5秒后栏目消失
		if (isfadein) {
			var oSelf = this;
			this.setTimer(setTimeout(function() {
				oSelf.disappear();
			}, 1000));
		}
	}
	// 当文件上传成功时的样式
	else {
		// class settings
		this.fileProgresscancel.className = ""; 
		this.fileProgressok.className = "progress_ok"; // "progress_ok"
		this.fileProgressok.style.width = "100%";
		
		if (isfadein) {
			var oSelf = this;
			this.setTimer(setTimeout(function() {
				oSelf.disappear();
			}, 1000));
		}
	}
};

// 设置出错样式
singleFileProgress.prototype.setError = function(isfadein) {
	// class settings
	this.fileProgresscancel.className = ""; 
	this.fileProgressok.className = "progress_ok"; // "progress_ok"
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
singleFileProgress.prototype.setCancelled = function(isfadein) {
	// class settings
	this.fileProgresscancel.className = "progress_cancel"; 
	this.fileProgressok.className = "progress_ok"; // "progress_ok"
	this.fileProgressok.style.width = "0%";
};

// 淡入样式
singleFileProgress.prototype.appear = function() {
	if (this.getTimer() !== null) {
		clearTimeout(this.getTimer());
		this.setTimer(null);
	}

	if (this.fileProgressBox.filters) {
		try {
			this.fileProgressBox.filters
					.item("DXImageTransform.Microsoft.Alpha").opacity = 100;
		} catch (e) {
			// If it is not set initially, the browser will throw an error. This
			// will set it if it is not set yet.
			this.fileProgressBox.style.filter = "progid:DXImageTransform.Microsoft.Alpha(opacity=100)";
		}
	} else {
		this.fileProgressBox.style.opacity = 1;
	}

	this.fileProgressBox.style.height = "";

	this.height = this.fileProgressBox.offsetHeight;
	this.opacity = 100;
	this.fileProgressBox.style.display = "";
};

// 淡出样式
singleFileProgress.prototype.disappear = function() {

	var reduceOpacityBy = 15;
	var reduceHeightBy = 4;
	var rate = 30; // 15 fps

	if (this.opacity > 0) {
		this.opacity -= reduceOpacityBy;
		if (this.opacity < 0) {
			this.opacity = 0;
		}

		if (this.fileProgressBox.filters) {
			try {
				this.fileProgressBox.filters
						.item("DXImageTransform.Microsoft.Alpha").opacity = this.opacity;
			} catch (e) {
				// If it is not set initially, the browser will throw an error.
				// This will set it if it is not set yet.
				this.fileProgressBox.style.filter = "progid:DXImageTransform.Microsoft.Alpha(opacity="
						+ this.opacity + ")";
			}
		} else {
			this.fileProgressBox.style.opacity = this.opacity / 100;
		}
	}

	if (this.height > 0) {
		this.height -= reduceHeightBy;
		if (this.height < 0) {
			this.height = 0;
		}

		this.fileProgressBox.style.height = this.height + "px";
	}

	if (this.height > 0 || this.opacity > 0) {
		var oSelf = this;
		this.setTimer(setTimeout(function() {
			oSelf.disappear();
		}, rate));
	} else {
		this.fileProgressBox.style.display = "none";
		this.setTimer(null);
	}
};