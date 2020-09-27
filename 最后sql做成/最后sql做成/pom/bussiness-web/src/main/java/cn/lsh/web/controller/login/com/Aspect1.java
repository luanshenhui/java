package cn.lsh.web.controller.login.com;

import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.*;
import org.springframework.stereotype.Component;
 
@Component
@Aspect
public class Aspect1 {
 
    @Before(value = "test.PointCuts.aopDemo()")
    public void before(JoinPoint joinPoint) {
        System.out.println("[Aspect1] before advise");
    }
 
    @Around(value = "test.PointCuts.aopDemo()")
    public void around(ProceedingJoinPoint pjp) throws  Throwable{
        System.out.println("[Aspect1] around advise 1");
        pjp.proceed();
        System.out.println("[Aspect1] around advise2");
    }
 
    @AfterReturning(value = "test.PointCuts.aopDemo()")
    public void afterReturning(JoinPoint joinPoint) {
        System.out.println("[Aspect1] afterReturning advise");
    }
 
    @AfterThrowing(value = "test.PointCuts.aopDemo()")
    public void afterThrowing(JoinPoint joinPoint) {
        System.out.println("[Aspect1] afterThrowing advise");
    }
 
    @After(value = "test.PointCuts.aopDemo()")
    public void after(JoinPoint joinPoint) {
        System.out.println("[Aspect1] after advise");
    }
}
