package com.sanzeng.hello_watch.utils;

import com.google.gson.annotations.SerializedName;

import java.io.Serializable;

/**
 * 我们将每一个接口返回的数据作为一个Response。
 * 之后让子类实现自己的D就可以了。
 * <p>
 */

public abstract class Response implements Serializable {

    @SerializedName(value = "currentServerTime")
    private long currentServerTime;

    @SerializedName(value = "isEmpty")
    private boolean isEmpty;

    @SerializedName(value = "isSuccess")
    private boolean isSuccess;

    @SerializedName(value = "treatmentResult")
    private TreatmentResult treatmentResult;

    public long getCurrentServerTime() {
        return currentServerTime;
    }

    public void setCurrentServerTime(long currentServerTime) {
        this.currentServerTime = currentServerTime;
    }

    public boolean isEmpty() {
        return isEmpty;
    }

    public void setEmpty(boolean empty) {
        isEmpty = empty;
    }

    public boolean isSuccess() {
        return isSuccess;
    }

    public void setSuccess(boolean success) {
        isSuccess = success;
    }

    public TreatmentResult getTreatmentResult() {
        return treatmentResult;
    }

    public void setTreatmentResult(TreatmentResult treatmentResult) {
        this.treatmentResult = treatmentResult;
    }

    @Override
    public String toString() {
        return "Response{" +
                "currentServerTime=" + currentServerTime +
                ", isEmpty=" + isEmpty +
                ", isSuccess=" + isSuccess +
                ", treatmentResult=" + treatmentResult +
                '}';
    }
}
