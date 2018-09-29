package org.xdemo.example.websocket.controller;

import java.sql.Timestamp;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import javax.annotation.Resource;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.xdemo.example.websocket.entity.Group;
import org.xdemo.example.websocket.entity.UserGroupRelation;
import org.xdemo.example.websocket.service.GroupService;
import org.xdemo.example.websocket.service.UserGroupRelationService;
import org.xdemo.example.websocket.service.UserService;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.serializer.SerializeConfig;
import com.alibaba.fastjson.serializer.SerializerFeature;
import com.alibaba.fastjson.serializer.SimpleDateFormatSerializer;



@Controller
public class GroupController {
	@Resource 
	private GroupService groupService;
	@Resource 
	private UserGroupRelationService userGroupRelationService;
	@Resource 
	private UserService userService;
	
	@RequestMapping(value="/createGroup",method=RequestMethod.POST)
	@ResponseBody
	public Map<String,Object> createGroup(String groupName,String groupIntroduction,int groupCreaterId){
		
		Group group = new Group();
		//群号码是随机    确实  一定不相同
		String groupId =String.valueOf((int) (Math.random()*100000));
		while(groupService.getGroup(groupId)!=null){
			groupId =String.valueOf((int) (Math.random()*100000));
		}
		group.setGroupId(groupId);
		group.setGroupCreaterId(groupCreaterId);
		group.setGroupIntroduction(groupIntroduction);
		group.setGroupName(groupName);
		Date date = new Date();
		Timestamp timestamp = new Timestamp(date.getTime());
		group.setGroupCreateTime(timestamp);
		group.setGroupUserCount(0);
		group.setGroupMembers("");
		groupService.addGroup(group);
		
		//创建群的 用户  和 群 组   建立关系
		UserGroupRelation userGroupRelation = new UserGroupRelation();
	
		Group groups = groupService.getGroup(groupId);
		userGroupRelation.setGroupId(groups.getId());
		userGroupRelation.setUserId(groupCreaterId);
		userGroupRelation.setEnterGroupTime(timestamp);
		userGroupRelation.setGroupUserNickName(userService.getUser(groupCreaterId).getUserNickName());
		userGroupRelation.setGroupLevel(10);
		userGroupRelationService.addUserGroupRelation(userGroupRelation);
		groups.setGroupMembers(String.valueOf(String.valueOf(groupCreaterId)));
		groups.setGroupUserCount(groups.getGroupUserCount()+1);
		groupService.updateGroup(groups);
		Map<String,Object> resoult = new HashMap<String,Object>();
		resoult.put("resoult", groupId);
		return resoult;
	}
	
	
	/**
	 *  在群中 发送 消息 时  确认 该群是否存在
	 * @param id
	 * @return
	 */
	
	@RequestMapping(value="/findGroupById",method=RequestMethod.POST)
	@ResponseBody
	public Map<String,Object> findGroupById(int id){
		Group group = groupService.getGroup(id);
		String JsonGroup = JSONArray.toJSONString(group,SerializerFeature.UseSingleQuotes);
		System.out.println("群id "+id+"群中消息  确认群是否存在  "+JsonGroup);
		Map<String,Object> resoult = new HashMap<String,Object>();
		resoult.put("resoult", JsonGroup);
		return resoult;
	}
	
	
	@RequestMapping(value="/findGroupByGroupId",method=RequestMethod.POST)
	@ResponseBody
	public Map<String,Object> findGroupByGroupId(String groupId){
		Group group = groupService.getGroup(groupId);
		String JsonGroup = JSONArray.toJSONString(group,SerializerFeature.UseSingleQuotes);
		Map<String,Object> resoult = new HashMap<String,Object>();
		resoult.put("resoult", JsonGroup);
		return resoult;
	}
	
	private static SerializeConfig mapping = new SerializeConfig();  
	private static String dateFormat;  
	static {  
	    dateFormat = "yyyy-MM-dd HH:mm:ss";  
	    mapping.put(Timestamp.class, new SimpleDateFormatSerializer(dateFormat));  
	}
}