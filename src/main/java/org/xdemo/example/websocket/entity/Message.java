package org.xdemo.example.websocket.entity;

import java.sql.Timestamp;
import java.util.Date;

import com.fasterxml.jackson.annotation.JsonFormat;
/**
 * 消息类
 * @author Goofy
 * @Date 2015年6月12日 下午7:32:39
 */
public class Message {
	private int id;
	//发送者
	public Long from;
	//发送者名称
	public String fromName;
	//接收者
	public Long to;
	//发送的文本
	public String content;
	//发送日期
	@JsonFormat(pattern="yyyy-MM-dd HH-mm-ss")  
	public Date time;
	
	private int type;
	//是否转发
	private int isTransport;

	public Long getFrom() {
		return from;
	}

	public void setFrom(Long from) {
		this.from = from;
	}

	public Long getTo() {
		return to;
	}

	public void setTo(Long to) {
		this.to = to;
	}

	public String getFromName() {
		return fromName;
	}

	public void setFromName(String fromName) {
		this.fromName = fromName;
	}



	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}

	public Date getTime() {
		return time;
	}

	public void setTime(Date time) {
		this.time = time;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public int getType() {
		return type;
	}

	public void setType(int type) {
		this.type = type;
	}

	public int getIsTransport() {
		return isTransport;
	}

	public void setIsTransport(int isTransport) {
		this.isTransport = isTransport;
	}

	@Override
	public String toString() {
		return "Message [id=" + id + ", from=" + from + ", fromName=" + fromName + ", to=" + to + ", content=" + content
				+ ", time=" + time + ", type=" + type + ", isTransport=" + isTransport + "]";
	}
    
	
}
