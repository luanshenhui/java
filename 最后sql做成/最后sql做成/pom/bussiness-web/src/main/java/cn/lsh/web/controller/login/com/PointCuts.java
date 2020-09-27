package cn.lsh.web.controller.login.com;


import org.aspectj.lang.annotation.Pointcut;
 
public class PointCuts {
    @Pointcut(value = "within(test.*)")
    public void aopDemo() {
 
    }
}
