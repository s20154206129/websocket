package org.xdemo.example.websocket.controller;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.xdemo.example.websocket.entity.User;
import org.xdemo.example.websocket.entity.UserRelation;
import org.xdemo.example.websocket.service.UserRelationService;
import org.xdemo.example.websocket.service.UserService;

import com.alibaba.fastjson.JSONArray;


@Controller
public class UserRealtionController {
	
	@Resource 
	private UserService userService;
	@Resource 
	private UserRelationService userRelationService;
	
	/**
	 * 建立好友
	 * @param userIdA
	 * @param userIdB
	 * @return
	 */
	@RequestMapping(value="/buildRelation",method=RequestMethod.POST)
	@ResponseBody
	public Map<String,Object> buildRelation(int userIdA,int userIdB){
		
		System.out.println("进入了建立联系好友");
		UserRelation userRelation = new UserRelation();
		userRelation.setUserIdA(userIdA);
		userRelation.setUserIdB(userIdB);
		userRelation.setRelationStatus(1);
		Date date = new Date();
		Timestamp timestamp = new Timestamp(date.getTime());
		userRelation.setRelationStart(timestamp);
		userRelationService.addUserRelation(userRelation);
		Map<String,Object> resoult = new HashMap<String,Object>();
		
		resoult.put("resoult", "success");
		return resoult;
	}
	
	
	@RequestMapping(value="/removeRelation",method=RequestMethod.POST)
	public String removeRelation(int userId,HttpSession httpSession){
		User user = (User)httpSession.getAttribute("currentUser");
		int idA = user.getId().intValue();
		int idB = userId;
		userRelationService.deleteUserRelation(idA, idB);
		httpSession.setAttribute("friends", userRelationService.getAllFriends(user.getId().intValue()));
		return "main";
	}
	
	/**
	 * 邀请新成员入群  就是邀请 当前好友 
	 * @param userId
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/getRelations",method=RequestMethod.POST)
	@ResponseBody
	public Map<String,Object> getRelations(int userId){
		List<User> list = new ArrayList<User>();
		list = userRelationService.getAllFriends(userId);
		String relations = JSONArray.toJSONString(list);
		Map<String,Object> resoult = new HashMap<String,Object>();
		resoult.put("relations", relations);
		return resoult;
	}
}