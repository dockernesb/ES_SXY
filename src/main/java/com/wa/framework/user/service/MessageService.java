package com.wa.framework.user.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Service;

import com.wa.framework.QueryCondition;
import com.wa.framework.QueryConditions;
import com.wa.framework.common.ComConstants;
import com.wa.framework.common.CommonUtil;
import com.wa.framework.common.comet.Message;
import com.wa.framework.common.comet.MessageManager;
import com.wa.framework.service.BaseService;
import com.wa.framework.user.dao.SysMessageDao;
import com.wa.framework.user.model.SysMessage;

/**
 * 描述：系统消息service类 创建人：guoyt 创建时间：2016年2月26日下午1:54:18 修改人：guoyt 修改时间：2016年2月26日下午1:54:18 修改内容：TODO 修改内容简述 版本号：TODO 版本号
 */
@Service
public class MessageService extends BaseService {

    @Resource
    SysMessageDao sysMessageDao;

    /**
     * @Description: 根据任务接受者和实例id查找taskid
     * @param: @param receiveId
     * @param: @param instanceId
     * @param: @return
     * @return: String
     * @throws
     * @since JDK 1.6
     */
    public String findTaskIdByInstanceId(String receiveId, String instanceId) {
        return sysMessageDao.findTaskIdByInstanceId(receiveId, instanceId);
    }

    /**
     * @Description: 获取未读系统消息数量
     * @param: @param request
     * @param: @return
     * @return: Long
     * @throws
     * @since JDK 1.6
     */
    public Long totalUnread(HttpServletRequest request) {
        QueryConditions queryConditions = new QueryConditions();
        String userId = CommonUtil.getCurrentUserId();
        queryConditions.add(QueryCondition.eq("receiverId", userId));
        queryConditions.add(QueryCondition.eq("state", false));
        Long total = count(SysMessage.class, queryConditions);

        return total;
    }

    /**
     * @Description: comet推送已读消息记录
     * @param: @param receiverList
     * @return: void
     * @throws
     * @since JDK 1.6
     */
    public void sendDelegePopMessage(List<String> receiverList, int readNum) {
        if (receiverList != null && receiverList.size() > 0) {
            Message message = new Message();
            message.setType(ComConstants.MESSAGE_TYPE_SYS);
            Map<String, Object> hmap = new HashMap<String, Object>();
            hmap.put("countType", ComConstants.SYS_MESSAGE_DEL);
            hmap.put("readNum", readNum);

            message.setParam(hmap);
            MessageManager.messageSender.send(message, receiverList);
        }
    }

    /**
     * <描述>: 推送新的系统消息
     * @author 作者：lijj
     * @version 创建时间：2016年7月28日上午9:43:57
     * @param sysMessage
     */
    public void sendMessage(SysMessage sysMessage) {
        Message message = new Message();
        message.setType(ComConstants.MESSAGE_TYPE_SYS);
        Map<String, Object> hmap = new HashMap<String, Object>();
        hmap.put("countType", ComConstants.SYS_MESSAGE_ADD);
        hmap.put("message", sysMessage.getContent());
        hmap.put("sysMessageId", sysMessage.getId());
        hmap.put("receiverId", sysMessage.getReceiverId());
        message.setParam(hmap);
        message.setMessage(sysMessage.getTitle());
        List<String> receiverList = new ArrayList<String>();
        receiverList.add(sysMessage.getReceiverId());
        MessageManager.messageSender.send(message, receiverList);
    }
}
