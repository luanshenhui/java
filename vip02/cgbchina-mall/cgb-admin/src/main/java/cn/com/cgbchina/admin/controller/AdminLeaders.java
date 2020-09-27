package cn.com.cgbchina.admin.controller;

import com.spirit.zookeeper.Leaders;
import lombok.extern.slf4j.Slf4j;
import org.apache.curator.framework.recipes.leader.LeaderLatch;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import javax.annotation.PostConstruct;
import javax.annotation.PreDestroy;
import java.net.InetAddress;
import java.util.UUID;

/**
 * Created by 11140721050130 on 2016/8/21.
 */
@Component
@Slf4j
public class AdminLeaders {

    @Autowired(required = false)
    private Leaders leaders;

    private final String hostName;
    private LeaderLatch leaderLatch;

    public AdminLeaders() {
        String tempHostName = UUID.randomUUID().toString().substring(0, 6);
        try {
            tempHostName = InetAddress.getLocalHost().getHostName();
            log.info("get local host name:{}", tempHostName);
        } catch (Exception e) {
            log.error("failed to get local host name", e);
        }
        hostName = tempHostName;
    }


    @PostConstruct
    public void init() throws Exception {
        if (leaders != null) {
            leaderLatch = leaders.initLeaderLatch("/cgb-admin-leader", hostName);
        }
    }

    /**
     * 获取leader ID
     * @return
     */
    public String currentLeaderId() {
        try {
            if (leaders != null) {
                return leaderLatch.getLeader().getId();
            } else {
                return hostName;
            }
        } catch (Exception e) {
            log.error("failed to get current leader id",e);
            return "unknown";
        }
    }

    /**
     * 是否是leader
     * @return
     */
    public boolean isLeader() {
        if (leaders == null) {
            return true;
        }
        try {
            return leaders.isLeader(leaderLatch, hostName);
        } catch (Exception e) {
            log.error("oops, zookeeper failed,", e);
            return false;
        }
    }

    @PreDestroy
    public void shutdown() throws Exception {
        if (leaders != null) {
            leaderLatch.close();
            leaders.close();
        }
    }
}
