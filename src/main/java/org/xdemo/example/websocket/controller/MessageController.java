package org.xdemo.example.websocket.controller;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.xdemo.example.websocket.entity.Message;
import org.xdemo.example.websocket.service.MessageService;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.serializer.SerializeConfig;
import com.alibaba.fastjson.serializer.SerializerFeature;
import com.alibaba.fastjson.serializer.SimpleDateFormatSerializer;

@Controller
public class MessageController {
	
	@Resource 
	private MessageService messageService;

	
	/**
	 *  单人之间进行 聊天
	 * @param userIdA
	 * @param userIdB
	 * @return
	 */
	
	@RequestMapping(value="/getMessageRecordBetweenUsers",method=RequestMethod.POST)
	@ResponseBody
	public Map<String,Object> getMessageRecordBetweenUsers(int userIdA,int userIdB){
		System.out.println("获取用户之间的聊天记录");
		
		//查找用户  单人聊天记录  type 为  0
		List<Message> list = messageService.getMessageByType(0);
		
		List<Message> lists = new ArrayList<Message>();
		for(int i=0;i<list.size();i++){
			Message message = list.get(i);
			
			//System.out.println("聊天记录："+message);
			//System.out.println("userIdA:"+userIdA+",userIdB"+userIdB+"messageFrom:"+message.getFrom()+",messageTo:"+message.getTo());
			//istransport==1的 作用
			if(((message.getFrom() == userIdA && message.getTo() == userIdB)||(message.getFrom() == userIdB && message.getTo() == userIdA))&& message.getIsTransport() == 1)
				lists.add(message);
		}
		String messages = JSONArray.toJSONString(lists,SerializerFeature.UseSingleQuotes);
	    System.out.println("我到了这里："+messages);
		Map<String,Object> resoult = new HashMap<String,Object>();
		resoult.put("resoult",messages);
		return resoult;
	}
	
	@RequestMapping(value="/getMessageRecordBetweenUserAndGroup",method=RequestMethod.POST)
	@ResponseBody
	public Map<String,Object> getMessageRecordBetweenUserAndGroup(int id,int userId){
		
		System.out.println("进入个人在群组的 消息记录"	);
		List<Message> list = messageService.getMessageByType(1);
		List<Message> lists = new ArrayList<Message>();
		for(int i=0;i<list.size();i++){
			Message message = list.get(i);
			if(message.getTo() == id && message.getIsTransport() == 1){
				message.setType(1);
				message.setTo((long)userId);
			}
			lists.add(message);
		}
		//数据格式转换
		String messages = JSONArray.toJSONString(lists,SerializerFeature.UseSingleQuotes);
		Map<String,Object> resoult = new HashMap<String,Object>();
		resoult.put("resoult",messages);
		return resoult;
	}
	
	//fastJson(json)对javaBean的date以及timestamp直接转换为json对象时会乱码，这里配合bean（entity）中的注解，就可以保证转化的日期格式正确
	private static SerializeConfig mapping = new SerializeConfig();  
	private static String dateFormat;  
	static {  
	    dateFormat = "yyyy-MM-dd HH:mm:ss";  
	    mapping.put(Timestamp.class, new SimpleDateFormatSerializer(dateFormat));  
	}
	
	
	/**
	 *  增加Message   私聊
	 *  @RequestBody  是将前台json 保存在一个对象中
	 * @param userIdA
	 * @param userIdB
	 * @return
	 */
	@RequestMapping(value="/addMessage",method=RequestMethod.POST)
	@ResponseBody
	public Map<String,Object> addMessageRecordBetweenUsers(
			int userIdA,int userIdB,String content,int type){
		System.out.println("数据库添加用户之间的聊天记录"+userIdA+","+userIdB);
		Message message=new Message();
		message.setFrom((long)userIdA);
		message.setTo((long)userIdB);
		message.setContent(content);
		//message.setTime(time);
		message.setTime(new Date());
		message.setType(type);
		message.setIsTransport(1);
		messageService.addMessage(message);
		Map<String,Object> resoult = new HashMap<String,Object>();
	    resoult.put("resoult","添加message成功");
		return resoult;
	}
	
	
	/**
	 *  增加Message  群聊的 message
	 *  @RequestBody  是将前台json 保存在一个对象中
	 * @param userIdA
	 * @param userIdB
	 * @return
	 */
	@RequestMapping(value="/addMessageInUserGroup",method=RequestMethod.POST)
	@ResponseBody
	public Map<String,Object> addMessageInUserGroup(
			int userIdA,int userIdB,String content,int type){
		System.out.println("数据库添加用户之间的聊天记录"+userIdA+","+userIdB);
		Message message=new Message();
		message.setFrom((long)userIdA);
		message.setTo((long)userIdB);
		message.setContent(content);
		//message.setTime(time);
		message.setTime(new Date());
		message.setType(type);
		message.setIsTransport(1);
		messageService.addMessage(message);
		Map<String,Object> resoult = new HashMap<String,Object>();
	    resoult.put("resoult","添加message成功");
		return resoult;
	}
	
	
}