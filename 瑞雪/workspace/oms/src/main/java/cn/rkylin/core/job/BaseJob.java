package cn.rkylin.core.job;


public abstract class BaseJob {
    /**
     * 子类覆盖些方法
     * @throws Exception
     */
    public abstract void executeInternal() throws Exception;
}
